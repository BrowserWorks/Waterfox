# $Revision: 1.20 $
# $Id: Reporter.pm,v 1.20 2003/03/05 09:15:53 afoxson Exp $

# Test::Reporter - sends test results to cpan-testers@perl.org
# Copyright (c) 2003 Adam J. Foxson. All rights reserved.

# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package Test::Reporter;

use strict;
use Cwd;
use Config;
use Carp;
use Net::SMTP;
use File::Temp;
use Test::Reporter::Mail::Util;
use Test::Reporter::Date::Format;
use vars qw($VERSION $AUTOLOAD $Tempfile $Report $MacMPW $MacApp $DNS $Domain $Send);

$MacMPW    = $^O eq 'MacOS' && $MacPerl::Version =~ /MPW/;
$MacApp    = $^O eq 'MacOS' && $MacPerl::Version =~ /Application/;
$VERSION = '1.27';

local $^W;

sub FAKE_NO_NET_DNS() {0}    # for debugging only
sub FAKE_NO_NET_DOMAIN() {0} # for debugging only
sub FAKE_NO_MAIL_SEND() {0}  # for debugging only

sub new {
	my $type  = shift;
	my $class = ref($type) || $type;
	my $self  = {
		'_mx'                => ['mx1.x.perl.org', 'mx2.x.perl.org'],
		'_address'           => 'cpan-testers@perl.org',
		'_grade'             => undef,
		'_distribution'      => undef,
		'_report'            => undef,
		'_subject'           => undef,
		'_from'              => undef,
		'_comments'          => '',
		'_errstr'            => '',
		'_via'               => '',
		'_mail_send_args'    => '',
		'_timeout'           => 120,
		'_debug'             => 0,
		'_dir'               => '',
		'_subject_lock'      => 0,
		'_report_lock'       => 0,
	};

	bless $self, $class;

	$self->{_attr} = {   
		map {$_ => 1} qw(   
			_address _distribution _comments _errstr _via _timeout _debug _dir
		)
	};

	warn __PACKAGE__, ": new\n" if $self->debug();
	croak __PACKAGE__, ": new: even number of named arguments required"
		unless scalar @_ % 2 == 0;

	$self->_process_params(@_) if @_;
	$self->_get_mx(@_) if $self->_have_net_dns();

	return $self;
}

sub _get_mx {
	my $self = shift;
	warn __PACKAGE__, ": _get_mx\n" if $self->debug();

	my %params = @_;

	return if exists $params{'mx'};

	my $dom = $params{'address'} || $self->address();
	my @mx;

	$dom =~ s/^.+\@//;

	for my $mx (sort {$a->preference() <=> $b->preference()} Net::DNS::mx($dom)) {
		push @mx, $mx->exchange();
	}

	if (not @mx) {
		warn __PACKAGE__,
			": _get_mx: unable to find MX's for $dom, using defaults\n" if
				$self->debug();
		return;
	}

	$self->mx(\@mx);
}

sub _process_params {
	my $self = shift;
	warn __PACKAGE__, ": _process_params\n" if $self->debug();

	my %params   = @_;
	my @defaults = qw(
		mx address grade distribution from comments via timeout debug dir);
	my %defaults = map {$_ => 1} @defaults;

	for my $param (keys %params) {   
		croak __PACKAGE__, ": new: parameter '$param' is invalid." unless
			exists $defaults{$param};
	}

	for my $param (keys %params) {   
		$self->$param($params{$param});
	}
}

sub subject {
	my $self = shift;
	warn __PACKAGE__, ": subject\n" if $self->debug();
	croak __PACKAGE__, ": subject: grade and distribution must first be set"
		if not defined $self->{_grade} or not defined $self->{_distribution};

	return $self->{_subject} if $self->{_subject_lock};

	my $subject = uc($self->{_grade}) . ' ' . $self->{_distribution} .
		" $Config{archname} $Config{osvers}";

	return $self->{_subject} = $subject;
}

sub report {
	my $self = shift;
	warn __PACKAGE__, ": report\n" if $self->debug();

	return $self->{_report} if $self->{_report_lock};

	my $report = qq(
		This distribution has been tested as part of the cpan-testers
		effort to test as many new uploads to CPAN as possible.  See
		http://testers.cpan.org/

		Please cc any replies to cpan-testers\@perl.org to keep other
		test volunteers informed and to prevent any duplicate effort.
	);

	$report =~ s/\n//;
	$report =~ s/\t{2}//g;

	if (not $self->{_comments}) {
		$report .= "\n\n--\n\n";
	}
	else {
		$report .= "\n--\n" . $self->{_comments} . "\n--\n\n";
	}

	$report .= Config::myconfig();

	chomp $report;
	chomp $report;

	return $self->{_report} = $report;
}

