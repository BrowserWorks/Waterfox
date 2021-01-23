// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: URI tests
esid: sec-decodeuri-encodeduri
description: Test some url
---*/

//CHECK#1
if (decodeURI("") !== "") {
  $ERROR('#1: ""');
}

//CHECK#2
if (decodeURI("http:%2f%2Funipro.ru") !== "http:%2f%2Funipro.ru") {
  $ERROR('#2: http:%2f%2Funipro.ru');
}

//CHECK#3
if (decodeURI("http://www.google.ru/support/jobs/bin/static.py%3Fpage%3dwhy-ru.html%26sid%3Dliveandwork") !== "http://www.google.ru/support/jobs/bin/static.py%3Fpage%3dwhy-ru.html%26sid%3Dliveandwork") {
  $ERROR('#3: http://www.google.ru/support/jobs/bin/static.py%3Fpage%3dwhy-ru.html%26sid%3Dliveandwork"');
}

//CHECK%234
if (decodeURI("http://en.wikipedia.org/wiki/UTF-8%23Description") !== "http://en.wikipedia.org/wiki/UTF-8%23Description") {
  $ERROR('%234: http://en.wikipedia.org/wiki/UTF-8%23Description');
}

reportCompare(0, 0);
