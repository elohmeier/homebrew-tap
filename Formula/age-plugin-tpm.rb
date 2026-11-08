class AgePluginTpm < Formula
  desc "Age plugin for TPM 2.0 sealed identities, with PIN unlock agent"
  homepage "https://github.com/elohmeier/age-plugin-tpm"
  url "https://github.com/elohmeier/age-plugin-tpm.git",
      tag:      "v1.0.1-agent.1",
      revision: "6485358467d5a6b5bc5f687afe331aa746316ea7"
  version "1.0.1-agent.1"
  license "MIT"
  head "https://github.com/elohmeier/age-plugin-tpm.git", branch: "agent"

  depends_on "go" => :build
  depends_on :linux
  depends_on "openssl@3"

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/age-plugin-tpm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/age-plugin-tpm --version")
  end
end
