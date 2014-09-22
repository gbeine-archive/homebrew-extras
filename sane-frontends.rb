require 'formula'

class SaneFrontends < Formula
  homepage 'http://www.sane-project.org/'
  url 'http://fossies.org/linux/misc/sane-frontends-1.0.24.tar.gz'
  sha1 '063e11df3e32d7a43161fd37026a4dc601d5482d'

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
