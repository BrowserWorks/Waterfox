# NOTE: Derived from ../../lib/Storable.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Storable;

#line 116 "../../lib/Storable.pm (autosplit into ../../lib/auto/Storable/read_magic.al)"
sub read_magic {
  my $header = shift;
  return unless defined $header and length $header > 11;
  my $result;
  if ($header =~ s/^perl-store//) {
    die "Can't deal with version 0 headers";
  } elsif ($header =~ s/^pst0//) {
    $result->{file} = 1;
  }
  # Assume it's a string.
  my ($major, $minor, $bytelen) = unpack "C3", $header;

  my $net_order = $major & 1;
  $major >>= 1;
  @$result{qw(major minor netorder)} = ($major, $minor, $net_order);

  return $result if $net_order;

  # I assume that it is rare to find v1 files, so this is an intentionally
  # inefficient way of doing it, to make the rest of the code constant.
  if ($major < 2) {
    delete $result->{minor};
    $header = '.' . $header;
    $bytelen = $minor;
  }

  @$result{qw(byteorder intsize longsize ptrsize)} =
    unpack "x3 A$bytelen C3", $header;

  if ($major >= 2 and $minor >= 2) {
    $result->{nvsize} = unpack "x6 x$bytelen C", $header;
  }
  $result;
}

# end of Storable::read_magic
1;
