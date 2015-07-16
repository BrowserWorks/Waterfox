package ExtUtils::Installed;

use 5.00503;
use strict;
use Carp qw();
use ExtUtils::Packlist;
use ExtUtils::MakeMaker;
use Config;
use File::Find;
use File::Basename;
use File::Spec;

my $Is_VMS = $^O eq 'VMS';
my $DOSISH = ($^O =~ /^(MSWin\d\d|os2|dos|mint)$/);

require VMS::Filespec if $Is_VMS;

use vars qw($VERSION);
$VERSION = '0.08';

sub _is_prefix {
    my ($self, $path, $prefix) = @_;
    return unless defined $prefix && defined $path;

    if( $Is_VMS ) {
        $prefix = VMS::Filespec::unixify($prefix);
        $path   = VMS::Filespec::unixify($path);
    }

    # Sloppy Unix path normalization.
    $prefix =~ s{/+}{/}g;
    $path   =~ s{/+}{/}g;

    return 1 if substr($path, 0, length($prefix)) eq $prefix;

    if ($DOSISH) {
        $path =~ s|\\|/|g;
        $prefix =~ s|\\|/|g;
        return 1 if $path =~ m{^\Q$prefix\E}i;
    }
    return(0);
}

sub _is_doc { 
    my ($self, $path) = @_;
    my $man1dir = $Config{man1direxp};
    my $man3dir = $Config{man3direxp};
    return(($man1dir && $self->_is_prefix($path, $man1dir))
           ||
           ($man3dir && $self->_is_prefix($path, $man3dir))
           ? 1 : 0)
}
 
sub _is_type {
    my ($self, $path, $type) = @_;
    return 1 if $type eq "all";

    return($self->_is_doc($path)) if $type eq "doc";

    if ($type eq "prog") {
        return($self->_is_prefix($path, $Config{prefix} || $Config{prefixexp})
               &&
               !($self->_is_doc($path))
               ? 1 : 0);
    }
    return(0);
}

sub _is_under {
    my ($self, $path, @under) = @_;
    $under[0] = "" if (! @under);
    foreach my $dir (@under) {
        return(1) if ($self->_is_prefix($path, $dir));
    }

    return(0);
}

sub new {
    my ($class) = @_;
    $class = ref($class) || $class;
    my $self = {};

    my $archlib = $Config{archlibexp};
    my $sitearch = $Config{sitearchexp};

    # File::Find does not know how to deal with VMS filepaths.
    if( $Is_VMS ) {
        $archlib  = VMS::Filespec::unixify($archlib);
        $sitearch = VMS::Filespec::unixify($sitearch);
    }

    if ($DOSISH) {
        $archlib =~ s|\\|/|g;
        $sitearch =~ s|\\|/|g;
    }

    # Read the core packlist
    $self->{Perl}{packlist} =
      ExtUtils::Packlist->new( File::Spec->catfile($archlib, '.packlist') );
    $self->{Perl}{version} = $Config{version};

    # Read the module packlists
    my $sub = sub {
        # Only process module .packlists
        return if $_ ne ".packlist" || $File::Find::dir eq $archlib;

        # Hack of the leading bits of the paths & convert to a module name
        my $module = $File::Find::name;

        $module =~ s!\Q$archlib\E/?auto/(.*)/.packlist!$1!s  or
        $module =~ s!\Q$sitearch\E/?auto/(.*)/.packlist!$1!s;
        my $modfile = "$module.pm";
        $module =~ s!/!::!g;

        # Find the top-level module file in @INC
        $self->{$module}{version} = '';
        foreach my $dir (@INC) {
            my $p = File::Spec->catfile($dir, $modfile);
            if (-r $p) {
                $module = _module_name($p, $module) if $Is_VMS;

                require ExtUtils::MM;
                $self->{$module}{version} = MM->parse_version($p);
                last;
            }
        }

        # Read the .packlist
        $self->{$module}{packlist} = 
          ExtUtils::Packlist->new($File::Find::name);
    };

    my(@dirs) = grep { -e } ($archlib, $sitearch);
    find($sub, @dirs) if @dirs;

    return(bless($self, $class));
}

# VMS's non-case preserving file-system means the package name can't
# be reconstructed from the filename.
sub _module_name {
    my($file, $orig_module) = @_;

    my $module = '';
    if (open PACKFH, $file) {
        while (<PACKFH>) {
            if (/package\s+(\S+)\s*;/) {
                my $pack = $1;
                # Make a sanity check, that lower case $module
                # is identical to lowercase $pack before
                # accepting it
                if (lc($pack) eq lc($orig_module)) {
                    $module = $pack;
                    last;
                }
            }
        }
        close PACKFH;
    }

    print STDERR "Couldn't figure out the package name for $file\n"
      unless $module;

    return $module;
}



