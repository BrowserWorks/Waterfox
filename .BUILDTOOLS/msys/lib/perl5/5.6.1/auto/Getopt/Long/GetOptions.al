# NOTE: Derived from lib/Getopt/Long.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Getopt::Long;

#line 226 "lib/Getopt/Long.pm (autosplit into lib/auto/Getopt/Long/GetOptions.al)"
################ AutoLoading subroutines ################

# RCS Status      : $Id: GetoptLongAl.pl,v 2.30 2001-01-31 10:21:11+01 jv Exp $
# Author          : Johan Vromans
# Created On      : Fri Mar 27 11:50:30 1998
# Last Modified By: Johan Vromans
# Last Modified On: Tue Dec 26 18:01:16 2000
# Update Count    : 98
# Status          : Released

sub GetOptions {

    my @optionlist = @_;	# local copy of the option descriptions
    my $argend = '--';		# option list terminator
    my %opctl = ();		# table of arg.specs (long and abbrevs)
    my %bopctl = ();		# table of arg.specs (bundles)
    my $pkg = $caller || (caller)[0];	# current context
				# Needed if linkage is omitted.
    my %aliases= ();		# alias table
    my @ret = ();		# accum for non-options
    my %linkage;		# linkage
    my $userlinkage;		# user supplied HASH
    my $opt;			# current option
    my $genprefix = $genprefix;	# so we can call the same module many times
    my @opctl;			# the possible long option names

    $error = '';

    print STDERR ("GetOpt::Long $Getopt::Long::VERSION ",
		  "called from package \"$pkg\".",
		  "\n  ",
		  'GetOptionsAl $Revision: 2.30 $ ',
		  "\n  ",
		  "ARGV: (@ARGV)",
		  "\n  ",
		  "autoabbrev=$autoabbrev,".
		  "bundling=$bundling,",
		  "getopt_compat=$getopt_compat,",
		  "gnu_compat=$gnu_compat,",
		  "order=$order,",
		  "\n  ",
		  "ignorecase=$ignorecase,",
		  "passthrough=$passthrough,",
		  "genprefix=\"$genprefix\".",
		  "\n")
	if $debug;

    # Check for ref HASH as first argument.
    # First argument may be an object. It's OK to use this as long
    # as it is really a hash underneath.
    $userlinkage = undef;
    if ( ref($optionlist[0]) and
	 "$optionlist[0]" =~ /^(?:.*\=)?HASH\([^\(]*\)$/ ) {
	$userlinkage = shift (@optionlist);
	print STDERR ("=> user linkage: $userlinkage\n") if $debug;
    }

    # See if the first element of the optionlist contains option
    # starter characters.
    # Be careful not to interpret '<>' as option starters.
    if ( $optionlist[0] =~ /^\W+$/
	 && !($optionlist[0] eq '<>'
	      && @optionlist > 0
	      && ref($optionlist[1])) ) {
	$genprefix = shift (@optionlist);
	# Turn into regexp. Needs to be parenthesized!
	$genprefix =~ s/(\W)/\\$1/g;
	$genprefix = "([" . $genprefix . "])";
    }

    # Verify correctness of optionlist.
    %opctl = ();
    %bopctl = ();
    while ( @optionlist > 0 ) {
	my $opt = shift (@optionlist);

	# Strip leading prefix so people can specify "--foo=i" if they like.
	$opt = $+ if $opt =~ /^$genprefix+(.*)$/s;

	if ( $opt eq '<>' ) {
	    if ( (defined $userlinkage)
		&& !(@optionlist > 0 && ref($optionlist[0]))
		&& (exists $userlinkage->{$opt})
		&& ref($userlinkage->{$opt}) ) {
		unshift (@optionlist, $userlinkage->{$opt});
	    }
	    unless ( @optionlist > 0
		    && ref($optionlist[0]) && ref($optionlist[0]) eq 'CODE' ) {
		$error .= "Option spec <> requires a reference to a subroutine\n";
		next;
	    }
	    $linkage{'<>'} = shift (@optionlist);
	    next;
	}

	# Match option spec. Allow '?' as an alias only.
	if ( $opt !~ /^((\w+[-\w]*)(\|(\?|\w[-\w]*)?)*)?([!~+]|[=:][infse][@%]?)?$/ ) {
	    $error .= "Error in option spec: \"$opt\"\n";
	    next;
	}
	my ($o, $c, $a) = ($1, $5);
	$c = '' unless defined $c;

	# $linko keeps track of the primary name the user specified.
	# This name will be used for the internal or external linkage.
	# In other words, if the user specifies "FoO|BaR", it will
	# match any case combinations of 'foo' and 'bar', but if a global
	# variable needs to be set, it will be $opt_FoO in the exact case
	# as specified.
	my $linko;

	if ( ! defined $o ) {
	    # empty -> '-' option
	    $linko = $o = '';
	    $opctl{''} = $c;
	    $bopctl{''} = $c if $bundling;
	}
	else {
	    # Handle alias names
	    my @o =  split (/\|/, $o);
	    $linko = $o = $o[0];
	    # Force an alias if the option name is not locase.
	    $a = $o unless $o eq lc($o);
	    $o = lc ($o)
		if $ignorecase > 1
		    || ($ignorecase
			&& ($bundling ? length($o) > 1  : 1));

	    foreach ( @o ) {
		if ( $bundling && length($_) == 1 ) {
		    $_ = lc ($_) if $ignorecase > 1;
		    if ( $c eq '!' ) {
			$opctl{"no$_"} = $c;
			warn ("Ignoring '!' modifier for short option $_\n");
			$opctl{$_} = $bopctl{$_} = '';
		    }
		    else {
			$opctl{$_} = $bopctl{$_} = $c;
		    }
		}
		else {
		    $_ = lc ($_) if $ignorecase;
		    if ( $c eq '!' ) {
			$opctl{"no$_"} = $c;
			$opctl{$_} = ''
		    }
		    else {
			$opctl{$_} = $c;
		    }
		}
		if ( defined $a ) {
		    # Note alias.
		    $aliases{$_} = $a;
		}
		else {
		    # Set primary name.
		    $a = $_;
		}
	    }
	}

	# If no linkage is supplied in the @optionlist, copy it from
	# the userlinkage if available.
	if ( defined $userlinkage ) {
	    unless ( @optionlist > 0 && ref($optionlist[0]) ) {
		if ( exists $userlinkage->{$linko} &&
		     ref($userlinkage->{$linko}) ) {
		    print STDERR ("=> found userlinkage for \"$linko\": ",
				  "$userlinkage->{$linko}\n")
			if $debug;
		    unshift (@optionlist, $userlinkage->{$linko});
		}
		else {
		    # Do nothing. Being undefined will be handled later.
		    next;
		}
	    }
	}

	# Copy the linkage. If omitted, link to global variable.
	if ( @optionlist > 0 && ref($optionlist[0]) ) {
	    print STDERR ("=> link \"$linko\" to $optionlist[0]\n")
		if $debug;
	    if ( ref($optionlist[0]) =~ /^(SCALAR|CODE)$/ ) {
		$linkage{$linko} = shift (@optionlist);
	    }
	    elsif ( ref($optionlist[0]) =~ /^(ARRAY)$/ ) {
		$linkage{$linko} = shift (@optionlist);
		$opctl{$o} .= '@'
		  if $opctl{$o} ne '' and $opctl{$o} !~ /\@$/;
		$bopctl{$o} .= '@'
		  if $bundling and defined $bopctl{$o} and
		    $bopctl{$o} ne '' and $bopctl{$o} !~ /\@$/;
	    }
	    elsif ( ref($optionlist[0]) =~ /^(HASH)$/ ) {
		$linkage{$linko} = shift (@optionlist);
		$opctl{$o} .= '%'
		  if $opctl{$o} ne '' and $opctl{$o} !~ /\%$/;
		$bopctl{$o} .= '%'
		  if $bundling and defined $bopctl{$o} and
		    $bopctl{$o} ne '' and $bopctl{$o} !~ /\%$/;
	    }
	    else {
		$error .= "Invalid option linkage for \"$opt\"\n";
	    }
	}
	else {
	    # Link to global $opt_XXX variable.
	    # Make sure a valid perl identifier results.
	    my $ov = $linko;
	    $ov =~ s/\W/_/g;
	    if ( $c =~ /@/ ) {
		print STDERR ("=> link \"$linko\" to \@$pkg","::opt_$ov\n")
		    if $debug;
		eval ("\$linkage{\$linko} = \\\@".$pkg."::opt_$ov;");
	    }
	    elsif ( $c =~ /%/ ) {
		print STDERR ("=> link \"$linko\" to \%$pkg","::opt_$ov\n")
		    if $debug;
		eval ("\$linkage{\$linko} = \\\%".$pkg."::opt_$ov;");
	    }
	    else {
		print STDERR ("=> link \"$linko\" to \$$pkg","::opt_$ov\n")
		    if $debug;
		eval ("\$linkage{\$linko} = \\\$".$pkg."::opt_$ov;");
	    }
	}
    }

    # Bail out if errors found.
    die ($error) if $error;
    $error = 0;

    # Sort the possible long option names.
    @opctl = sort(keys (%opctl)) if $autoabbrev;

    # Show the options tables if debugging.
    if ( $debug ) {
	my ($arrow, $k, $v);
	$arrow = "=> ";
	while ( ($k,$v) = each(%opctl) ) {
	    print STDERR ($arrow, "\$opctl{\"$k\"} = \"$v\"\n");
	    $arrow = "   ";
	}
	$arrow = "=> ";
	while ( ($k,$v) = each(%bopctl) ) {
	    print STDERR ($arrow, "\$bopctl{\"$k\"} = \"$v\"\n");
	    $arrow = "   ";
	}
    }

    # Process argument list
    my $goon = 1;
    while ( $goon && @ARGV > 0 ) {

	#### Get next argument ####

	$opt = shift (@ARGV);
	print STDERR ("=> option \"", $opt, "\"\n") if $debug;

	#### Determine what we have ####

	# Double dash is option list terminator.
	if ( $opt eq $argend ) {
	    # Finish. Push back accumulated arguments and return.
	    unshift (@ARGV, @ret)
		if $order == $PERMUTE;
	    return ($error == 0);
	}

	my $tryopt = $opt;
	my $found;		# success status
	my $dsttype;		# destination type ('@' or '%')
	my $incr;		# destination increment
	my $key;		# key (if hash type)
	my $arg;		# option argument

	($found, $opt, $arg, $dsttype, $incr, $key) =
	  FindOption ($genprefix, $argend, $opt,
		      \%opctl, \%bopctl, \@opctl, \%aliases);

	if ( $found ) {

	    # FindOption undefines $opt in case of errors.
	    next unless defined $opt;

	    if ( defined $arg ) {
		if ( defined $aliases{$opt} ) {
		    print STDERR ("=> alias \"$opt\" -> \"$aliases{$opt}\"\n")
		      if $debug;
		    $opt = $aliases{$opt};
		}

		if ( defined $linkage{$opt} ) {
		    print STDERR ("=> ref(\$L{$opt}) -> ",
				  ref($linkage{$opt}), "\n") if $debug;

		    if ( ref($linkage{$opt}) eq 'SCALAR' ) {
			if ( $incr ) {
			    print STDERR ("=> \$\$L{$opt} += \"$arg\"\n")
			      if $debug;
			    if ( defined ${$linkage{$opt}} ) {
			        ${$linkage{$opt}} += $arg;
			    }
		            else {
			        ${$linkage{$opt}} = $arg;
			    }
			}
			else {
			    print STDERR ("=> \$\$L{$opt} = \"$arg\"\n")
			      if $debug;
			    ${$linkage{$opt}} = $arg;
		        }
		    }
		    elsif ( ref($linkage{$opt}) eq 'ARRAY' ) {
			print STDERR ("=> push(\@{\$L{$opt}, \"$arg\")\n")
			    if $debug;
			push (@{$linkage{$opt}}, $arg);
		    }
		    elsif ( ref($linkage{$opt}) eq 'HASH' ) {
			print STDERR ("=> \$\$L{$opt}->{$key} = \"$arg\"\n")
			    if $debug;
			$linkage{$opt}->{$key} = $arg;
		    }
		    elsif ( ref($linkage{$opt}) eq 'CODE' ) {
			print STDERR ("=> &L{$opt}(\"$opt\", \"$arg\")\n")
			    if $debug;
			local ($@);
			eval {
			    &{$linkage{$opt}}($opt, $arg);
			};
			print STDERR ("=> die($@)\n") if $debug && $@ ne '';
			if ( $@ =~ /^!/ ) {
			    if ( $@ =~ /^!FINISH\b/ ) {
				$goon = 0;
			    }
			}
			elsif ( $@ ne '' ) {
			    warn ($@);
			    $error++;
			}
		    }
		    else {
			print STDERR ("Invalid REF type \"", ref($linkage{$opt}),
				      "\" in linkage\n");
			Croak ("Getopt::Long -- internal error!\n");
		    }
		}
		# No entry in linkage means entry in userlinkage.
		elsif ( $dsttype eq '@' ) {
		    if ( defined $userlinkage->{$opt} ) {
			print STDERR ("=> push(\@{\$L{$opt}}, \"$arg\")\n")
			    if $debug;
			push (@{$userlinkage->{$opt}}, $arg);
		    }
		    else {
			print STDERR ("=>\$L{$opt} = [\"$arg\"]\n")
			    if $debug;
			$userlinkage->{$opt} = [$arg];
		    }
		}
		elsif ( $dsttype eq '%' ) {
		    if ( defined $userlinkage->{$opt} ) {
			print STDERR ("=> \$L{$opt}->{$key} = \"$arg\"\n")
			    if $debug;
			$userlinkage->{$opt}->{$key} = $arg;
		    }
		    else {
			print STDERR ("=>\$L{$opt} = {$key => \"$arg\"}\n")
			    if $debug;
			$userlinkage->{$opt} = {$key => $arg};
		    }
		}
		else {
		    if ( $incr ) {
			print STDERR ("=> \$L{$opt} += \"$arg\"\n")
			  if $debug;
			if ( defined $userlinkage->{$opt} ) {
			    $userlinkage->{$opt} += $arg;
			}
			else {
			    $userlinkage->{$opt} = $arg;
			}
		    }
		    else {
			print STDERR ("=>\$L{$opt} = \"$arg\"\n") if $debug;
			$userlinkage->{$opt} = $arg;
		    }
		}
	    }
	}

	# Not an option. Save it if we $PERMUTE and don't have a <>.
	elsif ( $order == $PERMUTE ) {
	    # Try non-options call-back.
	    my $cb;
	    if ( (defined ($cb = $linkage{'<>'})) ) {
		local ($@);
		eval {
		    &$cb ($tryopt);
		};
		print STDERR ("=> die($@)\n") if $debug && $@ ne '';
		if ( $@ =~ /^!/ ) {
		    if ( $@ =~ /^!FINISH\b/ ) {
			$goon = 0;
		    }
		}
		elsif ( $@ ne '' ) {
		    warn ($@);
		    $error++;
		}
	    }
	    else {
		print STDERR ("=> saving \"$tryopt\" ",
			      "(not an option, may permute)\n") if $debug;
		push (@ret, $tryopt);
	    }
	    next;
	}

	# ...otherwise, terminate.
	else {
	    # Push this one back and exit.
	    unshift (@ARGV, $tryopt);
	    return ($error == 0);
	}

    }

    # Finish.
    if ( $order == $PERMUTE ) {
	#  Push back accumulated arguments
	print STDERR ("=> restoring \"", join('" "', @ret), "\"\n")
	    if $debug && @ret > 0;
	unshift (@ARGV, @ret) if @ret > 0;
    }

    return ($error == 0);
}

# end of Getopt::Long::GetOptions
1;
