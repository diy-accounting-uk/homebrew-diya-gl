class DiyaGl < Formula
  desc "Recalculate, read and write DIYA-GL books from the command line"
  homepage "https://spreadsheets.diyaccounting.co.uk/diya-gl.html"
  url "https://registry.npmjs.org/@diy-accounting-uk/diya-gl/-/diya-gl-1.0.3.tgz"
  sha256 "00b44510817056842980d54c1441c8db5287c8e575b00ce3a74fdd8ab1f92360"
  license "AGPL-3.0-only"

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
