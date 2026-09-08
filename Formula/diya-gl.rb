class DiyaGl < Formula
  desc "Recalculate, read and write diya-gl books: a UK sole trader or company's"
  homepage "https://spreadsheets.diyaccounting.co.uk/diya-gl.html"
  url "https://registry.npmjs.org/@diy-accounting-uk/diya-gl/-/diya-gl-1.0.0.tgz"
  sha256 "2933f73ab5498c444a5cf503982ee67e983d7f9d7e4d592a94b85e06a29f412c"
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
