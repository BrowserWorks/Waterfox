#!/bin/bash

# Prepare the AppDir

mkdir -p ./AppDir/usr/bin/
tar -jxvf ./dist/Artifact_Classic_*/waterfox*.tar.bz2  -C ./AppDir/
mv ./AppDir/waterfox-classic/* ./AppDir/usr/bin/
rm -rf ./AppDir/waterfox-classic/

mkdir -p ./AppDir/usr/bin/browser/defaults/preferences/
cp ./build/github-actions/appimage/appimage_settings.js ./AppDir/usr/bin/browser/defaults/preferences/

mkdir -p ./AppDir/usr/bin/distribution
install -Dm644 ./build/github-actions/appimage/distribution.ini \
    "$PWD/AppDir/usr/bin/distribution/distribution.ini"

# Generate date and version for metadata file
TODAY_DATE=$(date +%Y-%m-%d)
sed -i "s/__DATE__/$TODAY_DATE/g" ./build/github-actions/appimage/waterfox-classic.appdata.xml.in
VERSION=$(<browser/config/version_display.txt)
sed -i "s/__VERSION__/$VERSION/g" ./build/github-actions/appimage/waterfox-classic.appdata.xml.in

install -Dm644 ./build/github-actions/appimage/waterfox-classic.appdata.xml.in \
    "$PWD/AppDir/usr/share/metainfo/net.waterfox.waterfox-classic.appdata.xml"

install -Dm644 ./build/github-actions/appimage/net.waterfox.waterfox-classic.desktop \
    "$PWD/AppDir/net.waterfox.waterfox-classic.desktop"

mkdir -p "$PWD/AppDir/usr/share/applications"
ln -Trs "$PWD/AppDir/net.waterfox.waterfox-classic.desktop" \
    "$PWD/AppDir/usr/share/applications/net.waterfox.waterfox-classic.desktop"

for i in 16 22 24 32 48 64 128 256; do
    mkdir -p "$PWD/AppDir/usr/share/icons/hicolor/${i}x${i}/apps"
    ln -Trs "$PWD/AppDir/usr/bin/browser/chrome/icons/default/default$i.png" \
        "$PWD/AppDir/usr/share/icons/hicolor/${i}x${i}/apps/waterfox-classic.png"
done

ln -Trs "$PWD/AppDir/usr/bin/browser/chrome/icons/default/default128.png" \
    "$PWD/AppDir/waterfox-classic.png"

install -Dm644 browser/branding/unofficial/content/about-logo.png \
    "$PWD/AppDir/usr/share/icons/hicolor/192x192/apps/waterfox-classic.png"
install -Dm644 browser/branding/unofficial/content/about-logo@2x.png \
    "$PWD/AppDir/usr/share/icons/hicolor/384x384/apps/waterfox-classic.png"

cp ./build/github-actions/appimage/AppRun ./AppDir/AppRun
chmod +x ./AppDir/AppRun
ln -Trs ./AppDir/AppRun ./AppDir/usr/bin/AppRun

mv ./AppDir/ ./dist/

# Create AppImage
cd ./dist || exit
wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x "appimagetool-x86_64.AppImage"
export VERSION
./appimagetool-x86_64.AppImage "$PWD/AppDir" "waterfox-classic-$VERSION-x86_64.AppImage" -u "$UPDATE_INFO"
