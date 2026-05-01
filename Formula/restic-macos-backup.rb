class ResticMacosBackup < Formula
  desc "Restic build with macOS backup integration support"
  homepage "https://restic.net/"
  url "https://github.com/elohmeier/restic/archive/refs/tags/v0.18.1-macos.1.tar.gz"
  version "0.18.1-macos.1"
  sha256 "0b5c75bb743d90739cbe74e2e66dc848e17109081dce4c0b422a97e19bca67e5"
  license "BSD-2-Clause"

  depends_on "go" => :build

  def install
    system "go", "run", "build.go", "--output", "restic-macos-backup"
    bin.install "restic-macos-backup"
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system bin/"restic-macos-backup", "init"
    system bin/"restic-macos-backup", "backup", "--exclude-macos-backup", "--use-fs-snapshot", "testfile"
    system bin/"restic-macos-backup", "restore", "latest", "-t", testpath/"restore"

    assert_path_exists testpath/"restore/testfile"
  end
end
