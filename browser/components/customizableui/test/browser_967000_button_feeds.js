/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const TEST_PAGE = "http://mochi.test:8888/browser/browser/components/customizableui/test/support/feeds_test_page.html";
const TEST_FEED = "http://mochi.test:8888/browser/browser/components/customizableui/test/support/test-feed.xml"

var newTab = null;
var initialLocation = gBrowser.currentURI.spec;

add_task(async function() {
  await SpecialPowers.pushPrefEnv({set: [["browser.photon.structure.enabled", false]]});
  info("Check Subscribe button functionality");

  // add the Subscribe button to the panel
  CustomizableUI.addWidgetToArea("feed-button",
                                  CustomizableUI.AREA_PANEL);

  // check the button's functionality
  await PanelUI.show();

  let feedButton = document.getElementById("feed-button");
  ok(feedButton, "The Subscribe button was added to the Panel Menu");
  is(feedButton.getAttribute("disabled"), "true", "The Subscribe button is initially disabled");

  let panelHidePromise = promisePanelHidden(window);
  PanelUI.hide();
  await panelHidePromise;

  newTab = gBrowser.selectedTab;
  await promiseTabLoadEvent(newTab, TEST_PAGE);

  await PanelUI.show();

  await waitForCondition(() => !feedButton.hasAttribute("disabled"));
  ok(!feedButton.hasAttribute("disabled"), "The Subscribe button gets enabled");

  feedButton.click();
  await promiseTabLoadEvent(newTab, TEST_FEED);

  is(gBrowser.currentURI.spec, TEST_FEED, "Subscribe page opened");
  ok(!isPanelUIOpen(), "Panel is closed");

  if (isPanelUIOpen()) {
    panelHidePromise = promisePanelHidden(window);
    PanelUI.hide();
    await panelHidePromise;
  }
});

add_task(async function asyncCleanup() {
  // reset the panel UI to the default state
  await resetCustomization();
  ok(CustomizableUI.inDefaultState, "The UI is in default state again.");

  // restore the initial location
  BrowserTestUtils.addTab(gBrowser, initialLocation);
  gBrowser.removeTab(newTab);
});
