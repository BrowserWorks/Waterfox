
#include "config.h"

#include <stdio.h>
#include <stdlib.h>

#include <orc/orc.h>
#include <orc/orcprogram.h>
#include <orc/orcdebug.h>

/* static const char *c_get_type_name (int size); */

void orc_c_init (void);

static void emit_loop (OrcCompiler *compiler, int prefix);

void
orc_compiler_c64x_c_init (OrcCompiler *compiler)
{
  int i;

  for(i=ORC_GP_REG_BASE;i<ORC_GP_REG_BASE+16;i++){
    compiler->valid_regs[i] = 1;
  }
  compiler->loop_shift = 0;
}

const char *
orc_target_c64x_c_get_asm_preamble (void)
{
  return "\n"
    "/* begin Orc C target preamble */\n"
    "typedef signed char int8_t;\n"
    "typedef unsigned char uint8_t;\n"
    "typedef signed short int16_t;\n"
    "typedef unsigned short uint16_t;\n"
    "typedef signed int int32_t;\n"
    "typedef unsigned int uint32_t;\n"
    "typedef signed long long int64_t;\n"
    "typedef unsigned long long uint64_t;\n"
    "#define ORC_RESTRICT restrict\n"
    "typedef struct _OrcProgram OrcProgram;\n"
    "typedef struct _OrcExecutor OrcExecutor;\n"
    "#define ORC_N_VARIABLES 20\n"
    "#define ORC_N_REGISTERS 20\n"
    "#define ORC_OPCODE_N_ARGS 4\n"
    "struct _OrcExecutor {\n"
    "  OrcProgram *program;\n"
    "  int n;\n"
    "  int counter1;\n"
    "  int counter2;\n"
    "  int counter3;\n"
    "  void *arrays[ORC_N_VARIABLES];\n"
    "  int params[ORC_N_VARIABLES];\n"
    "  /* OrcVariable vars[ORC_N_VARIABLES]; */\n"
    "  /* OrcVariable *args[ORC_OPCODE_N_ARGS]; */\n"
    "};\n"
    "#define ORC_CLAMP(x,a,b) ((x)<(a) ? (a) : ((x)>(b) ? (b) : (x)))\n"
    "#define ORC_ABS(a) ((a)<0 ? -(a) : (a))\n"
    "#define ORC_MIN(a,b) ((a)<(b) ? (a) : (b))\n"
    "#define ORC_MAX(a,b) ((a)>(b) ? (a) : (b))\n"
    "#define ORC_SB_MAX 127\n"
    "#define ORC_SB_MIN (-1-ORC_SB_MAX)\n"
    "#define ORC_UB_MAX 255\n"
    "#define ORC_UB_MIN 0\n"
    "#define ORC_SW_MAX 32767\n"
    "#define ORC_SW_MIN (-1-ORC_SW_MAX)\n"
    "#define ORC_UW_MAX 65535\n"
    "#define ORC_UW_MIN 0\n"
    "#define ORC_SL_MAX 2147483647\n"
    "#define ORC_SL_MIN (-1-ORC_SL_MAX)\n"
    "#define ORC_UL_MAX 4294967295U\n"
    "#define ORC_UL_MIN 0\n"
    "#define ORC_CLAMP_SB(x) ORC_CLAMP(x,ORC_SB_MIN,ORC_SB_MAX)\n"
    "#define ORC_CLAMP_UB(x) ORC_CLAMP(x,ORC_UB_MIN,ORC_UB_MAX)\n"
    "#define ORC_CLAMP_SW(x) ORC_CLAMP(x,ORC_SW_MIN,ORC_SW_MAX)\n"
    "#define ORC_CLAMP_UW(x) ORC_CLAMP(x,ORC_UW_MIN,ORC_UW_MAX)\n"
    "#define ORC_CLAMP_SL(x) ORC_CLAMP(x,ORC_SL_MIN,ORC_SL_MAX)\n"
    "#define ORC_CLAMP_UL(x) ORC_CLAMP(x,ORC_UL_MIN,ORC_UL_MAX)\n"
    "#define ORC_SWAP_W(x) ((((x)&0xff)<<8) | (((x)&0xff00)>>8))\n"
    "#define ORC_SWAP_L(x) ((((x)&0xff)<<24) | (((x)&0xff00)<<8) | (((x)&0xff0000)>>8) | (((x)&0xff000000)>>24))\n"
    "#define ORC_PTR_OFFSET(ptr,offset) ((void *)(((unsigned char *)(ptr)) + (offset)))\n"
    "/* end Orc C target preamble */\n\n";
}

unsigned int
orc_compiler_c64x_c_get_default_flags (void)
{
  return ORC_TARGET_C_NOEXEC;
}

