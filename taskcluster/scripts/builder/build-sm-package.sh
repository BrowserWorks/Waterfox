#!/bin/bash

set -xe

source $(dirname $0)/sm-tooltool-config.sh

mkdir -p $UPLOAD_DIR

# Package up the sources into the release tarball.
AUTOMATION=1 DIST=$UPLOAD_DIR $SRCDIR/js/src/make-source-package.sh

# Extract the tarball into a new directory in the workspace.

PACKAGE_DIR=$WORK/sm-package
mkdir -p $PACKAGE_DIR
pushd $PACKAGE_DIR

tar -xjvf $UPLOAD_DIR/mozjs-*.tar.bz2

: ${PYTHON:=python2.7}

# Build the freshly extracted, packaged SpiderMonkey.
pushd ./mozjs-*/js/src

# MOZ_AUTOMATION enforces certain requirements that don't apply to
# packaged builds. Unset it.
unset MOZ_AUTOMATION

AUTOMATION=1 $PYTHON ./devtools/automation/autospider.py --skip-tests=checks $SPIDERMONKEY_VARIANT
popd

# Copy artifacts for upload by TaskCluster
cp -rL ./mozjs-*/obj-spider/dist/bin/{js,jsapi-tests,js-gdb.py,libmozjs*} $UPLOAD_DIR
