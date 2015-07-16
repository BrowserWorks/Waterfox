package bigint;
require 5.005;

$VERSION = '0.07';
use Exporter;
@ISA		= qw( Exporter );
@EXPORT_OK	= qw( ); 
@EXPORT		= qw( inf NaN ); 

use strict;
use overload;

############################################################################## 

# These are all alike, and thus faked by AUTOLOAD

my @faked = qw/round_mode accuracy precision div_scale/;
use vars qw/$VERSION $AUTOLOAD $_lite/;		# _lite for testsuite

sub AUTOLOAD
  {
  my $name = $AUTOLOAD;

  $name =~ s/.*:://;    # split package
  no strict 'refs';
  foreach my $n (@faked)
    {
    if ($n eq $name)
      {
      *{"bigint::$name"} = sub 
        {
        my $self = shift;
        no strict 'refs';
        if (defined $_[0])
          {
          return Math::BigInt->$name($_[0]);
          }
        return Math::BigInt->$name();
        };
      return &$name;
      }
    }
 
  # delayed load of Carp and avoid recursion
  require Carp;
  Carp::croak ("Can't call bigint\-\>$name, not a valid method");
  }

sub upgrade
  {
  my $self = shift;
  no strict 'refs';
#  if (defined $_[0])
#    {
#    $Math::BigInt::upgrade = $_[0];
#    }
  return $Math::BigInt::upgrade;
  }

sub _constant
  {
  # this takes a floating point constant string and returns it truncated to
  # integer. For instance, '4.5' => '4', '1.234e2' => '123' etc
  my $float = shift;

  # some simple cases first
  return $float if ($float =~ /^[+-]?[0-9]+$/);		# '+123','-1','0' etc
  return $float 
    if ($float =~ /^[+-]?[0-9]+\.?[eE]\+?[0-9]+$/);	# 123e2, 123.e+2
  return '0' if ($float =~ /^[+-]?[0]*\.[0-9]+$/);	# .2, 0.2, -.1
  if ($float =~ /^[+-]?[0-9]+\.[0-9]*$/)		# 1., 1.23, -1.2 etc
    {
    $float =~ s/\..*//;
    return $float;
    }
  my ($mis,$miv,$mfv,$es,$ev) = Math::BigInt::_split($float);
  return $float if !defined $mis; 	# doesn't look like a number to me
  my $ec = int($$ev);
  my $sign = $$mis; $sign = '' if $sign eq '+';
  if ($$es eq '-')
    {
    # ignore fraction part entirely
    if ($ec >= length($$miv))			# 123.23E-4
      {
      return '0';
      }
    return $sign . substr ($$miv,0,length($$miv)-$ec);	# 1234.45E-2 = 12
    }
  # xE+y
  if ($ec >= length($$mfv))
    {
    $ec -= length($$mfv);			
    return $sign.$$miv.$$mfv if $ec == 0;	# 123.45E+2 => 12345
    return $sign.$$miv.$$mfv.'E'.$ec; 		# 123.45e+3 => 12345e1
    }
  $mfv = substr($$mfv,0,$ec);
  return $sign.$$miv.$mfv; 			# 123.45e+1 => 1234
  }

