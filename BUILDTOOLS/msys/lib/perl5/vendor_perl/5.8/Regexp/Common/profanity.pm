# $Id: profanity.pm,v 2.104 2003/07/04 13:34:05 abigail Exp $

package Regexp::Common::profanity;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;
use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.104 $ =~ /[\d.]+/g;

my $profanity = '(?:cvff(?:\\ gnxr|\\-gnxr|gnxr|r(?:ef|[feq])|vat|l)?|dhvzf?|fuvg(?:g(?:r(?:ef|[qe])|vat|l)|r(?:ef|[fqel])|vat|[fr])?|g(?:heqf?|jngf?)|jnax(?:r(?:ef|[eq])|vat|f)?|n(?:ef(?:r(?:\\ ubyr|\\-ubyr|ubyr|[fq])|vat|r)|ff(?:\\ ubyrf?|\\-ubyrf?|rq|ubyrf?|vat))|o(?:hyy(?:\\ fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?|\\-fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?|fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?)|ybj(?:\\ wbof?|\\-wbof?|wbof?))|p(?:bpx(?:\\ fhpx(?:ref?|vat)|\\-fhpx(?:ref?|vat)|fhpx(?:ref?|vat))|enc(?:c(?:r(?:ef|[eq])|vat|l)|f)?|h(?:agf?|z(?:vat|zvat|f)))|qvpx(?:\\ urnq|\\-urnq|rq|urnq|vat|yrff|f)|s(?:hpx(?:rq|vat|f)?|neg(?:r[eq]|vat|[fl])?|rygpu(?:r(?:ef|[efq])|vat)?)|un(?:eq[\\-\\ ]?ba|ys(?:\\ n[fe]|\\-n[fe]|n[fe])frq)|z(?:bgure(?:\\ shpx(?:ref?|vat)|\\-shpx(?:ref?|vat)|shpx(?:ref?|vat))|hgu(?:n(?:\\ shpx(?:ref?|vat|[nnn])|\\-shpx(?:ref?|vat|[nnn])|shpx(?:ref?|vat|[nnn]))|re(?:\\ shpx(?:ref?|vat)|\\-shpx(?:ref?|vat)|shpx(?:ref?|vat)))|reqr?))';

my $contextual = '(?:c(?:bex|e(?:bax|vpxf?)|hff(?:vrf|l)|vff(?:\\ gnxr|\\-gnxr|gnxr|r(?:ef|[feq])|vat|l)?)|dhvzf?|ebbg(?:r(?:ef|[eq])|vat|f)?|f(?:bq(?:q(?:rq|vat)|f)?|chax|perj(?:rq|vat|f)?|u(?:nt(?:t(?:r(?:ef|[qe])|vat)|f)?|vg(?:g(?:r(?:ef|[qe])|vat|l)|r(?:ef|[fqel])|vat|[fr])?))|g(?:heqf?|jngf?|vgf?)|jnax(?:r(?:ef|[eq])|vat|f)?|n(?:ef(?:r(?:\\ ubyr|\\-ubyr|ubyr|[fq])|vat|r)|ff(?:\\ ubyrf?|\\-ubyrf?|rq|ubyrf?|vat))|o(?:ba(?:r(?:ef|[fe])|vat|r)|h(?:ttre|yy(?:\\ fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?|\\-fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?|fuvg(?:g(?:r(?:ef|[qe])|vat)|f)?))|n(?:fgneq|yy(?:r(?:ef|[qe])|vat|f)?)|yb(?:bql|j(?:\\ wbof?|\\-wbof?|wbof?)))|p(?:bpx(?:\\ fhpx(?:ref?|vat)|\\-fhpx(?:ref?|vat)|fhpx(?:ref?|vat)|f)?|enc(?:c(?:r(?:ef|[eq])|vat|l)|f)?|h(?:agf?|z(?:vat|zvat|f)))|q(?:batf?|vpx(?:\\ urnq|\\-urnq|rq|urnq|vat|yrff|f)?)|s(?:hpx(?:rq|vat|f)?|neg(?:r[eq]|vat|[fl])?|rygpu(?:r(?:ef|[efq])|vat)?)|u(?:hzc(?:r(?:ef|[eq])|vat|f)?|n(?:eq[\\-\\ ]?ba|ys(?:\\ n[fe]|\\-n[fe]|n[fe])frq))|z(?:bgure(?:\\ shpx(?:ref?|vat)|\\-shpx(?:ref?|vat)|shpx(?:ref?|vat))|hgu(?:n(?:\\ shpx(?:ref?|vat|[nnn])|\\-shpx(?:ref?|vat|[nnn])|shpx(?:ref?|vat|[nnn]))|re(?:\\ shpx(?:ref?|vat)|\\-shpx(?:ref?|vat)|shpx(?:ref?|vat)))|reqr?))';

tr/A-Za-z/N-ZA-Mn-za-m/ foreach $profanity, $contextual;

pattern name   => [qw (profanity)],
        create => '(?:\b(?k:' . $profanity . ')\b)',
        ;

pattern name   => [qw (profanity contextual)],
        create => '(?:\b(?k:' . $contextual . ')\b)',
        ;


1;

__END__

=pod

=head1 NAME

Regexp::Common::profanity -- provide regexes for profanity

=head1 SYNOPSIS

    use Regexp::Common qw /profanity/;

    while (<>) {
        /$RE{profanity}/               and  print "Contains profanity\n";
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 $RE{profanity}

Returns a pattern matching words -- such as Carlin's "big seven" -- that
are most likely to give offense. Note that correct anatomical terms are
deliberately I<not> included in the list.

Under C<-keep> (see L<Regexp::Common>):

=over 4

=item $1

captures the entire word

=back

=head2 C<$RE{profanity}{contextual}>

Returns a pattern matching words that are likely to give offense when
used in specific contexts, but which also have genuinely
non-offensive meanings.

Under C<-keep> (see L<Regexp::Common>):

=over 4

=item $1

captures the entire word

=back

=head1 HISTORY

 $Log: profanity.pm,v $
 Revision 2.104  2003/07/04 13:34:05  abigail
 Fixed assignment to

 Revision 2.103  2003/02/11 10:23:07  abigail
 Small fix

 Revision 2.102  2003/02/11 09:45:09  abigail
 Added

 Revision 2.101  2003/02/01 22:55:31  abigail
 Changed Copyright years

 Revision 2.100  2003/01/21 23:19:40  abigail
 The whole world understands RCS/CVS version numbers, that 1.9 is an
 older version than 1.10. Except CPAN. Curse the idiot(s) who think
 that version numbers are floats (in which universe do floats have
 more than one decimal dot?).
 Everything is bumped to version 2.100 because CPAN couldn't deal
 with the fact one file had version 1.10.

 Revision 1.2  2002/08/05 12:16:59  abigail
 Fixed 'Regex::' and 'Rexexp::' typos to 'Regexp::' (Found my Mike Castle).

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
