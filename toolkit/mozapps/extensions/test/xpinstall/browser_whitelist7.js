// ----------------------------------------------------------------------------
// Tests installing an unsigned add-on through a direct install request from
// web content. This should be blocked by the whitelist check because we disable
// direct request whitelisting, even though the target URI is whitelisted.
function test() {
  Harness.installBlockedCallback = allow_blocked;
  Harness.installsCompletedCallback = finish_test;
  Harness.setup();

  // Disable direct request whitelisting, installing should be blocked.
  Services.prefs.setBoolPref("xpinstall.whitelist.directRequest", false);

  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser, "about:blank");
  BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser).then(() => {
    gBrowser.loadURI(TESTROOT + "amosigned.xpi");
  });
}

function allow_blocked(installInfo) {
  ok(true, "Seen blocked");
  return false;
}

function finish_test(count) {
  is(count, 0, "No add-ons should have been installed");

  Services.perms.remove(makeURI("http://example.org"), "install");
  Services.prefs.clearUserPref("xpinstall.whitelist.directRequest");

  gBrowser.removeCurrentTab();
  Harness.finish();
}
