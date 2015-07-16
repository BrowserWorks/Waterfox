# Pod::Man -- Convert POD data to formatted *roff input.
# $Id: Man.pm,v 1.37 2003/03/30 22:34:11 eagle Exp $
#
# Copyright 1999, 2000, 2001, 2002, 2003 by Russ Allbery <rra@stanford.edu>
#
# This program is free software; you may redistribute it and/or modify it
# under the same terms as Perl itself.
#
# This module translates POD documentation into *roff markup using the man
# macro set, and is intended for converting POD documents written as Unix
# manual pages to manual pages that can be read by the man(1) command.  It is
# a replacement for the pod2man command distributed with versions of Perl
# prior to 5.6.
#
# Perl core hackers, please note that this module is also separately
# maintained outside of the Perl core as part of the podlators.  Please send
# me any patches at the address above in addition to sending them to the
# standard Perl mailing lists.

##############################################################################
# Modules and declarations
##############################################################################

package Pod::Man;

require 5.005;

use Carp qw(carp croak);
use Pod::ParseLink qw(parselink);
use Pod::Parser ();

use strict;
use subs qw(makespace);
use vars qw(@ISA %ESCAPES $PREAMBLE $VERSION);

@ISA = qw(Pod::Parser);

# Don't use the CVS revision as the version, since this module is also in Perl
# core and too many things could munge CVS magic revision strings.  This
# number should ideally be the same as the CVS revision in podlators, however.
$VERSION = 1.37;


##############################################################################
# Preamble and *roff output tables
##############################################################################

