/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

add_task(async function testExecuteScript() {
  let {MessageChannel} = Cu.import("resource://gre/modules/MessageChannel.jsm", {});

  let messageManagersSize = MessageChannel.messageManagers.size;
  let responseManagersSize = MessageChannel.responseManagers.size;

  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://mochi.test:8888/", true);

  async function background() {
    let tasks = [
      {
        background: "rgba(0, 0, 0, 0)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.insertCSS({
            file: "file2.css",
          });
        },
      },
      {
        background: "rgb(42, 42, 42)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.insertCSS({
            code: "* { background: rgb(42, 42, 42) }",
          });
        },
      },
      {
        background: "rgb(42, 42, 42)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.insertCSS({
            code: "* { background: rgb(100, 100, 100) !important }",
            cssOrigin: "author",
          }).then(r => browser.tabs.insertCSS({
            code: "* { background: rgb(42, 42, 42) !important }",
            cssOrigin: "author",
          }));
        },
      },
      {
        background: "rgb(100, 100, 100)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          // User has higher importance
          return browser.tabs.insertCSS({
            code: "* { background: rgb(100, 100, 100) !important }",
            cssOrigin: "user",
          }).then(r => browser.tabs.insertCSS({
            code: "* { background: rgb(42, 42, 42) !important }",
            cssOrigin: "author",
          }));
        },
      },
    ];

    function checkCSS() {
      let computedStyle = window.getComputedStyle(document.body);
      return [computedStyle.backgroundColor, computedStyle.color];
    }

    try {
      for (let {promise, background, foreground} of tasks) {
        let result = await promise();

        browser.test.assertEq(undefined, result, "Expected callback result");

        [result] = await browser.tabs.executeScript({
          code: `(${checkCSS})()`,
        });

        browser.test.assertEq(background, result[0], "Expected background color");
        browser.test.assertEq(foreground, result[1], "Expected foreground color");
      }

      browser.test.notifyPass("insertCSS");
    } catch (e) {
      browser.test.fail(`Error: ${e} :: ${e.stack}`);
      browser.test.notifyFailure("insertCSS");
    }
  }

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["http://mochi.test/"],
    },

    background,

    files: {
      "file2.css": "* { color: rgb(0, 113, 4) }",
    },
  });

  await extension.startup();

  await extension.awaitFinish("insertCSS");

  await extension.unload();

  await BrowserTestUtils.removeTab(tab);

  // Make sure that we're not holding on to references to closed message
  // managers.
  is(MessageChannel.messageManagers.size, messageManagersSize, "Message manager count");
  is(MessageChannel.responseManagers.size, responseManagersSize, "Response manager count");
  is(MessageChannel.pendingResponses.size, 0, "Pending response count");
});
