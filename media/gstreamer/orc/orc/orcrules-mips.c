/*
  Copyright 2002 - 2009 David A. Schleef <ds@schleef.org>
  Copyright 2012 MIPS Technologies, Inc.

  Author: Guillaume Emont <guijemont@igalia.com>

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.

*/

#include <orc/orcmips.h>
#include <orc/orcdebug.h>
#include <stdlib.h>

#define ORC_SW_MAX 32767
#define ORC_SW_MIN (-1-ORC_SW_MAX)
#define ORC_SB_MAX 127
#define ORC_SB_MIN (-1-ORC_SB_MAX)
#define ORC_UB_MAX 255
#define ORC_UB_MIN 0

void
mips_rule_load (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = compiler->vars[insn->src_args[0]].ptr_register;
  int dest = compiler->vars[insn->dest_args[0]].alloc;
  /* such that 2^total_shift is the amount to load at a time */
  int total_shift = compiler->insn_shift + ORC_PTR_TO_INT (user);
  int is_aligned = compiler->vars[insn->src_args[0]].is_aligned;
  int offset;

  if (compiler->vars[insn->src_args[0]].vartype == ORC_VAR_TYPE_CONST) {
    ORC_PROGRAM_ERROR (compiler, "not implemented");
    return;
  }

  ORC_DEBUG ("insn_shift=%d", compiler->insn_shift);
  offset = compiler->unroll_index << total_shift;
  switch (total_shift) {
  case 0:
    orc_mips_emit_lbu (compiler, dest, src, offset);
    break;
  case 1:
    if (is_aligned) {
      orc_mips_emit_lh  (compiler, dest, src, offset);
    } else {
      orc_mips_emit_lbu (compiler, ORC_MIPS_T3, src, offset);
      orc_mips_emit_lbu (compiler, dest, src, offset+1);
      orc_mips_emit_append (compiler, dest, ORC_MIPS_T3, 8);
    }
    break;
  case 2:
    if (is_aligned) {
      orc_mips_emit_lw (compiler, dest, src, offset);
    } else {
      /* note: the code below is little endian specific */
      orc_mips_emit_lwr (compiler, dest, src, offset);
      orc_mips_emit_lwl (compiler, dest, src, offset+3);
    }
    break;
  default:
    ORC_PROGRAM_ERROR(compiler, "Don't know how to handle that shift");
  }
  compiler->vars[insn->src_args[0]].update_type = 2;
}

void
mips_rule_store (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = compiler->vars[insn->src_args[0]].alloc;
  int dest = compiler->vars[insn->dest_args[0]].ptr_register;
  int total_shift = compiler->insn_shift + ORC_PTR_TO_INT (user);
  int is_aligned = compiler->vars[insn->dest_args[0]].is_aligned;
  int offset;

  ORC_DEBUG ("insn_shift=%d", compiler->insn_shift);

  offset = compiler->unroll_index << total_shift;
  switch (total_shift) {
  case 0:
    orc_mips_emit_sb (compiler, src, dest, offset);
    break;
  case 1:
    if (is_aligned) {
      orc_mips_emit_sh (compiler, src, dest, offset);
    } else {
      /* Note: the code below is little endian specific */
      orc_mips_emit_sb (compiler, src, dest, offset);
      orc_mips_emit_srl (compiler, ORC_MIPS_T3, src, 8);
      orc_mips_emit_sb (compiler, ORC_MIPS_T3, dest, offset+1);
    }
    break;
  case 2:
    if (is_aligned) {
      orc_mips_emit_sw (compiler, src, dest, offset);
    } else {
      orc_mips_emit_swr (compiler, src, dest, offset);
      orc_mips_emit_swl (compiler, src, dest, offset+3);
    }
    break;
  default:
    ORC_PROGRAM_ERROR(compiler, "Don't know how to handle that shift");
  }
  compiler->vars[insn->dest_args[0]].update_type = 2;
}


void
mips_rule_addl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_addu (compiler, dest, src1, src2);
}

void
mips_rule_addw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_addu_ph (compiler, dest, src1, src2);
}

void
mips_rule_addb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_addu_qb (compiler, dest, src1, src2);

}

