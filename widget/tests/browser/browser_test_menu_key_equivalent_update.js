/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// When Gecko leaves a key unhandled, nsCocoaWindow::PostHandleKeyEvent offers
// it to the menu bar, which matches it against the key equivalents cached on
// the native menu items. Those have to follow changes to the <key> element the
// item was built from.

const KEY_ID = "key_fullZoomReduce";
const MENUITEM_ID = "menu_zoomReduce";
const ATTRS = ["data-l10n-id", "key", "keycode", "modifiers"];

function keyEquivalent() {
  return window.windowUtils.getNativeMenuItemKeyEquivalent(MENUITEM_ID);
}

add_task(async function test_key_equivalent_follows_key_element() {
  const keyEl = document.getElementById(KEY_ID);
  const saved = new Map();
  for (const attr of ATTRS) {
    if (keyEl.hasAttribute(attr)) {
      saved.set(attr, keyEl.getAttribute(attr));
    }
  }

  registerCleanupFunction(() => {
    for (const attr of ATTRS) {
      keyEl.removeAttribute(attr);
    }
    for (const [attr, value] of saved) {
      keyEl.setAttribute(attr, value);
    }
  });

  // Without this the assertions below would also pass on an item that never
  // had a key equivalent to begin with.
  is(keyEquivalent(), "command|-", "starts out carrying accel+-");

  for (const attr of ATTRS) {
    keyEl.removeAttribute(attr);
  }
  is(keyEquivalent(), "", "clearing the <key> clears the native equivalent");

  keyEl.setAttribute("key", "-");
  keyEl.setAttribute("modifiers", "accel,shift");
  is(
    keyEquivalent(),
    "shift,command|-",
    "reassigning the <key> updates the native equivalent"
  );
});
