#!/usr/bin/perl

eval 'exec /usr/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell

$VERSION = '0.71';

use strict;
use Config;
use Getopt::Std;
use Module::ScanDeps;
use ExtUtils::MakeMaker;
use subs qw( _name _modtree );

my %opts;
getopts('BVxce:', \%opts);

my (%map, %skip);
my $core    = $opts{B};
my $verbose = $opts{V};
my $eval    = $opts{e};

if ($eval) {
    require File::Temp;
    my ($fh, $filename) = File::Temp::tempfile( UNLINK => 1 );
    print $fh $eval, "\n" or die $!;
    close $fh;
    push @ARGV, $filename;
}

die "Usage: $0 [ -B ] [ -V ] [ -x | -c ] [ -e STRING | FILE ... ]\n" unless @ARGV;

my @files = @ARGV;
while (<>) {
    next unless /^package\s+([\w:]+)/;
    $skip{$1}++;
}

my $map = scan_deps(
    files   => \@files,
    recurse => 1,
    $opts{x} ? ( execute => 1 ) :
    $opts{c} ? ( compile => 1 ) : (),
    $opts{V} ? ( warn_missing => 1 ) : (),
);


my $len = 0;
my @todo;
my (%seen, %dist, %core, %bin);

foreach my $key (sort keys %$map) {
    my $mod  = $map->{$key};
    my $name = $mod->{name} = _name($key);

    print "# $key [$mod->{type}]\n" if $verbose;

    if ($mod->{type} eq 'shared') {
	$key =~ s!auto/!!;
	$key =~ s!/[^/]+$!!;
	$key =~ s!/!::!;
	$bin{$key}++;
    }

    next unless $mod->{type} eq 'module';

    next if $skip{$name};

    if ($mod->{file} eq "$Config::Config{privlib}/$key"
	or $mod->{file} eq "$Config::Config{archlib}/$key") {
	next unless $core;

	$core{$name}++;
    }
    elsif (my $dist = _modtree->{$name}) {
	$seen{$name} = $dist{$dist->package}++;
    }

    $len = length($name) if $len < length($name);
    $mod->{used_by} ||= [];

    push @todo, $mod;
}

$len += 2;

print "# Legend: [C]ore [X]ternal [S]ubmodule [?]NotOnCPAN\n" if $verbose;

foreach my $mod (sort {
    "@{$a->{used_by}}" cmp "@{$b->{used_by}}" or
    $a->{key} cmp $b->{key}
} @todo) {

    my $version = MM->parse_version($mod->{file});

    if (!$verbose) {
        printf "%-${len}s => '$version',", "'$mod->{name}'" if $version;
    } else {
        printf "%-${len}s => '0', # ", "'$mod->{name}'";
        my @base = map(_name($_), @{$mod->{used_by}});
        print $seen{$mod->{name}}	? 'S' : ' ';
        print $bin{$mod->{name}}	? 'X' : ' ';
        print $core{$mod->{name}}	? 'C' : ' ';
        print _modtree && !_modtree->{$mod->{name}} ? '?' : ' ';
        print " # ";
        print "@base" if @base;
    }
    print "\n";

}

warn "No modules found!\n" unless @todo;

sub _name {
    my $str = shift;
    $str =~ s!/!::!g;
    $str =~ s!.pm$!!i;
    $str =~ s!^auto::(.+)::.*!$1!;
    return $str;
}

my $modtree;
sub _modtree {
    $modtree ||= eval {
        require CPANPLUS::Backend;
        CPANPLUS::Backend->new->module_tree;
    } || {};
}


1;

__END__

=head1 NAME

scandeps.pl - Scan file prerequisites

=head1 SYNOPSIS

    % scandeps.pl *.pm		# Print PREREQ_PM section for *.pm
    % scandeps.pl -e 'STRING'	# Scan an one-liner
    % scandeps.pl -B *.pm	# Include core modules
    % scandeps.pl -V *.pm	# Show autoload/shared/data files

=head1 DESCRIPTION

F<scandeps.pl> is a simple-minded utility that prints out the
C<PREREQ_PM> section needed by modules.

If you have B<CPANPLUS> installed, modules that are part of an
earlier module's distribution with be denoted with C<S>; modules
without a distribution name on CPAN are marked with C<?>.

Also, if the C<-B> option is specified, module belongs to a perl
distribution on CPAN (and thus uninstallable by C<CPAN.pm> or
C<CPANPLUS.pm>) are marked with C<C>.

Finally, modules that has loadable shared object files (usually
needing a compiler to install) are marked with C<X>; with the
C<-V> flag, those files (and all other files found) will be listed
before the main output. Additionally, all module files that the
scanned code depends on but were not found (and thus not scanned
recursively) are listed. These may include genuinely missing
modules or false positives. That means, modules your code does
not depend on (on this particular platform) but that were picked
up by the heuristic anyway.

=head1 OPTIONS

=over 4

=item -e STRING

Scan I<STRING> as a string containing perl code.

=item -c

Compiles the code and inspects its C<%INC>, in addition to static scanning.

=item -x

Executes the code and inspects its C<%INC>, in addition to static scanning.

=item -B

Include core modules in the output and the recursive search list.

=item -V

Verbose mode: Output all files found during the process; 
show dependencies between modules and availability.

Additionally, warns of any missing dependencies. If you find missing
dependencies that aren't really dependencies, you have probably found
false positives.

=back

=head1 SEE ALSO

L<Module::ScanDeps>, L<CPANPLUS::Backend>, L<PAR>

=head1 ACKNOWLEDGMENTS

Simon Cozens, for suggesting this script to be written.

=head1 AUTHORS

Audrey Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2003, 2004, 2005, 2006 by Audrey Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
