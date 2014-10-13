
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcpowerpc.h>
#include <orc/orcprogram.h>
#include <orc/orcdebug.h>



/* rules */

static void
powerpc_rule_loadpX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int size = ORC_PTR_TO_INT(user);

  if (src->vartype == ORC_VAR_TYPE_PARAM) {
    int greg = compiler->gp_tmpreg;

    powerpc_emit_addi (compiler,
        greg, POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, params[insn->src_args[0]]));
    ORC_ASM_CODE(compiler,"  lvewx %s, 0, %s\n",
        powerpc_get_regname (dest->alloc),
        powerpc_get_regname (greg));
    powerpc_emit_X (compiler, 0x7c00008e, powerpc_regnum(dest->alloc),
        0, powerpc_regnum(greg));

    ORC_ASM_CODE(compiler,"  lvsl %s, 0, %s\n",
        powerpc_get_regname (POWERPC_V0),
        powerpc_get_regname (greg));
    powerpc_emit_X (compiler, 0x7c00000c, powerpc_regnum(POWERPC_V0),
        0, powerpc_regnum(greg));

    powerpc_emit_vperm (compiler, dest->alloc, dest->alloc, dest->alloc,
        POWERPC_V0);
    switch (size) {
      case 1:
        ORC_ASM_CODE(compiler,"  vspltb %s, %s, 3\n",
            powerpc_get_regname (dest->alloc),
            powerpc_get_regname (dest->alloc));
        powerpc_emit_VX (compiler, 0x1000020c,
            powerpc_regnum(dest->alloc), 3, powerpc_regnum(dest->alloc));
        break;
      case 2:
        ORC_ASM_CODE(compiler,"  vsplth %s, %s, 1\n",
            powerpc_get_regname (dest->alloc),
            powerpc_get_regname (dest->alloc));
        powerpc_emit_VX (compiler, 0x1000024c,
            powerpc_regnum(dest->alloc), 1, powerpc_regnum(dest->alloc));
        break;
      case 4:
        ORC_ASM_CODE(compiler,"  vspltw %s, %s, 0\n",
            powerpc_get_regname (dest->alloc),
            powerpc_get_regname (dest->alloc));
        powerpc_emit_VX (compiler, 0x1000028c,
            powerpc_regnum(dest->alloc), 0, powerpc_regnum(dest->alloc));
        break;
    }
  } else {
    int value = src->value.i;

    switch (size) {
      case 1:
        if (value < 16 && value >= -16) {
          ORC_ASM_CODE(compiler,"  vspltisb %s, %d\n",
              powerpc_get_regname(dest->alloc), value&0x1f);
          powerpc_emit_VX(compiler, 0x1000030c,
              powerpc_regnum(dest->alloc), value & 0x1f, 0);
        } else {
          value &= 0xff;
          value |= value << 8;
          value |= value << 16;
          powerpc_load_long_constant (compiler, dest->alloc, value, value,
              value, value);
        }
        break;
      case 2:
        if (value < 16 && value >= -16) {
          ORC_ASM_CODE(compiler,"  vspltish %s, %d\n",
              powerpc_get_regname(dest->alloc), value&0x1f);
          powerpc_emit_VX(compiler, 0x1000034c,
              powerpc_regnum(dest->alloc), value & 0x1f, 0);
        } else {
          value &= 0xffff;
          value |= value << 16;
          powerpc_load_long_constant (compiler, dest->alloc, value, value,
              value, value);
        }
        break;
      case 4:
        if (value < 16 && value >= -16) {
          ORC_ASM_CODE(compiler,"  vspltisw %s, %d\n",
              powerpc_get_regname(dest->alloc), value&0x1f);
          powerpc_emit_VX(compiler, 0x1000038c,
              powerpc_regnum(dest->alloc), value & 0x1f, 0);
        } else {
          powerpc_load_long_constant (compiler, dest->alloc, value, value,
              value, value);
        }
        break;
    }
  }

}

