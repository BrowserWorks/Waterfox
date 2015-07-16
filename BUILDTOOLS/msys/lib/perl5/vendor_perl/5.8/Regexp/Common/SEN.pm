# $Id: SEN.pm,v 2.102 2005/01/02 01:17:48 abigail Exp $

package Regexp::Common::SEN;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;

use vars qw /$VERSION @EXPORT_OK @ISA/;

($VERSION) = q $Revision: 2.102 $ =~ /[\d.]+/g;

=pod

sub par11 {
    my $string = shift;
    my $sum    = 0;
    for my $i (0 .. length ($string) - 1) {
        my $c = substr ($string, $i, 1);
        $sum += $c * (length ($string) - $i)
    }
    !($sum % 11)
}

=cut

# http://www.ssa.gov/history/ssn/geocard.html
pattern name   => [qw /SEN USA SSN -sep=-/],
        create => sub {
            my $sep = $_ [1] {-sep};
            "(?k:(?k:[1-9][0-9][0-9]|0[1-9][0-9]|00[1-9])$sep"   .
                "(?k:[1-9][0-9]|0[1-9])$sep"                     .
                "(?k:[1-9][0-9][0-9][0-9]|0[1-9][0-9][0-9]|"     .
                                         "00[1-9][0-9]|000[1-9]))"
        },
        ;

=for nobody

It's not clear whether this is the right checksum.

# http://www.google.nl/search?q=cache:8m1zKNYrEO0J:www.enschede.nl/nieuw/projecten/aanbesteding/integratie/pve%2520Bijlage%25207.5.doc+Sofi+nummer+formaat&hl=en&start=56&lr=lang_en|lang_nl&ie=UTF-8
pattern name   => [qw /SEN Netherlands SoFi/],
        create => sub {
            # 9 digits (d1 d2 d3 d4 d5 d6 d7 d8 d9)
            # 9*d1 + 8*d2 + 7*d3 + 6*d4 + 5*d5 + 4*d6 + 3*d7 + 2*d8 + 1*d9 
            # == 0 mod 11.
            qr /([0-9]{9})(?(?{par11 ($^N)})|(?!))/;
        }
        ;

=cut

1;

__END__

=pod

=head1 NAME

Regexp::Common::SEN -- provide regexes for Social-Economical Numbers.

=head1 SYNOPSIS

 use Regexp::Common qw /SEN/;

 while (<>) {
     /^$RE{SEN}{USA}{SSN}$/    and  print "Social Security Number\n";
 }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 C<$RE{SEN}{USA}{SSN}{-sep}>

Returns a pattern that matches an American Social Security Number (SSN).
SSNs consist of three groups of numbers, separated by a hypen (C<->).
This pattern only checks for a valid structure, that is, it validates
whether a number is valid SSN, was a valid SSN, or maybe a valid SSN
in the future. There are almost a billion possible SSNs, and about 
400 million are in use, or have been in use. 

If C<-sep=I<P>> is specified, the pattern I<P> is used as the
separator between the groups of numbers.

Under C<-keep> (see L<Regexp::Common>):

=over 4

=item $1

captures the entire SSN.

=item $2

captures the first group of digits (the area number).

=item $3

captures the second group of digits (the group number).

=item $4

captures the third group of digits (the serial number).

=back

=head1 HISTORY

 $Log: SEN.pm,v $
 Revision 2.102  2005/01/02 01:17:48  abigail
 - Removed 'use Carp', as we aren't using it.
 - Outcommented unused 'par11' function. Ought to be in _support.pm anyway.

 Revision 2.101  2004/06/09 21:52:14  abigail
 Force 2.101 version

 Revision 2.1  2004/06/09 21:50:14  abigail
 Initial checkin


=head1 SEE ALSO

L<Regexp::Common> for a general description of how to use this interface.

=head1 AUTHORS

Damian Conway and Abigail.

=head1 MAINTAINANCE

This package is maintained by Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

For a start, there are many common regexes missing.
Send them in to I<regexp-common@abigail.nl>.

=head1 COPYRIGHT

          Copyright (c) 2001 - 2003, Damian Conway and Abigail.
        All Rights Reserved. This module is free software. It may
        be used, redistributed and/or modified under the terms of
                        the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
