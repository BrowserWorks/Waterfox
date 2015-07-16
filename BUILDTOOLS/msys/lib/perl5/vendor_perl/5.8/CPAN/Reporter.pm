package CPAN::Reporter;
use strict;

$CPAN::Reporter::VERSION = "0.44"; 

use Config;
use Config::Tiny ();
use CPAN ();
use Fcntl qw/:flock :seek/;
use File::Basename qw/basename/;
use File::HomeDir ();
use File::Path qw/mkpath rmtree/;
use File::Temp ();
use IO::File ();
use Probe::Perl ();
use Symbol qw/gensym/;
use Tee qw/tee/;
use Test::Reporter ();

#--------------------------------------------------------------------------#
# Back-compatibility checks -- just once per load
#--------------------------------------------------------------------------#

# 0.28_51 changed Mac OS X config file location -- if old directory is found,
# move it to the new location
if ( $^O eq 'darwin' ) {
    my $old = File::Spec->catdir(File::HomeDir->my_documents,".cpanreporter");
    my $new = File::Spec->catdir(File::HomeDir->my_home,".cpanreporter");
    if ( ( -d $old ) && (! -d $new ) ) {
        $CPAN::Frontend->mywarn( << "HERE");
Since CPAN::Reporter 0.28_51, the Mac OSX config directory has changed. 

  Old: $old
  New: $new  

Your existing configuration file will be moved automatically.
HERE
        mkpath($new);
        my $OLD_CONFIG = IO::File->new(
            File::Spec->catfile($old, "config.ini"), "<"
        ) or die $!;
        my $NEW_CONFIG = IO::File->new(
            File::Spec->catfile($new, "config.ini"), ">"
        ) or die $!;
        $NEW_CONFIG->print( do { local $/; <$OLD_CONFIG> } );
        $OLD_CONFIG->close;
        $NEW_CONFIG->close;
        unlink File::Spec->catfile($old, "config.ini") or die $!;
        rmdir($old) or die $!;
    }
}

#--------------------------------------------------------------------------#
# Some platforms don't implement flock, so fake it if necessary
#--------------------------------------------------------------------------#

BEGIN {
    eval {
        my $fh = File::Temp->new();
        flock $fh, LOCK_EX;
    };
    if ( $@ ) {
        *CORE::GLOBAL::flock = sub () { 1 };
    }
}


#--------------------------------------------------------------------------#
# defaults and prompts
#--------------------------------------------------------------------------#

# undef defaults are not written to the starter configuration file

my @config_order = qw/ email_from cc_author edit_report send_report
                       send_duplicates smtp_server /;

my $grade_action_prompt = << 'HERE'; 

Some of the following configuration options require one or more "grade:action"
pairs that determine what grade-specific action to take for that option.
These pairs should be space-separated and are processed left-to-right. See
CPAN::Reporter documentation for more details.

    GRADE   :   ACTION  ======> EXAMPLES        
    -------     -------         --------    
    pass        yes             default:no
    fail        no              default:yes pass:no
    unknown     ask/no          default:ask/no pass:yes fail:no
    na          ask/yes         
    default

HERE

my %defaults = (
    email_from => {
        default => '',
        prompt => 'What email address will be used for sending reports?',
        info => <<'HERE',
CPAN::Reporter requires a valid email address as the return address
for test reports sent to cpan-testers\@perl.org.  Either provide just
an email address, or put your real name in double-quote marks followed 
by your email address in angle marks, e.g. "John Doe" <jdoe@nowhere.com>.
Note: unless this email address is subscribed to the cpan-testers mailing
list, your test reports will not appear until manually reviewed.
HERE
    },
    cc_author => {
        default => 'default:yes pass:no',
        prompt => "Do you want to CC the the module author?",
        validate => 1,
        info => <<'HERE',
If you would like, CPAN::Reporter will copy the module author with
the results of your tests.  By default, authors are copied only on 
failed/unknown results. This option takes "grade:action" pairs.  
HERE
    },
    edit_report => {
        default => 'default:ask/no pass:no',
        prompt => "Do you want to edit the test report?",
        validate => 1,
        info => <<'HERE',
Before test reports are sent, you may want to edit the test report
and add additional comments about the result or about your system or
Perl configuration.  By default, CPAN::Reporter will ask after
each report is generated whether or not you would like to edit the 
report. This option takes "grade:action" pairs.
HERE
    },
    send_report => {
        default => 'default:ask/yes pass:yes na:no',
        prompt => "Do you want to send the test report?",
        validate => 1,
        info => <<'HERE',
By default, CPAN::Reporter will prompt you for confirmation that
the test report should be sent before actually emailing the 
report.  This gives the opportunity to bypass sending particular
reports if you need to (e.g. if you caused the failure).
This option takes "grade:action" pairs.
HERE
    },
    send_duplicates => {
        default => 'default:no',
        prompt => "This report is identical to a previous one.  Send it anyway?",
        validate => 1,
        info => <<'HERE',
CPAN::Reporter records tests grades for each distribution, version and
platform.  By default, duplicates of previous results will not be sent at
all, regardless of the value of the "send_report" option.  This option takes 
"grade:action" pairs.
HERE
    },
    smtp_server => {
        default => undef, # not written to starter config
        info => <<'HERE',
If your computer is behind a firewall or your ISP blocks
outbound mail traffic, CPAN::Reporter will not be able to send
test reports unless you provide an alternate outbound (SMTP) 
email server.  Enter the full name of your outbound mail server
(e.g. smtp.your-ISP.com) or leave this blank to send mail 
directly to perl.org.  Use a space character to reset an existing
default.
HERE
    },
    email_to => {
        default => undef, # not written to starter config
    },
    editor => {
        default => undef, # not written to starter config
    },
    debug => {
        default => undef, # not written to starter config
    }
);

#--------------------------------------------------------------------------#
# public API
#--------------------------------------------------------------------------#

