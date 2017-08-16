#!/usr/bin/env perl
## Copyright (c) 2016, Alliance for Open Media. All rights reserved
##
## This source code is subject to the terms of the BSD 2 Clause License and
## the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
## was not distributed with this source code in the LICENSE file, you can
## obtain it at www.aomedia.org/license/software. If the Alliance for Open
## Media Patent License 1.0 was not distributed with this source code in the
## PATENTS file, you can obtain it at www.aomedia.org/license/patent.
##


# ads2gas_apple.pl
# Author: Eric Fung (efung (at) acm.org)
#
# Convert ARM Developer Suite 1.0.1 syntax assembly source to GNU as format
#
# Usage: cat inputfile | perl ads2gas_apple.pl > outputfile
#

my $chromium = 0;

foreach my $arg (@ARGV) {
    $chromium = 1 if ($arg eq "-chromium");
}

print "@ This file was created from a .asm file\n";
print "@  using the ads2gas_apple.pl script.\n\n";
print "\t.set WIDE_REFERENCE, 0\n";
print "\t.set ARCHITECTURE, 5\n";
print "\t.set DO1STROUNDING, 0\n";

my %register_aliases;
my %macro_aliases;

my @mapping_list = ("\$0", "\$1", "\$2", "\$3", "\$4", "\$5", "\$6", "\$7", "\$8", "\$9");

my @incoming_array;

my @imported_functions;

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

while (<STDIN>)
{
    # Load and store alignment
    s/@/,:/g;

    # Comment character
    s/;/ @/g;

    # Hexadecimal constants prefaced by 0x
    s/#&/#0x/g;

    # Convert :OR: to |
    s/:OR:/ | /g;

    # Convert :AND: to &
    s/:AND:/ & /g;

    # Convert :NOT: to ~
    s/:NOT:/ ~ /g;

    # Convert :SHL: to <<
    s/:SHL:/ << /g;

    # Convert :SHR: to >>
    s/:SHR:/ >> /g;

    # Convert ELSE to .else
    s/\bELSE\b/.else/g;

    # Convert ENDIF to .endif
    s/\bENDIF\b/.endif/g;

    # Convert ELSEIF to .elseif
    s/\bELSEIF\b/.elseif/g;

    # Convert LTORG to .ltorg
    s/\bLTORG\b/.ltorg/g;

    # Convert IF :DEF:to .if
    # gcc doesn't have the ability to do a conditional
    # if defined variable that is set by IF :DEF: on
    # armasm, so convert it to a normal .if and then
    # make sure to define a value elesewhere
    if (s/\bIF :DEF:\b/.if /g)
    {
        s/=/==/g;
    }

    # Convert IF to .if
    if (s/\bIF\b/.if/g)
    {
        s/=/==/g;
    }

    # Convert INCLUDE to .INCLUDE "file"
    s/INCLUDE(\s*)(.*)$/.include $1\"$2\"/;

    # Code directive (ARM vs Thumb)
    s/CODE([0-9][0-9])/.code $1/;

    # No AREA required
    # But ALIGNs in AREA must be obeyed
    s/^\s*AREA.*ALIGN=([0-9])$/.text\n.p2align $1/;
    # If no ALIGN, strip the AREA and align to 4 bytes
    s/^\s*AREA.*$/.text\n.p2align 2/;

    # DCD to .word
    # This one is for incoming symbols
    s/DCD\s+\|(\w*)\|/.long $1/;

    # DCW to .short
    s/DCW\s+\|(\w*)\|/.short $1/;
    s/DCW(.*)/.short $1/;

    # Constants defined in scope
    s/DCD(.*)/.long $1/;
    s/DCB(.*)/.byte $1/;

    # Build a hash of all the register - alias pairs.
    if (s/(.*)RN(.*)/$1 .req $2/g)
    {
        $register_aliases{trim($1)} = trim($2);
        next;
    }

    while (($key, $value) = each(%register_aliases))
    {
        s/\b$key\b/$value/g;
    }

    # Make function visible to linker, and make additional symbol with
    # prepended underscore
    s/EXPORT\s+\|([\$\w]*)\|/.globl _$1\n\t.globl $1/;

    # Prepend imported functions with _
    if (s/IMPORT\s+\|([\$\w]*)\|/.globl $1/)
    {
        $function = trim($1);
        push(@imported_functions, $function);
    }

    foreach $function (@imported_functions)
    {
        s/$function/_$function/;
    }

    # No vertical bars required; make additional symbol with prepended
    # underscore
    s/^\|(\$?\w+)\|/_$1\n\t$1:/g;

    # Labels need trailing colon
#   s/^(\w+)/$1:/ if !/EQU/;
    # put the colon at the end of the line in the macro
    s/^([a-zA-Z_0-9\$]+)/$1:/ if !/EQU/;

    # ALIGN directive
    s/\bALIGN\b/.balign/g;

    # Strip ARM
    s/\sARM/@ ARM/g;

    # Strip REQUIRE8
    #s/\sREQUIRE8/@ REQUIRE8/g;
    s/\sREQUIRE8/@ /g;

    # Strip PRESERVE8
    s/\sPRESERVE8/@ PRESERVE8/g;

    # Strip PROC and ENDPROC
    s/\bPROC\b/@/g;
    s/\bENDP\b/@/g;

    # EQU directive
    s/(.*)EQU(.*)/.set $1, $2/;

    # Begin macro definition
    if (/\bMACRO\b/)
    {
        # Process next line down, which will be the macro definition
        $_ = <STDIN>;

        $trimmed = trim($_);

        # remove commas that are separating list
        $trimmed =~ s/,//g;

        # string to array
        @incoming_array = split(/\s+/, $trimmed);

        print ".macro @incoming_array[0]\n";

        # remove the first element, as that is the name of the macro
        shift (@incoming_array);

        @macro_aliases{@incoming_array} = @mapping_list;

        next;
    }

    while (($key, $value) = each(%macro_aliases))
    {
        $key =~ s/\$/\\\$/;
        s/$key\b/$value/g;
    }

    # For macros, use \ to reference formal params
#   s/\$/\\/g;                  # End macro definition
    s/\bMEND\b/.endm/;              # No need to tell it where to stop assembling
    next if /^\s*END\s*$/;

    # Clang used by Chromium differs slightly from clang in XCode in what it
    # will accept in the assembly.
    if ($chromium) {
        s/qsubaddx/qsax/i;
        s/qaddsubx/qasx/i;
        s/ldrneb/ldrbne/i;
        s/ldrneh/ldrhne/i;
        s/(vqshrun\.s16 .*, \#)0$/${1}8/i;

        # http://llvm.org/bugs/show_bug.cgi?id=16022
        s/\.include/#include/;
    }

    print;
}
