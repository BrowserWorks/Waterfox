set -ex

cd /c/Builds/waterfox

./mach -v build
./mach -v build installer

BROWSER_VERSION=`cat browser/config/version_display.txt`
ls -a objdir-classic/dist/installer/sea/
"C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64\signtool.exe" sign -tr http://timestamp.digicert.com -fd sha256 -f "build/appveyor/waterfox.cer" -csp "eToken Base Cryptographic Provider" -kc "[{{$CSP}}]=te-ba4d65f7-af06-4aa4-91c1-54d4f0cb9b5b" "objdir-classic/dist/installer/sea/waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe"

# YEAR=$(date +%Y)
# MONTH=$(date +%m)
# DAY=$(date +%-e) # single digit, no leading zeros or spaces
# HOUR=$(date +%H)
# DATE="$YEAR/$MONTH/$DAY/$HOUR"
# aws s3 cp ./objdir-classic/dist/install/sea/waterfox-*.en-US.win64.installer.exe s3://waterfox/builds/windows/classic/"$DATE"/
