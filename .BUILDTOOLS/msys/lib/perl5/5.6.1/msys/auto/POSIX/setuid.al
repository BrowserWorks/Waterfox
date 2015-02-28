# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 742 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/setuid.al)"
sub setuid {
    usage "setuid(uid)" if @_ != 1;
    $< = $_[0];
}

# end of POSIX::setuid
1;
