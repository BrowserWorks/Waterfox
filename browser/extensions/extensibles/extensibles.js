/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["Extensibles"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

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
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "Overlays",
  "resource:///modules/Overlays.jsm"
);

var Extensibles = {
  loadContextOverlays() {
    new ContextMenuExtension();
  },
  // called in browser/components/preferences/main.js init
  init_prefToggles() {
    new AboutPreferencesExtension().init_prefTogglesInAllWindows();
  },
};
