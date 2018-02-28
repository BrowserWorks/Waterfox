/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests that the eventListeners request works when there are event handlers
 * that the debugger cannot unwrap.
 */

const TAB_URL = EXAMPLE_URL + "doc_native-event-handler.html";

var gClient;
var gTab;

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
      .then((aTab) => {
        gTab = aTab;
        return attachThreadActorForUrl(gClient, TAB_URL);
      })
      .then(pauseDebuggee)
      .then(testEventListeners)
      .then(() => gClient.close())
      .then(finish)
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });
  });
}

function pauseDebuggee(aThreadClient) {
  let deferred = promise.defer();

  gClient.addOneTimeListener("paused", (aEvent, aPacket) => {
    is(aPacket.type, "paused",
      "We should now be paused.");
    is(aPacket.why.type, "debuggerStatement",
      "The debugger statement was hit.");

    deferred.resolve(aThreadClient);
  });

  generateMouseClickInTab(gTab, "content.document.querySelector('button')");

  return deferred.promise;
}

function testEventListeners(aThreadClient) {
  let deferred = promise.defer();

  aThreadClient.eventListeners(aPacket => {
    if (aPacket.error) {
      let msg = "Error getting event listeners: " + aPacket.message;
      ok(false, msg);
      deferred.reject(msg);
      return;
    }

    // There are 3 event listeners in the page: button.onclick, window.onload
    // and one more from the video element controls.
    is(aPacket.listeners.length, 3, "Found all event listeners.");
    aThreadClient.resume(deferred.resolve);
  });

  return deferred.promise;
}

registerCleanupFunction(function () {
  gClient = null;
});
