/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

// This directory contains tests that check tips and interventions, and in
// particular the update-related interventions.
// We mock updates by using the test helpers in
// toolkit/mozapps/update/tests/browser.

"use strict";

/* import-globals-from ../../../../../toolkit/mozapps/update/tests/browser/head.js */
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/toolkit/mozapps/update/tests/browser/head.js",
  this
);

XPCOMUtils.defineLazyModuleGetters(this, {
  HttpServer: "resource://testing-common/httpd.js",
  ResetProfile: "resource://gre/modules/ResetProfile.jsm",
  UrlbarProviderInterventions:
    "resource:///modules/UrlbarProviderInterventions.jsm",
  UrlbarProvidersManager: "resource:///modules/UrlbarProvidersManager.jsm",
  UrlbarResult: "resource:///modules/UrlbarResult.jsm",
  UrlbarTestUtils: "resource://testing-common/UrlbarTestUtils.jsm",
  SearchTestUtils: "resource://testing-common/SearchTestUtils.jsm",
  TelemetryTestUtils: "resource://testing-common/TelemetryTestUtils.jsm",
});

// For each intervention type, a search string that trigger the intervention.
const SEARCH_STRINGS = {
  CLEAR: "firefox history",
  REFRESH: "firefox slow",
  UPDATE: "firefox update",
};

add_task(async function init() {
  await SpecialPowers.pushPrefEnv({
    set: [["browser.urlbar.update1.interventions", true]],
  });
  registerCleanupFunction(() => {
    // We need to reset the provider's appUpdater.status between tests so that
    // each test doesn't interfere with the next.
    UrlbarProviderInterventions.resetAppUpdater();
  });
});

/**
 * Initializes a mock app update.  Adapted from runAboutDialogUpdateTest:
 * https://searchfox.org/mozilla-central/source/toolkit/mozapps/update/tests/browser/head.js
 *
 * @param {object} params
 *   See the files in toolkit/mozapps/update/tests/browser.
 */
async function initUpdate(params) {
  gEnv.set("MOZ_TEST_SLOW_SKIP_UPDATE_STAGE", "1");
  await SpecialPowers.pushPrefEnv({
    set: [
      [PREF_APP_UPDATE_DISABLEDFORTESTING, false],
      [PREF_APP_UPDATE_URL_MANUAL, gDetailsURL],
    ],
  });

  await setupTestUpdater();

  let queryString = params.queryString ? params.queryString : "";
  let updateURL =
    URL_HTTP_UPDATE_SJS +
    "?detailsURL=" +
    gDetailsURL +
    queryString +
    getVersionParams();
  if (params.backgroundUpdate) {
    setUpdateURL(updateURL);
    gAUS.checkForBackgroundUpdates();
    if (params.continueFile) {
      await continueFileHandler(params.continueFile);
    }
    if (params.waitForUpdateState) {
      await TestUtils.waitForCondition(
        () =>
          gUpdateManager.activeUpdate &&
          gUpdateManager.activeUpdate.state == params.waitForUpdateState,
        "Waiting for update state: " + params.waitForUpdateState,
        undefined,
        200
      ).catch(e => {
        // Instead of throwing let the check below fail the test so the panel
        // ID and the expected panel ID is printed in the log.
        logTestInfo(e);
      });
      // Display the UI after the update state equals the expected value.
      Assert.equal(
        gUpdateManager.activeUpdate.state,
        params.waitForUpdateState,
        "The update state value should equal " + params.waitForUpdateState
      );
    }
  } else {
    updateURL += "&slowUpdateCheck=1&useSlowDownloadMar=1";
    setUpdateURL(updateURL);
  }
}

/**
 * Performs steps in a mock update.  Adapted from runAboutDialogUpdateTest:
 * https://searchfox.org/mozilla-central/source/toolkit/mozapps/update/tests/browser/head.js
 *
 * @param {array} steps
 *   See the files in toolkit/mozapps/update/tests/browser.
 */
async function processUpdateSteps(steps) {
  for (let step of steps) {
    await processUpdateStep(step);
  }
}

