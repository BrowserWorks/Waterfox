# Test::Reporter::Date::Format
#
# Copyright (c) 1995-1999 Graham Barr. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Test::Reporter::Date::Format;

use     strict;
use     vars qw(@EXPORT @ISA $VERSION);
require Exporter;

$VERSION = "2.22";
@ISA     = qw(Exporter);
@EXPORT  = qw(time2str strftime ctime asctime);

sub time2str ($;$$)
{
 Test::Reporter::Date::Format::Generic->time2str(@_);
}

sub strftime ($\@;$)
{
 Test::Reporter::Date::Format::Generic->strftime(@_);
}

sub ctime ($;$)
{
 my($t,$tz) = @_;
 Test::Reporter::Date::Format::Generic->time2str("%a %b %e %T %Y\n", $t, $tz); 
}

sub asctime (\@;$)
{
 my($t,$tz) = @_;
 Test::Reporter::Date::Format::Generic->strftime("%a %b %e %T %Y\n", $t, $tz); 
}

##
##
##

package Test::Reporter::Date::Format::Generic;

use vars qw($epoch $tzname);
use Test::Reporter::Time::Zone;
use Time::Local;

sub ctime
{
 my($me,$t,$tz) = @_;
 $me->time2str("%a %b %e %T %Y\n", $t, $tz); 
}

sub asctime
{
 my($me,$t,$tz) = @_;
 $me->strftime("%a %b %e %T %Y\n", $t, $tz); 
}

sub _subs
{
 my $fn;
 $_[1] =~ s/
		%(O?[%a-zA-Z])
	   /
                ($_[0]->can("format_$1") || sub { $1 })->($_[0]);
	   /sgeox;

 $_[1];
}

sub strftime 
{
 my($pkg,$fmt,$time);

 ($pkg,$fmt,$time,$tzname) = @_;

 my $me = ref($pkg) ? $pkg : bless [];

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
	unless($tzname =~ /\D/);

   $epoch = timegm(@{$time}[0..5]);

   @$me = gmtime($epoch + tz_offset($tzname) - tz_offset());
  }
 else
  {
   @$me = @$time;
   undef $epoch;
  }

 _subs($me,$fmt);
}

sub time2str
{
 my($pkg,$fmt,$time);

 ($pkg,$fmt,$time,$tzname) = @_;

 my $me = ref($pkg) ? $pkg : bless [], $pkg;

 $epoch = $time;

 if(defined $tzname)
  {
   $tzname = uc $tzname;

   $tzname = sprintf("%+05d",$tzname)
	unless($tzname =~ /\D/);

   $time += tz_offset($tzname);
   @$me = gmtime($time);
  }
 else
  {
   @$me = localtime($time);
  }
 _subs($me,$fmt);
}

my(@DoW,@MoY,@DoWs,@MoYs,@AMPM,%format,@Dsuf);

@DoW = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

@MoY = qw(January February March April May June
          July August September October November December);

@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;

@AMPM = qw(AM PM);

@Dsuf = (qw(th st nd rd th th th th th th)) x 3;
@Dsuf[11,12,13] = qw(th th th);
@Dsuf[30,31] = qw(th st);

%format = ('x' => "%m/%d/%y",
           'C' => "%a %b %e %T %Z %Y",
           'X' => "%H:%M:%S",
          );

my @locale;
my $locale = "/usr/share/lib/locale/LC_TIME/default";
local *LOCALE;

if(open(LOCALE,"$locale"))
 {
  chop(@locale = <LOCALE>);
  close(LOCALE);

  @MoYs = @locale[0 .. 11];
  @MoY  = @locale[12 .. 23];
  @DoWs = @locale[24 .. 30];
  @DoW  = @locale[31 .. 37];
  @format{"X","x","C"} =  @locale[38 .. 40];
  @AMPM = @locale[41 .. 42];
 }

sub wkyr {
    my($wstart, $wday, $yday) = @_;
    $wday = ($wday + 7 - $wstart) % 7;
    return int(($yday - $wday + 13) / 7 - 1);
}