static void
powerpc_rule_loadX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int size = src->size << compiler->loop_shift;
  int perm = orc_compiler_get_temp_reg (compiler);

  switch (size) {
    case 1:
      ORC_ASM_CODE(compiler,"  lvebx %s, 0, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00000e, powerpc_regnum(dest->alloc),
          0, powerpc_regnum(src->ptr_register));
      break;
    case 2:
      ORC_ASM_CODE(compiler,"  lvehx %s, 0, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00004e, powerpc_regnum(dest->alloc),
          0, powerpc_regnum(src->ptr_register));
      break;
    case 4:
      ORC_ASM_CODE(compiler,"  lvewx %s, 0, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00008e, powerpc_regnum(dest->alloc),
          0, powerpc_regnum(src->ptr_register));
      break;
    case 8:
    case 16:
      ORC_ASM_CODE(compiler,"  lvx %s, 0, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c0000ce, powerpc_regnum(dest->alloc),
          0, powerpc_regnum(src->ptr_register));
      break;
    default:
      ORC_COMPILER_ERROR(compiler,"bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }
  ORC_ASM_CODE(compiler,"  lvsl %s, 0, %s\n",
      powerpc_get_regname (perm),
      powerpc_get_regname (src->ptr_register));
  powerpc_emit_X (compiler, 0x7c00000c, powerpc_regnum(perm),
      0, powerpc_regnum(src->ptr_register));
  powerpc_emit_vperm (compiler, dest->alloc, dest->alloc, dest->alloc, perm);
}

static void
powerpc_rule_loadoffX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int size = src->size << compiler->loop_shift;
  int perm = orc_compiler_get_temp_reg (compiler);
  int offset;

  if (compiler->vars[insn->src_args[1]].vartype != ORC_VAR_TYPE_CONST) {
    ORC_COMPILER_ERROR(compiler, "Rule only works with consts");
    return;
  }

  offset = compiler->vars[insn->src_args[1]].value.i * src->size;
  powerpc_emit_addi (compiler, compiler->gp_tmpreg, POWERPC_R0, offset);
  switch (size) {
    case 1:
      ORC_ASM_CODE(compiler,"  lvebx %s, %s, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (compiler->gp_tmpreg),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00000e, powerpc_regnum(dest->alloc),
          powerpc_regnum(compiler->gp_tmpreg),
          powerpc_regnum(src->ptr_register));
      break;
    case 2:
      ORC_ASM_CODE(compiler,"  lvehx %s, %s, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (compiler->gp_tmpreg),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00004e, powerpc_regnum(dest->alloc),
          powerpc_regnum(compiler->gp_tmpreg),
          powerpc_regnum(src->ptr_register));
      break;
    case 4:
      ORC_ASM_CODE(compiler,"  lvewx %s, %s, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (compiler->gp_tmpreg),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c00008e, powerpc_regnum(dest->alloc),
          powerpc_regnum(compiler->gp_tmpreg),
          powerpc_regnum(src->ptr_register));
      break;
    case 8:
    case 16:
      ORC_ASM_CODE(compiler,"  lvx %s, %s, %s\n",
          powerpc_get_regname (dest->alloc),
          powerpc_get_regname (compiler->gp_tmpreg),
          powerpc_get_regname (src->ptr_register));
      powerpc_emit_X (compiler, 0x7c0000ce, powerpc_regnum(dest->alloc),
          powerpc_regnum(compiler->gp_tmpreg),
          powerpc_regnum(src->ptr_register));
      break;
    default:
      ORC_COMPILER_ERROR(compiler,"bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }
  ORC_ASM_CODE(compiler,"  lvsl %s, %s, %s\n",
      powerpc_get_regname (perm),
      powerpc_get_regname (compiler->gp_tmpreg),
      powerpc_get_regname (src->ptr_register));
  powerpc_emit_X (compiler, 0x7c00000c, powerpc_regnum(perm),
      powerpc_regnum(compiler->gp_tmpreg),
      powerpc_regnum(src->ptr_register));
  powerpc_emit_vperm (compiler, dest->alloc, dest->alloc, dest->alloc, perm);
}

static void
powerpc_rule_storeX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int size = dest->size << compiler->loop_shift;
  int perm = orc_compiler_get_temp_reg (compiler);
  int tmp = orc_compiler_get_temp_reg (compiler);

  ORC_ASM_CODE(compiler,"  lvsr %s, 0, %s\n",
      powerpc_get_regname (perm),
      powerpc_get_regname (dest->ptr_register));
  powerpc_emit_X (compiler, 0x7c00004c, powerpc_regnum(perm),
      0, powerpc_regnum(dest->ptr_register));

  powerpc_emit_vperm (compiler, tmp, src->alloc, src->alloc, perm);

  switch (size) {
    case 1:
      ORC_ASM_CODE(compiler,"  stvebx %s, 0, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c00010e,
          powerpc_regnum(tmp),
          0, powerpc_regnum(dest->ptr_register));
      break;
    case 2:
      ORC_ASM_CODE(compiler,"  stvehx %s, 0, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c00014e,
          powerpc_regnum(tmp),
          0, powerpc_regnum(dest->ptr_register));
      break;
    case 4:
      ORC_ASM_CODE(compiler,"  stvewx %s, 0, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c00018e,
          powerpc_regnum(tmp),
          0, powerpc_regnum(dest->ptr_register));
      break;
    case 8:
      ORC_ASM_CODE(compiler,"  stvewx %s, 0, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c00018e,
          powerpc_regnum(tmp),
          0, powerpc_regnum(dest->ptr_register));

      powerpc_emit_D (compiler, "addi", 0x38000000, compiler->gp_tmpreg,
          POWERPC_R0, 4);

      ORC_ASM_CODE(compiler,"  stvewx %s, %s, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (compiler->gp_tmpreg),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c00018e,
          powerpc_regnum(tmp),
          powerpc_regnum(compiler->gp_tmpreg),
          powerpc_regnum(dest->ptr_register));
      break;
    case 16:
      ORC_ASM_CODE(compiler,"  stvx %s, 0, %s\n",
          powerpc_get_regname (tmp),
          powerpc_get_regname (dest->ptr_register));
      powerpc_emit_X (compiler, 0x7c0001ce,
          powerpc_regnum(tmp),
          0, powerpc_regnum(dest->ptr_register));
      break;
    default:
      ORC_COMPILER_ERROR(compiler,"bad store size %d",
          dest->size << compiler->loop_shift);
      break;
  }
}



#define RULE(name, opcode, code) \
static void \
powerpc_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  int src1 = ORC_SRC_ARG (p, insn, 0); \
  int src2 = ORC_SRC_ARG (p, insn, 1); \
  int dest = ORC_DEST_ARG (p, insn, 0); \
  powerpc_emit_VX_2 (p, opcode, code , dest, src1, src2);\
}