/**
 * Performs a step in a mock update.  Adapted from runAboutDialogUpdateTest:
 * https://searchfox.org/mozilla-central/source/toolkit/mozapps/update/tests/browser/head.js
 *
 * @param {object} step
 *   See the files in toolkit/mozapps/update/tests/browser.
 */
async function processUpdateStep(step) {
  if (typeof step == "function") {
    step();
    return;
  }

  const { panelId, checkActiveUpdate, continueFile, downloadInfo } = step;
  if (checkActiveUpdate) {
    await TestUtils.waitForCondition(
      () => gUpdateManager.activeUpdate,
      "Waiting for active update"
    );
    Assert.ok(
      !!gUpdateManager.activeUpdate,
      "There should be an active update"
    );
    Assert.equal(
      gUpdateManager.activeUpdate.state,
      checkActiveUpdate.state,
      "The active update state should equal " + checkActiveUpdate.state
    );
  } else {
    Assert.ok(
      !gUpdateManager.activeUpdate,
      "There should not be an active update"
    );
  }

  if (panelId == "downloading") {
    for (let i = 0; i < downloadInfo.length; ++i) {
      let data = downloadInfo[i];
      // The About Dialog tests always specify a continue file.
      await continueFileHandler(continueFile);
      let patch = getPatchOfType(data.patchType);
      // The update is removed early when the last download fails so check
      // that there is a patch before proceeding.
      let isLastPatch = i == downloadInfo.length - 1;
      if (!isLastPatch || patch) {
        let resultName = data.bitsResult ? "bitsResult" : "internalResult";
        patch.QueryInterface(Ci.nsIWritablePropertyBag);
        await TestUtils.waitForCondition(
          () => patch.getProperty(resultName) == data[resultName],
          "Waiting for expected patch property " +
            resultName +
            " value: " +
            data[resultName],
          undefined,
          200
        ).catch(e => {
          // Instead of throwing let the check below fail the test so the
          // property value and the expected property value is printed in
          // the log.
          logTestInfo(e);
        });
        Assert.equal(
          patch.getProperty(resultName),
          data[resultName],
          "The patch property " +
            resultName +
            " value should equal " +
            data[resultName]
        );
      }
    }
  } else if (continueFile) {
    await continueFileHandler(continueFile);
  }
}

/**
 * Checks an intervention tip.  This works by starting a search that should
 * trigger a tip, picks the tip, and waits for the tip's action to happen.
 *
 * @param {string} searchString
 *   The search string.
 * @param {string} tip
 *   The expected tip type.
 * @param {string/regexp} title
 *   The expected tip title.
 * @param {string/regexp} button
 *   The expected button title.
 * @param {function} awaitCallback
 *   A function that checks the tip's action.  Should return a promise (or be
 *   async).
 * @returns {object}
 *   The value returned from `awaitCallback`.
 */
async function doUpdateTest({
  searchString,
  tip,
  title,
  button,
  awaitCallback,
} = {}) {
  // Do a search that triggers the tip.
  let [result, element] = await awaitTip(searchString);
  Assert.strictEqual(result.payload.type, tip, "Tip type");
  await element.ownerDocument.l10n.translateFragment(element);

  let actualTitle = element._elements.get("title").textContent;
  if (typeof title == "string") {
    Assert.equal(actualTitle, title, "Title string");
  } else {
    // regexp
    Assert.ok(title.test(actualTitle), "Title regexp");
  }

  let actualButton = element._elements.get("tipButton").textContent;
  if (typeof button == "string") {
    Assert.equal(actualButton, button, "Button string");
  } else {
    // regexp
    Assert.ok(button.test(actualButton), "Button regexp");
  }

  Assert.ok(
    BrowserTestUtils.is_visible(element._elements.get("helpButton")),
    "Help button visible"
  );

  // Pick the tip and wait for the action.
  let values = await Promise.all([awaitCallback(), pickTip()]);

  // Check telemetry.
  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, true);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    "urlbar.tips",
    `${tip}-shown`,
    1
  );
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    "urlbar.tips",
    `${tip}-picked`,
    1
  );

  return values[0] || null;
}

