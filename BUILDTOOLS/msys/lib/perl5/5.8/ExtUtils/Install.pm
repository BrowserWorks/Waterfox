package ExtUtils::Install;

use 5.00503;
use vars qw(@ISA @EXPORT $VERSION);
$VERSION = '1.33';

use Exporter;
use Carp ();
use Config qw(%Config);
@ISA = ('Exporter');
@EXPORT = ('install','uninstall','pm_to_blib', 'install_default');
$Is_VMS     = $^O eq 'VMS';
$Is_MacPerl = $^O eq 'MacOS';

my $Inc_uninstall_warn_handler;

# install relative to here

my $INSTALL_ROOT = $ENV{PERL_INSTALL_ROOT};

use File::Spec;
my $Curdir = File::Spec->curdir;
my $Updir  = File::Spec->updir;


=head1 NAME

ExtUtils::Install - install files from here to there

=head1 SYNOPSIS

  use ExtUtils::Install;

  install({ 'blib/lib' => 'some/install/dir' } );

  uninstall($packlist);

  pm_to_blib({ 'lib/Foo/Bar.pm' => 'blib/lib/Foo/Bar.pm' });


=head1 DESCRIPTION

Handles the installing and uninstalling of perl modules, scripts, man
pages, etc...

Both install() and uninstall() are specific to the way
ExtUtils::MakeMaker handles the installation and deinstallation of
perl modules. They are not designed as general purpose tools.

=head2 Functions

=over 4

=item B<install>

    install(\%from_to);
    install(\%from_to, $verbose, $dont_execute, $uninstall_shadows);

Copies each directory tree of %from_to to its corresponding value
preserving timestamps and permissions.

There are two keys with a special meaning in the hash: "read" and
"write".  These contain packlist files.  After the copying is done,
install() will write the list of target files to $from_to{write}. If
$from_to{read} is given the contents of this file will be merged into
the written file. The read and the written file may be identical, but
on AFS it is quite likely that people are installing to a different
directory than the one where the files later appear.

If $verbose is true, will print out each file removed.  Default is
false.  This is "make install VERBINST=1"

If $dont_execute is true it will only print what it was going to do
without actually doing it.  Default is false.

If $uninstall_shadows is true any differing versions throughout @INC
will be uninstalled.  This is "make install UNINST=1"

=cut