##
## these 6 formatting routins need to be *copied* into the language
## specific packages
##

my @roman = ('',qw(I II III IV V VI VII VIII IX));
sub roman {
  my $n = shift;

  $n =~ s/(\d)$//;
  my $r = $roman[ $1 ];

  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/XLC/;
    $r = $t . $r;
  }
  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/CDM/;
    $r = $t . $r;
  }
  if($n =~ s/(\d)$//) {
    (my $t = $roman[$1]) =~ tr/IVX/M../;
    $r = $t . $r;
  }
  $r;
}

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_P { lc($_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0]) }

sub format_d { sprintf("%02d",$_[0]->[3]) }
sub format_e { sprintf("%2d",$_[0]->[3]) }
sub format_H { sprintf("%02d",$_[0]->[2]) }
sub format_I { sprintf("%02d",$_[0]->[2] % 12 || 12)}
sub format_j { sprintf("%03d",$_[0]->[7] + 1) }
sub format_k { sprintf("%2d",$_[0]->[2]) }
sub format_l { sprintf("%2d",$_[0]->[2] % 12 || 12)}
sub format_L { $_[0]->[4] + 1 }
sub format_m { sprintf("%02d",$_[0]->[4] + 1) }
sub format_M { sprintf("%02d",$_[0]->[1]) }
sub format_q { sprintf("%01d",int($_[0]->[4] / 3) + 1) }
sub format_s { 
   $epoch = timegm(@{$_[0]}[0..5])
	unless defined $epoch;
   sprintf("%d",$epoch) 
}
sub format_S { sprintf("%02d",$_[0]->[0]) }
sub format_U { wkyr(0, $_[0]->[6], $_[0]->[7]) }
sub format_w { $_[0]->[6] }
sub format_W { wkyr(1, $_[0]->[6], $_[0]->[7]) }
sub format_y { sprintf("%02d",$_[0]->[5] % 100) }
sub format_Y { sprintf("%04d",$_[0]->[5] + 1900) }

sub format_Z {
 my $o = tz_local_offset(timelocal(@{$_[0]}[0..5]));
 defined $tzname ? $tzname : uc tz_name($o, $_[0]->[8]);
}

sub format_z {
 my $t = timelocal(@{$_[0]}[0..5]);
 my $o = defined $tzname ? tz_offset($tzname, $t) : tz_offset(undef,$t);
 sprintf("%+03d%02d", int($o / 3600), abs(int($o % 3600)));
}

sub format_c { &format_x . " " . &format_X }
sub format_D { &format_m . "/" . &format_d . "/" . &format_y  }      
sub format_r { &format_I . ":" . &format_M . ":" . &format_S . " " . &format_p  }   
sub format_R { &format_H . ":" . &format_M }
sub format_T { &format_H . ":" . &format_M . ":" . &format_S }
sub format_t { "\t" }
sub format_n { "\n" }
sub format_o { sprintf("%2d%s",$_[0]->[3],$Dsuf[$_[0]->[3]]) }
sub format_x { my $f = $format{'x'}; _subs($_[0],$f); }
sub format_X { my $f = $format{'X'}; _subs($_[0],$f); }
sub format_C { my $f = $format{'C'}; _subs($_[0],$f); }

sub format_Od { roman(format_d(@_)) }
sub format_Oe { roman(format_e(@_)) }
sub format_OH { roman(format_H(@_)) }
sub format_OI { roman(format_I(@_)) }
sub format_Oj { roman(format_j(@_)) }
sub format_Ok { roman(format_k(@_)) }
sub format_Ol { roman(format_l(@_)) }
sub format_Om { roman(format_m(@_)) }
sub format_OM { roman(format_M(@_)) }
sub format_Oq { roman(format_q(@_)) }
sub format_Oy { roman(format_y(@_)) }
sub format_OY { roman(format_Y(@_)) }

1;
__END__

