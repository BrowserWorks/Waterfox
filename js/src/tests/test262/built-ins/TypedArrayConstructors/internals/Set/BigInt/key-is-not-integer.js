// Copyright (C) 2016 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-integer-indexed-exotic-objects-set-p-v-receiver
description: >
  Returns false if index is not integer
info: |
  9.4.5.5 [[Set]] ( P, V, Receiver)

  ...
  2. If Type(P) is String, then
    a. Let numericIndex be ! CanonicalNumericIndexString(P).
    b. If numericIndex is not undefined, then
      i. Return ? IntegerIndexedElementSet(O, numericIndex, V).
  ...

  9.4.5.9 IntegerIndexedElementSet ( O, index, value )

  ...
  6. If IsInteger(index) is false, return false.
  ...
includes: [testBigIntTypedArray.js]
features: [BigInt, Reflect, TypedArray]
---*/

testWithBigIntTypedArrayConstructors(function(TA) {
  var sample = new TA([42n]);

  assert.sameValue(Reflect.set(sample, "1.1", 1n), false, "1.1");
  assert.sameValue(Reflect.set(sample, "0.0001", 1n), false, "0.0001");

  assert.sameValue(sample.hasOwnProperty("1.1"), false, "has no property [1.1]");
  assert.sameValue(
    sample.hasOwnProperty("0.0001"),
    false,
    "has no property [0.0001]"
  );
});

reportCompare(0, 0);
