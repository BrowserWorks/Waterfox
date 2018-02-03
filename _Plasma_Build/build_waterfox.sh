# Waterfox quick build script
# Version: 1.0

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


# Apply patches to locally downloaded repository.
function ApplyPatches(){
	# Apply patches
    if [ ! -f "$SourceDir/wf_lock" ]; then
        cd $SourceDir
        patch -Np1 -i $SourceDir/_Plasma_Build/wifi-disentangle.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/wifi-fix-interface.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/0001-Bug-1384062-Make-SystemResourceMonitor.stop-more-res.patch
        patch -Np1 -i $SourceDir/_Plasma_Build/glibc-2.26-fix.diff
				echo >> "$SourceDir/wf_lock"
    else
        echo "Unable to find patches or patches has already been applied!"
    fi; 
}

testConnection


# Apply patches
echo "Applying patches"
ApplyPatches

# Build Waterfox
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
	break;;
        No ) break;;
        "Quit" )
			exit 0
		break;;
            esac
done
