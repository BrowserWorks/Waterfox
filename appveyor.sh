set -ex

cd /c/Builds/waterfox
git config core.autocrlf false
git config core.eof lf
git rm --cached -r .
git reset --hard

./mach -v build
./mach -v build installer

# YEAR=$(date +%Y)
# MONTH=$(date +%m)
# DAY=$(date +%-e) # single digit, no leading zeros or spaces
# HOUR=$(date +%H)
# DATE="$YEAR/$MONTH/$DAY/$HOUR"
# aws s3 cp ./objdir-classic/dist/install/sea/waterfox-*.en-US.win64.installer.exe s3://waterfox/builds/windows/classic/"$DATE"/
