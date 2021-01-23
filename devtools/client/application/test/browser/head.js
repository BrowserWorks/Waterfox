/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* eslint-env browser */
/* eslint no-unused-vars: [2, {"vars": "local"}] */
/* import-globals-from ../../../shared/test/shared-head.js */

"use strict";

// Load the shared-head file first.
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/shared/test/shared-head.js",
  this
);

/**
 * Set all preferences needed to enable service worker debugging and testing.
 */
async function enableServiceWorkerDebugging() {
  // Enable service workers.
  await pushPref("dom.serviceWorkers.enabled", true);
  // Accept workers from mochitest's http.
  await pushPref("dom.serviceWorkers.testing.enabled", true);
  // Force single content process, see Bug 1231208 for the SW refactor that should enable
  // SW debugging in multi-e10s.
  await pushPref("dom.ipc.processCount", 1);

  // Enable service workers in the debugger
  await pushPref("devtools.debugger.features.windowless-service-workers", true);
  // Disable randomly spawning processes during tests
  await pushPref("dom.ipc.processPrelaunch.enabled", false);

  // Wait for dom.ipc.processCount to be updated before releasing processes.
  Services.ppmm.releaseCachedProcesses();
}

async function enableApplicationPanel() {
  // FIXME bug 1575427 this rejection is very common.
  const { PromiseTestUtils } = ChromeUtils.import(
    "resource://testing-common/PromiseTestUtils.jsm"
  );
  PromiseTestUtils.whitelistRejectionsGlobally(
    /this._frontCreationListeners is null/
  );

  // Enable all preferences related to service worker debugging.
  await enableServiceWorkerDebugging();

  // Enable web manifest processing.
  Services.prefs.setBoolPref("dom.manifest.enabled", true);

  // Enable application panel in DevTools.
  await pushPref("devtools.application.enabled", true);
}

function getWorkerContainers(doc) {
  return doc.querySelectorAll(".js-sw-container");
}

async function openNewTabAndApplicationPanel(url) {
  const tab = await addTab(url);
  const target = await TargetFactory.forTab(tab);

  const toolbox = await gDevTools.showToolbox(target, "application");
  const panel = toolbox.getCurrentPanel();
  return { panel, tab, target, toolbox };
}

async function unregisterAllWorkers(client, doc) {
  info("Wait until all workers have a valid registrationFront");
  let workers;
  await asyncWaitUntil(async function() {
    workers = await client.mainRoot.listAllWorkers();
    const allWorkersRegistered = workers.service.every(
      worker => !!worker.registrationFront
    );
    return allWorkersRegistered;
  });

  info("Unregister all service workers");
  for (const worker of workers.service) {
    await worker.registrationFront.unregister();
  }

  // wait for service workers to disappear from the UI
  waitUntil(() => getWorkerContainers(doc).length === 0);
}

async function waitForWorkerRegistration(swTab) {
  info("Wait until the registration appears on the window");
  const swBrowser = swTab.linkedBrowser;
  await asyncWaitUntil(async () =>
    SpecialPowers.spawn(swBrowser, [], function() {
      return !!content.wrappedJSObject.getRegistration();
    })
  );
}

function selectPage(panel, page) {
  /**
   * Select a page by simulating a user click in the sidebar.
   * @param {string} page The page we want to select (see `PAGE_TYPES`)
   **/
  info(`Selecting application page: ${page}`);
  const doc = panel.panelWin.document;
  const navItem = doc.querySelector(`.js-sidebar-${page}`);
  navItem.click();
}
