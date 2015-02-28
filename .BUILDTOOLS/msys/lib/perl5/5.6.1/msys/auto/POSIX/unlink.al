# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 756 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/unlink.al)"
sub unlink {
    usage "unlink(filename)" if @_ != 1;
    CORE::unlink($_[0]);
}

# end of POSIX::unlink
1;
