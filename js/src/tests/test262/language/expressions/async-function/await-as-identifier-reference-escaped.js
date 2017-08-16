// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/async-functions/await-as-identifier-reference-escaped.case
// - src/async-functions/syntax/async-expression.template
/*---
description: await is a reserved keyword within generator function bodies and may not be used as an identifier reference. (Unnamed async function expression)
esid: prod-AsyncFunctionExpression
features: [async-functions]
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    Async Function Definitions

    AsyncFunctionExpression :
      async [no LineTerminator here] function ( FormalParameters ) { AsyncFunctionBody }


    IdentifierReference : Identifier

    It is a Syntax Error if this production has a [Await] parameter and
    StringValue of Identifier is "await".

---*/


var fn = async function () {
  void \u0061wait;
};
