// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-const-declaration.case
// - src/declarations/redeclare/block-attempt-to-redeclare-let-declaration.template
/*---
description: redeclaration with const-LexicalDeclaration (LexicalDeclaration (let) in BlockStatement)
esid: sec-block-static-semantics-early-errors
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    Block : { StatementList }

    It is a Syntax Error if the LexicallyDeclaredNames of StatementList contains
    any duplicate entries.

---*/


{ let f; const f = 0; }
