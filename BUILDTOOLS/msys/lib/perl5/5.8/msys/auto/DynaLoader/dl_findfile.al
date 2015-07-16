# NOTE: Derived from ../../lib/DynaLoader.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package DynaLoader;

#line 269 "../../lib/DynaLoader.pm (autosplit into ../../lib/auto/DynaLoader/dl_findfile.al)"
sub dl_findfile {
    # Read ext/DynaLoader/DynaLoader.doc for detailed information.
    # This function does not automatically consider the architecture
    # or the perl library auto directories.
    my (@args) = @_;
    my (@dirs,  $dir);   # which directories to search
    my (@found);         # full paths to real files we have found
    my $dl_ext= 'dll'; # $Config::Config{'dlext'} suffix for perl extensions
    my $dl_so = 'dll'; # $Config::Config{'so'} suffix for shared libraries

    print STDERR "dl_findfile(@args)\n" if $dl_debug;

    # accumulate directories but process files as they appear
    arg: foreach(@args) {
        #  Special fast case: full filepath requires no search
        if ($Is_VMS && m%[:>/\]]% && -f $_) {
	    push(@found,dl_expandspec(VMS::Filespec::vmsify($_)));
	    last arg unless wantarray;
	    next;
        }
	elsif ($Is_MacOS) {
	    if (m/:/ && -f $_) {
	    	push(@found,$_);
	    	last arg unless wantarray;
	    }
	}
        elsif (m:/: && -f $_ && !$do_expand) {
	    push(@found,$_);
	    last arg unless wantarray;
	    next;
	}

        # Deal with directories first:
        #  Using a -L prefix is the preferred option (faster and more robust)
        if (m:^-L:) { s/^-L//; push(@dirs, $_); next; }

	if ($Is_MacOS) {
            #  Otherwise we try to try to spot directories by a heuristic
            #  (this is a more complicated issue than it first appears)
	    if (m/:/ && -d $_) {   push(@dirs, $_); next; }
            #  Only files should get this far...
            my(@names, $name);    # what filenames to look for
	    s/^-l//;
	    push(@names, $_);
            foreach $dir (@dirs, @dl_library_path) {
            	next unless -d $dir;
		$dir =~ s/^([^:]+)$/:$1/;
		$dir =~ s/:$//;
            	foreach $name (@names) {
	    	    my($file) = "$dir:$name";
                    print STDERR " checking in $dir for $name\n" if $dl_debug;
		    if (-f $file) {
                    	push(@found, $file);
                    	next arg; # no need to look any further
                    }
                }
	    }
	    next;
	}
	
        #  Otherwise we try to try to spot directories by a heuristic
        #  (this is a more complicated issue than it first appears)
        if (m:/: && -d $_) {   push(@dirs, $_); next; }

        # VMS: we may be using native VMS directory syntax instead of
        # Unix emulation, so check this as well
        if ($Is_VMS && /[:>\]]/ && -d $_) {   push(@dirs, $_); next; }

        #  Only files should get this far...
        my(@names, $name);    # what filenames to look for
        if (m:-l: ) {          # convert -lname to appropriate library name
            s/-l//;
            push(@names,"lib$_.$dl_so");
            push(@names,"lib$_.a");
        } else {                # Umm, a bare name. Try various alternatives:
            # these should be ordered with the most likely first
            push(@names,"$_.$dl_ext")    unless m/\.$dl_ext$/o;
            push(@names,"$_.$dl_so")     unless m/\.$dl_so$/o;
            push(@names,"lib$_.$dl_so")  unless m:/:;
            push(@names,"$_.a")          if !m/\.a$/ and $dlsrc eq "dl_dld.xs";
            push(@names, $_);
        }
        foreach $dir (@dirs, @dl_library_path) {
            next unless -d $dir;
            chop($dir = VMS::Filespec::unixpath($dir)) if $Is_VMS;
            foreach $name (@names) {
		my($file) = "$dir/$name";
                print STDERR " checking in $dir for $name\n" if $dl_debug;
		$file = ($do_expand) ? dl_expandspec($file) : (-f $file && $file);
		#$file = _check_file($file);
		if ($file) {
                    push(@found, $file);
                    next arg; # no need to look any further
                }
            }
        }
    }
    if ($dl_debug) {
        foreach(@dirs) {
            print STDERR " dl_findfile ignored non-existent directory: $_\n" unless -d $_;
        }
        print STDERR "dl_findfile found: @found\n";
    }
    return $found[0] unless wantarray;
    @found;
}

# end of DynaLoader::dl_findfile
1;