sub install {
    my($from_to,$verbose,$nonono,$inc_uninstall) = @_;
    $verbose ||= 0;
    $nonono  ||= 0;

    use Cwd qw(cwd);
    use ExtUtils::Packlist;
    use File::Basename qw(dirname);
    use File::Copy qw(copy);
    use File::Find qw(find);
    use File::Path qw(mkpath);
    use File::Compare qw(compare);

    my(%from_to) = %$from_to;
    my(%pack, $dir, $warn_permissions);
    my($packlist) = ExtUtils::Packlist->new();
    # -w doesn't work reliably on FAT dirs
    $warn_permissions++ if $^O eq 'MSWin32';
    local(*DIR);
    for (qw/read write/) {
	$pack{$_}=$from_to{$_};
	delete $from_to{$_};
    }
    my($source_dir_or_file);
    foreach $source_dir_or_file (sort keys %from_to) {
	#Check if there are files, and if yes, look if the corresponding
	#target directory is writable for us
	opendir DIR, $source_dir_or_file or next;
	for (readdir DIR) {
	    next if $_ eq $Curdir || $_ eq $Updir || $_ eq ".exists";
            my $targetdir = install_rooted_dir($from_to{$source_dir_or_file});
            mkpath($targetdir) unless $nonono;
	    if (!$nonono && !-w $targetdir) {
		warn "Warning: You do not have permissions to " .
		    "install into $from_to{$source_dir_or_file}"
		    unless $warn_permissions++;
	    }
	}
	closedir DIR;
    }
    my $tmpfile = install_rooted_file($pack{"read"});
    $packlist->read($tmpfile) if (-f $tmpfile);
    my $cwd = cwd();

    MOD_INSTALL: foreach my $source (sort keys %from_to) {
	#copy the tree to the target directory without altering
	#timestamp and permission and remember for the .packlist
	#file. The packlist file contains the absolute paths of the
	#install locations. AFS users may call this a bug. We'll have
	#to reconsider how to add the means to satisfy AFS users also.

	#October 1997: we want to install .pm files into archlib if
	#there are any files in arch. So we depend on having ./blib/arch
	#hardcoded here.

	my $targetroot = install_rooted_dir($from_to{$source});

        my $blib_lib  = File::Spec->catdir('blib', 'lib');
        my $blib_arch = File::Spec->catdir('blib', 'arch');
	if ($source eq $blib_lib and
	    exists $from_to{$blib_arch} and
	    directory_not_empty($blib_arch)) {
	    $targetroot = install_rooted_dir($from_to{$blib_arch});
            print "Files found in $blib_arch: installing files in $blib_lib into architecture dependent library tree\n";
	}

        chdir $source or next;
	find(sub {
	    my ($mode,$size,$atime,$mtime) = (stat)[2,7,8,9];
	    return unless -f _;

            my $origfile = $_;
	    return if $origfile eq ".exists";
	    my $targetdir  = File::Spec->catdir($targetroot, $File::Find::dir);
	    my $targetfile = File::Spec->catfile($targetdir, $origfile);
            my $sourcedir  = File::Spec->catdir($source, $File::Find::dir);
            my $sourcefile = File::Spec->catfile($sourcedir, $origfile);

            my $save_cwd = cwd;
            chdir $cwd;  # in case the target is relative
                         # 5.5.3's File::Find missing no_chdir option.

	    my $diff = 0;
	    if ( -f $targetfile && -s _ == $size) {
		# We have a good chance, we can skip this one
		$diff = compare($sourcefile, $targetfile);
	    } else {
		print "$sourcefile differs\n" if $verbose>1;
		$diff++;
	    }

	    if ($diff){
		if (-f $targetfile){
		    forceunlink($targetfile) unless $nonono;
		} else {
		    mkpath($targetdir,0,0755) unless $nonono;
		    print "mkpath($targetdir,0,0755)\n" if $verbose>1;
		}
		copy($sourcefile, $targetfile) unless $nonono;
		print "Installing $targetfile\n";
		utime($atime,$mtime + $Is_VMS,$targetfile) unless $nonono>1;
		print "utime($atime,$mtime,$targetfile)\n" if $verbose>1;
		$mode = 0444 | ( $mode & 0111 ? 0111 : 0 );
		chmod $mode, $targetfile;
		print "chmod($mode, $targetfile)\n" if $verbose>1;
	    } else {
		print "Skipping $targetfile (unchanged)\n" if $verbose;
	    }

	    if (defined $inc_uninstall) {
		inc_uninstall($sourcefile,$File::Find::dir,$verbose, 
                              $inc_uninstall ? 0 : 1);
	    }

	    # Record the full pathname.
	    $packlist->{$targetfile}++;

            # File::Find can get confused if you chdir in here.
            chdir $save_cwd;

        # File::Find seems to always be Unixy except on MacPerl :(
	}, $Is_MacPerl ? $Curdir : '.' );
	chdir($cwd) or Carp::croak("Couldn't chdir to $cwd: $!");
    }
    if ($pack{'write'}) {
	$dir = install_rooted_dir(dirname($pack{'write'}));
	mkpath($dir,0,0755) unless $nonono;
	print "Writing $pack{'write'}\n";
	$packlist->write(install_rooted_file($pack{'write'})) unless $nonono;
    }
}

sub install_rooted_file {
    if (defined $INSTALL_ROOT) {
	File::Spec->catfile($INSTALL_ROOT, $_[0]);
    } else {
	$_[0];
    }
}


sub install_rooted_dir {
    if (defined $INSTALL_ROOT) {
	File::Spec->catdir($INSTALL_ROOT, $_[0]);
    } else {
	$_[0];
    }
}


sub forceunlink {
    chmod 0666, $_[0];
    unlink $_[0] or Carp::croak("Cannot forceunlink $_[0]: $!")
}


sub directory_not_empty ($) {
  my($dir) = @_;
  my $files = 0;
  find(sub {
	   return if $_ eq ".exists";
	   if (-f) {
	     $File::Find::prune++;
	     $files = 1;
	   }
       }, $dir);
  return $files;
}


=item B<install_default> I<DISCOURAGED>

    install_default();
    install_default($fullext);

Calls install() with arguments to copy a module from blib/ to the
default site installation location.

$fullext is the name of the module converted to a directory
(ie. Foo::Bar would be Foo/Bar).  If $fullext is not specified, it
will attempt to read it from @ARGV.

This is primarily useful for install scripts.

