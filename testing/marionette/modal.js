/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {utils: Cu} = Components;

Cu.import("resource://gre/modules/Services.jsm");

this.EXPORTED_SYMBOLS = ["modal"];

const isFirefox = () => Services.appinfo.name == "Firefox";

this.modal = {};
modal = {
  COMMON_DIALOG_LOADED: "common-dialog-loaded",
  TABMODAL_DIALOG_LOADED: "tabmodal-dialog-loaded",
  handlers: {
    "common-dialog-loaded": new Set(),
    "tabmodal-dialog-loaded": new Set()
  }
};

/**
 * Add handler that will be called when a global- or tab modal dialogue
 * appears.
 *
 * This is achieved by installing observers for common-
 * and tab modal loaded events.
 *
 * This function is a no-op if called on any other product than Firefox.
 *
 * @param {function(Object, string)} handler
 *     The handler to be called, which is passed the
 *     subject (e.g. ChromeWindow) and the topic (one of
 *     {@code modal.COMMON_DIALOG_LOADED} or
 *     {@code modal.TABMODAL_DIALOG_LOADED}.
 */
modal.addHandler = function (handler) {
  if (!isFirefox()) {
    return;
  }

  Object.keys(this.handlers).map(topic => {
    this.handlers[topic].add(handler);
    Services.obs.addObserver(handler, topic, false);
  });
};

/**
 * Remove modal dialogue handler by function reference.
 *
 * This function is a no-op if called on any other product than Firefox.
 *
 * @param {function} toRemove
 *     The handler previously passed to modal.addHandler which will now
 *     be removed.
 */
modal.removeHandler = function (toRemove) {
  if (!isFirefox()) {
    return;
  }

  for (let topic of Object.keys(this.handlers)) {
    let handlers = this.handlers[topic];
    for (let handler of handlers) {
      if (handler == toRemove) {
        Services.obs.removeObserver(handler, topic);
        handlers.delete(handler);
      }
    }
  }
};

/**
 * Represents the current modal dialogue.
 *
 * @param {function(): browser.Context} curBrowserFn
 *     Function that returns the current |browser.Context|.
 * @param {nsIWeakReference=} winRef
 *     A weak reference to the current |ChromeWindow|.
 */
modal.Dialog = class {
  constructor(curBrowserFn, winRef = undefined) {
    this.curBrowserFn_ = curBrowserFn;
    this.win_ = winRef;
  }

  get curBrowser_() { return this.curBrowserFn_(); }

  /**
   * Returns the ChromeWindow associated with an open dialog window if
   * it is currently attached to the DOM.
   */
  get window() {
    if (this.win_) {
      let win = this.win_.get();
      if (win && win.parent) {
        return win;
      }
    }
    return null;
  }

  get ui() {
    let win = this.window;
    if (win) {
      return win.Dialog.ui;
    }
    return this.curBrowser_.getTabModalUI();
  }
};
