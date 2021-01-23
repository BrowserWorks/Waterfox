// |reftest| skip-if(release_or_beta) -- AggregateError is not released yet
// Copyright (C) 2019 Leo Balter. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-get-aggregate-error.prototype.errors
description: >
  "errors" property of AggregateError.prototype
info: |
  AggregateError.prototype.errors is an accessor property whose set accessor
  function is undefined.

  Section 17: Every accessor property described in clauses 18 through 26 and in
  Annex B.2 has the attributes {[[Enumerable]]: false, [[Configurable]]: true }
includes: [propertyHelper.js]
features: [AggregateError]
---*/

var desc = Object.getOwnPropertyDescriptor(AggregateError.prototype, 'errors');

assert.sameValue(desc.set, undefined);
assert.sameValue(typeof desc.get, 'function');

verifyProperty(AggregateError.prototype, 'errors', {
  enumerable: false,
  configurable: true
});

reportCompare(0, 0);