#define RULE_SHIFT(name, opcode, code) \
static void \
powerpc_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  int src1 = ORC_SRC_ARG (p, insn, 0); \
  int src2 = ORC_SRC_ARG (p, insn, 1); \
  int dest = ORC_DEST_ARG (p, insn, 0); \
  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) { \
    ORC_ASM_CODE(p,"  vspltisb %s, %d\n", \
        powerpc_get_regname(p->tmpreg), (int)p->vars[insn->src_args[1]].value.i); \
    powerpc_emit_VX(p, 0x1000030c, \
        powerpc_regnum(p->tmpreg), (int)p->vars[insn->src_args[1]].value.i, 0); \
    powerpc_emit_VX_2 (p, opcode, code , dest, src1, p->tmpreg);\
  } else { \
    powerpc_emit_VX_2 (p, opcode, code , dest, src1, src2);\
  } \
}

RULE(addb, "vaddubm", 0x10000000)
RULE(addssb, "vaddsbs", 0x10000300)
RULE(addusb, "vaddubs", 0x10000200)
RULE(andb, "vand", 0x10000404)
/* RULE(andnb, "vandc", 0x10000444) */
RULE(avgsb, "vavgsb", 0x10000502)
RULE(avgub, "vavgub", 0x10000402)
RULE(cmpeqb, "vcmpequb", 0x10000006)
RULE(cmpgtsb, "vcmpgtsb", 0x10000306)
RULE(maxsb, "vmaxsb", 0x10000102)
RULE(maxub, "vmaxub", 0x10000002)
RULE(minsb, "vminsb", 0x10000302)
RULE(minub, "vminub", 0x10000202)
RULE(orb, "vor", 0x10000484)
RULE_SHIFT(shlb, "vslb", 0x10000104)
RULE_SHIFT(shrsb, "vsrab", 0x10000304)
RULE_SHIFT(shrub, "vsrb", 0x10000204)
RULE(subb, "vsububm", 0x10000400)
RULE(subssb, "vsubsbs", 0x10000700)
RULE(subusb, "vsububs", 0x10000600)
RULE(xorb, "vxor", 0x100004c4)

RULE(addw, "vadduhm", 0x10000040)
RULE(addssw, "vaddshs", 0x10000340)
RULE(addusw, "vadduhs", 0x10000240)
RULE(andw, "vand", 0x10000404)
/* RULE(andnw, "vandc", 0x10000444) */
RULE(avgsw, "vavgsh", 0x10000542)
RULE(avguw, "vavguh", 0x10000442)
RULE(cmpeqw, "vcmpequh", 0x10000046)
RULE(cmpgtsw, "vcmpgtsh", 0x10000346)
RULE(maxsw, "vmaxsh", 0x10000142)
RULE(maxuw, "vmaxuh", 0x10000042)
RULE(minsw, "vminsh", 0x10000342)
RULE(minuw, "vminuh", 0x10000242)
RULE(orw, "vor", 0x10000484)
RULE_SHIFT(shlw, "vslh", 0x10000144)
RULE_SHIFT(shrsw, "vsrah", 0x10000344)
RULE_SHIFT(shruw, "vsrh", 0x10000244)
RULE(subw, "vsubuhm", 0x10000440)
RULE(subssw, "vsubshs", 0x10000740)
RULE(subusw, "vsubuhs", 0x10000640)
RULE(xorw, "vxor", 0x100004c4)

RULE(addl, "vadduwm", 0x10000080)
RULE(addssl, "vaddsws", 0x10000380)
RULE(addusl, "vadduws", 0x10000280)
RULE(andl, "vand", 0x10000404)
/* RULE(andnl, "vandc", 0x10000444) */
RULE(avgsl, "vavgsw", 0x10000582)
RULE(avgul, "vavguw", 0x10000482)
RULE(cmpeql, "vcmpequw", 0x10000086)
RULE(cmpgtsl, "vcmpgtsw", 0x10000386)
RULE(maxsl, "vmaxsw", 0x10000182)
RULE(maxul, "vmaxuw", 0x10000082)
RULE(minsl, "vminsw", 0x10000382)
RULE(minul, "vminuw", 0x10000282)
RULE(orl, "vor", 0x10000484)
RULE_SHIFT(shll, "vslw", 0x10000184)
RULE_SHIFT(shrsl, "vsraw", 0x10000384)
RULE_SHIFT(shrul, "vsrw", 0x10000284)
RULE(subl, "vsubuwm", 0x10000480)
RULE(subssl, "vsubsws", 0x10000780)
RULE(subusl, "vsubuws", 0x10000680)
RULE(xorl, "vxor", 0x100004c4)

RULE(andq, "vand", 0x10000404)
RULE(orq, "vor", 0x10000484)
RULE(xorq, "vxor", 0x100004c4)

RULE(addf, "vaddfp", 0x1000000a)
RULE(subf, "vsubfp", 0x1000004a)
RULE(maxf, "vmaxfp", 0x1000040a)
RULE(minf, "vminfp", 0x1000044a)
RULE(cmpeqf, "vcmpeqfp", 0x100000c6)

static void
powerpc_rule_andnX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vandc (p, dest, src2, src1);
}

static void
powerpc_rule_copyX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vor (p, dest, src1, src1);
}

static void
powerpc_rule_mullb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmulesb (p, dest, src1, src2);
  powerpc_emit_vsldoi (p, dest, dest, dest, 1);
}

static void
powerpc_rule_mulhsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmulesb (p, dest, src1, src2);
}

static void
powerpc_rule_mulhub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmuleub (p, dest, src1, src2);
}

static void
powerpc_rule_mulhsw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmulesh (p, dest, src1, src2);
}

static void
powerpc_rule_mulhuw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmuleuh (p, dest, src1, src2);
}

static void
powerpc_rule_mullw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = POWERPC_V0;

  powerpc_emit_vxor (p, tmp, tmp, tmp);
  powerpc_emit_vmladduhm (p, dest, src1, src2, POWERPC_V0);
}

static void
powerpc_rule_convsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vupkhsb (p, dest, src1);
}

static void
powerpc_rule_convswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vupkhsh (p, dest, src1);
}

static void
powerpc_rule_convubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int reg = powerpc_get_constant (p, ORC_CONST_ZERO, 0);
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmrghb (p, dest, reg, src1);
}

static void
powerpc_rule_convuwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int reg = powerpc_get_constant (p, ORC_CONST_ZERO, 0);
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmrghh (p, dest, reg, src1);
}

static void
powerpc_rule_convssswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkshss (p, dest, src1, src1);
}

static void
powerpc_rule_convssslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkswss (p, dest, src1, src1);
}

static void
powerpc_rule_convsuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkshus (p, dest, src1, src1);
}

static void
powerpc_rule_convsuslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkswus (p, dest, src1, src1);
}

static void
powerpc_rule_convuuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuhus (p, dest, src1, src1);
}

static void
powerpc_rule_convuuslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuwus (p, dest, src1, src1);
}

static void
powerpc_rule_convwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuhum (p, dest, src1, src1);
}

static void
powerpc_rule_convlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuwum (p, dest, src1, src1);
}

static void
powerpc_rule_mulsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmulesb (p, dest, src1, src2);
}

static void
powerpc_rule_mulubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmuleub (p, dest, src1, src2);
}

static void
powerpc_rule_mulswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmulesh (p, dest, src1, src2);
}

static void
powerpc_rule_muluwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmuleuh (p, dest, src1, src2);
}

static void
powerpc_rule_accw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vadduhm (p, dest, dest, src1);
}

static void
powerpc_rule_accl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vadduwm (p, dest, dest, src1);
}

static void
powerpc_rule_accsadubl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int tmp1 = p->tmpreg;
  int tmp2 = POWERPC_V31;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vmaxub (p, tmp1, src1, src2);
  powerpc_emit_vminub (p, tmp2, src1, src2);

  powerpc_emit_vsububm (p, tmp1, tmp1, tmp2);
  if (p->loop_shift == 0) {
    powerpc_emit_vxor (p, tmp2, tmp2, tmp2);
    powerpc_emit_vmrghb (p, tmp1, tmp2, tmp1);
    powerpc_emit_vmrghh (p, tmp1, tmp2, tmp1);
    powerpc_emit_vadduwm (p, dest, dest, tmp1);
  } else if (p->loop_shift == 1) {
    powerpc_emit_vxor (p, tmp2, tmp2, tmp2);
    powerpc_emit_vmrghh (p, tmp1, tmp2, tmp1);
    powerpc_emit_vsum4ubs (p, dest, dest, tmp1);
  } else {
    powerpc_emit_vsum4ubs (p, dest, dest, tmp1);
  }
}

static void
powerpc_rule_signb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int reg;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_B, 1);
  powerpc_emit_vminsb (p, dest, src1, reg);
  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_B, -1);
  powerpc_emit_vmaxsb (p, dest, dest, reg);
}

static void
powerpc_rule_signw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int reg;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_W, 1);
  powerpc_emit_vminsh(p, dest, src1, reg);
  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_W, -1);
  powerpc_emit_vmaxsh(p, dest, dest, reg);
}

static void
powerpc_rule_signl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int reg;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 1);
  powerpc_emit_vminsw (p, dest, src1, reg);
  reg = powerpc_get_constant (p, ORC_CONST_SPLAT_L, -1);
  powerpc_emit_vmaxsw (p, dest, dest, reg);
}

static void
powerpc_rule_select1wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuhum (p, dest, src1, src1);
}

static void
powerpc_rule_select0wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00020406, 0x080a0c0e,
      0x00020406, 0x080a0c0e);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_select1lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_vpkuwum (p, dest, src1, src1);
}

static void
powerpc_rule_select0lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00010405, 0x08090c0d,
      0x10111415, 0x18191c1d);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_select1ql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x04050607, 0x0c0d0e0f,
		  0x14151617, 0x1c1d1e1f);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_select0ql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00010203, 0x08090a0b,
		  0x10111213, 0x18191a1b);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_mergebw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00100111, 0x02120313,
      0x04140515, 0x06160717);
  powerpc_emit_vperm (p, dest, src1, src2, perm);
}

static void
powerpc_rule_mergewl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00011011, 0x02031213,
      0x04051415, 0x06071617);
  powerpc_emit_vperm (p, dest, src1, src2, perm);
}

static void
powerpc_rule_mergelq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00010203, 0x10111213,
      0x04050607, 0x14151617);
  powerpc_emit_vperm (p, dest, src1, src2, perm);
}

static void
powerpc_rule_absb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int tmpc;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp;

  tmpc = powerpc_get_constant (p, ORC_CONST_SPLAT_B, 0);
  if (src1 != dest) {
    tmp = dest;
  } else {
    tmp = orc_compiler_get_temp_reg (p);
  }
  powerpc_emit_VX_2 (p, "vsububm", 0x10000400, tmp, tmpc, src1);
  powerpc_emit_vminub (p, dest, tmp, src1);
}

static void
powerpc_rule_absw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int tmp;
  int tmpc;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  tmpc = powerpc_get_constant (p, ORC_CONST_SPLAT_W, 0);
  if (src1 != dest) {
    tmp = dest;
  } else {
    tmp = orc_compiler_get_temp_reg (p);
  }
  powerpc_emit_VX_2 (p, "vsubuhm", 0x10000440, tmp, tmpc, src1);
  powerpc_emit_VX_2 (p, "vminuh", 0x10000242, dest, tmp, src1);
}

static void
powerpc_rule_absl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int tmp;
  int tmpc;
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  tmpc = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0);
  if (src1 != dest) {
    tmp = dest;
  } else {
    tmp = orc_compiler_get_temp_reg (p);
  }
  powerpc_emit_VX_2 (p, "vsubuwm", 0x10000480, tmp, tmpc, src1);
  powerpc_emit_VX_2 (p, "vminuw", 0x10000282, dest, tmp, src1);
}

static void
powerpc_rule_splatw3q (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00010001, 0x00010001,
      0x08090809, 0x08090809);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_splatbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_VX_2 (p, "vmrghb", 0x1000000c, dest, src1, src1);
}

static void
powerpc_rule_splatbl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
#if 0
  int perm;

  perm = powerpc_get_constant_full (p, 0x00000000, 0x01010101,
      0x02020202, 0x03030303);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
#else
  powerpc_emit_VX_2 (p, "vmrghb", 0x1000000c, dest, src1, src1);
  powerpc_emit_VX_2 (p, "vmrghh", 0x1000004c, dest, dest, dest);
#endif
}

static void
powerpc_rule_convulq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;
  int zero;

  zero = powerpc_get_constant (p, ORC_CONST_SPLAT_B, 0);
  perm = powerpc_get_constant_full (p, 0x10101010, 0x00010203,
      0x10101010, 0x04050607);
  powerpc_emit_vperm (p, dest, src1, zero, perm);
}

static void
powerpc_rule_convslq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;
  int tmp = orc_compiler_get_temp_reg (p);

  ORC_ASM_CODE(p,"  vspltisb %s, -1\n", powerpc_get_regname(tmp));
  powerpc_emit_VX(p, 0x1000030c, powerpc_regnum(tmp), 0x1f, 0);

  powerpc_emit_VX_2 (p, "vsraw", 0x10000384, tmp, src1, tmp);

  perm = powerpc_get_constant_full (p, 0x10101010, 0x00010203,
      0x10101010, 0x04050607);
  powerpc_emit_vperm (p, dest, src1, tmp, perm);
}

static void
powerpc_rule_convhwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00020406, 0x080a0c0e,
      0x10121416, 0x181a1c1e);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_convhlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x00010405, 0x08090c0d,
      0x10111415, 0x18191c1d);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_convql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x04050607, 0x0c0d0e0f,
      0x14151617, 0x1c1d1e1f);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_swapw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x01000302, 0x05040706,
      0x09080b0a, 0x0d0c0f0e);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_swapl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x03020100, 0x07060504,
      0x0b0a0908, 0x0f0e0d0c);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_swapwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x02030001, 0x06070405,
      0x0a0b0809, 0x0e0f0c0d);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_swaplq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x04050607, 0x00010203,
      0x0c0d0e0f, 0x08090a0b);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_swapq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int perm;

  perm = powerpc_get_constant_full (p, 0x07060504, 0x03020100,
      0x0f0e0d0c, 0x0b0a0908);
  powerpc_emit_vperm (p, dest, src1, src1, perm);
}

static void
powerpc_rule_splitql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest1 = ORC_DEST_ARG (p, insn, 0);
  int dest2 = ORC_DEST_ARG (p, insn, 1);
  int perm;

  perm = powerpc_get_constant_full (p, 0x04050607, 0x0c0d0e0f,
		  0x14151617, 0x1c1d1e1f);
  powerpc_emit_vperm (p, dest1, src1, src1, perm);
  perm = powerpc_get_constant_full (p, 0x00010203, 0x08090a0b,
		  0x10111213, 0x18191a1b);
  powerpc_emit_vperm (p, dest2, src1, src1, perm);
}

static void
powerpc_rule_splitlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest1 = ORC_DEST_ARG (p, insn, 0);
  int dest2 = ORC_DEST_ARG (p, insn, 1);
  int perm;

  powerpc_emit_vpkuwum (p, dest1, src1, src1);
  perm = powerpc_get_constant_full (p, 0x00010405, 0x08090c0d,
		  0x10111415, 0x18191c1d);
  powerpc_emit_vperm (p, dest2, src1, src1, perm);
}

static void
powerpc_rule_splitwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest1 = ORC_DEST_ARG (p, insn, 0);
  int dest2 = ORC_DEST_ARG (p, insn, 1);
  int perm;

  powerpc_emit_vpkuhum (p, dest1, src1, src1);
  perm = powerpc_get_constant_full (p, 0x00020406, 0x080a0c0e,
		  0x10121416, 0x181a1c1e);
  powerpc_emit_vperm (p, dest2, src1, src1, perm);
}

static void
powerpc_rule_mulf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp;

  tmp = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0x80000000);
  powerpc_emit_VA_acb (p, "vmaddfp", 0x1000002e, dest, src1, tmp, src2);
}

static void
powerpc_rule_divf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int y = orc_compiler_get_temp_reg (p);
  int t = orc_compiler_get_temp_reg (p);
  int c1;
  int c0;

  c1 = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0x3f800000); /* 1.0 */

  powerpc_emit_VX_db (p, "vrefp", 0x1000010a, y, src2);

  powerpc_emit_VA_acb (p, "vnmsubfp", 0x1000002f, t, y, c1, src2);
  powerpc_emit_VA_acb (p, "vmaddfp", 0x1000002e, y, y, y, t);

  c0 = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0x00000000); /* 0.0 */
  powerpc_emit_VA_acb (p, "vmaddfp", 0x1000002e, dest, y, c0, src1);
}

static void
powerpc_rule_cmpltf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_VXR (p, "vcmpgtfp", 0x100002c6, dest, src2, src1, FALSE);
}

static void
powerpc_rule_cmplef (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int src2 = ORC_SRC_ARG (p, insn, 1);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_VXR (p, "vcmpgefp", 0x100001c6, dest, src2, src1, FALSE);
}

static void
powerpc_rule_convfl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = orc_compiler_get_temp_reg (p);
  int tmpc;
  int tmpc2;

  if (p->target_flags & ORC_TARGET_FAST_NAN) {
    powerpc_emit_VX_dbi (p, "vctsxs", 0x100003ca, dest, src1, 0);
  } else {
    /* This changes NANs into infinities of the same sign */
    tmpc = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0x7f800000);
    tmpc2 = powerpc_get_constant (p, ORC_CONST_SPLAT_L, 0x007fffff);
    powerpc_emit_VX_2 (p, "vand", 0x10000404, tmp, tmpc, src1);
    powerpc_emit_VX_2 (p, "vcmpequw", 0x10000086, tmp, tmp, tmpc);
    powerpc_emit_VX_2 (p, "vand", 0x10000404, tmp, tmp, tmpc2);
    powerpc_emit_vandc (p, tmp, src1, tmp);
    powerpc_emit_VX_dbi (p, "vctsxs", 0x100003ca, dest, tmp, 0);
  }
}

static void
powerpc_rule_convlf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);

  powerpc_emit_VX_dbi (p, "vcfsx", 0x1000034a, dest, src1, 0);
}

static void
powerpc_rule_div255w (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = ORC_SRC_ARG (p, insn, 0);
  int dest = ORC_DEST_ARG (p, insn, 0);
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);
  int tmpc;

  tmpc = powerpc_get_constant (p, ORC_CONST_SPLAT_W, 0x0080);
  powerpc_emit_VX_2 (p, "vadduhm", 0x10000040, dest, src1, tmpc);

  ORC_ASM_CODE(p,"  vspltish %s, 8\n", powerpc_get_regname(tmp2));
  powerpc_emit_VX(p, 0x1000034c, powerpc_regnum(tmp2), 8, 0);

  powerpc_emit_VX_2 (p, "vsrh", 0x10000244, tmp, dest, tmp2);
  powerpc_emit_VX_2 (p, "vadduhm", 0x10000040, dest, dest, tmp);
  powerpc_emit_VX_2 (p, "vsrh", 0x10000244, dest, dest, tmp2);
}

void
orc_compiler_powerpc_register_rules (OrcTarget *target)
{
  OrcRuleSet *rule_set;

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target, 0);

