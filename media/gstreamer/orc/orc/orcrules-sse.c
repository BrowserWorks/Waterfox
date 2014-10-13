
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>
#include <orc/orcsse.h>

#undef MMX
#define SIZE 65536

/* sse rules */

static void
sse_rule_loadpX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int reg;
  int size = ORC_PTR_TO_INT(user);

  if (src->vartype == ORC_VAR_TYPE_PARAM) {
    reg = dest->alloc;

    if (size == 8 && src->size == 8) {
      orc_x86_emit_mov_memoffset_sse (compiler, 4,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[insn->src_args[0]]),
          compiler->exec_reg, reg, FALSE);
#ifndef MMX
      orc_sse_emit_movhps_load_memoffset (compiler,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,
            params[insn->src_args[0] + (ORC_VAR_T1 - ORC_VAR_P1)]),
          compiler->exec_reg, reg);
      orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(2,0,2,0), reg, reg);
#else
      /* FIXME yes, I understand this is terrible */
      orc_sse_emit_pinsrw_memoffset (compiler, 2,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,
            params[insn->src_args[0] + (ORC_VAR_T1 - ORC_VAR_P1)]) + 0,
          compiler->exec_reg, reg);
      orc_sse_emit_pinsrw_memoffset (compiler, 3,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,
            params[insn->src_args[0] + (ORC_VAR_T1 - ORC_VAR_P1)]) + 2,
          compiler->exec_reg, reg);
#ifndef MMX
      orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(1,0,1,0), reg, reg);
#endif
#endif
    } else {
      orc_x86_emit_mov_memoffset_sse (compiler, 4,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[insn->src_args[0]]),
          compiler->exec_reg, reg, FALSE);
      if (size < 8) {
        if (size == 1) {
          orc_sse_emit_punpcklbw (compiler, reg, reg);
        }
#ifndef MMX
        if (size <= 2) {
          orc_sse_emit_pshuflw (compiler, 0, reg, reg);
        }
        orc_sse_emit_pshufd (compiler, 0, reg, reg);
#else
        if (size <= 2) {
          orc_mmx_emit_pshufw (compiler, ORC_MMX_SHUF(0,0,0,0), reg, reg);
        } else {
          orc_mmx_emit_pshufw (compiler, ORC_MMX_SHUF(1,0,1,0), reg, reg);
        }
#endif
      } else {
#ifndef MMX
        orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(1,0,1,0), reg, reg);
#endif
      }
    }
  } else if (src->vartype == ORC_VAR_TYPE_CONST) {
    orc_sse_load_constant (compiler, dest->alloc, size, src->value.i);
  } else {
    ORC_ASSERT(0);
  }
}

static void
sse_rule_loadX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int ptr_reg;
  int offset = 0;

  offset = compiler->offset * src->size;
  if (src->ptr_register == 0) {
    int i = insn->src_args[0];
    orc_x86_emit_mov_memoffset_reg (compiler, compiler->is_64bit ? 8 : 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]),
        compiler->exec_reg, compiler->gp_tmpreg);
    ptr_reg = compiler->gp_tmpreg;
  } else {
    ptr_reg = src->ptr_register;
  } 
  switch (src->size << compiler->loop_shift) {
    case 1:
      orc_x86_emit_mov_memoffset_reg (compiler, 1, offset, ptr_reg,
          compiler->gp_tmpreg);
      orc_sse_emit_movd_load_register (compiler, compiler->gp_tmpreg, dest->alloc);
      break;
    case 2:
      orc_sse_emit_pxor (compiler, dest->alloc, dest->alloc);
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset, ptr_reg, dest->alloc);
      break;
    case 4:
      orc_x86_emit_mov_memoffset_sse (compiler, 4, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 8:
      orc_x86_emit_mov_memoffset_sse (compiler, 8, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 16:
      orc_x86_emit_mov_memoffset_sse (compiler, 16, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    default:
      orc_compiler_error (compiler, "bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }

  src->update_type = 2;
}

static void
sse_rule_loadoffX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int ptr_reg;
  int offset = 0;

  if (compiler->vars[insn->src_args[1]].vartype != ORC_VAR_TYPE_CONST) {
    orc_compiler_error (compiler, "code generation rule for %s only works with constant offset",
        insn->opcode->name);
    return;
  }

  offset = (compiler->offset + compiler->vars[insn->src_args[1]].value.i) *
    src->size;
  if (src->ptr_register == 0) {
    int i = insn->src_args[0];
    orc_x86_emit_mov_memoffset_reg (compiler, compiler->is_64bit ? 8 : 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]),
        compiler->exec_reg, compiler->gp_tmpreg);
    ptr_reg = compiler->gp_tmpreg;
  } else {
    ptr_reg = src->ptr_register;
  } 
  switch (src->size << compiler->loop_shift) {
    case 1:
      orc_x86_emit_mov_memoffset_reg (compiler, 1, offset, ptr_reg,
          compiler->gp_tmpreg);
      orc_sse_emit_movd_load_register (compiler, compiler->gp_tmpreg, dest->alloc);
      break;
    case 2:
      orc_sse_emit_pxor (compiler, dest->alloc, dest->alloc);
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset, ptr_reg, dest->alloc);
      break;
    case 4:
      orc_x86_emit_mov_memoffset_sse (compiler, 4, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 8:
      orc_x86_emit_mov_memoffset_sse (compiler, 8, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 16:
      orc_x86_emit_mov_memoffset_sse (compiler, 16, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    default:
      orc_compiler_error (compiler,"bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }

  src->update_type = 2;
}

static void
sse_rule_loadupib (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int ptr_reg;
  int offset = 0;
  int tmp = orc_compiler_get_temp_reg (compiler);

  offset = (compiler->offset * src->size) >> 1;
  if (src->ptr_register == 0) {
    int i = insn->src_args[0];
    orc_x86_emit_mov_memoffset_reg (compiler, compiler->is_64bit ? 8 : 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]),
        compiler->exec_reg, compiler->gp_tmpreg);
    ptr_reg = compiler->gp_tmpreg;
  } else {
    ptr_reg = src->ptr_register;
  } 
  switch (src->size << compiler->loop_shift) {
    case 1:
    case 2:
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset, ptr_reg, dest->alloc);
      orc_sse_emit_movdqa (compiler, dest->alloc, tmp);
      orc_sse_emit_psrlw_imm (compiler, 8, tmp);
      break;
    case 4:
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset, ptr_reg, dest->alloc);
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset + 1, ptr_reg, tmp);
      break;
    case 8:
      orc_x86_emit_mov_memoffset_sse (compiler, 4, offset, ptr_reg,
          dest->alloc, FALSE);
      orc_x86_emit_mov_memoffset_sse (compiler, 4, offset + 1, ptr_reg,
          tmp, FALSE);
      break;
    case 16:
      orc_x86_emit_mov_memoffset_sse (compiler, 8, offset, ptr_reg,
          dest->alloc, FALSE);
      orc_x86_emit_mov_memoffset_sse (compiler, 8, offset + 1, ptr_reg,
          tmp, FALSE);
      break;
    case 32:
      orc_x86_emit_mov_memoffset_sse (compiler, 16, offset, ptr_reg,
          dest->alloc, FALSE);
      orc_x86_emit_mov_memoffset_sse (compiler, 16, offset + 1, ptr_reg,
          tmp, FALSE);
      break;
    default:
      orc_compiler_error(compiler,"bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }

  orc_sse_emit_pavgb (compiler, dest->alloc, tmp);
  orc_sse_emit_punpcklbw (compiler, tmp, dest->alloc);

  src->update_type = 1;
}

static void
sse_rule_loadupdb (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int ptr_reg;
  int offset = 0;

  offset = (compiler->offset * src->size) >> 1;
  if (src->ptr_register == 0) {
    int i = insn->src_args[0];
    orc_x86_emit_mov_memoffset_reg (compiler, compiler->is_64bit ? 8 : 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]),
        compiler->exec_reg, compiler->gp_tmpreg);
    ptr_reg = compiler->gp_tmpreg;
  } else {
    ptr_reg = src->ptr_register;
  } 
  switch (src->size << compiler->loop_shift) {
    case 1:
    case 2:
      orc_x86_emit_mov_memoffset_reg (compiler, 1, offset, ptr_reg,
          compiler->gp_tmpreg);
      orc_sse_emit_movd_load_register (compiler, compiler->gp_tmpreg, dest->alloc);
      break;
    case 4:
      orc_sse_emit_pinsrw_memoffset (compiler, 0, offset, ptr_reg, dest->alloc);
      break;
    case 8:
      orc_x86_emit_mov_memoffset_sse (compiler, 4, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 16:
      orc_x86_emit_mov_memoffset_sse (compiler, 8, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    case 32:
      orc_x86_emit_mov_memoffset_sse (compiler, 16, offset, ptr_reg,
          dest->alloc, src->is_aligned);
      break;
    default:
      orc_compiler_error(compiler,"bad load size %d",
          src->size << compiler->loop_shift);
      break;
  }
  switch (src->size) {
    case 1:
      orc_sse_emit_punpcklbw (compiler, dest->alloc, dest->alloc);
      break;
    case 2:
      orc_sse_emit_punpcklwd (compiler, dest->alloc, dest->alloc);
      break;
    case 4:
      orc_sse_emit_punpckldq (compiler, dest->alloc, dest->alloc);
      break;
  }

  src->update_type = 1;
}

static void
sse_rule_storeX (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int offset;
  int ptr_reg;

  offset = compiler->offset * dest->size;
  if (dest->ptr_register == 0) {
    orc_x86_emit_mov_memoffset_reg (compiler, compiler->is_64bit ? 8 : 4,
        dest->ptr_offset, compiler->exec_reg, compiler->gp_tmpreg);
    ptr_reg = compiler->gp_tmpreg; 
  } else {
    ptr_reg = dest->ptr_register;
  } 
  switch (dest->size << compiler->loop_shift) {
    case 1:
      /* FIXME we might be using ecx twice here */
      if (ptr_reg == compiler->gp_tmpreg) {
        orc_compiler_error (compiler, "unimplemented corner case in %s",
            insn->opcode->name);
      }
      orc_sse_emit_movd_store_register (compiler, src->alloc, compiler->gp_tmpreg);
      orc_x86_emit_mov_reg_memoffset (compiler, 1, compiler->gp_tmpreg,
          offset, ptr_reg);
      break;
    case 2:
      if (compiler->target_flags & ORC_TARGET_SSE_SSE4_1) {
        orc_sse_emit_pextrw_memoffset (compiler, 0, offset, src->alloc,
            ptr_reg);
      } else {
        /* FIXME we might be using ecx twice here */
        if (ptr_reg == compiler->gp_tmpreg) {
          orc_compiler_error(compiler, "unimplemented corner case in %s",
              insn->opcode->name);
        } 
        orc_sse_emit_movd_store_register (compiler, src->alloc, compiler->gp_tmpreg);
        orc_x86_emit_mov_reg_memoffset (compiler, 2, compiler->gp_tmpreg,
            offset, ptr_reg);
      }
      break;
    case 4:
      orc_x86_emit_mov_sse_memoffset (compiler, 4, src->alloc, offset, ptr_reg,
          dest->is_aligned, dest->is_uncached);
      break;
    case 8:
      orc_x86_emit_mov_sse_memoffset (compiler, 8, src->alloc, offset, ptr_reg,
          dest->is_aligned, dest->is_uncached);
      break;
    case 16:
      orc_x86_emit_mov_sse_memoffset (compiler, 16, src->alloc, offset, ptr_reg,
          dest->is_aligned, dest->is_uncached);
      break;
    default:
      orc_compiler_error (compiler, "bad size");
      break;
  }

  dest->update_type = 2;
}

#if try1
static void
sse_rule_ldresnearl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int tmp = orc_compiler_get_temp_reg (compiler);
  int tmp2 = orc_compiler_get_temp_reg (compiler);
  int tmpc;

  orc_sse_emit_movd_store_register (compiler, X86_XMM6, compiler->gp_tmpreg);
  orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);

  orc_sse_emit_movdqu_load_memindex (compiler, 0, src->ptr_register,
      compiler->gp_tmpreg, 4, dest->alloc);