sub grade {
	my ($self, $grade) = @_;
	warn __PACKAGE__, ": grade\n" if $self->debug();

	my %grades    = (
		'pass'    => "all tests passed",
		'fail'    => "one or more tests failed",
		'na'      => "distribution will not work on this platform",
		'unknown' => "distribution did not include tests",
	);

	return $self->{_grade} if scalar @_ == 1;

	croak __PACKAGE__, ":grade: '$grade' is invalid, choose from: " .
		join ' ', keys %grades unless $grades{$grade};

	return $self->{_grade} = $grade;
}

sub edit_comments {
    my($self, %args) = @_;
	warn __PACKAGE__, ": edit_comments\n" if $self->debug();

    my %tempfile_args = (
        UNLINK => 1,
        SUFFIX => '.txt',
    );

    if (exists $args{'suffix'} && defined $args{'suffix'} && length $args{'suffix'}) {
        $tempfile_args{SUFFIX} = $args{'suffix'};
        # prefix the extension with a period, if the user didn't.
        $tempfile_args{SUFFIX} =~ s/^(?!\.)(?=.)/./;
    }

	($Tempfile, $Report) = File::Temp::tempfile(%tempfile_args);

	print $Tempfile $self->{_comments};

	$self->_start_editor();

	my $comments;
	{
		local $/;
		open FH, $Report or die __PACKAGE__, ": Can't open comment file '$Report': $!";
		$comments = <FH>;
		close FH or die __PACKAGE__, ": Can't close comment file '$Report': $!";
	}

	chomp $comments;

	$self->{_comments} = $comments;

	return;
}

sub send {
	my ($self, @recipients) = @_;
	warn __PACKAGE__, ": send\n" if $self->debug();

	$self->from();
	$self->report();
	$self->subject();

	return unless $self->_verify();

	if ($^O !~ /^(?:cygwin|msys|MSWin32)$/ && $self->_have_mail_send()) {
		return $self->_mail_send(@recipients);
	}
	else {
		return $self->_send_smtp(@recipients);
	}
}

sub write {
	my $self = shift;
	warn __PACKAGE__, ": write\n" if $self->debug();

	my $from = $self->from();
	my $report = $self->report();
	my $subject = $self->subject();
	my $distribution = $self->distribution();
	my $grade = $self->grade();
	my $dir = $self->dir() || cwd;

	return unless $self->_verify();

	$distribution =~ s/[^A-Za-z0-9\.\-]+//g;

	my($fh, $file); unless ($fh = $_[0]) {
		$file = "$dir/$grade.$distribution.$Config{archname}.$Config{osvers}.${\(time)}.$$.rpt";
		warn $file if $self->debug();
		open $fh, ">$file" or die __PACKAGE__, ": Can't open report file '$file': $!";
	}
	print $fh "From: $from\n";
	print $fh "Subject: $subject\n";
	print $fh "Report: $report";
	unless ($_[0]) {
		close $fh or die __PACKAGE__, ": Can't close report file '$file': $!";
		warn $file if $self->debug();
		return $file;
	} else {
		return $fh;
	}
}

sub read {
	my ($self, $file) = @_;
	warn __PACKAGE__, ": read\n" if $self->debug();

	my $buffer;

	{
		local $/;
		open REPORT, $file or die __PACKAGE__, ": Can't open report file '$file': $!";
		$buffer = <REPORT>;
		close REPORT or die __PACKAGE__, ": Can't close report file '$file': $!";
	}

	if (my ($from, $subject, $report) = $buffer =~ /^From:\s(.+)Subject:\s(.+)Report:\s(.+)$/s) {
		my ($grade, $distribution) = (split /\s/, $subject)[0,1];
		$self->from($from) unless $self->from();
		$self->{_subject} = $subject;
		$self->{_report} = $report;
		$self->{_grade} = lc $grade;
		$self->{_distribution} = $distribution;
		$self->{_subject_lock} = 1;
		$self->{_report_lock} = 1;
	} else {
		die __PACKAGE__, ": Failed to parse report file '$file'\n";
	}

	return $self;
}

