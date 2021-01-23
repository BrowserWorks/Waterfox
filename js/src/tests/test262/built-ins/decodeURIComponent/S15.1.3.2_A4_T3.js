// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: URI tests
esid: sec-decodeuricomponent-encodeduricomponent
description: Checking URL with Line Terminator
---*/

//CHECK#1
if (decodeURIComponent("http://unipro.ru/%0Aabout") !== "http://unipro.ru/\nabout") {
  $ERROR('#1: http://unipro.ru/%A0about');
}

//CHECK#2
if (decodeURIComponent("http://unipro.ru/%0Babout") !== "http://unipro.ru/\vabout") {
  $ERROR('#2: http://unipro.ru/%0Babout');
}

//CHECK#3
if (decodeURIComponent("http://unipro.ru/%0Cabout") !== "http://unipro.ru/\fabout") {
  $ERROR('#3: http://unipro.ru/%0Cabout');
}

//CHECK#4
if (decodeURIComponent("http://unipro.ru/%0Dabout") !== "http://unipro.ru/\rabout") {
  $ERROR('#4: http://unipro.ru/%0Dabout');
}

reportCompare(0, 0);
