
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include <orc/orcprogram.h>
#include <orc/orcdebug.h>

/**
 * SECTION:orcopcode
 * @title: OrcOpcode
 * @short_description: Operations
 */


static OrcOpcodeSet *opcode_sets;
static int n_opcode_sets;

static OrcTarget *targets[ORC_N_TARGETS];
static int n_targets;

static OrcTarget *default_target;

#define ORC_SB_MAX 127
#define ORC_SB_MIN (-1-ORC_SB_MAX)
#define ORC_UB_MAX 255
#define ORC_UB_MIN 0
#define ORC_SW_MAX 32767
#define ORC_SW_MIN (-1-ORC_SW_MAX)
#define ORC_UW_MAX 65535
#define ORC_UW_MIN 0
#define ORC_SL_MAX 2147483647
#define ORC_SL_MIN (-1-ORC_SL_MAX)
#define ORC_UL_MAX ORC_UINT64_C(4294967295)
#define ORC_UL_MIN 0

#define ORC_CLAMP_SB(x) ORC_CLAMP(x,ORC_SB_MIN,ORC_SB_MAX)
#define ORC_CLAMP_UB(x) ORC_CLAMP(x,ORC_UB_MIN,ORC_UB_MAX)
#define ORC_CLAMP_SW(x) ORC_CLAMP(x,ORC_SW_MIN,ORC_SW_MAX)
#define ORC_CLAMP_UW(x) ORC_CLAMP(x,ORC_UW_MIN,ORC_UW_MAX)
#define ORC_CLAMP_SL(x) ORC_CLAMP(x,ORC_SL_MIN,ORC_SL_MAX)
#define ORC_CLAMP_UL(x) ORC_CLAMP(x,ORC_UL_MIN,ORC_UL_MAX)


void
orc_target_register (OrcTarget *target)
{
  targets[n_targets] = target;
  n_targets++;

  if (target->executable) {
    default_target = target;
  }
}

OrcTarget *
orc_target_get_by_name (const char *name)
{
  int i;

  if (name == NULL) return default_target;

  for(i=0;i<n_targets;i++){
    if (strcmp (name, targets[i]->name) == 0) {
      return targets[i];
    }
  }

  return NULL;
}

OrcTarget *
orc_target_get_default (void)
{
  return default_target;
}

const char *
orc_target_get_name (OrcTarget *target)
{
  if (target == NULL) return NULL;
  return target->name;
}

unsigned int
orc_target_get_default_flags (OrcTarget *target)
{
  if (target == NULL) return 0;
  return target->get_default_flags();
}

const char *
orc_target_get_preamble (OrcTarget *target)
{
  if (target->get_asm_preamble == NULL) return "";

  return target->get_asm_preamble ();
}

const char *
orc_target_get_asm_preamble (const char *target)
{
  OrcTarget *t;

  t = orc_target_get_by_name (target);
  if (t == NULL) return "";

  return orc_target_get_preamble (t);
}

const char *
orc_target_get_flag_name (OrcTarget *target, int shift)
{
  if (target->get_flag_name == NULL) return "";

  return target->get_flag_name (shift);
}

#if 0
int
orc_opcode_get_list (OrcOpcode **list)
{
  (*list) = opcode_list;
  return n_opcodes;
}
#endif

#if 0
void
orc_opcode_register (const char *name, int n_dest, int n_src,
    OrcOpcodeEmulateFunc emulate, void *user)
{
  OrcOpcode *opcode;

  if (n_opcodes == n_opcodes_alloc) {
    n_opcodes_alloc += 100;
    opcode_list = realloc(opcode_list, sizeof(OrcOpcode) * n_opcodes_alloc);
  }

  opcode = opcode_list + n_opcodes;

  opcode->name = strdup (name);
  opcode->n_src = n_src;
  opcode->n_dest = n_dest;
  opcode->emulate = emulate;
  opcode->emulate_user = user;

  n_opcodes++;
}
#endif

