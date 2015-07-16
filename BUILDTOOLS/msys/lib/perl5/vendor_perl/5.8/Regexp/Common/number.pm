# $Id: number.pm,v 2.108 2005/03/16 00:25:58 abigail Exp $

package Regexp::Common::number;

use strict;
use Config;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;

use vars qw /$VERSION @EXPORT_OK @ISA/;

($VERSION) = q $Revision: 2.108 $ =~ /[\d.]+/g;

sub _croak {
    require Carp;
    goto &Carp::croak;
}

my $digits = join ("", 0 .. 9, "A" .. "Z");

sub int_creator {
    my $flags = $_ [1];
    my ($sep, $group, $base, $places) =
            @{$flags} {qw /-sep -group -base -places/};

    # Deal with the bases.
    _croak "Base must be between 1 and 36" unless $base >=  1 &&
                                                  $base <= 36;
    my $chars = substr $digits, 0, $base;

    $sep = ',' if exists $flags -> {-sep} && !defined $flags -> {-sep};

    my $max = $group;
       $max = $2 if $group =~ /^\s*(\d+)\s*,\s*(\d+)\s*$/;

    my $quant = $places ? "{$places}" : "+";

    return $sep ? qq {(?k:(?k:[+-]?)(?k:[$chars]{1,$max}} .
                  qq {(?:$sep} . qq {[$chars]{$group})*))}
                : qq {(?k:(?k:[+-]?)(?k:[$chars]$quant))}
}

sub real_creator { 
    my ($base, $places, $radix, $sep, $group, $expon) =
            @{$_[1]}{-base, -places, -radix, -sep, -group, -expon};
    _croak "Base must be between 1 and 36"
           unless $base >= 1 && $base <= 36;
    $sep = ',' if exists $_[1]->{-sep}
               && !defined $_[1]->{-sep};
    if ($base > 14 && $expon =~ /^[Ee]$/) {$expon = 'G'}
    foreach ($radix, $sep, $expon) {$_ = "[$_]" if 1 == length}
    my $chars = substr $digits, 0, $base;
    return $sep
           ? qq {(?k:(?i)(?k:[+-]?)(?k:(?=[$chars]|$radix)}              .
             qq {(?k:[$chars]{1,$group}(?:(?:$sep)[$chars]{$group})*)}  .
             qq {(?:(?k:$radix)(?k:[$chars]{$places}))?)}                .
             qq {(?:(?k:$expon)(?k:(?k:[+-]?)(?k:[$chars]+))|))}
           : qq {(?k:(?i)(?k:[+-]?)(?k:(?=[$chars]|$radix)}              .
             qq {(?k:[$chars]*)(?:(?k:$radix)(?k:[$chars]{$places}))?)} .
             qq {(?:(?k:$expon)(?k:(?k:[+-]?)(?k:[$chars]+))|))};
}
sub decimal_creator { 
    my ($base, $places, $radix, $sep, $group) =
            @{$_[1]}{-base, -places, -radix, -sep, -group};
    _croak "Base must be between 1 and 36"
           unless $base >= 1 && $base <= 36;
    $sep = ',' if exists $_[1]->{-sep}
               && !defined $_[1]->{-sep};
    foreach ($radix, $sep) {$_ = "[$_]" if 1 == length}
    my $chars = substr $digits, 0, $base;
    return $sep
           ? qq {(?k:(?i)(?k:[+-]?)(?k:(?=[$chars]|$radix)}               .
             qq {(?k:[$chars]{1,$group}(?:(?:$sep)[$chars]{$group})*)}   .
             qq {(?:(?k:$radix)(?k:[$chars]{$places}))?))}
           : qq {(?k:(?i)(?k:[+-]?)(?k:(?=[$chars]|$radix)}               .
             qq {(?k:[$chars]*)(?:(?k:$radix)(?k:[$chars]{$places}))?))}
}


pattern name   => [qw (num int -sep= -base=10 -group=3)],
        create => \&int_creator,
        ;

