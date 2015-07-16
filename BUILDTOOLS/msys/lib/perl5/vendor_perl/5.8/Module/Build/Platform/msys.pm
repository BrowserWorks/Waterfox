package Module::Build::Platform::msys;

use strict;
use Module::Build::Platform::Unix;

use vars qw(@ISA);
@ISA = qw(Module::Build::Platform::Unix);

sub manpage_separator {
   '.'
}

1;
__END__


=head1 NAME

Module::Build::Platform::msys - Builder class for Msys platform

=head1 DESCRIPTION

This module provides some routines very specific to the msys
platform.

Please see the L<Module::Build> for the general docs.

=head1 AUTHOR

Initial stub by Yitzchak Scott-Thoennes <sthoenna@efn.org>

=head1 SEE ALSO

perl(1), Module::Build(3), ExtUtils::MakeMaker(3)

=cut
