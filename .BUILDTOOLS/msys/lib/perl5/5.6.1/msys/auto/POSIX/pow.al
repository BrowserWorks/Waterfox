# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 173 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/pow.al)"
sub pow {
    usage "pow(x,exponent)" if @_ != 2;
    $_[0] ** $_[1];
}

# end of POSIX::pow
1;
