
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>
#include <orc/orcsse.h>
#include <orc/orcmmx.h>
#include <orc/orcx86insn.h>

/**
 * SECTION:orcsse
 * @title: SSE
 * @short_description: code generation for SSE
 */


const char *
orc_x86_get_regname_sse(int i)
{
  static const char *x86_regs[] = {
    "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7",
    "xmm8", "xmm9", "xmm10", "xmm11", "xmm12", "xmm13", "xmm14", "xmm15"
  };

  if (i>=X86_XMM0 && i<X86_XMM0 + 16) return x86_regs[i - X86_XMM0];
  if (i>=X86_MM0 && i<X86_MM0 + 8) return "ERROR_MMX";
  switch (i) {
    case 0:
      return "UNALLOCATED";
    case 1:
      return "direct";
    default:
      return "ERROR";
  }
}


void
orc_x86_emit_mov_memoffset_sse (OrcCompiler *compiler, int size, int offset,
    int reg1, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      orc_sse_emit_movd_load_memoffset (compiler, offset, reg1, reg2);
      break;
    case 8:
      orc_sse_emit_movq_load_memoffset (compiler, offset, reg1, reg2);
      break;
    case 16:
      if (is_aligned) {
        orc_sse_emit_movdqa_load_memoffset (compiler, offset, reg1, reg2);
      } else {
        orc_sse_emit_movdqu_load_memoffset (compiler, offset, reg1, reg2);
      }
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
}

void
orc_x86_emit_mov_memindex_sse (OrcCompiler *compiler, int size, int offset,
    int reg1, int regindex, int shift, int reg2, int is_aligned)
{
  switch (size) {
    case 4:
      orc_sse_emit_movd_load_memindex (compiler, offset,
          reg1, regindex, shift, reg2);
      break;
    case 8:
      orc_sse_emit_movq_load_memindex (compiler, offset,
          reg1, regindex, shift, reg2);
      break;
    case 16:
      if (is_aligned) {
        orc_sse_emit_movdqa_load_memindex (compiler, offset,
            reg1, regindex, shift, reg2);
      } else {
        orc_sse_emit_movdqu_load_memindex (compiler, offset,
            reg1, regindex, shift, reg2);
      }
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }
}

void
orc_x86_emit_mov_sse_memoffset (OrcCompiler *compiler, int size, int reg1, int offset,
    int reg2, int aligned, int uncached)
{
  switch (size) {
    case 4:
      orc_sse_emit_movd_store_memoffset (compiler, offset, reg1, reg2);
      break;
    case 8:
      orc_sse_emit_movq_store_memoffset (compiler, offset, reg1, reg2);
      break;
    case 16:
      if (aligned) {
        if (uncached) {
          orc_sse_emit_movntdq_store_memoffset (compiler, offset, reg1, reg2);
        } else {
          orc_sse_emit_movdqa_store_memoffset (compiler, offset, reg1, reg2);
        }
      } else {
        orc_sse_emit_movdqu_store_memoffset (compiler, offset, reg1, reg2);
      }
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size");
      break;
  }

}

void
orc_sse_set_mxcsr (OrcCompiler *compiler)
{
  orc_x86_emit_cpuinsn_load_memoffset (compiler, ORC_X86_stmxcsr, 4, 0,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]),
      compiler->exec_reg, 0);

  orc_x86_emit_mov_memoffset_reg (compiler, 4,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]),
      compiler->exec_reg, compiler->gp_tmpreg);

  orc_x86_emit_mov_reg_memoffset (compiler, 4, compiler->gp_tmpreg,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_C1]),
      compiler->exec_reg);

  orc_x86_emit_cpuinsn_imm_reg (compiler, ORC_X86_or_imm32_rm, 4,
      0x8040, compiler->gp_tmpreg);

  orc_x86_emit_mov_reg_memoffset (compiler, 4, compiler->gp_tmpreg,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]),
      compiler->exec_reg);

  orc_x86_emit_cpuinsn_load_memoffset (compiler, ORC_X86_ldmxcsr, 4, 0,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]),
      compiler->exec_reg, 0);
}

void
orc_sse_restore_mxcsr (OrcCompiler *compiler)
{
  orc_x86_emit_cpuinsn_load_memoffset (compiler, ORC_X86_ldmxcsr, 4, 0,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A4]),
      compiler->exec_reg, 0);
}

