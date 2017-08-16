/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Check that source maps and breakpoints work with minified javascript.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-source-map");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-source-map",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_minified();
                           });
  });
  do_test_pending();
}

function test_minified() {
  gThreadClient.addOneTimeListener("newSource", function _onNewSource(event, packet) {
    do_check_eq(event, "newSource");
    do_check_eq(packet.type, "newSource");
    do_check_true(!!packet.source);

    do_check_eq(packet.source.url, "http://example.com/foo.js",
                "The new source should be foo.js");
    do_check_eq(packet.source.url.indexOf("foo.min.js"), -1,
                "The new source should not be the minified file");
  });

  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    do_check_eq(event, "paused");
    do_check_eq(packet.why.type, "debuggerStatement");

    let location = {
      line: 5
    };

    getSource(gThreadClient, "http://example.com/foo.js").then(source => {
      source.setBreakpoint(location, function (response, bpClient) {
        do_check_true(!response.error);
        testHitBreakpoint();
      });
    });
  });

  // This is the original foo.js, which was then minified with uglifyjs version
  // 2.2.5 and the "--mangle" option.
  //
  // (function () {
  //   debugger;
  //   function foo(n) {
  //     var bar = n + n;
  //     var unused = null;
  //     return bar;
  //   }
  //   for (var i = 0; i < 10; i++) {
  //     foo(i);
  //   }
  // }());

  // eslint-disable-next-line max-len
  let code = '(function(){debugger;function r(r){var n=r+r;var u=null;return n}for(var n=0;n<10;n++){r(n)}})();\n//# sourceMappingURL=data:text/json,{"file":"foo.min.js","version":3,"sources":["foo.js"],"names":["foo","n","bar","unused","i"],"mappings":"CAAC,WACC,QACA,SAASA,GAAIC,GACX,GAAIC,GAAMD,EAAIA,CACd,IAAIE,GAAS,IACb,OAAOD,GAET,IAAK,GAAIE,GAAI,EAAGA,EAAI,GAAIA,IAAK,CAC3BJ,EAAII"}';

  Components.utils.evalInSandbox(code, gDebuggee, "1.8",
                                 "http://example.com/foo.min.js", 1);
}

function testHitBreakpoint(timesHit = 0) {
  gClient.addOneTimeListener("paused", function (event, packet) {
    ++timesHit;

    do_check_eq(event, "paused");
    do_check_eq(packet.why.type, "breakpoint");

    if (timesHit === 10) {
      gThreadClient.resume(() => finishClient(gClient));
    } else {
      testHitBreakpoint(timesHit);
    }
  });

  gThreadClient.resume();
}
