"use strict";

add_task(async function setup() {
  await SpecialPowers.pushPrefEnv({
    set: [["extensions.webextensions.themes.enabled", true]],
  });
});

add_task(async function test_support_LWT_properties() {
  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "theme": {
        "images": {
          "headerURL": "image1.png",
        },
        "colors": {
          "accentcolor": ACCENT_COLOR,
          "textcolor": TEXT_COLOR,
        },
      },
    },
    files: {
      "image1.png": BACKGROUND,
    },
  });

  await extension.startup();

  let docEl = window.document.documentElement;
  let style = window.getComputedStyle(docEl);

  Assert.ok(docEl.hasAttribute("lwtheme"), "LWT attribute should be set");
  Assert.equal(docEl.getAttribute("lwthemetextcolor"), "bright",
    "LWT text color attribute should be set");

  Assert.ok(style.backgroundImage.includes("image1.png"), "Expected background image");
  Assert.equal(style.backgroundColor, "rgb(" + hexToRGB(ACCENT_COLOR).join(", ") + ")",
    "Expected correct background color");
  Assert.equal(style.color, "rgb(" + hexToRGB(TEXT_COLOR).join(", ") + ")",
    "Expected correct text color");

  await extension.unload();

  Assert.ok(!docEl.hasAttribute("lwtheme"), "LWT attribute should not be set");
});

add_task(async function test_LWT_requires_all_properties_defined_image_only() {
  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "theme": {
        "images": {
          "headerURL": "image1.png",
        },
      },
    },
    files: {
      "image1.png": BACKGROUND,
    },
  });

  await extension.startup();

  let docEl = window.document.documentElement;
  Assert.ok(!docEl.hasAttribute("lwtheme"), "LWT attribute should not be set");
  await extension.unload();
  Assert.ok(!docEl.hasAttribute("lwtheme"), "LWT attribute should not be set");
});

add_task(async function test_LWT_requires_all_properties_defined_colors_only() {
  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "theme": {
        "colors": {
          "accentcolor": ACCENT_COLOR,
          "textcolor": TEXT_COLOR,
        },
      },
    },
  });

  await extension.startup();

  let docEl = window.document.documentElement;
  Assert.ok(!docEl.hasAttribute("lwtheme"), "LWT attribute should not be set");
  await extension.unload();
  Assert.ok(!docEl.hasAttribute("lwtheme"), "LWT attribute should not be set");
});
