// |reftest| skip-if(release_or_beta) -- async-iteration is not released yet
// This file was procedurally generated from the following sources:
// - src/arguments/args-trailing-comma-multiple.case
// - src/arguments/default/async-gen-named-func-expr.template
/*---
description: A trailing comma should not increase the arguments.length, using multiple args (async generator named function expression)
esid: sec-asyncgenerator-definitions-evaluation
features: [async-iteration]
flags: [generated, async]
info: |
    AsyncGeneratorExpression : async [no LineTerminator here] function * BindingIdentifier
        ( FormalParameters ) { AsyncGeneratorBody }

        [...]
        7. Let closure be ! AsyncGeneratorFunctionCreate(Normal, FormalParameters,
           AsyncGeneratorBody, funcEnv, strict).
        [...]


    Trailing comma in the arguments list

    12.3 Left-Hand-Side Expressions

    Arguments[Yield, Await] : ( ArgumentList[?Yield, ?Await] , )
---*/


var callCount = 0;
// Stores a reference `ref` for case evaluation
var ref;
ref = async function* g() {
  assert.sameValue(arguments.length, 2);
  assert.sameValue(arguments[0], 42);
  assert.sameValue(arguments[1], 'TC39');
  callCount = callCount + 1;
};

ref(42, 'TC39',).next().then(() => {
    assert.sameValue(callCount, 1, 'generator function invoked exactly once');
}).then($DONE, $DONE);
