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
#include <string.h>
#include "config.h"

unsigned int orc_compiler_orc_mips_get_default_flags (void);

void orc_compiler_orc_mips_init (OrcCompiler *compiler);

void orc_compiler_orc_mips_assemble (OrcCompiler *compiler);

const char * orc_compiler_orc_mips_get_asm_preamble (void);

void orc_mips_flush_cache (OrcCode *code);

/* in orcrules-mips.c */
void orc_compiler_orc_mips_register_rules (OrcTarget *target);

static OrcTarget orc_mips_target = {
  "mips",
#ifdef HAVE_MIPSEL
  TRUE,
#else
  FALSE,
#endif
  ORC_GP_REG_BASE,
  orc_compiler_orc_mips_get_default_flags,
  orc_compiler_orc_mips_init,
  orc_compiler_orc_mips_assemble,
  { { 0 } },
  0,
  orc_compiler_orc_mips_get_asm_preamble,
  NULL,
  NULL,
  orc_mips_flush_cache,
};

enum {
  LABEL_REGION0_LOOP = 1,
  LABEL_REGION1,
  LABEL_REGION1_LOOP,
  LABEL_REGION2,
  LABEL_REGION2_LOOP, /* 5 */
  LABEL_REGION2_LOOP_END,
  LABEL_OUTER_LOOP,
  LABEL_END
};
#define LAST_LABEL LABEL_END

void
orc_mips_init (void)
{
  orc_target_register (&orc_mips_target);

  orc_compiler_orc_mips_register_rules (&orc_mips_target);
}

unsigned int
orc_compiler_orc_mips_get_default_flags (void)
{
  unsigned int flags = 0;

  if (_orc_compiler_flag_debug) {
    flags |= ORC_TARGET_MIPS_FRAME_POINTER;
  }
  return flags;
}

void
orc_compiler_orc_mips_init (OrcCompiler *compiler)
{
  int i;

  if (compiler->target_flags & ORC_TARGET_MIPS_FRAME_POINTER)
    compiler->use_frame_pointer = TRUE;

  for (i=ORC_GP_REG_BASE; i<ORC_GP_REG_BASE+32; i++)
    compiler->valid_regs[i] = 1;

  compiler->valid_regs[ORC_MIPS_ZERO] = 0; /* always 0 */
  compiler->valid_regs[ORC_MIPS_AT] = 0; /* we shouldn't touch that (assembler
                                            temporary) */
  compiler->exec_reg = ORC_MIPS_A0;
  compiler->valid_regs[ORC_MIPS_A0] = 0; /* first (and in our case only)
                                            function argument */
  compiler->valid_regs[ORC_MIPS_T0] = 0; /* $t0, $t1 and $t2 are used as loop */
  compiler->valid_regs[ORC_MIPS_T1] = 0; /* counters */
  compiler->valid_regs[ORC_MIPS_T2] = 0;
  compiler->valid_regs[ORC_MIPS_T3] = 0;
  compiler->valid_regs[ORC_MIPS_T4] = 0;
  compiler->valid_regs[ORC_MIPS_T5] = 0;
  compiler->valid_regs[ORC_MIPS_K0] = 0; /* for kernel/interupts */
  compiler->valid_regs[ORC_MIPS_K1] = 0; /* for kernel/interupts */
  compiler->valid_regs[ORC_MIPS_GP] = 0; /* global pointer */
  compiler->valid_regs[ORC_MIPS_SP] = 0; /* stack pointer */
  compiler->valid_regs[ORC_MIPS_FP] = 0; /* frame pointer */
  compiler->valid_regs[ORC_MIPS_RA] = 0; /* return address */

  for (i=0;i<ORC_N_REGS;i++){
    compiler->alloc_regs[i] = 0;
    compiler->used_regs[i] = 0;
    compiler->save_regs[i] = 0;
  }

  compiler->save_regs[ORC_MIPS_V0] = 1;
  compiler->save_regs[ORC_MIPS_V1] = 1;
  for (i=ORC_MIPS_S0; i<= ORC_MIPS_S7; i++)
    compiler->save_regs[i] = 1;

  switch (compiler->max_var_size) {
  case 1:
    compiler->loop_shift = 2;
    break;
  case 2:
    compiler->loop_shift = 1;
    break;
  case 4:
    compiler->loop_shift = 0;
    break;
  default:
    ORC_ERROR("unhandled variable size %d", compiler->max_var_size);
  }

  /* Empirical evidence in a colorspace conversion benchmark shows that 3 is
   * the best unroll shift. */
  compiler->unroll_shift = 3;
  compiler->unroll_index = 0;

  for(i=0;i<compiler->n_insns;i++){
    OrcInstruction *insn = compiler->insns + i;
    OrcStaticOpcode *opcode = insn->opcode;

    if ((strcmp (opcode->name, "loadupib") == 0)
        || (strcmp (opcode->name, "loadupdb") == 0)) {
      compiler->vars[insn->src_args[0]].need_offset_reg = TRUE;
    }
  }
}

