package File::Path;

=head1 NAME

File::Path - create or remove directory trees

=head1 SYNOPSIS

    use File::Path;

    mkpath(['/foo/bar/baz', 'blurfl/quux'], 1, 0711);
    rmtree(['foo/bar/baz', 'blurfl/quux'], 1, 1);

=head1 DESCRIPTION

The C<mkpath> function provides a convenient way to create directories, even
if your C<mkdir> kernel call won't create more than one level of directory at
a time.  C<mkpath> takes three arguments:

=over 4

=item *

the name of the path to create, or a reference
to a list of paths to create,

=item *

a boolean value, which if TRUE will cause C<mkpath>
to print the name of each directory as it is created
(defaults to FALSE), and

=item *

the numeric mode to use when creating the directories
(defaults to 0777), to be modified by the current umask.

=back

It returns a list of all directories (including intermediates, determined
using the Unix '/' separator) created.

If a system error prevents a directory from being created, then the
C<mkpath> function throws a fatal error with C<Carp::croak>. This error
can be trapped with an C<eval> block:

  eval { mkpath($dir) };
  if ($@) {
    print "Couldn't create $dir: $@";
  }

Similarly, the C<rmtree> function provides a convenient way to delete a
subtree from the directory structure, much like the Unix command C<rm -r>.
C<rmtree> takes three arguments:

=over 4

=item *

the root of the subtree to delete, or a reference to
a list of roots.  All of the files and directories
below each root, as well as the roots themselves,
will be deleted.

=item *

a boolean value, which if TRUE will cause C<rmtree> to
print a message each time it examines a file, giving the
name of the file, and indicating whether it's using C<rmdir>
or C<unlink> to remove it, or that it's skipping it.
(defaults to FALSE)

=item *

a boolean value, which if TRUE will cause C<rmtree> to
skip any files to which you do not have delete access
(if running under VMS) or write access (if running
under another OS).  This will change in the future when
a criterion for 'delete permission' under OSs other
than VMS is settled.  (defaults to FALSE)

=back

It returns the number of files successfully deleted.  Symlinks are
simply deleted and not followed.

B<NOTE:> There are race conditions internal to the implementation of
C<rmtree> making it unsafe to use on directory trees which may be
altered or moved while C<rmtree> is running, and in particular on any
directory trees with any path components or subdirectories potentially
writable by untrusted users.

Additionally, if the third parameter is not TRUE and C<rmtree> is
interrupted, it may leave files and directories with permissions altered
to allow deletion (and older versions of this module would even set
files and directories to world-read/writable!)

Note also that the occurrence of errors in C<rmtree> can be determined I<only>
by trapping diagnostic messages using C<$SIG{__WARN__}>; it is not apparent
from the return value.

=head1 DIAGNOSTICS

=over 4

=item *

On Windows, if C<mkpath> gives you the warning: B<No such file or
directory>, this may mean that you've exceeded your filesystem's
maximum path length.

=back

=head1 AUTHORS

Tim Bunce <F<Tim.Bunce@ig.co.uk>> and
Charles Bailey <F<bailey@newman.upenn.edu>>

=cut

use 5.006;
use Carp;
use File::Basename ();
use Exporter ();
use strict;
use warnings;

our $VERSION = "1.08";
our @ISA = qw( Exporter );
our @EXPORT = qw( mkpath rmtree );

my $Is_VMS = $^O eq 'VMS';
my $Is_MacOS = $^O eq 'MacOS';

# These OSes complain if you want to remove a file that you have no
# write permission to:
my $force_writeable = ($^O eq 'os2' || $^O eq 'dos' || $^O eq 'MSWin32' ||
		       $^O eq 'amigaos' || $^O eq 'MacOS' || $^O eq 'epoc');

