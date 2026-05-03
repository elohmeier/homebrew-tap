class OpendataloaderPdf < Formula
  desc "PDF parser for AI-ready data extraction (Markdown, JSON, HTML)"
  homepage "https://github.com/opendataloader-project/opendataloader-pdf"
  url "https://github.com/opendataloader-project/opendataloader-pdf/releases/download/v2.4.1/opendataloader-pdf-cli-2.4.1.zip"
  sha256 "91af7b0b12acad1d66fafb62392111b233aba014ead9d5ee107a02f875b2e387"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "openjdk"

  def install
    libexec.install "opendataloader-pdf-cli-#{version}.jar" => "opendataloader-pdf-cli.jar"

    (bin/"opendataloader-pdf").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -Djava.awt.headless=true -jar "#{libexec}/opendataloader-pdf-cli.jar" "$@"
    EOS
  end

  test do
    assert_path_exists libexec/"opendataloader-pdf-cli.jar"
    assert_match "format", shell_output("#{bin}/opendataloader-pdf 2>&1")
  end
end
