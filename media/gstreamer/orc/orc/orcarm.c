
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcdebug.h>
#include <orc/orcprogram.h>
#include <orc/orcarm.h>
#include <orc/orcutils.h>

#ifdef HAVE_ARM
#if defined(__APPLE__)
#include  <libkern/OSCacheControl.h>
#endif
#endif

/**
 * SECTION:orcarm
 * @title: ARM
 * @short_description: code generation for ARM
 */

const char *
orc_arm_cond_name (OrcArmCond cond)
{
  static const char *cond_names[] = {
    "eq", "ne", "cs", "cc", "mi", "pl", "vs", "vc",
    "hi", "ls", "ge", "lt", "gt", "le", "", ""
  };
  if ((int)cond < 0 || (int)cond >= 16) {
    return "ERROR";
  }
  return cond_names[cond&0xf];
}

const char *
orc_arm_reg_name (int reg)
{
#if 0
  static const char *gp_regs[] = {
    "a1", "a2", "a3", "a4",
    "v1", "v2", "v3", "v4",
    "v5", "v6", "v7", "v8",
    "ip", "sp", "lr", "pc" };
#else
  static const char *gp_regs[] = {
    "r0", "r1", "r2", "r3",
    "r4", "r5", "r6", "r7",
    "r8", "r9", "r10", "r11",
    "ip", "sp", "lr", "pc" };
  /* "r12", "r13", "r14", "r15" }; */
#endif

  if (reg < ORC_GP_REG_BASE || reg >= ORC_GP_REG_BASE+16) {
    return "ERROR";
  }

  return gp_regs[reg&0xf];
}

void
orc_arm_emit (OrcCompiler *compiler, orc_uint32 insn)
{
  ORC_WRITE_UINT32_LE (compiler->codeptr, insn);
  compiler->codeptr+=4;
}

void
orc_arm_emit_bx_lr (OrcCompiler *compiler)
{
  ORC_ASM_CODE(compiler,"  bx lr\n");
  orc_arm_emit (compiler, 0xe12fff1e);
}

void
orc_arm_emit_push (OrcCompiler *compiler, int regs)
{
  int i;
  int x = 0;

  ORC_ASM_CODE(compiler,"  push {");
  for(i=0;i<16;i++){
    if (regs & (1<<i)) {
      x |= (1<<i);
      ORC_ASM_CODE(compiler,"r%d", i);
      if (x != regs) {
        ORC_ASM_CODE(compiler,", ");
      }
    }
  }
  ORC_ASM_CODE(compiler,"}\n");

  orc_arm_emit (compiler, 0xe92d0000 | regs);
}

void
orc_arm_emit_pop (OrcCompiler *compiler, int regs)
{
  int i;
  int x = 0;

  ORC_ASM_CODE(compiler,"  pop {");
  for(i=0;i<16;i++){
    if (regs & (1<<i)) {
      x |= (1<<i);
      ORC_ASM_CODE(compiler,"r%d", i);
      if (x != regs) {
        ORC_ASM_CODE(compiler,", ");
      }
    }
  }
  ORC_ASM_CODE(compiler,"}\n");

  orc_arm_emit (compiler, 0xe8bd0000 | regs);
}

void
orc_arm_emit_label (OrcCompiler *compiler, int label)
{
  ORC_ASSERT (label < ORC_N_LABELS);

  ORC_ASM_CODE(compiler,".L%d:\n", label);

  compiler->labels[label] = compiler->codeptr;
}

void
orc_arm_add_fixup (OrcCompiler *compiler, int label, int type)
{
  ORC_ASSERT (compiler->n_fixups < ORC_N_FIXUPS);

  compiler->fixups[compiler->n_fixups].ptr = compiler->codeptr;
  compiler->fixups[compiler->n_fixups].label = label;
  compiler->fixups[compiler->n_fixups].type = type;
  compiler->n_fixups++;
}

