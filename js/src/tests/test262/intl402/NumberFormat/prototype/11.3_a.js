// Copyright 2012 Google Inc.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 11.3_a
description: >
    Tests that Intl.NumberFormat.prototype is an object that  has been
    initialized as an Intl.NumberFormat.
author: Roozbeh Pournader
---*/

// test by calling a function that would fail if "this" were not an object
// initialized as an Intl.NumberFormat
assert.sameValue(typeof Intl.NumberFormat.prototype.format(0), "string", "Intl.NumberFormat's prototype is not an object that has been initialized as an Intl.NumberFormat");

reportCompare(0, 0);
