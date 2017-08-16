/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

requestLongerTimeout(2);

// Restoring default should reset theme and show an "undo" option which undoes the restoring operation.
add_task(async function() {
  await SpecialPowers.pushPrefEnv({set: [["browser.photon.structure.enabled", false]]});
  let homeButtonId = "home-button";
  CustomizableUI.removeWidgetFromArea(homeButtonId);
  await startCustomizing();
  ok(!CustomizableUI.inDefaultState, "Not in default state to begin with");
  is(CustomizableUI.getPlacementOfWidget(homeButtonId), null, "Home button is in palette");
  let undoResetButton = document.getElementById("customization-undo-reset-button");
  is(undoResetButton.hidden, true, "The undo button is hidden before reset");

  let themesButton = document.getElementById("customization-lwtheme-button");
  let popup = document.getElementById("customization-lwtheme-menu");
  let popupShownPromise = popupShown(popup);
  EventUtils.synthesizeMouseAtCenter(themesButton, {});
  info("Clicked on themes button");
  await popupShownPromise;

  let recommendedHeader = document.getElementById("customization-lwtheme-menu-recommended");
  let firstLWTheme = recommendedHeader.nextSibling;
  let firstLWThemeId = firstLWTheme.theme.id;
  let themeChangedPromise = promiseObserverNotified("lightweight-theme-changed");
  firstLWTheme.doCommand();
  info("Clicked on first theme");
  await themeChangedPromise;

  is(LightweightThemeManager.currentTheme.id, firstLWThemeId, "Theme changed to first option");

  await gCustomizeMode.reset();

  ok(CustomizableUI.inDefaultState, "In default state after reset");
  is(undoResetButton.hidden, false, "The undo button is visible after reset");
  is(LightweightThemeManager.currentTheme, null, "Theme reset to default");

  await gCustomizeMode.undoReset()

  is(LightweightThemeManager.currentTheme.id, firstLWThemeId, "Theme has been reset from default to original choice");
  ok(!CustomizableUI.inDefaultState, "Not in default state after undo-reset");
  is(undoResetButton.hidden, true, "The undo button is hidden after clicking on the undo button");
  is(CustomizableUI.getPlacementOfWidget(homeButtonId), null, "Home button is in palette");

  await gCustomizeMode.reset();
});

// Performing an action after a reset will hide the reset button.
add_task(async function() {
  let homeButtonId = "home-button";
  CustomizableUI.removeWidgetFromArea(homeButtonId);
  ok(!CustomizableUI.inDefaultState, "Not in default state to begin with");
  is(CustomizableUI.getPlacementOfWidget(homeButtonId), null, "Home button is in palette");
  let undoResetButton = document.getElementById("customization-undo-reset-button");
  is(undoResetButton.hidden, true, "The undo button is hidden before reset");

  await gCustomizeMode.reset();

  ok(CustomizableUI.inDefaultState, "In default state after reset");
  is(undoResetButton.hidden, false, "The undo button is visible after reset");

  CustomizableUI.addWidgetToArea(homeButtonId, CustomizableUI.AREA_PANEL);
  is(undoResetButton.hidden, true, "The undo button is hidden after another change");
});

// "Restore defaults", exiting customize, and re-entering shouldn't show the Undo button
add_task(async function() {
  let undoResetButton = document.getElementById("customization-undo-reset-button");
  is(undoResetButton.hidden, true, "The undo button is hidden before a reset");
  ok(!CustomizableUI.inDefaultState, "The browser should not be in default state");
  await gCustomizeMode.reset();

  is(undoResetButton.hidden, false, "The undo button is visible after a reset");
  await endCustomizing();
  await startCustomizing();
  is(undoResetButton.hidden, true, "The undo reset button should be hidden after entering customization mode");
});

// Bug 971626 - Restore Defaults should collapse the Title Bar
add_task(async function() {
  if (Services.appinfo.OS != "WINNT" &&
      Services.appinfo.OS != "Darwin") {
    return;
  }
  let prefName = "browser.tabs.drawInTitlebar";
  let defaultValue = Services.prefs.getBoolPref(prefName);
  let restoreDefaultsButton = document.getElementById("customization-reset-button");
  let titlebarCheckbox = document.getElementById("customization-titlebar-visibility-checkbox");
  let undoResetButton = document.getElementById("customization-undo-reset-button");
  ok(CustomizableUI.inDefaultState, "Should be in default state at start of test");
  ok(restoreDefaultsButton.disabled, "Restore defaults button should be disabled when in default state");
  is(titlebarCheckbox.hasAttribute("checked"), !defaultValue, "Title bar checkbox should reflect pref value");
  is(undoResetButton.hidden, true, "Undo reset button should be hidden at start of test");

  Services.prefs.setBoolPref(prefName, !defaultValue);
  ok(!restoreDefaultsButton.disabled, "Restore defaults button should be enabled when pref changed");
  is(titlebarCheckbox.hasAttribute("checked"), defaultValue, "Title bar checkbox should reflect changed pref value");
  ok(!CustomizableUI.inDefaultState, "With titlebar flipped, no longer default");
  is(undoResetButton.hidden, true, "Undo reset button should be hidden after pref change");

  await gCustomizeMode.reset();
  ok(restoreDefaultsButton.disabled, "Restore defaults button should be disabled after reset");
  is(titlebarCheckbox.hasAttribute("checked"), !defaultValue, "Title bar checkbox should reflect default value after reset");
  is(Services.prefs.getBoolPref(prefName), defaultValue, "Reset should reset drawInTitlebar");
  ok(CustomizableUI.inDefaultState, "In default state after titlebar reset");
  is(undoResetButton.hidden, false, "Undo reset button should be visible after reset");
  ok(!undoResetButton.disabled, "Undo reset button should be enabled after reset");

  await gCustomizeMode.undoReset();
  ok(!restoreDefaultsButton.disabled, "Restore defaults button should be enabled after undo-reset");
  is(titlebarCheckbox.hasAttribute("checked"), defaultValue, "Title bar checkbox should reflect undo-reset value");
  ok(!CustomizableUI.inDefaultState, "No longer in default state after undo");
  is(Services.prefs.getBoolPref(prefName), !defaultValue, "Undo-reset goes back to previous pref value");
  is(undoResetButton.hidden, true, "Undo reset button should be hidden after undo-reset clicked");

  Services.prefs.clearUserPref(prefName);
  ok(CustomizableUI.inDefaultState, "In default state after pref cleared");
  is(undoResetButton.hidden, true, "Undo reset button should be hidden at end of test");
});

add_task(async function asyncCleanup() {
  await gCustomizeMode.reset();
  await endCustomizing();
});
