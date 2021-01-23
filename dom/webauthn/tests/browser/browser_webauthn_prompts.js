/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const TEST_URL = "https://example.com/";

function promiseNotification(id) {
  return new Promise(resolve => {
    PopupNotifications.panel.addEventListener("popupshown", function shown() {
      let notification = PopupNotifications.getNotification(id);
      if (notification) {
        ok(true, `${id} prompt visible`);
        PopupNotifications.panel.removeEventListener("popupshown", shown);
        resolve();
      }
    });
  });
}

let expectAbortError = expectError("Abort");

function verifyAnonymizedCertificate(result) {
  let { attObj, rawId } = result;
  return webAuthnDecodeCBORAttestation(attObj).then(({ fmt, attStmt }) => {
    is("none", fmt, "Is a None Attestation");
    is("object", typeof attStmt, "attStmt is a map");
    is(0, Object.keys(attStmt).length, "attStmt is empty");
  });
}

function verifyDirectCertificate(result) {
  let { attObj, rawId } = result;
  return webAuthnDecodeCBORAttestation(attObj).then(({ fmt, attStmt }) => {
    is("fido-u2f", fmt, "Is a FIDO U2F Attestation");
    is("object", typeof attStmt, "attStmt is a map");
    ok(attStmt.hasOwnProperty("x5c"), "attStmt.x5c exists");
    ok(attStmt.hasOwnProperty("sig"), "attStmt.sig exists");
  });
}

add_task(async function test_setup_usbtoken() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["security.webauth.u2f", false],
      ["security.webauth.webauthn", true],
      ["security.webauth.webauthn_enable_softtoken", false],
      ["security.webauth.webauthn_enable_android_fido2", false],
      ["security.webauth.webauthn_enable_usbtoken", true],
    ],
  });
});

add_task(async function test_register() {
  // Open a new tab.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_URL);

  // Request a new credential and wait for the prompt.
  let active = true;
  let request = promiseWebAuthnMakeCredential(tab, "indirect", {})
    .then(arrivingHereIsBad)
    .catch(expectAbortError)
    .then(() => (active = false));
  await promiseNotification("webauthn-prompt-register");

  // Cancel the request.
  ok(active, "request should still be active");
  PopupNotifications.panel.firstElementChild.button.click();
  await request;

  // Close tab.
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function test_sign() {
  // Open a new tab.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_URL);

  // Request a new assertion and wait for the prompt.
  let active = true;
  let request = promiseWebAuthnGetAssertion(tab)
    .then(arrivingHereIsBad)
    .catch(expectAbortError)
    .then(() => (active = false));
  await promiseNotification("webauthn-prompt-sign");

  // Cancel the request.
  ok(active, "request should still be active");
  PopupNotifications.panel.firstElementChild.button.click();
  await request;

  // Close tab.
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function test_register_direct_cancel() {
  // Open a new tab.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_URL);

  // Request a new credential with direct attestation and wait for the prompt.
  let active = true;
  let promise = promiseWebAuthnMakeCredential(tab, "direct", {})
    .then(arrivingHereIsBad)
    .catch(expectAbortError)
    .then(() => (active = false));
  await promiseNotification("webauthn-prompt-register-direct");

  // Cancel the request.
  ok(active, "request should still be active");
  PopupNotifications.panel.firstElementChild.secondaryButton.click();
  await promise;

  // Close tab.
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function test_setup_softtoken() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["security.webauth.u2f", false],
      ["security.webauth.webauthn", true],
      ["security.webauth.webauthn_enable_softtoken", true],
      ["security.webauth.webauthn_enable_usbtoken", false],
    ],
  });
});

add_task(async function test_register_direct_proceed() {
  // Open a new tab.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_URL);

  // Request a new credential with direct attestation and wait for the prompt.
  let request = promiseWebAuthnMakeCredential(tab, "direct", {});
  await promiseNotification("webauthn-prompt-register-direct");

  // Proceed.
  PopupNotifications.panel.firstElementChild.button.click();

  // Ensure we got "direct" attestation.
  await request.then(verifyDirectCertificate);

  // Close tab.
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function test_register_direct_proceed_anon() {
  // Open a new tab.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_URL);

  // Request a new credential with direct attestation and wait for the prompt.
  let request = promiseWebAuthnMakeCredential(tab, "direct", {});
  await promiseNotification("webauthn-prompt-register-direct");

  // Check "anonymize anyway" and proceed.
  PopupNotifications.panel.firstElementChild.checkbox.checked = true;
  PopupNotifications.panel.firstElementChild.button.click();

  // Ensure we got "none" attestation.
  await request.then(verifyAnonymizedCertificate);

  // Close tab.
  await BrowserTestUtils.removeTab(tab);
});
