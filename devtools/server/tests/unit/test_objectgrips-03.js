/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

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
  gDebuggee.eval(function stopMe(arg1) {
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

    do_check_eq(args[0].class, "Object");

    let objClient = gThreadClient.pauseGrip(args[0]);
    objClient.getProperty("x", function (response) {
      do_check_eq(response.descriptor.configurable, true);
      do_check_eq(response.descriptor.enumerable, true);
      do_check_eq(response.descriptor.writable, true);
      do_check_eq(response.descriptor.value, 10);

      objClient.getProperty("y", function (response) {
        do_check_eq(response.descriptor.configurable, true);
        do_check_eq(response.descriptor.enumerable, true);
        do_check_eq(response.descriptor.writable, true);
        do_check_eq(response.descriptor.value, "kaiju");

        objClient.getProperty("a", function (response) {
          do_check_eq(response.descriptor.configurable, true);
          do_check_eq(response.descriptor.enumerable, true);
          do_check_eq(response.descriptor.get.type, "object");
          do_check_eq(response.descriptor.get.class, "Function");
          do_check_eq(response.descriptor.set.type, "undefined");

          gThreadClient.resume(function () {
            gClient.close().then(gCallback);
          });
        });
      });
    });
  });

  gDebuggee.eval("stopMe({ x: 10, y: 'kaiju', get a() { return 42; } })");
}

