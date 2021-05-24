/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["OverlayHelper"];

ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "Overlays",
  "resource:///modules/Overlays.jsm"
);

// tabbrowser
class OverlayHelper extends ExtensibleUtils {
  constructor() {
    super();
  }

  static loadOverlayInWindow(aWindow, aURI) {
    let windowURI = aWindow.location.href;
    if (!windowURI.includes("browser.xhtml")) {
      // only want to attempt to load into a window doc
      return;
    }
    let instance = new OverlayHelper();
    let overlayProvider = instance._buildOverlayProvider(aURI, windowURI);
    Overlays.load(overlayProvider, aWindow);
  }

  static loadOverlayInTopWindow(aURI) {
    let window = Services.wm.getMostRecentWindow("navigator:browser");
    OverlayHelper.loadOverlayInWindow(window, aURI);
  }

  static loadOverlayInAllWindows(aURI) {
    let instance = new OverlayHelper();
    instance.loadInAllWindows(this.loadOverlayInWindow, [aURI]);
  }

  _buildOverlayProvider(aOverlayURI, aWindowURI) {
    let overlay = new Map();
    let style = new Map();
    overlay.set(aWindowURI, aOverlayURI);
    overlay.set(aOverlayURI, "");
    style.set(aWindowURI, "");
    style.set(aOverlayURI, "");
    let overlayProvider = {
      overlay,
      style,
    };
    return overlayProvider;
  }
}
