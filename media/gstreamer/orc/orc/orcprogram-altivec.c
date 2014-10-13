
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>

#include <orc/orcpowerpc.h>
#include <orc/orcprogram.h>
#include <orc/orcdebug.h>


void orc_compiler_powerpc_init (OrcCompiler *compiler);
unsigned int orc_compiler_powerpc_get_default_flags (void);
void orc_compiler_powerpc_assemble (OrcCompiler *compiler);
void orc_compiler_powerpc_register_rules (OrcTarget *target);


void
powerpc_emit_prologue (OrcCompiler *compiler)
{
  int i;

  ORC_ASM_CODE (compiler, ".global %s\n", compiler->program->name);
  ORC_ASM_CODE (compiler, "%s:\n", compiler->program->name);

  if (compiler->is_64bit) {
    ORC_ASM_CODE (compiler, " .quad .%s,.TOC.@tocbase,0\n",
                  compiler->program->name);
    ORC_ASM_CODE (compiler, ".%s:\n", compiler->program->name);
    powerpc_emit (compiler, 0); powerpc_emit (compiler, 0);
    powerpc_emit (compiler, 0); powerpc_emit (compiler, 0);
    powerpc_emit (compiler, 0); powerpc_emit (compiler, 0);
    powerpc_emit_stdu (compiler, POWERPC_R1, POWERPC_R1, -16);
  } else {
    powerpc_emit_stwu (compiler, POWERPC_R1, POWERPC_R1, -16);
  }

  for(i=POWERPC_R13;i<=POWERPC_R31;i++){
    if (compiler->used_regs[i]) {
      /* powerpc_emit_push (compiler, 4, i); */
    }
  }
}

void
powerpc_emit_epilogue (OrcCompiler *compiler)
{
  int i;

  for(i=POWERPC_R31;i>=POWERPC_R31;i--){
    if (compiler->used_regs[i]) {
      /* powerpc_emit_pop (compiler, 4, i); */
    }
  }

  powerpc_emit_addi (compiler, POWERPC_R1, POWERPC_R1, 16);
  ORC_ASM_CODE(compiler,"  blr\n");
  powerpc_emit(compiler, 0x4e800020);
}

static OrcTarget altivec_target = {
  "altivec",
#ifdef HAVE_POWERPC
  TRUE,
#else
  FALSE,
#endif
  ORC_VEC_REG_BASE,
  orc_compiler_powerpc_get_default_flags,
  orc_compiler_powerpc_init,
  orc_compiler_powerpc_assemble,
  { { 0 } },
  0,
  NULL,
  NULL,
  NULL,
  orc_powerpc_flush_cache

};

void
orc_powerpc_init (void)
{
  orc_target_register (&altivec_target);

  orc_compiler_powerpc_register_rules (&altivec_target);
}

unsigned int
orc_compiler_powerpc_get_default_flags (void)
{
  unsigned int flags = 0;

#ifdef __powerpc64__
  flags |= ORC_TARGET_POWERPC_64BIT;
#endif

  return flags;
}

void
orc_compiler_powerpc_init (OrcCompiler *compiler)
{
  int i;

  if (compiler->target_flags & ORC_TARGET_POWERPC_64BIT) {
    compiler->is_64bit = TRUE;
  }

  for(i=0;i<32;i++){
    compiler->valid_regs[POWERPC_R0+i] = 1;
    compiler->valid_regs[POWERPC_V0+i] = 1;
  }
  compiler->valid_regs[POWERPC_R0] = 0; /* used for temp space */
  compiler->valid_regs[POWERPC_R1] = 0; /* stack pointer */
  compiler->valid_regs[POWERPC_R2] = 0; /* TOC pointer */
  compiler->valid_regs[POWERPC_R3] = 0; /* pointer to OrcExecutor */
  compiler->valid_regs[POWERPC_R13] = 0; /* reserved */

  compiler->tmpreg = POWERPC_V0;
  compiler->gp_tmpreg = POWERPC_R4;
  compiler->valid_regs[compiler->tmpreg] = 0;
  compiler->valid_regs[compiler->gp_tmpreg] = 0;

  for(i=14;i<32;i++){
    compiler->save_regs[POWERPC_R0 + i] = 1;
  }
  for(i=20;i<32;i++){
    compiler->save_regs[POWERPC_V0 + i] = 1;
  }

  compiler->loop_shift = 0;
  compiler->load_params = TRUE;
}

