
package Test::Reporter::Time::Zone;

=head1 NAME

Test::Reporter::Time::Zone -- miscellaneous timezone manipulations routines

=head1 SYNOPSIS

	use Test::Reporter::Time::Zone;
	print tz2zone();
	print tz2zone($ENV{'TZ'});
	print tz2zone($ENV{'TZ'}, time());
	print tz2zone($ENV{'TZ'}, undef, $isdst);
	$offset = tz_local_offset();
	$offset = tz_offset($TZ);

=head1 DESCRIPTION

This is a collection of miscellaneous timezone manipulation routines.

C<tz2zone()> parses the TZ environment variable and returns a timezone
string suitable for inclusion in L<date>-like output.  It opionally takes
a timezone string, a time, and a is-dst flag.

C<tz_local_offset()> determins the offset from GMT time in seconds.  It
only does the calculation once.

C<tz_offset()> determines the offset from GMT in seconds of a specified
timezone.  

C<tz_name()> determines the name of the timezone based on its offset

=head1 AUTHORS

Graham Barr <gbarr@pobox.com>
David Muir Sharnoff <muir@idiom.com>
Paul Foley <paul@ascent.com>

=cut

require 5.002;

require Exporter;
use Carp;
use strict;
use vars qw(@ISA @EXPORT $VERSION @tz_local);

@ISA = qw(Exporter);
@EXPORT = qw(tz2zone tz_local_offset tz_offset tz_name);
$VERSION = "2.22";

# Parts stolen from code by Paul Foley <paul@ascent.com>

sub tz2zone (;$$$)
{
	my($TZ, $time, $isdst) = @_;

	use vars qw(%tzn_cache);

	$TZ = defined($ENV{'TZ'}) ? ( $ENV{'TZ'} ? $ENV{'TZ'} : 'GMT' ) : ''
	    unless $TZ;

	# Hack to deal with 'PST8PDT' format of TZ
	# Note that this can't deal with all the esoteric forms, but it
	# does recognize the most common: [:]STDoff[DST[off][,rule]]

	if (! defined $isdst) {
		my $j;
		$time = time() unless $time;
		($j, $j, $j, $j, $j, $j, $j, $j, $isdst) = localtime($time);
	}

	if (defined $tzn_cache{$TZ}->[$isdst]) {
		return $tzn_cache{$TZ}->[$isdst];
	}
      
	if ($TZ =~ /^
		    ( [^:\d+\-,] {3,} )
		    ( [+-] ?
		      \d {1,2}
		      ( : \d {1,2} ) {0,2} 
		    )
		    ( [^\d+\-,] {3,} )?
		    /x
	    ) {
		my $dsttz = defined($4) ? $4 : $1;
		$TZ = $isdst ? $dsttz : $1;
		$tzn_cache{$TZ} = [ $1, $dsttz ];
	} else {
		$tzn_cache{$TZ} = [ $TZ, $TZ ];
	}
	return $TZ;
}

sub tz_local_offset (;$)
{
	my ($time) = @_;

	$time = time() unless $time;
	my (@l) = localtime($time);
	my $isdst = $l[8];

	if (defined($tz_local[$isdst])) {
		return $tz_local[$isdst];
	}

	$tz_local[$isdst] = &calc_off($time);

	return $tz_local[$isdst];
}

sub calc_off
{
	my ($time) = @_;

	my (@l) = localtime($time);
	my (@g) = gmtime($time);

	my $off;

	$off =     $l[0] - $g[0]
		+ ($l[1] - $g[1]) * 60
		+ ($l[2] - $g[2]) * 3600;

	# subscript 7 is yday.

	if ($l[7] == $g[7]) {
		# done
	} elsif ($l[7] == $g[7] + 1) {
		$off += 86400;
	} elsif ($l[7] == $g[7] - 1) {
		$off -= 86400;
	} elsif ($l[7] < $g[7]) {
		# crossed over a year boundry!
		# localtime is beginning of year, gmt is end
		# therefore local is ahead
		$off += 86400;
	} else {
		$off -= 86400;
	}

	return $off;
}

# constants

