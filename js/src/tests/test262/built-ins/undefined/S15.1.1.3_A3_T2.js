// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The undefined is DontDelete
esid: sec-undefined
description: Use delete
flags: [noStrict]
---*/

// CHECK#1
if (delete undefined !== false) {
  $ERROR('#1: delete undefined === false. Actual: ' + (delete undefined));
}

reportCompare(0, 0);
