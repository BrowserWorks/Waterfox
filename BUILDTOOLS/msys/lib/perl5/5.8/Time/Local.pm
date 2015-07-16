package Time::Local;

require Exporter;
use Carp;
use Config;
use strict;
use integer;

use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK );
$VERSION    = '1.11';
$VERSION    = eval $VERSION;
@ISA	= qw( Exporter );
@EXPORT	= qw( timegm timelocal );
@EXPORT_OK	= qw( timegm_nocheck timelocal_nocheck );

my @MonthDays = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

# Determine breakpoint for rolling century
my $ThisYear     = (localtime())[5];
my $Breakpoint   = ($ThisYear + 50) % 100;
my $NextCentury  = $ThisYear - $ThisYear % 100;
   $NextCentury += 100 if $Breakpoint < 50;
my $Century      = $NextCentury - 100;
my $SecOff       = 0;

my (%Options, %Cheat, %Min, %Max);
my ($MinInt, $MaxInt);

if ($^O eq 'MacOS') {
    # time_t is unsigned...
    $MaxInt = (1 << (8 * $Config{intsize})) - 1;
    $MinInt = 0;
} else {
    $MaxInt = ((1 << (8 * $Config{intsize} - 2))-1)*2 + 1;
    $MinInt = -$MaxInt - 1;

    # On Win32 (and others?) time_t appears to be signed, but negative
    # epochs still don't work. - XXX - this is experimental
    $MinInt = 0
        unless defined ((localtime(-1))[0]);
}

$Max{Day} = ($MaxInt >> 1) / 43200;
$Min{Day} = $MinInt ? -($Max{Day} + 1) : 0;

$Max{Sec} = $MaxInt - 86400 * $Max{Day};
$Min{Sec} = $MinInt - 86400 * $Min{Day};

# Determine the EPOC day for this machine
my $Epoc = 0;
if ($^O eq 'vos') {
# work around posix-977 -- VOS doesn't handle dates in
# the range 1970-1980.
  $Epoc = _daygm((0, 0, 0, 1, 0, 70, 4, 0));
}
elsif ($^O eq 'MacOS') {
  no integer;

  # MacOS time() is seconds since 1 Jan 1904, localtime
  # so we need to calculate an offset to apply later
  $Epoc = 693901;
  $SecOff = timelocal(localtime(0)) - timelocal(gmtime(0));
  $Epoc += _daygm(gmtime(0));
}
else {
  $Epoc = _daygm(gmtime(0));
}

%Cheat=(); # clear the cache as epoc has changed

sub _daygm {
    $_[3] + ($Cheat{pack("ss",@_[4,5])} ||= do {
	my $month = ($_[4] + 10) % 12;
	my $year = $_[5] + 1900 - $month/10;
	365*$year + $year/4 - $year/100 + $year/400 + ($month*306 + 5)/10 - $Epoc
    });
}


sub _timegm {
    my $sec = $SecOff + $_[0]  +  60 * $_[1]  +  3600 * $_[2];

    no integer;

    $sec +  86400 * &_daygm;
}


sub _zoneadjust {
    my ($day, $sec, $time) = @_;

    $sec = $sec + _timegm(localtime($time)) - $time;
    if ($sec >= 86400) { $day++; $sec -= 86400; }
    if ($sec <  0)     { $day--; $sec += 86400; }

    ($day, $sec);
}


