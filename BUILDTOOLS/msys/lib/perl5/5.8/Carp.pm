package Carp;

our $VERSION = '1.04';

=head1 NAME

carp    - warn of errors (from perspective of caller)

cluck   - warn of errors with stack backtrace
          (not exported by default)

croak   - die of errors (from perspective of caller)

confess - die of errors with stack backtrace

shortmess - return the message that carp and croak produce

longmess - return the message that cluck and confess produce

=head1 SYNOPSIS

    use Carp;
    croak "We're outta here!";

    use Carp qw(cluck);
    cluck "This is how we got here!";

    print FH Carp::shortmess("This will have caller's details added");
    print FH Carp::longmess("This will have stack backtrace added");

=head1 DESCRIPTION

The Carp routines are useful in your own modules because
they act like die() or warn(), but with a message which is more
likely to be useful to a user of your module.  In the case of
cluck, confess, and longmess that context is a summary of every
call in the call-stack.  For a shorter message you can use carp,
croak or shortmess which report the error as being from where
your module was called.  There is no guarantee that that is where
the error was, but it is a good educated guess.

You can also alter the way the output and logic of C<Carp> works, by
changing some global variables in the C<Carp> namespace. See the
section on C<GLOBAL VARIABLES> below.

Here is a more complete description of how shortmess works.  What
it does is search the call-stack for a function call stack where
it hasn't been told that there shouldn't be an error.  If every
call is marked safe, it then gives up and gives a full stack
backtrace instead.  In other words it presumes that the first likely
looking potential suspect is guilty.  Its rules for telling whether
a call shouldn't generate errors work as follows:

=over 4

=item 1.

Any call from a package to itself is safe.

=item 2.

Packages claim that there won't be errors on calls to or from
packages explicitly marked as safe by inclusion in @CARP_NOT, or
(if that array is empty) @ISA.  The ability to override what
@ISA says is new in 5.8.

=item 3.

The trust in item 2 is transitive.  If A trusts B, and B
trusts C, then A trusts C.  So if you do not override @ISA
with @CARP_NOT, then this trust relationship is identical to,
"inherits from".

=item 4.

Any call from an internal Perl module is safe.  (Nothing keeps
user modules from marking themselves as internal to Perl, but
this practice is discouraged.)

=item 5.

Any call to Carp is safe.  (This rule is what keeps it from
reporting the error where you call carp/croak/shortmess.)

=back

=head2 Forcing a Stack Trace

As a debugging aid, you can force Carp to treat a croak as a confess
and a carp as a cluck across I<all> modules. In other words, force a
detailed stack trace to be given.  This can be very helpful when trying
to understand why, or from where, a warning or error is being generated.

This feature is enabled by 'importing' the non-existent symbol
'verbose'. You would typically enable it by saying

    perl -MCarp=verbose script.pl

or by including the string C<MCarp=verbose> in the PERL5OPT
environment variable.

Alternately, you can set the global variable C<$Carp::Verbose> to true.
See the C<GLOBAL VARIABLES> section below.

=cut

# This package is heavily used. Be small. Be fast. Be good.

# Comments added by Andy Wardley <abw@kfs.org> 09-Apr-98, based on an
# _almost_ complete understanding of the package.  Corrections and
# comments are welcome.

# The members of %Internal are packages that are internal to perl.
# Carp will not report errors from within these packages if it
# can.  The members of %CarpInternal are internal to Perl's warning
# system.  Carp will not report errors from within these packages
# either, and will not report calls *to* these packages for carp and
# croak.  They replace $CarpLevel, which is deprecated.    The
# $Max(EvalLen|(Arg(Len|Nums)) variables are used to specify how the eval
# text and function arguments should be formatted when printed.

# Comments added by Jos I. Boumans <kane@dwim.org> 11-Aug-2004
# I can not get %CarpInternal or %Internal to work as advertised,
# therefor leaving it out of the below documentation.
# $CarpLevel may be decprecated according to the last comment, but
# after 6 years, it's still around and in heavy use ;)

=pod

=head1 GLOBAL VARIABLES

=head2 $Carp::CarpLevel

This variable determines how many call frames are to be skipped when
reporting where an error occurred on a call to one of C<Carp>'s
functions. For example:

    $Carp::CarpLevel = 1;
    sub bar     { .... or _error('Wrong input') }
    sub _error  { Carp::carp(@_) }