#if 0
  orc_sse_emit_movdqa (compiler, X86_XMM6, tmp);
  orc_sse_emit_pslld_imm (compiler, 10, tmp);
  orc_sse_emit_psrld_imm (compiler, 26, tmp);
  orc_sse_emit_pslld_imm (compiler, 2, tmp);

  orc_sse_emit_movdqa (compiler, tmp, tmp2);
  orc_sse_emit_pslld_imm (compiler, 8, tmp2);
  orc_sse_emit_por (compiler, tmp2, tmp);
  orc_sse_emit_movdqa (compiler, tmp, tmp2);
  orc_sse_emit_pslld_imm (compiler, 16, tmp2);
  orc_sse_emit_por (compiler, tmp2, tmp);
#else
  orc_sse_emit_movdqa (compiler, X86_XMM6, tmp);
  tmpc = orc_compiler_get_constant_long (compiler, 0x02020202,
      0x06060606, 0x0a0a0a0a, 0x0e0e0e0e);
  orc_sse_emit_pshufb (compiler, tmpc, tmp);
  orc_sse_emit_paddb (compiler, tmp, tmp);
  orc_sse_emit_paddb (compiler, tmp, tmp);
#endif

  orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(0,0,0,0), tmp, tmp2);
  orc_sse_emit_psubd (compiler, tmp2, tmp);
  tmpc = orc_compiler_get_constant (compiler, 4, 0x03020100);
  orc_sse_emit_paddd (compiler, tmpc, tmp);

  orc_sse_emit_pshufb (compiler, tmp, dest->alloc);

  orc_sse_emit_movdqa (compiler, X86_XMM7, tmp);
  orc_sse_emit_pslld_imm (compiler, compiler->loop_shift, tmp);

  orc_sse_emit_paddd (compiler, tmp, X86_XMM6);

  src->update_type = 0;
}
#endif

static void
sse_rule_ldresnearl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  int increment_var = insn->src_args[2];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int tmp = orc_compiler_get_temp_reg (compiler);
  int i;

  for(i=0;i<(1<<compiler->loop_shift);i++){
    if (i == 0) {
      orc_x86_emit_mov_memoffset_sse (compiler, 4, 0,
          src->ptr_register, dest->alloc, FALSE);
    } else {
      orc_x86_emit_mov_memindex_sse (compiler, 4, 0,
          src->ptr_register, compiler->gp_tmpreg, 2, tmp, FALSE);
#ifdef MMX
      /* orc_mmx_emit_punpckldq (compiler, tmp, dest->alloc); */
      orc_sse_emit_psllq_imm (compiler, 8*4*i, tmp);
      orc_sse_emit_por (compiler, tmp, dest->alloc);
#else
      orc_sse_emit_pslldq_imm (compiler, 4*i, tmp);
      orc_sse_emit_por (compiler, tmp, dest->alloc);
#endif
    }

    if (compiler->vars[increment_var].vartype == ORC_VAR_TYPE_PARAM) {
      orc_x86_emit_add_memoffset_reg (compiler, 4,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[increment_var]),
          compiler->exec_reg, src->ptr_offset);
    } else {
      orc_x86_emit_add_imm_reg (compiler, 4,
          compiler->vars[increment_var].value.i,
          src->ptr_offset, FALSE);
    }

    orc_x86_emit_mov_reg_reg (compiler, 4, src->ptr_offset, compiler->gp_tmpreg);
    orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);
  }

  orc_x86_emit_add_reg_reg_shift (compiler, compiler->is_64bit ? 8 : 4,
      compiler->gp_tmpreg,
      src->ptr_register, 2);
  orc_x86_emit_and_imm_reg (compiler, 4, 0xffff, src->ptr_offset);

  src->update_type = 0;
}

#ifndef MMX
static void
sse_rule_ldreslinl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  int increment_var = insn->src_args[2];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int tmp = orc_compiler_get_temp_reg (compiler);
  int tmp2 = orc_compiler_get_temp_reg (compiler);
  int regsize = compiler->is_64bit ? 8 : 4;
  int i;

  if (compiler->loop_shift == 0) {
    orc_x86_emit_mov_memoffset_sse (compiler, 8, 0,
        src->ptr_register, tmp, FALSE);

    orc_sse_emit_pxor (compiler, tmp2, tmp2);
    orc_sse_emit_punpcklbw (compiler, tmp2, tmp);
    orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(3,2,3,2), tmp, tmp2);
    orc_sse_emit_psubw (compiler, tmp, tmp2);

    orc_sse_emit_movd_load_register (compiler, src->ptr_offset, tmp);
    orc_sse_emit_pshuflw (compiler, ORC_SSE_SHUF(0,0,0,0), tmp, tmp);
    orc_sse_emit_psrlw_imm (compiler, 8, tmp);
    orc_sse_emit_pmullw (compiler, tmp2, tmp);
    orc_sse_emit_psraw_imm (compiler, 8, tmp);
    orc_sse_emit_pxor (compiler, tmp2, tmp2);
    orc_sse_emit_packsswb (compiler, tmp2, tmp);

    orc_x86_emit_mov_memoffset_sse (compiler, 4, 0,
        src->ptr_register, dest->alloc, FALSE);
    orc_sse_emit_paddb (compiler, tmp, dest->alloc);

    if (compiler->vars[increment_var].vartype == ORC_VAR_TYPE_PARAM) {
      orc_x86_emit_add_memoffset_reg (compiler, 4,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[increment_var]),
          compiler->exec_reg, src->ptr_offset);
    } else {
      orc_x86_emit_add_imm_reg (compiler, regsize,
          compiler->vars[increment_var].value.i,
          src->ptr_offset, FALSE);
    }

    orc_x86_emit_mov_reg_reg (compiler, 4, src->ptr_offset, compiler->gp_tmpreg);
    orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);

    orc_x86_emit_add_reg_reg_shift (compiler, regsize, compiler->gp_tmpreg,
        src->ptr_register, 2);
    orc_x86_emit_and_imm_reg (compiler, 4, 0xffff, src->ptr_offset);
  } else {
    int tmp3 = orc_compiler_get_temp_reg (compiler);
    int tmp4 = orc_compiler_get_temp_reg (compiler);

    for(i=0;i<(1<<compiler->loop_shift);i+=2){
      orc_x86_emit_mov_memoffset_sse (compiler, 8, 0,
          src->ptr_register, tmp, FALSE);
      orc_sse_emit_movd_load_register (compiler, src->ptr_offset, tmp4);

      if (compiler->vars[increment_var].vartype == ORC_VAR_TYPE_PARAM) {
        orc_x86_emit_add_memoffset_reg (compiler, 4,
            (int)ORC_STRUCT_OFFSET(OrcExecutor, params[increment_var]),
            compiler->exec_reg, src->ptr_offset);
      } else {
        orc_x86_emit_add_imm_reg (compiler, 4,
            compiler->vars[increment_var].value.i,
            src->ptr_offset, FALSE);
      }
      orc_x86_emit_mov_reg_reg (compiler, 4, src->ptr_offset, compiler->gp_tmpreg);
      orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);

      orc_x86_emit_mov_memindex_sse (compiler, 8, 0,
          src->ptr_register, compiler->gp_tmpreg, 2, tmp2, FALSE);

      orc_sse_emit_punpckldq (compiler, tmp2, tmp);
      orc_sse_emit_movdqa (compiler, tmp, tmp2);
      if (i == 0) {
        orc_sse_emit_movdqa (compiler, tmp, dest->alloc);
      } else {
        orc_sse_emit_punpcklqdq (compiler, tmp, dest->alloc);
      }

      orc_sse_emit_pxor (compiler, tmp3, tmp3);
      orc_sse_emit_punpcklbw (compiler, tmp3, tmp);
      orc_sse_emit_punpckhbw (compiler, tmp3, tmp2);

      orc_sse_emit_psubw (compiler, tmp, tmp2);

      orc_sse_emit_pinsrw_register (compiler, 1, src->ptr_offset, tmp4);

#if 0
      orc_sse_emit_punpcklwd (compiler, tmp4, tmp4);
      orc_sse_emit_punpckldq (compiler, tmp4, tmp4);
#else
      orc_sse_emit_pshuflw (compiler, ORC_SSE_SHUF(1,1,0,0), tmp4, tmp4);
      orc_sse_emit_pshufd (compiler, ORC_SSE_SHUF(1,1,0,0), tmp4, tmp4);
#endif
      orc_sse_emit_psrlw_imm (compiler, 8, tmp4);
      orc_sse_emit_pmullw (compiler, tmp4, tmp2);
      orc_sse_emit_psraw_imm (compiler, 8, tmp2);
      orc_sse_emit_pxor (compiler, tmp, tmp);
      orc_sse_emit_packsswb (compiler, tmp, tmp2);

      if (i != 0) {
        orc_sse_emit_pslldq_imm (compiler, 8, tmp2);
      }
      orc_sse_emit_paddb (compiler, tmp2, dest->alloc);

      if (compiler->vars[increment_var].vartype == ORC_VAR_TYPE_PARAM) {
        orc_x86_emit_add_memoffset_reg (compiler, 4,
            (int)ORC_STRUCT_OFFSET(OrcExecutor, params[increment_var]),
            compiler->exec_reg, src->ptr_offset);
      } else {
        orc_x86_emit_add_imm_reg (compiler, 4,
            compiler->vars[increment_var].value.i,
            src->ptr_offset, FALSE);
      }

      orc_x86_emit_mov_reg_reg (compiler, 4, src->ptr_offset, compiler->gp_tmpreg);
      orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);

      orc_x86_emit_add_reg_reg_shift (compiler, 8, compiler->gp_tmpreg,
          src->ptr_register, 2);
      orc_x86_emit_and_imm_reg (compiler, 4, 0xffff, src->ptr_offset);
    }
  }

  src->update_type = 0;
}
#else
static void
mmx_rule_ldreslinl (OrcCompiler *compiler, void *user, OrcInstruction *insn)
{
  OrcVariable *src = compiler->vars + insn->src_args[0];
  int increment_var = insn->src_args[2];
  OrcVariable *dest = compiler->vars + insn->dest_args[0];
  int tmp = orc_compiler_get_temp_reg (compiler);
  int tmp2 = orc_compiler_get_temp_reg (compiler);
  int zero;
  int regsize = compiler->is_64bit ? 8 : 4;
  int i;

  zero = orc_compiler_get_constant (compiler, 1, 0);
  for(i=0;i<(1<<compiler->loop_shift);i++){
    orc_x86_emit_mov_memoffset_mmx (compiler, 4, 0,
        src->ptr_register, tmp, FALSE);
    orc_x86_emit_mov_memoffset_mmx (compiler, 4, 4,
        src->ptr_register, tmp2, FALSE);

    orc_mmx_emit_punpcklbw (compiler, zero, tmp);
    orc_mmx_emit_punpcklbw (compiler, zero, tmp2);
    orc_mmx_emit_psubw (compiler, tmp, tmp2);

    orc_sse_emit_movd_load_register (compiler, src->ptr_offset, tmp);
    orc_mmx_emit_pshufw (compiler, ORC_MMX_SHUF(0,0,0,0), tmp, tmp);
    orc_mmx_emit_psrlw_imm (compiler, 8, tmp);
    orc_mmx_emit_pmullw (compiler, tmp2, tmp);
    orc_mmx_emit_psraw_imm (compiler, 8, tmp);
    orc_mmx_emit_pxor (compiler, tmp2, tmp2);
    orc_mmx_emit_packsswb (compiler, tmp2, tmp);

    if (i == 0) {
      orc_x86_emit_mov_memoffset_mmx (compiler, 4, 0,
          src->ptr_register, dest->alloc, FALSE);
      orc_mmx_emit_paddb (compiler, tmp, dest->alloc);
    } else {
      orc_x86_emit_mov_memoffset_mmx (compiler, 4, 0,
          src->ptr_register, tmp2, FALSE);
      orc_mmx_emit_paddb (compiler, tmp, tmp2);
      orc_mmx_emit_psllq_imm (compiler, 32, tmp2);
      orc_mmx_emit_por (compiler, tmp2, dest->alloc);
    }

    if (compiler->vars[increment_var].vartype == ORC_VAR_TYPE_PARAM) {
      orc_x86_emit_add_memoffset_reg (compiler, 4,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[increment_var]),
          compiler->exec_reg, src->ptr_offset);
    } else {
      orc_x86_emit_add_imm_reg (compiler, regsize,
          compiler->vars[increment_var].value.i,
          src->ptr_offset, FALSE);
    }

    orc_x86_emit_mov_reg_reg (compiler, 4, src->ptr_offset, compiler->gp_tmpreg);
    orc_x86_emit_sar_imm_reg (compiler, 4, 16, compiler->gp_tmpreg);

    orc_x86_emit_add_reg_reg_shift (compiler, regsize, compiler->gp_tmpreg,
        src->ptr_register, 2);
    orc_x86_emit_and_imm_reg (compiler, 4, 0xffff, src->ptr_offset);
  }

  src->update_type = 0;
}
#endif

