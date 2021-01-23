// |reftest| skip-if(!this.hasOwnProperty('Atomics')) -- Atomics is not enabled unconditionally
// Copyright (C) 2018 Rick Waldron. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-atomics.store
description: >
  Test Atomics.store on non-shared integer TypedArrays
includes: [testBigIntTypedArray.js]
features: [ArrayBuffer, arrow-function, Atomics, BigInt, TypedArray]
---*/
const buffer = new ArrayBuffer(BigInt64Array.BYTES_PER_ELEMENT * 2);

testWithBigIntTypedArrayConstructors(function(TA) {
  assert.throws(TypeError, function() {
    Atomics.store(new TA(buffer), 0, 0n);
  }, '`Atomics.store(new TA(buffer), 0, 0n)` throws TypeError');
});

reportCompare(0, 0);
