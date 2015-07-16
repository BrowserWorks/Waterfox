# B::Bytecode.pm
# Copyright (c) 2003 Enache Adrian. All rights reserved.
# This module is free software; you can redistribute and/or modify
# it under the same terms as Perl itself.

# Based on the original Bytecode.pm module written by Malcolm Beattie.

package B::Bytecode;

our $VERSION = '1.01_01';

use strict;
use Config;
use B qw(class main_cv main_root main_start cstring comppadlist
	defstash curstash begin_av init_av end_av inc_gv warnhook diehook
	dowarn SVt_PVGV SVt_PVHV OPf_SPECIAL OPf_STACKED OPf_MOD
	OPpLVAL_INTRO SVf_FAKE SVf_READONLY);
use B::Asmdata qw(@specialsv_name);
use B::Assembler qw(asm newasm endasm);

#################################################

my ($varix, $opix, $savebegins, %walked, %files, @cloop);
my %strtab = (0,0);
my %svtab = (0,0);
my %optab = (0,0);
my %spectab = (0,0);
my $tix = 1;
sub asm;
sub nice ($) { }

BEGIN {
    my $ithreads = $Config{'useithreads'} eq 'define';
    eval qq{
	sub ITHREADS() { $ithreads }
	sub VERSION() { $] }
    }; die $@ if $@;
}

#################################################

sub pvstring {
    my $pv = shift;
    defined($pv) ? cstring ($pv."\0") : "\"\"";
}

sub pvix {
    my $str = pvstring shift;
    my $ix = $strtab{$str};
    defined($ix) ? $ix : do {
	asm "newpv", $str;
	asm "stpv", $strtab{$str} = $tix;
	$tix++;
    }
}

sub B::OP::ix {
    my $op = shift;
    my $ix = $optab{$$op};
    defined($ix) ? $ix : do {
	nice "[".$op->name." $tix]";
	asm "newopx", $op->size | $op->type <<7;
	$optab{$$op} = $opix = $ix = $tix++;
	$op->bsave($ix);
	$ix;
    }
}

sub B::SPECIAL::ix {
    my $spec = shift;
    my $ix = $spectab{$$spec};
    defined($ix) ? $ix : do {
	nice '['.$specialsv_name[$$spec].']';
	asm "ldspecsvx", $$spec;
	$spectab{$$spec} = $varix = $tix++;
    }
}

sub B::SV::ix {
    my $sv = shift;
    my $ix = $svtab{$$sv};
    defined($ix) ? $ix : do {
	nice '['.class($sv).']';
	asm "newsvx", $sv->FLAGS;
	$svtab{$$sv} = $varix = $ix = $tix++;
	$sv->bsave($ix);
	$ix;
    }
}

sub B::GV::ix {
    my ($gv,$desired) = @_;
    my $ix = $svtab{$$gv};
    defined($ix) ? $ix : do {
	if ($gv->GP) {
	    my ($svix, $avix, $hvix, $cvix, $ioix, $formix);
	    nice "[GV]";
	    my $name = $gv->STASH->NAME . "::" . $gv->NAME;
	    asm "gv_fetchpvx", cstring $name;
	    $svtab{$$gv} = $varix = $ix = $tix++;
	    asm "sv_flags", $gv->FLAGS;
	    asm "sv_refcnt", $gv->REFCNT;
	    asm "xgv_flags", $gv->GvFLAGS;

	    asm "gp_refcnt", $gv->GvREFCNT;
	    asm "load_glob", $ix if $name eq "CORE::GLOBAL::glob";
	    return $ix
		    unless $desired || desired $gv;
	    $svix = $gv->SV->ix;
	    $avix = $gv->AV->ix;
	    $hvix = $gv->HV->ix;

    # XXX {{{{
	    my $cv = $gv->CV;
	    $cvix = $$cv && defined $files{$cv->FILE} ? $cv->ix : 0;
	    my $form = $gv->FORM;
	    $formix = $$form && defined $files{$form->FILE} ? $form->ix : 0;

	    $ioix = $name !~ /STDOUT$/ ? $gv->IO->ix : 0;	
							    # }}}} XXX

	    nice "-GV-",
	    asm "ldsv", $varix = $ix unless $ix == $varix;
	    asm "gp_sv", $svix;
	    asm "gp_av", $avix;
	    asm "gp_hv", $hvix;
	    asm "gp_cv", $cvix;
	    asm "gp_io", $ioix;
	    asm "gp_cvgen", $gv->CVGEN;
	    asm "gp_form", $formix;
	    asm "gp_file", pvix $gv->FILE;
	    asm "gp_line", $gv->LINE;
	    asm "formfeed", $svix if $name eq "main::\cL";
	} else {
	    nice "[GV]";
	    asm "newsvx", $gv->FLAGS;
	    $svtab{$$gv} = $varix = $ix = $tix++;
	    my $stashix = $gv->STASH->ix;
	    $gv->B::PVMG::bsave($ix);
	    asm "xgv_flags", $gv->GvFLAGS;
	    asm "xgv_stash", $stashix;
	}
	$ix;
    }
}

