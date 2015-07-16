# $Id: news.pm,v 2.100 2003/02/11 14:11:29 abigail Exp $

package Regexp::Common::URI::news;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC1738 qw /$grouppart $group $article
                                     $host $port $digits/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $news_scheme = 'news';
my $news_uri    = "(?k:(?k:$news_scheme):(?k:$grouppart))";

my $nntp_scheme = 'nntp';
my $nntp_uri    = "(?k:(?k:$nntp_scheme)://(?k:(?k:(?k:$host)(?::(?k:$port))?)" 
                . "/(?k:$group)(?:/(?k:$digits))?))";

register_uri $news_scheme => $news_uri;
register_uri $nntp_scheme => $nntp_uri;

pattern name    => [qw (URI news)],
        create  => $news_uri,
        ;

pattern name    => [qw (URI NNTP)],
        create  => $nntp_uri,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::news -- Returns a pattern for file URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{news}/       and  print "Contains a news URI.\n";
    }

=head1 DESCRIPTION

=head2 $RE{URI}{news}

Returns a pattern that matches I<news> URIs, as defined by RFC 1738.
News URIs have the form:

    "news:" ( "*" | group | article "@" host )

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The scheme.

=item $3

The part of the URI following "news://".

=back

=head2 $RE{URI}{NNTP}

Returns a pattern that matches I<NNTP> URIs, as defined by RFC 1738.
NNTP URIs have the form:

    "nntp://" host [ ":" port ] "/" group [ "/" digits ]

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The complete URI.

=item $2

The scheme.

=item $3

The part of the URI following "nntp://".

=item $4

The host and port, separated by a colon. If no port was given, just
the host.

=item $5

The host.

=item $6

The port, if given.

=item $7

The group.

=item $8

The digits, if given.

=back

=head1 REFERENCES

=over 4

=item B<[RFC 1738]>

Berners-Lee, Tim, Masinter, L., McCahill, M.: I<Uniform Resource
Locators (URL)>. December 1994.

=back

=head1 HISTORY

 $Log: news.pm,v $
 Revision 2.100  2003/02/11 14:11:29  abigail
 NNTP and news URIs


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