static const char *varnames[] = {
  "d1", "d2", "d3", "d4",
  "s1", "s2", "s3", "s4",
  "s5", "s6", "s7", "s8",
  "a1", "a2", "a3", "d4",
  "c1", "c2", "c3", "c4",
  "c5", "c6", "c7", "c8",
  "p1", "p2", "p3", "p4",
  "p5", "p6", "p7", "p8",
  "t1", "t2", "t3", "t4",
  "t5", "t6", "t7", "t8",
  "t9", "t10", "t11", "t12",
  "t13", "t14", "t15", "t16"
};

static void
output_prototype (OrcCompiler *compiler)
{
  OrcProgram *p = compiler->program;
  OrcVariable *var;
  int i;
  int need_comma;

  ORC_ASM_CODE(compiler, "%s (", p->name);
  need_comma = FALSE;
  for(i=0;i<4;i++){
    var = &p->vars[ORC_VAR_D1 + i];
    if (var->size) {
      if (need_comma) ORC_ASM_CODE(compiler, ", ");
      if (var->type_name) {
        ORC_ASM_CODE(compiler, "%s * %s", var->type_name,
            varnames[ORC_VAR_D1 + i]);
      } else {
        ORC_ASM_CODE(compiler, "uint%d_t * %s", var->size*8,
            varnames[ORC_VAR_D1 + i]);
      }
      if (p->is_2d) {
        ORC_ASM_CODE(compiler, ", int %s_stride", varnames[ORC_VAR_D1 + i]);
      }
      need_comma = TRUE;
    }
  }
  for(i=0;i<4;i++){
    var = &p->vars[ORC_VAR_A1 + i];
    if (var->size) {
      if (need_comma) ORC_ASM_CODE(compiler, ", ");
      if (var->type_name) {
        ORC_ASM_CODE(compiler, "%s * %s", var->type_name,
            varnames[ORC_VAR_A1 + i]);
      } else {
        ORC_ASM_CODE(compiler, "uint%d_t * %s", var->size*8,
            varnames[ORC_VAR_A1 + i]);
      }
      need_comma = TRUE;
    }
  }
  for(i=0;i<8;i++){
    var = &p->vars[ORC_VAR_S1 + i];
    if (var->size) {
      if (need_comma) ORC_ASM_CODE(compiler, ", ");
      if (var->type_name) {
        ORC_ASM_CODE(compiler, "%s * %s", var->type_name,
            varnames[ORC_VAR_S1 + i]);
      } else {
        ORC_ASM_CODE(compiler, "uint%d_t * %s", var->size*8,
            varnames[ORC_VAR_S1 + i]);
      }
      if (p->is_2d) {
        ORC_ASM_CODE(compiler, ", int %s_stride", varnames[ORC_VAR_S1 + i]);
      }
      need_comma = TRUE;
    }
  }
  for(i=0;i<8;i++){
    var = &p->vars[ORC_VAR_P1 + i];
    if (var->size) {
      if (need_comma) ORC_ASM_CODE(compiler, ", ");
      ORC_ASM_CODE(compiler, "int %s", varnames[ORC_VAR_P1 + i]);
      need_comma = TRUE;
    }
  }
  if (p->constant_n == 0) {
    if (need_comma) ORC_ASM_CODE(compiler, ", ");
    ORC_ASM_CODE(compiler, "int n");
    need_comma = TRUE;
  }
  if (p->is_2d && p->constant_m == 0) {
    if (need_comma) ORC_ASM_CODE(compiler, ", ");
    ORC_ASM_CODE(compiler, "int m");
  }
  ORC_ASM_CODE(compiler, ")");
}

static int
get_align_var (OrcCompiler *compiler)
{
  if (compiler->vars[ORC_VAR_D1].size) return ORC_VAR_D1;
  if (compiler->vars[ORC_VAR_S1].size) return ORC_VAR_S1;

  ORC_COMPILER_ERROR(compiler, "could not find alignment variable");

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
    case 8:
      return 3;
    default:
      ORC_ERROR("bad size %d", size);
  }
  return -1;
}

