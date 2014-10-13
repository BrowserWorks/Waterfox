
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcx86.h>
#include <orc/orcdebug.h>
#include <orc/orcutils.h>
#include <orc/orcx86insn.h>
#include <orc/orcsse.h>


/**
 * SECTION:orcx86
 * @title: x86
 * @short_description: code generation for x86
 */

const char *
orc_x86_get_regname(int i)
{
  static const char *x86_regs[] = {
    "eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi",
    "r8d", "r9d", "r10d", "r11d", "r12d", "r13d", "r14d", "r15d" };

  if (i>=ORC_GP_REG_BASE && i<ORC_GP_REG_BASE + 16) return x86_regs[i - ORC_GP_REG_BASE];
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}

int
orc_x86_get_regnum(int i)
{
  return (i&0xf);
}

const char *
orc_x86_get_regname_8(int i)
{
  static const char *x86_regs[] = { "al", "cl", "dl", "bl",
    "ah", "ch", "dh", "bh" };

  if (i>=ORC_GP_REG_BASE && i<ORC_GP_REG_BASE + 8) return x86_regs[i - ORC_GP_REG_BASE];
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}

const char *
orc_x86_get_regname_16(int i)
{
  static const char *x86_regs[] = { "ax", "cx", "dx", "bx",
    "sp", "bp", "si", "di" };

  if (i>=ORC_GP_REG_BASE && i<ORC_GP_REG_BASE + 8) return x86_regs[i - ORC_GP_REG_BASE];
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}

const char *
orc_x86_get_regname_64(int i)
{
  static const char *x86_regs[] = {
    "rax", "rcx", "rdx", "rbx", "rsp", "rbp", "rsi", "rdi",
    "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15" };

  if (i>=ORC_GP_REG_BASE && i<ORC_GP_REG_BASE + 16) return x86_regs[i - ORC_GP_REG_BASE];
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}

const char *
orc_x86_get_regname_ptr(OrcCompiler *compiler, int i)
{
  if (compiler->is_64bit) {
    return orc_x86_get_regname_64 (i);
  } else {
    return orc_x86_get_regname (i);
  }
}

const char *
orc_x86_get_regname_size(int i, int size)
{
  switch (size) {
    case 1:
      return orc_x86_get_regname_8 (i);
    case 2:
      return orc_x86_get_regname_16 (i);
    case 4:
      return orc_x86_get_regname (i);
    case 8:
      return orc_x86_get_regname_64 (i);
  }
  return NULL;
}

void
orc_x86_emit_push (OrcCompiler *compiler, int size, int reg)
{
  orc_x86_emit_cpuinsn_size (compiler, ORC_X86_push, 0, reg, reg);
}

void
orc_x86_emit_pop (OrcCompiler *compiler, int size, int reg)
{
  orc_x86_emit_cpuinsn_size (compiler, ORC_X86_pop, 0, reg, reg);
}

#define X86_MODRM(mod, rm, reg) ((((mod)&3)<<6)|(((rm)&7)<<0)|(((reg)&7)<<3))
#define X86_SIB(ss, ind, reg) ((((ss)&3)<<6)|(((ind)&7)<<3)|((reg)&7))

void
orc_x86_emit_modrm_memoffset_old (OrcCompiler *compiler, int reg1, int offset, int reg2)
{
  if (offset == 0 && reg2 != compiler->exec_reg) {
    if (reg2 == X86_ESP) {
      *compiler->codeptr++ = X86_MODRM(0, 4, reg1);
      *compiler->codeptr++ = X86_SIB(0, 4, reg2);
    } else {
      *compiler->codeptr++ = X86_MODRM(0, reg2, reg1);
    }
  } else if (offset >= -128 && offset < 128) {
    *compiler->codeptr++ = X86_MODRM(1, reg2, reg1);
    if (reg2 == X86_ESP) {
      *compiler->codeptr++ = X86_SIB(0, 4, reg2);
    }
    *compiler->codeptr++ = (offset & 0xff);
  } else {
    *compiler->codeptr++ = X86_MODRM(2, reg2, reg1);
    if (reg2 == X86_ESP) {
      *compiler->codeptr++ = X86_SIB(0, 4, reg2);
    }
    *compiler->codeptr++ = (offset & 0xff);
    *compiler->codeptr++ = ((offset>>8) & 0xff);
    *compiler->codeptr++ = ((offset>>16) & 0xff);
    *compiler->codeptr++ = ((offset>>24) & 0xff);
  }
}

