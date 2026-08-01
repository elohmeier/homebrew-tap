class Taskjuggler < Formula
  desc "Project management tool with an optimizing scheduler"
  homepage "https://taskjuggler.org/"
  url "https://github.com/elohmeier/TaskJuggler/archive/32aea8cb9634a6b7559fcc22b04b52db8f64c8f8.tar.gz"
  version "3.8.4"
  sha256 "0c48c54500749b40ab742c013397dee985feca5d302eb3491a3408aca3fbb438"
  license "GPL-2.0-only"
  revision 2

  depends_on "ruby"

  # Runtime dependencies not provided as default gems by Homebrew's Ruby.
  resource "webrick" do
    url "https://rubygems.org/downloads/webrick-1.9.2.gem"
    sha256 "beb4a15fc474defed24a3bda4ffd88a490d517c9e4e6118c3edce59e45864131"
  end

  resource "sync" do
    url "https://rubygems.org/downloads/sync-0.5.0.gem"
    sha256 "668356cc07c59ac7ed9ecf34fec3929831f179c07adb1f3e1c3b7a1609a638fd"
  end

  resource "tins" do
    url "https://rubygems.org/downloads/tins-1.32.1.gem"
    sha256 "b75c4dafafa83744b6925c0e4ac7a9a8ee9aba7c72514fb0b08cd2f98ffde30c"
  end

  resource "term-ansicolor" do
    url "https://rubygems.org/downloads/term-ansicolor-1.11.3.gem"
    sha256 "8c01ec3abd095eb94dca8aed5a127d36e594239eb525eb306259c9e930534603"
  end

  resource "net-protocol" do
    url "https://rubygems.org/downloads/net-protocol-0.2.2.gem"
    sha256 "aa73e0cba6a125369de9837b8d8ef82a61849360eba0521900e2c3713aa162a8"
  end

  resource "net-smtp" do
    url "https://rubygems.org/downloads/net-smtp-0.5.1.gem"
    sha256 "ed96a0af63c524fceb4b29b0d352195c30d82dd916a42f03c62a3a70e5b70736"
  end

  resource "net-pop" do
    url "https://rubygems.org/downloads/net-pop-0.1.2.gem"
    sha256 "848b4e982013c15b2f0382792268763b748cce91c9e91e36b0f27ed26420dff3"
  end

  resource "net-imap" do
    url "https://rubygems.org/downloads/net-imap-0.6.4.1.gem"
    sha256 "29f0360d75a7efd3539f16ac1957dea5c0a51ddeceb348db4553c3120914ea0d"
  end

  resource "mini_mime" do
    url "https://rubygems.org/downloads/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "mail" do
    url "https://rubygems.org/downloads/mail-2.9.1.gem"
    sha256 "06574eca475253d6c18145dd70af80d0eb970182d55053497c5f4d797ea160e8"
  end

  # Ruby 4 extracts these libraries from the standard library.
  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  resource "drb" do
    url "https://rubygems.org/downloads/drb-2.2.3.gem"
    sha256 "0b00d6fdb50995fe4a45dea13663493c841112e4068656854646f418fda13373"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |resource|
      resource.fetch
      system "gem", "install", resource.cached_download,
             "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "taskjuggler.gemspec"
    system "gem", "install", "taskjuggler-#{version}.gem",
           "--ignore-dependencies", "--no-document", "--install-dir", libexec

    bin.install libexec.glob("bin/tj3*")
    bin.env_script_all_files libexec/"bin",
                             GEM_HOME: ENV.fetch("GEM_HOME"),
                             GEM_PATH: ENV.fetch("GEM_HOME")

    gem_root = libexec/"gems/taskjuggler-#{version}"
    manpages = (gem_root/"man").glob("*.1")
    man1.install manpages unless manpages.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tj3 --version")

    (testpath/"project.tjp").write <<~TJP
      project brew "Homebrew test" "1.0" 2026-01-01 +1w

      task build "Build formula" {
        start 2026-01-01
        length 1d
      }

      textreport report "report" {
        taskreport tasks ""
        formats html
      }
    TJP

    output_dir = testpath/"reports"
    output_dir.mkpath
    system bin/"tj3", "--silent", "--output-dir", output_dir,
                      "--report", "report", testpath/"project.tjp"
    assert_match "Homebrew test", (output_dir/"report.html").read
  end
end
