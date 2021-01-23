"use strict";

add_task(setup);

add_task(async function testDoorhangerUserReject() {
  // Set up a passing environment and enable DoH.
  setPassingHeuristics();
  let promise = waitForDoorhanger();
  let prefPromise = TestUtils.waitForPrefChange(prefs.DOH_SELF_ENABLED_PREF);
  Preferences.set(prefs.DOH_ENABLED_PREF, true);

  await prefPromise;
  is(Preferences.get(prefs.DOH_SELF_ENABLED_PREF), true, "Breadcrumb saved.");
  is(
    Preferences.get(prefs.DOH_TRR_SELECT_URI_PREF),
    "https://dummytrr.com/query",
    "TRR selection complete."
  );
  await checkTRRSelectionTelemetry();

  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, EXAMPLE_URL);
  let panel = await promise;
  is(
    Preferences.get(prefs.DOH_DOORHANGER_SHOWN_PREF),
    undefined,
    "Doorhanger shown pref undefined before user interaction."
  );

  await ensureTRRMode(2);
  await checkHeuristicsTelemetry("enable_doh", "startup");

  prefPromise = TestUtils.waitForPrefChange(prefs.DOH_DOORHANGER_SHOWN_PREF);

  // Click the doorhanger's "reject" button.
  let button = panel.querySelector(".popup-notification-secondary-button");
  promise = BrowserTestUtils.waitForEvent(panel, "popuphidden");
  EventUtils.synthesizeMouseAtCenter(button, {});
  await promise;

  await prefPromise;

  is(
    Preferences.get(prefs.DOH_DOORHANGER_SHOWN_PREF),
    true,
    "Doorhanger shown pref saved."
  );
  is(
    Preferences.get(prefs.DOH_DOORHANGER_USER_DECISION_PREF),
    "UIDisabled",
    "Doorhanger decision saved."
  );
  is(
    Preferences.get(prefs.DOH_SELF_ENABLED_PREF),
    undefined,
    "Breadcrumb cleared."
  );

  BrowserTestUtils.removeTab(tab);

  await ensureTRRMode(5);
  await checkHeuristicsTelemetry("disable_doh", "doorhangerDecline");

  // Simulate a network change.
  simulateNetworkChange();
  await ensureNoTRRModeChange(5);
  ensureNoHeuristicsTelemetry();

  // Restart the add-on for good measure.
  await restartAddon();
  ensureNoTRRSelectionTelemetry();
  await ensureNoTRRModeChange(5);
  ensureNoHeuristicsTelemetry();

  // Set failing environment and trigger another network change.
  setFailingHeuristics();
  simulateNetworkChange();
  await ensureNoTRRModeChange(5);
  ensureNoHeuristicsTelemetry();
});
