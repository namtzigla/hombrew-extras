
require 'formula'

class Grpc < Formula
  homepage 'http://grpc.io'
  url ' https://github.com/grpc/grpc/archive/release-0_14_1.tar.gz'
  sha256 '006cde82481d72f3490e7d933fe91a81bec3b30a6928251796ea47a0098267de'
  depends_on "protobuf" 


  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
