class AgePluginTpm < Formula
  desc "Age plugin for TPM 2.0 sealed identities, with PIN unlock agent"
  homepage "https://github.com/elohmeier/age-plugin-tpm"
  # TODO: push the `agent` branch of the fork, tag it, and fill in the tag's commit.
  url "https://github.com/elohmeier/age-plugin-tpm.git",
      tag:      "v1.0.1-agent.1",
      revision: "0000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/elohmeier/age-plugin-tpm.git", branch: "agent"

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/age-plugin-tpm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/age-plugin-tpm --version")
  end
end
