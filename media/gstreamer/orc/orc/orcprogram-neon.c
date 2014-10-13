
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcprogram.h>
#include <orc/orcarm.h>
#include <orc/orcutils.h>
#include <orc/orcdebug.h>

#include <orc/orcneon.h>

#define SIZE 65536

void orc_neon_emit_loop (OrcCompiler *compiler, int unroll_index);

void orc_compiler_neon_register_rules (OrcTarget *target);
unsigned int orc_compiler_neon_get_default_flags (void);

void orc_compiler_neon_init (OrcCompiler *compiler);
void orc_compiler_neon_assemble (OrcCompiler *compiler);

void orc_compiler_rewrite_vars (OrcCompiler *compiler);
void orc_compiler_dump (OrcCompiler *compiler);
void orc_neon_save_accumulators (OrcCompiler *compiler);
void neon_add_strides (OrcCompiler *compiler);


void
orc_neon_emit_prologue (OrcCompiler *compiler)
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
orc_neon_dump_insns (OrcCompiler *compiler)
{

  orc_arm_emit_label (compiler, 0);

  orc_arm_emit_add (compiler, ORC_ARM_A2, ORC_ARM_A3, ORC_ARM_A4);
  orc_arm_emit_sub (compiler, ORC_ARM_A2, ORC_ARM_A3, ORC_ARM_A4);
  orc_arm_emit_push (compiler, 0x06);
  orc_arm_emit_mov (compiler, ORC_ARM_A2, ORC_ARM_A3);

  orc_arm_emit_branch (compiler, ORC_ARM_COND_LE, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, 0);

  orc_arm_emit_load_imm (compiler, ORC_ARM_A3, 0xa500);
  orc_arm_loadw (compiler, ORC_ARM_A3, ORC_ARM_A4, 0xa5);
  orc_arm_emit_load_reg (compiler, ORC_ARM_A3, ORC_ARM_A4, 0x5a5);
}

void
orc_neon_emit_epilogue (OrcCompiler *compiler)
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

  /* arm_dump_insns (compiler); */
}

static OrcTarget neon_target = {
  "neon",
#ifdef HAVE_ARM
  TRUE,
#else
  FALSE,
#endif
  ORC_VEC_REG_BASE,
  orc_compiler_neon_get_default_flags,
  orc_compiler_neon_init,
  orc_compiler_neon_assemble,
  { { 0 } }, 0,
  NULL,
  NULL,
  NULL,
  orc_arm_flush_cache
};

void
orc_neon_init (void)
{
#if defined(HAVE_ARM)
  if (!(orc_arm_get_cpu_flags () & ORC_TARGET_NEON_NEON)) {
    ORC_INFO("marking neon backend non-executable");
    neon_target.executable = FALSE;
  }
#endif

  orc_target_register (&neon_target);

  orc_compiler_neon_register_rules (&neon_target);
}

unsigned int
orc_compiler_neon_get_default_flags (void)
{
  return ORC_TARGET_NEON_NEON;
}