void
mips_rule_subb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_subu_qb (compiler, dest, src1, src2);

}

void
mips_rule_copyl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_move (compiler, dest, src);
}

void
mips_rule_copyw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_move (compiler, dest, src);
}

void
mips_rule_copyb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  if (dest != src)
    orc_mips_emit_move (compiler, dest, src);
}

void
mips_rule_mulswl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp0 = ORC_MIPS_T3;
  OrcMipsRegister tmp1 = ORC_MIPS_T4;

  orc_mips_emit_seh (compiler, tmp0, src1);
  orc_mips_emit_seh (compiler, tmp1, src2);
  orc_mips_emit_mul (compiler, dest, tmp0, tmp1);
}

void
mips_rule_mullw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_mul_ph (compiler, dest, src1, src2);
}


void
mips_rule_shrs (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  OrcVariable *src2 = compiler->vars + insn->src_args[1];
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  if (src2->vartype == ORC_VAR_TYPE_CONST) {
    orc_mips_emit_sra (compiler, dest, src1, src2->value.i);
  } else {
    ORC_COMPILER_ERROR(compiler, "rule only implemented for constants");
  }
}

void
mips_rule_convssslw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp0 = ORC_MIPS_T3;
  OrcMipsRegister tmp1 = ORC_MIPS_T4;

  if (dest != src)
    orc_mips_emit_move (compiler, dest, src);
  orc_mips_emit_ori (compiler, tmp0, ORC_MIPS_ZERO, ORC_SW_MAX);
  orc_mips_emit_slt (compiler, tmp1, tmp0, src);
  orc_mips_emit_movn (compiler, dest, tmp0, tmp1);
  orc_mips_emit_lui (compiler, tmp0, (ORC_SW_MIN >> 16) & 0xffff);
  orc_mips_emit_ori (compiler, tmp0, tmp0, ORC_SW_MIN & 0xffff);
  /* this still works if src == dest since in that case, its value is either
   * the original src or ORC_SW_MAX, which works as well here */
  orc_mips_emit_slt (compiler, tmp1, src, tmp0);
  orc_mips_emit_movn (compiler, dest, tmp0, tmp1);
}

void
mips_rule_convssswb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp = ORC_MIPS_T3;

  orc_mips_emit_repl_ph (compiler, tmp, ORC_SB_MAX);
  orc_mips_emit_cmp_lt_ph (compiler, tmp, src);
  orc_mips_emit_pick_ph (compiler, dest, tmp, src);
  orc_mips_emit_repl_ph (compiler, tmp, ORC_SB_MIN);
  orc_mips_emit_cmp_lt_ph (compiler, dest, tmp);
  orc_mips_emit_pick_ph (compiler, dest, tmp, dest);
  if (compiler->insn_shift > 0)
    orc_mips_emit_precr_qb_ph (compiler, dest, ORC_MIPS_ZERO, dest);
}

void
mips_rule_convsuswb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp = ORC_MIPS_T3;

  orc_mips_emit_repl_ph (compiler, tmp, ORC_UB_MAX);
  orc_mips_emit_cmp_lt_ph (compiler, tmp, src);
  orc_mips_emit_pick_ph (compiler, dest, tmp, src);
  orc_mips_emit_cmp_lt_ph (compiler, dest, ORC_MIPS_ZERO);
  orc_mips_emit_pick_ph (compiler, dest, ORC_MIPS_ZERO, dest);
  if (compiler->insn_shift > 0)
    orc_mips_emit_precr_qb_ph (compiler, dest, ORC_MIPS_ZERO, dest);
}


void
mips_rule_convsbw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  /* left shift 8 bits, then right shift signed 8 bits, so that the sign bit
   * gets replicated in the upper 8 bits */
  if (compiler->insn_shift > 0) {
    orc_mips_emit_preceu_ph_qbr (compiler, dest, src);
    orc_mips_emit_shll_ph (compiler, dest, dest, 8);
    orc_mips_emit_shra_ph (compiler, dest, dest, 8);
  } else {
    orc_mips_emit_shll_ph (compiler, dest, src, 8);
    orc_mips_emit_shra_ph (compiler, dest, dest, 8);
  }
}