sub _verify {
	my $self = shift;
	warn __PACKAGE__, ": _verify\n" if $self->debug();

	my @undefined;

	for my $key (keys %{$self}) {
		push @undefined, $key unless defined $self->{$key};
	}

	$self->errstr(__PACKAGE__ . ": Missing values for: " .
		join ', ', map {$_ =~ /^_(.+)$/} @undefined) if
		scalar @undefined > 0;
	return $self->errstr() ? return 0 : return 1;
}

sub _mail_send {
	my $self = shift;
	warn __PACKAGE__, ": _mail_send\n" if $self->debug();

	my $fh;
	my $recipients;
	my @recipients = @_;
	my $via        = $self->via();
	my $msg        = Mail::Send->new();

	if (@recipients) {
		$recipients = join ', ', @recipients;
		chomp $recipients;
		chomp $recipients;
	}

	$via = ', via ' . $via if $via;

	$msg->to($self->address());
	$msg->set('From', $self->from());
	$msg->subject($self->subject());
	$msg->add('X-Reported-Via', "Test::Reporter ${VERSION}$via");
	$msg->add('Cc', $recipients) if @_;

	if ($self->mail_send_args() and ref $self->mail_send_args() eq 'ARRAY') {
		$fh = $msg->open(@{$self->mail_send_args()});
	}
	else {
		$fh = $msg->open();
	}

	print $fh $self->report();
	
	$fh->close();
}

sub _send_smtp {
	my $self = shift;
	warn __PACKAGE__, ": _send_smtp\n" if $self->debug();

	my $helo          = $self->_maildomain();
	my $from          = $self->from();
	my $via           = $self->via();
	my $debug         = $self->debug();
	my @recipients    = @_;
	my @tmprecipients = ();
	my @bad           = ();
	my $success       = 0;
	my $fail          = 0;
	my $recipients;
	my $smtp;

	my $mx;
	for my $server (@{$self->{_mx}}) {
		$smtp = Net::SMTP->new($server, Hello => $helo,
			Timeout => $self->{_timeout}, Debug => $debug);

		if (defined $smtp) {
		    $mx = $server;
		    last;
		}

		$fail++;
	}

	unless ($mx && $smtp) {
		$self->errstr(__PACKAGE__ . ': Unable to connect to any MX\'s');
		return 0;
	}

	if (@recipients) {
		if ($mx =~ /(?:^|\.)(?:perl|cpan)\.org$/) {
			for my $recipient (sort @recipients) {
			    if ($recipient =~ /(?:@|\.)(?:perl|cpan)\.org$/) {
				    push @tmprecipients, $recipient;
			    } else {
				    push @bad, $recipient;
			    }
			}

			if (@bad) {
				warn __PACKAGE__, ": Will not attempt to cc the following recipients since perl.org MX's will not relay for them. Either install Mail::Send, use other MX's, or only cc address ending in cpan.org or perl.org: ${\(join ', ', @bad)}.\n";
			}

			@recipients = @tmprecipients;
		}

		$recipients = join ', ', @recipients;
		chomp $recipients;
		chomp $recipients;
	}

	$via = ', via ' . $via if $via;

	$success += $smtp->mail($from);
	$success += $smtp->to($self->{_address});
	$success += $smtp->cc(@recipients) if @recipients;
	$success += $smtp->data();
	$success += $smtp->datasend("Date: ", time2str("%a, %e %b %Y %T %z", time), "\n");
	$success += $smtp->datasend("Subject: ", $self->subject(), "\n");
	$success += $smtp->datasend("From: $from\n");
	$success += $smtp->datasend("To: ", $self->{_address}, "\n");
	$success += $smtp->datasend("Cc: $recipients\n") if @recipients && $success == 8;
	$success +=
		$smtp->datasend("X-Reported-Via: Test::Reporter ${VERSION}$via\n");
	$success += $smtp->datasend("\n");
	$success += $smtp->datasend($self->report());
	$success += $smtp->dataend();
	$success += $smtp->quit;

	if (@recipients) {
		$self->errstr(__PACKAGE__ .
			": Unable to send test report to one or more recipients\n") if $success != 14;
	}
	else {
		$self->errstr(__PACKAGE__ . ": Unable to send test report\n") if $success != 12;
	}

	return $self->errstr() ? 0 : 1;
}

