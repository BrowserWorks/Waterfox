/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that clicking on the Start button next to a Service Worker works as
// intended in about:debugging.
// It should cause a worker to start running in a child process.

// Service workers can't be loaded from chrome://, but http:// is ok with
// dom.serviceWorkers.testing.enabled turned on.
const SERVICE_WORKER = URL_ROOT + "service-workers/empty-sw.js";
const TAB_URL = URL_ROOT + "service-workers/empty-sw.html";

const SW_TIMEOUT = 1000;

add_task(function* () {
  info("Turn on workers via mochitest http.");
  yield new Promise(done => {
    let options = { "set": [
      // Accept workers from mochitest's http.
      ["dom.serviceWorkers.testing.enabled", true],
      // Reduce the timeout to accelerate service worker freezing
      ["dom.serviceWorkers.idle_timeout", SW_TIMEOUT],
      ["dom.serviceWorkers.idle_extended_timeout", SW_TIMEOUT],
    ]};
    SpecialPowers.pushPrefEnv(options, done);
  });

  let { tab, document } = yield openAboutDebugging("workers");

  // Listen for mutations in the service-workers list.
  let serviceWorkersElement = getServiceWorkerList(document);
  let onMutation = waitForMutation(serviceWorkersElement, { childList: true });

  // Open a tab that registers an empty service worker.
  let swTab = yield addTab(TAB_URL);

  // Wait for the service-workers list to update.
  yield onMutation;

  // Check that the service worker appears in the UI.
  assertHasTarget(true, document, "service-workers", SERVICE_WORKER);

  info("Ensure that the registration resolved before trying to interact with " +
    "the service worker.");
  yield waitForServiceWorkerRegistered(swTab);
  ok(true, "Service worker registration resolved");

  yield waitForServiceWorkerActivation(SERVICE_WORKER, document);

  // Retrieve the Target element corresponding to the service worker.
  let names = [...document.querySelectorAll("#service-workers .target-name")];
  let name = names.filter(element => element.textContent === SERVICE_WORKER)[0];
  ok(name, "Found the service worker in the list");
  let targetElement = name.parentNode.parentNode;

  // The service worker may already be killed with the low 1s timeout
  if (!targetElement.querySelector(".start-button")) {
    // Check that there is a Debug button but not a Start button.
    ok(targetElement.querySelector(".debug-button"), "Found its debug button");

    // Wait for the service worker to be killed due to inactivity.
    yield waitForMutation(targetElement, { childList: true });
  } else {
    // Check that there is no Debug button when the SW is already shut down.
    ok(!targetElement.querySelector(".debug-button"), "No debug button when " +
      "the worker is already killed");
  }

  // We should now have a Start button but no Debug button.
  let startBtn = targetElement.querySelector(".start-button");
  ok(startBtn, "Found its start button");
  ok(!targetElement.querySelector(".debug-button"), "No debug button");

  // Click on the Start button and wait for the service worker to be back.
  let onStarted = waitForMutation(targetElement, { childList: true });
  startBtn.click();
  yield onStarted;

  // Check that we have a Debug button but not a Start button again.
  ok(targetElement.querySelector(".debug-button"), "Found its debug button");
  ok(!targetElement.querySelector(".start-button"), "No start button");

  // Finally, unregister the service worker itself.
  try {
    yield unregisterServiceWorker(swTab, serviceWorkersElement);
    ok(true, "Service worker registration unregistered");
  } catch (e) {
    ok(false, "SW not unregistered; " + e);
  }

  yield removeTab(swTab);
  yield closeAboutDebugging(tab);
});
