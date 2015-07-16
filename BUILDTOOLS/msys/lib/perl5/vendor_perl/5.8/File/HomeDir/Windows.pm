package File::HomeDir::Windows;

# Generalised implementation for the entire Windows family of operating
# systems.

use 5.005;
use strict;
use Carp       ();
use File::Spec ();

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.65';
}

# If prefork is available, set Win32::TieRegistry
# to be preloaded if needed.
eval "use prefork 'Win32::TieRegistry'";





#####################################################################
# Current User Methods

sub my_home {
	my $class = shift;

	# A lot of unix people and unix-derived tools rely on
	# the ability to overload HOME. We will support it too
	# so that they can replace raw HOME calls with File::HomeDir.
	if ( exists $ENV{HOME} and $ENV{HOME} ) {
		return $ENV{HOME};
	}

	# Do we have a user profile?
	if ( exists $ENV{USERPROFILE} and $ENV{USERPROFILE} ) {
		return $ENV{USERPROFILE};
	}

	# Some Windows use something like $ENV{HOME}
	if ( exists $ENV{HOMEDRIVE} and exists $ENV{HOMEPATH} and $ENV{HOMEDRIVE} and $ENV{HOMEPATH} ) {
		return File::Spec->catpath(
			$ENV{HOMEDRIVE}, $ENV{HOMEPATH}, '',
			);
	}

	return undef;
}

sub my_desktop {
	my $class = shift;

	# The most correct way to find the desktop
	SCOPE: {
		my $dir = $class->my_win32_folder('Desktop');
		return $dir if $dir and -d $dir;
	}

	# MSWindows sets WINDIR, MS WinNT sets USERPROFILE.
	foreach my $e ( 'USERPROFILE', 'WINDIR' ) {
		next unless $ENV{$e};
		my $desktop = File::Spec->catdir($ENV{$e}, 'Desktop');
		return $desktop if $desktop and -d $desktop;
	}

	# As a last resort, try some hard-wired values
	foreach my $fixed (
		# The reason there are both types of slash here is because
		# this set of paths has been kept from thethe original version
		# of File::HomeDir::Win32 (before it was rewritten).
		# I can only assume this is Cygwin-related stuff.
		"C:\\windows\\desktop",
		"C:\\win95\\desktop",
		"C:/win95/desktop",
		"C:/windows/desktop",
	) {
		return $fixed if -d $fixed;
	}

	return undef;
}

sub my_documents {
	my $class = shift;

	# The most correct way to find my documents
	SCOPE: {
		my $dir = $class->my_win32_folder('Personal');
		return $dir if $dir and -d $dir;
	}

	return undef;
}

sub my_data {
	my $class = shift;

	# The most correct way to find my documents
	SCOPE: {
		my $dir = $class->my_win32_folder('Local AppData');
		return $dir if $dir and -d $dir;
	}

	return undef;
}

sub my_music {
	my $class = shift;

	# The most correct way to find my music
	SCOPE: {
		my $dir = $class->my_win32_folder('My Music');
		return $dir if $dir and -d $dir;
	}

	return undef;
}

sub my_pictures {
	my $class = shift;

	# The most correct way to find my pictures
	SCOPE: {
		my $dir = $class->my_win32_folder('My Pictures');
		return $dir if $dir and -d $dir;
	}

	return undef;
}

sub my_videos {
	my $class = shift;

	# The most correct way to find my videos
	SCOPE: {
		my $dir = $class->my_win32_folder('My Video');
		return $dir if $dir and -d $dir;
	}

	return undef;
}

# The explorer shell holds all sorts of folder information.
# This method is specific to this platform
sub my_win32_folder {
	my $class = shift;

	# Find the shell's folder hash
	local $SIG{'__DIE__'} = '';
	require Win32::TieRegistry;
	my $folders = Win32::TieRegistry->new(
		'HKEY_CURRENT_USER/Software/Microsoft/Windows/CurrentVersion/Explorer/Shell Folders',
		{ Delimiter => '/' },
		) or return undef;

	# Find the specific folder
	my $folder = $folders->GetValue(shift);
	return $folder;
}

1;

=pod

=head1 NAME

File::HomeDir::Windows - find your home and other directories, on Windows

=head1 DESCRIPTION

This module provides Windows-specific implementations for determining
common user directories.  In normal usage this module will always be
used via L<File::HomeDir>.

=head1 SYNOPSIS

  use File::HomeDir;
  
  # Find directories for the current user (eg. using Windows XP Professional)
  $home    = File::HomeDir->my_home;        # C:\Documents and Settings\mylogin
  $desktop = File::HomeDir->my_desktop;     # C:\Documents and Settings\mylogin\Desktop
  $docs    = File::HomeDir->my_documents;   # C:\Documents and Settings\mylogin\My Documents
  $music   = File::HomeDir->my_music;       # C:\Documents and Settings\mylogin\My Documents\My Music
  $pics    = File::HomeDir->my_pictures;    # C:\Documents and Settings\mylogin\My Documents\My Pictures
  $videos  = File::HomeDir->my_videos;      # C:\Documents and Settings\mylogin\My Documents\My Video
  $data    = File::HomeDir->my_data;        # C:\Documents and Settings\mylogin\Local Settings\Application Data

=head1 TODO

=over 4

=item * Merge remaining edge case code in L<File::HomeDir::Win32>

=back
