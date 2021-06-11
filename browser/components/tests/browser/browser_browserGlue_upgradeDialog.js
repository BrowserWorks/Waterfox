/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { ExperimentFakes } = ChromeUtils.import(
  "resource://testing-common/NimbusTestUtils.jsm"
);
const { NimbusFeatures, ExperimentFeature, ExperimentAPI } = ChromeUtils.import(
  "resource://nimbus/ExperimentAPI.jsm"
);

function mockAppConstants({ isWin7 }) {
  if (mockAppConstants.value === undefined) {
    const stub = sinon.stub(window, "AppConstants").value({
      isPlatformAndVersionAtMost() {
        return mockAppConstants.value;
      },
    });
    registerCleanupFunction(() => stub.restore());
  }
  mockAppConstants.value = isWin7;
}

function AssertEvents(message, ...events) {
  info(`Checking telemetry events: ${message}`);
  TelemetryTestUtils.assertEvents(
    events.map(event => ["upgrade_dialog", ...event]),
    { category: "upgrade_dialog" }
  );
}

add_task(async function open_close_dialog() {
  mockShell();

  await showAndWaitForDialog();

  Assert.ok(true, "Upgrade dialog opened and closed");
});

add_task(async function set_as_default() {
  mockAppConstants({ isWin7: false });
  const mock = mockShell({ isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    1,
    "Primary button sets as default"
  );
});

add_task(async function need_only_pin() {
  const mock = mockShell({ canPin: true, isDefault: true });

  let screen1Default, screen1Pin;
  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    screen1Default = mock.setAsDefault.callCount;
    screen1Pin = mock.pinCurrentAppToTaskbar.callCount;
    win.document.getElementById("primary").click();
  });

  Assert.equal(screen1Default, 0, "First screen didn't default");
  Assert.equal(screen1Pin, 1, "First screen pinned");
  Assert.equal(
    mock.setAsDefault.callCount,
    0,
    "Primary buttons did not set as default"
  );
  Assert.equal(
    mock.pinCurrentAppToTaskbar.callCount,
    1,
    "Primary button did not pin after second screen"
  );
});

add_task(async function already_pin() {
  const mock = mockShell({ canPin: true, isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    1,
    "Primary button sets as default"
  );
  Assert.equal(
    mock.pinCurrentAppToTaskbar.callCount,
    0,
    "Primary button avoids re-pinning"
  );
});

add_task(async function already_default() {
  const mock = mockShell({ isDefault: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    0,
    "Primary button moves to second screen"
  );
});

add_task(async function already_default_need_pin() {
  const mock = mockShell({ canPin: true, isDefault: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    0,
    "Primary button doesn't need to default"
  );
  Assert.equal(
    mock.pinCurrentAppToTaskbar.callCount,
    1,
    "Primary button pins even when already default"
  );
});

add_task(async function theme_change() {
  const theme = await AddonManager.getAddonByID(
    "firefox-alpenglow@mozilla.org"
  );
  mockShell({ isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("secondary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.querySelectorAll("[name=theme]")[3].click();
    await TestUtils.waitForCondition(() => theme.isActive, "Theme is active");
    win.document.getElementById("primary").click();
  });

  Assert.ok(theme.isActive, "Theme change saved");
  theme.disable();
});

add_task(async function skip_screens() {
  Services.telemetry.clearEvents();
  const mock = mockShell({ isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("secondary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("secondary").click();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    0,
    "Skipped both screens without setting default"
  );
  AssertEvents(
    "Displayed default button and skipped",
    ["content", "show", "2-screens"],
    ["content", "show", "upgrade-dialog-new-primary-default-button"],
    ["content", "button", "upgrade-dialog-new-secondary-button"],
    ["content", "show", "upgrade-dialog-theme-primary-button"],
    ["content", "button", "upgrade-dialog-theme-secondary-button"],
    ["content", "close", "complete"]
  );
});

add_task(async function exit_early() {
  const mock = mockShell({ isDefault: true, isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("secondary").click();
  });

  Assert.equal(
    mock.setAsDefault.callCount,
    0,
    "Only 1 screen to skip when default"
  );
  AssertEvents(
    "Displayed theme button and skipped",
    ["content", "show", "2-screens"],
    ["content", "show", "upgrade-dialog-new-primary-theme-button"],
    ["content", "button", "upgrade-dialog-new-secondary-button"],
    ["content", "close", "early"]
  );
});

add_task(async function need_pin_and_default() {
  mockShell({ canPin: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });

  AssertEvents(
    "Pin and default shows 3 screens",
    ["content", "show", "3-screens"],
    ["content", "show", "upgrade-dialog-pin-primary-button"],
    ["content", "button", "upgrade-dialog-pin-primary-button"],
    ["content", "show", "upgrade-dialog-default-primary-button-2"],
    ["content", "button", "upgrade-dialog-default-primary-button-2"],
    ["content", "show", "upgrade-dialog-theme-primary-button"],
    ["content", "close", "external"]
  );
});

add_task(async function win7_okay() {
  mockAppConstants({ isWin7: true });
  mockShell({ isDefault: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("primary").click();
  });

  AssertEvents(
    "Dialog uses special windows 7 primary button",
    ["content", "show", "2-screens"],
    ["content", "show", "upgrade-dialog-new-primary-win7-button"],
    ["content", "button", "upgrade-dialog-new-primary-win7-button"],
    ["content", "close", "win7"]
  );
});

add_task(async function win7_1screen() {
  mockShell({ isPinned: true });

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.document.getElementById("secondary").click();
  });

  AssertEvents(
    "Dialog closed after Windows 7's only screen",
    ["content", "show", "2-screens"],
    ["content", "show", "upgrade-dialog-new-primary-default-button"],
    ["content", "button", "upgrade-dialog-new-secondary-button"],
    ["content", "close", "win7"]
  );
});

add_task(async function quit_app() {
  mockAppConstants({ isWin7: false });
  mockShell();

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    const cancelled = Cc["@mozilla.org/supports-PRBool;1"].createInstance(
      Ci.nsISupportsPRBool
    );
    cancelled.data = true;
    Services.obs.notifyObservers(
      cancelled,
      "quit-application-requested",
      "test"
    );
  });

  AssertEvents(
    "Dialog closed on quit request",
    ["content", "show", "3-screens"],
    ["content", "show", "upgrade-dialog-pin-primary-button"],
    ["content", "close", "quit-application-requested"]
  );
});

add_task(async function window_warning() {
  // Dismiss the alert when it opens.
  const warning = BrowserTestUtils.promiseAlertDialog("cancel");

  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");

    // Show close warning without blocking to allow this callback to complete.
    setTimeout(() => gBrowser.warnAboutClosingTabs());
  });
  await warning;

  AssertEvents(
    "Dialog closed when close warning wants to open",
    ["content", "show", "3-screens"],
    ["content", "show", "upgrade-dialog-pin-primary-button"],
    ["content", "close", "external"]
  );
});

