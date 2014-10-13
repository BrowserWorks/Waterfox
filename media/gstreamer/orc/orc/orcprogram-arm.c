
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcarm.h>
#include <orc/orcutils.h>
#include <orc/orcdebug.h>

#define SIZE 65536

void orc_arm_emit_loop (OrcCompiler *compiler);

void orc_compiler_orc_arm_register_rules (OrcTarget *target);

void orc_compiler_orc_arm_init (OrcCompiler *compiler);
unsigned int orc_compiler_orc_arm_get_default_flags (void);
void orc_compiler_orc_arm_assemble (OrcCompiler *compiler);

void orc_compiler_rewrite_vars (OrcCompiler *compiler);
void orc_compiler_dump (OrcCompiler *compiler);
void arm_add_strides (OrcCompiler *compiler);

void
orc_arm_emit_prologue (OrcCompiler *compiler)
{
  unsigned int regs = 0;
  int i;

  orc_compiler_append_code(compiler,".global %s\n", compiler->program->name);
  orc_compiler_append_code(compiler,"%s:\n", compiler->program->name);

  for(i=0;i<16;i++){
    if (compiler->used_regs[ORC_GP_REG_BASE + i] &&
        compiler->save_regs[ORC_GP_REG_BASE + i]) {
      regs |= (1<<i);
    }
  }
  if (regs) orc_arm_emit_push (compiler, regs);

}

void
orc_arm_dump_insns (OrcCompiler *compiler)
{
  orc_arm_emit_label (compiler, 0);

  orc_arm_emit_add_r (compiler, ORC_ARM_COND_AL, 0, ORC_ARM_A2, ORC_ARM_A3, ORC_ARM_A4);
  orc_arm_emit_sub_r (compiler, ORC_ARM_COND_AL, 0, ORC_ARM_A2, ORC_ARM_A3, ORC_ARM_A4);
  orc_arm_emit_push (compiler, 0x06);
  orc_arm_emit_mov_r (compiler, ORC_ARM_COND_AL, 0, ORC_ARM_A2, ORC_ARM_A3);

  orc_arm_emit_branch (compiler, ORC_ARM_COND_LE, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, 0);

  orc_arm_emit_load_imm (compiler, ORC_ARM_A3, 0xa500);
  orc_arm_loadw (compiler, ORC_ARM_A3, ORC_ARM_A4, 0xa5);
  orc_arm_emit_load_reg (compiler, ORC_ARM_A3, ORC_ARM_A4, 0x5a5);
}

void
orc_arm_emit_epilogue (OrcCompiler *compiler)
{
  int i;
  unsigned int regs = 0;

  for(i=0;i<16;i++){
    if (compiler->used_regs[ORC_GP_REG_BASE + i] &&
        compiler->save_regs[ORC_GP_REG_BASE + i]) {
      regs |= (1<<i);
    }
  }
  if (regs) orc_arm_emit_pop (compiler, regs);
  orc_arm_emit_bx_lr (compiler);

  /* orc_arm_dump_insns (compiler); */
}

static OrcTarget orc_arm_target = {
  "arm",
#ifdef HAVE_ARM
  TRUE,
#else
  FALSE,
#endif
  ORC_GP_REG_BASE,
  orc_compiler_orc_arm_get_default_flags,
  orc_compiler_orc_arm_init,
  orc_compiler_orc_arm_assemble,
  { { 0 } },
  0,
  NULL,
  NULL,
  NULL,
  orc_arm_flush_cache
};

void
orc_arm_init (void)
{
#if defined(HAVE_ARM)
  orc_arm_get_cpu_flags ();
#endif

  orc_target_register (&orc_arm_target);

  orc_compiler_orc_arm_register_rules (&orc_arm_target);
}

unsigned int
orc_compiler_orc_arm_get_default_flags (void)
{
#if defined(HAVE_ARM)
  return orc_arm_get_cpu_flags ();
#else
  return ORC_TARGET_ARM_EDSP;
#endif
}

