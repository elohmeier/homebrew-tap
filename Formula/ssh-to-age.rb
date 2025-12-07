class SshToAge < Formula
  desc "Convert SSH Ed25519 keys to age keys"
  homepage "https://github.com/elohmeier/ssh-to-age"
  version "1.3.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/elohmeier/ssh-to-age/releases/download/#{version}/ssh-to-age.darwin-amd64"
      sha256 "c042396745daa23563065a598d78b521b95f61726e61248002f5980941d0f7b9"
    end

    on_arm do
      url "https://github.com/elohmeier/ssh-to-age/releases/download/#{version}/ssh-to-age.darwin-arm64"
      sha256 "982547265af0a2e77aab3eb05a813cfe0bde95532e969494c3db8b0852a93be9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/elohmeier/ssh-to-age/releases/download/#{version}/ssh-to-age.linux-amd64"
      sha256 "0fa89a64ee81a13a86f678fa1dc5d7101d152592c87cb89d91ab23f69127fa76"
    end

    on_arm do
      url "https://github.com/elohmeier/ssh-to-age/releases/download/#{version}/ssh-to-age.linux-arm64"
      sha256 "805491262e186fc175bfed00975f62accec7041291a709ada02e0447aa2a321c"
    end
  end

  def install
    bin.install Dir["ssh-to-age*"].first => "ssh-to-age"
  end

  test do
    output = shell_output("#{bin}/ssh-to-age -h 2>&1", 0)
    assert_match "private-key", output
  end
end
