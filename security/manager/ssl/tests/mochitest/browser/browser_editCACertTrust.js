// Any copyright is dedicated to the Public Domain.
// http://creativecommons.org/publicdomain/zero/1.0/
"use strict";

// Tests that the UI for editing the trust of a CA certificate correctly
// reflects trust in the cert DB, and correctly updates trust in the cert DB
// when requested.

var gCertDB = Cc["@mozilla.org/security/x509certdb;1"]
                .getService(Ci.nsIX509CertDB);

/**
 * The cert we're editing the trust of.
 * @type nsIX509Cert
 */
var gCert;

/**
 * Opens the cert trust editing dialog.
 *
 * @returns {Promise}
 *          A promise that resolves when the dialog has finished loading with
 *          the window of the opened dialog.
 */
function openEditCertTrustDialog() {
  let win = window.openDialog("chrome://pippki/content/editcacert.xul", "", "",
                              gCert);
  return new Promise((resolve, reject) => {
    win.addEventListener("load", function onLoad() {
      win.removeEventListener("load", onLoad);
      resolve(win);
    });
  });
}

add_task(function* setup() {
  // Initially trust ca.pem for SSL, but not e-mail or object signing.
  gCert = yield readCertificate("ca.pem", "CT,,");
  Assert.ok(gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                  Ci.nsIX509CertDB.TRUSTED_SSL),
            "Sanity check: ca.pem should be trusted for SSL");
  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                   Ci.nsIX509CertDB.TRUSTED_EMAIL),
            "Sanity check: ca.pem should not be trusted for e-mail");
  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                   Ci.nsIX509CertDB.TRUSTED_OBJSIGN),
            "Sanity check: ca.pem should not be trusted for object signing");
});

// Tests the following:
// 1. The checkboxes correctly reflect the trust set in setup().
// 2. Accepting the dialog after flipping some of the checkboxes results in the
//    correct trust being set in the cert DB.
add_task(function* testAcceptDialog() {
  let win = yield openEditCertTrustDialog();

  let sslCheckbox = win.document.getElementById("trustSSL");
  let emailCheckbox = win.document.getElementById("trustEmail");
  let objSignCheckbox = win.document.getElementById("trustObjSign");
  Assert.ok(sslCheckbox.checked,
            "Cert should be trusted for SSL in UI");
  Assert.ok(!emailCheckbox.checked,
            "Cert should not be trusted for e-mail in UI");
  Assert.ok(!objSignCheckbox.checked,
            "Cert should not be trusted for object signing in UI");

  sslCheckbox.checked = false;
  emailCheckbox.checked = true;

  info("Accepting dialog");
  win.document.getElementById("editCaCert").acceptDialog();
  yield BrowserTestUtils.windowClosed(win);

  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                   Ci.nsIX509CertDB.TRUSTED_SSL),
            "Cert should no longer be trusted for SSL");
  Assert.ok(gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                  Ci.nsIX509CertDB.TRUSTED_EMAIL),
            "Cert should now be trusted for e-mail");
  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                   Ci.nsIX509CertDB.TRUSTED_OBJSIGN),
            "Cert should still not be trusted for object signing");
});

// Tests the following:
// 1. The checkboxes correctly reflect the trust set in testAcceptDialog().
// 2. Canceling the dialog even after flipping the checkboxes doesn't result in
//    a change of trust in the cert DB.
add_task(function* testCancelDialog() {
  let win = yield openEditCertTrustDialog();

  let sslCheckbox = win.document.getElementById("trustSSL");
  let emailCheckbox = win.document.getElementById("trustEmail");
  let objSignCheckbox = win.document.getElementById("trustObjSign");
  Assert.ok(!sslCheckbox.checked,
            "Cert should not be trusted for SSL in UI");
  Assert.ok(emailCheckbox.checked,
            "Cert should be trusted for e-mail in UI");
  Assert.ok(!objSignCheckbox.checked,
            "Cert should not be trusted for object signing in UI");

  sslCheckbox.checked = true;
  emailCheckbox.checked = false;
  objSignCheckbox.checked = true;

  info("Canceling dialog");
  win.document.getElementById("editCaCert").cancelDialog();
  yield BrowserTestUtils.windowClosed(win);

  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                  Ci.nsIX509CertDB.TRUSTED_SSL),
            "Cert should still not be trusted for SSL");
  Assert.ok(gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                  Ci.nsIX509CertDB.TRUSTED_EMAIL),
            "Cert should still be trusted for e-mail");
  Assert.ok(!gCertDB.isCertTrusted(gCert, Ci.nsIX509Cert.CA_CERT,
                                   Ci.nsIX509CertDB.TRUSTED_OBJSIGN),
            "Cert should still not be trusted for object signing");
});
