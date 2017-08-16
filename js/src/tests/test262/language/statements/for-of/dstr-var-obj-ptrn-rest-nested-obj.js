// This file was procedurally generated from the following sources:
// - src/dstr-binding/obj-ptrn-rest-nested-obj.case
// - src/dstr-binding/default/for-of-var.template
/*---
description: When DestructuringAssignmentTarget is an object literal, it should be parsed parsed as a DestructuringAssignmentPattern and evaluated as a destructuring assignment. (for-of statement)
esid: sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation
es6id: 13.7.5.11
features: [object-rest, destructuring-binding]
flags: [generated]
info: |
    IterationStatement :
        for ( var ForBinding of AssignmentExpression ) Statement

    [...]
    3. Return ForIn/OfBodyEvaluation(ForBinding, Statement, keyResult,
       varBinding, labelSet).

    13.7.5.13 Runtime Semantics: ForIn/OfBodyEvaluation

    [...]
    3. Let destructuring be IsDestructuring of lhs.
    [...]
    5. Repeat
       [...]
       h. If destructuring is false, then
          [...]
       i. Else
          i. If lhsKind is assignment, then
             [...]
          ii. Else if lhsKind is varBinding, then
              1. Assert: lhs is a ForBinding.
              2. Let status be the result of performing BindingInitialization
                 for lhs passing nextValue and undefined as the arguments.
          [...]
---*/
var obj = {a: 3, b: 4};

var iterCount = 0;

for (var {a, b, ...{c, e}} of [{a: 1, b: 2, c: 3, d: 4, e: 5}]) {
  assert.sameValue(a, 1);
  assert.sameValue(b, 2);
  assert.sameValue(c, 3);
  assert.sameValue(e, 5);


  iterCount += 1;
}

assert.sameValue(iterCount, 1, 'Iteration occurred as expected');

reportCompare(0, 0);
