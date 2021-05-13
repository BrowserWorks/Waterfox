set -ex

cd $APPVEYOR_BUILD_FOLDER

BROWSER_VERSION=`cat browser/config/version_display.txt`
SIGNTOOL=/c/PROGRA~2/WI3CF2~1/10/bin/10.0.17763.0/x64/signtool.exe
TOPDIR=$APPVEYOR_BUILD_FOLDER

./mach build
./mach build installer

# "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64\signtool.exe" sign -tr http://timestamp.digicert.com -fd sha256 -f "build/appveyor/waterfox.cer" -csp "eToken Base Cryptographic Provider" -kc "[{{$CSP}}]=te-ba4d65f7-af06-4aa4-91c1-54d4f0cb9b5b" objdir-classic/dist/install/sea/waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe

# Extract unsigned installer, sign DLLs and EXEs and then create installer. Sign resulting installer.

pushd objdir-classic/dist/install/sea/
7z x waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe
rm -f waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe
find ./ -type f -name "*.exe" -exec $SIGNTOOL sign -tr http://timestamp.digicert.com -fd sha256 -f "$BUILD_DIR/build/appveyor/waterfox.cer" -csp "eToken Base Cryptographic Provider" -kc "[{{$CSP}}]=te-ba4d65f7-af06-4aa4-91c1-54d4f0cb9b5b" {} \;
find ./ -type f -name "*.dll" -exec $SIGNTOOL sign -tr http://timestamp.digicert.com -fd sha256 -f "$BUILD_DIR/build/appveyor/waterfox.cer" -csp "eToken Base Cryptographic Provider" -kc "[{{$CSP}}]=te-ba4d65f7-af06-4aa4-91c1-54d4f0cb9b5b" {} \;
7z a -r -t7z app.7z -mx -m0=BCJ2 -m1=LZMA:d25 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3
cp $BUILD_DIR/browser/installer/windows/app.tag .
cp $BUILD_DIR/other-licenses/7zstub/firefox/7zSD.sfx .
cat 7zSD.sfx app.tag app.7z > "Waterfox Classic $BROWSER_VERSION Setup.exe"
$SIGNTOOL sign -tr http://timestamp.digicert.com -fd sha256 -f "$BUILD_DIR/build/appveyor/waterfox.cer" -csp "eToken Base Cryptographic Provider" -kc "[{{$CSP}}]=te-ba4d65f7-af06-4aa4-91c1-54d4f0cb9b5b" "Waterfox Classic $BROWSER_VERSION Setup.exe"
popd

# Generate update XML and file

pushd objdir-classic/dist/
mkdir update
cp $BUILD_DIR/tools/update-packaging/make_full_update.sh update/
cp $BUILD_DIR/tools/update-packaging/common.sh update/
cp "$BUILD_DIR/objdir-classic/dist/install/sea/Waterfox Classic $BROWSER_VERSION Setup.exe" update/
xml=('<?xml version="1.0"?>'
'<updates>'
'    <update type="major" appVersion="VERSION"  buildID="BUILDID" detailsURL="https://www.waterfox.net/blog/waterfox-BROWSER_VERSION-release" displayVersion="BROWSER_VERSION" extensionVersion="VERSION" platformVersion="VERSION" version="VERSION">'
'        <patch type="complete" URL="https://cdn.waterfox.net/releases/win64/update/waterfox-classic-BROWSER_VERSION.en-US.win64.complete.xz.mar" hashFunction="SHA512" hashValue="HASH" size="SIZE"/>'
'    </update>'
'</updates>')

for line in "${xml[@]}" ; do echo $line >> update/update.xml ; done
pushd update
7z x "Waterfox Classic $BROWSER_VERSION Setup.exe" -otmp/
MAR=$BUILD_DIR/objdir-classic/dist/host/bin/mar \
    MOZ_PRODUCT_VERSION=$BROWSER_VERSION MAR_CHANNEL_ID="default" \
    ./make_full_update.sh \
    waterfox-classic-$BROWSER_VERSION.en-US.win64.complete.xz.mar \
    'tmp/core'
BROWSER_VERSION=$(grep 'DisplayVersion=' tmp/core/application.ini | cut -d'=' -f2)
VERSION=$(grep '\<Version\>' tmp/core/application.ini | cut -d'=' -f2)
BUILDID=$(grep 'BuildID=' tmp/core/application.ini | cut -d'=' -f2)
SHA512=$(shasum -a 512 waterfox-classic-$BROWSER_VERSION.en-US.win64.complete.xz.mar | awk '{print $1}')
    SIZE=$(ls -l waterfox-classic-$BROWSER_VERSION.en-US.win64.complete.xz.mar | awk '{print $5}')
echo "Display Version: $BROWSER_VERSION, Version: $VERSION, Build ID: $BUILDID, File Size: $SIZE, SHA512: $SHA512"
sed -i "s/OPERATING_SYSTEM/$OPERATING_SYSTEM/g" update.xml
sed -i "s/BROWSER_VERSION/$BROWSER_VERSION/g" update.xml
sed -i "s/VERSION/$VERSION/g" update.xml
sed -i "s/BUILDID/$BUILDID/g" update.xml
sed -i "s/SIZE/$SIZE/g" update.xml
sed -i "s/HASH/"$SHA512"/g" update.xml
sed -i "s/PLATFORM/win/g" update.xml
popd
popd
