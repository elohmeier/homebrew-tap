class Sqitch < Formula
  desc "Sensible database change management"
  homepage "https://sqitch.org/"
  url "https://github.com/sqitchers/sqitch/releases/download/v1.6.1/App-Sqitch-v1.6.1.tar.gz"
  sha256 "c82faf99128e5b3303ee3c8e85a3190f00bc91502e3919600ddc1f495f713474"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cpm" => :build
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "sqlite"

  # Perl XS modules need access to perl headers (EXTERN.h etc.)
  # which superenv hides.
  env :std

  def install
    # Install sqitch and all runtime deps via cpm into libexec.
    system "cpm", "install",
           "--local-lib-contained", libexec.to_s,
           "--no-test",
           "App::Sqitch",
           "DBI",
           "DBD::Pg",
           "DBD::SQLite"

    # Install sqitch config templates from the source tarball.
    (etc/"sqitch").install Dir["etc/*"]

    # Patch Config.pm to point to our etc dir.
    config_pm = libexec/"lib/perl5/App/Sqitch/Config.pm"
    inreplace config_pm,
              /my \$SYSTEM_DIR = q\{[^}]*\}/,
              "my $SYSTEM_DIR = q{#{etc}/sqitch}"

    # Record perl version used during build for staleness detection.
    perl_version = Utils.safe_popen_read("perl", "-e", "print $^V").strip
    (libexec/".perl_version").write(perl_version)

    # Create wrapper that sets PERL5LIB and detects perl version mismatch.
    (bin/"sqitch").write <<~BASH
      #!/bin/bash
      set -euo pipefail
      SQITCH_LIBEXEC="#{libexec}"
      BUILT_PERL_VERSION="$(cat "$SQITCH_LIBEXEC/.perl_version")"
      CURRENT_PERL_VERSION="$(perl -e 'print $^V')"
      if [ "$BUILT_PERL_VERSION" != "$CURRENT_PERL_VERSION" ]; then
        echo "sqitch was built with perl $BUILT_PERL_VERSION but current perl is $CURRENT_PERL_VERSION" >&2
        echo "Run: brew reinstall elohmeier/tap/sqitch" >&2
        exit 1
      fi
      export PERL5LIB="$SQITCH_LIBEXEC/lib/perl5${PERL5LIB:+:$PERL5LIB}"
      export PATH="#{Formula["libpq"].opt_bin}:#{Formula["sqlite"].opt_bin}:$PATH"
      exec perl -CAS "$SQITCH_LIBEXEC/bin/sqitch" "$@"
    BASH
  end

  def caveats
    <<~EOS
      PostgreSQL and SQLite support are included.

      Make sure libpq is linked for psql access:
        brew link libpq --force

      After upgrading perl, reinstall sqitch:
        brew reinstall elohmeier/tap/sqitch
    EOS
  end

  test do
    system bin/"sqitch", "--version"
  end
end
