# NOTE: Derived from ../../lib/POSIX.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package POSIX;

#line 118 "../../lib/POSIX.pm (autosplit into ../../lib/auto/POSIX/rewinddir.al)"
sub rewinddir {
    usage "rewinddir(dirhandle)" if @_ != 1;
    CORE::rewinddir($_[0]);
}

# end of POSIX::rewinddir
1;
