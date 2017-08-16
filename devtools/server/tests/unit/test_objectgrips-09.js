/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * This tests exercises getProtypesAndProperties message accepted
 * by a thread actor.
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
  gDebuggee.eval(function stopMe(arg1, arg2) {
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
    let args = packet.frame.arguments;

    gThreadClient.getPrototypesAndProperties(
      [args[0].actor, args[1].actor], function (response) {
        let obj1 = response.actors[args[0].actor];
        let obj2 = response.actors[args[1].actor];
        do_check_eq(obj1.ownProperties.x.configurable, true);
        do_check_eq(obj1.ownProperties.x.enumerable, true);
        do_check_eq(obj1.ownProperties.x.writable, true);
        do_check_eq(obj1.ownProperties.x.value, 10);

        do_check_eq(obj1.ownProperties.y.configurable, true);
        do_check_eq(obj1.ownProperties.y.enumerable, true);
        do_check_eq(obj1.ownProperties.y.writable, true);
        do_check_eq(obj1.ownProperties.y.value, "kaiju");

        do_check_eq(obj2.ownProperties.z.configurable, true);
        do_check_eq(obj2.ownProperties.z.enumerable, true);
        do_check_eq(obj2.ownProperties.z.writable, true);
        do_check_eq(obj2.ownProperties.z.value, 123);

        do_check_true(obj1.prototype != undefined);
        do_check_true(obj2.prototype != undefined);

        gThreadClient.resume(function () {
          gClient.close().then(gCallback);
        });
      });
  });

  gDebuggee.eval("stopMe({ x: 10, y: 'kaiju'}, { z: 123 })");
}