const char *
orc_compiler_orc_mips_get_asm_preamble (void)
{
  return "\n"
      "/* begin Orc MIPS target preamble */\n"
      ".abicalls\n" /* not exactly sure what this is, but linker complains
                       without it  */
      ".set noreorder\n"
      "/* end Orc MIPS target preamble */\n\n";
}

int
orc_mips_emit_prologue (OrcCompiler *compiler)
{
  int i, stack_size;
  unsigned int stack_increment;

  if (compiler->use_frame_pointer) {
    stack_size = 12; /* we stack at least fp and a0 and start at stack_increment 4 */
    stack_increment = 4;
  } else {
    stack_size = 0;
    stack_increment = 0;
  }

  orc_compiler_append_code(compiler,".globl %s\n", compiler->program->name);
  orc_compiler_append_code(compiler,"%s:\n", compiler->program->name);

  /* push registers we need to save */
  for(i=0; i<32; i++)
    if (compiler->used_regs[ORC_GP_REG_BASE + i] &&
        compiler->save_regs[ORC_GP_REG_BASE + i])
      stack_size += 4;

  if (stack_size) {
    orc_mips_emit_addiu (compiler, ORC_MIPS_SP, ORC_MIPS_SP, -stack_size);

    if (compiler->use_frame_pointer) {
      orc_mips_emit_sw (compiler, ORC_MIPS_FP, ORC_MIPS_SP, stack_increment);
      stack_increment += 4;
      orc_mips_emit_move (compiler, ORC_MIPS_FP, ORC_MIPS_SP);
      orc_mips_emit_sw (compiler, ORC_MIPS_A0, ORC_MIPS_SP, stack_increment);
      stack_increment += 4;
    }


    for(i=0; i<32; i++){
      if (compiler->used_regs[ORC_GP_REG_BASE + i] &&
          compiler->save_regs[ORC_GP_REG_BASE + i]) {
        orc_mips_emit_sw (compiler, ORC_GP_REG_BASE+i,
                          ORC_MIPS_SP, stack_increment);
            stack_increment +=4;
      }
    }
  }

  return stack_size;
}

void orc_mips_emit_epilogue (OrcCompiler *compiler, int stack_size)
{
  int i;

  /* pop saved registers */
  if (stack_size) {
    unsigned int stack_increment = 0;
    if (compiler->use_frame_pointer)
      stack_increment = 8;

    for(i=0; i<32; i++){
      if (compiler->used_regs[ORC_GP_REG_BASE + i] &&
          compiler->save_regs[ORC_GP_REG_BASE + i]) {
        orc_mips_emit_lw (compiler, ORC_GP_REG_BASE+i,
                          ORC_MIPS_SP, stack_increment);
            stack_increment +=4;
      }
    }
    if (compiler->use_frame_pointer)
      orc_mips_emit_lw (compiler, ORC_MIPS_FP, ORC_MIPS_SP, 4);
    orc_mips_emit_addiu (compiler, ORC_MIPS_SP, ORC_MIPS_SP, stack_size);
  }

  orc_mips_emit_jr (compiler, ORC_MIPS_RA);
  orc_mips_emit_nop (compiler);
  if (compiler->target_flags & ORC_TARGET_CLEAN_COMPILE) {
    /* we emit some padding nops at the end to align to 16 bytes because that's
     * what gnu as does (not sure why) and we want to generate the same code
     * for testing purposes */
    orc_mips_emit_align (compiler, 4);
  }
}

