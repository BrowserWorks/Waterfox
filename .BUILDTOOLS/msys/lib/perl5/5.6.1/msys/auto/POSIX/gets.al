# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 322 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/gets.al)"
sub gets {
    usage "gets()" if @_ != 0;
    scalar <STDIN>;
}

# end of POSIX::gets
1;