sub B::HV::ix {
    my $hv = shift;
    my $ix = $svtab{$$hv};
    defined($ix) ? $ix : do {
	my ($ix,$i,@array);
	my $name = $hv->NAME;
	if ($name) {
	    nice "[STASH]";
	    asm "gv_stashpvx", cstring $name;
	    asm "sv_flags", $hv->FLAGS;
	    $svtab{$$hv} = $varix = $ix = $tix++;
	    asm "xhv_name", pvix $name;
	    # my $pmrootix = $hv->PMROOT->ix;	# XXX
	    asm "ldsv", $varix = $ix unless $ix == $varix;
	    # asm "xhv_pmroot", $pmrootix;	# XXX
	} else {
	    nice "[HV]";
	    asm "newsvx", $hv->FLAGS;
	    $svtab{$$hv} = $varix = $ix = $tix++;
	    my $stashix = $hv->SvSTASH->ix;
	    for (@array = $hv->ARRAY) {
		next if $i = not $i;
		$_ = $_->ix;
	    }
	    nice "-HV-",
	    asm "ldsv", $varix = $ix unless $ix == $varix;
	    ($i = not $i) ? asm ("newpv", pvstring $_) : asm("hv_store", $_)
		for @array;
	    if (VERSION < 5.009) {
		asm "xnv", $hv->NVX;
	    }
	    asm "xmg_stash", $stashix;
	    asm "xhv_riter", $hv->RITER;
	}
	asm "sv_refcnt", $hv->REFCNT;
	$ix;
    }
}

sub B::NULL::ix {
    my $sv = shift;
    $$sv ? $sv->B::SV::ix : 0;
}

sub B::NULL::opwalk { 0 }

#################################################

sub B::NULL::bsave {
    my ($sv,$ix) = @_;

    nice '-'.class($sv).'-',
    asm "ldsv", $varix = $ix unless $ix == $varix;
    asm "sv_refcnt", $sv->REFCNT;
}

sub B::SV::bsave;
    *B::SV::bsave = *B::NULL::bsave;

sub B::RV::bsave {
    my ($sv,$ix) = @_;
    my $rvix = $sv->RV->ix;
    $sv->B::NULL::bsave($ix);
    asm "xrv", $rvix;
}

sub B::PV::bsave {
    my ($sv,$ix) = @_;
    $sv->B::NULL::bsave($ix);
    asm "newpv", pvstring $sv->PVBM;
    asm "xpv";
}

sub B::IV::bsave {
    my ($sv,$ix) = @_;
    $sv->B::NULL::bsave($ix);
    asm "xiv", $sv->IVX;
}

sub B::NV::bsave {
    my ($sv,$ix) = @_;
    $sv->B::NULL::bsave($ix);
    asm "xnv", sprintf "%.40g", $sv->NVX;
}

sub B::PVIV::bsave {
    my ($sv,$ix) = @_;
    $sv->POK ?
	$sv->B::PV::bsave($ix):
    $sv->ROK ?
	$sv->B::RV::bsave($ix):
	$sv->B::NULL::bsave($ix);
    if (VERSION >= 5.009) {
	# See note below in B::PVNV::bsave
	return if $sv->isa('B::AV');
	return if $sv->isa('B::HV');
    }
    asm "xiv", !ITHREADS && $sv->FLAGS & (SVf_FAKE|SVf_READONLY) ?
	"0 but true" : $sv->IVX;
}

