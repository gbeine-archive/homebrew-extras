require 'formula'
require File.expand_path("../../../homebrew/homebrew-php/Requirements/php-meta-requirement", __FILE__)
require File.expand_path("../../../homebrew/homebrew-php/Requirements/phar-requirement", __FILE__)

class Phing < Formula
  homepage 'http://phing.info'
  url 'http://www.phing.info/get/phing-latest.phar'
  sha1 '8e5bf0b392e2f226039365d8243c7e7ebb7d1ca2'
  version 'latest'

  depends_on PhpMetaRequirement
  depends_on PharRequirement

  def install
    libexec.install "phing-#{version}.phar"
    sh = libexec + "phing"
    sh.write("#!/bin/sh\n\n/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/phing-#{version}.phar $*")
    chmod 0755, sh
    bin.install_symlink sh
  end

  test do
    system 'phing --version'
  end

  def caveats; <<-EOS.undent
    Verify your installation by running:
      "phing --version".

    You can read more about phing by running:
      "brew home phing".
    EOS
  end
end
