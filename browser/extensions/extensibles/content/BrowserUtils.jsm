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
