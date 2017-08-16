// ----------------------------------------------------------------------------
// Test whether an install fails when the xpi is corrupt.
function test() {
  Harness.downloadFailedCallback = download_failed;
  Harness.installsCompletedCallback = finish_test;
  Harness.finalContentEvent = "InstallComplete";
  Harness.setup();

  var pm = Services.perms;
  pm.add(makeURI("http://example.com/"), "install", pm.ALLOW_ACTION);

  var triggers = encodeURIComponent(JSON.stringify({
    "Corrupt XPI": TESTROOT + "corrupt.xpi"
  }));
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.loadURI(TESTROOT + "installtrigger.html?" + triggers);
}

function download_failed(install) {
  is(install.error, AddonManager.ERROR_CORRUPT_FILE, "Install should fail");
}

const finish_test = async function(count) {
  is(count, 0, "No add-ons should have been installed");
  Services.perms.remove(makeURI("http://example.com"), "install");

  const results = await ContentTask.spawn(gBrowser.selectedBrowser, null, () => {
    return {
      return: content.document.getElementById("return").textContent,
      status: content.document.getElementById("status").textContent,
    }
  })

  is(results.status, "-207", "Callback should have seen the failure");

  gBrowser.removeCurrentTab();
  Harness.finish();
};