void
orc_x86_emit_modrm_memoffset (OrcCompiler *compiler, int offset, int src, int dest)
{
  if (offset == 0 && src != compiler->exec_reg) {
    if (src == X86_ESP) {
      *compiler->codeptr++ = X86_MODRM(0, 4, dest);
      *compiler->codeptr++ = X86_SIB(0, 4, src);
    } else {
      *compiler->codeptr++ = X86_MODRM(0, src, dest);
    }
  } else if (offset >= -128 && offset < 128) {
    *compiler->codeptr++ = X86_MODRM(1, src, dest);
    if (src == X86_ESP) {
      *compiler->codeptr++ = X86_SIB(0, 4, src);
    }
    *compiler->codeptr++ = (offset & 0xff);
  } else {
    *compiler->codeptr++ = X86_MODRM(2, src, dest);
    if (src == X86_ESP) {
      *compiler->codeptr++ = X86_SIB(0, 4, src);
    }
    *compiler->codeptr++ = (offset & 0xff);
    *compiler->codeptr++ = ((offset>>8) & 0xff);
    *compiler->codeptr++ = ((offset>>16) & 0xff);
    *compiler->codeptr++ = ((offset>>24) & 0xff);
  }
}

void orc_x86_emit_modrm_memindex (OrcCompiler *compiler, int reg1, int offset,
    int reg2, int regindex, int shift)
{
  if (offset == 0) {
    *compiler->codeptr++ = X86_MODRM(0, 4, reg1);
    *compiler->codeptr++ = X86_SIB(shift, regindex, reg2);
  } else if (offset >= -128 && offset < 128) {
    *compiler->codeptr++ = X86_MODRM(1, 4, reg1);
    *compiler->codeptr++ = X86_SIB(shift, regindex, reg2);
    *compiler->codeptr++ = (offset & 0xff);
  } else {
    *compiler->codeptr++ = X86_MODRM(2, 4, reg1);
    *compiler->codeptr++ = X86_SIB(shift, regindex, reg2);
    *compiler->codeptr++ = (offset & 0xff);
    *compiler->codeptr++ = ((offset>>8) & 0xff);
    *compiler->codeptr++ = ((offset>>16) & 0xff);
    *compiler->codeptr++ = ((offset>>24) & 0xff);
  }
}

void orc_x86_emit_modrm_memindex2 (OrcCompiler *compiler, int offset,
    int src, int src_index, int shift, int dest)
{
  if (offset == 0) {
    *compiler->codeptr++ = X86_MODRM(0, 4, dest);
    *compiler->codeptr++ = X86_SIB(shift, src_index, src);
  } else if (offset >= -128 && offset < 128) {
    *compiler->codeptr++ = X86_MODRM(1, 4, dest);
    *compiler->codeptr++ = X86_SIB(shift, src_index, src);
    *compiler->codeptr++ = (offset & 0xff);
  } else {
    *compiler->codeptr++ = X86_MODRM(2, 4, dest);
    *compiler->codeptr++ = X86_SIB(shift, src_index, src);
    *compiler->codeptr++ = (offset & 0xff);
    *compiler->codeptr++ = ((offset>>8) & 0xff);
    *compiler->codeptr++ = ((offset>>16) & 0xff);
    *compiler->codeptr++ = ((offset>>24) & 0xff);
  }
}

void
orc_x86_emit_modrm_reg (OrcCompiler *compiler, int reg1, int reg2)
{
  *compiler->codeptr++ = X86_MODRM(3, reg1, reg2);
}