sub from {
	my $self = shift;
	warn __PACKAGE__, ": from\n" if $self->debug();

	if (@_) {
		$self->{_from} = shift;
	}
	else {
		$self->{_from} = $self->_mailaddress();
	}

	return $self->{_from};
}

sub mx {
	my $self = shift;
	warn __PACKAGE__, ": mx\n" if $self->debug();

	if (@_) {
		my $mx = shift;
		croak __PACKAGE__,
			": mx: array reference required" if ref $mx ne 'ARRAY';
		$self->{_mx} = $mx;
	}

	return $self->{_mx};
}

sub mail_send_args {
	my $self = shift;
	warn __PACKAGE__, ": mail_send_args\n" if $self->debug();
	croak __PACKAGE__, ": mail_send_args cannot be called unless Mail::Send is installed\n" unless $self->_have_mail_send();

	if (@_) {
		my $mail_send_args = shift;
		croak __PACKAGE__, ": mail_send_args: array reference required" if
			ref $mail_send_args ne 'ARRAY';
		$self->{_mail_send_args} = $mail_send_args;
	}

	return $self->{_mail_send_args};
}

sub AUTOLOAD {
	my $self               = $_[0];
	my ($package, $method) = ($AUTOLOAD =~ /(.*)::(.*)/);

	return if $method =~ /^DESTROY$/;

	unless ($self->{_attr}->{"_$method"}) {
		croak __PACKAGE__, ": No such method: $method; aborting";
	}

	my $code = q{
		sub {   
			my $self = shift;
			warn __PACKAGE__, ": METHOD\n" if $self->{_debug};
			$self->{_METHOD} = shift if @_;
			return $self->{_METHOD};
		}
	};

	$code =~ s/METHOD/$method/g;

	{
		no strict 'refs';
		*$AUTOLOAD = eval $code;
	}

	goto &$AUTOLOAD;
}

sub _have_net_dns {
	my $self = shift;
	warn __PACKAGE__, ": _have_net_dns\n" if $self->debug();

	return $DNS if defined $DNS;
	return 0 if FAKE_NO_NET_DNS;

	$DNS = eval {require Net::DNS};
}

sub _have_net_domain {
	my $self = shift;
	warn __PACKAGE__, ": _have_net_domain\n" if $self->debug();

	return $Domain if defined $Domain;
	return 0 if FAKE_NO_NET_DOMAIN;

	$Domain = eval {require Net::Domain};
}

sub _have_mail_send {
	my $self = shift;
	warn __PACKAGE__, ": _have_mail_send\n" if $self->debug();

	return $Send if defined $Send;
	return 0 if FAKE_NO_MAIL_SEND;

	$Send = eval {require Mail::Send};
}

sub _start_editor_mac {
	my $self = shift;
	warn __PACKAGE__, ": _start_editor_mac\n" if $self->debug();

	my $editor = shift;

	use vars '%Application';
	for my $mod (qw(Mac::MoreFiles Mac::AppleEvents::Simple Mac::AppleEvents)) {
		eval qq(require $mod) or die __PACKAGE__, ": Can't load $mod; \$\@: $@\n";
		eval qq($mod->import());
	}

	my $app = $Application{$editor};
	die __PACKAGE__, ": Application with ID '$editor' not found.\n" if !$app;

	my $obj = 'obj {want:type(cobj), from:null(), ' .
		'form:enum(name), seld:TEXT(@)}';
	my $evt = do_event(qw/aevt odoc MACS/,
		"'----': $obj, usin: $obj", $Report, $app);

	if (my $err = AEGetParamDesc($evt->{REP}, 'errn')) {
		die __PACKAGE__, ": AppleEvent error: ${\AEPrint($err)}.\n";
	}

	$self->_prompt('Done?', 'Yes') if $MacMPW;
	MacPerl::Answer('Done?') if $MacApp;
}

sub _start_editor {
	my $self = shift;
	warn __PACKAGE__, ": _start_editor\n" if $self->debug();

	my $editor = $ENV{VISUAL} || $ENV{EDITOR} || $ENV{EDIT}
		|| ($^O eq 'VMS'     and "edit/tpu")
		|| ($^O eq 'MSWin32' and "notepad")
		|| ($^O eq 'MacOS'   and 'ttxt')
		|| 'vi';

	$editor = $self->_prompt('Editor', $editor) unless $MacApp;

	if ($^O eq 'MacOS') {
		$self->_start_editor_mac($editor);
	}
	else {
		die __PACKAGE__, ": The editor `$editor' could not be run" if system "$editor $Report";
		die __PACKAGE__, ": Report has disappeared; terminated" unless -e $Report;
		die __PACKAGE__, ": Empty report; terminated" unless -s $Report > 2;
	}
}

