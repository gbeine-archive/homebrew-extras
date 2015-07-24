require 'formula'

class Virtualenv < Formula
  homepage 'https://pypi.python.org/pypi/virtualenv/'
  url 'https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.0.tar.gz'
  sha1 '99f0b1974ac3e7a67f7e365fd00486c0369b5551'

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
