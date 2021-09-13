cd "$GITHUB_WORKSPACE" || exit
./mach package
mkdir ./dist/
mv ./objdir-*/dist/waterfox*.zip ./dist/
