/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

var EXPORTED_SYMBOLS = ["GeckoViewPrompter"];

const { GeckoViewUtils } = ChromeUtils.import(
  "resource://gre/modules/GeckoViewUtils.jsm"
);

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { debug, warn } = GeckoViewUtils.initLogging("GeckoViewPrompter"); // eslint-disable-line no-unused-vars

class GeckoViewPrompter {
  constructor(aParent) {
    if (aParent) {
      if (aParent instanceof Window) {
        this._domWin = aParent;
      } else if (aParent.window) {
        this._domWin = aParent.window;
      } else {
        this._domWin =
          aParent.embedderElement && aParent.embedderElement.ownerGlobal;
      }
    }

    if (this._domWin) {
      this._dispatcher = GeckoViewUtils.getDispatcherForWindow(this._domWin);
    }

    if (!this._dispatcher) {
      [
        this._dispatcher,
        this._domWin,
      ] = GeckoViewUtils.getActiveDispatcherAndWindow();
    }
  }

  get domWin() {
    return this._domWin;
  }

  _changeModalState(aEntering) {
    if (!this._domWin) {
      // Allow not having a DOM window.
      return true;
    }
    // Accessing the document object can throw if this window no longer exists. See bug 789888.
    try {
      const winUtils = this._domWin.windowUtils;
      if (!aEntering) {
        winUtils.leaveModalState();
      }

      const event = this._domWin.document.createEvent("Events");
      event.initEvent(
        aEntering ? "DOMWillOpenModalDialog" : "DOMModalDialogClosed",
        true,
        true
      );
      winUtils.dispatchEventToChromeOnly(this._domWin, event);

      if (aEntering) {
        winUtils.enterModalState();
      }
      return true;
    } catch (ex) {
      Cu.reportError("Failed to change modal state: " + ex);
    }
    return false;
  }

  /**
   * Shows a native prompt, and then spins the event loop for this thread while we wait
   * for a response
   */
  showPrompt(aMsg) {
    let result = undefined;
    if (!this._domWin || !this._changeModalState(/* aEntering */ true)) {
      return result;
    }
    try {
      this.asyncShowPrompt(aMsg, res => (result = res));

      // Spin this thread while we wait for a result
      Services.tm.spinEventLoopUntil(
        () => this._domWin.closed || result !== undefined
      );
    } finally {
      this._changeModalState(/* aEntering */ false);
    }
    return result;
  }

  asyncShowPrompt(aMsg, aCallback) {
    let handled = false;
    const onResponse = response => {
      if (handled) {
        return;
      }
      aCallback(response);
      // This callback object is tied to the Java garbage collector because
      // it is invoked from Java. Manually release the target callback
      // here; otherwise we may hold onto resources for too long, because
      // we would be relying on both the Java and the JS garbage collectors
      // to run.
      aMsg = undefined;
      aCallback = undefined;
      handled = true;
    };

    if (!this._dispatcher) {
      onResponse(null);
      return;
    }

    this._dispatcher.dispatch("GeckoView:Prompt", aMsg, {
      onSuccess: onResponse,
      onError: error => {
        Cu.reportError("Prompt error: " + error);
        onResponse(null);
      },
    });
  }
}
