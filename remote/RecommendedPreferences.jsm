/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["RecommendedPreferences"];

const RecommendedPreferences = {
  // Allow the application to have focus even when it runs in the background.
  "focusmanager.testmode": true,

  // Avoid breaking odd-runs of firefox because of it running in safe mode.
  // Firefox will run in safe mode alsmost on every even/odd runs as
  // Puppeteer may very easily shutdown Firefox process brutaly and force
  // it to run in safe mode in the next run.
  "toolkit.startup.max_resumed_crashes": -1,

  // Prevent various error message on the console
  // jest-puppeteer asserts that no error message is emitted by the console
  "browser.contentblocking.features.standard":
    "-tp,tpPrivate,cookieBehavior0,-cm,-fp",
  "network.cookie.cookieBehavior": 0,
};