static void
sse_rule_copyx (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  if (p->vars[insn->src_args[0]].alloc == p->vars[insn->dest_args[0]].alloc) {
    return;
  }

  orc_sse_emit_movdqa (p,
      p->vars[insn->src_args[0]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

#define UNARY(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[0]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

#define BINARY(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[1]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}


UNARY(absb,pabsb,0x381c)
BINARY(addb,paddb,0xfc)
BINARY(addssb,paddsb,0xec)
BINARY(addusb,paddusb,0xdc)
BINARY(andb,pand,0xdb)
BINARY(andnb,pandn,0xdf)
BINARY(avgub,pavgb,0xe0)
BINARY(cmpeqb,pcmpeqb,0x74)
BINARY(cmpgtsb,pcmpgtb,0x64)
BINARY(maxsb,pmaxsb,0x383c)
BINARY(maxub,pmaxub,0xde)
BINARY(minsb,pminsb,0x3838)
BINARY(minub,pminub,0xda)
/* BINARY(mullb,pmullb,0xd5) */
/* BINARY(mulhsb,pmulhb,0xe5) */
/* BINARY(mulhub,pmulhub,0xe4) */
BINARY(orb,por,0xeb)
/* UNARY(signb,psignb,0x3808) */
BINARY(subb,psubb,0xf8)
BINARY(subssb,psubsb,0xe8)
BINARY(subusb,psubusb,0xd8)
BINARY(xorb,pxor,0xef)

UNARY(absw,pabsw,0x381d)
BINARY(addw,paddw,0xfd)
BINARY(addssw,paddsw,0xed)
BINARY(addusw,paddusw,0xdd)
BINARY(andw,pand,0xdb)
BINARY(andnw,pandn,0xdf)
BINARY(avguw,pavgw,0xe3)
BINARY(cmpeqw,pcmpeqw,0x75)
BINARY(cmpgtsw,pcmpgtw,0x65)
BINARY(maxsw,pmaxsw,0xee)
BINARY(maxuw,pmaxuw,0x383e)
BINARY(minsw,pminsw,0xea)
BINARY(minuw,pminuw,0x383a)
BINARY(mullw,pmullw,0xd5)
BINARY(mulhsw,pmulhw,0xe5)
BINARY(mulhuw,pmulhuw,0xe4)
BINARY(orw,por,0xeb)
/* UNARY(signw,psignw,0x3809) */
BINARY(subw,psubw,0xf9)
BINARY(subssw,psubsw,0xe9)
BINARY(subusw,psubusw,0xd9)
BINARY(xorw,pxor,0xef)

UNARY(absl,pabsd,0x381e)
BINARY(addl,paddd,0xfe)
/* BINARY(addssl,paddsd,0xed) */
/* BINARY(addusl,paddusd,0xdd) */
BINARY(andl,pand,0xdb)
BINARY(andnl,pandn,0xdf)
/* BINARY(avgul,pavgd,0xe3) */
BINARY(cmpeql,pcmpeqd,0x76)
BINARY(cmpgtsl,pcmpgtd,0x66)
BINARY(maxsl,pmaxsd,0x383d)
BINARY(maxul,pmaxud,0x383f)
BINARY(minsl,pminsd,0x3839)
BINARY(minul,pminud,0x383b)
BINARY(mulll,pmulld,0x3840)
/* BINARY(mulhsl,pmulhd,0xe5) */
/* BINARY(mulhul,pmulhud,0xe4) */
BINARY(orl,por,0xeb)
/* UNARY(signl,psignd,0x380a) */
BINARY(subl,psubd,0xfa)
/* BINARY(subssl,psubsd,0xe9) */
/* BINARY(subusl,psubusd,0xd9) */
BINARY(xorl,pxor,0xef)

BINARY(andq,pand,0xdb)
BINARY(andnq,pandn,0xdf)
BINARY(orq,por,0xeb)
BINARY(xorq,pxor,0xef)
BINARY(cmpeqq,pcmpeqq,0x3829)
BINARY(cmpgtsq,pcmpgtq,0x3837)

#ifndef MMX
BINARY(addq,paddq,0xd4)
BINARY(subq,psubq,0xfb)
#endif

static void
sse_rule_accw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_paddw (p, src, dest);
}

static void
sse_rule_accl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

#ifndef MMX
  if (p->loop_shift == 0) {
    orc_sse_emit_pslldq_imm (p, 12, src);
  }
#endif
  orc_sse_emit_paddd (p, src, dest);
}

static void
sse_rule_accsadubl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src1 = p->vars[insn->src_args[0]].alloc;
  int src2 = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

#ifndef MMX
  if (p->loop_shift <= 2) {
    orc_sse_emit_movdqa (p, src1, tmp);
    orc_sse_emit_pslldq_imm (p, 16 - (1<<p->loop_shift), tmp);
    orc_sse_emit_movdqa (p, src2, tmp2);
    orc_sse_emit_pslldq_imm (p, 16 - (1<<p->loop_shift), tmp2);
    orc_sse_emit_psadbw (p, tmp2, tmp);
  } else if (p->loop_shift == 3) {
    orc_sse_emit_movdqa (p, src1, tmp);
    orc_sse_emit_psadbw (p, src2, tmp);
    orc_sse_emit_pslldq_imm (p, 8, tmp);
  } else {
    orc_sse_emit_movdqa (p, src1, tmp);
    orc_sse_emit_psadbw (p, src2, tmp);
  }
#else
  if (p->loop_shift <= 2) {
    orc_sse_emit_movdqa (p, src1, tmp);
    orc_sse_emit_psllq_imm (p, 8*(8 - (1<<p->loop_shift)), tmp);
    orc_sse_emit_movdqa (p, src2, tmp2);
    orc_sse_emit_psllq_imm (p, 8*(8 - (1<<p->loop_shift)), tmp2);
    orc_sse_emit_psadbw (p, tmp2, tmp);
  } else {
    orc_sse_emit_movdqa (p, src1, tmp);
    orc_sse_emit_psadbw (p, src2, tmp);
  }
#endif
  orc_sse_emit_paddd (p, tmp, dest);
}

#ifndef MMX
static void
sse_rule_signX_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int opcodes[] = { ORC_X86_psignb, ORC_X86_psignw, ORC_X86_psignd };
  int type = ORC_PTR_TO_INT(user);
  int tmpc;

  tmpc = orc_compiler_get_temp_constant (p, 1<<type, 1);
  if (src == dest) {
    orc_x86_emit_cpuinsn_size (p, opcodes[type], 16, src, tmpc);
    orc_sse_emit_movdqa (p, tmpc, dest);
  } else {
    /* FIXME this would be a good opportunity to not chain src to dest */
    orc_sse_emit_movdqa (p, tmpc, dest);
    orc_x86_emit_cpuinsn_size (p, opcodes[type], 16, src, dest);
  }
}
#endif

static void
sse_rule_signw_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_get_constant (p, 2, 0x0001);
  orc_sse_emit_pminsw (p, tmp, dest);

  tmp = orc_compiler_get_constant (p, 2, 0xffff);
  orc_sse_emit_pmaxsw (p, tmp, dest);
}

static void
sse_rule_absb_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_pxor (p, tmp, tmp);
  orc_sse_emit_pcmpgtb (p, src, tmp);
  orc_sse_emit_pxor (p, tmp, dest);
  orc_sse_emit_psubb (p, tmp, dest);
}

static void
sse_rule_absw_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  if (src == dest) {
    orc_sse_emit_movdqa (p, src, tmp);
  } else {
    orc_sse_emit_movdqa (p, src, tmp);
    orc_sse_emit_movdqa (p, tmp, dest);
  }

  orc_sse_emit_psraw_imm (p, 15, tmp);
  orc_sse_emit_pxor (p, tmp, dest);
  orc_sse_emit_psubw (p, tmp, dest);

}

static void
sse_rule_absl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  if (src == dest) {
    orc_sse_emit_movdqa (p, src, tmp);
  } else {
    orc_sse_emit_movdqa (p, src, tmp);
    orc_sse_emit_movdqa (p, tmp, dest);
  }

  orc_sse_emit_psrad_imm (p, 31, tmp);
  orc_sse_emit_pxor (p, tmp, dest);
  orc_sse_emit_psubd (p, tmp, dest);

}

