/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global setConsoleEventHandler, retrieveConsoleEvents */

"use strict";

// This file is loaded on the server side for worker debugging.
// Since the server is running in the worker thread, it doesn't
// have access to Services / Components but the listeners defined here
// are imported by webconsole-utils and used for the webconsole actor.

function ConsoleAPIListener(window, owner, consoleID) {
  this.window = window;
  this.owner = owner;
  this.consoleID = consoleID;
  this.observe = this.observe.bind(this);
}

ConsoleAPIListener.prototype = {
  init: function() {
    setConsoleEventHandler(this.observe);
  },
  destroy: function() {
    setConsoleEventHandler(null);
  },
  observe: function(message) {
    this.owner.onConsoleAPICall(message.wrappedJSObject);
  },
  getCachedMessages: function() {
    return retrieveConsoleEvents();
  },
};

exports.ConsoleAPIListener = ConsoleAPIListener;