void
orc_x86_emit_rex (OrcCompiler *compiler, int size, int reg1, int reg2, int reg3)
{
  int rex = 0x40;

  if (compiler->is_64bit) {
    if (size >= 8) rex |= 0x08;
    if (reg1 & 8) rex |= 0x4;
    if (reg2 & 8) rex |= 0x2;
    if (reg3 & 8) rex |= 0x1;

    if (rex != 0x40) *compiler->codeptr++ = rex;
  }
}

void
orc_x86_emit_mov_memoffset_reg (OrcCompiler *compiler, int size, int offset,
    int reg1, int reg2)
{

  switch (size) {
    case 1:
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_movzx_rm_r, 4, offset, reg1, reg2);
      return;
    case 2:
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_movw_rm_r, size, offset, reg1, reg2);
      break;
    case 4:
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_movl_rm_r, size, offset, reg1, reg2);
      break;
    case 8:
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_mov_rm_r, size, offset, reg1, reg2);
      break;
    default:
      orc_compiler_error(compiler, "bad size");
      break;
  }
}

void
orc_x86_emit_mov_reg_memoffset (OrcCompiler *compiler, int size, int reg1, int offset,
    int reg2)
{
  switch (size) {
    case 1:
      orc_x86_emit_cpuinsn_reg_memoffset (compiler, ORC_X86_movb_r_rm,
          reg1, offset, reg2);
      break;
    case 2:
      orc_x86_emit_cpuinsn_reg_memoffset (compiler, ORC_X86_movw_r_rm,
          reg1, offset, reg2);
      break;
    case 4:
      orc_x86_emit_cpuinsn_reg_memoffset (compiler, ORC_X86_movl_r_rm,
          reg1, offset, reg2);
      break;
    case 8:
      orc_x86_emit_cpuinsn_reg_memoffset_8 (compiler, ORC_X86_mov_r_rm,
          reg1, offset, reg2);
      break;
    default:
      orc_compiler_error(compiler, "bad size");
      break;
  }

}

void
orc_x86_emit_add_imm_reg (OrcCompiler *compiler, int size, int value, int reg, orc_bool record)
{
  if (!record) {
    if (size == 4 && !compiler->is_64bit) {
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_leal, size,
          value, reg, reg);
      return;
    }
    if (size == 8 && compiler->is_64bit) {
      orc_x86_emit_cpuinsn_memoffset_reg (compiler, ORC_X86_leaq, size,
          value, reg, reg);
      return;
    }
  }

  if (value >= -128 && value < 128) {
    orc_x86_emit_cpuinsn_imm_reg (compiler, ORC_X86_add_imm8_rm, size,
        value, reg);
  } else {
    orc_x86_emit_cpuinsn_imm_reg (compiler, ORC_X86_add_imm32_rm, size,
        value, reg);
  }
}

void
orc_x86_emit_add_reg_reg_shift (OrcCompiler *compiler, int size, int reg1,
    int reg2, int shift)
{
  if (size == 4) {
    orc_x86_emit_cpuinsn_load_memindex (compiler, ORC_X86_leal, size, 0,
        0, reg2, reg1, shift, reg2);
  } else {
    orc_x86_emit_cpuinsn_load_memindex (compiler, ORC_X86_leaq, size, 0,
        0, reg2, reg1, shift, reg2);
  }
}

void
orc_x86_emit_cmp_imm_reg (OrcCompiler *compiler, int size, int value, int reg)
{
  if (value >= -128 && value < 128) {
    orc_x86_emit_cpuinsn_imm_reg (compiler, ORC_X86_cmp_imm8_rm, size, value, reg);
  } else {
    orc_x86_emit_cpuinsn_imm_reg (compiler, ORC_X86_cmp_imm32_rm, size, value, reg);
  }
}