add_task(async function not_major_upgrade() {
  await BROWSER_GLUE._maybeShowDefaultBrowserPrompt();

  AssertEvents("Not major upgrade for upgrade dialog requirements", [
    "trigger",
    "reason",
    "not-major",
  ]);
});

add_task(async function remote_disabled() {
  await ExperimentAPI.ready();
  await ExperimentFakes.remoteDefaultsHelper({
    feature: NimbusFeatures.upgradeDialog,
    configuration: { enabled: false, variables: {} },
  });

  // Simulate starting from a previous version.
  await SpecialPowers.pushPrefEnv({
    set: [["browser.startup.homepage_override.mstone", "88.0"]],
  });
  Cc["@mozilla.org/browser/clh;1"].getService(Ci.nsIBrowserHandler).defaultArgs;

  await BROWSER_GLUE._maybeShowDefaultBrowserPrompt();

  AssertEvents("Feature disabled for upgrade dialog requirements", [
    "trigger",
    "reason",
    "disabled",
  ]);

  // Re-enable back
  await ExperimentFakes.remoteDefaultsHelper({
    feature: NimbusFeatures.upgradeDialog,
    configuration: { enabled: true, variables: {} },
  });
});

add_task(async function show_major_upgrade() {
  const promise = waitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    win.close();
  });
  await BROWSER_GLUE._maybeShowDefaultBrowserPrompt();
  await promise;

  AssertEvents(
    "Upgrade dialog opened and closed from major upgrade",
    ["trigger", "reason", "satisfied"],
    ["content", "show", "3-screens"],
    ["content", "show", "upgrade-dialog-pin-primary-button"],
    ["content", "close", "external"]
  );
});

add_task(async function dont_reshow() {
  await BROWSER_GLUE._maybeShowDefaultBrowserPrompt();

  AssertEvents("Shouldn't reshow for upgrade dialog requirements", [
    "trigger",
    "reason",
    "already-shown",
  ]);
});

registerCleanupFunction(() => {
  Cc["@mozilla.org/browser/clh;1"].getService(
    Ci.nsIBrowserHandler
  ).majorUpgrade = false;
  Services.prefs.clearUserPref("browser.startup.upgradeDialog.version");
});
