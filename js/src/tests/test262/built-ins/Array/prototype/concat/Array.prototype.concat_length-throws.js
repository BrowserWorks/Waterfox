// Copyright (c) 2014 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


/*---
esid: sec-array.prototype.concat
description: Array.prototype.concat length throws
features: [Symbol.isConcatSpreadable]
---*/
function MyError() {}
var obj = {};
obj[Symbol.isConcatSpreadable] = true;
Object.defineProperty(obj, "length", {
  get: function() {
    throw new MyError();
  }
});

assert.throws(MyError, function() {
  [].concat(obj);
});

assert.throws(MyError, function() {
  Array.prototype.concat.call(obj, 1, 2, 3);
});

reportCompare(0, 0);
