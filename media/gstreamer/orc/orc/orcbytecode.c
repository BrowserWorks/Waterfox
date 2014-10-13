
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <orc/orc.h>
#include <orc/orcbytecode.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void bytecode_append_code (OrcBytecode *bytecode, int code);
void bytecode_append_int (OrcBytecode *bytecode, int value);
void bytecode_append_uint32 (OrcBytecode *bytecode, orc_uint32 value);
void bytecode_append_uint64 (OrcBytecode *bytecode, orc_uint64 value);
void bytecode_append_string (OrcBytecode *bytecode, char *s);


OrcBytecode *
orc_bytecode_new (void)
{
  OrcBytecode *bytecode;

  bytecode = malloc (sizeof(OrcBytecode));
  memset (bytecode, 0, sizeof(OrcBytecode));

  bytecode->alloc_len = 256;
  bytecode->bytecode = malloc(bytecode->alloc_len);

  return bytecode;
}

void
orc_bytecode_free (OrcBytecode *bytecode)
{
  free (bytecode->bytecode);
  free (bytecode);
}

OrcBytecode *
orc_bytecode_from_program (OrcProgram *p)
{
  OrcBytecode *bytecode = orc_bytecode_new ();
  int i;
  OrcVariable *var;
  OrcOpcodeSet *opcode_set;

  opcode_set = orc_opcode_set_get ("sys");

  bytecode_append_code (bytecode, ORC_BC_BEGIN_FUNCTION);

  if (p->constant_n != 0) {
    bytecode_append_code (bytecode, ORC_BC_SET_CONSTANT_N);
    bytecode_append_int (bytecode, p->constant_n);
  }
  if (p->n_multiple != 0) {
    bytecode_append_code (bytecode, ORC_BC_SET_N_MULTIPLE);
    bytecode_append_int (bytecode, p->n_multiple);
  }
  if (p->n_minimum != 0) {
    bytecode_append_code (bytecode, ORC_BC_SET_N_MINIMUM);
    bytecode_append_int (bytecode, p->n_minimum);
  }
  if (p->n_maximum != 0) {
    bytecode_append_code (bytecode, ORC_BC_SET_N_MAXIMUM);
    bytecode_append_int (bytecode, p->n_maximum);
  }
  if (p->is_2d) {
    bytecode_append_code (bytecode, ORC_BC_SET_2D);
    if (p->constant_m != 0) {
      bytecode_append_code (bytecode, ORC_BC_SET_CONSTANT_M);
      bytecode_append_int (bytecode, p->constant_m);
    }
  }
  if (p->name) {
    bytecode_append_code (bytecode, ORC_BC_SET_NAME);
    bytecode_append_string (bytecode, p->name);
  }
#if 0
  /* if (!is_inline) { */
  if (p->backup_function) {
    bytecode_append_code (bytecode, ORC_BC_SET_BACKUP_FUNCTION);
    bytecode_pointer (bytecode, p->backup_function);
  }
#endif
  for(i=0;i<4;i++){
    var = &p->vars[ORC_VAR_D1 + i];
    if (var->size) {
      bytecode_append_code (bytecode, ORC_BC_ADD_DESTINATION);
      bytecode_append_int (bytecode, var->size);
      bytecode_append_int (bytecode, var->alignment);
    }
  }
  for(i=0;i<8;i++){
    var = &p->vars[ORC_VAR_S1 + i];
    if (var->size) {
      bytecode_append_code (bytecode, ORC_BC_ADD_SOURCE);
      bytecode_append_int (bytecode, var->size);
      bytecode_append_int (bytecode, var->alignment);
    }
  }
  for(i=0;i<4;i++){
    var = &p->vars[ORC_VAR_A1 + i];
    if (var->size) {
      bytecode_append_code (bytecode, ORC_BC_ADD_ACCUMULATOR);
      bytecode_append_int (bytecode, var->size);
      /* bytecode_append_int (bytecode, var->alignment); */
    }
  }
  for(i=0;i<8;i++){
    var = &p->vars[ORC_VAR_C1 + i];
    if (var->size == 0) continue;
    if (var->size <= 4) {
      bytecode_append_code (bytecode, ORC_BC_ADD_CONSTANT);
      bytecode_append_int (bytecode, var->size);
      bytecode_append_uint32 (bytecode, (orc_uint32)var->value.i);
    } else if (var->size > 4) {
      bytecode_append_code (bytecode, ORC_BC_ADD_CONSTANT_INT64);
      bytecode_append_int (bytecode, var->size);
      bytecode_append_uint64 (bytecode, (orc_uint64)var->value.i);
    }
  }
  for(i=0;i<8;i++){
    var = &p->vars[ORC_VAR_P1 + i];
    if (var->size) {
      switch (var->param_type) {
        case ORC_PARAM_TYPE_INT:
          bytecode_append_code (bytecode, ORC_BC_ADD_PARAMETER);
          break;
        case ORC_PARAM_TYPE_FLOAT:
          bytecode_append_code (bytecode, ORC_BC_ADD_PARAMETER_FLOAT);
          break;
        case ORC_PARAM_TYPE_INT64:
          bytecode_append_code (bytecode, ORC_BC_ADD_PARAMETER_INT64);
          break;
        case ORC_PARAM_TYPE_DOUBLE:
          bytecode_append_code (bytecode, ORC_BC_ADD_PARAMETER_INT64);
          break;
        default:
          ORC_ASSERT(0);
          break;
      }
      bytecode_append_int (bytecode, var->size);
    }
  }
  for(i=0;i<16;i++){
    var = &p->vars[ORC_VAR_T1 + i];
    if (var->size) {
      bytecode_append_code (bytecode, ORC_BC_ADD_TEMPORARY);
      bytecode_append_int (bytecode, var->size);
    }
  }

  for(i=0;i<p->n_insns;i++){
    OrcInstruction *insn = p->insns + i;

    if (insn->flags) {
      bytecode_append_code (bytecode, ORC_BC_INSTRUCTION_FLAGS);
      bytecode_append_int (bytecode, insn->flags);
    }
    bytecode_append_code (bytecode, (insn->opcode - opcode_set->opcodes) + 32);
    if (insn->opcode->dest_size[0] != 0) {
      bytecode_append_int (bytecode, insn->dest_args[0]);
    }
    if (insn->opcode->dest_size[1] != 0) {
      bytecode_append_int (bytecode, insn->dest_args[1]);
    }
    if (insn->opcode->src_size[0] != 0) {
      bytecode_append_int (bytecode, insn->src_args[0]);
    }
    if (insn->opcode->src_size[1] != 0) {
      bytecode_append_int (bytecode, insn->src_args[1]);
    }
    if (insn->opcode->src_size[2] != 0) {
      bytecode_append_int (bytecode, insn->src_args[2]);
    }
  }

  bytecode_append_code (bytecode, ORC_BC_END_FUNCTION);
  bytecode_append_code (bytecode, ORC_BC_END);

  return bytecode;
}

