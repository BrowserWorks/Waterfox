"use strict";

module.exports = {
  // Extend from the shared list of defined globals for mochitests.
  "extends": "../../../.eslintrc.mochitests.js",
  // All globals made available in aboutdebugging head.js file.
  "globals": {
    "AddonManager": true,
    "addTab": true,
    "assertHasTarget": true,
    "CHROME_ROOT": true,
    "changeAboutDebuggingHash": true,
    "closeAboutDebugging": true,
    "getServiceWorkerList": true,
    "getSupportsFile": true,
    "installAddon": true,
    "openAboutDebugging": true,
    "openPanel": true,
    "removeTab": true,
    "uninstallAddon": true,
    "unregisterServiceWorker": true,
    "waitForInitialAddonList": true,
    "waitForMutation": true,
    "waitForServiceWorkerRegistered": true
  }
};
