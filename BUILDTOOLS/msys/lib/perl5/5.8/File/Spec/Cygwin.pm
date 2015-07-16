package File::Spec::Cygwin;

use strict;
use vars qw(@ISA $VERSION);
require File::Spec::Unix;

$VERSION = '1.1';

@ISA = qw(File::Spec::Unix);

=head1 NAME

File::Spec::Cygwin - methods for Cygwin file specs

=head1 SYNOPSIS

 require File::Spec::Cygwin; # Done internally by File::Spec if needed

=head1 DESCRIPTION

See L<File::Spec> and L<File::Spec::Unix>.  This package overrides the
implementation of these methods, not the semantics.

This module is still in beta.  Cygwin-knowledgeable folks are invited
to offer patches and suggestions.

=cut

=pod

=over 4

=item canonpath

Any C<\> (backslashes) are converted to C</> (forward slashes),
and then File::Spec::Unix canonpath() is called on the result.

=cut

sub canonpath {
    my($self,$path) = @_;
    $path =~ s|\\|/|g;
    return $self->SUPER::canonpath($path);
}

=pod

=item file_name_is_absolute

True is returned if the file name begins with C<drive_letter:>,
and if not, File::Spec::Unix file_name_is_absolute() is called.

=cut


sub file_name_is_absolute {
    my ($self,$file) = @_;
    return 1 if $file =~ m{^([a-z]:)?[\\/]}is; # C:/test
    return $self->SUPER::file_name_is_absolute($file);
}

=item tmpdir (override)

Returns a string representation of the first existing directory
from the following list:

    $ENV{TMPDIR}
    /tmp
    C:/temp

Since Perl 5.8.0, if running under taint mode, and if the environment
variables are tainted, they are not used.

=cut

my $tmpdir;
sub tmpdir {
    return $tmpdir if defined $tmpdir;
    $tmpdir = $_[0]->_tmpdir( $ENV{TMPDIR}, "/tmp", 'C:/temp' );
}

=back

=head1 COPYRIGHT

Copyright (c) 2004 by the Perl 5 Porters.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
