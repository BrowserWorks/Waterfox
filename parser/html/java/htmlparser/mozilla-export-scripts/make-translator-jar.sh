#!/usr/bin/env sh

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/util.sh
SCRIPT_DIR=`abs $SCRIPT_DIR`

SRCDIR=`abs $SCRIPT_DIR/../translator-src`
BINDIR=`abs $SCRIPT_DIR/../translator-bin`
LIBDIR=`abs $SCRIPT_DIR/../translator-lib`

if [ $# -eq 1 ]
then
    JAVAPARSER_JAR_PATH=`abs $1`
else
    echo
    echo "Usage: sh `basename $0` /path/to/javaparser-1.0.7.jar"
    echo "Note that relative paths will work just fine."
    echo "Obtain javaparser-1.0.7.jar from http://code.google.com/p/javaparser"
    echo
    exit 1
fi

set_up() {
    rm -rf $BINDIR; mkdir $BINDIR
    rm -rf $LIBDIR; mkdir $LIBDIR
    cp $JAVAPARSER_JAR_PATH $LIBDIR/javaparser.jar
}

write_manifest() {
    rm -f $LIBDIR/manifest
    echo "Main-Class: nu.validator.htmlparser.cpptranslate.Main" > $LIBDIR/manifest
    echo "Class-Path: javaparser.jar" >> $LIBDIR/manifest
}

compile_translator() {
    find $SRCDIR -name "*.java" | \
        xargs javac -cp $LIBDIR/javaparser.jar -g -d $BINDIR
}

generate_jar() {
    jar cvfm $LIBDIR/translator.jar $LIBDIR/manifest -C $BINDIR .
}

clean_up() {
    rm -f $LIBDIR/manifest
}

success_message() {
    echo
    echo "Successfully generated directory \"$LIBDIR\" with contents:"
    echo
    ls -al $LIBDIR
    echo
    echo "Now run `dirname $0`/export-all.sh with no arguments and follow the usage instructions."
    echo
}

set_up && \
    compile_translator && \
    write_manifest && \
    generate_jar && \
    clean_up && \
    success_message