void
bytecode_append_byte (OrcBytecode *bytecode, int byte)
{
  if (bytecode->length >= bytecode->alloc_len) {
    bytecode->alloc_len += 256;
    bytecode->bytecode = realloc (bytecode->bytecode, bytecode->alloc_len);
  }
  bytecode->bytecode[bytecode->length] = byte;
  bytecode->length++;
}

void
bytecode_append_code (OrcBytecode *bytecode, int code)
{
  bytecode_append_byte (bytecode, code);
#if 0
  OrcOpcodeSet *opcode_set = orc_opcode_set_get ("sys");

  fprintf(bytecode, "\n  ");
  if (code >= 32) {
    fprintf(bytecode, "ORC_BC_%s, ", opcode_set->opcodes[code-32].name);
  } else {
    static char *codes[32] = {
      "END",
      "BEGIN_FUNCTION",
      "END_FUNCTION",
      "SET_CONSTANT_N",
      "SET_N_MULTIPLE",
      "SET_N_MINIMUM",
      "SET_N_MAXIMUM",
      "SET_2D",
      "SET_CONSTANT_M",
      "SET_NAME",
      "SET_BACKUP_FUNCTION",
      "ADD_DESTINATION",
      "ADD_SOURCE",
      "ADD_ACCUMULATOR",
      "ADD_CONSTANT",
      "ADD_CONSTANT_INT64",
      "ADD_PARAMETER",
      "ADD_PARAMETER_FLOAT",
      "ADD_PARAMETER_INT64",
      "ADD_PARAMETER_DOUBLE",
      "ADD_TEMPORARY",
      "RESERVED_21",
      "RESERVED_22",
      "RESERVED_23",
      "RESERVED_24",
      "RESERVED_25",
      "RESERVED_26",
      "RESERVED_27",
      "RESERVED_28",
      "RESERVED_29",
      "RESERVED_30",
      "RESERVED_31"
    };

    fprintf(bytecode, "ORC_BC_%s, ", codes[code]);
  }
#endif
}

