# $Id: pop.pm,v 2.100 2003/03/25 23:10:23 abigail Exp $

package Regexp::Common::URI::pop;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC1738 qw /$host $port/;
use Regexp::Common::URI::RFC2384 qw /$enc_user $enc_auth_type/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $scheme = "pop";
my $uri    = "(?k:(?k:$scheme)://(?:(?k:$enc_user)"     .  
             "(?:;AUTH=(?k:[*]|$enc_auth_type))?\@)?"   .
             "(?k:$host)(?::(?k:$port))?)";

register_uri $scheme => $uri;

pattern name    => [qw (URI POP)],
        create  => $uri,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::pop -- Returns a pattern for POP URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{POP}/       and  print "Contains a POP URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{POP}

Returns a pattern that matches I<POP> URIs, as defined by RFC 2384.
POP URIs have the form:

    "pop:" "//" [ user [ ";AUTH" ( "*" | auth_type ) ] "@" ]
                  host [ ":" port ]

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The I<scheme>.

=item $3

The I<user>, if given.

=item $4

The I<authentication type>, if given (could be a I<*>).

=item $5

The I<host>.

=item $6

The I<port>, if given.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 2384]>

Gellens, R.: I<POP URL Scheme>. August 1998.

=back

=head1 HISTORY

 $Log: pop.pm,v $
 Revision 2.100  2003/03/25 23:10:23  abigail
 POP URIs


=head1 SEE ALSO

L<Regexp::Common::URI> for other supported URIs.

=head1 AUTHOR

Abigail. (I<regexp-common@abigail.nl>).

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

=head1 COPYRIGHT

   Copyright (c) 2003, Damian Conway and Abigail. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
