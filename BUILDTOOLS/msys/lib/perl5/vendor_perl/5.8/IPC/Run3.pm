package IPC::Run3;

=head1 NAME

IPC::Run3 - run a subprocess in batch mode (a la system) on Unix, Win32, etc.

=head1 VERSION

version 0.037

=cut

$VERSION = '0.037';

=head1 SYNOPSIS

    use IPC::Run3;    # Exports run3() by default

    run3 \@cmd, \$in, \$out, \$err;
    run3 \@cmd, \@in, \&out, \$err;

=head1 DESCRIPTION

This module allows you to run a subprocess and redirect stdin, stdout,
and/or stderr to files and perl data structures.  It aims to satisfy 99% of the
need for using C<system>, C<qx>, and C<open3> with a simple, extremely Perlish
API and none of the bloat and rarely used features of IPC::Run.

Speed, simplicity, and portability are paramount.  (That's speed of Perl code;
which is often much slower than the kind of buffered I/O that this module uses
to spool input to and output from the child command.) Disk space is not.

=head2 C<< run3(\@cmd, INPUT, OUTPUT, \$err) >>

Note that passing in a reference to C<undef> explicitly redirects the
associated file descriptor for C<STDIN>, C<STDOUT>, or C<STDERR> from or to the
local equivalent of C</dev/null> (this does I<not> pass a closed filehandle).
Passing in C<undef> (or not passing a redirection) allows the child to inherit
the corresponding C<STDIN>, C<STDOUT>, or C<STDERR> from the parent.

Because the redirects come last, this allows C<STDOUT> and C<STDERR> to default
to the parent's by just not specifying them -- a common use case.

B<Note>: This means that:

    run3 \@cmd, undef, \$out;   # Pass on parent's STDIN

B<does not close the child's STDIN>, it passes on the parent's.  Use

    run3 \@cmd, \undef, \$out;  # Close child's STDIN

for that.  It's not ideal, but it does work.

If the exact same value is passed for C<$stdout> and C<$stderr>, then the child
will write both to the same filehandle.  In general, this means that

    run3 \@cmd, \undef, "foo.txt", "foo.txt";
    run3 \@cmd, \undef, \$both, \$both;

will DWYM and pass a single file handle to the child for both C<STDOUT> and
C<STDERR>, collecting all into C<$both>.

C<run3> returns true if the command executes and throws an exception otherwise.
It should leave C<$?> intact for inspection of exit and wait status.

=head1 DEBUGGING

To enable debugging use the IPCRUN3DEBUG environment variable to
a non-zero integer value:

    $ IPCRUN3DEBUG=1 myapp

=head1 PROFILING

To enable profiling, set IPCRUN3PROFILE to a number to enable emitting profile
information to STDERR (1 to get timestamps, 2 to get a summary report at the
END of the program, 3 to get mini reports after each run) or to a filename to
emit raw data to a file for later analysis.

=head1 COMPARISON

Here's how it stacks up to existing APIs:

=over

=item compared to C<system()>, C<qx''>, C<open "...|">, C<open "|...">:

=over

=item + redirects more than one file descriptor

=item + returns TRUE on success, FALSE on failure

=item + throws an error if problems occur in the parent process (or the pre-exec child)

=item + allows a very perlish interface to Perl data structures and subroutines

=item + allows 1 word invocations to avoid the shell easily:

 run3 ["foo"];  # does not invoke shell

=item - does not return the exit code, leaves it in $?

=back

=item compared to C<open2()>, C<open3()>:

=over

=item + No lengthy, error prone polling / select loop needed

=item + Hides OS dependancies

=item + Allows SCALAR, ARRAY, and CODE references to source and sink I/O

=item + I/O parameter order is like open3()  (not like open2()).

=item - Does not allow interaction with the subprocess

=back

=item compared to C<IPC::Run::run()>:

=over

=item + Smaller, lower overhead, simpler, more portable

=item + No select() loop portability issues

=item + Does not fall prey to Perl closure leaks

=item - Does not allow interaction with the subprocess (which
IPC::Run::run() allows by redirecting subroutines).

=item - Lacks many features of IPC::Run::run() (filters, pipes,
redirects, pty support).

=back

=back

=cut

@EXPORT = qw( run3 );
%EXPORT_TAGS = ( all => \@EXPORT );
@ISA = qw( Exporter );
use Exporter;

use strict;
use constant debugging => $ENV{IPCRUN3DEBUG} || $ENV{IPCRUNDEBUG} || 0;
use constant profiling => $ENV{IPCRUN3PROFILE} || $ENV{IPCRUNPROFILE} || 0;
use constant is_win32  => 0 <= index $^O, "Win32";

BEGIN {
   if ( is_win32 ) {
      eval "use Win32 qw( GetOSName ); 1" or die $@;
   }
}

