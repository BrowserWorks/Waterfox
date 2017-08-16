// This file was procedurally generated from the following sources:
// - src/dstr-binding/obj-ptrn-rest-nested-obj.case
// - src/dstr-binding/default/for-var.template
/*---
description: When DestructuringAssignmentTarget is an object literal, it should be parsed parsed as a DestructuringAssignmentPattern and evaluated as a destructuring assignment. (for statement)
esid: sec-for-statement-runtime-semantics-labelledevaluation
es6id: 13.7.4.7
features: [object-rest, destructuring-binding]
flags: [generated]
info: |
    IterationStatement :
        for ( var VariableDeclarationList ; Expressionopt ; Expressionopt ) Statement

    1. Let varDcl be the result of evaluating VariableDeclarationList.
    [...]

    13.3.2.4 Runtime Semantics: Evaluation

    VariableDeclarationList : VariableDeclarationList , VariableDeclaration

    1. Let next be the result of evaluating VariableDeclarationList.
    2. ReturnIfAbrupt(next).
    3. Return the result of evaluating VariableDeclaration.

    VariableDeclaration : BindingPattern Initializer

    1. Let rhs be the result of evaluating Initializer.
    2. Let rval be GetValue(rhs).
    3. ReturnIfAbrupt(rval).
    4. Return the result of performing BindingInitialization for BindingPattern
       passing rval and undefined as arguments.
---*/
var obj = {a: 3, b: 4};

var iterCount = 0;

for (var {a, b, ...{c, e}} = {a: 1, b: 2, c: 3, d: 4, e: 5}; iterCount < 1; ) {
  assert.sameValue(a, 1);
  assert.sameValue(b, 2);
  assert.sameValue(c, 3);
  assert.sameValue(e, 5);

  iterCount += 1;
}

assert.sameValue(iterCount, 1, 'Iteration occurred as expected');

reportCompare(0, 0);