void
orc_mips_load_constants_inner (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcVariable *var = compiler->vars + i;
    if (var->name == NULL) continue;
    switch (var->vartype) {
      case ORC_VAR_TYPE_CONST:
      case ORC_VAR_TYPE_PARAM:
        break;
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        orc_mips_emit_lw (compiler,
            var->ptr_register,
            compiler->exec_reg, ORC_MIPS_EXECUTOR_OFFSET_ARRAYS(i));
        break;
      default:
        break;
    }

    if (var->ptr_offset)
      orc_mips_emit_move (compiler, var->ptr_offset, ORC_MIPS_ZERO);
  }


  for(i=0;i<compiler->n_insns;i++){
    OrcInstruction *insn = compiler->insns + i;
    OrcStaticOpcode *opcode = insn->opcode;
    OrcRule *rule;

    if (!(insn->flags & ORC_INSN_FLAG_INVARIANT)) continue;

    ORC_ASM_CODE(compiler,"# %d: %s\n", i, insn->opcode->name);

    compiler->insn_shift = compiler->loop_shift;
    if (insn->flags & ORC_INSTRUCTION_FLAG_X2) {
      compiler->insn_shift += 1;
    }
    if (insn->flags & ORC_INSTRUCTION_FLAG_X4) {
      compiler->insn_shift += 2;
    }

    rule = insn->rule;
    if (rule && rule->emit) {
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      ORC_COMPILER_ERROR(compiler,"No rule for: %s", opcode->name);
    }
  }
}

#define CACHE_LINE_SIZE 32

void
orc_mips_emit_var_pref (OrcCompiler *compiler, int iter_offset, int total_shift)
{
  int i, j;
  int offset = 0;
  /* prefetch stuff into cache */
  for (i=0; i<ORC_N_COMPILER_VARIABLES; i++) {
    OrcVariable *var = compiler->vars + i;

    if (var->name == NULL) continue;
    if (var->update_type == 0) {
      offset = 0;
    } else if (var->update_type == 1) {
      offset = (var->size << total_shift) >> 1;
    } else {
      offset = var->size << total_shift;
    }
    if (var->vartype == ORC_VAR_TYPE_SRC) {
      for (j = iter_offset*offset; j < (iter_offset+1)*offset; j+=CACHE_LINE_SIZE)
        orc_mips_emit_pref (compiler, 4 /* load-streamed */,
                            var->ptr_register, j);
    } else if (var->vartype == ORC_VAR_TYPE_DEST) {
      for (j = iter_offset*offset; j < (iter_offset+1)*offset; j+=CACHE_LINE_SIZE)
      orc_mips_emit_pref (compiler, 5 /* store-streamed */,
                          var->ptr_register, j);
    }
  }
}

static int
uses_register (OrcCompiler *compiler,
               OrcInstruction *insn,
               OrcMipsRegister reg)
{
  int i;
  for (i=0; i<ORC_STATIC_OPCODE_N_DEST; i++) {
    OrcVariable *var = compiler->vars + insn->dest_args[i];
    if (var->alloc == reg || var->ptr_register == reg)
      return TRUE;
  }

  for (i=0; i<ORC_STATIC_OPCODE_N_SRC; i++) {
    OrcVariable *var = compiler->vars + insn->src_args[i];
    if (var->alloc == reg || var->ptr_register == reg)
      return TRUE;
  }

  return FALSE;
}

static void
do_swap (int *tab, int i, int j)
{
  int tmp = tab[i];
  tab[i] = tab[j];
  tab[j] = tmp;
}