sub B::PVNV::bsave {
    my ($sv,$ix) = @_;
    $sv->B::PVIV::bsave($ix);
    if (VERSION >= 5.009) {
	# Magical AVs end up here, but AVs now don't have an NV slot actually
	# allocated. Hence don't write out assembly to store the NV slot if
	# we're actually an array.
	return if $sv->isa('B::AV');
	# Likewise HVs have no NV slot actually allocated.
	# I don't think that they can get here, but better safe than sorry
	return if $sv->isa('B::HV');
    }
    asm "xnv", sprintf "%.40g", $sv->NVX;
}

sub B::PVMG::domagic {
    my ($sv,$ix) = @_;
    nice '-MAGICAL-';
    my @mglist = $sv->MAGIC;
    my (@mgix, @namix);
    for (@mglist) {
	push @mgix, $_->OBJ->ix;
	push @namix, $_->PTR->ix if $_->LENGTH == B::HEf_SVKEY;
    }

    nice '-'.class($sv).'-',
    asm "ldsv", $varix = $ix unless $ix == $varix;
    for (@mglist) {
	asm "sv_magic", cstring $_->TYPE;
	asm "mg_obj", shift @mgix;
	my $length = $_->LENGTH;
	if ($length == B::HEf_SVKEY) {
	    asm "mg_namex", shift @namix;
	} elsif ($length) {
	    asm "newpv", pvstring $_->PTR;
	    asm "mg_name";
	}
    }
}

sub B::PVMG::bsave {
    my ($sv,$ix) = @_;
    my $stashix = $sv->SvSTASH->ix;
    $sv->B::PVNV::bsave($ix);
    asm "xmg_stash", $stashix;
    $sv->domagic($ix) if $sv->MAGICAL;
}

sub B::PVLV::bsave {
    my ($sv,$ix) = @_;
    my $targix = $sv->TARG->ix;
    $sv->B::PVMG::bsave($ix);
    asm "xlv_targ", $targix;
    asm "xlv_targoff", $sv->TARGOFF;
    asm "xlv_targlen", $sv->TARGLEN;
    asm "xlv_type", $sv->TYPE;

}

sub B::BM::bsave {
    my ($sv,$ix) = @_;
    $sv->B::PVMG::bsave($ix);
    asm "xpv_cur", $sv->CUR;
    asm "xbm_useful", $sv->USEFUL;
    asm "xbm_previous", $sv->PREVIOUS;
    asm "xbm_rare", $sv->RARE;
}

sub B::IO::bsave {
    my ($io,$ix) = @_;
    my $topix = $io->TOP_GV->ix;
    my $fmtix = $io->FMT_GV->ix;
    my $bottomix = $io->BOTTOM_GV->ix;
    $io->B::PVMG::bsave($ix);
    asm "xio_lines", $io->LINES;
    asm "xio_page", $io->PAGE;
    asm "xio_page_len", $io->PAGE_LEN;
    asm "xio_lines_left", $io->LINES_LEFT;
    asm "xio_top_name", pvix $io->TOP_NAME;
    asm "xio_top_gv", $topix;
    asm "xio_fmt_name", pvix $io->FMT_NAME;
    asm "xio_fmt_gv", $fmtix;
    asm "xio_bottom_name", pvix $io->BOTTOM_NAME;
    asm "xio_bottom_gv", $bottomix;
    asm "xio_subprocess", $io->SUBPROCESS;
    asm "xio_type", ord $io->IoTYPE;
    # asm "xio_flags", ord($io->IoFLAGS) & ~32;		# XXX XXX
}

sub B::CV::bsave {
    my ($cv,$ix) = @_;
    my $stashix = $cv->STASH->ix;
    my $gvix = $cv->GV->ix;
    my $padlistix = $cv->PADLIST->ix;
    my $outsideix = $cv->OUTSIDE->ix;
    my $constix = $cv->CONST ? $cv->XSUBANY->ix : 0;
    my $startix = $cv->START->opwalk;
    my $rootix = $cv->ROOT->ix;

    $cv->B::PVMG::bsave($ix);
    asm "xcv_stash", $stashix;
    asm "xcv_start", $startix;
    asm "xcv_root", $rootix;
    asm "xcv_xsubany", $constix;
    asm "xcv_gv", $gvix;
    asm "xcv_file", pvix $cv->FILE if $cv->FILE;	# XXX AD
    asm "xcv_padlist", $padlistix;
    asm "xcv_outside", $outsideix;
    asm "xcv_flags", $cv->CvFLAGS;
    asm "xcv_outside_seq", $cv->OUTSIDE_SEQ;
    asm "xcv_depth", $cv->DEPTH;
}

