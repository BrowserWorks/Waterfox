/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test RDM menu item is checked when expected, on multiple windows.

const TEST_URL = "data:text/html;charset=utf-8,";

const isMenuCheckedFor = ({document}) => {
  let menu = document.getElementById("menu_responsiveUI");
  return menu.getAttribute("checked") === "true";
};

add_task(function* () {
  const window1 = yield BrowserTestUtils.openNewBrowserWindow();
  let { gBrowser } = window1;

  yield BrowserTestUtils.withNewTab({ gBrowser, url: TEST_URL },
    function* (browser) {
      let tab = gBrowser.getTabForBrowser(browser);

      is(window1, Services.wm.getMostRecentWindow("navigator:browser"),
        "The new window is the active one");

      ok(!isMenuCheckedFor(window1),
        "RDM menu item is unchecked by default");

      yield openRDM(tab);

      ok(isMenuCheckedFor(window1),
        "RDM menu item is checked with RDM open");

      yield closeRDM(tab);

      ok(!isMenuCheckedFor(window1),
        "RDM menu item is unchecked with RDM closed");
    });

  yield BrowserTestUtils.closeWindow(window1);

  is(window, Services.wm.getMostRecentWindow("navigator:browser"),
    "The original window is the active one");

  ok(!isMenuCheckedFor(window),
    "RDM menu item is unchecked");
});
