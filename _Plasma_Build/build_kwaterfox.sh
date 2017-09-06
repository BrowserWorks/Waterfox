# Waterfox KDE Plasma Edition quick build script
# Version: 1.0.1

#!/bin/bash


# Set current directory to Waterfox source code directory.
SourceDir=$(cd "$(dirname "$0")/.." && pwd)
cd $SourceDir

VERSION=$(<$SourceDir/browser/config/version.txt)

# Test internet connection
function testConnection(){
	echo "Checking for internet connection!"
	wget -q --tries=10 --timeout=20 --spider https://ftp.mozilla.org
	if [[ $? -eq 0 ]]; then
		# 0 = true
		echo "Internet connection found!"
	    return 0 
	else
	    # 1 = false
	    echo "No internet connection found!"
	    return 1
	    exit 0
	fi
}


# Apply KDE Plasma patch to locally downloaded repository.
function ApplyKDE(){
_patchrev=fde25c29562d # Waterfox 55.0.1
	# Download patch if not exist and replace some words
	if [ ! -f "$SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch" ] && [ ! -f "$SourceDir/_Plasma_Build/firefox-kde-$VERSION.patch" ]; then
		# Check url next release for changes.	
			wget -O $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch "http://www.rosenauer.org/hg/mozilla/raw-file/$_patchrev/mozilla-kde.patch"
			wget -O $SourceDir/_Plasma_Build/firefox-kde-$VERSION.patch "http://www.rosenauer.org/hg/mozilla/raw-file/$_patchrev/firefox-kde.patch"
			sed -i 's/Firefox/Waterfox/g' $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch
			sed -i 's/KMOZILLAHELPER/KWATERFOXHELPER/g' $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch
			sed -i 's|/usr/lib/mozilla/kmozillahelper|/opt/waterfox/kwaterfoxhelper|g' $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch
			sed -i 's/kmozillahelper/kwaterfoxhelper/g' $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch
			sed -i 's/firefox/waterfox/g' $SourceDir/_Plasma_Build/firefox-kde-$VERSION.patch
	fi

	# Apply patches if exists
    if [  -f "$SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch" ] && [  -f "$SourceDir/_Plasma_Build/firefox-kde-$VERSION.patch" ] && [ ! -f "$SourceDir/KDE_lock" ]; then
        cd $SourceDir
        patch -Np1 -i $SourceDir/_Plasma_Build/mozilla-kde-$VERSION.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/firefox-kde-$VERSION.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/fix_waterfox_browser-kde_xul.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/pgo_fix_missing_kdejs.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/fix-wifi-scanner.diff
        patch -Np1 -i $SourceDir/_Plasma_Build/no-crmf.diff
				echo >> "$SourceDir/KDE_lock"
    else
        echo "Unable to find KDE patches or patches has already been applied!"
    fi; 
}

testConnection


# Apply KDE Plasma patches
echo "Applying KDE patches"
ApplyKDE

# Build Waterfox KDE Plasma Edition
echo "Do you wish to build Waterfox now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes ) 
        rm -rvf $SourceDir/objdir; 
        ./mach build 
        break;;
		      No ) break;;
		      "Quit" )
			exit 0
		break;;
		  esac
	      done
   

echo "Do you wish to package Waterfox now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )
	./mach package
	
	# Include kde.js
	mkdir -p $SourceDir/objdir/dist/waterfox/browser/defaults/preferences/
	cp -R $SourceDir/_Plasma_Build/kde.js $SourceDir/objdir/dist/waterfox/browser/defaults/preferences/

	break;;
        No ) break;;
        "Quit" )
			exit 0
		break;;
            esac
done