OrcRuleSet *
orc_rule_set_new (OrcOpcodeSet *opcode_set, OrcTarget *target,
    unsigned int required_flags)
{
  OrcRuleSet *rule_set;

  rule_set = target->rule_sets + target->n_rule_sets;
  target->n_rule_sets++;

  memset (rule_set, 0, sizeof(OrcRuleSet));

  rule_set->opcode_major = opcode_set->opcode_major;
  rule_set->required_target_flags = required_flags;

  rule_set->rules = malloc (sizeof(OrcRule) * opcode_set->n_opcodes);
  memset (rule_set->rules, 0, sizeof(OrcRule) * opcode_set->n_opcodes);

  return rule_set;
}

OrcRule *
orc_target_get_rule (OrcTarget *target, OrcStaticOpcode *opcode,
    unsigned int target_flags)
{
  OrcRule *rule;
  int i;
  int j;
  int k;

  for(k=0;k<n_opcode_sets;k++){
    j = opcode - opcode_sets[k].opcodes;

    if (j < 0 || j >= opcode_sets[k].n_opcodes) continue;
    if (opcode_sets[k].opcodes + j != opcode) continue;

    for(i=target->n_rule_sets-1;i>=0;i--){
      if (target->rule_sets[i].opcode_major != opcode_sets[k].opcode_major) continue;
      if (target->rule_sets[i].required_target_flags & (~target_flags)) continue;

      rule = target->rule_sets[i].rules + j;
      if (rule->emit) return rule;
    }
  }

  return NULL;
}

int
orc_opcode_register_static (OrcStaticOpcode *sopcode, char *prefix)
{
  int n;
  int major;

  n = 0;
  while (sopcode[n].name[0]) {
    n++;
  }

  major = n_opcode_sets;

  n_opcode_sets++;
  opcode_sets = realloc (opcode_sets, sizeof(OrcOpcodeSet)*n_opcode_sets);
  
  memset (opcode_sets + major, 0, sizeof(OrcOpcodeSet));
  strncpy(opcode_sets[major].prefix, prefix, sizeof(opcode_sets[major].prefix)-1);
  opcode_sets[major].n_opcodes = n;
  opcode_sets[major].opcodes = sopcode;
  opcode_sets[major].opcode_major = major;

  return major;
}

OrcOpcodeSet *
orc_opcode_set_get (const char *name)
{
  int i;

  for(i=0;i<n_opcode_sets;i++){
    if (strcmp (opcode_sets[i].prefix, name) == 0) {
      return opcode_sets + i;
    }
  }

  return NULL;
}

OrcOpcodeSet *
orc_opcode_set_get_nth (int opcode_major)
{
  return opcode_sets + opcode_major;
}

int
orc_opcode_set_find_by_name (OrcOpcodeSet *opcode_set, const char *name)
{
  int j;

  for(j=0;j<opcode_set->n_opcodes;j++){
    if (strcmp (name, opcode_set->opcodes[j].name) == 0) {
      return j;
    }
  }

  return -1;
}

OrcStaticOpcode *
orc_opcode_find_by_name (const char *name)
{
  int i;
  int j;

  for(i=0;i<n_opcode_sets;i++){
    j = orc_opcode_set_find_by_name (opcode_sets + i, name);
    if (j >= 0) {
      return &opcode_sets[i].opcodes[j];
    }
  }

  return NULL;
}

void
emulate_null (OrcOpcodeExecutor *ex, int offset, int n)
{
  /* This is a placeholder for adding new opcodes */
  ORC_ERROR("emulate_null() called.  This is a bug.");
}

#include "orc/orcemulateopcodes.h"