static void
sse_rule_shift (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int type = ORC_PTR_TO_INT(user);
  /* int imm_code1[] = { 0x71, 0x71, 0x71, 0x72, 0x72, 0x72, 0x73, 0x73 }; */
  /* int imm_code2[] = { 6, 2, 4, 6, 2, 4, 6, 2 }; */
  /* int reg_code[] = { 0xf1, 0xd1, 0xe1, 0xf2, 0xd2, 0xe2, 0xf3, 0xd3 }; */
  /* const char *code[] = { "psllw", "psrlw", "psraw", "pslld", "psrld", "psrad", "psllq", "psrlq" }; */
  const int opcodes[] = { ORC_X86_psllw, ORC_X86_psrlw, ORC_X86_psraw,
    ORC_X86_pslld, ORC_X86_psrld, ORC_X86_psrad, ORC_X86_psllq,
    ORC_X86_psrlq };
  const int opcodes_imm[] = { ORC_X86_psllw_imm, ORC_X86_psrlw_imm,
    ORC_X86_psraw_imm, ORC_X86_pslld_imm, ORC_X86_psrld_imm,
    ORC_X86_psrad_imm, ORC_X86_psllq_imm, ORC_X86_psrlq_imm };

  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) {
    orc_x86_emit_cpuinsn_imm (p, opcodes_imm[type],
        p->vars[insn->src_args[1]].value.i, 16,
        p->vars[insn->dest_args[0]].alloc);
  } else if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_PARAM) {
    int tmp = orc_compiler_get_temp_reg (p);

    /* FIXME this is a gross hack to reload the register with a
     * 64-bit version of the parameter. */
    orc_x86_emit_mov_memoffset_sse (p, 4,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, params[insn->src_args[1]]),
        p->exec_reg, tmp, FALSE);

    orc_x86_emit_cpuinsn_size (p, opcodes[type], 16, tmp,
        p->vars[insn->dest_args[0]].alloc);
  } else {
    orc_compiler_error (p, "code generation rule for %s only works with "
        "constant or parameter shifts", insn->opcode->name);
    p->result = ORC_COMPILE_RESULT_UNKNOWN_COMPILE;
  }
}

static void
sse_rule_shlb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) {
    orc_sse_emit_psllw_imm (p, p->vars[insn->src_args[1]].value.i, dest);
    tmp = orc_compiler_get_constant (p, 1,
        0xff&(0xff<<p->vars[insn->src_args[1]].value.i));
    orc_sse_emit_pand (p, tmp, dest);
  } else {
    orc_compiler_error (p, "code generation rule for %s only works with "
        "constant shifts", insn->opcode->name);
    p->result = ORC_COMPILE_RESULT_UNKNOWN_COMPILE;
  }
}

static void
sse_rule_shrsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) {
    orc_sse_emit_movdqa (p, src, tmp);
    orc_sse_emit_psllw_imm (p, 8, tmp);
    orc_sse_emit_psraw_imm (p, p->vars[insn->src_args[1]].value.i, tmp);
    orc_sse_emit_psrlw_imm (p, 8, tmp);

    orc_sse_emit_psraw_imm (p, 8 + p->vars[insn->src_args[1]].value.i, dest);
    orc_sse_emit_psllw_imm (p, 8, dest);

    orc_sse_emit_por (p, tmp, dest);
  } else {
    orc_compiler_error (p, "code generation rule for %s only works with "
        "constant shifts", insn->opcode->name);
    p->result = ORC_COMPILE_RESULT_UNKNOWN_COMPILE;
  }
}

static void
sse_rule_shrub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) {
    orc_sse_emit_psrlw_imm (p, p->vars[insn->src_args[1]].value.i, dest);
    tmp = orc_compiler_get_constant (p, 1,
        (0xff>>p->vars[insn->src_args[1]].value.i));
    orc_sse_emit_pand (p, tmp, dest);
  } else {
    orc_compiler_error (p, "code generation rule for %s only works with "
        "constant shifts", insn->opcode->name);
    p->result = ORC_COMPILE_RESULT_UNKNOWN_COMPILE;
  }
}

static void
sse_rule_shrsq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  if (p->vars[insn->src_args[1]].vartype == ORC_VAR_TYPE_CONST) {
#ifndef MMX
    orc_sse_emit_pshufd (p, ORC_SSE_SHUF(3,3,1,1), src, tmp);
#else
    orc_mmx_emit_pshufw (p, ORC_MMX_SHUF(3,2,3,2), src, tmp);
#endif
    orc_sse_emit_psrad_imm (p, 31, tmp);
    orc_sse_emit_psllq_imm (p, 64-p->vars[insn->src_args[1]].value.i, tmp);

    orc_sse_emit_psrlq_imm (p, p->vars[insn->src_args[1]].value.i, dest);
    orc_sse_emit_por (p, tmp, dest);
  } else {
    orc_compiler_error (p, "code generation rule for %s only works with "
        "constant shifts", insn->opcode->name);
    p->result = ORC_COMPILE_RESULT_UNKNOWN_COMPILE;
  }
}

static void
sse_rule_convsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklbw (p, src, dest);
  orc_sse_emit_psraw_imm (p, 8, dest);
}

static void
sse_rule_convubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  /* FIXME need a zero register */
  if (0) {
    orc_sse_emit_punpcklbw (p, src, dest);
    orc_sse_emit_psrlw_imm (p, 8, dest);
  } else {
    orc_sse_emit_pxor(p, tmp, tmp);
    orc_sse_emit_punpcklbw (p, tmp, dest);
  }
}

static void
sse_rule_convssswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_packsswb (p, src, dest);
}

static void
sse_rule_convsuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_packuswb (p, src, dest);
}

static void
sse_rule_convuuswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_movdqa (p, src, dest);
  orc_sse_emit_psrlw_imm (p, 15, tmp);
  orc_sse_emit_psllw_imm (p, 14, tmp);
  orc_sse_emit_por (p, tmp, dest);
  orc_sse_emit_psllw_imm (p, 1, tmp);
  orc_sse_emit_pxor (p, tmp, dest);
  orc_sse_emit_packuswb (p, dest, dest);
}

static void
sse_rule_convwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_psllw_imm (p, 8, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_packuswb (p, dest, dest);
}

static void
sse_rule_convhwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_packuswb (p, dest, dest);
}

static void
sse_rule_convswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklwd (p, src, dest);
  orc_sse_emit_psrad_imm (p, 16, dest);
}

static void
sse_rule_convuwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  /* FIXME need a zero register */
  if (0) {
    orc_sse_emit_punpcklwd (p, src, dest);
    orc_sse_emit_psrld_imm (p, 16, dest);
  } else {
    orc_sse_emit_pxor(p, tmp, tmp);
    orc_sse_emit_punpcklwd (p, tmp, dest);
  }
}

static void
sse_rule_convlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_pslld_imm (p, 16, dest);
  orc_sse_emit_psrad_imm (p, 16, dest);
  orc_sse_emit_packssdw (p, dest, dest);
}

static void
sse_rule_convhlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_psrad_imm (p, 16, dest);
  orc_sse_emit_packssdw (p, dest, dest);
}

static void
sse_rule_convssslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_packssdw (p, src, dest);
}

static void
sse_rule_convsuslw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_packusdw (p, src, dest);
}

static void
sse_rule_convslq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_psrad_imm (p, 31, tmp);
  orc_sse_emit_punpckldq (p, tmp, dest);
}

static void
sse_rule_convulq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_get_constant (p, 4, 0);
  orc_sse_emit_punpckldq (p, tmp, dest);
}

static void
sse_rule_convql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

#ifndef MMX
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,2,0), src, dest);
#else
  orc_sse_emit_movdqa (p, src, dest);
#endif
}

static void
sse_rule_splatw3q (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

#ifndef MMX
  orc_sse_emit_pshuflw (p, ORC_SSE_SHUF(3,3,3,3), dest, dest);
  orc_sse_emit_pshufhw (p, ORC_SSE_SHUF(3,3,3,3), dest, dest);
#else
  orc_mmx_emit_pshufw (p, ORC_SSE_SHUF(3,3,3,3), dest, dest);
#endif
}

static void
sse_rule_splatbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklbw (p, dest, dest);
}

static void
sse_rule_splatbl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklbw (p, dest, dest);
  orc_sse_emit_punpcklwd (p, dest, dest);
}

static void
sse_rule_div255w (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmpc;

  tmpc = orc_compiler_get_constant (p, 2, 0x0080);
  orc_sse_emit_paddw (p, tmpc, dest);
  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_psrlw_imm (p, 8, tmp);
  orc_sse_emit_paddw (p, tmp, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);
}

#if 1
static void
sse_rule_divluw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* About 5.2 cycles per array member on ginger */
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int a = orc_compiler_get_temp_reg (p);
  int j = orc_compiler_get_temp_reg (p);
  int j2 = orc_compiler_get_temp_reg (p);
  int l = orc_compiler_get_temp_reg (p);
  int divisor = orc_compiler_get_temp_reg (p);
  int tmp;
  int i;

  orc_sse_emit_movdqa (p, src, divisor);
  orc_sse_emit_psllw_imm (p, 8, divisor);
  orc_sse_emit_psrlw_imm (p, 1, divisor);

  orc_sse_load_constant (p, a, 2, 0x00ff);
  tmp = orc_compiler_get_constant (p, 2, 0x8000);
  orc_sse_emit_movdqa (p, tmp, j);
  orc_sse_emit_psrlw_imm (p, 8, j);

  orc_sse_emit_pxor (p, tmp, dest);

  for(i=0;i<7;i++){
    orc_sse_emit_movdqa (p, divisor, l);
    orc_sse_emit_pxor (p, tmp, l);
    orc_sse_emit_pcmpgtw (p, dest, l);
    orc_sse_emit_movdqa (p, l, j2);
    orc_sse_emit_pandn (p, divisor, l);
    orc_sse_emit_psubw (p, l, dest);
    orc_sse_emit_psrlw_imm (p, 1, divisor);

     orc_sse_emit_pand (p, j, j2);
     orc_sse_emit_pxor (p, j2, a);
     orc_sse_emit_psrlw_imm (p, 1, j);
  }
  
  orc_sse_emit_movdqa (p, divisor, l);
  orc_sse_emit_pxor (p, tmp, l);
  orc_sse_emit_pcmpgtw (p, dest, l);
  orc_sse_emit_pand (p, j, l);
  orc_sse_emit_pxor (p, l, a);

  orc_sse_emit_movdqa (p, a, dest);
}
#else
static void
sse_rule_divluw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* About 8.4 cycles per array member on ginger */
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int b = orc_compiler_get_temp_reg (p);
  int a = orc_compiler_get_temp_reg (p);
  int k = orc_compiler_get_temp_reg (p);
  int j = orc_compiler_get_temp_reg (p);
  int tmp;
  int i;

  orc_sse_emit_movdqa (p, dest, b);
  tmp = orc_compiler_get_constant (p, 2, 0x00ff);
  orc_sse_emit_pand (p, tmp, src);

  tmp = orc_compiler_get_constant (p, 2, 0x8000);
  orc_sse_emit_pxor (p, tmp, b);

  orc_sse_emit_pxor (p, a, a);
  orc_sse_emit_movdqa (p, tmp, j);
  orc_sse_emit_psrlw_imm (p, 8, j);

  for(i=0;i<8;i++){
    orc_sse_emit_por (p, j, a);
    orc_sse_emit_movdqa (p, a, k);
    orc_sse_emit_pmullw (p, src, k);
    orc_sse_emit_pxor (p, tmp, k);
    orc_sse_emit_pcmpgtw (p, b, k);
    orc_sse_emit_pand (p, j, k);
    orc_sse_emit_pxor (p, k, a);
    orc_sse_emit_psrlw_imm (p, 1, j);
  }

  orc_sse_emit_movdqa (p, a, dest);
}
#endif

static void
sse_rule_mulsbw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_punpcklbw (p, src, tmp);
  orc_sse_emit_psraw_imm (p, 8, tmp);
  orc_sse_emit_punpcklbw (p, dest, dest);
  orc_sse_emit_psraw_imm (p, 8, dest);
  orc_sse_emit_pmullw (p, tmp, dest);
}

static void
sse_rule_mulubw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_punpcklbw (p, src, tmp);
  orc_sse_emit_psrlw_imm (p, 8, tmp);
  orc_sse_emit_punpcklbw (p, dest, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_pmullw (p, tmp, dest);
}