void
orc_compiler_orc_arm_init (OrcCompiler *compiler)
{
  int i;

  for(i=ORC_GP_REG_BASE;i<ORC_GP_REG_BASE+9;i++){
    compiler->valid_regs[i] = 1;
  }
  /* compiler->valid_regs[ORC_ARM_SB] = 0; */
  compiler->valid_regs[ORC_ARM_IP] = 0;
  compiler->valid_regs[ORC_ARM_SP] = 0;
  compiler->valid_regs[ORC_ARM_LR] = 0;
  compiler->valid_regs[ORC_ARM_PC] = 0;
  for(i=4;i<11;i++) {
    compiler->save_regs[ORC_GP_REG_BASE+i] = 1;
  }
  
  for(i=0;i<ORC_N_REGS;i++){
    compiler->alloc_regs[i] = 0;
    compiler->used_regs[i] = 0;
  }
  compiler->exec_reg = ORC_ARM_A1;
  compiler->valid_regs[compiler->exec_reg] = 0;
  compiler->gp_tmpreg = ORC_ARM_A2;
  compiler->valid_regs[compiler->gp_tmpreg] = 0;
  compiler->tmpreg = ORC_ARM_A3;
  compiler->valid_regs[compiler->tmpreg] = 0;

  compiler->loop_shift = 0;
}

void
orc_arm_load_constants_outer (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_CONST:
        /* orc_arm_emit_load_imm (compiler, compiler->vars[i].alloc, */
        /*     (int)compiler->vars[i].value); */
        break;
      case ORC_VAR_TYPE_PARAM:
        ORC_PROGRAM_ERROR(compiler,"unimplemented");
        return;
        /* FIXME offset is too large */
        /* orc_arm_loadw (compiler, compiler->vars[i].alloc, */
        /*     compiler->exec_reg, */
        /*     (int)ORC_STRUCT_OFFSET(OrcExecutor, params[i])); */
        break;
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        break;
      default:
        break;
    }
  }

  for(i=0;i<compiler->n_insns;i++){
    OrcInstruction *insn = compiler->insns + i;
    OrcStaticOpcode *opcode = insn->opcode;
    OrcRule *rule;

    if (!(insn->flags & ORC_INSN_FLAG_INVARIANT)) continue;

    ORC_ASM_CODE(compiler,"# %d: %s\n", i, insn->opcode->name);

    rule = insn->rule;
    if (rule && rule->emit) {
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      ORC_COMPILER_ERROR(compiler,"No rule for: %s", opcode->name);
    }
  }
}

void
orc_arm_load_constants_inner (OrcCompiler *compiler)
{
  int i;
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_CONST:
      case ORC_VAR_TYPE_PARAM:
        break;
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        orc_arm_emit_load_reg (compiler, 
            compiler->vars[i].ptr_register,
            compiler->exec_reg, ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
        break;
      default:
        break;
    }
  }
}

#if 0
void
orc_arm_emit_load_src (OrcCompiler *compiler, OrcVariable *var)
{
  int ptr_reg;
  if (var->ptr_register == 0) {
    int i;
    i = var - compiler->vars;
    /* orc_arm_emit_mov_memoffset_reg (compiler, orc_arm_ptr_size, */
    /*     (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]), */
    /*     compiler->exec_reg, X86_ECX); */
    ptr_reg = ORC_ARM_PC;
  } else {
    ptr_reg = var->ptr_register;
  }
  switch (var->size << compiler->loop_shift) {
    case 1:
      orc_arm_loadb (compiler, var->alloc, ptr_reg, 0);
      /* orc_arm_emit_mov_memoffset_reg (compiler, 1, 0, ptr_reg, X86_ECX); */
      /* orc_arm_emit_mov_reg_arm (compiler, X86_ECX, var->alloc); */
      break;
    case 2:
      orc_arm_loadw (compiler, var->alloc, ptr_reg, 0);
      /* orc_arm_emit_mov_memoffset_reg (compiler, 2, 0, ptr_reg, X86_ECX); */
      /* orc_arm_emit_mov_reg_arm (compiler, X86_ECX, var->alloc); */
      break;
    case 4:
      orc_arm_loadl (compiler, var->alloc, ptr_reg, 0);
      /* orc_arm_emit_mov_memoffset_arm (compiler, 4, 0, ptr_reg, var->alloc); */
      break;
    /* case 8: */
      /* orc_arm_emit_mov_memoffset_arm (compiler, 8, 0, ptr_reg, var->alloc); */
      break;
    /* case 16: */
      /* orc_arm_emit_mov_memoffset_arm (compiler, 16, 0, ptr_reg, var->alloc); */
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size %d", var->size << compiler->loop_shift);
  }
}

