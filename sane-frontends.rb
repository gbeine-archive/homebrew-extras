require 'formula'

class SaneFrontends < Formula
  homepage 'http://www.sane-project.org/'
  url 'http://fossies.org/linux/misc/sane-frontends-1.0.14.tar.gz'
  sha1 'e7839dac1b70b5bb39124615aba8a136f5275d0e78bafd3d52ed76964ffea4a9'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'sane-backends'

  def install

    inreplace "src/gtkglue.c",
      "if (!(opt->cap & SANE_CAP_ALWAYS_SETTABLE))", ""
    inreplace "src/gtkglue.c",
      "gtk_widget_set_sensitive (dialog->element[i].widget, sensitive);", ""

    system "./configure", "--prefix=#{prefix}",
                          "--disable-gimp"
    system "make"
    system "make install"
  end

end
