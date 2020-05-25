#!/usr/bin/env sh

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/util.sh
SCRIPT_DIR=`abs $SCRIPT_DIR`

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

$SCRIPT_DIR/export-translator.sh $MOZ_PARSER_PATH
$SCRIPT_DIR/export-java-srcs.sh  $MOZ_PARSER_PATH

echo
echo "Now go to $MOZ_PARSER_PATH and run"
echo "  java -jar javalib/translator.jar javasrc . nsHtml5AtomList.h"
echo
