package ExtUtils::MakeMaker::Config;

$VERSION = '0.02';

use strict;
use Config ();

# Give us an overridable config.
use vars qw(%Config);
%Config = %Config::Config;

sub import {
    my $caller = caller;

    no strict 'refs';
    *{$caller.'::Config'} = \%Config;
}

1;


=head1 NAME

ExtUtils::MakeMaker::Config - Wrapper around Config.pm


=head1 SYNOPSIS

  use ExtUtils::MakeMaker::Config;
  print $Config{installbin};  # or whatever


=head1 DESCRIPTION

B<FOR INTERNAL USE ONLY>

A very thin wrapper around Config.pm so MakeMaker is easier to test.

=cut
