// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 12.1.1_1
description: >
    Tests that the this-value is ignored in DateTimeFormat, if the this-value
    isn't a DateTimeFormat instance.
author: Norbert Lindenberg
includes: [testIntl.js]
---*/

testWithIntlConstructors(function (Constructor) {
    if (Constructor === Intl.DateTimeFormat)
        return true;

    var obj, newObj;

    // variant 1: use constructor in a "new" expression
    obj = new Constructor();
    newObj = Intl.DateTimeFormat.call(obj);
    assert.notSameValue(obj, newObj, "DateTimeFormat object created with \"new\" was not ignored as this-value.");

    // variant 2: use constructor as a function
    obj = Constructor();
    newObj = Intl.DateTimeFormat.call(obj);
    assert.notSameValue(obj, newObj, "DateTimeFormat object created with constructor as function was not ignored as this-value.");

    return true;
});

reportCompare(0, 0);
