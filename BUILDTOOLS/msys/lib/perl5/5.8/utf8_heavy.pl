package utf8;
use strict;
use warnings;

sub DEBUG () { 0 }

sub DESTROY {}

my %Cache;

our (%PropertyAlias, %PA_reverse, %PropValueAlias, %PVA_reverse, %PVA_abbr_map);

sub croak { require Carp; Carp::croak(@_) }

##
## "SWASH" == "SWATCH HASH". A "swatch" is a swatch of the Unicode landscape.
## It's a data structure that encodes a set of Unicode characters.
##

sub SWASHNEW {
    my ($class, $type, $list, $minbits, $none) = @_;
    local $^D = 0 if $^D;

    print STDERR "SWASHNEW @_\n" if DEBUG;

    ##
    ## Get the list of codepoints for the type.
    ## Called from utf8.c
    ##
    ## Given a $type, our goal is to fill $list with the set of codepoint
    ## ranges.
    ##
    ## To make the parsing of $type clear, this code takes the a rather
    ## unorthodox approach of last'ing out of the block once we have the
    ## info we need. Were this to be a subroutine, the 'last' would just
    ## be a 'return'.
    ##
    my $file; ## file to load data from, and also part of the %Cache key.
    my $ListSorted = 0;

    if ($type)
    {
        $type =~ s/^\s+//;
        $type =~ s/\s+$//;

        print "type = $type\n" if DEBUG;

      GETFILE:
        {
	    ##
	    ## It could be a user-defined property.
	    ##

	    my $caller1 = $type =~ s/(.+)::// ? $1 : caller(1);

	    if (defined $caller1 && $type =~ /^(?:\w+)$/) {
		my $prop = "${caller1}::$type";
		if (exists &{$prop}) {
		    no strict 'refs';
		    
		    $list = &{$prop};
		    last GETFILE;
		}
	    }

            my $wasIs;

            ($wasIs = $type =~ s/^Is(?:\s+|[-_])?//i)
              or
            $type =~ s/^(?:(?:General(?:\s+|_)?)?Category|gc)\s*[:=]\s*//i
              or
            $type =~ s/^(?:Script|sc)\s*[:=]\s*//i
              or
            $type =~ s/^Block\s*[:=]\s*/In/i;


	    ##
	    ## See if it's in some enumeration.
	    ##
	    require "unicore/PVA.pl";
	    if ($type =~ /^([\w\s]+)[:=]\s*(.*)/) {
		my ($enum, $val) = (lc $1, lc $2);
		$enum =~ tr/ _-//d;
		$val =~ tr/ _-//d;

		my $pa = $PropertyAlias{$enum} ? $enum : $PA_reverse{$enum};
		my $f = $PropValueAlias{$pa}{$val} ? $val : $PVA_reverse{$pa}{lc $val};

		if ($pa and $f) {
		    $pa = "gc_sc" if $pa eq "gc" or $pa eq "sc";
		    $file = "unicore/lib/$pa/$PVA_abbr_map{$pa}{lc $f}.pl";
		    last GETFILE;
		}
	    }
	    else {
		my $t = lc $type;
		$t =~ tr/ _-//d;

		if ($PropValueAlias{gc}{$t} or $PropValueAlias{sc}{$t}) {
		    $file = "unicore/lib/gc_sc/$PVA_abbr_map{gc_sc}{$t}.pl";
		    last GETFILE;
		}
	    }

            ##
            ## See if it's in the direct mapping table.
            ##
            require "unicore/Exact.pl";
            if (my $base = $utf8::Exact{$type}) {
                $file = "unicore/lib/gc_sc/$base.pl";
                last GETFILE;
            }

            ##
            ## If not there exactly, try the canonical form. The canonical
            ## form is lowercased, with any separators (\s+|[-_]) removed.
            ##
            my $canonical = lc $type;
            $canonical =~ s/(?<=[a-z\d])(?:\s+|[-_])(?=[a-z\d])//g;
            print "canonical = $canonical\n" if DEBUG;

            require "unicore/Canonical.pl";
            if (my $base = ($utf8::Canonical{$canonical} || $utf8::Canonical{ lc $utf8::PropertyAlias{$canonical} })) {
                $file = "unicore/lib/gc_sc/$base.pl";
                last GETFILE;
            }

	    ##
	    ## See if it's a user-level "To".
	    ##

	    my $caller0 = caller(0);

	    if (defined $caller0 && $type =~ /^To(?:\w+)$/) {
		my $map = $caller0 . "::" . $type;

		if (exists &{$map}) {
		    no strict 'refs';
		    
		    $list = &{$map};
		    last GETFILE;
		}
	    }

            ##
            ## Last attempt -- see if it's a standard "To" name
	    ## (e.g. "ToLower")  ToTitle is used by ucfirst().
	    ## The user-level way to access ToDigit() and ToFold()
	    ## is to use Unicode::UCD.
            ##
            if ($type =~ /^To(Digit|Fold|Lower|Title|Upper)$/)
            {
                $file = "unicore/To/$1.pl";
                ## would like to test to see if $file actually exists....
                last GETFILE;
            }

            ##
            ## If we reach this line, it's because we couldn't figure
            ## out what to do with $type. Ouch.
            ##

            return $type;
        }

	if (defined $file) {
	    print "found it (file='$file')\n" if DEBUG;

	    ##
	    ## If we reach here, it was due to a 'last GETFILE' above
	    ## (exception: user-defined properties and mappings), so we
	    ## have a filename, so now we load it if we haven't already.
	    ## If we have, return the cached results. The cache key is the
	    ## file to load.
	    ##
	    if ($Cache{$file} and ref($Cache{$file}) eq $class)
	    {
		print "Returning cached '$file' for \\p{$type}\n" if DEBUG;
		return $Cache{$class, $file};
	    }

	    $list = do $file;
	}

        $ListSorted = 1; ## we know that these lists are sorted
    }

    my $extras;
    my $bits = 0;

    my $ORIG = $list;
    if ($list) {
	my @tmp = split(/^/m, $list);
	my %seen;
	no warnings;
	$extras = join '', grep /^[^0-9a-fA-F]/, @tmp;
	$list = join '',
	    map  { $_->[1] }
	    sort { $a->[0] <=> $b->[0] }
	    map  { /^([0-9a-fA-F]+)/; [ hex($1), $_ ] }
	    grep { /^([0-9a-fA-F]+)/ and not $seen{$1}++ } @tmp; # XXX doesn't do ranges right
    }

    if ($none) {
	my $hextra = sprintf "%04x", $none + 1;
	$list =~ s/\tXXXX$/\t$hextra/mg;
    }

    if ($minbits < 32) {
	my $top = 0;
	while ($list =~ /^([0-9a-fA-F]+)(?:[\t]([0-9a-fA-F]+)?)(?:[ \t]([0-9a-fA-F]+))?/mg) {
	    my $min = hex $1;
	    my $max = defined $2 ? hex $2 : $min;
	    my $val = defined $3 ? hex $3 : 0;
	    $val += $max - $min if defined $3;
	    $top = $val if $val > $top;
	}
	$bits =
	    $top > 0xffff ? 32 :
	    $top > 0xff ? 16 :
	    $top > 1 ? 8 : 1
    }
    $bits = $minbits if $bits < $minbits;

    my @extras;
    for my $x ($extras) {
	pos $x = 0;
	while ($x =~ /^([^0-9a-fA-F\n])(.*)/mg) {
	    my $char = $1;
	    my $name = $2;
	    print STDERR "$1 => $2\n" if DEBUG;
	    if ($char =~ /[-+!&]/) {
		my ($c,$t) = split(/::/, $name, 2);	# bogus use of ::, really
		my $subobj;
		if ($c eq 'utf8') {
		    $subobj = utf8->SWASHNEW($t, "", 0, 0, 0);
		}
		elsif (exists &$name) {
		    $subobj = utf8->SWASHNEW($name, "", 0, 0, 0);
		}
		elsif ($c =~ /^([0-9a-fA-F]+)/) {
		    $subobj = utf8->SWASHNEW("", $c, 0, 0, 0);
		}
		return $subobj unless ref $subobj;
		push @extras, $name => $subobj;
		$bits = $subobj->{BITS} if $bits < $subobj->{BITS};
	    }
	}
    }

    print STDERR "CLASS = $class, TYPE => $type, BITS => $bits, NONE => $none\nEXTRAS =>\n$extras\nLIST =>\n$list\n" if DEBUG;

    my $SWASH = bless {
	TYPE => $type,
	BITS => $bits,
	EXTRAS => $extras,
	LIST => $list,
	NONE => $none,
	@extras,
    } => $class;

    if ($file) {
        $Cache{$class, $file} = $SWASH;
    }

    return $SWASH;
}

# NOTE: utf8.c:swash_init() assumes entries are never modified once generated.

sub SWASHGET {
    # See utf8.c:Perl_swash_fetch for problems with this interface.
    my ($self, $start, $len) = @_;
    local $^D = 0 if $^D;
    my $type = $self->{TYPE};
    my $bits = $self->{BITS};
    my $none = $self->{NONE};
    print STDERR "SWASHGET @_ [$type/$bits/$none]\n" if DEBUG;
    my $end = $start + $len;
    my $swatch = "";
    my $key;
    vec($swatch, $len - 1, $bits) = 0;	# Extend to correct length.
    if ($none) {
	for $key (0 .. $len - 1) { vec($swatch, $key, $bits) = $none }
    }

    for ($self->{LIST}) {
	pos $_ = 0;
	if ($bits > 1) {
	  LINE:
	    while (/^([0-9a-fA-F]+)(?:[ \t]([0-9a-fA-F]+)?)?(?:[ \t]([0-9a-fA-F]+))?/mg) {
		chomp;
		my ($a, $b, $c) = ($1, $2, $3);
		croak "$type: illegal mapping '$_'"
		    if $type =~ /^To/ &&
		       !(defined $a && defined $c);
		my $min = hex $a;
		my $max = defined $b ? hex $b : $min;
		my $val = defined $c ? hex $c : 0;
		next if $max < $start;
		print "$min $max $val\n" if DEBUG;
		if ($none) {
		    if ($min < $start) {
			$val += $start - $min if $val < $none;
			$min = $start;
		    }
		    for ($key = $min; $key <= $max; $key++) {
			last LINE if $key >= $end;
			print STDERR "$key => $val\n" if DEBUG;
			vec($swatch, $key - $start, $bits) = $val;
			++$val if $val < $none;
		    }
		}
		else {
		    if ($min < $start) {
			$val += $start - $min;
			$min = $start;
		    }
		    for ($key = $min; $key <= $max; $key++, $val++) {
			last LINE if $key >= $end;
			print STDERR "$key => $val\n" if DEBUG;
			vec($swatch, $key - $start, $bits) = $val;
		    }
		}
	    }
	}
	else {
	  LINE:
	    while (/^([0-9a-fA-F]+)(?:[ \t]+([0-9a-fA-F]+))?/mg) {
		chomp;
		my $min = hex $1;
		my $max = defined $2 ? hex $2 : $min;
		next if $max < $start;
		if ($min < $start) {
		    $min = $start;
		}
		for ($key = $min; $key <= $max; $key++) {
		    last LINE if $key >= $end;
		    print STDERR "$key => 1\n" if DEBUG;
		    vec($swatch, $key - $start, 1) = 1;
		}
	    }
	}
    }
    for my $x ($self->{EXTRAS}) {
	pos $x = 0;
	while ($x =~ /^([-+!&])(.*)/mg) {
	    my $char = $1;
	    my $name = $2;
	    print STDERR "INDIRECT $1 $2\n" if DEBUG;
	    my $otherbits = $self->{$name}->{BITS};
	    croak("SWASHGET size mismatch") if $bits < $otherbits;
	    my $other = $self->{$name}->SWASHGET($start, $len);
	    if ($char eq '+') {
		if ($bits == 1 and $otherbits == 1) {
		    $swatch |= $other;
		}
		else {
		    for ($key = 0; $key < $len; $key++) {
			vec($swatch, $key, $bits) = vec($other, $key, $otherbits);
		    }
		}
	    }
	    elsif ($char eq '!') {
		if ($bits == 1 and $otherbits == 1) {
		    $swatch |= ~$other;
		}
		else {
		    for ($key = 0; $key < $len; $key++) {
			if (!vec($other, $key, $otherbits)) {
			    vec($swatch, $key, $bits) = 1;
			}
		    }
		}
	    }
	    elsif ($char eq '-') {
		if ($bits == 1 and $otherbits == 1) {
		    $swatch &= ~$other;
		}
		else {
		    for ($key = 0; $key < $len; $key++) {
			if (vec($other, $key, $otherbits)) {
			    vec($swatch, $key, $bits) = 0;
			}
		    }
		}
	    }
	    elsif ($char eq '&') {
		if ($bits == 1 and $otherbits == 1) {
		    $swatch &= $other;
		}
		else {
		    for ($key = 0; $key < $len; $key++) {
			if (!vec($other, $key, $otherbits)) {
			    vec($swatch, $key, $bits) = 0;
			}
		    }
		}
	    }
	}
    }
    if (DEBUG) {
	print STDERR "CELLS ";
	for ($key = 0; $key < $len; $key++) {
	    print STDERR vec($swatch, $key, $bits), " ";
	}
	print STDERR "\n";
    }
    $swatch;
}

1;