sub B::FM::bsave {
    my ($form,$ix) = @_;

    $form->B::CV::bsave($ix);
    asm "xfm_lines", $form->LINES;
}

sub B::AV::bsave {
    my ($av,$ix) = @_;
    return $av->B::PVMG::bsave($ix) if $av->MAGICAL;
    my @array = $av->ARRAY;
    $_ = $_->ix for @array;
    my $stashix = $av->SvSTASH->ix;

    nice "-AV-",
    asm "ldsv", $varix = $ix unless $ix == $varix;
    asm "av_extend", $av->MAX if $av->MAX >= 0;
    asm "av_pushx", $_ for @array;
    asm "sv_refcnt", $av->REFCNT;
    if (VERSION < 5.009) {
	asm "xav_flags", $av->AvFLAGS;
    }
    asm "xmg_stash", $stashix;
}

sub B::GV::desired {
    my $gv = shift;
    my ($cv, $form);
    $files{$gv->FILE} && $gv->LINE
    || ${$cv = $gv->CV} && $files{$cv->FILE}
    || ${$form = $gv->FORM} && $files{$form->FILE}
}

sub B::HV::bwalk {
    my $hv = shift;
    return if $walked{$$hv}++;
    my %stash = $hv->ARRAY;
    while (my($k,$v) = each %stash) {
	if ($v->SvTYPE == SVt_PVGV) {
	    my $hash = $v->HV;
	    if ($$hash && $hash->NAME) {
		$hash->bwalk;
	    } 
	    $v->ix(1) if desired $v;
	} else {
	    nice "[prototype]";
	    asm "gv_fetchpvx", cstring $hv->NAME . "::$k";
	    $svtab{$$v} = $varix = $tix;
	    $v->bsave($tix++);
	    asm "sv_flags", $v->FLAGS;
	}
    }
}

######################################################


sub B::OP::bsave_thin {
    my ($op, $ix) = @_;
    my $next = $op->next;
    my $nextix = $optab{$$next};
    $nextix = 0, push @cloop, $op unless defined $nextix;
    if ($ix != $opix) {
	nice '-'.$op->name.'-',
	asm "ldop", $opix = $ix;
    }
    asm "op_next", $nextix;
    asm "op_targ", $op->targ if $op->type;		# tricky
    asm "op_flags", $op->flags;
    asm "op_private", $op->private;
}

sub B::OP::bsave;
    *B::OP::bsave = *B::OP::bsave_thin;

sub B::UNOP::bsave {
    my ($op, $ix) = @_;
    my $name = $op->name;
    my $flags = $op->flags;
    my $first = $op->first;
    my $firstix = 
	$name =~ /fl[io]p/
			# that's just neat
    ||	(!ITHREADS && $name eq 'regcomp')
			# trick for /$a/o in pp_regcomp
    ||	$name eq 'rv2sv'
	    && $op->flags & OPf_MOD	
	    && $op->private & OPpLVAL_INTRO
			# change #18774 made my life hard
    ?	$first->ix
    :	0;

    $op->B::OP::bsave($ix);
    asm "op_first", $firstix;
}

sub B::BINOP::bsave {
    my ($op, $ix) = @_;
    if ($op->name eq 'aassign' && $op->private & B::OPpASSIGN_HASH()) {
	my $last = $op->last;
	my $lastix = do {
	    local *B::OP::bsave = *B::OP::bsave_fat;
	    local *B::UNOP::bsave = *B::UNOP::bsave_fat;
	    $last->ix;
	};
	asm "ldop", $lastix unless $lastix == $opix;
	asm "op_targ", $last->targ;
	$op->B::OP::bsave($ix);
	asm "op_last", $lastix;
    } else {
	$op->B::OP::bsave($ix);
    }
}

