"use strict";

function handleMessage(request, sender, sendResponse) {
  browser.wf.attemptInstallChromeExtension(request.downloadURL);
}

browser.runtime.onMessage.addListener(handleMessage);
