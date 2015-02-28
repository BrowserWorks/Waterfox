# Copyright 2001 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# Written by Akim Demaille <akim@freefriends.org>.

###############################################################
# The main copy of this file is in Autoconf's CVS repository. #
# Updates should be sent to autoconf-patches@gnu.org.         #
###############################################################

package Automake::XFile;

=head1 NAME

Automake::XFile - supply object methods for filehandles with error handling

=head1 SYNOPSIS

    use Automake::XFile;

    $fh = new Automake::XFile;
    $fh->open("< file"))
    # No need to check $FH: we died if open failed.
    print <$fh>;
    $fh->close;
    # No need to check the return value of close: we died if it failed.

    $fh = new Automake::XFile "> file";
    # No need to check $FH: we died if new failed.
    print $fh "bar\n";
    $fh->close;

    $fh = new Automake::XFile "file", "r";
    # No need to check $FH: we died if new failed.
    defined $fh
    print <$fh>;
    undef $fh;   # automatically closes the file and checks for errors.

    $fh = new Automake::XFile "file", O_WRONLY|O_APPEND;
    # No need to check $FH: we died if new failed.
    print $fh "corge\n";

    $pos = $fh->getpos;
    $fh->setpos($pos);

    undef $fh;   # automatically closes the file and checks for errors.

    autoflush STDOUT 1;

=head1 DESCRIPTION

C<Automake::XFile> inherits from C<IO::File>.  It provides dying
version of the methods C<open>, C<new>, and C<close>.  It also overrides
the C<getline> and C<getlines> methods to translate C<\r\n> to C<\n>.

=head1 SEE ALSO

L<perlfunc>,
L<perlop/"I/O Operators">,
L<IO::File>
L<IO::Handle>
L<IO::Seekable>

=head1 HISTORY

Derived from IO::File.pm by Akim Demaille E<lt>F<akim@freefriends.org>E<gt>.

=cut

require 5.000;
use strict;
use vars qw($VERSION @EXPORT @EXPORT_OK $AUTOLOAD @ISA);
use Carp;
use File::Basename;

require Exporter;
require DynaLoader;

@ISA = qw(IO::File Exporter DynaLoader);

$VERSION = "1.1";

@EXPORT = @IO::File::EXPORT;

eval {
    # Make all Fcntl O_XXX constants available for importing
    require Fcntl;
    my @O = grep /^O_/, @Fcntl::EXPORT;
    Fcntl->import(@O);  # first we import what we want to export
    push(@EXPORT, @O);
};


################################################
## Constructor
##

sub new
{
  my $type = shift;
  my $class = ref($type) || $type || "Automake::XFile";
  my $fh = $class->SUPER::new ();
  if (@_)
    {
      $fh->open (@_);
    }
  $fh;
}

################################################
## Open
##

sub open
{
  my ($fh) = shift;
  my ($file) = @_;

  # WARNING: Gross hack: $FH is a typeglob: use its hash slot to store
  # the `name' of the file we are opening.  See the example with
  # io_socket_timeout in IO::Socket for more, and read Graham's
  # comment in IO::Handle.
  ${*$fh}{'autom4te_xfile_file'} = "$file";

  if (!$fh->SUPER::open (@_))
    {
      my $me = basename ($0);
      croak "$me: cannot open $file: $!\n";
    }

  # In case we're running under MSWindows, don't write with CRLF.
  # (This circumvents a bug in at least Cygwin bash where the shell
  # parsing fails on lines ending with the continuation character '\'
  # and CRLF).
  binmode $fh if $file =~ /^\s*>/;
}

################################################
## Close
##

sub close
{
  my ($fh) = shift;
  if (!$fh->SUPER::close (@_))
    {
      my $me = basename ($0);
      my $file = ${*$fh}{'autom4te_xfile_file'};
      croak "$me: cannot close $file: $!\n";
    }
}

################################################
## Getline
##

# Some Win32/perl installations fail to translate \r\n to \n on input
# so we do that here.
sub getline
{
    local $_ = $_[0]->SUPER::getline;
    # Perform a _global_ replacement: $_ may can contains many lines
    # in slurp mode ($/ = undef).
    s/\015\012/\n/gs if defined $_;
    return $_;
}

################################################
## Getlines
##

sub getlines
{
    my @res = ();
    my $line;
    push @res, $line while $line = $_[0]->getline;
    return @res;
}

1;

### Setup "GNU" style for perl-mode and cperl-mode.
## Local Variables:
## perl-indent-level: 2
## perl-continued-statement-offset: 2
## perl-continued-brace-offset: 0
## perl-brace-offset: 0
## perl-brace-imaginary-offset: 0
## perl-label-offset: -2
## cperl-indent-level: 2
## cperl-brace-offset: 0
## cperl-continued-brace-offset: 0
## cperl-label-offset: -2
## cperl-extra-newline-before-brace: t
## cperl-merge-trailing-else: nil
## cperl-continued-statement-offset: 2
## End:
