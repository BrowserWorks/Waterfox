/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["LightweightThemes"];

const { AddonManager } = ChromeUtils.import(
  "resource://gre/modules/AddonManager.jsm"
);

var LightweightThemes = {
  init(libDir) {},

  configurations: {
    noLWT: {
      selectors: [],
      async applyConfig() {
        let addon = await AddonManager.getAddonByID(
          "default-theme@mozilla.org"
        );
        await addon.enable();
      },
    },

    abyss: {
      selectors: [],
      async applyConfig() {
        let addon = await AddonManager.getAddonByID(
          "abyss@waterfox.net"
        );
        await addon.enable();
      },
    },

    floe: {
      selectors: [],
      async applyConfig() {
        let addon = await AddonManager.getAddonByID(
          "floe@waterfox.net"
        );
        await addon.enable();
      },
    },

  },
};