# not needed if no pseudohashes

*B::BINOP::bsave = *B::OP::bsave if VERSION >= 5.009;

# deal with sort / formline 

sub B::LISTOP::bsave {
    my ($op, $ix) = @_;
    my $name = $op->name;
    sub blocksort() { OPf_SPECIAL|OPf_STACKED }
    if ($name eq 'sort' && ($op->flags & blocksort) == blocksort) {
	my $first = $op->first;
	my $pushmark = $first->sibling;
	my $rvgv = $pushmark->first;
	my $leave = $rvgv->first;

	my $leaveix = $leave->ix;

	my $rvgvix = $rvgv->ix;
	asm "ldop", $rvgvix unless $rvgvix == $opix;
	asm "op_first", $leaveix;

	my $pushmarkix = $pushmark->ix;
	asm "ldop", $pushmarkix unless $pushmarkix == $opix;
	asm "op_first", $rvgvix;

	my $firstix = $first->ix;
	asm "ldop", $firstix unless $firstix == $opix;
	asm "op_sibling", $pushmarkix;

	$op->B::OP::bsave($ix);
	asm "op_first", $firstix;
    } elsif ($name eq 'formline') {
	$op->B::UNOP::bsave_fat($ix);
    } else {
	$op->B::OP::bsave($ix);
    }
}

# fat versions

sub B::OP::bsave_fat {
    my ($op, $ix) = @_;
    my $siblix = $op->sibling->ix;

    $op->B::OP::bsave_thin($ix);
    asm "op_sibling", $siblix;
    # asm "op_seq", -1;			XXX don't allocate OPs piece by piece
}

sub B::UNOP::bsave_fat {
    my ($op,$ix) = @_;
    my $firstix = $op->first->ix;

    $op->B::OP::bsave($ix);
    asm "op_first", $firstix;
}

sub B::BINOP::bsave_fat {
    my ($op,$ix) = @_;
    my $last = $op->last;
    my $lastix = $op->last->ix;
    if (VERSION < 5.009 && $op->name eq 'aassign' && $last->name eq 'null') {
	asm "ldop", $lastix unless $lastix == $opix;
	asm "op_targ", $last->targ;
    }

    $op->B::UNOP::bsave($ix);
    asm "op_last", $lastix;
}

sub B::LOGOP::bsave {
    my ($op,$ix) = @_;
    my $otherix = $op->other->ix;

    $op->B::UNOP::bsave($ix);
    asm "op_other", $otherix;
}

sub B::PMOP::bsave {
    my ($op,$ix) = @_;
    my ($rrop, $rrarg, $rstart);

    # my $pmnextix = $op->pmnext->ix;	# XXX

    if (ITHREADS) {
	if ($op->name eq 'subst') {
	    $rrop = "op_pmreplroot";
	    $rrarg = $op->pmreplroot->ix;
	    $rstart = $op->pmreplstart->ix;
	} elsif ($op->name eq 'pushre') {
	    $rrop = "op_pmreplrootpo";
	    $rrarg = $op->pmreplroot;
	}
	$op->B::BINOP::bsave($ix);
	asm "op_pmstashpv", pvix $op->pmstashpv;
    } else {
	$rrop = "op_pmreplrootgv";
	$rrarg = $op->pmreplroot->ix;
	$rstart = $op->pmreplstart->ix if $op->name eq 'subst';
	my $stashix = $op->pmstash->ix;
	$op->B::BINOP::bsave($ix);
	asm "op_pmstash", $stashix;
    }

    asm $rrop, $rrarg if $rrop;
    asm "op_pmreplstart", $rstart if $rstart;

    asm "op_pmflags", $op->pmflags;
    asm "op_pmpermflags", $op->pmpermflags;
    asm "op_pmdynflags", $op->pmdynflags;
    # asm "op_pmnext", $pmnextix;	# XXX
    asm "newpv", pvstring $op->precomp;
    asm "pregcomp";
}

sub B::SVOP::bsave {
    my ($op,$ix) = @_;
    my $svix = $op->sv->ix;

    $op->B::OP::bsave($ix);
    asm "op_sv", $svix;
}

sub B::PADOP::bsave {
    my ($op,$ix) = @_;

    $op->B::OP::bsave($ix);
    asm "op_padix", $op->padix;
}