void
orc_compiler_neon_init (OrcCompiler *compiler)
{
  int i;
  int loop_shift;

  for(i=ORC_GP_REG_BASE;i<ORC_GP_REG_BASE+16;i++){
    compiler->valid_regs[i] = 1;
  }
  for(i=ORC_VEC_REG_BASE+0;i<ORC_VEC_REG_BASE+32;i+=2){
    compiler->valid_regs[i] = 1;
  }
  /* compiler->valid_regs[ORC_ARM_SB] = 0; */
  compiler->valid_regs[ORC_ARM_IP] = 0;
  compiler->valid_regs[ORC_ARM_SP] = 0;
  compiler->valid_regs[ORC_ARM_LR] = 0;
  compiler->valid_regs[ORC_ARM_PC] = 0;
  for(i=4;i<12;i++) {
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
  compiler->tmpreg = ORC_VEC_REG_BASE + 0;
  compiler->valid_regs[compiler->tmpreg] = 0;
  compiler->tmpreg2 = ORC_VEC_REG_BASE + 2;
  compiler->valid_regs[compiler->tmpreg2] = 0;

  loop_shift = 0;
  switch (compiler->max_var_size) {
    case 1:
      compiler->loop_shift = 4;
      break;
    case 2:
      compiler->loop_shift = 3;
      break;
    case 4:
      compiler->loop_shift = 2;
      break;
    case 8:
      compiler->loop_shift = 1;
      break;
    default:
      ORC_ERROR("unhandled max var size %d", compiler->max_var_size);
      break;
  }

  switch (orc_program_get_max_array_size (compiler->program)) {
    case 0:
    case 1:
      loop_shift = 4;
      break;
    case 2:
      loop_shift = 3;
      break;
    case 4:
      loop_shift = 2;
      break;
    case 8:
      loop_shift = 1;
      break;
    default:
      ORC_ERROR("unhandled max array size %d",
          orc_program_get_max_array_size (compiler->program));
      break;
  }
  if (loop_shift < compiler->loop_shift) {
    compiler->loop_shift = loop_shift;
  }

  switch (orc_program_get_max_accumulator_size (compiler->program)) {
    case 0:
      loop_shift = 4;
      break;
    case 1:
      loop_shift = 3;
      break;
    case 2:
      loop_shift = 2;
      break;
    case 4:
      loop_shift = 1;
      break;
    case 8:
      loop_shift = 0;
      break;
    default:
      ORC_ERROR("unhandled max accumulator size %d",
          orc_program_get_max_accumulator_size (compiler->program));
      break;
  }
  if (loop_shift < compiler->loop_shift) {
    compiler->loop_shift = loop_shift;
  }

  /* Unrolling isn't helpful until neon gets an instruction
   * scheduler.  This decreases the raw amount of code generated
   * while still keeping the feature active. */
  if (compiler->n_insns < 5) {
    compiler->unroll_shift = 0;
  }

  if (0) {
    compiler->need_mask_regs = TRUE;
  }
}

void
orc_neon_load_constants_outer (OrcCompiler *compiler)
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
        break;
      case ORC_VAR_TYPE_ACCUMULATOR:
        orc_neon_emit_loadil (compiler, compiler->vars[i].alloc, 0);
        break;
      case ORC_VAR_TYPE_TEMP:
        break;
      default:
        ORC_PROGRAM_ERROR(compiler,"bad vartype");
        break;
    }
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

void
orc_neon_load_constants_inner (OrcCompiler *compiler)
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
        orc_arm_emit_load_reg (compiler, 
            compiler->vars[i].ptr_register,
            compiler->exec_reg, ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
        break;
      case ORC_VAR_TYPE_ACCUMULATOR:
        break;
      case ORC_VAR_TYPE_TEMP:
        break;
      default:
        ORC_PROGRAM_ERROR(compiler,"bad vartype");
        break;
    }
  }
}

#if 0
void
orc_neon_emit_load_src (OrcCompiler *compiler, OrcVariable *var, int unroll_index)
{
  int ptr_reg;
  int update;

  if (var->ptr_register == 0) {
    int i;
    i = var - compiler->vars;
    /* arm_emit_mov_memoffset_reg (compiler, arm_ptr_size, */
    /*     (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]), */
    /*     p->exec_reg, X86_ECX); */
    ptr_reg = ORC_ARM_PC;
  } else {
    ptr_reg = var->ptr_register;
  }
  if (var->vartype == ORC_VAR_TYPE_DEST) {
    update = FALSE;
  } else {
    update = TRUE;
  }
  switch (var->size) {
    case 1:
      orc_neon_loadb (compiler, var, update);
      break;
    case 2:
      orc_neon_loadw (compiler, var, update);
      break;
    case 4:
      orc_neon_loadl (compiler, var, update);
      break;
    case 8:
      orc_neon_loadq (compiler, var->alloc, ptr_reg, update, var->is_aligned);
      break;
    default:
      ORC_ERROR("bad size");
  }
  
  if (unroll_index == 0) {
  switch (compiler->size_region) {
    case 0:
    case 1:
      orc_neon_preload (compiler, var, FALSE, 208);
      break;
    case 2:
    case 3:
      orc_neon_preload (compiler, var, FALSE, 208);
      break;
  }
  }
}

