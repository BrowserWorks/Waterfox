#!/bin/bash

set -e

# Usage: update-nspr.sh <NSPR version>
# E.g., for NSPR 4.28: update-nspr.sh 4.28

SCRIPT_PATH=$(dirname "$(realpath -s "$0")")
VERSION=$(echo "$1" | tr . _)
TAG=NSPR_${VERSION}_RTM

nspr_dir="$SCRIPT_PATH"/../nsprpub
rm -rf "$nspr_dir"
mkdir -p "$nspr_dir"
cd "$SCRIPT_PATH"/..
mkdir -p "$nspr_dir"
hg clone --verbose https://hg.mozilla.org/projects/nspr -r "$TAG" nsprpub

cat >"$nspr_dir"/TAG-INFO <<END
$TAG
END
sed -i 's/NSPR_MINVER.*/NSPR_MINVER='$1'/g' "$SCRIPT_PATH"/../old-configure.in

# Cleanup
rm -rf "$nspr_dir"/.hg/
find "$nspr_dir" -type f -name ".*" -delete
