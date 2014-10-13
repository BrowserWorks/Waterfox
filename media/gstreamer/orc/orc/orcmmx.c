
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>
#include <orc/orcmmx.h>

/**
 * SECTION:orcmmx
 * @title: MMX
 * @short_description: code generation for MMX
 */


const char *
orc_x86_get_regname_mmx(int i)
{
  static const char *x86_regs[] = {
    "mm0", "mm1", "mm2", "mm3", "mm4", "mm5", "mm6", "mm7",
    "mm8", "mm9", "mm10", "mm11", "mm12", "mm13", "mm14", "mm15"
  };

  if (i>=X86_MM0 && i<X86_MM0 + 16) return x86_regs[i - X86_MM0];
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}

#if 0
void
orc_x86_emit_mov_memindex_mmx (OrcCompiler *compiler, int size, int offset,
    int reg1, int regindex, int shift, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      ORC_ASM_CODE(compiler,"  movd %d(%%%s,%%%s,%d), %%%s\n", offset,
          orc_x86_get_regname_ptr(compiler, reg1),
          orc_x86_get_regname_ptr(compiler, regindex), 1<<shift,
          orc_x86_get_regname_mmx(reg2));
      orc_x86_emit_rex(compiler, 0, reg2, 0, reg1);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x6e;
      break;
    case 8:
      ORC_ASM_CODE(compiler,"  movq %d(%%%s,%%%s,%d), %%%s\n", offset, orc_x86_get_regname_ptr(compiler, reg1),
          orc_x86_get_regname_ptr(compiler, regindex), 1<<shift,
          orc_x86_get_regname_mmx(reg2));
      orc_x86_emit_rex(compiler, 0, reg2, 0, reg1);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x7e;
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
  orc_x86_emit_modrm_memindex (compiler, reg2, offset, reg1, regindex, shift);
}

void
orc_x86_emit_mov_memoffset_mmx (OrcCompiler *compiler, int size, int offset,
    int reg1, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      ORC_ASM_CODE(compiler,"  movd %d(%%%s), %%%s\n", offset, orc_x86_get_regname_ptr(compiler, reg1),
          orc_x86_get_regname_mmx(reg2));
      orc_x86_emit_rex(compiler, 0, reg2, 0, reg1);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x6e;
      break;
    case 8:
      ORC_ASM_CODE(compiler,"  movq %d(%%%s), %%%s\n", offset, orc_x86_get_regname_ptr(compiler, reg1),
          orc_x86_get_regname_mmx(reg2));
      orc_x86_emit_rex(compiler, 0, reg2, 0, reg1);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x6f;
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
  orc_x86_emit_modrm_memoffset (compiler, offset, reg1, reg2);
}

void
orc_x86_emit_mov_mmx_memoffset (OrcCompiler *compiler, int size, int reg1, int offset,
    int reg2, int aligned, int uncached)
{
  switch (size) {
    case 4:
      ORC_ASM_CODE(compiler,"  movd %%%s, %d(%%%s)\n", orc_x86_get_regname_mmx(reg1), offset,
          orc_x86_get_regname_ptr(compiler, reg2));
      orc_x86_emit_rex(compiler, 0, reg1, 0, reg2);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x7e;
      break;
    case 8:
      ORC_ASM_CODE(compiler,"  movq %%%s, %d(%%%s)\n", orc_x86_get_regname_mmx(reg1), offset,
          orc_x86_get_regname_ptr(compiler, reg2));
      orc_x86_emit_rex(compiler, 0, reg1, 0, reg2);
      *compiler->codeptr++ = 0x0f;
      *compiler->codeptr++ = 0x7f;
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }

  orc_x86_emit_modrm_memoffset (compiler, offset, reg2, reg1);
}
#endif

void
orc_x86_emit_mov_memoffset_mmx (OrcCompiler *compiler, int size, int offset,
    int reg1, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      orc_mmx_emit_movd_load_memoffset (compiler, offset, reg1, reg2);
      break;
    case 8:
      orc_mmx_emit_movq_load_memoffset (compiler, offset, reg1, reg2);
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
}

void
orc_x86_emit_mov_memindex_mmx (OrcCompiler *compiler, int size, int offset,
    int reg1, int regindex, int shift, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      orc_mmx_emit_movd_load_memindex (compiler, offset,
          reg1, regindex, shift, reg2);
      break;
    case 8:
      orc_mmx_emit_movq_load_memindex (compiler, offset,
          reg1, regindex, shift, reg2);
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
}

void
orc_x86_emit_mov_mmx_memoffset (OrcCompiler *compiler, int size, int reg1,
    int offset, int reg2, int aligned, int uncached)
{
  switch (size) {
    case 4:
      orc_mmx_emit_movd_store_memoffset (compiler, offset, reg1, reg2);
      break;
    case 8:
      orc_mmx_emit_movq_store_memoffset (compiler, offset, reg1, reg2);
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }

}

