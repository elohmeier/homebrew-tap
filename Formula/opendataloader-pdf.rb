class OpendataloaderPdf < Formula
  desc "PDF parser for AI-ready data extraction (Markdown, JSON, HTML)"
  homepage "https://github.com/opendataloader-project/opendataloader-pdf"
  url "https://github.com/opendataloader-project/opendataloader-pdf/releases/download/v2.4.7/opendataloader-pdf-cli-2.4.7.zip"
  sha256 "dafcadc514cb5fb77f6f108a1a3be9a11937f0304749c5707bdd0881abea20bc"
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