void
orc_compiler_c64x_c_assemble (OrcCompiler *compiler)
{
  int i;
  int prefix = 0;
  int loop_shift = 0;
  int align_var;

  align_var = get_align_var (compiler);

  switch (compiler->max_var_size) {
    case 1:
      loop_shift = 2;
      break;
    case 2:
      loop_shift = 1;
      break;
    case 4:
      loop_shift = 0;
      break;
    default:
      ORC_ERROR("unhandled max var size %d", compiler->max_var_size);
      break;
  }

  compiler->target_flags |= ORC_TARGET_C_NOEXEC;

  if (!(compiler->target_flags & ORC_TARGET_C_BARE)) {
    if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
      ORC_ASM_CODE(compiler,"void\n");
      ORC_ASM_CODE(compiler,"%s (OrcExecutor *ex)\n", compiler->program->name);
    } else{
      ORC_ASM_CODE(compiler,"void\n");
      output_prototype (compiler);
      ORC_ASM_CODE(compiler,"\n");
    }
    ORC_ASM_CODE(compiler,"{\n");
  }

  ORC_ASM_CODE(compiler,"%*s  int i;\n", prefix, "");
  if (compiler->program->is_2d) {
    ORC_ASM_CODE(compiler,"  int j;\n");
  }

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcVariable *var = compiler->vars + i;
    if (var->name == NULL) continue;
    switch (var->vartype) {
      case ORC_VAR_TYPE_CONST:
        {
          int value = var->value.i;

          if (var->size == 1) {
            value = (value&0xff);
            value |= (value<<8);
            value |= (value<<16);
          }
          if (var->size == 2) {
            value = (value&0xffff);
            value |= (value<<16);
          }

          if (value == 0x80000000) {
            ORC_ASM_CODE(compiler,"  const int var%d = 0x80000000;\n", i);
          } else {
            ORC_ASM_CODE(compiler,"  const int var%d = %d;\n",
                i, value);
          }
        }
        break;
      case ORC_VAR_TYPE_TEMP:
        ORC_ASM_CODE(compiler,"  int var%d;\n", i);
        break;
      case ORC_VAR_TYPE_SRC:
        ORC_ASM_CODE(compiler,"  const unsigned char * restrict ptr%d;\n", i);
        break;
      case ORC_VAR_TYPE_DEST:
        ORC_ASM_CODE(compiler,"  unsigned char * restrict ptr%d;\n", i);
        break;
      case ORC_VAR_TYPE_ACCUMULATOR:
        ORC_ASM_CODE(compiler,"  int var%d = 0;\n", i);
        break;
      case ORC_VAR_TYPE_PARAM:
        if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
          ORC_ASM_CODE(compiler,"  const int var%d = ex->params[%d];\n", i, i);
        } else {
          ORC_ASM_CODE(compiler,"  const int var%d = %s;\n", i, varnames[i]);
        }
        break;
      default:
        ORC_COMPILER_ERROR(compiler, "bad vartype");
        break;
    }
  }

  if (compiler->program->constant_n == 0) {
    if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
      ORC_ASM_CODE(compiler,"%*s  int n;\n", prefix, "");
    }
  }
  if (loop_shift > 0) {
    ORC_ASM_CODE(compiler,"%*s  int n1, n2, n3;\n", prefix, "");
  }

  ORC_ASM_CODE(compiler,"\n");
  if (compiler->program->is_2d) {
    if (compiler->program->constant_m == 0) {
      if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
        ORC_ASM_CODE(compiler,"  for (j = 0; j < ex->params[ORC_VAR_A1]; j++) {\n");
      } else {
        ORC_ASM_CODE(compiler,"  for (j = 0; j < m; j++) {\n");
      }
    } else {
      ORC_ASM_CODE(compiler,"  for (j = 0; j < %d; j++) {\n",
          compiler->program->constant_m);
    }
    prefix = 2;

    for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
      OrcVariable *var = compiler->vars + i;
      if (var->name == NULL) continue;
      switch (var->vartype) {
        case ORC_VAR_TYPE_SRC:
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"    ptr%d = ORC_PTR_OFFSET(ex->arrays[%d], ex->params[%d] * j);\n",
                i, i, i);
          } else {
            ORC_ASM_CODE(compiler,"    ptr%d = ORC_PTR_OFFSET(%s, %s_stride * j);\n",
                i, varnames[i], varnames[i]);
          }
          break;
        case ORC_VAR_TYPE_DEST:
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"    ptr%d = ORC_PTR_OFFSET(ex->arrays[%d], ex->params[%d] * j);\n",
                i, i, i);
          } else {
            ORC_ASM_CODE(compiler,"    ptr%d = ORC_PTR_OFFSET(%s, %s_stride * j);\n",
                i, varnames[i], varnames[i]);
          }
          break;
        default:
          break;
      }
    }
  } else {
    for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
      OrcVariable *var = compiler->vars + i;
      if (var->name == NULL) continue;
      switch (var->vartype) {
        case ORC_VAR_TYPE_SRC:
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"  ptr%d = ex->arrays[%d];\n", i, i);
          } else {
            ORC_ASM_CODE(compiler,"  ptr%d = (void *)%s;\n", i, varnames[i]);
          }
          break;
        case ORC_VAR_TYPE_DEST:
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"  ptr%d = ex->arrays[%d];\n", i, i);
          } else {
            ORC_ASM_CODE(compiler,"  ptr%d = (void *)%s;\n", i, varnames[i]);
          }
          break;
        default:
          break;
      }
    }
  }

  if (compiler->program->constant_n == 0) {
    if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
      ORC_ASM_CODE(compiler,"%*s  n = ex->n;\n", prefix, "");
    }
  }
  if (loop_shift > 0) {
    ORC_ASM_CODE(compiler,"%*s  n1 = ((4 - (int)ptr%d)&0x3) >> %d;\n",
        prefix, "", align_var, get_shift(compiler->vars[align_var].size));
    ORC_ASM_CODE(compiler,"%*s  n2 = (n - n1) >> %d;\n",
        prefix, "", loop_shift);
    ORC_ASM_CODE(compiler,"%*s  n3 = n & ((1 << %d) - 1);\n",
        prefix, "", loop_shift);

    ORC_ASM_CODE(compiler,"\n");

    ORC_ASM_CODE(compiler,"#pragma MUST_ITERATE(0,%d)\n", (1<<loop_shift)-1);
    ORC_ASM_CODE(compiler,"%*s  for (i = 0; i < n1; i++) {\n", prefix, "");
    compiler->loop_shift = 0;
    emit_loop (compiler, prefix);
    ORC_ASM_CODE(compiler,"%*s  }\n", prefix, "");

    ORC_ASM_CODE(compiler,"%*s  for (i = 0; i < n2; i++) {\n", prefix, "");
    compiler->vars[align_var].is_aligned = TRUE;
    compiler->loop_shift = loop_shift;
    emit_loop (compiler, prefix);
    compiler->vars[align_var].is_aligned = FALSE;
    ORC_ASM_CODE(compiler,"%*s  }\n", prefix, "");

    ORC_ASM_CODE(compiler,"#pragma MUST_ITERATE(0,%d)\n", (1<<loop_shift)-1);
    ORC_ASM_CODE(compiler,"%*s  for (i = 0; i < n3; i++) {\n", prefix, "");
    compiler->loop_shift = 0;
    emit_loop (compiler, prefix);
    ORC_ASM_CODE(compiler,"%*s  }\n", prefix, "");
  } else {
    ORC_ASM_CODE(compiler,"%*s  for (i = 0; i < n; i++) {\n", prefix, "");
    compiler->loop_shift = loop_shift;
    emit_loop (compiler, prefix);
    ORC_ASM_CODE(compiler,"%*s  }\n", prefix, "");
  }

  if (compiler->program->is_2d) {
    ORC_ASM_CODE(compiler,"  }\n");
  }

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcVariable *var = compiler->vars + i;
    if (var->name == NULL) continue;
    switch (var->vartype) {
      case ORC_VAR_TYPE_ACCUMULATOR:
        if (var->size == 2) {
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"  ex->accumulators[%d] = (var%d & 0xffff);\n",
                i - ORC_VAR_A1, i);
          } else {
            ORC_ASM_CODE(compiler,"  *%s = (var%d & 0xffff);\n",
                varnames[i], i);
          }
        } else {
          if (!(compiler->target_flags & ORC_TARGET_C_NOEXEC)) {
            ORC_ASM_CODE(compiler,"  ex->accumulators[%d] = var%d;\n",
                i - ORC_VAR_A1, i);
          } else {
            ORC_ASM_CODE(compiler,"  *%s = var%d;\n",
                varnames[i], i);
          }
        }
        break;
      default:
        break;
    }
  }

  if (!(compiler->target_flags & ORC_TARGET_C_BARE)) {
    ORC_ASM_CODE(compiler,"}\n");
    ORC_ASM_CODE(compiler,"\n");
  }
}

