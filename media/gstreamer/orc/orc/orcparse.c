
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <orc/orc.h>
#include <orc/orcparse.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/**
 * SECTION:orcparse
 * @title: Parser
 * @short_description: Parse Orc source code
 */


typedef struct _OrcParser OrcParser;
struct _OrcParser {
  const char *code;
  int code_length;

  const char *p;

  int line_number;
  char *line;
  int creg_index;

  OrcOpcodeSet *opcode_set;
  OrcProgram *program;
  OrcProgram *error_program;

  OrcProgram **programs;
  int n_programs;
  int n_programs_alloc;

  char *log;
  int log_size;
  int log_alloc;
};

static void orc_parse_get_line (OrcParser *parser);
static OrcStaticOpcode * get_opcode (OrcParser *parser, const char *opcode);
static void orc_parse_log (OrcParser *parser, const char *format, ...);
static int opcode_n_args (OrcStaticOpcode *opcode);
static void orc_parse_sanity_check (OrcParser *parser, OrcProgram *program);


int
orc_parse (const char *code, OrcProgram ***programs)
{
  return orc_parse_full (code, programs, NULL);
}

int
orc_parse_full (const char *code, OrcProgram ***programs, char **log)
{
  OrcParser _parser;
  OrcParser *parser = &_parser;
  char *init_function = NULL;

  memset (parser, 0, sizeof(*parser));

  parser->code = code;
  parser->code_length = strlen (code);
  parser->line_number = 0;
  parser->p = code;
  parser->opcode_set = orc_opcode_set_get ("sys");
  parser->log = malloc(100);
  parser->log_alloc = 100;
  parser->log_size = 0;
  parser->log[0] = 0;

  while (parser->p[0] != 0) {
    char *p;
    char *end;
    char *token[10];
    int n_tokens;

    orc_parse_get_line (parser);
    if (parser->program) orc_program_set_line (parser->program, parser->line_number);

    p = parser->line;
    end = p + strlen (p);
    /* printf("%d: %s\n", parser->line_number, parser->line); */

    while (p[0] == ' ' || p[0] == '\t') p++;

    if (p[0] == 0) {
      continue;
    }

    if (p[0] == '#') {
      /* printf("comment: %s\n", p+1); */
      continue;
    }

    n_tokens = 0;

    while (p < end) {
      while (p[0] != 0 && (p[0] == ' ' || p[0] == '\t')) p++;
      if (p[0] == 0 || p[0] == '#') break;

      token[n_tokens] = p;
      while (p[0] != 0 && p[0] != ' ' && p[0] != '\t' && p[0] != ',') p++;
      n_tokens++;

      p[0] = 0;
      p++;
    }

    if (n_tokens == 0) {
      continue;
    }

    {
      int i;
      for(i=0;i<n_tokens;i++){
        /* printf("'%s' ", token[i]); */
      }
      /* printf("\n"); */
    }

    if (token[0][0] == '.') {
      if (strcmp (token[0], ".function") == 0) {
        if (parser->program) {
          orc_parse_sanity_check (parser, parser->program);
        }
        parser->program = orc_program_new ();
        orc_program_set_name (parser->program, token[1]);
        if (parser->n_programs == parser->n_programs_alloc) {
          parser->n_programs_alloc += 32;
          parser->programs = realloc (parser->programs,
              sizeof(OrcProgram *)*parser->n_programs_alloc);
        }
        parser->programs[parser->n_programs] = parser->program;
        parser->n_programs++;
        parser->creg_index = 1;
      } else if (strcmp (token[0], ".init") == 0) {
        free (init_function);
        init_function = NULL;
        if (n_tokens < 2) {
          orc_parse_log (parser, "error: line %d: .init without function name\n",
              parser->line_number);
        } else {
          init_function = strdup (token[1]);
        }
      } else if (strcmp (token[0], ".flags") == 0) {
        int i;
        for(i=1;i<n_tokens;i++){
          if (!strcmp (token[i], "2d")) {
            orc_program_set_2d (parser->program);
          }
        }
      } else if (strcmp (token[0], ".n") == 0) {
        int i;
        for(i=1;i<n_tokens;i++){
          if (strcmp (token[i], "mult") == 0) {
            if (i == n_tokens - 1) {
              orc_parse_log (parser, "error: line %d: .n mult requires multiple value\n",
                  parser->line_number);
            } else {
              orc_program_set_n_multiple (parser->program,
                  strtol (token[1], NULL, 0));
              i++;
            }
          } else if (strcmp (token[i], "min") == 0) {
            if (i == n_tokens - 1) {
              orc_parse_log (parser, "error: line %d: .n min requires multiple value\n",
                  parser->line_number);
            } else {
              orc_program_set_n_minimum (parser->program,
                  strtol (token[1], NULL, 0));
              i++;
            }
          } else if (strcmp (token[i], "max") == 0) {
            if (i == n_tokens - 1) {
              orc_parse_log (parser, "error: line %d: .n max requires multiple value\n",
                  parser->line_number);
            } else {
              orc_program_set_n_maximum (parser->program,
                  strtol (token[1], NULL, 0));
              i++;
            }
          } else if (i == n_tokens - 1) {
            orc_program_set_constant_n (parser->program,
                strtol (token[1], NULL, 0));
          } else {
            orc_parse_log (parser, "error: line %d: unknown .n token '%s'\n",
                parser->line_number, token[i]);
          }
        }
      } else if (strcmp (token[0], ".m") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_set_constant_m (parser->program, size);
      } else if (strcmp (token[0], ".source") == 0) {
        int size = strtol (token[1], NULL, 0);
        int var;
        int i;
        var = orc_program_add_source (parser->program, size, token[2]);
        for(i=3;i<n_tokens;i++){
          if (strcmp (token[i], "align") == 0) {
            if (i == n_tokens - 1) {
              orc_parse_log (parser, "error: line %d: .source align requires alignment value\n",
                  parser->line_number);
            } else {
              int alignment = strtol (token[i+1], NULL, 0);
              orc_program_set_var_alignment (parser->program, var, alignment);
              i++;
            }
          } else if (i == n_tokens - 1) {
            orc_program_set_type_name (parser->program, var, token[i]);
          } else {
            orc_parse_log (parser, "error: line %d: unknown .dest token '%s'\n",
                parser->line_number, token[i]);
          }
        }
      } else if (strcmp (token[0], ".dest") == 0) {
        int size = strtol (token[1], NULL, 0);
        int var;
        int i;
        var = orc_program_add_destination (parser->program, size, token[2]);
        for(i=3;i<n_tokens;i++){
          if (strcmp (token[i], "align") == 0) {
            if (i == n_tokens - 1) {
              orc_parse_log (parser, "error: line %d: .source align requires alignment value\n",
                  parser->line_number);
            } else {
              int alignment = strtol (token[i+1], NULL, 0);
              orc_program_set_var_alignment (parser->program, var, alignment);
              i++;
            }
          } else if (i == n_tokens - 1) {
            orc_program_set_type_name (parser->program, var, token[i]);
          } else {
            orc_parse_log (parser, "error: line %d: unknown .source token '%s'\n",
                parser->line_number, token[i]);
          }
        }
      } else if (strcmp (token[0], ".accumulator") == 0) {
        int size = strtol (token[1], NULL, 0);
        int var;
        var = orc_program_add_accumulator (parser->program, size, token[2]);
        if (n_tokens > 3) {
          orc_program_set_type_name (parser->program, var, token[3]);
        }
      } else if (strcmp (token[0], ".temp") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_add_temporary (parser->program, size, token[2]);
      } else if (strcmp (token[0], ".param") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_add_parameter (parser->program, size, token[2]);
      } else if (strcmp (token[0], ".longparam") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_add_parameter_int64 (parser->program, size, token[2]);
      } else if (strcmp (token[0], ".const") == 0) {
        int size = strtol (token[1], NULL, 0);

        orc_program_add_constant_str (parser->program, size, token[3], token[2]);
      } else if (strcmp (token[0], ".floatparam") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_add_parameter_float (parser->program, size, token[2]);
      } else if (strcmp (token[0], ".doubleparam") == 0) {
        int size = strtol (token[1], NULL, 0);
        orc_program_add_parameter_double (parser->program, size, token[2]);
      } else {
        orc_parse_log (parser, "error: line %d: unknown directive: %s\n",
            parser->line_number, token[0]);
      }
    } else {
      OrcStaticOpcode *o;
      unsigned int flags = 0;
      int offset = 0;

      if (strcmp (token[0], "x4") == 0) {
        flags |= ORC_INSTRUCTION_FLAG_X4;
        offset = 1;
      } else if (strcmp (token[0], "x2") == 0) {
        flags |= ORC_INSTRUCTION_FLAG_X2;
        offset = 1;
      }

      o = get_opcode (parser, token[offset]);

      if (o) {
        int n_args = opcode_n_args (o);
        int i;

        if (n_tokens != 1 + offset + n_args) {
          orc_parse_log (parser, "error: line %d: too %s arguments for %s (expected %d)\n",
              parser->line_number, (n_tokens < 1+offset+n_args) ? "few" : "many",
              token[offset], n_args);
        }

        for(i=offset+1;i<n_tokens;i++){
          char *end;
          double unused ORC_GNUC_UNUSED;

          unused = strtod (token[i], &end);
          if (end != token[i]) {
            orc_program_add_constant_str (parser->program, 0, token[i],
                token[i]);
          }
        }

        if (n_tokens - offset == 5) {
          orc_program_append_str_2 (parser->program, token[offset], flags,
              token[offset+1], token[offset+2], token[offset+3], token[offset+4]);
        } else if (n_tokens - offset == 4) {
          orc_program_append_str_2 (parser->program, token[offset], flags,
              token[offset+1], token[offset+2], token[offset+3], NULL);
        } else {
          orc_program_append_str_2 (parser->program, token[offset], flags,
              token[offset+1], token[offset+2], NULL, NULL);
        }
      } else {
        orc_parse_log (parser, "error: line %d: unknown opcode: %s\n",
            parser->line_number,
            token[offset]);
      }
    }
  }

  if (parser->program) {
    orc_parse_sanity_check (parser, parser->program);
  }

  if (parser->line) free (parser->line);

  if (log) {
    *log = parser->log;
  } else {
    free (parser->log);
  }
  if (parser->programs && parser->programs[0]) {
    parser->programs[0]->init_function = init_function;
  } else {
    free (init_function);
  }
  *programs = parser->programs;
  return parser->n_programs;
}

