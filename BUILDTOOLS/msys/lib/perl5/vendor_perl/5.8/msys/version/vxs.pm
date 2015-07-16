#!perl -w
package version::vxs;

use 5.005_03;
use strict;

require DynaLoader;
use vars qw(@ISA $VERSION $CLASS );

@ISA = qw(DynaLoader);

$VERSION = 0.7203;

$CLASS = 'version::vxs';

local $^W; # shut up the 'redefined' warning for UNIVERSAL::VERSION
bootstrap version::vxs if $] < 5.009;

# Preloaded methods go here.

1;
