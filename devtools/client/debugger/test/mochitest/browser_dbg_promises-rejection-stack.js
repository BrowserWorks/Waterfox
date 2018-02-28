/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Test that we can get a stack to a promise's rejection point.
 */

"use strict";

const TAB_URL = EXAMPLE_URL + "doc_promise-get-rejection-stack.html";
const { PromisesFront } = require("devtools/shared/fronts/promises");
var events = require("sdk/event/core");

// The code in the document above leaves an uncaught rejection. This is only
// reported to the testing framework if the code is loaded in the main process.
if (!gMultiProcessBrowser) {
  Cu.import("resource://testing-common/PromiseTestUtils.jsm", this);
  PromiseTestUtils.expectUncaughtRejection(/hello/);
}

const TEST_DATA = [
  {
    functionDisplayName: "returnPromise/<",
    line: 19,
    column: 47
  },
  {
    functionDisplayName: "returnPromise",
    line: 19,
    column: 14
  },
  {
    functionDisplayName: "makePromise",
    line: 14,
    column: 15
  },
];

function test() {
  Task.spawn(function* () {
    DebuggerServer.init();
    DebuggerServer.addBrowserActors();

    let options = {
      source: TAB_URL,
      line: 1
    };
    const [ tab,, panel ] = yield initDebugger(TAB_URL, options);

    let client = new DebuggerClient(DebuggerServer.connectPipe());
    yield connect(client);

    let { tabs } = yield listTabs(client);
    let targetTab = findTab(tabs, TAB_URL);
    yield attachTab(client, targetTab);

    yield testGetRejectionStack(client, targetTab, tab);

    yield close(client);
    yield closeDebuggerAndFinish(panel);
  }).catch(error => {
    ok(false, "Got an error: " + error.message + "\n" + error.stack);
  });
}

function* testGetRejectionStack(client, form, tab) {
  let front = PromisesFront(client, form);

  yield front.attach();
  yield front.listPromises();

  // Get the grip for promise p
  let onNewPromise = new Promise(resolve => {
    events.on(front, "new-promises", promises => {
      for (let p of promises) {
        if (p.preview.ownProperties.name &&
            p.preview.ownProperties.name.value === "p") {
          resolve(p);
        }
      }
    });
  });

  callInTab(tab, "makePromise");

  let grip = yield onNewPromise;
  ok(grip, "Found our promise p");

  let objectClient = new ObjectClient(client, grip);
  ok(objectClient, "Got Object Client");

  yield new Promise(resolve => {
    objectClient.getPromiseRejectionStack(response => {
      ok(response.rejectionStack.length, "Got promise allocation stack.");

      for (let i = 0; i < TEST_DATA.length; i++) {
        let stack = response.rejectionStack[i];
        let data = TEST_DATA[i];
        is(stack.source.url, TAB_URL, "Got correct source URL.");
        is(stack.functionDisplayName, data.functionDisplayName,
           "Got correct function display name.");
        is(stack.line, data.line, "Got correct stack line number.");
        is(stack.column, data.column, "Got correct stack column number.");
      }

      resolve();
    });
  });

  yield front.detach();
}