#define REG(name) \
  orc_rule_register (rule_set, #name , powerpc_rule_ ## name , NULL);

  REG(addb);
  REG(addssb);
  REG(addusb);
  REG(andb);
  REG(avgsb);
  REG(avgub);
  REG(cmpeqb);
  REG(cmpgtsb);
  REG(maxsb);
  REG(maxub);
  REG(minsb);
  REG(minub);
  REG(orb);
  REG(shlb);
  REG(shrsb);
  REG(shrub);
  REG(subb);
  REG(subssb);
  REG(subusb);
  REG(xorb);

  REG(addw);
  REG(addssw);
  REG(addusw);
  REG(andw);
  REG(avgsw);
  REG(avguw);
  REG(cmpeqw);
  REG(cmpgtsw);
  REG(maxsw);
  REG(maxuw);
  REG(minsw);
  REG(minuw);
  REG(orw);
  REG(shlw);
  REG(shrsw);
  REG(shruw);
  REG(subw);
  REG(subssw);
  REG(subusw);
  REG(xorw);

  REG(addl);
  REG(addssl);
  REG(addusl);
  REG(andl);
  REG(avgsl);
  REG(avgul);
  REG(cmpeql);
  REG(cmpgtsl);
  REG(maxsl);
  REG(maxul);
  REG(minsl);
  REG(minul);
  REG(orl);
  REG(shll);
  REG(shrsl);
  REG(shrul);
  REG(subl);
  REG(subssl);
  REG(subusl);
  REG(xorl);

  REG(andq);
  REG(orq);
  REG(xorq);

  REG(mullb);
  REG(mulhsb);
  REG(mulhub);
  REG(mullw);
  REG(mulhsw);
  REG(mulhuw);

  REG(convsbw);
  REG(convswl);
  REG(convubw);
  REG(convuwl);
  REG(convssswb);
  REG(convssslw);
  REG(convsuswb);
  REG(convsuslw);
  REG(convuuswb);
  REG(convuuslw);
  REG(convwb);
  REG(convlw);

  REG(mulsbw);
  REG(mulubw);
  REG(mulswl);
  REG(muluwl);

  REG(accw);
  REG(accl);
  REG(accsadubl);

  REG(signb);
  REG(signw);
  REG(signl);

  REG(select0wb);
  REG(select1wb);
  REG(select0lw);
  REG(select1lw);
  REG(select0ql);
  REG(select1ql);
  REG(mergebw);
  REG(mergewl);
  REG(mergelq);

  REG(absb);
  REG(absw);
  REG(absl);
  REG(splatw3q);
  REG(splatbw);
  REG(splatbl);
  REG(convslq);
  REG(convulq);
  REG(convhwb);
  REG(convhlw);
  REG(convql);
  REG(swapw);
  REG(swapl);
  REG(swapwl);
  REG(swapq);
  REG(swaplq);
  if (0) REG(splitql);
  REG(splitlw);
  REG(splitwb);
  REG(div255w);

  REG(addf);
  REG(subf);
  REG(minf);
  REG(maxf);
  REG(cmpeqf);
  REG(cmplef);
  REG(cmpltf);
  REG(mulf);
  if (0) REG(divf); /* not accurate enough */
  REG(convfl);
  REG(convlf);

  orc_rule_register (rule_set, "loadpb", powerpc_rule_loadpX, (void *)1);
  orc_rule_register (rule_set, "loadpw", powerpc_rule_loadpX, (void *)2);
  orc_rule_register (rule_set, "loadpl", powerpc_rule_loadpX, (void *)4);
  orc_rule_register (rule_set, "loadb", powerpc_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadw", powerpc_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadl", powerpc_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadq", powerpc_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadoffb", powerpc_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "loadoffw", powerpc_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "loadoffl", powerpc_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "storeb", powerpc_rule_storeX, NULL);
  orc_rule_register (rule_set, "storew", powerpc_rule_storeX, NULL);
  orc_rule_register (rule_set, "storel", powerpc_rule_storeX, NULL);
  orc_rule_register (rule_set, "storeq", powerpc_rule_storeX, NULL);

  orc_rule_register (rule_set, "andnb", powerpc_rule_andnX, NULL);
  orc_rule_register (rule_set, "andnw", powerpc_rule_andnX, NULL);
  orc_rule_register (rule_set, "andnl", powerpc_rule_andnX, NULL);
  orc_rule_register (rule_set, "andnq", powerpc_rule_andnX, NULL);

  orc_rule_register (rule_set, "copyb", powerpc_rule_copyX, NULL);
  orc_rule_register (rule_set, "copyw", powerpc_rule_copyX, NULL);
  orc_rule_register (rule_set, "copyl", powerpc_rule_copyX, NULL);
  orc_rule_register (rule_set, "copyq", powerpc_rule_copyX, NULL);

}

