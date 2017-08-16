/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

add_task(async function testDuplicateTab() {
  await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://example.net/");

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
    },

    background: function() {
      browser.tabs.query({
        lastFocusedWindow: true,
      }, function(tabs) {
        let source = tabs[1];
        // By moving it 0, we check that the new tab is created next
        // to the existing one.
        browser.tabs.move(source.id, {index: 0}, () => {
          browser.tabs.duplicate(source.id, (tab) => {
            browser.test.assertEq("http://example.net/", tab.url);
            // Should be the second tab, next to the one duplicated.
            browser.test.assertEq(1, tab.index);
            // Should be active by default.
            browser.test.assertTrue(tab.active);
            browser.test.notifyPass("tabs.duplicate");
          });
        });
      });
    },
  });

  await extension.startup();
  await extension.awaitFinish("tabs.duplicate");
  await extension.unload();

  while (gBrowser.tabs[0].linkedBrowser.currentURI.spec === "http://example.net/") {
    await BrowserTestUtils.removeTab(gBrowser.tabs[0]);
  }
});

add_task(async function testDuplicateTabLazily() {
  async function background() {
    let tabLoadComplete = new Promise(resolve => {
      browser.test.onMessage.addListener((message, tabId, result) => {
        if (message == "duplicate-tab-done") {
          resolve(tabId);
        }
      });
    });

    function awaitLoad(tabId) {
      return new Promise(resolve => {
        browser.tabs.onUpdated.addListener(function listener(tabId_, changed, tab) {
          if (tabId == tabId_ && changed.status == "complete") {
            browser.tabs.onUpdated.removeListener(listener);
            resolve();
          }
        });
      });
    }

    try {
      let url = "http://example.com/browser/browser/components/extensions/test/browser/file_dummy.html";
      let tab = await browser.tabs.create({url});
      let startTabId = tab.id;

      await awaitLoad(startTabId);
      browser.test.sendMessage("duplicate-tab", startTabId);

      let unloadedTabId = await tabLoadComplete;
      let loadedtab = await browser.tabs.get(startTabId);
      browser.test.assertEq("Dummy test page", loadedtab.title, "Title should be returned for loaded pages");
      browser.test.assertEq("complete", loadedtab.status, "Tab status should be complete for loaded pages");

      let unloadedtab = await browser.tabs.get(unloadedTabId);
      browser.test.assertEq("Dummy test page", unloadedtab.title, "Title should be returned after page has been unloaded");

      await browser.tabs.remove([tab.id, unloadedTabId]);
      browser.test.notifyPass("tabs.hasCorrectTabTitle");
    } catch (e) {
      browser.test.fail(`${e} :: ${e.stack}`);
      browser.test.notifyFail("tabs.hasCorrectTabTitle");
    }
  }

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
    },

    background,
  });

  extension.onMessage("duplicate-tab", tabId => {
    let {Management: {global: {tabTracker}}} = Cu.import("resource://gre/modules/Extension.jsm", {});

    let tab = tabTracker.getTab(tabId);
    // This is a bit of a hack to load a tab in the background.
    let newTab = gBrowser.duplicateTab(tab, true);

    BrowserTestUtils.waitForEvent(newTab, "SSTabRestored", () => true).then(() => {
      extension.sendMessage("duplicate-tab-done", tabTracker.getId(newTab));
    });
  });

  await extension.startup();
  await extension.awaitFinish("tabs.hasCorrectTabTitle");
  await extension.unload();
});

add_task(async function testDuplicatePinnedTab() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://example.net/");
  gBrowser.pinTab(tab);

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
    },

    background: function() {
      browser.tabs.query({
        lastFocusedWindow: true,
      }, function(tabs) {
        // Duplicate the pinned tab, example.net.
        browser.tabs.duplicate(tabs[0].id, (tab) => {
          browser.test.assertEq("http://example.net/", tab.url);
          // Should be the second tab, next to the one duplicated.
          browser.test.assertEq(1, tab.index);
          // Should be pinned.
          browser.test.assertTrue(tab.pinned);
          browser.test.notifyPass("tabs.duplicate.pinned");
        });
      });
    },
  });

  await extension.startup();
  await extension.awaitFinish("tabs.duplicate.pinned");
  await extension.unload();

  while (gBrowser.tabs[0].linkedBrowser.currentURI.spec === "http://example.net/") {
    await BrowserTestUtils.removeTab(gBrowser.tabs[0]);
  }
});
