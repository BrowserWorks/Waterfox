/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function setup() {
  await BrowserTestUtils.openNewForegroundTab({
    gBrowser,
    url: "about:logins",
  });
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(gBrowser.selectedTab);
  });
});

add_task(async function test_open_feedback() {
  const menuArray = [
    {
      urlFinal: "https://example.com/firefox-lockwise",
      urlBase: "https://example.com/",
      pref: "app.support.baseURL",
      selector: ".menuitem-help",
    },
    {
      urlFinal: "https://example.com/android?utm_creative=Elipsis_Menu",
      urlBase: "https://example.com/android?utm_creative=",
      pref: "signon.management.page.mobileAndroidURL",
      selector: ".menuitem-mobile-android",
    },
    {
      urlFinal: "https://example.com/apple?utm_creative=Elipsis_Menu",
      urlBase: "https://example.com/apple?utm_creative=",
      pref: "signon.management.page.mobileAppleURL",
      selector: ".menuitem-mobile-ios",
    },
  ];

  for (const { urlFinal, urlBase, pref, selector } of menuArray) {
    info("Test on " + urlFinal);

    await SpecialPowers.pushPrefEnv({
      set: [[pref, urlBase]],
    });

    let promiseNewTab = BrowserTestUtils.waitForNewTab(gBrowser, urlFinal);

    let browser = gBrowser.selectedBrowser;
    await BrowserTestUtils.synthesizeMouseAtCenter("menu-button", {}, browser);
    await SpecialPowers.spawn(browser, [], async () => {
      return ContentTaskUtils.waitForCondition(() => {
        let menuButton = Cu.waiveXrays(
          content.document.querySelector("menu-button")
        );
        return !menuButton.shadowRoot.querySelector(".menu").hidden;
      }, "waiting for menu to open");
    });

    // Not using synthesizeMouseAtCenter here because the element we want clicked on
    // is in the shadow DOM. BrowserTestUtils.synthesizeMouseAtCenter/AsyncUtilsContent
    // thinks that the shadow DOM element is in another document and throws an exception
    // when trying to call element.ownerGlobal on the targeted shadow DOM node. This is
    // on file as bug 1557489. As a workaround, this manually calculates the position to click.
    let { x, y } = await SpecialPowers.spawn(
      browser,
      [selector],
      async menuItemSelector => {
        let menuButton = Cu.waiveXrays(
          content.document.querySelector("menu-button")
        );
        let prefsItem = menuButton.shadowRoot.querySelector(menuItemSelector);
        return prefsItem.getBoundingClientRect();
      }
    );
    await BrowserTestUtils.synthesizeMouseAtPoint(x + 5, y + 5, {}, browser);

    info("waiting for new tab to get opened");
    let newTab = await promiseNewTab;
    ok(true, "New tab opened to" + urlFinal);

    BrowserTestUtils.removeTab(newTab);
  }
});
