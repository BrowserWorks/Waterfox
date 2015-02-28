package File::Find;
use strict;
use warnings;
use 5.6.0;
our $VERSION = '1.01';
require Exporter;
require Cwd;

=head1 NAME

find - traverse a file tree

finddepth - traverse a directory structure depth-first

=head1 SYNOPSIS

    use File::Find;
    find(\&wanted, '/foo', '/bar');
    sub wanted { ... }

    use File::Find;
    finddepth(\&wanted, '/foo', '/bar');
    sub wanted { ... }

    use File::Find;
    find({ wanted => \&process, follow => 1 }, '.');

=head1 DESCRIPTION

The first argument to find() is either a hash reference describing the
operations to be performed for each file, or a code reference.

Here are the possible keys for the hash:

=over 3

=item C<wanted>

The value should be a code reference.  This code reference is called
I<the wanted() function> below.

=item C<bydepth>

Reports the name of a directory only AFTER all its entries
have been reported.  Entry point finddepth() is a shortcut for
specifying C<{ bydepth => 1 }> in the first argument of find().

=item C<preprocess>

The value should be a code reference. This code reference is used to 
preprocess the current directory. The name of currently processed 
directory is in $File::Find::dir. Your preprocessing function is 
called after readdir() but before the loop that calls the wanted() 
function. It is called with a list of strings (actually file/directory 
names) and is expected to return a list of strings. The code can be 
used to sort the file/directory names alphabetically, numerically, 
or to filter out directory entries based on their name alone. When 
I<follow> or I<follow_fast> are in effect, C<preprocess> is a no-op.

=item C<postprocess>

The value should be a code reference. It is invoked just before leaving 
the currently processed directory. It is called in void context with no 
arguments. The name of the current directory is in $File::Find::dir. This 
hook is handy for summarizing a directory, such as calculating its disk 
usage. When I<follow> or I<follow_fast> are in effect, C<postprocess> is a 
no-op.

=item C<follow>

Causes symbolic links to be followed. Since directory trees with symbolic
links (followed) may contain files more than once and may even have
cycles, a hash has to be built up with an entry for each file.
This might be expensive both in space and time for a large
directory tree. See I<follow_fast> and I<follow_skip> below.
If either I<follow> or I<follow_fast> is in effect:

=over 6

=item *

It is guaranteed that an I<lstat> has been called before the user's
I<wanted()> function is called. This enables fast file checks involving S< _>.

=item *

There is a variable C<$File::Find::fullname> which holds the absolute
pathname of the file with all symbolic links resolved

=back

=item C<follow_fast>