static void
sse_rule_mullb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, dest, tmp);

  orc_sse_emit_pmullw (p, src, dest);
  orc_sse_emit_psllw_imm (p, 8, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);

  orc_sse_emit_movdqa (p, src, tmp2);
  orc_sse_emit_psraw_imm (p, 8, tmp2);
  orc_sse_emit_psraw_imm (p, 8, tmp);
  orc_sse_emit_pmullw (p, tmp2, tmp);
  orc_sse_emit_psllw_imm (p, 8, tmp);

  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_mulhsb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_movdqa (p, dest, tmp2);
  orc_sse_emit_psllw_imm (p, 8, tmp);
  orc_sse_emit_psraw_imm (p, 8, tmp);

  orc_sse_emit_psllw_imm (p, 8, dest);
  orc_sse_emit_psraw_imm (p, 8, dest);

  orc_sse_emit_pmullw (p, tmp, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_psraw_imm (p, 8, tmp);
  orc_sse_emit_psraw_imm (p, 8, tmp2);
  orc_sse_emit_pmullw (p, tmp, tmp2);
  orc_sse_emit_psrlw_imm (p, 8, tmp2);
  orc_sse_emit_psllw_imm (p, 8, tmp2);
  orc_sse_emit_por (p, tmp2, dest);
}

static void
sse_rule_mulhub (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_movdqa (p, dest, tmp2);
  orc_sse_emit_psllw_imm (p, 8, tmp);
  orc_sse_emit_psrlw_imm (p, 8, tmp);

  orc_sse_emit_psllw_imm (p, 8, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);

  orc_sse_emit_pmullw (p, tmp, dest);
  orc_sse_emit_psrlw_imm (p, 8, dest);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_psrlw_imm (p, 8, tmp);
  orc_sse_emit_psrlw_imm (p, 8, tmp2);
  orc_sse_emit_pmullw (p, tmp, tmp2);
  orc_sse_emit_psrlw_imm (p, 8, tmp2);
  orc_sse_emit_psllw_imm (p, 8, tmp2);
  orc_sse_emit_por (p, tmp2, dest);
}

static void
sse_rule_mulswl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pmulhw (p, src, tmp);
  orc_sse_emit_pmullw (p, src, dest);
  orc_sse_emit_punpcklwd (p, tmp, dest);
}

static void
sse_rule_muluwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pmulhuw (p, src, tmp);
  orc_sse_emit_pmullw (p, src, dest);
  orc_sse_emit_punpcklwd (p, tmp, dest);
}

static void
sse_rule_mulll_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int i;
  int offset = ORC_STRUCT_OFFSET(OrcExecutor,arrays[ORC_VAR_T1]);

  orc_x86_emit_mov_sse_memoffset (p, 16, p->vars[insn->src_args[0]].alloc,
      offset, p->exec_reg, FALSE, FALSE);
  orc_x86_emit_mov_sse_memoffset (p, 16, p->vars[insn->src_args[1]].alloc,
      offset + 16, p->exec_reg, FALSE, FALSE);

  for(i=0;i<(1<<p->insn_shift);i++) {
    orc_x86_emit_mov_memoffset_reg (p, 4, offset + 4*i, p->exec_reg,
        p->gp_tmpreg);
    orc_x86_emit_imul_memoffset_reg (p, 4, offset + 16+4*i, p->exec_reg,
        p->gp_tmpreg);
    orc_x86_emit_mov_reg_memoffset (p, 4, p->gp_tmpreg, offset + 4*i,
        p->exec_reg);
  }

  orc_x86_emit_mov_memoffset_sse (p, 16, offset, p->exec_reg,
      p->vars[insn->dest_args[0]].alloc, FALSE);
}

#ifndef MMX
static void
sse_rule_mulhsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,3,0,1), dest, tmp);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,3,0,1), src, tmp2);
  orc_sse_emit_pmuldq (p, src, dest);
  orc_sse_emit_pmuldq (p, tmp, tmp2);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,3,1), dest, dest);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,3,1), tmp2, tmp2);
  orc_sse_emit_punpckldq (p, tmp2, dest);
}
#endif

#ifndef MMX
static void
sse_rule_mulhsl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int i;
  int regsize = p->is_64bit ? 8 : 4;
  int offset = ORC_STRUCT_OFFSET(OrcExecutor,arrays[ORC_VAR_T1]);

  orc_x86_emit_mov_sse_memoffset (p, 16, p->vars[insn->src_args[0]].alloc,
      offset, p->exec_reg, FALSE, FALSE);
  orc_x86_emit_mov_sse_memoffset (p, 16, p->vars[insn->src_args[1]].alloc,
      offset + 16, p->exec_reg, FALSE, FALSE);
  orc_x86_emit_mov_reg_memoffset (p, regsize, X86_EAX, offset + 32,
      p->exec_reg);
  orc_x86_emit_mov_reg_memoffset (p, regsize, X86_EDX, offset + 40,
      p->exec_reg);

  for(i=0;i<(1<<p->insn_shift);i++) {
    orc_x86_emit_mov_memoffset_reg (p, 4, offset + 4*i, p->exec_reg, X86_EAX);
    orc_x86_emit_cpuinsn_memoffset (p, ORC_X86_imul_rm, 4,
        offset + 16 + 4*i, p->exec_reg);
    orc_x86_emit_mov_reg_memoffset (p, 4, X86_EDX, offset + 4*i, p->exec_reg);
  }

  orc_x86_emit_mov_memoffset_sse (p, 16, offset, p->exec_reg,
      p->vars[insn->dest_args[0]].alloc, FALSE);
  orc_x86_emit_mov_memoffset_reg (p, regsize, offset + 32, p->exec_reg, X86_EAX);
  orc_x86_emit_mov_memoffset_reg (p, regsize, offset + 40, p->exec_reg, X86_EDX);
}
#endif

#ifndef MMX
static void
sse_rule_mulhul (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,3,0,1), dest, tmp);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,3,0,1), src, tmp2);
  orc_sse_emit_pmuludq (p, src, dest);
  orc_sse_emit_pmuludq (p, tmp, tmp2);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,3,1), dest, dest);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,3,1), tmp2, tmp2);
  orc_sse_emit_punpckldq (p, tmp2, dest);
}
#endif

static void
sse_rule_mulslq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_punpckldq (p, dest, dest);
  orc_sse_emit_punpckldq (p, tmp, tmp);
  orc_sse_emit_pmuldq (p, tmp, dest);
}

#ifndef MMX
static void
sse_rule_mulslq_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int i;
  int regsize = p->is_64bit ? 8 : 4;
  int offset = ORC_STRUCT_OFFSET(OrcExecutor,arrays[ORC_VAR_T1]);

  orc_x86_emit_mov_sse_memoffset (p, 8, p->vars[insn->src_args[0]].alloc,
      offset, p->exec_reg, FALSE, FALSE);
  orc_x86_emit_mov_sse_memoffset (p, 8, p->vars[insn->src_args[1]].alloc,
      offset + 8, p->exec_reg, FALSE, FALSE);
  orc_x86_emit_mov_reg_memoffset (p, regsize, X86_EAX, offset + 32,
      p->exec_reg);
  orc_x86_emit_mov_reg_memoffset (p, regsize, X86_EDX, offset + 40,
      p->exec_reg);

  for(i=0;i<(1<<p->insn_shift);i++) {
    orc_x86_emit_mov_memoffset_reg (p, 4, offset + 4*i, p->exec_reg, X86_EAX);
    orc_x86_emit_cpuinsn_memoffset (p, ORC_X86_imul_rm, 4,
        offset + 8 + 4*i, p->exec_reg);
    orc_x86_emit_mov_reg_memoffset (p, 4, X86_EAX, offset + 16 + 8*i, p->exec_reg);
    orc_x86_emit_mov_reg_memoffset (p, 4, X86_EDX, offset + 16 + 8*i + 4, p->exec_reg);
  }

  orc_x86_emit_mov_memoffset_sse (p, 16, offset + 16, p->exec_reg,
      p->vars[insn->dest_args[0]].alloc, FALSE);
  orc_x86_emit_mov_memoffset_reg (p, regsize, offset + 32, p->exec_reg, X86_EAX);
  orc_x86_emit_mov_memoffset_reg (p, regsize, offset + 40, p->exec_reg, X86_EDX);
}
#endif

#ifndef MMX
static void
sse_rule_mululq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_punpckldq (p, dest, dest);
  orc_sse_emit_punpckldq (p, tmp, tmp);
  orc_sse_emit_pmuludq (p, tmp, dest);
}
#endif

static void
sse_rule_select0lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* int src = p->vars[insn->src_args[0]].alloc; */
  int dest = p->vars[insn->dest_args[0]].alloc;

  /* FIXME slow */
  /* same as convlw */

  orc_sse_emit_pslld_imm (p, 16, dest);
  orc_sse_emit_psrad_imm (p, 16, dest);
  orc_sse_emit_packssdw (p, dest, dest);
}

static void
sse_rule_select1lw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* int src = p->vars[insn->src_args[0]].alloc; */
  int dest = p->vars[insn->dest_args[0]].alloc;

  /* FIXME slow */

  orc_sse_emit_psrad_imm (p, 16, dest);
  orc_sse_emit_packssdw (p, dest, dest);
}

static void
sse_rule_select0ql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  /* same as convql */
#ifndef MMX
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,2,0), src, dest);
#else
  orc_sse_emit_movdqa (p, src, dest);
#endif
}

static void
sse_rule_select1ql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_psrlq_imm (p, 32, dest);
#ifndef MMX
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,2,0), src, dest);
#else
  orc_sse_emit_movdqa (p, src, dest);
#endif
}

static void
sse_rule_select0wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* int src = p->vars[insn->src_args[0]].alloc; */
  int dest = p->vars[insn->dest_args[0]].alloc;

  /* FIXME slow */
  /* same as convwb */

  orc_sse_emit_psllw_imm (p, 8, dest);
  orc_sse_emit_psraw_imm (p, 8, dest);
  orc_sse_emit_packsswb (p, dest, dest);
}

static void
sse_rule_select1wb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  /* int src = p->vars[insn->src_args[0]].alloc; */
  int dest = p->vars[insn->dest_args[0]].alloc;

  /* FIXME slow */

  orc_sse_emit_psraw_imm (p, 8, dest);
  orc_sse_emit_packsswb (p, dest, dest);
}

static void
sse_rule_splitql (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest1 = p->vars[insn->dest_args[0]].alloc;
  int dest2 = p->vars[insn->dest_args[1]].alloc;

#ifndef MMX
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,0,2,0), src, dest2);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(3,1,3,1), src, dest1);
#else
  orc_sse_emit_movdqa (p, src, dest2);
  orc_sse_emit_pshufw (p, ORC_SSE_SHUF(3,2,3,2), src, dest1);
#endif
}

static void
sse_rule_splitlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest1 = p->vars[insn->dest_args[0]].alloc;
  int dest2 = p->vars[insn->dest_args[1]].alloc;

  /* FIXME slow */

  orc_sse_emit_psrad_imm (p, 16, dest1);
  orc_sse_emit_packssdw (p, dest1, dest1);

  if (dest2 != src) {
    orc_sse_emit_movdqa (p, src, dest2);
  }
  orc_sse_emit_pslld_imm (p, 16, dest2);
  orc_sse_emit_psrad_imm (p, 16, dest2);
  orc_sse_emit_packssdw (p, dest2, dest2);

}

