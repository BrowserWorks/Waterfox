/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const chrome_base = "chrome://mochitests/content/browser/browser/base/content/test/general/";
Services.scriptloader.loadSubScript(chrome_base + "head.js", this);
/* import-globals-from ../general/head.js */

const remoteClientsFixture = [ { id: 1, name: "Foo"}, { id: 2, name: "Bar"} ];

let [testTab] = gBrowser.visibleTabs;

add_task(async function setup() {
  await promiseSyncReady();
  is(gBrowser.visibleTabs.length, 1, "there is one visible tab");
});

// We are not testing the devices popup contents, since it is already tested by
// browser_contextmenu_sendpage.js and the code to populate it is the same.

add_task(async function test_tab_contextmenu() {
  const sandbox = setupSendTabMocks({ syncReady: true, clientsSynced: true, remoteClients: remoteClientsFixture,
                                      state: UIState.STATUS_SIGNED_IN, isSendableURI: true });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, false, "Send tab to device is enabled");

  sandbox.restore();
});

add_task(async function test_tab_contextmenu_unconfigured() {
  const sandbox = setupSendTabMocks({ syncReady: true, clientsSynced: true, remoteClients: remoteClientsFixture,
                                      state: UIState.STATUS_NOT_CONFIGURED, isSendableURI: true });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, false, "Send tab to device is enabled");

  sandbox.restore();
});

add_task(async function test_tab_contextmenu_not_sendable() {
  const sandbox = setupSendTabMocks({ syncReady: true, clientsSynced: true, remoteClients: [{ id: 1, name: "Foo"}],
                                      state: UIState.STATUS_SIGNED_IN, isSendableURI: false });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, true, "Send tab to device is disabled");

  sandbox.restore();
});

add_task(async function test_tab_contextmenu_not_synced_yet() {
  const sandbox = setupSendTabMocks({ syncReady: true, clientsSynced: false, remoteClients: [],
                                      state: UIState.STATUS_SIGNED_IN, isSendableURI: true });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, true, "Send tab to device is disabled");

  sandbox.restore();
});

add_task(async function test_tab_contextmenu_sync_not_ready_configured() {
  const sandbox = setupSendTabMocks({ syncReady: false, clientsSynced: false, remoteClients: null,
                                      state: UIState.STATUS_SIGNED_IN, isSendableURI: true });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, true, "Send tab to device is disabled");

  sandbox.restore();
});

add_task(async function test_tab_contextmenu_sync_not_ready_other_state() {
  const sandbox = setupSendTabMocks({ syncReady: false, clientsSynced: false, remoteClients: null,
                                      state: UIState.STATUS_NOT_VERIFIED, isSendableURI: true });

  await updateTabContextMenu(testTab);
  is(document.getElementById("context_sendTabToDevice").hidden, false, "Send tab to device is shown");
  is(document.getElementById("context_sendTabToDevice").disabled, false, "Send tab to device is enabled");

  sandbox.restore();
});