sub mkpath {
    my($paths, $verbose, $mode) = @_;
    # $paths   -- either a path string or ref to list of paths
    # $verbose -- optional print "mkdir $path" for each directory created
    # $mode    -- optional permissions, defaults to 0777
    local($")=$Is_MacOS ? ":" : "/";
    $mode = 0777 unless defined($mode);
    $paths = [$paths] unless ref $paths;
    my(@created,$path);
    foreach $path (@$paths) {
	$path .= '/' if $^O eq 'os2' and $path =~ /^\w:\z/s; # feature of CRT 
	# Logic wants Unix paths, so go with the flow.
	if ($Is_VMS) {
	    next if $path eq '/';
	    $path = VMS::Filespec::unixify($path);
	    if ($path =~ m:^(/[^/]+)/?\z:) {
	        $path = $1.'/000000';
	    }
	}
	next if -d $path;
	my $parent = File::Basename::dirname($path);
	unless (-d $parent or $path eq $parent) {
	    push(@created,mkpath($parent, $verbose, $mode));
 	}
	print "mkdir $path\n" if $verbose;
	unless (mkdir($path,$mode)) {
	    my $e = $!;
	    # allow for another process to have created it meanwhile
	    $! = $e, croak ("mkdir $path: $e") unless -d $path;
	}
	push(@created, $path);
    }
    @created;
}

sub rmtree {
    my($roots, $verbose, $safe) = @_;
    my(@files);
    my($count) = 0;
    $verbose ||= 0;
    $safe ||= 0;

    if ( defined($roots) && length($roots) ) {
      $roots = [$roots] unless ref $roots;
    }
    else {
      carp "No root path(s) specified\n";
      return 0;
    }

    my($root);
    foreach $root (@{$roots}) {
    	if ($Is_MacOS) {
	    $root = ":$root" if $root !~ /:/;
	    $root =~ s#([^:])\z#$1:#;
	} else {
	    $root =~ s#/\z##;
	}
	(undef, undef, my $rp) = lstat $root or next;
	$rp &= 07777;	# don't forget setuid, setgid, sticky bits
	if ( -d _ ) {
	    # notabene: 0700 is for making readable in the first place,
	    # it's also intended to change it to writable in case we have
	    # to recurse in which case we are better than rm -rf for 
	    # subtrees with strange permissions
	    chmod($rp | 0700, ($Is_VMS ? VMS::Filespec::fileify($root) : $root))
	      or carp "Can't make directory $root read+writeable: $!"
		unless $safe;

	    if (opendir my $d, $root) {
		no strict 'refs';
		if (!defined ${"\cTAINT"} or ${"\cTAINT"}) {
		    # Blindly untaint dir names
		    @files = map { /^(.*)$/s ; $1 } readdir $d;
		} else {
		    @files = readdir $d;
		}
		closedir $d;
	    }
	    else {
	        carp "Can't read $root: $!";
		@files = ();
	    }

	    # Deleting large numbers of files from VMS Files-11 filesystems
	    # is faster if done in reverse ASCIIbetical order 
	    @files = reverse @files if $Is_VMS;
	    ($root = VMS::Filespec::unixify($root)) =~ s#\.dir\z## if $Is_VMS;
	    if ($Is_MacOS) {
		@files = map("$root$_", @files);
	    } else {
		@files = map("$root/$_", grep $_!~/^\.{1,2}\z/s,@files);
	    }
	    $count += rmtree(\@files,$verbose,$safe);
	    if ($safe &&
		($Is_VMS ? !&VMS::Filespec::candelete($root) : !-w $root)) {
		print "skipped $root\n" if $verbose;
		next;
	    }
	    chmod $rp | 0700, $root
	      or carp "Can't make directory $root writeable: $!"
		if $force_writeable;
	    print "rmdir $root\n" if $verbose;
	    if (rmdir $root) {
		++$count;
	    }
	    else {
		carp "Can't remove directory $root: $!";
		chmod($rp, ($Is_VMS ? VMS::Filespec::fileify($root) : $root))
		    or carp("and can't restore permissions to "
		            . sprintf("0%o",$rp) . "\n");
	    }
	}
	else { 
	    if ($safe &&
		($Is_VMS ? !&VMS::Filespec::candelete($root)
		         : !(-l $root || -w $root)))
	    {
		print "skipped $root\n" if $verbose;
		next;
	    }
	    chmod $rp | 0600, $root
	      or carp "Can't make file $root writeable: $!"
		if $force_writeable;
	    print "unlink $root\n" if $verbose;
	    # delete all versions under VMS
	    for (;;) {
		unless (unlink $root) {
		    carp "Can't unlink file $root: $!";
		    if ($force_writeable) {
			chmod $rp, $root
			    or carp("and can't restore permissions to "
			            . sprintf("0%o",$rp) . "\n");
		    }
		    last;
		}
		++$count;
		last unless $Is_VMS && lstat $root;
	    }
	}
    }

    $count;
}

1;
