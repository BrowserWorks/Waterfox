# NOTE: Derived from lib/Getopt/Long.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Getopt::Long;

#line 921 "lib/Getopt/Long.pm (autosplit into lib/auto/Getopt/Long/Configure.al)"
# Getopt::Long Configuration.
sub Configure (@) {
    my (@options) = @_;

    my $prevconfig =
      [ $error, $debug, $major_version, $minor_version,
	$autoabbrev, $getopt_compat, $ignorecase, $bundling, $order,
	$gnu_compat, $passthrough, $genprefix ];

    if ( ref($options[0]) eq 'ARRAY' ) {
	( $error, $debug, $major_version, $minor_version,
	  $autoabbrev, $getopt_compat, $ignorecase, $bundling, $order,
	  $gnu_compat, $passthrough, $genprefix ) = @{shift(@options)};
    }

    my $opt;
    foreach $opt ( @options ) {
	my $try = lc ($opt);
	my $action = 1;
	if ( $try =~ /^no_?(.*)$/s ) {
	    $action = 0;
	    $try = $+;
	}
	if ( ($try eq 'default' or $try eq 'defaults') && $action ) {
	    ConfigDefaults ();
	}
	elsif ( ($try eq 'posix_default' or $try eq 'posix_defaults') ) {
	    local $ENV{POSIXLY_CORRECT};
	    $ENV{POSIXLY_CORRECT} = 1 if $action;
	    ConfigDefaults ();
	}
	elsif ( $try eq 'auto_abbrev' or $try eq 'autoabbrev' ) {
	    $autoabbrev = $action;
	}
	elsif ( $try eq 'getopt_compat' ) {
	    $getopt_compat = $action;
	}
	elsif ( $try eq 'gnu_getopt' ) {
	    if ( $action ) {
		$gnu_compat = 1;
		$bundling = 1;
		$getopt_compat = 0;
		$permute = 1;
	    }
	}
	elsif ( $try eq 'gnu_compat' ) {
	    $gnu_compat = $action;
	}
	elsif ( $try eq 'ignorecase' or $try eq 'ignore_case' ) {
	    $ignorecase = $action;
	}
	elsif ( $try eq 'ignore_case_always' ) {
	    $ignorecase = $action ? 2 : 0;
	}
	elsif ( $try eq 'bundling' ) {
	    $bundling = $action;
	}
	elsif ( $try eq 'bundling_override' ) {
	    $bundling = $action ? 2 : 0;
	}
	elsif ( $try eq 'require_order' ) {
	    $order = $action ? $REQUIRE_ORDER : $PERMUTE;
	}
	elsif ( $try eq 'permute' ) {
	    $order = $action ? $PERMUTE : $REQUIRE_ORDER;
	}
	elsif ( $try eq 'pass_through' or $try eq 'passthrough' ) {
	    $passthrough = $action;
	}
	elsif ( $try =~ /^prefix=(.+)$/ && $action ) {
	    $genprefix = $1;
	    # Turn into regexp. Needs to be parenthesized!
	    $genprefix = "(" . quotemeta($genprefix) . ")";
	    eval { '' =~ /$genprefix/; };
	    Croak ("Getopt::Long: invalid pattern \"$genprefix\"") if $@;
	}
	elsif ( $try =~ /^prefix_pattern=(.+)$/ && $action ) {
	    $genprefix = $1;
	    # Parenthesize if needed.
	    $genprefix = "(" . $genprefix . ")"
	      unless $genprefix =~ /^\(.*\)$/;
	    eval { '' =~ /$genprefix/; };
	    Croak ("Getopt::Long: invalid pattern \"$genprefix\"") if $@;
	}
	elsif ( $try eq 'debug' ) {
	    $debug = $action;
	}
	else {
	    Croak ("Getopt::Long: unknown config parameter \"$opt\"")
	}
    }
    $prevconfig;
}

# end of Getopt::Long::Configure
1;
