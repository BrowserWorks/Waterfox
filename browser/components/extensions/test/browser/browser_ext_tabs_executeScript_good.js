/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

requestLongerTimeout(2);

async function testHasPermission(params) {
  let contentSetup = params.contentSetup || (() => Promise.resolve());

  async function background(contentSetup) {
    browser.runtime.onMessage.addListener((msg, sender) => {
      browser.test.assertEq(msg, "script ran", "script ran");
      browser.test.notifyPass("executeScript");
    });

    browser.test.onMessage.addListener(msg => {
      browser.test.assertEq(msg, "execute-script");

      browser.tabs.executeScript({
        file: "script.js",
      });
    });

    await contentSetup();

    browser.test.sendMessage("ready");
  }

  let extension = ExtensionTestUtils.loadExtension({
    manifest: params.manifest,

    background: `(${background})(${contentSetup})`,

    files: {
      "script.js": function() {
        browser.runtime.sendMessage("script ran");
      },
    },
  });

  await extension.startup();
  await extension.awaitMessage("ready");

  if (params.setup) {
    await params.setup(extension);
  }

  extension.sendMessage("execute-script");

  await extension.awaitFinish("executeScript");

  if (params.tearDown) {
    await params.tearDown(extension);
  }

  await extension.unload();
}

add_task(async function testGoodPermissions() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://mochi.test:8888/", true);

  info("Test explicit host permission");
  await testHasPermission({
    manifest: {"permissions": ["http://mochi.test/"]},
  });

  info("Test explicit host subdomain permission");
  await testHasPermission({
    manifest: {"permissions": ["http://*.mochi.test/"]},
  });

  info("Test explicit <all_urls> permission");
  await testHasPermission({
    manifest: {"permissions": ["<all_urls>"]},
  });

  info("Test activeTab permission with a command key press");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab"],
      "commands": {
        "test-tabs-executeScript": {
          "suggested_key": {
            "default": "Alt+Shift+K",
          },
        },
      },
    },
    contentSetup: function() {
      browser.commands.onCommand.addListener(function(command) {
        if (command == "test-tabs-executeScript") {
          browser.test.sendMessage("tabs-command-key-pressed");
        }
      });
      return Promise.resolve();
    },
    setup: async function(extension) {
      await EventUtils.synthesizeKey("k", {altKey: true, shiftKey: true});
      await extension.awaitMessage("tabs-command-key-pressed");
    },
  });

  info("Test activeTab permission with a browser action click");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab"],
      "browser_action": {},
    },
    contentSetup: function() {
      browser.browserAction.onClicked.addListener(() => {
        browser.test.log("Clicked.");
      });
      return Promise.resolve();
    },
    setup: clickBrowserAction,
    tearDown: closeBrowserAction,
  });

  info("Test activeTab permission with a page action click");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab"],
      "page_action": {},
    },
    contentSetup: async () => {
      let [tab] = await browser.tabs.query({active: true, currentWindow: true});
      await browser.pageAction.show(tab.id);
    },
    setup: clickPageAction,
    tearDown: closePageAction,
  });

  info("Test activeTab permission with a browser action w/popup click");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab"],
      "browser_action": {"default_popup": "_blank.html"},
    },
    setup: async extension => {
      await clickBrowserAction(extension);
      return awaitExtensionPanel(extension, window, "_blank.html");
    },
    tearDown: closeBrowserAction,
  });

  info("Test activeTab permission with a page action w/popup click");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab"],
      "page_action": {"default_popup": "_blank.html"},
    },
    contentSetup: async () => {
      let [tab] = await browser.tabs.query({active: true, currentWindow: true});
      await browser.pageAction.show(tab.id);
    },
    setup: clickPageAction,
    tearDown: closePageAction,
  });

  info("Test activeTab permission with a context menu click");
  await testHasPermission({
    manifest: {
      "permissions": ["activeTab", "contextMenus"],
    },
    contentSetup: function() {
      browser.contextMenus.create({title: "activeTab", contexts: ["all"]});
      return Promise.resolve();
    },
    setup: async function(extension) {
      let contextMenu = document.getElementById("contentAreaContextMenu");
      let awaitPopupShown = BrowserTestUtils.waitForEvent(contextMenu, "popupshown");
      let awaitPopupHidden = BrowserTestUtils.waitForEvent(contextMenu, "popuphidden");

      await BrowserTestUtils.synthesizeMouseAtCenter("a[href]", {type: "contextmenu", button: 2},
                                                     gBrowser.selectedBrowser);
      await awaitPopupShown;

      let item = contextMenu.querySelector("[label=activeTab]");

      await EventUtils.synthesizeMouseAtCenter(item, {}, window);

      await awaitPopupHidden;
    },
  });

  await BrowserTestUtils.removeTab(tab);
});

add_task(forceGC);