/**
 * Starts a search and asserts that the second result is a tip.
 *
 * @param {string} searchString
 *   The search string.
 * @param {window} win
 *   The window.
 * @returns {[result, element]}
 *   The result and its element in the DOM.
 */
async function awaitTip(searchString, win = window) {
  let context = await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window: win,
    value: searchString,
    waitForFocus,
    fireInputEvent: true,
  });
  Assert.ok(context.results.length >= 2);
  let result = context.results[1];
  Assert.equal(result.type, UrlbarUtils.RESULT_TYPE.TIP);
  let element = await UrlbarTestUtils.waitForAutocompleteResultAt(win, 1);
  return [result, element];
}

/**
 * Picks the current tip's button.  The view should be open and the second
 * result should be a tip.
 */
async function pickTip() {
  let result = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  let button = result.element.row._elements.get("tipButton");
  await UrlbarTestUtils.promisePopupClose(window, () => {
    EventUtils.synthesizeMouseAtCenter(button, {});
  });
}

/**
 * Waits for the quit-application-requested notification and cancels it (so that
 * the app isn't actually restarted).
 */
async function awaitAppRestartRequest() {
  await TestUtils.topicObserved(
    "quit-application-requested",
    (cancelQuit, data) => {
      if (data == "restart") {
        cancelQuit.QueryInterface(Ci.nsISupportsPRBool).data = true;
        return true;
      }
      return false;
    }
  );
}

/**
 * Sets up the profile so that it can be reset.
 */
function makeProfileResettable() {
  // Make reset possible.
  let profileService = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
    Ci.nsIToolkitProfileService
  );
  let currentProfileDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
  let profileName = "mochitest-test-profile-temp-" + Date.now();
  let tempProfile = profileService.createProfile(
    currentProfileDir,
    profileName
  );
  Assert.ok(
    ResetProfile.resetSupported(),
    "Should be able to reset from mochitest's temporary profile once it's in the profile manager."
  );

  registerCleanupFunction(() => {
    tempProfile.remove(false);
    Assert.ok(
      !ResetProfile.resetSupported(),
      "Shouldn't be able to reset from mochitest's temporary profile once removed from the profile manager."
    );
  });
}

/**
 * Starts a search that should trigger a tip, picks the tip, and waits for the
 * tip's action to happen.
 *
 * @param {string} searchString
 *   The search string.
 * @param {TIPS} tip
 *   The expected tip type.
 * @param {string} title
 *   The expected tip title.
 * @param {string} button
 *   The expected button title.
 * @param {function} awaitCallback
 *   A function that checks the tip's action.  Should return a promise (or be
 *   async).
 * @returns {*}
 *   The value returned from `awaitCallback`.
 */
function checkIntervention({
  searchString,
  tip,
  title,
  button,
  awaitCallback,
} = {}) {
  // Opening modal dialogs confuses focus on Linux just after them, thus run
  // these checks in separate tabs to better isolate them.
  return BrowserTestUtils.withNewTab("about:blank", async () => {
    // Do a search that triggers the tip.
    let [result, element] = await awaitTip(searchString);
    Assert.strictEqual(result.payload.type, tip);
    await element.ownerDocument.l10n.translateFragment(element);

    let actualTitle = element._elements.get("title").textContent;
    if (typeof title == "string") {
      Assert.equal(actualTitle, title, "Title string");
    } else {
      // regexp
      Assert.ok(title.test(actualTitle), "Title regexp");
    }

    let actualButton = element._elements.get("tipButton").textContent;
    if (typeof button == "string") {
      Assert.equal(actualButton, button, "Button string");
    } else {
      // regexp
      Assert.ok(button.test(actualButton), "Button regexp");
    }

    Assert.ok(BrowserTestUtils.is_visible(element._elements.get("helpButton")));

    let values = await Promise.all([awaitCallback(), pickTip()]);
    Assert.ok(true, "Refresh dialog opened");

    // Ensure the urlbar is closed so that the engagement is ended.
    await UrlbarTestUtils.promisePopupClose(window, () => gURLBar.blur());

    const scalars = TelemetryTestUtils.getProcessScalars("parent", true, true);
    TelemetryTestUtils.assertKeyedScalar(
      scalars,
      "urlbar.tips",
      `${tip}-shown`,
      1
    );
    TelemetryTestUtils.assertKeyedScalar(
      scalars,
      "urlbar.tips",
      `${tip}-picked`,
      1
    );

    return values[0] || null;
  });
}

