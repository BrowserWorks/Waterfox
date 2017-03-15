#!/bin/bash -vex

set -x -e

: WORKSPACE ${WORKSPACE:=/workspace}
: GRADLE_VERSION ${GRADLE_VERSION:=2.14.1}

set -v

# Package everything up.
pushd ${WORKSPACE}
# Not yet.  See notes on tooltool below.
# cp -R /root/.android-sdk android-sdk-linux
# tar cJf android-sdk-linux.tar.xz android-sdk-linux

cp -R /workspace/nexus/storage/central jcentral
tar cJf jcentral.tar.xz jcentral

# The Gradle wrapper will have downloaded and verified the hash of exactly one
# Gradle distribution.  It will be located in $GRADLE_USER_HOME, like
# ~/.gradle/wrapper/dists/gradle-2.7-all/$PROJECT_HASH/gradle-2.7-all.zip.  We
# want to remove the version from the internal directory for use via tooltool in
# a mozconfig.
cp $GRADLE_USER_HOME/wrapper/dists/gradle-${GRADLE_VERSION}-all/*/gradle-${GRADLE_VERSION}-all.zip gradle-${GRADLE_VERSION}-all.zip
unzip -q gradle-${GRADLE_VERSION}-all.zip
mv gradle-${GRADLE_VERSION} gradle-dist
tar cJf gradle-dist.tar.xz gradle-dist

mkdir -p /home/worker/artifacts
# We can't redistribute the Android SDK publicly just yet.  We'll
# upload to (internal) tooltool eventually.  mv
# android-sdk-linux.tar.xz /home/worker/artifacts
mv jcentral.tar.xz /home/worker/artifacts
mv gradle-dist.tar.xz /home/worker/artifacts
popd

# Bug 1245170: at some point in the future, we'll be able to upload
# things directly to tooltool.
# pushd /home/worker/artifacts
# /build/tooltool.py add --visibility=public jcentral.tar.xz
# /build/tooltool.py add --visibility=public gradle-dist.tar.xz
# /build/tooltool.py add --visibility=internal android-sdk-linux.tar.xz
# /build/tooltool.py upload -v --url=http://relengapi/tooltool/ \
#   --message="No message - Gradle and jcentral archives uploaded from taskcluster."
# popd