void
orc_neon_emit_store_dest (OrcCompiler *compiler, OrcVariable *var)
{
  int ptr_reg;
  if (var->ptr_register == 0) {
    /* arm_emit_mov_memoffset_reg (compiler, arm_ptr_size, */
    /*     var->ptr_offset, p->exec_reg, X86_ECX); */
    ptr_reg = ORC_ARM_PC;
  } else {
    ptr_reg = var->ptr_register;
  }
  switch (var->size) {
    case 1:
      orc_neon_storeb (compiler, ptr_reg, TRUE, var->alloc, var->is_aligned);
      break;
    case 2:
      orc_neon_storew (compiler, ptr_reg, TRUE, var->alloc, var->is_aligned);
      break;
    case 4:
      orc_neon_storel (compiler, ptr_reg, TRUE, var->alloc, var->is_aligned);
      break;
    case 8:
      orc_neon_storeq (compiler, ptr_reg, TRUE, var->alloc, var->is_aligned);
      break;
    default:
      ORC_ERROR("bad size");
  }

  switch (compiler->size_region) {
    case 0:
      break;
    case 1:
      /* assume hot cache, see below */
      break;
    case 2:
      /* This is only useful for cold cache and for memset-like operations,
         which isn't the usual case, thus it's disabled. */
#if 0
      orc_neon_preload (compiler, var, FALSE, 208);
#endif
      break;
    case 3:
      /* none */
      break;
  }
}
#endif

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
    case 8:
      return 3;
    default:
      ORC_ERROR("bad size %d", size);
  }
  return -1;
}

static int
get_align_var (OrcCompiler *compiler)
{
  if (compiler->vars[ORC_VAR_D1].size) return ORC_VAR_D1;
  if (compiler->vars[ORC_VAR_S1].size) return ORC_VAR_S1;

  ORC_PROGRAM_ERROR(compiler, "could not find alignment variable");

  return -1;
}

enum {
  LABEL_ONE_REGION = 1,
  LABEL_ONE_REGION_AFTER,
  LABEL_REGION0_LOOP,
  LABEL_REGION0_SKIP,
  LABEL_REGION1_LOOP,
  LABEL_REGION1_SKIP,
  LABEL_REGION2_LOOP_SMALL,
  LABEL_REGION2_LOOP_MEDIUM,
  LABEL_REGION2_LOOP_LARGE,
  LABEL_REGION2_SMALL,
  LABEL_REGION2_MEDIUM,
  LABEL_REGION2_SKIP,
  LABEL_REGION3_LOOP,
  LABEL_REGION3_SKIP,
  LABEL_OUTER_LOOP,
  LABEL_OUTER_LOOP_SKIP,
  LABEL_L1L2_AFTER,
};

void
orc_compiler_neon_assemble (OrcCompiler *compiler)
{
  int align_var;
  int align_shift;
  int var_size_shift;
  int i;
  
  align_var = get_align_var (compiler);
  if (compiler->error) return;

  var_size_shift = get_shift (compiler->vars[align_var].size);
  align_shift = 4;

  compiler->vars[align_var].is_aligned = FALSE;

  orc_neon_emit_prologue (compiler);

  orc_neon_load_constants_outer (compiler);

  if (compiler->program->is_2d) {
    if (compiler->program->constant_m > 0) {
      orc_arm_emit_load_imm (compiler, ORC_ARM_A3, compiler->program->constant_m);
      orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    } else {
      orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor, params[ORC_VAR_A1]));
      orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
          (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    }

    orc_arm_emit_label (compiler, LABEL_OUTER_LOOP);
  }