=head1 NAME

Test::Reporter::Date::Format - Date formating subroutines

=head1 SYNOPSIS

	use Test::Reporter::Date::Format;
	
	@lt = localtime(time);
	
	print time2str($template, time);
	print strftime($template, @lt);
	
	print time2str($template, time, $zone);
	print strftime($template, @lt, $zone);
	
	print ctime(time);
	print asctime(@lt);
	
	print ctime(time, $zone);
	print asctime(@lt, $zone);

=head1 DESCRIPTION

This module provides routines to format dates into ASCII strings. They
correspond to the C library routines C<strftime> and C<ctime>.

=over 4

=item time2str(TEMPLATE, TIME [, ZONE])

C<time2str> converts C<TIME> into an ASCII string using the conversion
specification given in C<TEMPLATE>. C<ZONE> if given specifies the zone
which the output is required to be in, C<ZONE> defaults to your current zone.


=item strftime(TEMPLATE, TIME [, ZONE])

C<strftime> is similar to C<time2str> with the exception that the time is
passed as an array, such as the array returned by C<localtime>.

=item ctime(TIME [, ZONE])

C<ctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=item asctime(TIME [, ZONE])

C<asctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=back

=head1 MULTI-LANGUAGE SUPPORT

Test::Reporter::Date::Format is capable of formating into several languages, these are
English, French, German and Italian. Changing the language is done via
a static method call, for example

	Test::Reporter::Date::Format->language('German');

will change the language in which all subsequent dates are formatted.

This is only a first pass, I am considering changing this to be

	$lang = Date::Language->new('German');
	$lang->time2str("%a %b %e %T %Y\n", time);

I am open to suggestions on this.

=head1 CONVERSION SPECIFICATION

Each conversion specification  is  replaced  by  appropriate
characters   as   described  in  the  following  list.   The
appropriate  characters  are  determined  by   the   LC_TIME
category of the program's locale.

	%%	PERCENT
	%a	day of the week abbr
	%A	day of the week
	%b	month abbr
	%B 	month
	%c	MM/DD/YY HH:MM:SS
	%C 	ctime format: Sat Nov 19 21:05:57 1994
	%d 	numeric day of the month, with leading zeros (eg 01..31)
	%e 	numeric day of the month, without leading zeros (eg 1..31)
	%D 	MM/DD/YY
	%h 	month abbr
	%H 	hour, 24 hour clock, leading 0's)
	%I 	hour, 12 hour clock, leading 0's)
	%j 	day of the year
	%k 	hour
	%l 	hour, 12 hour clock
	%L 	month number, starting with 1
	%m 	month number, starting with 01
	%M 	minute, leading 0's
	%n 	NEWLINE
	%o	ornate day of month -- "1st", "2nd", "25th", etc.
	%p 	AM or PM 
	%P 	am or pm (Yes %p and %P are backwards :)
	%q	Quarter number, starting with 1
	%r 	time format: 09:05:57 PM
	%R 	time format: 21:05
	%s	seconds since the Epoch, UCT
	%S 	seconds, leading 0's
	%t 	TAB
	%T 	time format: 21:05:57
	%U 	week number, Sunday as first day of week
	%w 	day of the week, numerically, Sunday == 0
	%W 	week number, Monday as first day of week
	%x 	date format: 11/19/94
	%X 	time format: 21:05:57
	%y	year (2 digits)
	%Y	year (4 digits)
	%Z 	timezone in ascii. eg: PST
	%z	timezone in format -/+0000

C<%d>, C<%e>, C<%H>, C<%I>, C<%j>, C<%k>, C<%l>, C<%m>, C<%M>, C<%q>,
C<%y> and C<%Y> can be output in Roman numerals by prefixing the letter
with C<O>, e.g. C<%OY> will output the year as roman numerals.

=head1 AUTHOR

Graham Barr <gbarr@pobox.com>

=head1 COPYRIGHT

Copyright (c) 1995-1999 Graham Barr. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut


