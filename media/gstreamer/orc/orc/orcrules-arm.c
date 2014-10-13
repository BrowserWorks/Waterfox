
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcdebug.h>
#include <orc/orcprogram.h>
#include <orc/orcarm.h>

#define BINARY_DP(opcode,insn_name) \
static void \
arm_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  int src1 = ORC_SRC_ARG (p, insn, 0);                                 \
  int src2 = ORC_SRC_ARG (p, insn, 1);                                 \
  int dest = ORC_DEST_ARG (p, insn, 0);                                \
                                                                       \
  orc_arm_emit_ ##insn_name## _r (p, ORC_ARM_COND_AL, 0,               \
          dest, src1, src2);                                           \
}

#define BINARY_MM(opcode,insn_name) \
static void \
arm_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  int src1 = ORC_SRC_ARG (p, insn, 0);                                 \
  int src2 = ORC_SRC_ARG (p, insn, 1);                                 \
  int dest = ORC_DEST_ARG (p, insn, 0);                                \
                                                                       \
  orc_arm_emit_##insn_name (p, ORC_ARM_COND_AL, dest, src1, src2);     \
}

/* multiplies */
#define orc_arm_smulxy(cond,x,y,Rd,Rm,Rs) (0x01600080|((cond)<<28)|(((Rd)&15)<<16)|(((Rs)&15)<<8)|((y)<<6)|((x)<<5)|((Rm)&15))
#define orc_arm_emit_smulbb(p,cond,Rd,Rm,Rs) do { \
  ORC_ASM_CODE (p, "smulbb %s, %s, %s\n", orc_arm_reg_name (Rd), \
      orc_arm_reg_name (Rm), orc_arm_reg_name(Rs)); \
  orc_arm_emit (p, orc_arm_smulxy (cond,0,0,Rd,Rm,Rs)); \
} while (0)
#define orc_arm_emit_smulbt(p,cond,Rd,Rm,Rs) do { \
  ORC_ASM_CODE (p, "smulbt %s, %s, %s\n", orc_arm_reg_name (Rd), \
      orc_arm_reg_name (Rm), orc_arm_reg_name(Rs)); \
  orc_arm_emit (p, orc_arm_smulxy (cond,0,1,Rd,Rm,Rs)); \
} while (0)
#define orc_arm_emit_smultb(p,cond,Rd,Rm,Rs) do { \
  ORC_ASM_CODE (p, "smultb %s, %s, %s\n", orc_arm_reg_name (Rd), \
      orc_arm_reg_name (Rm), orc_arm_reg_name(Rs)); \
  orc_arm_emit (p, orc_arm_smulxy (cond,1,0,Rd,Rm,Rs)); \
} while (0)
#define orc_arm_emit_smultt(p,cond,Rd,Rm,Rs) do { \
  ORC_ASM_CODE (p, "smultt %s, %s, %s\n", orc_arm_reg_name (Rd), \
      orc_arm_reg_name (Rm), orc_arm_reg_name(Rs)); \
  orc_arm_emit (p, orc_arm_smulxy (cond,1,1,Rd,Rm,Rs)); \
} while (0)

#define orc_arm_mul(cond,S,Rd,Rm,Rs) (0x00000090|((cond)<<28)|((S)<<20)|(((Rd)&15)<<16)|(((Rs)&15)<<8)|((Rm)&15))
#define orc_arm_emit_mul(p,cond,S,Rd,Rm,Rs) do { \
  ORC_ASM_CODE (p, "mul %s, %s, %s\n", orc_arm_reg_name (Rd), \
      orc_arm_reg_name (Rm), orc_arm_reg_name(Rs)); \
  orc_arm_emit (p, orc_arm_mul (cond,S,Rd,Rm,Rs)); \
} while (0)

#define orc_arm_mull(op,cond,S,RdL,RdH,Rn,Rm) (op|((cond)<<28)|((S)<<20)|(((Rn)&15)<<16)|(((RdL)&15)<<12)|(((RdH)&15)<<8)|((Rm)&15))
#define orc_arm_emit_smull(p,cond,S,RdL,RdH,Rn,Rm) do { \
  ORC_ASM_CODE (p, "smull %s, %s, %s, %s\n", orc_arm_reg_name (RdL), \
      orc_arm_reg_name (RdH), \
      orc_arm_reg_name (Rn), orc_arm_reg_name(Rm)); \
  orc_arm_emit(p,orc_arm_mull (0x00c00090,cond,S,RdL,Rm,RdH,Rn)); \
} while (0)
#define orc_arm_emit_umull(p,cond,S,RdL,RdH,Rn,Rm) do { \
  ORC_ASM_CODE (p, "umull %s, %s, %s, %s\n", orc_arm_reg_name (RdL), \
      orc_arm_reg_name (RdH), \
      orc_arm_reg_name (Rn), orc_arm_reg_name(Rm)); \
  orc_arm_emit(p,orc_arm_mull (0x00800090,cond,S,RdL,RdH,Rn,Rm)); \
} while (0)

static void
arm_rule_loadpX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  if (compiler->vars[insn->src_args[0]].vartype == ORC_VAR_TYPE_CONST) {
    orc_arm_emit_load_imm (compiler, compiler->vars[insn->dest_args[0]].alloc,
        (int)compiler->vars[insn->src_args[0]].value.i);
  } else {
    orc_arm_loadw (compiler, compiler->vars[insn->dest_args[0]].alloc,
        compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, params[insn->src_args[0]]));
  }
}

static void
arm_rule_loadX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = compiler->vars[insn->src_args[0]].ptr_register;
  int dest = compiler->vars[insn->dest_args[0]].alloc;
  int size;
  orc_uint32 code;
  int offset = 0;

  size = (compiler->vars[insn->src_args[0]].size << compiler->loop_shift);

  if (size == 4) {
    code = 0xe5900000;
    ORC_ASM_CODE(compiler,"  ldr %s, [%s, #%d]\n",
        orc_arm_reg_name (dest),
        orc_arm_reg_name (src), offset);
  } else if (size == 2) {
    code = 0xe1d000b0;
    ORC_ASM_CODE(compiler,"  ldrh %s, [%s, #%d]\n",
        orc_arm_reg_name (dest),
        orc_arm_reg_name (src), offset);
  } else {
    code = 0xe5d00000;
    ORC_ASM_CODE(compiler,"  ldrb %s, [%s, #%d]\n",
        orc_arm_reg_name (dest),
        orc_arm_reg_name (src), offset);
  }
  code |= (src&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;
  orc_arm_emit (compiler, code);
}

static void
arm_rule_storeX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  int src = compiler->vars[insn->src_args[0]].alloc;
  int dest = compiler->vars[insn->dest_args[0]].ptr_register;
  int size;
  orc_uint32 code;
  int offset = 0;

  size = (compiler->vars[insn->src_args[0]].size << compiler->loop_shift);

  if (size == 4) {
    code = 0xe5800000;
    ORC_ASM_CODE(compiler,"  str %s, [%s, #%d]\n",
        orc_arm_reg_name (src),
        orc_arm_reg_name (dest), offset);
  } else if (size == 2) {
    code = 0xe1c000b0;
    ORC_ASM_CODE(compiler,"  strh %s, [%s, #%d]\n",
        orc_arm_reg_name (src),
        orc_arm_reg_name (dest), offset);
  } else {
    code = 0xe5c00000;
    ORC_ASM_CODE(compiler,"  strb %s, [%s, #%d]\n",
        orc_arm_reg_name (src),
        orc_arm_reg_name (dest), offset);
  }
  code |= (dest&0xf) << 16;
  code |= (src&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;
  orc_arm_emit (compiler, code);
}

void
orc_arm_loadb (OrcCompiler *compiler, int dest, int src1, int offset)
{
  orc_uint32 code;

  code = 0xe5d00000;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  ldrb %s, [%s, #%d]\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_storeb (OrcCompiler *compiler, int dest, int offset, int src1)
{
  orc_uint32 code;

  code = 0xe5c00000;
  code |= (dest&0xf) << 16;
  code |= (src1&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  strb %s, [%s, #%d]\n",
      orc_arm_reg_name (src1),
      orc_arm_reg_name (dest), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_loadl (OrcCompiler *compiler, int dest, int src1, int offset)
{
  orc_uint32 code;

  code = 0xe5900000;
  code |= (src1&0xf) << 16;
  code |= (dest&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  ldr %s, [%s, #%d]\n",
      orc_arm_reg_name (dest),
      orc_arm_reg_name (src1), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_storel (OrcCompiler *compiler, int dest, int offset, int src1)
{
  orc_uint32 code;

  code = 0xe5800000;
  code |= (dest&0xf) << 16;
  code |= (src1&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  str %s, [%s, #%d]\n",
      orc_arm_reg_name (src1),
      orc_arm_reg_name (dest), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_storew (OrcCompiler *compiler, int dest, int offset, int src1)
{
  orc_uint32 code;

  code = 0xe1c000b0;
  code |= (dest&0xf) << 16;
  code |= (src1&0xf) << 12;
  code |= (offset&0xf0) << 4;
  code |= offset&0x0f;

  ORC_ASM_CODE(compiler,"  strh %s, [%s, #%d]\n",
      orc_arm_reg_name (src1),
      orc_arm_reg_name (dest), offset);
  orc_arm_emit (compiler, code);
}

void
orc_arm_emit_mov_iw (OrcCompiler *p, int cond, int dest, int val, int loop)
{
  /* dest = val */
  orc_arm_emit_mov_i (p, cond, 0, dest, val);
  if (loop > 1)
    /* 2 words:  dest |= dest << 16 */
    orc_arm_emit_orr_rsi (p, cond, 0, dest, dest, dest, ORC_ARM_LSL, 16);
}

void
orc_arm_emit_mov_ib (OrcCompiler *p, int cond, int dest, int val, int loop)
{
  /* 1 byte */
  orc_arm_emit_mov_i (p, cond, 0, dest, val);
  if (loop > 1)
    /* 2 bytes:  dest |= dest << 8 */
    orc_arm_emit_orr_rsi (p, cond, 0, dest, dest, dest, ORC_ARM_LSL, 8);
  if (loop > 2)
    /* 4 bytes:  dest |= dest << 16 */
    orc_arm_emit_orr_rsi (p, cond, 0, dest, dest, dest, ORC_ARM_LSL, 16);
}

/* byte instructions */
static void
arm_rule_absX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int type = ORC_PTR_TO_INT(user);

  orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, dest, 0);

  if (type == 0) {
    /* negate tmp = 0 - src1 */
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, tmp, dest, src1);
    /* check sign dest = src1 - 0 */
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, src1, dest);
  } else {
    /* negate tmp = 0 - src1 */
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, tmp, dest, src1);
    /* check sign dest = src1 - 0 */
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, src1, dest);
  }
  /* take positive or negative values */
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src1, tmp);
}
BINARY_MM (addb, sadd8);
BINARY_MM (addssb, qadd8);
BINARY_MM (addusb, uqadd8);
BINARY_DP (andX, and);

static void
arm_rule_andnX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_bic_r (p, ORC_ARM_COND_AL, 0, dest, src2, src1); 
}

static void
arm_rule_avgX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int mask = p->tmpreg;
  int tmp = p->gp_tmpreg;
  int dest = ORC_DEST_ARG (p, insn, 0);
  int type = ORC_PTR_TO_INT(user);

  /* signed variant, make a mask, FIXME, instruction constants */
  if (type >= 2) {
    /* mask for word 0x80008000 */
    orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, mask, 0x80000000);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, mask, mask, mask, ORC_ARM_LSR, 16);

    if (type >= 3) {
      /* mask for byte 0x80808080 */
      orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, mask, mask, mask, ORC_ARM_LSR, 8);
    }

    /* signed variant, bias the inputs */
    orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, src1, src1, mask);
    orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, src2, src2, mask);
  }

  /* dest = (s1 | s2) - (((s1 ^ s2) & ~(0x1 >>> (shift*2))) >> 1) */
  /* (s1 | s2) */
  orc_arm_emit_orr_r (p, ORC_ARM_COND_AL, 0, tmp, src1, src2);
  /* (s1 ^ s2) */
  orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, dest, src1, src2);

  /* clear the bits we will shift into view in the next instruction, FIXME, we
   * need instruction wide constants */
  if (type <= 1) {
    /* clear 0x00010000 */
    orc_arm_emit_bic_i (p, ORC_ARM_COND_AL, 0, dest, dest, 0x00010000);
    if (type == 0) {
      /* clear 0x00000100 */
      orc_arm_emit_bic_i (p, ORC_ARM_COND_AL, 0, dest, dest, 0x00000100);
      /* clear 0x01000000 */
      orc_arm_emit_bic_i (p, ORC_ARM_COND_AL, 0, dest, dest, 0x01000000);
    }
  } else if (type >= 2) {
    /* already have a mask, use it here */
    orc_arm_emit_bic_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, mask, ORC_ARM_LSR, 7);
  }

  /* do final right shift and subtraction */
  orc_arm_emit_sub_rsi (p, ORC_ARM_COND_AL, 0, dest, tmp, dest, ORC_ARM_LSR, 1);

  if (type >= 2) {
    /* signed variant, unbias input again */
    orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, src1, src1, mask);
    orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, src2, src2, mask);
  }
}
static void
arm_rule_cmpeqX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int size = ORC_PTR_TO_INT(user);

  /* bytes that are equal will have all bits 0 */
  orc_arm_emit_eor_r (p, ORC_ARM_COND_AL, 0, tmp, src1, src2);

  /* clear dest register */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, dest, 0);

  /* tmp = 0 - tmp, set GE flags for 0 bytes */
  if (size == 1) {
    orc_arm_emit_usub8 (p, ORC_ARM_COND_AL, tmp, dest, tmp);
  } else {
    orc_arm_emit_usub16 (p, ORC_ARM_COND_AL, tmp, dest, tmp);
  }

  /* make 0xffffffff in tmp */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_AL, 0, tmp, 0);

  /* set 0xff for 0 bytes, 0x00 otherwise */
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, tmp, dest);
}
static void
arm_rule_cmpgtsX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int size = ORC_PTR_TO_INT(user);

  /* dest = src2 - src1, set GE flags for src2 >= src1 */
  if (size == 1) {
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, src2, src1);
  } else {
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, src2, src1);
  }

  /* clear dest register */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, dest, 0);
  /* make 0xffffffff in tmp */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_AL, 0, tmp, 0);

  /* set 0x00 for src2 >= src1 bytes, 0xff if src2 < src1 */
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, dest, tmp);
}
static void
arm_rule_copyX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_mov_r (p, ORC_ARM_COND_AL, 0, dest, src1);
}

static void
arm_rule_maxsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src1, src2);
}
static void
arm_rule_maxub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_usub8 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src1, src2);
}
static void
arm_rule_minsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src2, src1);
}
static void
arm_rule_minub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_usub8 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src2, src1);
}

static void
arm_rule_mullb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int tmp3 = ORC_ARM_V8;
  int loop = 1;

  /* extract and multiply first item */
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp2, src2);
  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, tmp1, tmp2);

  if (loop > 1) {
    if (loop > 2) {
      /* third item, reuse extracted bits for first item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with first */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, dest, tmp1, 16);
    }
    /* clear upper bits */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);

    /* extract and multiply second item */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 8);
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 8);
    orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, tmp3, tmp1, tmp2);

    if (loop > 2) {
      /* forth item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with second */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, tmp3, tmp3, tmp1, 16);
    }
    /* clear upper bits */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp3, tmp3);

    /* merge results */
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp3, ORC_ARM_LSL, 8);
  }
}

static void
arm_rule_mulhsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_SB(mulhsb, "(%s * %s) >> 8") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int tmp3 = ORC_ARM_V8;
  int loop = 1;

  /* first item (and third) */
  orc_arm_emit_sxtb16 (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_sxtb16 (p, ORC_ARM_COND_AL, tmp2, src2);
  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, tmp1, tmp2);

  if (loop > 1) {
    if (loop > 2) {
      /* third item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with first */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, dest, tmp1, 16);
    }
    /* extract upper bits */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, dest, dest, 8);

    /* second item (and fourth) */
    orc_arm_emit_sxtb16_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 8);
    orc_arm_emit_sxtb16_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 8);
    orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, tmp3, tmp1, tmp2);

    if (loop > 2) {
      /* forth item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with second */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, tmp3, tmp3, tmp1, 16);
    }
    /* extract upper bits */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp3, tmp3, 8);

    /* merge tmp3 */
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp3, ORC_ARM_LSL, 8);
  } else {
    /* bring upper bits in position */
    orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, ORC_ARM_LSR, 8);
  }
}

static void
arm_rule_mulhub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_UB(mulhub, "((orc_uint32)(uint8_t)%s * (orc_uint32)(uint8_t)%s) >> 8") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int tmp3 = ORC_ARM_V8;
  int loop = 1;

  /* first item (and third) */
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp2, src2);
  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, tmp1, tmp2);

  if (loop > 1) {
    if (loop > 2) {
      /* third item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with first */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, dest, tmp1, 16);
    }
    /* extract upper bits */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, dest, dest, 8);

    /* second item (and fourth) */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 8);
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 8);
    orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, tmp3, tmp1, tmp2);

    if (loop > 2) {
      /* forth item */
      orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);
      /* merge with second */
      orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, tmp3, tmp3, tmp1, 16);
    }
    /* extract upper bits */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp3, tmp3, 8);

    /* merge tmp3 */
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp3, ORC_ARM_LSL, 8);
  } else {
    /* bring upper bits in position */
    orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, ORC_ARM_LSR, 8);
  }
}

BINARY_DP (orX, orr);
static void
arm_rule_shlX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* degrades nicely to trivial shift when not doing parallel shifts */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int mask = p->tmpreg;
  int src2type = ORC_SRC_TYPE (p, insn, 1);
  int size = ORC_PTR_TO_INT(user);
  int loop = 4 / size; /* number of items in one register */

  if (src2type == ORC_VAR_TYPE_CONST) {
    int val = ORC_SRC_VAL (p, insn, 1);

    if (loop > 1 && size != 4 && val < 5) {
      for (;val; val--) {
        /* small values, do a series of additions, we need at least 5
         * instructions for the generic case below. */
        if (size == 1)
          orc_arm_emit_uadd8 (p, ORC_ARM_COND_AL, dest, src1, src1);
        else
          orc_arm_emit_uadd16 (p, ORC_ARM_COND_AL, dest, src1, src1);
      }
    }
    else {
      /* bigger values, shift and mask out excess bits */
      if (val >= size) {
        /* too big, clear all */
        orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, dest, 0);
      } else if (val > 0) {
        if (loop > 1 && size < 4) {
          /* shift, note that we skip the next instructions when 0 */
          orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSL, val);
          if (size == 1)
            /* make loop * 0x80 */
            orc_arm_emit_mov_ib (p, ORC_ARM_COND_NE, mask, 0x80, loop);
          else
            /* make loop * 0x8000 */
            orc_arm_emit_mov_iw (p, ORC_ARM_COND_NE, mask, 0x8000, loop);
          /* make mask, this mask has enough bits but is shifted one position to the right */
          orc_arm_emit_sub_rsi (p, ORC_ARM_COND_NE, 0, mask, mask, mask, ORC_ARM_LSR, val);
          /* clear upper bits */
          orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, mask, ORC_ARM_LSL, 1);
        } else {
          orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSL, val);
        }
      }
    }
  } else if (src2type == ORC_VAR_TYPE_PARAM) {
    int src2 = ORC_SRC_ARG (p, insn, 1);

    if (loop > 1 && size < 4) {
      /* shift with register value, note that we skip the next instructions when 0 */
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSL, src2);
      if (size == 1)
        /* make loop * 0x80 */
        orc_arm_emit_mov_ib (p, ORC_ARM_COND_NE, mask, 0x80, loop);
      else
        /* make loop * 0x8000 */
        orc_arm_emit_mov_iw (p, ORC_ARM_COND_NE, mask, 0x8000, loop);
      /* make mask */
      orc_arm_emit_sub_rsr (p, ORC_ARM_COND_NE, 0, mask, mask, mask, ORC_ARM_LSR, src2);
      /* clear bits */
      orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, mask, ORC_ARM_LSL, 1);
    } else {
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSL, src2);
    }
  } else {
    ORC_COMPILER_ERROR(p,"rule only works with constants or parameters");
  }
}

static void
arm_rule_shrsX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* degrades nicely to trivial shift when not doing parallel shifts */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int mask = p->tmpreg;
  int tmp = p->gp_tmpreg;
  int src2type = ORC_SRC_TYPE (p, insn, 1);
  int size = ORC_PTR_TO_INT(user);
  int loop = 4 / size; /* number of items in one register */

  if (src2type == ORC_VAR_TYPE_CONST) {
    int val = ORC_SRC_VAL (p, insn, 1);

    if (val > 0) {
      /* clamp max shift so we can sign extend */
      if (val >= size)
        val = size - 1;

      /* shift */
      if (size < 4) {
        if (size == 2 && val == 8) {
          /* half word shift by 8 */
          orc_arm_emit_sxtb16_r8 (p, ORC_ARM_COND_AL, dest, src1, 8);
        } else {
          if (size == 1)
            /* make loop * 80, position of sign bit after shift */
            orc_arm_emit_mov_ib (p, ORC_ARM_COND_AL, mask, 0x80, loop);
          else
            /* make loop * 8000 */
            orc_arm_emit_mov_iw (p, ORC_ARM_COND_AL, mask, 0x8000, loop);
          /* make mask, save in tmp, we need the original mask */
          orc_arm_emit_sub_rsi (p, ORC_ARM_COND_AL, 0, tmp, mask, mask, ORC_ARM_LSR, val);

          /* do the shift */
          orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSR, val);
          /* clear upper bits */
          orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, tmp, ORC_ARM_LSL, 1);

          /* flip sign bit */
          orc_arm_emit_eor_r (p, ORC_ARM_COND_NE, 0, dest, dest, mask);
          /* extend sign bits */
          if (size == 1)
            orc_arm_emit_usub8 (p, ORC_ARM_COND_NE, dest, dest, mask);
          else
            orc_arm_emit_usub16 (p, ORC_ARM_COND_NE, dest, dest, mask);
        }
      } else {
        /* full word shift */
        orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_ASR, val);
      }
    }
  } else if (src2type == ORC_VAR_TYPE_PARAM) {
    int src2 = ORC_SRC_ARG (p, insn, 1);

    if (size < 4) {
      if (size == 1)
        /* make loop * 0x80 */
        orc_arm_emit_mov_ib (p, ORC_ARM_COND_AL, mask, 0x80, loop);
      else
        /* make loop * 0x8000 */
        orc_arm_emit_mov_iw (p, ORC_ARM_COND_AL, mask, 0x8000, loop);
      /* make mask */
      orc_arm_emit_sub_rsr (p, ORC_ARM_COND_AL, 0, tmp, mask, mask, ORC_ARM_LSR, src2);

      /* do the shift */
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSR, src2);
      /* clear upper bits */
      orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, tmp, ORC_ARM_LSL, 1);

      /* flip sign bit */
      orc_arm_emit_eor_r (p, ORC_ARM_COND_NE, 0, dest, dest, mask);
      /* extend sign bits */
      if (size == 1)
        orc_arm_emit_usub8 (p, ORC_ARM_COND_NE, dest, dest, mask);
      else
        orc_arm_emit_usub16 (p, ORC_ARM_COND_NE, dest, dest, mask);
    } else {
      /* full word shift with register value */
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 0, dest, dest, ORC_ARM_ASR, src2);
    }
  } else {
    ORC_COMPILER_ERROR(p,"rule only works with constants or parameters");
  }
}

static void
arm_rule_shruX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* degrades nicely to trivial shift when not doing parallel shifts */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int mask = p->tmpreg;
  int src2type = ORC_SRC_TYPE (p, insn, 1);
  int size = ORC_PTR_TO_INT(user);
  int loop = 4 / size; /* number of items in one register */

  if (src2type == ORC_VAR_TYPE_CONST) {
    int val = ORC_SRC_VAL (p, insn, 1);

    /* shift and mask out excess bits */
    if (val >= size) {
      /* too big, clear all */
      orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, dest, 0);
    } else if (val > 0) {
      if (size < 4) {
        if (size == 2 && val == 8) {
          /* half word shift by 8 */
          orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, dest, src1, 8);
        } else {
          /* do the shift, set S flags */
          orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSR, val);

          if (size == 1)
            /* make loop * 0x80 */
            orc_arm_emit_mov_ib (p, ORC_ARM_COND_NE, mask, 0x80, loop);
          else
            /* make loop * 0x8000 */
            orc_arm_emit_mov_iw (p, ORC_ARM_COND_NE, mask, 0x8000, loop);
          /* make mask */
          orc_arm_emit_sub_rsi (p, ORC_ARM_COND_NE, 0, mask, mask, mask, ORC_ARM_LSR, val);

          /* clear upper bits */
          orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, mask, ORC_ARM_LSL, 1);
        }
      } else {
        /* one 4 byte shift, no need for the S flag */
        orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSR, val);
      }
    }
  } else if (src2type == ORC_VAR_TYPE_PARAM) {
    int src2 = ORC_SRC_ARG (p, insn, 1);

    if (size < 4) {
      /* shift with register value */
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 1, dest, src1, ORC_ARM_LSR, src2);

      if (size == 1)
        /* make loop * 0x80 */
        orc_arm_emit_mov_ib (p, ORC_ARM_COND_NE, mask, 0x80, loop);
      else
        /* make loop * 0x8000 */
        orc_arm_emit_mov_iw (p, ORC_ARM_COND_NE, mask, 0x8000, loop);
      /* make mask */
      orc_arm_emit_sub_rsr (p, ORC_ARM_COND_NE, 0, mask, mask, mask, ORC_ARM_LSR, src2);

      /* clear bits */
      orc_arm_emit_bic_rsi (p, ORC_ARM_COND_NE, 0, dest, dest, mask, ORC_ARM_LSL, 1);
    } else {
      /* shift with register value */
      orc_arm_emit_mov_rsr (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSR, src2);
    }
  } else {
    ORC_COMPILER_ERROR(p,"rule only works with constants or parameters");
  }
}

static void
arm_rule_signX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int zero = p->tmpreg;
  int ones = p->gp_tmpreg;
  int tmp = ORC_ARM_V8;
  int type = ORC_PTR_TO_INT(user);

  /* make 0 */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_AL, 0, zero, 0);
  /* make 0xffffffff */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_AL, 0, ones, 0);

  /* dest = src1 - 0 (src1 >= 0 ? 0 : -1) */
  if (type == 0)
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, src1, zero);
  else
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, src1, zero);

  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, zero, ones);

  /* tmp = 0 - src1 (src1 <= 0 ? 0 : -1) */
  if (type == 0)
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, tmp, zero, src1);
  else
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, tmp, zero, src1);

  orc_arm_emit_sel (p, ORC_ARM_COND_AL, tmp, zero, ones);

  /* (src1 >= 0 ? 0 : -1) - (src1 <= 0 ? 0 : -1) */
  if (type == 0)
    orc_arm_emit_ssub8 (p, ORC_ARM_COND_AL, dest, dest, tmp);
  else
    orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, dest, tmp);
}

BINARY_MM (subb, ssub8);
BINARY_MM (subssb, qsub8);
BINARY_MM (subusb, uqsub8);
BINARY_DP (xorX, eor);

BINARY_MM (addw, sadd16);
BINARY_MM (addssw, qadd16);
BINARY_MM (addusw, uqadd16);

static void
arm_rule_maxsw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src1, src2);
}
static void
arm_rule_maxuw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_usub16 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src1, src2);
}
static void
arm_rule_minsw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_ssub16 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src2, src1);
}
static void
arm_rule_minuw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_usub16 (p, ORC_ARM_COND_AL, dest, src1, src2);
  orc_arm_emit_sel (p, ORC_ARM_COND_AL, dest, src2, src1);
}

static void
arm_rule_mullw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int loop = 1;

  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, src1, src2);

  if (loop == 2) {
    orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp, src1, src2);
    orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, dest, tmp, 16);
  }
}
static void
arm_rule_mulhsw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int loop = 1;

  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, src1, src2);
  if (loop == 1) {
    orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, ORC_ARM_ASR, 16);
  } else {
    orc_arm_emit_smultt (p, ORC_ARM_COND_AL, tmp, src1, src2);
    orc_arm_emit_pkhtb_s (p, ORC_ARM_COND_AL, dest, tmp, dest, 16);
  }
}
static void
arm_rule_mulhuw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_UW(mulhuw, "((orc_uint32)((uint16_t)%s) * (orc_uint32)((uint16_t)%s)) >> 16") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int loop = 1;

  /* extract first halves */
  orc_arm_emit_uxth (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_uxth (p, ORC_ARM_COND_AL, tmp2, src2);
  /* multiply, result should fit in the word */
  orc_arm_emit_mul (p, ORC_ARM_COND_AL, 0, dest, tmp1, tmp2);

  if (loop == 1) {
    orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, ORC_ARM_LSR, 16);
  } else {
    /* second halves */
    orc_arm_emit_uxth_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 16);
    orc_arm_emit_uxth_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 16);
    orc_arm_emit_mul (p, ORC_ARM_COND_AL, 0, tmp1, tmp1, tmp2);
    /* merge */
    orc_arm_emit_pkhtb_s (p, ORC_ARM_COND_AL, dest, tmp1, dest, 16);
  }
}
BINARY_MM (subw, ssub16);
BINARY_MM (subssw, qsub16);
BINARY_MM (subusw, uqsub16);

static void
arm_rule_absl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* reverse sign 0 - src1, assume the value is negative */
  orc_arm_emit_rsb_i (p, ORC_ARM_COND_AL, 1, dest, src1, 0);

  /* if we got negative, copy the original value again */
  orc_arm_emit_mov_r (p, ORC_ARM_COND_MI, 0, dest, src1);
}

BINARY_DP (addl, add);
BINARY_MM (addssl, qadd);
static void
arm_rule_addusl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* add numbers */
  orc_arm_emit_add_r (p, ORC_ARM_COND_AL, 1, dest, src1, src2);

  /* on overflow, move ffffffff */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_CS, 0, dest, 0);
}
static void
arm_rule_avgXl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* set the carry flag */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src1);

  /* src1 + src2 + 1 */
  orc_arm_emit_adc_r (p, ORC_ARM_COND_AL, 0, dest, src1, src2);

  /* rotate right, top bit is the carry */
  orc_arm_emit_mov_rrx (p, ORC_ARM_COND_AL, 0, dest, dest);
}
static void
arm_rule_cmpeql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* set to all 0 when not equal */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_NE, 0, dest, 0);

  /* set to all ff when equal */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_EQ, 0, dest, 0);
}
static void
arm_rule_cmpgtsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* set to all 0 when less or equal */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_LE, 0, dest, 0);

  /* set to all ff when greater */
  orc_arm_emit_mvn_i (p, ORC_ARM_COND_GT, 0, dest, 0);
}

static void
arm_rule_maxsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* conditionally move result */
  orc_arm_emit_mov_r (p, ORC_ARM_COND_GE, 0, dest, src1);
  orc_arm_emit_mov_r (p, ORC_ARM_COND_LT, 0, dest, src2);
}
static void
arm_rule_maxul (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* conditionally move result */
  orc_arm_emit_mov_r (p, ORC_ARM_COND_CS, 0, dest, src1);
  orc_arm_emit_mov_r (p, ORC_ARM_COND_CC, 0, dest, src2);
}
static void
arm_rule_minsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* conditionally move result */
  orc_arm_emit_mov_r (p, ORC_ARM_COND_GE, 0, dest, src2);
  orc_arm_emit_mov_r (p, ORC_ARM_COND_LT, 0, dest, src1);
}
static void
arm_rule_minul (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* compare */
  orc_arm_emit_cmp_r (p, ORC_ARM_COND_AL, src1, src2);

  /* conditionally move result */
  orc_arm_emit_mov_r (p, ORC_ARM_COND_CS, 0, dest, src2);
  orc_arm_emit_mov_r (p, ORC_ARM_COND_CC, 0, dest, src1);
}

