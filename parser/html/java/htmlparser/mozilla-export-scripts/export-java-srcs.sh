#!/usr/bin/env sh

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/util.sh
SCRIPT_DIR=`abs $SCRIPT_DIR`

SRCDIR=`abs $SCRIPT_DIR/../src/nu/validator/htmlparser/impl`

if [ $# -eq 1 ]
then
    MOZ_PARSER_PATH=`abs $1`
else
    echo
    echo "Usage: sh `basename $0` /path/to/mozilla-central/parser/html"
    echo "Note that relative paths will work just fine."
    echo
    exit 1
fi

SRCTARGET=$MOZ_PARSER_PATH/javasrc

rm -rf $SRCTARGET
mkdir $SRCTARGET
# Avoid copying the .svn directory:
cp -rv $SRCDIR/*.java $SRCTARGET
