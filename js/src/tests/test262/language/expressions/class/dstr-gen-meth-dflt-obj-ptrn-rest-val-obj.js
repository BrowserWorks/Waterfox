// This file was procedurally generated from the following sources:
// - src/dstr-binding/obj-ptrn-rest-val-obj.case
// - src/dstr-binding/default/cls-expr-gen-meth-dflt.template
/*---
description: Rest object contains just unextracted data (class expression method (default parameter))
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
           i. Let status be the result of performing
              PropertyDefinitionEvaluation for m with arguments proto and
              false.
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
  *method({a, b, ...rest} = {x: 1, y: 2, a: 5, b: 3}) {
    assert.sameValue(rest.x, 1);
    assert.sameValue(rest.y, 2);
    assert.sameValue(rest.a, undefined);
    assert.sameValue(rest.b, undefined);

    verifyEnumerable(rest, "x");
    verifyWritable(rest, "x");
    verifyConfigurable(rest, "x");

    verifyEnumerable(rest, "y");
    verifyWritable(rest, "y");
    verifyConfigurable(rest, "y");

    callCount = callCount + 1;
  }
};

new C().method().next();
assert.sameValue(callCount, 1, 'method invoked exactly once');

reportCompare(0, 0);
