/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */

Preferences.addAll([
  // Restart Menu Item
  { id: "browser.restart_menu.purgecache", type: "bool" },
  { id: "browser.restart_menu.requireconfirm", type: "bool" },
  { id: "browser.restart_menu.showpanelmenubtn", type: "bool" },

  // Status Bar
  { id: "browser.statusbar.mode", type: "int" },
  { id: "browser.statusbar.showbtn", type: "bool" },
]);

var gAppearancePane = {
    init() {
        // Notify observers that the UI is now ready
        Services.obs.notifyObservers(window, "appearance-pane-loaded");

        this.setInitialized();
    }
};

gAppearancePane.initialized = new Promise(res => {
  gAppearancePane.setInitialized = res;
});
