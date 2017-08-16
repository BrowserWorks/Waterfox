// ----------------------------------------------------------------------------
// Tests that navigating away from the initiating page during the install
// doesn't break the install.
// This verifies bug 473060
function test() {
  Harness.downloadProgressCallback = download_progress;
  Harness.installEndedCallback = install_ended;
  Harness.installsCompletedCallback = finish_test;
  Harness.setup();

  var pm = Services.perms;
  pm.add(makeURI("http://example.com/"), "install", pm.ALLOW_ACTION);

  var triggers = encodeURIComponent(JSON.stringify({
    "Unsigned XPI": TESTROOT + "amosigned.xpi"
  }));
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.loadURI(TESTROOT + "installtrigger.html?" + triggers);
}

function download_progress(addon, value, maxValue) {
  gBrowser.loadURI(TESTROOT + "enabled.html");
}

function install_ended(install, addon) {
  install.cancel();
}

function finish_test(count) {
  is(count, 1, "1 Add-on should have been successfully installed");

  Services.perms.remove(makeURI("http://example.com"), "install");

  gBrowser.removeCurrentTab();
  Harness.finish();
}