void
mips_rule_mergewl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  if (src1 == src2) {
    orc_mips_emit_replv_ph (compiler, dest, src1);
  } else if (dest == src1) {
    orc_mips_emit_sll (compiler, dest, dest, 16);
    orc_mips_emit_prepend (compiler, dest, src2, 16);
  } else {
    if (dest != src2)
      orc_mips_emit_move (compiler, dest, src2);
    orc_mips_emit_append (compiler, dest, src1, 16);
  }
}

void
mips_rule_mergebw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp0 = ORC_MIPS_T3;
  OrcMipsRegister tmp1 = ORC_MIPS_T4;

  if (compiler->insn_shift > 0) {
    orc_mips_emit_preceu_ph_qbr (compiler, tmp0, src1);
    orc_mips_emit_preceu_ph_qbr (compiler, tmp1, src2);
    orc_mips_emit_shll_ph (compiler, tmp1, tmp1, 8);
    orc_mips_emit_or (compiler, dest, tmp0, tmp1);
  } else {
    orc_mips_emit_shll_ph (compiler, tmp0, src2, 8);
    orc_mips_emit_or (compiler, dest, tmp0, src1);
  }
}

void
mips_rule_addssw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_addq_s_ph (compiler, dest, src1, src2);
}

void
mips_rule_subssw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_subq_s_ph (compiler, dest, src1, src2);
}

void
mips_rule_shrsw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  OrcVariable *src2 = compiler->vars + insn->src_args[1];
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  if (src2->vartype == ORC_VAR_TYPE_CONST) {
    orc_mips_emit_shra_ph (compiler, dest, src1, src2->value.i);
  } else {
    ORC_COMPILER_ERROR(compiler, "rule only implemented for constants");
  }
}

void
mips_rule_shruw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  OrcVariable *src2 = compiler->vars + insn->src_args[1];
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  if (src2->vartype == ORC_VAR_TYPE_CONST) {
    orc_mips_emit_shrl_ph (compiler, dest, src1, src2->value.i);
  } else {
    ORC_COMPILER_ERROR(compiler, "rule only implemented for constants");
  }
}

void
mips_rule_loadupib (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  OrcMipsRegister tmp0 = ORC_MIPS_T3;
  OrcMipsRegister tmp1 = ORC_MIPS_T4;
  OrcMipsRegister tmp2 = ORC_MIPS_T5;
  int offset;

  if (src->vartype != ORC_VAR_TYPE_SRC) {
    ORC_PROGRAM_ERROR (compiler, "not implemented");
    return;
  }
  switch (compiler->insn_shift) {
  case 0:
    orc_mips_emit_andi (compiler, tmp0, src->ptr_offset, 1);
    /* We only do the first lb if offset is even */
    orc_mips_emit_conditional_branch_with_offset (compiler,
                                                  ORC_MIPS_BEQ,
                                                  tmp0,
                                                  ORC_MIPS_ZERO,
                                                  16);
    orc_mips_emit_lb (compiler, dest->alloc, src->ptr_register, 0);

    orc_mips_emit_lb (compiler, tmp0, src->ptr_register, 1);
    orc_mips_emit_adduh_r_qb (compiler, dest->alloc, dest->alloc, tmp0);
    /* In the case where there is no insn_shift, src->ptr_register needs to be
     * incremented only when ptr_offset is odd, _emit_loop() doesn't update it
     * in that case, and therefore we do it here */
    orc_mips_emit_addiu (compiler, src->ptr_register, src->ptr_register, 1);

    orc_mips_emit_addiu (compiler, src->ptr_offset, src->ptr_offset, 1);
    break;
  case 2:
    /*
       lb       tmp0, 0(src)      # a
       lb       tmp1, 1(src)      # b
       lb       dest, 2(src)    # c
       andi     tmp2, ptr_offset, 1 # i&1
       replv.qb tmp0, tmp0          # aaaa
       replv.qb tmp1, tmp1          # bbbb
       replv.qb dest, dest      # cccc
       packrl.ph tmp0, tmp1, tmp0     # bbaa
       move     tmp1, tmp0          # bbaa
       prepend   tmp1, dest, 8     # cbba
       packrl.ph dest, dest, tmp1 # ccbb
       # if tmp2
       # tmp0 <- dest
       movn     tmp0, dest, tmp2    # if tmp2 ccbb else bbaa

       adduh_r.qb dest, tmp0, tmp1  # (b,c)b(a,b)a | c(b,c)b(a,b)

     */
    offset = compiler->unroll_index << (compiler->insn_shift - 1);
    orc_mips_emit_lb (compiler, tmp0, src->ptr_register, offset);
    orc_mips_emit_lb (compiler, tmp1, src->ptr_register, offset + 1);
    orc_mips_emit_lb (compiler, dest->alloc, src->ptr_register, offset + 2);
    orc_mips_emit_andi (compiler, tmp2, src->ptr_offset, 1);
    orc_mips_emit_replv_qb (compiler, tmp0, tmp0);
    orc_mips_emit_replv_qb (compiler, tmp1, tmp1);
    orc_mips_emit_replv_qb (compiler, dest->alloc, dest->alloc);
    orc_mips_emit_packrl_ph (compiler, tmp0, tmp1, tmp0);
    orc_mips_emit_move (compiler, tmp1, tmp0);
    orc_mips_emit_prepend (compiler, tmp1, dest->alloc, 8);
    orc_mips_emit_packrl_ph (compiler, dest->alloc, dest->alloc, tmp1);
    orc_mips_emit_movn (compiler, tmp0, dest->alloc, tmp2);
    orc_mips_emit_adduh_r_qb (compiler, dest->alloc, tmp0, tmp1);
    /* FIXME: should we remove that as we only use ptr_offset for parity? */
    orc_mips_emit_addiu (compiler, src->ptr_offset, src->ptr_offset, 4);
    break;
  default:
    ORC_PROGRAM_ERROR (compiler, "unimplemented");
  }
  src->update_type = 1;
}

