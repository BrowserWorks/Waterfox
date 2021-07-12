/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ContextMenuExtension",
  "resource://extensibles/ContextMenuExtension.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "AboutPreferencesExtension",
  "resource://extensibles/AboutPreferencesExtension.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "MenuBarExtension",
  "resource://extensibles/MenuBarExtension.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "Overlays",
  "resource:///modules/Overlays.jsm"
);

// define prefs
const COPY_TAB_PREF = "browser.tabs.copyurl";
const COPY_ALL_TABS_PREF = "browser.tabs.copyallurls";
const SHOW_RESTART_BUTTON_PREF = "browser.restart_menu.showpanelmenubtn";
