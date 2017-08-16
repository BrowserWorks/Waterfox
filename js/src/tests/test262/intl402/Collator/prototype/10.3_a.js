// Copyright 2012 Google Inc.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 10.3_a
description: >
    Tests that Intl.Collator.prototype is an object that  has been
    initialized as an Intl.Collator.
---*/

// test by calling a function that would fail if "this" were not an object
// initialized as an Intl.Collator
assert.sameValue(Intl.Collator.prototype.compare("aаあ아", "aаあ아"), 0, "Intl.Collator.prototype is not an object that has been initialized as an Intl.Collator.");

reportCompare(0, 0);
