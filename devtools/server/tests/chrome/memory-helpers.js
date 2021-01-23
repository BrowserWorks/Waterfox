/* exported Task, startServerAndGetSelectedTabMemory, destroyServerAndFinish,
   waitForTime, waitUntil */
"use strict";

const { require } = ChromeUtils.import("resource://devtools/shared/Loader.jsm");
const Services = require("Services");
const { TargetFactory } = require("devtools/client/framework/target");

// Always log packets when running tests.
Services.prefs.setBoolPref("devtools.debugger.log", true);
var gReduceTimePrecision = Services.prefs.getBoolPref(
  "privacy.reduceTimerPrecision"
);
Services.prefs.setBoolPref("privacy.reduceTimerPrecision", false);
SimpleTest.registerCleanupFunction(function() {
  Services.prefs.clearUserPref("devtools.debugger.log");
  Services.prefs.setBoolPref(
    "privacy.reduceTimerPrecision",
    gReduceTimePrecision
  );
});

async function getTargetForSelectedTab() {
  const browserWindow = Services.wm.getMostRecentWindow("navigator:browser");
  const target = await TargetFactory.forTab(browserWindow.gBrowser.selectedTab);
  return target;
}

async function startServerAndGetSelectedTabMemory() {
  const target = await getTargetForSelectedTab();
  const memory = await target.getFront("memory");
  return { memory, target };
}

async function destroyServerAndFinish(target) {
  await target.destroy();
  SimpleTest.finish();
}

function waitForTime(ms) {
  return new Promise((resolve, reject) => {
    setTimeout(resolve, ms);
  });
}

function waitUntil(predicate) {
  if (predicate()) {
    return Promise.resolve(true);
  }
  return new Promise(resolve =>
    setTimeout(() => waitUntil(predicate).then(() => resolve(true)), 10)
  );
}