CONFIG: {
	use vars qw(%dstZone %zoneOff %dstZoneOff %Zone);

	my @dstZone = (
	#   "ndt"  =>   -2*3600-1800,	 # Newfoundland Daylight   
	    "brst" =>   -2*3600,         # Brazil Summer Time (East Daylight)
	    "adt"  =>   -3*3600,  	 # Atlantic Daylight   
	    "edt"  =>   -4*3600,  	 # Eastern Daylight
	    "cdt"  =>   -5*3600,  	 # Central Daylight
	    "mdt"  =>   -6*3600,  	 # Mountain Daylight
	    "pdt"  =>   -7*3600,  	 # Pacific Daylight
	    "ydt"  =>   -8*3600,  	 # Yukon Daylight
	    "hdt"  =>   -9*3600,  	 # Hawaii Daylight
	    "bst"  =>   +1*3600,  	 # British Summer   
	    "mest" =>   +2*3600,  	 # Middle European Summer   
	    "sst"  =>   +2*3600,  	 # Swedish Summer
	    "fst"  =>   +2*3600,  	 # French Summer
            "cest" =>   +2*3600,         # Central European Daylight
            "eest" =>   +3*3600,         # Eastern European Summer
	    "wadt" =>   +8*3600,  	 # West Australian Daylight
	    "kdt"  =>  +10*3600,	 # Korean Daylight
	#   "cadt" =>  +10*3600+1800,	 # Central Australian Daylight
	    "eadt" =>  +11*3600,  	 # Eastern Australian Daylight
	    "nzd"  =>  +13*3600,  	 # New Zealand Daylight   
	    "nzdt" =>  +13*3600,  	 # New Zealand Daylight   
	);

	my @Zone = (
	    "gmt"	=>   0,  	 # Greenwich Mean
	    "ut"        =>   0,  	 # Universal (Coordinated)
	    "utc"       =>   0,
	    "wet"       =>   0,  	 # Western European
	    "wat"       =>  -1*3600,	 # West Africa
	    "at"        =>  -2*3600,	 # Azores
	    "fnt"	=>  -2*3600,	 # Brazil Time (Extreme East - Fernando Noronha)
	    "brt"	=>  -3*3600,	 # Brazil Time (East Standard - Brasilia)
	# For completeness.  BST is also British Summer, and GST is also Guam Standard.
	#   "bst"       =>  -3*3600,	 # Brazil Standard
	#   "gst"       =>  -3*3600,	 # Greenland Standard
	#   "nft"       =>  -3*3600-1800,# Newfoundland
	#   "nst"       =>  -3*3600-1800,# Newfoundland Standard
	    "mnt"	=>  -4*3600,	 # Brazil Time (West Standard - Manaus)
	    "ewt"       =>  -4*3600,	 # U.S. Eastern War Time
	    "ast"       =>  -4*3600,	 # Atlantic Standard
	    "est"       =>  -5*3600,	 # Eastern Standard
	    "act"	=>  -5*3600,	 # Brazil Time (Extreme West - Acre)
	    "cst"       =>  -6*3600,	 # Central Standard
	    "mst"       =>  -7*3600,	 # Mountain Standard
	    "pst"       =>  -8*3600,	 # Pacific Standard
	    "yst"	=>  -9*3600,	 # Yukon Standard
	    "hst"	=> -10*3600,	 # Hawaii Standard
	    "cat"	=> -10*3600,	 # Central Alaska
	    "ahst"	=> -10*3600,	 # Alaska-Hawaii Standard
	    "nt"	=> -11*3600,	 # Nome
	    "idlw"	=> -12*3600,	 # International Date Line West
	    "cet"	=>  +1*3600, 	 # Central European
	    "mez"	=>  +1*3600, 	 # Central European (German)
	    "ect"	=>  +1*3600, 	 # Central European (French)
	    "met"	=>  +1*3600, 	 # Middle European
	    "mewt"	=>  +1*3600, 	 # Middle European Winter
	    "swt"	=>  +1*3600, 	 # Swedish Winter
	    "set"	=>  +1*3600, 	 # Seychelles
	    "fwt"	=>  +1*3600, 	 # French Winter
	    "eet"	=>  +2*3600, 	 # Eastern Europe, USSR Zone 1
	    "ukr"	=>  +2*3600, 	 # Ukraine
	    "bt"	=>  +3*3600, 	 # Baghdad, USSR Zone 2
	#   "it"	=>  +3*3600+1800,# Iran
	    "zp4"	=>  +4*3600, 	 # USSR Zone 3
	    "zp5"	=>  +5*3600, 	 # USSR Zone 4
	#   "ist"	=>  +5*3600+1800,# Indian Standard
	    "zp6"	=>  +6*3600, 	 # USSR Zone 5
	# For completeness.  NST is also Newfoundland Stanard, and SST is also Swedish Summer.
	#   "nst"	=>  +6*3600+1800,# North Sumatra
	#   "sst"	=>  +7*3600, 	 # South Sumatra, USSR Zone 6
	#   "jt"	=>  +7*3600+1800,# Java (3pm in Cronusland!)
	    "wst"	=>  +8*3600, 	 # West Australian Standard
	    "hkt"	=>  +8*3600, 	 # Hong Kong
	    "cct"	=>  +8*3600, 	 # China Coast, USSR Zone 7
	    "jst"	=>  +9*3600,	 # Japan Standard, USSR Zone 8
	    "kst"	=>  +9*3600,	 # Korean Standard
	#   "cast"	=>  +9*3600+1800,# Central Australian Standard
	    "east"	=> +10*3600,	 # Eastern Australian Standard
	    "gst"	=> +10*3600,	 # Guam Standard, USSR Zone 9
	    "nzt"	=> +12*3600,	 # New Zealand
	    "nzst"	=> +12*3600,	 # New Zealand Standard
	    "idle"	=> +12*3600,	 # International Date Line East
	);

	%Zone = @Zone;
	%dstZone = @dstZone;
	%zoneOff = reverse(@Zone);
	%dstZoneOff = reverse(@dstZone);

}

sub tz_offset (;$$)
{
	my ($zone, $time) = @_;

	return &tz_local_offset($time) unless($zone);

	$time = time() unless $time;
	my(@l) = localtime($time);
	my $dst = $l[8];

	$zone = lc $zone;

	if($zone =~ /^(([\-\+])\d\d?)(\d\d)$/) {
		my $v = $2 . $3;
		return $1 * 3600 + $v * 60;
	} elsif (exists $dstZone{$zone} && ($dst || !exists $Zone{$zone})) {
		return $dstZone{$zone};
	} elsif(exists $Zone{$zone}) {
		return $Zone{$zone};
	}
	undef;
}

sub tz_name (;$$)
{
	my ($off, $dst) = @_;

	$off = tz_offset()
		unless(defined $off);

	$dst = (localtime(time))[8]
		unless(defined $dst);

	if (exists $dstZoneOff{$off} && ($dst || !exists $zoneOff{$off})) {
		return $dstZoneOff{$off};
	} elsif (exists $zoneOff{$off}) {
		return $zoneOff{$off};
	}
	sprintf("%+05d", int($off / 60) * 100 + $off % 60);
}

1;