# The following is the static preamble which starts all *roff output we
# generate.  It's completely static except for the font to use as a
# fixed-width font, which is designed by @CFONT@, and the left and right
# quotes to use for C<> text, designated by @LQOUTE@ and @RQUOTE@.  $PREAMBLE
# should therefore be run through s/\@CFONT\@/<font>/g before output.
$PREAMBLE = <<'----END OF PREAMBLE----';
.de Sh \" Subsection heading
.br
.if t .Sp
.ne 5
.PP
\fB\\$1\fR
.PP
..
.de Sp \" Vertical space (when we can't use .PP)
.if t .sp .5v
.if n .sp
..
.de Vb \" Begin verbatim text
.ft @CFONT@
.nf
.ne \\$1
..
.de Ve \" End verbatim text
.ft R
.fi
..
.\" Set up some character translations and predefined strings.  \*(-- will
.\" give an unbreakable dash, \*(PI will give pi, \*(L" will give a left
.\" double quote, and \*(R" will give a right double quote.  | will give a
.\" real vertical bar.  \*(C+ will give a nicer C++.  Capital omega is used to
.\" do unbreakable dashes and therefore won't be available.  \*(C` and \*(C'
.\" expand to `' in nroff, nothing in troff, for use with C<>.
.tr \(*W-|\(bv\*(Tr
.ds C+ C\v'-.1v'\h'-1p'\s-2+\h'-1p'+\s0\v'.1v'\h'-1p'
.ie n \{\
.    ds -- \(*W-
.    ds PI pi
.    if (\n(.H=4u)&(1m=24u) .ds -- \(*W\h'-12u'\(*W\h'-12u'-\" diablo 10 pitch
.    if (\n(.H=4u)&(1m=20u) .ds -- \(*W\h'-12u'\(*W\h'-8u'-\"  diablo 12 pitch
.    ds L" ""
.    ds R" ""
.    ds C` @LQUOTE@
.    ds C' @RQUOTE@
'br\}
.el\{\
.    ds -- \|\(em\|
.    ds PI \(*p
.    ds L" ``
.    ds R" ''
'br\}
.\"
.\" If the F register is turned on, we'll generate index entries on stderr for
.\" titles (.TH), headers (.SH), subsections (.Sh), items (.Ip), and index
.\" entries marked with X<> in POD.  Of course, you'll have to process the
.\" output yourself in some meaningful fashion.
.if \nF \{\
.    de IX
.    tm Index:\\$1\t\\n%\t"\\$2"
..
.    nr % 0
.    rr F
.\}
.\"
.\" For nroff, turn off justification.  Always turn off hyphenation; it makes
.\" way too many mistakes in technical documents.
.hy 0
.if n .na
.\"
.\" Accent mark definitions (@(#)ms.acc 1.5 88/02/08 SMI; from UCB 4.2).
.\" Fear.  Run.  Save yourself.  No user-serviceable parts.
.    \" fudge factors for nroff and troff
.if n \{\
.    ds #H 0
.    ds #V .8m
.    ds #F .3m
.    ds #[ \f1
.    ds #] \fP
.\}
.if t \{\
.    ds #H ((1u-(\\\\n(.fu%2u))*.13m)
.    ds #V .6m
.    ds #F 0
.    ds #[ \&
.    ds #] \&
.\}
.    \" simple accents for nroff and troff
.if n \{\
.    ds ' \&
.    ds ` \&
.    ds ^ \&
.    ds , \&
.    ds ~ ~
.    ds /
.\}
.if t \{\
.    ds ' \\k:\h'-(\\n(.wu*8/10-\*(#H)'\'\h"|\\n:u"
.    ds ` \\k:\h'-(\\n(.wu*8/10-\*(#H)'\`\h'|\\n:u'
.    ds ^ \\k:\h'-(\\n(.wu*10/11-\*(#H)'^\h'|\\n:u'
.    ds , \\k:\h'-(\\n(.wu*8/10)',\h'|\\n:u'
.    ds ~ \\k:\h'-(\\n(.wu-\*(#H-.1m)'~\h'|\\n:u'
.    ds / \\k:\h'-(\\n(.wu*8/10-\*(#H)'\z\(sl\h'|\\n:u'
.\}
.    \" troff and (daisy-wheel) nroff accents
.ds : \\k:\h'-(\\n(.wu*8/10-\*(#H+.1m+\*(#F)'\v'-\*(#V'\z.\h'.2m+\*(#F'.\h'|\\n:u'\v'\*(#V'
.ds 8 \h'\*(#H'\(*b\h'-\*(#H'
.ds o \\k:\h'-(\\n(.wu+\w'\(de'u-\*(#H)/2u'\v'-.3n'\*(#[\z\(de\v'.3n'\h'|\\n:u'\*(#]
.ds d- \h'\*(#H'\(pd\h'-\w'~'u'\v'-.25m'\f2\(hy\fP\v'.25m'\h'-\*(#H'
.ds D- D\\k:\h'-\w'D'u'\v'-.11m'\z\(hy\v'.11m'\h'|\\n:u'
.ds th \*(#[\v'.3m'\s+1I\s-1\v'-.3m'\h'-(\w'I'u*2/3)'\s-1o\s+1\*(#]
.ds Th \*(#[\s+2I\s-2\h'-\w'I'u*3/5'\v'-.3m'o\v'.3m'\*(#]
.ds ae a\h'-(\w'a'u*4/10)'e
.ds Ae A\h'-(\w'A'u*4/10)'E
.    \" corrections for vroff
.if v .ds ~ \\k:\h'-(\\n(.wu*9/10-\*(#H)'\s-2\u~\d\s+2\h'|\\n:u'
.if v .ds ^ \\k:\h'-(\\n(.wu*10/11-\*(#H)'\v'-.4m'^\v'.4m'\h'|\\n:u'
.    \" for low resolution devices (crt and lpr)
.if \n(.H>23 .if \n(.V>19 \
\{\
.    ds : e
.    ds 8 ss
.    ds o a
.    ds d- d\h'-1'\(ga
.    ds D- D\h'-1'\(hy
.    ds th \o'bp'
.    ds Th \o'LP'
.    ds ae ae
.    ds Ae AE
.\}
.rm #[ #] #H #V #F C
----END OF PREAMBLE----
#`# for cperl-mode

# This table is taken nearly verbatim from Tom Christiansen's pod2man.  It
# assumes that the standard preamble has already been printed, since that's
# what defines all of the accent marks.  Note that some of these are quoted
# with double quotes since they contain embedded single quotes, so use \\
# uniformly for backslash for readability.
%ESCAPES = (
    'amp'       =>    '&',      # ampersand
    'apos'      =>    "'",      # apostrophe
    'lt'        =>    '<',      # left chevron, less-than
    'gt'        =>    '>',      # right chevron, greater-than
    'quot'      =>    '"',      # double quote
    'sol'       =>    '/',      # solidus (forward slash)
    'verbar'    =>    '|',      # vertical bar

    'Aacute'    =>    "A\\*'",  # capital A, acute accent
    'aacute'    =>    "a\\*'",  # small a, acute accent
    'Acirc'     =>    'A\\*^',  # capital A, circumflex accent
    'acirc'     =>    'a\\*^',  # small a, circumflex accent
    'AElig'     =>    '\*(AE',  # capital AE diphthong (ligature)
    'aelig'     =>    '\*(ae',  # small ae diphthong (ligature)
    'Agrave'    =>    "A\\*`",  # capital A, grave accent
    'agrave'    =>    "A\\*`",  # small a, grave accent
    'Aring'     =>    'A\\*o',  # capital A, ring
    'aring'     =>    'a\\*o',  # small a, ring
    'Atilde'    =>    'A\\*~',  # capital A, tilde
    'atilde'    =>    'a\\*~',  # small a, tilde
    'Auml'      =>    'A\\*:',  # capital A, dieresis or umlaut mark
    'auml'      =>    'a\\*:',  # small a, dieresis or umlaut mark
    'Ccedil'    =>    'C\\*,',  # capital C, cedilla
    'ccedil'    =>    'c\\*,',  # small c, cedilla
    'Eacute'    =>    "E\\*'",  # capital E, acute accent
    'eacute'    =>    "e\\*'",  # small e, acute accent
    'Ecirc'     =>    'E\\*^',  # capital E, circumflex accent
    'ecirc'     =>    'e\\*^',  # small e, circumflex accent
    'Egrave'    =>    'E\\*`',  # capital E, grave accent
    'egrave'    =>    'e\\*`',  # small e, grave accent
    'ETH'       =>    '\\*(D-', # capital Eth, Icelandic
    'eth'       =>    '\\*(d-', # small eth, Icelandic
    'Euml'      =>    'E\\*:',  # capital E, dieresis or umlaut mark
    'euml'      =>    'e\\*:',  # small e, dieresis or umlaut mark
    'Iacute'    =>    "I\\*'",  # capital I, acute accent
    'iacute'    =>    "i\\*'",  # small i, acute accent
    'Icirc'     =>    'I\\*^',  # capital I, circumflex accent
    'icirc'     =>    'i\\*^',  # small i, circumflex accent
    'Igrave'    =>    'I\\*`',  # capital I, grave accent
    'igrave'    =>    'i\\*`',  # small i, grave accent
    'Iuml'      =>    'I\\*:',  # capital I, dieresis or umlaut mark
    'iuml'      =>    'i\\*:',  # small i, dieresis or umlaut mark
    'Ntilde'    =>    'N\*~',   # capital N, tilde
    'ntilde'    =>    'n\*~',   # small n, tilde
    'Oacute'    =>    "O\\*'",  # capital O, acute accent
    'oacute'    =>    "o\\*'",  # small o, acute accent
    'Ocirc'     =>    'O\\*^',  # capital O, circumflex accent
    'ocirc'     =>    'o\\*^',  # small o, circumflex accent
    'Ograve'    =>    'O\\*`',  # capital O, grave accent
    'ograve'    =>    'o\\*`',  # small o, grave accent
    'Oslash'    =>    'O\\*/',  # capital O, slash
    'oslash'    =>    'o\\*/',  # small o, slash
    'Otilde'    =>    'O\\*~',  # capital O, tilde
    'otilde'    =>    'o\\*~',  # small o, tilde
    'Ouml'      =>    'O\\*:',  # capital O, dieresis or umlaut mark
    'ouml'      =>    'o\\*:',  # small o, dieresis or umlaut mark
    'szlig'     =>    '\*8',    # small sharp s, German (sz ligature)
    'THORN'     =>    '\\*(Th', # capital THORN, Icelandic
    'thorn'     =>    '\\*(th', # small thorn, Icelandic
    'Uacute'    =>    "U\\*'",  # capital U, acute accent
    'uacute'    =>    "u\\*'",  # small u, acute accent
    'Ucirc'     =>    'U\\*^',  # capital U, circumflex accent
    'ucirc'     =>    'u\\*^',  # small u, circumflex accent
    'Ugrave'    =>    'U\\*`',  # capital U, grave accent
    'ugrave'    =>    'u\\*`',  # small u, grave accent
    'Uuml'      =>    'U\\*:',  # capital U, dieresis or umlaut mark
    'uuml'      =>    'u\\*:',  # small u, dieresis or umlaut mark
    'Yacute'    =>    "Y\\*'",  # capital Y, acute accent
    'yacute'    =>    "y\\*'",  # small y, acute accent
    'yuml'      =>    'y\\*:',  # small y, dieresis or umlaut mark

    'nbsp'      =>    '\\ ',    # non-breaking space
    'shy'       =>    '',       # soft (discretionary) hyphen
);


##############################################################################
# Static helper functions
##############################################################################

# Protect leading quotes and periods against interpretation as commands.  Also
# protect anything starting with a backslash, since it could expand or hide
# something that *roff would interpret as a command.  This is overkill, but
# it's much simpler than trying to parse *roff here.
sub protect {
    local $_ = shift;
    s/^([.\'\\])/\\&$1/mg;
    $_;
}

# Translate a font string into an escape.
sub toescape { (length ($_[0]) > 1 ? '\f(' : '\f') . $_[0] }


##############################################################################
# Initialization
##############################################################################

# Initialize the object.  Here, we also process any additional options passed
# to the constructor or set up defaults if none were given.  center is the
# centered title, release is the version number, and date is the date for the
# documentation.  Note that we can't know what file name we're processing due
# to the architecture of Pod::Parser, so that *has* to either be passed to the
# constructor or set separately with Pod::Man::name().
sub initialize {
    my $self = shift;

    # Figure out the fixed-width font.  If user-supplied, make sure that they
    # are the right length.
    for (qw/fixed fixedbold fixeditalic fixedbolditalic/) {
        if (defined $$self{$_}) {
            if (length ($$self{$_}) < 1 || length ($$self{$_}) > 2) {
                croak qq(roff font should be 1 or 2 chars,)
                    . qq( not "$$self{$_}");
            }
        } else {
            $$self{$_} = '';
        }
    }

    # Set the default fonts.  We can't be sure what fixed bold-italic is going
    # to be called, so default to just bold.
    $$self{fixed}           ||= 'CW';
    $$self{fixedbold}       ||= 'CB';
    $$self{fixeditalic}     ||= 'CI';
    $$self{fixedbolditalic} ||= 'CB';

    # Set up a table of font escapes.  First number is fixed-width, second is
    # bold, third is italic.
    $$self{FONTS} = { '000' => '\fR', '001' => '\fI',
                      '010' => '\fB', '011' => '\f(BI',
                      '100' => toescape ($$self{fixed}),
                      '101' => toescape ($$self{fixeditalic}),
                      '110' => toescape ($$self{fixedbold}),
                      '111' => toescape ($$self{fixedbolditalic})};

    # Extra stuff for page titles.
    $$self{center} = 'User Contributed Perl Documentation'
        unless defined $$self{center};
    $$self{indent} = 4 unless defined $$self{indent};

    # We used to try first to get the version number from a local binary, but
    # we shouldn't need that any more.  Get the version from the running Perl.
    # Work a little magic to handle subversions correctly under both the
    # pre-5.6 and the post-5.6 version numbering schemes.
    if (!defined $$self{release}) {
        my @version = ($] =~ /^(\d+)\.(\d{3})(\d{0,3})$/);
        $version[2] ||= 0;
        $version[2] *= 10 ** (3 - length $version[2]);
        for (@version) { $_ += 0 }
        $$self{release} = 'perl v' . join ('.', @version);
    }

    # Double quotes in things that will be quoted.
    for (qw/center date release/) {
        $$self{$_} =~ s/\"/\"\"/g if $$self{$_};
    }

    # Figure out what quotes we'll be using for C<> text.
    $$self{quotes} ||= '"';
    if ($$self{quotes} eq 'none') {
        $$self{LQUOTE} = $$self{RQUOTE} = '';
    } elsif (length ($$self{quotes}) == 1) {
        $$self{LQUOTE} = $$self{RQUOTE} = $$self{quotes};
    } elsif ($$self{quotes} =~ /^(.)(.)$/
             || $$self{quotes} =~ /^(..)(..)$/) {
        $$self{LQUOTE} = $1;
        $$self{RQUOTE} = $2;
    } else {
        croak qq(Invalid quote specification "$$self{quotes}");
    }

    # Double the first quote; note that this should not be s///g as two double
    # quotes is represented in *roff as three double quotes, not four.  Weird,
    # I know.
    $$self{LQUOTE} =~ s/\"/\"\"/;
    $$self{RQUOTE} =~ s/\"/\"\"/;

    $self->SUPER::initialize;
}

# For each document we process, output the preamble first.
sub begin_pod {
    my $self = shift;

    # Try to figure out the name and section from the file name.
    my $section = $$self{section} || 1;
    my $name = $$self{name};
    if (!defined $name) {
        $name = $self->input_file;
        $section = 3 if (!$$self{section} && $name =~ /\.pm\z/i);
        $name =~ s/\.p(od|[lm])\z//i;
        if ($section !~ /^3/) {
            require File::Basename;
            $name = uc File::Basename::basename ($name);
        } else {
            # Assume that we're dealing with a module.  We want to figure out
            # the full module name from the path to the file, but we don't
            # want to include too much of the path into the module name.  Lose
            # everything up to the first of:
            #
            #     */lib/*perl*/         standard or site_perl module
            #     */*perl*/lib/         from -Dprefix=/opt/perl
            #     */*perl*/             random module hierarchy
            #
            # which works.  Also strip off a leading site or site_perl
            # component, any OS-specific component, and any version number
            # component, and strip off an initial component of "lib" or
            # "blib/lib" since that's what ExtUtils::MakeMaker creates.
            # splitdir requires at least File::Spec 0.8.
            require File::Spec;
            my ($volume, $dirs, $file) = File::Spec->splitpath ($name);
            my @dirs = File::Spec->splitdir ($dirs);
            my $cut = 0;
            my $i;
            for ($i = 0; $i < scalar @dirs; $i++) {
                if ($dirs[$i] eq 'lib' && $dirs[$i + 1] =~ /perl/) {
                    $cut = $i + 2;
                    last;
                } elsif ($dirs[$i] =~ /perl/) {
                    $cut = $i + 1;
                    $cut++ if $dirs[$i + 1] eq 'lib';
                    last;
                }
            }
            if ($cut > 0) {
                splice (@dirs, 0, $cut);
                shift @dirs if ($dirs[0] =~ /^site(_perl)?$/);
                shift @dirs if ($dirs[0] =~ /^[\d.]+$/);
                shift @dirs if ($dirs[0] =~ /^(.*-$^O|$^O-.*|$^O)$/);
            }
            shift @dirs if $dirs[0] eq 'lib';
            splice (@dirs, 0, 2) if ($dirs[0] eq 'blib' && $dirs[1] eq 'lib');

            # Remove empty directories when building the module name; they
            # occur too easily on Unix by doubling slashes.
            $name = join ('::', (grep { $_ ? $_ : () } @dirs), $file);
        }
    }

    # If $name contains spaces, quote it; this mostly comes up in the case of
    # input from stdin.
    $name = '"' . $name . '"' if ($name =~ /\s/);

    # Modification date header.  Try to use the modification time of our
    # input.
    if (!defined $$self{date}) {
        my $time = (stat $self->input_file)[9] || time;
        my ($day, $month, $year) = (localtime $time)[3,4,5];
        $month++;
        $year += 1900;
        $$self{date} = sprintf ('%4d-%02d-%02d', $year, $month, $day);
    }

    # Now, print out the preamble and the title.  The meaning of the arguments
    # to .TH unfortunately vary by system; some systems consider the fourth
    # argument to be a "source" and others use it as a version number.
    # Generally it's just presented as the left-side footer, though, so it
    # doesn't matter too much if a particular system gives it another
    # interpretation.
    #
    # The order of date and release used to be reversed in older versions of
    # this module, but this order is correct for both Solaris and Linux.
    local $_ = $PREAMBLE;
    s/\@CFONT\@/$$self{fixed}/;
    s/\@LQUOTE\@/$$self{LQUOTE}/;
    s/\@RQUOTE\@/$$self{RQUOTE}/;
    chomp $_;
    my $pversion = $Pod::Parser::VERSION;
    print { $self->output_handle } <<"----END OF HEADER----";
.\\" Automatically generated by Pod::Man v$VERSION, Pod::Parser v$pversion
.\\"
.\\" Standard preamble:
.\\" ========================================================================
$_
.\\" ========================================================================
.\\"
.IX Title "$name $section"
.TH $name $section "$$self{date}" "$$self{release}" "$$self{center}"
----END OF HEADER----

    # Initialize a few per-file variables.
    $$self{INDENT}    = 0;      # Current indentation level.
    $$self{INDENTS}   = [];     # Stack of indentations.
    $$self{INDEX}     = [];     # Index keys waiting to be printed.
    $$self{IN_NAME}   = 0;      # Whether processing the NAME section.
    $$self{ITEMS}     = 0;      # The number of consecutive =items.
    $$self{ITEMTYPES} = [];     # Stack of =item types, one per list.
    $$self{SHIFTWAIT} = 0;      # Whether there is a shift waiting.
    $$self{SHIFTS}    = [];     # Stack of .RS shifts.
}


##############################################################################
# Core overrides
##############################################################################

# Called for each command paragraph.  Gets the command, the associated
# paragraph, the line number, and a Pod::Paragraph object.  Just dispatches
# the command to a method named the same as the command.  =cut is handled
# internally by Pod::Parser.
sub command {
    my $self = shift;
    my $command = shift;
    return if $command eq 'pod';
    return if ($$self{EXCLUDE} && $command ne 'end');
    if ($self->can ('cmd_' . $command)) {
        $command = 'cmd_' . $command;
        $self->$command (@_);
    } else {
        my ($text, $line, $paragraph) = @_;
        my $file;
        ($file, $line) = $paragraph->file_line;
        $text =~ s/\n+\z//;
        $text = " $text" if ($text =~ /^\S/);
        warn qq($file:$line: Unknown command paragraph "=$command$text"\n);
        return;
    }
}

# Called for a verbatim paragraph.  Gets the paragraph, the line number, and a
# Pod::Paragraph object.  Rofficate backslashes, untabify, put a zero-width
# character at the beginning of each line to protect against commands, and
# wrap in .Vb/.Ve.
sub verbatim {
    my $self = shift;
    return if $$self{EXCLUDE};
    local $_ = shift;
    return if /^\s+$/;
    s/\s+$/\n/;
    my $lines = tr/\n/\n/;
    1 while s/^(.*?)(\t+)/$1 . ' ' x (length ($2) * 8 - length ($1) % 8)/me;
    s/\\/\\e/g;
    s/^(\s*\S)/'\&' . $1/gme;
    $self->makespace;
    $self->output (".Vb $lines\n$_.Ve\n");
    $$self{NEEDSPACE} = 1;
}

# Called for a regular text block.  Gets the paragraph, the line number, and a
# Pod::Paragraph object.  Perform interpolation and output the results.
sub textblock {
    my $self = shift;
    return if $$self{EXCLUDE};
    $self->output ($_[0]), return if $$self{VERBATIM};

    # Parse the tree.  collapse knows about references to scalars as well as
    # scalars and does the right thing with them.  Tidy up any trailing
    # whitespace.
    my $text = shift;
    $text = $self->parse ($text, @_);
    $text =~ s/\n\s*$/\n/;

    # Output the paragraph.  We also have to handle =over without =item.  If
    # there's an =over without =item, SHIFTWAIT will be set, and we need to
    # handle creation of the indent here.  Add the shift to SHIFTS so that it
    # will be cleaned up on =back.
    $self->makespace;
    if ($$self{SHIFTWAIT}) {
        $self->output (".RS $$self{INDENT}\n");
        push (@{ $$self{SHIFTS} }, $$self{INDENT});
        $$self{SHIFTWAIT} = 0;
    }
    $self->output (protect $self->textmapfonts ($text));
    $self->outindex;
    $$self{NEEDSPACE} = 1;
}

# Called for a formatting code.  Takes a Pod::InteriorSequence object and
# returns a reference to a scalar.  This scalar is the final formatted text.
# It's returned as a reference to an array so that other formatting codes
# above us know that the text has already been processed.
sub sequence {
    my ($self, $seq) = @_;
    my $command = $seq->cmd_name;

    # We have to defer processing of the inside of an L<> formatting code.  If
    # this code is nested inside an L<> code, return the literal raw text of
    # it.
    my $parent = $seq->nested;
    while (defined $parent) {
        return $seq->raw_text if ($parent->cmd_name eq 'L');
        $parent = $parent->nested;
    }

    # Zero-width characters.
    return [ '\&' ] if ($command eq 'Z');

    # C<>, L<>, X<>, and E<> don't apply guesswork to their contents.  C<>
    # needs some additional special handling.
    my $literal = ($command =~ /^[CELX]$/);
    local $_ = $self->collapse ($seq->parse_tree, $literal, $command eq 'C');

    # Handle E<> escapes.  Numeric escapes that match one of the supported ISO
    # 8859-1 characters don't work at present.
    if ($command eq 'E') {
        if (/^\d+$/) {
            return [ chr ($_) ];
        } elsif (exists $ESCAPES{$_}) {
            return [ $ESCAPES{$_} ];
        } else {
            my ($file, $line) = $seq->file_line;
            warn "$file:$line: Unknown escape E<$_>\n";
            return [ "E<$_>" ];
        }
    }

    # For all the other codes, empty content produces no output.
    return '' if $_ eq '';

    # Handle simple formatting codes.
    if ($command eq 'B') {
        return [ '\f(BS' . $_ . '\f(BE' ];
    } elsif ($command eq 'F' || $command eq 'I') {
        return [ '\f(IS' . $_ . '\f(IE' ];
    } elsif ($command eq 'C') {
        return [ $self->quote_literal ($_) ];
    }

    # Handle links.
    if ($command eq 'L') {
        my ($text, $type) = (parselink ($_))[1,4];
        return '' unless $text;
        my ($file, $line) = $seq->file_line;
        $text = $self->parse ($text, $line);
        $text = '<' . $text . '>' if $type eq 'url';
        return [ $text ];
    }

    # Whitespace protection replaces whitespace with "\ ".
    if ($command eq 'S') {
        s/\s+/\\ /g;
        return [ $_ ];
    }

    # Add an index entry to the list of ones waiting to be output.
    if ($command eq 'X') {
        push (@{ $$self{INDEX} }, $_);
        return '';
    }

    # Anything else is unknown.
    my ($file, $line) = $seq->file_line;
    warn "$file:$line: Unknown formatting code $command<$_>\n";
}


##############################################################################
# Command paragraphs
##############################################################################

# All command paragraphs take the paragraph and the line number.

# First level heading.  We can't output .IX in the NAME section due to a bug
# in some versions of catman, so don't output a .IX for that section.  .SH
# already uses small caps, so remove \s1 and \s-1.  Maintain IN_NAME as
# appropriate, but don't leave it set while calling parse() so as to not
# override guesswork on section headings after NAME.
sub cmd_head1 {
    my $self = shift;
    $$self{IN_NAME} = 0;
    local $_ = $self->parse (@_);
    s/\s+$//;
    s/\\s-?\d//g;
    s/\s*\n\s*/ /g;
    if ($$self{ITEMS} > 1) {
        $$self{ITEMS} = 0;
        $self->output (".PD\n");
    }
    $self->output ($self->switchquotes ('.SH', $self->mapfonts ($_)));
    $self->outindex (($_ eq 'NAME') ? () : ('Header', $_));
    $$self{NEEDSPACE} = 0;
    $$self{IN_NAME} = ($_ eq 'NAME');
}

# Second level heading.
sub cmd_head2 {
    my $self = shift;
    local $_ = $self->parse (@_);
    s/\s+$//;
    s/\s*\n\s*/ /g;
    if ($$self{ITEMS} > 1) {
        $$self{ITEMS} = 0;
        $self->output (".PD\n");
    }
    $self->output ($self->switchquotes ('.Sh', $self->mapfonts ($_)));
    $self->outindex ('Subsection', $_);
    $$self{NEEDSPACE} = 0;
}

# Third level heading.
sub cmd_head3 {
    my $self = shift;
    local $_ = $self->parse (@_);
    s/\s+$//;
    s/\s*\n\s*/ /g;
    if ($$self{ITEMS} > 1) {
        $$self{ITEMS} = 0;
        $self->output (".PD\n");
    }
    $self->makespace;
    $self->output ($self->textmapfonts ('\f(IS' . $_ . '\f(IE') . "\n");
    $self->outindex ('Subsection', $_);
    $$self{NEEDSPACE} = 1;
}

# Fourth level heading.
sub cmd_head4 {
    my $self = shift;
    local $_ = $self->parse (@_);
    s/\s+$//;
    s/\s*\n\s*/ /g;
    if ($$self{ITEMS} > 1) {
        $$self{ITEMS} = 0;
        $self->output (".PD\n");
    }
    $self->makespace;
    $self->output ($self->textmapfonts ($_) . "\n");
    $self->outindex ('Subsection', $_);
    $$self{NEEDSPACE} = 1;
}

# Start a list.  For indents after the first, wrap the outside indent in .RS
# so that hanging paragraph tags will be correct.
sub cmd_over {
    my $self = shift;
    local $_ = shift;
    unless (/^[-+]?\d+\s+$/) { $_ = $$self{indent} }
    if (@{ $$self{SHIFTS} } < @{ $$self{INDENTS} }) {
        $self->output (".RS $$self{INDENT}\n");
        push (@{ $$self{SHIFTS} }, $$self{INDENT});
    }
    push (@{ $$self{INDENTS} }, $$self{INDENT});
    push (@{ $$self{ITEMTYPES} }, 'unknown');
    $$self{INDENT} = ($_ + 0);
    $$self{SHIFTWAIT} = 1;
}

# End a list.  If we've closed an embedded indent, we've mangled the hanging
# paragraph indent, so temporarily replace it with .RS and set WEIRDINDENT.
# We'll close that .RS at the next =back or =item.
sub cmd_back {
    my $self = shift;
    $$self{INDENT} = pop @{ $$self{INDENTS} };
    if (defined $$self{INDENT}) {
        pop @{ $$self{ITEMTYPES} };
    } else {
        my ($file, $line, $paragraph) = @_;
        ($file, $line) = $paragraph->file_line;
        warn "$file:$line: Unmatched =back\n";
        $$self{INDENT} = 0;
    }
    if (@{ $$self{SHIFTS} } > @{ $$self{INDENTS} }) {
        $self->output (".RE\n");
        pop @{ $$self{SHIFTS} };
    }
    if (@{ $$self{INDENTS} } > 0) {
        $self->output (".RE\n");
        $self->output (".RS $$self{INDENT}\n");
    }
    $$self{NEEDSPACE} = 1;
    $$self{SHIFTWAIT} = 0;
}

# An individual list item.  Emit an index entry for anything that's
# interesting, but don't emit index entries for things like bullets and
# numbers.  rofficate bullets too while we're at it (so for nice output, use *
# for your lists rather than o or . or - or some other thing).  Newlines in an
# item title are turned into spaces since *roff can't handle them embedded.
sub cmd_item {
    my $self = shift;
    local $_ = $self->parse (@_);
    s/\s+$//;
    s/\s*\n\s*/ /g;
    my $index;
    if (/\w/ && !/^\w[.\)]\s*$/) {
        $index = $_;
        $index =~ s/^\s*[-*+o.]?(?:\s+|\Z)//;
    }
    $_ = '*' unless length ($_) > 0;
    my $type = $$self{ITEMTYPES}[0];
    unless (defined $type) {
        my ($file, $line, $paragraph) = @_;
        ($file, $line) = $paragraph->file_line;
        $type = 'unknown';
    }
    if ($type eq 'unknown') {
        $type = /^\*\s*\Z/ ? 'bullet' : 'text';
        $$self{ITEMTYPES}[0] = $type if $$self{ITEMTYPES}[0];
    }
    s/^\*\s*\Z/\\\(bu/ if $type eq 'bullet';
    if (@{ $$self{SHIFTS} } == @{ $$self{INDENTS} }) {
        $self->output (".RE\n");
        pop @{ $$self{SHIFTS} };
    }
    $_ = $self->textmapfonts ($_);
    $self->output (".PD 0\n") if ($$self{ITEMS} == 1);
    $self->output ($self->switchquotes ('.IP', $_, $$self{INDENT}));
    $self->outindex ($index ? ('Item', $index) : ());
    $$self{NEEDSPACE} = 0;
    $$self{ITEMS}++;
    $$self{SHIFTWAIT} = 0;
}

# Begin a block for a particular translator.  Setting VERBATIM triggers
# special handling in textblock().
sub cmd_begin {
    my $self = shift;
    local $_ = shift;
    my ($kind) = /^(\S+)/ or return;
    if ($kind eq 'man' || $kind eq 'roff') {
        $$self{VERBATIM} = 1;
    } else {
        $$self{EXCLUDE} = 1;
    }
}

# End a block for a particular translator.  We assume that all =begin/=end
# pairs are properly closed.
sub cmd_end {
    my $self = shift;
    $$self{EXCLUDE} = 0;
    $$self{VERBATIM} = 0;
}

# One paragraph for a particular translator.  Ignore it unless it's intended
# for man or roff, in which case we output it verbatim.
sub cmd_for {
    my $self = shift;
    local $_ = shift;
    return unless s/^(?:man|roff)\b[ \t]*\n?//;
    $self->output ($_);
}


##############################################################################
# Escaping and fontification
##############################################################################

# At this point, we'll have embedded font codes of the form \f(<font>[SE]
# where <font> is one of B, I, or F.  Turn those into the right font start or
# end codes.  The old pod2man didn't get B<someI<thing> else> right; after I<>
# it switched back to normal text rather than bold.  We take care of this by
# using variables as a combined pointer to our current font sequence, and set
# each to the number of current nestings of start tags for that font.  Use
# them as a vector to look up what font sequence to use.
#
# \fP changes to the previous font, but only one previous font is kept.  We
# don't know what the outside level font is; normally it's R, but if we're
# inside a heading it could be something else.  So arrange things so that the
# outside font is always the "previous" font and end with \fP instead of \fR.
# Idea from Zack Weinberg.
sub mapfonts {
    my $self = shift;
    local $_ = shift;

    my ($fixed, $bold, $italic) = (0, 0, 0);
    my %magic = (F => \$fixed, B => \$bold, I => \$italic);
    my $last = '\fR';
    s { \\f\((.)(.) } {
        my $sequence = '';
        my $f;
        if ($last ne '\fR') { $sequence = '\fP' }
        ${ $magic{$1} } += ($2 eq 'S') ? 1 : -1;
        $f = $$self{FONTS}{($fixed && 1) . ($bold && 1) . ($italic && 1)};
        if ($f eq $last) {
            '';
        } else {
            if ($f ne '\fR') { $sequence .= $f }
            $last = $f;
            $sequence;
        }
    }gxe;
    $_;
}

# Unfortunately, there is a bug in Solaris 2.6 nroff (not present in GNU
# groff) where the sequence \fB\fP\f(CW\fP leaves the font set to B rather
# than R, presumably because \f(CW doesn't actually do a font change.  To work
# around this, use a separate textmapfonts for text blocks where the default
# font is always R and only use the smart mapfonts for headings.
sub textmapfonts {
    my $self = shift;
    local $_ = shift;

    my ($fixed, $bold, $italic) = (0, 0, 0);
    my %magic = (F => \$fixed, B => \$bold, I => \$italic);
    s { \\f\((.)(.) } {
        ${ $magic{$1} } += ($2 eq 'S') ? 1 : -1;
        $$self{FONTS}{($fixed && 1) . ($bold && 1) . ($italic && 1)};
    }gxe;
    $_;
}


##############################################################################
# *roff-specific parsing and magic
##############################################################################

# Called instead of parse_text, calls parse_text with the right flags.
sub parse {
    my $self = shift;
    $self->parse_text ({ -expand_seq   => 'sequence',
                         -expand_ptree => 'collapse' }, @_);
}

# Takes a parse tree, a flag saying whether or not to treat it as literal text
# (not call guesswork on it), and a flag saying whether or not to clean some
# things up for *roff, and returns the concatenation of all of the text
# strings in that parse tree.  If the literal flag isn't true, guesswork()
# will be called on all plain scalars in the parse tree.  Otherwise, if
# collapse is being called on a C<> code, $cleanup should be set to true and
# some additional cleanup will be done.  Assumes that everything in the parse
# tree is either a scalar or a reference to a scalar.
sub collapse {
    my ($self, $ptree, $literal, $cleanup) = @_;

    # If we're processing the NAME section, don't do normal guesswork.  This
    # is because NAME lines are often extracted by utilities like catman that
    # require plain text and don't understand *roff markup.  We still need to
    # escape backslashes and hyphens for *roff (and catman expects \- instead
    # of -).
    if ($$self{IN_NAME}) {
        $literal = 1;
        $cleanup = 1;
    }

    # Do the collapse of the parse tree as described above.
    return join ('', map {
        if (ref $_) {
            join ('', @$_);
        } elsif ($literal) {
            if ($cleanup) {
                s/\\/\\e/g;
                s/-/\\-/g;
                s/__/_\\|_/g;
            }
            $_;
        } else {
            $self->guesswork ($_);
        }
    } $ptree->children);
}

# Takes a text block to perform guesswork on; this is guaranteed not to
# contain any formatting codes.  Returns the text block with remapping done.
sub guesswork {
    my $self = shift;
    local $_ = shift;

    # rofficate backslashes.
    s/\\/\\e/g;

    # Ensure double underbars have a tiny space between them.
    s/__/_\\|_/g;

    # Leave hyphens only if they're part of regular words and there is only
    # one dash at a time.  Leave a dash after the first character as a regular
    # non-breaking dash, but don't let it mark the rest of the word invalid
    # for hyphenation.
    s/-/\\-/g;
    s{
      ( (?:\G|^|\s) [a-zA-Z] ) ( \\- )?
      ( (?: [a-zA-Z]+ \\-)+ )
      ( [a-zA-Z]+ ) (?=\s|\Z)
      \b
     } {
         my ($prefix, $hyphen, $main, $suffix) = ($1, $2, $3, $4);
         $hyphen ||= '';
         $main =~ s/\\-/-/g;
         $prefix . $hyphen . $main . $suffix;
    }egx;

    # Translate -- into a real em dash if it's used like one.
    s{ (\s) \\-\\- (\s) }                         { $1 . '\*(--' . $2 }egx;
    s{ (\b[a-zA-Z]+) \\-\\- (\s|\Z|[a-zA-Z]+\b) } { $1 . '\*(--' . $2 }egx;

    # Make all caps a little smaller.  Be careful here, since we don't want to
    # make @ARGV into small caps, nor do we want to fix the MIME in
    # MIME-Version, since it looks weird with the full-height V.
    s{
        ( ^ | [\s\(\"\'\`\[\{<>] )
        ( [A-Z] [A-Z] (?: [/A-Z+:\d_\$&] | \\- )* )
        (?= [\s>\}\]\(\)\'\".?!,;] | \\*\(-- | $ )
    } { $1 . '\s-1' . $2 . '\s0' }egx;

    # Italize functions in the form func().
    s{
        ( \b | \\s-1 )
        (
            [A-Za-z_] ([:\w]|\\s-?[01])+ \(\)
        )
    } { $1 . '\f(IS' . $2 . '\f(IE' }egx;

    # func(n) is a reference to a manual page.  Make it \fIfunc\fR\|(n).
    s{
        ( \b | \\s-1 )
        ( [A-Za-z_] (?:[.:\w]|\\-|\\s-?[01])+ )
        (
            \( \d [a-z]* \)
        )
    } { $1 . '\f(IS' . $2 . '\f(IE\|' . $3 }egx;

    # Convert simple Perl variable references to a fixed-width font.
    s{
        ( \s+ )
        ( [\$\@%] [\w:]+ )
        (?! \( )
    } { $1 . '\f(FS' . $2 . '\f(FE'}egx;

    # Fix up double quotes.
    s{ \" ([^\"]+) \" } { '\*(L"' . $1 . '\*(R"' }egx;

    # Make C++ into \*(C+, which is a squinched version.
    s{ \b C\+\+ } {\\*\(C+}gx;

    # All done.
    $_;
}

# Handles C<> text, deciding whether to put \*C` around it or not.  This is a
# whole bunch of messy heuristics to try to avoid overquoting, originally from
# Barrie Slaymaker.  This largely duplicates similar code in Pod::Text.
sub quote_literal {
    my $self = shift;
    local $_ = shift;

    # A regex that matches the portion of a variable reference that's the
    # array or hash index, separated out just because we want to use it in
    # several places in the following regex.
    my $index = '(?: \[.*\] | \{.*\} )?';

    # Check for things that we don't want to quote, and if we find any of
    # them, return the string with just a font change and no quoting.
    m{
      ^\s*
      (?:
         ( [\'\`\"] ) .* \1                             # already quoted
       | \` .* \'                                       # `quoted'
       | \$+ [\#^]? \S $index                           # special ($^Foo, $")
       | [\$\@%&*]+ \#? [:\'\w]+ $index                 # plain var or func
       | [\$\@%&*]* [:\'\w]+ (?: -> )? \(\s*[^\s,]\s*\) # 0/1-arg func call
       | [+-]? ( \d[\d.]* | \.\d+ ) (?: [eE][+-]?\d+ )? # a number
       | 0x [a-fA-F\d]+                                 # a hex constant
      )
      \s*\z
     }xo && return '\f(FS' . $_ . '\f(FE';

    # If we didn't return, go ahead and quote the text.
    return '\f(FS\*(C`' . $_ . "\\*(C'\\f(FE";
}


##############################################################################
# Output formatting
##############################################################################

# Make vertical whitespace.
sub makespace {
    my $self = shift;
    $self->output (".PD\n") if ($$self{ITEMS} > 1);
    $$self{ITEMS} = 0;
    $self->output ($$self{INDENT} > 0 ? ".Sp\n" : ".PP\n")
        if $$self{NEEDSPACE};
}

# Output any pending index entries, and optionally an index entry given as an
# argument.  Support multiple index entries in X<> separated by slashes, and
# strip special escapes from index entries.
sub outindex {
    my ($self, $section, $index) = @_;
    my @entries = map { split m%\s*/\s*% } @{ $$self{INDEX} };
    return unless ($section || @entries);
    $$self{INDEX} = [];
    my @output;
    if (@entries) {
        push (@output, [ 'Xref', join (' ', @entries) ]);
    }
    if ($section) {
        $index =~ s/\\-/-/g;
        $index =~ s/\\(?:s-?\d|.\(..|.)//g;
        push (@output, [ $section, $index ]);
    }
    for (@output) {
        my ($type, $entry) = @$_;
        $entry =~ s/\"/\"\"/g;
        $self->output (".IX $type " . '"' . $entry . '"' . "\n");
    }
}

# Output text to the output device.
sub output { print { $_[0]->output_handle } $_[1] }

# Given a command and a single argument that may or may not contain double
# quotes, handle double-quote formatting for it.  If there are no double
# quotes, just return the command followed by the argument in double quotes.
# If there are double quotes, use an if statement to test for nroff, and for
# nroff output the command followed by the argument in double quotes with
# embedded double quotes doubled.  For other formatters, remap paired double
# quotes to LQUOTE and RQUOTE.
sub switchquotes {
    my $self = shift;
    my $command = shift;
    local $_ = shift;
    my $extra = shift;
    s/\\\*\([LR]\"/\"/g;

    # We also have to deal with \*C` and \*C', which are used to add the
    # quotes around C<> text, since they may expand to " and if they do this
    # confuses the .SH macros and the like no end.  Expand them ourselves.
    # Also separate troff from nroff if there are any fixed-width fonts in use
    # to work around problems with Solaris nroff.
    my $c_is_quote = ($$self{LQUOTE} =~ /\"/) || ($$self{RQUOTE} =~ /\"/);
    my $fixedpat = join ('|', @{ $$self{FONTS} }{'100', '101', '110', '111'});
    $fixedpat =~ s/\\/\\\\/g;
    $fixedpat =~ s/\(/\\\(/g;
    if (/\"/ || /$fixedpat/) {
        s/\"/\"\"/g;
        my $nroff = $_;
        my $troff = $_;
        $troff =~ s/\"\"([^\"]*)\"\"/\`\`$1\'\'/g;
        if ($c_is_quote && /\\\*\(C[\'\`]/) {
            $nroff =~ s/\\\*\(C\`/$$self{LQUOTE}/g;
            $nroff =~ s/\\\*\(C\'/$$self{RQUOTE}/g;
            $troff =~ s/\\\*\(C[\'\`]//g;
        }
        $nroff = qq("$nroff") . ($extra ? " $extra" : '');
        $troff = qq("$troff") . ($extra ? " $extra" : '');

        # Work around the Solaris nroff bug where \f(CW\fP leaves the font set
        # to Roman rather than the actual previous font when used in headings.
        # troff output may still be broken, but at least we can fix nroff by
        # just switching the font changes to the non-fixed versions.
        $nroff =~ s/\Q$$self{FONTS}{100}\E(.*)\\f[PR]/$1/g;
        $nroff =~ s/\Q$$self{FONTS}{101}\E(.*)\\f([PR])/\\fI$1\\f$2/g;
        $nroff =~ s/\Q$$self{FONTS}{110}\E(.*)\\f([PR])/\\fB$1\\f$2/g;
        $nroff =~ s/\Q$$self{FONTS}{111}\E(.*)\\f([PR])/\\f\(BI$1\\f$2/g;

        # Now finally output the command.  Only bother with .ie if the nroff
        # and troff output isn't the same.
        if ($nroff ne $troff) {
            return ".ie n $command $nroff\n.el $command $troff\n";
        } else {
            return "$command $nroff\n";
        }
    } else {
        $_ = qq("$_") . ($extra ? " $extra" : '');
        return "$command $_\n";
    }
}

##############################################################################
# Module return value and documentation
##############################################################################

1;
__END__

=head1 NAME

Pod::Man - Convert POD data to formatted *roff input

=head1 SYNOPSIS

    use Pod::Man;
    my $parser = Pod::Man->new (release => $VERSION, section => 8);

    # Read POD from STDIN and write to STDOUT.
    $parser->parse_from_filehandle;

    # Read POD from file.pod and write to file.1.
    $parser->parse_from_file ('file.pod', 'file.1');

=head1 DESCRIPTION

Pod::Man is a module to convert documentation in the POD format (the
preferred language for documenting Perl) into *roff input using the man
macro set.  The resulting *roff code is suitable for display on a terminal
using L<nroff(1)>, normally via L<man(1)>, or printing using L<troff(1)>.
It is conventionally invoked using the driver script B<pod2man>, but it can
also be used directly.

As a derived class from Pod::Parser, Pod::Man supports the same methods and
interfaces.  See L<Pod::Parser> for all the details; briefly, one creates a
new parser with C<< Pod::Man->new() >> and then calls either
parse_from_filehandle() or parse_from_file().

new() can take options, in the form of key/value pairs that control the
behavior of the parser.  See below for details.

If no options are given, Pod::Man uses the name of the input file with any
trailing C<.pod>, C<.pm>, or C<.pl> stripped as the man page title, to
section 1 unless the file ended in C<.pm> in which case it defaults to
section 3, to a centered title of "User Contributed Perl Documentation", to
a centered footer of the Perl version it is run with, and to a left-hand
footer of the modification date of its input (or the current date if given
STDIN for input).

Pod::Man assumes that your *roff formatters have a fixed-width font named
CW.  If yours is called something else (like CR), use the C<fixed> option to
specify it.  This generally only matters for troff output for printing.
Similarly, you can set the fonts used for bold, italic, and bold italic
fixed-width output.

Besides the obvious pod conversions, Pod::Man also takes care of formatting
func(), func(3), and simple variable references like $foo or @bar so you
don't have to use code escapes for them; complex expressions like
C<$fred{'stuff'}> will still need to be escaped, though.  It also translates
dashes that aren't used as hyphens into en dashes, makes long dashes--like
this--into proper em dashes, fixes "paired quotes," makes C++ look right,
puts a little space between double underbars, makes ALLCAPS a teeny bit
smaller in B<troff>, and escapes stuff that *roff treats as special so that
you don't have to.

The recognized options to new() are as follows.  All options take a single
argument.

=over 4

=item center

Sets the centered page header to use instead of "User Contributed Perl
Documentation".

=item date

Sets the left-hand footer.  By default, the modification date of the input
file will be used, or the current date if stat() can't find that file (the
case if the input is from STDIN), and the date will be formatted as
YYYY-MM-DD.

=item fixed

The fixed-width font to use for vertabim text and code.  Defaults to CW.
Some systems may want CR instead.  Only matters for B<troff> output.

=item fixedbold

Bold version of the fixed-width font.  Defaults to CB.  Only matters for
B<troff> output.

=item fixeditalic

Italic version of the fixed-width font (actually, something of a misnomer,
since most fixed-width fonts only have an oblique version, not an italic
version).  Defaults to CI.  Only matters for B<troff> output.

=item fixedbolditalic

Bold italic (probably actually oblique) version of the fixed-width font.
Pod::Man doesn't assume you have this, and defaults to CB.  Some systems
(such as Solaris) have this font available as CX.  Only matters for B<troff>
output.

=item name

Set the name of the manual page.  Without this option, the manual name is
set to the uppercased base name of the file being converted unless the
manual section is 3, in which case the path is parsed to see if it is a Perl
module path.  If it is, a path like C<.../lib/Pod/Man.pm> is converted into
a name like C<Pod::Man>.  This option, if given, overrides any automatic
determination of the name.

=item quotes

Sets the quote marks used to surround CE<lt>> text.  If the value is a
single character, it is used as both the left and right quote; if it is two
characters, the first character is used as the left quote and the second as
the right quoted; and if it is four characters, the first two are used as
the left quote and the second two as the right quote.

This may also be set to the special value C<none>, in which case no quote
marks are added around CE<lt>> text (but the font is still changed for troff
output).

=item release

Set the centered footer.  By default, this is the version of Perl you run
Pod::Man under.  Note that some system an macro sets assume that the
centered footer will be a modification date and will prepend something like
"Last modified: "; if this is the case, you may want to set C<release> to
the last modified date and C<date> to the version number.

=item section

Set the section for the C<.TH> macro.  The standard section numbering
convention is to use 1 for user commands, 2 for system calls, 3 for
functions, 4 for devices, 5 for file formats, 6 for games, 7 for
miscellaneous information, and 8 for administrator commands.  There is a lot
of variation here, however; some systems (like Solaris) use 4 for file
formats, 5 for miscellaneous information, and 7 for devices.  Still others
use 1m instead of 8, or some mix of both.  About the only section numbers
that are reliably consistent are 1, 2, and 3.

By default, section 1 will be used unless the file ends in .pm in which case
section 3 will be selected.

=back

The standard Pod::Parser method parse_from_filehandle() takes up to two
arguments, the first being the file handle to read POD from and the second
being the file handle to write the formatted output to.  The first defaults
to STDIN if not given, and the second defaults to STDOUT.  The method
parse_from_file() is almost identical, except that its two arguments are the
input and output disk files instead.  See L<Pod::Parser> for the specific
details.

=head1 DIAGNOSTICS

=over 4

=item roff font should be 1 or 2 chars, not "%s"

(F) You specified a *roff font (using C<fixed>, C<fixedbold>, etc.) that
wasn't either one or two characters.  Pod::Man doesn't support *roff fonts
longer than two characters, although some *roff extensions do (the canonical
versions of B<nroff> and B<troff> don't either).

=item Invalid link %s

(W) The POD source contained a C<LE<lt>E<gt>> formatting code that
Pod::Man was unable to parse.  You should never see this error message; it
probably indicates a bug in Pod::Man.

=item Invalid quote specification "%s"

(F) The quote specification given (the quotes option to the constructor) was
invalid.  A quote specification must be one, two, or four characters long.

=item %s:%d: Unknown command paragraph "%s".

(W) The POD source contained a non-standard command paragraph (something of
the form C<=command args>) that Pod::Man didn't know about.  It was ignored.

=item %s:%d: Unknown escape EE<lt>%sE<gt>

(W) The POD source contained an C<EE<lt>E<gt>> escape that Pod::Man didn't
know about.  C<EE<lt>%sE<gt>> was printed verbatim in the output.

=item %s:%d: Unknown formatting code %s

(W) The POD source contained a non-standard formatting code (something of
the form C<XE<lt>E<gt>>) that Pod::Man didn't know about.  It was ignored.

=item %s:%d: Unmatched =back

(W) Pod::Man encountered a C<=back> command that didn't correspond to an
C<=over> command.

=back

=head1 BUGS

Eight-bit input data isn't handled at all well at present.  The correct
approach would be to map EE<lt>E<gt> escapes to the appropriate UTF-8
characters and then do a translation pass on the output according to the
user-specified output character set.  Unfortunately, we can't send eight-bit
data directly to the output unless the user says this is okay, since some
vendor *roff implementations can't handle eight-bit data.  If the *roff
implementation can, however, that's far superior to the current hacked
characters that only work under troff.

There is currently no way to turn off the guesswork that tries to format
unmarked text appropriately, and sometimes it isn't wanted (particularly
when using POD to document something other than Perl).

The NAME section should be recognized specially and index entries emitted
for everything in that section.  This would have to be deferred until the
next section, since extraneous things in NAME tends to confuse various man
page processors.

Pod::Man doesn't handle font names longer than two characters.  Neither do
most B<troff> implementations, but GNU troff does as an extension.  It would
be nice to support as an option for those who want to use it.

The preamble added to each output file is rather verbose, and most of it is
only necessary in the presence of EE<lt>E<gt> escapes for non-ASCII
characters.  It would ideally be nice if all of those definitions were only
output if needed, perhaps on the fly as the characters are used.

Pod::Man is excessively slow.

=head1 CAVEATS

The handling of hyphens and em dashes is somewhat fragile, and one may get
the wrong one under some circumstances.  This should only matter for
B<troff> output.

When and whether to use small caps is somewhat tricky, and Pod::Man doesn't
necessarily get it right.

=head1 SEE ALSO

L<Pod::Parser>, L<perlpod(1)>, L<pod2man(1)>, L<nroff(1)>, L<troff(1)>,
L<man(1)>, L<man(7)>

Ossanna, Joseph F., and Brian W. Kernighan.  "Troff User's Manual,"
Computing Science Technical Report No. 54, AT&T Bell Laboratories.  This is
the best documentation of standard B<nroff> and B<troff>.  At the time of
this writing, it's available at
L<http://www.cs.bell-labs.com/cm/cs/cstr.html>.

The man page documenting the man macro set may be L<man(5)> instead of
L<man(7)> on your system.  Also, please see L<pod2man(1)> for extensive
documentation on writing manual pages if you've not done it before and
aren't familiar with the conventions.

The current version of this module is always available from its web site at
L<http://www.eyrie.org/~eagle/software/podlators/>.  It is also part of the
Perl core distribution as of 5.6.0.

=head1 AUTHOR

Russ Allbery <rra@stanford.edu>, based I<very> heavily on the original
B<pod2man> by Tom Christiansen <tchrist@mox.perl.com>.

=head1 COPYRIGHT AND LICENSE

Copyright 1999, 2000, 2001, 2002, 2003 by Russ Allbery <rra@stanford.edu>.

This program is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

=cut
