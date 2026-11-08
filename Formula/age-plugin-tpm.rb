class AgePluginTpm < Formula
  desc "Age plugin for TPM 2.0 sealed identities, with PIN unlock agent"
  homepage "https://github.com/elohmeier/age-plugin-tpm"
  url "https://github.com/elohmeier/age-plugin-tpm.git",
      tag:      "v1.0.1-agent.2",
      revision: "53b6435440b9f5acce8d3fb0488efe98dbc07c71"
  version "1.0.1-agent.2"
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
