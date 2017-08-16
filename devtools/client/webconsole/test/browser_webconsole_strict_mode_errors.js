/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Check that "use strict" JS errors generate errors, not warnings.

"use strict";

add_task(function* () {
  // On e10s, the exception is triggered in child process
  // and is ignored by test harness
  if (!Services.appinfo.browserTabsRemoteAutostart) {
    expectUncaughtException();
  }
  yield loadTab("data:text/html;charset=utf8,<script>'use strict';var arguments;</script>");

  let hud = yield openConsole();

  yield waitForMessages({
    webconsole: hud,
    messages: [
      {
        text: "SyntaxError: 'arguments' can't be defined or assigned to in strict mode code",
        category: CATEGORY_JS,
        severity: SEVERITY_ERROR,
      },
    ],
  });

  if (!Services.appinfo.browserTabsRemoteAutostart) {
    expectUncaughtException();
  }
  BrowserTestUtils.loadURI(gBrowser.selectedBrowser, "data:text/html;charset="
    + "utf8,<script>'use strict';function f(a, a) {};</script>");

  yield waitForMessages({
    webconsole: hud,
    messages: [
      {
        text: "SyntaxError: duplicate formal argument a",
        category: CATEGORY_JS,
        severity: SEVERITY_ERROR,
      },
    ],
  });

  if (!Services.appinfo.browserTabsRemoteAutostart) {
    expectUncaughtException();
  }
  BrowserTestUtils.loadURI(gBrowser.selectedBrowser, "data:text/html;charset="
    + "utf8,<script>'use strict';var o = {get p() {}};o.p = 1;</script>");

  yield waitForMessages({
    webconsole: hud,
    messages: [
      {
        text: 'TypeError: setting getter-only property "p"',
        category: CATEGORY_JS,
        severity: SEVERITY_ERROR,
      },
    ],
  });

  if (!Services.appinfo.browserTabsRemoteAutostart) {
    expectUncaughtException();
  }
  BrowserTestUtils.loadURI(gBrowser.selectedBrowser,
    "data:text/html;charset=utf8,<script>'use strict';v = 1;</script>");

  yield waitForMessages({
    webconsole: hud,
    messages: [
      {
        text: "ReferenceError: assignment to undeclared variable v",
        category: CATEGORY_JS,
        severity: SEVERITY_ERROR,
      },
    ],
  });

  hud = null;
});
