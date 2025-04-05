class Chawan < Formula
  desc "TUI client for Gemini, Gopher, Finger, and Spartan protocols"
  homepage "https://sr.ht/~bptato/chawan/"

  # No stable releases (tags) were found in the upstream repository.
  # Only the HEAD (latest development) version is available for installation.
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  # Set license to Unlicense based on the repository's UNLICENSE file
  license "Unlicense"

  # Build dependencies (Ensure Nim is >= 2.0.0)
  depends_on "nim" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build

  # Runtime dependencies
  depends_on "curl"
  depends_on "libssh2"
  depends_on "ncurses"
  depends_on "openssl"

  def install
    # Compile using make
    system "make"

    # Install using make install, specifying Homebrew's prefix
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # A simple test to ensure the executable is installed and runs.
    assert_match "Usage: cha", shell_output("#{bin}/cha -h", 0)
  end
end
