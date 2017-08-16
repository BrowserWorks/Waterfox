function remote(task) {
  return ContentTask.spawn(gBrowser.selectedBrowser, null, task);
}

add_task(async function() {
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);

  let promise = BrowserTestUtils.waitForErrorPage(gBrowser.selectedBrowser);
  gBrowser.loadURI("https://nocert.example.com/");
  await promise;

  await remote(() => {
    // Confirm that we are displaying the contributed error page, not the default
    let uri = content.document.documentURI;
    Assert.ok(uri.startsWith("about:certerror"), "Broken page should go to about:certerror, not about:neterror");
  });

  await remote(() => {
    let div = content.document.getElementById("badCertAdvancedPanel");
    // Confirm that the expert section is collapsed
    Assert.ok(div, "Advanced content div should exist");
    Assert.equal(div.ownerGlobal.getComputedStyle(div).display,
      "none", "Advanced content should not be visible by default");
  });

  // Tweak the expert mode pref
  gPrefService.setBoolPref("browser.xul.error_pages.expert_bad_cert", true);

  promise = BrowserTestUtils.waitForErrorPage(gBrowser.selectedBrowser);
  gBrowser.reload();
  await promise;

  await remote(() => {
    let div = content.document.getElementById("badCertAdvancedPanel");
    Assert.ok(div, "Advanced content div should exist");
    Assert.equal(div.ownerGlobal.getComputedStyle(div).display,
      "block", "Advanced content should be visible by default");
  });

  // Clean up
  gBrowser.removeCurrentTab();
  if (gPrefService.prefHasUserValue("browser.xul.error_pages.expert_bad_cert"))
    gPrefService.clearUserPref("browser.xul.error_pages.expert_bad_cert");
});