sub timegm {
    my ($sec,$min,$hour,$mday,$month,$year) = @_;

    if ($year >= 1000) {
	$year -= 1900;
    }
    elsif ($year < 100 and $year >= 0) {
	$year += ($year > $Breakpoint) ? $Century : $NextCentury;
    }

    unless ($Options{no_range_check}) {
	if (abs($year) >= 0x7fff) {
	    $year += 1900;
	    croak "Cannot handle date ($sec, $min, $hour, $mday, $month, *$year*)";
	}

	croak "Month '$month' out of range 0..11" if $month > 11 or $month < 0;

	my $md = $MonthDays[$month];
#        ++$md if $month == 1 and $year % 4 == 0 and
#            ($year % 100 != 0 or ($year + 1900) % 400 == 0);
	++$md unless $month != 1 or $year % 4 or !($year % 400);

	croak "Day '$mday' out of range 1..$md"   if $mday  > $md  or $mday  < 1;
	croak "Hour '$hour' out of range 0..23"   if $hour  > 23   or $hour  < 0;
	croak "Minute '$min' out of range 0..59"  if $min   > 59   or $min   < 0;
	croak "Second '$sec' out of range 0..59"  if $sec   > 59   or $sec   < 0;
    }

    my $days = _daygm(undef, undef, undef, $mday, $month, $year);
    my $xsec = $sec + $SecOff + 60*$min + 3600*$hour;

    unless ($Options{no_range_check}
        or  ($days > $Min{Day} or $days == $Min{Day} and $xsec >= $Min{Sec})
       and  ($days < $Max{Day} or $days == $Max{Day} and $xsec <= $Max{Sec}))
    {
        warn "Day too small - $days > $Min{Day}\n" if $days < $Min{Day};
        warn "Day too big - $days > $Max{Day}\n" if $days > $Max{Day};
        warn "Sec too small - $days < $Min{Sec}\n" if $days < $Min{Sec};
        warn "Sec too big - $days > $Max{Sec}\n" if $days > $Max{Sec};
	$year += 1900;
	croak "Cannot handle date ($sec, $min, $hour, $mday, $month, $year)";
    }

    no integer;

    $xsec + 86400 * $days;
}


sub timegm_nocheck {
    local $Options{no_range_check} = 1;
    &timegm;
}


sub timelocal {
    # Adjust Max/Min allowed times to fit local time zone and call timegm
    local ($Max{Day}, $Max{Sec}) = _zoneadjust($Max{Day}, $Max{Sec}, $MaxInt);
    local ($Min{Day}, $Min{Sec}) = _zoneadjust($Min{Day}, $Min{Sec}, $MinInt);
    my $ref_t = &timegm;

    # Calculate first guess with a one-day delta to avoid localtime overflow
    my $delta = ($_[5] < 100)? 86400 : -86400;
    my $loc_t = _timegm(localtime( $ref_t + $delta )) - $delta;

    # Is there a timezone offset from GMT or are we done
    my $zone_off = $ref_t - $loc_t
	or return $loc_t;

    # This hack is needed to always pick the first matching time
    # during a DST change when time would otherwise be ambiguous
    $zone_off -= 3600 if ($delta > 0 && $ref_t >= 3600);

    # Adjust for timezone
    $loc_t = $ref_t + $zone_off;

    # Are we close to a DST change or are we done
    my $dst_off = $ref_t - _timegm(localtime($loc_t))
	or return $loc_t;

    # Adjust for DST change
    $loc_t += $dst_off;

    return $loc_t if $dst_off >= 0;

    # for a negative offset from GMT, and if the original date
    # was a non-extent gap in a forward DST jump, we should
    # now have the wrong answer - undo the DST adjust;

    my ($s,$m,$h) = localtime($loc_t);
    $loc_t -= $dst_off if $s != $_[0] || $m != $_[1] || $h != $_[2];

    $loc_t;
}


sub timelocal_nocheck {
    local $Options{no_range_check} = 1;
    &timelocal;
}

1;

__END__

=head1 NAME

Time::Local - efficiently compute time from local and GMT time

=head1 SYNOPSIS

    $time = timelocal($sec,$min,$hour,$mday,$mon,$year);
    $time = timegm($sec,$min,$hour,$mday,$mon,$year);

=head1 DESCRIPTION

These routines are the inverse of built-in perl functions localtime()
and gmtime().  They accept a date as a six-element array, and return
the corresponding time(2) value in seconds since the system epoch
(Midnight, January 1, 1970 GMT on Unix, for example).  This value can
be positive or negative, though POSIX only requires support for
positive values, so dates before the system's epoch may not work on
all operating systems.

It is worth drawing particular attention to the expected ranges for
the values provided.  The value for the day of the month is the actual day
(ie 1..31), while the month is the number of months since January (0..11).
This is consistent with the values returned from localtime() and gmtime().

