/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */
/* import-globals-from main.js */

// HOME PAGE

/*
 * Preferences:
 *
 * browser.startup.homepage
 * - the user's home page, as a string; if the home page is a set of tabs,
 *   this will be those URLs separated by the pipe character "|"
 * browser.newtabpage.enabled
 * - determines that is shown on the user's new tab page.
 *   true = Activity Stream is shown,
 *   false = about:blank is shown
 */

Preferences.addAll([
  { id: "browser.startup.homepage", type: "wstring" },
  { id: "pref.browser.homepage.disable_button.current_page", type: "bool" },
  { id: "pref.browser.homepage.disable_button.bookmark_page", type: "bool" },
  { id: "pref.browser.homepage.disable_button.restore_default", type: "bool" },
  { id: "browser.newtabpage.enabled", type: "bool" },
]);

const HOMEPAGE_OVERRIDE_KEY = "homepage_override";
const URL_OVERRIDES_TYPE = "url_overrides";
const NEW_TAB_KEY = "newTabURL";

var gHomePane = {
  HOME_MODE_FIREFOX_HOME: "0",
  HOME_MODE_BLANK: "1",
  HOME_MODE_CUSTOM: "2",
  HOMEPAGE_PREF: "browser.startup.homepage",
  NEWTAB_ENABLED_PREF: "browser.newtabpage.enabled",
  ACTIVITY_STREAM_PREF_BRANCH: "browser.newtabpage.activity-stream.",

  get homePanePrefs() {
    return Preferences.getAll().filter(pref =>
      pref.id.includes(this.ACTIVITY_STREAM_PREF_BRANCH)
    );
  },

  get isPocketNewtabEnabled() {
    const value = Services.prefs.getStringPref(
      "browser.newtabpage.activity-stream.discoverystream.config",
      ""
    );
    if (value) {
      try {
        return JSON.parse(value).enabled;
      } catch (e) {
        console.error("Failed to parse Discovery Stream pref.");
      }
    }

    return false;
  },

  /**
   * _handleNewTabOverrides: disables new tab settings UI. Called by
   * an observer in ._watchNewTab that watches for new tab url changes
   */
  async _handleNewTabOverrides() {
    const isControlled = await handleControllingExtension(
      URL_OVERRIDES_TYPE,
      NEW_TAB_KEY
    );
    const el = document.getElementById("newTabMode");
    el.disabled = isControlled;
  },

  /**
   * watchNewTab: Listen for changes to the new tab url and disable appropriate
   * areas of the UI
   */
  watchNewTab() {
    this._handleNewTabOverrides();
    let newTabObserver = {
      observe: this._handleNewTabOverrides.bind(this),
    };
    Services.obs.addObserver(newTabObserver, "newtab-url-changed");
    window.addEventListener("unload", () => {
      Services.obs.removeObserver(newTabObserver, "newtab-url-changed");
    });
  },

  /**
   * Listen for all preferences changes on the Home Tab in order to show or
   * hide the Restore Defaults button.
   */
  watchHomeTabPrefChange() {
    const observer = () => this.toggleRestoreDefaultsBtn();
    Services.prefs.addObserver(this.ACTIVITY_STREAM_PREF_BRANCH, observer);
    Services.prefs.addObserver(this.HOMEPAGE_PREF, observer);
    Services.prefs.addObserver(this.NEWTAB_ENABLED_PREF, observer);

    window.addEventListener("unload", () => {
      Services.prefs.removeObserver(this.ACTIVITY_STREAM_PREF_BRANCH, observer);
      Services.prefs.removeObserver(this.HOMEPAGE_PREF, observer);
      Services.prefs.removeObserver(this.NEWTAB_ENABLED_PREF, observer);
    });
  },

  /**
   * _renderCustomSettings: Hides or shows the UI for setting a custom
   * homepage URL
   * @param {obj} options
   * @param {bool} options.shouldShow Should the custom UI be shown?
   * @param {bool} options.isControlled Is an extension controlling the home page?
   */
  _renderCustomSettings(options = {}) {
    let { shouldShow, isControlled } = options;
    const customSettingsContainerEl = document.getElementById("customSettings");
    const customUrlEl = document.getElementById("homePageUrl");
    const homePage = HomePage.get();

    const isHomePageCustom =
      isControlled ||
      (!this._isHomePageDefaultValue() && !this.isHomePageBlank());
    if (typeof shouldShow === "undefined") {
      shouldShow = isHomePageCustom;
    }
    customSettingsContainerEl.hidden = !shouldShow;

    // We can't use isHomePageDefaultValue and isHomePageBlank here because we want to disregard the blank
    // possibility triggered by the browser.startup.page being 0.
    // We also skip when HomePage is locked because it might be locked to a default that isn't "about:home"
    // (and it makes existing tests happy).
    let newValue;
    if (
      homePage === "about:blank" ||
      (HomePage.isDefault && !HomePage.locked)
    ) {
      newValue = "";
    } else {
      newValue = homePage;
    }
    if (customUrlEl.value !== newValue) {
      customUrlEl.value = newValue;
    }
  },

  /**
   * _isHomePageDefaultValue
   * @returns {bool} Is the homepage set to the default pref value?
   */
  _isHomePageDefaultValue() {
    const startupPref = Preferences.get("browser.startup.page");
    return (
      startupPref.value !== gMainPane.STARTUP_PREF_BLANK && HomePage.isDefault
    );
  },

  /**
   * isHomePageBlank
   * @returns {bool} Is the homepage set to about:blank?
   */
  isHomePageBlank() {
    const startupPref = Preferences.get("browser.startup.page");
    return (
      ["about:blank", ""].includes(HomePage.get()) ||
      startupPref.value === gMainPane.STARTUP_PREF_BLANK
    );
  },
  /**
   * isHomePageControlled
   * @resolves {bool} Is the homepage being controlled by an extension?
   * @returns {Promise}
   */
  isHomePageControlled() {
    if (HomePage.locked) {
      return Promise.resolve(false);
    }
    return handleControllingExtension(PREF_SETTING_TYPE, HOMEPAGE_OVERRIDE_KEY);
  },

  /**
   * _isTabAboutPreferences: Is a given tab set to about:preferences?
   * @param {Element} aTab A tab element
   * @returns {bool} Is the linkedBrowser of aElement set to about:preferences?
   */
  _isTabAboutPreferences(aTab) {
    return aTab.linkedBrowser.currentURI.spec.startsWith("about:preferences");
  },

  /**
   * _getTabsForHomePage
   * @returns {Array} An array of current tabs
   */
  _getTabsForHomePage() {
    let tabs = [];
    let win = Services.wm.getMostRecentWindow("navigator:browser");

    // We should only include visible & non-pinned tabs
    if (
      win &&
      win.document.documentElement.getAttribute("windowtype") ===
        "navigator:browser"
    ) {
      tabs = win.gBrowser.visibleTabs.slice(win.gBrowser._numPinnedTabs);
      tabs = tabs.filter(tab => !this._isTabAboutPreferences(tab));
      // XXX: Bug 1441637 - Fix tabbrowser to report tab.closing before it blurs it
      tabs = tabs.filter(tab => !tab.closing);
    }

    return tabs;
  },

  _renderHomepageMode(isControlled) {
    const isDefault = this._isHomePageDefaultValue();
    const isBlank = this.isHomePageBlank();
    const el = document.getElementById("homeMode");
    let newValue;

    if (isControlled) {
      newValue = this.HOME_MODE_CUSTOM;
    } else if (isDefault) {
      newValue = this.HOME_MODE_FIREFOX_HOME;
    } else if (isBlank) {
      newValue = this.HOME_MODE_BLANK;
    } else {
      newValue = this.HOME_MODE_CUSTOM;
    }
    if (el.value !== newValue) {
      el.value = newValue;
    }
  },

  _setInputDisabledStates(isControlled) {
    let tabCount = this._getTabsForHomePage().length;

    // Disable or enable the inputs based on if this is controlled by an extension.
    document
      .querySelectorAll(".check-home-page-controlled")
      .forEach(element => {
        let isDisabled;
        let pref =
          element.getAttribute("preference") ||
          element.getAttribute("data-preference-related");
        if (!pref) {
          throw new Error(
            `Element with id ${element.id} did not have preference or data-preference-related attribute defined.`
          );
        }

        if (pref === this.HOMEPAGE_PREF) {
          isDisabled = HomePage.locked || isControlled;
        } else {
          isDisabled = Preferences.get(pref).locked || isControlled;
        }

        if (pref === "pref.browser.disable_button.current_page") {
          // Special case for current_page to disable it if tabCount is 0
          isDisabled = isDisabled || tabCount < 1;
        }

        element.disabled = isDisabled;
      });
  },

  async _handleHomePageOverrides() {
    if (HomePage.locked) {
      // An extension can't control these settings if they're locked.
      hideControllingExtension(HOMEPAGE_OVERRIDE_KEY);
      this._setInputDisabledStates(false);
    } else {
      const isControlled = await this.isHomePageControlled();
      this._setInputDisabledStates(isControlled);
      this._renderCustomSettings({ isControlled });
      this._renderHomepageMode(isControlled);
    }
  },

  syncFromHomePref() {
    this._updateUseCurrentButton();
    this._renderCustomSettings();
    this._renderHomepageMode();
    this._handleHomePageOverrides();
  },

  syncFromNewTabPref() {
    const newtabPref = Preferences.get(this.NEWTAB_ENABLED_PREF);
    return newtabPref.value
      ? this.HOME_MODE_FIREFOX_HOME
      : this.HOME_MODE_BLANK;
  },

  syncToNewTabPref(value) {
    return value !== this.HOME_MODE_BLANK;
  },

  onMenuChange(event) {
    const { value } = event.target;
    const startupPref = Preferences.get("browser.startup.page");

    switch (value) {
      case this.HOME_MODE_FIREFOX_HOME:
        if (startupPref.value === gMainPane.STARTUP_PREF_BLANK) {
          startupPref.value = gMainPane.STARTUP_PREF_HOMEPAGE;
        }
        if (!HomePage.isDefault) {
          HomePage.reset();
        } else {
          this._renderCustomSettings({ shouldShow: false });
        }
        break;
      case this.HOME_MODE_BLANK:
        if (HomePage.get() !== "about:blank") {
          HomePage.safeSet("about:blank");
        } else {
          this._renderCustomSettings({ shouldShow: false });
        }
        break;
      case this.HOME_MODE_CUSTOM:
        if (startupPref.value === gMainPane.STARTUP_PREF_BLANK) {
          Services.prefs.clearUserPref(startupPref.id);
        }
        if (HomePage.getDefault() != HomePage.getOriginalDefault()) {
          HomePage.clear();
        }
        this._renderCustomSettings({ shouldShow: true });
        break;
    }
  },

  /**
   * Switches the "Use Current Page" button between its singular and plural
   * forms.
   */
  async _updateUseCurrentButton() {
    let useCurrent = document.getElementById("useCurrentBtn");
    let tabs = this._getTabsForHomePage();
    const tabCount = tabs.length;
    document.l10n.setAttributes(useCurrent, "use-current-pages", { tabCount });

    // If the homepage is controlled by an extension then you can't use this.
    if (
      await getControllingExtensionInfo(
        PREF_SETTING_TYPE,
        HOMEPAGE_OVERRIDE_KEY
      )
    ) {
      return;
    }

    // In this case, the button's disabled state is set by preferences.xml.
    let prefName = "pref.browser.homepage.disable_button.current_page";
    if (Preferences.get(prefName).locked) {
      return;
    }

    useCurrent.disabled = tabCount < 1;
  },

  /**
   * Sets the home page to the URL(s) of any currently opened tab(s),
   * updating about:preferences#home UI to reflect this.
   */
  setHomePageToCurrent() {
    let tabs = this._getTabsForHomePage();
    function getTabURI(t) {
      return t.linkedBrowser.currentURI.spec;
    }

    // FIXME Bug 244192: using dangerous "|" joiner!
    if (tabs.length) {
      HomePage.set(tabs.map(getTabURI).join("|")).catch(Cu.reportError);
    }

    Services.telemetry.scalarAdd("preferences.use_current_page", 1);
  },

  _setHomePageToBookmarkClosed(rv, aEvent) {
    if (aEvent.detail.button != "accept") {
      return;
    }
    if (rv.urls && rv.names) {
      // XXX still using dangerous "|" joiner!
      HomePage.set(rv.urls.join("|")).catch(Cu.reportError);
    }
  },

  /**
   * Displays a dialog in which the user can select a bookmark to use as home
   * page.  If the user selects a bookmark, that bookmark's name is displayed in
   * UI and the bookmark's address is stored to the home page preference.
   */
  setHomePageToBookmark() {
    const rv = { urls: null, names: null };
    gSubDialog.open(
      "chrome://browser/content/preferences/dialogs/selectBookmark.xhtml",
      "resizable=yes, modal=yes",
      rv,
      this._setHomePageToBookmarkClosed.bind(this, rv)
    );
    Services.telemetry.scalarAdd("preferences.use_bookmark", 1);
  },

  restoreDefaultHomePage() {
    HomePage.reset();
    Services.prefs.clearUserPref(this.NEWTAB_ENABLED_PREF);
  },

  onCustomHomePageInput(event) {
    if (this._telemetryHomePageTimer) {
      clearTimeout(this._telemetryHomePageTimer);
    }
    let browserHomePage = event.target.value;
    // The length of the home page URL string should be more then four,
    // and it should contain at least one ".", for example, "https://mozilla.org".
    if (browserHomePage.length > 4 && browserHomePage.includes(".")) {
      this._telemetryHomePageTimer = setTimeout(() => {
        let homePageNumber = browserHomePage.split("|").length;
        Services.telemetry.scalarAdd("preferences.browser_home_page_change", 1);
        Services.telemetry.keyedScalarAdd(
          "preferences.browser_home_page_count",
          homePageNumber,
          1
        );
      }, 3000);
    }
  },

  onCustomHomePageChange(event) {
    const value = event.target.value || HomePage.getDefault();
    HomePage.set(value).catch(Cu.reportError);
  },

  /**
   * Check all Home Tab preferences for user set values.
   */
  _changedHomeTabDefaultPrefs() {
    // If Discovery Stream is enabled Firefox Home Content preference options are hidden
    const homeContentChanged =
      !this.isPocketNewtabEnabled &&
      this.homePanePrefs.some(pref => pref.hasUserValue);
    const newtabPref = Preferences.get(this.NEWTAB_ENABLED_PREF);

    return homeContentChanged || HomePage.overridden || newtabPref.hasUserValue;
  },

  /**
   * Show the Restore Defaults button if any preference on the Home tab was
   * changed, or hide it otherwise.
   */
  toggleRestoreDefaultsBtn() {
    const btn = document.getElementById("restoreDefaultHomePageBtn");
    const prefChanged = this._changedHomeTabDefaultPrefs();
    btn.style.visibility = prefChanged ? "visible" : "hidden";
  },

  /**
   * Set all prefs on the Home tab back to their default values.
   */
  restoreDefaultPrefsForHome() {
    this.restoreDefaultHomePage();
    // If Discovery Stream is enabled Firefox Home Content preference options are hidden
    if (!this.isPocketNewtabEnabled) {
      this.homePanePrefs.forEach(pref => Services.prefs.clearUserPref(pref.id));
    }
  },

  init() {
    // Event Listeners
    document
      .getElementById("homeMode")
      .addEventListener("command", this.onMenuChange.bind(this));
    document
      .getElementById("homePageUrl")
      .addEventListener("change", this.onCustomHomePageChange.bind(this));
    document
      .getElementById("homePageUrl")
      .addEventListener("input", this.onCustomHomePageInput.bind(this));
    document
      .getElementById("useCurrentBtn")
      .addEventListener("command", this.setHomePageToCurrent.bind(this));
    document
      .getElementById("useBookmarkBtn")
      .addEventListener("command", this.setHomePageToBookmark.bind(this));
    document
      .getElementById("restoreDefaultHomePageBtn")
      .addEventListener("command", this.restoreDefaultPrefsForHome.bind(this));

    Preferences.addSyncFromPrefListener(
      document.getElementById("homePrefHidden"),
      () => this.syncFromHomePref()
    );
    Preferences.addSyncFromPrefListener(
      document.getElementById("newTabMode"),
      () => this.syncFromNewTabPref()
    );
    Preferences.addSyncToPrefListener(
      document.getElementById("newTabMode"),
      element => this.syncToNewTabPref(element.value)
    );

    this._updateUseCurrentButton();
    window.addEventListener("focus", this._updateUseCurrentButton.bind(this));

    // Extension/override-related events
    this.watchNewTab();
    document
      .getElementById("disableHomePageExtension")
      .addEventListener(
        "command",
        makeDisableControllingExtension(
          PREF_SETTING_TYPE,
          HOMEPAGE_OVERRIDE_KEY
        )
      );
    document
      .getElementById("disableNewTabExtension")
      .addEventListener(
        "command",
        makeDisableControllingExtension(URL_OVERRIDES_TYPE, NEW_TAB_KEY)
      );

    this.watchHomeTabPrefChange();
    // Notify observers that the UI is now ready
    Services.obs.notifyObservers(window, "home-pane-loaded");
  },
};