sub _prompt {
	my $self = shift;
	warn __PACKAGE__, ": _prompt\n" if $self->debug();

	my ($label, $default) = @_;

	printf "$label%s", ($MacMPW ? ":\n$default" : " [$default]: ");
	my $input = scalar <STDIN>;
	chomp $input;

	return (length $input) ? $input : $default;
}

=head1 NAME

Test::Reporter - sends test results to cpan-testers@perl.org

=head1 SYNOPSIS

  use Test::Reporter;

  my $reporter = Test::Reporter->new();

  $reporter->grade('pass');
  $reporter->distribution('Mail-Freshmeat-1.20');
  $reporter->send() || die $reporter->errstr();

  # or

  my $reporter = Test::Reporter->new();

  $reporter->grade('fail');
  $reporter->distribution('Mail-Freshmeat-1.20');
  $reporter->comments('output of a failed make test goes here...');
  $reporter->edit_comments(); # if you want to edit comments in an editor
  $reporter->send('afoxson@cpan.org') || die $reporter->errstr();

  # or

  my $reporter = Test::Reporter->new(
      grade => 'fail',
      distribution => 'Mail-Freshmeat-1.20',
      from => 'whoever@wherever.net (Whoever Wherever)',
      comments => 'output of a failed make test goes here...',
      via => 'CPANPLUS X.Y.Z',
  );
  $reporter->send() || die $reporter->errstr();

=head1 DESCRIPTION

Test::Reporter reports the test results of any given distribution to the
CPAN testing service. See B<http://testers.cpan.org/> for details.

Test::Reporter has wide support for various perl5's and platforms.

=head1 METHODS

=over 4

=item * B<new>

This constructor returns a Test::Reporter object. It will optionally accept
named parameters for: mx, address, grade, distribution, from, comments,
via, timeout, debug and dir.

=item * B<subject>

Returns the subject line of a report, i.e.
"PASS Mail-Freshmeat-1.20 Darwin 6.0". 'grade' and 'distribution' must
first be specified before calling this method.

=item * B<report>

Returns the actual content of a report, i.e.
"This distribution has been tested as part of the cpan-testers...". 
'comments' must first be specified before calling this method, if you have
comments to make and expect them to be included in the report.

=item * B<comments>

Optional. Gets or sets the comments on the test report. This is most
commonly used for distributions that did not pass a 'make test'.

=item * B<edit_comments>

Optional. Allows one to interactively edit the comments within a text
editor. comments() doesn't have to be first specified, but it will work
properly if it was.  Accepts an optional hash of arguments:

=over 4

=item * B<suffix>

Optional. Allows one to specify the suffix ("extension") of the temp
file used by B<edit_comments>.  Defaults to '.txt'.

=back

=item * B<errstr>

Returns an error message describing why something failed. You must check
errstr() on a send() in order to be guaranteed delivery. This is optional
if you don't intend to use Test::Reporter to send reports via e-mail,
see 'send' below for more information.

=item * B<from>

Optional. Gets or sets the e-mail address of the individual submitting
the test report, i.e. "afoxson@pobox.com (Adam Foxson)". This is
mostly of use to testers running under Windows, since Test::Reporter
will usually figure this out automatically.

=item * B<grade>

Gets or sets the success or failure of the distributions's 'make test'
result. This must be one of:

  grade     meaning
  -----     -------
  pass      all tests passed
  fail      one or more tests failed
  na        distribution will not work on this platform
  unknown   distribution did not include tests

=item * B<distribution>

Gets or sets the name of the distribution you're working on, for example
Foo-Bar-0.01. There are no restrictions on what can be put here.

=item * B<send>

Sends the test report to cpan-testers@perl.org and cc's the e-mail to the
specified recipients, if any. If you do specify recipients to be cc'd and
you do not have Mail::Send installed be sure that you use the author's
@cpan.org address otherwise they will not be delivered. You must check
errstr() on a send() in order to be guaranteed delivery. Technically, this
is optional, as you may use Test::Reporter to only obtain the 'subject' and
'report' without sending an e-mail at all, although that would be unusual.