static OrcStaticOpcode opcodes[] = {

  /* byte ops */
  { "absb", 0, { 1 }, { 1 }, emulate_absb },
  { "addb", 0, { 1 }, { 1, 1 }, emulate_addb },
  { "addssb", 0, { 1 }, { 1, 1 }, emulate_addssb },
  { "addusb", 0, { 1 }, { 1, 1 }, emulate_addusb },
  { "andb", 0, { 1 }, { 1, 1 }, emulate_andb },
  { "andnb", 0, { 1 }, { 1, 1 }, emulate_andnb },
  { "avgsb", 0, { 1 }, { 1, 1 }, emulate_avgsb },
  { "avgub", 0, { 1 }, { 1, 1 }, emulate_avgub },
  { "cmpeqb", 0, { 1 }, { 1, 1 }, emulate_cmpeqb },
  { "cmpgtsb", 0, { 1 }, { 1, 1 }, emulate_cmpgtsb },
  { "copyb", 0, { 1 }, { 1 }, emulate_copyb },
  { "loadb", ORC_STATIC_OPCODE_LOAD, { 1 }, { 1 }, emulate_loadb },
  { "loadoffb", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 4 }, emulate_loadoffb },
  { "loadupdb", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_ITERATOR, { 1 }, { 1 }, emulate_loadupdb },
  { "loadupib", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_ITERATOR, { 1 }, { 1 }, emulate_loadupib },
  { "loadpb", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR|ORC_STATIC_OPCODE_INVARIANT, { 1 }, { 1 }, emulate_loadpb },
  { "ldresnearb", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 4, 4 }, emulate_ldresnearb },
  { "ldresnearl", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4, 4 }, emulate_ldresnearl },
  { "ldreslinb", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 4, 4 }, emulate_ldreslinb },
  { "ldreslinl", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4, 4 }, emulate_ldreslinl },
  { "maxsb", 0, { 1 }, { 1, 1 }, emulate_maxsb },
  { "maxub", 0, { 1 }, { 1, 1 }, emulate_maxub },
  { "minsb", 0, { 1 }, { 1, 1 }, emulate_minsb },
  { "minub", 0, { 1 }, { 1, 1 }, emulate_minub },
  { "mullb", 0, { 1 }, { 1, 1 }, emulate_mullb },
  { "mulhsb", 0, { 1 }, { 1, 1 }, emulate_mulhsb },
  { "mulhub", 0, { 1 }, { 1, 1 }, emulate_mulhub },
  { "orb", 0, { 1 }, { 1, 1 }, emulate_orb },
  { "shlb", ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 1 }, emulate_shlb },
  { "shrsb", ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 1 }, emulate_shrsb },
  { "shrub", ORC_STATIC_OPCODE_SCALAR, { 1 }, { 1, 1 }, emulate_shrub },
  { "signb", 0, { 1 }, { 1 }, emulate_signb },
  { "storeb", ORC_STATIC_OPCODE_STORE, { 1 }, { 1 }, emulate_storeb },
  { "subb", 0, { 1 }, { 1, 1 }, emulate_subb },
  { "subssb", 0, { 1 }, { 1, 1 }, emulate_subssb },
  { "subusb", 0, { 1 }, { 1, 1 }, emulate_subusb },
  { "xorb", 0, { 1 }, { 1, 1 }, emulate_xorb },

  /* word ops */
  { "absw", 0, { 2 }, { 2 }, emulate_absw },
  { "addw", 0, { 2 }, { 2, 2 }, emulate_addw },
  { "addssw", 0, { 2 }, { 2, 2 }, emulate_addssw },
  { "addusw", 0, { 2 }, { 2, 2 }, emulate_addusw },
  { "andw", 0, { 2 }, { 2, 2 }, emulate_andw },
  { "andnw", 0, { 2 }, { 2, 2 }, emulate_andnw },
  { "avgsw", 0, { 2 }, { 2, 2 }, emulate_avgsw },
  { "avguw", 0, { 2 }, { 2, 2 }, emulate_avguw },
  { "cmpeqw", 0, { 2 }, { 2, 2 }, emulate_cmpeqw },
  { "cmpgtsw", 0, { 2 }, { 2, 2 }, emulate_cmpgtsw },
  { "copyw", 0, { 2 }, { 2 }, emulate_copyw },
  { "div255w", 0, { 2 }, { 2 }, emulate_div255w },
  { "divluw", 0, { 2 }, { 2, 2 }, emulate_divluw },
  { "loadw", ORC_STATIC_OPCODE_LOAD, { 2 }, { 2 }, emulate_loadw },
  { "loadoffw", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 2 }, { 2, 4 }, emulate_loadoffw },
  { "loadpw", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR|ORC_STATIC_OPCODE_INVARIANT, { 2 }, { 2 }, emulate_loadpw },
  { "maxsw", 0, { 2 }, { 2, 2 }, emulate_maxsw },
  { "maxuw", 0, { 2 }, { 2, 2 }, emulate_maxuw },
  { "minsw", 0, { 2 }, { 2, 2 }, emulate_minsw },
  { "minuw", 0, { 2 }, { 2, 2 }, emulate_minuw },
  { "mullw", 0, { 2 }, { 2, 2 }, emulate_mullw },
  { "mulhsw", 0, { 2 }, { 2, 2 }, emulate_mulhsw },
  { "mulhuw", 0, { 2 }, { 2, 2 }, emulate_mulhuw },
  { "orw", 0, { 2 }, { 2, 2 }, emulate_orw },
  { "shlw", ORC_STATIC_OPCODE_SCALAR, { 2 }, { 2, 2 }, emulate_shlw },
  { "shrsw", ORC_STATIC_OPCODE_SCALAR, { 2 }, { 2, 2 }, emulate_shrsw },
  { "shruw", ORC_STATIC_OPCODE_SCALAR, { 2 }, { 2, 2 }, emulate_shruw },
  { "signw", 0, { 2 }, { 2 }, emulate_signw },
  { "storew", ORC_STATIC_OPCODE_STORE, { 2 }, { 2 }, emulate_storew },
  { "subw", 0, { 2 }, { 2, 2 }, emulate_subw },
  { "subssw", 0, { 2 }, { 2, 2 }, emulate_subssw },
  { "subusw", 0, { 2 }, { 2, 2 }, emulate_subusw },
  { "xorw", 0, { 2 }, { 2, 2 }, emulate_xorw },

  /* long ops */
  { "absl", 0, { 4 }, { 4 }, emulate_absl },
  { "addl", 0, { 4 }, { 4, 4 }, emulate_addl },
  { "addssl", 0, { 4 }, { 4, 4 }, emulate_addssl },
  { "addusl", 0, { 4 }, { 4, 4 }, emulate_addusl },
  { "andl", 0, { 4 }, { 4, 4 }, emulate_andl },
  { "andnl", 0, { 4 }, { 4, 4 }, emulate_andnl },
  { "avgsl", 0, { 4 }, { 4, 4 }, emulate_avgsl },
  { "avgul", 0, { 4 }, { 4, 4 }, emulate_avgul },
  { "cmpeql", 0, { 4 }, { 4, 4 }, emulate_cmpeql },
  { "cmpgtsl", 0, { 4 }, { 4, 4 }, emulate_cmpgtsl },
  { "copyl", 0, { 4 }, { 4 }, emulate_copyl },
  { "loadl", ORC_STATIC_OPCODE_LOAD, { 4 }, { 4 }, emulate_loadl },
  { "loadoffl", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4 }, emulate_loadoffl },
  { "loadpl", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR|ORC_STATIC_OPCODE_INVARIANT, { 4 }, { 4 }, emulate_loadpl },
  { "maxsl", 0, { 4 }, { 4, 4 }, emulate_maxsl },
  { "maxul", 0, { 4 }, { 4, 4 }, emulate_maxul },
  { "minsl", 0, { 4 }, { 4, 4 }, emulate_minsl },
  { "minul", 0, { 4 }, { 4, 4 }, emulate_minul },
  { "mulll", 0, { 4 }, { 4, 4 }, emulate_mulll },
  { "mulhsl", 0, { 4 }, { 4, 4 }, emulate_mulhsl },
  { "mulhul", 0, { 4 }, { 4, 4 }, emulate_mulhul },
  { "orl", 0, { 4 }, { 4, 4 }, emulate_orl },
  { "shll", ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4 }, emulate_shll },
  { "shrsl", ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4 }, emulate_shrsl },
  { "shrul", ORC_STATIC_OPCODE_SCALAR, { 4 }, { 4, 4 }, emulate_shrul },
  { "signl", 0, { 4 }, { 4 }, emulate_signl },
  { "storel", ORC_STATIC_OPCODE_STORE, { 4 }, { 4 }, emulate_storel },
  { "subl", 0, { 4 }, { 4, 4 }, emulate_subl },
  { "subssl", 0, { 4 }, { 4, 4 }, emulate_subssl },
  { "subusl", 0, { 4 }, { 4, 4 }, emulate_subusl },
  { "xorl", 0, { 4 }, { 4, 4 }, emulate_xorl },

  { "loadq", ORC_STATIC_OPCODE_LOAD, { 8 }, { 8 }, emulate_loadq },
  { "loadpq", ORC_STATIC_OPCODE_LOAD|ORC_STATIC_OPCODE_SCALAR|ORC_STATIC_OPCODE_INVARIANT, { 8 }, { 8 }, emulate_loadpq },
  { "storeq", ORC_STATIC_OPCODE_STORE, { 8 }, { 8 }, emulate_storeq },
  { "splatw3q", 0, { 8 }, { 8 }, emulate_splatw3q },
  { "copyq", 0, { 8 }, { 8 }, emulate_copyq },
  { "cmpeqq", 0, { 8 }, { 8, 8 }, emulate_cmpeqq },
  { "cmpgtsq", 0, { 8 }, { 8, 8 }, emulate_cmpgtsq },
  { "andq", 0, { 8 }, { 8, 8 }, emulate_andq },
  { "andnq", 0, { 8 }, { 8, 8 }, emulate_andnq },
  { "orq", 0, { 8 }, { 8, 8 }, emulate_orq },
  { "xorq", 0, { 8 }, { 8, 8 }, emulate_xorq },
  { "addq", 0, { 8 }, { 8, 8 }, emulate_addq },
  { "subq", 0, { 8 }, { 8, 8 }, emulate_subq },
  { "shlq", ORC_STATIC_OPCODE_SCALAR, { 8 }, { 8, 8 }, emulate_shlq },
  { "shrsq", ORC_STATIC_OPCODE_SCALAR, { 8 }, { 8, 8 }, emulate_shrsq },
  { "shruq", ORC_STATIC_OPCODE_SCALAR, { 8 }, { 8, 8 }, emulate_shruq },

  { "convsbw", 0, { 2 }, { 1 }, emulate_convsbw },
  { "convubw", 0, { 2 }, { 1 }, emulate_convubw },
  { "splatbw", 0, { 2 }, { 1 }, emulate_splatbw },
  { "splatbl", 0, { 4 }, { 1 }, emulate_splatbl },

  { "convswl", 0, { 4 }, { 2 }, emulate_convswl },
  { "convuwl", 0, { 4 }, { 2 }, emulate_convuwl },
  { "convslq", 0, { 8 }, { 4 }, emulate_convslq },
  { "convulq", 0, { 8 }, { 4 }, emulate_convulq },

  { "convwb", 0, { 1 }, { 2 }, emulate_convwb },
  { "convhwb", 0, { 1 }, { 2 }, emulate_convhwb },
  { "convssswb", 0, { 1 }, { 2 }, emulate_convssswb },
  { "convsuswb", 0, { 1 }, { 2 }, emulate_convsuswb },
  { "convusswb", 0, { 1 }, { 2 }, emulate_convusswb },
  { "convuuswb", 0, { 1 }, { 2 }, emulate_convuuswb },

  { "convlw", 0, { 2 }, { 4 }, emulate_convlw },
  { "convhlw", 0, { 2 }, { 4 }, emulate_convhlw },
  { "convssslw", 0, { 2 }, { 4 }, emulate_convssslw },
  { "convsuslw", 0, { 2 }, { 4 }, emulate_convsuslw },
  { "convusslw", 0, { 2 }, { 4 }, emulate_convusslw },
  { "convuuslw", 0, { 2 }, { 4 }, emulate_convuuslw },

  { "convql", 0, { 4 }, { 8 }, emulate_convql },
  { "convsssql", 0, { 4 }, { 8 }, emulate_convsssql },
  { "convsusql", 0, { 4 }, { 8 }, emulate_convsusql },
  { "convussql", 0, { 4 }, { 8 }, emulate_convussql },
  { "convuusql", 0, { 4 }, { 8 }, emulate_convuusql },

  { "mulsbw", 0, { 2 }, { 1, 1 }, emulate_mulsbw },
  { "mulubw", 0, { 2 }, { 1, 1 }, emulate_mulubw },
  { "mulswl", 0, { 4 }, { 2, 2 }, emulate_mulswl },
  { "muluwl", 0, { 4 }, { 2, 2 }, emulate_muluwl },
  { "mulslq", 0, { 8 }, { 4, 4 }, emulate_mulslq },
  { "mululq", 0, { 8 }, { 4, 4 }, emulate_mululq },

  /* accumulators */
  { "accw", ORC_STATIC_OPCODE_ACCUMULATOR, { 2 }, { 2 }, emulate_accw },
  { "accl", ORC_STATIC_OPCODE_ACCUMULATOR, { 4 }, { 4 }, emulate_accl },
  { "accsadubl", ORC_STATIC_OPCODE_ACCUMULATOR, { 4 }, { 1, 1 }, emulate_accsadubl },

  { "swapw", 0, { 2 }, { 2 }, emulate_swapw },
  { "swapl", 0, { 4 }, { 4 }, emulate_swapl },
  { "swapwl", 0, { 4 }, { 4 }, emulate_swapwl },
  { "swapq", 0, { 8 }, { 8 }, emulate_swapq },
  { "swaplq", 0, { 8 }, { 8 }, emulate_swaplq },
  { "select0wb", 0, { 1 }, { 2 }, emulate_select0wb },
  { "select1wb", 0, { 1 }, { 2 }, emulate_select1wb },
  { "select0lw", 0, { 2 }, { 4 }, emulate_select0lw },
  { "select1lw", 0, { 2 }, { 4 }, emulate_select1lw },
  { "select0ql", 0, { 4 }, { 8 }, emulate_select0ql },
  { "select1ql", 0, { 4 }, { 8 }, emulate_select1ql },
  { "mergelq", 0, { 8 }, { 4, 4 }, emulate_mergelq },
  { "mergewl", 0, { 4 }, { 2, 2 }, emulate_mergewl },
  { "mergebw", 0, { 2 }, { 1, 1 }, emulate_mergebw },
  { "splitql", 0, { 4, 4 }, { 8 }, emulate_splitql },
  { "splitlw", 0, { 2, 2 }, { 4 }, emulate_splitlw },
  { "splitwb", 0, { 1, 1 }, { 2 }, emulate_splitwb },

  /* float ops */
  { "addf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_addf },
  { "subf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_subf },
  { "mulf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_mulf },
  { "divf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_divf },
  { "sqrtf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4 }, emulate_sqrtf },
  { "maxf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_maxf },
  { "minf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 4, 4 }, emulate_minf },
  { "cmpeqf", ORC_STATIC_OPCODE_FLOAT_SRC, { 4 }, { 4, 4 }, emulate_cmpeqf },
  { "cmpltf", ORC_STATIC_OPCODE_FLOAT_SRC, { 4 }, { 4, 4 }, emulate_cmpltf },
  { "cmplef", ORC_STATIC_OPCODE_FLOAT_SRC, { 4 }, { 4, 4 }, emulate_cmplef },
  { "convfl", ORC_STATIC_OPCODE_FLOAT_SRC, { 4 }, { 4 }, emulate_convfl },
  { "convlf", ORC_STATIC_OPCODE_FLOAT_DEST, { 4 }, { 4 }, emulate_convlf },

  /* double ops */
  { "addd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_addd },
  { "subd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_subd },
  { "muld", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_muld },
  { "divd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_divd },
  { "sqrtd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8 }, emulate_sqrtd },
  { "maxd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_maxd },
  { "mind", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 8, 8 }, emulate_mind },
  { "cmpeqd", ORC_STATIC_OPCODE_FLOAT_SRC, { 8 }, { 8, 8 }, emulate_cmpeqd },
  { "cmpltd", ORC_STATIC_OPCODE_FLOAT_SRC, { 8 }, { 8, 8 }, emulate_cmpltd },
  { "cmpled", ORC_STATIC_OPCODE_FLOAT_SRC, { 8 }, { 8, 8 }, emulate_cmpled },
  { "convdl", ORC_STATIC_OPCODE_FLOAT_SRC, { 4 }, { 8 }, emulate_convdl },
  { "convld", ORC_STATIC_OPCODE_FLOAT_DEST, { 8 }, { 4 }, emulate_convld },
  { "convfd", ORC_STATIC_OPCODE_FLOAT, { 8 }, { 4 }, emulate_convfd },
  { "convdf", ORC_STATIC_OPCODE_FLOAT, { 4 }, { 8 }, emulate_convdf },

  { "" }
};

void
orc_opcode_init (void)
{
  orc_opcode_register_static (opcodes, "sys");
}