B<NOTE> This function is not really useful because of the hard-coded
install location with no way to control site vs core vs vendor
directories and the strange way in which the module name is given.
Consider its use discouraged.

=cut

sub install_default {
  @_ < 2 or die "install_default should be called with 0 or 1 argument";
  my $FULLEXT = @_ ? shift : $ARGV[0];
  defined $FULLEXT or die "Do not know to where to write install log";
  my $INST_LIB = File::Spec->catdir($Curdir,"blib","lib");
  my $INST_ARCHLIB = File::Spec->catdir($Curdir,"blib","arch");
  my $INST_BIN = File::Spec->catdir($Curdir,'blib','bin');
  my $INST_SCRIPT = File::Spec->catdir($Curdir,'blib','script');
  my $INST_MAN1DIR = File::Spec->catdir($Curdir,'blib','man1');
  my $INST_MAN3DIR = File::Spec->catdir($Curdir,'blib','man3');
  install({
	   read => "$Config{sitearchexp}/auto/$FULLEXT/.packlist",
	   write => "$Config{installsitearch}/auto/$FULLEXT/.packlist",
	   $INST_LIB => (directory_not_empty($INST_ARCHLIB)) ?
			 $Config{installsitearch} :
			 $Config{installsitelib},
	   $INST_ARCHLIB => $Config{installsitearch},
	   $INST_BIN => $Config{installbin} ,
	   $INST_SCRIPT => $Config{installscript},
	   $INST_MAN1DIR => $Config{installman1dir},
	   $INST_MAN3DIR => $Config{installman3dir},
	  },1,0,0);
}


=item B<uninstall>

    uninstall($packlist_file);
    uninstall($packlist_file, $verbose, $dont_execute);

Removes the files listed in a $packlist_file.

If $verbose is true, will print out each file removed.  Default is
false.

If $dont_execute is true it will only print what it was going to do
without actually doing it.  Default is false.

=cut

sub uninstall {
    use ExtUtils::Packlist;
    my($fil,$verbose,$nonono) = @_;
    $verbose ||= 0;
    $nonono  ||= 0;

    die "no packlist file found: $fil" unless -f $fil;
    # my $my_req = $self->catfile(qw(auto ExtUtils Install forceunlink.al));
    # require $my_req; # Hairy, but for the first
    my ($packlist) = ExtUtils::Packlist->new($fil);
    foreach (sort(keys(%$packlist))) {
	chomp;
	print "unlink $_\n" if $verbose;
	forceunlink($_) unless $nonono;
    }
    print "unlink $fil\n" if $verbose;
    forceunlink($fil) unless $nonono;
}

sub inc_uninstall {
    my($filepath,$libdir,$verbose,$nonono) = @_;
    my($dir);
    my $file = (File::Spec->splitpath($filepath))[2];
    my %seen_dir = ();

    my @PERL_ENV_LIB = split $Config{path_sep}, defined $ENV{'PERL5LIB'} 
      ? $ENV{'PERL5LIB'} : $ENV{'PERLLIB'} || '';

    foreach $dir (@INC, @PERL_ENV_LIB, @Config{qw(archlibexp
						  privlibexp
						  sitearchexp
						  sitelibexp)}) {
	next if $dir eq $Curdir;
	next if $seen_dir{$dir}++;
	my($targetfile) = File::Spec->catfile($dir,$libdir,$file);
	next unless -f $targetfile;

	# The reason why we compare file's contents is, that we cannot
	# know, which is the file we just installed (AFS). So we leave
	# an identical file in place
	my $diff = 0;
	if ( -f $targetfile && -s _ == -s $filepath) {
	    # We have a good chance, we can skip this one
	    $diff = compare($filepath,$targetfile);
	} else {
	    print "#$file and $targetfile differ\n" if $verbose>1;
	    $diff++;
	}

	next unless $diff;
	if ($nonono) {
	    if ($verbose) {
		$Inc_uninstall_warn_handler ||= new ExtUtils::Install::Warn;
		$libdir =~ s|^\./||s ; # That's just cosmetics, no need to port. It looks prettier.
		$Inc_uninstall_warn_handler->add(
                                     File::Spec->catfile($libdir, $file),
                                     $targetfile
                                    );
	    }
	    # if not verbose, we just say nothing
	} else {
	    print "Unlinking $targetfile (shadowing?)\n";
	    forceunlink($targetfile);
	}
    }
}

