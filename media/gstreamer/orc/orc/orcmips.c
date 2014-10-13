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

#define MIPS_IMMEDIATE_INSTRUCTION(opcode,rs,rt,immediate) \
    (((opcode) & 0x3f) << 26 \
     |((rs)-ORC_GP_REG_BASE) << 21 \
     |((rt)-ORC_GP_REG_BASE) << 16 \
     |((immediate) & 0xffff))

#define REGIMM 01
#define MIPS_IMMEDIATE_REGIMM_INSTRUCTION(operation,rs,immediate) \
    (REGIMM << 26 \
     |((rs)-ORC_GP_REG_BASE) << 21 \
     |((operation) & 0x1f) << 16 \
     |((immediate) & 0xffff))

#define MIPS_BINARY_INSTRUCTION(opcode,rs,rt,rd,sa,function) \
    (((opcode) & 0x3f) << 26 \
     | ((rs)-ORC_GP_REG_BASE) << 21 \
     | ((rt)-ORC_GP_REG_BASE) << 16 \
     | ((rd)-ORC_GP_REG_BASE) << 11 \
     | ((sa) & 0x1f) << 6 \
     | ((function) & 0x3f))

#define MIPS_SHLLQB_INSTRUCTION(opcode, source, dest, immediate) \
                 (037 << 26 /* SPECIAL3 */ \
                 | (immediate & 0xf) << 21 \
                 | (source - ORC_GP_REG_BASE) << 16 \
                 | (dest - ORC_GP_REG_BASE) << 11 \
                 | (opcode & 0x1f) << 6 \
                 | 023) /* SHLL.QB */

const char *
orc_mips_reg_name (int reg)
{
  static const char *regs[] = {
    "$0", "$at",
    "$v0", "$v1",
    "$a0", "$a1", "$a2", "$a3",
    "$t0", "$t1", "$t2", "$t3","$t4", "$t5", "$t6", "$t7",
    "$s0", "$s1", "$s2", "$s3","$s4", "$s5", "$s6", "$s7",
    "$t8", "$t9",
    "$k0", "$k1",
    "$gp", "$sp", "$fp", "$ra"
  };

  if (reg < ORC_GP_REG_BASE || reg >= ORC_GP_REG_BASE + 32)
    return "ERROR";

  return regs[reg-32];
}

void
orc_mips_emit (OrcCompiler *compiler, orc_uint32 insn)
{
  ORC_WRITE_UINT32_LE (compiler->codeptr, insn);
  compiler->codeptr+=4;
}

void
orc_mips_emit_label (OrcCompiler *compiler, unsigned int label)
{
  ORC_ASSERT (label < ORC_N_LABELS);
  ORC_ASM_CODE(compiler,".L%s%d:\n", compiler->program->name, label);
  compiler->labels[label] = compiler->codeptr;
}

void
orc_mips_add_fixup (OrcCompiler *compiler, int label, int type)
{
  ORC_ASSERT (compiler->n_fixups < ORC_N_FIXUPS);

  compiler->fixups[compiler->n_fixups].ptr = compiler->codeptr;
  compiler->fixups[compiler->n_fixups].label = label;
  compiler->fixups[compiler->n_fixups].type = type;
  compiler->n_fixups++;
}

void
orc_mips_do_fixups (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<compiler->n_fixups;i++){
    /* Type 0 of fixup is a branch label that could not be resolved at first
     * pass. We compute the offset, which should be the 16 least significant
     * bits of the instruction. */
    unsigned char *label = compiler->labels[compiler->fixups[i].label];
    unsigned char *ptr = compiler->fixups[i].ptr;
    orc_uint32 code;
    int offset;
    ORC_ASSERT (compiler->fixups[i].type == 0);
    offset = (label - (ptr + 4)) >> 2;
    code = ORC_READ_UINT32_LE (ptr);
    code |= offset & 0xffff;
    ORC_WRITE_UINT32_LE (ptr, code);
  }
}

void
orc_mips_emit_align (OrcCompiler *compiler, int align_shift)
{
  int diff;

  diff = (compiler->code - compiler->codeptr)&((1<<align_shift) - 1);
  while (diff) {
    orc_mips_emit_nop (compiler);
    diff-=4;
  }
}

void
orc_mips_emit_nop (OrcCompiler *compiler)
{
  ORC_ASM_CODE(compiler,"  nop\n");
  /* We emit "or $at, $at, $0" aka "move $at, $at" for nop, because that's what
   * gnu as does. */
  orc_mips_emit (compiler,
      MIPS_BINARY_INSTRUCTION(0,ORC_MIPS_AT, ORC_MIPS_ZERO, ORC_MIPS_AT,
                              0, 045));
}

