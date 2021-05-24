/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["ContextMenuExtension"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "OverlayHelper",
  "resource://extensibles/OverlayHelper.jsm"
);

// tabbrowser
class ContextMenuExtension extends ExtensibleUtils {
  constructor() {
    super();
    this.overlayURI = "resource://extensibles/tabfeatures.xhtml";
    try {
      // ensure overlay loaded into all active windows at startup
      this.loadInAllWindows(OverlayHelper.loadOverlayInWindow, [
        this.overlayURI,
      ]);
      // ensure overlay loaded into any new windows after startup
      this.addWindowListener(OverlayHelper.loadOverlayInWindow, [
        this.overlayURI,
      ]);
      // add context menu functions to all active windows at startup
      this.loadInAllWindows(this._loadContextFunctions.bind(this), []);
      // add context menu functions to any new windows after startup
      this.addWindowListener(this._loadContextFunctions.bind(this), []);
      // ensure on load all windows have the correct hidden param for each item
      this.loadInAllWindows(this._setContextItemVisibility.bind(this), []);
      // ensure all new windows set correctly
      this.addWindowListener(this._setContextItemVisibility.bind(this), []);
    } catch (ex) {
      // something went wrong
    }
  }

  _setContextItemVisibility(aWindow) {
    let contextItems = [
      ["context_copyCurrentTabUrl", "browser.tabs.copyurl"],
      ["context_copyAllTabUrls", "browser.tabs.copyallurls"],
    ];
    for (let [id, pref] of contextItems) {
      try {
        this.amendBrowserElementVisibility(aWindow, id, pref);
      } catch (ex) {
        Cu.reportError(ex);
      }
    }
  }

  _loadContextFunctions(aWindow) {
    // register functions in TabContextMenu so they are accessible in browser.xhtml
    if (aWindow.TabContextMenu) {
      aWindow.TabContextMenu.copyCurrentTabUrl = this.copyCurrentTabUrl;
      aWindow.TabContextMenu.copyAllTabUrls = this.copyAllTabUrls;
      aWindow.TabContextMenu._getAllUrls = this._getAllUrls;
    }
  }

  // Copies current tab url to clipboard
  copyCurrentTabUrl(aUri) {
    try {
      var window = this.window;
      if (!window) {
        window = Services.wm.getMostRecentWindow("navigator:browser");
      }

      let gClipboardHelper = Cc[
        "@mozilla.org/widget/clipboardhelper;1"
      ].getService(Ci.nsIClipboardHelper);

      Services.prefs.getBoolPref("browser.tabs.copyurl.activetab")
        ? gClipboardHelper.copyString(window.gBrowser.currentURI.spec)
        : gClipboardHelper.copyString(aUri);
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'CopyCurrentTabUrl' " + e
      );
    }
  }

  // Copies all tab urls to clipboard
  copyAllTabUrls() {
    var window = this.window;
    if (!window) {
      window = Services.wm.getMostRecentWindow("navigator:browser");
    }
    //Get all urls
    let urlArr = this._getAllUrls(window);
    try {
      let gClipboardHelper = Cc[
        "@mozilla.org/widget/clipboardhelper;1"
      ].getService(Ci.nsIClipboardHelper);
      // Enumerate all urls in to a list.
      let urlList = "";
      for (let i = 0; urlArr[i]; i++) {
        try {
          urlList += urlArr[i].url + "\n";
        } catch (e) {
          Cu.reportError(e);
        }
      }
      // Send list to clipboard.
      gClipboardHelper.copyString(urlList.trim());
      // Clear url list after clipboard event
      urlList = "";
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'copyAllTabUrls' " + e
      );
    }
  }

  // Get all the tab urls into an array.
  _getAllUrls(aWindow) {
    // We don't want to copy about uri's
    let blocklist = /^about:.*/i;
    let urlArr = [];
    let tabCount = aWindow.gBrowser.browsers.length;
    for (let i = 0; i < tabCount; i++) {
      try {
        let spec = aWindow.gBrowser.getBrowserAtIndex(i).currentURI.spec;
        if (!blocklist.test(spec)) {
          urlArr.push({
            url: spec,
          });
        }
      } catch (e) {
        Cu.reportError(e);
      }
    }
    return urlArr;
  }
}
