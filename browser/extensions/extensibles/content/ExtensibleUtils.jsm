/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["ExtensibleUtils"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

class ExtensibleUtils {
  createElement(aDoc, aTag, aAttrs, aXUL = true) {
    let el = aXUL ? aDoc.createXULElement(aTag) : aDoc.createElement(aTag);
    for (let att in aAttrs) {
      el.setAttribute(att, aAttrs[att]);
    }
    return el;
  }

  getPrefVal(aPref) {
    return Services.prefs.getBoolPref(aPref);
  }

  // create context menu items
  createElementsAndInsert(aDocument, aItems, aAfterId, aPosition) {
    try {
      let pos = aDocument.getElementById(aAfterId);
      aItems.forEach(([type, attrs]) => {
        let el = this.createElement(aDocument, type, attrs);
        if (el) {
          pos.insertAdjacentElement(aPosition ? aPosition : "afterend", el);
        }
      });
    } catch (ex) {
      Cu.reportError(ex);
    }
  }

  addWindowListener(aCallback, aArgs) {
    const windowListener = {
      onOpenWindow: xulWindow => {
        const win = xulWindow.docShell.domWindow;
        win.addEventListener("load", () => {
          aCallback(win, ...aArgs);
        });
      },
      onCloseWindow() {},
    };
    Services.wm.addListener(windowListener);
  }

  loadInAllWindows(aCallback, aArgs) {
    let windows = Services.wm.getEnumerator("navigator:browser");
    while (windows.hasMoreElements()) {
      let window = windows.getNext();
      aCallback(window, ...aArgs);
    }
  }

  loadInCurrentAndFutureWindows(aCallback, aArgs) {
    this.loadInAllWindows(aCallback, aArgs);
    this.addWindowListener(aCallback, aArgs);
  }

  amendBrowserElementVisibility(aWindow, aId, aPref) {
    const { document } = aWindow;
    let el = document.getElementById(aId);
    let visible = !this.getPrefVal(aPref);
    if (el) {
      el.hidden = visible;
    }
  }

  amendMultipleBrowserElementVisibility(aWindow, aItems) {
    for (let [id, pref] of aItems) {
      try {
        this.amendBrowserElementVisibility(aWindow, id, pref);
      } catch (ex) {
        Cu.reportError(ex);
      }
    }
  }

  adjustElementStateFromPref(aId, aPref) {
    let enumerator = Services.wm.getEnumerator("navigator:browser");
    var preference = Services.prefs.getBoolPref(aPref);
    while (enumerator.hasMoreElements()) {
      let win = enumerator.getNext();
      let { document } = win;
      let el = document.getElementById(aId);
      if (el) {
        el.hidden = !preference;
      }
    }
  }
}
