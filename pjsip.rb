
require 'formula'

class Pjsip < Formula
  homepage 'http://www.pjsip.org'
  url 'http://www.pjsip.org/release/2.6/pjproject-2.6.tar.bz2'
  sha256 '2f5a1da1c174d845871c758bd80fbb580fca7799d3cfaa0d3c4e082b5161c7b4'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    Pathname('pjlib/include/pj/config_site.h').write <<-EOS.undent
      #define PJ_CONFIG_MAXIMUM_SPEED
      #include <pj/config_site_sample.h>

      #ifndef FD_SETSIZE
        #include <sys/types.h>
      #endif

      #if PJ_IOQUEUE_MAX_HANDLES>FD_SETSIZE
        #undef PJ_IOQUEUE_MAX_HANDLES
        #define PJ_IOQUEUE_MAX_HANDLES     FD_SETSIZE
      #endif

      #define PJSUA_MAX_CALLS              1024
      #define PJSUA_MAX_PLAYERS            1024
      #define PJSUA_MAX_RECORDERS          1024
      #define PJSUA_MAX_CONF_PORTS         (PJSUA_MAX_CALLS+PJSUA_MAX_PLAYERS+PJSUA_MAX_RECORDERS)
    EOS
    system "make", "dep"
    system "make"
    system "make", "install"
  end
end

