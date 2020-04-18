#!/usr/bin/env sh

abs() {
    local rel
    local p
    if [ $# -ne 1 ]
    then
        rel=.
    else
        rel=$1
    fi
    if [ -d $rel ]
    then
        pushd $rel > /dev/null
        p=`pwd`
        popd > /dev/null
    else
        pushd `dirname $rel` > /dev/null
        p=`pwd`/`basename $rel`
        popd > /dev/null
    fi
    echo $p
}
