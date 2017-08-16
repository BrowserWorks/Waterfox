/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Check that we can load sources whose content is embedded in the
 * "sourcesContent" field of a source map.
 */

var gDebuggee;
var gClient;
var gThreadClient;

const {SourceNode} = require("source-map");

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-source-map");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-source-map",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_source_content();
                           });
  });
  do_test_pending();
}

function test_source_content() {
  let numNewSources = 0;

  gThreadClient.addListener("newSource", function _onNewSource(event, packet) {
    if (++numNewSources !== 3) {
      return;
    }
    gThreadClient.removeListener("newSource", _onNewSource);

    gThreadClient.getSources(function (response) {
      do_check_true(!response.error, "Should not get an error");

      testContents(response.sources, 0, (timesCalled) => {
        do_check_eq(timesCalled, 3);
        finishClient(gClient);
      });
    });
  });

  let node = new SourceNode(null, null, null, [
    new SourceNode(1, 0, "a.js", "function a() { return 'a'; }\n"),
    new SourceNode(1, 0, "b.js", "function b() { return 'b'; }\n"),
    new SourceNode(1, 0, "c.js", "function c() { return 'c'; }\n"),
  ]);

  node.setSourceContent("a.js", "content for a.js");
  node.setSourceContent("b.js", "content for b.js");
  node.setSourceContent("c.js", "content for c.js");

  let { code, map } = node.toStringWithSourceMap({
    file: "abc.js"
  });

  code += "//# sourceMappingURL=data:text/json;base64," + btoa(map.toString());

  Components.utils.evalInSandbox(code, gDebuggee, "1.8",
                                 "http://example.com/www/js/abc.js", 1);
}

function testContents(sources, timesCalled, callback) {
  if (sources.length === 0) {
    callback(timesCalled);
    return;
  }

  let source = sources[0];
  let sourceClient = gThreadClient.source(sources[0]);

  if (sourceClient.url) {
    sourceClient.source((response) => {
      do_check_true(!response.error,
                    "Should not get an error loading the source from sourcesContent");

      let expectedContent = "content for " + source.url;
      do_check_eq(response.source, expectedContent,
                  "Should have the expected source content");

      testContents(sources.slice(1), timesCalled + 1, callback);
    });
  } else {
    testContents(sources.slice(1), timesCalled, callback);
  }
}
