/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* exported runCodeMirrorTest */
/* globals codemirrorSetStatus */

"use strict";

function runCodeMirrorTest(browser) {
  let mm = browser.messageManager;
  mm.addMessageListener("setStatus", function listener({ data }) {
    const { statusMsg, type, customMsg } = data;
    codemirrorSetStatus(statusMsg, type, customMsg);
  });
  mm.addMessageListener("done", function listener({ data }) {
    ok(!data.failed, "CodeMirror tests all passed");
    while (gBrowser.tabs.length > 1) {
      gBrowser.removeCurrentTab();
    }
    mm = null;
    finish();
  });

  // Interact with the content iframe, giving it a function to
  //  1) Proxy CM test harness calls into ok() calls
  //  2) Detecting when it finishes by checking the DOM and
  //     setting a timeout to check again if not.
  /* eslint-disable max-len */
  mm.loadFrameScript(
    "data:," +
      "content.wrappedJSObject.mozilla_setStatus = function(statusMsg, type, customMsg) {" +
      "  sendSyncMessage('setStatus', {statusMsg: statusMsg, type: type, customMsg: customMsg});" +
      "};" +
      "function check() { " +
      "  var doc = content.document; var out = doc.getElementById('status'); " +
      "  if (!out || !out.classList.contains('done')) { return content.setTimeout(check, 100); }" +
      "  sendAsyncMessage('done', { failed: content.wrappedJSObject.failed });" +
      "}" +
      "check();",
    true
  );
  /* eslint-enable max-len */
}
