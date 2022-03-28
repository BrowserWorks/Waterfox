"use strict";

// Handle install request from Chrome Web store button click
function handleMessage(request, sender, sendResponse) {
  browser.wf.attemptInstallChromeExtension(request.downloadURL);
}

browser.runtime.onMessage.addListener(handleMessage);

// Send message to content script to add new element to indicate crx install attempt succeeded
browser.wf.onCrxInstall.addListener(data => {
  browser.tabs
    .query({
      currentWindow: true,
      active: true,
    })
    .then(tabs => {
      for (let tab of tabs) {
        browser.tabs.sendMessage(tab.id, { update: true });
      }
    });
});