static OrcStaticOpcode *
get_opcode (OrcParser *parser, const char *opcode)
{
  int i;

  for(i=0;i<parser->opcode_set->n_opcodes;i++){
    if (strcmp (opcode, parser->opcode_set->opcodes[i].name) == 0) {
      return parser->opcode_set->opcodes + i;
    }
  }

  return NULL;
}

static int
opcode_n_args (OrcStaticOpcode *opcode)
{
  int i;
  int n = 0;
  for(i=0;i<ORC_STATIC_OPCODE_N_DEST;i++){
    if (opcode->dest_size[i] != 0) n++;
  }
  for(i=0;i<ORC_STATIC_OPCODE_N_SRC;i++){
    if (opcode->src_size[i] != 0) n++;
  }
  return n;
}

static void
orc_parse_log_valist (OrcParser *parser, const char *format, va_list args)
{
  char s[100];
  int len;
  
  if (parser->error_program != parser->program) {
    sprintf(s, "In function %s:\n", parser->program->name);
    len = strlen(s);

    if (parser->log_size + len + 1 >= parser->log_alloc) {
      parser->log_alloc += 100;
      parser->log = realloc (parser->log, parser->log_alloc);
    }

    strcpy (parser->log + parser->log_size, s);
    parser->log_size += len;
    parser->error_program = parser->program;
  }

  vsprintf(s, format, args);
  len = strlen(s);

  if (parser->log_size + len + 1 >= parser->log_alloc) {
    parser->log_alloc += 100;
    parser->log = realloc (parser->log, parser->log_alloc);
  }

  strcpy (parser->log + parser->log_size, s);
  parser->log_size += len;
}

