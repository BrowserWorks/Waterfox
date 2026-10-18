/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// The host resolves to an IPv6 and an IPv4 address, but the IPv6 address is
// unusable: TCP connects to it are refused and UDP sends to it keep returning
// EAGAIN while the socket still polls as writable. A resumed (0-RTT) HTTP/3
// session to the IPv6 address must not wedge requests forever; they should
// complete over another route.
//
// Run with and without Happy Eyeballs.

"use strict";

var { setTimeout, clearTimeout } = ChromeUtils.importESModule(
  "resource://gre/modules/Timer.sys.mjs"
);

const { NodeHTTP2Server, HTTP3Server } = ChromeUtils.importESModule(
  "resource://testing-common/NodeServer.sys.mjs"
);

const override = Cc["@mozilla.org/network/native-dns-override;1"].getService(
  Ci.nsINativeDNSResolverOverride
);

const mockController = Cc[
  "@mozilla.org/network/mock-network-controller;1"
].getService(Ci.nsIMockNetworkLayerController);

const HOST = "foo.example.com";
const REQUEST_TIMEOUT_MS = 10000;

let h3Server;
let h2Server;
let h3Port;
let h2Port;

add_setup(async function () {
  let h3ServerPath = Services.env.get("MOZ_HTTP3_SERVER_PATH");
  let h3DBPath = Services.env.get("MOZ_HTTP3_CERT_DB_PATH");

  let certdb = Cc["@mozilla.org/security/x509certdb;1"].getService(
    Ci.nsIX509CertDB
  );
  addCertFromFile(certdb, "http2-ca.pem", "CTu,u,u");

  Services.prefs.setBoolPref("network.http.http3.enable", true);
  Services.prefs.setBoolPref("network.http.http3.enable_0rtt", true);
  Services.prefs.setBoolPref("network.socket.attach_mock_network_layer", true);
  Services.prefs.setBoolPref("network.dns.disableIPv6", false);
  Services.prefs.setIntPref("network.http.speculative-parallel-limit", 0);
  Services.prefs.setIntPref("network.http.http3.0rtt_timeout", 1000);
  // Give the second request time to join the HTTP/3 connection before the
  // first request's TCP backup takes it away.
  Services.prefs.setIntPref("network.http.http3.backup_timer_delay", 1000);

  h3Server = new HTTP3Server();
  await h3Server.start(h3ServerPath, h3DBPath);
  h3Port = h3Server.port();

  h2Server = new NodeHTTP2Server();
  await h2Server.start();
  h2Port = h2Server.port();
  for (let path of ["/", "/first", "/second"]) {
    await h2Server.registerPathHandler(path, (_req, resp) => {
      resp.writeHead(200, { "content-type": "text/plain" });
      resp.end("ok");
    });
  }

  Services.prefs.setCharPref(
    "network.http.http3.alt-svc-mapping-for-testing",
    `${HOST};h3=:${h3Port}`
  );

  registerCleanupFunction(async () => {
    Services.prefs.clearUserPref("network.http.happy_eyeballs_enabled");
    Services.prefs.clearUserPref("network.http.http3.enable");
    Services.prefs.clearUserPref("network.http.http3.enable_0rtt");
    Services.prefs.clearUserPref("network.socket.attach_mock_network_layer");
    Services.prefs.clearUserPref("network.dns.disableIPv6");
    Services.prefs.clearUserPref("network.http.speculative-parallel-limit");
    Services.prefs.clearUserPref("network.http.http3.0rtt_timeout");
    Services.prefs.clearUserPref("network.http.http3.backup_timer_delay");
    Services.prefs.clearUserPref(
      "network.http.http3.alt-svc-mapping-for-testing"
    );
    override.clearOverrides();
    clearMocks();
    await h3Server.stop();
    await h2Server.stop();
  });
});

function clearMocks() {
  mockController.clearBlockedTCPConnect();
  mockController.clearWouldBlockUDPAddr();
}

async function resetState() {
  clearMocks();
  Services.obs.notifyObservers(null, "net:cancel-all-connections");
  Services.obs.notifyObservers(null, "browser:purge-session-history");
  let tokenCache = Cc["@mozilla.org/network/ssl-tokens-cache;1"].getService(
    Ci.nsISSLTokensCache
  );
  await tokenCache.asyncClearSSLExternalAndInternalSessionCache();
  Services.dns.clearCache(true);
  override.clearOverrides();
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 1000));
}

