class ResticMacosBackup < Formula
  desc "Restic build with macOS backup exclusion support"
  homepage "https://restic.net/"
  url "https://github.com/elohmeier/restic/archive/refs/tags/v0.18.1-macos-backup-excludes.1.tar.gz"
  version "0.18.1-macos-backup-excludes.1"
  sha256 "2bf264a6135d1213d0e731048c77bb5ad3f33a8ec6d4fb03d2ef74904b12a38d"
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
    system bin/"restic-macos-backup", "backup", "--exclude-macos-backup", "testfile"
    system bin/"restic-macos-backup", "restore", "latest", "-t", testpath/"restore"

    assert_path_exists testpath/"restore/testfile"
  end
end
