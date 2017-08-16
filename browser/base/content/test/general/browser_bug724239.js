/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function test() {
  await BrowserTestUtils.withNewTab({ gBrowser, url: "about:blank" },
                                    async function(browser) {
    BrowserTestUtils.loadURI(browser, "http://example.com");
    await BrowserTestUtils.browserLoaded(browser);
    ok(!gBrowser.canGoBack, "about:newtab wasn't added to the session history");
  });
});
