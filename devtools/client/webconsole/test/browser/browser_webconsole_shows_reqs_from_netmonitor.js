/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const TEST_URI =
  "data:text/html;charset=utf8,Test that the netmonitor " +
  "displays requests that have been recorded in the " +
  "web console, even if the netmonitor hadn't opened yet.";

const TEST_FILE = "test-network-request.html";
const TEST_PATH =
  "http://example.com/browser/devtools/client/webconsole/" +
  "test/browser/" +
  TEST_FILE;

const NET_PREF = "devtools.webconsole.filter.net";
Services.prefs.setBoolPref(NET_PREF, true);
registerCleanupFunction(() => {
  Services.prefs.clearUserPref(NET_PREF);
});

add_task(async function task() {
  await pushPref("devtools.target-switching.enabled", true);

  // Test that the request appears in the console.
  const hud = await openNewTabAndConsole(TEST_URI);
  const currentTab = gBrowser.selectedTab;
  info("Web console is open");

  const onMessageAdded = waitForMessages({
    hud,
    messages: [
      {
        text: TEST_PATH,
      },
    ],
  });

  await navigateTo(TEST_PATH);
  info("Document loaded.");

  await onMessageAdded;
  info("Network message found.");

  // Test that the request appears in the network panel.
  const target = await TargetFactory.forTab(currentTab);
  const toolbox = await gDevTools.showToolbox(target, "netmonitor");
  info("Network panel is open.");

  await testNetmonitor(toolbox);
});

async function testNetmonitor(toolbox) {
  const monitor = toolbox.getCurrentPanel();

  const { store, windowRequire } = monitor.panelWin;
  const Actions = windowRequire("devtools/client/netmonitor/src/actions/index");
  const { getSortedRequests } = windowRequire(
    "devtools/client/netmonitor/src/selectors/index"
  );

  store.dispatch(Actions.batchEnable(false));

  await waitUntil(() => store.getState().requests.requests.length > 0);

  is(
    store.getState().requests.requests.length,
    1,
    "Network request appears in the network panel"
  );

  const item = getSortedRequests(store.getState())[0];
  is(item.method, "GET", "The attached method is correct.");
  is(item.url, TEST_PATH, "The attached url is correct.");
}
