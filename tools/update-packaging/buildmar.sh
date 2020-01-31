#!/bin/sh

set -e

# Shell script parsing from https://pretzelhands.com/posts/command-line-flags
# Default values of arguments
BROWSER_CHANNEL="current"
OPERATING_SYSTEM="osx64"

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -c=*|--channel=*)
        BROWSER_CHANNEL="${arg#*=}"
        shift # current or classic
        ;;
        -s=*|--system=*)
        OPERATING_SYSTEM="${arg#*=}"
        shift # osx64, linux64 or win64
        ;;
    esac
done

echo "# Channel: $BROWSER_CHANNEL"
echo "# Operating System: $OPERATING_SYSTEM"

DISPLAYVERSION=$(grep 'DisplayVersion=' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# DisplayVersion: $DISPLAYVERSION"
VERSION=$(grep '\<Version\>' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# Version: $DISPLAYVERSION"
BUILDID=$(grep 'BuildID=' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# Build ID: $DISPLAYVERSION"

mkdir ./objdir-$BROWSER_CHANNEL/dist/update
MAR=./objdir-$BROWSER_CHANNEL/dist/host/bin/mar \
./tools/update-packaging/make_full_update.sh \
./objdir-$BROWSER_CHANNEL/dist/update/waterfox-current-$DISPLAYVERSION.en-US.$OPERATING_SYSTEM.complete.xz.mar \
./objdir-$BROWSER_CHANNEL/dist/waterfox/Waterfox\ Current.app/

SHA512=$(shasum -a 512 objdir-$BROWSER_CHANNEL/dist/update/waterfox-current-$DISPLAYVERSION.en-US.$OPERATING_SYSTEM.complete.xz.mar | awk '{print $1}')
echo "# SHA512: $SHA512"
SIZE=$(ls -l objdir-$BROWSER_CHANNEL/dist/update/waterfox-current-2020.01.1.en-US.$OPERATING_SYSTEM.complete.xz.mar | awk '{print $5}')
echo "# File Size: $SIZE"

cp ./tools/update-packaging/update.xml ./objdir-$BROWSER_CHANNEL/dist/update/update.xml
sed -i '' -e "s/DISPLAYVERSION/$DISPLAYVERSION/g" objdir-$BROWSER_CHANNEL/dist/update/update.xml
sed -i '' -e "s/VERSION/$VERSION/g" objdir-$BROWSER_CHANNEL/dist/update/update.xml
sed -i '' -e "s/BUILDID/$BUILDID/g" objdir-$BROWSER_CHANNEL/dist/update/update.xml
sed -i '' -e "s/SIZE/$SIZE/g" objdir-$BROWSER_CHANNEL/dist/update/update.xml
sed -i '' -e "s/HASH/"$SHA512"/g" objdir-$BROWSER_CHANNEL/dist/update/update.xml