static void
emit_loop (OrcCompiler *compiler, int prefix)
{
  int j;
  int i;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  OrcRule *rule;

  for(j=0;j<compiler->n_insns;j++){
    insn = compiler->insns + j;
    opcode = insn->opcode;

    ORC_ASM_CODE(compiler,"%*s    /* %d: %s */\n", prefix, "",
        j, insn->opcode->name);

    rule = insn->rule;
    if (rule) {
      ORC_ASM_CODE(compiler,"%*s", prefix, "");
      rule->emit (compiler, rule->emit_user, insn);
    } else {
      ORC_COMPILER_ERROR(compiler, "No rule for: %s on target %s",
          opcode->name, compiler->target->name);
      compiler->error = TRUE;
    }
  }
  ORC_ASM_CODE(compiler,"\n");
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcVariable *var = compiler->vars + i;
    if (var->name == NULL) continue;
    switch (var->vartype) {
      case ORC_VAR_TYPE_SRC:
      case ORC_VAR_TYPE_DEST:
        ORC_ASM_CODE(compiler,"%*s    ptr%d += %d;\n", prefix, "",
            i, var->size << compiler->loop_shift);
        break;
      default:
        break;
    }
  }
}

/* rules */

static void
c_get_name (char *name, OrcCompiler *p, int var)
{
  int size;

  size = p->vars[var].size << p->loop_shift;

  switch (p->vars[var].vartype) {
    case ORC_VAR_TYPE_CONST:
    case ORC_VAR_TYPE_PARAM:
    case ORC_VAR_TYPE_TEMP:
    case ORC_VAR_TYPE_ACCUMULATOR:
      sprintf(name, "var%d", var);
      break;
    case ORC_VAR_TYPE_SRC:
    case ORC_VAR_TYPE_DEST:
      if (size == 1) {
        sprintf(name, "(*(%sint8_t *)var%d)",
            (p->vars[var].vartype == ORC_VAR_TYPE_SRC) ? "const " : "", var);
      } else {
        sprintf(name, "_%smem%d%s(var%d)",
            (p->vars[var].is_aligned) ? "a" : "", size,
            (p->vars[var].vartype == ORC_VAR_TYPE_SRC) ? "_const" : "", var);
      }
      break;
    default:
      ORC_COMPILER_ERROR(p, "bad vartype");
      sprintf(name, "ERROR");
      break;
  }
}