static void
sse_rule_splitwb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest1 = p->vars[insn->dest_args[0]].alloc;
  int dest2 = p->vars[insn->dest_args[1]].alloc;
  int tmp = orc_compiler_get_constant (p, 2, 0xff);

  /* FIXME slow */

  orc_sse_emit_psraw_imm (p, 8, dest1);
  orc_sse_emit_packsswb (p, dest1, dest1);

  if (dest2 != src) {
    orc_sse_emit_movdqa (p, src, dest2);
  }

#if 0
  orc_sse_emit_psllw_imm (p, 8, dest2);
  orc_sse_emit_psraw_imm (p, 8, dest2);
  orc_sse_emit_packsswb (p, dest2, dest2);
#else
  orc_sse_emit_pand (p, tmp, dest2);
  orc_sse_emit_packuswb (p, dest2, dest2);
#endif
}

static void
sse_rule_mergebw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklbw (p, src, dest);
}

static void
sse_rule_mergewl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpcklwd (p, src, dest);
}

static void
sse_rule_mergelq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;

  orc_sse_emit_punpckldq (p, src, dest);
}

static void
sse_rule_swapw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_psllw_imm (p, 8, tmp);
  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_swapl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pslld_imm (p, 16, tmp);
  orc_sse_emit_psrld_imm (p, 16, dest);
  orc_sse_emit_por (p, tmp, dest);
  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_psllw_imm (p, 8, tmp);
  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_swapwl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pslld_imm (p, 16, tmp);
  orc_sse_emit_psrld_imm (p, 16, dest);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_swapq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_psllq_imm (p, 32, tmp);
  orc_sse_emit_psrlq_imm (p, 32, dest);
  orc_sse_emit_por (p, tmp, dest);
  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pslld_imm (p, 16, tmp);
  orc_sse_emit_psrld_imm (p, 16, dest);
  orc_sse_emit_por (p, tmp, dest);
  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_psllw_imm (p, 8, tmp);
  orc_sse_emit_psrlw_imm (p, 8, dest);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_swaplq (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;

#ifndef MMX
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(2,3,0,1), dest, dest);
#else
  orc_mmx_emit_pshufw (p, ORC_MMX_SHUF(1,0,3,2), dest, dest);
#endif
}

#ifndef MMX
static void
sse_rule_swapw_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x02030001, 0x06070405, 0x0a0b0809, 0x0e0f0c0d);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_swapw (p, user, insn);
  }
}

static void
sse_rule_swapl_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_swapl (p, user, insn);
  }
}

static void
sse_rule_swapwl_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x01000302, 0x05040706, 0x09080b0a, 0x0d0c0f0e);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_swapl (p, user, insn);
  }
}

static void
sse_rule_swapq_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x04050607, 0x00010203, 0x0c0d0e0f, 0x08090a0b);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_swapq (p, user, insn);
  }
}

static void
sse_rule_select0lw_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x05040100, 0x0d0c0908, 0x05040100, 0x0d0c0908);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_select0lw (p, user, insn);
  }
}

static void
sse_rule_select1lw_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x07060302, 0x0f0e0b0a, 0x07060302, 0x0f0e0b0a);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_select1lw (p, user, insn);
  }
}

static void
sse_rule_select0wb_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x06040200, 0x0e0c0a08, 0x06040200, 0x0e0c0a08);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_select0wb (p, user, insn);
  }
}

static void
sse_rule_select1wb_ssse3 (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_try_get_constant_long (p,
      0x07050301, 0x0f0d0b09, 0x07050301, 0x0f0d0b09);
  if (tmp != ORC_REG_INVALID) {
    orc_sse_emit_pshufb (p, tmp, dest);
  } else {
    sse_rule_select1wb (p, user, insn);
  }
}
#endif

/* slow rules */

static void
sse_rule_maxuw_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  tmp = orc_compiler_get_constant (p, 2, 0x8000);
  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
  orc_sse_emit_pmaxsw (p, src, dest);
  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
}

static void
sse_rule_minuw_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_get_constant (p, 2, 0x8000);

  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
  orc_sse_emit_pminsw (p, src, dest);
  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
}

static void
sse_rule_avgsb_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_get_constant (p, 1, 0x80);

  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
  orc_sse_emit_pavgb (p, src, dest);
  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
}

static void
sse_rule_avgsw_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp;

  tmp = orc_compiler_get_constant (p, 2, 0x8000);

  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
  orc_sse_emit_pavgw (p, src, dest);
  orc_sse_emit_pxor(p, tmp, src);
  orc_sse_emit_pxor(p, tmp, dest);
}

static void
sse_rule_maxsb_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pcmpgtb (p, src, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_minsb_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pcmpgtb (p, dest, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_maxsl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pcmpgtd (p, src, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_minsl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pcmpgtd (p, dest, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_maxul_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmpc;

  tmpc = orc_compiler_get_constant (p, 4, 0x80000000);
  orc_sse_emit_pxor(p, tmpc, src);
  orc_sse_emit_pxor(p, tmpc, dest);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pcmpgtd (p, src, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);

  orc_sse_emit_pxor(p, tmpc, src);
  orc_sse_emit_pxor(p, tmpc, dest);
}

static void
sse_rule_minul_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmpc;

  tmpc = orc_compiler_get_constant (p, 4, 0x80000000);
  orc_sse_emit_pxor(p, tmpc, src);
  orc_sse_emit_pxor(p, tmpc, dest);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pcmpgtd (p, dest, tmp);
  orc_sse_emit_pand (p, tmp, dest);
  orc_sse_emit_pandn (p, src, tmp);
  orc_sse_emit_por (p, tmp, dest);

  orc_sse_emit_pxor(p, tmpc, src);
  orc_sse_emit_pxor(p, tmpc, dest);
}

static void
sse_rule_avgsl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  /* (a+b+1) >> 1 = (a|b) - ((a^b)>>1) */

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pxor(p, src, tmp);
  orc_sse_emit_psrad_imm(p, 1, tmp);

  orc_sse_emit_por(p, src, dest);
  orc_sse_emit_psubd(p, tmp, dest);
}

static void
sse_rule_avgul (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);

  /* (a+b+1) >> 1 = (a|b) - ((a^b)>>1) */

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_pxor(p, src, tmp);
  orc_sse_emit_psrld_imm(p, 1, tmp);

  orc_sse_emit_por(p, src, dest);
  orc_sse_emit_psubd(p, tmp, dest);
}

static void
sse_rule_addssl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
#if 0
  int tmp2 = orc_compiler_get_temp_reg (p);
  int tmp3 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pand (p, dest, tmp);

  orc_sse_emit_movdqa (p, src, tmp2);
  orc_sse_emit_pxor (p, dest, tmp2);
  orc_sse_emit_psrad_imm (p, 1, tmp2);
  orc_sse_emit_paddd (p, tmp2, tmp);

  orc_sse_emit_psrad (p, 30, tmp);
  orc_sse_emit_pslld (p, 30, tmp);
  orc_sse_emit_movdqa (p, tmp, tmp2);
  orc_sse_emit_pslld_imm (p, 1, tmp2);
  orc_sse_emit_movdqa (p, tmp, tmp3);
  orc_sse_emit_pxor (p, tmp2, tmp3);
  orc_sse_emit_psrad_imm (p, 31, tmp3);

  orc_sse_emit_psrad_imm (p, 31, tmp2);
  tmp = orc_compiler_get_constant (p, 4, 0x80000000);
  orc_sse_emit_pxor (p, tmp, tmp2); /*  clamped value */
  orc_sse_emit_pand (p, tmp3, tmp2);

  orc_sse_emit_paddd (p, src, dest);
  orc_sse_emit_pandn (p, dest, tmp3); /*  tmp is mask: ~0 is for clamping */
  orc_sse_emit_movdqa (p, tmp3, dest);

  orc_sse_emit_por (p, tmp2, dest);
#endif

  int s = orc_compiler_get_temp_reg (p);
  int t = orc_compiler_get_temp_reg (p);

  /*
     From Tim Terriberry: (slightly faster than above)

     m=0xFFFFFFFF;
     s=_a;
     t=_a;
     s^=_b;
     _a+=_b;
     t^=_a;
     t^=m;
     m>>=1;
     s|=t;
     t=_b;
     s>>=31;
     t>>=31;
     _a&=s;
     t^=m;
     s=~s&t;
     _a|=s; 
  */

  orc_sse_emit_movdqa (p, dest, s);
  orc_sse_emit_movdqa (p, dest, t);
  orc_sse_emit_pxor (p, src, s);
  orc_sse_emit_paddd (p, src, dest);
  orc_sse_emit_pxor (p, dest, t);
  tmp = orc_compiler_get_constant (p, 4, 0xffffffff);
  orc_sse_emit_pxor (p, tmp, t);
  orc_sse_emit_por (p, t, s);
  orc_sse_emit_movdqa (p, src, t);
  orc_sse_emit_psrad_imm (p, 31, s);
  orc_sse_emit_psrad_imm (p, 31, t);
  orc_sse_emit_pand (p, s, dest);
  tmp = orc_compiler_get_constant (p, 4, 0x7fffffff);
  orc_sse_emit_pxor (p, tmp, t);
  orc_sse_emit_pandn (p, t, s);
  orc_sse_emit_por (p, s, dest);
}

static void
sse_rule_subssl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);
  int tmp3 = orc_compiler_get_temp_reg (p);

  tmp = orc_compiler_get_temp_constant (p, 4, 0xffffffff);
  orc_sse_emit_pxor (p, src, tmp);
  orc_sse_emit_movdqa (p, tmp, tmp2);
  orc_sse_emit_por (p, dest, tmp);

  orc_sse_emit_pxor (p, dest, tmp2);
  orc_sse_emit_psrad_imm (p, 1, tmp2);
  orc_sse_emit_psubd (p, tmp2, tmp);

  orc_sse_emit_psrad_imm (p, 30, tmp);
  orc_sse_emit_pslld_imm (p, 30, tmp);
  orc_sse_emit_movdqa (p, tmp, tmp2);
  orc_sse_emit_pslld_imm (p, 1, tmp2);
  orc_sse_emit_movdqa (p, tmp, tmp3);
  orc_sse_emit_pxor (p, tmp2, tmp3);
  orc_sse_emit_psrad_imm (p, 31, tmp3); /*  tmp3 is mask: ~0 is for clamping */

  orc_sse_emit_psrad_imm (p, 31, tmp2);
  tmp = orc_compiler_get_constant (p, 4, 0x80000000);
  orc_sse_emit_pxor (p, tmp, tmp2); /*  clamped value */
  orc_sse_emit_pand (p, tmp3, tmp2);

  orc_sse_emit_psubd (p, src, dest);
  orc_sse_emit_pandn (p, dest, tmp3);
  orc_sse_emit_movdqa (p, tmp3, dest);

  orc_sse_emit_por (p, tmp2, dest);

}

static void
sse_rule_addusl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

