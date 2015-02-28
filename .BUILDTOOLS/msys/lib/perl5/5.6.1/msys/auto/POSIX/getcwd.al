# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 658 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/getcwd.al)"
sub getcwd
{
    usage "getcwd()" if @_ != 0;
    if ($^O eq 'MSWin32') {
	# this perhaps applies to everyone else also?
	require Cwd;
	$cwd = &Cwd::cwd;
    }
    else {
	chop($cwd = `pwd`);
    }
    $cwd;
}

# end of POSIX::getcwd
1;
