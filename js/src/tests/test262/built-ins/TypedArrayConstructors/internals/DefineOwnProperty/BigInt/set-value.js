// Copyright (C) 2016 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-integer-indexed-exotic-objects-defineownproperty-p-desc
description: >
  Set the value and return true
info: |
  9.4.5.3 [[DefineOwnProperty]] ( P, Desc)
  ...
  3. If Type(P) is String, then
    a. Let numericIndex be ! CanonicalNumericIndexString(P).
    b. If numericIndex is not undefined, then
      ...
      xi. If Desc has a [[Value]] field, then
        1. Let value be Desc.[[Value]].
        2. Return ? IntegerIndexedElementSet(O, intIndex, value).
  ...

  9.4.5.9 IntegerIndexedElementSet ( O, index, value )

  ...
  15. Perform SetValueInBuffer(buffer, indexedPosition, elementType, numValue).
  16. Return true.
includes: [testBigIntTypedArray.js]
features: [BigInt, Reflect, TypedArray]
---*/

testWithBigIntTypedArrayConstructors(function(TA) {
  var sample = new TA([0n, 0n]);

  assert.sameValue(
    Reflect.defineProperty(sample, "0", {value: 1n}),
    true,
    "set value for sample[0] returns true"
  );

  assert.sameValue(
    Reflect.defineProperty(sample, "1", {value: 2n}),
    true,
    "set value for sample[1] returns true"
  );

  assert.sameValue(sample[0], 1n, "sample[0]");
  assert.sameValue(sample[1], 2n, "sample[1]");
});

reportCompare(0, 0);
