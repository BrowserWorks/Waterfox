// |reftest| error:SyntaxError
'use strict';
// This file was procedurally generated from the following sources:
// - src/dstr-assignment/array-rest-yield-ident-invalid.case
// - src/dstr-assignment/syntax/assignment-expr.template
/*---
description: When a `yield` token appears within the DestructuringAssignmentTarget of an AssignmentRestElement and outside of a generator function body, it should behave as an IdentifierReference. (AssignmentExpression)
esid: sec-variable-statement-runtime-semantics-evaluation
es6id: 13.3.2.4
features: [destructuring-binding]
flags: [generated, onlyStrict]
negative:
  phase: early
  type: SyntaxError
info: |
    VariableDeclaration : BindingPattern Initializer

    1. Let rhs be the result of evaluating Initializer.
    2. Let rval be GetValue(rhs).
    3. ReturnIfAbrupt(rval).
    4. Return the result of performing BindingInitialization for
       BindingPattern passing rval and undefined as arguments.
---*/
var x = {};

0, [...x[yield]] = [];
