/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global */

const EXPORTED_SYMBOLS = ["TabFeatures"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

const { BrowserUtils } = ChromeUtils.import(
  "resource:///modules/BrowserUtils.jsm"
);

const TabFeatures = {
  PREF_ACTIVETAB: "browser.tabs.copyurl.activetab",
  PREF_REQUIRECONFIRM: "browser.restart_menu.requireconfirm",
  PREF_PURGECACHE: "browser.restart_menu.purgecache",
  get browserBundle() {
    return Services.strings.createBundle(
      "chrome://extensibles/locale/extensibles.properties"
    );
  },
  get brandBundle() {
    return Services.strings.createBundle(
      "chrome://branding/locale/brand.properties"
    );
  },
  get updateItems() {
    return [
      {
        id: "context_duplicateTab",
        attrs: {
          class: "tabFeature",
          preference: "browser.tabs.duplicateTab",
        },
      },
    ];
  },

  init(window) {
    // Add any attributes to required elements
    this.initAttributes(this.updateItems, window);
    this.initListeners(window);
  },

  initListeners(aWindow) {
    aWindow.document
      .getElementById("tabContextMenu")
      ?.addEventListener("popupshowing", this.tabContext);
    if (AppConstants.platform == "macosx") {
      aWindow.document
        .getElementById("file-menu")
        ?.addEventListener("popupshowing", this.tabContext);
    } else {
      aWindow.document
        .getElementById("appMenu-popup")
        ?.addEventListener("popupshowing", this.tabContext);
    }
  },

  initAttributes(aItems, aWindow) {
    aItems.forEach(item => {
      let el = aWindow.document.getElementById(item.id);
      Object.entries(item.attrs).forEach(([id, val]) => {
        el?.setAttribute(id, val);
      });
    });
  },

  tabContext(aEvent) {
    let win = aEvent.view;
    if (!win) {
      win = Services.wm.getMostRecentWindow("navigator:browser");
    }
    let { document } = win;
    let elements = document.getElementsByClassName("tabFeature");
    for (let i = 0; i < elements.length; i++) {
      let el = elements[i];
      let pref = el.getAttribute("preference");
      if (pref) {
        let visible = Services.prefs.getBoolPref(pref);
        el.hidden = !visible;
      }
    }
  },

  // Copies current tab url to clipboard
  copyTabUrl(aUri, aWindow) {
    const gClipboardHelper = Cc[
      "@mozilla.org/widget/clipboardhelper;1"
    ].getService(Ci.nsIClipboardHelper);
    try {
      Services.prefs.getBoolPref(this.PREF_ACTIVETAB)
        ? gClipboardHelper.copyString(aWindow.gBrowser.currentURI.spec)
        : gClipboardHelper.copyString(aUri);
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'CopyTabUrl' " + e
      );
    }
  },

  // Copies all tab urls to clipboard
  copyAllTabUrls(aWindow) {
    const gClipboardHelper = Cc[
      "@mozilla.org/widget/clipboardhelper;1"
    ].getService(Ci.nsIClipboardHelper);
    //Get all urls
    let urlArr = this._getAllUrls(aWindow);
    try {
      // Enumerate all urls in to a list.
      let urlList = urlArr.join("\n");
      // Send list to clipboard.
      gClipboardHelper.copyString(urlList.trim());
      // Clear url list after clipboard event
      urlList = "";
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'copyAllTabUrls' " + e
      );
    }
  },

  // Get all the tab urls into an array.
  _getAllUrls(aWindow) {
    // We don't want to copy about uri's
    let blocklist = /^about:.*/i;
    let urlArr = [];
    let tabCount = aWindow.gBrowser.browsers.length;
    Array(tabCount)
      .fill()
      .map((_, i) => {
        let spec = aWindow.gBrowser.getBrowserAtIndex(i).currentURI.spec;
        if (!blocklist.test(spec)) {
          urlArr.push(spec);
        }
      });
    return urlArr;
  },

  restartBrowser() {
    try {
      if (Services.prefs.getBoolPref(this.PREF_REQUIRECONFIRM)) {
        let brand = this.brandBundle.GetStringFromName("brandShortName");
        let title = this.browserBundle.formatStringFromName(
          "restartPromptTitle",
          [brand],
          1
        );
        let question = this.browserBundle.formatStringFromName(
          "restartPromptQuestion",
          [brand],
          1
        );
        if (Services.prompt.confirm(null, title, question)) {
          // only restart if confirmation given
          this._attemptRestart();
        }
      } else {
        this._attemptRestart();
      }
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'restartBrowser' " + e
      );
    }
  },

  _attemptRestart() {
    if (Services.prefs.getBoolPref(this.PREF_PURGECACHE)) {
      Services.appinfo.invalidateCachesOnRestart();
    }
    Services.startup.quit(
      Services.startup.eRestart | Services.startup.eAttemptQuit
    );
  },
};

// Inherited props
TabFeatures.executeInAllWindows = BrowserUtils.executeInAllWindows;
