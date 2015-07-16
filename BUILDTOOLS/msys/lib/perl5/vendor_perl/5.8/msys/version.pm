#!perl -w
package version;

use 5.005_04;
use strict;

use vars qw(@ISA $VERSION $CLASS *qv);

$VERSION = 0.7203;

$CLASS = 'version';

eval "use version::vxs $VERSION";
if ( $@ ) { # don't have the XS version installed
    eval "use version::vpp $VERSION"; # don't tempt fate
    die "$@" if ( $@ );
    push @ISA, "version::vpp";
    *version::qv = \&version::vpp::qv;
}
else { # use XS module
    push @ISA, "version::vxs";
    *version::qv = \&version::vxs::qv;
}

# Preloaded methods go here.
sub import {
    my ($class) = shift;
    my $callpkg = caller();
    no strict 'refs';
    
    *{$callpkg."::qv"} = 
	    sub {return bless version::qv(shift), $class }
	unless defined(&{"$callpkg\::qv"});

#    if (@_) { # must have initialization on the use line
#	if ( defined $_[2] ) { # CVS style
#	    $_[0] = version::qv($_[2]);
#	}
#	else {
#	    $_[0] = version->new($_[1]);
#	}
#    }
}

1;