#if 0
  /* an alternate version.  slower. */
  /* Compute the bit that gets carried from bit 0 to bit 1 */
  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pand (p, dest, tmp);
  orc_sse_emit_pslld_imm (p, 31, tmp);
  orc_sse_emit_psrld_imm (p, 31, tmp);

  /* Add in (src>>1) */
  orc_sse_emit_movdqa (p, src, tmp2);
  orc_sse_emit_psrld_imm (p, 1, tmp2);
  orc_sse_emit_paddd (p, tmp2, tmp);

  /* Add in (dest>>1) */
  orc_sse_emit_movdqa (p, dest, tmp2);
  orc_sse_emit_psrld_imm (p, 1, tmp2);
  orc_sse_emit_paddd (p, tmp2, tmp);

  /* turn overflow bit into mask */
  orc_sse_emit_psrad_imm (p, 31, tmp);

  /* compute the sum, then or over the mask */
  orc_sse_emit_paddd (p, src, dest);
  orc_sse_emit_por (p, tmp, dest);
#endif

  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_pand (p, dest, tmp);

  orc_sse_emit_movdqa (p, src, tmp2);
  orc_sse_emit_pxor (p, dest, tmp2);
  orc_sse_emit_psrld_imm (p, 1, tmp2);
  orc_sse_emit_paddd (p, tmp2, tmp);

  orc_sse_emit_psrad_imm (p, 31, tmp);
  orc_sse_emit_paddd (p, src, dest);
  orc_sse_emit_por (p, tmp, dest);
}

static void
sse_rule_subusl_slow (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[1]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmp = orc_compiler_get_temp_reg (p);
  int tmp2 = orc_compiler_get_temp_reg (p);

  orc_sse_emit_movdqa (p, src, tmp2);
  orc_sse_emit_psrld_imm (p, 1, tmp2);

  orc_sse_emit_movdqa (p, dest, tmp);
  orc_sse_emit_psrld_imm (p, 1, tmp);
  orc_sse_emit_psubd (p, tmp, tmp2);

  /* turn overflow bit into mask */
  orc_sse_emit_psrad_imm (p, 31, tmp2);

  /* compute the difference, then and over the mask */
  orc_sse_emit_psubd (p, src, dest);
  orc_sse_emit_pand (p, tmp2, dest);

}

#ifndef MMX
/* float ops */

#define UNARY_F(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[0]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

#define BINARY_F(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[1]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

BINARY_F(addf, addps, 0x58)
BINARY_F(subf, subps, 0x5c)
BINARY_F(mulf, mulps, 0x59)
BINARY_F(divf, divps, 0x5e)
UNARY_F(sqrtf, sqrtps, 0x51)

#define UNARY_D(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[0]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

#define BINARY_D(opcode,insn_name,code) \
static void \
sse_rule_ ## opcode (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[1]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

BINARY_D(addd, addpd, 0x58)
BINARY_D(subd, subpd, 0x5c)
BINARY_D(muld, mulpd, 0x59)
BINARY_D(divd, divpd, 0x5e)
UNARY_D(sqrtd, sqrtpd, 0x51)

