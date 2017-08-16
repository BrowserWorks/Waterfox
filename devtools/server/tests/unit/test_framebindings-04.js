/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

/* strict mode code may not contain 'with' statements */
/* eslint-disable strict */

/**
 * Check the environment bindings of a  |with| within a |with|.
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
                             test_pause_frame();
                           });
  });
  do_test_pending();
}

function test_pause_frame() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let env = packet.frame.environment;
    do_check_neq(env, undefined);

    let objClient = gThreadClient.pauseGrip(env.object);
    objClient.getPrototypeAndProperties(function (response) {
      do_check_eq(response.ownProperties.one.value, 1);
      do_check_eq(response.ownProperties.two.value, 2);
      do_check_eq(response.ownProperties.foo, undefined);

      let parentEnv = env.parent;
      do_check_neq(parentEnv, undefined);

      let parentClient = gThreadClient.pauseGrip(parentEnv.object);
      parentClient.getPrototypeAndProperties(function (response) {
        do_check_eq(response.ownProperties.PI.value, Math.PI);
        do_check_eq(response.ownProperties.cos.value.type, "object");
        do_check_eq(response.ownProperties.cos.value.class, "Function");
        do_check_true(!!response.ownProperties.cos.value.actor);

        parentEnv = parentEnv.parent;
        do_check_neq(parentEnv, undefined);

        let bindings = parentEnv.bindings;
        let args = bindings.arguments;
        let vars = bindings.variables;
        do_check_eq(args.length, 1);
        do_check_eq(args[0].number.value, 10);
        do_check_eq(vars.r.value, 10);
        do_check_eq(vars.a.value, Math.PI * 100);
        do_check_eq(vars.arguments.value.class, "Arguments");
        do_check_true(!!vars.arguments.value.actor);
        do_check_eq(vars.foo.value, 2 * Math.PI);

        gThreadClient.resume(function () {
          finishClient(gClient);
        });
      });
    });
  });

  /* eslint-disable */
  gDebuggee.eval("(" + function () {
    function stopMe(number) {
      var a, obj = { one: 1, two: 2 };
      var r = number;
      with (Math) {
        a = PI * r * r;
        with (obj) {
          var foo = two * PI;
          debugger;
        }
      }
    }
    stopMe(10);
  } + ")()");
  /* eslint-enable */
}