sub run_filter {
    my ($cmd, $src, $dest) = @_;
    local(*CMD, *SRC);
    open(CMD, "|$cmd >$dest") || die "Cannot fork: $!";
    open(SRC, $src)           || die "Cannot open $src: $!";
    my $buf;
    my $sz = 1024;
    while (my $len = sysread(SRC, $buf, $sz)) {
	syswrite(CMD, $buf, $len);
    }
    close SRC;
    close CMD or die "Filter command '$cmd' failed for $src";
}


=item B<pm_to_blib>

    pm_to_blib(\%from_to, $autosplit_dir);
    pm_to_blib(\%from_to, $autosplit_dir, $filter_cmd);

Copies each key of %from_to to its corresponding value efficiently.
Filenames with the extension .pm are autosplit into the $autosplit_dir.
Any destination directories are created.

$filter_cmd is an optional shell command to run each .pm file through
prior to splitting and copying.  Input is the contents of the module,
output the new module contents.

You can have an environment variable PERL_INSTALL_ROOT set which will
be prepended as a directory to each installed file (and directory).

=cut

sub pm_to_blib {
    my($fromto,$autodir,$pm_filter) = @_;

    use File::Basename qw(dirname);
    use File::Copy qw(copy);
    use File::Path qw(mkpath);
    use File::Compare qw(compare);
    use AutoSplit;

    mkpath($autodir,0,0755);
    while(my($from, $to) = each %$fromto) {
	if( -f $to && -s $from == -s $to && -M $to < -M $from ) {
            print "Skip $to (unchanged)\n";
            next;
        }

	# When a pm_filter is defined, we need to pre-process the source first
	# to determine whether it has changed or not.  Therefore, only perform
	# the comparison check when there's no filter to be ran.
	#    -- RAM, 03/01/2001

	my $need_filtering = defined $pm_filter && length $pm_filter && 
                             $from =~ /\.pm$/;

	if (!$need_filtering && 0 == compare($from,$to)) {
	    print "Skip $to (unchanged)\n";
	    next;
	}
	if (-f $to){
	    forceunlink($to);
	} else {
	    mkpath(dirname($to),0,0755);
	}
	if ($need_filtering) {
	    run_filter($pm_filter, $from, $to);
	    print "$pm_filter <$from >$to\n";
	} else {
	    copy($from,$to);
	    print "cp $from $to\n";
	}
	my($mode,$atime,$mtime) = (stat $from)[2,8,9];
	utime($atime,$mtime+$Is_VMS,$to);
	chmod(0444 | ( $mode & 0111 ? 0111 : 0 ),$to);
	next unless $from =~ /\.pm$/;
	_autosplit($to,$autodir);
    }
}


=begin _private

=item _autosplit

From 1.0307 back, AutoSplit will sometimes leave an open filehandle to
the file being split.  This causes problems on systems with mandatory
locking (ie. Windows).  So we wrap it and close the filehandle.

=end _private

=cut

sub _autosplit {
    my $retval = autosplit(@_);
    close *AutoSplit::IN if defined *AutoSplit::IN{IO};

    return $retval;
}


package ExtUtils::Install::Warn;

sub new { bless {}, shift }

sub add {
    my($self,$file,$targetfile) = @_;
    push @{$self->{$file}}, $targetfile;
}

sub DESTROY {
    unless(defined $INSTALL_ROOT) {
        my $self = shift;
        my($file,$i,$plural);
        foreach $file (sort keys %$self) {
            $plural = @{$self->{$file}} > 1 ? "s" : "";
            print "## Differing version$plural of $file found. You might like to\n";
            for (0..$#{$self->{$file}}) {
                print "rm ", $self->{$file}[$_], "\n";
                $i++;
            }
        }
        $plural = $i>1 ? "all those files" : "this file";
        print "## Running 'make install UNINST=1' will unlink $plural for you.\n";
    }
}

=back


=head1 ENVIRONMENT

=over 4

=item B<PERL_INSTALL_ROOT>

Will be prepended to each install path.

=back

=head1 AUTHOR

Original author lost in the mists of time.  Probably the same as Makemaker.

Currently maintained by Michael G Schwern C<schwern@pobox.com>

Send patches and ideas to C<makemaker@perl.org>.

Send bug reports via http://rt.cpan.org/.  Please send your
generated Makefile along with your report.

For more up-to-date information, see L<http://www.makemaker.org>.


=head1 LICENSE

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>


=cut

1;
