// Copyright (C) 2019 Leo Balter. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
esid: sec-Intl.DisplayNames
description: >
  Random options are not checked or used, including case sensitive
info: |
  Intl.DisplayNames ([ locales [ , options ]])

  1. If NewTarget is undefined, throw a TypeError exception.
  2. Let displayNames be ? OrdinaryCreateFromConstructor(NewTarget, "%DisplayNamesPrototype%",
    « [[InitializedDisplayNames]], [[Locale]], [[Style]], [[Type]], [[Fallback]], [[Fields]] »).
  ...
  4. If options is undefined, then
    a. Let options be ObjectCreate(null).
  5. Else
    a. Let options be ? ToObject(options).
  ...
  8. Let matcher be ? GetOption(options, "localeMatcher", "string", « "lookup", "best fit" », "best fit").
  ...
  11. Let style be ? GetOption(options, "style", "string", « "narrow", "short", "long" », "long").
  ...
  13. Let type be ? GetOption(options, "type", "string", « "language", "region", "script", "currency", "weekday", "month", "quarter", "dayPeriod", "dateTimeField" », "language").
  ...
  15. Let fallback be ? GetOption(options, "fallback", "string", « "code", "none" », "code").
  ...

  GetOption ( options, property, type, values, fallback )

  1. Let value be ? Get(options, property).
  ...
features: [Intl.DisplayNames]
locale: [en]
---*/

var options = {};
Object.defineProperty(options, 'fallBack', {
  get() { throw new Test262Error(); }
});
Object.defineProperty(options, 'localematcher', {
  get() { throw new Test262Error(); }
});
Object.defineProperty(options, 'locale-matcher', {
  get() { throw new Test262Error(); }
});
Object.defineProperty(options, 'Type', {
  get() { throw new Test262Error(); }
});

var obj = new Intl.DisplayNames('en', options);

assert(obj instanceof Intl.DisplayNames);
assert.sameValue(Object.getPrototypeOf(obj), Intl.DisplayNames.prototype);

reportCompare(0, 0);
