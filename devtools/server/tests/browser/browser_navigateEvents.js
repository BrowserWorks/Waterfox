/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const URL1 = MAIN_DOMAIN + "navigate-first.html";
const URL2 = MAIN_DOMAIN + "navigate-second.html";

var isE10s = Services.appinfo.browserTabsRemoteAutostart;

SpecialPowers.pushPrefEnv({
  set: [["dom.require_user_interaction_for_beforeunload", false]],
});

var signalAllEventsReceived;
var onAllEventsReceived = new Promise(resolve => {
  signalAllEventsReceived = resolve;
});

// State machine to check events order
var i = 0;
function assertEvent(event, data) {
  switch (i++) {
    case 0:
      is(event, "request", "Get first page load");
      is(data, URL1);
      break;
    case 1:
      is(event, "load-new-document", "Ask to load the second page");
      break;
    case 2:
      is(event, "unload-dialog", "We get the dialog on first page unload");
      break;
    case 3:
      is(
        event,
        "will-navigate",
        "The very first event is will-navigate on server side"
      );
      is(data.newURI, URL2, "newURI property is correct");
      break;
    case isE10s ? 4 : 5: // When e10s is disabled tabNavigated/request order is swapped
      is(
        event,
        "tabNavigated",
        "After the request, the client receive tabNavigated"
      );
      is(data.state, "start", "state is start");
      is(data.url, URL2, "url property is correct");
      is(data.nativeConsoleAPI, true, "nativeConsoleAPI is correct");
      break;
    case isE10s ? 5 : 4:
      is(
        event,
        "request",
        "RDP is async with messageManager, the request happens after will-navigate"
      );
      is(data, URL2);
      break;
    case 6:
      is(event, "DOMContentLoaded");
      is(data.readyState, "interactive");
      break;
    case 7:
      is(event, "load");
      is(data.readyState, "complete");
      break;
    case 8:
      is(
        event,
        "navigate",
        "Then once the second doc is loaded, we get the navigate event"
      );
      is(
        data.readyState,
        "complete",
        "navigate is emitted only once the document is fully loaded"
      );
      break;
    case 9:
      is(event, "tabNavigated", "Finally, the receive the client event");
      is(data.state, "stop", "state is stop");
      is(data.url, URL2, "url property is correct");
      is(data.nativeConsoleAPI, true, "nativeConsoleAPI is correct");

      signalAllEventsReceived();
      break;
  }
}

function waitForOnBeforeUnloadDialog(browser, callback) {
  browser.addEventListener(
    "DOMWillOpenModalDialog",
    async function(event) {
      const stack = browser.parentNode;
      const dialogs = stack.getElementsByTagName("tabmodalprompt");
      await waitUntil(() => dialogs[0]);
      const { button0, button1 } = browser.tabModalPromptBox.getPrompt(
        dialogs[0]
      ).ui;
      callback(button0, button1);
    },
    { capture: true, once: true }
  );
}

var httpObserver = function(subject, topic, state) {
  const channel = subject.QueryInterface(Ci.nsIHttpChannel);
  const url = channel.URI.spec;
  // Only listen for our document request, as many other requests can happen
  if (url == URL1 || url == URL2) {
    assertEvent("request", url);
  }
};
Services.obs.addObserver(httpObserver, "http-on-modify-request");

function onMessage({ data }) {
  assertEvent(data.event, data.data);
}

async function connectAndAttachTab(tab) {
  const target = await TargetFactory.forTab(tab);
  await target.attach();
  const actorID = target.targetForm.actor;
  target.on("tabNavigated", function(packet) {
    assertEvent("tabNavigated", packet);
  });
  return { target, actorID };
}

add_task(async function() {
  // Open a test tab
  const browser = await addTab(URL1);

  // Listen for alert() call being made in navigate-first during unload
  waitForOnBeforeUnloadDialog(browser, function(btnLeave, btnStay) {
    assertEvent("unload-dialog");
    // accept to quit this page to another
    btnLeave.click();
  });

  // Listen for messages sent by the content task
  browser.messageManager.addMessageListener("devtools-test:event", onMessage);

  const tab = gBrowser.getTabForBrowser(browser);
  const { target, actorID } = await connectAndAttachTab(tab);
  await ContentTask.spawn(browser, [actorID], async function(actorId) {
    const { require } = ChromeUtils.import(
      "resource://devtools/shared/Loader.jsm"
    );
    const { DevToolsServer } = require("devtools/server/devtools-server");
    const EventEmitter = require("devtools/shared/event-emitter");

    // !Hack! Retrieve a server side object, the FrameTargetActor instance
    const targetActor = DevToolsServer.searchAllConnectionsForActor(actorId);
    // In order to listen to internal will-navigate/navigate events
    EventEmitter.on(targetActor, "will-navigate", function(data) {
      sendSyncMessage("devtools-test:event", {
        event: "will-navigate",
        data: { newURI: data.newURI },
      });
    });
    EventEmitter.on(targetActor, "navigate", function(data) {
      sendSyncMessage("devtools-test:event", {
        event: "navigate",
        data: { readyState: content.document.readyState },
      });
    });
    // Forward DOMContentLoaded and load events
    addEventListener(
      "DOMContentLoaded",
      function() {
        sendSyncMessage("devtools-test:event", {
          event: "DOMContentLoaded",
          data: { readyState: content.document.readyState },
        });
      },
      { capture: true }
    );
    addEventListener(
      "load",
      function() {
        sendSyncMessage("devtools-test:event", {
          event: "load",
          data: { readyState: content.document.readyState },
        });
      },
      { capture: true }
    );
  });

  // Load another document in this doc to dispatch these events
  assertEvent("load-new-document");

  // Use BrowserTestUtils instead of navigateTo as there is no toolbox opened
  const onBrowserLoaded = BrowserTestUtils.browserLoaded(
    gBrowser.selectedBrowser
  );
  await BrowserTestUtils.loadURI(gBrowser.selectedBrowser, URL2);
  await onBrowserLoaded;

  // Wait for all events to be received
  await onAllEventsReceived;

  // Cleanup
  browser.messageManager.removeMessageListener(
    "devtools-test:event",
    onMessage
  );
  await target.destroy();
  Services.obs.addObserver(httpObserver, "http-on-modify-request");
  DevToolsServer.destroy();
});
