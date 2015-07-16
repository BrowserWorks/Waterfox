# $Id: RFC2384.pm,v 2.102 2004/12/15 08:15:35 abigail Exp $

package Regexp::Common::URI::RFC2384;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;
use Regexp::Common::URI::RFC1738 qw /$unreserved_range $escape $hostport/;

use vars qw /$VERSION @EXPORT @EXPORT_OK %EXPORT_TAGS @ISA/;

use Exporter ();
@ISA = qw /Exporter/;

($VERSION) = q $Revision: 2.102 $ =~ /[\d.]+/g;

my %vars;

BEGIN {
    $vars {low}     = [qw /$achar_range $achar $achars $achar_more/];
    $vars {connect} = [qw /$enc_sasl $enc_user $enc_ext $enc_auth_type $auth
                           $user_auth $server/];
    $vars {parts}   = [qw /$pop_url/];
}

use vars map {@$_} values %vars;

@EXPORT      = qw /$host/;
@EXPORT_OK   = map {@$_} values %vars;
%EXPORT_TAGS = (%vars, ALL => [@EXPORT_OK]);

# RFC 2384, POP3.

# Lowlevel definitions.
$achar_range       =  "$unreserved_range&=~";
$achar             =  "(?:[$achar_range]|$escape)";
$achars            =  "(?:(?:[$achar_range]+|$escape)*)";
$achar_more        =  "(?:(?:[$achar_range]+|$escape)+)";
$enc_sasl          =  $achar_more;
$enc_user          =  $achar_more;
$enc_ext           =  "(?:[+](?:APOP|$achar_more))";
$enc_auth_type     =  "(?:$enc_sasl|$enc_ext)";
$auth              =  "(?:;AUTH=(?:[*]|$enc_auth_type))";
$user_auth         =  "(?:$enc_user$auth?)";
$server            =  "(?:(?:$user_auth\@)?$hostport)";
$pop_url           =  "(?:pop://$server)";


1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::RFC2384 -- Definitions from RFC2384;

=head1 SYNOPSIS

    use Regexp::Common::URI::RFC2384 qw /:ALL/;

=head1 DESCRIPTION

This package exports definitions from RFC2384. It's intended
usage is for Regexp::Common::URI submodules only. Its interface
might change without notice.

=head1 REFERENCES

=over 4

=item B<[RFC 2384]>

Gellens, R.: I<POP URL scheme> August 1998.

=back

=head1 HISTORY

 $Log: RFC2384.pm,v $
 Revision 2.102  2004/12/15 08:15:35  abigail
 Fixed Revision extraction for $VERSION

 Revision 2.101  2004/06/30 14:38:59  abigail
 $VERSION issue (reported by Mike Arms)

 Revision 2.100  2003/03/25 23:10:23  abigail
 POP URIs


=head1 AUTHOR

Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

=head1 COPYRIGHT

   Copyright (c) 2003, Abigail and Damian Conway. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
