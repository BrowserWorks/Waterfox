package PerlIO::encoding;

use strict;
our $VERSION = '0.09';
our $DEBUG = 0;
$DEBUG and warn __PACKAGE__, " called by ", join(", ", caller), "\n";

#
# Equivalent of this is done in encoding.xs - do not uncomment.
#
# use Encode ();

use XSLoader ();
XSLoader::load(__PACKAGE__, $VERSION);

our $fallback =
    Encode::PERLQQ()|Encode::WARN_ON_ERR()|Encode::STOP_AT_PARTIAL();

1;
__END__

=head1 NAME

PerlIO::encoding - encoding layer

=head1 SYNOPSIS

  open($f, "<:encoding(foo)", "infoo");
  open($f, ">:encoding(bar)", "outbar");

  use Encode qw(:fallbacks);
  $PerlIO::encoding::fallback = FB_PERLQQ;

=head1 DESCRIPTION

Open a filehandle with a transparent encoding filter.

On input, convert the bytes expected to be in the specified
character set and encoding to Perl string data (Unicode and
Perl's internal Unicode encoding, UTF-8).  On output, convert
Perl string data into the specified character set and encoding.

When the layer is pushed the current value of C<$PerlIO::encoding::fallback>
is saved and used as the CHECK argument when calling the Encode methods encode()
and decode().

=head1 SEE ALSO

L<open>, L<Encode>, L<perlfunc/binmode>, L<perluniintro>

=cut
