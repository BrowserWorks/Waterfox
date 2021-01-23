// Copyright 2015 Microsoft Corporation. All rights reserved.
// This code is governed by the license found in the LICENSE file.

/*---
description: Passing a valid array
esid: sec-array.from
---*/

var array = [0, 'foo', , Infinity];
var result = Array.from(array);

assert.sameValue(result.length, 4, 'result.length');
assert.sameValue(result[0], 0, 'result[0]');
assert.sameValue(result[1], 'foo', 'result[1]');
assert.sameValue(result[2], undefined, 'result[2]');
assert.sameValue(result[3], Infinity, 'result[3]');

assert.notSameValue(
  result, array,
  'result is not the object from items argument'
);

assert(result instanceof Array, 'result instanceof Array');

reportCompare(0, 0);
