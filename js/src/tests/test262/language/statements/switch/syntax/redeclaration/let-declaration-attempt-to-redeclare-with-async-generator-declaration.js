// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-async-generator-declaration.case
// - src/declarations/redeclare/switch-attempt-to-redeclare-let-declaration.template
/*---
description: redeclaration with AsyncGeneratorDeclaration (LexicalDeclaration (let) in SwitchStatement)
esid: sec-switch-statement-static-semantics-early-errors
features: [async-iteration]
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    SwitchStatement : switch ( Expression ) CaseBlock

    It is a Syntax Error if the LexicallyDeclaredNames of CaseBlock contains any
    duplicate entries.

---*/


switch (0) { case 1: let f; default: async function* f() {} }
