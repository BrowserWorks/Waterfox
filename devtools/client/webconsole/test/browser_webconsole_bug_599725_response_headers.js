/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const INIT_URI = "data:text/plain;charset=utf8,hello world";
const TEST_URI = "http://example.com/browser/devtools/client/webconsole/" +
                 "test/test-bug-599725-response-headers.sjs";

function performTest(request, hud) {
  let deferred = promise.defer();

  let headers = null;

  function readHeader(name) {
    for (let header of headers) {
      if (header.name == name) {
        return header.value;
      }
    }
    return null;
  }

  hud.ui.proxy.webConsoleClient.getResponseHeaders(request.actor,
    function (response) {
      headers = response.headers;
      ok(headers, "we have the response headers for reload");

      let contentType = readHeader("Content-Type");
      let contentLength = readHeader("Content-Length");

      ok(!contentType, "we do not have the Content-Type header");
      isnot(contentLength, 60, "Content-Length != 60");

      executeSoon(deferred.resolve);
    });

  return deferred.promise;
}

let waitForRequest = Task.async(function*(hud) {
  let request = yield waitForFinishedRequest(req=> {
    return req.response.status === "304";
  });

  yield performTest(request, hud);
});

add_task(function* () {
  // Disable rcwn to make sure we will send a conditional request.
  yield pushPref("network.http.rcwn.enabled", false);

  let { browser } = yield loadTab(INIT_URI);

  let hud = yield openConsole();

  let gotLastRequest = waitForRequest(hud);

  let loaded = loadBrowser(browser);
  BrowserTestUtils.loadURI(browser, TEST_URI);
  yield loaded;

  let reloaded = loadBrowser(browser);
  ContentTask.spawn(browser, null, "() => content.location.reload()");
  yield reloaded;

  yield gotLastRequest;
});
