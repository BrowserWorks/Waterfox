# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 599 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/gmtime.al)"
sub gmtime {
    usage "gmtime(time)" if @_ != 1;
    CORE::gmtime($_[0]);
}

# end of POSIX::gmtime
1;
