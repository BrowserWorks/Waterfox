// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-var-declaration.case
// - src/declarations/redeclare-allow-var/block-attempt-to-redeclare-async-generator-declaration.template
/*---
description: redeclaration with VariableDeclaration (AsyncGeneratorDeclaration in BlockStatement)
esid: sec-block-static-semantics-early-errors
features: [async-iteration]
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    Block : { StatementList }

    It is a Syntax Error if any element of the LexicallyDeclaredNames of
    StatementList also occurs in the VarDeclaredNames of StatementList.

---*/


{ async function* f() {} var f; }