#define ORC_NEON_ALIGNED_DEST_CUTOFF 64

  if (compiler->loop_shift > 0 && compiler->n_insns < 5) {
    orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,n));
    orc_arm_emit_cmp_imm (compiler, ORC_ARM_A3, ORC_NEON_ALIGNED_DEST_CUTOFF);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_GT, LABEL_REGION0_SKIP);

    orc_arm_emit_asr_imm (compiler, ORC_ARM_A2, ORC_ARM_A3,
        compiler->loop_shift);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A2, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter2));

    orc_arm_emit_and_imm (compiler, ORC_ARM_A3, ORC_ARM_A3,
        (1<<compiler->loop_shift)-1);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter3));

    orc_neon_load_constants_inner (compiler);
    orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter2));
    orc_arm_emit_cmp_imm (compiler, ORC_ARM_IP, 0);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION2_SKIP);

    compiler->size_region = 0;
    orc_arm_emit_label (compiler, LABEL_REGION0_LOOP);
    orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
    orc_neon_emit_loop (compiler, -1);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION0_LOOP);
    

    orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, LABEL_REGION2_SKIP);

    orc_arm_emit_label (compiler, LABEL_REGION0_SKIP);
  }

  if (compiler->loop_shift > 0) {
    orc_arm_emit_load_imm (compiler, ORC_ARM_IP, 1<<align_shift);

    orc_arm_emit_load_reg (compiler, ORC_ARM_A2, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,arrays[align_var]));
    orc_arm_emit_sub (compiler, ORC_ARM_IP, ORC_ARM_IP, ORC_ARM_A2);
    orc_arm_emit_and_imm (compiler, ORC_ARM_IP, ORC_ARM_IP,
        (1<<align_shift)-1);
    if (var_size_shift > 0) {
      orc_arm_emit_asr_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, var_size_shift);
    }

    orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,n));
    orc_arm_emit_cmp (compiler, ORC_ARM_A3, ORC_ARM_IP);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_LE, LABEL_ONE_REGION);

    orc_arm_emit_store_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter1));
    orc_arm_emit_sub (compiler, ORC_ARM_A2, ORC_ARM_A3, ORC_ARM_IP);

    orc_arm_emit_asr_imm (compiler, ORC_ARM_A3, ORC_ARM_A2,
        compiler->loop_shift + compiler->unroll_shift);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter2));

    orc_arm_emit_and_imm (compiler, ORC_ARM_A3, ORC_ARM_A2,
        (1<<(compiler->loop_shift + compiler->unroll_shift))-1);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter3));

    orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, LABEL_ONE_REGION_AFTER);
    orc_arm_emit_label (compiler, LABEL_ONE_REGION);

    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter1));

    orc_arm_emit_load_imm (compiler, ORC_ARM_A3, 0);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter2));
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter3));

    orc_arm_emit_label (compiler, LABEL_ONE_REGION_AFTER);
  }

  orc_neon_load_constants_inner (compiler);

  if (compiler->loop_shift > 0) {
    int save_loop_shift = compiler->loop_shift;
    compiler->loop_shift = 0;

    orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter1));

    orc_arm_emit_cmp_imm (compiler, ORC_ARM_IP, 0);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION1_SKIP);

    orc_arm_emit_label (compiler, LABEL_REGION1_LOOP);
    orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
    orc_neon_emit_loop (compiler, -1);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION1_LOOP);
    orc_arm_emit_label (compiler, LABEL_REGION1_SKIP);

    compiler->loop_shift = save_loop_shift;
    compiler->vars[align_var].is_aligned = TRUE;
  }

  if (compiler->loop_shift > 0) {
    orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter2));
  } else {
    orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,n));
  }

  orc_arm_emit_cmp_imm (compiler, ORC_ARM_IP, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION2_SKIP);

  orc_arm_emit_asr_imm (compiler, compiler->gp_tmpreg, ORC_ARM_IP,
      17 + var_size_shift - compiler->loop_shift - compiler->unroll_shift);
  orc_arm_emit_cmp_imm (compiler, compiler->gp_tmpreg, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION2_MEDIUM);

  /* N is larger than L2 cache size */
  compiler->size_region = 3;
  orc_arm_emit_label (compiler, LABEL_REGION2_LOOP_LARGE);
  orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
  for(i=0;i<(1<<compiler->unroll_shift);i++){
    orc_neon_emit_loop (compiler, i);
  }
  orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION2_LOOP_LARGE);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, LABEL_REGION2_SKIP);

  orc_arm_emit_label (compiler, LABEL_REGION2_MEDIUM);
  orc_arm_emit_asr_imm (compiler, compiler->gp_tmpreg, ORC_ARM_IP,
      13 + var_size_shift - compiler->loop_shift - compiler->unroll_shift);
  orc_arm_emit_cmp_imm (compiler, compiler->gp_tmpreg, 0);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION2_SMALL);

  /* N is smaller than L2 cache size */
  compiler->size_region = 2;
  orc_arm_emit_label (compiler, LABEL_REGION2_LOOP_MEDIUM);
  orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
  for(i=0;i<(1<<compiler->unroll_shift);i++){
    orc_neon_emit_loop (compiler, i);
  }
  orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION2_LOOP_MEDIUM);
  orc_arm_emit_branch (compiler, ORC_ARM_COND_AL, LABEL_REGION2_SKIP);

  orc_arm_emit_label (compiler, LABEL_REGION2_SMALL);
  /* N is smaller than L2 cache size */
  compiler->size_region = 1;
  orc_arm_emit_label (compiler, LABEL_REGION2_LOOP_SMALL);
  orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
  for(i=0;i<(1<<compiler->unroll_shift);i++){
    orc_neon_emit_loop (compiler, i);
  }
  orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION2_LOOP_SMALL);

  orc_arm_emit_label (compiler, LABEL_REGION2_SKIP);

  if (compiler->loop_shift > 0) {
    int save_loop_shift = compiler->loop_shift;

    compiler->loop_shift = 0;

    compiler->vars[align_var].is_aligned = FALSE;

    orc_arm_emit_load_reg (compiler, ORC_ARM_IP, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,counter3));

    orc_arm_emit_cmp_imm (compiler, ORC_ARM_IP, 0);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_EQ, LABEL_REGION3_SKIP);

    orc_arm_emit_label (compiler, LABEL_REGION3_LOOP);
    orc_arm_emit_sub_imm (compiler, ORC_ARM_IP, ORC_ARM_IP, 1, TRUE);
    orc_neon_emit_loop (compiler, -1);
    orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_REGION3_LOOP);
    orc_arm_emit_label (compiler, LABEL_REGION3_SKIP);

    compiler->loop_shift = save_loop_shift;
  }

  if (compiler->program->is_2d) {
    neon_add_strides (compiler);

    orc_arm_emit_load_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, params[ORC_VAR_A2]));
    orc_arm_emit_sub_imm (compiler, ORC_ARM_A3, ORC_ARM_A3, 1, TRUE);
    orc_arm_emit_store_reg (compiler, ORC_ARM_A3, compiler->exec_reg,
        (int)ORC_STRUCT_OFFSET(OrcExecutor,params[ORC_VAR_A2]));
    orc_arm_emit_branch (compiler, ORC_ARM_COND_NE, LABEL_OUTER_LOOP);
  }

  orc_neon_save_accumulators (compiler);

  orc_neon_emit_epilogue (compiler);

  orc_arm_emit_align (compiler, 4);

  orc_arm_emit_label (compiler, 20);
  orc_arm_emit_data (compiler, 0x07060706);
  orc_arm_emit_data (compiler, 0x07060706);
  orc_arm_emit_data (compiler, 0x0f0e0f0e);
  orc_arm_emit_data (compiler, 0x0f0e0f0e);

  orc_arm_do_fixups (compiler);
}

