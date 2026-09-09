#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2006-2026 DIY Accounting Limited
#
# update-formula.sh — write a Homebrew node-package formula from the npm registry.
#
# Reads the latest published version of PACKAGE from the npm registry,
# downloads its tarball, computes the sha256 Homebrew wants, and writes
# FORMULA in Homebrew's node-package shape. Exits 0 and changes nothing
# if the package is not published yet, or if FORMULA already tracks the
# latest tarball.
set -euo pipefail

PACKAGE="${PACKAGE:-@diy-accounting-uk/diya-gl}"

# The unscoped name drives both the formula's class name and its default
# file name, so PACKAGE can be pointed at any scoped npm package (for a
# dry run of this script) without also having to set FORMULA.
unscoped_name="${PACKAGE##*/}"

FORMULA="${FORMULA:-Formula/${unscoped_name}.rb}"

# Homebrew's own name-to-class rule (Formulary.class_s): capitalize, then
# upcase the letter after each '-', '_', '.' or space and drop the
# separator. Matching it here keeps the class name in step with the file
# name Homebrew expects when this formula is tapped.
class_name="$(node -e '
  const name = process.argv[1];
  let className = name.charAt(0).toUpperCase() + name.slice(1);
  className = className.replace(/[-_.\s]([a-zA-Z0-9])/g, (_, c) => c.toUpperCase());
  console.log(className);
' "$unscoped_name")"

registry_url="https://registry.npmjs.org/${PACKAGE}/latest"

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json" "${tmp_tarball:-}"' EXIT

http_code="$(curl -sS -o "$tmp_json" -w '%{http_code}' "$registry_url")"

if [[ "$http_code" == "404" ]]; then
  echo "$PACKAGE is not published on the npm registry yet (404 from $registry_url). Nothing to do."
  exit 0
fi

if [[ "$http_code" != "200" ]]; then
  echo "npm registry returned HTTP $http_code for $registry_url" >&2
  cat "$tmp_json" >&2
  exit 1
fi

version="$(node -e '
  const fs = require("fs");
  const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  console.log(pkg.version);
' "$tmp_json")"

tarball_url="$(node -e '
  const fs = require("fs");
  const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  console.log(pkg.dist.tarball);
' "$tmp_json")"

description="$(node -e '
  const fs = require("fs");
  const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  console.log(pkg.description || "");
' "$tmp_json")"

license="$(node -e '
  const fs = require("fs");
  const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  console.log(pkg.license || "");
' "$tmp_json")"

# The formula must state the licence the registry actually publishes, not
# an assumed value, so a missing or malformed field stops the run instead
# of writing a wrong or empty licence line into the formula.
if [[ -z "$license" ]]; then
  echo "$PACKAGE has no license field on the npm registry ($registry_url). Refusing to write $FORMULA." >&2
  exit 1
fi

if [[ ! "$license" =~ ^[A-Za-z0-9.+-]+$ ]]; then
  echo "$PACKAGE's license field \"$license\" is not a bare SPDX identifier. Refusing to write $FORMULA." >&2
  exit 1
fi

if [[ -z "$description" ]]; then
  description="$PACKAGE, installed from npm"
fi

# Homebrew's desc convention: no trailing full stop, 80 characters or fewer.
description="${description%.}"
if [[ ${#description} -gt 80 ]]; then
  description="${description:0:80}"
  description="${description% *}"
  description="${description%.}"
fi

# The npm registry never rewrites a published version's tarball, so a
# formula that already points at this exact tarball URL is already
# current: skip the download and sha256 recompute.
if [[ -f "$FORMULA" ]] && grep -qF "url \"${tarball_url}\"" "$FORMULA"; then
  echo "$FORMULA already tracks $PACKAGE $version. Nothing to change."
  exit 0
fi

tmp_tarball="$(mktemp)"
curl -sSL -o "$tmp_tarball" "$tarball_url"

if command -v sha256sum >/dev/null 2>&1; then
  sha256="$(sha256sum "$tmp_tarball" | awk '{print $1}')"
else
  sha256="$(shasum -a 256 "$tmp_tarball" | awk '{print $1}')"
fi

# Ruby double-quoted string escaping for the description.
escaped_description="$(printf '%s' "$description" | sed 's/\\/\\\\/g; s/"/\\"/g')"

mkdir -p "$(dirname "$FORMULA")"

cat > "$FORMULA" <<RUBY
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2006-2026 DIY Accounting Limited
class ${class_name} < Formula
  desc "${escaped_description}"
  homepage "https://spreadsheets.diyaccounting.co.uk/diya-gl.html"
  url "${tarball_url}"
  sha256 "${sha256}"
  license "${license}"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/${unscoped_name} 2>&1", 1)
    assert_match "Usage: ${unscoped_name}", output
  end
end
RUBY

echo "Wrote $FORMULA for $PACKAGE $version (sha256 $sha256)."

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$version" >> "$GITHUB_OUTPUT"
fi
