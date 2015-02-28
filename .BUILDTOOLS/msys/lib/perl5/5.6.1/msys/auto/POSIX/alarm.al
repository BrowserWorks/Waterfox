# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 614 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/alarm.al)"
sub alarm {
    usage "alarm(seconds)" if @_ != 1;
    CORE::alarm($_[0]);
}

# end of POSIX::alarm
1;