#use constant is_win2k => is_win32 && GetOSName() =~ /Win2000/i;
#use constant is_winXP => is_win32 && GetOSName() =~ /WinXP/i;

use Carp qw( croak );
use File::Temp qw( tempfile );
use POSIX qw( dup dup2 );

# We cache the handles of our temp files in order to
# keep from having to incur the (largish) overhead of File::Temp
my %fh_cache;
my $fh_cache_pid = $$;

my $profiler;

sub _profiler { $profiler } # test suite access

BEGIN {
    if ( profiling ) {
        eval "use Time::HiRes qw( gettimeofday ); 1" or die $@;
        if ( $ENV{IPCRUN3PROFILE} =~ /\A\d+\z/ ) {
            require IPC::Run3::ProfPP;
            IPC::Run3::ProfPP->import;
            $profiler = IPC::Run3::ProfPP->new(Level => $ENV{IPCRUN3PROFILE});
        } else {
            my ( $dest, undef, $class ) =
               reverse split /(=)/, $ENV{IPCRUN3PROFILE}, 2;
            $class = "IPC::Run3::ProfLogger"
                unless defined $class && length $class;
            if ( not eval "require $class" ) {
                my $e = $@;
                $class = "IPC::Run3::$class";
                eval "require IPC::Run3::$class" or die $e;
            }
            $profiler = $class->new( Destination => $dest );
        }
        $profiler->app_call( [ $0, @ARGV ], scalar gettimeofday() );
    }
}


END {
    $profiler->app_exit( scalar gettimeofday() ) if profiling;
}

sub _spool_data_to_child {
    my ( $type, $source, $binmode_it ) = @_;

    # If undef (not \undef) passed, they want the child to inherit
    # the parent's STDIN.
    return undef unless defined $source;
    warn "binmode()ing STDIN\n" if is_win32 && debugging && $binmode_it;

    my $fh;
    if ( ! $type ) {
        local *FH;  # Do this the backcompat way
        open FH, "<$source" or croak "$!: $source";
        $fh = *FH{IO};
        if ( is_win32 ) {
            binmode $fh, ":raw"; # Remove all layers
            binmode $fh, ":crlf" unless $binmode_it;
        }
        warn "run3(): feeding file '$source' to child STDIN\n"
            if debugging >= 2;
    } elsif ( $type eq "FH" ) {
        $fh = $source;
        warn "run3(): feeding filehandle '$source' to child STDIN\n"
            if debugging >= 2;
    } else {
        $fh = $fh_cache{in} ||= tempfile;
        truncate $fh, 0;
        seek $fh, 0, 0;
        if ( is_win32 ) {
            binmode $fh, ":raw"; # Remove any previous layers
            binmode $fh, ":crlf" unless $binmode_it;
        }
        my $seekit;
        if ( $type eq "SCALAR" ) {

            # When the run3()'s caller asks to feed an empty file
            # to the child's stdin, we want to pass a live file
            # descriptor to an empty file (like /dev/null) so that
            # they don't get surprised by invalid fd errors and get
            # normal EOF behaviors.
            return $fh unless defined $$source;  # \undef passed

            warn "run3(): feeding SCALAR to child STDIN",
                debugging >= 3
                   ? ( ": '", $$source, "' (", length $$source, " chars)" )
                   : (),
                "\n"
                if debugging >= 2;

            $seekit = length $$source;
            print $fh $$source or die "$! writing to temp file";

        } elsif ( $type eq "ARRAY" ) {
            warn "run3(): feeding ARRAY to child STDIN",
                debugging >= 3 ? ( ": '", @$source, "'" ) : (),
                "\n"
            if debugging >= 2;

            print $fh @$source or die "$! writing to temp file";
            $seekit = grep length, @$source;
        } elsif ( $type eq "CODE" ) {
            warn "run3(): feeding output of CODE ref '$source' to child STDIN\n"
                if debugging >= 2;
            my $parms = [];  # TODO: get these from $options
            while (1) {
                my $data = $source->( @$parms );
                last unless defined $data;
                print $fh $data or die "$! writing to temp file";
                $seekit = length $data;
            }
        }

        seek $fh, 0, 0 or croak "$! seeking on temp file for child's stdin"
            if $seekit;
    }

    croak "run3() can't redirect $type to child stdin"
        unless defined $fh;

    return $fh;
}

