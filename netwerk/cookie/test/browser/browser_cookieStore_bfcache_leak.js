"use strict";

// A page that holds cookieStore and receives cookie changes while it is in
// the bfcache must not be leaked once its bfcache entry is evicted.

const TEST_URL_OTHER_SITE =
  "https://example.org/" + TEST_PATH + "file_empty.html";

async function forceGCAndCC(browser) {
  await SpecialPowers.spawn(browser, [], () => {
    for (let i = 0; i < 3; i++) {
      Cu.forceGC();
      Cu.forceCC();
    }
  });
}

function getDeadWindowReports(marker) {
  let mgr = Cc["@mozilla.org/memory-reporter-manager;1"].getService(
    Ci.nsIMemoryReporterManager
  );
  let paths = new Set();
  return new Promise(resolve => {
    mgr.getReports(
      (process, path) => {
        if (
          path.startsWith("explicit/window-objects/top(none)/") &&
          path.includes(marker)
        ) {
          paths.add(path.split("/window(")[1]?.split(")/")[0]);
        }
      },
      null,
      () => resolve([...paths]),
      null,
      false
    );
  });
}

add_task(async function test_bfcached_page_with_cookie_changes_is_freed() {
  await SpecialPowers.pushPrefEnv({
    set: [["dom.ipc.processCount.webIsolated", 1]],
  });

  let anchorTab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    TEST_TOP_PAGE
  );

  let marker = "bfcache-leak-" + Math.random().toString(36).slice(2);
  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    TEST_TOP_PAGE + "?" + marker
  );
  await SpecialPowers.spawn(tab.linkedBrowser, [], () => {
    content.wrappedJSObject.store = content.wrappedJSObject.cookieStore;
  });

  let loaded = BrowserTestUtils.browserLoaded(
    tab.linkedBrowser,
    false,
    TEST_URL_OTHER_SITE
  );
  BrowserTestUtils.startLoadingURIString(
    tab.linkedBrowser,
    TEST_URL_OTHER_SITE
  );
  await loaded;

  await SpecialPowers.spawn(anchorTab.linkedBrowser, [], () => {
    for (let i = 0; i < 10; i++) {
      content.document.cookie = `bfcache_leak_${i}=${i}`;
    }
  });
  await TestUtils.waitForTick();

  BrowserTestUtils.removeTab(tab);
  await forceGCAndCC(anchorTab.linkedBrowser);

  let dead = await getDeadWindowReports(marker);
  Assert.deepEqual(dead, [], "The evicted bfcache page was freed");

  await SpecialPowers.spawn(anchorTab.linkedBrowser, [], () => {
    for (let i = 0; i < 10; i++) {
      content.document.cookie = `bfcache_leak_${i}=; max-age=0`;
    }
  });
  BrowserTestUtils.removeTab(anchorTab);
});
