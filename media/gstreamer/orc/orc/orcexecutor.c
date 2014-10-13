
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>

/**
 * SECTION:orcexecutor
 * @title: OrcExecutor
 * @short_description: Running Orc programs
 */

#define CHUNK_SIZE 16

OrcExecutor *
orc_executor_new (OrcProgram *program)
{
  OrcExecutor *ex;

  ex = malloc(sizeof(OrcExecutor));
  memset(ex,0,sizeof(OrcExecutor));

  ex->program = program;
  ex->arrays[ORC_VAR_A2] = program->orccode;

  return ex;
}

void
orc_executor_free (OrcExecutor *ex)
{
  free (ex);
}

void
orc_executor_run (OrcExecutor *ex)
{
  void (*func) (OrcExecutor *);

  if (ex->program) {
    func = ex->program->code_exec;
  } else {
    OrcCode *code = (OrcCode *)ex->arrays[ORC_VAR_A2];
    func = code->exec;
  }
  if (func) {
    func (ex);
    /* ORC_ERROR("counters %d %d %d", ex->counter1, ex->counter2, ex->counter3); */
  } else {
    orc_executor_emulate (ex);
  }
}

void
orc_executor_run_backup (OrcExecutor *ex)
{
  void (*func) (OrcExecutor *);

  if (ex->program) {
    func = ex->program->backup_func;
  } else {
    OrcCode *code = (OrcCode *)ex->arrays[ORC_VAR_A2];
    func = code->exec;
  }
  if (func) {
    func (ex);
    /* ORC_ERROR("counters %d %d %d", ex->counter1, ex->counter2, ex->counter3); */
  } else {
    orc_executor_emulate (ex);
  }
}

void
orc_executor_set_program (OrcExecutor *ex, OrcProgram *program)
{
  ex->program = program;
  if (program->code_exec) {
    ex->arrays[ORC_VAR_A1] = (void *)program->code_exec;
  } else {
    ex->arrays[ORC_VAR_A1] = (void *)orc_executor_emulate;
  }
}

void
orc_executor_set_array (OrcExecutor *ex, int var, void *ptr)
{
  ex->arrays[var] = ptr;
}

void
orc_executor_set_stride (OrcExecutor *ex, int var, int stride)
{
  ex->params[var] = stride;
}

void
orc_executor_set_array_str (OrcExecutor *ex, const char *name, void *ptr)
{
  int var;
  var = orc_program_find_var_by_name (ex->program, name);
  if (var >= 0)
    ex->arrays[var] = ptr;
}

void
orc_executor_set_param (OrcExecutor *ex, int var, int value)
{
  ex->params[var] = value;
}

void
orc_executor_set_param_float (OrcExecutor *ex, int var, float value)
{
  orc_union32 u;
  u.f = value;
  ex->params[var] = u.i;
}

void
orc_executor_set_param_int64 (OrcExecutor *ex, int var, orc_int64 value)
{
  orc_union64 u;
  u.i = value;
  ex->params[var] = u.x2[0];
  ex->params[var + (ORC_VAR_T1-ORC_VAR_P1)] = u.x2[1];
}

void
orc_executor_set_param_double (OrcExecutor *ex, int var, double value)
{
  orc_union64 u;
  u.f = value;
  ex->params[var] = u.x2[0];
  ex->params[var + (ORC_VAR_T1-ORC_VAR_P1)] = u.x2[1];
}

void
orc_executor_set_param_str (OrcExecutor *ex, const char *name, int value)
{
  int var;
  var = orc_program_find_var_by_name (ex->program, name);
  if (var >= 0)
    ex->params[var] = value;
}

int
orc_executor_get_accumulator (OrcExecutor *ex, int var)
{
  return ex->accumulators[var - ORC_VAR_A1];
}

int
orc_executor_get_accumulator_str (OrcExecutor *ex, const char *name)
{
  int var;
  var = orc_program_find_var_by_name (ex->program, name);
  if (var >= 0)
    return ex->accumulators[var];
  return -1;
}

void
orc_executor_set_n (OrcExecutor *ex, int n)
{
  ex->n = n;
}

void
orc_executor_set_m (OrcExecutor *ex, int m)
{
  ORC_EXECUTOR_M(ex) = m;
}

