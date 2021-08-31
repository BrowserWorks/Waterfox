set -ex

cd $GITHUB_WORKSPACE
BROWSER_VERSION=`cat browser/config/version_display.txt`
if [[ $(uname -s) = MINGW32_NT-6.2 ]]
then
    INSTALLER_PATH="$BUILD_DIR/objdir-classic/dist/install/sea/WaterfoxClassic$BROWSER_VERSION.exe"
    PLATFORM="win64"
    EXTRACT_PATH="tmp/core"
    APP_PATH="tmp/core"
elif [[ $(uname -s) = Linux ]]
then
    INSTALLER_PATH="$BUILD_DIR/objdir-classic/dist/waterfox-classic-$BROWSER_VERSION.en-US.linux-x86_64.tar.bz2"
    PLATFORM="linux64"
    EXTRACT_PATH="waterfox-classic"
    APP_PATH="waterfox-classic"
elif [[ $(uname -s) = Darwin ]]
then
    INSTALLER_PATH="$BUILD_DIR/objdir-classic/dist/waterfox-classic/WaterfoxClassic.app"
    PLATFORM="osx64"
    EXTRACT_PATH="WaterfoxClassic.app"
    APP_PATH="WaterfoxClassic.app/Contents/Resources"
fi

pushd objdir-classic/dist/
mkdir -p update
cp $BUILD_DIR/tools/update-packaging/make_full_update.sh update/
cp $BUILD_DIR/tools/update-packaging/common.sh update/
cp -r $INSTALLER_PATH update/
xml=('<?xml version="1.0"?>'
'<updates>'
'    <update type="major" appVersion="VERSION"  buildID="BUILDID" detailsURL="https://www.waterfox.net/blog/waterfox-BROWSER_VERSION-release" displayVersion="BROWSER_VERSION" extensionVersion="VERSION" platformVersion="VERSION" version="VERSION">'
'        <patch type="complete" URL="https://cdn.waterfox.net/releases/PLATFORM/update/waterfox-classic-BROWSER_VERSION.en-US.PLATFORM.complete.xz.mar" hashFunction="SHA512" hashValue="HASH" size="SIZE"/>'
'    </update>'
'</updates>')

for line in "${xml[@]}" ; do echo $line >> update/update.xml ; done
pushd update
if [[ $(uname -s) = MINGW32_NT-6.2 ]]
then
    7z x "WaterfoxClassic$BROWSER_VERSION.exe" -otmp/
elif [[ $(uname -s) = Linux ]]
then
    tar -xvf waterfox-classic-$BROWSER_VERSION.en-US.linux-x86_64.tar.bz2
    chmod +x $BUILD_DIR/objdir-classic/dist/host/bin/mar
elif [[ $(uname -s) = Darwin ]]
then
    chmod +x $BUILD_DIR/objdir-classic/dist/host/bin/mar
fi
MAR=$BUILD_DIR/objdir-classic/dist/host/bin/mar \
    MOZ_PRODUCT_VERSION=$BROWSER_VERSION MAR_CHANNEL_ID="default" \
    ./make_full_update.sh \
    waterfox-classic-$BROWSER_VERSION.en-US.$PLATFORM.complete.xz.mar \
    $EXTRACT_PATH
BROWSER_VERSION=$(grep 'DisplayVersion=' $APP_PATH/application.ini | cut -d'=' -f2)
VERSION=$(grep '\<Version\>' $APP_PATH/application.ini | cut -d'=' -f2)
BUILDID=$(grep 'BuildID=' $APP_PATH/application.ini | cut -d'=' -f2)
SHA512=$(shasum -a 512 waterfox-classic-$BROWSER_VERSION.en-US.$PLATFORM.complete.xz.mar | awk '{print $1}')
    SIZE=$(ls -l waterfox-classic-$BROWSER_VERSION.en-US.$PLATFORM.complete.xz.mar | awk '{print $5}')
echo "Display Version: $BROWSER_VERSION, Version: $VERSION, Build ID: $BUILDID, File Size: $SIZE, SHA512: $SHA512"
if [[ $(uname -s) = Darwin ]]
then
    sed -i "" "s/BROWSER_VERSION/$BROWSER_VERSION/g" update.xml
    sed -i "" "s/VERSION/$VERSION/g" update.xml
    sed -i "" "s/BUILDID/$BUILDID/g" update.xml
    sed -i "" "s/SIZE/$SIZE/g" update.xml
    sed -i "" "s/HASH/"$SHA512"/g" update.xml
    sed -i "" "s/PLATFORM/$PLATFORM/g" update.xml
else
    sed -i "s/BROWSER_VERSION/$BROWSER_VERSION/g" update.xml
    sed -i "s/VERSION/$VERSION/g" update.xml
    sed -i "s/BUILDID/$BUILDID/g" update.xml
    sed -i "s/SIZE/$SIZE/g" update.xml
    sed -i "s/HASH/"$SHA512"/g" update.xml
    sed -i "s/PLATFORM/$PLATFORM/g" update.xml
fi
popd
popd