/* Assumes that the instruction at indexes[i] is a load instruction */
static int
can_raise (OrcCompiler *compiler, int *indexes, int i)
{
  OrcMipsRegister reg;
  OrcInstruction *insn, *previous_insn;

  if (i==0)
    return FALSE;

  insn = compiler->insns + indexes[i];
  previous_insn = compiler->insns + indexes[i-1];

  /* Register where the load operation will put the data */
  reg = compiler->vars[insn->dest_args[0]].alloc;
  return ! uses_register (compiler, previous_insn, reg);
}

/* Recursive. */
static void
try_raise (OrcCompiler *compiler, int *indexes, int i)
{
  if (can_raise (compiler, indexes, i)) {
    do_swap (indexes, i-1, i);
    try_raise (compiler, indexes, i-1);
  }
}

/*
   Do a kind of bubble sort, though it might not exactly be a sort. It only
   moves load instructions up until they reach an operation above which they
   cannot go.

   FIXME: also push store instructions down.
 */
static void
optimise_order (OrcCompiler *compiler, int *indexes)
{
  int i;
  for (i=0; i<compiler->n_insns; i++) {
    OrcInstruction *insn = compiler->insns + indexes[i];
    if (insn->opcode->flags & ORC_STATIC_OPCODE_LOAD)
      try_raise (compiler, indexes, i);
  }
}

static int *
get_optimised_instruction_order (OrcCompiler *compiler)
{
  int *instruction_idx = NULL;
  int i;
  if (compiler->n_insns == 0)
    return NULL;

  instruction_idx = malloc (compiler->n_insns * sizeof(int));
  for (i=0; i<compiler->n_insns; i++)
    instruction_idx[i] = i;

  optimise_order (compiler, instruction_idx);

  return instruction_idx;
}

void
orc_mips_emit_loop (OrcCompiler *compiler, int unroll)
{
  int i, j;
  int iteration_per_loop = 1;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  OrcRule *rule;
  int total_shift = compiler->loop_shift;
  int *insn_idx;
  ORC_DEBUG ("loop_shift=%d", compiler->loop_shift);

  if (unroll)
    total_shift += compiler->unroll_shift;


  if (unroll)
    iteration_per_loop = 1 << compiler->unroll_shift;

  insn_idx = get_optimised_instruction_order (compiler);
  if (insn_idx == NULL) {
    ORC_ERROR ("Could not get optimised instruction order, not emitting loop");
    return;
  }

  for (j=0; j<iteration_per_loop; j++) {
    compiler->unroll_index = j;
    for (i=0; i<compiler->n_insns; i++) {
      insn = compiler->insns + insn_idx[i];
      opcode = insn->opcode;
      if (insn->flags & ORC_INSN_FLAG_INVARIANT) continue;

      orc_compiler_append_code(compiler,"/* %d: %s */\n", i, insn->opcode->name);

      compiler->min_temp_reg = ORC_MIPS_T3;

      rule = insn->rule;
      if (rule && rule->emit) {
        compiler->insn_shift = compiler->loop_shift;
        if (insn->flags & ORC_INSTRUCTION_FLAG_X2) {
          compiler->insn_shift += 1;
        }
        if (insn->flags & ORC_INSTRUCTION_FLAG_X4) {
          compiler->insn_shift += 2;
        }
        rule->emit (compiler, rule->emit_user, insn);
      } else {
        orc_compiler_append_code (compiler, "No rule for %s\n", opcode->name);
      }
    }
  }

  compiler->unroll_index = 0;

  for (j=0; j<ORC_N_COMPILER_VARIABLES; j++) {
    OrcVariable *var = compiler->vars + j;

    if (var->name == NULL) continue;
    if (var->vartype == ORC_VAR_TYPE_SRC ||
        var->vartype == ORC_VAR_TYPE_DEST) {
      int offset;
      if (var->update_type == 0) {
        offset = 0;
      } else if (var->update_type == 1) {
        offset = (var->size << total_shift) >> 1;
      } else {
        offset = var->size << total_shift;
      }
      if (offset !=0 && var->ptr_register) {
        orc_mips_emit_addiu (compiler,
                             var->ptr_register,
                             var->ptr_register,
                             offset);
      }
    }
  }
}

