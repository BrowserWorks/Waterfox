/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global */

const EXPORTED_SYMBOLS = ["BrowserUtils"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { CustomizableUI } = ChromeUtils.import(
  "resource:///modules/CustomizableUI.jsm"
);

const BrowserUtils = {
  // internal functions/props
  get mostRecentWindow() {
    return Services.wm.getMostRecentWindow("navigator:browser");
  },

  get document() {
    return Services.wm.getMostRecentWindow("navigator:browser").document;
  },
  createElement(aDoc, aTag, aAttrs) {
    // Create element
    let el = aDoc.createXULElement(aTag);
    for (let att in aAttrs) {
      // don't set null attrs
      if (aAttrs[att]) {
        el.setAttribute(att, aAttrs[att]);
      }
    }
    return el;
  },

  // api endpoints
  createAndPositionElement(aTag, aAttrs, aAdjacentTo, aPosition) {
    let doc = this.document;
    // Create element
    let el = this.createElement(doc, aTag, aAttrs);
    // Place it in certain location
    let pos = doc.getElementById(aAdjacentTo);
    if (aPosition) {
      pos.insertAdjacentElement(aPosition, el);
    } else if (aAdjacentTo == "gNavToolbox") {
      this.mostRecentWindow.gNavToolbox.appendChild(el);
    } else {
      pos.appendChild(el);
    }
  },

  createElementAs(aTag, aAttrs, aSetAs) {
    let doc = this.document;
    // create element
    if (aSetAs == "win.statusbar.node") {
      this.mostRecentWindow.statusbar.node = this.createElement(
        doc,
        aTag,
        aAttrs
      );
    } else if (aSetAs == "win.statusbar.textNode") {
      this.mostRecentWindow.statusbar.textNode = this.createElement(
        doc,
        aTag,
        aAttrs
      );
    }
  },

  executeInAllWindows(aFunc) {
    let windows = Services.wm.getEnumerator("navigator:browser");
    while (windows.hasMoreElements()) {
      let win = windows.getNext();
      if (!win.statusBar) {
        continue;
      }
      let { document } = win;
      aFunc(document, win);
    }
  },

  setStyle(aStyleSheet) {
    let styleSheetService = Cc[
      "@mozilla.org/content/style-sheet-service;1"
    ].getService(Ci.nsIStyleSheetService);

    let url = Services.io.newURI(
      "data:text/css;charset=UTF-8," + encodeURIComponent(aStyleSheet)
    );
    let type = styleSheetService.USER_SHEET;

    styleSheetService.loadAndRegisterSheet(url, type);
  },

  registerArea(aArea) {
    CustomizableUI.registerArea(aArea, {});
  },
};
