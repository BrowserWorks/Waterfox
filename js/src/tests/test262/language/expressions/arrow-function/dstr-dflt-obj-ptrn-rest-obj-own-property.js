// This file was procedurally generated from the following sources:
// - src/dstr-binding/obj-ptrn-rest-obj-own-property.case
// - src/dstr-binding/default/arrow-function-dflt.template
/*---
description: Rest object contains just soruce object's own properties (arrow function expression (default parameter))
esid: sec-arrow-function-definitions-runtime-semantics-evaluation
es6id: 14.2.16
features: [object-rest, destructuring-binding, default-parameters]
flags: [generated]
includes: [propertyHelper.js]
info: |
    ArrowFunction : ArrowParameters => ConciseBody

    [...]
    4. Let closure be FunctionCreate(Arrow, parameters, ConciseBody, scope, strict).
    [...]

    9.2.1 [[Call]] ( thisArgument, argumentsList)

    [...]
    7. Let result be OrdinaryCallEvaluateBody(F, argumentsList).
    [...]

    9.2.1.3 OrdinaryCallEvaluateBody ( F, argumentsList )

    1. Let status be FunctionDeclarationInstantiation(F, argumentsList).
    [...]

    9.2.12 FunctionDeclarationInstantiation(func, argumentsList)

    [...]
    23. Let iteratorRecord be Record {[[iterator]]:
        CreateListIterator(argumentsList), [[done]]: false}.
    24. If hasDuplicates is true, then
        [...]
    25. Else,
        b. Let formalStatus be IteratorBindingInitialization for formals with
           iteratorRecord and env as arguments.
    [...]
---*/
var o = Object.create({ x: 1, y: 2 });
o.z = 3;

var callCount = 0;
var f;
f = ({ x, ...{y , z} } = o) => {
  assert.sameValue(x, 1);
  assert.sameValue(y, undefined);
  assert.sameValue(z, 3);

  callCount = callCount + 1;
};

f();
assert.sameValue(callCount, 1, 'arrow function invoked exactly once');

reportCompare(0, 0);
