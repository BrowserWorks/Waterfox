/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

add_task(async function test_create_options() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, "about:robots");
  gBrowser.selectedTab = tab;

  // TODO: Multiple windows.

  // Using pre-loaded new tab pages interferes with onUpdated events.
  // It probably shouldn't.
  SpecialPowers.setBoolPref("browser.newtab.preload", false);
  registerCleanupFunction(() => {
    SpecialPowers.clearUserPref("browser.newtab.preload");
  });

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],

      "background": {"page": "bg/background.html"},
    },

    files: {
      "bg/blank.html": `<html><head><meta charset="utf-8"></head></html>`,

      "bg/background.html": `<html><head>
        <meta charset="utf-8">
        <script src="background.js"></script>
      </head></html>`,

      "bg/background.js": function() {
        let activeTab;
        let activeWindow;

        function runTests() {
          const DEFAULTS = {
            index: 2,
            windowId: activeWindow,
            active: true,
            pinned: false,
            url: "about:newtab",
            // 'selected' is marked as unsupported in schema, so we've removed it.
            // For more details, see bug 1337509
            selected: undefined,
          };

          let tests = [
            {
              create: {url: "http://example.com/"},
              result: {url: "http://example.com/"},
            },
            {
              create: {url: "blank.html"},
              result: {url: browser.runtime.getURL("bg/blank.html")},
            },
            {
              create: {},
              result: {url: "about:newtab"},
            },
            {
              create: {active: false},
              result: {active: false},
            },
            {
              create: {active: true},
              result: {active: true},
            },
            {
              create: {pinned: true},
              result: {pinned: true, index: 0},
            },
            {
              create: {pinned: true, active: true},
              result: {pinned: true, active: true, index: 0},
            },
            {
              create: {pinned: true, active: false},
              result: {pinned: true, active: false, index: 0},
            },
            {
              create: {index: 1},
              result: {index: 1},
            },
            {
              create: {index: 1, active: false},
              result: {index: 1, active: false},
            },
            {
              create: {windowId: activeWindow},
              result: {windowId: activeWindow},
            },
          ];

          async function nextTest() {
            if (!tests.length) {
              browser.test.notifyPass("tabs.create");
              return;
            }

            let test = tests.shift();
            let expected = Object.assign({}, DEFAULTS, test.result);

            browser.test.log(`Testing tabs.create(${JSON.stringify(test.create)}), expecting ${JSON.stringify(test.result)}`);

            let updatedPromise = new Promise(resolve => {
              let onUpdated = (changedTabId, changed) => {
                if (changed.url) {
                  browser.tabs.onUpdated.removeListener(onUpdated);
                  resolve({tabId: changedTabId, url: changed.url});
                }
              };
              browser.tabs.onUpdated.addListener(onUpdated);
            });

            let createdPromise = new Promise(resolve => {
              let onCreated = tab => {
                browser.test.assertTrue("id" in tab, `Expected tabs.onCreated callback to receive tab object`);
                resolve();
              };
              browser.tabs.onCreated.addListener(onCreated);
            });

            let [tab] = await Promise.all([
              browser.tabs.create(test.create),
              createdPromise,
            ]);
            let tabId = tab.id;

            for (let key of Object.keys(expected)) {
              if (key === "url") {
                // FIXME: This doesn't get updated until later in the load cycle.
                continue;
              }

              browser.test.assertEq(expected[key], tab[key], `Expected value for tab.${key}`);
            }

            let updated = await updatedPromise;
            browser.test.assertEq(tabId, updated.tabId, `Expected value for tab.id`);
            browser.test.assertEq(expected.url, updated.url, `Expected value for tab.url`);

            await browser.tabs.remove(tabId);
            await browser.tabs.update(activeTab, {active: true});

            nextTest();
          }

          nextTest();
        }

        browser.tabs.query({active: true, currentWindow: true}, tabs => {
          activeTab = tabs[0].id;
          activeWindow = tabs[0].windowId;

          runTests();
        });
      },
    },
  });

  await extension.startup();
  await extension.awaitFinish("tabs.create");
  await extension.unload();

  await BrowserTestUtils.removeTab(tab);
});

add_task(async function test_urlbar_focus() {
  const extension = ExtensionTestUtils.loadExtension({
    background() {
      browser.tabs.onUpdated.addListener(function onUpdated(_, info) {
        if (info.status === "complete") {
          browser.test.sendMessage("complete");
          browser.tabs.onUpdated.removeListener(onUpdated);
        }
      });
      browser.test.onMessage.addListener(async (cmd, ...args) => {
        const result = await browser.tabs[cmd](...args);
        browser.test.sendMessage("result", result);
      });
    },
  });

  await extension.startup();

  // Test content is focused after opening a regular url
  extension.sendMessage("create", {url: "https://example.com"});
  const [tab1] = await Promise.all([
    extension.awaitMessage("result"),
    extension.awaitMessage("complete"),
  ]);

  is(document.activeElement.tagName, "browser", "Content focused after opening a web page");

  extension.sendMessage("remove", tab1.id);
  await extension.awaitMessage("result");

  // Test urlbar is focused after opening an empty tab
  extension.sendMessage("create", {});
  const tab2 = await extension.awaitMessage("result");

  const active = document.activeElement;
  info(`Active element: ${active.tagName}, id: ${active.id}, class: ${active.className}`);

  const parent = active.parentNode;
  info(`Parent element: ${parent.tagName}, id: ${parent.id}, class: ${parent.className}`);

  info(`After opening an empty tab, gURLBar.focused: ${gURLBar.focused}`);

  is(active.tagName, "html:input", "Input element focused");
  ok(active.classList.contains("urlbar-input"), "Urlbar focused");

  extension.sendMessage("remove", tab2.id);
  await extension.awaitMessage("result");

  await extension.unload();
});
