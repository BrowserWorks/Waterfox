// Copyright (c) 2014 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


/*---
esid: sec-array.prototype.concat
description: Array.prototype.concat sloppy arguments throws
features: [Symbol.isConcatSpreadable]
---*/
function MyError() {}
var args = (function(a) {
  return arguments;
})(1, 2, 3);
Object.defineProperty(args, 0, {
  get: function() {
    throw new MyError();
  }
});
args[Symbol.isConcatSpreadable] = true;
assert.throws(MyError, function() {
  return [].concat(args, args);
});

reportCompare(0, 0);
