package Hash::Util;

require 5.007003;
use strict;
use Carp;

require Exporter;
our @ISA        = qw(Exporter);
our @EXPORT_OK  = qw(lock_keys unlock_keys lock_value unlock_value
                     lock_hash unlock_hash hash_seed
                    );
our $VERSION    = 0.05;

=head1 NAME

Hash::Util - A selection of general-utility hash subroutines

=head1 SYNOPSIS

  use Hash::Util qw(lock_keys   unlock_keys
                    lock_value  unlock_value
                    lock_hash   unlock_hash
                    hash_seed);

  %hash = (foo => 42, bar => 23);
  lock_keys(%hash);
  lock_keys(%hash, @keyset);
  unlock_keys(%hash);

  lock_value  (%hash, 'foo');
  unlock_value(%hash, 'foo');

  lock_hash  (%hash);
  unlock_hash(%hash);

  my $hashes_are_randomised = hash_seed() != 0;

=head1 DESCRIPTION

C<Hash::Util> contains special functions for manipulating hashes that
don't really warrant a keyword.

By default C<Hash::Util> does not export anything.

=head2 Restricted hashes

5.8.0 introduces the ability to restrict a hash to a certain set of
keys.  No keys outside of this set can be added.  It also introduces
the ability to lock an individual key so it cannot be deleted and the
value cannot be changed.

This is intended to largely replace the deprecated pseudo-hashes.

=over 4

=item lock_keys

=item unlock_keys

  lock_keys(%hash);
  lock_keys(%hash, @keys);

Restricts the given %hash's set of keys to @keys.  If @keys is not
given it restricts it to its current keyset.  No more keys can be
added. delete() and exists() will still work, but will not alter
the set of allowed keys. B<Note>: the current implementation prevents
the hash from being bless()ed while it is in a locked state. Any attempt
to do so will raise an exception. Of course you can still bless()
the hash before you call lock_keys() so this shouldn't be a problem.

  unlock_keys(%hash);

Removes the restriction on the %hash's keyset.

=cut

sub lock_keys (\%;@) {
    my($hash, @keys) = @_;

    Internals::hv_clear_placeholders %$hash;
    if( @keys ) {
        my %keys = map { ($_ => 1) } @keys;
        my %original_keys = map { ($_ => 1) } keys %$hash;
        foreach my $k (keys %original_keys) {
            die sprintf "Hash has key '$k' which is not in the new key ".
                        "set at %s line %d\n", (caller)[1,2]
              unless $keys{$k};
        }
    
        foreach my $k (@keys) {
            $hash->{$k} = undef unless exists $hash->{$k};
        }
        Internals::SvREADONLY %$hash, 1;

        foreach my $k (@keys) {
            delete $hash->{$k} unless $original_keys{$k};
        }
    }
    else {
        Internals::SvREADONLY %$hash, 1;
    }

    return;
}

sub unlock_keys (\%) {
    my($hash) = shift;

    Internals::SvREADONLY %$hash, 0;
    return;
}

=item lock_value

=item unlock_value

  lock_value  (%hash, $key);
  unlock_value(%hash, $key);

Locks and unlocks an individual key of a hash.  The value of a locked
key cannot be changed.

%hash must have already been locked for this to have useful effect.

=cut

sub lock_value (\%$) {
    my($hash, $key) = @_;
    carp "Cannot usefully lock values in an unlocked hash" 
      unless Internals::SvREADONLY %$hash;
    Internals::SvREADONLY $hash->{$key}, 1;
}

sub unlock_value (\%$) {
    my($hash, $key) = @_;
    Internals::SvREADONLY $hash->{$key}, 0;
}


=item B<lock_hash>

=item B<unlock_hash>

    lock_hash(%hash);

lock_hash() locks an entire hash, making all keys and values readonly.
No value can be changed, no keys can be added or deleted.

    unlock_hash(%hash);

unlock_hash() does the opposite of lock_hash().  All keys and values
are made read/write.  All values can be changed and keys can be added
and deleted.

=cut

sub lock_hash (\%) {
    my($hash) = shift;

    lock_keys(%$hash);

    foreach my $key (keys %$hash) {
        lock_value(%$hash, $key);
    }

    return 1;
}

sub unlock_hash (\%) {
    my($hash) = shift;

    foreach my $key (keys %$hash) {
        unlock_value(%$hash, $key);
    }

    unlock_keys(%$hash);

    return 1;
}


=item B<hash_seed>

    my $hash_seed = hash_seed();

hash_seed() returns the seed number used to randomise hash ordering.
Zero means the "traditional" random hash ordering, non-zero means the
new even more random hash ordering introduced in Perl 5.8.1.

B<Note that the hash seed is sensitive information>: by knowing it one
can craft a denial-of-service attack against Perl code, even remotely,
see L<perlsec/"Algorithmic Complexity Attacks"> for more information.
B<Do not disclose the hash seed> to people who don't need to know it.
See also L<perlrun/PERL_HASH_SEED_DEBUG>.

=cut

sub hash_seed () {
    Internals::rehash_seed();
}

=back

=head1 CAVEATS

Note that the trapping of the restricted operations is not atomic:
for example

    eval { %hash = (illegal_key => 1) }

leaves the C<%hash> empty rather than with its original contents.

=head1 AUTHOR

Michael G Schwern <schwern@pobox.com> on top of code by Nick
Ing-Simmons and Jeffrey Friedl.

=head1 SEE ALSO

L<Scalar::Util>, L<List::Util>, L<Hash::Util>,
and L<perlsec/"Algorithmic Complexity Attacks">.

=cut

1;
