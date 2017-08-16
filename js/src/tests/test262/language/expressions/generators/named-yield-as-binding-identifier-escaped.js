// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/generators/yield-as-binding-identifier-escaped.case
// - src/generators/syntax/expression-named.template
/*---
description: yield is a reserved keyword within generator function bodies and may not be used as a binding identifier. (Named generator expression)
esid: prod-GeneratorExpression
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    14.4 Generator Function Definitions

    GeneratorExpression:
      function * BindingIdentifier opt ( FormalParameters ) { GeneratorBody }

    BindingIdentifier : Identifier

    It is a Syntax Error if this production has a [Yield] parameter and
    StringValue of Identifier is "yield".

---*/

var gen = function *g() {
  var yi\u0065ld;
};
