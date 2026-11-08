class Passage < Formula
  desc "Password manager using age encryption, a fork of pass"
  homepage "https://github.com/FiloSottile/passage"
  url "https://github.com/FiloSottile/passage/archive/refs/tags/1.7.4a2.tar.gz"
  sha256 "d4bd97be2eda4249b31c2042707ef70ba50385f6fb7791598f51be794168ee2c"
  license "GPL-2.0-or-later"
  head "https://github.com/FiloSottile/passage.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?\d*)$/i)
  end

  depends_on "age"
  depends_on "qrencode"
  depends_on "tree"

  on_macos do
    depends_on "gnu-getopt"
  end

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}",
                   "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace bin/"passage",
              /^SYSTEM_EXTENSION_DIR=.*$/,
              "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/passage/extensions\""
  end

  test do
    ENV["PASSAGE_DIR"] = testpath/"store"
    ENV["PASSAGE_IDENTITIES_FILE"] = testpath/"identities"
    system formula_opt_bin("age")/"age-keygen", "-o", testpath/"identities"
    (testpath/"store").mkpath
    (testpath/"store/.age-recipients").write shell_output(
      "#{formula_opt_bin("age")}/age-keygen -y #{testpath}/identities",
    )
    pipe_output("#{bin}/passage insert --multiline Email/testing@foo.bar", "hunter2\n", 0)
    assert_path_exists testpath/"store/Email/testing@foo.bar.age"
    assert_equal "hunter2", shell_output("#{bin}/passage show Email/testing@foo.bar").chomp
  end
end
