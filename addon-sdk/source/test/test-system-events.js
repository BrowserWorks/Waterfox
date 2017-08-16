/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const events = require("sdk/system/events");
const self = require("sdk/self");
const { Cc, Ci, Cu } = require("chrome");
const { setTimeout } = require("sdk/timers");
const { Loader, LoaderWithHookedConsole2 } = require("sdk/test/loader");
const nsIObserverService = Cc["@mozilla.org/observer-service;1"].
                           getService(Ci.nsIObserverService);

var isConsoleEvent = (topic) =>
  !!~["console-api-log-event", "console-storage-cache-event"].indexOf(topic)

exports["test basic"] = function(assert) {
  let type = Date.now().toString(32);

  let timesCalled = 0;
  function handler({subject, data}) { timesCalled++; };

  events.on(type, handler);
  events.emit(type, { data: "yo yo" });

  assert.equal(timesCalled, 1, "event handler was called");

  events.off(type, handler);
  events.emit(type, { data: "no way" });

  assert.equal(timesCalled, 1, "removed handler is no longer called");

  events.once(type, handler);
  events.emit(type, { data: "and we meet again" });
  events.emit(type, { data: "it's always hard to say bye" });

  assert.equal(timesCalled, 2, "handlers added via once are triggered once");
}

exports["test simple argument passing"] = function (assert) {
  let type = Date.now().toString(32);

  let lastArg;
  function handler({data}) { lastArg = data; }
  events.on(type, handler);

  [true, false, 100, 0, 'a string', ''].forEach(arg => {
    events.emit(type, arg);
    assert.strictEqual(lastArg, arg + '',
      'event emitted for ' + arg + ' has correct data value');

    events.emit(type, { data: arg });
    assert.strictEqual(lastArg, arg + '',
      'event emitted for ' + arg + ' has correct data value when a property on an object');
  });

  [null, undefined, {}].forEach(arg => {
    events.emit(type, arg);
    assert.strictEqual(lastArg, null,
      'emitting ' + arg + ' gets null data');
  });

  events.off(type, handler);
};

exports["test error reporting"] = function(assert) {
  let { loader, messages } = LoaderWithHookedConsole2(module);

  let events = loader.require("sdk/system/events");
  function brokenHandler(subject, data) { throw new Error("foo"); };

  let lineNumber;
  try { brokenHandler() } catch (error) { lineNumber = error.lineNumber }

  let errorType = Date.now().toString(32);

  events.on(errorType, brokenHandler);
  events.emit(errorType, { data: "yo yo" });

  assert.equal(messages.length, 2, "Got an exception");
  assert.equal(messages[0], "console.error: " + self.name + ": \n",
               "error is logged");
  let text = messages[1];
  assert.ok(text.indexOf("Error: foo") >= 0, "error message is logged");
  assert.ok(text.indexOf(module.uri) >= 0, "module uri is logged");
  assert.ok(text.indexOf(lineNumber) >= 0, "error line is logged");

  events.off(errorType, brokenHandler);

  loader.unload();
};

exports["test listeners are GC-ed"] = function(assert, done) {
  let receivedFromWeak = [];
  let receivedFromStrong = [];
  let loader = Loader(module);
  let events = loader.require('sdk/system/events');

  let type = 'test-listeners-are-garbage-collected';
  function handler(event) { receivedFromStrong.push(event); }
  function weakHandler(event) { receivedFromWeak.push(event); }

  events.on(type, handler, true);
  events.on(type, weakHandler);

  events.emit(type, { data: 1 });
  assert.equal(receivedFromStrong.length, 1, "strong listener invoked");
  assert.equal(receivedFromWeak.length, 1, "weak listener invoked");

  handler = weakHandler = null;

  Cu.schedulePreciseGC(function() {
    events.emit(type, { data: 2 });

    assert.equal(receivedFromWeak.length, 1, "weak listener was GC-ed");
    assert.equal(receivedFromStrong.length, 2, "strong listener was invoked");

    loader.unload();
    done();
  });
};

exports["test alive listeners are removed on unload"] = function*(assert) {
  let receivedFromWeak = [];
  let receivedFromStrong = [];
  let loader = Loader(module);
  let events = loader.require('sdk/system/events');

  let type = 'test-alive-listeners-are-removed';
  const handler = (event) => receivedFromStrong.push(event);
  const weakHandler = (event) => receivedFromWeak.push(event);

  events.on(type, handler, true);
  events.on(type, weakHandler);

  events.emit(type, { data: 1 });
  assert.equal(receivedFromStrong.length, 1, "strong listener invoked");
  assert.equal(receivedFromWeak.length, 1, "weak listener invoked");

  loader.unload();
  // Give the cleanup code a chance to run.
  yield Promise.resolve();
  events.emit(type, { data: 2 });

  assert.equal(receivedFromWeak.length, 1, "weak listener was removed");
  assert.equal(receivedFromStrong.length, 1, "strong listener was removed");
};