void
orc_neon_emit_loop (OrcCompiler *compiler, int unroll_index)
{
  int j;
  int k;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  OrcRule *rule;

  orc_compiler_append_code(compiler,"# LOOP shift %d\n", compiler->loop_shift);
  for(j=0;j<compiler->n_insns;j++){
    compiler->insn_index = j;
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
          /* orc_neon_emit_load_src (compiler, &compiler->vars[insn->src_args[k]], unroll_index); */
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

    compiler->insn_shift = compiler->loop_shift;
    if (insn->flags & ORC_INSTRUCTION_FLAG_X2) {
      compiler->insn_shift += 1;
    }
    if (insn->flags & ORC_INSTRUCTION_FLAG_X4) {
      compiler->insn_shift += 2;
    }

    rule = insn->rule;
    if (rule && rule->emit) {
#if 0
      if (compiler->vars[insn->dest_args[0]].alloc !=
          compiler->vars[insn->src_args[0]].alloc) {
        orc_neon_emit_mov (compiler, compiler->vars[insn->dest_args[0]].alloc,
            compiler->vars[insn->src_args[0]].alloc);
      }
#endif
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      orc_compiler_append_code(compiler,"No rule for: %s\n", opcode->name);
    }

    for(k=0;k<ORC_STATIC_OPCODE_N_DEST;k++){
      if (opcode->dest_size[k] == 0) continue;

      switch (compiler->vars[insn->dest_args[k]].vartype) {
        case ORC_VAR_TYPE_DEST:
          /* orc_neon_emit_store_dest (compiler, &compiler->vars[insn->dest_args[k]]); */
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
        orc_arm_emit_add_imm (compiler,
            compiler->vars[k].ptr_register,
            compiler->vars[k].ptr_register,
            compiler->vars[k].size << compiler->loop_shift);
      } else {
        /* arm_emit_add_imm_memoffset (compiler, arm_ptr_size, */
        /*     compiler->vars[k].size << compiler->loop_shift, */
        /*     (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]), */
        /*     p->exec_reg); */
      }
    }
  }
}