function openChan(path = "/") {
  let chan = NetUtil.newChannel({
    uri: `https://${HOST}:${h2Port}${path}`,
    loadUsingSystemPrincipal: true,
  }).QueryInterface(Ci.nsIHttpChannel);
  chan.loadFlags = Ci.nsIChannel.LOAD_INITIAL_DOCUMENT_URI;
  let promise = new Promise(resolve => {
    chan.asyncOpen({
      onStartRequest() {},
      onDataAvailable(_req, stream, _offset, count) {
        read_stream(stream, count);
      },
      onStopRequest(req, status) {
        let httpChan = req.QueryInterface(Ci.nsIHttpChannel);
        resolve({
          status,
          responseStatus: Components.isSuccessCode(status)
            ? httpChan.responseStatus
            : 0,
          protocol: Components.isSuccessCode(status)
            ? httpChan.protocolVersion
            : "",
        });
      },
      QueryInterface: ChromeUtils.generateQI(["nsIStreamListener"]),
    });
  });
  return { chan, promise };
}

async function openChanWithTimeout(path) {
  let { chan, promise } = openChan(path);
  let timer;
  let timeout = new Promise(resolve => {
    // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
    timer = setTimeout(() => resolve(null), REQUEST_TIMEOUT_MS);
  });
  let result = await Promise.race([promise, timeout]);
  clearTimeout(timer);
  if (!result) {
    chan.cancel(Cr.NS_BINDING_ABORTED);
    await promise;
  }
  return result;
}

async function primeSessionTicket() {
  // Only the IPv4 address is known and TCP is blocked, so this request uses
  // HTTP/3 over IPv4 and leaves a session ticket for 0-RTT.
  override.addIPOverride(HOST, "127.0.0.1");
  mockController.blockTCPConnect(
    mockController.createScriptableNetAddr("127.0.0.1", h2Port)
  );

  let { promise } = openChan();
  let r = await promise;
  Assert.equal(r.responseStatus, 200, "Priming request should succeed");
  Assert.equal(r.protocol, "h3", "Priming request should use HTTP/3");

  // Let the NewSessionTicket arrive before tearing the connection down.
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 1000));
  Services.obs.notifyObservers(null, "net:cancel-all-connections");
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 1000));

  mockController.clearBlockedTCPConnect();
  Services.dns.clearCache(true);
  override.clearOverrides();
}

function breakIPv6() {
  override.addIPOverride(HOST, "::1");
  override.addIPOverride(HOST, "127.0.0.1");
  mockController.blockTCPConnect(
    mockController.createScriptableNetAddr("::1", h2Port)
  );
  mockController.wouldBlockUDPAddrIO(
    mockController.createScriptableNetAddr("::1", h3Port)
  );
}

async function runScenario(heEnabled) {
  Services.prefs.setBoolPref("network.http.happy_eyeballs_enabled", heEnabled);
  await resetState();
  await primeSessionTicket();
  breakIPv6();

  // The first request sets up the resumed HTTP/3 connection. The second one
  // starts while that connection is already active, so it is dispatched onto
  // it directly, like the requests that hung in the original report.
  let first = openChanWithTimeout("/first");
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 300));
  let second = openChanWithTimeout("/second");

  checkResult(await first, "first", heEnabled);
  checkResult(await second, "second", heEnabled);

  await resetState();
}

function checkResult(r, name, heEnabled) {
  Assert.ok(
    r,
    `The ${name} request should not hang when IPv6 sends would block (HE=${heEnabled})`
  );
  if (r) {
    Assert.ok(
      Components.isSuccessCode(r.status),
      `The ${name} request should succeed (HE=${heEnabled}), status=0x${r.status.toString(16)}`
    );
    Assert.equal(r.responseStatus, 200, "Response status should be 200");
  }
}

add_task(async function test_ipv6_would_block_with_happy_eyeballs() {
  await runScenario(true);
});

add_task(async function test_ipv6_would_block_without_happy_eyeballs() {
  await runScenario(false);
});
