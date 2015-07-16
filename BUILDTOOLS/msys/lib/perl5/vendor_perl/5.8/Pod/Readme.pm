=head1 NAME

Pod::Readme - Convert POD to README file

=begin readme

=head1 REQUIREMENTS

This module should run on Perl 5.005 or newer.  The following non-core
modules (depending on your Perl version) are required:

  Pod::PlainText
  Test::More

=head1 INSTALLATION

Installation can be done using the traditional Makefile.PL or the newer
Build.PL methods.

Using Makefile.PL:

  perl Makefile.PL
  make test
  make install

(On Windows platforms you should use C<nmake> instead.)

Using Build.PL (if you have Module::Build installed):

  perl Build.PL
  perl Build test
  perl Build install

=end readme

=head1 SYNOPSIS

  use Pod::Readme;
  my $parser = Pod::Readme->new();

  # Read POD from STDIN and write to STDOUT
  $parser->parse_from_filehandle;

  # Read POD from Module.pm and write to README
  $parser->parse_from_file('Module.pm', 'README');

=cut

package Pod::Readme;

use 5.005;
use strict;

use Carp;
use IO::File;
use Pod::PlainText;
use Regexp::Common qw( URI );

use vars qw( @ISA $VERSION );

@ISA = qw( Pod::PlainText );

$VERSION = '0.09';

=begin internal

=item initialize

Override adds the C<readme_type> and <debug> options, and initializes
the "README_SKIP" flag.

=end internal

=cut

{
  my %INVALID_TYPES = map { $_ => 1, } (qw(
    test testing tests
    html xhtml xml docbook rtf man nroff dsr rno latex tex code
  ));

  sub initialize {
    my $self = shift;

    $$self{README_SKIP} ||= 0;
    $$self{readme_type} ||= "readme";

    $$self{debug}       ||= 0;

    $self->SUPER::initialize;

    croak "$$self{readme_type} is an invalid readme_type",
      if ($INVALID_TYPES{ $$self{readme_type} });
  }
}


=begin internal

=item output

Override does not output anything if the "README_SKIP" flag is enabled.

=end internal

=cut

sub output {
  my $self = shift;
  return if $$self{README_SKIP};
  $self->SUPER::output(@_);
}


=begin internal

=item _parse_args

Parses destination and name="value" arguments passed for L</cmd_for>.

=end internal

=cut

sub _parse_args {
  my $self   = shift;
  my $string = shift;
  my @values = ( );

  my $arg      = "";
  my $in_quote = 0;
  my $last;
  foreach (split //, $string) {
    if (/\s/) {
      if ($in_quote) {
        $arg .= $_;
      }
      else {
        if ($arg ne "") {
          push @values, $arg;
          $arg = "";
        }
      }
    }
    else {
      $arg .= $_;
      if (/\"/) {
        if ($in_quote) {
          $in_quote = 0 unless ($last eq "\\");
        }
        else {
          # croak "expected \"name=\" before quotes" unless ($last eq "=");
          $in_quote = 1;
        }
      }
    }
    $last = $_;
  }
  push @values, $arg if ($arg ne "");
  return @values;
}



=begin internal

=item cmd_begin

Overrides support for "begin" command.

=end internal

=cut

sub cmd_begin {
  my $self = shift;
  my $sec  = $$self{readme_type} || "readme";
  my @fmt  = $self->_parse_args($_[0]);
  my %secs = map { $_ => 1, } split /,/, $fmt[0];
  if ($secs{$sec}) {
    $$self{README_SKIP} = 0;
    if (($fmt[1]||"pod") eq "pod") {
    }
    elsif ($fmt[1] eq "text") {
      $$self{VERBATIM} = 1;
    }
    else {
      # TODO - return error
      $$self{EXCLUDE}  = 1;
    }
  }
  else {
    carp "Ignoring document type(s) \"$fmt[0]\" in POD line $_[1]"
      if ($$self{debug});
    $self->SUPER::cmd_begin(@_);
  }
}


=begin internal

=item cmd_for

Overrides support for "for" command.

=end internal

=cut

