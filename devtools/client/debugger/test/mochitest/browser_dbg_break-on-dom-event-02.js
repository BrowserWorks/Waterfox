/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests that the break-on-dom-events request works even for bound event
 * listeners and handler objects with 'handleEvent' methods.
 */

const TAB_URL = EXAMPLE_URL + "doc_event-listeners-03.html";

var gClient, gThreadClient;

function test() {
  if (!DebuggerServer.initialized) {
    DebuggerServer.init();
    DebuggerServer.addBrowserActors();
  }

  let transport = DebuggerServer.connectPipe();
  gClient = new DebuggerClient(transport);
  gClient.connect().then(([aType, aTraits]) => {
    is(aType, "browser",
      "Root actor should identify itself as a browser.");

    addTab(TAB_URL)
      .then(() => attachThreadActorForUrl(gClient, TAB_URL))
      .then(aThreadClient => gThreadClient = aThreadClient)
      .then(pauseDebuggee)
      .then(testBreakOnClick)
      .then(() => gClient.close())
      .then(finish)
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });
  });
}

function pauseDebuggee() {
  let deferred = promise.defer();

  gClient.addOneTimeListener("paused", (aEvent, aPacket) => {
    is(aPacket.type, "paused",
      "We should now be paused.");
    is(aPacket.why.type, "debuggerStatement",
      "The debugger statement was hit.");

    gThreadClient.resume(deferred.resolve);
  });

  // Spin the event loop before causing the debuggee to pause, to allow
  // this function to return first.
  executeSoon(() => triggerButtonClick("initialSetup"));

  return deferred.promise;
}

// Test pause on a single event.
function testBreakOnClick() {
  let deferred = promise.defer();

  // Test calling pauseOnDOMEvents from a running state.
  gThreadClient.pauseOnDOMEvents(["click"], (aPacket) => {
    is(aPacket.error, undefined,
      "The pause-on-click request completed successfully.");
    let handlers = ["clicker"];

    gClient.addListener("paused", function tester(aEvent, aPacket) {
      is(aPacket.why.type, "pauseOnDOMEvents",
        "A hidden breakpoint was hit.");

      switch (handlers.length) {
        case 1:
          is(aPacket.frame.where.line, 25, "Found the clicker handler.");
          handlers.push("handleEventClick");
          break;
        case 2:
          is(aPacket.frame.where.line, 35, "Found the handleEventClick handler.");
          handlers.push("boundHandleEventClick");
          break;
        case 3:
          is(aPacket.frame.where.line, 45, "Found the boundHandleEventClick handler.");
          gClient.removeListener("paused", tester);
          deferred.resolve();
      }

      gThreadClient.resume(() => triggerButtonClick(handlers.slice(-1)));
    });

    triggerButtonClick(handlers.slice(-1));
  });

  return deferred.promise;
}

function triggerButtonClick(aNodeId) {
  let button = content.document.getElementById(aNodeId);
  EventUtils.sendMouseEvent({ type: "click" }, button);
}

registerCleanupFunction(function () {
  gClient = null;
  gThreadClient = null;
});
