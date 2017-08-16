"use strict";

const FAVICON = "data:image/gif;base64,R0lGODlhCwALAIAAAAAA3pn/ZiH5BAEAAAEALAAAAAALAAsAAAIUhA+hkcuO4lmNVindo7qyrIXiGBYAOw==";
const PAGE_URL = `data:text/html,
<html>
  <head>
    <link rel="shortcut icon" href="${FAVICON}">
  </head>
  <body>
    Favicon!
  </body>
</html>`;

/**
 * Tests that if a background tab crashes that it doesn't
 * lose the favicon in the tab.
 */
add_task(async function test_tabicon_after_bg_tab_crash() {
  let originalTab = gBrowser.selectedTab;

  await BrowserTestUtils.withNewTab({
    gBrowser,
    url: PAGE_URL,
  }, async function(browser) {
    Assert.equal(browser.mIconURL, FAVICON, "Favicon is correctly set.");
    await BrowserTestUtils.switchTab(gBrowser, originalTab);
    await BrowserTestUtils.crashBrowser(browser,
                                        false /* shouldShowTabCrashPage */);
    Assert.equal(browser.mIconURL, FAVICON,
                 "Favicon is still set after crash.");
  });
});