#if 0
void
mips_rule_loadupdb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  OrcMipsRegister tmp = ORC_MIPS_T3;
  int offset;

  if (src->vartype != ORC_VAR_TYPE_SRC) {
    ORC_PROGRAM_ERROR (compiler, "not implemented");
    return;
  }

  switch (compiler->insn_shift) {
  case 0:
    orc_mips_emit_andi (compiler, tmp, src->ptr_offset, 1);
    orc_mips_emit_conditional_branch_with_offset (compiler,
                                                  ORC_MIPS_BEQ,
                                                  tmp,
                                                  ORC_MIPS_ZERO,
                                                  8);
    /* this is always done: in branch delay slot*/
    orc_mips_emit_lb (compiler, dest->alloc, src->ptr_register, 0);
    /* In the case where there is no insn_shift, src->ptr_register needs to be
     * incremented only when ptr_offset is odd, _emit_loop() doesn't update it
     * in that case, and therefore we do it here */
    orc_mips_emit_addiu (compiler, src->ptr_register, src->ptr_register, 1);
    orc_mips_emit_append (compiler, dest->alloc, dest->alloc, 8);

    orc_mips_emit_addiu (compiler, src->ptr_offset, src->ptr_offset, 1);
    break;
  case 2:
    offset = compiler->unroll_index << (compiler->insn_shift - 1);
    orc_mips_emit_lb (compiler, tmp, src->ptr_register, offset + 0);
    orc_mips_emit_lb (compiler, dest->alloc, src->ptr_register, offset + 1);
    orc_mips_emit_replv_qb (compiler, tmp, tmp);
    orc_mips_emit_replv_qb (compiler, dest->alloc, dest->alloc);
    orc_mips_emit_packrl_ph (compiler, dest->alloc, dest->alloc, tmp);
    /* FIXME: should we remove that as we only use ptr_offset for parity? */
    orc_mips_emit_addiu (compiler, src->ptr_offset, src->ptr_offset, 4);
    break;
  default:
    ORC_PROGRAM_ERROR (compiler, "unimplemented");
  }
  src->update_type = 1;
}
#endif

