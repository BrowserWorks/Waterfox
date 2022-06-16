/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

add_task(async function regular_mode() {
  let className;
  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    ({ className } = win.document.body);
    win.close();
  });

  Assert.equal(className, "", "No classes set on body");
});

function promiseResize(win, width, height) {
  if (win.outerWidth == width && win.outerHeight == height) {
    return Promise.resolve();
  }
  return new Promise(resolve => {
    // More than one "resize" might be received if the window was recently
    // created.
    win.addEventListener("resize", () => {
      if (win.outerWidth == width && win.outerHeight == height) {
        resolve();
      }
    });
    win.resizeTo(width, height);
  });
}

add_task(async function compact_mode() {
  // Shrink the window for this test.
  const { outerHeight, outerWidth } = window;
  await promiseResize(window, outerWidth, 500);

  let className;
  await showAndWaitForDialog(async win => {
    await BrowserTestUtils.waitForEvent(win, "ready");
    ({ className } = win.document.body);
    win.close();
  });

  Assert.equal(className, "compact", "Set class on body");

  await promiseResize(window, outerWidth, outerHeight);
});
