/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global */

const EXPORTED_SYMBOLS = ["TabFeatures"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { PrefUtils } = ChromeUtils.import("resource:///modules/PrefUtils.jsm");

const { BrowserUtils } = ChromeUtils.import(
  "resource:///modules/BrowserUtils.jsm"
);

const TabFeatures = {
  PREF_ACTIVETAB: "browser.tabs.copyurl.activetab",
  PREF_REQUIRECONFIRM: "browser.restart_menu.requireconfirm",
  PREF_PURGECACHE: "browser.restart_menu.purgecache",
  PREF_TOOLBARPOS: "browser.tabs.toolbarposition",
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
  get style() {
    return `
           @-moz-document url('chrome://browser/content/browser.xhtml') {
            #appMenu-restart-button {
                list-style-image: url("data:image/png;base64,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");
              }
            }
          `;
  },

  setPrefs() {
    PrefUtils.set(this.PREF_ACTIVETAB, false, true);
    PrefUtils.set(this.PREF_REQUIRECONFIRM, true, true);
    PrefUtils.set(this.PREF_PURGECACHE, true, true);
  },

  initPrefListeners() {
    PrefUtils.set(this.PREF_TOOLBARPOS, "topabove", true);
    this.toolbarPositionListener = PrefUtils.addListener(
      this.PREF_TOOLBARPOS,
      value => {
        TabFeatures.executeInAllWindows((doc, win) => {
          TabFeatures.moveTabBar(win, value);
        });
      }
    );
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

  restartBrowser(aWindow) {
    try {
      if (Services.prefs.getBoolPref(this.PREF_REQUIRECONFIRM)) {
        let brand = aWindow.tabFeatures.brandBundle.GetStringFromName(
          "brandShortName"
        );
        let title = aWindow.tabFeatures.browserBundle.formatStringFromName(
          "restartPromptTitle",
          [brand],
          1
        );
        let question = aWindow.tabFeatures.browserBundle.formatStringFromName(
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

  moveTabBar(aWindow, aValue) {
    let bottomBookmarksBar = aWindow.document.querySelector(
      "#browser-bottombox #PersonalToolbar"
    );
    let bottomBox = aWindow.document.querySelector("#browser-bottombox");
    let tabsToolbar = aWindow.document.querySelector("#TabsToolbar");
    let titlebar = aWindow.document.querySelector("#titlebar");

    if (!aValue) {
      aValue = PrefUtils.get(this.PREF_TOOLBARPOS);
    }

    switch (aValue) {
      case "topabove":
        titlebar.insertAdjacentElement("beforeend", tabsToolbar);
        aWindow.gBrowser.setTabTitle(
          aWindow.document.querySelector(".tabbrowser-tab[first-visible-tab]")
        );
        break;
      case "topbelow":
        aWindow.document
          .querySelector("#navigator-toolbox")
          .appendChild(tabsToolbar);
        aWindow.gBrowser.setTabTitle(
          aWindow.document.querySelector(".tabbrowser-tab[first-visible-tab]")
        );
        break;
      case "bottomabove":
        // Above status bar
        bottomBox.collapsed = false;
        if (bottomBookmarksBar) {
          bottomBookmarksBar.insertAdjacentElement("afterend", tabsToolbar);
        } else {
          bottomBox.insertAdjacentElement("afterbegin", tabsToolbar);
        }
        aWindow.gBrowser.setTabTitle(
          aWindow.document.querySelector(".tabbrowser-tab[first-visible-tab]")
        );
        break;
      case "bottombelow":
        // Below status bar
        bottomBox.collapsed = false;
        bottomBox.insertAdjacentElement("afterend", tabsToolbar);
        aWindow.gBrowser.setTabTitle(
          aWindow.document.querySelector(".tabbrowser-tab[first-visible-tab]")
        );
        break;
    }

    // Set title on top bar when title bar is disabled and tab bar position is different than default
    const topBar = aWindow.document.querySelector("#toolbar-menubar-pagetitle");
    const activeTab = aWindow.document.querySelector('tab[selected="true"]');
    if (topBar && activeTab) {
      topBar.textContent = activeTab.getAttribute("label");
    }
  },
};

// Inherited props
TabFeatures.executeInAllWindows = BrowserUtils.executeInAllWindows;
