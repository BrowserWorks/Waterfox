/* global SHOW_RESTART_BUTTON_PREF */

"use strict";

add_task(async function test_addRestartButton() {
  let EventUtils = {};
  Services.scriptloader.loadSubScript(
    "chrome://mochikit/content/tests/SimpleTest/EventUtils.js",
    EventUtils
  );
  let restartButton;
  // check that restart button has been created
  if (AppConstants.platform == "macosx") {
    restartButton = document.getElementById("app_restartBrowser");
    ok(restartButton, "Check restart browser item added.");
  } else {
    // windows - linux
    restartButton = document.getElementById("appMenu-restart-button");
    ok(restartButton, "Check restart browser item added.");
  }
  // check that adjusting pref on non-mac adjusts state to be hidden
  if (AppConstants.platform != "macosx") {
    var oldRestartPref = SpecialPowers.getBoolPref(SHOW_RESTART_BUTTON_PREF);
    SpecialPowers.setBoolPref(SHOW_RESTART_BUTTON_PREF, false);
    ok(
      BrowserTestUtils.is_hidden(restartButton),
      "Check setting restart button pref to be hiddden hides item."
    );
    // check that reverting pref adjusts state again
    SpecialPowers.setBoolPref(SHOW_RESTART_BUTTON_PREF, true);
    ok(
      BrowserTestUtils.is_visible(restartButton),
      "Check setting restart button pref to be visible shows item."
    );
    // reset pref
    SpecialPowers.setBoolPref(SHOW_RESTART_BUTTON_PREF, oldRestartPref);
  }
  // check that if new window is opened, element is added there as well
  if (AppConstants.platform == "macosx") {
    let newWin = await BrowserTestUtils.openNewBrowserWindow();
    let newDoc = newWin.document;
    let newRestartButton = newDoc.getElementById("app_restartBrowser");
    ok(newRestartButton, "Check restart browser item added.");
    // check that correct label text is pulled from l10n files
    is(
      newRestartButton.label,
      "Restart",
      "Check restart browser label loaded."
    );
    await BrowserTestUtils.closeWindow(newWin);
  } else {
    let newWin = await BrowserTestUtils.openNewBrowserWindow();
    let newDoc = newWin.document;
    let newRestartButton = newDoc.getElementById("appMenu-restart-button");
    ok(newRestartButton, "Check restart browser item added.");
    // check that correct label text is pulled from l10n files
    is(
      newRestartButton.label,
      "Restart",
      "Check restart browser label loaded."
    );
    await BrowserTestUtils.closeWindow(newWin);
  }
  // check that clicking initiates a browser restart
  let setRestartDialogPromise = BrowserTestUtils.promiseAlertDialogOpen(
    "accept"
  );
  restartButton.click();
  await setRestartDialogPromise;
  ok(true, "dialog appeared in response to restart button click");
  // check that confirmation prompt shows if pref set
  // check that confirmation prompt doesn't show if prompt not set
});
