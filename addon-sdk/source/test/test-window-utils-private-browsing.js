/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
'use strict';

// Fennec support tracked in bug #809412
module.metadata = {
  'engines': {
    'Firefox': '*'
  }
};

const windowUtils = require('sdk/deprecated/window-utils');
const { Cc, Ci } = require('chrome');
const { isWindowPBSupported } = require('sdk/private-browsing/utils');
const { getFrames, getWindowTitle, onFocus, isWindowPrivate } = require('sdk/window/utils');
const { open, close, focus } = require('sdk/window/helpers');
const WM = Cc['@mozilla.org/appshell/window-mediator;1'].getService(Ci.nsIWindowMediator);
const { isPrivate } = require('sdk/private-browsing');
const { fromIterator: toArray } = require('sdk/util/array');
const { defer } = require('sdk/core/promise');
const { setTimeout } = require('sdk/timers');

function tick() {
  let deferred = defer();
  setTimeout(deferred.resolve);
  return deferred.promise;
}

function makeEmptyBrowserWindow(options) {
  options = options || {};
  return open('chrome://browser/content/browser.xul', {
    features: {
      chrome: true,
      private: !!options.private
    }
  });
}

exports.testWindowTrackerIgnoresPrivateWindows = function(assert, done) {
  var myNonPrivateWindow, myPrivateWindow;
  var finished = false;
  var privateWindow;
  var privateWindowClosed = false;

  let wt = windowUtils.WindowTracker({
    onTrack: function(window) {
      assert.ok(!isWindowPrivate(window), 'private window was not tracked!');
    },
    onUntrack: function(window) {
      assert.ok(!isWindowPrivate(window), 'private window was not tracked!');
      // PWPB case
      if (window === myPrivateWindow && isWindowPBSupported) {
        privateWindowClosed = true;
      }
      if (window === myNonPrivateWindow) {
        assert.ok(!privateWindowClosed);
        wt.unload();
        done();
      }
    }
  });

  // make a new private window
  makeEmptyBrowserWindow({
    private: true
  }).then(function(window) {
    myPrivateWindow = window;

    assert.equal(isWindowPrivate(window), isWindowPBSupported);
    assert.ok(getFrames(window).length > 1, 'there are frames for private window');
    assert.equal(getWindowTitle(window), window.document.title,
                 'getWindowTitle works');

    return close(window).then(function() {
      return makeEmptyBrowserWindow().then(function(window) {
        myNonPrivateWindow = window;
        assert.pass('opened new window');
        return close(window);
      });
    });
  }).catch(assert.fail);
};

// Test setting activeWIndow and onFocus for private windows
exports.testSettingActiveWindowDoesNotIgnorePrivateWindow = function(assert, done) {
  let browserWindow = WM.getMostRecentWindow("navigator:browser");

  assert.equal(windowUtils.activeBrowserWindow, browserWindow,
               "Browser window is the active browser window.");
  assert.ok(!isPrivate(browserWindow), "Browser window is not private.");

  // make a new private window
  makeEmptyBrowserWindow({ private: true }).then(focus).then(window => {
    // PWPB case
    if (isWindowPBSupported) {
      assert.ok(isPrivate(window), "window is private");
      assert.notStrictEqual(windowUtils.activeBrowserWindow, browserWindow);
    }
    // Global case
    else {
      assert.ok(!isPrivate(window), "window is not private");
    }

    assert.strictEqual(windowUtils.activeBrowserWindow, window,
                 "Correct active browser window pb supported");
    assert.notStrictEqual(browserWindow, window,
                 "The window is not the old browser window");


    return onFocus(windowUtils.activeWindow = browserWindow).then(_ => {
      assert.strictEqual(windowUtils.activeWindow, browserWindow,
                         "Correct active window [1]");
      assert.strictEqual(windowUtils.activeBrowserWindow, browserWindow,
                         "Correct active browser window [1]");

      // test focus(window)
      return focus(window).then(w => {
        assert.strictEqual(w, window, 'require("sdk/window/helpers").focus on window works');
      }).then(tick);
    }).then(_ => {
      assert.strictEqual(windowUtils.activeBrowserWindow, window,
                         "Correct active browser window [2]");
      assert.strictEqual(windowUtils.activeWindow, window,
                         "Correct active window [2]");

      // test setting a private window
      return onFocus(windowUtils.activeWindow = window);
    }).then(function() {
      assert.strictEqual(windowUtils.activeBrowserWindow, window,
                         "Correct active browser window [3]");
      assert.strictEqual(windowUtils.activeWindow, window,
                         "Correct active window [3]");

      // just to get back to original state
      return onFocus(windowUtils.activeWindow = browserWindow);
    }).then(_ => {
      assert.strictEqual(windowUtils.activeBrowserWindow, browserWindow,
                         "Correct active browser window when pb mode is supported [4]");
      assert.strictEqual(windowUtils.activeWindow, browserWindow,
                         "Correct active window when pb mode is supported [4]");

      return close(window);
    })
  }).then(done).catch(assert.fail);
};

exports.testActiveWindowDoesNotIgnorePrivateWindow = function(assert, done) {
  // make a new private window
  makeEmptyBrowserWindow({
    private: true
  }).then(function(window) {
    // PWPB case
    if (isWindowPBSupported) {
      assert.equal(isPrivate(windowUtils.activeWindow), true,
                   "active window is private");
      assert.equal(isPrivate(windowUtils.activeBrowserWindow), true,
                   "active browser window is private");
      assert.ok(isWindowPrivate(window), "window is private");
      assert.ok(isPrivate(window), "window is private");

      // pb mode is supported
      assert.ok(
        isWindowPrivate(windowUtils.activeWindow),
        "active window is private when pb mode is supported");
      assert.ok(
        isWindowPrivate(windowUtils.activeBrowserWindow),
        "active browser window is private when pb mode is supported");
      assert.ok(isPrivate(windowUtils.activeWindow),
                "active window is private when pb mode is supported");
      assert.ok(isPrivate(windowUtils.activeBrowserWindow),
        "active browser window is private when pb mode is supported");
    }
    // Global case
    else {
      assert.equal(isPrivate(windowUtils.activeWindow), false,
                   "active window is not private");
      assert.equal(isPrivate(windowUtils.activeBrowserWindow), false,
                   "active browser window is not private");
      assert.equal(isWindowPrivate(window), false, "window is not private");
      assert.equal(isPrivate(window), false, "window is not private");
    }

    return close(window);
  }).then(done).catch(assert.fail);
}

exports.testWindowIteratorIgnoresPrivateWindows = function(assert, done) {
  // make a new private window
  makeEmptyBrowserWindow({
    private: true
  }).then(function(window) {
    // PWPB case
    if (isWindowPBSupported) {
      assert.ok(isWindowPrivate(window), "window is private");
      assert.equal(toArray(windowUtils.windowIterator()).indexOf(window), -1,
                   "window is not in windowIterator()");
    }
    // Global case
    else {
      assert.equal(isWindowPrivate(window), false, "window is not private");
      assert.ok(toArray(windowUtils.windowIterator()).indexOf(window) > -1,
                "window is in windowIterator()");
    }

    return close(window);
  }).then(done).catch(assert.fail);
};

require("sdk/test").run(exports);