sub cmd_for {
  my $self = shift;
  my $sec  = $$self{readme_type} || "readme";
  my @fmt  = $self->_parse_args($_[0]);
  my %secs = map { $_ => 1, } split /,/, $fmt[0];
  if ($secs{$sec}) {
    my $cmd = $fmt[1] || "continue";
    if ($cmd eq "stop") {
      $$self{README_SKIP} = 1;
    } elsif ($cmd eq "continue") {
      $$self{README_SKIP} = 0;
    } elsif ($cmd eq "include") {

      my %arg = map {
        s/\"//g;
        my ($k,$v) = split /\=/;
        $k => $v;
      } @fmt[2..$#fmt];
      $arg{type} ||= "pod";

      my $text =
	$self->_include_file( map { $arg{$_} } (qw( type file start stop )) );
      if ($arg{type} eq "text") {
        $self->verbatim($text, $_[1], $_[2]);
      } else {
        $self->textblock($text, $_[1], $_[2]);
      }
    } else {
      croak "Don\'t know how to \"$cmd\" in POD line $_[1]";
    }
  }
  else {
    carp "Ignoring document type(s) \"$fmt[0]\" in POD line $_[1]"
      if ($$self{debug});
    $self->SUPER::cmd_for(@_);
  }
}


=begin internal

=item _include_file

Includes a file.

=end internal

=cut

sub _include_file {
  my $self = shift;
  my $type = shift || "pod";
  my $file = shift;
  my $mark = shift || "";
  my $stop = shift || "";

  my $fh   = IO::File->new("<$file")
    || croak "Unable to open file \"$file\"";

  my $buffer = "";
  while (my $line = <$fh>) {
    next if (($mark ne "") && ($line !~ /$mark/));
    $mark = "" if ($mark ne "");
    last if (($stop ne "") && ($line =~ /$stop/));
    $buffer .= $line;
  }
  close $fh;

  if ($type ne "pod") {
    my $indent = " " x $$self{MARGIN};
    $buffer =~ s/([\r\n]+)(\t)?/$1 . $indent x (1+length($2||""))/ge;
    $buffer =~ s/($indent)+$//;
  }

  return $buffer;
}


=begin internal

=item seq_l

Overrides support for "L" markup.

=end internal

=cut

# This code is based on code from Pod::PlainText 2.02

sub seq_l {
  my $self = shift;
  local $_ = shift;
    # Smash whitespace in case we were split across multiple lines.
    s/\s+/ /g;

    # If we were given any explicit text, just output it.
    if (/^([^|]+)\|/) { return $1 }

    # Okay, leading and trailing whitespace isn't important; get rid of it.
    s/^\s+//;
    s/\s+$//;

    # Default to using the whole content of the link entry as a section
    # name.  Note that L<manpage/> forces a manpage interpretation, as does
    # something looking like L<manpage(section)>.  The latter is an
    # enhancement over the original Pod::Text.


    my ($manpage, $section) = ('', $_);
    if (/$RE{URI}/ || /^(?:https?|ftps?|svn):/) {
        # a URL
        return $_;
    } elsif (/^"\s*(.*?)\s*"$/) {
        $section = '"' . $1 . '"';
    } elsif (m/^[-:.\w]+(?:\(\S+\))?$/) {
        ($manpage, $section) = ($_, '');
    } elsif (m%/%) {
        ($manpage, $section) = split (/\s*\/\s*/, $_, 2);
    }

    if (length $manpage) {
      return $manpage;
    } else {
      return $section;
    }
}


=head1 DESCRIPTION

This module is a subclass of L<Pod::PlainText> which provides additional
POD markup for generating F<README> files.

Why should one bother with this? One can simply use

  pod2text Module.pm > README

A problem with doing that is that the default L<pod2text> converter will
add text to links, so that "LZ<><Module>" is translated to
"the Module manpage".

Another problem is that the F<README> includes the entirety of
the module documentation!  Most people browsing the F<README> file do not
need all of this information.

Likewise, including installation and requirement information in the 
module documentation is not necessary either, since the module is already
installed.

This module allows authors to mark portions of the POD to be included only
in, or to be excluded from the F<README> file.  It also allows you to
include portions of another file (such as a separate F<ChangeLog>).

=begin readme

See the module documentation for more details.

=end readme

=for readme stop

=head2 Markup

Special POD markup options are described below:

=over

=item begin/end

  =begin readme
  
  =head1 README ONLY

  This section will only show up in the README file.

  =end readme

Delineates a POD section that is only available in README file. If
you prefer to include plain text instead, add the C<text> modifier:

  =begin readme text

  README ONLY (PLAINTEXT)

      This section will only show up in the README file.

  =end readme

Note that placing a colon before the section to indicate that it is
POD (e.g. C<begin :readme>) is not supported in this version.

=item stop/continue

  =for readme stop

All POD that follows will not be included in the README, until
a C<continue> command occurs:

  =for readme continue

=item include

  =for readme include file=filename type=type start=Regexp stop=Regexp

  =for readme include file=Changes start=^0.09 stop=^0.081 type=text

Includes a plaintext file named F<filename>, starting with the line
that contains the start C<Regexp> and ending at the line that begins
with the stop C<Regexp>.  (The start and stop Regexps are optional: one
or both may be omitted.)

Type may be C<text> or C<pod>. If omitted, C<pod> will be assumed.

Quotes may be used when the filename or marks contains spaces:

  =for readme include file="another file.pod"

=back

One can also using maintain multiple file types (such as including F<TODO>,
or F<COPYING>) by using a modified constructor:

  $parser = Pod::Readme->new( readme_type => "copying" );

In the above L</Markup> commands replace "readme" with the tag specified
instead (such as "copying"):

  =begin copying

As of version 0.03 you can specify multiple sections by separating them
with a comma:

  =begin copying,readme

There is also no standard list of type names.  Some names might be recognized
by other POD processors (such as "testing" or "html").  L<Pod::Readme> will
reject the following "known" type names when they are specified in the
constructor:

    testing html xhtml xml docbook rtf man nroff dsr rno latex tex code

You can also use a "debug" mode to diagnose any problems, such as mistyped
format names:

  $parser = Pod::Readme->new( debug => 1 );

Warnings will be issued for any ignored formatting commands.

=head2 Example

For an example, see the F<Readme.pm> file in this distribution.

=for readme continue

=begin readme

=head1 REVSION HISTORY

Changes since the last release:

=for readme include file="Changes" start="^0.09" stop="^0.081" type="text"

A detailed history is available in the F<Changes> file.

=end readme

=head1 SEE ALSO

See L<perlpod>, L<perlpodspec> and L<podlators>.

=head1 AUTHOR

Robert Rothenberg <rrwo at cpan.org>

=head2 Suggestions and Bug Reporting

Feedback is always welcome.  Please use the CPAN Request Tracker at
L<http://rt.cpan.org> to submit bug reports.

=head1 LICENSE

Copyright (c) 2005,2006 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

Some portions are based on L<Pod::PlainText> 2.02.

=cut
