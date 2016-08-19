require 'formula'

class OracleDownloadStrategy < AbstractFileDownloadStrategy
# Due to license reasons Oracle's client binaries cannot be loaded via curl
  attr_reader :tarball_path, :temporary_path
  def initialize(name, resource)
    super
    @tarball_path = HOMEBREW_CACHE.join("#{name}-#{version}#{ext}")
    @temporary_path = Pathname.new("#{cached_location}.incomplete")
  end
  
  def fetch
    file = "#{HOMEBREW_CACHE}/#{resource.url}"
    unless cached_location.exist?
      unless File.exist?(file)
        print "Please load the file #{resource.url} from http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html and place it in #{HOMEBREW_CACHE}\n"
        exit 1
      end
      File.rename file, cached_location
    end
  end

  def cached_location
    tarball_path
  end

  def clear_cache
    super
    rm_rf(temporary_path)
  end

end

class OracleClient < Formula
  homepage "http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html"
  url "instantclient-basic-macos.x64-12.1.0.2.0.zip", :using => OracleDownloadStrategy
  sha1 "ecbf84ff011fcd8981c2cd9355f958ee42b2e452ebaad2d42df7b226903679cf"

  resource "jdbc" do
    url "instantclient-jdbc-macos.x64-12.1.0.2.0.zip", :using => OracleDownloadStrategy
    sha1 "996a44db0b09080bebc5b73ddadb0636d3e8d9681ed500c23d060b6708b6a0de"
  end

  resource "sdk" do
    url "instantclient-sdk-macos.x64-12.1.0.2.0.zip", :using => OracleDownloadStrategy
    sha1 "63582d9a2f4afabd7f5e678c39bf9184d51625c61e67372acdbc7b42ed8530ac"
  end

  resource "sqlplus" do
    url "instantclient-sqlplus-macos.x64-12.1.0.2.0.zip", :using => OracleDownloadStrategy
    sha1 "d1a83949aa742a4f7e5dfb39f5d2b15b5687c87edf7d998fe6caef2ad4d9ef6d"
  end

  option "with-jdbc", "Install extended JDBC support"
  option "with-sqlplus", "Install sqlplus command line client"
  option "with-sdk", "Install software development kit"

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
