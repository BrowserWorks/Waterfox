"use strict";

/**
 * This test ensures that we correctly clean up the session state before
 * writing to disk a last time on shutdown. For now it only tests that each
 * tab's shistory is capped to a maximum number of preceding and succeeding
 * entries.
 */

const {XPCOMUtils} = Cu.import("resource://gre/modules/XPCOMUtils.jsm", {});
const {SessionWorker} = Cu.import("resource:///modules/sessionstore/SessionWorker.jsm", {});

const profd = do_get_profile();
const {SessionFile} = Cu.import("resource:///modules/sessionstore/SessionFile.jsm", {});
const {Paths} = SessionFile;

const {File} = OS;

const MAX_ENTRIES = 9;
const URL = "http://example.com/#";

// We need a XULAppInfo to initialize SessionFile
Cu.import("resource://testing-common/AppInfo.jsm", this);
updateAppInfo({
  name: "SessionRestoreTest",
  ID: "{230de50e-4cd1-11dc-8314-0800200c9a66}",
  version: "1",
  platformVersion: "",
});

add_task(async function setup() {
  let source = do_get_file("data/sessionstore_valid.js");
  source.copyTo(profd, "sessionstore.js");
  await writeCompressedFile(Paths.clean.replace("jsonlz4", "js"), Paths.clean);

  // Finish SessionFile initialization.
  await SessionFile.read();

  // Reset prefs on cleanup.
  do_register_cleanup(() => {
    Services.prefs.clearUserPref("browser.sessionstore.max_serialize_back");
    Services.prefs.clearUserPref("browser.sessionstore.max_serialize_forward");
  });
});

function createSessionState(index) {
  // Generate the tab state entries and set the one-based
  // tab-state index to the middle session history entry.
  let tabState = {entries: [], index};
  for (let i = 0; i < MAX_ENTRIES; i++) {
    tabState.entries.push({url: URL + i});
  }

  return {windows: [{tabs: [tabState]}]};
}

async function setMaxBackForward(back, fwd) {
  Services.prefs.setIntPref("browser.sessionstore.max_serialize_back", back);
  Services.prefs.setIntPref("browser.sessionstore.max_serialize_forward", fwd);
  await SessionFile.read();
}

async function writeAndParse(state, path, options = {}) {
  await SessionWorker.post("write", [state, options]);
  return JSON.parse(await File.read(path, {encoding: "utf-8", compression: "lz4"}));
}

add_task(async function test_shistory_cap_none() {
  let state = createSessionState(5);

  // Don't limit the number of shistory entries.
  await setMaxBackForward(-1, -1);

  // Check that no caps are applied.
  let diskState = await writeAndParse(state, Paths.clean, {isFinalWrite: true});
  Assert.deepEqual(state, diskState, "no cap applied");
});

add_task(async function test_shistory_cap_middle() {
  let state = createSessionState(5);
  await setMaxBackForward(2, 3);

  // Cap is only applied on clean shutdown.
  let diskState = await writeAndParse(state, Paths.recovery);
  Assert.deepEqual(state, diskState, "no cap applied");

  // Check that the right number of shistory entries was discarded
  // and the shistory index updated accordingly.
  diskState = await writeAndParse(state, Paths.clean, {isFinalWrite: true});
  let tabState = state.windows[0].tabs[0];
  tabState.entries = tabState.entries.slice(2, 8);
  tabState.index = 3;
  Assert.deepEqual(state, diskState, "cap applied");
});

add_task(async function test_shistory_cap_lower_bound() {
  let state = createSessionState(1);
  await setMaxBackForward(5, 5);

  // Cap is only applied on clean shutdown.
  let diskState = await writeAndParse(state, Paths.recovery);
  Assert.deepEqual(state, diskState, "no cap applied");

  // Check that the right number of shistory entries was discarded.
  diskState = await writeAndParse(state, Paths.clean, {isFinalWrite: true});
  let tabState = state.windows[0].tabs[0];
  tabState.entries = tabState.entries.slice(0, 6);
  Assert.deepEqual(state, diskState, "cap applied");
});

add_task(async function test_shistory_cap_upper_bound() {
  let state = createSessionState(MAX_ENTRIES);
  await setMaxBackForward(5, 5);

  // Cap is only applied on clean shutdown.
  let diskState = await writeAndParse(state, Paths.recovery);
  Assert.deepEqual(state, diskState, "no cap applied");

  // Check that the right number of shistory entries was discarded
  // and the shistory index updated accordingly.
  diskState = await writeAndParse(state, Paths.clean, {isFinalWrite: true});
  let tabState = state.windows[0].tabs[0];
  tabState.entries = tabState.entries.slice(3);
  tabState.index = 6;
  Assert.deepEqual(state, diskState, "cap applied");
});