This would make Carp report the error as coming from C<bar>'s caller,
rather than from C<_error>'s caller, as it normally would.

Defaults to C<0>.

=head2 $Carp::MaxEvalLen

This variable determines how many characters of a string-eval are to
be shown in the output. Use a value of C<0> to show all text.

Defaults to C<0>.

=head2 $Carp::MaxArgLen

This variable determines how many characters of each argument to a
function to print. Use a value of C<0> to show the full length of the
argument.

Defaults to C<64>.

=head2 $Carp::MaxArgNums

This variable determines how many arguments to each function to show.
Use a value of C<0> to show all arguments to a function call.

Defaults to C<8>.

=head2 $Carp::Verbose

This variable makes C<Carp> use the C<longmess> function at all times.
This effectively means that all calls to C<carp> become C<cluck> and
all calls to C<croak> become C<confess>.

Note, this is analogous to using C<use Carp 'verbose'>.

Defaults to C<0>.

=cut


$CarpInternal{Carp}++;
$CarpInternal{warnings}++;
$CarpLevel = 0;     # How many extra package levels to skip on carp.
                    # How many calls to skip on confess.
                    # Reconciling these notions is hard, use
                    # %Internal and %CarpInternal instead.
$MaxEvalLen = 0;    # How much eval '...text...' to show. 0 = all.
$MaxArgLen = 64;    # How much of each argument to print. 0 = all.
$MaxArgNums = 8;    # How many arguments to print. 0 = all.
$Verbose = 0;       # If true then make shortmess call longmess instead

require Exporter;
@ISA = ('Exporter');
@EXPORT = qw(confess croak carp);
@EXPORT_OK = qw(cluck verbose longmess shortmess);
@EXPORT_FAIL = qw(verbose);	# hook to enable verbose mode

=head1 BUGS

The Carp routines don't handle exception objects currently.
If called with a first argument that is a reference, they simply
call die() or warn(), as appropriate.

=cut

# if the caller specifies verbose usage ("perl -MCarp=verbose script.pl")
# then the following method will be called by the Exporter which knows
# to do this thanks to @EXPORT_FAIL, above.  $_[1] will contain the word
# 'verbose'.

sub export_fail {
    shift;
    $Verbose = shift if $_[0] eq 'verbose';
    return @_;
}


# longmess() crawls all the way up the stack reporting on all the function
# calls made.  The error string, $error, is originally constructed from the
# arguments passed into longmess() via confess(), cluck() or shortmess().
# This gets appended with the stack trace messages which are generated for
# each function call on the stack.

sub longmess {
    {
	local($@, $!);
	# XXX fix require to not clear $@ or $!?
	# don't use require unless we need to (for Safe compartments)
	require Carp::Heavy unless $INC{"Carp/Heavy.pm"};
    }
    # Icky backwards compatibility wrapper. :-(
    my $call_pack = caller();
    if ($Internal{$call_pack} or $CarpInternal{$call_pack}) {
      return longmess_heavy(@_);
    }
    else {
      local $CarpLevel = $CarpLevel + 1;
      return longmess_heavy(@_);
    }
}


# shortmess() is called by carp() and croak() to skip all the way up to
# the top-level caller's package and report the error from there.  confess()
# and cluck() generate a full stack trace so they call longmess() to
# generate that.  In verbose mode shortmess() calls longmess() so
# you always get a stack trace

sub shortmess {	# Short-circuit &longmess if called via multiple packages
    {
	local($@, $!);
	# XXX fix require to not clear $@ or $!?
	# don't use require unless we need to (for Safe compartments)
	require Carp::Heavy unless $INC{"Carp/Heavy.pm"};
    }
    # Icky backwards compatibility wrapper. :-(
    my $call_pack = caller();
    local @CARP_NOT = caller();
    shortmess_heavy(@_);
}


# the following four functions call longmess() or shortmess() depending on
# whether they should generate a full stack trace (confess() and cluck())
# or simply report the caller's package (croak() and carp()), respectively.
# confess() and croak() die, carp() and cluck() warn.

sub croak   { die  shortmess @_ }
sub confess { die  longmess  @_ }
sub carp    { warn shortmess @_ }
sub cluck   { warn longmess  @_ }

1;
