// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
// This file was procedurally generated from the following sources:
// - src/declarations/redeclare-with-async-generator-declaration.case
// - src/declarations/redeclare/block-attempt-to-redeclare-generator-declaration.template
/*---
description: redeclaration with AsyncGeneratorDeclaration (GeneratorDeclaration in BlockStatement)
esid: sec-block-static-semantics-early-errors
features: [async-iteration]
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    Block : { StatementList }

    It is a Syntax Error if the LexicallyDeclaredNames of StatementList contains
    any duplicate entries.

---*/


{ function* f() {} async function* f() {} }
