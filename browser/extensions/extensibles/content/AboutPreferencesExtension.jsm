/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["AboutPreferencesExtension"];

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);

class AboutPreferencesExtension extends ExtensibleUtils {
  constructor() {
    super();
  }

  init_prefTogglesInAllWindows() {
    // Need to ensure this is only run in the window with about:preferences open
    this.loadInAllWindows(this._findAboutPrefWindow.bind(this), []);
  }

  _findAboutPrefWindow(aWindow) {
    let tabCount = aWindow.gBrowser.browsers.length;
    for (let i = 0; i < tabCount; i++) {
      let spec = aWindow.gBrowser.getBrowserAtIndex(i).currentURI.spec;
      if (spec == "about:preferences" && !aWindow.prefsInitializing) {
        this.window = aWindow;
        this.window.prefsInitializing = true;
        this.init_prefToggles();
        break;
      }
    }
  }

  init_prefToggles() {
    // about:preferences not found in any window, should never happen as
    // this is only called from within about:preferences
    if (!this.window) {
      return;
    }
    var { document } = this.window.content;
    const kPrefs = [
      { id: "browser.tabs.duplicateTab", type: "bool" },
      { id: "browser.tabs.copyurl", type: "bool" },
      { id: "browser.tabs.copyurl.activetab", type: "bool" },
      { id: "browser.tabs.copyallurls", type: "bool" },
      { id: "browser.restart_menu.purgecache", type: "bool" },
      { id: "browser.restart_menu.requireconfirm", type: "bool" },
      { id: "browser.restart_menu.showpanelmenubtn", type: "bool" },
    ];
    const kTabPrefToggles = [
      [
        "duplicateTab",
        "duplicate-tab-options",
        "", // context menu rendered on right click, so setting .hidden overridden when menu next opened
        "browser.tabs.duplicateTab",
      ],
      [
        "copyUrl",
        "copy-tab-url-options",
        "context_copyCurrentTabUrl",
        "browser.tabs.copyurl",
      ],
      [
        "copyActiveTab",
        "copy-active-tab-url-options",
        "",
        "browser.tabs.copyurl.activetab",
      ],
      [
        "copyAllUrls",
        "copy-all-tab-urls-options",
        "context_copyAllTabUrls",
        "browser.tabs.copyallurls",
      ],
    ];
    var restartPrefToggles = [
      [
        "showRestartItem",
        "restart-paneluibtn",
        "appMenu-restart-button",
        "browser.restart_menu.showpanelmenubtn",
      ],
      [
        "purgeCache",
        "clean-fast-restart-cache",
        "",
        "browser.restart_menu.purgecache",
      ],
      [
        "requireRestartConfirmation",
        "restart-reqconfirmation",
        "",
        "browser.restart_menu.requireconfirm",
      ],
    ];
    // register prefs
    this._registerPrefs(kPrefs);
    // create tab pref container
    let tabPrefContainer = this._createPreferenceContainer(
      document,
      "tabBarPositionSettingsContainer",
      "tabContextMenu-header",
      "tabContextMenuSettingsContainer",
      false
    );
    if (tabPrefContainer) {
      // create tab preference toggles && listeners
      this._buildPreferenceToggles(document, kTabPrefToggles, tabPrefContainer);
    }
    // create restart pref container
    let restartGroup = this._createPrefGroupbox(
      document,
      "restartGroup",
      "themeGroup"
    );
    if (restartGroup) {
      this._createLabel(document, "restartGroup", "restart-header", true);
      // remove show restart button toggle if macosx
      if (AppConstants.platform == "macosx") {
        restartPrefToggles.splice(0, 1);
      }
      // create restart preference toggles && listeners
      this._buildPreferenceToggles(document, restartPrefToggles, restartGroup);
    }

    // finished initializing
    this.window.prefsInitializing = false;
  }

  // create container to group similar preferences
  _createPreferenceContainer(
    aDocument,
    aAfterId,
    aL10n,
    aContainerId,
    aInside
  ) {
    let container;
    try {
      // if we have already made the container, don't attempt to make it again
      if (aDocument.getElementById(aContainerId)) {
        return container;
      }
      let label = this._createLabel(aDocument, aAfterId, aL10n, aInside);
      if (!label) {
        return container;
      }
      container = this.createElement(aDocument, "vbox", {
        id: aContainerId,
      });
      label.insertAdjacentElement("afterend", container);
    } catch (e) {
      Cu.reportError(e);
    }
    return container;
  }

  _createLabel(aDocument, aAfterId, aL10n, aInside) {
    let label;
    try {
      let labelPos = aDocument.getElementById(aAfterId);
      label = this.createElement(aDocument, "label");
      let header = this.createElement(aDocument, "html:h2", {
        "data-l10n-id": aL10n,
        style:
          "font-weight: 600;margin: 16px 0 4px;font-size: 1.14em;line-height: normal;",
      });
      labelPos.insertAdjacentElement(
        aInside ? "afterbegin" : "afterend",
        label
      );
      label.insertAdjacentElement("afterbegin", header);
    } catch (e) {
      if (!e.inludes("labelPos is null")) {
        Cu.reportError(e);
      }
    }
    return label;
  }

  _createPrefGroupbox(aDocument, aId, aAfterId) {
    let groupbox;
    try {
      if (aDocument.getElementById(aId)) {
        return groupbox;
      }
      let groupPos = aDocument.getElementById(aAfterId);
      groupbox = this.createElement(aDocument, "groupbox", {
        id: aId,
        "data-category": "paneGeneral",
        hidden: true,
      });
      groupPos.insertAdjacentElement("afterend", groupbox);
    } catch (e) {
      if (!e.inludes("groupPos is null")) {
        Cu.reportError(e);
      }
    }
    return groupbox;
  }

  _buildPreferenceToggles(aDocument, aPrefToggles, aContainer) {
    aPrefToggles.forEach(([toggleId, l10n, menuId, prefId]) => {
      let element = aDocument.getElementById(toggleId);
      if (!element) {
        element = this.createElement(aDocument, "checkbox", {
          id: toggleId,
          "data-l10n-id": l10n,
          preference: prefId,
        });
      }
      if (element) {
        aContainer.insertAdjacentElement("beforeend", element);
        if (menuId && prefId) {
          this._setPrefListener(element, menuId, prefId);
        }
      }
    });
  }

  // set listener for preference checkbox on about:preferences
  _setPrefListener(aElement, aMenuId, aPrefId) {
    this.window.content.Preferences.addSyncFromPrefListener(aElement, () => {
      this._adjustElementStateFromPref(aMenuId, aPrefId);
    });
  }

  _registerPrefs(aPrefs) {
    try {
      this.window.content.Preferences.addAll(aPrefs);
    } catch (ex) {}
  }
}