exports["test handle nsIObserverService notifications"] = function(assert) {
  let ios = Cc['@mozilla.org/network/io-service;1']
            .getService(Ci.nsIIOService);

  let uri = ios.newURI("http://www.foo.com");

  let type = Date.now().toString(32);
  let timesCalled = 0;
  let lastSubject = null;
  let lastData = null;
  let lastType = null;

  function handler({ subject, data, type }) {
    // Ignores internal console events
    if (isConsoleEvent(type))
      return;
    timesCalled++;
    lastSubject = subject;
    lastData = data;
    lastType = type;
  };

  events.on(type, handler);
  nsIObserverService.notifyObservers(uri, type, "some data");

  assert.equal(timesCalled, 1, "notification invokes handler");
  assert.equal(lastType, type, "event.type is notification topic");
  assert.equal(lastSubject, uri, "event.subject is notification subject");
  assert.equal(lastData, "some data", "event.data is notification data");

  function customSubject() {}
  function customData() {}

  events.emit(type, { data: customData, subject: customSubject });

  assert.equal(timesCalled, 2, "notification invokes handler");
  assert.equal(lastType, type, "event.type is notification topic");
  assert.equal(lastSubject, customSubject,
               "event.subject is wrapped & unwrapped");
  assert.equal(lastData, customData, "event.data is wrapped & unwrapped");

  events.off(type, handler);

  nsIObserverService.notifyObservers(null, type, "some data");

  assert.equal(timesCalled, 2, "event handler is removed");

  events.on("*", handler);

  nsIObserverService.notifyObservers(null, type, "more data");

  assert.equal(timesCalled, 3, "notification invokes * handler");
  assert.equal(lastType, type, "event.type is notification topic");
  assert.equal(lastSubject, null,
               "event.subject is notification subject");
  assert.equal(lastData, "more data", "event.data is notification data");

  events.off("*", handler);

  nsIObserverService.notifyObservers(null, type, "last data");

  assert.equal(timesCalled, 3, "* event handler is removed");
};

exports["test emit to nsIObserverService observers"] = function(assert) {
  let ios = Cc['@mozilla.org/network/io-service;1']
            .getService(Ci.nsIIOService);

  let uri = ios.newURI("http://www.foo.com");
  let timesCalled = 0;
  let lastSubject = null;
  let lastData = null;
  let lastTopic = null;

  var topic = Date.now().toString(32)
  let nsIObserver = {
    QueryInterface: function() {
      return nsIObserver;
    },
    observe: function(subject, topic, data) {
      // Ignores internal console events
      if (isConsoleEvent(topic))
        return;
      timesCalled = timesCalled + 1;
      lastSubject = subject;
      lastData = data;
      lastTopic = topic;
    }
  };

  nsIObserverService.addObserver(nsIObserver, topic);

  events.emit(topic, { subject: uri, data: "some data" });

  assert.equal(timesCalled, 1, "emit notifies observers");
  assert.equal(lastTopic, topic, "event type is notification topic");
  assert.equal(lastSubject.wrappedJSObject.object, uri,
               "event.subject is notification subject");
  assert.equal(lastData, "some data", "event.data is notification data");
  function customSubject() {}
  function customData() {}
  events.emit(topic, { subject: customSubject, data: customData });

  assert.equal(timesCalled, 2, "emit notifies observers");
  assert.equal(lastTopic, topic, "event.type is notification");
  assert.equal(lastSubject.wrappedJSObject.object, customSubject,
               "event.subject is notification subject");
  assert.equal(lastData, customData, "event.data is notification data");

  nsIObserverService.removeObserver(nsIObserver, topic);

  events.emit(topic, { data: "more data" });

  assert.equal(timesCalled, 2, "removed observers no longer invoked");

  nsIObserverService.addObserver(nsIObserver, "*");

  events.emit(topic, { data: "data again" });

  assert.equal(timesCalled, 3, "emit notifies * observers");

  assert.equal(lastTopic, topic, "event.type is notification");
  assert.equal(lastSubject, null,
               "event.subject is notification subject");
  assert.equal(lastData, "data again", "event.data is notification data");

  nsIObserverService.removeObserver(nsIObserver, "*");

  events.emit(topic, { data: "last data" });
  assert.equal(timesCalled, 3, "removed observers no longer invoked");
}

require("sdk/test").run(exports);
