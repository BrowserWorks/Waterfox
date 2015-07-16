package ExtUtils::MY;

use strict;
require ExtUtils::MM;

use vars qw(@ISA $VERSION);
$VERSION = 0.01;
@ISA = qw(ExtUtils::MM);

{
    package MY;
    use vars qw(@ISA);
    @ISA = qw(ExtUtils::MY);
}

sub DESTROY {}


=head1 NAME

ExtUtils::MY - ExtUtils::MakeMaker subclass for customization

=head1 SYNOPSIS

  # in your Makefile.PL
  sub MY::whatever {
      ...
  }

=head1 DESCRIPTION

B<FOR INTERNAL USE ONLY>

ExtUtils::MY is a subclass of ExtUtils::MM.  Its provided in your
Makefile.PL for you to add and override MakeMaker functionality.

It also provides a convenient alias via the MY class.

ExtUtils::MY might turn out to be a temporary solution, but MY won't
go away.

=cut