static void
sse_rule_minf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  if (p->target_flags & ORC_TARGET_FAST_NAN) {
    orc_sse_emit_minps (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
  } else {
    int tmp = orc_compiler_get_temp_reg (p);
    orc_sse_emit_movdqa (p,
        p->vars[insn->src_args[1]].alloc,
        tmp);
    orc_sse_emit_minps (p,
        p->vars[insn->dest_args[0]].alloc,
        tmp);
    orc_sse_emit_minps (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
    orc_sse_emit_por (p,
        tmp,
        p->vars[insn->dest_args[0]].alloc);
  }
}

static void
sse_rule_mind (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  if (p->target_flags & ORC_TARGET_FAST_NAN) {
    orc_sse_emit_minpd (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
  } else {
    int tmp = orc_compiler_get_temp_reg (p);
    orc_sse_emit_movdqa (p,
        p->vars[insn->src_args[1]].alloc,
        tmp);
    orc_sse_emit_minpd (p,
        p->vars[insn->dest_args[0]].alloc,
        tmp);
    orc_sse_emit_minpd (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
    orc_sse_emit_por (p,
        tmp,
        p->vars[insn->dest_args[0]].alloc);
  }
}

static void
sse_rule_maxf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  if (p->target_flags & ORC_TARGET_FAST_NAN) {
    orc_sse_emit_maxps (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
  } else {
    int tmp = orc_compiler_get_temp_reg (p);
    orc_sse_emit_movdqa (p,
        p->vars[insn->src_args[1]].alloc,
        tmp);
    orc_sse_emit_maxps (p,
        p->vars[insn->dest_args[0]].alloc,
        tmp);
    orc_sse_emit_maxps (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
    orc_sse_emit_por (p,
        tmp,
        p->vars[insn->dest_args[0]].alloc);
  }
}

static void
sse_rule_maxd (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  if (p->target_flags & ORC_TARGET_FAST_NAN) {
    orc_sse_emit_maxpd (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
  } else {
    int tmp = orc_compiler_get_temp_reg (p);
    orc_sse_emit_movdqa (p,
        p->vars[insn->src_args[1]].alloc,
        tmp);
    orc_sse_emit_maxpd (p,
        p->vars[insn->dest_args[0]].alloc,
        tmp);
    orc_sse_emit_maxpd (p,
        p->vars[insn->src_args[1]].alloc,
        p->vars[insn->dest_args[0]].alloc);
    orc_sse_emit_por (p,
        tmp,
        p->vars[insn->dest_args[0]].alloc);
  }
}

static void
sse_rule_cmpeqf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmpeqps (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_cmpeqd (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmpeqpd (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}


static void
sse_rule_cmpltf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmpltps (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_cmpltd (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmpltpd (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}


static void
sse_rule_cmplef (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmpleps (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_cmpled (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cmplepd (p,
      p->vars[insn->src_args[1]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}


static void
sse_rule_convfl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmpc;
  int tmp = orc_compiler_get_temp_reg (p);
  
  tmpc = orc_compiler_get_temp_constant (p, 4, 0x80000000);
  orc_sse_emit_movdqa (p, src, tmp);
  orc_sse_emit_cvttps2dq (p, src, dest);
  orc_sse_emit_psrad_imm (p, 31, tmp);
  orc_sse_emit_pcmpeqd (p, dest, tmpc);
  orc_sse_emit_pandn (p, tmpc, tmp);
  orc_sse_emit_paddd (p, tmp, dest);

}

static void
sse_rule_convdl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  int src = p->vars[insn->src_args[0]].alloc;
  int dest = p->vars[insn->dest_args[0]].alloc;
  int tmpc;
  int tmp = orc_compiler_get_temp_reg (p);
  
  tmpc = orc_compiler_get_temp_constant (p, 4, 0x80000000);
  orc_sse_emit_pshufd (p, ORC_SSE_SHUF(3,1,3,1), src, tmp);
  orc_sse_emit_cvttpd2dq (p, src, dest);
  orc_sse_emit_psrad_imm (p, 31, tmp);
  orc_sse_emit_pcmpeqd (p, dest, tmpc);
  orc_sse_emit_pandn (p, tmpc, tmp);
  orc_sse_emit_paddd (p, tmp, dest);
}

static void
sse_rule_convlf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cvtdq2ps (p,
      p->vars[insn->src_args[0]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_convld (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cvtdq2pd (p,
      p->vars[insn->src_args[0]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_convfd (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cvtps2pd (p,
      p->vars[insn->src_args[0]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}

static void
sse_rule_convdf (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  orc_sse_emit_cvtpd2ps (p,
      p->vars[insn->src_args[0]].alloc,
      p->vars[insn->dest_args[0]].alloc);
}
#endif

#define UNARY_SSE41(opcode,insn_name) \
static void \
sse_rule_ ## opcode ## _sse41 (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  orc_sse_emit_ ## insn_name (p, \
      p->vars[insn->src_args[0]].alloc, \
      p->vars[insn->dest_args[0]].alloc); \
}

UNARY_SSE41(convsbw,pmovsxbw);
UNARY_SSE41(convswl,pmovsxwd);
UNARY_SSE41(convslq,pmovsxdq);
UNARY_SSE41(convubw,pmovzxbw);
UNARY_SSE41(convuwl,pmovzxwd);
UNARY_SSE41(convulq,pmovzxdq);


void
orc_compiler_sse_register_rules (OrcTarget *target)
{
  OrcRuleSet *rule_set;

#define REG(x) \
  orc_rule_register (rule_set, #x , sse_rule_ ## x, NULL)

  /* SSE 2 */
#ifndef MMX
  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_SSE_SSE2);
#else
  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_MMX_MMX);
#endif

  orc_rule_register (rule_set, "loadb", sse_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadw", sse_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadl", sse_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadq", sse_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadoffb", sse_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "loadoffw", sse_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "loadoffl", sse_rule_loadoffX, NULL);
  orc_rule_register (rule_set, "loadupdb", sse_rule_loadupdb, NULL);
  orc_rule_register (rule_set, "loadupib", sse_rule_loadupib, NULL);
  orc_rule_register (rule_set, "loadpb", sse_rule_loadpX, (void *)1);
  orc_rule_register (rule_set, "loadpw", sse_rule_loadpX, (void *)2);
  orc_rule_register (rule_set, "loadpl", sse_rule_loadpX, (void *)4);
  orc_rule_register (rule_set, "loadpq", sse_rule_loadpX, (void *)8);
  orc_rule_register (rule_set, "ldresnearl", sse_rule_ldresnearl, NULL);
  orc_rule_register (rule_set, "ldreslinl", sse_rule_ldreslinl, NULL);

  orc_rule_register (rule_set, "storeb", sse_rule_storeX, NULL);
  orc_rule_register (rule_set, "storew", sse_rule_storeX, NULL);
  orc_rule_register (rule_set, "storel", sse_rule_storeX, NULL);
  orc_rule_register (rule_set, "storeq", sse_rule_storeX, NULL);

  REG(addb);
  REG(addssb);
  REG(addusb);
  REG(andb);
  REG(andnb);
  REG(avgub);
  REG(cmpeqb);
  REG(cmpgtsb);
  REG(maxub);
  REG(minub);
  REG(orb);
  REG(subb);
  REG(subssb);
  REG(subusb);
  REG(xorb);

  REG(addw);
  REG(addssw);
  REG(addusw);
  REG(andw);
  REG(andnw);
  REG(avguw);
  REG(cmpeqw);
  REG(cmpgtsw);
  REG(maxsw);
  REG(minsw);
  REG(mullw);
  REG(mulhsw);
  REG(mulhuw);
  REG(orw);
  REG(subw);
  REG(subssw);
  REG(subusw);
  REG(xorw);

  REG(addl);
  REG(andl);
  REG(andnl);
  REG(cmpeql);
  REG(cmpgtsl);
  REG(orl);
  REG(subl);
  REG(xorl);

  REG(andq);
  REG(andnq);
  REG(orq);
  REG(xorq);

  REG(select0ql);
  REG(select1ql);
  REG(select0lw);
  REG(select1lw);
  REG(select0wb);
  REG(select1wb);
  REG(mergebw);
  REG(mergewl);
  REG(mergelq);

  orc_rule_register (rule_set, "copyb", sse_rule_copyx, NULL);
  orc_rule_register (rule_set, "copyw", sse_rule_copyx, NULL);
  orc_rule_register (rule_set, "copyl", sse_rule_copyx, NULL);
  orc_rule_register (rule_set, "copyq", sse_rule_copyx, NULL);

  orc_rule_register (rule_set, "shlw", sse_rule_shift, (void *)0);
  orc_rule_register (rule_set, "shruw", sse_rule_shift, (void *)1);
  orc_rule_register (rule_set, "shrsw", sse_rule_shift, (void *)2);
  orc_rule_register (rule_set, "shll", sse_rule_shift, (void *)3);
  orc_rule_register (rule_set, "shrul", sse_rule_shift, (void *)4);
  orc_rule_register (rule_set, "shrsl", sse_rule_shift, (void *)5);
  orc_rule_register (rule_set, "shlq", sse_rule_shift, (void *)6);
  orc_rule_register (rule_set, "shruq", sse_rule_shift, (void *)7);
  orc_rule_register (rule_set, "shrsq", sse_rule_shrsq, NULL);

  orc_rule_register (rule_set, "convsbw", sse_rule_convsbw, NULL);
  orc_rule_register (rule_set, "convubw", sse_rule_convubw, NULL);
  orc_rule_register (rule_set, "convssswb", sse_rule_convssswb, NULL);
  orc_rule_register (rule_set, "convsuswb", sse_rule_convsuswb, NULL);
  orc_rule_register (rule_set, "convuuswb", sse_rule_convuuswb, NULL);
  orc_rule_register (rule_set, "convwb", sse_rule_convwb, NULL);

  orc_rule_register (rule_set, "convswl", sse_rule_convswl, NULL);
  orc_rule_register (rule_set, "convuwl", sse_rule_convuwl, NULL);
  orc_rule_register (rule_set, "convssslw", sse_rule_convssslw, NULL);

  orc_rule_register (rule_set, "convql", sse_rule_convql, NULL);
  orc_rule_register (rule_set, "convslq", sse_rule_convslq, NULL);
  orc_rule_register (rule_set, "convulq", sse_rule_convulq, NULL);
  /* orc_rule_register (rule_set, "convsssql", sse_rule_convsssql, NULL); */

  orc_rule_register (rule_set, "mulsbw", sse_rule_mulsbw, NULL);
  orc_rule_register (rule_set, "mulubw", sse_rule_mulubw, NULL);
  orc_rule_register (rule_set, "mulswl", sse_rule_mulswl, NULL);
  orc_rule_register (rule_set, "muluwl", sse_rule_muluwl, NULL);

  orc_rule_register (rule_set, "accw", sse_rule_accw, NULL);
  orc_rule_register (rule_set, "accl", sse_rule_accl, NULL);
  orc_rule_register (rule_set, "accsadubl", sse_rule_accsadubl, NULL);

#ifndef MMX
  /* These require the SSE2 flag, although could be used with MMX.
     That flag is not yet handled. */
  orc_rule_register (rule_set, "mululq", sse_rule_mululq, NULL);
  REG(addq);
  REG(subq);

  orc_rule_register (rule_set, "addf", sse_rule_addf, NULL);
  orc_rule_register (rule_set, "subf", sse_rule_subf, NULL);
  orc_rule_register (rule_set, "mulf", sse_rule_mulf, NULL);
  orc_rule_register (rule_set, "divf", sse_rule_divf, NULL);
  orc_rule_register (rule_set, "minf", sse_rule_minf, NULL);
  orc_rule_register (rule_set, "maxf", sse_rule_maxf, NULL);
  orc_rule_register (rule_set, "sqrtf", sse_rule_sqrtf, NULL);
  orc_rule_register (rule_set, "cmpeqf", sse_rule_cmpeqf, NULL);
  orc_rule_register (rule_set, "cmpltf", sse_rule_cmpltf, NULL);
  orc_rule_register (rule_set, "cmplef", sse_rule_cmplef, NULL);
  orc_rule_register (rule_set, "convfl", sse_rule_convfl, NULL);
  orc_rule_register (rule_set, "convlf", sse_rule_convlf, NULL);

  orc_rule_register (rule_set, "addd", sse_rule_addd, NULL);
  orc_rule_register (rule_set, "subd", sse_rule_subd, NULL);
  orc_rule_register (rule_set, "muld", sse_rule_muld, NULL);
  orc_rule_register (rule_set, "divd", sse_rule_divd, NULL);
  orc_rule_register (rule_set, "mind", sse_rule_mind, NULL);
  orc_rule_register (rule_set, "maxd", sse_rule_maxd, NULL);
  orc_rule_register (rule_set, "sqrtd", sse_rule_sqrtd, NULL);
  orc_rule_register (rule_set, "cmpeqd", sse_rule_cmpeqd, NULL);
  orc_rule_register (rule_set, "cmpltd", sse_rule_cmpltd, NULL);
  orc_rule_register (rule_set, "cmpled", sse_rule_cmpled, NULL);
  orc_rule_register (rule_set, "convdl", sse_rule_convdl, NULL);
  orc_rule_register (rule_set, "convld", sse_rule_convld, NULL);

  orc_rule_register (rule_set, "convfd", sse_rule_convfd, NULL);
  orc_rule_register (rule_set, "convdf", sse_rule_convdf, NULL);
#endif

  /* slow rules */
  orc_rule_register (rule_set, "maxuw", sse_rule_maxuw_slow, NULL);
  orc_rule_register (rule_set, "minuw", sse_rule_minuw_slow, NULL);
  orc_rule_register (rule_set, "avgsb", sse_rule_avgsb_slow, NULL);
  orc_rule_register (rule_set, "avgsw", sse_rule_avgsw_slow, NULL);
  orc_rule_register (rule_set, "maxsb", sse_rule_maxsb_slow, NULL);
  orc_rule_register (rule_set, "minsb", sse_rule_minsb_slow, NULL);
  orc_rule_register (rule_set, "maxsl", sse_rule_maxsl_slow, NULL);
  orc_rule_register (rule_set, "minsl", sse_rule_minsl_slow, NULL);
  orc_rule_register (rule_set, "maxul", sse_rule_maxul_slow, NULL);
  orc_rule_register (rule_set, "minul", sse_rule_minul_slow, NULL);
  orc_rule_register (rule_set, "convlw", sse_rule_convlw, NULL);
  orc_rule_register (rule_set, "signw", sse_rule_signw_slow, NULL);
  orc_rule_register (rule_set, "absb", sse_rule_absb_slow, NULL);
  orc_rule_register (rule_set, "absw", sse_rule_absw_slow, NULL);
  orc_rule_register (rule_set, "absl", sse_rule_absl_slow, NULL);
  orc_rule_register (rule_set, "swapw", sse_rule_swapw, NULL);
  orc_rule_register (rule_set, "swapl", sse_rule_swapl, NULL);
  orc_rule_register (rule_set, "swapwl", sse_rule_swapwl, NULL);
  orc_rule_register (rule_set, "swapq", sse_rule_swapq, NULL);
  orc_rule_register (rule_set, "swaplq", sse_rule_swaplq, NULL);
  orc_rule_register (rule_set, "splitql", sse_rule_splitql, NULL);
  orc_rule_register (rule_set, "splitlw", sse_rule_splitlw, NULL);
  orc_rule_register (rule_set, "splitwb", sse_rule_splitwb, NULL);
  orc_rule_register (rule_set, "avgsl", sse_rule_avgsl, NULL);
  orc_rule_register (rule_set, "avgul", sse_rule_avgul, NULL);
  orc_rule_register (rule_set, "shlb", sse_rule_shlb, NULL);
  orc_rule_register (rule_set, "shrsb", sse_rule_shrsb, NULL);
  orc_rule_register (rule_set, "shrub", sse_rule_shrub, NULL);
  orc_rule_register (rule_set, "mulll", sse_rule_mulll_slow, NULL);
#ifndef MMX
  orc_rule_register (rule_set, "mulhsl", sse_rule_mulhsl_slow, NULL);
  orc_rule_register (rule_set, "mulhul", sse_rule_mulhul, NULL);
  orc_rule_register (rule_set, "mulslq", sse_rule_mulslq_slow, NULL);
#endif
  orc_rule_register (rule_set, "mullb", sse_rule_mullb, NULL);
  orc_rule_register (rule_set, "mulhsb", sse_rule_mulhsb, NULL);
  orc_rule_register (rule_set, "mulhub", sse_rule_mulhub, NULL);
  orc_rule_register (rule_set, "addssl", sse_rule_addssl_slow, NULL);
  orc_rule_register (rule_set, "subssl", sse_rule_subssl_slow, NULL);
  orc_rule_register (rule_set, "addusl", sse_rule_addusl_slow, NULL);
  orc_rule_register (rule_set, "subusl", sse_rule_subusl_slow, NULL);
  orc_rule_register (rule_set, "convhwb", sse_rule_convhwb, NULL);
  orc_rule_register (rule_set, "convhlw", sse_rule_convhlw, NULL);
  orc_rule_register (rule_set, "splatw3q", sse_rule_splatw3q, NULL);
  orc_rule_register (rule_set, "splatbw", sse_rule_splatbw, NULL);
  orc_rule_register (rule_set, "splatbl", sse_rule_splatbl, NULL);
  orc_rule_register (rule_set, "div255w", sse_rule_div255w, NULL);
  orc_rule_register (rule_set, "divluw", sse_rule_divluw, NULL);

  /* SSE 3 -- no rules */

  /* SSSE 3 */
  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_SSE_SSSE3);

#ifndef MMX
  orc_rule_register (rule_set, "signb", sse_rule_signX_ssse3, (void *)0);
  orc_rule_register (rule_set, "signw", sse_rule_signX_ssse3, (void *)1);
  orc_rule_register (rule_set, "signl", sse_rule_signX_ssse3, (void *)2);
#endif
  REG(absb);
  REG(absw);
  REG(absl);
#ifndef MMX
  orc_rule_register (rule_set, "swapw", sse_rule_swapw_ssse3, NULL);
  orc_rule_register (rule_set, "swapl", sse_rule_swapl_ssse3, NULL);
  orc_rule_register (rule_set, "swapwl", sse_rule_swapwl_ssse3, NULL);
  orc_rule_register (rule_set, "swapq", sse_rule_swapq_ssse3, NULL);
  orc_rule_register (rule_set, "select0lw", sse_rule_select0lw_ssse3, NULL);
  orc_rule_register (rule_set, "select1lw", sse_rule_select1lw_ssse3, NULL);
  orc_rule_register (rule_set, "select0wb", sse_rule_select0wb_ssse3, NULL);
  orc_rule_register (rule_set, "select1wb", sse_rule_select1wb_ssse3, NULL);
#endif

  /* SSE 4.1 */
  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_SSE_SSE4_1);

  REG(maxsb);
  REG(minsb);
  REG(maxuw);
  REG(minuw);
  REG(maxsl);
  REG(maxul);
  REG(minsl);
  REG(minul);
  REG(mulll);
  orc_rule_register (rule_set, "convsbw", sse_rule_convsbw_sse41, NULL);
  orc_rule_register (rule_set, "convswl", sse_rule_convswl_sse41, NULL);
  orc_rule_register (rule_set, "convslq", sse_rule_convslq_sse41, NULL);
  orc_rule_register (rule_set, "convubw", sse_rule_convubw_sse41, NULL);
  orc_rule_register (rule_set, "convuwl", sse_rule_convuwl_sse41, NULL);
  orc_rule_register (rule_set, "convulq", sse_rule_convulq_sse41, NULL);
  orc_rule_register (rule_set, "convsuslw", sse_rule_convsuslw, NULL);
  orc_rule_register (rule_set, "mulslq", sse_rule_mulslq, NULL);
#ifndef MMX
  orc_rule_register (rule_set, "mulhsl", sse_rule_mulhsl, NULL);
#endif
  REG(cmpeqq);

  /* SSE 4.2 -- no rules */
  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), target,
      ORC_TARGET_SSE_SSE4_2);

  REG(cmpgtsq);

  /* SSE 4a -- no rules */
}

