# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 430 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/exit.al)"
sub exit {
    usage "exit(status)" if @_ != 1;
    CORE::exit($_[0]);
}

# end of POSIX::exit
1;
