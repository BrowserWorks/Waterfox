// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-function-declaration.case
// - src/declarations/redeclare-allow-sloppy-function/switch-attempt-to-redeclare-class-declaration.template
/*---
description: redeclaration with FunctionDeclaration (ClassDeclaration in SwitchStatement)
esid: sec-switch-statement-static-semantics-early-errors
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    SwitchStatement : switch ( Expression ) CaseBlock

    It is a Syntax Error if the LexicallyDeclaredNames of CaseBlock contains any
    duplicate entries.

---*/


switch (0) { case 1: class f {} default: function f() {} }
