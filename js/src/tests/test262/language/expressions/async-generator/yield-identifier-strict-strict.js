// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
'use strict';
// This file was procedurally generated from the following sources:
// - src/async-generators/yield-identifier-strict.case
// - src/async-generators/default/async-expression.template
/*---
description: It's an early error if the generator body has another function body with yield as an identifier in strict mode. (Unnamed async generator expression)
esid: prod-AsyncGeneratorExpression
features: [async-iteration]
flags: [generated, onlyStrict]
negative:
  phase: early
  type: SyntaxError
info: |
    Async Generator Function Definitions

    AsyncGeneratorExpression :
      async [no LineTerminator here] function * BindingIdentifier ( FormalParameters ) {
        AsyncGeneratorBody }

---*/


var callCount = 0;

var gen = async function *() {
  callCount += 1;
  (function() {
      var yield;
      throw new Test262Error();
    }())
};

var iter = gen();



assert.sameValue(callCount, 1);
