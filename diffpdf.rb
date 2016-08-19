require "formula"

class Diffpdf < Formula
  homepage "http://soft.rubypdf.com/software/diffpdf"
  url "http://soft.rubypdf.com/wp-content/uploads/2010/08/diffpdf-2.1.3.tar.gz"
  sha256 "c6142ee038a78108397f45b0c456dca7a4fe1d75250f21a514a134101d322433"

  depends_on "qt"
  depends_on "poppler" => 'with-qt4'

  def install
    # Path to poppler is hard coded in diffpdf.pro
    inreplace "diffpdf.pro", "/usr/local/include/poppler", "#{Formula["poppler"].include}/poppler"
    system "lrelease", "diffpdf.pro"
    system "qmake"
    system "make"
    prefix.install "diffpdf.app"
    bin.install_symlink prefix+"diffpdf.app/Contents/MacOS/diffpdf"
  end

  test do
    # as diffpdf is a GUI program, there is no real test possible
    system "#{bin}/diffpdf", "--help"
  end
end