static int
get_align_var (OrcCompiler *compiler)
{
  if (compiler->vars[ORC_VAR_D1].size) return ORC_VAR_D1;
  if (compiler->vars[ORC_VAR_S1].size) return ORC_VAR_S1;

  ORC_PROGRAM_ERROR(compiler, "could not find alignment variable");

  return -1;
}

static int
get_shift (int size)
{
  switch (size) {
    case 1:
      return 0;
    case 2:
      return 1;
    case 4:
      return 2;
    default:
      ORC_ERROR("bad size %d", size);
  }
  return -1;
}

/* alignment is a bit field. Each bit (from least significant) corresponds to a
 * dest or source variable in the order
 * ORC_VAR_D1-ORC_VAR_D4,ORC_VAR_S1-ORC_VAR_S8
 */
void
orc_mips_set_alignment (OrcCompiler *compiler, orc_uint16 alignment)
{
  int i;
  for (i=ORC_VAR_D1; i<=ORC_VAR_S8; i++) {
    compiler->vars[i].is_aligned = !!(alignment & (1<<i));
  }
}

orc_uint16
orc_mips_get_alignment (OrcCompiler *compiler)
{
  int i;
  orc_uint16 alignment=0;
  for (i=ORC_VAR_D1; i<=ORC_VAR_S8; i++) {
    if (compiler->vars[i].is_aligned)
      alignment |= 1<<i;
  }
  return alignment;
}

void
orc_mips_emit_full_loop (OrcCompiler *compiler, OrcMipsRegister counter,
                         int loop_shift, int loop_label, int alignment, int unroll)
{
  int saved_loop_shift;
  int saved_alignment;
  orc_mips_emit_label (compiler, loop_label);
  saved_loop_shift = compiler->loop_shift;
  compiler->loop_shift = loop_shift;
  saved_alignment = orc_mips_get_alignment (compiler);
  orc_mips_set_alignment (compiler, alignment);
  orc_mips_emit_loop (compiler, unroll);
  orc_mips_set_alignment (compiler, saved_alignment);
  compiler->loop_shift = saved_loop_shift;
  orc_mips_emit_addi (compiler, counter, counter, -1);
  orc_mips_emit_bnez (compiler, counter, loop_label);
  orc_mips_emit_nop (compiler);
}

/* FIXME: this stuff should be cached */
int
orc_mips_get_loop_label (OrcCompiler *compiler, int alignments)
{
  int i,
      j=0,
      bitfield=0;
  for (i=ORC_VAR_D1; i<=ORC_VAR_S8; i++) {
    OrcVariable *var = &(compiler->vars[i]);
    if (var->name == NULL || var->ptr_register == 0 || var->is_aligned) {
      if (alignments & (1 << i))
        return -1;
      else
        continue;
    }

    if (alignments & (1 << i)) {
      bitfield |= 1 << j;
    }
    j++;
  }
  if (bitfield)
    return LAST_LABEL + bitfield;

  return -1;
}

/* overwrites $t0 and $t1 */
void
orc_mips_add_strides (OrcCompiler *compiler, int var_size_shift)
{
  int i;
  orc_mips_emit_lw (compiler, ORC_MIPS_T1, compiler->exec_reg,
                    ORC_MIPS_EXECUTOR_OFFSET_N);
  orc_mips_emit_sll (compiler, ORC_MIPS_T1, ORC_MIPS_T1, var_size_shift);
  /* $t1 now contains the number of bytes that we treated (and that the var
   * pointer registers advanced) */
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_CONST:
        break;
      case ORC_VAR_TYPE_PARAM:
        break;
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        /* get the stride (it's in bytes) */
        orc_mips_emit_lw (compiler, ORC_MIPS_T0, compiler->exec_reg,
                          ORC_MIPS_EXECUTOR_OFFSET_PARAMS(i));
        /* $t0 = stride - bytes advanced
           we add that to the pointer so that it points to the beginning of the
           next stride */
        orc_mips_emit_sub (compiler, ORC_MIPS_T0, ORC_MIPS_T0, ORC_MIPS_T1);
        orc_mips_emit_addu (compiler, compiler->vars[i].ptr_register,
                            compiler->vars[i].ptr_register, ORC_MIPS_T0);
        break;
      case ORC_VAR_TYPE_ACCUMULATOR:
        break;
      case ORC_VAR_TYPE_TEMP:
        break;
      default:
        ORC_COMPILER_ERROR(compiler,"bad vartype");
        break;
    }
  }
}