sub B::PVOP::bsave {
    my ($op,$ix) = @_;
    $op->B::OP::bsave($ix);
    return unless my $pv = $op->pv;

    if ($op->name eq 'trans') {
        asm "op_pv_tr", join ',', length($pv)/2, unpack("s*", $pv);
    } else {
        asm "newpv", pvstring $pv;
        asm "op_pv";
    }
}

sub B::LOOP::bsave {
    my ($op,$ix) = @_;
    my $nextix = $op->nextop->ix;
    my $lastix = $op->lastop->ix;
    my $redoix = $op->redoop->ix;

    $op->B::BINOP::bsave($ix);
    asm "op_redoop", $redoix;
    asm "op_nextop", $nextix;
    asm "op_lastop", $lastix;
}

sub B::COP::bsave {
    my ($cop,$ix) = @_;
    my $warnix = $cop->warnings->ix;
    my $ioix = $cop->io->ix;
    if (ITHREADS) {
	$cop->B::OP::bsave($ix);
	asm "cop_stashpv", pvix $cop->stashpv;
	asm "cop_file", pvix $cop->file;
    } else {
    	my $stashix = $cop->stash->ix;
    	my $fileix = $cop->filegv->ix(1);
	$cop->B::OP::bsave($ix);
	asm "cop_stash", $stashix;
	asm "cop_filegv", $fileix;
    }
    asm "cop_label", pvix $cop->label if $cop->label;	# XXX AD
    asm "cop_seq", $cop->cop_seq;
    asm "cop_arybase", $cop->arybase;
    asm "cop_line", $cop->line;
    asm "cop_warnings", $warnix;
    asm "cop_io", $ioix;
}

sub B::OP::opwalk {
    my $op = shift;
    my $ix = $optab{$$op};
    defined($ix) ? $ix : do {
	my $ix;
	my @oplist = $op->oplist;
	push @cloop, undef;
	$ix = $_->ix while $_ = pop @oplist;
	while ($_ = pop @cloop) {
	    asm "ldop", $optab{$$_};
	    asm "op_next", $optab{${$_->next}};
	}
	$ix;
    }
}

#################################################

sub save_cq {
    my $av;
    if (($av=begin_av)->isa("B::AV")) {
	if ($savebegins) {
	    for ($av->ARRAY) {
		next unless $_->FILE eq $0;
		asm "push_begin", $_->ix;
	    }
	} else {
	    for ($av->ARRAY) {
		next unless $_->FILE eq $0;
		# XXX BEGIN { goto A while 1; A: }
		for (my $op = $_->START; $$op; $op = $op->next) {
		    next unless $op->name eq 'require' || 
			# this kludge needed for tests
			$op->name eq 'gv' && do {
			    my $gv = class($op) eq 'SVOP' ?
				$op->gv :
			    	(($_->PADLIST->ARRAY)[1]->ARRAY)[$op->padix];
			    $$gv && $gv->NAME =~ /use_ok|plan/
			};
		    asm "push_begin", $_->ix;
		    last;
		}
	    }
	}
    }
    if (($av=init_av)->isa("B::AV")) {
	for ($av->ARRAY) {
	    next unless $_->FILE eq $0;
	    asm "push_init", $_->ix;
	}
    }
    if (($av=end_av)->isa("B::AV")) {
	for ($av->ARRAY) {
	    next unless $_->FILE eq $0;
	    asm "push_end", $_->ix;
	}
    }
}