void
orc_x86_emit_cmp_imm_memoffset (OrcCompiler *compiler, int size, int value,
    int offset, int reg)
{
  if (value >= -128 && value < 128) {
    orc_x86_emit_cpuinsn_imm_memoffset (compiler, ORC_X86_cmp_imm8_rm, size,
        value, offset, reg);
  } else {
    orc_x86_emit_cpuinsn_imm_memoffset (compiler, ORC_X86_cmp_imm32_rm, size,
        value, offset, reg);
  }
}

void
orc_x86_emit_dec_memoffset (OrcCompiler *compiler, int size,
    int offset, int reg)
{
  if (size == 4) {
    orc_x86_emit_cpuinsn_imm_memoffset (compiler, ORC_X86_add_imm8_rm, size,
        -1, offset, reg);
  } else {
    orc_x86_emit_cpuinsn_load_memoffset (compiler, ORC_X86_dec, size,
        0, offset, reg, -1);
  }
}

void orc_x86_emit_rep_movs (OrcCompiler *compiler, int size)
{
  switch (size) {
    case 1:
      orc_x86_emit_cpuinsn_none (compiler, ORC_X86_rep_movsb);
      break;
    case 2:
      orc_x86_emit_cpuinsn_none (compiler, ORC_X86_rep_movsw);
      break;
    case 4:
      orc_x86_emit_cpuinsn_none (compiler, ORC_X86_rep_movsl);
      break;
  }
}

void
x86_add_fixup (OrcCompiler *compiler, unsigned char *ptr, int label, int type)
{
  compiler->fixups[compiler->n_fixups].ptr = ptr;
  compiler->fixups[compiler->n_fixups].label = label;
  compiler->fixups[compiler->n_fixups].type = type;
  compiler->n_fixups++;
}

void
x86_add_label (OrcCompiler *compiler, unsigned char *ptr, int label)
{
  compiler->labels[label] = ptr;
}

void
x86_add_label2 (OrcCompiler *compiler, int index, int label)
{
  compiler->labels_int[label] = index;
}

void
orc_x86_do_fixups (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<compiler->n_fixups;i++){
    if (compiler->fixups[i].type == 0) {
      unsigned char *label = compiler->labels[compiler->fixups[i].label];
      unsigned char *ptr = compiler->fixups[i].ptr;
      int diff;

      diff = ((orc_int8)ptr[0]) + (label - ptr);
      if (diff != (orc_int8)diff) {
        orc_compiler_error (compiler, "short jump too long %d", diff);
      }

      ptr[0] = diff;
    } else if (compiler->fixups[i].type == 1) {
      unsigned char *label = compiler->labels[compiler->fixups[i].label];
      unsigned char *ptr = compiler->fixups[i].ptr;
      int diff;

      diff = ORC_READ_UINT32_LE (ptr) + (label - ptr);
      ORC_WRITE_UINT32_LE(ptr, diff);
    }
  }
}

void
orc_x86_emit_prologue (OrcCompiler *compiler)
{
  orc_compiler_append_code(compiler,".global %s\n", compiler->program->name);
  orc_compiler_append_code(compiler,".p2align 4\n");
  orc_compiler_append_code(compiler,"%s:\n", compiler->program->name);
  if (compiler->is_64bit) {
    int i;
    for(i=0;i<16;i++){
      if (compiler->used_regs[ORC_GP_REG_BASE+i] &&
          compiler->save_regs[ORC_GP_REG_BASE+i]) {
        orc_x86_emit_push (compiler, 8, ORC_GP_REG_BASE+i);
      }
    }
  } else {
    orc_x86_emit_push (compiler, 4, X86_EBP);
    if (compiler->use_frame_pointer) {
      orc_x86_emit_mov_reg_reg (compiler, 4, X86_ESP, X86_EBP);
    }
    orc_x86_emit_mov_memoffset_reg (compiler, 4, 8, X86_ESP, compiler->exec_reg);
    if (compiler->used_regs[X86_EDI]) {
      orc_x86_emit_push (compiler, 4, X86_EDI);
    }
    if (compiler->used_regs[X86_ESI]) {
      orc_x86_emit_push (compiler, 4, X86_ESI);
    }
    if (compiler->used_regs[X86_EBX]) {
      orc_x86_emit_push (compiler, 4, X86_EBX);
    }
  }

#if 0
  orc_x86_emit_rdtsc(compiler);
  orc_x86_emit_mov_reg_memoffset (compiler, 4, X86_EAX,
      ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A3]), compiler->exec_reg);
