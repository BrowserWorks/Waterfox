package Sys::Syslog;
use strict;
use Carp;
require 5.006;
require Exporter;

our $VERSION = '0.13';
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
    standard => [qw(openlog syslog closelog setlogmask)],
    extended => [qw(setlogsock)],
    macros => [qw(
        LOG_ALERT LOG_AUTH LOG_AUTHPRIV LOG_CONS LOG_CRIT LOG_CRON
        LOG_DAEMON LOG_DEBUG LOG_EMERG LOG_ERR LOG_FACMASK LOG_FTP
        LOG_INFO LOG_KERN LOG_LFMT LOG_LOCAL0 LOG_LOCAL1 LOG_LOCAL2
        LOG_LOCAL3 LOG_LOCAL4 LOG_LOCAL5 LOG_LOCAL6 LOG_LOCAL7 LOG_LPR
        LOG_MAIL LOG_NDELAY LOG_NEWS LOG_NFACILITIES LOG_NOTICE
        LOG_NOWAIT LOG_ODELAY LOG_PERROR LOG_PID LOG_PRIMASK LOG_SYSLOG
        LOG_USER LOG_UUCP LOG_WARNING
    )],
);

our @EXPORT = (
    @{$EXPORT_TAGS{standard}}, 
);

our @EXPORT_OK = (
    @{$EXPORT_TAGS{extended}}, 
    @{$EXPORT_TAGS{macros}}, 
);

# it would be nice to try stream/unix first, since that will be
# most efficient. However streams are dodgy - see _syslog_send_stream
my @connectMethods = ( 'tcp', 'udp', 'unix', 'stream', 'console' );
if ($^O =~ /^(freebsd|linux)$/) {
    @connectMethods = grep { $_ ne 'udp' } @connectMethods;
}
my @defaultMethods = @connectMethods;
my $syslog_path = undef;
my $transmit_ok = 0;
my $current_proto = undef;
my $failed = undef;
my $fail_time = undef;
our ($connected, @fallbackMethods, $syslog_send, $host);

use Socket ':all';
use POSIX qw(strftime setlocale LC_TIME);

=head1 NAME

Sys::Syslog - Perl interface to the UNIX syslog(3) calls

=head1 VERSION

Version 0.13

=head1 SYNOPSIS

    use Sys::Syslog;                          # all except setlogsock(), or:
    use Sys::Syslog qw(:DEFAULT setlogsock);  # default set, plus setlogsock()
    use Sys::Syslog qw(:standard :macros);    # standard functions, plus macros

    setlogsock $sock_type;
    openlog $ident, $logopt, $facility;       # don't forget this
    syslog $priority, $format, @args;
    $oldmask = setlogmask $mask_priority;
    closelog;


=head1 DESCRIPTION

C<Sys::Syslog> is an interface to the UNIX C<syslog(3)> program.
Call C<syslog()> with a string priority and a list of C<printf()> args
just like C<syslog(3)>.


=head1 EXPORTS

C<Sys::Syslog> exports the following C<Exporter> tags: 

=over 4

=item *

C<:standard> exports the standard C<syslog(3)> functions: 

    openlog closelog setlogmask syslog

=item *

C<:extended> exports the Perl specific functions for C<syslog(3)>: 

    setlogsock

=item *

C<:macros> exports the symbols corresponding to most of your C<syslog(3)> 
macros. See L<"CONSTANTS"> for the supported constants and their meaning. 

=back

By default, C<Sys::Syslog> exports the symbols from the C<:standard> tag. 


=head1 FUNCTIONS

=over 4

=item B<openlog($ident, $logopt, $facility)>

Opens the syslog.
C<$ident> is prepended to every message.  C<$logopt> contains zero or
more of the words C<pid>, C<ndelay>, C<nowait>.  The C<cons> option is
ignored, since the failover mechanism will drop down to the console
automatically if all other media fail.  C<$facility> specifies the
part of the system to report about, for example C<LOG_USER> or C<LOG_LOCAL0>:
see your C<syslog(3)> documentation for the facilities available in
your system. Facility can be given as a string or a numeric macro. 

