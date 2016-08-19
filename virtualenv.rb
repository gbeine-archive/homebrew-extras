require 'formula'

class Virtualenv < Formula
  homepage 'https://pypi.python.org/pypi/virtualenv/'
  url 'https://pypi.python.org/packages/8b/2c/c0d3e47709d0458816167002e1aa3d64d03bdeb2a9d57c5bd18448fd24cd/virtualenv-15.0.3.tar.gz#md5=a5a061ad8a37d973d27eb197d05d99bf'
  sha1 '6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d'

  depends_on :python

  def install
    vendor_path = lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_path
    (lib/"python2.7/site-packages/homebrew-virtualenv.pth").write "#{vendor_path}\n"
    system "python", "setup.py", "build", "install", "--prefix=#{prefix}"
    (lib/"python2.7/site-packages/easy-install.pth").delete
    (lib/"python2.7/site-packages/site.py").delete
  end
end
