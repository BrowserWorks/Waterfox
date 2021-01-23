const gCompleteState =
  Ci.nsIWebProgressListener.STATE_STOP +
  Ci.nsIWebProgressListener.STATE_IS_NETWORK;

function getOriginalURL(request) {
  return request && request.QueryInterface(Ci.nsIChannel).originalURI.spec;
}

var gFrontProgressListener = {
  onProgressChange(
    aWebProgress,
    aRequest,
    aCurSelfProgress,
    aMaxSelfProgress,
    aCurTotalProgress,
    aMaxTotalProgress
  ) {},

  onStateChange(aWebProgress, aRequest, aStateFlags, aStatus) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      return;
    }
    var state = "onStateChange";
    info(
      "FrontProgress (" + url + "): " + state + " 0x" + aStateFlags.toString(16)
    );
    Assert.less(
      gFrontNotificationsPos,
      gFrontNotifications.length,
      "Got an expected notification for the front notifications listener"
    );
    is(
      state,
      gFrontNotifications[gFrontNotificationsPos],
      "Got a notification for the front notifications listener"
    );
    gFrontNotificationsPos++;
  },

  onLocationChange(aWebProgress, aRequest, aLocationURI, aFlags) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      return;
    }
    var state = "onLocationChange";
    info("FrontProgress: " + state + " " + aLocationURI.spec);
    Assert.less(
      gFrontNotificationsPos,
      gFrontNotifications.length,
      "Got an expected notification for the front notifications listener"
    );
    is(
      state,
      gFrontNotifications[gFrontNotificationsPos],
      "Got a notification for the front notifications listener"
    );
    gFrontNotificationsPos++;
  },

  onSecurityChange(aWebProgress, aRequest, aState) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      return;
    }
    var state = "onSecurityChange";
    info("FrontProgress (" + url + "): " + state + " 0x" + aState.toString(16));
    Assert.less(
      gFrontNotificationsPos,
      gFrontNotifications.length,
      "Got an expected notification for the front notifications listener"
    );
    is(
      state,
      gFrontNotifications[gFrontNotificationsPos],
      "Got a notification for the front notifications listener"
    );
    gFrontNotificationsPos++;
  },
};

var gAllProgressListener = {
  onStateChange(aBrowser, aWebProgress, aRequest, aStateFlags, aStatus) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      // ignore initial about blank
      return;
    }
    var state = "onStateChange";
    info(
      "AllProgress (" + url + "): " + state + " 0x" + aStateFlags.toString(16)
    );
    ok(
      aBrowser == gTestBrowser,
      state + " notification came from the correct browser"
    );
    Assert.less(
      gAllNotificationsPos,
      gAllNotifications.length,
      "Got an expected notification for the all notifications listener"
    );
    is(
      state,
      gAllNotifications[gAllNotificationsPos],
      "Got a notification for the all notifications listener"
    );
    gAllNotificationsPos++;

    if ((aStateFlags & gCompleteState) == gCompleteState) {
      is(
        gAllNotificationsPos,
        gAllNotifications.length,
        "Saw the expected number of notifications"
      );
      is(
        gFrontNotificationsPos,
        gFrontNotifications.length,
        "Saw the expected number of frontnotifications"
      );
      executeSoon(gNextTest);
    }
  },

  onLocationChange(aBrowser, aWebProgress, aRequest, aLocationURI, aFlags) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      // ignore initial about blank
      return;
    }
    var state = "onLocationChange";
    info("AllProgress: " + state + " " + aLocationURI.spec);
    ok(
      aBrowser == gTestBrowser,
      state + " notification came from the correct browser"
    );
    Assert.less(
      gAllNotificationsPos,
      gAllNotifications.length,
      "Got an expected notification for the all notifications listener"
    );
    is(
      state,
      gAllNotifications[gAllNotificationsPos],
      "Got a notification for the all notifications listener"
    );
    gAllNotificationsPos++;
  },

  onSecurityChange(aBrowser, aWebProgress, aRequest, aState) {
    var url = getOriginalURL(aRequest);
    if (url == "about:blank") {
      // ignore initial about blank
      return;
    }
    var state = "onSecurityChange";
    info("AllProgress (" + url + "): " + state + " 0x" + aState.toString(16));
    ok(
      aBrowser == gTestBrowser,
      state + " notification came from the correct browser"
    );
    Assert.less(
      gAllNotificationsPos,
      gAllNotifications.length,
      "Got an expected notification for the all notifications listener"
    );
    is(
      state,
      gAllNotifications[gAllNotificationsPos],
      "Got a notification for the all notifications listener"
    );
    gAllNotificationsPos++;
  },
};

