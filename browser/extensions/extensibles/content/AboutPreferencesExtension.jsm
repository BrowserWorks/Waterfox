/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["AboutPreferencesExtension"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

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
    ];
    const kPrefToggles = [
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
    // register prefs
    this._registerPrefs(kPrefs);
    // create label && vbox
    let container = this._createPreferenceContainer(
      document,
      "tabBarPositionSettingsContainer",
      "tabContextMenu-header",
      "tabContextMenuSettingsContainer"
    );
    if (container) {
      // create preference toggles && pref listeners
      this._buildPreferenceToggles(document, kPrefToggles, container);
    }
    // finished initializing
    this.window.prefsInitializing = false;
  }

  // create container to group similar preferences
  _createPreferenceContainer(aDocument, aAfterId, aL10n, aContainerId) {
    let container;
    try {
      // if we have already made the container, don't attempt to make it again
      if (aDocument.getElementById(aContainerId)) {
        return container;
      }
      let labelPos = aDocument.getElementById(aAfterId);
      let label = this.createElement(aDocument, "label");
      let header = this.createElement(aDocument, "html:h2", {
        "data-l10n-id": aL10n,
        style:
          "font-weight: 600;margin: 16px 0 4px;font-size: 1.14em;line-height: normal;",
      });
      labelPos.insertAdjacentElement("afterend", label);
      label.insertAdjacentElement("afterbegin", header);
      container = this.createElement(aDocument, "vbox", {
        id: aContainerId,
      });
      label.insertAdjacentElement("afterend", container);
    } catch (e) {
      Cu.reportError(e);
    }
    return container;
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

  // if about:preferences checkbox toggled, hide/unhide context menu element in all windows
  _adjustElementStateFromPref(aId, aPref) {
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

  _registerPrefs(aPrefs) {
    try {
      this.window.content.Preferences.addAll(aPrefs);
    } catch (ex) {}
  }
}