pattern name   => [qw (num real -base=10), '-places=0,',
                   qw (-radix=[.] -sep= -group=3 -expon=E)],
        create => \&real_creator,
        ;

pattern name   => [qw (num decimal -base=10), '-places=0,',
                   qw (-radix=[.] -sep= -group=3)],
        create => \&decimal_creator,
        ;

sub real_synonym {
    my ($name, $base) = @_;
    pattern name   => ['num', $name, '-places=0,', '-radix=[.]',
                       '-sep=', '-group=3', '-expon=E'],
            create => sub {my %flags = (%{$_[1]}, -base => $base);
                           real_creator (undef, \%flags);
                      }
            ;
}


real_synonym (hex => 16);
real_synonym (dec => 10);
real_synonym (oct =>  8);
real_synonym (bin =>  2);


# 2147483647
pattern name    => [qw (num square)],
        create  => sub {
            use re 'eval';
            my $num = $Config {use64bitint} ? '0*[1-8]?[0-9]{1,15}' :
                     '0*(?:2(?:[0-0][0-9]{8}' .
                         '|1(?:[0-3][0-9]{7}' .
                         '|4(?:[0-6][0-9]{6}' .
                         '|7(?:[0-3][0-9]{5}' .
                         '|4(?:[0-7][0-9]{4}' .
                         '|8(?:[0-2][0-9]{3}' .
                         '|3(?:[0-5][0-9]{2}' .
                         '|6(?:[0-3][0-9]{1}' .
                         '|4[0-7])))))))))|1?[0-9]{1,9}';
            qr {($num)(?(?{sqrt ($^N) == int sqrt ($^N)})|(?!))}
        },
        version => 5.008;
        ;

pattern name    => [qw (num roman)],
        create  => '(?xi)(?=[MDCLXVI])
                         (?k:M{0,3}
                            (D?C{0,3}|CD|CM)?
                            (L?X{0,3}|XL|XC)?
                            (V?I{0,3}|IV|IX)?)'
        ;

1;

__END__

=pod

=head1 NAME

Regexp::Common::number -- provide regexes for numbers