The timelocal() and timegm() functions perform range checking on the
input $sec, $min, $hour, $mday, and $mon values by default.  If you'd
rather they didn't, you can explicitly import the timelocal_nocheck()
and timegm_nocheck() functions.

	use Time::Local 'timelocal_nocheck';

	{
	    # The 365th day of 1999
	    print scalar localtime timelocal_nocheck 0,0,0,365,0,99;

	    # The twenty thousandth day since 1970
	    print scalar localtime timelocal_nocheck 0,0,0,20000,0,70;

	    # And even the 10,000,000th second since 1999!
	    print scalar localtime timelocal_nocheck 10000000,0,0,1,0,99;
	}

Your mileage may vary when trying these with minutes and hours,
and it doesn't work at all for months.

Strictly speaking, the year should also be specified in a form consistent
with localtime(), i.e. the offset from 1900.
In order to make the interpretation of the year easier for humans,
however, who are more accustomed to seeing years as two-digit or four-digit
values, the following conventions are followed:

=over 4

=item *

Years greater than 999 are interpreted as being the actual year,
rather than the offset from 1900.  Thus, 1964 would indicate the year
Martin Luther King won the Nobel prize, not the year 3864.

=item *

Years in the range 100..999 are interpreted as offset from 1900, 
so that 112 indicates 2012.  This rule also applies to years less than zero
(but see note below regarding date range).

=item *

Years in the range 0..99 are interpreted as shorthand for years in the
rolling "current century," defined as 50 years on either side of the current
year.  Thus, today, in 1999, 0 would refer to 2000, and 45 to 2045,
but 55 would refer to 1955.  Twenty years from now, 55 would instead refer
to 2055.  This is messy, but matches the way people currently think about
two digit dates.  Whenever possible, use an absolute four digit year instead.

=back

The scheme above allows interpretation of a wide range of dates, particularly
if 4-digit years are used.  

Please note, however, that the range of dates that can be actually be handled
depends on the size of an integer (time_t) on a given platform.  
Currently, this is 32 bits for most systems, yielding an approximate range 
from Dec 1901 to Jan 2038.

Both timelocal() and timegm() croak if given dates outside the supported
range.

=head2 Ambiguous Local Times (DST)

Because of DST changes, there are many time zones where the same local
time occurs for two different GMT times on the same day.  For example,
in the "Europe/Paris" time zone, the local time of 2001-10-28 02:30:00
can represent either 2001-10-28 00:30:00 GMT, B<or> 2001-10-28
01:30:00 GMT.

When given an ambiguous local time, the timelocal() function should
always return the epoch for the I<earlier> of the two possible GMT
times.

=head2 Non-Existent Local Times (DST)

When a DST change causes a locale clock to skip one hour forward,
there will be an hour's worth of local times that don't exist.  Again,
for the "Europe/Paris" time zone, the local clock jumped from
2001-03-25 01:59:59 to 2001-03-25 03:00:00.

If the timelocal() function is given a non-existent local time, it
will simply return an epoch value for the time one hour later.

=head2 Negative Epoch Values

Negative epoch (time_t) values are not officially supported by the
POSIX standards, so this module's tests do not test them.  On some
systems, they are known not to work.  These include MacOS (pre-OSX)
and Win32.

On systems which do support negative epoch values, this module should
be able to cope with dates before the start of the epoch, down the
minimum value of time_t for the system.

=head1 IMPLEMENTATION

These routines are quite efficient and yet are always guaranteed to agree
with localtime() and gmtime().  We manage this by caching the start times
of any months we've seen before.  If we know the start time of the month,
we can always calculate any time within the month.  The start times
are calculated using a mathematical formula. Unlike other algorithms
that do multiple calls to gmtime().

timelocal() is implemented using the same cache.  We just assume that we're
translating a GMT time, and then fudge it when we're done for the timezone
and daylight savings arguments.  Note that the timezone is evaluated for
each date because countries occasionally change their official timezones.
Assuming that localtime() corrects for these changes, this routine will
also be correct.

=head1 BUGS

The whole scheme for interpreting two-digit years can be considered a bug.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org
email list.  See http://lists.perl.org/ for more details.

Please submit bugs using the RT system at rt.cpan.org, or as a last
resort, to the datetime@perl.org list.

=head1 AUTHOR

This module is based on a Perl 4 library, timelocal.pl, that was
included with Perl 4.036, and was most likely written by Tom
Christiansen.

The current version was written by Graham Barr.

It is now being maintained separately from the Perl core by Dave
Rolsky, <autarch@urth.org>.

=cut

