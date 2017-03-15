/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* global sendAsyncMessage */

"use strict";

// Test that clicking on the Push button next to a Service Worker works as
// intended in about:debugging.
// It should trigger a "push" notification in the worker.

// Service workers can't be loaded from chrome://, but http:// is ok with
// dom.serviceWorkers.testing.enabled turned on.
const SERVICE_WORKER = URL_ROOT + "service-workers/push-sw.js";
const TAB_URL = URL_ROOT + "service-workers/push-sw.html";

add_task(function* () {
  info("Turn on workers via mochitest http.");
  yield new Promise(done => {
    let options = { "set": [
      // Accept workers from mochitest's http.
      ["dom.serviceWorkers.testing.enabled", true],
    ]};
    SpecialPowers.pushPrefEnv(options, done);
  });

  let { tab, document } = yield openAboutDebugging("workers");

  // Listen for mutations in the service-workers list.
  let serviceWorkersElement = getServiceWorkerList(document);
  let onMutation = waitForMutation(serviceWorkersElement, { childList: true });

  // Open a tab that registers a push service worker.
  let swTab = yield addTab(TAB_URL);

  info("Make the test page notify us when the service worker sends a message.");

  yield ContentTask.spawn(swTab.linkedBrowser, {}, function () {
    let win = content.wrappedJSObject;
    win.navigator.serviceWorker.addEventListener("message", function (event) {
      sendAsyncMessage(event.data);
    }, false);
  });

  // Expect the service worker to claim the test window when activating.
  let mm = swTab.linkedBrowser.messageManager;
  let onClaimed = new Promise(done => {
    mm.addMessageListener("sw-claimed", function listener() {
      mm.removeMessageListener("sw-claimed", listener);
      done();
    });
  });

  // Wait for the service-workers list to update.
  yield onMutation;

  // Check that the service worker appears in the UI.
  assertHasTarget(true, document, "service-workers", SERVICE_WORKER);

  info("Ensure that the registration resolved before trying to interact with " +
    "the service worker.");
  yield waitForServiceWorkerRegistered(swTab);
  ok(true, "Service worker registration resolved");

  yield waitForServiceWorkerActivation(SERVICE_WORKER, document);

  // Retrieve the Push button for the worker.
  let names = [...document.querySelectorAll("#service-workers .target-name")];
  let name = names.filter(element => element.textContent === SERVICE_WORKER)[0];
  ok(name, "Found the service worker in the list");

  let targetElement = name.parentNode.parentNode;

  let pushBtn = targetElement.querySelector(".push-button");
  ok(pushBtn, "Found its push button");

  info("Wait for the service worker to claim the test window before " +
    "proceeding.");
  yield onClaimed;

  info("Click on the Push button and wait for the service worker to receive " +
    "a push notification");
  let onPushNotification = new Promise(done => {
    mm.addMessageListener("sw-pushed", function listener() {
      mm.removeMessageListener("sw-pushed", listener);
      done();
    });
  });
  pushBtn.click();
  yield onPushNotification;
  ok(true, "Service worker received a push notification");

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
