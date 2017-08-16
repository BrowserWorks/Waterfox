/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

requestLongerTimeout(5);

// Dragging the zoom controls to be before the print button should not move any controls.
add_task(async function() {
  await SpecialPowers.pushPrefEnv({set: [["browser.photon.structure.enabled", false]]});
  await startCustomizing();
  let zoomControls = document.getElementById("zoom-controls");
  let printButton = document.getElementById("print-button");
  let placementsAfterMove = ["edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "zoom-controls",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(zoomControls, printButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(!CustomizableUI.inDefaultState, "Should no longer be in default state.");
  let newWindowButton = document.getElementById("new-window-button");
  simulateItemDrag(zoomControls, newWindowButton);
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

// Dragging the zoom controls to be before the save button should not move any controls.
add_task(async function() {
  await startCustomizing();
  let zoomControls = document.getElementById("zoom-controls");
  let savePageButton = document.getElementById("save-page-button");
  let placementsAfterMove = ["edit-controls",
                             "zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(zoomControls, savePageButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(CustomizableUI.inDefaultState, "Should be in default state.");
});


// Dragging the zoom controls to be before the new-window button should not move any widgets.
add_task(async function() {
  await startCustomizing();
  let zoomControls = document.getElementById("zoom-controls");
  let newWindowButton = document.getElementById("new-window-button");
  let placementsAfterMove = ["edit-controls",
                             "zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(zoomControls, newWindowButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the zoom controls to be before the history-panelmenu should move the zoom-controls in to the row higher than the history-panelmenu.
add_task(async function() {
  await startCustomizing();
  let zoomControls = document.getElementById("zoom-controls");
  let historyPanelMenu = document.getElementById("history-panelmenu");
  let placementsAfterMove = ["edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "zoom-controls",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(zoomControls, historyPanelMenu);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(!CustomizableUI.inDefaultState, "Should no longer be in default state.");
  let newWindowButton = document.getElementById("new-window-button");
  simulateItemDrag(zoomControls, newWindowButton);
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

// Dragging the zoom controls to be before the preferences-button should move the zoom-controls
// in to the row higher than the preferences-button.
add_task(async function() {
  await startCustomizing();
  let zoomControls = document.getElementById("zoom-controls");
  let preferencesButton = document.getElementById("preferences-button");
  let placementsAfterMove = ["edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "zoom-controls",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(zoomControls, preferencesButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(!CustomizableUI.inDefaultState, "Should no longer be in default state.");
  let newWindowButton = document.getElementById("new-window-button");
  simulateItemDrag(zoomControls, newWindowButton);
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

// Dragging an item from the palette to before the zoom-controls should move it and two other buttons before the zoom controls.
add_task(async function() {
  await startCustomizing();
  let openFileButton = document.getElementById("open-file-button");
  let zoomControls = document.getElementById("zoom-controls");
  let placementsAfterInsert = ["edit-controls",
                               "open-file-button",
                               "new-window-button",
                               "privatebrowsing-button",
                               "zoom-controls",
                               "save-page-button",
                               "print-button",
                               "history-panelmenu",
                               "fullscreen-button",
                               "find-button",
                               "preferences-button",
                               "add-ons-button",
                               "developer-button",
                               "sync-button",
                               "webcompat-reporter-button"
                              ];
  removeNonReleaseButtons(placementsAfterInsert);
  simulateItemDrag(openFileButton, zoomControls);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterInsert);
  ok(!CustomizableUI.inDefaultState, "Should no longer be in default state.");
  let palette = document.getElementById("customization-palette");
  // Check that the palette items are re-wrapped correctly.
  let feedWrapper = document.getElementById("wrapper-feed-button");
  let feedButton = document.getElementById("feed-button");
  is(feedButton.parentNode, feedWrapper,
     "feed-button should be a child of wrapper-feed-button");
  is(feedWrapper.getAttribute("place"), "palette",
     "The feed-button wrapper should have it's place set to 'palette'");
  simulateItemDrag(openFileButton, palette);
  is(openFileButton.parentNode.tagName, "toolbarpaletteitem",
     "The open-file-button should be wrapped by a toolbarpaletteitem");
  let newWindowButton = document.getElementById("new-window-button");
  simulateItemDrag(zoomControls, newWindowButton);
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

// Dragging an item from the palette to before the edit-controls
// should move it and two other buttons before the edit and zoom controls.
add_task(async function() {
  await startCustomizing();
  let openFileButton = document.getElementById("open-file-button");
  let editControls = document.getElementById("edit-controls");
  let placementsAfterInsert = ["open-file-button",
                               "new-window-button",
                               "privatebrowsing-button",
                               "edit-controls",
                               "zoom-controls",
                               "save-page-button",
                               "print-button",
                               "history-panelmenu",
                               "fullscreen-button",
                               "find-button",
                               "preferences-button",
                               "add-ons-button",
                               "developer-button",
                               "sync-button",
                               "webcompat-reporter-button"
                              ];
  removeNonReleaseButtons(placementsAfterInsert);
  simulateItemDrag(openFileButton, editControls);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterInsert);
  ok(!CustomizableUI.inDefaultState, "Should no longer be in default state.");
  let palette = document.getElementById("customization-palette");
  // Check that the palette items are re-wrapped correctly.
  let feedWrapper = document.getElementById("wrapper-feed-button");
  let feedButton = document.getElementById("feed-button");
  is(feedButton.parentNode, feedWrapper,
     "feed-button should be a child of wrapper-feed-button");
  is(feedWrapper.getAttribute("place"), "palette",
     "The feed-button wrapper should have it's place set to 'palette'");
  simulateItemDrag(openFileButton, palette);
  is(openFileButton.parentNode.tagName, "toolbarpaletteitem",
     "The open-file-button should be wrapped by a toolbarpaletteitem");
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

// Dragging the edit-controls to be before the zoom-controls button
// should not move any widgets.
add_task(async function() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let zoomControls = document.getElementById("zoom-controls");
  let placementsAfterMove = ["edit-controls",
                             "zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(editControls, zoomControls);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to be before the new-window-button should
// move the zoom-controls before the edit-controls.
add_task(async function() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let newWindowButton = document.getElementById("new-window-button");
  let placementsAfterMove = ["zoom-controls",
                             "edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(editControls, newWindowButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(editControls, zoomControls);
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to be before the privatebrowsing-button
// should move the edit-controls in to the row higher than the
// privatebrowsing-button.
add_task(async function() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let privateBrowsingButton = document.getElementById("privatebrowsing-button");
  let placementsAfterMove = ["zoom-controls",
                             "edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(editControls, privateBrowsingButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(editControls, zoomControls);
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to be before the save-page-button
// should move the edit-controls in to the row higher than the
// save-page-button.
add_task(async function() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let savePageButton = document.getElementById("save-page-button");
  let placementsAfterMove = ["zoom-controls",
                             "edit-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button"
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(editControls, savePageButton);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(editControls, zoomControls);
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to the panel itself should append
// the edit controls to the bottom of the panel.
add_task(async function editControlsToPanelEmptySpace() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let panel = document.getElementById(CustomizableUI.AREA_PANEL);
  let placementsAfterMove = ["zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "edit-controls",
                             "developer-button",
                             "sync-button",
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  if (isNotReleaseOrBeta()) {
    CustomizableUI.removeWidgetFromArea("webcompat-reporter-button");
  }
  simulateItemDrag(editControls, panel);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(editControls, zoomControls);
  if (isNotReleaseOrBeta()) {
    CustomizableUI.addWidgetToArea("webcompat-reporter-button", CustomizableUI.AREA_PANEL);
  }
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to the customization-palette and
// back should work.
add_task(async function() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let palette = document.getElementById("customization-palette");
  let placementsAfterMove = ["zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "developer-button",
                             "sync-button",
                             "webcompat-reporter-button",
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  let paletteChildElementCount = palette.childElementCount;
  simulateItemDrag(editControls, palette);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  is(paletteChildElementCount + 1, palette.childElementCount,
     "The palette should have a new child, congratulations!");
  is(editControls.parentNode.id, "wrapper-edit-controls",
     "The edit-controls should be properly wrapped.");
  is(editControls.parentNode.getAttribute("place"), "palette",
     "The edit-controls should have the place of 'palette'.");
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(editControls, zoomControls);
  is(paletteChildElementCount, palette.childElementCount,
     "The palette child count should have returned to its prior value.");
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging the edit-controls to each of the panel placeholders
// should append the edit-controls to the bottom of the panel.
add_task(async function editControlsToPanelPlaceholders() {
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let panel = document.getElementById(CustomizableUI.AREA_PANEL);
  let numPlaceholders = 2;
  for (let i = 0; i < numPlaceholders; i++) {
    // This test relies on there being a specific number of widgets in the
    // panel. The addition of sync-button and webcompat-reporter-button screwed
    // this up, so we remove them here. We should either fix the tests to not
    // rely on the specific layout, or fix bug 1007910 which would change the
    // placeholder logic in different ways. Bug 1229236 is for these tests to
    // be smarter.
    removeNonOriginalButtons();
    // NB: We can't just iterate over all of the placeholders
    // because each drag-drop action recreates them.
    let placeholder = panel.getElementsByClassName("panel-customization-placeholder")[i];
    let placementsAfterMove = ["zoom-controls",
                               "new-window-button",
                               "privatebrowsing-button",
                               "save-page-button",
                               "print-button",
                               "history-panelmenu",
                               "fullscreen-button",
                               "find-button",
                               "preferences-button",
                               "add-ons-button",
                               "edit-controls",
                               "developer-button",
                              ];
    removeNonReleaseButtons(placementsAfterMove);
    simulateItemDrag(editControls, placeholder);
    assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
    let zoomControls = document.getElementById("zoom-controls");
    simulateItemDrag(editControls, zoomControls);
    restoreNonOriginalButtons();
    ok(CustomizableUI.inDefaultState, "Should still be in default state.");
  }
});

// Dragging the open-file-button back on to itself should work.
add_task(async function() {
  await startCustomizing();
  let openFileButton = document.getElementById("open-file-button");
  is(openFileButton.parentNode.tagName, "toolbarpaletteitem",
     "open-file-button should be wrapped by a toolbarpaletteitem");
  simulateItemDrag(openFileButton, openFileButton);
  is(openFileButton.parentNode.tagName, "toolbarpaletteitem",
     "open-file-button should be wrapped by a toolbarpaletteitem");
  let editControls = document.getElementById("edit-controls");
  is(editControls.parentNode.tagName, "toolbarpaletteitem",
     "edit-controls should be wrapped by a toolbarpaletteitem");
  ok(CustomizableUI.inDefaultState, "Should still be in default state.");
});

// Dragging a small button onto the last big button should work.
add_task(async function() {
  // Bug 1007910 requires there be a placeholder on the final row for this
  // test to work as written. The addition of sync-button and
  // webcompat-reporter-button meant that's not true so we remove them from
  // here. Bug 1229236 is for these tests to be smarter.
  removeNonOriginalButtons();
  await startCustomizing();
  let editControls = document.getElementById("edit-controls");
  let panel = document.getElementById(CustomizableUI.AREA_PANEL);
  let target = panel.getElementsByClassName("panel-customization-placeholder")[0];
  let placementsAfterMove = ["zoom-controls",
                             "new-window-button",
                             "privatebrowsing-button",
                             "save-page-button",
                             "print-button",
                             "history-panelmenu",
                             "fullscreen-button",
                             "find-button",
                             "preferences-button",
                             "add-ons-button",
                             "edit-controls",
                             "developer-button",
                            ];
  removeNonReleaseButtons(placementsAfterMove);
  simulateItemDrag(editControls, target);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);
  let itemToDrag = "email-link-button"; // any button in the palette by default.
  let button = document.getElementById(itemToDrag);
  placementsAfterMove.splice(11, 0, itemToDrag);
  simulateItemDrag(button, editControls);
  assertAreaPlacements(CustomizableUI.AREA_PANEL, placementsAfterMove);

  // Put stuff back:
  let palette = document.getElementById("customization-palette");
  let zoomControls = document.getElementById("zoom-controls");
  simulateItemDrag(button, palette);
  simulateItemDrag(editControls, zoomControls);
  restoreNonOriginalButtons();
  ok(CustomizableUI.inDefaultState, "Should be in default state again.");
});

add_task(async function asyncCleanup() {
  await endCustomizing();
  await resetCustomization();
});
