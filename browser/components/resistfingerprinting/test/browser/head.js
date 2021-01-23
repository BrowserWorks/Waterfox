/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// This function calculates the maximum available window dimensions and returns
// them as an object.
async function calcMaximumAvailSize(aChromeWidth, aChromeHeight) {
  let chromeUIWidth;
  let chromeUIHeight;
  let testPath =
    "http://example.net/browser/browser/" +
    "components/resistfingerprinting/test/browser/";

  // If the chrome UI dimensions is not given, we will calculate it.
  if (!aChromeWidth || !aChromeHeight) {
    let win = await BrowserTestUtils.openNewBrowserWindow();

    let tab = await BrowserTestUtils.openNewForegroundTab(
      win.gBrowser,
      testPath + "file_dummy.html"
    );

    let contentSize = await SpecialPowers.spawn(
      tab.linkedBrowser,
      [],
      async function() {
        let result = {
          width: content.innerWidth,
          height: content.innerHeight,
        };

        return result;
      }
    );

    // Calculate the maximum available window size which is depending on the
    // available screen space.
    chromeUIWidth = win.outerWidth - contentSize.width;
    chromeUIHeight = win.outerHeight - contentSize.height;

    BrowserTestUtils.removeTab(tab);
    await BrowserTestUtils.closeWindow(win);
  } else {
    chromeUIWidth = aChromeWidth;
    chromeUIHeight = aChromeHeight;
  }

  let availWidth = window.screen.availWidth;
  let availHeight = window.screen.availHeight;

  // Ideally, we would round the window size as 1000x1000. But the available
  // screen space might not suffice. So, we decide the size according to the
  // available screen size.
  let availContentWidth = Math.min(1000, availWidth - chromeUIWidth);
  let availContentHeight;

  // If it is GTK window, we would consider the system decorations when we
  // calculating avail content height since the system decorations won't be
  // reported when we get available screen dimensions.
  if (AppConstants.MOZ_WIDGET_GTK) {
    availContentHeight = Math.min(1000, -40 + availHeight - chromeUIHeight);
  } else {
    availContentHeight = Math.min(1000, availHeight - chromeUIHeight);
  }

  // Rounded the desire size to the nearest 200x100.
  let maxAvailWidth = availContentWidth - (availContentWidth % 200);
  let maxAvailHeight = availContentHeight - (availContentHeight % 100);

  return { maxAvailWidth, maxAvailHeight };
}

async function calcPopUpWindowChromeUISize() {
  let testPath =
    "http://example.net/browser/browser/" +
    "components/resistFingerprinting/test/browser/";
  // open a popup window to acquire the chrome UI size of it.
  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    testPath + "file_dummy.html"
  );

  let result = await SpecialPowers.spawn(
    tab.linkedBrowser,
    [],
    async function() {
      let win;

      await new Promise(resolve => {
        win = content.open("about:blank", "", "width=1000,height=1000");
        win.onload = () => resolve();
      });

      let res = {
        chromeWidth: win.outerWidth - win.innerWidth,
        chromeHeight: win.outerHeight - win.innerHeight,
      };

      win.close();

      return res;
    }
  );

  BrowserTestUtils.removeTab(tab);

  return result;
}

async function testWindowOpen(
  aBrowser,
  aSettingWidth,
  aSettingHeight,
  aTargetWidth,
  aTargetHeight,
  aTestOuter,
  aMaxAvailWidth,
  aMaxAvailHeight,
  aPopupChromeUIWidth,
  aPopupChromeUIHeight
) {
  // If the target size is greater than the maximum available content size,
  // we set the target size to it.
  if (aTargetWidth > aMaxAvailWidth) {
    aTargetWidth = aMaxAvailWidth;
  }

  if (aTargetHeight > aMaxAvailHeight) {
    aTargetHeight = aMaxAvailHeight;
  }

  // Create the testing window features.
  let winFeatures;

  if (aTestOuter) {
    winFeatures =
      "outerWidth=" +
      (aSettingWidth + aPopupChromeUIWidth) +
      ",outerHeight=" +
      (aSettingHeight + aPopupChromeUIHeight);
  } else {
    winFeatures = "width=" + aSettingWidth + ",height=" + aSettingHeight;
  }

  let testParams = {
    winFeatures,
    targetWidth: aTargetWidth,
    targetHeight: aTargetHeight,
  };

  await SpecialPowers.spawn(aBrowser, [testParams], async function(input) {
    // Call window.open() with window features.
    await new Promise(resolve => {
      let win = content.open("http://example.net/", "", input.winFeatures);

      win.onload = () => {
        is(
          win.screen.width,
          input.targetWidth,
          "The screen.width has a correct rounded value"
        );
        is(
          win.screen.height,
          input.targetHeight,
          "The screen.height has a correct rounded value"
        );
        is(
          win.innerWidth,
          input.targetWidth,
          "The window.innerWidth has a correct rounded value"
        );
        is(
          win.innerHeight,
          input.targetHeight,
          "The window.innerHeight has a correct rounded value"
        );

        win.close();
        resolve();
      };
    });
  });
}

