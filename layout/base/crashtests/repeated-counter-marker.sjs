/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const STATE_KEY = "repeated-counter-marker";

function getPendingState() {
  let state;
  getObjectState(STATE_KEY, value => {
    state = value?.wrappedJSObject;
  });
  return state;
}

function handleRequest(request, response) {
  response.setHeader("Cache-Control", "no-store", false);

  if (request.queryString === "reset") {
    const state = {
      responses: [],
      released: false,
      QueryInterface: ChromeUtils.generateQI([]),
    };
    state.wrappedJSObject = state;
    setObjectState(STATE_KEY, state);
    response.setHeader("Content-Type", "application/javascript", false);
    return;
  }

  const state = getPendingState();
  if (request.queryString === "release") {
    state.released = true;
    for (const pending of state.responses) {
      pending.finish();
    }
    state.responses.length = 0;
    response.setHeader("Content-Type", "text/plain", false);
    return;
  }

  response.setStatusLine(request.httpVersion, 404, "Not Found");
  response.setHeader("Content-Type", "image/png", false);
  response.processAsync();
  if (state.released) {
    response.finish();
  } else {
    state.responses.push(response);
  }
}
