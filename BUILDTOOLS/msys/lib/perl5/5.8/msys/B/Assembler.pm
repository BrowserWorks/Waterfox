#      Assembler.pm
#
#      Copyright (c) 1996 Malcolm Beattie
#
#      You may distribute under the terms of either the GNU General Public
#      License or the Artistic License, as specified in the README file.

package B::Assembler;
use Exporter;
use B qw(ppname);
use B::Asmdata qw(%insn_data @insn_name);
use Config qw(%Config);
require ByteLoader;		# we just need its $VERSION

no warnings;			# XXX

@ISA = qw(Exporter);
@EXPORT_OK = qw(assemble_fh newasm endasm assemble asm);
$VERSION = 0.07;

use strict;
my %opnumber;
my ($i, $opname);
for ($i = 0; defined($opname = ppname($i)); $i++) {
    $opnumber{$opname} = $i;
}

my($linenum, $errors, $out); #	global state, set up by newasm

sub error {
    my $str = shift;
    warn "$linenum: $str\n";
    $errors++;
}

my $debug = 0;
sub debug { $debug = shift }

sub limcheck($$$$){
    my( $val, $lo, $hi, $loc ) = @_;
    if( $val < $lo || $hi < $val ){
        error "argument for $loc outside [$lo, $hi]: $val";
        $val = $hi;
    }
    return $val;
}

#
# First define all the data conversion subs to which Asmdata will refer
#

sub B::Asmdata::PUT_U8 {
    my $arg = shift;
    my $c = uncstring($arg);
    if (defined($c)) {
	if (length($c) != 1) {
	    error "argument for U8 is too long: $c";
	    $c = substr($c, 0, 1);
	}
    } else {
        $arg = limcheck( $arg, 0, 0xff, 'U8' );
	$c = chr($arg);
    }
    return $c;
}

sub B::Asmdata::PUT_U16 {
    my $arg = limcheck( $_[0], 0, 0xffff, 'U16' );
    pack("S", $arg);
}
sub B::Asmdata::PUT_U32 {
    my $arg = limcheck( $_[0], 0, 0xffffffff, 'U32' );
    pack("L", $arg);
}
sub B::Asmdata::PUT_I32 {
    my $arg = limcheck( $_[0], -0x80000000, 0x7fffffff, 'I32' );
    pack("l", $arg);
}
sub B::Asmdata::PUT_NV  { sprintf("%s\0", $_[0]) } # "%lf" looses precision and pack('d',...)
						   # may not even be portable between compilers
sub B::Asmdata::PUT_objindex { # could allow names here
    my $arg = limcheck( $_[0], 0, 0xffffffff, '*index' );
    pack("L", $arg);
} 
sub B::Asmdata::PUT_svindex { &B::Asmdata::PUT_objindex }
sub B::Asmdata::PUT_opindex { &B::Asmdata::PUT_objindex }
sub B::Asmdata::PUT_pvindex { &B::Asmdata::PUT_objindex }

sub B::Asmdata::PUT_strconst {
    my $arg = shift;
    my $str = uncstring($arg);
    if (!defined($str)) {
	error "bad string constant: $arg";
	$str = '';
    }
    if ($str =~ s/\0//g) {
	error "string constant argument contains NUL: $arg";
        $str = '';
    }
    return $str . "\0";
}

sub B::Asmdata::PUT_pvcontents {
    my $arg = shift;
    error "extraneous argument: $arg" if defined $arg;
    return "";
}
sub B::Asmdata::PUT_PV {
    my $arg = shift;
    my $str = uncstring($arg);
    if( ! defined($str) ){
        error "bad string argument: $arg";
        $str = '';
    }
    return pack("L", length($str)) . $str;
}
sub B::Asmdata::PUT_comment_t {
    my $arg = shift;
    $arg = uncstring($arg);
    error "bad string argument: $arg" unless defined($arg);
    if ($arg =~ s/\n//g) {
	error "comment argument contains linefeed: $arg";
    }
    return $arg . "\n";
}
sub B::Asmdata::PUT_double { sprintf("%s\0", $_[0]) } # see PUT_NV above
sub B::Asmdata::PUT_none {
    my $arg = shift;
    error "extraneous argument: $arg" if defined $arg;
    return "";
}
sub B::Asmdata::PUT_op_tr_array {
    my @ary = split /\s*,\s*/, shift;
    return pack "S*", @ary;
}

sub B::Asmdata::PUT_IV64 {
    return pack "Q", shift;
}

sub B::Asmdata::PUT_IV {
    $Config{ivsize} == 4 ? &B::Asmdata::PUT_I32 : &B::Asmdata::PUT_IV64;
}

sub B::Asmdata::PUT_PADOFFSET {
    $Config{ptrsize} == 8 ? &B::Asmdata::PUT_IV64 : &B::Asmdata::PUT_U32;
}

sub B::Asmdata::PUT_long {
    $Config{longsize} == 8 ? &B::Asmdata::PUT_IV64 : &B::Asmdata::PUT_U32;
}

my %unesc = (n => "\n", r => "\r", t => "\t", a => "\a",
	     b => "\b", f => "\f", v => "\013");

