/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Ensure that a pending tab has label and icon correctly set.
 */
add_task(async function test_label_and_icon() {
  // Make sure that tabs are restored on demand as otherwise the tab will start
  // loading immediately and we can't check its icon and label.
  await SpecialPowers.pushPrefEnv({
    set: [["browser.sessionstore.restore_on_demand", true]],
  });

  // Create a new tab.
  let tab = BrowserTestUtils.addTab(gBrowser, "about:robots");
  let browser = tab.linkedBrowser;
  await promiseBrowserLoaded(browser);

  // Retrieve the tab state.
  await TabStateFlusher.flush(browser);
  let state = ss.getTabState(tab);
  await promiseRemoveTab(tab);
  browser = null;

  // Open a new tab to restore into.
  tab = BrowserTestUtils.addTab(gBrowser, "about:blank");
  ss.setTabState(tab, state);
  await promiseTabRestoring(tab);

  // Check that label and icon are set for the restoring tab.
  is(gBrowser.getIcon(tab), "chrome://browser/content/robot.ico", "icon is set");
  is(tab.label, "Gort! Klaatu barada nikto!", "label is set");

  let serhelper = Cc["@mozilla.org/network/serialization-helper;1"]
                    .getService(Ci.nsISerializationHelper);
  let serializedPrincipal = tab.getAttribute("iconLoadingPrincipal");
  let iconLoadingPrincipal = serhelper.deserializeObject(serializedPrincipal)
                                      .QueryInterface(Ci.nsIPrincipal);
  is(iconLoadingPrincipal.origin, "about:robots", "correct loadingPrincipal used");

  // Cleanup.
  await promiseRemoveTab(tab);
});