This function will croak if it can't connect to the syslog daemon.

Note that C<openlog()> now takes three arguments, just like C<openlog(3)>.

B<You should use openlog() before calling syslog().>

B<Options>

=over 4

=item *

C<ndelay> - Open the connection immediately (normally, the connection is
opened when the first message is logged).

=item *

C<nowait> - Don't wait for child processes that may have been created 
while logging the message.  (The GNU C library does not create a child
process, so this option has no effect on Linux.)

=item *

C<pid> - Include PID with each message.

=back

B<Examples>

Open the syslog with options C<ndelay> and C<pid>, and with facility C<LOCAL0>: 

    openlog($name, "ndelay,pid", "local0");

Same thing, but this time using the macro corresponding to C<LOCAL0>: 

    openlog($name, "ndelay,pid", LOG_LOCAL0);


=item B<syslog($priority, $message)>

=item B<syslog($priority, $format, @args)>

If C<$priority> permits, logs C<$message> or C<sprintf($format, @args)>
with the addition that C<%m> in $message or C<$format> is replaced with
C<"$!"> (the latest error message). 

C<$priority> can specify a level, or a level and a facility.  Levels and 
facilities can be given as strings or as macros.

If you didn't use C<openlog()> before using C<syslog()>, C<syslog()> will 
try to guess the C<$ident> by extracting the shortest prefix of 
C<$format> that ends in a C<":">.

B<Examples>

    syslog("info", $message);           # informational level
    syslog(LOG_INFO, $message);         # informational level

    syslog("info|local0", $message);        # information level, Local0 facility
    syslog(LOG_INFO|LOG_LOCAL0, $message);  # information level, Local0 facility

=over 4

=item B<Note>

C<Sys::Syslog> version v0.07 and older passed the C<$message> as the 
formatting string to C<sprintf()> even when no formatting arguments
were provided.  If the code calling C<syslog()> might execute with 
older versions of this module, make sure to call the function as
C<syslog($priority, "%s", $message)> instead of C<syslog($priority,
$message)>.  This protects against hostile formatting sequences that
might show up if $message contains tainted data.

=back


=item B<setlogmask($mask_priority)>

Sets the log mask for the current process to C<$mask_priority> and 
returns the old mask.  If the mask argument is 0, the current log mask 
is not modified.  See L<"Levels"> for the list of available levels. 

B<Examples>

Only log errors: 

    setlogmask(LOG_ERR);

Log critical messages, errors and warnings: 

    setlogmask(LOG_CRIT|LOG_ERR|LOG_WARNING);


=item B<setlogsock($sock_type)>

=item B<setlogsock($sock_type, $stream_location)> (added in 5.004_02)

Sets the socket type to be used for the next call to
C<openlog()> or C<syslog()> and returns true on success,
C<undef> on failure.

A value of C<"unix"> will connect to the UNIX domain socket (in some
systems a character special device) returned by the C<_PATH_LOG> macro
(if your system defines it), or F</dev/log> or F</dev/conslog>,
whatever is writable.  A value of 'stream' will connect to the stream
indicated by the pathname provided as the optional second parameter.
(For example Solaris and IRIX require C<"stream"> instead of C<"unix">.)
A value of C<"inet"> will connect to an INET socket (either C<tcp> or C<udp>,
tried in that order) returned by C<getservbyname()>. C<"tcp"> and C<"udp"> can
also be given as values. The value C<"console"> will send messages
directly to the console, as for the C<"cons"> option in the logopts in
C<openlog()>.

A reference to an array can also be passed as the first parameter.
When this calling method is used, the array should contain a list of
sock_types which are attempted in order.

The default is to try C<tcp>, C<udp>, C<unix>, C<stream>, C<console>.

Giving an invalid value for C<$sock_type> will croak.


=item B<closelog()>

Closes the log file and return true on success.

=back


