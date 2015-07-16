# $Id: URI.pm,v 2.108 2004/06/09 21:45:24 abigail Exp $

package Regexp::Common::URI;

use strict;
local $^W = 1;

use Exporter ();
use vars qw /$VERSION @EXPORT_OK @ISA/;

@ISA       = qw /Exporter/;
@EXPORT_OK = qw /register_uri/;

use Regexp::Common qw /pattern clean no_defaults/;

# Use 'require' here, not 'use', so we delay running them after we are compiled.
# We also do it using an 'eval'; this saves us from have repeated similar
# lines. The eval is further explained in 'perldoc -f require'.
my @uris = qw /fax file ftp gopher http pop prospero news tel telnet tv wais/;
foreach my $uri (@uris) {
    eval "require Regexp::Common::URI::$uri";
    die $@ if $@;
}

($VERSION) = q $Revision: 2.108 $ =~ /[\d.]+/g;

my %uris;

sub register_uri {
    my ($scheme, $uri) = @_;
    $uris {$scheme} = $uri;
}

pattern name    => [qw (URI)],
        create  => sub {my $uri =  join '|' => values %uris;
                           $uri =~ s/\(\?k:/(?:/g;
                      "(?k:$uri)";
        },
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::URI -- provide patterns for URIs.

=head1 SYNOPSIS

    use Regexp::Common qw /URI/;

    while (<>) {
        /$RE{URI}{HTTP}/       and  print "Contains an HTTP URI.\n";
    }

=head1 DESCRIPTION

Patterns for the following URIs are supported: fax, file, FTP, gopher,
HTTP, news, NTTP, pop, prospero, tel, telnet, tv and WAIS.
Each is documented in the I<Regexp::Common::URI::B<scheme>>,
manual page, for the appropriate scheme (in lowercase), except for
I<NNTP> URIs which are found in I<Regexp::Common::URI::news>.

=head2 C<$RE{URI}>

Return a pattern that recognizes any of the supported URIs. With
C<{-keep}>, only the entire URI is returned (in C<$1>).

=head1 REFERENCES

=over 4

=item B<[DRAFT-URI-TV]>

Zigmond, D. and Vickers, M: I<Uniform Resource Identifiers for
Television Broadcasts>. December 2000.

=item B<[DRAFT-URL-FTP]>

Casey, James: I<A FTP URL Format>. November 1996.

=item B<[RFC 1035]>

Mockapetris, P.: I<DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION>.
November 1987.

=item B<[RFC 1738]>

Berners-Lee, Tim, Masinter, L., McCahill, M.: I<Uniform Resource
Locators (URL)>. December 1994.

=item B<[RFC 2396]>

Berners-Lee, Tim, Fielding, R., and Masinter, L.: I<Uniform Resource
Identifiers (URI): Generic Syntax>. August 1998.

=item B<[RFC 2616]>

Fielding, R., Gettys, J., Mogul, J., Frystyk, H., Masinter, L., 
Leach, P. and Berners-Lee, Tim: I<Hypertext Transfer Protocol -- HTTP/1.1>.
June 1999.

=item B<[RFC 2806]>

Vaha-Sipila, A.: I<URLs for Telephone Calls>. April 2000.

=back

=head1 HISTORY

 $Log: URI.pm,v $
 Revision 2.108  2004/06/09 21:45:24  abigail
 POD

 Revision 2.107  2003/03/25 23:20:30  abigail
 pop and prospero URIs

 Revision 2.106  2003/03/12 22:28:57  abigail
 WAIS URIs

 Revision 2.105  2003/02/21 14:49:41  abigail
 Gopher added

 Revision 2.104  2003/02/11 14:10:25  abigail
 Changed 'nntp' to 'NNTP'

 Revision 2.103  2003/02/10 21:18:07  abigail
 Move most of the code into separate files. One file per URI, and
 one file per RFC.

 Revision 2.102  2003/02/07 15:24:17  abigail
 telnet URIs

 Revision 2.101  2003/02/01 22:55:31  abigail
 Changed Copyright years

 Revision 2.100  2003/01/21 23:19:40  abigail
 The whole world understands RCS/CVS version numbers, that 1.9 is an
 older version than 1.10. Except CPAN. Curse the idiot(s) who think
 that version numbers are floats (in which universe do floats have
 more than one decimal dot?).
 Everything is bumped to version 2.100 because CPAN couldn't deal
 with the fact one file had version 1.10.

 Revision 1.11  2003/01/21 22:59:33  abigail
 Fixed small errors with  and

 Revision 1.10  2003/01/17 13:17:15  abigail
 Fixed '$toplabel' and '$domainlabel'; they were both subexpressions
 of the form: A|AB. Which passed the tests because most tests anchor
 the regex at the beginning and end.

 Revision 1.9  2003/01/01 23:00:54  abigail
 TV URIs

 Revision 1.8  2002/08/27 16:56:27  abigail
 Support for fax URIs.

 Revision 1.7  2002/08/06 14:44:07  abigail
 Local phone numbers can have future extensions as well.

 Revision 1.6  2002/08/06 13:18:03  abigail
 Cosmetic changes

 Revision 1.5  2002/08/06 13:16:27  abigail
 Added $RE{URI}{tel}{nofuture}

 Revision 1.4  2002/08/06 00:03:30  abigail
 Added $RE{URI}{tel}

 Revision 1.3  2002/08/04 22:51:35  abigail
 Added FTP URIs.

 Revision 1.2  2002/07/25 22:37:44  abigail
 Added 'use strict'.
 Added 'no_defaults' to 'use Regex::Common' to prevent loading of all
 defaults.

 Revision 1.1  2002/07/25 19:56:07  abigail
 Modularizing Regexp::Common.

=head1 SEE ALSO

L<Regexp::Common> for a general description of how to use this interface.

=head1 AUTHOR

Damian Conway (damian@conway.org)

=head1 MAINTAINANCE

This package is maintained by Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

For a start, there are many common regexes missing.
Send them in to I<regexp-common@abigail.nl>.

=head1 COPYRIGHT

     Copyright (c) 2001 - 2003, Damian Conway. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
