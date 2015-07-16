package Thread;

use strict;

our($VERSION, $ithreads, $othreads);

BEGIN {
    $VERSION = '2.00';
    use Config;
    $ithreads = $Config{useithreads};
    $othreads = $Config{use5005threads};
}

require Exporter;
use XSLoader ();
our(@ISA, @EXPORT, @EXPORT_OK);

@ISA = qw(Exporter);

BEGIN {
    if ($ithreads) {
	@EXPORT = qw(cond_wait cond_broadcast cond_signal)
    } elsif ($othreads) {
	@EXPORT_OK = qw(cond_signal cond_broadcast cond_wait);
    }
    push @EXPORT_OK, qw(async yield);
}

=head1 NAME

Thread - manipulate threads in Perl (for old code only)

=head1 CAVEAT

Perl has two thread models.

In Perl 5.005 the thread model was that all data is implicitly shared
and shared access to data has to be explicitly synchronized.
This model is called "5005threads".

In Perl 5.6 a new model was introduced in which all is was thread
local and shared access to data has to be explicitly declared.
This model is called "ithreads", for "interpreter threads".

In Perl 5.6 the ithreads model was not available as a public API,
only as an internal API that was available for extension writers,
and to implement fork() emulation on Win32 platforms.

In Perl 5.8 the ithreads model became available through the C<threads>
module.

Neither model is configured by default into Perl (except, as mentioned
above, in Win32 ithreads are always available.)  You can see your
Perl's threading configuration by running C<perl -V> and looking for
the I<use...threads> variables, or inside script by C<use Config;>
and testing for C<$Config{use5005threads}> and C<$Config{useithreads}>.

For old code and interim backwards compatibility, the Thread module
has been reworked to function as a frontend for both 5005threads and
ithreads.

Note that the compatibility is not complete: because the data sharing
models are directly opposed, anything to do with data sharing has to
be thought differently.  With the ithreads you must explicitly share()
variables between the threads.

For new code the use of the C<Thread> module is discouraged and
the direct use of the C<threads> and C<threads::shared> modules
is encouraged instead.

Finally, note that there are many known serious problems with the
5005threads, one of the least of which is that regular expression
match variables like $1 are not threadsafe, that is, they easily get
corrupted by competing threads.  Other problems include more insidious
data corruption and mysterious crashes.  You are seriously urged to
use ithreads instead.

=head1 SYNOPSIS

    use Thread;

    my $t = Thread->new(\&start_sub, @start_args);

    $result = $t->join;
    $result = $t->eval;
    $t->detach;

    if ($t->done) {
        $t->join;
    }

    if($t->equal($another_thread)) {
    	# ...
    }

    yield();

    my $tid = Thread->self->tid; 

    lock($scalar);
    lock(@array);
    lock(%hash);

    lock(\&sub);	# not available with ithreads

    $flags = $t->flags;	# not available with ithreads

    my @list = Thread->list;	# not available with ithreads

    use Thread 'async';

=head1 DESCRIPTION

The C<Thread> module provides multithreading support for perl.

=head1 FUNCTIONS

=over 8

=item $thread = Thread->new(\&start_sub)

=item $thread = Thread->new(\&start_sub, LIST)

C<new> starts a new thread of execution in the referenced subroutine. The
optional list is passed as parameters to the subroutine. Execution
continues in both the subroutine and the code after the C<new> call.

C<Thread-&gt;new> returns a thread object representing the newly created
thread.

=item lock VARIABLE

C<lock> places a lock on a variable until the lock goes out of scope.

If the variable is locked by another thread, the C<lock> call will
block until it's available.  C<lock> is recursive, so multiple calls
to C<lock> are safe--the variable will remain locked until the
outermost lock on the variable goes out of scope.

Locks on variables only affect C<lock> calls--they do I<not> affect normal
access to a variable. (Locks on subs are different, and covered in a bit.)
If you really, I<really> want locks to block access, then go ahead and tie
them to something and manage this yourself.  This is done on purpose.
While managing access to variables is a good thing, Perl doesn't force
you out of its living room...

If a container object, such as a hash or array, is locked, all the
elements of that container are not locked. For example, if a thread
does a C<lock @a>, any other thread doing a C<lock($a[12])> won't
block.

With 5005threads you may also C<lock> a sub, using C<lock &sub>.
Any calls to that sub from another thread will block until the lock
is released. This behaviour is not equivalent to declaring the sub
with the C<locked> attribute.  The C<locked> attribute serializes
access to a subroutine, but allows different threads non-simultaneous
access. C<lock &sub>, on the other hand, will not allow I<any> other
thread access for the duration of the lock.

Finally, C<lock> will traverse up references exactly I<one> level.
C<lock(\$a)> is equivalent to C<lock($a)>, while C<lock(\\$a)> is not.

=item async BLOCK;