=head1 EXAMPLES

    openlog($program, 'cons,pid', 'user');
    syslog('info', '%s', 'this is another test');
    syslog('mail|warning', 'this is a better test: %d', time);
    closelog();

    syslog('debug', 'this is the last test');

    setlogsock('unix');
    openlog("$program $$", 'ndelay', 'user');
    syslog('notice', 'fooprogram: this is really done');

    setlogsock('inet');
    $! = 55;
    syslog('info', 'problem was %m'); # %m == $! in syslog(3)

    # Log to UDP port on $remotehost instead of logging locally
    setlogsock('udp');
    $Sys::Syslog::host = $remotehost;
    openlog($program, 'ndelay', 'user');
    syslog('info', 'something happened over here');


=head1 CONSTANTS

=head2 Facilities

=over 4

=item *

C<LOG_AUTH> - security/authorization messages

=item *

C<LOG_AUTHPRIV> - security/authorization messages (private)

=item *

C<LOG_CRON> - clock daemon (B<cron> and B<at>)

=item *

C<LOG_DAEMON> - system daemons without separate facility value

=item *

C<LOG_FTP> - ftp daemon

=item *

C<LOG_KERN> - kernel messages

=item *

C<LOG_LOCAL0> through C<LOG_LOCAL7> - reserved for local use

=item *

C<LOG_LPR> - line printer subsystem

=item *

C<LOG_MAIL> - mail subsystem

=item *

C<LOG_NEWS> - USENET news subsystem

=item *

C<LOG_SYSLOG> - messages generated internally by B<syslogd>

=item *

C<LOG_USER> (default) - generic user-level messages

=item *

C<LOG_UUCP> - UUCP subsystem

=back


=head2 Levels

=over 4

=item *

C<LOG_EMERG> - system is unusable

=item *

C<LOG_ALERT> - action must be taken immediately

=item *

C<LOG_CRIT> - critical conditions

=item *

C<LOG_ERR> - error conditions

=item *

C<LOG_WARNING> - warning conditions

=item *

C<LOG_NOTICE> - normal, but significant, condition

=item *

C<LOG_INFO> - informational message

=item *

C<LOG_DEBUG> - debug-level message

=back


=head1 DIAGNOSTICS

=over 4

=item Invalid argument passed to setlogsock

B<(F)> You gave C<setlogsock()> an invalid value for C<$sock_type>. 

=item no connection to syslog available

B<(F)> C<syslog()> failed to connect to the specified socket.

=item stream passed to setlogsock, but %s is not writable

B<(W)> You asked C<setlogsock()> to use a stream socket, but the given 
path is not writable. 

=item stream passed to setlogsock, but could not find any device

B<(W)> You asked C<setlogsock()> to use a stream socket, but didn't 
provide a path, and C<Sys::Syslog> was unable to find an appropriate one.

=item tcp passed to setlogsock, but tcp service unavailable

B<(W)> You asked C<setlogsock()> to use a TCP socket, but the service 
is not available on the system. 

=item syslog: expecting argument %s

B<(F)> You forgot to give C<syslog()> the indicated argument.

=item syslog: invalid level/facility: %s

B<(F)> You specified an invalid level or facility, like C<LOG_KERN> 
(which is reserved to the kernel). 

=item syslog: too many levels given: %s

B<(F)> You specified too many levels. 

=item syslog: too many facilities given: %s

B<(F)> You specified too many facilities. 

=item syslog: level must be given

B<(F)> You forgot to specify a level.

=item udp passed to setlogsock, but udp service unavailable

B<(W)> You asked C<setlogsock()> to use a UDP socket, but the service 
is not available on the system. 

=item unix passed to setlogsock, but path not available

B<(W)> You asked C<setlogsock()> to use a UNIX socket, but C<Sys::Syslog> 
was unable to find an appropriate an appropriate device.

=back


=head1 SEE ALSO

L<syslog(3)>

I<Syslogging with Perl>, L<http://lexington.pm.org/meetings/022001.html>


=head1 AUTHOR

Tom Christiansen E<lt>F<tchrist@perl.com>E<gt> and Larry Wall
E<lt>F<larry@wall.org>E<gt>.