sub import 
  {
  my $self = shift;

  # some defaults
  my $lib = '';

  my @import = ( ':constant' );				# drive it w/ constant
  my @a = @_; my $l = scalar @_; my $j = 0;
  my ($ver,$trace);					# version? trace?
  my ($a,$p);						# accuracy, precision
  for ( my $i = 0; $i < $l ; $i++,$j++ )
    {
    if ($_[$i] =~ /^(l|lib)$/)
      {
      # this causes a different low lib to take care...
      $lib = $_[$i+1] || '';
      my $s = 2; $s = 1 if @a-$j < 2;	# avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s; $i++;
      }
    elsif ($_[$i] =~ /^(a|accuracy)$/)
      {
      $a = $_[$i+1];
      my $s = 2; $s = 1 if @a-$j < 2;	# avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s; $i++;
      }
    elsif ($_[$i] =~ /^(p|precision)$/)
      {
      $p = $_[$i+1];
      my $s = 2; $s = 1 if @a-$j < 2;	# avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s; $i++;
      }
    elsif ($_[$i] =~ /^(v|version)$/)
      {
      $ver = 1;
      splice @a, $j, 1; $j --;
      }
    elsif ($_[$i] =~ /^(t|trace)$/)
      {
      $trace = 1;
      splice @a, $j, 1; $j --;
      }
    else { die "unknown option $_[$i]"; }
    }
  my $class;
  $_lite = 0;					# using M::BI::L ?
  if ($trace)
    {
    require Math::BigInt::Trace; $class = 'Math::BigInt::Trace';
    }
  else
    {
    # see if we can find Math::BigInt::Lite
    if (!defined $a && !defined $p)		# rounding won't work to well
      {
      eval 'require Math::BigInt::Lite;';
      if ($@ eq '')
        {
        @import = ( );				# :constant in Lite, not MBI
        Math::BigInt::Lite->import( ':constant' );
        $_lite= 1;				# signal okay
        }
      }
    require Math::BigInt if $_lite == 0;	# not already loaded?
    $class = 'Math::BigInt';			# regardless of MBIL or not
    }
  push @import, 'lib' => $lib if $lib ne '';
  # Math::BigInt::Trace or plain Math::BigInt
  $class->import(@import);

  bigint->accuracy($a) if defined $a;
  bigint->precision($p) if defined $p;
  if ($ver)
    {
    print "bigint\t\t\t v$VERSION\n";
    print "Math::BigInt::Lite\t v$Math::BigInt::Lite::VERSION\n" if $_lite;
    print "Math::BigInt\t\t v$Math::BigInt::VERSION";
    my $config = Math::BigInt->config();
    print " lib => $config->{lib} v$config->{lib_version}\n";
    exit;
    }
  # we take care of floating point constants, since BigFloat isn't available
  # and BigInt doesn't like them:
  overload::constant float => sub { Math::BigInt->new( _constant(shift) ); };

  $self->export_to_level(1,$self,@a);           # export inf and NaN
  }

sub inf () { Math::BigInt->binf(); }
sub NaN () { Math::BigInt->bnan(); }

1;

__END__

=head1 NAME

bigint - Transparent BigInteger support for Perl

=head1 SYNOPSIS

  use bigint;

  $x = 2 + 4.5,"\n";			# BigInt 6
  print 2 ** 512,"\n";			# really is what you think it is
  print inf + 42,"\n";			# inf
  print NaN * 7,"\n";			# NaN

=head1 DESCRIPTION

All operators (including basic math operations) are overloaded. Integer
constants are created as proper BigInts.

Floating point constants are truncated to integer. All results are also
truncated.

=head2 Options

bigint recognizes some options that can be passed while loading it via use.
The options can (currently) be either a single letter form, or the long form.
The following options exist:

=over 2

=item a or accuracy

This sets the accuracy for all math operations. The argument must be greater
than or equal to zero. See Math::BigInt's bround() function for details.

	perl -Mbigint=a,2 -le 'print 12345+1'

=item p or precision

This sets the precision for all math operations. The argument can be any
integer. Negative values mean a fixed number of digits after the dot, and
are <B>ignored</B> since all operations happen in integer space.
A positive value rounds to this digit left from the dot. 0 or 1 mean round to
integer and are ignore like negative values.

See Math::BigInt's bfround() function for details.

	perl -Mbignum=p,5 -le 'print 123456789+123'

=item t or trace

This enables a trace mode and is primarily for debugging bigint or
Math::BigInt.

=item l or lib

Load a different math lib, see L<MATH LIBRARY>.

	perl -Mbigint=l,GMP -e 'print 2 ** 512'

Currently there is no way to specify more than one library on the command
line. This will be hopefully fixed soon ;)

=item v or version

This prints out the name and version of all modules used and then exits.

	perl -Mbigint=v

