/*
 * Bug 1253771 - check mixed content blocking in combination with overriden certificates
 */

"use strict";

const MIXED_CONTENT_URL = "https://self-signed.example.com/browser/browser/base/content/test/general/test-mixedcontent-securityerrors.html";

function getConnectionState() {
  return document.getElementById("identity-popup").getAttribute("connection");
}

function getPopupContentVerifier() {
  return document.getElementById("identity-popup-content-verifier");
}

function getConnectionIcon() {
  return window.getComputedStyle(document.getElementById("connection-icon")).listStyleImage;
}

function checkIdentityPopup(icon) {
  gIdentityHandler.refreshIdentityPopup();
  is(getConnectionIcon(), `url("chrome://browser/skin/${icon}")`);
  is(getConnectionState(), "secure-cert-user-overridden");
  isnot(getPopupContentVerifier().style.display, "none", "Overridden certificate warning is shown");
  ok(getPopupContentVerifier().textContent.includes("security exception"), "Text shows overridden certificate warning.");
}

add_task(function* () {
  yield BrowserTestUtils.openNewForegroundTab(gBrowser);

  // check that a warning is shown when loading a page with mixed content and an overridden certificate
  yield loadBadCertPage(MIXED_CONTENT_URL);
  checkIdentityPopup("connection-mixed-passive-loaded.svg#icon");

  // check that the crossed out icon is shown when disabling mixed content protection
  gIdentityHandler.disableMixedContentProtection();
  yield BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser);

  checkIdentityPopup("connection-mixed-active-loaded.svg#icon");

  // check that a warning is shown even without mixed content
  yield BrowserTestUtils.loadURI(gBrowser.selectedBrowser, "https://self-signed.example.com");
  yield BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser);
  checkIdentityPopup("connection-mixed-passive-loaded.svg#icon");

  // remove cert exception
  let certOverrideService = Cc["@mozilla.org/security/certoverride;1"]
                              .getService(Ci.nsICertOverrideService);
  certOverrideService.clearValidityOverride("self-signed.example.com", -1);

  yield BrowserTestUtils.removeTab(gBrowser.selectedTab);
});