sub compile {
    my ($head, $scan, $T_inhinc, $keep_syn);
    my $cwd = '';
    $files{$0} = 1;
    sub keep_syn {
	$keep_syn = 1;
	*B::OP::bsave = *B::OP::bsave_fat;
	*B::UNOP::bsave = *B::UNOP::bsave_fat;
	*B::BINOP::bsave = *B::BINOP::bsave_fat;
	*B::LISTOP::bsave = *B::LISTOP::bsave_fat;
    }
    sub bwarn { print STDERR "Bytecode.pm: @_\n" }

    for (@_) {
	if (/^-S/) {
	    *newasm = *endasm = sub { };
	    *asm = sub { print "    @_\n" };
	    *nice = sub ($) { print "\n@_\n" };
	} elsif (/^-H/) {
	    require ByteLoader;
	    $head = "#! $^X\nuse ByteLoader $ByteLoader::VERSION;\n";
	} elsif (/^-k/) {
	    keep_syn;
	} elsif (/^-o(.*)$/) {
	    open STDOUT, ">$1" or die "open $1: $!";
	} elsif (/^-f(.*)$/) {
	    $files{$1} = 1;
	} elsif (/^-s(.*)$/) {
	    $scan = length($1) ? $1 : $0;
	} elsif (/^-b/) {
	    $savebegins = 1;
    # this is here for the testsuite
	} elsif (/^-TI/) {
	    $T_inhinc = 1;
	} elsif (/^-TF(.*)/) {
	    my $thatfile = $1;
	    *B::COP::file = sub { $thatfile };
	} else {
	    bwarn "Ignoring '$_' option";
	}
    }
    if ($scan) {
	my $f;
	if (open $f, $scan) {
	    while (<$f>) {
		/^#\s*line\s+\d+\s+("?)(.*)\1/ and $files{$2} = 1;
		/^#/ and next;
		if (/\bgoto\b\s*[^&]/ && !$keep_syn) {
		    bwarn "keeping the syntax tree: \"goto\" op found";
		    keep_syn;
		}
	    }
	} else {
	    bwarn "cannot rescan '$scan'";
	}
	close $f;
    }
    binmode STDOUT;
    return sub {
	print $head if $head;
	newasm sub { print @_ };

	defstash->bwalk;
	asm "main_start", main_start->opwalk;
	asm "main_root", main_root->ix;
	asm "main_cv", main_cv->ix;
	asm "curpad", (comppadlist->ARRAY)[1]->ix;

	asm "signal", cstring "__WARN__"		# XXX
	    if warnhook->ix;
	asm "incav", inc_gv->AV->ix if $T_inhinc;
	save_cq;
	asm "incav", inc_gv->AV->ix if $T_inhinc;
	asm "dowarn", dowarn;

	{
	    no strict 'refs';
	    nice "<DATA>";
	    my $dh = *{defstash->NAME."::DATA"};
	    unless (eof $dh) {
		local undef $/;
		asm "data", ord 'D';
		print <$dh>;
	    } else {
		asm "ret";
	    }
	}

	endasm;
    }
}

1;

=head1 NAME

B::Bytecode - Perl compiler's bytecode backend

=head1 SYNOPSIS

B<perl -MO=Bytecode>[B<,-H>][B<,-o>I<script.plc>] I<script.pl>

=head1 DESCRIPTION

Compiles a Perl script into a bytecode format that could be loaded
later by the ByteLoader module and executed as a regular Perl script.

=head1 EXAMPLE

    $ perl -MO=Bytecode,-H,-ohi -e 'print "hi!\n"'
    $ perl hi
    hi!

=head1 OPTIONS

=over 4

=item B<-b>

Save all the BEGIN blocks. Normally only BEGIN blocks that C<require>
other files (ex. C<use Foo;>) are saved.

=item B<-H>

prepend a C<use ByteLoader VERSION;> line to the produced bytecode.

=item B<-k>

keep the syntax tree - it is stripped by default.

=item B<-o>I<outfile>

put the bytecode in <outfile> instead of dumping it to STDOUT.

=item B<-s>

scan the script for C<# line ..> directives and for <goto LABEL>
expressions. When gotos are found keep the syntax tree.

=back

=head1 KNOWN BUGS

=over 4

=item *

C<BEGIN { goto A: while 1; A: }> won't even compile.

=item *

C<?...?> and C<reset> do not work as expected.

=item *

variables in C<(?{ ... })> constructs are not properly scoped.

=item *

scripts that use source filters will fail miserably. 

=back

=head1 NOTICE

There are also undocumented bugs and options.

THIS CODE IS HIGHLY EXPERIMENTAL. USE AT YOUR OWN RISK.

=head1 AUTHORS

Originally written by Malcolm Beattie <mbeattie@sable.ox.ac.uk> and
modified by Benjamin Stuhl <sho_pi@hotmail.com>.

Rewritten by Enache Adrian <enache@rdslink.ro>, 2003 a.d.

=cut