void
bytecode_append_int (OrcBytecode *bytecode, int value)
{
  ORC_ASSERT(value >= 0);

  if (value < 255) {
    bytecode_append_byte (bytecode, value);
  } else if (value < 65535) {
    bytecode_append_byte (bytecode, 255);
    bytecode_append_byte (bytecode, value & 0xff);
    bytecode_append_byte (bytecode, value >> 8);
  } else {
    ORC_ASSERT(0);
  }
}

void
bytecode_append_uint32 (OrcBytecode *bytecode, orc_uint32 value)
{
  bytecode_append_byte (bytecode, value & 0xff);
  bytecode_append_byte (bytecode, (value >> 8) & 0xff);
  bytecode_append_byte (bytecode, (value >> 16) & 0xff);
  bytecode_append_byte (bytecode, (value >> 24) & 0xff);

}

void
bytecode_append_uint64 (OrcBytecode *bytecode, orc_uint64 value)
{
  bytecode_append_byte (bytecode, value & 0xff);
  bytecode_append_byte (bytecode, (value >> 8) & 0xff);
  bytecode_append_byte (bytecode, (value >> 16) & 0xff);
  bytecode_append_byte (bytecode, (value >> 24) & 0xff);
  bytecode_append_byte (bytecode, (value >> 32) & 0xff);
  bytecode_append_byte (bytecode, (value >> 40) & 0xff);
  bytecode_append_byte (bytecode, (value >> 48) & 0xff);
  bytecode_append_byte (bytecode, (value >> 56) & 0xff);

}

void
bytecode_append_string (OrcBytecode *bytecode, char *s)
{
  int i;
  int len = strlen(s);
  bytecode_append_int (bytecode, len);
  for(i=0;i<len;i++){
    bytecode_append_byte (bytecode, s[i]);
  }
}

typedef struct _OrcBytecodeParse OrcBytecodeParse;
struct _OrcBytecodeParse {
  const orc_uint8 *bytecode;
  int parse_offset;
  int function_start;
  int code_start;
};

int
orc_bytecode_parse_get_byte (OrcBytecodeParse *parse)
{
  int value;
  value = parse->bytecode[parse->parse_offset];
  parse->parse_offset++;
  return value;
}

int
orc_bytecode_parse_get_int (OrcBytecodeParse *parse)
{
  int value;

  value = orc_bytecode_parse_get_byte(parse);
  if (value == 255) {
    value = orc_bytecode_parse_get_byte(parse);
    value |= orc_bytecode_parse_get_byte(parse) << 8;
  }

  return value;
}

char *
orc_bytecode_parse_get_string (OrcBytecodeParse *parse)
{
  int len;
  int i;
  char *s;

  len = orc_bytecode_parse_get_int (parse);
  s = malloc (len + 1);
  for(i=0;i<len;i++){
    s[i] = orc_bytecode_parse_get_byte (parse);
  }
  s[i] = 0;

  return s;
}

orc_uint32
orc_bytecode_parse_get_uint32 (OrcBytecodeParse *parse)
{
  orc_uint32 value;
  value = orc_bytecode_parse_get_byte (parse);
  value |= ((orc_uint32)orc_bytecode_parse_get_byte (parse)) << 8;
  value |= ((orc_uint32)orc_bytecode_parse_get_byte (parse)) << 16;
  value |= ((orc_uint32)orc_bytecode_parse_get_byte (parse)) << 24;
  return value;
}

orc_uint64
orc_bytecode_parse_get_uint64 (OrcBytecodeParse *parse)
{
  orc_uint64 value;

  value = ((orc_uint64)orc_bytecode_parse_get_byte (parse));
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 8;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 16;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 24;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 32;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 40;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 48;
  value |= ((orc_uint64)orc_bytecode_parse_get_byte (parse)) << 56;

  return value;
}