=head1 SYNOPSIS

    use Regexp::Common qw /number/;

    while (<>) {
        /^$RE{num}{int}$/                and  print "Integer\n";
        /^$RE{num}{real}$/               and  print "Real\n";
        /^$RE{num}{real}{-base => 16}$/  and  print "Hexadecimal real\n";
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 C<$RE{num}{int}{-base}{-sep}{-group}{-places}>

Returns a pattern that matches an integer.

If C<< -base => I<B> >> is specified, the integer is in base I<B>, with
C<< 2 <= I<B> <= 36 >>. For bases larger than 10, upper case letters
are used. The default base is 10.

If C<< -sep => I<P> >> is specified, the pattern I<P> is required as a
grouping marker within the number. If this option is not given, no
grouping marker is used.

If C<< -group => I<N> >> is specified, digits between grouping markers
must be grouped in sequences of exactly I<N> digits. The default value
of I<N> is 3.  If C<< -group => I<N,M> >> is specified, digits between
grouping markers must be grouped in sequences of at least I<N> digits,
and at most I<M> digits. This option is ignored unless the C<< -sep >>
option is used.

If C<< -places => I<N> >> is specified, the integer recognized must be
exactly I<N> digits wide. If C<< -places => I<N,M> >> is specified, the
integer must be at least I<N> wide, and at most I<M> characters. There
is no default, which means that integers are unlimited in size. This
option is ignored if the C<< -sep >> option is used.

For example:

 $RE{num}{int}                          # match 1234567
 $RE{num}{int}{-sep=>','}               # match 1,234,567
 $RE{num}{int}{-sep=>',?'}              # match 1234567 or 1,234,567
 $RE{num}{int}{-sep=>'.'}{-group=>4}    # match 1.2345.6789

Under C<-keep> (see L<Regexp::Common>):

=over 4

=item $1

captures the entire number

=item $2

captures the optional sign of the number

=item $3

captures the complete set of digits

=back

=head2 C<$RE{num}{real}{-base}{-radix}{-places}{-sep}{-group}{-expon}>

Returns a pattern that matches a floating-point number.

If C<-base=I<N>> is specified, the number is assumed to be in that base
(with A..Z representing the digits for 11..36). By default, the base is 10.

If C<-radix=I<P>> is specified, the pattern I<P> is used as the radix point for
the number (i.e. the "decimal point" in base 10). The default is C<qr/[.]/>.

If C<-places=I<N>> is specified, the number is assumed to have exactly
I<N> places after the radix point.
If C<-places=I<M,N>> is specified, the number is assumed to have between
I<M> and I<N> places after the radix point.
By default, the number of places is unrestricted.

If C<-sep=I<P>> specified, the pattern I<P> is required as a grouping marker
within the pre-radix section of the number. By default, no separator is
allowed.

If C<-group=I<N>> is specified, digits between grouping separators
must be grouped in sequences of exactly I<N> characters. The default value of
I<N> is 3.

If C<-expon=I<P>> is specified, the pattern I<P> is used as the exponential
marker.  The default value of I<P> is C<qr/[Ee]/>.

For example:

 $RE{num}{real}                  # matches 123.456 or -0.1234567
 $RE{num}{real}{-places=>2}      # matches 123.45 or -0.12
 $RE{num}{real}{-places=>'0,3'}  # matches 123.456 or 0 or 9.8
 $RE{num}{real}{-sep=>'[,.]?'}   # matches 123,456 or 123.456
 $RE{num}{real}{-base=>3'}       # matches 121.102

Under C<-keep>:

=over 4

=item $1

captures the entire match

=item $2

captures the optional sign of the number

=item $3

captures the complete mantissa

=item $4

captures the whole number portion of the mantissa

=item $5

captures the radix point

=item $6

captures the fractional portion of the mantissa

=item $7

captures the optional exponent marker

=item $8

captures the entire exponent value

=item $9

captures the optional sign of the exponent

=item $10

captures the digits of the exponent

=back

=head2 C<$RE{num}{dec}{-radix}{-places}{-sep}{-group}{-expon}>

A synonym for C<< $RE{num}{real}{-base=>10}{...} >>

=head2 C<$RE{num}{oct}{-radix}{-places}{-sep}{-group}{-expon}>

A synonym for C<< $RE{num}{real}{-base=>8}{...} >>

=head2 C<$RE{num}{bin}{-radix}{-places}{-sep}{-group}{-expon}>

A synonym for C<< $RE{num}{real}{-base=>2}{...} >>

=head2 C<$RE{num}{hex}{-radix}{-places}{-sep}{-group}{-expon}>

A synonym for C<< $RE{num}{real}{-base=>16}{...} >>

=head2 C<$RE{num}{decimal}{-base}{-radix}{-places}{-sep}{-group}>

The same as C<$RE{num}{real}>, except that an exponent isn't allowed.
Hence, this returns a pattern matching I<decimal> numbers.

If C<-base=I<N>> is specified, the number is assumed to be in that base
(with A..Z representing the digits for 11..36). By default, the base is 10.

If C<-radix=I<P>> is specified, the pattern I<P> is used as the radix point for
the number (i.e. the "decimal point" in base 10). The default is C<qr/[.]/>.

If C<-places=I<N>> is specified, the number is assumed to have exactly
I<N> places after the radix point.
If C<-places=I<M,N>> is specified, the number is assumed to have between
I<M> and I<N> places after the radix point.
By default, the number of places is unrestricted.

If C<-sep=I<P>> specified, the pattern I<P> is required as a grouping marker
within the pre-radix section of the number. By default, no separator is
allowed.

If C<-group=I<N>> is specified, digits between grouping separators
must be grouped in sequences of exactly I<N> characters. The default value of
I<N> is 3.

For example:

 $RE{num}{decimal}                  # matches 123.456 or -0.1234567
 $RE{num}{decimal}{-places=>2}      # matches 123.45 or -0.12
 $RE{num}{decimal}{-places=>'0,3'}  # matches 123.456 or 0 or 9.8
 $RE{num}{decimal}{-sep=>'[,.]?'}   # matches 123,456 or 123.456
 $RE{num}{decimal}{-base=>3'}       # matches 121.102

Under C<-keep>:

=over 4

=item $1

captures the entire match

=item $2

captures the optional sign of the number

=item $3

captures the complete mantissa

=item $4

captures the whole number portion of the mantissa

=item $5

captures the radix point

=item $6

captures the fractional portion of the mantissa

=back

=head2 C<$RE{num}{square}>

Returns a pattern that matches a (decimal) square. Because Perl's
arithmetic is lossy when using integers over about 53 bits, this pattern
only recognizes numbers less than 9000000000000000, if one uses a
Perl that is configured to use 64 bit integers. Otherwise, the limit
is 2147483647. These restrictions were introduced in versions 2.116
and 2.117 of Regexp::Common. Regardless whether C<-keep> was set,
the matched number will be returned in C<$1>.

This pattern is available for version 5.008 and up.

=head2 C<$RE{num}{roman}>

Returns a pattern that matches an integer written in Roman numbers.
Case doesn't matter. Only the more modern style, that is, no more
than three repetitions of a letter, is recognized. The largest number
matched is I<MMMCMXCIX>, or 3999. Larger numbers cannot be expressed
using ASCII characters. A future version will be able to deal with 
the Unicode symbols to match larger Roman numbers.

Under C<-keep>, the number will be captured in $1.

=head1 HISTORY

 $Log: number.pm,v $
 Revision 2.108  2005/03/16 00:25:58  abigail
 Added -base, -places for  {num} {int}. Changed -group

 Revision 2.107  2004/12/28 23:45:51  abigail
 Perl 5.6.2 parses qq lib/Regexp/Common/number.pm{sep}[0-9]! incorrectly

 Revision 2.106  2004/12/28 23:27:58  abigail
 Replaced C<\d> with [0-9] (Unicode reasons)

 Revision 2.105  2004/07/01 10:11:27  abigail
 Fixed problems with 32bit integer Perls

 Revision 2.104  2004/06/30 09:14:54  abigail
 Restricted recognition of square numbers to numbers less than
 9000000000000000 to avoid round-off errors.

 Revision 2.103  2003/03/12 22:24:25  abigail
 Decimal numbers

 Revision 2.102  2003/02/10 21:34:24  abigail
 Added VERSION

 Revision 2.101  2003/02/01 22:55:31  abigail
 Changed Copyright years

 Revision 2.100  2003/01/21 23:19:40  abigail
 The whole world understands RCS/CVS version numbers, that 1.9 is an
 older version than 1.10. Except CPAN. Curse the idiot(s) who think
 that version numbers are floats (in which universe do floats have
 more than one decimal dot?).
 Everything is bumped to version 2.100 because CPAN couldn't deal
 with the fact one file had version 1.10.

 Revision 1.6  2002/12/27 23:33:15  abigail
 Roman numbers.

 Revision 1.5  2002/08/23 13:09:13  abigail
 Cosmetic POD changes.

 Revision 1.4  2002/08/23 12:51:26  abigail
 + Several occurances of 'numbers' changed to 'number'.
 + Fixed bugs in documentation.
 + Made example use anchors to make it more clear.
  (All due to Christopher Baker)

 Revision 1.3  2002/08/05 12:16:59  abigail
 Fixed 'Regex::' and 'Rexexp::' typos to 'Regexp::'
 (Found by Mike Castle).

 Revision 1.2  2002/07/30 16:37:59  abigail
 Removed outcommented code.

 Revision 1.1  2002/07/28 21:41:07  abigail
 Split off from Regexp::Common.

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
