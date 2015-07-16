# $Id: http.pm,v 2.101 2004/06/09 21:42:48 abigail Exp $

package Regexp::Common::URI::http;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC2396 qw /$host $port $path_segments $query/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.101 $ =~ /[\d.]+/g;

my $http_uri = "(?k:(?k:http)://(?k:$host)(?::(?k:$port))?"           .
               "(?k:/(?k:(?k:$path_segments)(?:[?](?k:$query))?))?)";

register_uri HTTP => $http_uri;

pattern name    => [qw (URI HTTP), "-scheme=http"],
        create  => sub {
            my $scheme =  $_ [1] -> {-scheme};
            my $uri    =  $http_uri;
               $uri    =~ s/http/$scheme/;
            $uri;
        }
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::http -- Returns a pattern for HTTP URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{HTTP}/       and  print "Contains an HTTP URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{HTTP}{-scheme}

Provides a regex for an HTTP URI as defined by RFC 2396 (generic syntax)
and RFC 2616 (HTTP).

If C<< -scheme => I<P> >> is specified the pattern I<P> is used as the scheme.
By default I<P> is C<qr/http/>. C<https> and C<https?> are reasonable
alternatives.

The syntax for an HTTP URI is:

    "http:" "//" host [ ":" port ] [ "/" path [ "?" query ]]

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The entire URI.

=item $2

The scheme.

=item $3

The host (name or address).

=item $4

The port (if any).

=item $5

The absolute path, including the query and leading slash.

=item $6

The absolute path, including the query, without the leading slash.

=item $7

The absolute path, without the query or leading slash.

=item $8

The query, without the question mark.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 2396]>

Berners-Lee, Tim, Fielding, R., and Masinter, L.: I<Uniform Resource
Identifiers (URI): Generic Syntax>. August 1998.

=item B<[RFC 2616]>

Fielding, R., Gettys, J., Mogul, J., Frystyk, H., Masinter, L., 
Leach, P. and Berners-Lee, Tim: I<Hypertext Transfer Protocol -- HTTP/1.1>.
June 1999.

=back

=head1 HISTORY

 $Log: http.pm,v $
 Revision 2.101  2004/06/09 21:42:48  abigail
 POD nits

 Revision 2.100  2003/02/10 21:06:41  abigail
 http URI


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
