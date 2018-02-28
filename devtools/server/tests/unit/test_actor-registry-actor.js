/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Check that you can register new actors via the ActorRegistrationActor.
 */

var gClient;
var gRegistryFront;
var gActorFront;
var gOldPref;

const { ActorRegistryFront } = require("devtools/shared/fronts/actor-registry");

function run_test() {
  gOldPref = Services.prefs.getBoolPref("devtools.debugger.forbid-certified-apps");
  Services.prefs.setBoolPref("devtools.debugger.forbid-certified-apps", false);
  initTestDebuggerServer();
  DebuggerServer.addBrowserActors();
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(getRegistry);
  do_test_pending();
}

function getRegistry() {
  gClient.listTabs((response) => {
    gRegistryFront = ActorRegistryFront(gClient, response);
    registerNewActor();
  });
}

function registerNewActor() {
  let options = {
    prefix: "helloActor",
    constructor: "HelloActor",
    type: { global: true }
  };

  gRegistryFront
    .registerActor("resource://test/hello-actor.js", options)
    .then(actorFront => (gActorFront = actorFront))
    .then(talkToNewActor)
    .catch(e => {
      DevToolsUtils.reportException("registerNewActor", e);
      do_check_true(false);
    });
}

function talkToNewActor() {
  gClient.listTabs(({ helloActor }) => {
    do_check_true(!!helloActor);
    gClient.request({
      to: helloActor,
      type: "hello"
    }, response => {
      do_check_true(!response.error);
      unregisterNewActor();
    });
  });
}

function unregisterNewActor() {
  gActorFront
    .unregister()
    .then(testActorIsUnregistered)
    .catch(e => {
      DevToolsUtils.reportException("unregisterNewActor", e);
      do_check_true(false);
    });
}

function testActorIsUnregistered() {
  gClient.listTabs(({ helloActor }) => {
    do_check_true(!helloActor);

    Services.prefs.setBoolPref("devtools.debugger.forbid-certified-apps", gOldPref);
    finishClient(gClient);
  });
}
