// This file was procedurally generated from the following sources:
// - src/dstr-binding/obj-ptrn-rest-obj-nested-rest.case
// - src/dstr-binding/default/cls-expr-gen-meth-static-dflt.template
/*---
description: When DestructuringAssignmentTarget is an object literal, it should be parsed parsed as a DestructuringAssignmentPattern and evaluated as a destructuring assignment and object rest desconstruction is allowed in that case. (static class expression generator method (default parameter))
esid: sec-class-definitions-runtime-semantics-evaluation
es6id: 14.5.16
features: [object-rest, destructuring-binding, default-parameters]
flags: [generated]
includes: [propertyHelper.js]
info: |
    ClassExpression : class BindingIdentifieropt ClassTail

    1. If BindingIdentifieropt is not present, let className be undefined.
    2. Else, let className be StringValue of BindingIdentifier.
    3. Let value be the result of ClassDefinitionEvaluation of ClassTail
       with argument className.
    [...]

    14.5.14 Runtime Semantics: ClassDefinitionEvaluation

    21. For each ClassElement m in order from methods
        a. If IsStatic of m is false, then
        b. Else,
           Let status be the result of performing PropertyDefinitionEvaluation
           for m with arguments F and false.
    [...]

    14.4.13 Runtime Semantics: PropertyDefinitionEvaluation

    GeneratorMethod :
        * PropertyName ( StrictFormalParameters ) { GeneratorBody }

    1. Let propKey be the result of evaluating PropertyName.
    2. ReturnIfAbrupt(propKey).
    3. If the function code for this GeneratorMethod is strict mode code,
       let strict be true. Otherwise let strict be false.
    4. Let scope be the running execution context's LexicalEnvironment.
    5. Let closure be GeneratorFunctionCreate(Method,
       StrictFormalParameters, GeneratorBody, scope, strict).

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

var callCount = 0;
var C = class {
  static *method({a, b, ...{c, ...rest}} = {a: 1, b: 2, c: 3, d: 4, e: 5}) {
    assert.sameValue(a, 1);
    assert.sameValue(b, 2);
    assert.sameValue(c, 3);

    assert.sameValue(rest.d, 4);
    assert.sameValue(rest.e, 5);

    verifyEnumerable(rest, "d");
    verifyWritable(rest, "d");
    verifyConfigurable(rest, "d");

    verifyEnumerable(rest, "e");
    verifyWritable(rest, "e");
    verifyConfigurable(rest, "e");

    callCount = callCount + 1;
  }
};

C.method().next();
assert.sameValue(callCount, 1, 'method invoked exactly once');

reportCompare(0, 0);
