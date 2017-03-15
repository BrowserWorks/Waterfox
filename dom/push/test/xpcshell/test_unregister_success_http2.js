/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

'use strict';

Cu.import("resource://gre/modules/Services.jsm");

const {PushDB, PushService, PushServiceHttp2} = serviceExports;

var prefs;
var tlsProfile;
var pushEnabled;
var pushConnectionEnabled;

var serverPort = -1;

function run_test() {
  serverPort = getTestServerPort();

  do_get_profile();
  prefs = Cc["@mozilla.org/preferences-service;1"].getService(Ci.nsIPrefBranch);

  tlsProfile = prefs.getBoolPref("network.http.spdy.enforce-tls-profile");
  pushEnabled = prefs.getBoolPref("dom.push.enabled");
  pushConnectionEnabled = prefs.getBoolPref("dom.push.connection.enabled");

  // Set to allow the cert presented by our H2 server
  var oldPref = prefs.getIntPref("network.http.speculative-parallel-limit");
  prefs.setIntPref("network.http.speculative-parallel-limit", 0);
  prefs.setBoolPref("network.http.spdy.enforce-tls-profile", false);
  prefs.setBoolPref("dom.push.enabled", true);
  prefs.setBoolPref("dom.push.connection.enabled", true);

  addCertOverride("localhost", serverPort,
                  Ci.nsICertOverrideService.ERROR_UNTRUSTED |
                  Ci.nsICertOverrideService.ERROR_MISMATCH |
                  Ci.nsICertOverrideService.ERROR_TIME);

  prefs.setIntPref("network.http.speculative-parallel-limit", oldPref);

  run_next_test();
}

add_task(function* test_pushUnsubscriptionSuccess() {
  let db = PushServiceHttp2.newPushDB();
  do_register_cleanup(() => {
    return db.drop().then(_ => db.close());
  });

  var serverURL = "https://localhost:" + serverPort;

  yield db.put({
    subscriptionUri: serverURL + '/subscriptionUnsubscriptionSuccess',
    pushEndpoint: serverURL + '/pushEndpointUnsubscriptionSuccess',
    pushReceiptEndpoint: serverURL + '/receiptPushEndpointUnsubscriptionSuccess',
    scope: 'https://example.com/page/unregister-success',
    originAttributes: ChromeUtils.originAttributesToSuffix(
      { appId: Ci.nsIScriptSecurityManager.NO_APP_ID, inIsolatedMozBrowser: false }),
    quota: Infinity,
  });

  PushService.init({
    serverURI: serverURL,
    db
  });

  yield PushService.unregister({
    scope: 'https://example.com/page/unregister-success',
    originAttributes: ChromeUtils.originAttributesToSuffix(
      { appId: Ci.nsIScriptSecurityManager.NO_APP_ID, inIsolatedMozBrowser: false }),
  });
  let record = yield db.getByKeyID(serverURL + '/subscriptionUnsubscriptionSuccess');
  ok(!record, 'Unregister did not remove record');

});

add_task(function* test_complete() {
  prefs.setBoolPref("network.http.spdy.enforce-tls-profile", tlsProfile);
  prefs.setBoolPref("dom.push.enabled", pushEnabled);
  prefs.setBoolPref("dom.push.connection.enabled", pushConnectionEnabled);
});