sub _fh_for_child_output {
    my ( $what, $type, $dest, $binmode_it ) = @_;

    my $fh;
    if ( $type eq "SCALAR" && $dest == \undef ) {
        warn "run3(): redirecting child $what to oblivion\n"
            if debugging >= 2;

        $fh = $fh_cache{nul} ||= do {
            local *FH;
            open FH, ">" . File::Spec->devnull;
            *FH{IO};
        };
    } elsif ( $type eq "FH" ) {
        $fh = $dest;
        warn "run3(): redirecting $what to filehandle '$dest'\n"
            if debugging >= 3;
    } elsif ( !$type ) {
        warn "run3(): feeding child $what to file '$dest'\n"
            if debugging >= 2;

        local *FH;
        open FH, ">$dest" or croak "$!: $dest";
        $fh = *FH{IO};
    } else {
        warn "run3(): capturing child $what\n"
            if debugging >= 2;

        $fh = $fh_cache{$what} ||= tempfile;
        seek $fh, 0, 0;
        truncate $fh, 0;
    }

    if ( is_win32 ) {
        warn "binmode()ing $what\n" if debugging && $binmode_it;
        binmode $fh, ":raw";
        binmode $fh, ":crlf" unless $binmode_it;
    }
    return $fh;
}

sub _read_child_output_fh {
    my ( $what, $type, $dest, $fh, $options ) = @_;

    return if $type eq "SCALAR" && $dest == \undef;

    seek $fh, 0, 0 or croak "$! seeking on temp file for child $what";

    if ( $type eq "SCALAR" ) {
        warn "run3(): reading child $what to SCALAR\n"
            if debugging >= 3;

        # two read()s are used instead of 1 so that the first will be
        # logged even it reads 0 bytes; the second won't.
        my $count = read $fh, $$dest, 10_000;
        while (1) {
            croak "$! reading child $what from temp file"
                unless defined $count;

            last unless $count;

            warn "run3(): read $count bytes from child $what",
                debugging >= 3 ? ( ": '", substr( $$dest, -$count ), "'" ) : (),
                "\n"
                if debugging >= 2;

            $count = read $fh, $$dest, 10_000, length $$dest;
        }
    } elsif ( $type eq "ARRAY" ) {
        @$dest = <$fh>;
        if ( debugging >= 2 ) {
            my $count = 0;
            $count += length for @$dest;
            warn
                "run3(): read ",
                scalar @$dest,
                " records, $count bytes from child $what",
                debugging >= 3 ? ( ": '", @$dest, "'" ) : (),
                "\n";
        }
    } elsif ( $type eq "CODE" ) {
        warn "run3(): capturing child $what to CODE ref\n"
            if debugging >= 3;

        local $_;
        while ( <$fh> ) {
            warn
                "run3(): read ",
                length,
                " bytes from child $what",
                debugging >= 3 ? ( ": '", $_, "'" ) : (),
                "\n"
                if debugging >= 2;

            $dest->( $_ );
        }
    } else {
        croak "run3() can't redirect child $what to a $type";
    }

}

sub _type {
    my ( $redir ) = @_;
    return "FH" if eval { $redir->isa("IO::Handle") };
    my $type = ref $redir;
    return $type eq "GLOB" ? "FH" : $type;
}

sub _max_fd {
    my $fd = dup(0);
    POSIX::close $fd;
    return $fd;
}

my $run_call_time;
my $sys_call_time;
my $sys_exit_time;

