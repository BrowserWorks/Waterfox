# $Id: _support.pm,v 2.101 2004/12/18 11:28:25 abigail Exp $

package Regexp::Common::_support;

use strict;
local $^W = 1;

use vars qw /$VERSION/;
($VERSION) = q $Revision: 2.101 $ =~ /[\d.]+/g;


#
# Returns true/false, depending whether the given the argument
# satisfies the LUHN checksum.
# See http://www.webopedia.com/TERM/L/Luhn_formula.html.
#
# Note that this function is intended to be called from regular
# expression, so it should NOT use a regular expression in any way.
#
sub luhn {
    my $arg  = shift;
    my $even = 0;
    my $sum  = 0;
    while (length $arg) {
        my $num = chop $arg;
        return if $num lt '0' || $num gt '9';
        if ($even && (($num *= 2) > 9)) {$num = 1 + ($num % 10)}
        $even = 1 - $even;
        $sum += $num;
    }
    !($sum % 10)
}

sub import {
    my $pack   = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller . "::" . $_} = \&{$pack . "::" . $_} for @_;
}


1;

__END__

=pod

=head1 NAME

Regexp::Common::support -- Support functions for Regexp::Common.

=head1 SYNOPSIS

    use Regexp::Common::_support qw /luhn/;

    luhn ($number)    # Returns true/false.


=head1 DESCRIPTION

This module contains some subroutines to be used by other C<Regexp::Common>
modules. It's not intended to be used directly. Subroutines from the 
module may disappear without any notice, or their meaning or interface
may change without notice.

=over 4

=item luhn

This subroutine returns true if its argument passes the luhn checksum test.

=back

=head1 SEE ALSO

L<http://www.webopedia.com/TERM/L/Luhn_formula.html>.

=head1 HISTORY

 $Log: _support.pm,v $
 Revision 2.101  2004/12/18 11:28:25  abigail
 POD nit (Mike Castle)

 Revision 2.100  2004/07/01 14:47:00  abigail
 Force version

 Revision 2.1  2004/07/01 14:46:35  abigail
 Initial checkin


=head1 AUTHOR

Abigail S<(I<regexp-common@abigail.nl>)>.

=head1 BUGS AND IRRITATIONS

Bound to be plenty.

=head1 COPYRIGHT

 Copyright (c) 2001-2004, Damian Conway and Abigail. All Rights Reserved.
       This module is free software. It may be used, redistributed
      and/or modified under the terms of the Perl Artistic License
            (see http://www.perl.com/perl/misc/Artistic.html)

=cut
