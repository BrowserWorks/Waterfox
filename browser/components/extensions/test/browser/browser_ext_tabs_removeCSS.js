/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

add_task(async function testExecuteScript() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://mochi.test:8888/", true);

  async function background() {
    let tasks = [
      // Insert CSS file.
      {
        background: "rgba(0, 0, 0, 0)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.insertCSS({
            file: "file2.css",
          });
        },
      },
      // Insert CSS code.
      {
        background: "rgb(42, 42, 42)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.insertCSS({
            code: "* { background: rgb(42, 42, 42) }",
          });
        },
      },
      // Remove CSS code again.
      {
        background: "rgba(0, 0, 0, 0)",
        foreground: "rgb(0, 113, 4)",
        promise: () => {
          return browser.tabs.removeCSS({
            code: "* { background: rgb(42, 42, 42) }",
          });
        },
      },
      // Remove CSS file again.
      {
        background: "rgba(0, 0, 0, 0)",
        foreground: "rgb(0, 0, 0)",
        promise: () => {
          return browser.tabs.removeCSS({
            file: "file2.css",
          });
        },
      },
      // Insert CSS code.
      {
        background: "rgb(42, 42, 42)",
        foreground: "rgb(0, 0, 0)",
        promise: () => {
          return browser.tabs.insertCSS({
            code: "* { background: rgb(42, 42, 42) }",
            cssOrigin: "user",
          });
        },
      },
      // Remove CSS code again.
      {
        background: "rgba(0, 0, 0, 0)",
        foreground: "rgb(0, 0, 0)",
        promise: () => {
          return browser.tabs.removeCSS({
            code: "* { background: rgb(42, 42, 42) }",
            cssOrigin: "user",
          });
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

      browser.test.notifyPass("removeCSS");
    } catch (e) {
      browser.test.fail(`Error: ${e} :: ${e.stack}`);
      browser.test.notifyFailure("removeCSS");
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

  await extension.awaitFinish("removeCSS");

  await extension.unload();

  await BrowserTestUtils.removeTab(tab);
});