var gFrontNotifications,
  gAllNotifications,
  gFrontNotificationsPos,
  gAllNotificationsPos;
var gBackgroundTab,
  gForegroundTab,
  gBackgroundBrowser,
  gForegroundBrowser,
  gTestBrowser;
var gTestPage =
  "/browser/browser/base/content/test/general/alltabslistener.html";
const kBasePage =
  "http://mochi.test:8888/browser/browser/base/content/test/general/dummy_page.html";
var gNextTest;

function setExpectationForCrossDomainFrontBrowserLoad() {
  // In fission, we swap remoteness for this load, and we'll get sent a
  // notification to ensure the security state shown by the browser remains
  // correct after the remoteness change - we need to account for that:
  if (gFissionBrowser) {
    gFrontNotifications = [
      "onStateChange",
      "onSecurityChange",
      "onLocationChange",
      "onSecurityChange",
      "onStateChange",
    ];
  } else {
    gFrontNotifications = gAllNotifications;
  }
}

async function test() {
  waitForExplicitFinish();

  gBackgroundTab = BrowserTestUtils.addTab(gBrowser);
  gForegroundTab = BrowserTestUtils.addTab(gBrowser);
  gBackgroundBrowser = gBrowser.getBrowserForTab(gBackgroundTab);
  gForegroundBrowser = gBrowser.getBrowserForTab(gForegroundTab);
  gBrowser.selectedTab = gForegroundTab;

  gAllNotifications = [
    "onStateChange",
    "onLocationChange",
    "onSecurityChange",
    "onStateChange",
  ];

  // We must wait until a page has completed loading before
  // starting tests or we get notifications from that
  let promises = [
    BrowserTestUtils.browserStopped(gBackgroundBrowser, kBasePage),
    BrowserTestUtils.browserStopped(gForegroundBrowser, kBasePage),
  ];
  BrowserTestUtils.loadURI(gBackgroundBrowser, kBasePage);
  BrowserTestUtils.loadURI(gForegroundBrowser, kBasePage);
  await Promise.all(promises);
  // If we process switched, the tabbrowser may still be processing the state_stop
  // notification here because of how microtasks work. Ensure that that has
  // happened before starting to test (which would add listeners to the tabbrowser
  // which would get confused by being called about kBasePage loading).
  await new Promise(executeSoon);
  startTest1();
}

function runTest(browser, url, next) {
  gFrontNotificationsPos = 0;
  gAllNotificationsPos = 0;
  gNextTest = next;
  gTestBrowser = browser;
  BrowserTestUtils.loadURI(browser, url);
}

function startTest1() {
  info("\nTest 1");
  gBrowser.addProgressListener(gFrontProgressListener);
  gBrowser.addTabsProgressListener(gAllProgressListener);

  setExpectationForCrossDomainFrontBrowserLoad();
  runTest(gForegroundBrowser, "http://example.org" + gTestPage, startTest2);
}

function startTest2() {
  info("\nTest 2");
  setExpectationForCrossDomainFrontBrowserLoad();
  runTest(gForegroundBrowser, "https://example.com" + gTestPage, startTest3);
}

function startTest3() {
  info("\nTest 3");
  gFrontNotifications = [];
  runTest(gBackgroundBrowser, "http://example.org" + gTestPage, startTest4);
}

function startTest4() {
  info("\nTest 4");
  gFrontNotifications = [];
  runTest(gBackgroundBrowser, "https://example.com" + gTestPage, startTest5);
}

function startTest5() {
  info("\nTest 5");
  // Switch the foreground browser
  [gForegroundBrowser, gBackgroundBrowser] = [
    gBackgroundBrowser,
    gForegroundBrowser,
  ];
  [gForegroundTab, gBackgroundTab] = [gBackgroundTab, gForegroundTab];
  // Avoid the onLocationChange this will fire
  gBrowser.removeProgressListener(gFrontProgressListener);
  gBrowser.selectedTab = gForegroundTab;
  gBrowser.addProgressListener(gFrontProgressListener);

  setExpectationForCrossDomainFrontBrowserLoad();
  runTest(gForegroundBrowser, "http://example.org" + gTestPage, startTest6);
}

function startTest6() {
  info("\nTest 6");
  gFrontNotifications = [];
  runTest(gBackgroundBrowser, "http://example.org" + gTestPage, finishTest);
}

function finishTest() {
  gBrowser.removeProgressListener(gFrontProgressListener);
  gBrowser.removeTabsProgressListener(gAllProgressListener);
  gBrowser.removeTab(gBackgroundTab);
  gBrowser.removeTab(gForegroundTab);
  finish();
}
