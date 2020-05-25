#!/usr/bin/env sh

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/util.sh
SCRIPT_DIR=`abs $SCRIPT_DIR`

LIBDIR=`abs $SCRIPT_DIR/../translator-lib`

if [ $# -eq 1 ]
then
    MOZ_PARSER_PATH=`abs $1`
else
    echo
    echo "Usage: sh `basename $0` /path/to/mozilla-central/parser/html"
    echo "Note that relative paths will work just fine."
    echo "Be sure that you have run `dirname $0`/make-translator-jar.sh before running this script."
    echo
    exit 1
fi

LIBTARGET=$MOZ_PARSER_PATH/javalib

rm -rf $LIBTARGET
cp -rv $LIBDIR $LIBTARGET
