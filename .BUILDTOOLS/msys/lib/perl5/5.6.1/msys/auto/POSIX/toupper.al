# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 95 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/toupper.al)"
sub toupper {
    usage "toupper(string)" if @_ != 1;
    uc($_[0]);
}

# end of POSIX::toupper
1;
