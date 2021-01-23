/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["Input"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { Domain } = ChromeUtils.import(
  "chrome://remote/content/domains/Domain.jsm"
);

class Input extends Domain {
  // commands

  /**
   * Simulate key events.
   *
   * @param {Object} options
   *        - autoRepeat (not supported)
   *        - code (not supported)
   *        - key
   *        - isKeypad (not supported)
   *        - location (not supported)
   *        - modifiers
   *        - text (not supported)
   *        - type
   *        - unmodifiedText (not supported)
   *        - windowsVirtualKeyCode
   *        - nativeVirtualKeyCode (not supported)
   *        - keyIdentifier (not supported)
   *        - isSystemKey (not supported)
   */
  async dispatchKeyEvent(options = {}) {
    // missing code, text, unmodifiedText, autorepeat, location, iskeypad
    const { key, modifiers, type, windowsVirtualKeyCode } = options;
    const { alt, ctrl, meta, shift } = Input.Modifier;

    let domType;
    if (type == "keyDown" || type == "rawKeyDown") {
      // 'rawKeyDown' is passed as type by puppeteer for all non-text keydown events:
      // See https://github.com/GoogleChrome/puppeteer/blob/2d99d85976dcb28cc6e3bad4b6a00cd61a67a2cf/lib/Input.js#L52
      // For now we simply map rawKeyDown to keydown.
      domType = "keydown";
    } else if (type == "keyUp" || type == "char") {
      // 'char' is fired as a single key event. Behind the scenes it will trigger keydown,
      // keypress and keyup. `domType` will only be used as the event to wait for.
      domType = "keyup";
    } else {
      throw new Error(`Unknown key event type ${type}`);
    }

    const { browser } = this.session.target;
    const browserWindow = browser.ownerGlobal;

    const EventUtils = this._getEventUtils(browserWindow);
    const eventId = await this.executeInChild(
      "_addContentEventListener",
      domType
    );

    if (type == "char") {
      // type == "char" is used when doing `await page.keyboard.type( 'I’m a list' );`
      // the ’ character will be calling dispatchKeyEvent only once with type=char.
      EventUtils.synthesizeKey(key, {}, browserWindow);
    } else {
      // Non printable keys should be prefixed with `KEY_`
      const eventUtilsKey = key.length == 1 ? key : "KEY_" + key;
      const eventInfo = {
        keyCode: windowsVirtualKeyCode,
        type: domType,
        altKey: !!(modifiers & alt),
        ctrlKey: !!(modifiers & ctrl),
        metaKey: !!(modifiers & meta),
        shiftKey: !!(modifiers & shift),
      };
      EventUtils.synthesizeKey(eventUtilsKey, eventInfo, browserWindow);
    }

    // Temporary workaround to handle certain native key bindings than cannot
    // be synthesized with EventUtils: dispatch editor command directly
    if (domType == "keydown") {
      switch (Services.appinfo.OS) {
        case "Linux":
          if (modifiers == ctrl && key == "Backspace") {
            await this.executeInChild(
              "_doDocShellCommand",
              "cmd_deleteWordBackward"
            );
          }
          break;
        case "Darwin":
          if (modifiers == meta && key == "Backspace") {
            await this.executeInChild(
              "_doDocShellCommand",
              "cmd_deleteToBeginningOfLine"
            );
          }
      }
    }

    // TODO in case of workaround for native key bindings: wait for input event?
    await this.executeInChild("_waitForContentEvent", eventId);
  }

  async dispatchMouseEvent({ type, button, x, y, modifiers, clickCount }) {
    const { alt, ctrl, meta, shift } = Input.Modifier;

    if (type == "mousePressed") {
      type = "mousedown";
    } else if (type == "mouseReleased") {
      type = "mouseup";
    } else if (type == "mouseMoved") {
      type = "mousemove";
    } else {
      throw new Error(`Mouse type is not supported: ${type}`);
    }

    if (type === "mousedown" && button === "right") {
      type = "contextmenu";
    }
    const buttonID = Input.Button[button] || Input.Button.left;
    const { browser } = this.session.target;
    const currentWindow = browser.ownerGlobal;
    const EventUtils = this._getEventUtils(currentWindow);
    EventUtils.synthesizeMouse(browser, x, y, {
      type,
      button: buttonID,
      clickCount: clickCount || 1,
      altKey: !!(modifiers & alt),
      ctrlKey: !!(modifiers & ctrl),
      metaKey: !!(modifiers & meta),
      shiftKey: !!(modifiers & shift),
    });
  }

  /**
   * Memoized EventUtils getter.
   */
  _getEventUtils(win) {
    if (!this._eventUtils) {
      this._eventUtils = {
        window: win,
        parent: win,
        _EU_Ci: Ci,
        _EU_Cc: Cc,
      };
      Services.scriptloader.loadSubScript(
        "chrome://remote/content/external/EventUtils.js",
        this._eventUtils
      );
    }
    return this._eventUtils;
  }
}

Input.Button = {
  left: 0,
  middle: 1,
  right: 2,
  back: 3,
  forward: 4,
};

Input.Modifier = {
  alt: 1,
  ctrl: 2,
  meta: 4,
  shift: 8,
};
