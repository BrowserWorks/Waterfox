/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */
/* import-globals-from main.js */

// Pref for when containers is being controlled
const PREF_CONTAINERS_EXTENSION = "privacy.userContext.extension";

// Strings to identify ExtensionSettingsStore overrides
const CONTAINERS_KEY = "privacy.containers";

Preferences.addAll([
  // Tab Context Menu
  { id: "browser.tabs.duplicateTab", type: "bool" },
  { id: "browser.tabs.copyurl", type: "bool" },
  { id: "browser.tabs.copyurl.activetab", type: "bool" },
  { id: "browser.tabs.copyallurls", type: "bool" },

  /* Tab preferences
  Preferences:

  browser.link.open_newwindow
  1 opens such links in the most recent window or tab,
  2 opens such links in a new window,
  3 opens such links in a new tab
  browser.tabs.loadInBackground
  - true if display should switch to a new tab which has been opened from a
  link, false if display shouldn't switch
  browser.tabs.warnOnClose
  - true if when closing a window with multiple tabs the user is warned and
  allowed to cancel the action, false to just close the window
  browser.tabs.warnOnOpen
  - true if the user should be warned if he attempts to open a lot of tabs at
  once (e.g. a large folder of bookmarks), false otherwise
  browser.taskbar.previews.enable
  - true if tabs are to be shown in the Windows 7 taskbar
  */

  { id: "browser.link.open_newwindow", type: "int" },
  { id: "browser.tabs.loadInBackground", type: "bool", inverted: true },
  { id: "browser.tabs.warnOnClose", type: "bool" },
  { id: "browser.tabs.warnOnOpen", type: "bool" },
  { id: "browser.sessionstore.restore_on_demand", type: "bool" },
  { id: "browser.ctrlTab.recentlyUsedOrder", type: "bool" },
  { id: "browser.tabBar.position", type: "wstring" },

  { id: "privacy.userContext.enabled", type: "bool" },
]);

if (AppConstants.platform === "win") {
  Preferences.addAll([
    { id: "browser.taskbar.previews.enable", type: "bool" },
    { id: "ui.osk.enabled", type: "bool" },
  ]);
}

