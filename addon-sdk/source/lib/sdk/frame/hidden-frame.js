/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

module.metadata = {
  "stability": "experimental"
};

const { Cc, Ci } = require("chrome");
const { Class } = require("../core/heritage");
const { List, addListItem, removeListItem } = require("../util/list");
const { EventTarget } = require("../event/target");
lazyRequire(this, "../event/core", "emit");
lazyRequire(this, "./utils", { "create": "makeFrame" });
lazyRequire(this, "../core/promise", "defer");
const { when: unload } = require("../system/unload");
lazyRequire(this, "../deprecated/api-utils", "validateOptions", "getTypeOf");
lazyRequire(this, "../addon/window", "window");
lazyRequire(this, "../util/array", "fromIterator");

// This cache is used to access friend properties between functions
// without exposing them on the public API.
var cache = new Set();
var elements = new WeakMap();

function contentLoaded(target) {
  var deferred = defer();
  target.addEventListener("DOMContentLoaded", function DOMContentLoaded(event) {
    // "DOMContentLoaded" events from nested frames propagate up to target,
    // ignore events unless it's DOMContentLoaded for the given target.
    if (event.target === target || event.target === target.contentDocument) {
      target.removeEventListener("DOMContentLoaded", DOMContentLoaded);
      deferred.resolve(target);
    }
  });
  return deferred.promise;
}

function FrameOptions(options) {
  options = options || {}
  return validateOptions(options, FrameOptions.validator);
}
FrameOptions.validator = {
  onReady: {
    is: ["undefined", "function", "array"],
    ok: function(v) {
      if (getTypeOf(v) === "array") {
        // make sure every item is a function
        return v.every(item => typeof(item) === "function")
      }
      return true;
    }
  },
  onUnload: {
    is: ["undefined", "function"]
  }
};

var HiddenFrame = Class({
  extends: EventTarget,
  initialize: function initialize(options) {
    options = FrameOptions(options);
    EventTarget.prototype.initialize.call(this, options);
  },
  get element() {
    return elements.get(this);
  },
  toString: function toString() {
    return "[object Frame]"
  }
});
exports.HiddenFrame = HiddenFrame

function addHidenFrame(frame) {
  if (!(frame instanceof HiddenFrame))
    throw Error("The object to be added must be a HiddenFrame.");

  // This instance was already added.
  if (cache.has(frame)) return frame;
  else cache.add(frame);

  let element = makeFrame(window.document, {
    nodeName: "iframe",
    type: "content",
    allowJavascript: true,
    allowPlugins: true,
    allowAuth: true,
  });
  elements.set(frame, element);

  contentLoaded(element).then(function onFrameReady(element) {
    emit(frame, "ready");
  }, console.exception);

  return frame;
}
exports.add = addHidenFrame

function removeHiddenFrame(frame) {
  if (!(frame instanceof HiddenFrame))
    throw Error("The object to be removed must be a HiddenFrame.");

  if (!cache.has(frame)) return;

  // Remove from cache before calling in order to avoid loop
  cache.delete(frame);
  emit(frame, "unload")
  let element = frame.element
  if (element) element.remove()
}
exports.remove = removeHiddenFrame;

unload(() => fromIterator(cache).forEach(removeHiddenFrame));
