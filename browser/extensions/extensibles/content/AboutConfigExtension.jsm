/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["AboutConfigExtension"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);

class AboutConfigExtension extends ExtensibleUtils {
  constructor() {
    super();
  }

  waitForUnload() {
    var window = Services.wm.getMostRecentWindow("navigator:browser");
    this._loadFunctions(window);
    window.content.document.addEventListener("visibilitychange", event => {
      if (
        event.target.visibilityState == "hidden" &&
        window.updateElementStateFromPref()
      ) {
        window.updateElementStateFromPref().bind(window);
      }
    });
  }

  _loadFunctions(aWindow) {
    aWindow.updateElementStateFromPref = this._updateElementStateFromPref;
    aWindow.adjustElementStateFromPref = this.adjustElementStateFromPref;
  }

  _updateElementStateFromPref() {
    const kPrefToggles = [
      ["context_copyCurrentTabUrl", "browser.tabs.copyurl"],
      ["context_copyAllTabUrls", "browser.tabs.copyallurls"],
      ["appMenu-restart-button", "browser.restart_menu.showpanelmenubtn"],
    ];
    kPrefToggles.forEach(([menuId, prefId]) => {
      this.adjustElementStateFromPref(menuId, prefId);
    });
  }
}