sub uncstring {
    my $s = shift;
    $s =~ s/^"// and $s =~ s/"$// or return undef;
    $s =~ s/\\(\d\d\d|.)/length($1) == 3 ? chr(oct($1)) : ($unesc{$1}||$1)/eg;
    return $s;
}

sub strip_comments {
    my $stmt = shift;
    # Comments only allowed in instructions which don't take string arguments
    # Treat string as a single line so .* eats \n characters.
    $stmt =~ s{
	^\s*	# Ignore leading whitespace
	(
	  [^"]*	# A double quote '"' indicates a string argument. If we
		# find a double quote, the match fails and we strip nothing.
	)
	\s*\#	# Any amount of whitespace plus the comment marker...
	.*$	# ...which carries on to end-of-string.
    }{$1}sx;	# Keep only the instruction and optional argument.
    return $stmt;
}

# create the ByteCode header: magic, archname, ByteLoader $VERSION, ivsize,
# 	ptrsize, byteorder
# nvtype is irrelevant (floats are stored as strings)
# byteorder is strconst not U32 because of varying size issues

sub gen_header {
    my $header = "";

    $header .= B::Asmdata::PUT_U32(0x43424c50);	# 'PLBC'
    $header .= B::Asmdata::PUT_strconst('"' . $Config{archname}. '"');
    $header .= B::Asmdata::PUT_strconst(qq["$ByteLoader::VERSION"]);
    $header .= B::Asmdata::PUT_U32($Config{ivsize});
    $header .= B::Asmdata::PUT_U32($Config{ptrsize});
    $header;
}

sub parse_statement {
    my $stmt = shift;
    my ($insn, $arg) = $stmt =~ m{
	^\s*	# allow (but ignore) leading whitespace
	(.*?)	# Instruction continues up until...
	(?:	# ...an optional whitespace+argument group
	    \s+		# first whitespace.
	    (.*)	# The argument is all the rest (newlines included).
	)?$	# anchor at end-of-line
    }sx;
    if (defined($arg)) {
	if ($arg =~ s/^0x(?=[0-9a-fA-F]+$)//) {
	    $arg = hex($arg);
	} elsif ($arg =~ s/^0(?=[0-7]+$)//) {
	    $arg = oct($arg);
	} elsif ($arg =~ /^pp_/) {
	    $arg =~ s/\s*$//; # strip trailing whitespace
	    my $opnum = $opnumber{$arg};
	    if (defined($opnum)) {
		$arg = $opnum;
	    } else {
		error qq(No such op type "$arg");
		$arg = 0;
	    }
	}
    }
    return ($insn, $arg);
}

sub assemble_insn {
    my ($insn, $arg) = @_;
    my $data = $insn_data{$insn};
    if (defined($data)) {
	my ($bytecode, $putsub) = @{$data}[0, 1];
	my $argcode = &$putsub($arg);
	return chr($bytecode).$argcode;
    } else {
	error qq(no such instruction "$insn");
	return "";
    }
}

sub assemble_fh {
    my ($fh, $out) = @_;
    my $line;
    my $asm = newasm($out);
    while ($line = <$fh>) {
	assemble($line);
    }
    endasm();
}

sub newasm {
    my($outsub) = @_;

    die "Invalid printing routine for B::Assembler\n" unless ref $outsub eq 'CODE';
    die <<EOD if ref $out;
Can't have multiple byteassembly sessions at once!
	(perhaps you forgot an endasm()?)
EOD

    $linenum = $errors = 0;
    $out = $outsub;

    $out->(gen_header());
}

sub endasm {
    if ($errors) {
	die "There were $errors assembly errors\n";
    }
    $linenum = $errors = $out = 0;
}

sub assemble {
    my($line) = @_;
    my ($insn, $arg);
    $linenum++;
    chomp $line;
    if ($debug) {
	my $quotedline = $line;
	$quotedline =~ s/\\/\\\\/g;
	$quotedline =~ s/"/\\"/g;
	$out->(assemble_insn("comment", qq("$quotedline")));
    }
    if( $line = strip_comments($line) ){
        ($insn, $arg) = parse_statement($line);
        $out->(assemble_insn($insn, $arg));
        if ($debug) {
	    $out->(assemble_insn("nop", undef));
        }
    }
}

### temporary workaround

sub asm {
    return if $_[0] =~ /\s*\W/;
    if (defined $_[1]) {
	return if $_[1] eq "0" and
	    $_[0] !~ /^(?:newsvx?|av_pushx?|av_extend|xav_flags)$/;
	return if $_[1] eq "1" and $_[0] =~ /^(?:sv_refcnt)$/;
    }
    assemble "@_";
}

1;

__END__

=head1 NAME

B::Assembler - Assemble Perl bytecode

=head1 SYNOPSIS

	use B::Assembler qw(newasm endasm assemble);
	newasm(\&printsub);	# sets up for assembly
	assemble($buf); 	# assembles one line
	endasm();		# closes down

	use B::Assembler qw(assemble_fh);
	assemble_fh($fh, \&printsub);	# assemble everything in $fh

=head1 DESCRIPTION

See F<ext/B/B/Assembler.pm>.

=head1 AUTHORS

Malcolm Beattie, C<mbeattie@sable.ox.ac.uk>
Per-statement interface by Benjamin Stuhl, C<sho_pi@hotmail.com>

=cut
