# $Id: whitespace.pm,v 2.103 2003/07/04 13:34:05 abigail Exp $

package Regexp::Common::whitespace;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;
use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.103 $ =~ /[\d.]+/g;

pattern name   => [qw (ws crop)],
        create => '(?:^\s+|\s+$)',
        subs   => sub {$_[1] =~ s/^\s+//; $_[1] =~ s/\s+$//;}
        ;


1;

__END__

=pod

=head1 NAME

Regexp::Common::whitespace -- provides a regex for leading or
trailing whitescape

=head1 SYNOPSIS

    use Regexp::Common qw /whitespace/;

    while (<>) {
        s/$RE{ws}{crop}//g;           # Delete surrounding whitespace
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.


=head2 C<$RE{ws}{crop}>

Returns a pattern that identifies leading or trailing whitespace.

For example:

        $str =~ s/$RE{ws}{crop}//g;     # Delete surrounding whitespace

The call:

        $RE{ws}{crop}->subs($str);

is optimized (but probably still slower than doing the s///g explicitly).

This pattern does not capture under C<-keep>.

=head1 HISTORY

 $Log: whitespace.pm,v $
 Revision 2.103  2003/07/04 13:34:05  abigail
 Fixed assignment to

 Revision 2.102  2003/02/11 09:48:54  abigail
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

 Revision 1.2  2002/08/27 16:59:39  abigail
 Fix POD

 Revision 1.1  2002/08/27 16:58:59  abigail
 Initial checkin.


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