void
orc_arm_do_fixups (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<compiler->n_fixups;i++){
    unsigned char *label = compiler->labels[compiler->fixups[i].label];
    unsigned char *ptr = compiler->fixups[i].ptr;
    orc_uint32 code;
    int diff;

    if (compiler->fixups[i].type == 0) {
      code = ORC_READ_UINT32_LE (ptr);
      diff = code;
      diff = (diff << 8) >> 8;
      diff += ((label - ptr) >> 2);
      if (diff != (diff << 8)>>8) {
        ORC_COMPILER_ERROR(compiler, "fixup out of range");
      }
      ORC_WRITE_UINT32_LE(ptr, (code&0xff000000) | (diff&0x00ffffff));
    } else {
      code = ORC_READ_UINT32_LE (ptr);
      diff = code;
      /* We store the offset in the code as signed, but the CPU considers
       * it unsigned */
      diff = (diff << 24) >> 24;
      diff += ((label - ptr) >> 2);
      if (diff != (diff & 0xff)) {
        ORC_COMPILER_ERROR(compiler, "fixup out of range (%d > 255)", diff);
      }
      ORC_WRITE_UINT32_LE(ptr, (code&0xffffff00) | (diff&0x000000ff));
    }
  }
}

void
orc_arm_emit_align (OrcCompiler *compiler, int align_shift)
{
  int diff;

  diff = (compiler->code - compiler->codeptr)&((1<<align_shift) - 1);
  while (diff) {
    orc_arm_emit_nop (compiler);
    diff-=4;
  }
}

void
orc_arm_emit_nop (OrcCompiler *compiler)
{
  ORC_ASM_CODE(compiler,"  nop\n");
  orc_arm_emit (compiler, 0xe1a00000);
}

void
orc_arm_emit_branch (OrcCompiler *compiler, int cond, int label)
{
  orc_uint32 code;

  code = 0x0afffffe;
  code |= (cond&0xf) << 28;
  orc_arm_add_fixup (compiler, label, 0);
  orc_arm_emit (compiler, code);

  ORC_ASM_CODE(compiler,"  b%s .L%d\n", orc_arm_cond_name(cond), label);
}

