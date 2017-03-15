/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Tests that errors about insecure passwords are logged to the web console.

"use strict";

const TEST_URI = "http://example.com/browser/devtools/client/webconsole/" +
                 "test/test-bug-762593-insecure-passwords-about-blank-web-console-warning.html";
const INSECURE_PASSWORD_MSG = "Password fields present on an insecure " +
  "(http://) iframe. This is a security risk that allows user login " +
  "credentials to be stolen.";

add_task(function* () {
  yield loadTab(TEST_URI);

  let hud = yield openConsole();

  yield waitForMessages({
    webconsole: hud,
    messages: [
      {
        name: "Insecure password error displayed successfully",
        text: INSECURE_PASSWORD_MSG,
        category: CATEGORY_SECURITY,
        severity: SEVERITY_WARNING
      },
    ],
  });
});