async function testWindowSizeSetting(
  aBrowser,
  aSettingWidth,
  aSettingHeight,
  aTargetWidth,
  aTargetHeight,
  aInitWidth,
  aInitHeight,
  aTestOuter,
  aMaxAvailWidth,
  aMaxAvailHeight,
  aPopupChromeUIWidth,
  aPopupChromeUIHeight
) {
  // If the target size is greater than the maximum available content size,
  // we set the target size to it.
  if (aTargetWidth > aMaxAvailWidth) {
    aTargetWidth = aMaxAvailWidth;
  }

  if (aTargetHeight > aMaxAvailHeight) {
    aTargetHeight = aMaxAvailHeight;
  }

  let testParams = {
    initWidth: aInitWidth,
    initHeight: aInitHeight,
    settingWidth: aSettingWidth + (aTestOuter ? aPopupChromeUIWidth : 0),
    settingHeight: aSettingHeight + (aTestOuter ? aPopupChromeUIHeight : 0),
    targetWidth: aTargetWidth,
    targetHeight: aTargetHeight,
    testOuter: aTestOuter,
  };

  await SpecialPowers.spawn(aBrowser, [testParams], async function(input) {
    let win;
    // Open a new window and wait until it loads.
    await new Promise(resolve => {
      // Given a initial window size which should be different from target
      // size. We need this to trigger 'onresize' event.
      let initWinFeatures =
        "width=" + input.initWidth + ",height=" + input.initHeight;
      win = content.open("http://example.net/", "", initWinFeatures);
      win.onload = () => resolve();
    });

    // Test inner/outerWidth.
    await new Promise(resolve => {
      win.addEventListener(
        "resize",
        () => {
          is(
            win.screen.width,
            input.targetWidth,
            "The screen.width has a correct rounded value"
          );
          is(
            win.innerWidth,
            input.targetWidth,
            "The window.innerWidth has a correct rounded value"
          );

          resolve();
        },
        { once: true }
      );

      if (input.testOuter) {
        win.outerWidth = input.settingWidth;
      } else {
        win.innerWidth = input.settingWidth;
      }
    });

    win.close();
    // Open a new window and wait until it loads.
    await new Promise(resolve => {
      // Given a initial window size which should be different from target
      // size. We need this to trigger 'onresize' event.
      let initWinFeatures =
        "width=" + input.initWidth + ",height=" + input.initHeight;
      win = content.open("http://example.net/", "", initWinFeatures);
      win.onload = () => resolve();
    });

    // Test inner/outerHeight.
    await new Promise(resolve => {
      win.addEventListener(
        "resize",
        () => {
          is(
            win.screen.height,
            input.targetHeight,
            "The screen.height has a correct rounded value"
          );
          is(
            win.innerHeight,
            input.targetHeight,
            "The window.innerHeight has a correct rounded value"
          );

          resolve();
        },
        { once: true }
      );

      if (input.testOuter) {
        win.outerHeight = input.settingHeight;
      } else {
        win.innerHeight = input.settingHeight;
      }
    });

    win.close();
  });
}

class RoundedWindowTest {
  // testOuter is optional.  run() can be invoked with only 1 parameter.
  static run(testCases, testOuter) {
    // "this" is the calling class itself.
    // e.g. when invoked by RoundedWindowTest.run(), "this" is "class RoundedWindowTest".
    let test = new this(testCases);
    add_task(async () => test.setup());
    add_task(async () => {
      if (testOuter == undefined) {
        // If testOuter is not given, do tests for both inner and outer.
        await test.doTests(false);
        await test.doTests(true);
      } else {
        await test.doTests(testOuter);
      }
    });
  }

  get TEST_PATH() {
    return "http://example.net/browser/browser/components/resistfingerprinting/test/browser/";
  }

  constructor(testCases) {
    this.testCases = testCases;
  }

  async setup() {
    await SpecialPowers.pushPrefEnv({
      set: [["privacy.resistFingerprinting", true]],
    });

    // Calculate the popup window's chrome UI size for tests of outerWidth/Height.
    let popUpChromeUISize = await calcPopUpWindowChromeUISize();

    this.popupChromeUIWidth = popUpChromeUISize.chromeWidth;
    this.popupChromeUIHeight = popUpChromeUISize.chromeHeight;

    // Calculate the maximum available size.
    let maxAvailSize = await calcMaximumAvailSize(
      this.popupChromeUIWidth,
      this.popupChromeUIHeight
    );

    this.maxAvailWidth = maxAvailSize.maxAvailWidth;
    this.maxAvailHeight = maxAvailSize.maxAvailHeight;
  }

  async doTests(testOuter) {
    // Open a tab to test.
    this.tab = await BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      this.TEST_PATH + "file_dummy.html"
    );

    for (let test of this.testCases) {
      await this.doTest(test, testOuter);
    }

    BrowserTestUtils.removeTab(this.tab);
  }

  async doTest() {
    throw new Error("RoundedWindowTest.doTest must be overridden.");
  }
}

class WindowSettingTest extends RoundedWindowTest {
  async doTest(test, testOuter) {
    await testWindowSizeSetting(
      this.tab.linkedBrowser,
      test.settingWidth,
      test.settingHeight,
      test.targetWidth,
      test.targetHeight,
      test.initWidth,
      test.initHeight,
      testOuter,
      this.maxAvailWidth,
      this.maxAvailHeight,
      this.popupChromeUIWidth,
      this.popupChromeUIHeight
    );
  }
}

class OpenTest extends RoundedWindowTest {
  async doTest(test, testOuter) {
    await testWindowOpen(
      this.tab.linkedBrowser,
      test.settingWidth,
      test.settingHeight,
      test.targetWidth,
      test.targetHeight,
      testOuter,
      this.maxAvailWidth,
      this.maxAvailHeight,
      this.popupChromeUIWidth,
      this.popupChromeUIHeight
    );
  }
}
