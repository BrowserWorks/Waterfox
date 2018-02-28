// ----------------------------------------------------------------------------
// Test whether an install succeeds when authentication is required
// This verifies bug 312473
function test() {
  // Turn off the authentication dialog blocking for this test.
  Services.prefs.setBoolPref("network.auth.non-web-content-triggered-resources-http-auth-allow", true);

  Harness.authenticationCallback = get_auth_info;
  Harness.downloadFailedCallback = download_failed;
  Harness.installEndedCallback = install_ended;
  Harness.installsCompletedCallback = finish_test;
  Harness.setup();

  var prefs = Cc["@mozilla.org/preferences-service;1"].
                        getService(Ci.nsIPrefBranch);
  prefs.setIntPref("network.auth.subresource-http-auth-allow", 2);

  var pm = Services.perms;
  pm.add(makeURI("http://example.com/"), "install", pm.ALLOW_ACTION);

  var triggers = encodeURIComponent(JSON.stringify({
    "Unsigned XPI": TESTROOT + "authRedirect.sjs?" + TESTROOT + "amosigned.xpi"
  }));
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.loadURI(TESTROOT + "installtrigger.html?" + triggers);
}

function get_auth_info() {
  return [ "testuser", "testpass" ];
}

function download_failed(install) {
  ok(false, "Install should not have failed");
}

function install_ended(install, addon) {
  install.cancel();
}

function finish_test(count) {
  is(count, 1, "1 Add-on should have been successfully installed");
  var authMgr = Components.classes["@mozilla.org/network/http-auth-manager;1"]
                          .getService(Components.interfaces.nsIHttpAuthManager);
  authMgr.clearAll();

  Services.perms.remove(makeURI("http://example.com"), "install");

  Services.prefs.clearUserPref("network.auth.non-web-content-triggered-resources-http-auth-allow");

  gBrowser.removeCurrentTab();
  Harness.finish();
}