void
orc_compiler_orc_mips_assemble (OrcCompiler *compiler)
{
  int stack_size;
  int align_shift = 2; /* this wouldn't work on mips64 */
  int align_var = get_align_var (compiler);
  int var_size_shift;
  int i;

  if (align_var < 0)
    return;

  var_size_shift = get_shift (compiler->vars[align_var].size);

  stack_size = orc_mips_emit_prologue (compiler);

  /* FIXME: load constants and params */
#if 0
  for (i=0; i<ORC_N_COMPILER_VARIABLES; i++) {
    if (compiler->vars[i].name == NULL)
      ORC_PROGRAM_ERROR (compiler, "unimplemented");
  }
#endif

  orc_mips_load_constants_inner (compiler);

  if (compiler->program->is_2d) {
    /* ex->params[ORC_VAR_A1] contains "m", the number of lines we want to treat */
    orc_mips_emit_lw (compiler, ORC_MIPS_T0, compiler->exec_reg,
                      ORC_MIPS_EXECUTOR_OFFSET_PARAMS(ORC_VAR_A1));
    orc_mips_emit_beqz (compiler, ORC_MIPS_T0, LABEL_END);
    orc_mips_emit_label (compiler, LABEL_OUTER_LOOP);
  }

  orc_mips_emit_lw (compiler, ORC_MIPS_T2, compiler->exec_reg,
                    ORC_MIPS_EXECUTOR_OFFSET_N);
  orc_mips_emit_blez (compiler, ORC_MIPS_T2, LABEL_END);


  /* Note: in all these counter calculations ($t0, $t1 and $t2), we assume that
   * variables of k bytes are k-bytes aligned. */

  /* $t0 = number of iterations in region0 (before alignment) */
  /* = number of bytes to get to alignment / var_size
     = ((alignment - data_address) % alignment) / var_size
     = (((1 << align_shift) - data_address) % (1 << align_shift)) / var_size
     = (((1 << align_shift) - data_address) & ((1 << align_shfit) - 1)) >> var_size_shift
   */
  orc_mips_emit_addiu (compiler, ORC_MIPS_T0, ORC_MIPS_ZERO, 1 << align_shift);
  orc_mips_emit_sub (compiler, ORC_MIPS_T0, ORC_MIPS_T0,
                     compiler->vars[align_var].ptr_register);
  orc_mips_emit_andi (compiler, ORC_MIPS_T0, ORC_MIPS_T0,
                      (1 << align_shift) - 1);
  if (var_size_shift > 0)
    orc_mips_emit_srl (compiler, ORC_MIPS_T0, ORC_MIPS_T0, var_size_shift);

  /* $t1 = number of iterations in region1 (aligned)
         = (n - $t0) / (loop_size * unroll)
         = (n - $t0) >> (loop_shift + unroll_shift)
   */
  orc_mips_emit_sub (compiler, ORC_MIPS_T2, ORC_MIPS_T2, ORC_MIPS_T0);

  /*
     handle the case where n < $t0. In that case, we want to handle n elements
     in region0, and no element in the two other regions.

     bgez $t2, usual_case
     move $t1, $0
     move $t2, $0
     lw   $t0, OFFSET_N($a0)
     beqz $0, LABEL_REGION0_LOOP
usual_case:
   */
  orc_mips_emit_conditional_branch_with_offset (compiler, ORC_MIPS_BGEZ,
                                                ORC_MIPS_T2, ORC_MIPS_ZERO,
                                                24);
  orc_mips_emit_nop (compiler);
  orc_mips_emit_move (compiler, ORC_MIPS_T1, ORC_MIPS_ZERO);
  orc_mips_emit_move (compiler, ORC_MIPS_T2, ORC_MIPS_ZERO);
  orc_mips_emit_lw (compiler, ORC_MIPS_T0, compiler->exec_reg,
                    ORC_MIPS_EXECUTOR_OFFSET_N);
  orc_mips_emit_beqz (compiler, ORC_MIPS_ZERO, LABEL_REGION0_LOOP);
  orc_mips_emit_nop (compiler);


  if (compiler->loop_shift + compiler->unroll_shift > 0)
    orc_mips_emit_srl (compiler, ORC_MIPS_T1, ORC_MIPS_T2,
                       compiler->loop_shift + compiler->unroll_shift);
  else
    orc_mips_emit_move (compiler, ORC_MIPS_T1, ORC_MIPS_T2);


  /* if ($t0 == 0) goto REGION1 */
  orc_mips_emit_beqz (compiler, ORC_MIPS_T0, LABEL_REGION1);

  /* $t2 = number of iterations in region2 (after aligned region)
         = (n - $t0) % loop_size
         = (previous $t2) % loop_size
         = $t2 & ((1 << loop_shift + unroll_shift) - 1)
   */
     /* note that this instruction is in the branch delay slot */
  if (compiler->loop_shift + compiler->unroll_shift > 0)
    orc_mips_emit_andi (compiler, ORC_MIPS_T2, ORC_MIPS_T2,
                        (1 << (compiler->loop_shift + compiler->unroll_shift)) - 1);
  else
    /* loop_shift==0: $t2 should be 0 because we can handle all our data in region 1*/
    orc_mips_emit_move (compiler, ORC_MIPS_T2, ORC_MIPS_ZERO);

  /* FIXME: when loop_shift == 0, we only need to emit region1 */

  orc_mips_emit_full_loop (compiler, ORC_MIPS_T0, 0, LABEL_REGION0_LOOP, 0, FALSE);

  orc_mips_emit_label (compiler, LABEL_REGION1);
  orc_mips_emit_beqz (compiler, ORC_MIPS_T1, LABEL_REGION2);
  /* branch delay slot is occupied either by the next andi in the loop below or
   * by the nop after that loop */

  /* from here on until LABEL_REGION2, align_var is known to be aligned (that's
   * the reason why we went through region 0) */
  compiler->vars[align_var].is_aligned = TRUE;


  /* We need a register that contains 1 so that we easily get 2^i */
  orc_mips_emit_ori (compiler, ORC_MIPS_T3, ORC_MIPS_ZERO, 1);
  /* That's where we will store the bitfield of aligned vars (apart from
   * align_var) */
  orc_mips_emit_ori (compiler, ORC_MIPS_T5, ORC_MIPS_ZERO, 0);

  for (i=ORC_VAR_D1; i<=ORC_VAR_S8; i++) {
    OrcVariable *var = &(compiler->vars[i]);
    if (var->name == NULL || var->ptr_register == 0 || var->is_aligned) continue;
    orc_mips_emit_andi (compiler, ORC_MIPS_T0, var->ptr_register, (1 << align_shift) - 1);
    orc_mips_emit_conditional_branch_with_offset (compiler, ORC_MIPS_BNE,
                                                  ORC_MIPS_T0, ORC_MIPS_ZERO,
                                                  8 /* skipping the next two instructions */);
    orc_mips_emit_sll (compiler, ORC_MIPS_T4, ORC_MIPS_T3, i);
    orc_mips_emit_or (compiler, ORC_MIPS_T5, ORC_MIPS_T5, ORC_MIPS_T4);
  }

  orc_mips_emit_beqz (compiler, ORC_MIPS_T5, LABEL_REGION1_LOOP);

  /* Loop on all the alignment combinations we can handle and compare them to
   * the actual alignment we have, then branch to the best loop for it*/
  /* Note: this assumes that ORC_VAR_D1 == 0 */
  for (i=1; i < (1 << (ORC_VAR_S8 +1)); i++) {
    int label = orc_mips_get_loop_label (compiler, i);
    if (label == -1) continue;
    if (label >= ORC_N_LABELS) { /* this check works because _get_loop_label() */
       break;                    /* is strictly monotonic and increasing */
    }

    /* This next line works to load i because ORC_VAR_S8 < 16 */
    orc_mips_emit_ori (compiler, ORC_MIPS_T0, ORC_MIPS_ZERO, i);
    orc_mips_emit_beq (compiler, ORC_MIPS_T5, ORC_MIPS_T0, label);
  }

  orc_mips_emit_nop (compiler);
  /* If we reach here, it means we haven't branched to any specific loop, so we
   * branch to the fallback one */
  orc_mips_emit_beqz (compiler, ORC_MIPS_ZERO, LABEL_REGION1_LOOP);
  orc_mips_emit_nop (compiler);

  /* Loop on all alignment combinations we can handle (limited by number of
   * labels available) and emit the loop for it */
  for (i=0; i < (1 << (ORC_VAR_S8 +1)); i++) {
    int label = orc_mips_get_loop_label (compiler, i);
    if (label == -1) continue;
    if (label >= ORC_N_LABELS) /* this check works because _get_loop_label() */
       break;                  /* is strictly monotonic and increasing */

    orc_mips_emit_full_loop (compiler, ORC_MIPS_T1, compiler->loop_shift,
                             label, i | (1 << align_var), TRUE);

    /* Jump the other loop versions and go to REGION2 */
    orc_mips_emit_beqz (compiler, ORC_MIPS_ZERO, LABEL_REGION2);
    orc_mips_emit_nop (compiler);
  }


  /* Fallback loop that works for any alignment combination */
  orc_mips_emit_full_loop (compiler, ORC_MIPS_T1, compiler->loop_shift,
                           LABEL_REGION1_LOOP, 1 << align_var, TRUE);


  compiler->vars[align_var].is_aligned = FALSE;

  orc_mips_emit_label (compiler, LABEL_REGION2);
  orc_mips_emit_beqz (compiler, ORC_MIPS_T2, LABEL_REGION2_LOOP_END);
  orc_mips_emit_nop (compiler);

  orc_mips_emit_full_loop (compiler, ORC_MIPS_T2, 0, LABEL_REGION2_LOOP, 0, FALSE);
  orc_mips_emit_label (compiler, LABEL_REGION2_LOOP_END);

  if (compiler->program->is_2d) {

    /* ex->params[ORC_VAR_A1] contains "m", the number of lines we want to treat */
    orc_mips_emit_lw (compiler, ORC_MIPS_T2, compiler->exec_reg,
                      ORC_MIPS_EXECUTOR_OFFSET_PARAMS(ORC_VAR_A1));
    orc_mips_add_strides (compiler, var_size_shift);
    orc_mips_emit_addi (compiler, ORC_MIPS_T2, ORC_MIPS_T2, -1);
    orc_mips_emit_sw (compiler, ORC_MIPS_T2, compiler->exec_reg,
                      ORC_MIPS_EXECUTOR_OFFSET_PARAMS(ORC_VAR_A1));
    orc_mips_emit_bnez (compiler, ORC_MIPS_T2, LABEL_OUTER_LOOP);
    orc_mips_emit_nop (compiler);
  }

  orc_mips_emit_label (compiler, LABEL_END);

  orc_mips_do_fixups (compiler);

  orc_mips_emit_epilogue (compiler, stack_size);
}

void
orc_mips_flush_cache  (OrcCode *code)
{
#ifdef HAVE_MIPSEL
  __clear_cache (code->code, code->code + code->code_size);
#endif
}
