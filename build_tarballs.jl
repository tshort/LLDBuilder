using BinaryBuilder

# Collection of sources required to build WABT
sources = [
    "https://github.com/WebAssembly/wabt/archive/1.0.0.tar.gz" =>
    "a5d4cfb410fbe94814ed8ae67a2c356c4ea39d26578ca5b48a8d7ede2a0e08eb",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd wabt-1.0.0/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=gcc-release -DBUILD_TESTS=OFF
if [ $target = "i686-w64-mingw32" ]; then
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=gcc-i386-release -DBUILD_TESTS=OFF
fi

make -j8
make install

if [ $target = "x86_64-w64-mingw32" ]; then
  echo hello
fi


if [ $target = "x86_64-unknown-freebsd11.1" ]; then
cd $WORKSPACE/srcdir
ls
cd wabt-1.0.0/
ls -l
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=clang-release -DBUILD_TESTS=OFF
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=gcc-release -DBUILD_TESTS=OFF
make --version
ls /opt/$target
ls -l /opt/$target
ls -l /opt/$target/x86_64-unknown-freebsd11.1/

ls -l /opt/$target/x86_64-unknown-freebsd11.1/
ls -l /opt/$target/

fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi),
    BinaryProvider.Linux(:i686, :musl, :blank_abi),
    BinaryProvider.Linux(:x86_64, :musl, :blank_abi),
    BinaryProvider.Linux(:aarch64, :musl, :blank_abi),
    BinaryProvider.Linux(:armv7l, :musl, :eabihf),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "", :wast_sugar),
    ExecutableProduct(prefix, "", :wasm_objdump),
    ExecutableProduct(prefix, "", :wasm_interp),
    ExecutableProduct(prefix, "", :wasm_link),
    ExecutableProduct(prefix, "", :wasm_opcodecnt),
    ExecutableProduct(prefix, "", :wast2wasm),
    ExecutableProduct(prefix, "", :wasm2wast)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "WABT", sources, script, platforms, products, dependencies)

