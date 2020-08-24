#!/bin/bash

set -e

# Usage: update-nss.sh <NSS version>
# E.g., for NSS 3.55: update-nss.sh 3.55

SCRIPT_PATH=$(dirname "$(realpath -s "$0")")
VERSION=$(echo "$1" | tr . _)
TAG=NSS_${VERSION}_RTM

nss_dir="$SCRIPT_PATH"/nss
rm -rf "$nss_dir"
mkdir -p "$nss_dir"
cd "$SCRIPT_PATH"
mkdir -p "$nss_dir"
git clone --depth 1 --branch "$TAG" https://github.com/nss-dev/nss.git nss

cat >"$nss_dir"/TAG-INFO <<END
$TAG
END
sed -i "s/AM_PATH_NSS[^,]*,/AM_PATH_NSS($1,/" "$SCRIPT_PATH"/../old-configure.in

# Cleanup
rm -rf "$nss_dir"/.git/
find "$nss_dir" -type f -name ".*" ! -name ".gitignore" ! -name ".clang-format" -delete