sub configure {
    my $config_dir = _get_config_dir();
    my $config_file = _get_config_file();

    mkpath $config_dir if ! -d $config_dir;

    my $config;
    my $existing_options;
    
    # explain grade:action pairs
    $CPAN::Frontend->myprint( $grade_action_prompt );
    
    # read or create
    if ( -f $config_file ) {
        $CPAN::Frontend->myprint(
            "\nFound your CPAN::Reporter config file at:\n$config_file\n"
        );
        $config = _open_config_file();
        $existing_options = _get_config_options( $config ) if $config;
        # if a file exists, but we can't open it or read it, then stop
        if ( ! ( $config && $existing_options) ) {
            $CPAN::Frontend->mywarn("\n
                CPAN::Reporter configuration will not be changed\n");
            return;
        }
        $CPAN::Frontend->myprint(
            "\nUpdating your CPAN::Reporter configuration settings:\n"
        );
    }
    else {
        $CPAN::Frontend->myprint(
            "\nNo CPAN::Reporter config file found; creating a new one.\n"
        );
        $config = Config::Tiny->new();
    }
    
    for my $k ( @config_order ) {
        my $option_data = $defaults{$k};
        $CPAN::Frontend->myprint( "\n" . $option_data->{info}. "\n");
        # options with defaults are mandatory
        if ( defined $defaults{$k}{default} ) {
            # repeat until validated
            PROMPT:
            while ( my $answer = CPAN::Shell::colorable_makemaker_prompt(
                "$k?", 
                $existing_options->{$k} || $option_data->{default} )
            ) 
            {
                if ( $defaults{$k}{validate} ) {
                    for my $ga ( split q{ }, $answer ) {
                        if ( ! _validate_grade_action( $ga ) ) {
                            $CPAN::Frontend->mywarn( "\nInvalid option '$ga' in '$k'\n\n" );
                            next PROMPT;
                        }
                    }
                }
                $config->{_}{$k} = $answer;
                last PROMPT;
            }
        }
        else {
            # only initialize options without default if
            # answer matches non white space and validates, 
            # otherwise reset it
            my $answer = CPAN::Shell::colorable_makemaker_prompt( 
                "$k?", 
                $existing_options->{$k} || q{} 
            ); 
            if ( $answer =~ /\S/ ) {
                $config->{_}{$k} = $answer;
            }
            else {
                delete $config->{_}{$k};
            }
        }
        # delete existing as we proceed so we know what's left
        delete $existing_options->{$k};
    }

    # initialize remaining existing options
    $CPAN::Frontend->myprint(
        "\nYour CPAN::Reporter config file also contains these advanced " .
          "options:\n\n") if keys %$existing_options;
    for my $k ( keys %$existing_options ) {
        $config->{_}{$k} = CPAN::Shell::colorable_makemaker_prompt( 
            "$k?", $existing_options->{$k} 
        ); 
    }

    $CPAN::Frontend->myprint( 
        "\nWriting CPAN::Reporter config file to '$config_file'.\n"
    );
    if ( $config->write( $config_file ) ) {
        return $config->{_};
    }
    else {
        $CPAN::Frontend->mywarn( "\nError writing config file to '$config_file':" . 
             Config::Tiny->errstr(). "\n");
        return;
    }
}

sub test {
    my ($dist, $system_command) = @_;
    my $temp_out = File::Temp->new;
    
    my $result = {
        dist => $dist,
        command => $system_command,
    };

    my ($tee_input, $makewrapper);
    
    if ( -f "test.pl" && _is_make($system_command) ) {
        $makewrapper = File::Temp->new
            or die "Could not create a wrapper for make: $!";
        print $makewrapper qq{system('$system_command');\n};
        print $makewrapper qq{print "makewrapper: make ", \$? ? "failed" : "ok","\n"};
        $makewrapper->close;
        $tee_input = Probe::Perl->find_perl_interpreter() .  " $makewrapper";
    }
    else {
        $tee_input = $system_command;
    }
    
    tee($tee_input, { stderr => 1 }, $temp_out);
        
    my $TEST_RESULT = IO::File->new($temp_out->filename, "<");
    if ( !$TEST_RESULT ) {
        $CPAN::Frontend->mywarn( "CPAN::Reporter couldn't read test results\n" );
        return;
    }
    $result->{output} = [ <$TEST_RESULT> ];
    $TEST_RESULT->close;

    _expand_report( $result );
    _dispatch_report( $result );

    return $result->{success};   # from _expand_report 
}

#--------------------------------------------------------------------------#
# private functions
#--------------------------------------------------------------------------#

#--------------------------------------------------------------------------#
# _dispatch_report
#
# Set up Test::Reporter and prompt user for CC, edit, send
#--------------------------------------------------------------------------#

sub _dispatch_report {
    my $result = shift;

    $CPAN::Frontend->myprint("Preparing a test report for $result->{dist_name}\n");

    # Get configuration options
    my $config_obj = _open_config_file();
    my $config;
    $config = _get_config_options( $config_obj ) if $config_obj;
    if ( ! $config->{email_from} ) {
        $CPAN::Frontend->mywarn( << "EMAIL_REQUIRED");
        
CPAN::Reporter requires an email-address in the config file.  
Test report will not be sent. See documentation for configuration details.

EMAIL_REQUIRED
        return;
    }
        
    # Abort if the distribution name is not formatted according to 
    # CPAN Testers requirements: Dist-Name-version.suffix
    # Regex from CPAN-Testers should extract name, separator, version
    # and extension
    my @format_checks = $result->{dist_basename} =~ 
        m{(.+)([\-\_])(v?\d.*)(\.(?:tar\.(?:gz|bz2)|tgz|zip))$}i;
    ;
    if ( ! grep { length } @format_checks ) {
        $CPAN::Frontend->mywarn( << "END_BAD_DISTNAME");
        
The distribution name '$result->{dist_basename}' does not appear to be 
formatted according to CPAN tester guidelines. Perhaps it is not a normal
CPAN distribution.

Test report will not be sent.

END_BAD_DISTNAME

        return;
    }

    # Setup the test report
    my $tr = Test::Reporter->new;
    $tr->grade( $result->{grade} );
    $tr->distribution( $result->{dist_name}  );

    # Skip if duplicate and not sending duplicates
    my $is_duplicate = _is_duplicate( $tr->subject );
    if ( $is_duplicate ) {
        if ( _prompt( $config, "send_duplicates", $tr->grade) =~ /^n/ ) {
            $CPAN::Frontend->mywarn(<< "DUPLICATE_REPORT");

It seems that "@{[$tr->subject]}"
is a duplicate of a previous report you sent to CPAN Testers.

Test report will not be sent.

DUPLICATE_REPORT
            
            return;
        }
    }

    # Continue report setup
    $tr->debug( $config->{debug} ) if defined $config->{debug};
    $tr->from( $config->{email_from} );
    $tr->address( $config->{email_to} ) if $config->{email_to};
    if ( $config->{smtp_server} ) {
        my @mx = split " ", $config->{smtp_server};
        $tr->mx( \@mx );
    }
    
    # Populate the test report
    $tr->comments( _report_text( $result ) );
    $tr->via( 'CPAN::Reporter ' . $CPAN::Reporter::VERSION );
    my @cc;

    # User prompts for action
    if ( _prompt( $config, "cc_author", $tr->grade) =~ /^y/ ) {
        # CC only if we have an author_id
        push @cc, "$result->{author_id}\@cpan.org" if $result->{author_id};
    }
    
    if ( _prompt( $config, "edit_report", $tr->grade ) =~ /^y/ ) {
        local $ENV{VISUAL} = $ENV{VISUAL};
        my $editor = $config->{editor};
        $ENV{VISUAL} = $editor if $editor;
        $tr->edit_comments;
    }
    
    if ( _prompt( $config, "send_report", $tr->grade ) =~ /^y/ ) {
        $CPAN::Frontend->myprint( "Sending test report with '" . $tr->grade . 
              "' to " . join(q{, }, $tr->address, @cc) . "\n");
        if ( $tr->send( @cc ) ) {
                _record_history( $tr->subject ) if not $is_duplicate;
        }
        else {
            $CPAN::Frontend->mywarn( $tr->errstr. "\n");
        }
    }
    else {
        $CPAN::Frontend->myprint("Test report not sent\n");
    }

    return;
}

#--------------------------------------------------------------------------#
# _expand_report
#
# broken out separately for testing
#--------------------------------------------------------------------------#

sub _expand_report {
    my $result = shift;

    # Note: pretty_id is like "DAGOLDEN/CPAN-Reporter-0.40.tar.gz"
    $result->{dist_name} = _format_distname( $result->{dist} );
    $result->{dist_basename} = basename($result->{dist}->pretty_id);
    $result->{prereq_pm} = _prereq_report( $result->{dist} );
    $result->{env_vars} = _env_report();
    $result->{special_vars} = _special_vars_report();
    $result->{toolchain_versions} = _toolchain_report();
    $result->{grade} = _grade_report($result);
    $result->{success} =  $result->{grade} eq 'pass'
                       || $result->{grade} eq 'unknown';
    
    # CPAN might fail to find an author object for some strange dists
    my $author = $result->{dist}->author;
    $result->{author} = defined $author ? $author->fullname : "Author";
    $result->{author_id} = defined $author ? $author->id : "" ;

    return;
}

#--------------------------------------------------------------------------#
# _env_report
#--------------------------------------------------------------------------#

# Entries bracketed with "/" are taken to be a regex; otherwise literal
my @env_vars= qw(
    /PERL/
    /LC_/
    LANG
    LANGUAGE
    PATH
    SHELL
    COMSPEC
    TERM
    AUTOMATED_TESTING
    AUTHOR_TESTING
    INCLUDE
    LIB
    LD_LIBRARY_PATH
    PROCESSOR_IDENTIFIER
    NUMBER_OF_PROCESSORS
);

sub _env_report {
    my @vars_found;
    for my $var ( @env_vars ) {
        if ( $var =~ m{^/(.+)/$} ) {
            push @vars_found, grep { /$1/ } keys %ENV;
        }
        else {
            push @vars_found, $var if exists $ENV{$var};
        }
    }

    my $report = "";
    for my $var ( sort @vars_found ) {
        $report .= "    $var = $ENV{$var}\n";
    }
    return $report;
}

#--------------------------------------------------------------------------#
# _format_distname
#--------------------------------------------------------------------------#

sub _format_distname {
    my $dist = shift;
    my $basename = basename( $dist->pretty_id );
    $basename =~ s/(\.tar\.gz|\.tgz|\.zip)$//i;
    return $basename;
}

#--------------------------------------------------------------------------#
# _format_history -- append perl version to subject
#--------------------------------------------------------------------------#

sub _format_history {
    my $line = shift(@_) . " $]"; # append perl version to subject
    $line .= " patch $Config{perl_patchlevel}" if $Config{perl_patchlevel};
    return $line . "\n";
}

#--------------------------------------------------------------------------#
# _get_config_dir
#--------------------------------------------------------------------------#

sub _get_config_dir {
    return ( $^O eq 'MSWin32' )
        ? File::Spec->catdir(File::HomeDir->my_documents, ".cpanreporter")
        : File::Spec->catdir(File::HomeDir->my_home, ".cpanreporter") ;
}

#--------------------------------------------------------------------------#
# _get_config_file
#--------------------------------------------------------------------------#

sub _get_config_file {
    return File::Spec->catdir( _get_config_dir, "config.ini" );
}

#--------------------------------------------------------------------------#
# _get_config_options
#--------------------------------------------------------------------------#

sub _get_config_options {
    my $config = shift;
    # extract and return valid options, with fallback to defaults
    my %active;
    for my $option ( keys %defaults ) {
        if ( exists $config->{_}{$option} ) {
            $active{$option} = $config->{_}{$option};
        }
        else {
            $active{$option} = $defaults{$option}{default}
                if defined $defaults{$option}{default};
        }
    }
    return \%active;
}


#--------------------------------------------------------------------------#
# _get_history_file
#--------------------------------------------------------------------------#

sub _get_history_file {
    return File::Spec->catdir( _get_config_dir, "history.db" );
}

#--------------------------------------------------------------------------#
# _grade_msg
#--------------------------------------------------------------------------#

sub _grade_msg {
    my ($grade, $msg) = @_;
    $CPAN::Frontend->myprint( "Test result is '$grade'");
    $CPAN::Frontend->myprint(": $msg") if defined $msg && length $msg;
    $CPAN::Frontend->myprint(".\n");
    return;
}

#--------------------------------------------------------------------------#
# _grade_report
#--------------------------------------------------------------------------#

sub _grade_report {
    my $result = shift;
    my ($grade,$is_make,$msg);
    my $output = $result->{output};
    
    # Output strings taken from Test::Harness::
    # _show_results()  -- for versions < 2.57_03 
    # get_results()    -- for versions >= 2.57_03

    # XXX don't shortcut to unknown with _has_tests here because a custom
    # Makefile.PL or Build.PL might define tests in a non-standard way
    
    # check for make or Build
    $is_make = _is_make( $result->{command} );
    
    # parse in reverse order for Test::Harness results
    for my $i ( reverse 0 .. $#{$output} ) {
        if ( $output->[$i] =~ m{^All tests successful}ms ) {
            $grade = 'pass';
            $msg = 'All tests successful';
        }
        elsif ( $output->[$i] =~ m{^.?No tests defined}ms ) {
            $grade = 'unknown';
            $msg = 'No tests provided';
        }
        elsif ( $output->[$i] =~ m{^FAILED--no tests were run}ms ) {
            $grade = 'unknown';
            $msg = 'No tests were run';
        }
        elsif ( $output->[$i] =~ m{^FAILED--.*--no output}ms ) {
            $grade = 'fail';
            $msg = 'Tests had no output';
        }
        elsif ( $output->[$i] =~ m{^Failed }ms ) {  # must be lowercase
            $grade = 'fail';
            $msg = "Distribution had failing tests";
        }
        else {
            next;
        }
        if ( $grade eq 'unknown' && _has_tests() ) {
            # probably a spurious message from recursive make, so ignore and
            # continue if we can find any standard test files
            $grade = $msg = undef;
            next;
        }
        last if $grade;
    }
    
    # didn't find Test::Harness output we recognized
    if ( ! $grade ) {
        $grade = "unknown";
        $msg = "Couldn't determine a result";
    }

    # With test.pl and 'make test', any t/*.t might pass Test::Harness, but
    # test.pl might still fail, or there might only be test.pl,
    # so re-run make test on test.pl
    
    if ( $is_make && -f "test.pl" && $grade ne 'fail' ) {
        if ( $output->[-1] =~ m{^makewrapper: make failed}ims ) {
            $grade = "fail";
            $msg = "'make test' error detected";
        }
        else {
            $grade = "pass";
            $msg = "'make test' no errors";
        }
    }

    # Downgrade failure if we can determine a cause of the failure
    # that should be reported as 'na'

    if ( $grade eq 'fail' ) {
        # check for perl version prerequisite or outright failure
        if ( $result->{prereq_pm} =~ m{^\s+!\s+perl\s}ims ) {
            $grade = 'na';
            $msg = 'Perl version too low';
        }
        # check the prereq report for missing or failure flag '!'
        elsif ( $result->{prereq_pm} =~ m{n/a}ims ) {
            $grade = 'na';
            $msg = 'Prerequisite missing';
        }
        elsif ( $result->{prereq_pm} =~ m{^\s+!}ims ) {
            $grade = 'na';
            $msg = 'Prerequisite version too low';
        }
    }

    _grade_msg( $grade, $msg );
    return $grade;
}

#--------------------------------------------------------------------------#
# _has_tests
#--------------------------------------------------------------------------#

sub _has_tests {
    return 1 if -f 'test.pl';
    if ( -d 't' ) {
        local *TESTDIR;
        opendir TESTDIR, 't';
        while ( my $f = readdir TESTDIR ) {
            if ( $f =~ m{\.t$} ) {
                close TESTDIR;
                return 1;
            }
        }
    }
    return 0;
}

#--------------------------------------------------------------------------#
# _is_duplicate
#--------------------------------------------------------------------------#

sub _is_duplicate {
    my $subject = _format_history( shift );
    my $history = _open_history_file('<') or return;
    my $found = 0;
    flock $history, LOCK_SH;
    while ( defined (my $line = <$history>) ) {
        $found++, last if $line eq $subject
    }
    $history->close;
    return $found;
}

#--------------------------------------------------------------------------#
# _is_make
#--------------------------------------------------------------------------#

sub _is_make {
    my $command = shift;
    return $command =~ m{^\S*make}ims ? 1 : 0;
}

#--------------------------------------------------------------------------#
# _is_valid_action
#--------------------------------------------------------------------------#

my @valid_actions = qw{ yes no ask/yes ask/no ask };

sub _is_valid_action {
    my $action = shift;
    return grep { $action eq $_ } @valid_actions;
}

#--------------------------------------------------------------------------#
# _is_valid_grade
#--------------------------------------------------------------------------#

my @valid_grades = qw{ pass fail unknown na default };
sub _is_valid_grade {
    my $grade = shift;
    return grep { $grade eq $_ } @valid_grades;
}

#--------------------------------------------------------------------------#
# _max_length
#--------------------------------------------------------------------------#

sub _max_length {
    my $max = length shift;
    for my $term ( @_ ) {
        $max = length $term if length $term > $max;
    }
    return $max;
}

    
#--------------------------------------------------------------------------#
# _open_config_file
#--------------------------------------------------------------------------#

sub _open_config_file {
    my $config_file = _get_config_file();
    my $config = Config::Tiny->read( $config_file )
        or $CPAN::Frontend->mywarn("Couldn't read CPAN::Reporter configuration file " .
                "'$config_file': " . Config::Tiny->errstr() . "\n");
    return $config; 
}

#--------------------------------------------------------------------------#
# _open_history_file
#--------------------------------------------------------------------------#

sub _open_history_file {
    my $mode = shift || '<';
    my $history_filename = _get_history_file();
    return if ( $mode eq '<' && ! -f $history_filename );
    my $history = IO::File->new( $history_filename, $mode )
        or $CPAN::Frontend->mywarn("Couldn't open CPAN::Reporter history file "
        . "'$history_filename': $!\n");
    return $history; 
}

#--------------------------------------------------------------------------#
# _parse_option
#--------------------------------------------------------------------------#

sub _parse_option {
    my $name = shift;
    my $input_string = "default:no " . shift;
    
    # preset defaults
    my @options;

    # process space-separated terms in order
    for my $spec ( split q{ }, $input_string ) {
        my ($grade_list,$action);
        
        # get valid parts or warn
        my @grade_actions = _validate_grade_action($spec);
        
        if( ! @grade_actions ) {
            $CPAN::Frontend->mywarn( 
                "Ignoring invalid grade:action '$spec' for '$name'\n"
            );
        }
        
        push @options, @grade_actions;
    }
    
    return { @options };
}

#--------------------------------------------------------------------------#
# _prereq_report
#--------------------------------------------------------------------------#

sub _prereq_report {
    my $dist = shift;
    my (%need, %have, %prereq_met, $report);
    
    my $prereq_pm = $dist->prereq_pm;

    if ( ref $prereq_pm eq 'HASH' ) {
        # is it the new CPAN style with requires/build_requires?
        if (join(q{ }, sort keys %$prereq_pm) eq "build_requires requires") {
            $need{requires} = $prereq_pm->{requires} 
                if  ref $prereq_pm->{requires} eq 'HASH';
            $need{build_requires} = $prereq_pm->{build_requires} 
                if ref $prereq_pm->{build_requires} eq 'HASH';
        }
        else {
            $need{requires} = $prereq_pm;
        }
    }

    # see what prereqs are satisfied in subprocess
    for my $section ( qw/requires build_requires/ ) {
        next unless ref $need{$section} eq 'HASH';
        my @prereq_list = %{ $need{$section} };
        next unless @prereq_list;
        my $prereq_results = _version_finder( @prereq_list );
        for my $mod ( keys %{$prereq_results} ) {
            $have{$section}{$mod} = $prereq_results->{$mod}{have};
            $prereq_met{$section}{$mod} = $prereq_results->{$mod}{met};
        }
    }
    
    # find formatting widths 
    my ($name_width, $need_width, $have_width) = (6, 4, 4);
    for my $section ( qw/requires build_requires/ ) {
        for my $module ( keys %{ $need{$section} } ) {
            my $name_length = length $module;
            my $need_length = length $need{$section}{$module};
            my $have_length = length $have{$section}{$module};
            $name_width = $name_length if $name_length > $name_width;
            $need_width = $need_length if $need_length > $need_width;
            $have_width = $have_length if $have_length > $have_width;
        }
    }

    my $format_str = 
        "  \%1s \%-${name_width}s \%-${need_width}s \%-${have_width}s\n";

    # generate the report
    for my $section ( qw/requires build_requires/ ) {
        if ( keys %{ $need{$section} } ) {
            $report .= "$section:\n\n";
            $report .= sprintf( $format_str, " ", qw/Module Need Have/ );
            $report .= sprintf( $format_str, " ", 
                                 "-" x $name_width, 
                                 "-" x $need_width,
                                 "-" x $have_width );
        }
        for my $module ( sort { lc $a cmp lc $b } keys %{ $need{$section} } ) {
            my $need = $need{$section}{$module};
            my $have = $have{$section}{$module};
            my $bad = $prereq_met{$section}{$module} ? " " : "!";
            $report .= 
                sprintf( $format_str, $bad, $module, $need, $have);
        }
    }
    
    return $report || "    No requirements found\n";
}

#--------------------------------------------------------------------------#
# _prompt
#
# Note: always returns lowercase
#--------------------------------------------------------------------------#

sub _prompt {
    my ($config, $option, $grade) = @_;

    my $dispatch = _parse_option( $option, $config->{$option} );
    my $action = $dispatch->{$grade} || $dispatch->{default};

    my $prompt;
    if     ( $action =~ m{^ask/yes}i ) { 
        $prompt = CPAN::Shell::colorable_makemaker_prompt( 
            $defaults{$option}{prompt} . " (yes/no)", "yes" 
        );
    }
    elsif  ( $action =~ m{^ask(/no)?}i ) {
        $prompt = CPAN::Shell::colorable_makemaker_prompt( 
            $defaults{$option}{prompt} . " (yes/no)", "no" 
        );
    }
    else { 
        $prompt = $action;
    }
    return lc $prompt;
}

#--------------------------------------------------------------------------#
# _record_history
#--------------------------------------------------------------------------#

sub _record_history {
    my $subject = _format_history( shift );
    my $history = _open_history_file('>>') or return;

    flock( $history, LOCK_EX );
    seek( $history, 0, SEEK_END );
    $history->print( $subject );
    flock( $history, LOCK_UN );
    
    $history->close;
    return;
}

#--------------------------------------------------------------------------#
# _report_text
#--------------------------------------------------------------------------#

my %intro_para = (
    'pass' => <<'HERE',
Thank you for uploading your work to CPAN.  Congratulations!
All tests were successful.
HERE

    'fail' => <<'HERE',
Thank you for uploading your work to CPAN.  However, it appears that
there were some problems testing your distribution.
HERE

    'unknown' => <<'HERE',
Thank you for uploading your work to CPAN.  However, attempting to
test your distribution gave an inconclusive result.  This could be because
you did not define tests (or tests could not be found), because
your tests were interrupted before they finished, or because
the results of the tests could not be parsed by CPAN::Reporter.
HERE

    'na' => <<'HERE',
Thank you for uploading your work to CPAN.  However, it appears that
your distribution tests are not fully supported on this machine, either 
due to operating system limitations or missing prerequisite modules.
If the failure is due to missing prerequisites, you may wish to 
disregard this report.
HERE
    
);

sub _report_text {
    my $data = shift;
    my $test_log = join(q{},@{$data->{output}});
    # generate report
    my $output = << "ENDREPORT";
Dear $data->{author},
    
This is a computer-generated test report for $data->{dist_name}, created
automatically by CPAN::Reporter, version $CPAN::Reporter::VERSION, and sent to the CPAN 
Testers mailing list.  If you have received this email directly, it is 
because the person testing your distribution chose to send a copy to your 
CPAN email address; there may be a delay before the official report is
received and processed by CPAN Testers.

$intro_para{ $data->{grade} }
Sections of this report:

    * Tester comments
    * Prerequisites
    * Environment and other context
    * Test output

------------------------------
TESTER COMMENTS
------------------------------

Additional comments from tester: 

[none provided]

------------------------------
PREREQUISITES
------------------------------

Prerequisite modules loaded:

$data->{prereq_pm}
------------------------------
ENVIRONMENT AND OTHER CONTEXT
------------------------------

Environment variables:

$data->{env_vars}
Perl special variables (and OS-specific diagnostics, for MSWin32):

$data->{special_vars}
Perl module toolchain versions installed:

$data->{toolchain_versions}
------------------------------
TEST OUTPUT
------------------------------

Output from '$data->{command}':

$test_log
ENDREPORT

    return $output;
}

#--------------------------------------------------------------------------#
# _special_vars_report
#--------------------------------------------------------------------------#

sub _special_vars_report {
    my $special_vars = << "HERE";
    Perl: \$^X = $^X
    UID:  \$<  = $<
    EUID: \$>  = $>
    GID:  \$(  = $(
    EGID: \$)  = $)
HERE
    if ( $^O eq 'MSWin32' && eval "require Win32" ) { ## no critic
        my @getosversion = Win32::GetOSVersion();
        my $getosversion = join(", ", @getosversion);
        $special_vars .= "    Win32::GetOSName = " . Win32::GetOSName() . "\n";
        $special_vars .= "    Win32::GetOSVersion = $getosversion\n";
        $special_vars .= "    Win32::IsAdminUser = " . Win32::IsAdminUser() . "\n";
    }
    return $special_vars;
}

#--------------------------------------------------------------------------#-
# _toolchain_report
#--------------------------------------------------------------------------#

my @toolchain_mods= qw(
    CPAN
    Cwd
    ExtUtils::CBuilder
    ExtUtils::Command
    ExtUtils::Install
    ExtUtils::MakeMaker
    ExtUtils::Manifest
    ExtUtils::ParseXS
    File::Spec
    Module::Build
    Module::Signature
    Test::Harness
    Test::More
    version
);

sub _toolchain_report {
    my $installed = _version_finder( map { $_ => 0 } @toolchain_mods );

    my $mod_width = _max_length( keys %$installed );
    my $ver_width = _max_length( 
        map { $installed->{$_}{have} } keys %$installed  
    );

    my $format = "    \%-${mod_width}s \%-${ver_width}s\n";

    my $report = "";
    $report .= sprintf( $format, "Module", "Have" );
    $report .= sprintf( $format, "-" x $mod_width, "-" x $ver_width );

    for my $var ( sort keys %$installed ) {
        $report .= sprintf("    \%-${mod_width}s \%-${ver_width}s\n",
                            $var, $installed->{$var}{have} );
    }

    return $report;
}


#--------------------------------------------------------------------------#
# _validate_grade_action 
# returns grade, action, grade, action ...
# returns empty list/undef if invalid
#--------------------------------------------------------------------------#

sub _validate_grade_action {
    my $grade_action = shift;
    
    my ($grade_list,$action);

    if ( $grade_action =~ m{.:.} ) {
        # parse pair for later check
        ($grade_list, $action) = $grade_action =~ m{\A([^:]+):(.+)\z};
    }
    elsif ( _is_valid_action($grade_action) ) {
        # action by itself
        return "default", $grade_action;
    }
    elsif ( _is_valid_grade($grade_action) ) {
        # grade by itself
        return $grade_action, "yes";
    }
    elsif( $grade_action =~ m{./.} ) {
        # gradelist by itself, so setup for later check
        $grade_list = $grade_action;
        $action = "yes";
    }
    else {
        # something weird, so fail
        return;
    }
        
    # check gradelist
    my @grades = split "/", $grade_list;
    
    for my $g ( @grades ) { 
        return if ! _is_valid_grade($g);
    }
    
    # check action
    return if ! _is_valid_action($action);

    # otherwise, it all must be OK
    return map { $_ => $action } @grades;
}

#--------------------------------------------------------------------------#
# _version_finder
#
# module => version pairs
#
# This is done via an external program to show installed versions exactly
# the way they would be found when test programs are run.  This means that
# any updates to PERL5LIB will be reflected in the results.
#
# File-finding logic taken from CPAN::Module::inst_file().  Logic to 
# handle newer Module::Build prereq syntax is taken from
# CPAN::Distribution::unsat_prereq()
#
#--------------------------------------------------------------------------#

my $version_finder = File::Temp->new
    or die "Could not create temporary support program for versions: $!";
$version_finder->print( << 'END' );
use strict;
use ExtUtils::MakeMaker;
use CPAN::Version;

# read module and prereq string from STDIN
while ( <STDIN> ) {
    m/^(\S+)\s+([^\n]*)/;
    my ($mod, $need) = ($1, $2);
    die "Couldn't read module for '$_'" unless $mod;
    $need = 0 if not defined $need;

    # get installed version from file with EU::MM
    my($have, $inst_file, $dir, @packpath);
    if ( $mod eq "perl" ) { 
        $have = $];
    }
    else {
        @packpath = split /::/, $mod;
        $packpath[-1] .= ".pm";
        if (@packpath == 1 && $packpath[0] eq "readline.pm") {
            unshift @packpath, "Term", "ReadLine"; # historical reasons
        }
        foreach $dir (@INC) {
            my $pmfile = File::Spec->catfile($dir,@packpath);
            if (-f $pmfile){
                $inst_file = $pmfile;
            }
        }
        
        # get version from file or else report missing
        if ( defined $inst_file ) {
            $have = MM->parse_version($inst_file);
            $have = "0" if ! defined $have || $have eq 'undef';
        }
        else {
            print "$mod 0 n/a\n";
            next;
        }
    }

    # complex requirements are comma separated
    my ( @requirements ) = split /\s*,\s*/, $need;

    my $passes = 0;
    RQ: 
    for my $rq (@requirements) {
        if ($rq =~ s|>=\s*||) {
            # no-op -- just trimmed string
        } elsif ($rq =~ s|>\s*||) {
            if (CPAN::Version->vgt($have,$rq)){
                $passes++;
            }
            next RQ;
        } elsif ($rq =~ s|!=\s*||) {
            if (CPAN::Version->vcmp($have,$rq)) { 
                $passes++; # didn't match
            }
            next RQ;
        } elsif ($rq =~ s|<=\s*||) {
            if (! CPAN::Version->vgt($have,$rq)){
                $passes++;
            }
            next RQ;
        } elsif ($rq =~ s|<\s*||) {
            if (CPAN::Version->vlt($have,$rq)){
                $passes++;
            }
            next RQ;
        }
        # if made it here, then it's a normal >= comparison
        if (! CPAN::Version->vlt($have, $rq)){
            $passes++;
        }
    }
    my $ok = $passes == @requirements ? 1 : 0;
    print "$mod $ok $have\n"
}
END
close VERSIONFINDER;