void
orc_mips_emit_sw (OrcCompiler *compiler, OrcMipsRegister reg,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  sw      %s, %d(%s)\n",
                orc_mips_reg_name (reg),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(053, base, reg, offset));
}

void
orc_mips_emit_swr (OrcCompiler *compiler, OrcMipsRegister reg,
                   OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  swr     %s, %d(%s)\n",
                orc_mips_reg_name (reg),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(056, base, reg, offset));
}

void
orc_mips_emit_swl (OrcCompiler *compiler, OrcMipsRegister reg,
                   OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  swl     %s, %d(%s)\n",
                orc_mips_reg_name (reg),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(052, base, reg, offset));
}

void
orc_mips_emit_sh (OrcCompiler *compiler, OrcMipsRegister reg,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  sh      %s, %d(%s)\n",
                orc_mips_reg_name (reg),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(051, base, reg, offset));
}

void
orc_mips_emit_sb (OrcCompiler *compiler, OrcMipsRegister reg,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  sb      %s, %d(%s)\n",
                orc_mips_reg_name (reg),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(050, base, reg, offset));
}

void
orc_mips_emit_lw (OrcCompiler *compiler, OrcMipsRegister dest,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lw      %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(043, base, dest, offset));
}

void
orc_mips_emit_lwr (OrcCompiler *compiler, OrcMipsRegister dest,
                   OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lwr     %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(046, base, dest, offset));
}

void
orc_mips_emit_lwl (OrcCompiler *compiler, OrcMipsRegister dest,
                   OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lwl     %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(042, base, dest, offset));
}

void
orc_mips_emit_lh (OrcCompiler *compiler, OrcMipsRegister dest,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lh      %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(041, base, dest, offset));
}

void
orc_mips_emit_lb (OrcCompiler *compiler, OrcMipsRegister dest,
                  OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lb      %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(040, base, dest, offset));
}

void
orc_mips_emit_lbu (OrcCompiler *compiler, OrcMipsRegister dest,
                   OrcMipsRegister base, unsigned int offset)
{
  ORC_ASM_CODE (compiler, "  lbu     %s, %d(%s)\n",
                orc_mips_reg_name (dest),
                offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(044, base, dest, offset));
}

void
orc_mips_emit_jr (OrcCompiler *compiler, OrcMipsRegister address_reg)
{
  ORC_ASM_CODE (compiler, "  jr      %s\n", orc_mips_reg_name (address_reg));
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(0, address_reg, ORC_MIPS_ZERO, 010));
}

void
orc_mips_emit_conditional_branch (OrcCompiler *compiler,
                                  int condition,
                                  OrcMipsRegister rs,
                                  OrcMipsRegister rt,
                                  unsigned int label)
{
  int offset;
  char *opcode_name[] = { NULL, NULL, NULL, NULL,
    "beq ",
    "bne ",
    "blez",
    "bgtz"
  };
  switch (condition) {
  case ORC_MIPS_BEQ:
  case ORC_MIPS_BNE:
    ORC_ASM_CODE (compiler, "  %s    %s, %s, .L%s%d\n", opcode_name[condition],
                  orc_mips_reg_name (rs), orc_mips_reg_name (rt),
                  compiler->program->name, label);
    break;
  case ORC_MIPS_BLEZ:
  case ORC_MIPS_BGTZ:
    ORC_ASSERT (rt == ORC_MIPS_ZERO);
    ORC_ASM_CODE (compiler, "  %s    %s, .L%s%d\n", opcode_name[condition],
                  orc_mips_reg_name (rs),
                  compiler->program->name, label);
    break;
  default:
    ORC_PROGRAM_ERROR (compiler, "unknown branch type: 0x%x", condition);
  }
  if (compiler->labels[label]) {
    offset = (compiler->labels[label] - (compiler->codeptr+4)) >> 2;
  } else {
    orc_mips_add_fixup (compiler, label, 0);
    offset = 0;
  }
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(condition, rs, rt, offset));
}

