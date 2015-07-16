# $Id: tv.pm,v 2.100 2003/02/10 21:06:44 abigail Exp $

# TV URLs. 
# Internet draft: draft-zigmond-tv-url-03.txt

package Regexp::Common::URI::tv;

use strict;
local $^W = 1;

use Regexp::Common               qw /pattern clean no_defaults/;
use Regexp::Common::URI          qw /register_uri/;
use Regexp::Common::URI::RFC2396 qw /$hostname/;

use vars qw /$VERSION/;

($VERSION)    = q $Revision: 2.100 $ =~ /[\d.]+/g;

my $tv_scheme = 'tv';
my $tv_url    = "(?k:(?k:$tv_scheme):(?k:$hostname)?)";

register_uri $tv_scheme => $tv_url;

pattern name    => [qw (URI tv)],
        create  => $tv_url,
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::tv -- Returns a pattern for tv URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{tv}/       and  print "Contains a tv URI.\n";
    }

=head1 DESCRIPTION

=head2 C<$RE{URI}{tv}>

Returns a pattern that recognizes TV uris as per an Internet draft
[DRAFT-URI-TV].

Under C<{-keep}>, the following are returned:

=over 4

=item $1

The entire URI.

=item $2

The scheme.

=item $3

The host.

=back

=head1 REFERENCES

=over 4

=item B<[DRAFT-URI-TV]>

Zigmond, D. and Vickers, M: I<Uniform Resource Identifiers for
Television Broadcasts>. December 2000.

=item B<[RFC 2396]>

Berners-Lee, Tim, Fielding, R., and Masinter, L.: I<Uniform Resource
Identifiers (URI): Generic Syntax>. August 1998.

=back

=head1 HISTORY

 $Log: tv.pm,v $
 Revision 2.100  2003/02/10 21:06:44  abigail
 tv URI


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
