/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Tests for ML Suggest backend.

"use strict";

ChromeUtils.defineESModuleGetters(this, {
  MLSuggest: "moz-src:///browser/components/urlbar/private/MLSuggest.sys.mjs",
  setTimeout: "resource://gre/modules/Timer.sys.mjs",
});

const ML_PREFS = ["browser.ml.enable", "quicksuggest.mlEnabled"];

let gSandbox;
let gInitializeStub;
let gShutdownStub;

add_setup(async function init() {
  // Stub `MLSuggest`.
  gSandbox = sinon.createSandbox();
  gInitializeStub = gSandbox.stub(MLSuggest, "initialize");
  gShutdownStub = gSandbox.stub(MLSuggest, "shutdown");

  // Enable Suggest but not the ML backend yet.
  await QuickSuggestTestUtils.ensureQuickSuggestInit({
    prefs: [
      ["suggest.quicksuggest.all", true],
      ["suggest.quicksuggest.sponsored", true],
    ],
  });
});

function enableMl(enable) {
  if (enable) {
    for (let p of ML_PREFS) {
      UrlbarPrefs.set(p, true);
    }
  } else {
    // This assumes the prefs are false by default, i.e., the ML backend is
    // disabled by default.
    for (let p of ML_PREFS) {
      UrlbarPrefs.clear(p);
    }
  }
}

// The ML backend should be disabled when the `suggest.quicksuggest.all` pref is
// false.
add_task(async function suggestAllPref() {
  enableMl(true);

  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  await QuickSuggestTestUtils.forceSync();

  Assert.ok(
    QuickSuggest.getFeature("SuggestBackendMl").isEnabled,
    "SuggestBackendMl should be enabled"
  );

  UrlbarPrefs.set("suggest.quicksuggest.all", false);
  await QuickSuggestTestUtils.forceSync();

  Assert.ok(
    !QuickSuggest.getFeature("SuggestBackendMl").isEnabled,
    "SuggestBackendMl should be disabled after setting `suggest.quicksuggest.all` to false"
  );

  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  await QuickSuggestTestUtils.forceSync();

  enableMl(false);
});

// Init shouldn't be delayed by default.
add_task(async function zeroDelay() {
  // The init timer is always used, its timeout is just set to zero when init
  // shouldn't be delayed. To test that there's no large delay, get the current
  // time, enable ML, wait for `initialize()` to be called, and then make sure
  // the elapsed time is small. Some CI machines are really slow, so this might
  // take longer than you think. Use a generous expected upper bound of 1s
  // (1000ms).
  let startMs = ChromeUtils.now();
  enableMl(true);
  await TestUtils.waitForCondition(
    () => gInitializeStub.callCount > 0,
    "Waiting for initialize to be called"
  );

  let elapsedMs = ChromeUtils.now() - startMs;
  Assert.less(
    elapsedMs,
    1000,
    "initialize should have been called quickly after enabling the backend"
  );

  enableMl(false);

  gInitializeStub.resetHistory();
  gShutdownStub.resetHistory();
});

// Delaying init should work properly.
add_task(async function delay() {
  // Delay by 4s. We use a large timeout because some CI machines are slow.
  let cleanUpNimbus = await UrlbarTestUtils.initNimbusFeature({
    quickSuggestMlInitDelaySeconds: 4,
  });

  enableMl(true);

  Assert.equal(
    gInitializeStub.callCount,
    0,
    "initialize should not have been called immediately after enabling ML"
  );

  await waitSeconds(2);

  Assert.equal(
    gInitializeStub.callCount,
    0,
    "initialize should not have been called after waiting 2s"
  );

  // Wait a generous 4 more seconds for a total of 6s.
  await waitSeconds(4);

  Assert.equal(
    gInitializeStub.callCount,
    1,
    "initialize should have been called after waiting a total of 6s"
  );

  enableMl(false);
  Assert.equal(
    gShutdownStub.callCount,
    1,
    "shutdown should have been called after disabling ML"
  );

  gInitializeStub.resetHistory();
  gShutdownStub.resetHistory();

  await cleanUpNimbus();
});

// `initialize` should not be called if the backend is disabled before the init
// timer fires.
add_task(async function disabledBeforeTimerFires() {
  let cleanUpNimbus = await UrlbarTestUtils.initNimbusFeature({
    quickSuggestMlInitDelaySeconds: 3,
  });

  enableMl(true);

  // Wait a little for better realism.
  await waitSeconds(1);

  enableMl(false);
  Assert.equal(
    gShutdownStub.callCount,
    1,
    "shutdown should have been called after disabling ML"
  );

  // Wait a generous 3 more seconds for a total of 4s.
  await waitSeconds(3);

  Assert.equal(
    gInitializeStub.callCount,
    0,
    "initialize should not have been called after waiting 2s"
  );

  gInitializeStub.resetHistory();
  gShutdownStub.resetHistory();

  await cleanUpNimbus();
});

async function waitSeconds(s) {
  info(`Waiting ${s} seconds...`);
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(r => setTimeout(r, s * 1000));
}