static void
c_get_name_float (char *name, OrcCompiler *p, int var)
{
  switch (p->vars[var].vartype) {
    case ORC_VAR_TYPE_CONST:
    case ORC_VAR_TYPE_PARAM:
    case ORC_VAR_TYPE_TEMP:
    case ORC_VAR_TYPE_ACCUMULATOR:
      sprintf(name, "(*(float *)(&var%d))", var);
      break;
    case ORC_VAR_TYPE_SRC:
    case ORC_VAR_TYPE_DEST:
      sprintf(name, "((float *)var%d)[i]", var);
      break;
    default:
      ORC_COMPILER_ERROR(p, "bad vartype");
      sprintf(name, "ERROR");
      break;
  }
}

#if 0
static const char *
c_get_type_name (int size)
{
  switch (size) {
    case 1:
      return "int8_t";
    case 2:
      return "int16_t";
    case 4:
      return "int32_t";
    case 8:
      return "int64_t";
    default:
      return "ERROR";
  }
}
#endif


#define UNARY(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40]; \
\
  c_get_name (dest, p, insn->dest_args[0]); \
  c_get_name (src1, p, insn->src_args[0]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1); \
}

#define BINARY(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40], src2[40]; \
\
  c_get_name (dest, p, insn->dest_args[0]); \
  c_get_name (src1, p, insn->src_args[0]); \
  c_get_name (src2, p, insn->src_args[1]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1, src2); \
}

#define UNARYF(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40]; \
\
  c_get_name_float (dest, p, insn->dest_args[0]); \
  c_get_name_float (src1, p, insn->src_args[0]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1); \
}

#define BINARYF(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40], src2[40]; \
\
  c_get_name_float (dest, p, insn->dest_args[0]); \
  c_get_name_float (src1, p, insn->src_args[0]); \
  c_get_name_float (src2, p, insn->src_args[1]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1, src2); \
}

#define BINARYFL(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40], src2[40]; \
\
  c_get_name (dest, p, insn->dest_args[0]); \
  c_get_name_float (src1, p, insn->src_args[0]); \
  c_get_name_float (src2, p, insn->src_args[1]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1, src2); \
}

#define UNARYFL(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40]; \
\
  c_get_name (dest, p, insn->dest_args[0]); \
  c_get_name_float (src1, p, insn->src_args[0]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1); \
}

#define UNARYLF(name,op) \
static void \
c_rule_ ## name (OrcCompiler *p, void *user, OrcInstruction *insn) \
{ \
  char dest[40], src1[40]; \
\
  c_get_name_float (dest, p, insn->dest_args[0]); \
  c_get_name (src1, p, insn->src_args[0]); \
 \
  ORC_ASM_CODE(p,"    %s = " op ";\n", dest, src1); \
}

#define BINARY_SB(a,b) BINARY(a,b)
#define BINARY_UB(a,b) BINARY(a,b)
#define BINARY_SW(a,b) BINARY(a,b)
#define BINARY_UW(a,b) BINARY(a,b)
#define BINARY_SL(a,b) BINARY(a,b)
#define BINARY_UL(a,b) BINARY(a,b)
#define UNARY_SB(a,b) UNARY(a,b)
#define UNARY_UB(a,b) UNARY(a,b)
#define UNARY_SW(a,b) UNARY(a,b)
#define UNARY_UW(a,b) UNARY(a,b)
#define UNARY_SL(a,b) UNARY(a,b)
#define UNARY_UL(a,b) UNARY(a,b)
#define BINARY_BW(a,b) BINARY(a,b)
#define BINARY_WL(a,b) BINARY(a,b)
#define BINARY_LW(a,b) BINARY(a,b)
#define BINARY_WB(a,b) BINARY(a,b)
#define UNARY_BW(a,b) UNARY(a,b)
#define UNARY_WL(a,b) UNARY(a,b)
#define UNARY_LW(a,b) UNARY(a,b)
#define UNARY_WB(a,b) UNARY(a,b)

#define BINARY_F(a,b) BINARYF(a,b)
#define BINARY_FL(a,b) BINARYFL(a,b)
#define UNARY_F(a,b) UNARYF(a,b)
#define UNARY_FL(a,b) UNARYFL(a,b)
#define UNARY_LF(a,b) UNARYLF(a,b)

