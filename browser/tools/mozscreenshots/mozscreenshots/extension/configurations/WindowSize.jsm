/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["WindowSize"];

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Timer.jsm");
Cu.import("resource://testing-common/BrowserTestUtils.jsm");

this.WindowSize = {

  init(libDir) {
    Services.prefs.setBoolPref("browser.fullscreen.autohide", false);
  },

  configurations: {
    maximized: {
      async applyConfig() {
        let browserWindow = Services.wm.getMostRecentWindow("navigator:browser");
        await toggleFullScreen(browserWindow, false);

        // Wait for the Lion fullscreen transition to end as there doesn't seem to be an event
        // and trying to maximize while still leaving fullscreen doesn't work.
        await new Promise((resolve, reject) => {
          setTimeout(function waitToLeaveFS() {
            browserWindow.maximize();
            resolve();
          }, 5000);
        });
      },
    },

    normal: {
      async applyConfig() {
        let browserWindow = Services.wm.getMostRecentWindow("navigator:browser");
        await toggleFullScreen(browserWindow, false);
        browserWindow.restore();
        await new Promise((resolve, reject) => {
          setTimeout(resolve, 5000);
        });
      },
    },

    fullScreen: {
      async applyConfig() {
        let browserWindow = Services.wm.getMostRecentWindow("navigator:browser");
        await toggleFullScreen(browserWindow, true);
        // OS X Lion fullscreen transition takes a while
        await new Promise((resolve, reject) => {
          setTimeout(resolve, 5000);
        });
      },
    },
  },
};

function toggleFullScreen(browserWindow, wantsFS) {
  browserWindow.fullScreen = wantsFS;
  return BrowserTestUtils.waitForCondition(() => {
    return wantsFS == browserWindow.document.documentElement.hasAttribute("inFullscreen");
  }, "waiting for @inFullscreen change");
}
