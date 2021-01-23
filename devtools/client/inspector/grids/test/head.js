/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint no-unused-vars: [2, {"vars": "local"}] */
/* import-globals-from ../../../shared/test/shared-head.js */
/* import-globals-from ../../../shared/test/telemetry-test-helpers.js */
/* import-globals-from ../../test/head.js */
"use strict";

// Import the inspector's head.js first (which itself imports shared-head.js).
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/inspector/test/head.js",
  this
);

// Load the shared Redux helpers into this compartment.
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/shared/test/shared-redux-head.js",
  this
);

const asyncStorage = require("devtools/shared/async-storage");

Services.prefs.setIntPref("devtools.toolbox.footer.height", 350);
registerCleanupFunction(async function() {
  Services.prefs.clearUserPref("devtools.toolbox.footer.height");
  await asyncStorage.removeItem("gridInspectorHostColors");
});