void
orc_arm_emit_load_imm (OrcCompiler *compiler, int dest, int imm)
{
  orc_uint32 code;
  int shift2;
  unsigned int x;

  if ((imm & 0xff) == imm) {
    shift2 = 0;
    x = imm;
  } else {
    shift2 = 0;
    x = imm & 0xffffffff;
    while ((x & 3) == 0) {
      x >>= 2;
      shift2++;
    }
    if (x > 0xff) {
      ORC_PROGRAM_ERROR(compiler, "bad immediate value");
    }
  }

  code = 0xe3a00000;
  code |= (dest&0xf) << 12;
  code |= (((16-shift2)&0xf) << 8);
  code |= (x&0xff);

  ORC_ASM_CODE(compiler,"  mov %s, #0x%08x\n", orc_arm_reg_name (dest), imm);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_add_imm (OrcCompiler *compiler, int dest, int src1, int imm)
{
  orc_uint32 code;
  int shift2;
  unsigned int x;

  if ((imm & 0xff) == imm) {
    shift2 = 0;
    x = imm;
  } else {
    shift2 = 0;
    x = imm & 0xffffffff;
    while ((x & 3) == 0) {
      x >>= 2;
      shift2++;
    }
    if (x > 0xff) {
      ORC_PROGRAM_ERROR(compiler, "bad immediate value");
    }
  }

  code = 0xe2800000;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (((16-shift2)&0xf) << 8);
  code |= (x&0xff);

  ORC_ASM_CODE(compiler,"  add %s, %s, #0x%08x\n", orc_arm_reg_name (dest),
      orc_arm_reg_name(src1), imm);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_and_imm (OrcCompiler *compiler, int dest, int src1, int value)
{
  orc_uint32 code;

  code = 0xe2000000;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (value) << 0;

  ORC_ASM_CODE(compiler,"  and %s, %s, #%d\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1),
      value);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_cmp (OrcCompiler *compiler, int src1, int src2)
{
  orc_uint32 code;

  code = 0xe1500000;
  code |= (src1&0xf) << 16;
  code |= (src2&0xf) << 0;

  ORC_ASM_CODE(compiler,"  cmp %s, %s\n",
      orc_arm_reg_name (src1),
      orc_arm_reg_name (src2));
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_asr_imm (OrcCompiler *compiler, int dest, int src1, int value)
{
  orc_uint32 code;

  if (value == 0) {
    ORC_ERROR("bad immediate value");
  }
  code = 0xe1a00040;
  code |= (src1&0xf) << 0;
  code |= (dest&0xf) << 12;
  code |= (value) << 7;

  ORC_ASM_CODE(compiler,"  asr %s, %s, #%d\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1),
      value);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_lsl_imm (OrcCompiler *compiler, int dest, int src1, int value)
{
  orc_uint32 code;

  if (value == 0) {
    ORC_ERROR("bad immediate value");
  }
  code = 0xe1a00000;
  code |= (src1&0xf) << 0;
  code |= (dest&0xf) << 12;
  code |= (value) << 7;

  ORC_ASM_CODE(compiler,"  lsl %s, %s, #%d\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1),
      value);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_load_reg (OrcCompiler *compiler, int dest, int src1, int offset)
{
  orc_uint32 code;

  code = 0xe5900000;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= offset&0xfff;

  ORC_ASM_CODE(compiler,"  ldr %s, [%s, #%d]\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_store_reg (OrcCompiler *compiler, int src1, int dest, int offset)
{
  orc_uint32 code;

  code = 0xe5800000;
  code |= (dest&0xf) << 16;
  code |= (src1&0xf) << 12;
  code |= offset&0xfff;

  ORC_ASM_CODE(compiler,"  str %s, [%s, #%d]\n",
      orc_arm_reg_name (src1),
      orc_arm_reg_name (dest), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_mov (OrcCompiler *compiler, int dest, int src)
{
  if (dest == src) return;
  orc_arm_emit_mov_r(compiler, ORC_ARM_COND_AL, 0, dest, src);
}

void
orc_arm_emit_sub (OrcCompiler *compiler, int dest, int src1, int src2)
{
  orc_arm_emit_sub_r (compiler, ORC_ARM_COND_AL, 0, dest, src1, src2);
}

void
orc_arm_emit_sub_imm (OrcCompiler *compiler, int dest, int src1, int value,
    int record)
{
  orc_arm_emit_sub_i (compiler, ORC_ARM_COND_AL, record, dest, src1, value);
}

void
orc_arm_emit_add (OrcCompiler *compiler, int dest, int src1, int src2)
{
  orc_arm_emit_add_r (compiler, ORC_ARM_COND_AL, 0, dest, src1, src2);
}

void
orc_arm_emit_cmp_imm (OrcCompiler *compiler, int src1, int value)
{
  orc_arm_emit_cmp_i (compiler, ORC_ARM_COND_AL, src1, value);
}


/* shifter operands */
/*    1
 *  1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 * |rotimm |   immed_8     |
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_so_i(rot,imm) ((((rot)&15)<<8)|((imm)&255))
/*    1
 *  1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 * |    Si   | St|0|   Rm  |
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_so_rsi(Si,St,Rm)   ((((Si)&31)<<7)|(((St)&3)<<5)|((Rm)&15))
#define arm_so_rrx(Rm)         arm_so_rsi(0,ORC_ARM_ROR,Rm)
#define arm_so_r(Rm)           ((Rm)&15)
/*    1
 *  1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 * |  Rs   |0| St|1|   Rm  |
 * +-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_so_rsr(Rs,St,Rm)   (0x010|(((Rs)&15)<<8)|(((St)&3)<<5)|((Rm)&15))

/* data processing instructions */
/*    3   2 2 2 2 2     2 2 1     1 1     1   1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | cond  |0 0|I| opcode|S|   Rn  |  Rd   |   shifter_operand     |
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_code_dp(cond,I,opcode,S,Rn,Rd,So) ((((cond)&15)<<28) | (((I)&1)<<25) |   \
                                              (((opcode)&15)<<21) | (((S)&1)<<20) | \
                                              (((Rn)&15)<<16) | (((Rd)&15)<<12) |   \
                                              ((So)&0xfff))

/*
 * type 0:  <op>{<cond>}{s} {<Rd>}, <Rn>, #imm   (imm = (val>>(shift*2))|(val<<(32-(shift*2))))
 * type 1:  <op>{<cond>}{s} {<Rd>}, <Rn>, <Rm>
 * type 2:  <op>{<cond>}{s} {<Rd>}, <Rn>, <Rm>, [LSL|LSR|ASR] #imm
 * type 3:  <op>{<cond>}{s} {<Rd>}, <Rn>, <Rm>, [LSL|LSR|ASR] <Rs>
 * type 4:  <op>{<cond>}{s} {<Rd>,} <Rn>, <Rm>, RRX
 */
void
orc_arm_emit_dp (OrcCompiler *p, int type, OrcArmCond cond, OrcArmDP opcode,
    int S, int Rd, int Rn, int Rm, int shift, orc_uint32 val)
{
  orc_uint32 code;
  int I = 0;
  int shifter_op;
  char shifter[64];
  orc_uint32 imm;
  static const char *shift_names[] = {
    "LSL", "LSR", "ASR", "ROR"
  };
  /* opcodes with Rd */
  static const int op_Rd[] = {
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1
  };
  /* opcodes using Rn */
  static const int op_Rn[] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0
  };
  static const char *dp_insn_names[] = {
    "and", "eor", "sub", "rsb", "add", "adc", "sbc", "rsc",
    "tst", "teq", "cmp", "cmn", "orr", "mov", "bic", "mvn"
  };

  switch (type) {
    case 0:
      /* #imm */
      imm = (orc_uint32) val;
      /* if imm <= 0xff we're done. It's recommanded that we choose the
       * smallest shifter value. Impossible values will overflow the shifter. */
      while (imm > 0xff && shift < 16) {
        imm = (imm << 2) | (imm >> 30);
        shift++;
      }
      if (shift > 15) {
        ORC_COMPILER_ERROR(p,"invalid ARM immediate %08x", val);
        return;
      }
      shifter_op = arm_so_i (shift, imm);
      sprintf (shifter, "#0x%08x", val);
      I = 1;
      break;
    case 1:
      /* <Rm> */
      shifter_op = arm_so_r (Rm);
      sprintf (shifter, "%s", orc_arm_reg_name (Rm));
      break;
    case 2:
      /* <Rm>, [LSL|LSR|ASR] #imm */
      shifter_op = arm_so_rsi (val,shift,Rm);
      sprintf (shifter, "%s, %s #%d",
          orc_arm_reg_name (Rm), shift_names[shift], val);
      break;
    case 3:
      /* <Rm>, [LSL|LSR|ASR] <Rs> */
      shifter_op = arm_so_rsr (val,shift,Rm);
      sprintf (shifter, "%s, %s %s",
          orc_arm_reg_name (Rm), shift_names[shift], orc_arm_reg_name (val));
      break;
    case 4:
      /* <Rm>, RRX */
      shifter_op = arm_so_rrx (Rm);
      sprintf (shifter, "%s, RRX",
          orc_arm_reg_name (Rm));
      break;
    default:
      ORC_COMPILER_ERROR(p,"unknown data processing type %d", type);
      return;
  }

  if (op_Rd[opcode]) {
    if (op_Rn[opcode]) {
      /* opcode using Rn */
      code = arm_code_dp (cond, I, opcode, S, Rn, Rd, shifter_op);
      ORC_ASM_CODE(p,"  %s%s%s %s, %s, %s\n",
          dp_insn_names[opcode], orc_arm_cond_name(cond), (S ? "s" : ""),
          orc_arm_reg_name (Rd), orc_arm_reg_name (Rn), shifter);
    } else {
      /* opcode using Rd and val (mov, mvn) */
      code = arm_code_dp (cond, I, opcode, S, Rn, Rd, shifter_op);
      ORC_ASM_CODE(p,"  %s%s%s %s, %s\n",
          dp_insn_names[opcode], orc_arm_cond_name(cond), (S ? "s" : ""),
          orc_arm_reg_name (Rd), shifter);
    }
  } else {
    /* opcode does not change Rd, change status register (cmp, tst, ..) */
    code = arm_code_dp (cond, I, opcode, 1, Rn, 0, shifter_op);
    ORC_ASM_CODE(p,"  %s%s %s, %s\n",
        dp_insn_names[opcode], orc_arm_cond_name(cond), orc_arm_reg_name (Rn), shifter);
  }
  orc_arm_emit (p, code);
}

/* parallel instructions */
/*    3   2 2 2 2 2     2 2 1     1 1     1   1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | cond  |      mode     |   Rn  |  Rd   |0 0 0 0|  op   |  Rm   |
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_code_par(cond,mode,Rn,Rd,op,Rm) (((cond)<<28)|((mode)<<20)|(((Rn)&0xf)<<16)|(((Rd)&0xf)<<12)|((op)<<4)|((Rm)&0xf)|0xf00)

void
orc_arm_emit_par (OrcCompiler *p, int op, int mode, OrcArmCond cond,
    int Rd, int Rn, int Rm)
{
  orc_uint32 code;
  static const int par_op[] = {
    1, 3, 5, 7, 9, 15, 11, 5, 5
  };
  static const char *par_op_names[] = {
    "add16", "addsubx", "subaddx", "sub16", "add8", "sub8", "sel", "add", "sub"
  };
  static const int par_mode[] = {
    0x61, 0x62, 0x63, 0x65, 0x66, 0x67, 0x68, 0x10, 0x12, 0x14, 0x16
  };
  static const char *par_mode_names[] = {
    "s", "q", "sh", "u", "uq", "uh", "", "q", "q", "qd", "qd"
  };

  code = arm_code_par (cond, par_mode[mode], Rn, Rd, par_op[op], Rm);
  if (op == 7) {
    int tmp;
    /* gas does something screwy here */
    code &= ~0xf00;
    tmp = Rn;
    Rn = Rm;
    Rm = tmp;
  }
  ORC_ASM_CODE(p,"  %s%s%s %s, %s, %s\n",
      par_mode_names[mode], par_op_names[op], orc_arm_cond_name(cond),
      orc_arm_reg_name (Rd),
      orc_arm_reg_name (Rn),
      orc_arm_reg_name (Rm));
  orc_arm_emit (p, code);
}

/* extend instructions */
/*    3   2 2 2 2 2     2 2 1     1 1     1 1 1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | cond  |0 1 1 0 0 0 0 0|   Rn  |  Rd   |rot|0 0|0 1 1 1|  Rm   |
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_code_xt(op,cond,Rn,Rd,r8,Rm) (op|((cond)<<28)|(((Rn)&0xf)<<16)|(((Rd)&0xf)<<12)|((((r8)&0xf)&0x18)<<7)|((Rm)&0xf))

void
orc_arm_emit_xt (OrcCompiler *p, int op, OrcArmCond cond,
        int Rd, int Rn, int Rm, int r8)
{
  orc_uint32 code;
  char shifter[64];
  static const orc_uint32 xt_opcodes[] = {
    0x06800070, 0x06a00070, 0x06b00070, 0x06c00070, 0x06e00070, 0x06f00070
  };
  static const char *xt_insn_names[] = {
    "sxtb16", "sxtb", "sxth", "uxtb16", "uxtb", "uxth",
    "sxtab16", "sxtab", "sxtah", "uxtab16", "uxtab", "uxtah",
  };

  if (r8 & 0x18)
    sprintf (shifter, ", ROR #%d", r8 & 0x18);
  else
    shifter[0] = '\0';

  code = arm_code_xt (xt_opcodes[op], cond, Rn, Rd, r8, Rm);
  if (Rn < 15) {
    /* with Rn */
    ORC_ASM_CODE(p,"  %s%s %s, %s, %s%s\n",
        xt_insn_names[op], orc_arm_cond_name(cond),
        orc_arm_reg_name (Rd),
        orc_arm_reg_name (Rn),
        orc_arm_reg_name (Rm),
        shifter);
  } else {
    ORC_ASM_CODE(p,"  %s%s %s, %s%s\n",
        xt_insn_names[op], orc_arm_cond_name(cond),
        orc_arm_reg_name (Rd),
        orc_arm_reg_name (Rm),
        shifter);
  }
  orc_arm_emit (p, code);
}

#define arm_code_pkh(op,cond,Rn,Rd,sh,Rm) (op|((cond)<<28)|(((Rn)&0xf)<<16)|(((Rd)&0xf)<<12)|((sh)<<7)|((Rm)&0xf))
void
orc_arm_emit_pkh (OrcCompiler *p, int op, OrcArmCond cond,
    int Rd, int Rn, int Rm, int sh)
{
  orc_uint32 code;
  char shifter[64];
  static const orc_uint32 pkh_opcodes[] = { 0x06800010, 0x06800050 };
  static const char *pkh_insn_names[] = { "pkhbt", "pkhtb" };

  if (sh > 0) {
    sprintf (shifter, ", %s #%d",
        (op == 0 ? "LSL" : "ASR"), sh);
  } else {
    shifter[0] = '\0';
  }

  code = arm_code_pkh (pkh_opcodes[op], cond, Rn, Rd, sh, Rm);
  ORC_ASM_CODE(p,"  %s%s %s, %s, %s%s\n",
      pkh_insn_names[op], orc_arm_cond_name(cond),
      orc_arm_reg_name (Rd),
      orc_arm_reg_name (Rn),
      orc_arm_reg_name (Rm),
      shifter);
  orc_arm_emit (p, code);
}

/* extend instructions */
/*    3   2 2     2       2 1     1 1     1 1 1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * | cond  |0 1 1 0|x x x|   sat   |  Rd   |   sh    |a|0 1|  Rm   |
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 */
#define arm_code_sat(op,cond,sat,Rd,sh,a,Rm) (op|(((cond)&15)<<28)|(((sat)&31)<<16)|\
                                              (((Rd)&15)<<12)|(((sh)&31)<<7)|(((a)&1)<<6)|\
                                              ((Rm)&15))
void
orc_arm_emit_sat (OrcCompiler *p, int op, OrcArmCond cond,
        int Rd, int sat, int Rm, int sh, int asr)
{
  orc_uint32 code;
  char shifter[64];
  static const orc_uint32 sat_opcodes[] = { 0x06a00010, 0x06e00010, 0, 0 };
  static const char *sat_insn_names[] = { "ssat", "usat", "ssat16", "usat16" };
  static const int par_mode[] = { 0, 0, 0x6a, 0x6e };
  static const int par_op[] = { 0, 0, 3, 3 };

  if (sh > 0) {
    sprintf (shifter, ", %s #%d",
        (asr&1 ? "ASR" : "LSL"), sh);
  } else {
    shifter[0] = '\0';
  }

  if (op < 2) {
    code = arm_code_sat (sat_opcodes[op], cond, sat, Rd, sh, asr, Rm);
  } else {
    if (op == 3) {
      code = arm_code_par (cond, par_mode[op], sat, Rd, par_op[op], Rm);
    } else {
      code = arm_code_par (cond, par_mode[op], sat - 1, Rd, par_op[op], Rm);
    }
  }
  ORC_ASM_CODE(p,"  %s%s %s, #%d, %s%s\n",
      sat_insn_names[op], orc_arm_cond_name(cond),
      orc_arm_reg_name (Rd),
      sat,
      orc_arm_reg_name (Rm),
      shifter);
  orc_arm_emit (p, code);
}

#define arm_code_rv(op,cond,Rd,Rm) (op|(((cond)&15)<<28)|(((Rd)&15)<<12)|((Rm)&15))
void
orc_arm_emit_rv (OrcCompiler *p, int op, OrcArmCond cond,
    int Rd, int Rm)
{
  orc_uint32 code;
  static const orc_uint32 rv_opcodes[] = { 0x06bf0f30, 0x06bf0fb0 };
  static const char *rv_insn_names[] = { "rev", "rev16" };

  code = arm_code_rv (rv_opcodes[op], cond, Rd, Rm);
  ORC_ASM_CODE(p,"  %s%s %s, %s\n",
      rv_insn_names[op], orc_arm_cond_name(cond),
      orc_arm_reg_name (Rd), orc_arm_reg_name (Rm));
  orc_arm_emit (p, code);
}

void
orc_arm_flush_cache (OrcCode *code)
{
#ifdef HAVE_ARM
#ifdef __APPLE__
  sys_icache_invalidate(code->code, code->code_size);
#else
  __clear_cache (code->code, code->code + code->code_size);
#endif
#endif
}

void
orc_arm_emit_data (OrcCompiler *compiler, orc_uint32 data)
{
  if (compiler->target_flags & ORC_TARGET_CLEAN_COMPILE) {
    orc_arm_emit_nop (compiler);
  } else {
    ORC_ASM_CODE(compiler,"  .word 0x%08x\n", data);
    orc_arm_emit (compiler, data);
  }
}

void
orc_arm_loadw (OrcCompiler *compiler, int dest, int src1, int offset)
{
  orc_uint32 code;

  code = 0xe1d000b0;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  ldrh %s, [%s, #%d]\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1), offset);
  orc_arm_emit (compiler, code);
}

