class SshTpmAgent < Formula
  desc "SSH agent with support for TPM sealed keys"
  homepage "https://github.com/Foxboron/ssh-tpm-agent"
  url "https://github.com/Foxboron/ssh-tpm-agent/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "355f8ec5b07fcc1ad60041c0806fd477adc3f5f0c82b0f8883710be1db0b0e75"
  license "MIT"
  head "https://github.com/Foxboron/ssh-tpm-agent.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    # cgo only adds go-tpm-tools' OpenSSL-linked simulator, which is for testing
    ENV["CGO_ENABLED"] = "0"
    %w[ssh-tpm-agent ssh-tpm-keygen ssh-tpm-add ssh-tpm-hostkeys].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match "ssh-tpm-agent.sock", shell_output("#{bin}/ssh-tpm-agent --print-socket")
    assert_match "Usage", shell_output("#{bin}/ssh-tpm-keygen --help 2>&1")
  end
end