void
orc_mips_emit_conditional_branch_with_offset (OrcCompiler *compiler,
                                              int condition,
                                              OrcMipsRegister rs,
                                              OrcMipsRegister rt,
                                              int offset)
{
  char *opcode_name[] = { NULL, NULL, NULL, NULL,
    "beq ",
    "bne ",
    "blez",
    "bgtz",
    "bltz",
    "bgez"
  };
  switch (condition) {
  case ORC_MIPS_BEQ:
  case ORC_MIPS_BNE:
    ORC_ASM_CODE (compiler, "  %s    %s, %s, %d\n", opcode_name[condition],
                  orc_mips_reg_name (rs), orc_mips_reg_name (rt), offset);
    break;
  case ORC_MIPS_BLEZ:
  case ORC_MIPS_BGTZ:
  case ORC_MIPS_BLTZ:
  case ORC_MIPS_BGEZ:
    ORC_ASSERT (rt == ORC_MIPS_ZERO);
    ORC_ASM_CODE (compiler, "  %s    %s, %d\n", opcode_name[condition],
                  orc_mips_reg_name (rs), offset);
    break;
  default:
    ORC_PROGRAM_ERROR (compiler, "unknown branch type: 0x%x", condition);
  }

  if (condition >= ORC_MIPS_BLTZ) /* bltz and further are encoded as REGIMM */
    orc_mips_emit (compiler,
                   MIPS_IMMEDIATE_REGIMM_INSTRUCTION(condition - ORC_MIPS_BLTZ,
                                                     rs, offset>>2));
  else
    orc_mips_emit (compiler,
                   MIPS_IMMEDIATE_INSTRUCTION(condition, rs, rt, offset>>2));

}

void
orc_mips_emit_addiu (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  addiu   %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(011, source, dest, value));
}

void
orc_mips_emit_addi (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  addi    %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(010, source, dest, value));
}

void
orc_mips_emit_add (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  add     %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, source1, source2, dest, 0, 040));
}

void
orc_mips_emit_addu (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  addu    %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, source1, source2, dest, 0, 041));
}

void
orc_mips_emit_addu_qb (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  addu.qb %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 0, 020));
}

void
orc_mips_emit_addu_ph (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  addu.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 010, 020));
}

void
orc_mips_emit_addq_s_ph (OrcCompiler *compiler,
                         OrcMipsRegister dest,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  addq_s.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 016, 020));
}

void
orc_mips_emit_adduh_r_qb (OrcCompiler *compiler,
                         OrcMipsRegister dest,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  adduh_r.qb %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                                   source1, source2, dest,
                                                   02, /* ADDUH_R */
                                                   030 /* ADDUH.QB */));
}

void
orc_mips_emit_ori (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  ori     %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(015, source, dest, value));
}

void
orc_mips_emit_or (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  or      %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, source1, source2, dest, 0, 045));
}

void
orc_mips_emit_and (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  and     %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, source1, source2, dest, 0, 044));
}

void orc_mips_emit_lui (OrcCompiler *compiler, OrcMipsRegister dest, int value)
{
  ORC_ASM_CODE (compiler, "  lui     %s,  %d\n",
                orc_mips_reg_name (dest), value);
  orc_mips_emit (compiler,
                 MIPS_IMMEDIATE_INSTRUCTION (017, /* LUI */
                                             ORC_MIPS_ZERO,
                                             dest,
                                             value & 0xffff));
}

void
orc_mips_emit_move (OrcCompiler *compiler,
                    OrcMipsRegister dest, OrcMipsRegister source)
{
  orc_mips_emit_add (compiler, dest, source, ORC_MIPS_ZERO);
}

void
orc_mips_emit_sub (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  sub     %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, source1, source2, dest, 0, 042));
}

void
orc_mips_emit_subu_qb (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister source1, OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  subu.qb %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 01, 020));
}

void
orc_mips_emit_subq_s_ph (OrcCompiler *compiler,
                         OrcMipsRegister dest,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  subq_s.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 017, 020));
}

void
orc_mips_emit_subq_ph (OrcCompiler *compiler,
                         OrcMipsRegister dest,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  subq.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 013, 020));
}

void
orc_mips_emit_subu_ph (OrcCompiler *compiler,
                       OrcMipsRegister dest,
                       OrcMipsRegister source1,
                       OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  subu.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(037, source1, source2, dest, 011, 020));
}

void
orc_mips_emit_srl (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  srl     %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, ORC_MIPS_ZERO, source, dest, value, 02));
}

void
orc_mips_emit_sll (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  sll     %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, ORC_MIPS_ZERO, source, dest, value, 0));
}

void
orc_mips_emit_sra (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  sra     %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(0, ORC_MIPS_ZERO, source, dest, value, 03));
}