sub modules {
    my ($self) = @_;

    # Bug/feature of sort in scalar context requires this.
    return wantarray ? sort keys %$self : keys %$self;
}

sub files {
    my ($self, $module, $type, @under) = @_;

    # Validate arguments
    Carp::croak("$module is not installed") if (! exists($self->{$module}));
    $type = "all" if (! defined($type));
    Carp::croak('type must be "all", "prog" or "doc"')
        if ($type ne "all" && $type ne "prog" && $type ne "doc");

    my (@files);
    foreach my $file (keys(%{$self->{$module}{packlist}})) {
        push(@files, $file)
          if ($self->_is_type($file, $type) && 
              $self->_is_under($file, @under));
    }
    return(@files);
}

sub directories {
    my ($self, $module, $type, @under) = @_;
    my (%dirs);
    foreach my $file ($self->files($module, $type, @under)) {
        $dirs{dirname($file)}++;
    }
    return sort keys %dirs;
}

sub directory_tree {
    my ($self, $module, $type, @under) = @_;
    my (%dirs);
    foreach my $dir ($self->directories($module, $type, @under)) {
        $dirs{$dir}++;
        my ($last) = ("");
        while ($last ne $dir) {
            $last = $dir;
            $dir = dirname($dir);
            last if !$self->_is_under($dir, @under);
            $dirs{$dir}++;
        }
    }
    return(sort(keys(%dirs)));
}

sub validate {
    my ($self, $module, $remove) = @_;
    Carp::croak("$module is not installed") if (! exists($self->{$module}));
    return($self->{$module}{packlist}->validate($remove));
}

sub packlist {
    my ($self, $module) = @_;
    Carp::croak("$module is not installed") if (! exists($self->{$module}));
    return($self->{$module}{packlist});
}

sub version {
    my ($self, $module) = @_;
    Carp::croak("$module is not installed") if (! exists($self->{$module}));
    return($self->{$module}{version});
}


1;

__END__

=head1 NAME

ExtUtils::Installed - Inventory management of installed modules

=head1 SYNOPSIS

   use ExtUtils::Installed;
   my ($inst) = ExtUtils::Installed->new();
   my (@modules) = $inst->modules();
   my (@missing) = $inst->validate("DBI");
   my $all_files = $inst->files("DBI");
   my $files_below_usr_local = $inst->files("DBI", "all", "/usr/local");
   my $all_dirs = $inst->directories("DBI");
   my $dirs_below_usr_local = $inst->directory_tree("DBI", "prog");
   my $packlist = $inst->packlist("DBI");

=head1 DESCRIPTION

ExtUtils::Installed  provides a standard way to find out what core and module
files have been installed.  It uses the information stored in .packlist files
created during installation to provide this information.  In addition it
provides facilities to classify the installed files and to extract directory
information from the .packlist files.

=head1 USAGE

The new() function searches for all the installed .packlists on the system, and
stores their contents. The .packlists can be queried with the functions
described below.

=head1 FUNCTIONS

=over 4

=item new()

This takes no parameters, and searches for all the installed .packlists on the
system.  The packlists are read using the ExtUtils::packlist module.

=item modules()

This returns a list of the names of all the installed modules.  The perl 'core'
is given the special name 'Perl'.

=item files()

This takes one mandatory parameter, the name of a module.  It returns a list of
all the filenames from the package.  To obtain a list of core perl files, use
the module name 'Perl'.  Additional parameters are allowed.  The first is one
of the strings "prog", "doc" or "all", to select either just program files,
just manual files or all files.  The remaining parameters are a list of
directories. The filenames returned will be restricted to those under the
specified directories.

=item directories()

This takes one mandatory parameter, the name of a module.  It returns a list of
all the directories from the package.  Additional parameters are allowed.  The
first is one of the strings "prog", "doc" or "all", to select either just
program directories, just manual directories or all directories.  The remaining
parameters are a list of directories. The directories returned will be
restricted to those under the specified directories.  This method returns only
the leaf directories that contain files from the specified module.

=item directory_tree()

This is identical in operation to directories(), except that it includes all the
intermediate directories back up to the specified directories.

=item validate()

This takes one mandatory parameter, the name of a module.  It checks that all
the files listed in the modules .packlist actually exist, and returns a list of
any missing files.  If an optional second argument which evaluates to true is
given any missing files will be removed from the .packlist

=item packlist()

This returns the ExtUtils::Packlist object for the specified module.

=item version()

This returns the version number for the specified module.

=back

=head1 EXAMPLE

See the example in L<ExtUtils::Packlist>.

=head1 AUTHOR

Alan Burlison <Alan.Burlison@uk.sun.com>

=cut