/**
 * Starts a search and asserts that there are no tips.
 *
 * @param {string} searchString
 *   The search string.
 * @param {Window} win
 */
async function awaitNoTip(searchString, win = window) {
  let context = await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window: win,
    value: searchString,
    waitForFocus,
    fireInputEvent: true,
  });
  for (let result of context.results) {
    Assert.notEqual(result.type, UrlbarUtils.RESULT_TYPE.TIP);
  }
}

/**
 * Copied from BrowserTestUtils.jsm, but lets you listen for any one of multiple
 * dialog URIs instead of only one.
 * @param {string} buttonAction
 *   What button should be pressed on the alert dialog.
 * @param {array} uris
 *   The URIs for the alert dialogs.
 * @param {function} [func]
 *   An optional callback.
 */
async function promiseAlertDialogOpen(buttonAction, uris, func) {
  let win = await BrowserTestUtils.domWindowOpened(null, async aWindow => {
    // The test listens for the "load" event which guarantees that the alert
    // class has already been added (it is added when "DOMContentLoaded" is
    // fired).
    await BrowserTestUtils.waitForEvent(aWindow, "load");

    return uris.includes(aWindow.document.documentURI);
  });

  if (func) {
    await func(win);
    return win;
  }

  let dialog = win.document.querySelector("dialog");
  dialog.getButton(buttonAction).click();

  return win;
}

/**
 * Copied from BrowserTestUtils.jsm, but lets you listen for any one of multiple
 * dialog URIs instead of only one.
 * @param {string} buttonAction
 *   What button should be pressed on the alert dialog.
 * @param {array} uris
 *   The URIs for the alert dialogs.
 * @param {function} [func]
 *   An optional callback.
 */
async function promiseAlertDialog(buttonAction, uris, func) {
  let win = await promiseAlertDialogOpen(buttonAction, uris, func);
  return BrowserTestUtils.windowClosed(win);
}

async function checkTip(win, expectedTip, closeView = true) {
  if (!expectedTip) {
    // Wait a bit for the tip to not show up.
    // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
    await new Promise(resolve => setTimeout(resolve, 100));
    Assert.ok(!win.gURLBar.view.isOpen);
    return;
  }

  // Wait for the view to open, and then check the tip result.
  await UrlbarTestUtils.promisePopupOpen(win, () => {});
  Assert.ok(true, "View opened");
  Assert.equal(UrlbarTestUtils.getResultCount(win), 1);
  let result = await UrlbarTestUtils.getDetailsOfResultAt(win, 0);
  Assert.equal(result.type, UrlbarUtils.RESULT_TYPE.TIP);
  let heuristic;
  let title;
  let name = Services.search.defaultEngine.name;
  switch (expectedTip) {
    case UrlbarProviderSearchTips.TIP_TYPE.ONBOARD:
      heuristic = true;
      title =
        `Type less, find more: Search ${name} right from your ` +
        `address bar.`;
      break;
    case UrlbarProviderSearchTips.TIP_TYPE.REDIRECT:
      heuristic = false;
      title =
        `Start your search in the address bar to see suggestions from ` +
        `${name} and your browsing history.`;
      break;
  }
  Assert.equal(result.heuristic, heuristic);
  Assert.equal(result.displayed.title, title);
  Assert.equal(
    result.element.row._elements.get("tipButton").textContent,
    `Okay, Got It`
  );
  Assert.ok(
    BrowserTestUtils.is_hidden(result.element.row._elements.get("helpButton"))
  );

  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, true);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    "urlbar.tips",
    `${expectedTip}-shown`,
    1
  );

  if (closeView) {
    await UrlbarTestUtils.promisePopupClose(win);
  }
}

