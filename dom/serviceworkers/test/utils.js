function waitForState(worker, state, context) {
  return new Promise(resolve => {
    function onStateChange() {
      if (worker.state === state) {
        worker.removeEventListener("statechange", onStateChange);
        resolve(context);
      }
    }

    // First add an event listener, so we won't miss any change that happens
    // before we check the current state.
    worker.addEventListener("statechange", onStateChange);

    // Now check if the worker is already in the desired state.
    onStateChange();
  });
}

/**
 * Helper for browser tests to issue register calls from the content global and
 * wait for the SW to progress to the active state, as most tests desire.
 * From the ContentTask.spawn, use via
 * `content.wrappedJSObject.registerAndWaitForActive`.
 */
async function registerAndWaitForActive(...args) {
  console.log("...calling register");
  const reg = await navigator.serviceWorker.register(...args);
  // Unless registration resurrection happens, the SW should be in the
  // installing slot.
  console.log("...waiting for activation");
  await waitForState(reg.installing, "activated", reg);
  console.log("...activated!");
  return reg;
}

/**
 * Helper to create an iframe with the given URL and return the first
 * postMessage payload received.  This is intended to be used when creating
 * cross-origin iframes.
 *
 * A promise will be returned that resolves with the payload of the postMessage
 * call.
 */
function createIframeAndWaitForMessage(url) {
  const iframe = document.createElement("iframe");
  document.body.appendChild(iframe);
  return new Promise(resolve => {
    window.addEventListener(
      "message",
      event => {
        resolve(event.data);
      },
      { once: true }
    );
    iframe.src = url;
  });
}

/**
 * Helper to create a nested iframe into the iframe created by
 * createIframeAndWaitForMessage().
 *
 * A promise will be returned that resolves with the payload of the postMessage
 * call.
 */
function createNestedIframeAndWaitForMessage(url) {
  const iframe = document.getElementsByTagName("iframe")[0];
  iframe.contentWindow.postMessage("create nested iframe", "*");
  return new Promise(resolve => {
    window.addEventListener(
      "message",
      event => {
        resolve(event.data);
      },
      { once: true }
    );
  });
}

async function unregisterAll() {
  const registrations = await navigator.serviceWorker.getRegistrations();
  for (const reg of registrations) {
    await reg.unregister();
  }
}
