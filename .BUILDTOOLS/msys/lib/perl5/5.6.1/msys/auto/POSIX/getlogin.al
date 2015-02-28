# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 693 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/getlogin.al)"
sub getlogin {
    usage "getlogin()" if @_ != 0;
    CORE::getlogin();
}

# end of POSIX::getlogin
1;
