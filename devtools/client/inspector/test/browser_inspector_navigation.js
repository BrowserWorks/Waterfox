/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

// Test that inspector updates when page is navigated.

const TEST_URL_FILE = "browser/devtools/client/inspector/test/" +
  "doc_inspector_breadcrumbs.html";

const TEST_URL_1 = "http://test1.example.org/" + TEST_URL_FILE;
const TEST_URL_2 = "http://test2.example.org/" + TEST_URL_FILE;

add_task(function* () {
  let { inspector, testActor } = yield openInspectorForURL(TEST_URL_1);

  yield selectNode("#i1", inspector);

  info("Navigating to a different page.");
  yield navigateTo(inspector, TEST_URL_2);

  ok(true, "New page loaded");
  yield selectNode("#i1", inspector);

  let markuploaded = inspector.once("markuploaded");
  let onUpdated = inspector.once("inspector-updated");

  info("Going back in history");
  yield testActor.eval("history.go(-1)");

  info("Waiting for markup view to load after going back in history.");
  yield markuploaded;

  info("Check that the inspector updates");
  yield onUpdated;

  ok(true, "Old page loaded");
  is((yield testActor.eval("location.href;")), TEST_URL_1, "URL is correct.");

  yield selectNode("#i1", inspector);
});
