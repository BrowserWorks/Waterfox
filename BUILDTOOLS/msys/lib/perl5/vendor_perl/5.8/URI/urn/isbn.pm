package URI::urn::isbn;  # RFC 3187

require URI::urn;
@ISA=qw(URI::urn);

use strict;
use Business::ISBN ();


sub _isbn {
    my $nss = shift;
    $nss = $nss->nss if ref($nss);
    my $isbn = Business::ISBN->new($nss);
    $isbn = undef if $isbn && !$isbn->is_valid;
    return $isbn;
}

sub _nss_isbn {
    my $self = shift;
    my $nss = $self->nss(@_);
    my $isbn = _isbn($nss);
    $isbn = $isbn->as_string if $isbn;
    return($nss, $isbn);
}

sub isbn {
    my $self = shift;
    my $isbn;
    (undef, $isbn) = $self->_nss_isbn(@_);
    return $isbn;
}

sub isbn_publisher_code {
    my $isbn = shift->_isbn || return undef;
    return $isbn->publisher_code;
}

sub isbn_country_code {
    my $isbn = shift->_isbn || return undef;
    return $isbn->country_code;
}

sub isbn_as_ean {
    my $isbn = shift->_isbn || return undef;
    return $isbn->as_ean;
}

sub canonical {
    my $self = shift;
    my($nss, $isbn) = $self->_nss_isbn;
    my $new = $self->SUPER::canonical;
    return $new unless $nss && $isbn && $nss ne $isbn;
    $new = $new->clone if $new == $self;
    $new->nss($isbn);
    return $new;
}

1;