sub _version_finder {
    my %prereqs = @_;

    my $perl = Probe::Perl->find_perl_interpreter();
    my @prereq_results;
    
    my $prereq_input = File::Temp->new
        or die "Could not create temporary input for prereq analysis: $!";
    $prereq_input->print( map { "$_ $prereqs{$_}\n" } keys %prereqs );
    $prereq_input->close;

    my $prereq_result = qx/$perl $version_finder < $prereq_input/;

    my %result;
    for my $line ( split "\n", $prereq_result ) {
        my ($mod, $met, $have) = split " ", $line;
        $result{$mod}{have} = $have;
        $result{$mod}{met} = $met;
    }
    return \%result;
}

1; #this line is important and will help the module return a true value

__END__

#--------------------------------------------------------------------------#
# pod documentation 
#--------------------------------------------------------------------------#

=begin wikidoc

= NAME

CPAN::Reporter - Provides Test::Reporter support for CPAN.pm

= VERSION

This documentation describes version %%VERSION%%.

= SYNOPSIS

From the CPAN shell:

 cpan> install CPAN::Reporter
 cpan> reload cpan
 cpan> o conf init test_report

= DESCRIPTION

CPAN::Reporter is an add-on for the CPAN.pm module that uses
[Test::Reporter] to send the results of module tests to the CPAN
Testers project.  Support for CPAN::Reporter is available in CPAN.pm 
as of version 1.88.