BINARY_SB(addb, "_add4(%s,%s)")
BINARY_SB(addssb, "0x80808080^_saddu4(0x80808080^%s,0x80808080^%s)")
BINARY_SB(addusb, "_saddu4(%s,%s)")
BINARY_SB(andb, "%s & %s")
BINARY_SB(andnb, "(~%s) & %s")
BINARY_SB(avgsb, "0x7f7f7f7f^_avgu4(0x7f7f7f7f^%s,0x7f7f7f7f^%s)")
BINARY_UB(avgub, "_avgu4(%s,%s)")
BINARY_SB(cmpeqb, "_cmpeq4(%s,%s)")
BINARY_SB(cmpgtsb, "_cmpgtu4(0x80808080^%s,0x80808080^%s)")
UNARY_SB(copyb, "%s")
BINARY_SB(maxsb, "0x80808080^_maxu4(0x80808080^%s,0x80808080^%s)")
BINARY_UB(maxub, "_maxu4(%s,%s)")
BINARY_SB(minsb, "0x80808080^_minu4(0x80808080^%s,0x80808080^%s)")
BINARY_UB(minub, "_minu4(%s,%s)")
BINARY_SB(orb, "%s | %s")
UNARY_SB(signb, "0x80808080^_maxu4(0x7f7f7f7f,_minu4(0x81818181,0x80808080^%s))")
BINARY_SB(subb, "_sub4(%s,%s)")
BINARY_SB(xorb, "%s ^ %s")

UNARY_SW(absw, "_abs2(%s)")
BINARY_SW(addw, "_add2(%s,%s)")
BINARY_SW(addssw, "_sadd2(%s,%s)")
BINARY_SW(addusw, "0x80008000^_sadd2(0x80008000^%s,0x80008000^%s)")
BINARY_SW(andw, "%s & %s")
BINARY_SW(andnw, "(~%s) & %s")
BINARY_SW(avgsw, "_avg2(%s,%s)")
BINARY_UW(avguw, "0x7fff7fff^_avg2(0x7fff7fff^%s,0x7fff7fff^%s)")
BINARY_SW(cmpeqw, "_cmpeq2(%s,%s)")
BINARY_SW(cmpgtsw, "_cmpgt2(%s,%s)")
UNARY_SW(copyw, "%s")
BINARY_SW(maxsw, "_max2(%s,%s)")
BINARY_SW(maxuw, "_max2(0x80008000^%s,0x80008000^%s)")
BINARY_SW(minsw, "_min2(%s,%s)")
BINARY_SW(minuw, "_min2(0x80008000^%s,0x80008000^%s)")
BINARY_SW(orw, "%s | %s")
BINARY_SW(shrsw, "_shr2(%s,%s)")
BINARY_UW(shruw, "_shru2(%s,%s)")
UNARY_SW(signw, "_max2(-1,_min2(1,%s))")
BINARY_SW(subw, "_sub2(%s,%s)")
BINARY_SW(subssw, "_ssub2(%s,%s)")
BINARY_SW(subusw, "0x80008000^_ssub2(0x80008000^%s,0x80008000^%s)")
BINARY_SW(xorw, "%s ^ %s")

UNARY_SL(absl, "_abs(%s)")
BINARY_SL(addl, "%s + %s")
BINARY_SL(addssl, "_sadd(%s,%s)")
BINARY_UL(addusl, "ORC_CLAMP_UL((int64_t)(uint32_t)%s + (int64_t)(uint32_t)%s)")
BINARY_SL(andl, "%s & %s")
BINARY_SL(andnl, "(~%s) & %s")
BINARY_SL(avgsl, "((int64_t)%s + (int64_t)%s + 1)>>1")
BINARY_UL(avgul, "((uint64_t)(uint32_t)%s + (uint64_t)(uint32_t)%s + 1)>>1")
BINARY_SL(cmpeql, "(%s == %s) ? (~0) : 0")
BINARY_SL(cmpgtsl, "(%s > %s) ? (~0) : 0")
UNARY_SL(copyl, "%s")
BINARY_SL(maxsl, "ORC_MAX(%s, %s)")
BINARY_UL(maxul, "ORC_MAX((uint32_t)%s, (uint32_t)%s)")
BINARY_SL(minsl, "ORC_MIN(%s, %s)")
BINARY_UL(minul, "ORC_MIN((uint32_t)%s, (uint32_t)%s)")
BINARY_SL(mulll, "_loll(_mpy32ll(%s,%s))")
BINARY_SL(mulhsl, "_hill(_mpy32ll(%s,%s))")
BINARY_UL(mulhul, "_hill(_mpy32u(%s,%s))")
BINARY_SL(orl, "%s | %s")
BINARY_SL(shll, "%s << %s")
BINARY_SL(shrsl, "%s >> %s")
BINARY_UL(shrul, "((uint32_t)%s) >> %s")
UNARY_SL(signl, "ORC_CLAMP((int)%s,-1,1)")
BINARY_SL(subl, "%s - %s")
BINARY_SL(subssl, "_ssub(%s,%s)")
BINARY_UL(subusl, "ORC_CLAMP_UL((int64_t)(uint32_t)%s - (int64_t)(uint32_t)%s)")
BINARY_SL(xorl, "%s ^ %s")

