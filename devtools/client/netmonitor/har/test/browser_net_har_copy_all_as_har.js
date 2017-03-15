/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Basic tests for exporting Network panel content into HAR format.
 */
add_task(function* () {
  let { tab, monitor } = yield initNetMonitor(SIMPLE_URL);

  info("Starting test... ");

  let { NetMonitorView } = monitor.panelWin;
  let { RequestsMenu } = NetMonitorView;

  RequestsMenu.lazyUpdate = false;

  let wait = waitForNetworkEvents(monitor, 1);
  tab.linkedBrowser.reload();
  yield wait;

  yield RequestsMenu.contextMenu.copyAllAsHar();

  let jsonString = SpecialPowers.getClipboardData("text/unicode");
  let har = JSON.parse(jsonString);

  // Check out HAR log
  isnot(har.log, null, "The HAR log must exist");
  is(har.log.creator.name, "Firefox", "The creator field must be set");
  is(har.log.browser.name, "Firefox", "The browser field must be set");
  is(har.log.pages.length, 1, "There must be one page");
  is(har.log.entries.length, 1, "There must be one request");

  let entry = har.log.entries[0];
  is(entry.request.method, "GET", "Check the method");
  is(entry.request.url, SIMPLE_URL, "Check the URL");
  is(entry.request.headers.length, 9, "Check number of request headers");
  is(entry.response.status, 200, "Check response status");
  is(entry.response.statusText, "OK", "Check response status text");
  is(entry.response.headers.length, 6, "Check number of response headers");
  is(entry.response.content.mimeType, // eslint-disable-line
    "text/html", "Check response content type"); // eslint-disable-line
  isnot(entry.response.content.text, undefined, // eslint-disable-line
    "Check response body");
  isnot(entry.timings, undefined, "Check timings");

  return teardown(monitor);
});
