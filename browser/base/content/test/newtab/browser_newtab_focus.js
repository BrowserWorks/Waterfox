/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * These tests make sure that focusing the 'New Tab Page' works as expected.
 */
add_task(async function() {
  await pushPrefs(["accessibility.tabfocus", 7]);

  // When the onboarding component is enabled, it would inject extra tour notification into
  // the newtab page so there would be 3 more overlay button, notification close button and action button
  let onbardingEnabled = Services.prefs.getBoolPref("browser.onboarding.enabled");

  // Focus count in new tab page.
  // 30 = 9 * 3 + 3 = 9 sites, each with link, pin and remove buttons; search
  // bar; search button; and toggle button. Additionaly there may or may not be
  // a scroll bar caused by fix to 1180387, which will eat an extra focus
  let FOCUS_COUNT = 30;

  // Create a new tab page.
  await setLinks("0,1,2,3,4,5,6,7,8");
  setPinnedLinks("");

  if (onbardingEnabled) {
    await promiseNoMuteNotificationOnFirstSession();
  }
  let tab = await addNewTabPageTab();
  if (onbardingEnabled) {
    FOCUS_COUNT += 3;
    await promiseTourNotificationOpened(tab.linkedBrowser);
  }
  gURLBar.focus();
  // Count the focus with the enabled page.
  countFocus(FOCUS_COUNT);
  // Disable page and count the focus with the disabled page.
  NewTabUtils.allPages.enabled = false;

  let expectedCount = 4;
  if (onbardingEnabled) {
    expectedCount += 3;
  }
  countFocus(expectedCount);

  NewTabUtils.allPages.enabled = true;
});

/**
 * Focus the urlbar and count how many focus stops to return again to the urlbar.
 */
function countFocus(aExpectedCount) {
  let focusCount = 0;
  do {
    EventUtils.synthesizeKey("VK_TAB", {});
    if (document.activeElement == gBrowser.selectedBrowser) {
      focusCount++;
    }
  } while (document.activeElement != gURLBar.inputField);
  ok(focusCount == aExpectedCount || focusCount == (aExpectedCount + 1),
     "Validate focus count in the new tab page.");
}

function promiseNoMuteNotificationOnFirstSession() {
  return SpecialPowers.pushPrefEnv({set: [["browser.onboarding.notification.mute-duration-on-first-session-ms", 0]]});
}

/**
 * Wait for the onboarding tour notification opens
 */
function promiseTourNotificationOpened(browser) {
  function isOpened() {
    let doc = content && content.document;
    let notification = doc.querySelector("#onboarding-notification-bar");
    if (notification && notification.classList.contains("onboarding-opened")) {
      ok(true, "Should open tour notification");
      return Promise.resolve();
    }
    return new Promise(resolve => {
      let observer = new content.MutationObserver(mutations => {
        mutations.forEach(mutation => {
          let bar = Array.from(mutation.addedNodes)
                         .find(node => node.id == "onboarding-notification-bar");
          if (bar && bar.classList.contains("onboarding-opened")) {
            observer.disconnect();
            ok(true, "Should open tour notification");
            resolve();
          }
        });
      });
      observer.observe(doc.body, { childList: true });
    });
  }
  return ContentTask.spawn(browser, {}, isOpened);
}
