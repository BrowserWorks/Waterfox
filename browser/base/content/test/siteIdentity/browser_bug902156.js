/*
 * Description of the Tests for
 *  - Bug 902156: Persist "disable protection" option for Mixed Content Blocker
 *
 * 1. Navigate to the same domain via document.location
 *    - Load a html page which has mixed content
 *    - Control Center button to disable protection appears - we disable it
 *    - Load a new page from the same origin using document.location
 *    - Control Center button should not appear anymore!
 *
 * 2. Navigate to the same domain via simulateclick for a link on the page
 *    - Load a html page which has mixed content
 *    - Control Center button to disable protection appears - we disable it
 *    - Load a new page from the same origin simulating a click
 *    - Control Center button should not appear anymore!
 *
 * 3. Navigate to a differnet domain and show the content is still blocked
 *    - Load a different html page which has mixed content
 *    - Control Center button to disable protection should appear again because
 *      we navigated away from html page where we disabled the protection.
 *
 * Note, for all tests we set gHttpTestRoot to use 'https'.
 */

const PREF_ACTIVE = "security.mixed_content.block_active_content";

// We alternate for even and odd test cases to simulate different hosts
const HTTPS_TEST_ROOT_1 = getRootDirectory(gTestPath).replace("chrome://mochitests/content", "https://test1.example.com");
const HTTPS_TEST_ROOT_2 = getRootDirectory(gTestPath).replace("chrome://mochitests/content", "https://test2.example.com");

var origBlockActive;
var gTestBrowser = null;

registerCleanupFunction(function() {
  // Set preferences back to their original values
  Services.prefs.setBoolPref(PREF_ACTIVE, origBlockActive);
});

function cleanUpAfterTests() {
  gBrowser.removeCurrentTab();
  window.focus();
  finish();
}

// ------------------------ Test 1 ------------------------------

function test1A() {
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test1B);

  assertMixedContentBlockingState(gTestBrowser, {activeLoaded: false, activeBlocked: true, passiveLoaded: false});

  // Disable Mixed Content Protection for the page (and reload)
  let {gIdentityHandler} = gTestBrowser.ownerGlobal;
  gIdentityHandler.disableMixedContentProtection();
}

function test1B() {
  var expected = "Mixed Content Blocker disabled";
  BrowserTestUtils.waitForCondition(
    () => content.document.getElementById("mctestdiv").innerHTML == expected,
    "Error: Waited too long for mixed script to run in Test 1B").then(test1C);
}

function test1C() {
  var actual = content.document.getElementById("mctestdiv").innerHTML;
  is(actual, "Mixed Content Blocker disabled", "OK: Executed mixed script in Test 1C");

  // The Script loaded after we disabled the page, now we are going to reload the
  // page and see if our decision is persistent
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test1D);

  var url = HTTPS_TEST_ROOT_1 + "file_bug902156_2.html";
  gTestBrowser.loadURI(url);
}

function test1D() {
  // The Control Center button should appear but isMixedContentBlocked should be NOT true,
  // because our decision of disabling the mixed content blocker is persistent.
  assertMixedContentBlockingState(gTestBrowser, {activeLoaded: true, activeBlocked: false, passiveLoaded: false});

  var actual = content.document.getElementById("mctestdiv").innerHTML;
  is(actual, "Mixed Content Blocker disabled", "OK: Executed mixed script in Test 1D");

  // move on to Test 2
  test2();
}

// ------------------------ Test 2 ------------------------------

function test2() {
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test2A);
  var url = HTTPS_TEST_ROOT_2 + "file_bug902156_2.html";
  gTestBrowser.loadURI(url);
}

function test2A() {
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test2B);

  assertMixedContentBlockingState(gTestBrowser, {activeLoaded: false, activeBlocked: true, passiveLoaded: false});

  // Disable Mixed Content Protection for the page (and reload)
  let {gIdentityHandler} = gTestBrowser.ownerGlobal;
  gIdentityHandler.disableMixedContentProtection();
}

function test2B() {
  var expected = "Mixed Content Blocker disabled";
  BrowserTestUtils.waitForCondition(
    () => content.document.getElementById("mctestdiv").innerHTML == expected,
    "Error: Waited too long for mixed script to run in Test 2B").then(test2C);
}

function test2C() {
  var actual = content.document.getElementById("mctestdiv").innerHTML;
  is(actual, "Mixed Content Blocker disabled", "OK: Executed mixed script in Test 2C");

  // The Script loaded after we disabled the page, now we are going to reload the
  // page and see if our decision is persistent
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test2D);

  // reload the page using the provided link in the html file
  var mctestlink = content.document.getElementById("mctestlink");
  mctestlink.click();
}

function test2D() {
  // The Control Center button should appear but isMixedContentBlocked should be NOT true,
  // because our decision of disabling the mixed content blocker is persistent.
  assertMixedContentBlockingState(gTestBrowser, {activeLoaded: true, activeBlocked: false, passiveLoaded: false});

  var actual = content.document.getElementById("mctestdiv").innerHTML;
  is(actual, "Mixed Content Blocker disabled", "OK: Executed mixed script in Test 2D");

  // move on to Test 3
  test3();
}

// ------------------------ Test 3 ------------------------------

function test3() {
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test3A);
  var url = HTTPS_TEST_ROOT_1 + "file_bug902156_3.html";
  gTestBrowser.loadURI(url);
}

function test3A() {
  assertMixedContentBlockingState(gTestBrowser, {activeLoaded: false, activeBlocked: true, passiveLoaded: false});

  // We are done with tests, clean up
  cleanUpAfterTests();
}

// ------------------------------------------------------

function test() {
  // Performing async calls, e.g. 'onload', we have to wait till all of them finished
  waitForExplicitFinish();

  // Store original preferences so we can restore settings after testing
  origBlockActive = Services.prefs.getBoolPref(PREF_ACTIVE);

  Services.prefs.setBoolPref(PREF_ACTIVE, true);

  // Not really sure what this is doing
  var newTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.selectedTab = newTab;
  gTestBrowser = gBrowser.selectedBrowser;
  newTab.linkedBrowser.stop()

  // Starting Test Number 1:
  BrowserTestUtils.browserLoaded(gTestBrowser).then(test1A);
  var url = HTTPS_TEST_ROOT_1 + "file_bug902156_1.html";
  gTestBrowser.loadURI(url);
}