UNIX domain sockets added by Sean Robinson
E<lt>F<robinson_s@sc.maricopa.edu>E<gt> with support from Tim Bunce 
E<lt>F<Tim.Bunce@ig.co.uk>E<gt> and the C<perl5-porters> mailing list.

Dependency on F<syslog.ph> replaced with XS code by Tom Hughes
E<lt>F<tom@compton.nu>E<gt>.

Code for C<constant()>s regenerated by Nicholas Clark E<lt>F<nick@ccl4.org>E<gt>.

Failover to different communication modes by Nick Williams
E<lt>F<Nick.Williams@morganstanley.com>E<gt>.

Extracted from core distribution for publishing on the CPAN by 
SE<eacute>bastien Aperghis-Tramoni E<lt>sebastien@aperghis.netE<gt>.


=head1 BUGS

Please report any bugs or feature requests to
C<bug-sys-syslog at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sys-Syslog>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sys::Syslog

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sys-Syslog>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sys-Syslog>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sys-Syslog>

=item * Search CPAN

L<http://search.cpan.org/dist/Sys-Syslog>

=back


=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.
    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Sys::Syslog::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
	croak $error if $error;
    no strict 'refs';
    *$AUTOLOAD = sub { $val };
    goto &$AUTOLOAD;
}

eval {
    require XSLoader;
    XSLoader::load('Sys::Syslog', $VERSION);
    1
} or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    bootstrap Sys::Syslog $VERSION;
};

our $maskpri = &LOG_UPTO(&LOG_DEBUG);

sub openlog {
    our ($ident, $logopt, $facility) = @_;  # package vars
    our $lo_pid = $logopt =~ /\bpid\b/;
    our $lo_ndelay = $logopt =~ /\bndelay\b/;
    our $lo_nowait = $logopt =~ /\bnowait\b/;
    return 1 unless $lo_ndelay;
    &connect;
} 

sub closelog {
    our $facility = our $ident = '';
    &disconnect;
} 

sub setlogmask {
    my $oldmask = $maskpri;
    $maskpri = shift unless $_[0] == 0;
    $oldmask;
}
 
sub setlogsock {
    my $setsock = shift;
    $syslog_path = shift;
    &disconnect if $connected;
    $transmit_ok = 0;
    @fallbackMethods = ();
    @connectMethods = @defaultMethods;
    if (ref $setsock eq 'ARRAY') {
	@connectMethods = @$setsock;
    } elsif (lc($setsock) eq 'stream') {
	unless (defined $syslog_path) {
	    my @try = qw(/dev/log /dev/conslog);
	    if (length &_PATH_LOG) { # Undefined _PATH_LOG is "".
		unshift @try, &_PATH_LOG;
            }
	    for my $try (@try) {
		if (-w $try) {
		    $syslog_path = $try;
		    last;
		}
	    }
	    carp "stream passed to setlogsock, but could not find any device"
		unless defined $syslog_path
        }
	unless (-w $syslog_path) {
	    carp "stream passed to setlogsock, but $syslog_path is not writable";
	    return undef;
	} else {
	    @connectMethods = ( 'stream' );
	}
    } elsif (lc($setsock) eq 'unix') {
        if (length _PATH_LOG() && !defined $syslog_path) {
	    $syslog_path = _PATH_LOG();
	    @connectMethods = ( 'unix' );
        } else {
	    carp 'unix passed to setlogsock, but path not available';
	    return undef;
        }
    } elsif (lc($setsock) eq 'tcp') {
	if (getservbyname('syslog', 'tcp') || getservbyname('syslogng', 'tcp')) {
	    @connectMethods = ( 'tcp' );
	} else {
	    carp "tcp passed to setlogsock, but tcp service unavailable";
	    return undef;
	}
    } elsif (lc($setsock) eq 'udp') {
	if (getservbyname('syslog', 'udp')) {
	    @connectMethods = ( 'udp' );
	} else {
	    carp "udp passed to setlogsock, but udp service unavailable";
	    return undef;
	}
    } elsif (lc($setsock) eq 'inet') {
	@connectMethods = ( 'tcp', 'udp' );
    } elsif (lc($setsock) eq 'console') {
	@connectMethods = ( 'console' );
    } else {
        croak "Invalid argument passed to setlogsock; must be 'stream', 'unix', 'tcp', 'udp' or 'inet'"
    }
    return 1;
}

