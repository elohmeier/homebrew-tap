class JsonnetLanguageServer < Formula
  desc "Language Server Protocol implementation for Jsonnet"
  homepage "https://github.com/grafana/jsonnet-language-server"
  version "0.15.0"
  url "https://github.com/grafana/jsonnet-language-server/archive/refs/tags/v#{version}.tar.gz"
  sha256 "085085ad1c8c75cb178876726b5a974027058cab9a83dff6435aa5681f687517"
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
    # Verify binary works by checking version
    assert_match "jsonnet-language-server version #{version}", shell_output("#{bin}/jsonnet-language-server --version")
  end
end
