#!/bin/sh
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

# Update to an ICU release:
#   Usage: update-icu.sh <URL of ICU GIT> <release tag name>
#   E.g., for ICU 62.1: update-icu.sh https://github.com/unicode-org/icu.git release-62-1
#
# Update to an ICU maintenance branch:
#   Usage: update-icu.sh <URL of ICU GIT> <maintenance name>
#   E.g., for ICU 62.1: update-icu.sh https://github.com/unicode-org/icu.git maint/maint-62

if [ $# -lt 2 ]; then
    echo "Usage: update-icu.sh <URL of ICU GIT> <release tag name>"
    exit 1
fi

# Ensure that $Date$ in the checked-out git files expands timezone-agnostically,
# so that this script's behavior is consistent when run from any time zone.
export TZ=UTC

# Also ensure GIT-INFO is consistently English.
export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8

icu_dir=`dirname $0`/icu

# Remove intl/icu/source, then replace it with a clean export.
rm -rf ${icu_dir}/source
tmpclonedir=$(mktemp -d)
git clone --depth 1 --branch $2 $1 ${tmpclonedir}
cp -r ${tmpclonedir}/icu4c/source ${icu_dir}/source

# Record `git log`.
# (This ensures that if ICU modifications are performed properly, it's always
# possible to run the command at the top of this script and make no changes to
# the tree.)
git -C ${tmpclonedir} log -1 > ${icu_dir}/GIT-INFO

# Clean up after ourselves.
rm -rf ${tmpclonedir}

# remove layoutex, tests, and samples, but leave makefiles in place
find ${icu_dir}/source/layoutex -name '*Makefile.in' -prune -or -type f -print | xargs rm
find ${icu_dir}/source/test -name '*Makefile.in' -prune -or -type f -print | xargs rm
find ${icu_dir}/source/samples -name '*Makefile.in' -prune -or -type f -print | xargs rm

# remove data that we currently don't need
rm -rf ${icu_dir}/source/data/brkitr/*
rm ${icu_dir}/source/data/lang/*.mk
rm ${icu_dir}/source/data/lang/*.txt
rm ${icu_dir}/source/data/mappings/*.mk
find ${icu_dir}/source/data/mappings \
    -name ibm-37_P100-1995.ucm -prune -or \
    -name ibm-1047_P100-1995.ucm -prune -or \
    -name '*.ucm' -print | xargs rm
rm ${icu_dir}/source/data/rbnf/*
rm ${icu_dir}/source/data/region/*.mk
rm ${icu_dir}/source/data/region/*.txt
rm ${icu_dir}/source/data/translit/*
rm ${icu_dir}/source/data/unit/*.mk
rm ${icu_dir}/source/data/unit/*.txt
# bug 1225401 and bug1345336 to remove unused zone name
find ${icu_dir}/source/data/zone \
    -name root.txt -prune -or \
    -name tzdbNames.txt -prune -or \
    -name '*.txt' -print | xargs sed -i '/^\s\{8\}\"[A-Z]/, /^\s\{8\}}/ { d }'
find ${icu_dir}/source/data/zone \
    -name root.txt -prune -or \
    -name tzdbNames.txt -prune -or \
    -name '*.txt' -print | xargs sed -i '/^\s\{4\}zoneStrings{/{N; s/^\s\{4\}zoneStrings{\n\s\{4\}}// }; /^$/d'

for patch in \
 bug-915735 \
 suppress-warnings.diff \
 bug-1172609-timezone-recreateDefault.diff \
 bug-1198952-workaround-make-3.82-bug.diff \
 u_setMemoryFunctions-callconvention-anachronism-msvc.diff \
 bug-1373763-convertToPosix-stack-value-out-of-scope.diff \
 bug-1380083 \
 glibc_2.26.patch \
; do
  echo "Applying local patch $patch"
  patch -d ${icu_dir}/../../ -p1 --no-backup-if-mismatch < ${icu_dir}/../icu-patches/$patch
done

topsrcdir=`dirname $0`/../
python2 ${topsrcdir}/js/src/tests/ecma_6/String/make-normalize-generateddata-input.py $topsrcdir

# Update our moz.build files in config/external/icu, and
# build a new ICU data file.
python2 `dirname $0`/icu_sources_data.py $topsrcdir

#hg addremove "${icu_dir}/source" "${icu_dir}/SVN-INFO" ${topsrcdir}/config/external/icu

# Check local tzdata version.
`dirname $0`/update-tzdata.sh -c
