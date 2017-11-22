// Check to make sure that a worker can be attached to a toolbox
// directly, and that the toolbox has expected properties.

"use strict";

// The following "connectionClosed" rejection should not be left uncaught. This
// test has been whitelisted until the issue is fixed.
Cu.import("resource://testing-common/PromiseTestUtils.jsm", this);
PromiseTestUtils.expectUncaughtRejection(/[object Object]/);

var TAB_URL = EXAMPLE_URL + "doc_WorkerActor.attachThread-tab.html";
var WORKER_URL = "code_WorkerActor.attachThread-worker.js";

add_task(function* () {
  yield pushPrefs(["devtools.scratchpad.enabled", true]);

  DebuggerServer.init();
  DebuggerServer.addBrowserActors();

  let client = new DebuggerClient(DebuggerServer.connectPipe());
  yield connect(client);

  let tab = yield addTab(TAB_URL);
  let { tabs } = yield listTabs(client);
  let [, tabClient] = yield attachTab(client, findTab(tabs, TAB_URL));

  yield listWorkers(tabClient);
  yield createWorkerInTab(tab, WORKER_URL);

  let { workers } = yield listWorkers(tabClient);
  let [, workerClient] = yield attachWorker(tabClient,
                                             findWorker(workers, WORKER_URL));

  let toolbox = yield gDevTools.showToolbox(TargetFactory.forWorker(workerClient),
                                            "jsdebugger",
                                            Toolbox.HostType.WINDOW);

  is(toolbox.hostType, "window", "correct host");

  yield new Promise(done => {
    toolbox.win.parent.addEventListener("message", function onmessage(event) {
      if (event.data.name == "set-host-title") {
        toolbox.win.parent.removeEventListener("message", onmessage);
        done();
      }
    });
  });
  ok(toolbox.win.parent.document.title.includes(WORKER_URL),
     "worker URL in host title");

  let toolTabs = toolbox.doc.querySelectorAll(".devtools-tab");
  let activeTools = [...toolTabs].map(tab=>tab.getAttribute("data-id"));

  is(activeTools.join(","), "webconsole,jsdebugger,scratchpad,options",
    "Correct set of tools supported by worker");

  terminateWorkerInTab(tab, WORKER_URL);
  yield waitForWorkerClose(workerClient);
  yield close(client);

  yield toolbox.destroy();
});
