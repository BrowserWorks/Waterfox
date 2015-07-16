package bigrat;
require 5.005;

$VERSION = '0.08';
require Exporter;
@ISA		= qw( Exporter );
@EXPORT_OK	= qw( ); 
@EXPORT		= qw( inf NaN ); 

use strict;

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
      *{"bigrat::$name"} = sub 
        {
        my $self = shift;
        no strict 'refs';
        if (defined $_[0])
          {
          Math::BigInt->$name($_[0]);
          Math::BigFloat->$name($_[0]);
          return Math::BigRat->$name($_[0]);
          }
        return Math::BigInt->$name();
        };
      return &$name;
      }
    }
 
  # delayed load of Carp and avoid recursion
  require Carp;
  Carp::croak ("Can't call bigrat\-\>$name, not a valid method");
  }

sub upgrade
  {
  my $self = shift;
  no strict 'refs';
#  if (defined $_[0])
#    {
#    $Math::BigInt::upgrade = $_[0];
#    $Math::BigFloat::upgrade = $_[0];
#    }
  return $Math::BigInt::upgrade;
  }

sub import 
  {
  my $self = shift;

  # see also bignum->import() for additional comments

  # some defaults
  my $lib = ''; my $upgrade = 'Math::BigFloat';

  my @import = ( ':constant' );				# drive it w/ constant
  my @a = @_; my $l = scalar @_; my $j = 0;
  my ($a,$p);
  my ($ver,$trace);					# version? trace?
  for ( my $i = 0; $i < $l ; $i++,$j++ )
    {
    if ($_[$i] eq 'upgrade')
      {
      # this causes upgrading
      $upgrade = $_[$i+1];		# or undef to disable
      my $s = 2; $s = 1 if @a-$j < 2;	# avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s;
      }
    elsif ($_[$i] =~ /^(l|lib)$/)
      {
      # this causes a different low lib to take care...
      $lib = $_[$i+1] || '';
      my $s = 2; $s = 1 if @a-$j < 2;	# avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s; $i++;
      }
    elsif ($_[$i] =~ /^(a|accuracy)$/)
      {
      $a = $_[$i+1];
      my $s = 2; $s = 1 if @a-$j < 2;   # avoid "can not modify non-existant..."
      splice @a, $j, $s; $j -= $s; $i++;
      }
    elsif ($_[$i] =~ /^(p|precision)$/)
      {
      $p = $_[$i+1];
      my $s = 2; $s = 1 if @a-$j < 2;   # avoid "can not modify non-existant..."
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
    else
      {
      die ("unknown option $_[$i]");
      }
    }
  my $class;
  $_lite = 0;                                   # using M::BI::L ?
  if ($trace)
    {
    require Math::BigInt::Trace; $class = 'Math::BigInt::Trace';
    $upgrade = 'Math::BigFloat::Trace';
    }
  else
    {
    # see if we can find Math::BigInt::Lite
    if (!defined $a && !defined $p)             # rounding won't work to well
      {
      eval 'require Math::BigInt::Lite;';
      if ($@ eq '')
        {
        @import = ( );                          # :constant in Lite, not MBI
        Math::BigInt::Lite->import( ':constant' );
        $_lite= 1;                              # signal okay
        }
      }
    require Math::BigInt if $_lite == 0;        # not already loaded?
    $class = 'Math::BigInt';                    # regardless of MBIL or not
    }
  push @import, 'lib' => $lib if $lib ne '';
  # Math::BigInt::Trace or plain Math::BigInt
  $class->import(@import, upgrade => $upgrade);

  require Math::BigFloat;
  Math::BigFloat->import( upgrade => 'Math::BigRat', ':constant' );
  require Math::BigRat;

  bigrat->accuracy($a) if defined $a;
  bigrat->precision($p) if defined $p;
  if ($ver)
    {
    print "bigrat\t\t\t v$VERSION\n";
    print "Math::BigInt::Lite\t v$Math::BigInt::Lite::VERSION\n" if $_lite;  
    print "Math::BigInt\t\t v$Math::BigInt::VERSION";
    my $config = Math::BigInt->config();
    print " lib => $config->{lib} v$config->{lib_version}\n";
    print "Math::BigFloat\t\t v$Math::BigFloat::VERSION\n";
    print "Math::BigRat\t\t v$Math::BigRat::VERSION\n";
    exit;
    }
  $self->export_to_level(1,$self,@a);           # export inf and NaN
  }

sub inf () { Math::BigInt->binf(); }
sub NaN () { Math::BigInt->bnan(); }

1;

__END__

=head1 NAME

bigrat - Transparent BigNumber/BigRational support for Perl

=head1 SYNOPSIS

  use bigrat;

  $x = 2 + 4.5,"\n";			# BigFloat 6.5
  print 1/3 + 1/4,"\n";			# produces 7/12

=head1 DESCRIPTION

All operators (inlcuding basic math operations) are overloaded. Integer and
floating-point constants are created as proper BigInts or BigFloats,
respectively.

Other than L<bignum>, this module upgrades to Math::BigRat, meaning that
instead of 2.5 you will get 2+1/2 as output.

=head2 Modules Used

C<bigrat> is just a thin wrapper around various modules of the Math::BigInt
family. Think of it as the head of the family, who runs the shop, and orders
the others to do the work.

The following modules are currently used by bignum:

        Math::BigInt::Lite      (for speed, and only if it is loadable)
        Math::BigInt
        Math::BigFloat
        Math::BigRat

=head2 Math Library

Math with the numbers is done (by default) by a module called
Math::BigInt::Calc. This is equivalent to saying:

	use bigrat lib => 'Calc';

You can change this by using:

	use bigrat lib => 'BitVect';

The following would first try to find Math::BigInt::Foo, then
Math::BigInt::Bar, and when this also fails, revert to Math::BigInt::Calc:

	use bigrat lib => 'Foo,Math::BigInt::Bar';

Please see respective module documentation for further details.

=head2 Sign

The sign is either '+', '-', 'NaN', '+inf' or '-inf'.

A sign of 'NaN' is used to represent the result when input arguments are not
numbers or as a result of 0/0. '+inf' and '-inf' represent plus respectively
minus infinity. You will get '+inf' when dividing a positive number by 0, and
'-inf' when dividing any negative number by 0.

=head2 Methods

Since all numbers are not objects, you can use all functions that are part of
the BigInt or BigFloat API. It is wise to use only the bxxx() notation, and not
the fxxx() notation, though. This makes you independed on the fact that the
underlying object might morph into a different class than BigFloat.

=head2 Cavaet

But a warning is in order. When using the following to make a copy of a number,
only a shallow copy will be made.

        $x = 9; $y = $x;
        $x = $y = 7;

If you want to make a real copy, use the following:

	$y = $x->copy();

Using the copy or the original with overloaded math is okay, e.g. the
following work:

        $x = 9; $y = $x;
        print $x + 1, " ", $y,"\n";     # prints 10 9

but calling any method that modifies the number directly will result in
B<both> the original and the copy beeing destroyed:

        $x = 9; $y = $x;
        print $x->badd(1), " ", $y,"\n";        # prints 10 10

        $x = 9; $y = $x;
        print $x->binc(1), " ", $y,"\n";        # prints 10 10

        $x = 9; $y = $x;
        print $x->bmul(2), " ", $y,"\n";        # prints 18 18

Using methods that do not modify, but testthe contents works:

        $x = 9; $y = $x;
        $z = 9 if $x->is_zero();                # works fine

See the documentation about the copy constructor and C<=> in overload, as
well as the documentation in BigInt for further details.

=head2 Options

bignum recognizes some options that can be passed while loading it via use.
The options can (currently) be either a single letter form, or the long form.
The following options exist:

=over 2

=item a or accuracy

This sets the accuracy for all math operations. The argument must be greater
than or equal to zero. See Math::BigInt's bround() function for details.

	perl -Mbigrat=a,50 -le 'print sqrt(20)'

=item p or precision

This sets the precision for all math operations. The argument can be any
integer. Negative values mean a fixed number of digits after the dot, while
a positive value rounds to this digit left from the dot. 0 or 1 mean round to
integer. See Math::BigInt's bfround() function for details.

	perl -Mbigrat=p,-50 -le 'print sqrt(20)'

=item t or trace

This enables a trace mode and is primarily for debugging bignum or
Math::BigInt/Math::BigFloat.

=item l or lib

Load a different math lib, see L<MATH LIBRARY>.

	perl -Mbigrat=l,GMP -e 'print 2 ** 512'

Currently there is no way to specify more than one library on the command
line. This will be hopefully fixed soon ;)

=item v or version

This prints out the name and version of all modules used and then exits.

	perl -Mbigrat=v

=head1 EXAMPLES
 
	perl -Mbigrat -le 'print sqrt(33)'
	perl -Mbigrat -le 'print 2*255'
	perl -Mbigrat -le 'print 4.5+2*255'
	perl -Mbigrat -le 'print 3/7 + 5/7 + 8/3'	
	perl -Mbigrat -le 'print 12->is_odd()';

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

Especially L<bignum>.

L<Math::BigFloat>, L<Math::BigInt>, L<Math::BigRat> and L<Math::Big> as well
as L<Math::BigInt::BitVect>, L<Math::BigInt::Pari> and  L<Math::BigInt::GMP>.

=head1 AUTHORS

(C) by Tels L<http://bloodgate.com/> in early 2002 - 2005.

=cut
