// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-function-declaration.case
// - src/declarations/redeclare-allow-sloppy-function/block-attempt-to-redeclare-generator-declaration.template
/*---
description: redeclaration with FunctionDeclaration (GeneratorDeclaration in BlockStatement)
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


{ function* f() {} function f() {} }