void
orc_arm_emit_store_dest (OrcCompiler *compiler, OrcVariable *var)
{
  int ptr_reg;
  if (var->ptr_register == 0) {
    /* orc_arm_emit_mov_memoffset_reg (compiler, orc_arm_ptr_size, */
    /*     var->ptr_offset, compiler->exec_reg, X86_ECX); */
    ptr_reg = ORC_ARM_PC;
  } else {
    ptr_reg = var->ptr_register;
  }
  switch (var->size << compiler->loop_shift) {
    case 1:
      orc_arm_storeb (compiler, ptr_reg, 0, var->alloc);
      /* orc_arm_emit_mov_orc_arm_reg (compiler, var->alloc, X86_ECX); */
      /* orc_arm_emit_mov_reg_memoffset (compiler, 1, X86_ECX, 0, ptr_reg); */
      break;
    case 2:
      orc_arm_storew (compiler, ptr_reg, 0, var->alloc);
      /* orc_arm_emit_mov_orc_arm_reg (compiler, var->alloc, X86_ECX); */
      /* orc_arm_emit_mov_reg_memoffset (compiler, 2, X86_ECX, 0, ptr_reg); */
      break;
    case 4:
      orc_arm_storel (compiler, ptr_reg, 0, var->alloc);
      /* orc_arm_emit_mov_orc_arm_memoffset (compiler, 4, var->alloc, 0, ptr_reg, */
      /*     var->is_aligned, var->is_uncached); */
      break;
    case 8:
      /* orc_arm_emit_mov_orc_arm_memoffset (compiler, 8, var->alloc, 0, ptr_reg, */
      /*     var->is_aligned, var->is_uncached); */
      break;
    case 16:
      /* orc_arm_emit_mov_orc_arm_memoffset (compiler, 16, var->alloc, 0, ptr_reg, */
      /*     var->is_aligned, var->is_uncached); */
      break;
    default:
      ORC_COMPILER_ERROR(compiler, "bad size %d", var->size << compiler->loop_shift);
  }
}
#endif

void
orc_compiler_orc_arm_assemble (OrcCompiler *compiler)
{
  int dest_var = ORC_VAR_D1;

  compiler->vars[dest_var].is_aligned = FALSE;

  orc_arm_emit_prologue (compiler);

  orc_arm_load_constants_outer (compiler);

  if (compiler->program->is_2d) {
    if (compiler->program->constant_m > 0) {
      orc_arm_emit_load_imm (compiler, ORC_ARM_A3, compiler->program->constant_m
);    
      orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    } else {
      orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[ORC_VAR_A1]));
      orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    }
    
    orc_arm_emit_label (compiler, 8);
  }

  orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
      (int)ORC_STRUCT_OFFSET(OrcExecutor,n));
  orc_arm_load_constants_inner (compiler);

  orc_arm_emit_label (compiler, 1);

  orc_arm_emit_cmp_i (compiler, ORC_ARM_COND_AL, ORC_ARM_IP, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, 3);

  orc_arm_emit_label (compiler, 2);
  orc_arm_emit_loop (compiler);
  orc_arm_emit_sub_i (compiler, ORC_ARM_COND_AL, 0, ORC_ARM_IP, ORC_ARM_IP, 1);
  orc_arm_emit_cmp_i (compiler, ORC_ARM_COND_AL, ORC_ARM_IP, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, 2);
  orc_arm_emit_label (compiler, 3);

  if (compiler->program->is_2d) {
    arm_add_strides (compiler);

    orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, params[ORC_VAR_A2]));
    orc_arm_emit_sub_imm (compiler, ORC_ARM_A3, ORC_ARM_A3, 1, TRUE);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, 8);
  }

  orc_arm_emit_epilogue (compiler);

  orc_arm_do_fixups (compiler);
}