void
orc_mips_emit_shll_ph (OrcCompiler *compiler,
                       OrcMipsRegister dest,
                       OrcMipsRegister source,
                       int value)
{
  ORC_ASM_CODE (compiler, "  shll.ph %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_SHLLQB_INSTRUCTION(010, source, dest, value));
}

void
orc_mips_emit_shra_ph (OrcCompiler *compiler,
                       OrcMipsRegister dest,
                       OrcMipsRegister source,
                       int value)
{
  ORC_ASM_CODE (compiler, "  shra.ph %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_SHLLQB_INSTRUCTION(011, source, dest, value));
}

void
orc_mips_emit_shrl_ph (OrcCompiler *compiler,
                       OrcMipsRegister dest,
                       OrcMipsRegister source,
                       int value)
{
  ORC_ASM_CODE (compiler, "  shrl.ph %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_SHLLQB_INSTRUCTION(031, source, dest, value));
}

void
orc_mips_emit_andi (OrcCompiler *compiler,
                     OrcMipsRegister dest, OrcMipsRegister source, int value)
{
  ORC_ASM_CODE (compiler, "  andi    %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), value);
  orc_mips_emit (compiler, MIPS_IMMEDIATE_INSTRUCTION(014, source, dest, value));
}


void
orc_mips_emit_prepend (OrcCompiler *compiler, OrcMipsRegister dest,
                       OrcMipsRegister source, int shift_amount)
{
  ORC_ASM_CODE (compiler, "  prepend %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), shift_amount);
  orc_mips_emit (compiler, (037 << 26
                            | (source-ORC_GP_REG_BASE) << 21
                            | (dest-ORC_GP_REG_BASE) << 16
                            | shift_amount << 11
                            | 01 << 6 /* prepend */
                            | 061 /* append */));
}

void
orc_mips_emit_append (OrcCompiler *compiler, OrcMipsRegister dest,
                       OrcMipsRegister source, int shift_amount)
{
  ORC_ASM_CODE (compiler, "  append  %s, %s, %d\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source), shift_amount);
  orc_mips_emit (compiler, (037 << 26
                            | (source-ORC_GP_REG_BASE) << 21
                            | (dest-ORC_GP_REG_BASE) << 16
                            | shift_amount << 11
                            | 0 << 6 /* append */
                            | 061 /* append */));
}

void
orc_mips_emit_mul (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source1,
                   OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  mul     %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler, MIPS_BINARY_INSTRUCTION(034, source1, source2, dest, 0, 02));
}

void
orc_mips_emit_mul_ph (OrcCompiler *compiler,
                      OrcMipsRegister dest,
                      OrcMipsRegister source1,
                      OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  mul.ph  %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 037 << 26 /* SPECIAL3 */
                 | (source1 - ORC_GP_REG_BASE) << 21
                 | (source2 - ORC_GP_REG_BASE) << 16
                 | (dest - ORC_GP_REG_BASE) << 11
                 | 014 << 6 /* MUL.PH */
                 | 030); /* ADDUH.QB */
}

void
orc_mips_emit_mtlo
(OrcCompiler *compiler, OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  mtlo    %s\n",
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 0 << 26 /* SPECIAL */
                 | (source - ORC_GP_REG_BASE) << 21
                 | 023); /* MTLO */
}

void
orc_mips_emit_extr_s_h (OrcCompiler *compiler,
                        OrcMipsRegister dest,
                        int accumulator,
                        int shift)
{
  ORC_ASM_CODE (compiler, "  extr_s.h %s, $ac%d, %d\n",
                orc_mips_reg_name (dest),
                accumulator,
                shift);
  orc_mips_emit (compiler,
                 037 << 26 /* SPECIAL3 */
                 | (shift & 0x1f) << 21
                 | (dest - ORC_GP_REG_BASE) << 16
                 | (accumulator & 0x3) << 11
                 | 016 << 6 /* EXTR_S.H */
                 | 070); /* EXTR.W */
}

void
orc_mips_emit_slt (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister src1,
                   OrcMipsRegister src2)
{
  ORC_ASM_CODE (compiler, "  slt     %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (src1),
                orc_mips_reg_name (src2));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION (0, /* SPECIAL */
                                          src1, src2, dest, 0,
                                          052)); /* SLT */
}

void
orc_mips_emit_movn (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister src,
                    OrcMipsRegister condition)
{
  ORC_ASM_CODE (compiler, "  movn    %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (src),
                orc_mips_reg_name (condition));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION (0, /* SPECIAL */
                                          src, condition, dest, 0,
                                          013)); /* MOVN */
}

void
orc_mips_emit_repl_ph (OrcCompiler *compiler, OrcMipsRegister dest, int value)
{
  ORC_ASM_CODE (compiler, "  repl.ph %s, %d\n",
                orc_mips_reg_name (dest),
                value);
  orc_mips_emit (compiler,
                 037 << 26 /* SPECIAL3 */
                 | (value & 0x3ff) << 16
                 | (dest - ORC_GP_REG_BASE) << 11
                 | 012 << 6 /* REPL.PH */
                 | 022); /* ABSQ_S.PH */
}

void
orc_mips_emit_replv_qb (OrcCompiler *compiler,
                        OrcMipsRegister dest,
                        OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  replv.qb %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         ORC_MIPS_ZERO, /* actually no reg here */
                                         source, dest,
                                         03, /* REPLV.QB */
                                         022 /* ABSQ_S.PH */));
}