UNARY_BW(convsbw, "%s")
UNARY_BW(convubw, "_unpklu4(%s)")
UNARY_WL(convswl, "(int16_t)%s")
UNARY_WL(convuwl, "(uint16_t)%s")
UNARY_WB(convwb, "_packl4(0,%s)")
UNARY_WB(convsuswb, "_spacku4(0,%s)")
UNARY_LW(convlw, "_pack2(0,%s)")
UNARY_LW(convssslw, "_spack2(0,%s)")

BINARY_BW(mulsbw, "%s * %s")
BINARY_BW(mulubw, "(uint8_t)%s * (uint8_t)%s")
BINARY_WL(mulswl, "%s * %s")
BINARY_WL(muluwl, "(uint16_t)%s * (uint16_t)%s")

BINARY_WL(mergewl, "_pack2(%s, %s)")
BINARY_BW(mergebw, "_packl4(%s, %s)")
UNARY_WB(select0wb, "_packl4(0,%s)")
UNARY_WB(select1wb, "_packh4(0,%s)")
UNARY_LW(select0lw, "_pack2(0,%s)")
UNARY_LW(select1lw, "_packh2(0,%s)")
UNARY_UW(swapw, "_swap4(%s)")

#if 0
BINARY_F(addf, "%s + %s")
BINARY_F(subf, "%s - %s")
BINARY_F(mulf, "%s * %s")
BINARY_F(divf, "%s / %s")
UNARY_F(sqrtf, "sqrt(%s)")
BINARY_F(maxf, "ORC_MAX(%s,%s)")
BINARY_F(minf, "ORC_MIN(%s,%s)")
BINARY_FL(cmpeqf, "(%s == %s) ? (~0) : 0")
BINARY_FL(cmpltf, "(%s < %s) ? (~0) : 0")
BINARY_FL(cmplef, "(%s <= %s) ? (~0) : 0")
UNARY_FL(convfl, "rintf(%s)")
UNARY_LF(convlf, "%s")
#else
BINARY_F(addf, "0 /* float disabled %s %s */")
BINARY_F(subf, "0 /* float disabled %s %s */")
BINARY_F(mulf, "0 /* float disabled %s %s */")
BINARY_F(divf, "0 /* float disabled %s %s */")
UNARY_F(sqrtf, "0 /* float disabled %s */")
BINARY_F(maxf, "0 /* float disabled %s %s */")
BINARY_F(minf, "0 /* float disabled %s %s */")
BINARY_FL(cmpeqf, "0 /* float disabled %s %s */")
BINARY_FL(cmpltf, "0 /* float disabled %s %s */")
BINARY_FL(cmplef, "0 /* float disabled %s %s */")
UNARY_FL(convfl, "0 /* float disabled %s */")
UNARY_LF(convlf, "0 /* float disabled %s */")
#endif


static void
c_rule_absb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);

  ORC_ASM_CODE(p,"    %s = _subabs4(0x80808080,0x80808080^%s);\n", dest, src1);
}

static void
c_rule_mullw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,"    {\n");
  ORC_ASM_CODE(p,"      long long x = _mpy2ll(%s,%s);\n", src1, src2);
  ORC_ASM_CODE(p,"      %s = _pack2(_hill(x),_loll(x));\n", dest);
  ORC_ASM_CODE(p,"    }\n");
}

static void
c_rule_mulhsw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,"    {\n");
  ORC_ASM_CODE(p,"      long long x = _mpy2ll(%s,%s);\n", src1, src2);
  ORC_ASM_CODE(p,"      %s = _packh2(_hill(x),_loll(x));\n", dest);
  ORC_ASM_CODE(p,"    }\n");
}

static void
c_rule_mulhuw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,"    {\n");
  ORC_ASM_CODE(p,"      long long x = _mpy2ll(%s,%s);\n", src1, src2);
  ORC_ASM_CODE(p,"      %s = _packh2(_hill(x),_loll(x));\n", dest);
  ORC_ASM_CODE(p,"    }\n");
}

static void
c_rule_shlw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,"    %s = (%s<<%s) & (~(((1<<%s)-1)<<16 | ((1<<%s)-1)));\n",
      dest, src1, src2, src2, src2);
}

static void
c_rule_convssswb (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);

  ORC_ASM_CODE(p,"    %s = _packl4(0,_max2(0xff80ff80,_min2(0x007f007f,%s)));\n",
      dest, src1);
}

static void
c_rule_swapl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,"    %s = _packlh2(_swap4(%s),_swap4(%s));\n",
      dest, src1, src2);
}