void
mips_rule_loadp (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int size = ORC_PTR_TO_INT (user);

  if (src->vartype == ORC_VAR_TYPE_CONST) {
    if (size == 1 || size == 2) {
      orc_mips_emit_ori (compiler, dest->alloc, ORC_MIPS_ZERO, src->value.i);
      if (size == 1)
        orc_mips_emit_replv_qb (compiler, dest->alloc, dest->alloc);
      else if (size == 2)
        orc_mips_emit_replv_ph (compiler, dest->alloc, dest->alloc);
    } else if (size == 4) {
      orc_int16 high_bits;
      high_bits = ((src->value.i >> 16) & 0xffff);
      if (high_bits) {
        orc_mips_emit_lui (compiler, dest->alloc, high_bits);
        orc_mips_emit_ori (compiler, dest->alloc, dest->alloc, src->value.i & 0xffff);
      } else {
        orc_mips_emit_ori (compiler, dest->alloc, ORC_MIPS_ZERO, src->value.i & 0xffff);
      }
    } else {
      ORC_PROGRAM_ERROR(compiler,"unimplemented");
    }
  } else {
    if (size == 1) {
      orc_mips_emit_lb (compiler, dest->alloc, compiler->exec_reg,
                        ORC_MIPS_EXECUTOR_OFFSET_PARAMS(insn->src_args[0]));
      orc_mips_emit_replv_qb (compiler, dest->alloc, dest->alloc);
    } else if (size == 2) {
      orc_mips_emit_lh (compiler, dest->alloc, compiler->exec_reg,
                        ORC_MIPS_EXECUTOR_OFFSET_PARAMS(insn->src_args[0]));
      orc_mips_emit_replv_ph (compiler, dest->alloc, dest->alloc);
    } else if (size == 4) {
      orc_mips_emit_lw (compiler, dest->alloc, compiler->exec_reg,
                        ORC_MIPS_EXECUTOR_OFFSET_PARAMS(insn->src_args[0]));
    } else {
      ORC_PROGRAM_ERROR(compiler,"unimplemented");
    }
  }
}

void
mips_rule_swapl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_wsbh (compiler, dest, src);
  orc_mips_emit_packrl_ph (compiler, dest, dest, dest);
}

void
mips_rule_swapw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_wsbh (compiler, dest, src);
}

void
mips_rule_avgub (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_adduh_r_qb (compiler, dest, src1, src2);
}

void
mips_rule_convubw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  if (compiler->insn_shift == 1)
    orc_mips_emit_preceu_ph_qbr (compiler, dest, src);
}

void
mips_rule_subw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (compiler, insn, 0);
  int src2 = ORC_SRC_ARG (compiler, insn, 1);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_subq_ph (compiler, dest, src1, src2);
}

void
mips_rule_convwb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  if (compiler->insn_shift >0)
    orc_mips_emit_precr_qb_ph (compiler, dest, ORC_MIPS_ZERO, src);
}

void
mips_rule_select1wb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_precrq_qb_ph (compiler, dest, ORC_MIPS_ZERO, src);
}

void
mips_rule_select0lw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  /* no op */
}

void
mips_rule_select1lw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);

  orc_mips_emit_srl (compiler, dest, src, 16);
}

void
mips_rule_splatbw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest = ORC_DEST_ARG (compiler, insn, 0);
  OrcMipsRegister tmp = ORC_MIPS_T3;

  orc_mips_emit_preceu_ph_qbr (compiler, tmp, src);
  orc_mips_emit_shll_ph (compiler, dest, tmp, 8);
  orc_mips_emit_or (compiler, dest, dest, tmp);
}

void
mips_rule_splitlw (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest1 = ORC_DEST_ARG (compiler, insn, 0);
  int dest2 = ORC_DEST_ARG (compiler, insn, 1);

  orc_mips_emit_srl (compiler, dest1, src, 16);
  orc_mips_emit_andi (compiler, dest2, src, 0xffff);
}

void
mips_rule_splitwb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = ORC_SRC_ARG (compiler, insn, 0);
  int dest1 = ORC_DEST_ARG (compiler, insn, 0);
  int dest2 = ORC_DEST_ARG (compiler, insn, 1);

  orc_mips_emit_precrq_qb_ph (compiler, dest1, ORC_MIPS_ZERO, src);
  orc_mips_emit_precr_qb_ph (compiler, dest2, ORC_MIPS_ZERO, src);
}



