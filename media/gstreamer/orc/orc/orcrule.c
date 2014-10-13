
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>

/**
 * SECTION:orcrule
 * @title: OrcRule
 * @short_description: Creating rules for code generation
 */


void
orc_rule_register (OrcRuleSet *rule_set,
    const char *opcode_name,
    OrcRuleEmitFunc emit, void *emit_user)
{
  int i;
  OrcOpcodeSet *opcode_set;

  opcode_set = orc_opcode_set_get_nth (rule_set->opcode_major);

  i = orc_opcode_set_find_by_name (opcode_set, opcode_name);
  if (i == -1) {
    ORC_ERROR("failed to find opcode \"%s\"", opcode_name);
    return;
  }

  rule_set->rules[i].emit = emit;
  rule_set->rules[i].emit_user = emit_user;
}

