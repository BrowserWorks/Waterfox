# $Id: tel.pm,v 2.100 2003/02/10 21:06:42 abigail Exp $

package Regexp::Common::URI::tel;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC2806 qw /$telephone_subscriber 
                                     $telephone_subscriber_no_future/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $tel_scheme  = 'tel';
my $tel_uri     = "(?k:(?k:$tel_scheme):(?k:$telephone_subscriber))";
my $tel_uri_nf  = "(?k:(?k:$tel_scheme):(?k:$telephone_subscriber_no_future))";

register_uri $tel_scheme => $tel_uri;

pattern name    => [qw (URI tel)],
        create  => $tel_uri
        ;

pattern name    => [qw (URI tel nofuture)],
        create  => $tel_uri_nf
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::tel -- Returns a pattern for telephone URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{tel}/       and  print "Contains a telephone URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{tel}

Returns a pattern that matches I<tel> URIs, as defined by RFC 2806.
Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The scheme.

=item $3

The phone number, including any possible add-ons like ISDN subaddress,
a post dial part, area specifier, service provider, etc.

=back

=head2 C<$RE{URI}{tel}{nofuture}>

As above (including what's returned by C<{-keep}>), with the exception
that I<future extensions> are not allowed. Without allowing 
those I<future extensions>, it becomes much easier to check a URI if
the correct syntax for post dial, service provider, phone context,
etc has been used - otherwise the regex could always classify them
as a I<future extension>.

=head1 REFERENCES

=over 4

=item B<[RFC 1035]>

Mockapetris, P.: I<DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION>.
November 1987.

=item B<[RFC 2396]>

Berners-Lee, Tim, Fielding, R., and Masinter, L.: I<Uniform Resource
Identifiers (URI): Generic Syntax>. August 1998.

=item B<[RFC 2806]>

Vaha-Sipila, A.: I<URLs for Telephone Calls>. April 2000.

=back

=head1 HISTORY

 $Log: tel.pm,v $
 Revision 2.100  2003/02/10 21:06:42  abigail
 tel URI


=head1 SEE ALSO

L<Regexp::Common::URI> for other supported URIs.

=head1 AUTHOR

Damian Conway (damian@conway.org)

=head1 MAINTAINANCE

This package is maintained by Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

=head1 COPYRIGHT

     Copyright (c) 2001 - 2003, Damian Conway. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
