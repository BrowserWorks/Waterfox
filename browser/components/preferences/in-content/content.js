/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from preferences.js */
/* import-globals-from ../../../../toolkit/mozapps/preferences/fontbuilder.js */

XPCOMUtils.defineLazyGetter(this, "AlertsServiceDND", function() {
  try {
    let alertsService = Cc["@mozilla.org/alerts-service;1"]
                          .getService(Ci.nsIAlertsService)
                          .QueryInterface(Ci.nsIAlertsDoNotDisturb);
    // This will throw if manualDoNotDisturb isn't implemented.
    alertsService.manualDoNotDisturb;
    return alertsService;
  } catch (ex) {
    return undefined;
  }
});

var gContentPane = {
  init() {
    function setEventListener(aId, aEventType, aCallback) {
      document.getElementById(aId)
              .addEventListener(aEventType, aCallback.bind(gContentPane));
    }

    // Initializes the fonts dropdowns displayed in this pane.
    this._rebuildFonts();

    // Show translation preferences if we may:
    const prefName = "browser.translation.ui.show";
    if (Services.prefs.getBoolPref(prefName)) {
      let row = document.getElementById("translationBox");
      row.removeAttribute("hidden");
      // Showing attribution only for Bing Translator.
      Components.utils.import("resource:///modules/translation/Translation.jsm");
      if (Translation.translationEngine == "bing") {
        document.getElementById("bingAttribution").removeAttribute("hidden");
      }
    }

    if (AlertsServiceDND) {
      let notificationsDoNotDisturbRow =
        document.getElementById("notificationsDoNotDisturbRow");
      notificationsDoNotDisturbRow.removeAttribute("hidden");
      if (AlertsServiceDND.manualDoNotDisturb) {
        let notificationsDoNotDisturb =
          document.getElementById("notificationsDoNotDisturb");
        notificationsDoNotDisturb.setAttribute("checked", true);
      }
    }

    setEventListener("font.language.group", "change",
      gContentPane._rebuildFonts);
    setEventListener("notificationsPolicyButton", "command",
      gContentPane.showNotificationExceptions);
    setEventListener("popupPolicyButton", "command",
      gContentPane.showPopupExceptions);
    setEventListener("advancedFonts", "command",
      gContentPane.configureFonts);
    setEventListener("colors", "command",
      gContentPane.configureColors);
    setEventListener("chooseLanguage", "command",
      gContentPane.showLanguages);
    setEventListener("translationAttributionImage", "click",
      gContentPane.openTranslationProviderAttribution);
    setEventListener("translateButton", "command",
      gContentPane.showTranslationExceptions);
    setEventListener("notificationsDoNotDisturb", "command",
      gContentPane.toggleDoNotDisturbNotifications);

    let notificationInfoURL =
      Services.urlFormatter.formatURLPref("app.support.baseURL") + "push";
    document.getElementById("notificationsPolicyLearnMore").setAttribute("href",
                                                                         notificationInfoURL);

    let drmInfoURL =
      Services.urlFormatter.formatURLPref("app.support.baseURL") + "drm-content";
    document.getElementById("playDRMContentLink").setAttribute("href", drmInfoURL);
    let emeUIEnabled = Services.prefs.getBoolPref("browser.eme.ui.enabled");
    // Force-disable/hide on WinXP:
    if (navigator.platform.toLowerCase().startsWith("win")) {
      emeUIEnabled = emeUIEnabled && parseFloat(Services.sysinfo.get("version")) >= 6;
    }
    if (!emeUIEnabled) {
      // Don't want to rely on .hidden for the toplevel groupbox because
      // of the pane hiding/showing code potentially interfering:
      document.getElementById("drmGroup").setAttribute("style", "display: none !important");
    }
  },

  // UTILITY FUNCTIONS

  /**
   * Utility function to enable/disable the button specified by aButtonID based
   * on the value of the Boolean preference specified by aPreferenceID.
   */
  updateButtons(aButtonID, aPreferenceID) {
    var button = document.getElementById(aButtonID);
    var preference = document.getElementById(aPreferenceID);
    button.disabled = preference.value != true;
    return undefined;
  },

  // BEGIN UI CODE

  /*
   * Preferences:
   *
   * dom.disable_open_during_load
   * - true if popups are blocked by default, false otherwise
   */

  // NOTIFICATIONS

  /**
   * Displays the notifications exceptions dialog where specific site notification
   * preferences can be set.
   */
  showNotificationExceptions() {
    let bundlePreferences = document.getElementById("bundlePreferences");
    let params = { permissionType: "desktop-notification" };
    params.windowTitle = bundlePreferences.getString("notificationspermissionstitle");
    params.introText = bundlePreferences.getString("notificationspermissionstext4");

    gSubDialog.open("chrome://browser/content/preferences/permissions.xul",
                    "resizable=yes", params);

    try {
      Services.telemetry
              .getHistogramById("WEB_NOTIFICATION_EXCEPTIONS_OPENED").add();
    } catch (e) {}
  },


  // POP-UPS

  /**
   * Displays the popup exceptions dialog where specific site popup preferences
   * can be set.
   */
  showPopupExceptions() {
    var bundlePreferences = document.getElementById("bundlePreferences");
    var params = { blockVisible: false, sessionVisible: false, allowVisible: true,
                   prefilledHost: "", permissionType: "popup" }
    params.windowTitle = bundlePreferences.getString("popuppermissionstitle");
    params.introText = bundlePreferences.getString("popuppermissionstext");

    gSubDialog.open("chrome://browser/content/preferences/permissions.xul",
                    "resizable=yes", params);
  },

  // FONTS

  /**
   * Populates the default font list in UI.
   */
  _rebuildFonts() {
    var preferences = document.getElementById("contentPreferences");
    // Ensure preferences are "visible" to ensure bindings work.
    preferences.hidden = false;
    // Force flush:
    preferences.clientHeight;
    var langGroupPref = document.getElementById("font.language.group");
    this._selectDefaultLanguageGroup(langGroupPref.value,
                                     this._readDefaultFontTypeForLanguage(langGroupPref.value) == "serif");
  },

  /**
   *
   */
  _selectDefaultLanguageGroup(aLanguageGroup, aIsSerif) {
    const kFontNameFmtSerif         = "font.name.serif.%LANG%";
    const kFontNameFmtSansSerif     = "font.name.sans-serif.%LANG%";
    const kFontNameListFmtSerif     = "font.name-list.serif.%LANG%";
    const kFontNameListFmtSansSerif = "font.name-list.sans-serif.%LANG%";
    const kFontSizeFmtVariable      = "font.size.variable.%LANG%";

    var preferences = document.getElementById("contentPreferences");
    var prefs = [{ format: aIsSerif ? kFontNameFmtSerif : kFontNameFmtSansSerif,
                   type: "fontname",
                   element: "defaultFont",
                   fonttype: aIsSerif ? "serif" : "sans-serif" },
                 { format: aIsSerif ? kFontNameListFmtSerif : kFontNameListFmtSansSerif,
                   type: "unichar",
                   element: null,
                   fonttype: aIsSerif ? "serif" : "sans-serif" },
                 { format: kFontSizeFmtVariable,
                   type: "int",
                   element: "defaultFontSize",
                   fonttype: null }];
    for (var i = 0; i < prefs.length; ++i) {
      var preference = document.getElementById(prefs[i].format.replace(/%LANG%/, aLanguageGroup));
      if (!preference) {
        preference = document.createElement("preference");
        var name = prefs[i].format.replace(/%LANG%/, aLanguageGroup);
        preference.id = name;
        preference.setAttribute("name", name);
        preference.setAttribute("type", prefs[i].type);
        preferences.appendChild(preference);
      }

      if (!prefs[i].element)
        continue;

      var element = document.getElementById(prefs[i].element);
      if (element) {
        element.setAttribute("preference", preference.id);

        if (prefs[i].fonttype)
          FontBuilder.buildFontList(aLanguageGroup, prefs[i].fonttype, element);

        preference.setElementValue(element);
      }
    }
  },

  /**
   * Returns the type of the current default font for the language denoted by
   * aLanguageGroup.
   */
  _readDefaultFontTypeForLanguage(aLanguageGroup) {
    const kDefaultFontType = "font.default.%LANG%";
    var defaultFontTypePref = kDefaultFontType.replace(/%LANG%/, aLanguageGroup);
    var preference = document.getElementById(defaultFontTypePref);
    if (!preference) {
      preference = document.createElement("preference");
      preference.id = defaultFontTypePref;
      preference.setAttribute("name", defaultFontTypePref);
      preference.setAttribute("type", "string");
      preference.setAttribute("onchange", "gContentPane._rebuildFonts();");
      document.getElementById("contentPreferences").appendChild(preference);
    }
    return preference.value;
  },

  /**
   * Displays the fonts dialog, where web page font names and sizes can be
   * configured.
   */
  configureFonts() {
    gSubDialog.open("chrome://browser/content/preferences/fonts.xul", "resizable=no");
  },

  /**
   * Displays the colors dialog, where default web page/link/etc. colors can be
   * configured.
   */
  configureColors() {
    gSubDialog.open("chrome://browser/content/preferences/colors.xul", "resizable=no");
  },

  // LANGUAGES

  /**
   * Shows a dialog in which the preferred language for web content may be set.
   */
  showLanguages() {
    gSubDialog.open("chrome://browser/content/preferences/languages.xul");
  },

  /**
   * Displays the translation exceptions dialog where specific site and language
   * translation preferences can be set.
   */
  showTranslationExceptions() {
    gSubDialog.open("chrome://browser/content/preferences/translation.xul");
  },

  openTranslationProviderAttribution() {
    Components.utils.import("resource:///modules/translation/Translation.jsm");
    Translation.openProviderAttribution();
  },

  toggleDoNotDisturbNotifications(event) {
    AlertsServiceDND.manualDoNotDisturb = event.target.checked;
  },
};
