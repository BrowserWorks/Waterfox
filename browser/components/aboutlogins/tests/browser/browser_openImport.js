/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function setup() {
  let aboutLoginsTab = await BrowserTestUtils.openNewForegroundTab({
    gBrowser,
    url: "about:logins",
  });
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(aboutLoginsTab);
  });
});

add_task(async function test_open_import() {
  let promiseImportWindow = BrowserTestUtils.domWindowOpenedAndLoaded();

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
  let { x, y } = await SpecialPowers.spawn(browser, [], async () => {
    let menuButton = Cu.waiveXrays(
      content.document.querySelector("menu-button")
    );
    let prefsItem = menuButton.shadowRoot.querySelector(".menuitem-import");
    return prefsItem.getBoundingClientRect();
  });
  await BrowserTestUtils.synthesizeMouseAtPoint(x + 5, y + 5, {}, browser);

  info("waiting for Import to get opened");
  let importWindow = await promiseImportWindow;
  ok(true, "Import opened");

  importWindow.close();
});
