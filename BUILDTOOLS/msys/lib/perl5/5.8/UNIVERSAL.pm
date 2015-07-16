package UNIVERSAL;

our $VERSION = '1.01';

# UNIVERSAL should not contain any extra subs/methods beyond those
# that it exists to define. The use of Exporter below is a historical
# accident that can't be fixed without breaking code.  Note that we
# *don't* set @ISA here, don't want all classes/objects inheriting from
# Exporter.  It's bad enough that all classes have a import() method
# whenever UNIVERSAL.pm is loaded.
require Exporter;
*import = \&Exporter::import;
@EXPORT_OK = qw(isa can VERSION);

1;
__END__

=head1 NAME

UNIVERSAL - base class for ALL classes (blessed references)

=head1 SYNOPSIS

    $is_io = $fd->isa("IO::Handle");
    $is_io = Class->isa("IO::Handle");

    $sub = $obj->can("print");
    $sub = Class->can("print");

    use UNIVERSAL qw( isa can VERSION );
    $yes = isa $ref, "HASH" ;
    $sub = can $ref, "fandango" ;
    $ver = VERSION $obj ;

=head1 DESCRIPTION

C<UNIVERSAL> is the base class which all bless references will inherit from,
see L<perlobj>.

C<UNIVERSAL> provides the following methods and functions:

=over 4

=item C<< $obj->isa( TYPE ) >>

=item C<< CLASS->isa( TYPE ) >> 

=item C<isa( VAL, TYPE )>

Where

=over 4

=item C<TYPE>

is a package name

=item C<$obj>

is a blessed reference or a string containing a package name

=item C<CLASS>

is a package name

=item C<VAL>

is any of the above or an unblessed reference

=back

When used as an instance or class method (C<< $obj->isa( TYPE ) >>),
C<isa> returns I<true> if $obj is blessed into package C<TYPE> or
inherits from package C<TYPE>.

When used as a class method (C<< CLASS->isa( TYPE ) >>: sometimes
referred to as a static method), C<isa> returns I<true> if C<CLASS>
inherits from (or is itself) the name of the package C<TYPE> or
inherits from package C<TYPE>.

When used as a function, like

   use UNIVERSAL qw( isa ) ;
   $yes = isa $h, "HASH";
   $yes = isa "Foo", "Bar";

or

   require UNIVERSAL ;
   $yes = UNIVERSAL::isa $a, "ARRAY";

C<isa> returns I<true> in the same cases as above and also if C<VAL> is an
unblessed reference to a perl variable of type C<TYPE>, such as "HASH",
"ARRAY", or "Regexp".

=item C<< $obj->can( METHOD ) >>

=item C<< CLASS->can( METHOD ) >>

=item C<can( VAL, METHOD )>

C<can> checks if the object or class has a method called C<METHOD>. If it does
then a reference to the sub is returned. If it does not then I<undef> is
returned.  This includes methods inherited or imported by C<$obj>, C<CLASS>, or
C<VAL>.

C<can> cannot know whether an object will be able to provide a method
through AUTOLOAD, so a return value of I<undef> does not necessarily mean
the object will not be able to handle the method call. To get around
this some module authors use a forward declaration (see L<perlsub>)
for methods they will handle via AUTOLOAD. For such 'dummy' subs, C<can>
will still return a code reference, which, when called, will fall through
to the AUTOLOAD. If no suitable AUTOLOAD is provided, calling the coderef
will cause an error.

C<can> can be called as a class (static) method, an object method, or a
function.

When used as a function, if C<VAL> is a blessed reference or package name which
has a method called C<METHOD>, C<can> returns a reference to the subroutine.
If C<VAL> is not a blessed reference, or if it does not have a method
C<METHOD>, I<undef> is returned.

=item C<VERSION ( [ REQUIRE ] )>

C<VERSION> will return the value of the variable C<$VERSION> in the
package the object is blessed into. If C<REQUIRE> is given then
it will do a comparison and die if the package version is not
greater than or equal to C<REQUIRE>.

C<VERSION> can be called as either a class (static) method, an object
method or a function.


=back

=head1 EXPORTS

None by default.

You may request the import of all three functions (C<isa>, C<can>, and
C<VERSION>), however it isn't usually necessary to do so.  Perl magically
makes these functions act as methods on all objects.  The one exception is
C<isa>, which is useful as a function when operating on non-blessed
references.

=cut
