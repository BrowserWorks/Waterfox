package B::Generate;

require 5.005_62;
use strict;
use warnings;
use B;

require DynaLoader;
use vars qw( @ISA $VERSION );
@ISA = qw(DynaLoader);
$VERSION = '1.09';

{
    # 'no warnings' does not work.
    local $SIG{__WARN__} = sub {
        return if $_[0] =~ /Subroutine B(?:::\w+)+ redefined/;
        warn $_[0];
    };
    B::Generate->bootstrap($VERSION);
}

package B::OP;
use constant OP_LIST    => 141;    # MUST FIX CONSTANTS.
use constant OPf_PARENS => 8;      # *MUST* *FIX* *CONSTANTS*.
use constant OPf_KIDS   => 4;

# This is where we implement op.c in Perl. Sssh.
sub linklist {
    my $o = shift;
    if ( $o->can("first") and $o->first and ${ $o->first } ) {
        $o->next( $o->first->linklist );
        for ( my $kid = $o->first; $$kid; $kid = $kid->sibling ) {
            if ( ${ $kid->sibling } ) {
                $kid->next( $kid->sibling->linklist );
            }
            else {
                $kid->next($o);
            }
        }
    }
    else {
        $o->next($o);
    }
    $o->clean;
    return $o->next;
}

sub append_elem {
    my ( $class, $type, $first, $last ) = @_;
    return $last  unless $first and $$first;
    return $first unless $last  and $$last;

    if ( $first->type() != $type
        or ( $type == OP_LIST and ( $first->flags & OPf_PARENS ) ) )
    {
        return B::LISTOP->new( $type, 0, $first, $last );
    }

    if ( $first->flags() & OPf_KIDS ) {

        $first->last->sibling($last);
    }
    else {
        $first->flags( $first->flags | OPf_KIDS );
        $first->first($last);
    }
    $first->last($last);
    return $first;
}

sub prepend_elem {
    my ( $class, $type, $first, $last ) = @_;
    if ( $last->type() != $type ) {
        return B::LISTOP->new( $type, 0, $first, $last );
    }

    if ( $type == OP_LIST ) {
        $first->sibling( $last->first->sibling );
        $last->first->sibling($first);
        $last->flags( $last->flags & ~OPf_PARENS )
            unless ( $first->flags & OPf_PARENS );
    }
    else {
        unless ( $last->flags & OPf_KIDS ) {
            $last->last($first);
            $last->flags( $last->flags | OPf_KIDS );
        }
        $first->sibling( $last->first );
        $last->first($first);
    }
    $last->flags( $last->flags | OPf_KIDS );
    return $last;    # I cannot believe this works.
}

sub scope {
    my $o = shift;
    return unless $o and $$o;
    if ( $o->flags & OPf_PARENS ) {
        $o = B::OP->prepend_elem( B::opnumber("lineseq"),
            B::OP->new( "enter", 0 ), $o );
        $o->type( B::opnumber("leave") );
    }
    else {
        if ( $o->type == B::opnumber("lineseq") ) {
            my $kid;
            $o->type( B::opnumber("scope") );
            $kid = $o->first;
            die "This probably shouldn't happen (\$kid->null)\n"
                if ( $kid->type == B::opnumber("nextstate")
                or $kid->type == B::opnumber("dbstate") );
        }
        else {
            $o = B::LISTOP->new( "scope", 0, $o, undef );
        }
    }
    return ($o);
}

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

B::Generate - Create your own op trees. 

=head1 SYNOPSIS

    use B::Generate;
    # Do nothing, slowly.
      CHECK {
        my $null = new B::OP("null",0);
        my $enter = new B::OP("enter",0);
        my $cop = new B::COP(0, "hiya", 0);
        my $leave = new B::LISTOP("leave", 0, $enter, $null);
        $leave->children(3);
        $enter->sibling($cop);
        $enter->next($cop);
        $cop->sibling($null);
        $null->next($leave);
        $cop->next($leave);

        # Tell Perl where to find our tree.
        B::main_root($leave);
        B::main_start($enter);
      }

=head1 WARNING

This module will create segmentation faults if you don't know how to
use it properly. Further warning: sometimes B<I> don't know how to use
it properly.

There B<are> lots of other methods and utility functions, but they are
not documented here. This is deliberate, rather than just through
laziness. You are expected to have read the Perl and XS sources to this
module before attempting to do anything with it.

Patches welcome.

=head1 DESCRIPTION

Malcolm Beattie's C<B> module allows you to examine the Perl op tree at
runtime, in Perl space; it's the basis of the Perl compiler. But what it
doesn't let you do is manipulate that op tree: it won't let you create
new ops, or modify old ones. Now you can.

Well, if you're intimately familiar with Perl's internals, you can.

C<B::Generate> turns C<B>'s accessor methods into get-set methods.
Hence, instead of merely saying

    $op2 = $op->next;

you can now say

    $op->next($op2);

to set the next op in the chain. It also adds constructor methods to
create new ops. This is where it gets really hairy.

    new B::OP     ( type, flags )
    new B::UNOP   ( type, flags, first )
    new B::BINOP  ( type, flags, first, last )
    new B::LOGOP  ( type, flags, first, other )
    new B::LISTOP ( type, flags, first, last )
    new B::COP    ( flags, name, first )

In all of the above constructors, C<type> is either a numeric value
representing the op type (C<62> is the addition operator, for instance)
or the name of the op. (C<"add">)

(Incidentally, if you know about custom ops and have registed them
properly with the interpreter, you can create custom ops by name: 
C<new B::OP("mycustomop",0)>, or whatever.)

C<first>, C<last> and C<other> are ops to be attached to the current op;
these should be C<B::OP> objects. If you haven't created the ops yet,
don't worry; give a false value, and fill them in later:

    $x = new B::UNOP("negate", 0, undef);
    # ... create some more ops ...
    $x->first($y);

In addition, one may create a new C<nextstate> operator with

    newstate B::op ( flags, label, op)

in the same manner as C<B::COP::new> - this will also, however, add the
C<lineseq> op.

Finally, you can set the main root and the starting op by passing ops
to the C<B::main_root> and C<B::main_start> functions.

This module can obviously be used for all sorts of fun purposes. The
best one will be in conjuction with source filters; have your source
filter parse an input file in a foreign language, create an op tree for
it and get Perl to execute it. Then email me and tell me how you did it.
And why.

=head2 OTHER METHODS

=over 3

=item  $b_sv->sv

Returns a real SV instead of a C<B::SV>. For instance:

    $b_sv = $svop->sv;
    if ($b_sv->sv == 3) {
        print "SVOP's SV has an IV of 3\n"
    }

You can't use this to set the SV. That would be scary.

=item $op->dump

Runs C<Perl_op_dump> on an op; this is roughly equivalent to
C<B::Debug>, but not quite.

=item $b_sv->dump

Runs C<Perl_sv_dump> on an SV; this is exactly equivalent to
C<< Devel::Peek::dump($b_sv->sv) >>

=item $b_op->linklist

Sets the C<op_next> pointers in the tree in correct execution order, 
overwriting the old C<next> pointers. You B<need> to do this once you've
created an op tree for execution, unless you've carefully threaded it
together yourself.

=back

=head2 EXPORT

None.

=head1 AUTHOR

Simon Cozens, C<simon@cpan.org>
(Who else?)

=head1 MAINTAINERS

This is just a list of people who have submitted patches to the
module. To find someone to actually maintain this, please try
contacting perl5-porters.

Josh ben Jore, Michael Schwern, Jim Cromie, Scott Walters.

=head1 SEE ALSO

L<B>, F<perlguts>, F<op.c>

=cut
