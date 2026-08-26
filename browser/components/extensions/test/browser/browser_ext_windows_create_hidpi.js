"use strict";

add_setup(async () => {
  // The scale multiplies the browser window's minimum width (500 CSS pixels,
  // --window-min-width), which forces the window to grow, and popping the pref
  // does not shrink it back. Restore the size, otherwise the rest of the
  // manifest runs with a window that can be wider than the screen.
  const { outerWidth, outerHeight } = window;
  registerCleanupFunction(async () => {
    await SpecialPowers.popPrefEnv();
    // The minimum size only goes back down once layout has caught up with the
    // scale change; resizing before that would be clamped to the larger minimum.
    await window.promiseDocumentFlushed(() => {});
    if (window.outerWidth != outerWidth || window.outerHeight != outerHeight) {
      window.resizeTo(outerWidth, outerHeight);
    }
  });

  // Simulate hidpi monitor, where CSS and desktop pixels diverge. We use 3
  // because it differs from 1, and also differs from 2 (which would be
  // canceled out by contentsScaleFactor of 2 on macOS).
  await SpecialPowers.pushPrefEnv({
    set: [["layout.css.devPixelsPerPx", 3]],
  });

  // For informative purposes, show the scale. Should ideally be distinct from
  // 1, but even if it is 1, we still run the test because the behavior should
  // be the same.
  info(
    `cssToDesktopScale=${window.devicePixelRatio / window.desktopToDeviceScale}`
  );
});

// Regression test for https://bugzilla.mozilla.org/show_bug.cgi?id=1982177
// top/left in windows.create() (and windows.update()) should roundtrip, even
// on hidpi screens (where desktop pixels differ from CSS pixels).
add_task(async function test_windows_create_update_roundtrip_top_and_left() {
  const extension = ExtensionTestUtils.loadExtension({
    manifest: {
      description: JSON.stringify({
        isWayland: Services.appinfo.isWayland,
      }),
    },
    async background() {
      const { isWayland } = JSON.parse(
        browser.runtime.getManifest().description
      );

      function assertDimension(expected, actual, description) {
        if (isWayland) {
          // TODO bug 1989539: fails to return top/left on Wayland, always 0.
          browser.test.assertEq(
            0,
            actual,
            `TODO ${description}: expected ${expected}`
          );
          return;
        }
        // The returned left/top are window.screenX/screenY (CSS pixels) and
        // must match the request (allowing 1px for rounding).
        browser.test.assertTrue(
          Math.abs(expected - actual) <= 1,
          `${description}: Expected ${expected}, got ${actual}`
        );
      }
      let win = await browser.windows.create({
        type: "popup",
        top: 30,
        left: 60,
        width: 90,
        height: 120,
      });
      assertDimension(30, win.top, "windows.create() preserves top");
      assertDimension(60, win.left, "windows.create() preserves left");

      win = await browser.windows.update(win.id, {
        top: 60,
        left: 30,
      });

      // moveTo() may be applied asynchronously, e.g. with on Linux / X11. So
      // we wait a bit. This loop here is comparable to waitForCondition.
      for (let i = 0; i < 100 && win.left === 60; ++i) {
        browser.test.log(`Waiting for internal moveTo() to be applied (${i})`);
        // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
        await new Promise(r => setTimeout(r, 50));
        win = await browser.windows.get(win.id);
      }

      assertDimension(60, win.top, "windows.update() preserves top");
      assertDimension(30, win.left, "windows.update() preserves left");

      await browser.windows.remove(win.id);

      browser.test.sendMessage("done");
    },
  });

  await extension.startup();
  await extension.awaitMessage("done");
  await extension.unload();
});
