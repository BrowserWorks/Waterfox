# $Id: list.pm,v 2.103 2003/07/04 13:34:05 abigail Exp $

package Regexp::Common::list;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;
use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.103 $ =~ /[\d.]+/g;

sub gen_list_pattern {
    my ($pat, $sep, $lsep) = @_;
    $lsep = $sep unless defined $lsep;
    return "(?k:(?:(?:$pat)(?:$sep))*(?:$pat)(?k:$lsep)(?:$pat))";
}

my $defpat = '.*?\S';
my $defsep = '\s*,\s*';

pattern name   => ['list', "-pat=$defpat", "-sep=$defsep", '-lastsep'],
        create => sub {gen_list_pattern (@{$_[1]}{-pat, -sep, -lastsep})},
        ;

pattern name   => ['list', 'conj', '-word=(?:and|or)'],
        create => sub {gen_list_pattern($defpat, $defsep,
                                        '\s*,?\s*'.$_[1]->{-word}.'\s*');
                  },
        ;

pattern name   => ['list', 'and'],
        create => sub {gen_list_pattern ($defpat, $defsep, '\s*,?\s*and\s*')},
        ;

pattern name   => ['list', 'or'],
        create => sub {gen_list_pattern ($defpat, $defsep, '\s*,?\s*or\s*')},
        ;


1;

__END__

=pod

=head1 NAME

Regexp::Common::list -- provide regexes for lists

=head1 SYNOPSIS

    use Regexp::Common qw /list/;

    while (<>) {
        /$RE{list}{-pat => '\w+'}/          and print "List of words";
        /$RE{list}{-pat => $RE{num}{real}}/ and print "List of numbers";
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 C<$RE{list}{-pat}{-sep}{-lastsep}>

Returns a pattern matching a list of (at least two) substrings.

If C<-pat=I<P>> is specified, it defines the pattern for each substring
in the list. By default, I<P> is C<qr/.*?\S/>. In Regexp::Common 0.02
or earlier, the default pattern was C<qr/.*?/>. But that will match
a single space, causing unintended parsing of C<a, b, and c> as a
list of four elements instead of 3 (with C<-word> being C<(?:and)>).
One consequence is that a list of the form "a,,b" will no longer be
parsed. Use the pattern C<qr /.*?/> to be able to parse this, but see
the previous remark.

If C<-sep=I<P>> is specified, it defines the pattern I<P> to be used as
a separator between each pair of substrings in the list, except the final two.
By default I<P> is C<qr/\s*,\s*/>.

If C<-lastsep=I<P>> is specified, it defines the pattern I<P> to be used as
a separator between the final two substrings in the list.
By default I<P> is the same as the pattern specified by the C<-sep> flag.

For example:

      $RE{list}{-pat=>'\w+'}                # match a list of word chars
      $RE{list}{-pat=>$RE{num}{real}}       # match a list of numbers
      $RE{list}{-sep=>"\t"}                 # match a tab-separated list
      $RE{list}{-lastsep=>',\s+and\s+'}     # match a proper English list

Under C<-keep>:

=over 4

=item $1

captures the entire list

=item $2

captures the last separator

=back

=head2 C<$RE{list}{conj}{-word=I<PATTERN>}>

An alias for C<< $RE{list}{-lastsep=>'\s*,?\s*I<PATTERN>\s*'} >>

If C<-word> is not specified, the default pattern is C<qr/and|or/>.

For example:

      $RE{list}{conj}{-word=>'et'}        # match Jean, Paul, et Satre
      $RE{list}{conj}{-word=>'oder'}      # match Bonn, Koln oder Hamburg

=head2 C<$RE{list}{and}>

An alias for C<< $RE{list}{conj}{-word=>'and'} >>

=head2 C<$RE{list}{or}>

An alias for C<< $RE{list}{conj}{-word=>'or'} >>

=head1 HISTORY

 $Log: list.pm,v $
 Revision 2.103  2003/07/04 13:34:05  abigail
 Fixed assignment to

 Revision 2.102  2003/02/11 09:42:06  abigail
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
