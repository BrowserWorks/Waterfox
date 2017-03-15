/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

function* testTabsUpdateURL(existentTabURL, tabsUpdateURL, isErrorExpected) {
  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
    },

    files: {
      "tab.html": `
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
          </head>
          <body>
            <h1>tab page</h1>
          </body>
        </html>
      `.trim(),
    },
    background: function() {
      browser.test.sendMessage("ready", browser.runtime.getURL("tab.html"));

      browser.test.onMessage.addListener(async (msg, tabsUpdateURL, isErrorExpected) => {
        let tabs = await browser.tabs.query({lastFocusedWindow: true});

        try {
          let tab = await browser.tabs.update(tabs[1].id, {url: tabsUpdateURL});

          browser.test.assertFalse(isErrorExpected, `tabs.update with URL ${tabsUpdateURL} should be rejected`);
          browser.test.assertTrue(tab, "on success the tab should be defined");
        } catch (error) {
          browser.test.assertTrue(isErrorExpected, `tabs.update with URL ${tabsUpdateURL} should not be rejected`);
          browser.test.assertTrue(/^Illegal URL/.test(error.message),
                                  "tabs.update should be rejected with the expected error message");
        }

        browser.test.sendMessage("done");
      });
    },
  });

  yield extension.startup();

  let mozExtTabURL = yield extension.awaitMessage("ready");

  if (tabsUpdateURL == "self") {
    tabsUpdateURL = mozExtTabURL;
  }

  info(`tab.update URL "${tabsUpdateURL}" on tab with URL "${existentTabURL}"`);

  let tab1 = yield BrowserTestUtils.openNewForegroundTab(gBrowser, existentTabURL);

  extension.sendMessage("start", tabsUpdateURL, isErrorExpected);
  yield extension.awaitMessage("done");

  yield BrowserTestUtils.removeTab(tab1);
  yield extension.unload();
}

add_task(function* () {
  info("Start testing tabs.update on javascript URLs");

  let dataURLPage = `data:text/html,
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
      </head>
      <body>
        <h1>data url page</h1>
      </body>
    </html>`;

  let checkList = [
    {
      tabsUpdateURL: "http://example.net",
      isErrorExpected: false,
    },
    {
      tabsUpdateURL: "self",
      isErrorExpected: false,
    },
    {
      tabsUpdateURL: "about:addons",
      isErrorExpected: true,
    },
    {
      tabsUpdateURL: "javascript:console.log('tabs.update execute javascript')",
      isErrorExpected: true,
    },
    {
      tabsUpdateURL: dataURLPage,
      isErrorExpected: true,
    },
  ];

  let testCases = checkList
        .map((check) => Object.assign({}, check, {existentTabURL: "about:blank"}));

  for (let {existentTabURL, tabsUpdateURL, isErrorExpected} of testCases) {
    yield* testTabsUpdateURL(existentTabURL, tabsUpdateURL, isErrorExpected);
  }

  info("done");
});
