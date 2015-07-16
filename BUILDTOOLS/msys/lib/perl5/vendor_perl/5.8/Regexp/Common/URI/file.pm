# $Id: file.pm,v 2.100 2003/02/10 21:06:39 abigail Exp $

package Regexp::Common::URI::file;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC1738 qw /$host $fpath/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $scheme = 'file';
my $uri    = "(?k:(?k:$scheme)://(?k:(?k:(?:$host|localhost)?)" .
             "(?k:/(?k:$fpath))))";

register_uri $scheme => $uri;

pattern name    => [qw (URI file)],
        create  => $uri,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::file -- Returns a pattern for file URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{file}/       and  print "Contains a file URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{file}

Returns a pattern that matches I<file> URIs, as defined by RFC 1738.
File URIs have the form:

    "file:" "//" [ host | "localhost" ] "/" fpath

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The scheme.

=item $3

The part of the URI following "file://".

=item $4

The hostname.

=item $5

The path name, including the leading slash.

=item $6

The path name, without the leading slash.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 1738]>

Berners-Lee, Tim, Masinter, L., McCahill, M.: I<Uniform Resource
Locators (URL)>. December 1994.

=back

=head1 HISTORY

 $Log: file.pm,v $
 Revision 2.100  2003/02/10 21:06:39  abigail
 file URI


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
