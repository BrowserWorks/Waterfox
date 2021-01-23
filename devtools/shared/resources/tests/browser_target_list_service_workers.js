/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test the TargetList API for service workers in content tabs.

const { TargetList } = require("devtools/shared/resources/target-list");
const { TYPES } = TargetList;

const FISSION_TEST_URL = URL_ROOT_SSL + "fission_document.html";

add_task(async function() {
  // Enabled devtools.browsertoolbox.fission to listen to all target types.
  await pushPref("devtools.browsertoolbox.fission", true);

  // Disable the preloaded process as it creates processes intermittently
  // which forces the emission of RDP requests we aren't correctly waiting for.
  await pushPref("dom.ipc.processPrelaunch.enabled", false);

  info("Setup the test page with workers of all types");
  const client = await createLocalClient();
  const mainRoot = client.mainRoot;

  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  const tab = await addTab(FISSION_TEST_URL);

  info("Create a target list for a tab target");
  const descriptor = await mainRoot.getTab({ tab });
  const target = await descriptor.getTarget();
  const targetList = new TargetList(mainRoot, target);

  // Enable Service Worker listening.
  targetList.listenForServiceWorkers = true;
  await targetList.startListening();

  const serviceWorkerTargets = targetList.getAllTargets([TYPES.SERVICE_WORKER]);
  is(serviceWorkerTargets.length, 1, "TargetList has 1 service worker target");

  info("Check that the onAvailable is done when watchTargets resolves");
  const targets = [];
  const onAvailable = async ({ targetFront }) => {
    // Wait for one second here to check that watch targets waits for
    // the onAvailable callbacks correctly.
    await wait(1000);
    targets.push(targetFront);
  };
  const onDestroyed = ({ targetFront }) =>
    targets.splice(targets.indexOf(targetFront), 1);

  await targetList.watchTargets(
    [TYPES.SERVICE_WORKER],
    onAvailable,
    onDestroyed
  );

  // We expect onAvailable to have been called one time, for the only service
  // worker target available in the test page.
  is(targets.length, 1, "onAvailable has resolved");
  is(
    targets[0],
    serviceWorkerTargets[0],
    "onAvailable was called with the expected service worker target"
  );

  info("Unregister the worker and wait until onDestroyed is called.");
  SpecialPowers.spawn(tab.linkedBrowser, [], function() {
    const win = content.wrappedJSObject;
    // win.registration is set by the test page.
    win.registration.unregister();
  });
  await waitUntil(() => targets.length === 0);

  // Stop listening to avoid worker related requests
  targetList.stopListening();

  await client.waitForRequestsToSettle();

  await client.close();
});
