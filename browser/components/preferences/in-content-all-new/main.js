/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */
/* import-globals-from ../../../base/content/aboutDialog-appUpdater.js */

var { TransientPrefs } = ChromeUtils.import(
  "resource:///modules/TransientPrefs.jsm"
);
var { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);
var { L10nRegistry } = ChromeUtils.import(
  "resource://gre/modules/L10nRegistry.jsm"
);
var { Localization } = ChromeUtils.import(
  "resource://gre/modules/Localization.jsm"
);
var { HomePage } = ChromeUtils.import("resource:///modules/HomePage.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "SelectionChangedMenulist",
  "resource:///modules/SelectionChangedMenulist.jsm"
);

if (AppConstants.MOZ_DEV_EDITION) {
  ChromeUtils.defineModuleGetter(
    this,
    "fxAccounts",
    "resource://gre/modules/FxAccounts.jsm"
  );
  ChromeUtils.defineModuleGetter(
    this,
    "FxAccounts",
    "resource://gre/modules/FxAccounts.jsm"
  );
}

Preferences.addAll([
  // Startup
  { id: "browser.startup.page", type: "int" },
  { id: "browser.privatebrowsing.autostart", type: "bool" },
  { id: "browser.sessionstore.warnOnQuit", type: "bool" },

  // Languages
  { id: "browser.translation.detectLanguage", type: "bool" },
]);

if (AppConstants.HAVE_SHELL_SERVICE) {
  Preferences.addAll([
    { id: "browser.shell.checkDefaultBrowser", type: "bool" },
    { id: "pref.general.disable_button.default_browser", type: "bool" },
  ]);
}

// Load the preferences string bundle for other locales with fallbacks.
function getBundleForLocales(newLocales) {
  let locales = Array.from(
    new Set([
      ...newLocales,
      ...Services.locale.requestedLocales,
      Services.locale.lastFallbackLocale,
    ])
  );
  function generateBundles(resourceIds) {
    return L10nRegistry.generateBundles(locales, resourceIds);
  }
  return new Localization(
    ["browser/preferences/preferences.ftl", "branding/brand.ftl"],
    generateBundles
  );
}

var gNodeToObjectMap = new WeakMap();

