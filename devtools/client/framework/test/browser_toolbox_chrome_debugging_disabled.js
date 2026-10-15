/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that a toolbox can't debug a system principal page when
// devtools.chrome.enabled is locked to false.

const CHROME_ENABLED_PREF = "devtools.chrome.enabled";

function lockChromeEnabledPrefToFalse() {
  if (Services.prefs.prefIsLocked(CHROME_ENABLED_PREF)) {
    return;
  }
  // lockPref locks the default value, so set the default rather than the user
  // value.
  const defaultBranch = Services.prefs.getDefaultBranch("");
  const defaultValue = defaultBranch.getBoolPref(CHROME_ENABLED_PREF);
  defaultBranch.setBoolPref(CHROME_ENABLED_PREF, false);
  Services.prefs.lockPref(CHROME_ENABLED_PREF);
  registerCleanupFunction(() => {
    Services.prefs.unlockPref(CHROME_ENABLED_PREF);
    defaultBranch.setBoolPref(CHROME_ENABLED_PREF, defaultValue);
  });
}

add_task(async function test_unlocked_pref_allows_toolbox() {
  await pushPref(CHROME_ENABLED_PREF, false);

  const tab = await addTab("about:preferences");
  const toolbox = await openToolboxForTab(tab, "webconsole");
  ok(toolbox, "A toolbox opens when the pref is false but not locked");

  await toolbox.destroy();
  gBrowser.removeCurrentTab();
});

add_task(async function test_locked_pref_prevents_toolbox() {
  lockChromeEnabledPrefToFalse();

  const tab = await addTab("about:preferences");
  const toolbox = await gDevTools.showToolboxForTab(tab);
  is(toolbox, null, "No toolbox is opened");
  ok(!gDevTools.getToolboxForTab(tab), "No toolbox is registered for the tab");

  gBrowser.removeCurrentTab();
});

add_task(async function test_locked_pref_closes_toolbox_on_navigation() {
  lockChromeEnabledPrefToFalse();

  // about:robots loads in the parent process without a system principal.
  for (const url of ["data:text/html,<title>content</title>", "about:robots"]) {
    const tab = await addTab(url);
    const toolbox = await openToolboxForTab(tab, "webconsole");

    const onToolboxDestroyed = toolbox.once("destroyed");
    BrowserTestUtils.startLoadingURIString(
      tab.linkedBrowser,
      "about:preferences"
    );
    await onToolboxDestroyed;
    ok(true, `The toolbox is closed when navigating from ${url}`);

    gBrowser.removeCurrentTab();
  }
});
