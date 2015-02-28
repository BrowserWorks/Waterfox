# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 677 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/geteuid.al)"
sub geteuid {
    usage "geteuid()" if @_ != 0;
    $> + 0;
}

# end of POSIX::geteuid
1;
