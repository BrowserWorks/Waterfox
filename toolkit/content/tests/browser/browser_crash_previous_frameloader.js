"use strict";

/**
 * Cleans up the .dmp and .extra file from a crash.
 *
 * @param subject (nsISupports)
 *        The subject passed through the ipc:content-shutdown
 *        observer notification when a content process crash has
 *        occurred.
 */
function cleanUpMinidump(subject) {
  Assert.ok(subject instanceof Ci.nsIPropertyBag2,
            "Subject needs to be a nsIPropertyBag2 to clean up properly");
  let dumpID = subject.getPropertyAsAString("dumpID");

  Assert.ok(dumpID, "There should be a dumpID");
  if (dumpID) {
    let dir = Services.dirsvc.get("ProfD", Ci.nsIFile);
    dir.append("minidumps");

    let file = dir.clone();
    file.append(dumpID + ".dmp");
    file.remove(true);

    file = dir.clone();
    file.append(dumpID + ".extra");
    file.remove(true);
  }
}

/**
 * This test ensures that if a remote frameloader crashes after
 * the frameloader owner swaps it out for a new frameloader,
 * that a oop-browser-crashed event is not sent to the new
 * frameloader's browser element.
 */
add_task(function* test_crash_in_previous_frameloader() {
  // On debug builds, crashing tabs results in much thinking, which
  // slows down the test and results in intermittent test timeouts,
  // so we'll pump up the expected timeout for this test.
  requestLongerTimeout(2);

  if (!gMultiProcessBrowser) {
    Assert.ok(false, "This test should only be run in multi-process mode.");
    return;
  }

  yield BrowserTestUtils.withNewTab({
    gBrowser,
    url: "http://example.com",
  }, function*(browser) {
    // First, sanity check...
    Assert.ok(browser.isRemoteBrowser,
              "This browser needs to be remote if this test is going to " +
              "work properly.");

    // We will wait for the oop-browser-crashed event to have
    // a chance to appear. That event is fired when TabParents
    // are destroyed, and that occurs _before_ ContentParents
    // are destroyed, so we'll wait on the ipc:content-shutdown
    // observer notification, which is fired when a ContentParent
    // goes away. After we see this notification, oop-browser-crashed
    // events should have fired.
    let contentProcessGone = TestUtils.topicObserved("ipc:content-shutdown");
    let sawTabCrashed = false;
    let onTabCrashed = () => {
      sawTabCrashed = true;
    };

    browser.addEventListener("oop-browser-crashed", onTabCrashed);

    // The name of the game is to cause a crash in a remote browser,
    // and then immediately swap out the browser for a non-remote one.
    yield ContentTask.spawn(browser, null, function() {
      const Cu = Components.utils;
      Cu.import("resource://gre/modules/ctypes.jsm");
      Cu.import("resource://gre/modules/Timer.jsm");

      let dies = function() {
        privateNoteIntentionalCrash();
        let zero = new ctypes.intptr_t(8);
        let badptr = ctypes.cast(zero, ctypes.PointerType(ctypes.int32_t));
        badptr.contents
      };

      // When the parent flips the remoteness of the browser, the
      // page should receive the pagehide event, which we'll then
      // use to crash the frameloader.
      addEventListener("pagehide", function() {
        dump("\nEt tu, Brute?\n");
        dies();
      });
    });

    gBrowser.updateBrowserRemoteness(browser, false);
    info("Waiting for content process to go away.");
    let [subject, data] = yield contentProcessGone;

    // If we don't clean up the minidump, the harness will
    // complain.
    cleanUpMinidump(subject);

    info("Content process is gone!");
    Assert.ok(!sawTabCrashed,
              "Should not have seen the oop-browser-crashed event.");
    browser.removeEventListener("oop-browser-crashed", onTabCrashed);
  });
});