void
orc_arm_emit_loop (OrcCompiler *compiler)
{
  int j;
  int k;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  OrcRule *rule;

  for(j=0;j<compiler->n_insns;j++){
    insn = compiler->insns + j;
    opcode = insn->opcode;

    if (insn->flags & ORC_INSN_FLAG_INVARIANT) continue;

    orc_compiler_append_code(compiler,"# %d: %s", j, insn->opcode->name);

    /* set up args */
#if 0
    for(k=0;k<opcode->n_src + opcode->n_dest;k++){
      args[k] = compiler->vars + insn->args[k];
      orc_compiler_append_code(compiler," %d", args[k]->alloc);
      if (args[k]->is_chained) {
        orc_compiler_append_code(compiler," (chained)");
      }
    }
#endif
    orc_compiler_append_code(compiler,"\n");

    for(k=0;k<ORC_STATIC_OPCODE_N_SRC;k++){
      if (opcode->src_size[k] == 0) continue;

      switch (compiler->vars[insn->src_args[k]].vartype) {
        case ORC_VAR_TYPE_SRC:
        case ORC_VAR_TYPE_DEST:
          /* orc_arm_emit_load_src (compiler, &compiler->vars[insn->src_args[k]]); */
          break;
        case ORC_VAR_TYPE_CONST:
          break;
        case ORC_VAR_TYPE_PARAM:
          break;
        case ORC_VAR_TYPE_TEMP:
          break;
        default:
          break;
      }
    }

    rule = insn->rule;
    if (rule && rule->emit) {
      int src = ORC_SRC_ARG (compiler, insn, 0);
      int dest = ORC_DEST_ARG (compiler, insn, 0);

      if (dest != src) {
        orc_arm_emit_mov_r (compiler, ORC_ARM_COND_AL, 0, dest, src);
      }
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      orc_compiler_append_code(compiler,"No rule for: %s\n", opcode->name);
    }

    for(k=0;k<ORC_STATIC_OPCODE_N_DEST;k++){
      if (opcode->dest_size[k] == 0) continue;

      switch (compiler->vars[insn->dest_args[k]].vartype) {
        case ORC_VAR_TYPE_DEST:
          /* orc_arm_emit_store_dest (compiler, &compiler->vars[insn->dest_args[k]]); */
          break;
        case ORC_VAR_TYPE_TEMP:
          break;
        default:
          break;
      }
    }
  }

  for(k=0;k<ORC_N_COMPILER_VARIABLES;k++){
    if (compiler->vars[k].name == NULL) continue;
    if (compiler->vars[k].vartype == ORC_VAR_TYPE_SRC ||
        compiler->vars[k].vartype == ORC_VAR_TYPE_DEST) {
      if (compiler->vars[k].ptr_register) {
        orc_arm_emit_add_i (compiler, ORC_ARM_COND_AL, 0,
            compiler->vars[k].ptr_register,
            compiler->vars[k].ptr_register,
            compiler->vars[k].size << compiler->loop_shift);
      } else {
        /* orc_arm_emit_add_imm_memoffset (compiler, orc_arm_ptr_size, */
        /*     compiler->vars[k].size << compiler->loop_shift, */
        /*     (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]), */
        /*     compiler->exec_reg); */
      }
    }
  }
}

void
arm_add_strides (OrcCompiler *compiler)
{
  int i;

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_CONST:
        break;
      case ORC_VAR_TYPE_PARAM:
        break;
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
            (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
        orc_arm_emit_load_reg (compiler, ORC_ARM_A2, compiler->exec_reg,
            (int)ORC_STRUCT_OFFSET(OrcExecutor, params[i]));
        orc_arm_emit_add (compiler, ORC_ARM_A3, ORC_ARM_A3, ORC_ARM_A2);
        orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
            (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
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

