# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 624 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/chown.al)"
sub chown {
    usage "chown(filename, uid, gid)" if @_ != 3;
    CORE::chown($_[0], $_[1], $_[2]);
}

# end of POSIX::chown
1;
