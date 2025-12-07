class SshToAge < Formula
  desc "Convert SSH Ed25519 keys to age keys"
  homepage "https://github.com/Mic92/ssh-to-age"
  version "1.2.0"
  url "https://github.com/Mic92/ssh-to-age/archive/refs/tags/#{version}.tar.gz"
  sha256 "253ba51a8224371019efb95ec0164f7b1a35413e4473fe0135aed320e09f0671"
  license "MIT"
  head "https://github.com/Mic92/ssh-to-age.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ssh-to-age"
  end

  test do
    # Test that the binary runs and shows help when given invalid input
    output = shell_output("#{bin}/ssh-to-age -h 2>&1", 0)
    assert_match "private-key", output
  end
end
