#!/bin/bash
set -x -e -v

# This script is for building cctools (Apple's binutils) for Mac OS X on
# Linux using ctools-port (https://github.com/tpoechtrager/cctools-port).
WORKSPACE=$HOME/workspace
UPLOAD_DIR=$WORKSPACE/artifacts

# Repository info
: CROSSTOOL_PORT_REPOSITORY    ${CROSSTOOL_PORT_REPOSITORY:=https://github.com/tpoechtrager/cctools-port}
: CROSSTOOL_PORT_REV           ${CROSSTOOL_PORT_REV:=8e9c3f2506b51cf56725eaa60b6e90e240e249ca}

# Set some crosstools-port directories
CROSSTOOLS_SOURCE_DIR=$WORKSPACE/crosstools-port
CROSSTOOLS_CCTOOLS_DIR=$CROSSTOOLS_SOURCE_DIR/cctools
CROSSTOOLS_BUILD_DIR=/tmp/cctools
CLANG_DIR=$WORKSPACE/build/src/clang
CCTOOLS_DIR=$WORKSPACE/build/src/cctools
MACOSX_SDK_DIR=$WORKSPACE/build/src/MacOSX10.10.sdk

TARGET_TRIPLE=x86_64-apple-darwin11

# Create our directories
mkdir -p $CROSSTOOLS_BUILD_DIR

git clone --no-checkout $CROSSTOOL_PORT_REPOSITORY $CROSSTOOLS_SOURCE_DIR
cd $CROSSTOOLS_SOURCE_DIR
git checkout $CROSSTOOL_PORT_REV
echo "Building from commit hash `git rev-parse $CROSSTOOL_PORT_REV`..."

# Fetch clang from tooltool
cd $WORKSPACE/build/src
. taskcluster/scripts/misc/tooltool-download.sh

# Configure crosstools-port
cd $CROSSTOOLS_CCTOOLS_DIR
export CC=$CLANG_DIR/bin/clang
export CXX=$CLANG_DIR/bin/clang++
export CFLAGS="-mcpu=generic -mtune=generic -O3 -target $TARGET_TRIPLE -isysroot $MACOSX_SDK_DIR"
export CXXFLAGS="-mcpu=generic -mtune=generic -O3 -target $TARGET_TRIPLE -isysroot $MACOSX_SDK_DIR"
export LDFLAGS="-Wl,-syslibroot,$MACOSX_SDK_DIR -Wl,-dead_strip"
# TODO: bug 1357317 to avoid the LD_LIBRARY_PATH.
export LD_LIBRARY_PATH="$CLANG_DIR/lib"
export PATH="$CCTOOLS_DIR/bin:$PATH"
./autogen.sh
./configure --prefix=$CROSSTOOLS_BUILD_DIR --build=$MACHTYPE --host=$TARGET_TRIPLE --with-llvm-config=$CLANG_DIR/bin/llvm-config

# Build cctools
make -j `nproc --all` install
$CCTOOLS_DIR/bin/$TARGET_TRIPLE-strip $CROSSTOOLS_BUILD_DIR/bin/*

# Put a tarball in the artifacts dir
mkdir -p $UPLOAD_DIR
tar cjf $UPLOAD_DIR/cctools.tar.bz2 -C $CROSSTOOLS_BUILD_DIR/.. `basename $CROSSTOOLS_BUILD_DIR`
