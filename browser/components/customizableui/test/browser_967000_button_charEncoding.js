/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const TEST_PAGE =
  "http://mochi.test:8888/browser/browser/components/customizableui/test/support/test_967000_charEncoding_page.html";

add_task(async function() {
  info("Check Character Encoding button functionality");

  // add the Character Encoding button to the panel
  CustomizableUI.addWidgetToArea(
    "characterencoding-button",
    CustomizableUI.AREA_FIXED_OVERFLOW_PANEL
  );

  await waitForOverflowButtonShown();
  registerCleanupFunction(() => CustomizableUI.reset());

  info("Waiting for the overflow panel to open");
  await document.getElementById("nav-bar").overflowable.show();

  let charEncodingButton = document.getElementById("characterencoding-button");
  ok(
    charEncodingButton,
    "The Character Encoding button was added to the Panel Menu"
  );
  is(
    charEncodingButton.getAttribute("disabled"),
    "true",
    "The Character encoding button is initially disabled"
  );

  let panelHidePromise = promiseOverflowHidden(window);
  document.getElementById("nav-bar").overflowable._panel.hidePopup();
  await panelHidePromise;
  info("Panel hidden");

  let newTab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    TEST_PAGE,
    true,
    true
  );

  await document.getElementById("nav-bar").overflowable.show();
  ok(
    !charEncodingButton.hasAttribute("disabled"),
    "The Character encoding button gets enabled"
  );
  let characterEncodingView = document.getElementById(
    "PanelUI-characterEncodingView"
  );
  let subviewShownPromise = subviewShown(characterEncodingView);
  charEncodingButton.click();
  await subviewShownPromise;

  ok(
    characterEncodingView.hasAttribute("visible"),
    "The Character encoding panel is displayed"
  );

  let pinnedEncodings = document.getElementById(
    "PanelUI-characterEncodingView-pinned"
  );
  let charsetsList = document.getElementById(
    "PanelUI-characterEncodingView-charsets"
  );
  ok(pinnedEncodings, "Pinned charsets are available");
  ok(charsetsList, "Charsets list is available");

  let checkedButtons = characterEncodingView.querySelectorAll(
    "toolbarbutton[checked='true']"
  );
  is(
    checkedButtons.length,
    2,
    "There should be 2 checked items (1 charset, 1 detector)."
  );
  is(
    checkedButtons[0].getAttribute("label"),
    "Western",
    "The western encoding is correctly selected"
  );
  is(
    characterEncodingView.querySelectorAll(
      "#PanelUI-characterEncodingView-autodetect toolbarbutton[checked='true']"
    ).length,
    1,
    "There should be 1 checked detector."
  );

  panelHidePromise = promiseOverflowHidden(window);
  document.getElementById("nav-bar").overflowable._panel.hidePopup();
  await panelHidePromise;
  info("Panel hidden");

  BrowserTestUtils.removeTab(newTab);
});

add_task(async function asyncCleanup() {
  // reset the panel to the default state
  await resetCustomization();
  ok(CustomizableUI.inDefaultState, "The UI is in default state again.");
});
