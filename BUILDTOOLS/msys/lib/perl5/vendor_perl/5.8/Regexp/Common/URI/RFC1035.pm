# $Id: RFC1035.pm,v 2.100 2003/02/10 21:03:25 abigail Exp $

package Regexp::Common::URI::RFC1035;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;

use vars qw /$VERSION @EXPORT @EXPORT_OK %EXPORT_TAGS @ISA/;

use Exporter ();
@ISA = qw /Exporter/;

($VERSION) = q $Revision: 2.100 $ =~ /[\d.]+/g;

my %vars;

BEGIN {
    $vars {low}     = [qw /$digit $letter $let_dig $let_dig_hyp $ldh_str/];
    $vars {parts}   = [qw /$label $subdomain/];
    $vars {domain}  = [qw /$domain/];
}

use vars map {@$_} values %vars;

@EXPORT      = qw /$host/;
@EXPORT_OK   = map {@$_} values %vars;
%EXPORT_TAGS = (%vars, ALL => [@EXPORT_OK]);

# RFC 1035.
$digit             = "[0-9]";
$letter            = "[A-Za-z]";
$let_dig           = "[A-Za-z0-9]";
$let_dig_hyp       = "[-A-Za-z0-9]";
$ldh_str           = "(?:[-A-Za-z0-9]+)";
$label             = "(?:$letter(?:(?:$ldh_str){0,61}$let_dig)?)";
$subdomain         = "(?:$label(?:[.]$label)*)";
$domain            = "(?: |(?:$subdomain))";


1;

__END__

=pod

=head1 NAME

Regexp::Common::URI::RFC1035 -- Definitions from RFC1035;

=head1 SYNOPSIS

    use Regexp::Common::URI::RFC1035 qw /:ALL/;

=head1 DESCRIPTION

This package exports definitions from RFC1035. It's intended
usage is for Regexp::Common::URI submodules only. Its interface
might change without notice.

=head1 REFERENCES

=over 4

=item B<[RFC 1035]>

Mockapetris, P.: I<DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION>.
November 1987.

=back

=head1 HISTORY

 $Log: RFC1035.pm,v $
 Revision 2.100  2003/02/10 21:03:25  abigail
 Definitions of RFC 1035


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
