/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

function testURLBarCopy(targetValue) {
  return new Promise((resolve, reject) => {
    info("Expecting copy of: " + targetValue);
    waitForClipboard(targetValue, function() {
      gURLBar.focus();
      gURLBar.select();

      goDoCommand("cmd_copy");
    }, resolve, () => {
      ok(false, "Clipboard copy failed");
      reject();
    });
  });
}

add_task(async function() {
  const url = "http://mochi.test:8888/browser/browser/base/content/test/urlbar/test_wyciwyg_copying.html";
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, url);

  await BrowserTestUtils.synthesizeMouseAtCenter("#btn", {}, tab.linkedBrowser);
  let currentURL = gBrowser.currentURI.spec;
  ok(/^wyciwyg:\/\//i.test(currentURL), currentURL + " is a wyciwyg URI");

  await testURLBarCopy(url);

  while (gBrowser.tabs.length > 1)
    gBrowser.removeCurrentTab();
});
