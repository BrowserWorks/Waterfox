#!/bin/bash
set -x -e -v

# Needed by osx-cross-linker.
export TARGET="$1"

# This script is for building sccache

case "$(uname -s)" in
Linux)
    COMPRESS_EXT=xz
    PATH="$MOZ_FETCHES_DIR/binutils/bin:$PATH"
    ;;
MINGW*)
    UPLOAD_DIR=$PWD/public/build
    COMPRESS_EXT=bz2

    . $GECKO_PATH/taskcluster/scripts/misc/vs-setup.sh
    ;;
esac

cd $GECKO_PATH

if [ -n "$TOOLTOOL_MANIFEST" ]; then
  . taskcluster/scripts/misc/tooltool-download.sh
fi

PATH="$(cd $MOZ_FETCHES_DIR && pwd)/rustc/bin:$PATH"

cd $MOZ_FETCHES_DIR/sccache

COMMON_FEATURES="native-zlib"

case "$(uname -s)" in
Linux)
    if [ "$TARGET" == "x86_64-apple-darwin" ]; then
        export PATH="$MOZ_FETCHES_DIR/llvm-dsymutil/bin:$PATH"
        export PATH="$MOZ_FETCHES_DIR/cctools/bin:$PATH"
        export RUSTFLAGS="-C linker=$GECKO_PATH/taskcluster/scripts/misc/osx-cross-linker"
        export CC="$MOZ_FETCHES_DIR/clang/bin/clang"
        export TARGET_CC="$MOZ_FETCHES_DIR/clang/bin/clang -isysroot $MOZ_FETCHES_DIR/MacOSX10.11.sdk"
        cargo build --features "all $COMMON_FEATURES" --verbose --release --target $TARGET
    else
        cargo build --features "all dist-server openssl/vendored $COMMON_FEATURES" --verbose --release
    fi

    ;;
MINGW*)
    cargo build --verbose --release --features="dist-client s3 gcs $COMMON_FEATURES"
    ;;
esac

SCCACHE_OUT=target/release/sccache*
if [ -n "$TARGET" ]; then
    SCCACHE_OUT=target/$TARGET/release/sccache*
fi

mkdir sccache
cp $SCCACHE_OUT sccache/
tar -acf sccache.tar.$COMPRESS_EXT sccache
mkdir -p $UPLOAD_DIR
cp sccache.tar.$COMPRESS_EXT $UPLOAD_DIR

. $GECKO_PATH/taskcluster/scripts/misc/vs-cleanup.sh
