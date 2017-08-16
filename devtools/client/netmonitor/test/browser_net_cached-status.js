/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Tests if cached requests have the correct status code
 */

add_task(function* () {
  let { tab, monitor } = yield initNetMonitor(STATUS_CODES_URL, true);
  info("Starting test... ");

  let { document, store, windowRequire } = monitor.panelWin;
  let Actions = windowRequire("devtools/client/netmonitor/src/actions/index");
  let {
    getDisplayedRequests,
    getSortedRequests,
  } = windowRequire("devtools/client/netmonitor/src/selectors/index");

  store.dispatch(Actions.batchEnable(false));

  const REQUEST_DATA = [
    {
      method: "GET",
      uri: STATUS_CODES_SJS + "?sts=ok&cached",
      details: {
        status: 200,
        statusText: "OK",
        type: "plain",
        fullMimeType: "text/plain; charset=utf-8"
      }
    },
    {
      method: "GET",
      uri: STATUS_CODES_SJS + "?sts=redirect&cached",
      details: {
        status: 301,
        statusText: "Moved Permanently",
        type: "html",
        fullMimeType: "text/html; charset=utf-8"
      }
    },
    {
      method: "GET",
      uri: "http://example.com/redirected",
      details: {
        status: 404,
        statusText: "Not Found",
        type: "html",
        fullMimeType: "text/html; charset=utf-8"
      }
    },
    {
      method: "GET",
      uri: STATUS_CODES_SJS + "?sts=ok&cached",
      details: {
        status: 200,
        statusText: "OK (cached)",
        displayedStatus: "cached",
        type: "plain",
        fullMimeType: "text/plain; charset=utf-8"
      }
    },
    {
      method: "GET",
      uri: STATUS_CODES_SJS + "?sts=redirect&cached",
      details: {
        status: 301,
        statusText: "Moved Permanently (cached)",
        displayedStatus: "cached",
        type: "html",
        fullMimeType: "text/html; charset=utf-8"
      }
    },
    {
      method: "GET",
      uri: "http://example.com/redirected",
      details: {
        status: 404,
        statusText: "Not Found",
        type: "html",
        fullMimeType: "text/html; charset=utf-8"
      }
    }
  ];

  info("Performing requests #1...");
  yield performRequestsAndWait();

  info("Performing requests #2...");
  yield performRequestsAndWait();

  let index = 0;
  for (let request of REQUEST_DATA) {
    info("Verifying request #" + index);
    yield verifyRequestItemTarget(
      document,
      getDisplayedRequests(store.getState()),
      getSortedRequests(store.getState()).get(index),
      request.method,
      request.uri,
      request.details
    );

    index++;
  }

  yield teardown(monitor);

  function* performRequestsAndWait() {
    let wait = waitForNetworkEvents(monitor, 3);
    yield ContentTask.spawn(tab.linkedBrowser, {}, function* () {
      content.wrappedJSObject.performCachedRequests();
    });
    yield wait;
  }
});
