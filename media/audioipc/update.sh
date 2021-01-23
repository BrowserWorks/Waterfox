# Usage: sh update.sh <upstream_src_directory>
set -e

cp -p $1/README.md .
cp -p $1/Cargo.toml .

for crate in audioipc client server; do
    rm -fr $crate
    mkdir $crate
    cp -pr $1/$crate/Cargo.toml $crate
    [ -e $1/$crate/cbindgen.toml ] && cp -pr $1/$crate/cbindgen.toml $crate
    cp -pr $1/$crate/src $crate
done

rm -f audioipc/src/cmsghdr.c

if [ -d $1/.git ]; then
  rev=$(cd $1 && git rev-parse --verify HEAD)
  date=$(cd $1 && git show -s --format=%ci HEAD)
  dirty=$(cd $1 && git diff-index --name-only HEAD)
fi

if [ -n "$rev" ]; then
  version=$rev
  if [ -n "$dirty" ]; then
    version=$version-dirty
    echo "WARNING: updating from a dirty git repository."
  fi
  sed -i.bak -e "/The git commit ID used was/ s/[0-9a-f]\{40\}\(-dirty\)\{0,1\} .\{1,100\}/$version ($date)/" README_MOZILLA
  rm -f README_MOZILLA.bak
else
  echo "Remember to update README_MOZILLA with the version details."
fi

echo "Applying gecko.patch on top of $rev"
patch -p3 < gecko.patch

