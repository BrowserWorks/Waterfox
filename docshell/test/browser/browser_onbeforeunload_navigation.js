"use strict";

const TEST_PAGE =
  "http://mochi.test:8888/browser/docshell/test/browser/file_bug1046022.html";
const TARGETED_PAGE =
  "data:text/html," +
  encodeURIComponent("<body>Shouldn't be seeing this</body>");

var loadStarted = false;
var tabStateListener = {
  resolveLoad: null,
  expectLoad: null,

  onStateChange(webprogress, request, flags, status) {
    const WPL = Ci.nsIWebProgressListener;
    if (flags & WPL.STATE_IS_WINDOW) {
      if (flags & WPL.STATE_START) {
        loadStarted = true;
      } else if (flags & WPL.STATE_STOP) {
        let url = request.QueryInterface(Ci.nsIChannel).URI.spec;
        is(url, this.expectLoad, "Should only see expected document loads");
        if (url == this.expectLoad) {
          this.resolveLoad();
        }
      }
    }
  },
  QueryInterface: ChromeUtils.generateQI([
    Ci.nsIWebProgressListener,
    Ci.nsISupportsWeakReference,
  ]),
};

function promiseLoaded(url, callback) {
  if (tabStateListener.expectLoad) {
    throw new Error("Can't wait for multiple loads at once");
  }
  tabStateListener.expectLoad = url;
  return new Promise(resolve => {
    tabStateListener.resolveLoad = resolve;
    if (callback) {
      callback();
    }
  }).then(() => {
    tabStateListener.expectLoad = null;
    tabStateListener.resolveLoad = null;
  });
}

async function promiseStayOnPagePrompt(acceptNavigation) {
  loadStarted = false;
  let [dialog] = await TestUtils.topicObserved("tabmodal-dialog-loaded");

  ok(!loadStarted, "No load should be started");

  let button = dialog.querySelector(
    acceptNavigation ? ".tabmodalprompt-button0" : ".tabmodalprompt-button1"
  );
  button.click();

  // Make a trip through the event loop so that, if anything is going to
  // happen after we deny the navigation, it has a chance to happen
  // before we return to our caller.
  await new Promise(executeSoon);
}

add_task(async function test() {
  await SpecialPowers.pushPrefEnv({
    set: [["dom.require_user_interaction_for_beforeunload", false]],
  });

  let testTab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    TEST_PAGE,
    false,
    true
  );
  let browser = testTab.linkedBrowser;
  browser.addProgressListener(
    tabStateListener,
    Ci.nsIWebProgress.NOTIFY_STATE_WINDOW
  );

  const NUM_TESTS = 6;
  await SpecialPowers.spawn(browser, [NUM_TESTS], testCount => {
    let { testFns } = this.content.wrappedJSObject;
    Assert.equal(
      testFns.length,
      testCount,
      "Should have the correct number of test functions"
    );
  });

  for (let allowNavigation of [false, true]) {
    for (let i = 0; i < NUM_TESTS; i++) {
      info(
        `Running test ${i} with navigation ${
          allowNavigation ? "allowed" : "forbidden"
        }`
      );

      if (allowNavigation) {
        // If we're allowing navigations, we need to re-load the test
        // page after each test, since the tests will each navigate away
        // from it.
        await promiseLoaded(TEST_PAGE, () => {
          browser.loadURI(TEST_PAGE, {
            triggeringPrincipal: document.nodePrincipal,
          });
        });
      }

      let promptPromise = promiseStayOnPagePrompt(allowNavigation);
      let loadPromise;
      if (allowNavigation) {
        loadPromise = promiseLoaded(TARGETED_PAGE);
      }

      let winID = await SpecialPowers.spawn(
        browser,
        [i, TARGETED_PAGE],
        (testIdx, url) => {
          let { testFns } = this.content.wrappedJSObject;
          this.content.onbeforeunload = testFns[testIdx];
          this.content.location = url;
          return this.content.windowUtils.currentInnerWindowID;
        }
      );

      await promptPromise;
      await loadPromise;

      if (allowNavigation) {
        await SpecialPowers.spawn(
          browser,
          [TARGETED_PAGE, winID],
          (url, winID) => {
            this.content.onbeforeunload = null;
            Assert.equal(
              this.content.location.href,
              url,
              "Page should have navigated to the correct URL"
            );
            Assert.notEqual(
              this.content.windowUtils.currentInnerWindowID,
              winID,
              "Page should have a new inner window"
            );
          }
        );
      } else {
        await SpecialPowers.spawn(browser, [TEST_PAGE, winID], (url, winID) => {
          this.content.onbeforeunload = null;
          Assert.equal(
            this.content.location.href,
            url,
            "Page should have the same URL"
          );
          Assert.equal(
            this.content.windowUtils.currentInnerWindowID,
            winID,
            "Page should have the same inner window"
          );
        });
      }
    }
  }

  gBrowser.removeTab(testTab);
});
