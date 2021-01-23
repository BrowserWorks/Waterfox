// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The [[Class]] property of the newly constructed object
    is set to "Date"
esid: sec-date-year-month-date-hours-minutes-seconds-ms
description: >
    Test based on delete prototype.toString - 2 arguments, (year,
    month)
---*/

var x1 = new Date(1899, 11);
if (Object.prototype.toString.call(x1) !== "[object Date]") {
  $ERROR("#1: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x2 = new Date(1899, 12);
if (Object.prototype.toString.call(x2) !== "[object Date]") {
  $ERROR("#2: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x3 = new Date(1900, 0);
if (Object.prototype.toString.call(x3) !== "[object Date]") {
  $ERROR("#3: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x4 = new Date(1969, 11);
if (Object.prototype.toString.call(x4) !== "[object Date]") {
  $ERROR("#4: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x5 = new Date(1969, 12);
if (Object.prototype.toString.call(x5) !== "[object Date]") {
  $ERROR("#5: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x6 = new Date(1970, 0);
if (Object.prototype.toString.call(x6) !== "[object Date]") {
  $ERROR("#6: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x7 = new Date(1999, 11);
if (Object.prototype.toString.call(x7) !== "[object Date]") {
  $ERROR("#7: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x8 = new Date(1999, 12);
if (Object.prototype.toString.call(x8) !== "[object Date]") {
  $ERROR("#8: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x9 = new Date(2000, 0);
if (Object.prototype.toString.call(x9) !== "[object Date]") {
  $ERROR("#9: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x10 = new Date(2099, 11);
if (Object.prototype.toString.call(x10) !== "[object Date]") {
  $ERROR("#10: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x11 = new Date(2099, 12);
if (Object.prototype.toString.call(x11) !== "[object Date]") {
  $ERROR("#11: The [[Class]] property of the newly constructed object is set to 'Date'");
}

var x12 = new Date(2100, 0);
if (Object.prototype.toString.call(x12) !== "[object Date]") {
  $ERROR("#12: The [[Class]] property of the newly constructed object is set to 'Date'");
}

reportCompare(0, 0);