sub syslog {
    my $priority = shift;
    my $mask = shift;
    my ($message, $whoami);
    my (@words, $num, $numpri, $numfac, $sum);
    our $facility;
    local($facility) = $facility;	# may need to change temporarily.

    croak "syslog: expecting argument \$priority" unless defined $priority;
    croak "syslog: expecting argument \$format"   unless defined $mask;

    @words = split(/\W+/, $priority, 2);# Allow "level" or "level|facility".
    undef $numpri;
    undef $numfac;
    foreach (@words) {
	$num = &xlate($_);		# Translate word to number.
	if ($_ eq 'kern' || $num <= 0) {
	    croak "syslog: invalid level/facility: $_"
	}
	elsif ($num <= &LOG_PRIMASK) {
	    croak "syslog: too many levels given: $_" if defined($numpri);
	    $numpri = $num;
	    return 0 unless &LOG_MASK($numpri) & $maskpri;
	}
	else {
	    croak "syslog: too many facilities given: $_" if defined($numfac);
	    $facility = $_;
	    $numfac = $num;
	}
    }

    croak "syslog: level must be given" unless defined($numpri);

    if (!defined($numfac)) {	# Facility not specified in this call.
	$facility = 'user' unless $facility;
	$numfac = &xlate($facility);
    }

    &connect unless $connected;

    $whoami = our $ident;

    if (!$whoami && $mask =~ /^(\S.*?):\s?(.*)/) {
	$whoami = $1;
	$mask = $2;
    } 

    unless ($whoami) {
	($whoami = getlogin) ||
	    ($whoami = getpwuid($<)) ||
		($whoami = 'syslog');
    }

    $whoami .= "[$$]" if our $lo_pid;

    if ($mask =~ /%m/) {
	my $err = $!;
	# escape percent signs if sprintf will be called
	$err =~ s/%/%%/g if @_;
	# replace %m with $err, if preceded by an even number of percent signs
	$mask =~ s/(?<!%)((?:%%)*)%m/$1$err/g;
    }

    $mask .= "\n" unless $mask =~ /\n$/;
    $message = @_ ? sprintf($mask, @_) : $mask;

    $sum = $numpri + $numfac;
    my $oldlocale = setlocale(LC_TIME);
    setlocale(LC_TIME, 'C');
    my $timestamp = strftime "%b %e %T", localtime;
    setlocale(LC_TIME, $oldlocale);
    my $buf = "<$sum>$timestamp $whoami: $message\0";

    # it's possible that we'll get an error from sending
    # (e.g. if method is UDP and there is no UDP listener,
    # then we'll get ECONNREFUSED on the send). So what we
    # want to do at this point is to fallback onto a different
    # connection method.
    while (scalar @fallbackMethods || $syslog_send) {
	if ($failed && (time - $fail_time) > 60) {
	    # it's been a while... maybe things have been fixed
	    @fallbackMethods = ();
	    disconnect();
	    $transmit_ok = 0; # make it look like a fresh attempt
	    &connect;
        }
	if ($connected && !connection_ok()) {
	    # Something was OK, but has now broken. Remember coz we'll
	    # want to go back to what used to be OK.
	    $failed = $current_proto unless $failed;
	    $fail_time = time;
	    disconnect();
	}
	&connect unless $connected;
	$failed = undef if ($current_proto && $failed && $current_proto eq $failed);
	if ($syslog_send) {
	    if (&{$syslog_send}($buf)) {
		$transmit_ok++;
		return 1;
	    }
	    # typically doesn't happen, since errors are rare from write().
	    disconnect();
	}
    }
    # could not send, could not fallback onto a working
    # connection method. Lose.
    return 0;
}