void
orc_mips_emit_replv_ph (OrcCompiler *compiler,
                        OrcMipsRegister dest,
                        OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  replv.ph %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         ORC_MIPS_ZERO, /* actually no reg here */
                                         source, dest,
                                         013, /* REPLV.PH */
                                         022 /* ABSQ_S.PH */));
}

void
orc_mips_emit_preceu_ph_qbr (OrcCompiler *compiler,
                             OrcMipsRegister dest,
                             OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  preceu.ph.qbr %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         ORC_MIPS_ZERO, /* actually no reg here */
                                         source, dest,
                                         035, /* PRECEU.PH.QBR */
                                         022 /* ABSQ_S.PH */));
}

void
orc_mips_emit_precr_qb_ph (OrcCompiler *compiler,
                           OrcMipsRegister dest,
                           OrcMipsRegister source1,
                           OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  precr.qb.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         source1, source2, dest,
                                         015, /* PRECR.QB.PH */
                                         021 /* CMPU.EQ.QB */));
}

void
orc_mips_emit_precrq_qb_ph (OrcCompiler *compiler,
                           OrcMipsRegister dest,
                           OrcMipsRegister source1,
                           OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  precrq.qb.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         source1, source2, dest,
                                         014, /* PRECRS.QB.PH */
                                         021 /* CMPU.EQ.QB */));
}

void
orc_mips_emit_cmp_lt_ph (OrcCompiler *compiler,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  cmp.lt.ph %s, %s\n",
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 037 << 26 /* SPECIAL3 */
                 | (source1 - ORC_GP_REG_BASE) << 21
                 | (source2 - ORC_GP_REG_BASE) << 16
                 | 0 << 11
                 | 011 << 6 /* CMP.LT.PH */
                 | 021); /* CMPU.EQ.QB */
}

void
orc_mips_emit_pick_ph (OrcCompiler *compiler,
                       OrcMipsRegister dest,
                       OrcMipsRegister source1,
                       OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  pick.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 037 << 26 /* SPECIAL3 */
                 | (source1 - ORC_GP_REG_BASE) << 21
                 | (source2 - ORC_GP_REG_BASE) << 16
                 | (dest - ORC_GP_REG_BASE) << 11
                 | 013 << 6 /* PICK.PH */
                 | 021); /* CMPU.EQ.QB */
}

void
orc_mips_emit_packrl_ph (OrcCompiler *compiler,
                         OrcMipsRegister dest,
                         OrcMipsRegister source1,
                         OrcMipsRegister source2)
{
  ORC_ASM_CODE (compiler, "  packrl.ph %s, %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source1),
                orc_mips_reg_name (source2));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         source1, source2, dest,
                                         016, /* PACKRL.PH */
                                         021 /* CMPU.EQ.QB */));
}

void
orc_mips_emit_wsbh (OrcCompiler *compiler,
                    OrcMipsRegister dest,
                    OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  wsbh    %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         ORC_MIPS_ZERO, /* actually no reg here */
                                         source, dest,
                                         02, /* WSBH */
                                         040 /* BSHFL */));
}

void
orc_mips_emit_seh (OrcCompiler *compiler,
                   OrcMipsRegister dest,
                   OrcMipsRegister source)
{
  ORC_ASM_CODE (compiler, "  seh     %s, %s\n",
                orc_mips_reg_name (dest),
                orc_mips_reg_name (source));
  orc_mips_emit (compiler,
                 MIPS_BINARY_INSTRUCTION(037, /* SPECIAL3 */
                                         ORC_MIPS_ZERO, /* actually no reg here */
                                         source, dest,
                                         030, /* SEH */
                                         040 /* BSHFL */));

}

void
orc_mips_emit_pref (OrcCompiler *compiler,
                    int hint,
                    OrcMipsRegister base,
                    int offset)
{
  ORC_ASM_CODE (compiler, "  pref    %d, %d(%s)\n",
                hint, offset, orc_mips_reg_name (base));
  orc_mips_emit (compiler,
                 063 << 26 /* PREF */
                 | (base - ORC_GP_REG_BASE) << 21
                 | (hint & 0x1f) << 16
                 | (offset & 0xffff));

}
