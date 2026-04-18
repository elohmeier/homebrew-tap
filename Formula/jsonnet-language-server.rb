class JsonnetLanguageServer < Formula
  desc "Language Server Protocol implementation for Jsonnet"
  homepage "https://github.com/grafana/jsonnet-language-server"
  url "https://github.com/grafana/jsonnet-language-server/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7d51fbd633475f449772c95e410ffb498df5e4e2102c7ac49072a76f38a5b98b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/jsonnet-language-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "jsonnet-language-server version #{version}", shell_output("#{bin}/jsonnet-language-server --version")
  end
end
