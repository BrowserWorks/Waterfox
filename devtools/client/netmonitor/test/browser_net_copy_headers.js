/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Tests if copying a request's request/response headers works.
 */

add_task(function* () {
  let { tab, monitor } = yield initNetMonitor(SIMPLE_URL);
  info("Starting test... ");

  let { document, store, windowRequire } = monitor.panelWin;
  let {
    getSortedRequests,
  } = windowRequire("devtools/client/netmonitor/src/selectors/index");

  let wait = waitForNetworkEvents(monitor, 1);
  tab.linkedBrowser.reload();
  yield wait;

  EventUtils.sendMouseEvent({ type: "mousedown" },
    document.querySelectorAll(".request-list-item")[0]);

  let requestItem = getSortedRequests(store.getState()).get(0);
  let { method, httpVersion, status, statusText } = requestItem;

  EventUtils.sendMouseEvent({ type: "contextmenu" },
    document.querySelectorAll(".request-list-item")[0]);

  const EXPECTED_REQUEST_HEADERS = [
    `${method} ${SIMPLE_URL} ${httpVersion}`,
    "Host: example.com",
    "User-Agent: " + navigator.userAgent + "",
    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language: " + navigator.languages.join(",") + ";q=0.5",
    "Accept-Encoding: gzip, deflate",
    "Connection: keep-alive",
    "Upgrade-Insecure-Requests: 1",
    "Pragma: no-cache",
    "Cache-Control: no-cache"
  ].join("\n");

  yield waitForClipboardPromise(function setup() {
    monitor.panelWin.parent.document
      .querySelector("#request-list-context-copy-request-headers").click();
  }, function validate(result) {
    // Sometimes, a "Cookie" header is left over from other tests. Remove it:
    result = String(result).replace(/Cookie: [^\n]+\n/, "");
    return result === EXPECTED_REQUEST_HEADERS;
  });
  info("Clipboard contains the currently selected item's request headers.");

  const EXPECTED_RESPONSE_HEADERS = [
    `${httpVersion} ${status} ${statusText}`,
    "last-modified: Sun, 3 May 2015 11:11:11 GMT",
    "content-type: text/html",
    "content-length: 465",
    "connection: close",
    "server: httpd.js",
    "date: Sun, 3 May 2015 11:11:11 GMT"
  ].join("\n");

  EventUtils.sendMouseEvent({ type: "contextmenu" },
    document.querySelectorAll(".request-list-item")[0]);

  yield waitForClipboardPromise(function setup() {
    monitor.panelWin.parent.document
      .querySelector("#response-list-context-copy-response-headers").click();
  }, function validate(result) {
    // Fake the "Last-Modified" and "Date" headers because they will vary:
    result = String(result)
      .replace(/last-modified: [^\n]+ GMT/, "last-modified: Sun, 3 May 2015 11:11:11 GMT")
      .replace(/date: [^\n]+ GMT/, "date: Sun, 3 May 2015 11:11:11 GMT");
    return result === EXPECTED_RESPONSE_HEADERS;
  });
  info("Clipboard contains the currently selected item's response headers.");

  yield teardown(monitor);
});
