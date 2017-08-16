// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the license found in the LICENSE file.

/*---
es5id: 11.3.3
description: >
    Tests that the object returned by
    Intl.NumberFormat.prototype.resolvedOptions  has the right
    properties.
author: Norbert Lindenberg
includes: [testIntl.js]
---*/

var actual = new Intl.NumberFormat().resolvedOptions();

var actual2 = new Intl.NumberFormat().resolvedOptions();
assert.notSameValue(actual2, actual, "resolvedOptions returned the same object twice.");

// this assumes the default values where the specification provides them
mustHaveProperty(actual, "locale", isCanonicalizedStructurallyValidLanguageTag);
mustHaveProperty(actual, "numberingSystem", isValidNumberingSystem);
mustHaveProperty(actual, "style", ["decimal"]);
mustNotHaveProperty(actual, "currency");
mustNotHaveProperty(actual, "currencyDisplay");
mustHaveProperty(actual, "minimumIntegerDigits", [1]);
mustHaveProperty(actual, "minimumFractionDigits", [0]);
mustHaveProperty(actual, "maximumFractionDigits", [3]);
mustNotHaveProperty(actual, "minimumSignificantDigits");
mustNotHaveProperty(actual, "maximumSignificantDigits");
mustHaveProperty(actual, "useGrouping", [true]);

reportCompare(0, 0);