async function checkTab(win, url, expectedTip, reset = true) {
  // BrowserTestUtils.withNewTab always waits for tab load, which hangs on
  // about:newtab for some reason, so don't use it.
  let shownCount;
  if (expectedTip) {
    shownCount = UrlbarPrefs.get(`tipShownCount.${expectedTip}`);
  }

  let tab = await BrowserTestUtils.openNewForegroundTab({
    gBrowser: win.gBrowser,
    url,
    waitForLoad: url != "about:newtab",
  });

  await checkTip(win, expectedTip, true);
  if (expectedTip) {
    Assert.equal(
      UrlbarPrefs.get(`tipShownCount.${expectedTip}`),
      shownCount + 1,
      "The shownCount pref should have been incremented by one."
    );
  }

  if (reset) {
    resetSearchTipsProvider();
  }

  BrowserTestUtils.removeTab(tab);
}

/**
 * This lets us visit www.google.com (for example) and have it redirect to
 * our test HTTP server instead of visiting the actual site.
 * @param {string} domain
 *   The domain to which we are redirecting.
 * @param {string} path
 *   The pathname on the domain.
 * @param {function} callback
 *   Executed when the test suite thinks `domain` is loaded.
 */
async function withDNSRedirect(domain, path, callback) {
  // Some domains have special security requirements, like www.bing.com.  We
  // need to override them to successfully load them.  This part is adapted from
  // testing/marionette/cert.js.
  const certOverrideService = Cc[
    "@mozilla.org/security/certoverride;1"
  ].getService(Ci.nsICertOverrideService);
  Services.prefs.setBoolPref(
    "network.stricttransportsecurity.preloadlist",
    false
  );
  Services.prefs.setIntPref("security.cert_pinning.enforcement_level", 0);
  certOverrideService.setDisableAllSecurityChecksAndLetAttackersInterceptMyData(
    true
  );

  // Now set network.dns.localDomains to redirect the domain to localhost and
  // set up an HTTP server.
  Services.prefs.setCharPref("network.dns.localDomains", domain);

  let server = new HttpServer();
  server.registerPathHandler(path, (req, resp) => {
    resp.write(`Test! http://${domain}${path}`);
  });
  server.start(-1);
  server.identity.setPrimary("http", domain, server.identity.primaryPort);
  let url = `http://${domain}:${server.identity.primaryPort}${path}`;

  await callback(url);

  // Reset network.dns.localDomains and stop the server.
  Services.prefs.clearUserPref("network.dns.localDomains");
  await new Promise(resolve => server.stop(resolve));

  // Reset the security stuff.
  certOverrideService.setDisableAllSecurityChecksAndLetAttackersInterceptMyData(
    false
  );
  Services.prefs.clearUserPref("network.stricttransportsecurity.preloadlist");
  Services.prefs.clearUserPref("security.cert_pinning.enforcement_level");
  const sss = Cc["@mozilla.org/ssservice;1"].getService(
    Ci.nsISiteSecurityService
  );
  sss.clearAll();
  sss.clearPreloads();
}

function resetSearchTipsProvider() {
  Services.prefs.clearUserPref(
    `browser.urlbar.tipShownCount.${UrlbarProviderSearchTips.TIP_TYPE.ONBOARD}`
  );
  Services.prefs.clearUserPref(
    `browser.urlbar.tipShownCount.${UrlbarProviderSearchTips.TIP_TYPE.REDIRECT}`
  );
  UrlbarProviderSearchTips.disableTipsForCurrentSession = false;
}

async function setDefaultEngine(name) {
  let engine = (await Services.search.getEngines()).find(e => e.name == name);
  Assert.ok(engine);
  await Services.search.setDefault(engine);
}
