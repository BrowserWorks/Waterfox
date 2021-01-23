"use strict";

const { UrlbarTestUtils } = ChromeUtils.import(
  "resource://testing-common/UrlbarTestUtils.jsm"
);

var gTestTab;
var gContentAPI;
var gContentWindow;

add_task(setup_UITourTest);

add_UITour_task(async function test_showMenu_hideMenu_pageActionPanel() {
  let pageActionPanel = BrowserPageActions.panelNode;
  let shownPromise = promisePanelElementShown(window, pageActionPanel);
  await showMenuPromise("pageActionPanel");
  await shownPromise;
  is(
    pageActionPanel.state,
    "open",
    "The page action panel should open after showMenu"
  );
  let hidePromise = promisePanelElementHidden(window, pageActionPanel);
  await gContentAPI.hideMenu("pageActionPanel");
  await hidePromise;
  is(
    pageActionPanel.state,
    "closed",
    "The page action panel should close after hideMenu"
  );
});