This is similar to I<follow> except that it may report some files more
than once.  It does detect cycles, however.  Since only symbolic links
have to be hashed, this is much cheaper both in space and time.  If
processing a file more than once (by the user's I<wanted()> function)
is worse than just taking time, the option I<follow> should be used.

=item C<follow_skip>

C<follow_skip==1>, which is the default, causes all files which are
neither directories nor symbolic links to be ignored if they are about
to be processed a second time. If a directory or a symbolic link 
are about to be processed a second time, File::Find dies.
C<follow_skip==0> causes File::Find to die if any file is about to be
processed a second time.
C<follow_skip==2> causes File::Find to ignore any duplicate files and
directories but to proceed normally otherwise.

=item C<dangling_symlinks>

If true and a code reference, will be called with the symbolic link
name and the directory it lives in as arguments.  Otherwise, if true
and warnings are on, warning "symbolic_link_name is a dangling
symbolic link\n" will be issued.  If false, the dangling symbolic link
will be silently ignored.

=item C<no_chdir>

Does not C<chdir()> to each directory as it recurses. The wanted()
function will need to be aware of this, of course. In this case,
C<$_> will be the same as C<$File::Find::name>.

=item C<untaint>

If find is used in taint-mode (-T command line switch or if EUID != UID
or if EGID != GID) then internally directory names have to be untainted
before they can be chdir'ed to. Therefore they are checked against a regular
expression I<untaint_pattern>.  Note that all names passed to the user's 
I<wanted()> function are still tainted. If this option is used while 
not in taint-mode, C<untaint> is a no-op.

=item C<untaint_pattern>

See above. This should be set using the C<qr> quoting operator.
The default is set to  C<qr|^([-+@\w./]+)$|>. 
Note that the parantheses are vital.

=item C<untaint_skip>

If set, a directory which fails the I<untaint_pattern> is skipped, 
including all its sub-directories. The default is to 'die' in such a case.

=back

The wanted() function does whatever verifications you want.
C<$File::Find::dir> contains the current directory name, and C<$_> the
current filename within that directory.  C<$File::Find::name> contains
the complete pathname to the file. You are chdir()'d to
C<$File::Find::dir> when the function is called, unless C<no_chdir>
was specified.  When C<follow> or C<follow_fast> are in effect, there is
also a C<$File::Find::fullname>.  The function may set
C<$File::Find::prune> to prune the tree unless C<bydepth> was
specified.  Unless C<follow> or C<follow_fast> is specified, for
compatibility reasons (find.pl, find2perl) there are in addition the
following globals available: C<$File::Find::topdir>,
C<$File::Find::topdev>, C<$File::Find::topino>,
C<$File::Find::topmode> and C<$File::Find::topnlink>.

This library is useful for the C<find2perl> tool, which when fed,

    find2perl / -name .nfs\* -mtime +7 \
        -exec rm -f {} \; -o -fstype nfs -prune

produces something like:

    sub wanted {
        /^\.nfs.*\z/s &&
        (($dev, $ino, $mode, $nlink, $uid, $gid) = lstat($_)) &&
        int(-M _) > 7 &&
        unlink($_)
        ||
        ($nlink || (($dev, $ino, $mode, $nlink, $uid, $gid) = lstat($_))) &&
        $dev < 0 &&
        ($File::Find::prune = 1);
    }

Set the variable C<$File::Find::dont_use_nlink> if you're using AFS,
since AFS cheats.


Here's another interesting wanted function.  It will find all symlinks
that don't resolve:

    sub wanted {
         -l && !-e && print "bogus link: $File::Find::name\n";
    }

See also the script C<pfind> on CPAN for a nice application of this
module.

=head1 CAVEAT

Be aware that the option to follow symbolic links can be dangerous.
Depending on the structure of the directory tree (including symbolic
links to directories) you might traverse a given (physical) directory
more than once (only if C<follow_fast> is in effect). 
Furthermore, deleting or changing files in a symbolically linked directory
might cause very unpleasant surprises, since you delete or change files
in an unknown directory.

=head1 NOTES

=over 4

=item *

Mac OS (Classic) users should note a few differences:

=over 4

=item *   

The path separator is ':', not '/', and the current directory is denoted 
as ':', not '.'. You should be careful about specifying relative pathnames. 
While a full path always begins with a volume name, a relative pathname 
should always begin with a ':'.  If specifying a volume name only, a 
trailing ':' is required.

=item *   

C<$File::Find::dir> is guaranteed to end with a ':'. If C<$_> 
contains the name of a directory, that name may or may not end with a 
':'. Likewise, C<$File::Find::name>, which contains the complete 
pathname to that directory, and C<$File::Find::fullname>, which holds 
the absolute pathname of that directory with all symbolic links resolved,
may or may not end with a ':'.

=item *   

The default C<untaint_pattern> (see above) on Mac OS is set to  
C<qr|^(.+)$|>. Note that the parentheses are vital.

=item *   

The invisible system file "Icon\015" is ignored. While this file may 
appear in every directory, there are some more invisible system files 
on every volume, which are all located at the volume root level (i.e. 
"MacintoshHD:"). These system files are B<not> excluded automatically. 
Your filter may use the following code to recognize invisible files or 
directories (requires Mac::Files):

 use Mac::Files;

 # invisible() --  returns 1 if file/directory is invisible,  
 # 0 if it's visible or undef if an error occured

 sub invisible($) { 
   my $file = shift;
   my ($fileCat, $fileInfo); 
   my $invisible_flag =  1 << 14; 

   if ( $fileCat = FSpGetCatInfo($file) ) {
     if ($fileInfo = $fileCat->ioFlFndrInfo() ) {
       return (($fileInfo->fdFlags & $invisible_flag) && 1);
     }
   }
   return undef;
 }

Generally, invisible files are system files, unless an odd application 
decides to use invisible files for its own purposes. To distinguish 
such files from system files, you have to look at the B<type> and B<creator> 
file attributes. The MacPerl built-in functions C<GetFileInfo(FILE)> and 
C<SetFileInfo(CREATOR, TYPE, FILES)> offer access to these attributes 
(see MacPerl.pm for details).

Files that appear on the desktop actually reside in an (hidden) directory
named "Desktop Folder" on the particular disk volume. Note that, although
all desktop files appear to be on the same "virtual" desktop, each disk 
volume actually maintains its own "Desktop Folder" directory.

=back

=back

=head1 HISTORY

File::Find used to produce incorrect results if called recursively.
During the development of perl 5.8 this bug was fixed.
The first fixed version of File::Find was 1.01.

=cut

our @ISA = qw(Exporter);
our @EXPORT = qw(find finddepth);


use strict;
my $Is_VMS;
my $Is_MacOS;

require File::Basename;
require File::Spec;

# Should ideally be my() not our() but local() currently
# refuses to operate on lexicals

our %SLnkSeen;
our ($wanted_callback, $avoid_nlink, $bydepth, $no_chdir, $follow,
    $follow_skip, $full_check, $untaint, $untaint_skip, $untaint_pat,
    $pre_process, $post_process, $dangling_symlinks);

sub contract_name {
    my ($cdir,$fn) = @_;

    return substr($cdir,0,rindex($cdir,'/')) if $fn eq $File::Find::current_dir;

    $cdir = substr($cdir,0,rindex($cdir,'/')+1);

    $fn =~ s|^\./||;

    my $abs_name= $cdir . $fn;

    if (substr($fn,0,3) eq '../') {
       1 while $abs_name =~ s!/[^/]*/\.\./!/!;
    }

    return $abs_name;
}

# return the absolute name of a directory or file
sub contract_name_Mac {
    my ($cdir,$fn) = @_; 
    my $abs_name;

    if ($fn =~ /^(:+)(.*)$/) { # valid pathname starting with a ':'

	my $colon_count = length ($1);
	if ($colon_count == 1) {
	    $abs_name = $cdir . $2;
	    return $abs_name;
	}
	else { 
	    # need to move up the tree, but 
	    # only if it's not a volume name
	    for (my $i=1; $i<$colon_count; $i++) {
		unless ($cdir =~ /^[^:]+:$/) { # volume name
		    $cdir =~ s/[^:]+:$//;
		}
		else {
		    return undef;
		}
	    }
	    $abs_name = $cdir . $2;
	    return $abs_name;
	}

    }
    else {

	# $fn may be a valid path to a directory or file or (dangling)
	# symlink, without a leading ':'
	if ( (-e $fn) || (-l $fn) ) {
	    if ($fn =~ /^[^:]+:/) { # a volume name like DataHD:*
		return $fn; # $fn is already an absolute path
	    }
	    else {
		$abs_name = $cdir . $fn;
		return $abs_name;
	    }
	}
	else { # argh!, $fn is not a valid directory/file 
	     return undef;
	}
    }
}

sub PathCombine($$) {
    my ($Base,$Name) = @_;
    my $AbsName;

    if ($Is_MacOS) {
	# $Name is the resolved symlink (always a full path on MacOS),
	# i.e. there's no need to call contract_name_Mac()
	$AbsName = $Name; 

	# (simple) check for recursion
	if ( ( $Base =~ /^$AbsName/) && (-d $AbsName) ) { # recursion
	    return undef;
	}
    }
    else {
	if (substr($Name,0,1) eq '/') {
	    $AbsName= $Name;
	}
	else {
	    $AbsName= contract_name($Base,$Name);
	}

	# (simple) check for recursion
	my $newlen= length($AbsName);
	if ($newlen <= length($Base)) {
	    if (($newlen == length($Base) || substr($Base,$newlen,1) eq '/')
		&& $AbsName eq substr($Base,0,$newlen))
	    {
		return undef;
	    }
	}
    }
    return $AbsName;
}

sub Follow_SymLink($) {
    my ($AbsName) = @_;

    my ($NewName,$DEV, $INO);
    ($DEV, $INO)= lstat $AbsName;

    while (-l _) {
	if ($SLnkSeen{$DEV, $INO}++) {
	    if ($follow_skip < 2) {
		die "$AbsName is encountered a second time";
	    }
	    else {
		return undef;
	    }
	}
	$NewName= PathCombine($AbsName, readlink($AbsName));
	unless(defined $NewName) {
	    if ($follow_skip < 2) {
		die "$AbsName is a recursive symbolic link";
	    }
	    else {
		return undef;
	    }
	}
	else {
	    $AbsName= $NewName;
	}
	($DEV, $INO) = lstat($AbsName);
	return undef unless defined $DEV;  #  dangling symbolic link
    }

    if ($full_check && $SLnkSeen{$DEV, $INO}++) {
	if ( ($follow_skip < 1) || ((-d _) && ($follow_skip < 2)) ) {
	    die "$AbsName encountered a second time";
	}
	else {
	    return undef;
	}
    }

    return $AbsName;
}

our($dir, $name, $fullname, $prune);
sub _find_dir_symlnk($$$);
sub _find_dir($$$);

# check whether or not a scalar variable is tainted
# (code straight from the Camel, 3rd ed., page 561)
sub is_tainted_pp {
    my $arg = shift;
    my $nada = substr($arg, 0, 0); # zero-length
    local $@;
    eval { eval "# $nada" };
    return length($@) != 0;
} 

sub _find_opt {
    my $wanted = shift;
    die "invalid top directory" unless defined $_[0];

    # This function must local()ize everything because callbacks may
    # call find() or finddepth()

    local %SLnkSeen;
    local ($wanted_callback, $avoid_nlink, $bydepth, $no_chdir, $follow,
	$follow_skip, $full_check, $untaint, $untaint_skip, $untaint_pat,
	$pre_process, $post_process, $dangling_symlinks);
    local($dir, $name, $fullname, $prune);

    my $cwd            = $wanted->{bydepth} ? Cwd::fastcwd() : Cwd::cwd();
    my $cwd_untainted  = $cwd;
    my $check_t_cwd    = 1;
    $wanted_callback   = $wanted->{wanted};
    $bydepth           = $wanted->{bydepth};
    $pre_process       = $wanted->{preprocess};
    $post_process      = $wanted->{postprocess};
    $no_chdir          = $wanted->{no_chdir};
    $full_check        = $wanted->{follow};
    $follow            = $full_check || $wanted->{follow_fast};
    $follow_skip       = $wanted->{follow_skip};
    $untaint           = $wanted->{untaint};
    $untaint_pat       = $wanted->{untaint_pattern};
    $untaint_skip      = $wanted->{untaint_skip};
    $dangling_symlinks = $wanted->{dangling_symlinks};

    # for compatability reasons (find.pl, find2perl)
    local our ($topdir, $topdev, $topino, $topmode, $topnlink);

    # a symbolic link to a directory doesn't increase the link count
    $avoid_nlink      = $follow || $File::Find::dont_use_nlink;
    
    my ($abs_dir, $Is_Dir);

    Proc_Top_Item:
    foreach my $TOP (@_) {
	my $top_item = $TOP;

	if ($Is_MacOS) {
	    ($topdev,$topino,$topmode,$topnlink) = $follow ? stat $top_item : lstat $top_item;
	    $top_item = ":$top_item"
		if ( (-d _) && ( $top_item !~ /:/ ) );
	}
	else {
	    $top_item =~ s|/\z|| unless $top_item eq '/';
	    ($topdev,$topino,$topmode,$topnlink) = $follow ? stat $top_item : lstat $top_item;
	}

	$Is_Dir= 0;

	if ($follow) {

	    if ($Is_MacOS) {
		$cwd = "$cwd:" unless ($cwd =~ /:$/); # for safety

		if ($top_item eq $File::Find::current_dir) {
		    $abs_dir = $cwd;
		}
		else {
		    $abs_dir = contract_name_Mac($cwd, $top_item);
		    unless (defined $abs_dir) {
			warn "Can't determine absolute path for $top_item (No such file or directory)\n" if $^W;
			next Proc_Top_Item;
		    }
		}

	    }
	    else {
		if (substr($top_item,0,1) eq '/') {
		    $abs_dir = $top_item;
		}
		elsif ($top_item eq $File::Find::current_dir) {
		    $abs_dir = $cwd;
		}
		else {  # care about any  ../
		    $abs_dir = contract_name("$cwd/",$top_item);
		}
	    }
	    $abs_dir= Follow_SymLink($abs_dir);
	    unless (defined $abs_dir) {
		if ($dangling_symlinks) {
		    if (ref $dangling_symlinks eq 'CODE') {
			$dangling_symlinks->($top_item, $cwd);
		    } else {
			warn "$top_item is a dangling symbolic link\n" if $^W;
		    }
		}
		next Proc_Top_Item;
	    }

	    if (-d _) {
		_find_dir_symlnk($wanted, $abs_dir, $top_item);
		$Is_Dir= 1;
	    }
	}
	else { # no follow
	    $topdir = $top_item;
	    unless (defined $topnlink) {
		warn "Can't stat $top_item: $!\n" if $^W;
		next Proc_Top_Item;
	    }
	    if (-d _) {
		$top_item =~ s/\.dir\z// if $Is_VMS;
		_find_dir($wanted, $top_item, $topnlink);
		$Is_Dir= 1;
	    }
	    else {
		$abs_dir= $top_item;
	    }
	}

	unless ($Is_Dir) {
	    unless (($_,$dir) = File::Basename::fileparse($abs_dir)) {
		if ($Is_MacOS) {
		    ($dir,$_) = (':', $top_item); # $File::Find::dir, $_
		}
		else {
		    ($dir,$_) = ('./', $top_item);
		}
	    }

	    $abs_dir = $dir;
	    if (( $untaint ) && (is_tainted($dir) )) {
		( $abs_dir ) = $dir =~ m|$untaint_pat|;
		unless (defined $abs_dir) {
		    if ($untaint_skip == 0) {
			die "directory $dir is still tainted";
		    }
		    else {
			next Proc_Top_Item;
		    }
		}
	    }

	    unless ($no_chdir || chdir $abs_dir) {
		warn "Couldn't chdir $abs_dir: $!\n" if $^W;
		next Proc_Top_Item;
	    }

	    $name = $abs_dir . $_; # $File::Find::name

	    { &$wanted_callback }; # protect against wild "next"

	}

	unless ( $no_chdir ) {
	    if ( ($check_t_cwd) && (($untaint) && (is_tainted($cwd) )) ) {
		( $cwd_untainted ) = $cwd =~ m|$untaint_pat|;
		unless (defined $cwd_untainted) {
		    die "insecure cwd in find(depth)";
		}
		$check_t_cwd = 0;
	    }
	    unless (chdir $cwd_untainted) {
		die "Can't cd to $cwd: $!\n";
	    }
	}
    }
}

# API:
#  $wanted
#  $p_dir :  "parent directory"
#  $nlink :  what came back from the stat
# preconditions:
#  chdir (if not no_chdir) to dir

sub _find_dir($$$) {
    my ($wanted, $p_dir, $nlink) = @_;
    my ($CdLvl,$Level) = (0,0);
    my @Stack;
    my @filenames;
    my ($subcount,$sub_nlink);
    my $SE= [];
    my $dir_name= $p_dir;
    my $dir_pref;
    my $dir_rel;
    my $tainted = 0;

    if ($Is_MacOS) {
	$dir_pref= ($p_dir =~ /:$/) ? $p_dir : "$p_dir:"; # preface
	$dir_rel= ':'; # directory name relative to current directory
    }
    else {
	$dir_pref= ( $p_dir eq '/' ? '/' : "$p_dir/" );
	$dir_rel= '.'; # directory name relative to current directory
    }

    local ($dir, $name, $prune, *DIR);

    unless ( $no_chdir || ($p_dir eq $File::Find::current_dir)) {
	my $udir = $p_dir;
	if (( $untaint ) && (is_tainted($p_dir) )) {
	    ( $udir ) = $p_dir =~ m|$untaint_pat|;
	    unless (defined $udir) {
		if ($untaint_skip == 0) {
		    die "directory $p_dir is still tainted";
		}
		else {
		    return;
		}
	    }
	}
	unless (chdir $udir) {
	    warn "Can't cd to $udir: $!\n" if $^W;
	    return;
	}
    }

    # push the starting directory
    push @Stack,[$CdLvl,$p_dir,$dir_rel,-1]  if  $bydepth;

    if ($Is_MacOS) {
	$p_dir = $dir_pref;  # ensure trailing ':'
    }

    while (defined $SE) {
	unless ($bydepth) {
	    $dir= $p_dir; # $File::Find::dir 
	    $name= $dir_name; # $File::Find::name 
	    $_= ($no_chdir ? $dir_name : $dir_rel ); # $_
	    # prune may happen here
	    $prune= 0;
	    { &$wanted_callback };	# protect against wild "next"
	    next if $prune;
	}

	# change to that directory
	unless ($no_chdir || ($dir_rel eq $File::Find::current_dir)) {
	    my $udir= $dir_rel;
	    if ( ($untaint) && (($tainted) || ($tainted = is_tainted($dir_rel) )) ) {
		( $udir ) = $dir_rel =~ m|$untaint_pat|;
		unless (defined $udir) {
		    if ($untaint_skip == 0) {
			if ($Is_MacOS) {
			    die "directory ($p_dir) $dir_rel is still tainted";
			}
			else {
			    die "directory (" . ($p_dir ne '/' ? $p_dir : '') . "/) $dir_rel is still tainted";
			}
		    } else { # $untaint_skip == 1
			next; 
		    }
		}
	    }
	    unless (chdir $udir) {
		if ($Is_MacOS) {
		    warn "Can't cd to ($p_dir) $udir: $!\n" if $^W;
		}
		else {
		    warn "Can't cd to (" . ($p_dir ne '/' ? $p_dir : '') . "/) $udir: $!\n" if $^W;
		}
		next;
	    }
	    $CdLvl++;
	}

	if ($Is_MacOS) {
	    $dir_name = "$dir_name:" unless ($dir_name =~ /:$/);
	}

	$dir= $dir_name; # $File::Find::dir 

	# Get the list of files in the current directory.
	unless (opendir DIR, ($no_chdir ? $dir_name : $File::Find::current_dir)) {
	    warn "Can't opendir($dir_name): $!\n" if $^W;
	    next;
	}
	@filenames = readdir DIR;
	closedir(DIR);
	@filenames = &$pre_process(@filenames) if $pre_process;
	push @Stack,[$CdLvl,$dir_name,"",-2]   if $post_process;

	if ($nlink == 2 && !$avoid_nlink) {
	    # This dir has no subdirectories.
	    for my $FN (@filenames) {
		next if $FN =~ $File::Find::skip_pattern;
		
		$name = $dir_pref . $FN; # $File::Find::name
		$_ = ($no_chdir ? $name : $FN); # $_
		{ &$wanted_callback }; # protect against wild "next"
	    }

	}
	else {
	    # This dir has subdirectories.
	    $subcount = $nlink - 2;

	    for my $FN (@filenames) {
		next if $FN =~ $File::Find::skip_pattern;
		if ($subcount > 0 || $avoid_nlink) {
		    # Seen all the subdirs?
		    # check for directoriness.
		    # stat is faster for a file in the current directory
		    $sub_nlink = (lstat ($no_chdir ? $dir_pref . $FN : $FN))[3];

		    if (-d _) {
			--$subcount;
			$FN =~ s/\.dir\z// if $Is_VMS;
			push @Stack,[$CdLvl,$dir_name,$FN,$sub_nlink];
		    }
		    else {
			$name = $dir_pref . $FN; # $File::Find::name
			$_= ($no_chdir ? $name : $FN); # $_
			{ &$wanted_callback }; # protect against wild "next"
		    }
		}
		else {
		    $name = $dir_pref . $FN; # $File::Find::name
		    $_= ($no_chdir ? $name : $FN); # $_
		    { &$wanted_callback }; # protect against wild "next"
		}
	    }
	}
    }
    continue {
	while ( defined ($SE = pop @Stack) ) {
	    ($Level, $p_dir, $dir_rel, $nlink) = @$SE;
	    if ($CdLvl > $Level && !$no_chdir) {
		my $tmp;
		if ($Is_MacOS) {
		    $tmp = (':' x ($CdLvl-$Level)) . ':';
		}
		else {
		    $tmp = join('/',('..') x ($CdLvl-$Level));
		}
		die "Can't cd to $dir_name" . $tmp
		    unless chdir ($tmp);
		$CdLvl = $Level;
	    }

	    if ($Is_MacOS) {
		# $pdir always has a trailing ':', except for the starting dir,
		# where $dir_rel eq ':'
		$dir_name = "$p_dir$dir_rel";
		$dir_pref = "$dir_name:";
	    }
	    else {
		$dir_name = ($p_dir eq '/' ? "/$dir_rel" : "$p_dir/$dir_rel");
		$dir_pref = "$dir_name/";
	    }

	    if ( $nlink == -2 ) {
		$name = $dir = $p_dir; # $File::Find::name / dir
		if ($Is_MacOS) {
		    $_ = ':'; # $_
		}
		else {
		    $_ = '.';
		}
		&$post_process;		# End-of-directory processing
	    }
	    elsif ( $nlink < 0 ) {  # must be finddepth, report dirname now
		$name = $dir_name;
		if ($Is_MacOS) {
		    if ($dir_rel eq ':') { # must be the top dir, where we started
			$name =~ s|:$||; # $File::Find::name
			$p_dir = "$p_dir:" unless ($p_dir =~ /:$/);
		    }
		    $dir = $p_dir; # $File::Find::dir
		    $_ = ($no_chdir ? $name : $dir_rel); # $_
		}
		else {
		    if ( substr($name,-2) eq '/.' ) {
			$name =~ s|/\.$||;
		    }
		    $dir = $p_dir;
		    $_ = ($no_chdir ? $dir_name : $dir_rel );
		    if ( substr($_,-2) eq '/.' ) {
			s|/\.$||;
		    }
		}
		{ &$wanted_callback }; # protect against wild "next"
	     }
	     else {
		push @Stack,[$CdLvl,$p_dir,$dir_rel,-1]  if  $bydepth;
		last;
	    }
	}
    }
}


# API:
#  $wanted
#  $dir_loc : absolute location of a dir
#  $p_dir   : "parent directory"
# preconditions:
#  chdir (if not no_chdir) to dir

sub _find_dir_symlnk($$$) {
    my ($wanted, $dir_loc, $p_dir) = @_; # $dir_loc is the absolute directory
    my @Stack;
    my @filenames;
    my $new_loc;
    my $updir_loc = $dir_loc; # untainted parent directory
    my $SE = [];
    my $dir_name = $p_dir;
    my $dir_pref;
    my $loc_pref;
    my $dir_rel;
    my $byd_flag; # flag for pending stack entry if $bydepth
    my $tainted = 0;
    my $ok = 1;

    if ($Is_MacOS) {
	$dir_pref = ($p_dir =~ /:$/) ? "$p_dir" : "$p_dir:";
	$loc_pref = ($dir_loc =~ /:$/) ? "$dir_loc" : "$dir_loc:";
	$dir_rel  = ':'; # directory name relative to current directory
    } else {
	$dir_pref = ( $p_dir   eq '/' ? '/' : "$p_dir/" );
	$loc_pref = ( $dir_loc eq '/' ? '/' : "$dir_loc/" );
	$dir_rel  = '.'; # directory name relative to current directory
    }

    local ($dir, $name, $fullname, $prune, *DIR);

    unless ($no_chdir) {
	# untaint the topdir
	if (( $untaint ) && (is_tainted($dir_loc) )) {
	    ( $updir_loc ) = $dir_loc =~ m|$untaint_pat|; # parent dir, now untainted
	     # once untainted, $updir_loc is pushed on the stack (as parent directory);
	    # hence, we don't need to untaint the parent directory every time we chdir 
	    # to it later 
	    unless (defined $updir_loc) {
		if ($untaint_skip == 0) {
		    die "directory $dir_loc is still tainted";
		}
		else {
		    return;
		}
	    }
	}
	$ok = chdir($updir_loc) unless ($p_dir eq $File::Find::current_dir);
	unless ($ok) {
	    warn "Can't cd to $updir_loc: $!\n" if $^W;
	    return;
	}
    }

    push @Stack,[$dir_loc,$updir_loc,$p_dir,$dir_rel,-1]  if  $bydepth;

    if ($Is_MacOS) {
	$p_dir = $dir_pref; # ensure trailing ':'
    }

    while (defined $SE) {

	unless ($bydepth) {
	    # change (back) to parent directory (always untainted)
	    unless ($no_chdir) {
		unless (chdir $updir_loc) {
		    warn "Can't cd to $updir_loc: $!\n" if $^W;
		    next;
		}
	    }
	    $dir= $p_dir; # $File::Find::dir
	    $name= $dir_name; # $File::Find::name
	    $_= ($no_chdir ? $dir_name : $dir_rel ); # $_
	    $fullname= $dir_loc; # $File::Find::fullname
	    # prune may happen here
	    $prune= 0;
	    lstat($_); # make sure  file tests with '_' work
	    { &$wanted_callback }; # protect against wild "next"
	    next if $prune;
	}

	# change to that directory
	unless ($no_chdir || ($dir_rel eq $File::Find::current_dir)) {
	    $updir_loc = $dir_loc;
	    if ( ($untaint) && (($tainted) || ($tainted = is_tainted($dir_loc) )) ) {
		# untaint $dir_loc, what will be pushed on the stack as (untainted) parent dir 
		( $updir_loc ) = $dir_loc =~ m|$untaint_pat|;
		unless (defined $updir_loc) {
		    if ($untaint_skip == 0) {
			die "directory $dir_loc is still tainted";
		    }
		    else {
			next;
		    }
		}
	    }
	    unless (chdir $updir_loc) {
		warn "Can't cd to $updir_loc: $!\n" if $^W;
		next;
	    }
	}

	if ($Is_MacOS) {
	    $dir_name = "$dir_name:" unless ($dir_name =~ /:$/);
	}

	$dir = $dir_name; # $File::Find::dir

	# Get the list of files in the current directory.
	unless (opendir DIR, ($no_chdir ? $dir_loc : $File::Find::current_dir)) {
	    warn "Can't opendir($dir_loc): $!\n" if $^W;
	    next;
	}
	@filenames = readdir DIR;
	closedir(DIR);

	for my $FN (@filenames) {
	    next if $FN =~ $File::Find::skip_pattern;

	    # follow symbolic links / do an lstat
	    $new_loc = Follow_SymLink($loc_pref.$FN);

	    # ignore if invalid symlink
	    next unless defined $new_loc;

	    if (-d _) {
		push @Stack,[$new_loc,$updir_loc,$dir_name,$FN,1];
	    }
	    else {
		$fullname = $new_loc; # $File::Find::fullname 
		$name = $dir_pref . $FN; # $File::Find::name
		$_ = ($no_chdir ? $name : $FN); # $_
		{ &$wanted_callback }; # protect against wild "next"
	    }
	}

    }
    continue {
	while (defined($SE = pop @Stack)) {
	    ($dir_loc, $updir_loc, $p_dir, $dir_rel, $byd_flag) = @$SE;
	    if ($Is_MacOS) {
		# $p_dir always has a trailing ':', except for the starting dir,
		# where $dir_rel eq ':'
		$dir_name = "$p_dir$dir_rel";
		$dir_pref = "$dir_name:";
		$loc_pref = ($dir_loc =~ /:$/) ? $dir_loc : "$dir_loc:";
	    }
	    else {
		$dir_name = ($p_dir eq '/' ? "/$dir_rel" : "$p_dir/$dir_rel");
		$dir_pref = "$dir_name/";
		$loc_pref = "$dir_loc/";
	    }
	    if ( $byd_flag < 0 ) {  # must be finddepth, report dirname now
		unless ($no_chdir || ($dir_rel eq $File::Find::current_dir)) {
		    unless (chdir $updir_loc) { # $updir_loc (parent dir) is always untainted 
			warn "Can't cd to $updir_loc: $!\n" if $^W;
			next;
		    }
		}
		$fullname = $dir_loc; # $File::Find::fullname
		$name = $dir_name; # $File::Find::name
		if ($Is_MacOS) {
		    if ($dir_rel eq ':') { # must be the top dir, where we started
			$name =~ s|:$||; # $File::Find::name
			$p_dir = "$p_dir:" unless ($p_dir =~ /:$/);
		    }
		    $dir = $p_dir; # $File::Find::dir
		     $_ = ($no_chdir ? $name : $dir_rel); # $_
		}
		else {
		    if ( substr($name,-2) eq '/.' ) {
			$name =~ s|/\.$||; # $File::Find::name
		    }
		    $dir = $p_dir; # $File::Find::dir
		    $_ = ($no_chdir ? $dir_name : $dir_rel); # $_
		    if ( substr($_,-2) eq '/.' ) {
			s|/\.$||;
		    }
		}

		lstat($_); # make sure file tests with '_' work
		{ &$wanted_callback }; # protect against wild "next"
	    }
	    else {
		push @Stack,[$dir_loc, $updir_loc, $p_dir, $dir_rel,-1]  if  $bydepth;
		last;
	    }
	}
    }
}


sub wrap_wanted {
    my $wanted = shift;
    if ( ref($wanted) eq 'HASH' ) {
	if ( $wanted->{follow} || $wanted->{follow_fast}) {
	    $wanted->{follow_skip} = 1 unless defined $wanted->{follow_skip};
	}
	if ( $wanted->{untaint} ) {
	    $wanted->{untaint_pattern} = $File::Find::untaint_pattern  
		unless defined $wanted->{untaint_pattern};
	    $wanted->{untaint_skip} = 0 unless defined $wanted->{untaint_skip};
	}
	return $wanted;
    }
    else {
	return { wanted => $wanted };
    }
}

sub find {
    my $wanted = shift;
    _find_opt(wrap_wanted($wanted), @_);
}

sub finddepth {
    my $wanted = wrap_wanted(shift);
    $wanted->{bydepth} = 1;
    _find_opt($wanted, @_);
}

# default
$File::Find::skip_pattern    = qr/^\.{1,2}\z/;
$File::Find::untaint_pattern = qr|^([-+@\w./]+)$|;

# These are hard-coded for now, but may move to hint files.
if ($^O eq 'VMS') {
    $Is_VMS = 1;
    $File::Find::dont_use_nlink  = 1;
}
elsif ($^O eq 'MacOS') {
    $Is_MacOS = 1;
    $File::Find::dont_use_nlink  = 1;
    $File::Find::skip_pattern    = qr/^Icon\015\z/;
    $File::Find::untaint_pattern = qr|^(.+)$|;
}

# this _should_ work properly on all platforms
# where File::Find can be expected to work
$File::Find::current_dir = File::Spec->curdir || '.';

$File::Find::dont_use_nlink = 1
    if $^O eq 'os2' || $^O eq 'dos' || $^O eq 'amigaos' || $^O eq 'MSWin32' ||
       $^O eq 'cygwin' || $^O eq 'epoc' || $^O eq 'NetWare' || $^O eq 'msys';

# Set dont_use_nlink in your hint file if your system's stat doesn't
# report the number of links in a directory as an indication
# of the number of files.
# See, e.g. hints/machten.sh for MachTen 2.2.
unless ($File::Find::dont_use_nlink) {
    require Config;
    $File::Find::dont_use_nlink = 1 if ($Config::Config{'dont_use_nlink'});
}

# We need a function that checks if a scalar is tainted. Either use the 
# Scalar::Util module's tainted() function or our (slower) pure Perl 
# fallback is_tainted_pp()
{
    local $@;
    eval { require Scalar::Util };
    *is_tainted = $@ ? \&is_tainted_pp : \&Scalar::Util::tainted;
}

1;
