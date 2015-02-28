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

package Automake::General;

use 5.005;
use Exporter;
use File::Basename;
use File::stat;
use IO::File;
use Carp;
use strict;

use vars qw (@ISA @EXPORT);

@ISA = qw (Exporter);
@EXPORT = qw (&debug &find_configure_ac &find_file &getopt &mktmpdir &mtime
              &uniq &update_file &verbose &xsystem
	      $debug $help $me $tmp $verbose $version);

# Variable we share with the main package.  Be sure to have a single
# copy of them: using `my' together with multiple inclusion of this
# package would introduce several copies.
use vars qw ($debug);
$debug = 0;

use vars qw ($help);
$help = undef;

use vars qw ($me);
$me = basename ($0);

# Our tmp dir.
use vars qw ($tmp);
$tmp = undef;

use vars qw ($verbose);
$verbose = 0;

use vars qw ($version);
$version = undef;


# END
# ---
# Exit nonzero whenever closing STDOUT fails.
# Ideally we should `exit ($? >> 8)', unfortunately, for some reason
# I don't understand, whenever we `exit (1)' somewhere in the code,
# we arrive here with `$? = 29'.  I suspect some low level END routine
# might be responsible.  In this case, be sure to exit 1, not 29.
sub END
{
  my $exit_status = $? ? 1 : 0;

  use POSIX qw (_exit);

  if (!$debug && defined $tmp && -d $tmp)
    {
      if (<$tmp/*>)
	{
	  unlink <$tmp/*>
	    or carp ("$me: cannot empty $tmp: $!\n"), _exit (1);
	}
      rmdir $tmp
	or carp ("$me: cannot remove $tmp: $!\n"), _exit (1);
    }

  # This is required if the code might send any output to stdout
  # E.g., even --version or --help.  So it's best to do it unconditionally.
  close STDOUT
    or (carp "$me: closing standard output: $!\n"), _exit (1);

  _exit ($exit_status);
}


# debug(@MESSAGE)
# ---------------
# Messages displayed only if $DEBUG and $VERBOSE.
sub debug (@)
{
  print STDERR "$me: ", @_, "\n"
    if $verbose && $debug;
}


# $CONFIGURE_AC
# &find_configure_ac ()
# ---------------------
sub find_configure_ac ()
{
  if (-f 'configure.ac')
    {
      if (-f 'configure.in')
	{
	  carp "warning: `configure.ac' and `configure.in' both present.\n";
	  carp "warning: proceeding with `configure.ac'.\n";
	}
      return 'configure.ac';
    }
  elsif (-f 'configure.in')
    {
      return 'configure.in';
    }
  return;
}


# $FILENAME
# find_file ($FILENAME, @INCLUDE)
# -------------------------------
# We match exactly the behavior of GNU m4: first look in the current
# directory (which includes the case of absolute file names), and, if
# the file is not absolute, just fail.  Otherwise, look in the path.
#
# If the file is flagged as optional (ends with `?'), then return undef
# if absent.
sub find_file ($@)
{
  use File::Spec;

  my ($filename, @include) = @_;
  my $optional = 0;

  $optional = 1
    if $filename =~ s/\?$//;

  return File::Spec->canonpath ($filename)
    if -e $filename;

  if (File::Spec->file_name_is_absolute ($filename))
    {
      die "$me: no such file or directory: $filename\n"
	unless $optional;
      return undef;
    }

  foreach my $path (reverse @include)
    {
      return File::Spec->canonpath (File::Spec->catfile ($path, $filename))
	if -e File::Spec->catfile ($path, $filename)
    }

  die "$me: no such file or directory: $filename\n"
    unless $optional;

  return undef;
}


# getopt (%OPTION)
# ----------------
# Handle the %OPTION, plus all the common options.
# Work around Getopt bugs wrt `-'.
sub getopt (%)
{
  my (%option) = @_;
  use Getopt::Long;

  # F*k.  Getopt seems bogus and dies when given `-' with `bundling'.
  # If fixed some day, use this: '' => sub { push @ARGV, "-" }
  my $stdin = grep /^-$/, @ARGV;
  @ARGV = grep !/^-$/, @ARGV;
  %option = (%option,
	     "h|help"     => sub { print $help; exit 0 },
             "V|version"  => sub { print $version; exit 0 },

             "v|verbose"    => \$verbose,
             "d|debug"      => \$debug,
	    );
  Getopt::Long::Configure ("bundling");
  GetOptions (%option)
    or exit 1;

    push @ARGV, '-'
    if $stdin;
}


# mktmpdir ($SIGNATURE)
# ---------------------
# Create a temporary directory which name is based on $SIGNATURE.
sub mktmpdir ($)
{
  my ($signature) = @_;
  my $TMPDIR = $ENV{'TMPDIR'} || '/tmp';

  # If mktemp supports dirs, use it.
  $tmp = `(umask 077 &&
           mktemp -d -q "$TMPDIR/${signature}XXXXXX") 2>/dev/null`;
  chomp $tmp;

  if (!$tmp || ! -d $tmp)
    {
      $tmp = "$TMPDIR/$signature" . int (rand 10000) . ".$$";
      mkdir $tmp, 0700
	or croak "$me: cannot create $tmp: $!\n";
    }

  print STDERR "$me:$$: working in $tmp\n"
    if $debug;
}


# $MTIME
# MTIME ($FILE)
# -------------
# Return the mtime of $FILE.  Missing files, or `-' standing for STDIN
# or STDOUT are ``obsolete'', i.e., as old as possible.
sub mtime ($)
{
  my ($file) = @_;

  return 0
    if $file eq '-' || ! -f $file;

  my $stat = stat ($file)
    or croak "$me: cannot stat $file: $!\n";

  return $stat->mtime;
}


# @RES
# uniq (@LIST)
# ------------
# Return LIST with no duplicates.
sub uniq (@)
{
   my @res = ();
   my %seen = ();
   foreach my $item (@_)
     {
       if (! exists $seen{$item})
	 {
	   $seen{$item} = 1;
	   push (@res, $item);
	 }
     }
   return wantarray ? @res : "@res";
}


# &update_file ($FROM, $TO)
# -------------------------
# Rename $FROM as $TO, preserving $TO timestamp if it has not changed.
# Recognize `$TO = -' standing for stdin.
sub update_file ($$)
{
  my ($from, $to) = @_;
  my $SIMPLE_BACKUP_SUFFIX = $ENV{'SIMPLE_BACKUP_SUFFIX'} || '~';
  use File::Compare;
  use File::Copy;

  if ($to eq '-')
    {
      my $in = new IO::File ("$from");
      my $out = new IO::File (">-");
      while ($_ = $in->getline)
	{
	  print $out $_;
	}
      $in->close;
      unlink ($from)
	or die "$me: cannot not remove $from: $!\n";
      return;
    }

  if (-f "$to" && compare ("$from", "$to") == 0)
    {
      # File didn't change, so don't update its mod time.
      print STDERR "$me: `$to' is unchanged\n";
      return
    }

  if (-f "$to")
    {
      # Back up and install the new one.
      move ("$to",  "$to$SIMPLE_BACKUP_SUFFIX")
	or die "$me: cannot not backup $to: $!\n";
      move ("$from", "$to")
	or die "$me: cannot not rename $from as $to: $!\n";
      print STDERR "$me: `$to' is updated\n";
    }
  else
    {
      move ("$from", "$to")
	or die "$me: cannot not rename $from as $to: $!\n";
      print STDERR "$me: `$to' is created\n";
    }
}


# verbose(@MESSAGE)
# -----------------
sub verbose (@)
{
  print STDERR "$me: ", @_, "\n"
    if $verbose;
}


# xsystem ($COMMAND)
# ------------------
sub xsystem ($)
{
  my ($command) = @_;

  verbose "running: $command";

  (system $command) == 0
    or croak ("$me: "
	      . (split (' ', $command))[0]
	      . " failed with exit status: "
	      . ($? >> 8)
	      . "\n");
}


1; # for require
