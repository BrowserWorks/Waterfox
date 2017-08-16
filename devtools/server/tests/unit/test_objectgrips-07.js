/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * This test checks that objects which are not extensible report themselves as
 * such.
 */

var gDebuggee;
var gClient;
var gThreadClient;
var gCallback;

function run_test() {
  run_test_with_server(DebuggerServer, function () {
    run_test_with_server(WorkerDebuggerServer, do_test_finished);
  });
  do_test_pending();
}

function run_test_with_server(server, callback) {
  gCallback = callback;
  initTestDebuggerServer(server);
  gDebuggee = addTestGlobal("test-grips", server);
  gDebuggee.eval(function stopMe(arg1, arg2, arg3, arg4) {
    debugger;
  }.toString());

  gClient = new DebuggerClient(server.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-grips",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_object_grip();
                           });
  });
}

function test_object_grip() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let [f, s, ne, e] = packet.frame.arguments;
    let [fClient, sClient, neClient, eClient] = packet.frame.arguments.map(
      a => gThreadClient.pauseGrip(a));

    do_check_false(f.extensible);
    do_check_false(fClient.isExtensible);

    do_check_false(s.extensible);
    do_check_false(sClient.isExtensible);

    do_check_false(ne.extensible);
    do_check_false(neClient.isExtensible);

    do_check_true(e.extensible);
    do_check_true(eClient.isExtensible);

    gThreadClient.resume(_ => {
      gClient.close().then(gCallback);
    });
  });

  gDebuggee.eval("(" + function () {
    let f = {};
    Object.freeze(f);
    let s = {};
    Object.seal(s);
    let ne = {};
    Object.preventExtensions(ne);
    stopMe(f, s, ne, {});
  } + "())");
}

