# $Id: prospero.pm,v 2.100 2003/03/25 23:10:44 abigail Exp $

package Regexp::Common::URI::prospero;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC1738 qw /$host $port $ppath $fieldname $fieldvalue
                                     $fieldspec/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $scheme = 'prospero';
my $uri    = "(?k:(?k:$scheme)://(?k:$host)(?::(?k:$port))?" .
             "/(?k:$ppath)(?k:$fieldspec*))";

register_uri $scheme => $uri;

pattern name    => [qw (URI prospero)],
        create  => $uri,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::prospero -- Returns a pattern for prospero URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{prospero}/ and print "Contains a prospero URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{prospero}

Returns a pattern that matches I<prospero> URIs, as defined by RFC 1738.
prospero URIs have the form:

    "prospero:" "//" host [ ":" port ] "/" path [ fieldspec ] *

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The I<scheme>.

=item $3

The I<hostname>.

=item $4

The I<port>, if given.

=item $5

The propero path.

=item $6

The field specifications, if given. There can be more field specifications;
they will all be returned in C<$6>.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 1738]>

Berners-Lee, Tim, Masinter, L., McCahill, M.: I<Uniform Resource
Locators (URL)>. December 1994.

=back

=head1 HISTORY

 $Log: prospero.pm,v $
 Revision 2.100  2003/03/25 23:10:44  abigail
 prospero URIs


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
