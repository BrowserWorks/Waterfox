// Copyright (C) 2018 Valerie Young. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-typedarray-object
description: >
  Behavior for input array of Strings, successful conversion
info: |
  22.2.4.4 TypedArray ( object )

  This description applies only if the TypedArray function is called with at
  least one argument and the Type of the first argument is Object and that
  object does not have either a [[TypedArrayName]] or an [[ArrayBufferData]]
  internal slot.

  ...
  8. Repeat, while k < len
    ...
    b. Let kValue be ? Get(arrayLike, Pk).
    c. Perform ? Set(O, Pk, kValue, true).
  ...

  9.4.5.5 [[Set]] ( P, V, Receiver)

  ...
  2. If Type(P) is String and if SameValue(O, Receiver) is true, then
    a. Let numericIndex be ! CanonicalNumericIndexString(P).
    b. If numericIndex is not undefined, then
      i. Return ? IntegerIndexedElementSet(O, numericIndex, V).
  ...

  9.4.5.9 IntegerIndexedElementSet ( O, index, value )

  ...
  5. If arrayTypeName is "BigUint64Array" or "BigInt64Array",
     let numValue be ? ToBigInt(value).
  ...

  ToBigInt ( argument )

  Object, Apply the following steps:
    1. Let prim be ? ToPrimitive(argument, hint Number).
    2. Return the value that prim corresponds to in Table [BigInt Conversions]

  BigInt Conversions
    Argument Type: String
    Result:
      1. Let n be StringToBigInt(prim).
      2. If n is NaN, throw a SyntaxError exception.
      3. Return n.

includes: [testBigIntTypedArray.js]
features: [BigInt, TypedArray]
---*/

testWithBigIntTypedArrayConstructors(function(TA) {
  var typedArray = new TA(['', '1']);

  assert.sameValue(typedArray[0], 0n);
  assert.sameValue(typedArray[1], 1n);

  assert.throws(SyntaxError, function() {
    new TA(["1n"]);
  }, "A StringNumericLiteral may not include a BigIntLiteralSuffix.");

  assert.throws(SyntaxError, function() {
    new TA(["Infinity"]);
  }, "Replace the StrUnsignedDecimalLiteral production with DecimalDigits to not allow Infinity..");

  assert.throws(SyntaxError, function() {
    new TA(["1.1"]);
  }, "Replace the StrUnsignedDecimalLiteral production with DecimalDigits to not allow... decimal points...");

  assert.throws(SyntaxError, function() {
    new TA(["1e7"]);
  }, "Replace the StrUnsignedDecimalLiteral production with DecimalDigits to not allow... exponents...");

});

reportCompare(0, 0);