The goal of the CPAN Testers project ([http://testers.cpan.org/]) is to
test as many CPAN packages as possible on as many platforms as
possible.  This provides valuable feedback to module authors and
potential users to identify bugs or platform compatibility issues and
improves the overall quality and value of CPAN.

One way individuals can contribute is to send test results for each module that
they test or install.  Installing CPAN::Reporter gives the option of
automatically generating and emailing test reports whenever tests are run via
CPAN.pm.

= GETTING STARTED

The first step in using CPAN::Reporter is to install it using whatever
version of CPAN.pm is already installed.  CPAN.pm will be upgraded as
a dependency if necessary.

 cpan> install CPAN::Reporter

If CPAN.pm was upgraded, it needs to be reloaded.

 cpan> reload cpan

If upgrading from a very old version of CPAN.pm, users may be prompted to renew
their configuration settings, including the 'test_report' option to enable
CPAN::Reporter.  

If not prompted automatically, users should manually initialize CPAN::Reporter
support.  After enabling CPAN::Reporter, CPAN.pm will automatically continue
with interactive configuration of CPAN::Reporter options.  (Remember to 
commit the CPAN configuration changes.)

 cpan> o conf init test_report
 cpan> o conf commit

Once CPAN::Reporter is enabled and configured, test or install modules with
CPAN.pm as usual.  

For example, to force CPAN to repeat tests for CPAN::Reporter to see how it
works:

 cpan> force test CPAN::Reporter

= UNDERSTANDING TEST GRADES

CPAN::Reporter will assign one of the following grades to the report:

* {pass} -- all tests were successful  

* {fail} -- one or more tests failed, one or more test files died during
testing or no test output was seen

* {na} -- tests could not be run on this platform or one or more test files
died because of missing prerequisites

* {unknown} -- no test files could be found (either t/*.t or test.pl) or 
a result could not be determined from test output

* {default} -- this is not an actual grade reported to CPAN Testers, but it
is used in action prompt configuration options to indicate a fallback action

In returning results to CPAN.pm, "pass" and "unknown" are considered successful
attempts to "make test" or "Build test" and will not prevent installation.
"fail" and "na" are considered to be failures and CPAN.pm will not install
unless forced.

= CONFIG FILE OPTIONS

Default options for CPAN::Reporter are read from a configuration file 
{.cpanreporter/config.ini} in the user's home directory (Unix and OS X)
or "My Documents" directory (Windows).

The configuration file is in "ini" format, with the option name and value
separated by an "=" sign

  email_from = "John Doe" <johndoe@nowhere.org>
  cc_author = no

Interactive configuration of email address, action prompts and mail server
options may be repeated at any time from the CPAN shell.  

 cpan> o conf init test_report

Interactive configuration will also include any additional, non-standard
options that have been added manually to the configuration file.

Available options are described in the following sections.

== Email Address (required)

CPAN::Reporter requires users to provide an email address that will be used
in the "From" header of the email to cpan-testers@perl.org.

* {email_from = <email address>} -- email address of the user sending the
test report; it should be a valid address format, e.g.:

 user@domain
 John Doe <user@domain>
 "John Q. Public" <user@domain>

Because {cpan-testers} uses a mailing list to collect test reports, it is
helpful if the email address provided is subscribed to the list.  Otherwise,
test reports will be held until manually reviewed and approved.  

Subscribing an account to the cpan-testers list is as easy as sending a blank
email to cpan-testers-subscribe@perl.org and replying to the confirmation
email.

== Action Prompts

Several steps in the generation of a test report are optional.  Configuration
options control whether an action should be taken automatically or whether
CPAN::Reporter should prompt the user for the action to take.  The action
to take may be different for each report grade.

Valid actions, and their associated meaning, are as follows:

* {yes} -- automatic yes
* {no} -- automatic no
* {ask/no} or just {ask} -- ask each time, but default to no
* {ask/yes} -- ask each time, but default to yes

For "ask" prompts, the default will be used if return is pressed immediately at
the prompt or if the {PERL_MM_USE_DEFAULT} environment variable is set to a
true value.

Action prompt options take one or more space-separated "grade:action" pairs,
which are processed left to right.

 edit_report = fail:ask/yes pass:no
 
An action by itself is taken as a default to be used for any grade which does
not have a grade-specific action.  A default action may also be set by using
the word "default" in place of a grade.  

 edit_report = ask/no
 edit_report = default:ask/no
 
A grade by itself is taken to have the action "yes" for that grade.

 edit_report = default:no fail

Multiple grades may be specified together by separating them with a slash.

 edit_report = pass:no fail/na/unknown:ask/yes

The action prompt options are:

* {cc_author = <grade:action> ...} -- should module authors should be sent a copy of 
the test report at their {author@cpan.org} address? (default:yes pass:no)
* {edit_report = <grade:action> ...} -- edit the test report before sending? 
(default:ask/no pass:no)
* {send_report = <grade:action> ...} -- should test reports be sent at all?
(default:ask/yes pass:yes na:no)
* {send_duplicates = <grade:action> ...} -- should duplicates of previous 
reports be sent, regardless of {send_report}? (default:no)

These options are included in the starter config file created automatically the
first time CPAN::Reporter is configured interactively.

Note that if {send_report} is set to "no", CPAN::Reporter will still go through
the motions of preparing a report, but will discard it rather than send it.
This is the default for an "na" report -- users may still edit the report to 
see which prerequisites failed, but no report will be sent.

A better way to disable CPAN::Reporter temporarily is with the CPAN option
{test_report}:

 cpan> o conf test_report 0

== Mail Server

By default, Test::Reporter attempts to send mail directly to perl.org mail 
servers.  This may fail if a user's computer is behind a network firewall 
that blocks outbound email.  In this case, the following option should
be set to the outbound mail server (i.e., SMTP server) as provided by
the user's Internet service provider (ISP):

* {smtp_server = <server list>} -- one or more alternate outbound mail servers
if the default perl.org mail servers cannot be reached; multiple servers may be
given, separated with a space (none by default)

In at least one reported case, an ISP's outbound mail servers also refused 
to forward mail unless the {email_from} was from the ISP-given email address. 

This option is also included in the starter config file.

== Additional Options

These additional options are only necessary in special cases, such as for
testing, debugging or if a default editor cannot be found.

* {email_to = <email address>} -- alternate destination for reports instead of
{cpan-testers@perl.org}; used for testing
* {editor = <editor>} -- editor to use to edit the test report; if not set,
Test::Reporter will use environment variables {VISUAL}, {EDITOR} or {EDIT}
(in that order) to find an editor 
* {debug = <boolean>} -- turns debugging on/off

= FUNCTIONS

CPAN::Reporter provides only two public function for use within CPAN.pm.
They are not imported during {use}.  Ordinary users will never need them.

== {configure()}

 CPAN::Reporter::configure();

Prompts the user to edit configuration settings stored in the CPAN::Reporter
{config.ini} file.  It will create the configuration file if it does not exist.
It is automatically called by CPAN.pm when initializing the 'test_report'
option, e.g.:

 cpan> o conf init test_report

== {test()}

 CPAN::Reporter::test( $cpan_dist, $system_command );

Given a CPAN::Distribution object and a system command to run distribution
tests (e.g. "make test"), {test()} executes the command via {system()} while
teeing the output to a file.  Based on the output captured in the file,
{test()} generates and sends a [Test::Reporter] report.  It returns true if
the test grade is "pass" or "unknown" and returns false, otherwise.

= PRIVACY WARNING

CPAN::Reporter includes information in the test report about environment
variables and special Perl variables that could be affecting test results in
order to help module authors interpret the results of the tests.  This includes
information about paths, terminal, locale, user/group ID, installed toolchain
modules (e.g. ExtUtils::MakeMaker) and so on.  

These have been intentionally limited to items that should not cause harmful
personal information to be revealed -- it does ~not~ include your entire
environment.  Nevertheless, please do not use CPAN::Reporter if you are
concerned about the disclosure of this information as part of your test report.  

Users wishing to review this information may choose to edit the report 
prior to sending it.

= BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
[http://rt.cpan.org/Dist/Display.html?Queue=CPAN-Reporter]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= AUTHOR

David A. Golden (DAGOLDEN)

dagolden@cpan.org

http://www.dagolden.org/

= COPYRIGHT AND LICENSE

Copyright (c) 2006, 2007 by David A. Golden

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

= DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=end wikidoc

=cut