int
orc_bytecode_parse_function (OrcProgram *program, const orc_uint8 *bytecode)
{
  OrcBytecodeParse _parse;
  OrcBytecodeParse *parse = &_parse;
  /* int in_function = FALSE; */
  int bc;
  int size;
  int alignment;
  OrcOpcodeSet *opcode_set;
  int instruction_flags = 0;

  memset (parse, 0, sizeof(*parse));
  parse->bytecode = bytecode;

  opcode_set = orc_opcode_set_get ("sys");

  while (1) {
    bc = orc_bytecode_parse_get_int (parse);
    if (bc < ORC_BC_absb) {
      switch (bc) {
        case ORC_BC_END:
          /* FIXME this is technically an error */
          return 0;
        case ORC_BC_BEGIN_FUNCTION:
          /* in_function = TRUE; */
          break;
        case ORC_BC_END_FUNCTION:
          return 0;
        case ORC_BC_SET_CONSTANT_N:
          program->constant_n = orc_bytecode_parse_get_int (parse);
          break;
        case ORC_BC_SET_N_MULTIPLE:
          program->n_multiple = orc_bytecode_parse_get_int (parse);
          break;
        case ORC_BC_SET_N_MINIMUM:
          program->n_minimum = orc_bytecode_parse_get_int (parse);
          break;
        case ORC_BC_SET_N_MAXIMUM:
          program->n_maximum = orc_bytecode_parse_get_int (parse);
          break;
        case ORC_BC_SET_2D:
          program->is_2d = TRUE;
          break;
        case ORC_BC_SET_CONSTANT_M:
          program->constant_m = orc_bytecode_parse_get_int (parse);
          break;
        case ORC_BC_SET_NAME:
          if (program->name) {
            free (program->name);
          }
          program->name = orc_bytecode_parse_get_string (parse);
          break;
        case ORC_BC_SET_BACKUP_FUNCTION:
          /* FIXME error */
          break;
        case ORC_BC_ADD_DESTINATION:
          size = orc_bytecode_parse_get_int (parse);
          alignment = orc_bytecode_parse_get_int (parse);
          orc_program_add_destination_full (program, size, "d", "unknown",
              alignment);
          break;
        case ORC_BC_ADD_SOURCE:
          size = orc_bytecode_parse_get_int (parse);
          alignment = orc_bytecode_parse_get_int (parse);
          orc_program_add_source_full (program, size, "s", "unknown",
              alignment);
          break;
        case ORC_BC_ADD_ACCUMULATOR:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_accumulator (program, size, "a");
          break;
        case ORC_BC_ADD_CONSTANT:
          {
            orc_uint32 value;
            size = orc_bytecode_parse_get_int (parse);
            value = orc_bytecode_parse_get_uint32 (parse);
            orc_program_add_constant (program, size, value, "c");
          }
          break;
        case ORC_BC_ADD_CONSTANT_INT64:
          {
            orc_uint64 value;
            size = orc_bytecode_parse_get_int (parse);
            value = orc_bytecode_parse_get_uint64 (parse);
            orc_program_add_constant_int64 (program, size, value, "c");
          }
          break;
        case ORC_BC_ADD_PARAMETER:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_parameter (program, size, "p");
          break;
        case ORC_BC_ADD_PARAMETER_FLOAT:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_parameter_float (program, size, "p");
          break;
        case ORC_BC_ADD_PARAMETER_INT64:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_parameter_int64 (program, size, "p");
          break;
        case ORC_BC_ADD_PARAMETER_DOUBLE:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_parameter_double (program, size, "p");
          break;
        case ORC_BC_ADD_TEMPORARY:
          size = orc_bytecode_parse_get_int (parse);
          orc_program_add_temporary (program, size, "t");
          break;
        case ORC_BC_INSTRUCTION_FLAGS:
          instruction_flags = orc_bytecode_parse_get_int (parse);
          break;
        default:
          break;
      }
    } else {
      OrcInstruction *insn;

      insn = program->insns + program->n_insns;

      insn->opcode = opcode_set->opcodes + (bc - 32);
      if (insn->opcode->dest_size[0] != 0) {
        insn->dest_args[0] = orc_bytecode_parse_get_int (parse);
      }
      if (insn->opcode->dest_size[1] != 0) {
        insn->dest_args[1] = orc_bytecode_parse_get_int (parse);
      }
      if (insn->opcode->src_size[0] != 0) {
        insn->src_args[0] = orc_bytecode_parse_get_int (parse);
      }
      if (insn->opcode->src_size[1] != 0) {
        insn->src_args[1] = orc_bytecode_parse_get_int (parse);
      }
      if (insn->opcode->src_size[2] != 0) {
        insn->src_args[2] = orc_bytecode_parse_get_int (parse);
      }
      insn->flags = instruction_flags;
      instruction_flags = 0;

      program->n_insns++;
    }
  }
}

