// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-var-declaration.case
// - src/declarations/redeclare-allow-var/switch-attempt-to-redeclare-async-generator-declaration.template
/*---
description: redeclaration with VariableDeclaration (AsyncGeneratorDeclaration in SwitchStatement)
esid: sec-switch-statement-static-semantics-early-errors
features: [async-iteration]
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    SwitchStatement : switch ( Expression ) CaseBlock

    It is a Syntax Error if any element of the LexicallyDeclaredNames of
    CaseBlock also occurs in the VarDeclaredNames of CaseBlock.

---*/


switch (0) { case 1: async function* f() {} default: var f; }
