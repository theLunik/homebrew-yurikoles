class XmrigAmd < Formula
  desc "Monero AMD (OpenCL) miner"
  homepage "https://github.com/xmrig/xmrig-amd"
  url "https://github.com/xmrig/xmrig-amd/archive/v2.8.6.tar.gz"
  sha256 "df300404220481ac655348358116823e16b6077cf48408e0cc91265968e56b0f"

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig-amd"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig-amd -V", 2)
  end
end