var gTabsPane = {
  init() {
    this.initBrowserContainers();
    function setEventListener(aId, aEventType, aCallback) {
      document
        .getElementById(aId)
        .addEventListener(aEventType, aCallback.bind(gTabsPane));
    }
    setEventListener(
      "disableContainersExtension",
      "command",
      makeDisableControllingExtension(PREF_SETTING_TYPE, CONTAINERS_KEY)
    );
    setEventListener(
      "browserContainersCheckbox",
      "command",
      gTabsPane.checkBrowserContainers
    );
    setEventListener(
      "browserContainersSettings",
      "command",
      gTabsPane.showContainerSettings
    );

    if (AppConstants.platform == "win") {
      // Functionality for "Show tabs in taskbar" on Windows 7 and up.
      try {
        let ver = parseFloat(Services.sysinfo.getProperty("version"));
        let showTabsInTaskbar = document.getElementById("showTabsInTaskbar");
        showTabsInTaskbar.hidden = ver < 6.1;
      } catch (ex) {}
    }

    // The "closing multiple tabs" and "opening multiple tabs might slow down
    // &brandShortName;" warnings provide options for not showing these
    // warnings again. When the user disabled them, we provide checkboxes to
    // re-enable the warnings.
    if (!TransientPrefs.prefShouldBeVisible("browser.tabs.warnOnClose")) {
      document.getElementById("warnCloseMultiple").hidden = true;
    }
    if (!TransientPrefs.prefShouldBeVisible("browser.tabs.warnOnOpen")) {
      document.getElementById("warnOpenMany").hidden = true;
    }

    let browserBundle = document.getElementById("browserBundle");
    appendSearchKeywords("browserContainersSettings", [
      browserBundle.getString("userContextPersonal.label"),
      browserBundle.getString("userContextWork.label"),
      browserBundle.getString("userContextBanking.label"),
      browserBundle.getString("userContextShopping.label"),
    ]);
  },

  /*
   * Preferences:
   *
   * browser.link.open_newwindow - int
   *   Determines where links targeting new windows should open.
   *   Values:
   *     1 - Open in the current window or tab.
   *     2 - Open in a new window.
   *     3 - Open in a new tab in the most recent window.
   * browser.tabs.loadInBackground - bool
   *   True - Whether browser should switch to a new tab opened from a link.
   * browser.tabs.warnOnClose - bool
   *   True - If when closing a window with multiple tabs the user is warned and
   *          allowed to cancel the action, false to just close the window.
   * browser.tabs.warnOnOpen - bool
   *   True - Whether the user should be warned when trying to open a lot of
   *          tabs at once (e.g. a large folder of bookmarks), allowing to
   *          cancel the action.
   * browser.taskbar.previews.enable - bool
   *   True - Tabs are to be shown in Windows 7 taskbar.
   *   False - Only the window is to be shown in Windows 7 taskbar.
   */

  /**
   * Determines where a link which opens a new window will open.
   *
   * @returns |true| if such links should be opened in new tabs
   */
  readLinkTarget() {
    var openNewWindow = Preferences.get("browser.link.open_newwindow");
    return openNewWindow.value != 2;
  },

  /**
   * Determines where a link which opens a new window will open.
   *
   * @returns 2 if such links should be opened in new windows,
   *          3 if such links should be opened in new tabs
   */
  writeLinkTarget() {
    var linkTargeting = document.getElementById("linkTargeting");
    return linkTargeting.checked ? 3 : 2;
  },

  async checkBrowserContainers(event) {
    let checkbox = document.getElementById("browserContainersCheckbox");
    if (checkbox.checked) {
      Services.prefs.setBoolPref("privacy.userContext.enabled", true);
      return;
    }

    let count = ContextualIdentityService.countContainerTabs();
    if (count == 0) {
      Services.prefs.setBoolPref("privacy.userContext.enabled", false);
      return;
    }

    let [
      title,
      message,
      okButton,
      cancelButton,
    ] = await document.l10n.formatValues([
      { id: "containers-disable-alert-title" },
      { id: "containers-disable-alert-desc", args: { tabCount: count } },
      { id: "containers-disable-alert-ok-button", args: { tabCount: count } },
      { id: "containers-disable-alert-cancel-button" },
    ]);

    let buttonFlags =
      Ci.nsIPrompt.BUTTON_TITLE_IS_STRING * Ci.nsIPrompt.BUTTON_POS_0 +
      Ci.nsIPrompt.BUTTON_TITLE_IS_STRING * Ci.nsIPrompt.BUTTON_POS_1;

    let rv = Services.prompt.confirmEx(
      window,
      title,
      message,
      buttonFlags,
      okButton,
      cancelButton,
      null,
      null,
      {}
    );
    if (rv == 0) {
      Services.prefs.setBoolPref("privacy.userContext.enabled", false);
      return;
    }

    checkbox.checked = true;
  },

  /**
   * Displays container panel for customising and adding containers.
   */
  showContainerSettings() {
    gotoPref("containers");
  },

  // CONTAINERS

  /*
   * preferences:
   *
   * privacy.userContext.enabled
   * - true if containers is enabled
   */

  /**
   * Enables/disables the Settings button used to configure containers
   */
  readBrowserContainersCheckbox() {
    const pref = Preferences.get("privacy.userContext.enabled");
    const settings = document.getElementById("browserContainersSettings");

    settings.disabled = !pref.value;
    const containersEnabled = Services.prefs.getBoolPref(
      "privacy.userContext.enabled"
    );
    const containersCheckbox = document.getElementById(
      "browserContainersCheckbox"
    );
    containersCheckbox.checked = containersEnabled;
    handleControllingExtension(PREF_SETTING_TYPE, CONTAINERS_KEY).then(
      isControlled => {
        containersCheckbox.disabled = isControlled;
      }
    );
  },

  /**
   * Show the Containers UI depending on the privacy.userContext.ui.enabled pref.
   */
  initBrowserContainers() {
    if (!Services.prefs.getBoolPref("privacy.userContext.ui.enabled")) {
      // The browserContainersGroup element has its own internal padding that
      // is visible even if the browserContainersbox is visible, so hide the whole
      // groupbox if the feature is disabled to prevent a gap in the preferences.
      document
        .getElementById("browserContainersbox")
        .setAttribute("data-hidden-from-search", "true");
      return;
    }
    Services.prefs.addObserver(PREF_CONTAINERS_EXTENSION, this);

    const link = document.getElementById("browserContainersLearnMore");
    link.href =
      Services.urlFormatter.formatURLPref("app.support.baseURL") + "containers";

    document.getElementById("browserContainersbox").hidden = false;
    this.readBrowserContainersCheckbox();
  },

  async onGetStarted(aEvent) {
    if (!AppConstants.MOZ_DEV_EDITION) {
      return;
    }
    const win = Services.wm.getMostRecentWindow("navigator:browser");
    if (!win) {
      return;
    }
    const user = await fxAccounts.getSignedInUser();
    if (user) {
      // We have a user, open Sync preferences in the same tab
      win.openTrustedLinkIn("about:preferences#sync", "current");
      return;
    }
    let url = await FxAccounts.config.promiseSignInURI("dev-edition-setup");
    let accountsTab = win.gBrowser.addWebTab(url);
    win.gBrowser.selectedTab = accountsTab;
  },
  async observe(aSubject, aTopic, aData) {
    if (aTopic == "nsPref:changed") {
      if (aData == PREF_CONTAINERS_EXTENSION) {
        this.readBrowserContainersCheckbox();
        return;
      }
      // All the prefs we observe can affect what we display, so we rebuild
      // the view when any of them changes.
      this._rebuildView();
    }
  },
  destroy() {
    window.removeEventListener("unload", this);
    Services.prefs.removeObserver(PREF_CONTAINERS_EXTENSION, this);
  },
};