static void
c_rule_accw (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);

  ORC_ASM_CODE(p,"    %s = %s + %s;\n", dest, dest, src1);
}

static void
c_rule_accl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);

  ORC_ASM_CODE(p,"    %s = %s + %s;\n", dest, dest, src1);
}

static void
c_rule_accsadubl (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  char dest[40], src1[40], src2[40];

  c_get_name (dest, p, insn->dest_args[0]);
  c_get_name (src1, p, insn->src_args[0]);
  c_get_name (src2, p, insn->src_args[1]);

  ORC_ASM_CODE(p,
      "    %s = %s + ORC_ABS((int32_t)(uint8_t)%s - (int32_t)(uint8_t)%s);\n",
      dest, dest, src1, src2);
}

static void
c_rule_loadX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  ORC_ASM_CODE(p,"    var%d = ptr%d[i];\n", insn->dest_args[0],
      insn->src_args[0]);
}

static void
c_rule_storeX (OrcCompiler *p, void *user, OrcInstruction *insn)
{
  ORC_ASM_CODE(p,"    ptr%d[i] = var%d;\n", insn->dest_args[0],
      insn->src_args[0]);
}


static OrcTarget c64x_c_target = {
  "c64x-c",
  FALSE,
  ORC_GP_REG_BASE,
  orc_compiler_c64x_c_get_default_flags,
  orc_compiler_c64x_c_init,
  orc_compiler_c64x_c_assemble,
  { { 0 } },
  0,
  orc_target_c64x_c_get_asm_preamble,
};


void
orc_c64x_c_init (void)
{
  OrcRuleSet *rule_set;

  orc_target_register (&c64x_c_target);

  rule_set = orc_rule_set_new (orc_opcode_set_get("sys"), &c64x_c_target, 0);

#define REG(a) orc_rule_register (rule_set, #a , c_rule_ ## a, NULL);

  orc_rule_register (rule_set, "loadb", c_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadw", c_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadl", c_rule_loadX, NULL);
  orc_rule_register (rule_set, "loadq", c_rule_loadX, NULL);

  orc_rule_register (rule_set, "storeb", c_rule_storeX, NULL);
  orc_rule_register (rule_set, "storew", c_rule_storeX, NULL);
  orc_rule_register (rule_set, "storel", c_rule_storeX, NULL);
  orc_rule_register (rule_set, "storeq", c_rule_storeX, NULL);

  REG(absb);
  REG(addb);
  REG(addssb);
  REG(addusb);
  REG(andb);
  REG(andnb);
  REG(avgsb);
  REG(avgub);
  REG(cmpeqb);
  REG(cmpgtsb);
  REG(copyb);
  REG(maxsb);
  REG(maxub);
  REG(minsb);
  REG(minub);
  REG(orb);
  REG(signb);
  REG(subb);
  REG(xorb);

  REG(absw);
  REG(addw);
  REG(addssw);
  REG(addusw);
  REG(andw);
  REG(andnw);
  REG(avgsw);
  REG(avguw);
  REG(cmpeqw);
  REG(cmpgtsw);
  REG(copyw);
  REG(maxsw);
  REG(maxuw);
  REG(minsw);
  REG(minuw);
  REG(mullw);
  REG(mulhsw);
  REG(mulhuw);
  REG(orw);
  REG(shlw);
  REG(shrsw);
  REG(shruw);
  REG(signw);
  REG(subssw);
  REG(subusw);
  REG(subw);
  REG(xorw);

  REG(absl);
  REG(addl);
  REG(addssl);
  REG(addusl);
  REG(andl);
  REG(andnl);
  REG(avgsl);
  REG(avgul);
  REG(cmpeql);
  REG(cmpgtsl);
  REG(copyl);
  REG(maxsl);
  REG(maxul);
  REG(minsl);
  REG(minul);
  REG(mulll);
  REG(mulhsl);
  REG(mulhul);
  REG(orl);
  REG(shll);
  REG(shrsl);
  REG(shrul);
  REG(signl);
  REG(subl);
  REG(subssl);
  REG(subusl);
  REG(xorl);

  REG(convsbw);
  REG(convubw);
  REG(convswl);
  REG(convuwl);
  REG(convwb);
  REG(convssswb);
  REG(convsuswb);
  REG(convlw);
  REG(convssslw);

  REG(mulsbw);
  REG(mulubw);
  REG(mulswl);
  REG(muluwl);

  REG(mergewl);
  REG(mergebw);
  REG(select0wb);
  REG(select1wb);
  REG(select0lw);
  REG(select1lw);
  REG(swapw);
  REG(swapl);

  REG(addf);
  REG(subf);
  REG(mulf);
  REG(divf);
  REG(sqrtf);
  REG(maxf);
  REG(minf);
  REG(cmpeqf);
  REG(cmpltf);
  REG(cmplef);
  REG(convfl);
  REG(convlf);

  REG(accw);
  REG(accl);
  REG(accsadubl);

}

