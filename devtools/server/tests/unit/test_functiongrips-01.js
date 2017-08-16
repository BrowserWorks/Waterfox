/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-grips");
  gDebuggee.eval(function stopMe(arg1) {
    debugger;
  }.toString());

  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-grips",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_named_function();
                           });
  });
  do_test_pending();
}

function test_named_function() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let args = packet.frame.arguments;

    do_check_eq(args[0].class, "Function");
    do_check_eq(args[0].name, "stopMe");
    do_check_eq(args[0].displayName, "stopMe");

    let objClient = gThreadClient.pauseGrip(args[0]);
    objClient.getParameterNames(function (response) {
      do_check_eq(response.parameterNames.length, 1);
      do_check_eq(response.parameterNames[0], "arg1");

      gThreadClient.resume(test_inferred_name_function);
    });
  });

  gDebuggee.eval("stopMe(stopMe)");
}

function test_inferred_name_function() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let args = packet.frame.arguments;

    do_check_eq(args[0].class, "Function");
    // No name for an anonymous function, but it should have an inferred name.
    do_check_eq(args[0].name, undefined);
    do_check_eq(args[0].displayName, "m");

    let objClient = gThreadClient.pauseGrip(args[0]);
    objClient.getParameterNames(function (response) {
      do_check_eq(response.parameterNames.length, 3);
      do_check_eq(response.parameterNames[0], "foo");
      do_check_eq(response.parameterNames[1], "bar");
      do_check_eq(response.parameterNames[2], "baz");

      gThreadClient.resume(test_anonymous_function);
    });
  });

  gDebuggee.eval("var o = { m: function(foo, bar, baz) { } }; stopMe(o.m)");
}

function test_anonymous_function() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let args = packet.frame.arguments;

    do_check_eq(args[0].class, "Function");
    // No name for an anonymous function, and no inferred name, either.
    do_check_eq(args[0].name, undefined);
    do_check_eq(args[0].displayName, undefined);

    let objClient = gThreadClient.pauseGrip(args[0]);
    objClient.getParameterNames(function (response) {
      do_check_eq(response.parameterNames.length, 3);
      do_check_eq(response.parameterNames[0], "foo");
      do_check_eq(response.parameterNames[1], "bar");
      do_check_eq(response.parameterNames[2], "baz");

      gThreadClient.resume(function () {
        finishClient(gClient);
      });
    });
  });

  gDebuggee.eval("stopMe(function(foo, bar, baz) { })");
}