#endif
}

void
orc_x86_emit_epilogue (OrcCompiler *compiler)
{
#if 0
  orc_x86_emit_rdtsc(compiler);
  orc_x86_emit_mov_reg_memoffset (compiler, 4, X86_EAX,
      ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]), compiler->exec_reg);
#endif

  if (compiler->is_64bit) {
    int i;
    for(i=15;i>=0;i--){
      if (compiler->used_regs[ORC_GP_REG_BASE+i] &&
          compiler->save_regs[ORC_GP_REG_BASE+i]) {
        orc_x86_emit_pop (compiler, 8, ORC_GP_REG_BASE+i);
      }
    }
  } else {
    if (compiler->used_regs[X86_EBX]) {
      orc_x86_emit_pop (compiler, 4, X86_EBX);
    }
    if (compiler->used_regs[X86_ESI]) {
      orc_x86_emit_pop (compiler, 4, X86_ESI);
    }
    if (compiler->used_regs[X86_EDI]) {
      orc_x86_emit_pop (compiler, 4, X86_EDI);
    }
    orc_x86_emit_pop (compiler, 4, X86_EBP);
  }
  orc_x86_emit_ret (compiler);
}

/* memcpy implementation based on rep movs */

int
orc_x86_assemble_copy_check (OrcCompiler *compiler)
{
  if (compiler->program->n_insns == 1 &&
      compiler->program->is_2d == FALSE &&
      (strcmp (compiler->program->insns[0].opcode->name, "copyb") == 0 ||
      strcmp (compiler->program->insns[0].opcode->name, "copyw") == 0 ||
      strcmp (compiler->program->insns[0].opcode->name, "copyl") == 0)) {
    return TRUE;
  }

  return FALSE;
}

void
orc_x86_assemble_copy (OrcCompiler *compiler)
{
  OrcInstruction *insn;
  int shift = 0;

  insn = compiler->program->insns + 0;

  if (strcmp (insn->opcode->name, "copyw") == 0) {
    shift = 1;
  } else if (strcmp (insn->opcode->name, "copyl") == 0) {
    shift = 2;
  }

  compiler->used_regs[X86_EDI] = TRUE;
  compiler->used_regs[X86_ESI] = TRUE;

  orc_x86_emit_prologue (compiler);

  orc_x86_emit_mov_memoffset_reg (compiler, 4,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,arrays[insn->dest_args[0]]),
      compiler->exec_reg, X86_EDI);
  orc_x86_emit_mov_memoffset_reg (compiler, 4,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,arrays[insn->src_args[0]]),
      compiler->exec_reg, X86_ESI);
  orc_x86_emit_mov_memoffset_reg (compiler, 4,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,n), compiler->exec_reg,
      compiler->gp_tmpreg);

  orc_x86_emit_sar_imm_reg (compiler, 4, 2 - shift, compiler->gp_tmpreg);
  orc_x86_emit_rep_movs (compiler, 4);
  if (shift == 0) {
    orc_x86_emit_mov_memoffset_reg (compiler, 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,n), compiler->exec_reg,
        compiler->gp_tmpreg);
    orc_x86_emit_and_imm_reg (compiler, 4, 3, compiler->gp_tmpreg);
    orc_x86_emit_rep_movs (compiler, 1);
  }
  if (shift == 1) {
    orc_x86_emit_mov_memoffset_reg (compiler, 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,n), compiler->exec_reg,
        compiler->gp_tmpreg);
    orc_x86_emit_and_imm_reg (compiler, 4, 1, compiler->gp_tmpreg);
    orc_x86_emit_rep_movs (compiler, 2);
  }

  orc_x86_emit_epilogue (compiler);

  orc_x86_do_fixups (compiler);
}