sub run3 {
    $run_call_time = gettimeofday() if profiling;

    my $options = @_ && ref $_[-1] eq "HASH" ? pop : {};

    my ( $cmd, $stdin, $stdout, $stderr ) = @_;

    print STDERR "run3(): running ", 
       join( " ", map "'$_'", ref $cmd ? @$cmd : $cmd ), 
       "\n"
       if debugging;

    if ( ref $cmd ) {
        croak "run3(): empty command"     unless @$cmd;
        croak "run3(): undefined command" unless defined $cmd->[0];
        croak "run3(): command name ('')" unless length  $cmd->[0];
    } else {
        croak "run3(): missing command" unless @_;
        croak "run3(): undefined command" unless defined $cmd;
        croak "run3(): command ('')" unless length  $cmd;
    }

    my $in_type  = _type $stdin;
    my $out_type = _type $stdout;
    my $err_type = _type $stderr;

    if ($fh_cache_pid != $$) {
	# fork detected, close all cached filehandles and clear the cache
	close $_ foreach values %fh_cache;
	%fh_cache = ();
	$fh_cache_pid = $$;
    }
    
    # This routine procedes in stages so that a failure in an early
    # stage prevents later stages from running, and thus from needing
    # cleanup.

    my $in_fh  = _spool_data_to_child $in_type, $stdin,
        $options->{binmode_stdin} if defined $stdin;

    my $out_fh = _fh_for_child_output "stdout", $out_type, $stdout,
        $options->{binmode_stdout} if defined $stdout;

    my $tie_err_to_out =
        defined $stderr && defined $stdout && $stderr eq $stdout;

    my $err_fh = $tie_err_to_out
        ? $out_fh
        : _fh_for_child_output "stderr", $err_type, $stderr,
            $options->{binmode_stderr} if defined $stderr;

    # this should make perl close these on exceptions
    local *STDIN_SAVE;
    local *STDOUT_SAVE;
    local *STDERR_SAVE;

    my $saved_fd0 = dup( 0 ) if defined $in_fh;

#    open STDIN_SAVE,  "<&STDIN"#  or croak "run3(): $! saving STDIN"
#        if defined $in_fh;
    open STDOUT_SAVE, ">&STDOUT" or croak "run3(): $! saving STDOUT"
        if defined $out_fh;
    open STDERR_SAVE, ">&STDERR" or croak "run3(): $! saving STDERR"
        if defined $err_fh;

    my $ok = eval {
        # The open() call here seems to not force fd 0 in some cases;
        # I ran in to trouble when using this in VCP, not sure why.
        # the dup2() seems to work.
        dup2( fileno $in_fh, 0 )
#        open STDIN,  "<&=" . fileno $in_fh
            or croak "run3(): $! redirecting STDIN"
            if defined $in_fh;

#        close $in_fh or croak "$! closing STDIN temp file"
#            if ref $stdin;

        open STDOUT, ">&" . fileno $out_fh
            or croak "run3(): $! redirecting STDOUT"
            if defined $out_fh;

        open STDERR, ">&" . fileno $err_fh
            or croak "run3(): $! redirecting STDERR"
            if defined $err_fh;

        $sys_call_time = gettimeofday() if profiling;

        my $r = ref $cmd
              ? system { $cmd->[0] }
                       is_win32
                           ? map {
                                 # Probably need to offer a win32 escaping
                                 # option, every command may be different.
                                 ( my $s = $_ ) =~ s/"/"""/g;
                                 $s = qq{"$s"};
                                 $s;
                             } @$cmd
                           : @$cmd
              : system $cmd;

        $sys_exit_time = gettimeofday() if profiling;

        unless ( defined $r && $r != -1 ) {
            if ( debugging ) {
                my $err_fh = defined $err_fh ? \*STDERR_SAVE : \*STDERR;
                print $err_fh "run3(): system() error $!\n"
            }
            die $!;
        }

        if ( debugging ) {
            my $err_fh = defined $err_fh ? \*STDERR_SAVE : \*STDERR;
            print $err_fh "run3(): \$? is $?\n"
        }
        1;
    };
    my $x = $@;

    my @errs;

    if ( defined $saved_fd0 ) {
        dup2( $saved_fd0, 0 );
        POSIX::close( $saved_fd0 );
    }

#    open STDIN,  "<&STDIN_SAVE"#  or push @errs, "run3(): $! restoring STDIN"
#        if defined $in_fh;
    open STDOUT, ">&STDOUT_SAVE" or push @errs, "run3(): $! restoring STDOUT"
        if defined $out_fh;
    open STDERR, ">&STDERR_SAVE" or push @errs, "run3(): $! restoring STDERR"
        if defined $err_fh;

    croak join ", ", @errs if @errs;

    die $x unless $ok;

    _read_child_output_fh "stdout", $out_type, $stdout, $out_fh, $options
        if defined $out_fh && $out_type && $out_type ne "FH";
    _read_child_output_fh "stderr", $err_type, $stderr, $err_fh, $options
        if defined $err_fh && $err_type && $err_type ne "FH" && !$tie_err_to_out;
    $profiler->run_exit(
       $cmd,
       $run_call_time,
       $sys_call_time,
       $sys_exit_time,
       scalar gettimeofday() 
    ) if profiling;

    return 1;
}

=head1 TODO

pty support

=head1 LIMITATIONS

Often uses intermediate files (determined by File::Temp, and thus by the
File::Spec defaults and the TMPDIR env. variable) for speed, portability and
simplicity.

Use extrem caution when using C<run3> in a threaded environment if
concurrent calls of C<run3> are possible. Most likely, I/O from different
invocations will get mixed up. The reason is that in most thread 
implementations all threads in a process share the same STDIN/STDOUT/STDERR.
Known failures are Perl ithreads on Linux and Win32. Note that C<fork>
on Win32 is emulated via Win32 threads and hence I/O mix up is possible
between forked children here (C<run3> is "fork safe" on Unix, though).

=head1 COPYRIGHT

Copyright 2003, R. Barrie Slaymaker, Jr., All Rights Reserved

=head1 LICENSE

You may use this module under the terms of the BSD, Artistic, or GPL licenses,
any version.

=head1 AUTHOR

Barrie Slaymaker E<lt>C<barries@slaysys.com>E<gt>

Ricardo SIGNES E<lt>C<rjbs@cpan.org>E<gt> performed some routine maintenance in
2005, thanks to help from the following ticket and/or patch submitters: Jody
Belka, Roderich Schupp, David Morel, and anonymous others.

=cut

1;