C<async> creates a thread to execute the block immediately following
it.  This block is treated as an anonymous sub, and so must have a
semi-colon after the closing brace. Like C<Thread-&gt;new>, C<async>
returns a thread object.

=item Thread->self

The C<Thread-E<gt>self> function returns a thread object that represents
the thread making the C<Thread-E<gt>self> call.

=item cond_wait VARIABLE

The C<cond_wait> function takes a B<locked> variable as
a parameter, unlocks the variable, and blocks until another thread
does a C<cond_signal> or C<cond_broadcast> for that same locked
variable. The variable that C<cond_wait> blocked on is relocked
after the C<cond_wait> is satisfied.  If there are multiple threads
C<cond_wait>ing on the same variable, all but one will reblock waiting
to reaquire the lock on the variable.  (So if you're only using
C<cond_wait> for synchronization, give up the lock as soon as
possible.)

=item cond_signal VARIABLE

The C<cond_signal> function takes a locked variable as a parameter and
unblocks one thread that's C<cond_wait>ing on that variable. If more than
one thread is blocked in a C<cond_wait> on that variable, only one (and
which one is indeterminate) will be unblocked.

If there are no threads blocked in a C<cond_wait> on the variable,
the signal is discarded.

=item cond_broadcast VARIABLE

The C<cond_broadcast> function works similarly to C<cond_signal>.
C<cond_broadcast>, though, will unblock B<all> the threads that are
blocked in a C<cond_wait> on the locked variable, rather than only
one.

=item yield

The C<yield> function allows another thread to take control of the
CPU. The exact results are implementation-dependent.

=back

=head1 METHODS

=over 8

=item join

C<join> waits for a thread to end and returns any values the thread
exited with.  C<join> will block until the thread has ended, though
it won't block if the thread has already terminated.

If the thread being C<join>ed C<die>d, the error it died with will
be returned at this time. If you don't want the thread performing
the C<join> to die as well, you should either wrap the C<join> in
an C<eval> or use the C<eval> thread method instead of C<join>.

=item eval

The C<eval> method wraps an C<eval> around a C<join>, and so waits for
a thread to exit, passing along any values the thread might have returned.
Errors, of course, get placed into C<$@>.  (Not available with ithreads.)

=item detach

C<detach> tells a thread that it is never going to be joined i.e.
that all traces of its existence can be removed once it stops running.
Errors in detached threads will not be visible anywhere - if you want
to catch them, you should use $SIG{__DIE__} or something like that.

=item equal 

C<equal> tests whether two thread objects represent the same thread and
returns true if they do.

=item tid

The C<tid> method returns the tid of a thread. The tid is
a monotonically increasing integer assigned when a thread is
created. The main thread of a program will have a tid of zero,
while subsequent threads will have tids assigned starting with one.

=item flags

The C<flags> method returns the flags for the thread. This is the
integer value corresponding to the internal flags for the thread,
and the value may not be all that meaningful to you.
(Not available with ithreads.)

=item done

The C<done> method returns true if the thread you're checking has
finished, and false otherwise.  (Not available with ithreads.)

=back

=head1 LIMITATIONS

The sequence number used to assign tids is a simple integer, and no
checking is done to make sure the tid isn't currently in use.  If a
program creates more than 2**32 - 1 threads in a single run, threads
may be assigned duplicate tids.  This limitation may be lifted in
a future version of Perl.

=head1 SEE ALSO

L<threads::shared> (not available with 5005threads)

L<attributes>, L<Thread::Queue>, L<Thread::Semaphore>,
L<Thread::Specific> (not available with ithreads)

=cut

#
# Methods
#

#
# Exported functions
#

sub async (&) {
    return Thread->new($_[0]);
}

sub eval {
    return eval { shift->join; };
}

sub unimplemented {
    print $_[0], " unimplemented with ",
          $Config{useithreads} ? "ithreads" : "5005threads", "\n";

}

sub unimplement {
    for my $m (@_) {
	no strict 'refs';
	*{"Thread::$m"} = sub { unimplemented $m };
    }
}

BEGIN {
    if ($ithreads) {
	if ($othreads) {
	    require Carp;
	    Carp::croak("This Perl has both ithreads and 5005threads (serious malconfiguration)");
	}
	XSLoader::load 'threads';
	for my $m (qw(new join detach yield self tid equal list)) {
	    no strict 'refs';
	    *{"Thread::$m"} = \&{"threads::$m"};
	}
	require 'threads/shared.pm';
	for my $m (qw(cond_signal cond_broadcast cond_wait)) {
	    no strict 'refs';
	    *{"Thread::$m"} = \&{"threads::shared::${m}_enabled"};
	}
	# trying to unimplement eval gives redefined warning
	unimplement(qw(done flags));
    } elsif ($othreads) {
	XSLoader::load 'Thread';
    } else {
	require Carp;
	Carp::croak("This Perl has neither ithreads nor 5005threads");
    }
}

1;
