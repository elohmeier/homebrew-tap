class AgePluginSe < Formula
  desc "Age plugin for Apple Secure Enclave, with application-password unlock agent"
  homepage "https://github.com/elohmeier/age-plugin-se"
  url "https://github.com/elohmeier/age-plugin-se.git",
      tag:      "v0.2.1-agent.5",
      revision: "f5f50aac84e85abd626e3dae01e41198be41b91e"
  version "0.2.1-agent.5"
  license "MIT"
  head "https://github.com/elohmeier/age-plugin-se.git", branch: "agent"

  depends_on xcode: ["26.0", :build]
  depends_on "age" => :test
  depends_on macos: :tahoe

  conflicts_with "age-plugin-se", because: "both install `age-plugin-se`"

  def install
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "all"
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "install"
  end

  test do
    (testpath/"secret.txt").write "My secret"
    system "age", "--encrypt",
           "-r", "age1se1qgg72x2qfk9wg3wh0qg9u0v7l5dkq4jx69fv80p6wdus3ftg6flwg5dz2dp",
           "-o", "secret.txt.age", "secret.txt"
    assert_path_exists testpath/"secret.txt.age"

    assert_match "v0.2.1", shell_output("#{bin}/age-plugin-se --version")
  end
end