static void
arm_rule_mulll (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_mul (p, ORC_ARM_COND_AL, 0, dest, src1, src2);
}
static void
arm_rule_mulhsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;

  orc_arm_emit_smull (p, ORC_ARM_COND_AL, 0, tmp, dest, src1, src2);
}
static void
arm_rule_mulhul (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;

  orc_arm_emit_umull (p, ORC_ARM_COND_AL, 0, tmp, dest, src1, src2);
}
static void
arm_rule_signl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;

  /* dest = 0 - src1 */
  orc_arm_emit_rsb_i (p, ORC_ARM_COND_AL, 0, dest, src1, 0);

  /* move src1 sign into tmp */
  orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, tmp, src1, ORC_ARM_ASR, 31);

  /* dest = tmp - (dest >> 31) */
  orc_arm_emit_sub_rsi (p, ORC_ARM_COND_AL, 0, dest, tmp, dest, ORC_ARM_ASR, 31);
}
BINARY_DP (subl, sub);
BINARY_MM (subssl, qsub);
static void
arm_rule_subusl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* subtract numbers */
  orc_arm_emit_sub_r (p, ORC_ARM_COND_AL, 1, dest, src1, src2);

  /* overflow, move 00000000 */
  orc_arm_emit_mov_i (p, ORC_ARM_COND_CC, 0, dest, 0);
}

static void
arm_rule_convsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  if (loop == 1) {
    /* single byte */
    orc_arm_emit_sxtb (p, ORC_ARM_COND_AL, dest, src1);
  } else {
    /* two bytes */
    orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, src1, src1, 8);
    orc_arm_emit_sxtb16 (p, ORC_ARM_COND_AL, dest, dest);
  }
}

static void
arm_rule_convubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  if (loop == 1) {
    /* single byte */
    orc_arm_emit_uxtb (p, ORC_ARM_COND_AL, dest, src1);
  } else {
    /* two bytes */
    orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, src1, src1, 8);
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
  }
}

static void
arm_rule_convswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_sxth (p, ORC_ARM_COND_AL, dest, src1);
}
static void
arm_rule_convuwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_uxth (p, ORC_ARM_COND_AL, dest, src1);
}

static void
arm_rule_convwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  if (loop == 2) {
    /* two words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, src1);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}

static void
arm_rule_convssswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  orc_arm_emit_ssat16 (p, ORC_ARM_COND_AL, dest, 8, src1);

  if (loop == 2) {
    /* two words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}
static void
arm_rule_convsuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  orc_arm_emit_usat16 (p, ORC_ARM_COND_AL, dest, 8, src1);

  if (loop == 2) {
    /* two words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}
static void
arm_rule_convusswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  /* sign bias */
  orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, src1, 0x00008000);
  if (loop == 2)
    orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, dest, 0x80000000);

  /* saturate to signed region */
  orc_arm_emit_usat16 (p, ORC_ARM_COND_AL, dest, 7, dest);

  if (loop == 2) {
    /* pack two words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}
static void
arm_rule_convuuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  /* sign bias */
  orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, src1, 0x00008000);
  if (loop == 2)
    orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, dest, 0x80000000);

  /* saturate to unsigned region */
  orc_arm_emit_usat16 (p, ORC_ARM_COND_AL, dest, 8, dest);

  if (loop == 2) {
    /* pack two words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}
static void
arm_rule_convlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* NOP */
}

static void
arm_rule_convssslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_ssat (p, ORC_ARM_COND_AL, dest, 16, src1);
}
static void
arm_rule_convsuslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_usat (p, ORC_ARM_COND_AL, dest, 16, src1);
}
static void
arm_rule_convusslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* sign bias */
  orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, src1, 0x80000000);
  /* saturate to signed region */
  orc_arm_emit_usat (p, ORC_ARM_COND_AL, dest, 15, dest);
}
static void
arm_rule_convuuslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  /* sign bias */
  orc_arm_emit_eor_i (p, ORC_ARM_COND_AL, 0, dest, src1, 0x80000000);
  /* saturate to unsigned region */
  orc_arm_emit_usat (p, ORC_ARM_COND_AL, dest, 16, dest);
}

static void
arm_rule_mulsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_BW(mulsbw, "%s * %s") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int loop = 1;

  /* first item */
  orc_arm_emit_sxtb16 (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_sxtb16 (p, ORC_ARM_COND_AL, tmp2, src2);
  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, tmp1, tmp2);

  if (loop > 1) {
    /* second item */
    orc_arm_emit_sxtb16_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 8);
    orc_arm_emit_sxtb16_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 8);
    orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);

    /* merge results */
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp1, ORC_ARM_LSL, 16);
  }
}

static void
arm_rule_mulubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_BW(mulubw, "(uint8_t)%s * (uint8_t)%s") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;
  int tmp2 = p->gp_tmpreg;
  int loop = 1;

  /* first item */
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp2, src2);
  orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, dest, tmp1, tmp2);

  if (loop > 1) {
    /* second item */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp1, src1, 8);
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, tmp2, src2, 8);
    orc_arm_emit_smulbb (p, ORC_ARM_COND_AL, tmp1, tmp1, tmp2);

    /* merge results */
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp1, ORC_ARM_LSL, 16);
  }
}

static void
arm_rule_mulswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_WL(mulswl, "%s * %s") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;

  orc_arm_emit_sxth (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_sxth (p, ORC_ARM_COND_AL, dest, src2);
  orc_arm_emit_mul (p, ORC_ARM_COND_AL, 0, dest, tmp1, dest);
}

static void
arm_rule_muluwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_WL(muluwl, "(uint16_t)%s * (uint16_t)%s") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp1 = p->tmpreg;

  orc_arm_emit_uxth (p, ORC_ARM_COND_AL, tmp1, src1);
  orc_arm_emit_uxth (p, ORC_ARM_COND_AL, dest, src2);
  orc_arm_emit_mul (p, ORC_ARM_COND_AL, 0, dest, tmp1, dest);
}