sub _syslog_send_console {
    my ($buf) = @_;
    chop($buf); # delete the NUL from the end
    # The console print is a method which could block
    # so we do it in a child process and always return success
    # to the caller.
    if (my $pid = fork) {
	our $lo_nowait;
	if ($lo_nowait) {
	    return 1;
	} else {
	    if (waitpid($pid, 0) >= 0) {
	    	return ($? >> 8);
	    } else {
		# it's possible that the caller has other
		# plans for SIGCHLD, so let's not interfere
		return 1;
	    }
	}
    } else {
        if (open(CONS, ">/dev/console")) {
	    my $ret = print CONS $buf . "\r";
	    exit ($ret) if defined $pid;
	    close CONS;
	}
	exit if defined $pid;
    }
}

sub _syslog_send_stream {
    my ($buf) = @_;
    # XXX: this only works if the OS stream implementation makes a write 
    # look like a putmsg() with simple header. For instance it works on 
    # Solaris 8 but not Solaris 7.
    # To be correct, it should use a STREAMS API, but perl doesn't have one.
    return syswrite(SYSLOG, $buf, length($buf));
}

sub _syslog_send_socket {
    my ($buf) = @_;
    return syswrite(SYSLOG, $buf, length($buf));
    #return send(SYSLOG, $buf, 0);
}

sub xlate {
    my($name) = @_;
    return $name+0 if $name =~ /^\s*\d+\s*$/;
    $name = uc $name;
    $name = "LOG_$name" unless $name =~ /^LOG_/;
    $name = "Sys::Syslog::$name";
    # Can't have just eval { &$name } || -1 because some LOG_XXX may be zero.
    my $value = eval { no strict 'refs'; &$name };
    defined $value ? $value : -1;
}

sub connect {
    @fallbackMethods = @connectMethods unless (scalar @fallbackMethods);
    if ($transmit_ok && $current_proto) {
	# Retry what we were on, because it's worked in the past.
	unshift(@fallbackMethods, $current_proto);
    }
    $connected = 0;
    my @errs = ();
    my $proto = undef;
    while ($proto = shift(@fallbackMethods)) {
	no strict 'refs';
	my $fn = "connect_$proto";
	$connected = &$fn(\@errs) if defined &$fn;
	last if ($connected);
    }

    $transmit_ok = 0;
    if ($connected) {
	$current_proto = $proto;
        my($old) = select(SYSLOG); $| = 1; select($old);
    } else {
	@fallbackMethods = ();
	croak join "\n\t- ", "no connection to syslog available", @errs
    }
}

sub connect_tcp {
    my ($errs) = @_;
    my $tcp = getprotobyname('tcp');
    if (!defined $tcp) {
	push(@{$errs}, "getprotobyname failed for tcp");
	return 0;
    }
    my $syslog = getservbyname('syslog','tcp');
    $syslog = getservbyname('syslogng','tcp') unless (defined $syslog);
    if (!defined $syslog) {
	push(@{$errs}, "getservbyname failed for syslog/tcp and syslogng/tcp");
	return 0;
    }

    my $this = sockaddr_in($syslog, INADDR_ANY);
    my $that;
    if (defined $host) {
	$that = inet_aton($host);
	if (!$that) {
	    push(@{$errs}, "can't lookup $host");
	    return 0;
	}
    } else {
	$that = INADDR_LOOPBACK;
    }
    $that = sockaddr_in($syslog, $that);

    if (!socket(SYSLOG,AF_INET,SOCK_STREAM,$tcp)) {
	push(@{$errs}, "tcp socket: $!");
	return 0;
    }
    setsockopt(SYSLOG, SOL_SOCKET, SO_KEEPALIVE, 1);
    setsockopt(SYSLOG, IPPROTO_TCP, TCP_NODELAY, 1);
    if (!CORE::connect(SYSLOG,$that)) {
	push(@{$errs}, "tcp connect: $!");
	return 0;
    }
    $syslog_send = \&_syslog_send_socket;
    return 1;
}

