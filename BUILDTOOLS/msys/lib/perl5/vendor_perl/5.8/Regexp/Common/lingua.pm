# $Id: lingua.pm,v 2.105 2005/03/16 00:23:57 abigail Exp $

package Regexp::Common::lingua;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;

use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.105 $ =~ /[\d.]+/g;

pattern name    => [qw /lingua palindrome -chars=[A-Za-z]/],
        create  => sub {
            use re 'eval';
            local $^W = 1;
            my $keep  = exists $_ [1] -> {-keep};
            my $ch  = $_ [1] -> {-chars};
            my $idx = $keep ? "1:$ch" : "0:$ch";
            my $r   = "(??{\$Regexp::Common::lingua::pd{'" . $idx . "'}})";
            $Regexp::Common::lingua::pd {$idx} = 
                    $keep ? qr /($ch|($ch)($r)?\2)/ : qr  /$ch|($ch)($r)?\1/;
        #   print "[$ch]: ", $Regexp::Common::lingua::pd {$idx}, "\n";
        #   $Regexp::Common::lingua::pd {$idx};
        },
        version => 5.006
        ;


1;

__END__

=pod

=head1 NAME

Regexp::Common::lingua -- provide regexes for language related stuff.

=head1 SYNOPSIS

    use Regexp::Common qw /lingua/;

    while (<>) {
        /^$RE{lingua}{palindrome}$/    and  print "is a palindrome\n";
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 C<$RE{lingua}{palindrome}>

Returns a pattern that recognizes a palindrome, a string that is the
same if you reverse it. By default, it only matches strings consisting
of letters, but this can be changed using the C<{-chars}> option.
This option takes a character class (default is C<[A-Za-z]>) as
argument.

If C<{-keep}> is used, only C<$1> will be set, and set to the entire
match. 

This pattern requires at least perl 5.6.0.

=head1 HISTORY

 $Log: lingua.pm,v $
 Revision 2.105  2005/03/16 00:23:57  abigail
 Removed 'use Carp'

 Revision 2.104  2003/07/04 13:34:05  abigail
 Fixed assignment to

 Revision 2.103  2003/03/25 23:46:29  abigail
 Removed outer braces

 Revision 2.102  2003/03/25 23:20:02  abigail
 Added documentation

 Revision 2.101  2003/02/01 22:55:31  abigail
 Changed Copyright years

 Revision 2.100  2003/01/21 23:19:40  abigail
 The whole world understands RCS/CVS version numbers, that 1.9 is an
 older version than 1.10. Except CPAN. Curse the idiot(s) who think
 that version numbers are floats (in which universe do floats have
 more than one decimal dot?).
 Everything is bumped to version 2.100 because CPAN couldn't deal
 with the fact one file had version 1.10.

 Revision 1.2  2003/01/01 19:11:29  abigail
 Fixed problem with having different palindrome patterns in same program

 Revision 1.1  2003/01/01 17:05:56  abigail
 First version

=head1 SEE ALSO

L<Regexp::Common> for a general description of how to use this interface.

=head1 AUTHOR

Damian Conway (damian@conway.org)

=head1 MAINTAINANCE

This package is maintained by Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Many regexes are missing.
Send them in to I<regexp-common@abigail.nl>.

=head1 COPYRIGHT

     Copyright (c) 2001 - 2003, Damian Conway. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
