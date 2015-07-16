package base;

use strict 'vars';
use vars qw($VERSION);
$VERSION = '2.07';

# constant.pm is slow
sub SUCCESS () { 1 }

sub PUBLIC     () { 2**0  }
sub PRIVATE    () { 2**1  }
sub INHERITED  () { 2**2  }
sub PROTECTED  () { 2**3  }


my $Fattr = \%fields::attr;

sub has_fields {
    my($base) = shift;
    my $fglob = ${"$base\::"}{FIELDS};
    return( ($fglob && *$fglob{HASH}) ? 1 : 0 );
}

sub has_version {
    my($base) = shift;
    my $vglob = ${$base.'::'}{VERSION};
    return( ($vglob && *$vglob{SCALAR}) ? 1 : 0 );
}

sub has_attr {
    my($proto) = shift;
    my($class) = ref $proto || $proto;
    return exists $Fattr->{$class};
}

sub get_attr {
    $Fattr->{$_[0]} = [1] unless $Fattr->{$_[0]};
    return $Fattr->{$_[0]};
}

if ($] < 5.009) {
    *get_fields = sub {
	# Shut up a possible typo warning.
	() = \%{$_[0].'::FIELDS'};
	my $f = \%{$_[0].'::FIELDS'};

	# should be centralized in fields? perhaps
	# fields::mk_FIELDS_be_OK. Peh. As long as %{ $package . '::FIELDS' }
	# is used here anyway, it doesn't matter.
	bless $f, 'pseudohash' if (ref($f) ne 'pseudohash');

	return $f;
    }
}
else {
    *get_fields = sub {
	# Shut up a possible typo warning.
	() = \%{$_[0].'::FIELDS'};
	return \%{$_[0].'::FIELDS'};
    }
}

sub import {
    my $class = shift;

    return SUCCESS unless @_;

    # List of base classes from which we will inherit %FIELDS.
    my $fields_base;

    my $inheritor = caller(0);

    foreach my $base (@_) {
        next if $inheritor->isa($base);

        if (has_version($base)) {
	    ${$base.'::VERSION'} = '-1, set by base.pm' 
	      unless defined ${$base.'::VERSION'};
        }
        else {
            local $SIG{__DIE__};
            eval "require $base";
            # Only ignore "Can't locate" errors from our eval require.
            # Other fatal errors (syntax etc) must be reported.
            die if $@ && $@ !~ /^Can't locate .*? at \(eval /;
            unless (%{"$base\::"}) {
                require Carp;
                Carp::croak(<<ERROR);
Base class package "$base" is empty.
    (Perhaps you need to 'use' the module which defines that package first.)
ERROR

            }
            ${$base.'::VERSION'} = "-1, set by base.pm"
              unless defined ${$base.'::VERSION'};
        }
        push @{"$inheritor\::ISA"}, $base;

        if ( has_fields($base) || has_attr($base) ) {
	    # No multiple fields inheritence *suck*
	    if ($fields_base) {
		require Carp;
		Carp::croak("Can't multiply inherit %FIELDS");
	    } else {
		$fields_base = $base;
	    }
        }
    }

    if( defined $fields_base ) {
        inherit_fields($inheritor, $fields_base);
    }
}


sub inherit_fields {
    my($derived, $base) = @_;

    return SUCCESS unless $base;

    my $battr = get_attr($base);
    my $dattr = get_attr($derived);
    my $dfields = get_fields($derived);
    my $bfields = get_fields($base);

    $dattr->[0] = @$battr;

    if( keys %$dfields ) {
        warn "$derived is inheriting from $base but already has its own ".
             "fields!\n".
             "This will cause problems.\n".
             "Be sure you use base BEFORE declaring fields\n";
    }

    # Iterate through the base's fields adding all the non-private
    # ones to the derived class.  Hang on to the original attribute
    # (Public, Private, etc...) and add Inherited.
    # This is all too complicated to do efficiently with add_fields().
    while (my($k,$v) = each %$bfields) {
        my $fno;
	if ($fno = $dfields->{$k} and $fno != $v) {
	    require Carp;
	    Carp::croak ("Inherited %FIELDS can't override existing %FIELDS");
	}

        if( $battr->[$v] & PRIVATE ) {
            $dattr->[$v] = PRIVATE | INHERITED;
        }
        else {
            $dattr->[$v] = INHERITED | $battr->[$v];
            $dfields->{$k} = $v;
        }
    }

    foreach my $idx (1..$#{$battr}) {
	next if defined $dattr->[$idx];
	$dattr->[$idx] = $battr->[$idx] & INHERITED;
    }
}


1;

__END__

=head1 NAME

base - Establish IS-A relationship with base classes at compile time

=head1 SYNOPSIS

    package Baz;
    use base qw(Foo Bar);

=head1 DESCRIPTION

Allows you to both load one or more modules, while setting up inheritance from
those modules at the same time.  Roughly similar in effect to

    package Baz;
    BEGIN {
        require Foo;
        require Bar;
        push @ISA, qw(Foo Bar);
    }

If any of the listed modules are not loaded yet, I<base> silently attempts to
C<require> them (and silently continues if the C<require> failed).  Whether to
C<require> a base class module is determined by the absence of a global variable
$VERSION in the base package.  If $VERSION is not detected even after loading
it, <base> will define $VERSION in the base package, setting it to the string
C<-1, set by base.pm>.

Will also initialize the fields if one of the base classes has it.
Multiple inheritence of fields is B<NOT> supported, if two or more
base classes each have inheritable fields the 'base' pragma will
croak.  See L<fields>, L<public> and L<protected> for a description of
this feature.

=head1 DIAGNOSTICS

=over 4

=item Base class package "%s" is empty.

base.pm was unable to require the base package, because it was not
found in your path.

=back

=head1 HISTORY

This module was introduced with Perl 5.004_04.


=head1 CAVEATS

Due to the limitations of the implementation, you must use
base I<before> you declare any of your own fields.


=head1 SEE ALSO

L<fields>

=cut
