/* eslint-env mozilla/frame-script */

const DUMMY1 = "http://example.com/browser/toolkit/modules/tests/browser/dummy_page.html";
const DUMMY2 = "http://example.org/browser/toolkit/modules/tests/browser/dummy_page.html"

function waitForLoad(browser = gBrowser.selectedBrowser) {
  return BrowserTestUtils.browserLoaded(browser);
}

function waitForPageShow(browser = gBrowser.selectedBrowser) {
  return BrowserTestUtils.waitForContentEvent(browser, "pageshow", true);
}

function makeURI(url) {
  return Cc["@mozilla.org/network/io-service;1"].
         getService(Ci.nsIIOService).
         newURI(url, null, null);
}

// Tests that loadURI accepts a referrer and it is included in the load.
add_task(function* test_referrer() {
  gBrowser.selectedTab = gBrowser.addTab();
  let browser = gBrowser.selectedBrowser;

  browser.webNavigation.loadURI(DUMMY1,
                                Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                makeURI(DUMMY2),
                                null, null);
  yield waitForLoad();

  yield ContentTask.spawn(browser, [ DUMMY1, DUMMY2 ], function([dummy1, dummy2]) {
    is(content.location, dummy1, "Should have loaded the right URL");
    is(content.document.referrer, dummy2, "Should have the right referrer");
  });

  gBrowser.removeCurrentTab();
});

// Tests that remote access to webnavigation.sessionHistory works.
add_task(function* test_history() {
  function checkHistoryIndex(browser, n) {
    return ContentTask.spawn(browser, n, function(n) {
      let history = docShell.QueryInterface(Ci.nsIInterfaceRequestor)
                            .getInterface(Ci.nsISHistory);
      is(history.index, n, "Should be at the right place in history");
    });
  }
  gBrowser.selectedTab = gBrowser.addTab();
  let browser = gBrowser.selectedBrowser;

  browser.webNavigation.loadURI(DUMMY1,
                                Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                null, null, null);
  yield waitForLoad();

  browser.webNavigation.loadURI(DUMMY2,
                                Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                null, null, null);
  yield waitForLoad();

  yield ContentTask.spawn(browser, [DUMMY1, DUMMY2], function([dummy1, dummy2]) {
    let history = docShell.QueryInterface(Ci.nsIInterfaceRequestor)
                          .getInterface(Ci.nsISHistory);
    is(history.count, 2, "Should be two history items");
    is(history.index, 1, "Should be at the right place in history");
    let entry = history.getEntryAtIndex(0, false);
    is(entry.URI.spec, dummy1, "Should have the right history entry");
    entry = history.getEntryAtIndex(1, false);
    is(entry.URI.spec, dummy2, "Should have the right history entry");
  });

  let promise = waitForPageShow();
  browser.webNavigation.goBack();
  yield promise;
  yield checkHistoryIndex(browser, 0);

  promise = waitForPageShow();
  browser.webNavigation.goForward();
  yield promise;
  yield checkHistoryIndex(browser, 1);

  promise = waitForPageShow();
  browser.webNavigation.gotoIndex(0);
  yield promise;
  yield checkHistoryIndex(browser, 0);

  gBrowser.removeCurrentTab();
});

// Tests that load flags are passed through to the content process.
add_task(function* test_flags() {
  function checkHistory(browser, { count, index }) {
    return ContentTask.spawn(browser, [ DUMMY2, count, index ],
      function([ dummy2, count, index ]) {
        let history = docShell.QueryInterface(Ci.nsIInterfaceRequestor)
                              .getInterface(Ci.nsISHistory);
        is(history.count, count, "Should be one history item");
        is(history.index, index, "Should be at the right place in history");
        let entry = history.getEntryAtIndex(index, false);
        is(entry.URI.spec, dummy2, "Should have the right history entry");
      });
  }

  gBrowser.selectedTab = gBrowser.addTab();
  let browser = gBrowser.selectedBrowser;

  browser.webNavigation.loadURI(DUMMY1,
                                Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                null, null, null);
  yield waitForLoad();

  browser.webNavigation.loadURI(DUMMY2,
                                Ci.nsIWebNavigation.LOAD_FLAGS_REPLACE_HISTORY,
                                null, null, null);
  yield waitForLoad();
  yield checkHistory(browser, { count: 1, index: 0 });

  browser.webNavigation.loadURI(DUMMY1,
                                Ci.nsIWebNavigation.LOAD_FLAGS_BYPASS_HISTORY,
                                null, null, null);
  yield waitForLoad();
  yield checkHistory(browser, { count: 1, index: 0 });

  gBrowser.removeCurrentTab();
});

// Tests that attempts to use unsupported arguments throw an exception.
add_task(function* test_badarguments() {
  if (!gMultiProcessBrowser)
    return;

  gBrowser.selectedTab = gBrowser.addTab();
  let browser = gBrowser.selectedBrowser;

  try {
    browser.webNavigation.loadURI(DUMMY1,
                                  Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                  null, {}, null);
    ok(false, "Should have seen an exception from trying to pass some postdata");
  }
  catch (e) {
    ok(true, "Should have seen an exception from trying to pass some postdata");
  }

  try {
    browser.webNavigation.loadURI(DUMMY1,
                                  Ci.nsIWebNavigation.LOAD_FLAGS_NONE,
                                  null, null, {});
    ok(false, "Should have seen an exception from trying to pass some headers");
  }
  catch (e) {
    ok(true, "Should have seen an exception from trying to pass some headers");
  }

  gBrowser.removeCurrentTab();
});
