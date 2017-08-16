/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

(function (factory) {
  // This file can be loaded in several different ways.  It can be
  // require()d, either from the main thread or from a worker thread;
  // or it can be imported via Cu.import.  These different forms
  // explain some of the hairiness of this code.
  //
  // It's important for the devtools-as-html project that a require()
  // on the main thread not use any chrome privileged APIs.  Instead,
  // the body of the main function can only require() (not Cu.import)
  // modules that are available in the devtools content mode.  This,
  // plus the lack of |console| in workers, results in some gyrations
  // in the definition of |console|.
  if (this.module && module.id.indexOf("event-emitter") >= 0) {
    let console;
    if (isWorker) {
      console = {
        error: () => {}
      };
    } else {
      console = this.console;
    }
    // require
    factory.call(this, require, exports, module, console);
  } else {
    // Cu.import.  This snippet implements a sort of miniature loader,
    // which is responsible for appropriately translating require()
    // requests from the client function.  This code can use
    // Cu.import, because it is never run in the devtools-in-content
    // mode.
    this.isWorker = false;
    const Cu = Components.utils;
    let console = Cu.import("resource://gre/modules/Console.jsm", {}).console;
    // Bug 1259045: This module is loaded early in firefox startup as a JSM,
    // but it doesn't depends on any real module. We can save a few cycles
    // and bytes by not loading Loader.jsm.
    let require = function (module) {
      switch (module) {
        case "devtools/shared/defer":
          return Cu.import("resource://gre/modules/Promise.jsm", {}).Promise.defer;
        case "Services":
          return Cu.import("resource://gre/modules/Services.jsm", {}).Services;
        case "devtools/shared/platform/stack": {
          let obj = {};
          Cu.import("resource://devtools/shared/platform/chrome/stack.js", obj);
          return obj;
        }
      }
      return null;
    };
    factory.call(this, require, this, { exports: this }, console);
    this.EXPORTED_SYMBOLS = ["EventEmitter"];
  }
}).call(this, function (require, exports, module, console) {
  // ⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠⚠
  // After this point the code may not use Cu.import, and should only
  // require() modules that are "clean-for-content".
  let EventEmitter = this.EventEmitter = function () {};
  module.exports = EventEmitter;

  // See comment in JSM module boilerplate when adding a new dependency.
  const Services = require("Services");
  const defer = require("devtools/shared/defer");
  const { describeNthCaller } = require("devtools/shared/platform/stack");
  let loggingEnabled = true;

  if (!isWorker) {
    loggingEnabled = Services.prefs.getBoolPref("devtools.dump.emit");
    Services.prefs.addObserver("devtools.dump.emit", {
      observe: () => {
        loggingEnabled = Services.prefs.getBoolPref("devtools.dump.emit");
      }
    });
  }

  /**
   * Decorate an object with event emitter functionality.
   *
   * @param Object objectToDecorate
   *        Bind all public methods of EventEmitter to
   *        the objectToDecorate object.
   * @return Object the object given.
   */
  EventEmitter.decorate = function (objectToDecorate) {
    let emitter = new EventEmitter();
    objectToDecorate.on = emitter.on.bind(emitter);
    objectToDecorate.off = emitter.off.bind(emitter);
    objectToDecorate.once = emitter.once.bind(emitter);
    objectToDecorate.emit = emitter.emit.bind(emitter);

    return objectToDecorate;
  };

  EventEmitter.prototype = {
    /**
     * Connect a listener.
     *
     * @param string event
     *        The event name to which we're connecting.
     * @param function listener
     *        Called when the event is fired.
     */
    on(event, listener) {
      if (!this._eventEmitterListeners) {
        this._eventEmitterListeners = new Map();
      }
      if (!this._eventEmitterListeners.has(event)) {
        this._eventEmitterListeners.set(event, []);
      }
      this._eventEmitterListeners.get(event).push(listener);
    },

    /**
     * Listen for the next time an event is fired.
     *
     * @param string event
     *        The event name to which we're connecting.
     * @param function listener
     *        (Optional) Called when the event is fired. Will be called at most
     *        one time.
     * @return promise
     *        A promise which is resolved when the event next happens. The
     *        resolution value of the promise is the first event argument. If
     *        you need access to second or subsequent event arguments (it's rare
     *        that this is needed) then use listener
     */
    once(event, listener) {
      let deferred = defer();

      let handler = (_, first, ...rest) => {
        this.off(event, handler);
        if (listener) {
          listener(event, first, ...rest);
        }
        deferred.resolve(first);
      };

      handler._originalListener = listener;
      this.on(event, handler);

      return deferred.promise;
    },

    /**
     * Remove a previously-registered event listener.  Works for events
     * registered with either on or once.
     *
     * @param string event
     *        The event name whose listener we're disconnecting.
     * @param function listener
     *        The listener to remove.
     */
    off(event, listener) {
      if (!this._eventEmitterListeners) {
        return;
      }
      let listeners = this._eventEmitterListeners.get(event);
      if (listeners) {
        this._eventEmitterListeners.set(event, listeners.filter(l => {
          return l !== listener && l._originalListener !== listener;
        }));
      }
    },

    /**
     * Emit an event.  All arguments to this method will
     * be sent to listener functions.
     */
    emit(event) {
      this.logEvent(event, arguments);

      if (!this._eventEmitterListeners || !this._eventEmitterListeners.has(event)) {
        return;
      }

      let originalListeners = this._eventEmitterListeners.get(event);
      for (let listener of this._eventEmitterListeners.get(event)) {
        // If the object was destroyed during event emission, stop
        // emitting.
        if (!this._eventEmitterListeners) {
          break;
        }

        // If listeners were removed during emission, make sure the
        // event handler we're going to fire wasn't removed.
        if (originalListeners === this._eventEmitterListeners.get(event) ||
          this._eventEmitterListeners.get(event).some(l => l === listener)) {
          try {
            listener.apply(null, arguments);
          } catch (ex) {
            // Prevent a bad listener from interfering with the others.
            let msg = ex + ": " + ex.stack;
            console.error(msg);
            dump(msg + "\n");
          }
        }
      }
    },

    logEvent(event, args) {
      if (!loggingEnabled) {
        return;
      }

      let description = describeNthCaller(2);

      let argOut = "(";
      if (args.length === 1) {
        argOut += event;
      }

      let out = "EMITTING: ";

      // We need this try / catch to prevent any dead object errors.
      try {
        for (let i = 1; i < args.length; i++) {
          if (i === 1) {
            argOut = "(" + event + ", ";
          } else {
            argOut += ", ";
          }

          let arg = args[i];
          argOut += arg;

          if (arg && arg.nodeName) {
            argOut += " (" + arg.nodeName;
            if (arg.id) {
              argOut += "#" + arg.id;
            }
            if (arg.className) {
              argOut += "." + arg.className;
            }
            argOut += ")";
          }
        }
      } catch (e) {
        // Object is dead so the toolbox is most likely shutting down,
        // do nothing.
      }

      argOut += ")";
      out += "emit" + argOut + " from " + description + "\n";

      dump(out);
    },
  };
});
