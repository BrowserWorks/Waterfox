/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// Check that various highlighter elements exist.

const TEST_URL = "data:text/html;charset=utf-8,<div>test</div>";

// IDs of all highlighter elements that we expect to find in the canvasFrame.
const ELEMENTS = ["box-model-root",
                  "box-model-elements",
                  "box-model-margin",
                  "box-model-border",
                  "box-model-padding",
                  "box-model-content",
                  "box-model-guide-top",
                  "box-model-guide-right",
                  "box-model-guide-bottom",
                  "box-model-guide-left",
                  "box-model-infobar-container",
                  "box-model-infobar-tagname",
                  "box-model-infobar-id",
                  "box-model-infobar-classes",
                  "box-model-infobar-pseudo-classes",
                  "box-model-infobar-dimensions"];

add_task(function* () {
  let {inspector, testActor} = yield openInspectorForURL(TEST_URL);

  info("Show the box-model highlighter");
  let divFront = yield getNodeFront("div", inspector);
  yield inspector.highlighter.showBoxModel(divFront);

  for (let id of ELEMENTS) {
    let foundId = yield testActor.getHighlighterNodeAttribute(id, "id");
    is(foundId, id, "Element " + id + " found");
  }

  info("Hide the box-model highlighter");
  yield inspector.highlighter.hideBoxModel();
});
