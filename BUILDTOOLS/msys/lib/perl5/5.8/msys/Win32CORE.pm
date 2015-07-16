package Win32CORE;

$VERSION = '0.01';

use strict;
use warnings;
use vars qw($VERSION @ISA);
use base qw(Exporter DynaLoader);
no warnings "redefine";

bootstrap Win32CORE $VERSION;

1;
__END__
=head1 NAME

Win32CORE - Win32 CORE functions

=head1 DESCRIPTION

This library provides the functions marked as [CORE] in L<Win32>. See that
document for usage information.  In cygwin, as of 5.8.6 it is no longer
necessary to use this module; the functions should be available even without
C<use Win32CORE;> or C<-MWin32CORE>.

=cut