void
orc_compiler_orc_mips_register_rules (OrcTarget *target)
{
  OrcRuleSet *rule_set;

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target, 0);

  orc_rule_register (rule_set, "loadl", mips_rule_load, (void *) 2);
  orc_rule_register (rule_set, "loadw", mips_rule_load, (void *) 1);
  orc_rule_register (rule_set, "loadb", mips_rule_load, (void *) 0);
  orc_rule_register (rule_set, "loadpl", mips_rule_loadp, (void *) 4);
  orc_rule_register (rule_set, "loadpw", mips_rule_loadp, (void *) 2);
  orc_rule_register (rule_set, "loadpb", mips_rule_loadp, (void *) 1);
  orc_rule_register (rule_set, "storel", mips_rule_store, (void *)2);
  orc_rule_register (rule_set, "storew", mips_rule_store, (void *)1);
  orc_rule_register (rule_set, "storeb", mips_rule_store, (void *)0);
  orc_rule_register (rule_set, "addl", mips_rule_addl, NULL);
  orc_rule_register (rule_set, "addw", mips_rule_addw, NULL);
  orc_rule_register (rule_set, "addb", mips_rule_addb, NULL);
  orc_rule_register (rule_set, "subb", mips_rule_subb, NULL);
  orc_rule_register (rule_set, "copyl", mips_rule_copyl, NULL);
  orc_rule_register (rule_set, "copyw", mips_rule_copyw, NULL);
  orc_rule_register (rule_set, "copyb", mips_rule_copyb, NULL);
  orc_rule_register (rule_set, "mulswl", mips_rule_mulswl, NULL);
  orc_rule_register (rule_set, "mullw", mips_rule_mullw, NULL);
  orc_rule_register (rule_set, "shrsl", mips_rule_shrs, NULL);
  orc_rule_register (rule_set, "convssslw", mips_rule_convssslw, NULL);
  orc_rule_register (rule_set, "convssswb", mips_rule_convssswb, NULL);
  orc_rule_register (rule_set, "convsuswb", mips_rule_convsuswb, NULL);
  orc_rule_register (rule_set, "convsbw", mips_rule_convsbw, NULL);
  orc_rule_register (rule_set, "convubw", mips_rule_convubw, NULL);
  orc_rule_register (rule_set, "convwb", mips_rule_convwb, NULL);
  orc_rule_register (rule_set, "select0wb", mips_rule_convwb, NULL);
  orc_rule_register (rule_set, "select1wb", mips_rule_select1wb, NULL);
  orc_rule_register (rule_set, "select0lw", mips_rule_select0lw, NULL);
  orc_rule_register (rule_set, "select1lw", mips_rule_select1lw, NULL);
  orc_rule_register (rule_set, "mergewl", mips_rule_mergewl, NULL);
  orc_rule_register (rule_set, "mergebw", mips_rule_mergebw, NULL);
  orc_rule_register (rule_set, "splatbw", mips_rule_splatbw, NULL);
  orc_rule_register (rule_set, "splitlw", mips_rule_splitlw, NULL);
  orc_rule_register (rule_set, "splitwb", mips_rule_splitwb, NULL);
  orc_rule_register (rule_set, "addssw", mips_rule_addssw, NULL);
  orc_rule_register (rule_set, "subssw", mips_rule_subssw, NULL);
  orc_rule_register (rule_set, "loadupib", mips_rule_loadupib, NULL);
  /* orc_rule_register (rule_set, "loadupdb", mips_rule_loadupdb, NULL); */
  orc_rule_register (rule_set, "shrsw", mips_rule_shrsw, NULL);
  orc_rule_register (rule_set, "shruw", mips_rule_shruw, NULL);
  orc_rule_register (rule_set, "swapl", mips_rule_swapl, NULL);
  orc_rule_register (rule_set, "swapw", mips_rule_swapw, NULL);
  orc_rule_register (rule_set, "avgub", mips_rule_avgub, NULL);
  orc_rule_register (rule_set, "subw", mips_rule_subw, NULL);
}
