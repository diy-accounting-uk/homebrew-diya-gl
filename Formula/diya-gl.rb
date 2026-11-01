# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2006-2026 DIY Accounting Limited
class DiyaGl < Formula
  desc "Recalculate, read and write DIYA-GL books from the command line"
  homepage "https://spreadsheets.diyaccounting.co.uk/diya-gl.html"
  url "https://registry.npmjs.org/@diy-accounting-uk/diya-gl/-/diya-gl-1.2.73.tgz"
  sha256 "9672a4e336878c2317e40ee9902ca293f31a195ac3c099c012a1595732b72fbe"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/diya-gl 2>&1", 1)
    assert_match "Usage: diya-gl", output
  end
end
