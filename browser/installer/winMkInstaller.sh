#!/bin/sh

set -e

BROWSER_CHANNEL="current"
OPERATING_SYSTEM="win64"

DISPLAYVERSION=$(grep 'DisplayVersion=' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# DisplayVersion: $DISPLAYVERSION"
VERSION=$(grep '\<Version\>' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# Version: $DISPLAYVERSION"
BUILDID=$(grep 'BuildID=' objdir-$BROWSER_CHANNEL/dist/bin/application.ini | cut -d'=' -f2)
echo "# Build ID: $DISPLAYVERSION"

7z x objdir-$BROWSER_CHANNEL/dist/install/sea/waterfox-$DISPLAYVERSION.en-US.win64.installer.exe -oobjdir-$BROWSER_CHANNEL/dist/install/sea/
rm "objdir-$BROWSER_CHANNEL/dist/install/sea/waterfox-$DISPLAYVERSION.en-US.win64.installer.exe"
find objdir-$BROWSER_CHANNEL/dist/install/sea/ -type f -name "*.exe" -exec signtool sign -a -n Waterfox\ Limited -tr http://timestamp.globalsign.com/?signature=sha2 -td SHA256 {} \;
find objdir-$BROWSER_CHANNEL/dist/install/sea/ -type f -name "*.dll" -exec signtool sign -a -n Waterfox\ Limited -tr http://timestamp.globalsign.com/?signature=sha2 -td SHA256 {} \;
pushd objdir-$BROWSER_CHANNEL/dist/install/sea/
7z a -r -t7z app.7z -mx -m0=BCJ2 -m1=LZMA:d24 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3
cp ../../../../browser/installer/windows/app.tag .
cp ../../../../other-licenses/7zstub/firefox/7zSD.Win32.sfx .
cat 7zSD.Win32.sfx app.tag app.7z > "Waterfox $BROWSER_CHANNEL $DISPLAYVERSION Setup.exe"
signtool sign -a -n Waterfox\ Limited -tr http://timestamp.globalsign.com/?signature=sha2 -td SHA256 "Waterfox $BROWSER_CHANNEL $DISPLAYVERSION Setup.exe"
popd