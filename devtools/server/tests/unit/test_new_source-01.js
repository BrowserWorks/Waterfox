/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Check basic newSource packet sent from server.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-stack");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-stack",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_simple_new_source();
                           });
  });
  do_test_pending();
}

function test_simple_new_source() {
  gThreadClient.addOneTimeListener("newSource", function (event, packet) {
    do_check_eq(event, "newSource");
    do_check_eq(packet.type, "newSource");
    do_check_true(!!packet.source);
    do_check_true(!!packet.source.url.match(/test_new_source-01.js$/));

    finishClient(gClient);
  });

  Components.utils.evalInSandbox(function inc(n) {
    return n + 1;
  }.toString(), gDebuggee);
}
