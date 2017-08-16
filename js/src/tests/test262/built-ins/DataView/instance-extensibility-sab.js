// |reftest| skip-if(!this.hasOwnProperty('SharedArrayBuffer')) -- SharedArrayBuffer not yet riding the trains
// Copyright (C) 2016 the V8 project authors. All rights reserved.
// Copyright (C) 2017 Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es6id: 24.2.2.1
esid: sec-dataview-buffer-byteoffset-bytelength
description: >
  The new instance is extensible
info: |
  24.2.2.1 DataView (buffer, byteOffset, byteLength )

  ...
  12. Let O be ? OrdinaryCreateFromConstructor(NewTarget, "%DataViewPrototype%",
  « [[DataView]], [[ViewedArrayBuffer]], [[ByteLength]], [[ByteOffset]] »).
  ...
  17. Return O.

  9.1.13 OrdinaryCreateFromConstructor ( constructor, intrinsicDefaultProto [ ,
  internalSlotsList ] )

  ...
  3. Return ObjectCreate(proto, internalSlotsList).

  9.1.12 ObjectCreate (proto [ , internalSlotsList ])

  ...
  5. Set the [[Extensible]] internal slot of obj to true.
  ...
features: [SharedArrayBuffer]
---*/

var buffer = new SharedArrayBuffer(8);
var sample = new DataView(buffer, 0);

assert(Object.isExtensible(sample));

reportCompare(0, 0);
