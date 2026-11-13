# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2006-2026 DIY Accounting Limited
class DiyaGl < Formula
  desc "Recalculate, read and write DIYA-GL books from the command line"
  homepage "https://spreadsheets.diyaccounting.co.uk/diya-gl.html"
  url "https://registry.npmjs.org/@diy-accounting-uk/diya-gl/-/diya-gl-1.2.81.tgz"
  sha256 "00907b71070a0d2d0ebd22faac70914761ac09499be84af47e3fae4e7efe559c"
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
