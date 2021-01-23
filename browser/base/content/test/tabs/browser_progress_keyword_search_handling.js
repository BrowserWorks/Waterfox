/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const kButton = document.getElementById("reload-button");
const kDocChanPref = "browser.tabs.documentchannel";

add_task(async function setup() {
  await SpecialPowers.pushPrefEnv({
    set: [["browser.fixup.dns_first_for_single_words", true]],
  });
  registerCleanupFunction(() => {
    Services.prefs.clearUserPref(kDocChanPref);
  });
});

/*
 * When loading a keyword search as a result of an unknown host error,
 * check that we can stop the load.
 * See https://bugzilla.mozilla.org/show_bug.cgi?id=235825
 */
add_task(async function test_unknown_host() {
  for (let docChan of [true, false]) {
    Services.prefs.setBoolPref(kDocChanPref, docChan);
    await BrowserTestUtils.withNewTab("about:blank", async browser => {
      const kNonExistingHost = "idontreallyexistonthisnetwork";
      let searchPromise = BrowserTestUtils.waitForDocLoadAndStopIt(
        Services.uriFixup.keywordToURI(kNonExistingHost).preferredURI.spec,
        browser,
        () => {
          ok(kButton.hasAttribute("displaystop"), "Should be showing stop");
          return true;
        }
      );
      gURLBar.value = kNonExistingHost;
      gURLBar.select();
      EventUtils.synthesizeKey("KEY_Enter");
      await searchPromise;
      await BrowserTestUtils.waitForCondition(
        () => !kButton.hasAttribute("displaystop")
      );
      ok(
        !kButton.hasAttribute("displaystop"),
        "Should no longer be showing stop after search"
      );
    });
  }
});

/*
 * When NOT loading a keyword search as a result of an unknown host error,
 * check that the stop button goes back to being a reload button.
 * See https://bugzilla.mozilla.org/show_bug.cgi?id=1591183
 */
add_task(async function test_unknown_host_without_search() {
  for (let docChan of [true, false]) {
    Services.prefs.setBoolPref(kDocChanPref, docChan);
    await BrowserTestUtils.withNewTab("about:blank", async browser => {
      const kNonExistingHost = "idontreallyexistonthisnetwork.example.com";
      let searchPromise = BrowserTestUtils.browserLoaded(
        browser,
        false,
        "http://" + kNonExistingHost + "/",
        true /* want an error page */
      );
      gURLBar.value = kNonExistingHost;
      gURLBar.select();
      EventUtils.synthesizeKey("KEY_Enter");
      await searchPromise;
      await BrowserTestUtils.waitForCondition(
        () => !kButton.hasAttribute("displaystop")
      );
      ok(
        !kButton.hasAttribute("displaystop"),
        "Should not be showing stop on error page"
      );
    });
  }
});