=head2 Math Library

Math with the numbers is done (by default) by a module called
Math::BigInt::Calc. This is equivalent to saying:

	use bigint lib => 'Calc';

You can change this by using:

	use bigint lib => 'BitVect';

The following would first try to find Math::BigInt::Foo, then
Math::BigInt::Bar, and when this also fails, revert to Math::BigInt::Calc:

	use bigint lib => 'Foo,Math::BigInt::Bar';

Please see respective module documentation for further details.

=head2 Internal Format

The numbers are stored as objects, and their internals might change at anytime,
especially between math operations. The objects also might belong to different
classes, like Math::BigInt, or Math::BigInt::Lite. Mixing them together, even
with normal scalars is not extraordinary, but normal and expected.

You should not depend on the internal format, all accesses must go through
accessor methods. E.g. looking at $x->{sign} is not a good idea since there
is no guaranty that the object in question has such a hash key, nor is a hash
underneath at all.

=head2 Sign

The sign is either '+', '-', 'NaN', '+inf' or '-inf'.
You can access it with the sign() method.

A sign of 'NaN' is used to represent the result when input arguments are not
numbers or as a result of 0/0. '+inf' and '-inf' represent plus respectively
minus infinity. You will get '+inf' when dividing a positive number by 0, and
'-inf' when dividing any negative number by 0.

=head2 Methods

Since all numbers are now objects, you can use all functions that are part of
the BigInt API. You can only use the bxxx() notation, and not the fxxx()
notation, though. 

=head2 Caveat

But a warning is in order. When using the following to make a copy of a number,
only a shallow copy will be made.

	$x = 9; $y = $x;
	$x = $y = 7;

Using the copy or the original with overloaded math is okay, e.g. the
following work:

	$x = 9; $y = $x;
	print $x + 1, " ", $y,"\n";	# prints 10 9

but calling any method that modifies the number directly will result in
B<both> the original and the copy beeing destroyed:
	
	$x = 9; $y = $x;
	print $x->badd(1), " ", $y,"\n";	# prints 10 10
	
        $x = 9; $y = $x;
	print $x->binc(1), " ", $y,"\n";	# prints 10 10
        
	$x = 9; $y = $x;
	print $x->bmul(2), " ", $y,"\n";	# prints 18 18
	
Using methods that do not modify, but testthe contents works:

	$x = 9; $y = $x;
	$z = 9 if $x->is_zero();		# works fine

See the documentation about the copy constructor and C<=> in overload, as
well as the documentation in BigInt for further details.

=head1 MODULES USED

C<bigint> is just a thin wrapper around various modules of the Math::BigInt
family. Think of it as the head of the family, who runs the shop, and orders
the others to do the work.

The following modules are currently used by bigint:

	Math::BigInt::Lite	(for speed, and only if it is loadable)
	Math::BigInt

=head1 EXAMPLES

Some cool command line examples to impress the Python crowd ;) You might want
to compare them to the results under -Mbignum or -Mbigrat:
 
	perl -Mbigint -le 'print sqrt(33)'
	perl -Mbigint -le 'print 2*255'
	perl -Mbigint -le 'print 4.5+2*255'
	perl -Mbigint -le 'print 3/7 + 5/7 + 8/3'
	perl -Mbigint -le 'print 123->is_odd()'
	perl -Mbigint -le 'print log(2)'
	perl -Mbigint -le 'print 2 ** 0.5'
	perl -Mbigint=a,65 -le 'print 2 ** 0.2'

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

Especially L<bigrat> as in C<perl -Mbigrat -le 'print 1/3+1/4'> and
L<bignum> as in C<perl -Mbignum -le 'print sqrt(2)'>.

L<Math::BigInt>, L<Math::BigRat> and L<Math::Big> as well
as L<Math::BigInt::BitVect>, L<Math::BigInt::Pari> and  L<Math::BigInt::GMP>.

=head1 AUTHORS

(C) by Tels L<http://bloodgate.com/> in early 2002 - 2005.

=cut
