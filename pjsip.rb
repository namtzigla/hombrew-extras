require 'formula'

class Pjsip < Formula
  homepage 'http://www.pjsip.org'
  url 'http://www.pjsip.org/release/2.5.1/pjproject-2.5.1.tar.bz2'
  sha256 'c5a63bed7a0832ff53ddcd69612cf43148019d0f320b22beb5ca2223bc857dcb'

  # 1. We aren't cross compiling
  #    pjsip thinks we are, this is fixed somewhere between revision 4305 and
  #    4621. This should be removed when this formula is updated to 2.2.
  # 2, 3. Clang compatibility
  #    This is fixed in revision 4588 and should be removed when this formula
  #    is updated to 2.2. http://trac.pjsip.org/repos/ticket/1576
  # patch :DATA

  def install
    ENV.j1
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

