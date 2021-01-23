/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

// Tests handling of certificates issued by Symantec. If such certificates were
// issued by an Apple or Google intermediate, they are whitelisted. Otherwise,
// If they have a notBefore before 1 June 2016, they should be distrusted, while
// those from that date or later emit a warning to the console.

function shouldBeImminentlyDistrusted(aTransportSecurityInfo) {
  let isDistrust =
    aTransportSecurityInfo.securityState &
    Ci.nsIWebProgressListener.STATE_CERT_DISTRUST_IMMINENT;
  Assert.ok(isDistrust, "This host should be imminently distrusted");
}

do_get_profile();

const certDB = Cc["@mozilla.org/security/x509certdb;1"].getService(
  Ci.nsIX509CertDB
);

add_tls_server_setup(
  "SanctionsTestServer",
  "test_sanctions",
  /* Don't try to load non-existent test-ca.pem */ false
);

addCertFromFile(certDB, "test_sanctions/symantec-test-ca.pem", "CTu,u,u");

// Add the necessary intermediates. This is important because the test server,
// though it will attempt to send along an intermediate, isn't able to reliably
// pick between the intermediate-other-crossigned and intermediate-other.
add_test(function() {
  addCertFromFile(
    certDB,
    "test_sanctions/symantec-intermediate-whitelisted.pem",
    ",,"
  );
  addCertFromFile(
    certDB,
    "test_sanctions/symantec-intermediate-other.pem",
    ",,"
  );
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* DistrustedCAPolicy::DistrustSymantecRoots */ 0b01
  );
  run_next_test();
});

// Not-whitelisted certs after the cutoff are to be distrusted
add_connection_test(
  "symantec-not-whitelisted-after-cutoff.example.com",
  PRErrorCodeSuccess,
  null,
  shouldBeImminentlyDistrusted
);

// Not whitelisted certs before the cutoff are to be distrusted
add_connection_test(
  "symantec-not-whitelisted-before-cutoff.example.com",
  MOZILLA_PKIX_ERROR_ADDITIONAL_POLICY_CONSTRAINT_FAILED,
  null,
  null
);

// Enable the Firefox 63 total distrust; before or after cutoff should now all
// behave the same. This will be made the default in Bug 1460062.
add_test(function() {
  clearSessionCache();
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* DistrustedCAPolicy::DistrustSymantecRootsRegardlessOfDate */ 0b10
  );
  run_next_test();
});

add_connection_test(
  "symantec-not-whitelisted-before-cutoff.example.com",
  MOZILLA_PKIX_ERROR_ADDITIONAL_POLICY_CONSTRAINT_FAILED,
  null,
  null
);

add_connection_test(
  "symantec-not-whitelisted-after-cutoff.example.com",
  MOZILLA_PKIX_ERROR_ADDITIONAL_POLICY_CONSTRAINT_FAILED,
  null,
  null
);

// Disable the distrust, should be back to the console warning
add_test(function() {
  clearSessionCache();
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* DistrustedCAPolicy::Permit */ 0b00
  );
  run_next_test();
});

add_connection_test(
  "symantec-not-whitelisted-before-cutoff.example.com",
  PRErrorCodeSuccess,
  null,
  shouldBeImminentlyDistrusted
);

add_test(function() {
  clearSessionCache();
  Services.prefs.clearUserPref("security.pki.distrust_ca_policy");
  run_next_test();
});

// Add a cross-signed intermediate into the database, and ensure we still get
// the expected error.
add_test(function() {
  addCertFromFile(
    certDB,
    "test_sanctions/symantec-intermediate-other-crossigned.pem",
    ",,"
  );
  run_next_test();
});

add_connection_test(
  "symantec-not-whitelisted-before-cutoff.example.com",
  MOZILLA_PKIX_ERROR_ADDITIONAL_POLICY_CONSTRAINT_FAILED,
  null,
  null
);

// Load the wildcard *.google.com cert and its intermediate, then verify
// it at a reasonable time and make sure the whitelists work
add_task(async function() {
  addCertFromFile(
    certDB,
    "test_sanctions/symantec-real-google-g2-intermediate.pem",
    ",,"
  );
  let whitelistedCert = constructCertFromFile(
    "test_sanctions/symantec-real-googlecom.pem"
  );

  // Since we don't want to actually try to fetch OCSP for this certificate,
  // (as an external fetch is bad in the tests), disable OCSP first.
  Services.prefs.setIntPref("security.OCSP.enabled", 0);

  // Try with the policy for 60
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* DistrustedCAPolicy::DistrustSymantecRoots */ 0b01
  );

  // (new Date("2018-02-16")).getTime() / 1000
  const VALIDATION_TIME = 1518739200;

  await checkCertErrorGenericAtTime(
    certDB,
    whitelistedCert,
    PRErrorCodeSuccess,
    certificateUsageSSLServer,
    VALIDATION_TIME
  );

  // Try with the policy for 63
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* DistrustedCAPolicy::DistrustSymantecRootsRegardlessOfDate */ 0b10
  );

  await checkCertErrorGenericAtTime(
    certDB,
    whitelistedCert,
    PRErrorCodeSuccess,
    certificateUsageSSLServer,
    VALIDATION_TIME
  );
});

// Check invalid policy values; should default to current default
add_test(function() {
  clearSessionCache();
  Services.prefs.setIntPref(
    "security.pki.distrust_ca_policy",
    /* Larger than Max Value */ 0b1111
  );
  run_next_test();
});

add_connection_test(
  "symantec-not-whitelisted-before-cutoff.example.com",
  MOZILLA_PKIX_ERROR_ADDITIONAL_POLICY_CONSTRAINT_FAILED,
  null,
  null
);

add_connection_test(
  "symantec-not-whitelisted-after-cutoff.example.com",
  PRErrorCodeSuccess,
  null,
  shouldBeImminentlyDistrusted
);
