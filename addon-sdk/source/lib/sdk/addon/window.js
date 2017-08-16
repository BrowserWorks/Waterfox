/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

module.metadata = {
  "stability": "experimental"
};

const { Ci, Cc, Cu } = require("chrome");
const { when: unload } = require("../system/unload");
const prefs = require("../preferences/service");

if (!prefs.get("extensions.usehiddenwindow", false)) {
  const {HiddenFrame} = require("resource://gre/modules/HiddenFrame.jsm", {});
  let hiddenFrame = new HiddenFrame();
  exports.window = hiddenFrame.getWindow();
  exports.ready = hiddenFrame.get();

  // Still destroy frame on unload to claim memory back early.
  // NOTE: this doesn't seem to work and just doesn't get called. :-\
  unload(function() {
    hiddenFrame.destroy();
    hiddenFrame = null;
  });
} else {
  const { make: makeWindow, getHiddenWindow } = require("../window/utils");
  const { create: makeFrame, getDocShell } = require("../frame/utils");
  const { defer } = require("../core/promise");
  const cfxArgs = require("../test/options");

  var addonPrincipal = Cc["@mozilla.org/systemprincipal;1"].
                       createInstance(Ci.nsIPrincipal);

  var hiddenWindow = getHiddenWindow();

  if (cfxArgs.parseable) {
    console.info("hiddenWindow document.documentURI:" +
      hiddenWindow.document.documentURI);
    console.info("hiddenWindow document.readyState:" +
      hiddenWindow.document.readyState);
  }

  // Once Bug 565388 is fixed and shipped we'll be able to make invisible,
  // permanent docShells. Meanwhile we create hidden top level window and
  // use it's docShell.
  var frame = makeFrame(hiddenWindow.document, {
    nodeName: "iframe",
    namespaceURI: "http://www.w3.org/1999/xhtml",
    allowJavascript: true,
    allowPlugins: true
  })
  var docShell = getDocShell(frame);
  var eventTarget = docShell.chromeEventHandler;

  // We need to grant docShell system principals in order to load XUL document
  // from data URI into it.
  docShell.createAboutBlankContentViewer(addonPrincipal);

  // Get a reference to the DOM window of the given docShell and load
  // such document into that would allow us to create XUL iframes, that
  // are necessary for hidden frames etc..
  var window = docShell.contentViewer.DOMDocument.defaultView;
  window.location = "data:application/vnd.mozilla.xul+xml;charset=utf-8,<window/>";

  // Create a promise that is delivered once add-on window is interactive,
  // used by add-on runner to defer add-on loading until window is ready.
  var { promise, resolve } = defer();
  eventTarget.addEventListener("DOMContentLoaded", function(event) {
    resolve();
  }, {once: true});

  exports.ready = promise;
  exports.window = window;

  // Still close window on unload to claim memory back early.
  unload(function() {
    window.close()
    frame.remove();
  });
}