static void
orc_parse_log (OrcParser *parser, const char *format, ...)
{
  va_list var_args;

  va_start (var_args, format);
  orc_parse_log_valist (parser, format, var_args);
  va_end (var_args);
}

static void
orc_parse_get_line (OrcParser *parser)
{
  const char *end;
  int n;

  if (parser->line) {
    free (parser->line);
    parser->line = NULL;
  }

  end = strchr (parser->p, '\n');
  if (end == NULL) {
    end = parser->code + parser->code_length;
  }

  n = end - parser->p;
  parser->line = malloc (n + 1);
  memcpy (parser->line, parser->p, n);
  parser->line[n] = 0;

  parser->p = end;
  if (parser->p[0] == '\n') {
    parser->p++;
  }
  parser->line_number++;
}


static void
orc_parse_sanity_check (OrcParser *parser, OrcProgram *program)
{
  int i;
  int j;

  for(i=0;i<=ORC_VAR_T15;i++) {
    if (program->vars[i].size == 0) continue;
    for(j=i+1;j<=ORC_VAR_T15;j++) {
      if (program->vars[j].size == 0) continue;

      if (strcmp (program->vars[i].name, program->vars[j].name) == 0) {
        orc_parse_log (parser, "error: duplicate variable name: %s\n",
            program->vars[i].name);
      }
    }
  }

  for(i=0;i<program->n_insns;i++){
    OrcInstruction *insn = program->insns + i;
    OrcStaticOpcode *opcode = insn->opcode;

    for(j=0;j<ORC_STATIC_OPCODE_N_DEST;j++){
      if (opcode->dest_size[j] == 0) continue;
      if (program->vars[insn->dest_args[j]].used &&
          program->vars[insn->dest_args[j]].vartype == ORC_VAR_TYPE_DEST) {
        orc_parse_log (parser, "error: destination \"%s\" written multiple times\n",
            program->vars[insn->dest_args[j]].name);
      }
      program->vars[insn->dest_args[j]].used = TRUE;
    }

    for(j=0;j<ORC_STATIC_OPCODE_N_SRC;j++){
      if (opcode->src_size[j] == 0) continue;
      if (program->vars[insn->src_args[j]].used &&
          program->vars[insn->src_args[j]].vartype == ORC_VAR_TYPE_SRC) {
        orc_parse_log (parser, "error: source \"%s\" read multiple times\n",
            program->vars[insn->src_args[j]].name);
      }
      if (!program->vars[insn->src_args[j]].used &&
          program->vars[insn->src_args[j]].vartype == ORC_VAR_TYPE_TEMP) {
        orc_parse_log (parser, "error: variable \"%s\" used before being written\n",
            program->vars[insn->src_args[j]].name);
      }
    }

  }

}

const char *
orc_parse_get_init_function (OrcProgram *program)
{
  return program->init_function;
}