=item * B<timeout>

Optional. Gets or sets the timeout value for the submission of test
reports. Default is 120 seconds. 

=item * B<via>

Optional. Gets or sets the value that will be appended to
X-Reported-Via, generally this is useful for distributions that use
Test::Reporter to report test results. This would be something
like "CPANPLUS 0.036".

=item * B<debug>

Optional. Gets or sets the value that will turn debugging on or off.
Debug messages are sent to STDERR. 1 for on, 0 for off. Debugging
generates very verbose output and is useful mainly for finding bugs
in Test::Reporter itself.

=item * B<address>

Optional. Gets or sets the e-mail address that the reports will be
sent to. By default, this is set to cpan-testers@perl.org. You shouldn't
need this unless the CPAN Tester's change the e-mail address to send
report's to.

=item * B<mx>

Optional. Gets or sets the mail exchangers that will be used to send
the test reports. If you override the default values make sure you
pass in a reference to an array. By default, this contains the MX's
known at the time of release for perl.org. If you do not have
Mail::Send installed (thus using the Net::SMTP interface) and do have
Net::DNS installed it will dynamically retrieve the latest MX's. You
really shouldn't need to use this unless the hardcoded MX's have
become wrong and you don't have Net::DNS installed.

=item * B<mail_send_args>

Optional. If you have MailTools installed and you want to have it
behave in a non-default manner, parameters that you give this
method will be passed directly to the constructor of
Mail::Mailer. See L<Mail::Mailer> and L<Mail::Send> for details. 

=item * B<dir>

Optional. Defaults to the current working directory. This method specifies
the directory that write() writes test report files to.

=item * B<write and read>

These methods are used in situations where you test on a machine that has
port 25 blocked and there is no local MTA. You use write() on the machine
that you are testing from, transfer the written test reports from the
testing machine to the sending machine, and use read() on the machine that
you actually want to submit the reports from. write() will write a file in
an internal format that contains 'From', 'Subject', and the content of the
report. The filename will be represented as:
grade.distribution.archname.osvers.seconds_since_epoch.pid.rpt. write()
uses the value of dir() if it was specified, else the cwd.

On the machine you are testing from:

  my $reporter = Test::Reporter->new
  (
    grade => 'pass',
    distribution => 'Test-Reporter-1.16',
  )->write();

On the machine you are submitting from:

  my $reporter;
  $reporter = Test::Reporter->new()->read('pass.Test-Reporter-1.16.i686-linux.2.2.16.1046685296.14961.rpt')->send() || die $reporter->errstr(); # wrap in an opendir if you've a lot to submit

write() also accepts an optional filehandle argument:

  my $fh; open $fh, '>-';  # create a STDOUT filehandle object
  $reporter->write($fh);   # prints the report to STDOUT

=back

=head1 CAVEATS

If you specify recipients to be cc'd while using send() (and you do not have
Mail::Send installed) be sure that you use the author's @cpan.org address
otherwise they may not be delivered, since the perl.org MX's are unlikely
to relay for anything other than perl.org and cpan.org.

=head1 BUGS

If you happen to find one please email me at afoxson@pobox.com, and/or report
it to the below URL. Thank you.

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Reporter

=head1 COPYRIGHT

Copyright (c) 2003 Adam J. Foxson. All rights reserved.

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item * L<perl>

=item * L<Config>

=item * L<Net::SMTP>

=item * L<File::Spec>

=item * L<File::Temp>

=item * L<Net::Domain>

This is optional. If it's installed Test::Reporter will try even
harder at guessing your mail domain.

=item * L<Net::DNS>

This is optional. If it's installed Test::Reporter will dynamically
retrieve the mail exchangers for perl.org, instead of relying on the
MX's known at the time of this release.

=item * L<Mail::Send>

This is optional. If it's installed Test::Reporter will use Mail::Send
instead of Net::SMTP.

=back

=head1 AUTHOR

Adam J. Foxson E<lt>F<afoxson@pobox.com>E<gt> and
Richard Soderberg E<lt>F<rsod@cpan.org>E<gt>, with much deserved credit to
Kirrily "Skud" Robert E<lt>F<skud@cpan.org>E<gt>, and
Kurt Starsinic E<lt>F<Kurt.Starsinic@isinet.com>E<gt> for predecessor versions
(CPAN::Test::Reporter, and cpantest respectively).

=cut

1;