void
powerpc_load_inner_constants (OrcCompiler *compiler)
{
  int i;

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (compiler->vars[i].name == NULL) continue;
    switch (compiler->vars[i].vartype) {
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        if (compiler->vars[i].ptr_register) {
          if (compiler->is_64bit) {
            powerpc_emit_ld (compiler,
                compiler->vars[i].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
          } else {
            powerpc_emit_lwz (compiler,
                compiler->vars[i].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[i]));
          }
        } else {
          /* FIXME */
          ORC_ASM_CODE(compiler,"ERROR");
        }
        break;
      default:
        break;
    }
  }
}

static int
orc_program_has_float (OrcCompiler *compiler)
{
  int j;
  for(j=0;j<compiler->n_insns;j++){
    OrcInstruction *insn = compiler->insns + j;
    OrcStaticOpcode *opcode = insn->opcode;
    if (opcode->flags & ORC_STATIC_OPCODE_FLOAT) return TRUE;
  }
  return FALSE;
}

void
orc_compiler_powerpc_assemble (OrcCompiler *compiler)
{
  int j;
  int k;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  /* OrcVariable *args[10]; */
  OrcRule *rule;
  int label_outer_loop_start;
  int label_loop_start;
  int label_leave;
  int set_vscr = FALSE;

  label_outer_loop_start = orc_compiler_label_new (compiler);
  label_loop_start = orc_compiler_label_new (compiler);
  label_leave = orc_compiler_label_new (compiler);

  powerpc_emit_prologue (compiler);

  if (orc_program_has_float (compiler)) {
    int tmp = POWERPC_V0;

    set_vscr = TRUE;

    ORC_ASM_CODE(compiler,"  vspltish %s, %d\n",
        powerpc_get_regname(tmp), 1);
    powerpc_emit_VX(compiler, 0x1000034c,
        powerpc_regnum(tmp), 1, 0);

    powerpc_emit_VX_b(compiler, "mtvscr", 0x10000644, tmp);
  }

  if (compiler->program->is_2d) {
    powerpc_emit_lwz (compiler, POWERPC_R0, POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutorAlt, m));
    powerpc_emit_srawi (compiler, POWERPC_R0, POWERPC_R0,
        compiler->loop_shift, 1);
    powerpc_emit_beq (compiler, label_leave);
    powerpc_emit_stw (compiler, POWERPC_R0, POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutorAlt, m_index));
  }

  /* powerpc_load_constants (compiler); */
  powerpc_load_inner_constants (compiler);

  for(k=0;k<4;k++){
    OrcVariable *var = &compiler->vars[ORC_VAR_A1 + k];

    if (compiler->vars[ORC_VAR_A1 + k].name == NULL) continue;

      /* powerpc_emit_VX_2(p, "vxor", 0x100004c4, reg, reg, reg); */
    powerpc_emit_vxor (compiler, var->alloc, var->alloc, var->alloc);
  }

  powerpc_emit_label (compiler, label_outer_loop_start);

  powerpc_emit_lwz (compiler, POWERPC_R0, POWERPC_R3,
      (int)ORC_STRUCT_OFFSET(OrcExecutor, n));
  powerpc_emit_srawi (compiler, POWERPC_R0, POWERPC_R0,
      compiler->loop_shift, 1);

  powerpc_emit_beq (compiler, label_leave);

  powerpc_emit (compiler, 0x7c0903a6);
  ORC_ASM_CODE (compiler, "  mtctr %s\n", powerpc_get_regname(POWERPC_R0));

  powerpc_emit_label (compiler, label_loop_start);

  for(j=0;j<compiler->n_insns;j++){
    insn = compiler->insns + j;
    opcode = insn->opcode;

    compiler->insn_index = j;

    ORC_ASM_CODE(compiler,"# %d: %s\n", j, insn->opcode->name);

#if 0
    /* set up args */
    for(k=0;k<opcode->n_src + opcode->n_dest;k++){
      args[k] = compiler->vars + insn->args[k];
      ORC_ASM_CODE(compiler," %d", args[k]->alloc);
      if (args[k]->is_chained) {
        ORC_ASM_CODE(compiler," (chained)");
      }
    }
    ORC_ASM_CODE(compiler,"\n");
#endif

    for(k=0;k<ORC_STATIC_OPCODE_N_SRC;k++){
      OrcVariable *var = compiler->vars + insn->src_args[k];

      if (opcode->src_size[k] == 0) continue;

      switch (var->vartype) {
        case ORC_VAR_TYPE_SRC:
        case ORC_VAR_TYPE_DEST:
          /* powerpc_emit_load_src (compiler, var); */
          break;
        case ORC_VAR_TYPE_CONST:
          break;
        case ORC_VAR_TYPE_TEMP:
          break;
        default:
          break;
      }
    }

    compiler->min_temp_reg = ORC_VEC_REG_BASE;

    rule = insn->rule;
    if (rule) {
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      ORC_ASM_CODE(compiler,"No rule for: %s\n", opcode->name);
    }

    for(k=0;k<ORC_STATIC_OPCODE_N_DEST;k++){
      OrcVariable *var = compiler->vars + insn->dest_args[k];

      if (opcode->dest_size[k] == 0) continue;

      switch (var->vartype) {
        case ORC_VAR_TYPE_DEST:
          /* powerpc_emit_store_dest (compiler, var); */
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
        powerpc_emit_addi (compiler,
            compiler->vars[k].ptr_register,
            compiler->vars[k].ptr_register,
            compiler->vars[k].size << compiler->loop_shift);
      } else {
        ORC_ASM_CODE(compiler,"ERROR\n");
      }
    }
  }

  powerpc_emit_bne (compiler, label_loop_start);

  if (compiler->program->is_2d) {
    powerpc_emit_lwz (compiler, POWERPC_R0, POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutorAlt, m_index));
    powerpc_emit_addi_rec (compiler, POWERPC_R0, POWERPC_R0, -1);
    powerpc_emit_beq (compiler, label_leave);

    powerpc_emit_stw (compiler, POWERPC_R0, POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutorAlt, m_index));

    for(k=0;k<ORC_N_COMPILER_VARIABLES;k++){
      if (compiler->vars[k].name == NULL) continue;
      if (compiler->vars[k].vartype == ORC_VAR_TYPE_SRC ||
          compiler->vars[k].vartype == ORC_VAR_TYPE_DEST) {
        if (compiler->vars[k].ptr_register) {
          if (compiler->is_64bit) {
            powerpc_emit_ld (compiler,
                compiler->vars[k].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]));
          } else {
            powerpc_emit_lwz (compiler,
                compiler->vars[k].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]));
          }
          powerpc_emit_lwz (compiler,
              POWERPC_R0,
              POWERPC_R3,
              (int)ORC_STRUCT_OFFSET(OrcExecutorAlt, strides[k]));
          powerpc_emit_add (compiler,
              compiler->vars[k].ptr_register,
              compiler->vars[k].ptr_register,
	      POWERPC_R0);
          if (compiler->is_64bit) {
            powerpc_emit_std (compiler,
                compiler->vars[k].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]));
          } else {
            powerpc_emit_stw (compiler,
                compiler->vars[k].ptr_register,
                POWERPC_R3,
                (int)ORC_STRUCT_OFFSET(OrcExecutor, arrays[k]));
          }
        } else {
          ORC_ASM_CODE(compiler,"ERROR\n");
        }
      }
    }

    powerpc_emit_b (compiler, label_outer_loop_start);
  }

  powerpc_emit_label (compiler, label_leave);

  for(k=0;k<4;k++){
    OrcVariable *var = &compiler->vars[ORC_VAR_A1 + k];

    if (compiler->vars[ORC_VAR_A1 + k].name == NULL) continue;

    powerpc_emit_addi (compiler,
        POWERPC_R0,
        POWERPC_R3,
        (int)ORC_STRUCT_OFFSET(OrcExecutor, accumulators[k]));

    if (var->size == 2) {
      powerpc_emit_vxor (compiler, POWERPC_V0, POWERPC_V0, POWERPC_V0);
      powerpc_emit_vmrghh (compiler, var->alloc, POWERPC_V0, var->alloc);
    }

    ORC_ASM_CODE(compiler,"  lvsr %s, 0, %s\n", 
        powerpc_get_regname (POWERPC_V0),
        powerpc_get_regname (POWERPC_R0));
    powerpc_emit_X (compiler, 0x7c00004c, powerpc_regnum(POWERPC_V0),
        0, powerpc_regnum(POWERPC_R0));

    powerpc_emit_vperm (compiler, var->alloc, var->alloc, var->alloc,
        POWERPC_V0);

    ORC_ASM_CODE(compiler,"  stvewx %s, 0, %s\n", 
      powerpc_get_regname (var->alloc),
      powerpc_get_regname (POWERPC_R0));
    powerpc_emit_X (compiler, 0x7c00018e,
        powerpc_regnum(var->alloc),
        0, powerpc_regnum(POWERPC_R0));
  }

  if (set_vscr) {
    int tmp = POWERPC_V0;

    ORC_ASM_CODE(compiler,"  vspltisw %s, %d\n",
        powerpc_get_regname(tmp), 0);
    powerpc_emit_VX(compiler, 0x1000038c,
        powerpc_regnum(tmp), 0, 0);

    powerpc_emit_VX_b(compiler, "mtvscr", 0x10000644, tmp);
  }
  powerpc_emit_epilogue (compiler);

  powerpc_do_fixups (compiler);
}

