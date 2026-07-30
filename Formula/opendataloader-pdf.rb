class OpendataloaderPdf < Formula
  desc "PDF parser for AI-ready data extraction (Markdown, JSON, HTML)"
  homepage "https://github.com/opendataloader-project/opendataloader-pdf"
  url "https://github.com/opendataloader-project/opendataloader-pdf/releases/download/v2.5.0/opendataloader-pdf-cli-2.5.0.zip"
  sha256 "738e0a85b8fa82599205f47ede74dd76b0ede99e5bc5998b73c5f92320e6dc6b"
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