static void
load_constant (void *data, int size, orc_uint64 value)
{
  switch (size) {
    case 1:
      {
        int l;
        orc_int8 *d = data;
        for(l=0;l<CHUNK_SIZE;l++) {
          d[l] = value;
        }
      }
      break;
    case 2:
      {
        int l;
        orc_int16 *d = data;
        for(l=0;l<CHUNK_SIZE;l++) {
          d[l] = value;
        }
      }
      break;
    case 4:
      {
        int l;
        orc_int32 *d = data;
        for(l=0;l<CHUNK_SIZE;l++) {
          d[l] = value;
        }
      }
      break;
    case 8:
      {
        int l;
        orc_int64 *d = data;
        for(l=0;l<CHUNK_SIZE;l++) {
          d[l] = value;
        }
      }
      break;
    default:
      ORC_ASSERT(0);
  }

}


void
orc_executor_emulate (OrcExecutor *ex)
{
  int i;
  int j;
  int k;
  int m, m_index;
  OrcCode *code;
  OrcInstruction *insn;
  OrcStaticOpcode *opcode;
  OrcOpcodeExecutor *opcode_ex;
  void *tmpspace[ORC_N_COMPILER_VARIABLES] = { 0 };

  if (ex->program) {
    code = ex->program->orccode;
  } else {
    code = (OrcCode *)ex->arrays[ORC_VAR_A2];
  }

  ex->accumulators[0] = 0;
  ex->accumulators[1] = 0;
  ex->accumulators[2] = 0;
  ex->accumulators[3] = 0;

  ORC_DEBUG("emulating");

  memset (&opcode_ex, 0, sizeof(opcode_ex));

  if (code == NULL) {
    ORC_ERROR("attempt to run program that failed to compile");
    ORC_ASSERT(0);
  }

  if (code->is_2d) {
    m = ORC_EXECUTOR_M(ex);
  } else {
    m = 1;
  }

  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    OrcCodeVariable *var = code->vars + i;

    if (var->size) {
      tmpspace[i] = malloc(ORC_MAX_VAR_SIZE * CHUNK_SIZE);
    }
  }

  opcode_ex = malloc(sizeof(OrcOpcodeExecutor)*code->n_insns);

  for(j=0;j<code->n_insns;j++){
    insn = code->insns + j;
    opcode = insn->opcode;

    opcode_ex[j].emulateN = opcode->emulateN;
    opcode_ex[j].shift = 0;
    if (insn->flags & ORC_INSTRUCTION_FLAG_X2) {
      opcode_ex[j].shift = 1;
    } else if (insn->flags & ORC_INSTRUCTION_FLAG_X4) {
      opcode_ex[j].shift = 2;
    }

    for(k=0;k<ORC_STATIC_OPCODE_N_SRC;k++) {
      OrcCodeVariable *var = code->vars + insn->src_args[k];
      if (opcode->src_size[k] == 0) continue;

      if (var->vartype == ORC_VAR_TYPE_CONST) {
        opcode_ex[j].src_ptrs[k] = tmpspace[insn->src_args[k]];
        /* FIXME hack */
        load_constant (tmpspace[insn->src_args[k]], 8,
            var->value.i);
      } else if (var->vartype == ORC_VAR_TYPE_PARAM) {
        opcode_ex[j].src_ptrs[k] = tmpspace[insn->src_args[k]];
        /* FIXME hack */
        load_constant (tmpspace[insn->src_args[k]], 8,
            (orc_uint64)(orc_uint32)ex->params[insn->src_args[k]] |
            (((orc_uint64)(orc_uint32)ex->params[insn->src_args[k] +
             (ORC_VAR_T1 - ORC_VAR_P1)])<<32));
      } else if (var->vartype == ORC_VAR_TYPE_TEMP) {
        opcode_ex[j].src_ptrs[k] = tmpspace[insn->src_args[k]];
      } else if (var->vartype == ORC_VAR_TYPE_SRC) {
        if (ORC_PTR_TO_INT(ex->arrays[insn->src_args[k]]) & (var->size - 1)) {
          ORC_ERROR("Unaligned array for src%d, program %s",
              (insn->src_args[k]-ORC_VAR_S1), ex->program->name);
        }
        opcode_ex[j].src_ptrs[k] = ex->arrays[insn->src_args[k]];
      } else if (var->vartype == ORC_VAR_TYPE_DEST) {
        if (ORC_PTR_TO_INT(ex->arrays[insn->src_args[k]]) & (var->size - 1)) {
          ORC_ERROR("Unaligned array for dest%d, program %s",
              (insn->src_args[k]-ORC_VAR_D1), ex->program->name);
        }
        opcode_ex[j].src_ptrs[k] = ex->arrays[insn->src_args[k]];
      }
    }
    for(k=0;k<ORC_STATIC_OPCODE_N_DEST;k++) {
      OrcCodeVariable *var = code->vars + insn->dest_args[k];
      if (opcode->dest_size[k] == 0) continue;

      if (var->vartype == ORC_VAR_TYPE_TEMP) {
        ORC_DEBUG("dest vartype tmp %d", insn->dest_args[k]);
        opcode_ex[j].dest_ptrs[k] = tmpspace[insn->dest_args[k]];
      } else if (var->vartype == ORC_VAR_TYPE_ACCUMULATOR) {
        opcode_ex[j].dest_ptrs[k] =
          &ex->accumulators[insn->dest_args[k] - ORC_VAR_A1];
      } else if (var->vartype == ORC_VAR_TYPE_DEST) {
        if (ORC_PTR_TO_INT(ex->arrays[insn->dest_args[k]]) & (var->size - 1)) {
          ORC_ERROR("Unaligned array for dest%d, program %s",
              (insn->dest_args[k]-ORC_VAR_D1), ex->program->name);
        }
        opcode_ex[j].dest_ptrs[k] = ex->arrays[insn->dest_args[k]];
      }
    }
    ORC_DEBUG("opcode %s %p %p %p", opcode->name,
        opcode_ex[j].dest_ptrs[0], opcode_ex[j].src_ptrs[0],
        opcode_ex[j].src_ptrs[1]);
  }
  
  ORC_DEBUG("src ptr %p stride %d", ex->arrays[ORC_VAR_S1], ex->params[ORC_VAR_S1]);
  for(m_index=0;m_index<m;m_index++){
    ORC_DEBUG("m_index %d m %d", m_index, m);

    for(j=0;j<code->n_insns;j++){
      insn = code->insns + j;
      opcode = insn->opcode;

      for(k=0;k<ORC_STATIC_OPCODE_N_SRC;k++) {
        OrcCodeVariable *var = code->vars + insn->src_args[k];
        if (opcode->src_size[k] == 0) continue;

        if (var->vartype == ORC_VAR_TYPE_SRC) {
          opcode_ex[j].src_ptrs[k] =
            ORC_PTR_OFFSET(ex->arrays[insn->src_args[k]],
                ex->params[insn->src_args[k]]*m_index);
        } else if (var->vartype == ORC_VAR_TYPE_DEST) {
          opcode_ex[j].src_ptrs[k] =
            ORC_PTR_OFFSET(ex->arrays[insn->src_args[k]],
                ex->params[insn->src_args[k]]*m_index);
        }
      }
      for(k=0;k<ORC_STATIC_OPCODE_N_DEST;k++) {
        OrcCodeVariable *var = code->vars + insn->dest_args[k];
        if (opcode->dest_size[k] == 0) continue;

        if (var->vartype == ORC_VAR_TYPE_DEST) {
          opcode_ex[j].dest_ptrs[k] =
            ORC_PTR_OFFSET(ex->arrays[insn->dest_args[k]],
                ex->params[insn->dest_args[k]]*m_index);
        }
      }
    }

    for(i=0;i<ex->n;i+=CHUNK_SIZE){
      for(j=0;j<code->n_insns;j++){
        if (ex->n - i >= CHUNK_SIZE) {
          opcode_ex[j].emulateN (opcode_ex + j, i, CHUNK_SIZE << opcode_ex[j].shift);
        } else {
          opcode_ex[j].emulateN (opcode_ex + j, i, (ex->n - i) << opcode_ex[j].shift);
        }
      }
    }
  }

  free (opcode_ex);
  for(i=0;i<ORC_N_COMPILER_VARIABLES;i++){
    if (tmpspace[i]) free (tmpspace[i]);
  }
}