sub connect_udp {
    my ($errs) = @_;
    my $udp = getprotobyname('udp');
    if (!defined $udp) {
	push(@{$errs}, "getprotobyname failed for udp");
	return 0;
    }
    my $syslog = getservbyname('syslog','udp');
    if (!defined $syslog) {
	push(@{$errs}, "getservbyname failed for syslog/udp");
	return 0;
    }
    my $this = sockaddr_in($syslog, INADDR_ANY);
    my $that;
    if (defined $host) {
	$that = inet_aton($host);
	if (!$that) {
	    push(@{$errs}, "can't lookup $host");
	    return 0;
	}
    } else {
	$that = INADDR_LOOPBACK;
    }
    $that = sockaddr_in($syslog, $that);

    if (!socket(SYSLOG,AF_INET,SOCK_DGRAM,$udp)) {
	push(@{$errs}, "udp socket: $!");
	return 0;
    }
    if (!CORE::connect(SYSLOG,$that)) {
	push(@{$errs}, "udp connect: $!");
	return 0;
    }
    # We want to check that the UDP connect worked. However the only
    # way to do that is to send a message and see if an ICMP is returned
    _syslog_send_socket("");
    if (!connection_ok()) {
	push(@{$errs}, "udp connect: nobody listening");
	return 0;
    }
    $syslog_send = \&_syslog_send_socket;
    return 1;
}

sub connect_stream {
    my ($errs) = @_;
    # might want syslog_path to be variable based on syslog.h (if only
    # it were in there!)
    $syslog_path = '/dev/conslog'; 
    if (!-w $syslog_path) {
	push(@{$errs}, "stream $syslog_path is not writable");
	return 0;
    }
    if (!open(SYSLOG, ">" . $syslog_path)) {
	push(@{$errs}, "stream can't open $syslog_path: $!");
	return 0;
    }
    $syslog_send = \&_syslog_send_stream;
    return 1;
}

sub connect_unix {
    my ($errs) = @_;
    if (length _PATH_LOG()) {
	$syslog_path = _PATH_LOG();
    } else {
        push(@{$errs}, "_PATH_LOG not available in syslog.h");
	return 0;
    }
    if (! -S $syslog_path) {
	push(@{$errs}, "$syslog_path is not a socket");
	return 0;
    }
    my $that = sockaddr_un($syslog_path);
    if (!$that) {
	push(@{$errs}, "can't locate $syslog_path");
	return 0;
    }
    if (!socket(SYSLOG,AF_UNIX,SOCK_STREAM,0)) {
	push(@{$errs}, "unix stream socket: $!");
	return 0;
    }
    if (!CORE::connect(SYSLOG,$that)) {
        if (!socket(SYSLOG,AF_UNIX,SOCK_DGRAM,0)) {
	    push(@{$errs}, "unix dgram socket: $!");
	    return 0;
	}
        if (!CORE::connect(SYSLOG,$that)) {
	    push(@{$errs}, "unix dgram connect: $!");
	    return 0;
	}
    }
    $syslog_send = \&_syslog_send_socket;
    return 1;
}

sub connect_console {
    my ($errs) = @_;
    if (!-w '/dev/console') {
	push(@{$errs}, "console is not writable");
	return 0;
    }
    $syslog_send = \&_syslog_send_console;
    return 1;
}

# to test if the connection is still good, we need to check if any
# errors are present on the connection. The errors will not be raised
# by a write. Instead, sockets are made readable and the next read
# would cause the error to be returned. Unfortunately the syslog 
# 'protocol' never provides anything for us to read. But with 
# judicious use of select(), we can see if it would be readable...
sub connection_ok {
    return 1 if (defined $current_proto && $current_proto eq 'console');
    my $rin = '';
    vec($rin, fileno(SYSLOG), 1) = 1;
    my $ret = select $rin, undef, $rin, 0;
    return ($ret ? 0 : 1);
}

sub disconnect {
    $connected = 0;
    $syslog_send = undef;
    return close SYSLOG;
}

1;
