# $Id: telnet.pm,v 2.100 2003/02/10 21:06:43 abigail Exp $

package Regexp::Common::URI::telnet;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC1738 qw /$user $password $host $port/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $telnet_uri = "(?k:(?k:telnet)://(?:(?k:(?k:$user)(?::(?k:$password))?)\@)?" 
               . "(?k:(?k:$host)(?::(?k:$port))?)(?k:/)?)";

register_uri telnet => $telnet_uri;

pattern name    => [qw (URI telnet)],
        create  => $telnet_uri,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::telnet -- Returns a pattern for telnet URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{telnet}/       and  print "Contains a telnet URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{telnet}

Returns a pattern that matches I<telnet> URIs, as defined by RFC 1738.
Telnet URIs have the form:

    "telnet:" "//" [ user [ ":" password ] "@" ] host [ ":" port ] [ "/" ]

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The scheme.

=item $3

The username:password combo, or just the username if there is no password.

=item $4

The username, if given.

=item $5

The password, if given.

=item $6

The host:port combo, or just the host if there's no port.

=item $7

The host.

=item $8

The port, if given.

=item $9

The trailing slash, if any.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 1738]>

Berners-Lee, Tim, Masinter, L., McCahill, M.: I<Uniform Resource
Locators (URL)>. December 1994.

=back

=head1 HISTORY

 $Log: telnet.pm,v $
 Revision 2.100  2003/02/10 21:06:43  abigail
 telnet URI


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