var gMainPane = {
  // browser.startup.page values
  STARTUP_PREF_BLANK: 0,
  STARTUP_PREF_HOMEPAGE: 1,
  STARTUP_PREF_RESTORE_SESSION: 3,

  // Convenience & Performance Shortcuts

  get _brandShortName() {
    delete this._brandShortName;
    return (this._brandShortName = document
      .getElementById("bundleBrand")
      .getString("brandShortName"));
  },

  get _prefsBundle() {
    delete this._prefsBundle;
    return (this._prefsBundle = document.getElementById("bundlePreferences"));
  },

  _backoffIndex: 0,

  /**
   * Initialization of this.
   */
  init() {
    function setEventListener(aId, aEventType, aCallback) {
      document
        .getElementById(aId)
        .addEventListener(aEventType, aCallback.bind(gMainPane));
    }

    if (AppConstants.HAVE_SHELL_SERVICE) {
      this.updateSetDefaultBrowser();
      let win = Services.wm.getMostRecentWindow("navigator:browser");

      // Exponential backoff mechanism will delay the polling times if user doesn't
      // trigger SetDefaultBrowser for a long time.
      let backoffTimes = [
        1000,
        1000,
        1000,
        1000,
        2000,
        2000,
        2000,
        5000,
        5000,
        10000,
      ];

      let pollForDefaultBrowser = () => {
        let uri = win.gBrowser.currentURI.spec;

        if (
          (uri == "about:preferences" || uri == "about:preferences#general") &&
          document.visibilityState == "visible"
        ) {
          this.updateSetDefaultBrowser();
        }

        // approximately a "requestIdleInterval"
        window.setTimeout(() => {
          window.requestIdleCallback(pollForDefaultBrowser);
        }, backoffTimes[this._backoffIndex + 1 < backoffTimes.length ? this._backoffIndex++ : backoffTimes.length - 1]);
      };

      window.setTimeout(() => {
        window.requestIdleCallback(pollForDefaultBrowser);
      }, backoffTimes[this._backoffIndex]);
    }

    if (Services.prefs.getBoolPref("intl.multilingual.enabled")) {
      gMainPane.initBrowserLocale();
    }

    // Startup pref
    setEventListener(
      "browserRestoreSession",
      "command",
      gMainPane.onBrowserRestoreSessionChange
    );
    gMainPane.updateBrowserStartupUI = gMainPane.updateBrowserStartupUI.bind(
      gMainPane
    );
    Preferences.get("browser.privatebrowsing.autostart").on(
      "change",
      gMainPane.updateBrowserStartupUI
    );
    Preferences.get("browser.startup.page").on(
      "change",
      gMainPane.updateBrowserStartupUI
    );
    Preferences.get("browser.startup.homepage").on(
      "change",
      gMainPane.updateBrowserStartupUI
    );
    gMainPane.updateBrowserStartupUI();

    let connectionSettingsLink = document.getElementById(
      "connectionSettingsLearnMore"
    );
    let connectionSettingsUrl =
      Services.urlFormatter.formatURLPref("app.support.baseURL") +
      "prefs-connection-settings";
    connectionSettingsLink.setAttribute("href", connectionSettingsUrl);
    this.updateProxySettingsUI();
    initializeProxyUI(gMainPane);

    setEventListener(
      "connectionSettings",
      "command",
      gMainPane.showConnections
    );

    if (AppConstants.HAVE_SHELL_SERVICE) {
      setEventListener(
        "setDefaultButton",
        "command",
        gMainPane.setDefaultBrowser
      );
    }
    setEventListener("chooseLanguage", "command", gMainPane.showLanguages);
    setEventListener(
      "translationAttributionImage",
      "click",
      gMainPane.openTranslationProviderAttribution
    );
    setEventListener(
      "translateButton",
      "command",
      gMainPane.showTranslationExceptions
    );

    // Show translation preferences if we may:
    const prefName = "browser.translation.ui.show";
    if (Services.prefs.getBoolPref(prefName)) {
      let row = document.getElementById("translationBox");
      row.removeAttribute("hidden");
      // Showing attribution only for Bing Translator.
      var { Translation } = ChromeUtils.import(
        "resource:///modules/translation/Translation.jsm"
      );
      if (Translation.translationEngine == "Bing") {
        document.getElementById("bingAttribution").removeAttribute("hidden");
      }
    }

    // Listen for window unload so we can remove our preference observers.
    window.addEventListener("unload", this);

    // Notify observers that the UI is now ready
    Services.obs.notifyObservers(window, "main-pane-loaded");

    this.setInitialized();
  },

  // HOME PAGE
  /*
   * Preferences:
   *
   * browser.startup.page
   * - what page(s) to show when the user starts the application, as an integer:
   *
   *     0: a blank page (DEPRECATED - this can be set via browser.startup.homepage)
   *     1: the home page (as set by the browser.startup.homepage pref)
   *     2: the last page the user visited (DEPRECATED)
   *     3: windows and tabs from the last session (a.k.a. session restore)
   *
   *   The deprecated option is not exposed in UI; however, if the user has it
   *   selected and doesn't change the UI for this preference, the deprecated
   *   option is preserved.
   */

  /**
   * Utility function to enable/disable the button specified by aButtonID based
   * on the value of the Boolean preference specified by aPreferenceID.
   */
  updateButtons(aButtonID, aPreferenceID) {
    var button = document.getElementById(aButtonID);
    var preference = Preferences.get(aPreferenceID);
    button.disabled = !preference.value;
    return undefined;
  },

  /**
   * Hide/show the "Show my windows and tabs from last time" option based
   * on the value of the browser.privatebrowsing.autostart pref.
   */
  updateBrowserStartupUI() {
    const pbAutoStartPref = Preferences.get(
      "browser.privatebrowsing.autostart"
    );
    const startupPref = Preferences.get("browser.startup.page");

    let newValue;
    let checkbox = document.getElementById("browserRestoreSession");
    let warnOnQuitCheckbox = document.getElementById(
      "browserRestoreSessionQuitWarning"
    );
    if (pbAutoStartPref.value || startupPref.locked) {
      checkbox.setAttribute("disabled", "true");
      warnOnQuitCheckbox.setAttribute("disabled", "true");
    } else {
      checkbox.removeAttribute("disabled");
    }
    newValue = pbAutoStartPref.value
      ? false
      : startupPref.value === this.STARTUP_PREF_RESTORE_SESSION;
    if (checkbox.checked !== newValue) {
      checkbox.checked = newValue;
      let warnOnQuitPref = Preferences.get("browser.sessionstore.warnOnQuit");
      if (newValue && !warnOnQuitPref.locked && !pbAutoStartPref.value) {
        warnOnQuitCheckbox.removeAttribute("disabled");
      } else {
        warnOnQuitCheckbox.setAttribute("disabled", "true");
      }
    }
  },

  initBrowserLocale() {
    // Enable telemetry.
    Services.telemetry.setEventRecordingEnabled(
      "intl.ui.browserLanguage",
      true
    );

    // This will register the "command" listener.
    let menulist = document.getElementById("defaultBrowserLanguage");
    new SelectionChangedMenulist(menulist, event => {
      gMainPane.onBrowserLanguageChange(event);
    });

    gMainPane.setBrowserLocales(Services.locale.appLocaleAsBCP47);
  },

  /**
   * Update the available list of locales and select the locale that the user
   * is "selecting". This could be the currently requested locale or a locale
   * that the user would like to switch to after confirmation.
   */
  async setBrowserLocales(selected) {
    let available = await getAvailableLocales();
    let localeNames = Services.intl.getLocaleDisplayNames(undefined, available);
    let locales = available.map((code, i) => ({ code, name: localeNames[i] }));
    locales.sort((a, b) => a.name > b.name);

    let fragment = document.createDocumentFragment();
    for (let { code, name } of locales) {
      let menuitem = document.createXULElement("menuitem");
      menuitem.setAttribute("value", code);
      menuitem.setAttribute("label", name);
      fragment.appendChild(menuitem);
    }

    // Add an option to search for more languages if downloading is supported.
    if (Services.prefs.getBoolPref("intl.multilingual.downloadEnabled")) {
      let menuitem = document.createXULElement("menuitem");
      menuitem.id = "defaultBrowserLanguageSearch";
      menuitem.setAttribute(
        "label",
        await document.l10n.formatValue("browser-languages-search")
      );
      menuitem.setAttribute("value", "search");
      fragment.appendChild(menuitem);
    }

    let menulist = document.getElementById("defaultBrowserLanguage");
    let menupopup = menulist.querySelector("menupopup");
    menupopup.textContent = "";
    menupopup.appendChild(fragment);
    menulist.value = selected;

    document.getElementById("browserLanguagesBox").hidden = false;
  },

  /* Show the confirmation message bar to allow a restart into the new locales. */
  async showConfirmLanguageChangeMessageBar(locales) {
    let messageBar = document.getElementById("confirmBrowserLanguage");

    // Get the bundle for the new locale.
    let newBundle = getBundleForLocales(locales);

    // Find the messages and labels.
    let messages = await Promise.all(
      [newBundle, document.l10n].map(async bundle =>
        bundle.formatValue("confirm-browser-language-change-description")
      )
    );
    let buttonLabels = await Promise.all(
      [newBundle, document.l10n].map(async bundle =>
        bundle.formatValue("confirm-browser-language-change-button")
      )
    );

    // If both the message and label are the same, just include one row.
    if (messages[0] == messages[1] && buttonLabels[0] == buttonLabels[1]) {
      messages.pop();
      buttonLabels.pop();
    }

    let contentContainer = messageBar.querySelector(
      ".message-bar-content-container"
    );
    contentContainer.textContent = "";

    for (let i = 0; i < messages.length; i++) {
      let messageContainer = document.createXULElement("hbox");
      messageContainer.classList.add("message-bar-content");
      messageContainer.setAttribute("flex", "1");
      messageContainer.setAttribute("align", "center");

      let description = document.createXULElement("description");
      description.classList.add("message-bar-description");
      description.setAttribute("flex", "1");
      description.textContent = messages[i];
      messageContainer.appendChild(description);

      let button = document.createXULElement("button");
      button.addEventListener(
        "command",
        gMainPane.confirmBrowserLanguageChange
      );
      button.classList.add("message-bar-button");
      button.setAttribute("locales", locales.join(","));
      button.setAttribute("label", buttonLabels[i]);
      messageContainer.appendChild(button);

      contentContainer.appendChild(messageContainer);
    }

    messageBar.hidden = false;
    gMainPane.selectedLocales = locales;
  },

  hideConfirmLanguageChangeMessageBar() {
    let messageBar = document.getElementById("confirmBrowserLanguage");
    messageBar.hidden = true;
    let contentContainer = messageBar.querySelector(
      ".message-bar-content-container"
    );
    contentContainer.textContent = "";
    gMainPane.requestingLocales = null;
  },

  /* Confirm the locale change and restart the browser in the new locale. */
  confirmBrowserLanguageChange(event) {
    let localesString = (event.target.getAttribute("locales") || "").trim();
    if (!localesString || localesString.length == 0) {
      return;
    }
    let locales = localesString.split(",");
    Services.locale.requestedLocales = locales;

    // Record the change in telemetry before we restart.
    gMainPane.recordBrowserLanguagesTelemetry("apply");

    // Restart with the new locale.
    let cancelQuit = Cc["@mozilla.org/supports-PRBool;1"].createInstance(
      Ci.nsISupportsPRBool
    );
    Services.obs.notifyObservers(
      cancelQuit,
      "quit-application-requested",
      "restart"
    );
    if (!cancelQuit.data) {
      Services.startup.quit(
        Services.startup.eAttemptQuit | Services.startup.eRestart
      );
    }
  },

  /* Show or hide the confirm change message bar based on the new locale. */
  onBrowserLanguageChange(event) {
    let locale = event.target.value;

    if (locale == "search") {
      gMainPane.showBrowserLanguages({ search: true });
      return;
    } else if (locale == Services.locale.appLocaleAsBCP47) {
      this.hideConfirmLanguageChangeMessageBar();
      return;
    }

    // Note the change in telemetry.
    gMainPane.recordBrowserLanguagesTelemetry("reorder");

    let locales = Array.from(
      new Set([locale, ...Services.locale.requestedLocales]).values()
    );
    this.showConfirmLanguageChangeMessageBar(locales);
  },

  onBrowserRestoreSessionChange(event) {
    const value = event.target.checked;
    const startupPref = Preferences.get("browser.startup.page");
    let newValue;

    let warnOnQuitCheckbox = document.getElementById(
      "browserRestoreSessionQuitWarning"
    );
    if (value) {
      // We need to restore the blank homepage setting in our other pref
      if (startupPref.value === this.STARTUP_PREF_BLANK) {
        HomePage.set("about:blank");
      }
      newValue = this.STARTUP_PREF_RESTORE_SESSION;
      let warnOnQuitPref = Preferences.get("browser.sessionstore.warnOnQuit");
      if (!warnOnQuitPref.locked) {
        warnOnQuitCheckbox.removeAttribute("disabled");
      }
    } else {
      newValue = this.STARTUP_PREF_HOMEPAGE;
      warnOnQuitCheckbox.setAttribute("disabled", "true");
    }
    startupPref.value = newValue;
  },
  /*
   * Preferences:
   *
   * browser.shell.checkDefault
   * - true if a default-browser check (and prompt to make it so if necessary)
   *   occurs at startup, false otherwise
   */

  /**
   * Show button for setting browser as default browser or information that
   * browser is already the default browser.
   */
  updateSetDefaultBrowser() {
    if (AppConstants.HAVE_SHELL_SERVICE) {
      let shellSvc = getShellService();
      let defaultBrowserBox = document.getElementById("defaultBrowserBox");
      if (!shellSvc) {
        defaultBrowserBox.hidden = true;
        return;
      }
      let setDefaultPane = document.getElementById("setDefaultPane");
      let isDefault = shellSvc.isDefaultBrowser(false, true);
      setDefaultPane.selectedIndex = isDefault ? 1 : 0;
      let alwaysCheck = document.getElementById("alwaysCheckDefault");
      alwaysCheck.disabled =
        alwaysCheck.disabled || (isDefault && alwaysCheck.checked);
    }
  },

  /**
   * Set browser as the operating system default browser.
   */
  setDefaultBrowser() {
    if (AppConstants.HAVE_SHELL_SERVICE) {
      let alwaysCheckPref = Preferences.get(
        "browser.shell.checkDefaultBrowser"
      );
      alwaysCheckPref.value = true;

      // Reset exponential backoff delay time in order to do visual update in pollForDefaultBrowser.
      this._backoffIndex = 0;

      let shellSvc = getShellService();
      if (!shellSvc) {
        return;
      }
      try {
        shellSvc.setDefaultBrowser(true, false);
      } catch (ex) {
        Cu.reportError(ex);
        return;
      }

      let selectedIndex = shellSvc.isDefaultBrowser(false, true) ? 1 : 0;
      document.getElementById("setDefaultPane").selectedIndex = selectedIndex;
    }
  },

  /**
   * Shows a dialog in which the preferred language for web content may be set.
   */
  showLanguages() {
    gSubDialog.open("chrome://browser/content/preferences/languages.xul");
  },

  recordBrowserLanguagesTelemetry(method, value = null) {
    Services.telemetry.recordEvent(
      "intl.ui.browserLanguage",
      method,
      "main",
      value
    );
  },

  showBrowserLanguages({ search }) {
    // Record the telemetry event with an id to associate related actions.
    let telemetryId = parseInt(
      Services.telemetry.msSinceProcessStart(),
      10
    ).toString();
    let method = search ? "search" : "manage";
    gMainPane.recordBrowserLanguagesTelemetry(method, telemetryId);

    let opts = { selected: gMainPane.selectedLocales, search, telemetryId };
    gSubDialog.open(
      "chrome://browser/content/preferences/browserLanguages.xul",
      null,
      opts,
      this.browserLanguagesClosed
    );
  },

  /* Show or hide the confirm change message bar based on the updated ordering. */
  browserLanguagesClosed() {
    let { accepted, selected } = this.gBrowserLanguagesDialog;
    let active = Services.locale.appLocalesAsBCP47;

    this.gBrowserLanguagesDialog.recordTelemetry(
      accepted ? "accept" : "cancel"
    );

    // Prepare for changing the locales if they are different than the current locales.
    if (selected && selected.join(",") != active.join(",")) {
      gMainPane.showConfirmLanguageChangeMessageBar(selected);
      gMainPane.setBrowserLocales(selected[0]);
      return;
    }

    // They matched, so we can reset the UI.
    gMainPane.setBrowserLocales(Services.locale.appLocaleAsBCP47);
    gMainPane.hideConfirmLanguageChangeMessageBar();
  },

  /**
   * Displays the translation exceptions dialog where specific site and language
   * translation preferences can be set.
   */
  showTranslationExceptions() {
    gSubDialog.open("chrome://browser/content/preferences/translation.xul");
  },

  openTranslationProviderAttribution() {
    var { Translation } = ChromeUtils.import(
      "resource:///modules/translation/Translation.jsm"
    );
    Translation.openProviderAttribution();
  },

  /**
   * Stores the original value of the spellchecking preference to enable proper
   * restoration if unchanged (since we're mapping a tristate onto a checkbox).
   */
  _storedSpellCheck: 0,

  /**
   * Returns true if any spellchecking is enabled and false otherwise, caching
   * the current value to enable proper pref restoration if the checkbox is
   * never changed.
   *
   * layout.spellcheckDefault
   * - an integer:
   *     0  disables spellchecking
   *     1  enables spellchecking, but only for multiline text fields
   *     2  enables spellchecking for all text fields
   */
  readCheckSpelling() {
    var pref = Preferences.get("layout.spellcheckDefault");
    this._storedSpellCheck = pref.value;

    return pref.value != 0;
  },

  /**
   * Returns the value of the spellchecking preference represented by UI,
   * preserving the preference's "hidden" value if the preference is
   * unchanged and represents a value not strictly allowed in UI.
   */
  writeCheckSpelling() {
    var checkbox = document.getElementById("checkSpelling");
    if (checkbox.checked) {
      if (this._storedSpellCheck == 2) {
        return 2;
      }
      return 1;
    }
    return 0;
  },

  destroy() {
    window.removeEventListener("unload", this);
  },

  // nsISupports

  QueryInterface: ChromeUtils.generateQI([Ci.nsIObserver]),

  // EventListener

  handleEvent(aEvent) {
    if (aEvent.type == "unload") {
      this.destroy();
    }
  },

  // NETWORK
  /**
   * Displays a dialog in which proxy settings may be changed.
   */
  showConnections() {
    gSubDialog.open(
      "chrome://browser/content/preferences/connection.xul",
      null,
      null,
      this.updateProxySettingsUI.bind(this)
    );
  },

  // Update the UI to show the proper description depending on whether an
  // extension is in control or not.
  async updateProxySettingsUI() {
    let controllingExtension = await getControllingExtension(
      PREF_SETTING_TYPE,
      PROXY_KEY
    );
    let description = document.getElementById("connectionSettingsDescription");

    if (controllingExtension) {
      setControllingExtensionDescription(
        description,
        controllingExtension,
        "proxy.settings"
      );
    } else {
      setControllingExtensionDescription(
        description,
        null,
        "network-proxy-connection-description"
      );
    }
  },
};

gMainPane.initialized = new Promise(res => {
  gMainPane.setInitialized = res;
});
