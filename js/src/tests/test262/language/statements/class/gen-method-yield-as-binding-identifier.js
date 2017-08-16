// |reftest| error:SyntaxError
// This file was procedurally generated from the following sources:
// - src/generators/yield-as-binding-identifier.case
// - src/generators/syntax/class-decl-method.template
/*---
description: yield is a reserved keyword within generator function bodies and may not be used as a binding identifier. (Generator method as a ClassDeclaration element)
esid: prod-GeneratorMethod
flags: [generated]
negative:
  phase: early
  type: SyntaxError
info: |
    ClassElement :
      MethodDefinition

    MethodDefinition :
      GeneratorMethod

    14.4 Generator Function Definitions

    GeneratorMethod :
      * PropertyName ( UniqueFormalParameters ) { GeneratorBody }

    BindingIdentifier : Identifier

    It is a Syntax Error if this production has a [Yield] parameter and
    StringValue of Identifier is "yield".

---*/

class C { *gen() {
    var yield;
}}
