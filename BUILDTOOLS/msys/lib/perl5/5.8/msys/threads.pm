package threads;

use 5.008;
use strict;
use warnings;
use Config;

BEGIN {
    unless ($Config{useithreads}) {
	my @caller = caller(2);
        die <<EOF;
$caller[1] line $caller[2]:

This Perl hasn't been configured and built properly for the threads
module to work.  (The 'useithreads' configuration option hasn't been used.)

Having threads support requires all of Perl and all of the XS modules in
the Perl installation to be rebuilt, it is not just a question of adding
the threads module.  (In other words, threaded and non-threaded Perls
are binary incompatible.)

If you want to the use the threads module, please contact the people
who built your Perl.

Cannot continue, aborting.
EOF
    }
}

use overload
    '==' => \&equal,
    'fallback' => 1;

BEGIN {
    warn "Warning, threads::shared has already been loaded. ".
       "To enable shared variables for these modules 'use threads' ".
       "must be called before any of those modules are loaded\n"
               if($threads::shared::threads_shared);
}

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = ( all => [qw(yield)]);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
async	
);
our $VERSION = '1.07';


# || 0 to ensure compatibility with previous versions
sub equal { ($_[0]->tid == $_[1]->tid) || 0 }

# use "goto" trick to avoid pad problems from 5.8.1 (fixed in 5.8.2)
# should also be faster
sub async (&;@) { unshift @_,'threads'; goto &new }

sub object {
    return undef unless @_ > 1;
    foreach (threads->list) {
        return $_ if $_->tid == $_[1];
    }
    return undef;
}

$threads::threads = 1;

bootstrap threads $VERSION;

# why document 'new' then use 'create' in the tests!
*create = \&new;

# Preloaded methods go here.

1;
__END__

=head1 NAME

threads - Perl extension allowing use of interpreter based threads from perl

=head1 SYNOPSIS

    use threads;

    sub start_thread {
	print "Thread started\n";
    }

    my $thread  = threads->create("start_thread","argument");
    my $thread2 = $thread->create(sub { print "I am a thread"},"argument");
    my $thread3 = async { foreach (@files) { ... } };

    $thread->join();
    $thread->detach();

    $thread = threads->self();
    $thread = threads->object( $tid );

    $thread->tid();
    threads->tid();
    threads->self->tid();

    threads->yield();

    threads->list();

=head1 DESCRIPTION

Perl 5.6 introduced something called interpreter threads.  Interpreter
threads are different from "5005threads" (the thread model of Perl
5.005) by creating a new perl interpreter per thread and not sharing
any data or state between threads by default.

Prior to perl 5.8 this has only been available to people embedding
perl and for emulating fork() on windows.

The threads API is loosely based on the old Thread.pm API. It is very
important to note that variables are not shared between threads, all
variables are per default thread local.  To use shared variables one
must use threads::shared.

It is also important to note that you must enable threads by doing
C<use threads> as early as possible in the script itself and that it
is not possible to enable threading inside an C<eval "">, C<do>,
C<require>, or C<use>.  In particular, if you are intending to share
variables with threads::shared, you must C<use threads> before you
C<use threads::shared> and C<threads> will emit a warning if you do
it the other way around.

=over

=item $thread = threads->create(function, LIST)

This will create a new thread with the entry point function and give
it LIST as parameters.  It will return the corresponding threads
object, or C<undef> if thread creation failed. The new() method is an
alias for create().

=item $thread->join

This will wait for the corresponding thread to join. When the thread
finishes, join() will return the return values of the entry point
function. If the thread has been detached, an error will be thrown.

The context (void, scalar or list) of the thread creation is also the
context for join().  This means that if you intend to return an array
from a thread, you must use C<my ($thread) = threads->new(...)>, and
that if you intend to return a scalar, you must use C<my $thread = ...>.

If the program exits without all other threads having been either
joined or detached, then a warning will be issued. (A program exits
either because one of its threads explicitly calls exit(), or in the
case of the main thread, reaches the end of the main program file.)


=item $thread->detach

Will make the thread unjoinable, and cause any eventual return value
to be discarded.

=item threads->self

This will return the thread object for the current thread.

=item $thread->tid

This will return the id of the thread.  Thread IDs are integers, with
the main thread in a program being 0.  Currently Perl assigns a unique
tid to every thread ever created in your program, assigning the first
thread to be created a tid of 1, and increasing the tid by 1 for each
new thread that's created.

NB the class method C<< threads->tid() >> is a quick way to get the
current thread id if you don't have your thread object handy.

=item threads->object( tid )

This will return the thread object for the thread associated with the
specified tid.  Returns undef if there is no thread associated with the tid
or no tid is specified or the specified tid is undef.

=item threads->yield();

This is a suggestion to the OS to let this thread yield CPU time to other
threads.  What actually happens is highly dependent upon the underlying
thread implementation.

You may do C<use threads qw(yield)> then use just a bare C<yield> in your
code.

=item threads->list();

This will return a list of all non joined, non detached threads.

=item async BLOCK;

C<async> creates a thread to execute the block immediately following
it.  This block is treated as an anonymous sub, and so must have a
semi-colon after the closing brace. Like C<< threads->new >>, C<async>
returns a thread object.

=back

=head1 WARNINGS

=over 4

=item A thread exited while %d other threads were still running

A thread (not necessarily the main thread) exited while there were
still other threads running.  Usually it's a good idea to first collect
the return values of the created threads by joining them, and only then
exit from the main thread.

=back

=head1 TODO

The current implementation of threads has been an attempt to get
a correct threading system working that could be built on, 
and optimized, in newer versions of perl.

Currently the overhead of creating a thread is rather large,
also the cost of returning values can be large. These are areas
were there most likely will be work done to optimize what data
that needs to be cloned.

=head1 BUGS

=over

=item Parent-Child threads.

On some platforms it might not be possible to destroy "parent"
threads while there are still existing child "threads".

This will possibly be fixed in later versions of perl.

=item tid is I32

The thread id is a 32 bit integer, it can potentially overflow.
This might be fixed in a later version of perl.

=item Returning objects

When you return an object the entire stash that the object is blessed
as well.  This will lead to a large memory usage.  The ideal situation
would be to detect the original stash if it existed.

=item Creating threads inside BEGIN blocks

Creating threads inside BEGIN blocks (or during the compilation phase
in general) does not work.  (In Windows, trying to use fork() inside
BEGIN blocks is an equally losing proposition, since it has been
implemented in very much the same way as threads.)

=item PERL_OLD_SIGNALS are not threadsafe, will not be.

If your Perl has been built with PERL_OLD_SIGNALS (one has
to explicitly add that symbol to ccflags, see C<perl -V>),
signal handling is not threadsafe.

=back

=head1 AUTHOR and COPYRIGHT

Arthur Bergman E<lt>sky at nanisky.comE<gt>

threads is released under the same license as Perl.

Thanks to

Richard Soderberg E<lt>perl at crystalflame.netE<gt>
Helping me out tons, trying to find reasons for races and other weird bugs!

Simon Cozens E<lt>simon at brecon.co.ukE<gt>
Being there to answer zillions of annoying questions

Rocco Caputo E<lt>troc at netrus.netE<gt>

Vipul Ved Prakash E<lt>mail at vipul.netE<gt>
Helping with debugging.

please join perl-ithreads@perl.org for more information

=head1 SEE ALSO

L<threads::shared>, L<perlthrtut>, 
L<http://www.perl.com/pub/a/2002/06/11/threads.html>,
L<perlcall>, L<perlembed>, L<perlguts>

=cut