static void
arm_rule_mergewl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, src1, src2, 16);
}
static void
arm_rule_mergebw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* BINARY_BW(mergebw, "((uint8_t)%s) | ((uint8_t)%s << 8)") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = p->tmpreg;
  int loop = 1;

  if (loop == 1) {
    /* 1 word */
    orc_arm_emit_uxtb (p, ORC_ARM_COND_AL, dest, src1);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, src2, ORC_ARM_LSL, 8);
  } else {
    /* 2 words */
    orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, dest, src1, src1, 8);
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, dest);
    orc_arm_emit_pkhbt_s (p, ORC_ARM_COND_AL, tmp, src2, src2, 8);
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, tmp, tmp);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, tmp, ORC_ARM_LSL, 8);
  }
}

static void
arm_rule_select0wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* UNARY_WB(select0wb, "(uint16_t)%s & 0xff") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  if (loop == 1) {
    /* 1 words */
    /* NOP */
  } else {
    /* 2 words */
    orc_arm_emit_uxtb16 (p, ORC_ARM_COND_AL, dest, src1);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}

static void
arm_rule_select1wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* UNARY_WB(select1wb, "((uint16_t)%s >> 8)&0xff") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int loop = 1;

  if (loop == 1) {
    /* 1 words */
    orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSR, 8);
  } else {
    /* 2 words */
    orc_arm_emit_uxtb16_r8 (p, ORC_ARM_COND_AL, dest, src1, 8);
    orc_arm_emit_orr_rsi (p, ORC_ARM_COND_AL, 0, dest, dest, dest, ORC_ARM_LSR, 8);
  }
}
static void
arm_rule_select0lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* UNARY_LW(select0lw, "(orc_uint32)%s & 0xffff") */
  /* NOP */
}
static void
arm_rule_select1lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* UNARY_LW(select1lw, "((orc_uint32)%s >> 16)&0xffff") */
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_mov_rsi (p, ORC_ARM_COND_AL, 0, dest, src1, ORC_ARM_LSR, 16);
}

static void
arm_rule_swapw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_rev16 (p, ORC_ARM_COND_AL, dest, src1);
}

static void
arm_rule_swapl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  orc_arm_emit_rev (p, ORC_ARM_COND_AL, dest, src1);
}

#define FAIL if (0)

