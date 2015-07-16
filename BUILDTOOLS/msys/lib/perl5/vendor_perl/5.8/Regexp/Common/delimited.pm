# $Id: delimited.pm,v 2.104 2005/03/16 00:22:45 abigail Exp $

package Regexp::Common::delimited;

use strict;
local $^W = 1;

use Regexp::Common qw /pattern clean no_defaults/;
use vars qw /$VERSION/;

($VERSION) = q $Revision: 2.104 $ =~ /[\d.]+/g;

sub gen_delimited {

    my ($dels, $escs) = @_;
    # return '(?:\S*)' unless $dels =~ /\S/;
    if (length $escs) {
        $escs .= substr ($escs, -1) x (length ($dels) - length ($escs));
    }
    my @pat = ();
    my $i;
    for ($i=0; $i < length $dels; $i++) {
        my $del = quotemeta substr ($dels, $i, 1);
        my $esc = length($escs) ? quotemeta substr ($escs, $i, 1) : "";
        if ($del eq $esc) {
            push @pat,
                 "(?k:$del)(?k:[^$del]*(?:(?:$del$del)[^$del]*)*)(?k:$del)";
        }
        elsif (length $esc) {
            push @pat,
                 "(?k:$del)(?k:[^$esc$del]*(?:$esc.[^$esc$del]*)*)(?k:$del)";
        }
        else {
            push @pat, "(?k:$del)(?k:[^$del]*)(?k:$del)";
        }
    }
    my $pat = join '|', @pat;
    return "(?k:$pat)";
}

sub _croak {
    require Carp;
    goto &Carp::croak;
}

pattern name   => [qw( delimited -delim= -esc=\\ )],
        create => sub {my $flags = $_[1];
                       _croak 'Must specify delimiter in $RE{delimited}'
                             unless length $flags->{-delim};
                       return gen_delimited (@{$flags}{-delim, -esc});
                  },
        ;

pattern name   => [qw( quoted -esc=\\ )],
        create => sub {my $flags = $_[1];
                       return gen_delimited (q{"'`}, $flags -> {-esc});
                  },
        ;


1;

__END__

=pod

=head1 NAME

Regexp::Common::delimited -- provides a regex for delimited strings

=head1 SYNOPSIS

    use Regexp::Common qw /delimited/;

    while (<>) {
        /$RE{delimited}{-delim=>'"'}/  and print 'a \" delimited string';
        /$RE{delimited}{-delim=>'/'}/  and print 'a \/ delimited string';
    }


=head1 DESCRIPTION

Please consult the manual of L<Regexp::Common> for a general description
of the works of this interface.

Do not use this module directly, but load it via I<Regexp::Common>.

=head2 C<$RE{delimited}{-delim}{-esc}>

Returns a pattern that matches a single-character-delimited substring,
with optional internal escaping of the delimiter.

When C<-delim=I<S>> is specified, each character in the sequence I<S> is
a possible delimiter. There is no default delimiter, so this flag must always
be specified.

If C<-esc=I<S>> is specified, each character in the sequence I<S> is
the delimiter for the corresponding character in the C<-delim=I<S>> list.
The default escape is backslash.

For example:

   $RE{delimited}{-delim=>'"'}            # match "a \" delimited string"
   $RE{delimited}{-delim=>'"'}{-esc=>'"'} # match "a "" delimited string"
   $RE{delimited}{-delim=>'/'}            # match /a \/ delimited string/
   $RE{delimited}{-delim=>q{'"}}          # match "string" or 'string'

Under C<-keep> (See L<Regexp::Common>):

=over 4

=item $1

captures the entire match

=item $2

captures the opening delimiter (provided only one delimiter was specified)

=item $3

captures delimited portion of the string (provided only one delimiter was
specified)

=item $4

captures the closing delimiter (provided only one delimiter was specified)

=back

=head2 $RE{quoted}{-esc}

A synonym for C<$RE{delimited}{q{-delim='"`}{...}}>

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
