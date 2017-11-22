/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const RAND = Math.random();
const URL = "http://mochi.test:8888/browser/" +
            "browser/components/sessionstore/test/browser_sessionStorage.html" +
            "?" + RAND;

const OUTER_VALUE = "outer-value-" + RAND;

function getEstimateChars() {
  let snap;
  if (gMultiProcessBrowser) {
    snap = Services.telemetry.histogramSnapshots.content["FX_SESSION_RESTORE_DOM_STORAGE_SIZE_ESTIMATE_CHARS"];
  } else {
    snap = Services.telemetry.histogramSnapshots.parent["FX_SESSION_RESTORE_DOM_STORAGE_SIZE_ESTIMATE_CHARS"];
  }
  if (!snap) {
    return 0;
  }
  return snap.counts[4];
}

// Test that we record the size of messages.
add_task(async function test_telemetry() {
  Services.telemetry.canRecordExtended = true;

  let prev = getEstimateChars()

  let tab = BrowserTestUtils.addTab(gBrowser, URL);
  let browser = tab.linkedBrowser;
  await promiseBrowserLoaded(browser);

  // Flush to make sure we submitted telemetry data.
  await TabStateFlusher.flush(browser);

  // There is no good way to make sure that the parent received the histogram entries from the child processes.
  // Let's stick to the ugly, spinning the event loop until we have a good approach (Bug 1357509).
  await BrowserTestUtils.waitForCondition(() => {
    return getEstimateChars() > prev;
  });

  Assert.ok(true);
  await promiseRemoveTab(tab);
  Services.telemetry.canRecordExtended = false;
});

// Lower the size limit for DOM Storage content. Check that DOM Storage
// is not updated, but that other things remain updated.
add_task(async function test_large_content() {
  Services.prefs.setIntPref("browser.sessionstore.dom_storage_limit", 5);

  let tab = BrowserTestUtils.addTab(gBrowser, URL);
  let browser = tab.linkedBrowser;
  await promiseBrowserLoaded(browser);

  // Flush to make sure chrome received all data.
  await TabStateFlusher.flush(browser);

  let state = JSON.parse(ss.getTabState(tab));
  info(JSON.stringify(state, null, "\t"));
  Assert.equal(state.storage, null, "We have no storage for the tab");
  Assert.equal(state.entries[0].title, OUTER_VALUE);
  await promiseRemoveTab(tab);

  Services.prefs.clearUserPref("browser.sessionstore.dom_storage_limit");
});