#define NEON_BINARY(code,a,b,c) \
  ((code) | \
   (((a)&0xf)<<12) | \
   ((((a)>>4)&0x1)<<22) | \
   (((b)&0xf)<<16) | \
   ((((b)>>4)&0x1)<<7) | \
   (((c)&0xf)<<0) | \
   ((((c)>>4)&0x1)<<5))

void
orc_neon_save_accumulators (OrcCompiler *compiler)
{
  int i;
  int src;
  unsigned int code;

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcVariable *var = compiler->vars + i;

    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_ACCUMULATOR:
        src = compiler->vars[i].alloc;

        orc_arm_emit_load_imm (compiler, compiler->gp_tmpreg,
            ORC_STRUCT_OFFSET(OrcExecutor, accumulators[i-ORC_VAR_A1]));
        orc_arm_emit_add (compiler, compiler->gp_tmpreg,
            compiler->gp_tmpreg, compiler->exec_reg);
        switch (var->size) {
          case 2:
            if (compiler->loop_shift > 0) {
              ORC_ASM_CODE(compiler,"  vpaddl.u16 %s, %s\n",
                  orc_neon_reg_name (src),
                  orc_neon_reg_name (src));
              code = 0xf3b40280;
              code |= (src&0xf) << 12;
              code |= ((src>>4)&0x1) << 22;
              code |= (src&0xf) << 0;
              orc_arm_emit (compiler, code);

              ORC_ASM_CODE(compiler,"  vpaddl.u32 %s, %s\n",
                  orc_neon_reg_name (src),
                  orc_neon_reg_name (src));
              code = 0xf3b80280;
              code |= (src&0xf) << 12;
              code |= ((src>>4)&0x1) << 22;
              code |= (src&0xf) << 0;
              orc_arm_emit (compiler, code);
            }

            ORC_ASM_CODE(compiler,"  vst1.16 %s[%d], [%s]\n",
                orc_neon_reg_name (src), 0,
                orc_arm_reg_name (compiler->gp_tmpreg));
            code = 0xf480040f;
            code |= (compiler->gp_tmpreg&0xf) << 16;
            code |= (src&0xf) << 12;
            code |= ((src>>4)&0x1) << 22;
            orc_arm_emit (compiler, code);
            break;
          case 4:
            if (compiler->loop_shift > 0) {
              ORC_ASM_CODE(compiler,"  vpadd.u32 %s, %s, %s\n",
                  orc_neon_reg_name (src),
                  orc_neon_reg_name (src),
                  orc_neon_reg_name (src));
              code = NEON_BINARY(0xf2200b10, src, src, src);
              orc_arm_emit (compiler, code);
            }

            ORC_ASM_CODE(compiler,"  vst1.32 %s[%d], [%s]\n",
                orc_neon_reg_name (src), 0,
                orc_arm_reg_name (compiler->gp_tmpreg));
            code = 0xf480080f;
            code |= (compiler->gp_tmpreg&0xf) << 16;
            code |= (src&0xf) << 12;
            code |= ((src>>4)&0x1) << 22;
            orc_arm_emit (compiler, code);
            break;
          default:
            ORC_ERROR("bad size");
        }

        break;
      default:
        break;
    }
  }
}

void
neon_add_strides (OrcCompiler *compiler)
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

