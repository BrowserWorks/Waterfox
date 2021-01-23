/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

const TEST_URI_NAV = "http://example.com/browser/dom/tests/browser/";

function tearDown() {
  while (gBrowser.tabs.length > 1) {
    gBrowser.removeCurrentTab();
  }
}

add_task(async function() {
  // Don't cache removed tabs, so "clear console cache on tab close" triggers.
  await SpecialPowers.pushPrefEnv({ set: [["browser.tabs.max_tabs_undo", 0]] });

  registerCleanupFunction(tearDown);

  // Open a keepalive tab in the background to make sure we don't accidentally
  // kill the content process
  var keepaliveTab = await BrowserTestUtils.addTab(gBrowser, "about:blank");

  // Open the main tab to run the test in
  var tab = await BrowserTestUtils.addTab(gBrowser, "about:blank");
  gBrowser.selectedTab = tab;
  var browser = gBrowser.selectedBrowser;

  let observerPromise = ContentTask.spawn(browser, null, async function(opt) {
    const TEST_URI =
      "http://example.com/browser/dom/tests/browser/test-console-api.html";
    let ConsoleAPIStorage = Cc["@mozilla.org/consoleAPI-storage;1"].getService(
      Ci.nsIConsoleAPIStorage
    );

    let observerPromise = new Promise(resolve => {
      let apiCallCount = 0;
      let ConsoleObserver = {
        QueryInterface: ChromeUtils.generateQI([Ci.nsIObserver]),

        observe(aSubject, aTopic, aData) {
          if (aTopic == "console-storage-cache-event") {
            apiCallCount++;
            if (apiCallCount == 4) {
              let windowId = content.window.windowUtils.currentInnerWindowID;

              Services.obs.removeObserver(this, "console-storage-cache-event");
              ok(
                ConsoleAPIStorage.getEvents(windowId).length >= 4,
                "Some messages found in the storage service"
              );
              ConsoleAPIStorage.clearEvents();
              is(
                ConsoleAPIStorage.getEvents(windowId).length,
                0,
                "Cleared Storage"
              );

              resolve(windowId);
            }
          }
        },
      };

      Services.obs.addObserver(ConsoleObserver, "console-storage-cache-event");

      // Redirect the browser to the test URI
      content.window.location = TEST_URI;
    });

    await ContentTaskUtils.waitForEvent(this, "DOMContentLoaded");

    // Wait for the test document to be fully loaded.
    // This is a workaround to avoid JSWindowActor errors when moving on
    // to the next phase of the test. See Bug 1603925.
    await ContentTaskUtils.waitForCondition(
      () => content.document.querySelector("#test-emptyTimeStamp"),
      "Test document should be fully loaded"
    );

    content.console.log("this", "is", "a", "log message");
    content.console.info("this", "is", "a", "info message");
    content.console.warn("this", "is", "a", "warn message");
    content.console.error("this", "is", "a", "error message");
    return observerPromise;
  });

  let windowId = await observerPromise;

  await SpecialPowers.spawn(browser, [], function() {
    // make sure a closed window's events are in fact removed from
    // the storage cache
    content.console.log("adding a new event");
  });

  // Close the window.
  gBrowser.removeTab(tab, { animate: false });
  // Ensure actual window destruction is not delayed (too long).
  SpecialPowers.DOMWindowUtils.garbageCollect();

  // Spawn the check in the keepaliveTab, so that we can read the ConsoleAPIStorage correctly
  gBrowser.selectedTab = keepaliveTab;
  browser = gBrowser.selectedBrowser;

  // Spin the event loop to make sure everything is cleared.
  await SpecialPowers.spawn(browser, [], () => {});

  await SpecialPowers.spawn(browser, [windowId], function(windowId) {
    var ConsoleAPIStorage = Cc["@mozilla.org/consoleAPI-storage;1"].getService(
      Ci.nsIConsoleAPIStorage
    );
    is(
      ConsoleAPIStorage.getEvents(windowId).length,
      0,
      "tab close is clearing the cache"
    );
  });
});
