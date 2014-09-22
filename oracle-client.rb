require 'formula'

class OracleDownloadStrategy < CurlDownloadStrategy
# Due to license reasons Oracle's client binaries cannot be loaded via curl
  def curl(*args)
    file = "#{HOMEBREW_CACHE}/#{args[0]}"
    unless File.exist?(file)
      print "Please load the file #{file} from http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html and place it in #{HOMEBREW_CACHE}\n"
      exit 1
    end
    args[0] = "file://#{file}"
    super
  end
end

class OracleClient < Formula
  homepage "http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html"
  url "instantclient-basic-macos.x64-11.2.0.4.0.zip", :using => OracleDownloadStrategy
  sha1 "d9b5a1d13ecf2fca0317fc7b4964576a95990f08"

  resource "jdbc" do
    url "instantclient-jdbc-macos.x64-11.2.0.4.0.zip", :using => OracleDownloadStrategy
    sha1 "05ef8d96b3bde0c6133a24810e797a2cda48581a"
  end

  resource "sdk" do
    url "instantclient-sdk-macos.x64-11.2.0.4.0.zip", :using => OracleDownloadStrategy
    sha1 "1c37a37e62d02bad7705d7e417810da7fda9bd0e"
  end

  resource "sqlplus" do
    url "instantclient-sqlplus-macos.x64-11.2.0.4.0.zip", :using => OracleDownloadStrategy
    sha1 "0ee3385f508d03136f8131672f38b636f0f9f274"
  end

  option "with-jdbc", "Install extended JDBC support"
  option "with-sqlplus", "Install sqlplus command line client"
  option "with-sdk", "Install software development kit"

  def pre_install
exit 1
  end

  def install
    if build.with? "jdbc"
      resource("jdbc").stage do
        libexec.install Dir["*.jar", "*.dylib"]
        libexec.install Dir["*.dylib"]
        doc.install Dir["*README"]
      end
    end
    if build.with? "sdk"
      resource("sdk").stage do
        bin.install "sdk/ott"
        libexec.install "sdk/ottclasses.zip"
        (include/"oracle-client").install Dir["sdk/include/*"]
        doc.install Dir["sdk/*README"]
        (share/"oracle-client").install "sdk/demo"
      end
    end
    if build.with? "sqlplus"
      resource("sqlplus").stage do
        bin.install "sqlplus"
        libexec.install Dir["*.dylib"]
        doc.install Dir["glogin.sql", "*README"]
      end
    end
    bin.install Dir["adrci", "genezi", "uidrvci"]
    libexec.install Dir["*.jar", "*.dylib", "*.11.1"]
    doc.install Dir["*README"]
  end

  def caveats; <<-EOS.undent
    To run Oracle client executables ensure to set DYLD_LIBRARY_PATH
      export DYLD_LIBRARY_PATH=#{libexec}
    EOS
  end
end