void
orc_compiler_orc_arm_register_rules (OrcTarget *target)
{
  OrcRuleSet *rule_set;

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target, 0);

  orc_rule_register (rule_set, "loadpb", arm_rule_loadpX, NULL);
  orc_rule_register (rule_set, "loadpw", arm_rule_loadpX, NULL);
  orc_rule_register (rule_set, "loadpl", arm_rule_loadpX, NULL);
  orc_rule_register (rule_set, "loadb", arm_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadw", arm_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadl", arm_rule_loadX, NULL);
  orc_rule_register (rule_set, "storeb", arm_rule_storeX, NULL);
  orc_rule_register (rule_set, "storew", arm_rule_storeX, NULL);
  orc_rule_register (rule_set, "storel", arm_rule_storeX, NULL);

  orc_rule_register (rule_set, "andb", arm_rule_andX, NULL);
  orc_rule_register (rule_set, "andnb", arm_rule_andnX, NULL);
  orc_rule_register (rule_set, "avgsb", arm_rule_avgX, (void *)3);
  orc_rule_register (rule_set, "avgub", arm_rule_avgX, (void *)0);
  orc_rule_register (rule_set, "copyb", arm_rule_copyX, NULL);
  orc_rule_register (rule_set, "orb", arm_rule_orX, NULL);
  orc_rule_register (rule_set, "xorb", arm_rule_xorX, NULL);

  orc_rule_register (rule_set, "andw", arm_rule_andX, NULL);
  orc_rule_register (rule_set, "andnw", arm_rule_andnX, NULL);
  FAIL orc_rule_register (rule_set, "avgsw", arm_rule_avgX, (void *)2);
  orc_rule_register (rule_set, "avguw", arm_rule_avgX, (void *)1);
  orc_rule_register (rule_set, "copyw", arm_rule_copyX, NULL);
  orc_rule_register (rule_set, "orw", arm_rule_orX, NULL);
  orc_rule_register (rule_set, "xorw", arm_rule_xorX, NULL);
  orc_rule_register (rule_set, "mullw", arm_rule_mullw, NULL);

  FAIL orc_rule_register (rule_set, "absl", arm_rule_absl, NULL);
  orc_rule_register (rule_set, "addl", arm_rule_addl, NULL);
  orc_rule_register (rule_set, "addssl", arm_rule_addssl, NULL);
  orc_rule_register (rule_set, "addusl", arm_rule_addusl, NULL);
  orc_rule_register (rule_set, "andl", arm_rule_andX, NULL);
  orc_rule_register (rule_set, "andnl", arm_rule_andnX, NULL);
  FAIL orc_rule_register (rule_set, "avgul", arm_rule_avgXl, NULL);
  FAIL orc_rule_register (rule_set, "avgsl", arm_rule_avgXl, NULL);
  orc_rule_register (rule_set, "copyl", arm_rule_copyX, NULL);
  orc_rule_register (rule_set, "maxsl", arm_rule_maxsl, NULL);
  orc_rule_register (rule_set, "maxul", arm_rule_maxul, NULL);
  orc_rule_register (rule_set, "minsl", arm_rule_minsl, NULL);
  orc_rule_register (rule_set, "minul", arm_rule_minul, NULL);
  orc_rule_register (rule_set, "mulll", arm_rule_mulll, NULL);
  orc_rule_register (rule_set, "mulhsl", arm_rule_mulhsl, NULL);
  FAIL orc_rule_register (rule_set, "mulhul", arm_rule_mulhul, NULL);
  orc_rule_register (rule_set, "orl", arm_rule_orX, NULL);
  FAIL orc_rule_register (rule_set, "signl", arm_rule_signl, NULL);
  orc_rule_register (rule_set, "subl", arm_rule_subl, NULL);
  FAIL orc_rule_register (rule_set, "subssl", arm_rule_subssl, NULL);
  orc_rule_register (rule_set, "subusl", arm_rule_subusl, NULL);
  orc_rule_register (rule_set, "xorl", arm_rule_xorX, NULL);

  FAIL orc_rule_register (rule_set, "convubw", arm_rule_convubw, NULL);
  FAIL orc_rule_register (rule_set, "convswl", arm_rule_convswl, NULL);
  FAIL orc_rule_register (rule_set, "convuwl", arm_rule_convuwl, NULL);
  orc_rule_register (rule_set, "convwb", arm_rule_convwb, NULL);
  orc_rule_register (rule_set, "convlw", arm_rule_convlw, NULL);

  FAIL orc_rule_register (rule_set, "mulubw", arm_rule_mulubw, NULL);
  FAIL orc_rule_register (rule_set, "mulswl", arm_rule_mulswl, NULL);
  FAIL orc_rule_register (rule_set, "muluwl", arm_rule_muluwl, NULL);

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_ARM_EDSP);

  FAIL orc_rule_register (rule_set, "absb", arm_rule_absX, (void *)0);
  orc_rule_register (rule_set, "cmpeqb", arm_rule_cmpeqX, (void *)1);
  orc_rule_register (rule_set, "cmpgtsb", arm_rule_cmpgtsX, (void *)1);
  FAIL orc_rule_register (rule_set, "maxsb", arm_rule_maxsb, NULL);
  FAIL orc_rule_register (rule_set, "maxub", arm_rule_maxub, NULL);
  FAIL orc_rule_register (rule_set, "minsb", arm_rule_minsb, NULL);
  FAIL orc_rule_register (rule_set, "minub", arm_rule_minub, NULL);
  orc_rule_register (rule_set, "shlb", arm_rule_shlX, (void *)1);
  FAIL orc_rule_register (rule_set, "shrsb", arm_rule_shrsX, (void *)1);
  FAIL orc_rule_register (rule_set, "shrub", arm_rule_shruX, (void *)1);
  FAIL orc_rule_register (rule_set, "signb", arm_rule_signX, (void *)0);

  FAIL orc_rule_register (rule_set, "absw", arm_rule_absX, (void *)1);
  orc_rule_register (rule_set, "cmpeqw", arm_rule_cmpeqX, (void *)2);
  orc_rule_register (rule_set, "cmpgtsw", arm_rule_cmpgtsX, (void *)2);
  FAIL orc_rule_register (rule_set, "maxsw", arm_rule_maxsw, NULL);
  FAIL orc_rule_register (rule_set, "maxuw", arm_rule_maxuw, NULL);
  FAIL orc_rule_register (rule_set, "minsw", arm_rule_minsw, NULL);
  FAIL orc_rule_register (rule_set, "minuw", arm_rule_minuw, NULL);
  orc_rule_register (rule_set, "mulsbw", arm_rule_mulsbw, NULL);
  orc_rule_register (rule_set, "shlw", arm_rule_shlX, (void *)2);
  FAIL orc_rule_register (rule_set, "shrsw", arm_rule_shrsX, (void *)2);
  orc_rule_register (rule_set, "shruw", arm_rule_shruX, (void *)2);
  FAIL orc_rule_register (rule_set, "signw", arm_rule_signX, (void *)1);
  orc_rule_register (rule_set, "mulhsw", arm_rule_mulhsw, NULL);
  FAIL orc_rule_register (rule_set, "mulhuw", arm_rule_mulhuw, NULL);

  orc_rule_register (rule_set, "cmpeql", arm_rule_cmpeql, NULL);
  orc_rule_register (rule_set, "cmpgtsl", arm_rule_cmpgtsl, NULL);
  orc_rule_register (rule_set, "shll", arm_rule_shlX, (void *)4);
  orc_rule_register (rule_set, "shrsl", arm_rule_shrsX, (void *)4);
  orc_rule_register (rule_set, "shrul", arm_rule_shruX, (void *)4);

  orc_rule_register (rule_set, "convsbw", arm_rule_convsbw, NULL);

  orc_rule_register (rule_set, "mergewl", arm_rule_mergewl, NULL);
  FAIL orc_rule_register (rule_set, "mergebw", arm_rule_mergebw, NULL);
  orc_rule_register (rule_set, "select0wb", arm_rule_select0wb, NULL);
  orc_rule_register (rule_set, "select1wb", arm_rule_select1wb, NULL);
  orc_rule_register (rule_set, "select0lw", arm_rule_select0lw, NULL);
  orc_rule_register (rule_set, "select1lw", arm_rule_select1lw, NULL);

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_ARM_ARM6);

  orc_rule_register (rule_set, "addb", arm_rule_addb, NULL);
  orc_rule_register (rule_set, "addssb", arm_rule_addssb, NULL);
  orc_rule_register (rule_set, "addusb", arm_rule_addusb, NULL);
  orc_rule_register (rule_set, "subb", arm_rule_subb, NULL);
  orc_rule_register (rule_set, "subssb", arm_rule_subssb, NULL);
  orc_rule_register (rule_set, "subusb", arm_rule_subusb, NULL);
  orc_rule_register (rule_set, "addw", arm_rule_addw, NULL);
  orc_rule_register (rule_set, "addssw", arm_rule_addssw, NULL);
  orc_rule_register (rule_set, "addusw", arm_rule_addusw, NULL);
  orc_rule_register (rule_set, "subw", arm_rule_subw, NULL);
  orc_rule_register (rule_set, "subssw", arm_rule_subssw, NULL);
  orc_rule_register (rule_set, "subusw", arm_rule_subusw, NULL);
  orc_rule_register (rule_set, "convsuswb", arm_rule_convsuswb, NULL);
  orc_rule_register (rule_set, "convssswb", arm_rule_convssswb, NULL);
  FAIL orc_rule_register (rule_set, "convusswb", arm_rule_convusswb, NULL);
  FAIL orc_rule_register (rule_set, "convuuswb", arm_rule_convuuswb, NULL);
  FAIL orc_rule_register (rule_set, "convssslw", arm_rule_convssslw, NULL);
  orc_rule_register (rule_set, "convsuslw", arm_rule_convsuslw, NULL);
  FAIL orc_rule_register (rule_set, "convusslw", arm_rule_convusslw, NULL);
  FAIL orc_rule_register (rule_set, "convuuslw", arm_rule_convuuslw, NULL);
  orc_rule_register (rule_set, "mullb", arm_rule_mullb, NULL);
  orc_rule_register (rule_set, "mulhsb", arm_rule_mulhsb, NULL);
  FAIL orc_rule_register (rule_set, "mulhub", arm_rule_mulhub, NULL);
  orc_rule_register (rule_set, "swapw", arm_rule_swapw, NULL);
  orc_rule_register (rule_set, "swapl", arm_rule_swapl, NULL);

}

