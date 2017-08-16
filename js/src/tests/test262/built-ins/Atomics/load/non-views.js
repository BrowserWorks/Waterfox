// Copyright (C) 2017 Mozilla Corporation.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
description: >
  Test Atomics.load on view values other than TypedArrays
includes: [testAtomics.js]
---*/

testWithAtomicsNonViewValues(function(view) {
    assert.throws(TypeError, (() => Atomics.load(view, 0)));
});

reportCompare(0, 0);
