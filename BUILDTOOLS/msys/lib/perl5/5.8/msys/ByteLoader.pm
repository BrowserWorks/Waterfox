package ByteLoader;

use XSLoader ();

our $VERSION = '0.06';

XSLoader::load 'ByteLoader', $VERSION;

1;
__END__

=head1 NAME

ByteLoader - load byte compiled perl code

=head1 SYNOPSIS

  use ByteLoader 0.06;
  <byte code>

  or just

  perl -MByteLoader bytecode_file

=head1 DESCRIPTION

This module is used to load byte compiled perl code as produced by
C<perl -MO=Bytecode=...>. It uses the source filter mechanism to read
the byte code and insert it into the compiled code at the appropriate point.

=head1 AUTHOR

Tom Hughes <tom@compton.nu> based on the ideas of Tim Bunce and others.
Many changes by Enache Adrian <enache@rdslink.ro> 2003 a.d.

=head1 SEE ALSO

perl(1).

=cut
