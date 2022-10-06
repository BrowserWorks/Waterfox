/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* eslint-env mozilla/browser-window */
"use strict";

const { PrefUtils } = ChromeUtils.import("resource:///modules/PrefUtils.jsm");

XPCOMUtils.defineLazyServiceGetter(
  this,
  "styleSheetService",
  "@mozilla.org/content/style-sheet-service;1",
  "nsIStyleSheetService"
);

var gThemePane = {
  WATERFOX_THEME_PREF: "userChrome.theme.enable",

  get preferences() {
    return [
      // Waterfox Customizations
      { id: "userChrome.theme.enable", type: "bool" },

      // Tab Bar
      { id: "userChrome.autohide.tab", type: "bool" },
      { id: "userChrome.autohide.tab.blur", type: "bool" },
      { id: "userChrome.autohide.tabbar", type: "bool" },
      { id: "userChrome.centered.tab", type: "bool" },
      { id: "userChrome.centered.tab.label", type: "bool" },
      { id: "userChrome.rounding.square_tab", type: "bool" },
      { id: "userChrome.padding.drag_space", type: "bool" },
      { id: "userChrome.tab.close_button_at_hover", type: "bool" },

      // Nav Bar
      { id: "userChrome.autohide.back_button", type: "bool" },
      { id: "userChrome.autohide.forward_button", type: "bool" },
      { id: "userChrome.autohide.page_action", type: "bool" },
      { id: "userChrome.hidden.urlbar_iconbox", type: "bool" },
      { id: "userChrome.centered.urlbar", type: "bool" },
      { id: "userChrome.rounding.square_button", type: "bool" },
      { id: "userChrome.padding.urlView_expanding", type: "bool" },

      // Bookmarks Bar
      { id: "userChrome.autohide.bookmarkbar", type: "bool" },
      { id: "userChrome.centered.bookmarkbar", type: "bool" },
      { id: "userChrome.hidden.bookmarkbar_icon", type: "bool" },
      { id: "userChrome.hidden.bookmarkbar_label", type: "bool" },

      // Panels
      { id: "userChrome.decoration.disable_panel_animate", type: "bool" },
      { id: "userChrome.hidden.disabled_menu", type: "bool" },
      { id: "userChrome.rounding.square_panel", type: "bool" },
      { id: "userChrome.rounding.square_panelitem", type: "bool" },
      { id: "userChrome.rounding.square_menupopup", type: "bool" },
      { id: "userChrome.rounding.square_menuitem", type: "bool" },
      { id: "userChrome.rounding.square_field", type: "bool" },
      { id: "userChrome.rounding.square_checklabel", type: "bool" },
      { id: "userChrome.padding.menu_compact", type: "bool" },
      { id: "userChrome.padding.bookmark_menu.compact", type: "bool" },
      { id: "userChrome.padding.panel_header", type: "bool" },
      { id: "userChrome.panel.remove_strip", type: "bool" },
      { id: "userChrome.panel.full_width_separator", type: "bool" },

      // Sidebar
      { id: "userChrome.decoration.disable_sidebar_animate", type: "bool" },
      { id: "userChrome.autohide.sidebar", type: "bool" },
      { id: "userChrome.hidden.sidebar_header", type: "bool" },

      // Icons
      { id: "userChrome.hidden.tab_icon", type: "bool" },
      { id: "userChrome.icon.menu.full", type: "bool" },
      { id: "userChrome.icon.global_menu.mac", type: "bool" },

      // Media Player
      { id: "userContent.player.ui.twoline", type: "bool" },

      // Font
      { id: "userContent.page.monospace", type: "bool" },
    ];
  },

  init() {
    // Initialize prefs
    window.Preferences.addAll(this.preferences);
    const userChromeEnabled = PrefUtils.get(this.WATERFOX_THEME_PREF);

    // Init refresh button
    let refreshButton = document.getElementById("refreshWaterfoxCustomTheme");
    if (refreshButton) {
      refreshButton.addEventListener("click", e => {
        this.refreshTheme();
        e.preventDefault;
      });
      refreshButton.hidden = !userChromeEnabled;
      PrefUtils.addObserver(this.WATERFOX_THEME_PREF, isEnabled => {
        refreshButton.hidden = !isEnabled;
      });
    }

    // Init theme customizations
    let waterfoxCustomizations = document.getElementById(
      "waterfoxUserChromeCustomizations"
    );
    if (waterfoxCustomizations) {
      refreshButton.hidden = !userChromeEnabled;
      PrefUtils.addObserver(this.WATERFOX_THEME_PREF, isEnabled => {
        refreshButton.hidden = !isEnabled;
      });
    }
  },

  refreshTheme() {
    const userChromeSheet = "chrome://browser/skin/userChrome.css";
    const userContentSheet = "chrome://browser/skin/userContent.css";

    this.unregisterStylesheet(userChromeSheet);
    this.unregisterStylesheet(userContentSheet);
    this.registerStylesheet(userChromeSheet);
    this.registerStylesheet(userContentSheet);
  },

  registerStylesheet(uri) {
    let url = Services.io.newURI(uri);
    let type = styleSheetService.USER_SHEET;
    styleSheetService.loadAndRegisterSheet(url, type);
  },

  unregisterStylesheet(uri) {
    let url = Services.io.newURI(uri);
    let type = styleSheetService.USER_SHEET;
    styleSheetService.unregisterSheet(url, type);
  },
};
