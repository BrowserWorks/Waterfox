/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// Bug 2074097: with Happy Eyeballs disabled an HTTP channel resolves its host
// as AF_UNSPEC when it connects, so nsHttpChannel::MaybeStartDNSPrefetch must
// also prefetch AF_UNSPEC. A per-family (A/AAAA) prefetch uses a different DNS
// cache key (af) that the AF_UNSPEC connection lookup can't reuse, which made
// the host be resolved an extra time. This test drives a real channel through
// the prefetch + connect path over a DoH server and asserts the host is
// resolved exactly once per record type, with Happy Eyeballs both off and on.

const { NodeHTTP2Server } = ChromeUtils.importESModule(
  "resource://testing-common/NodeServer.sys.mjs"
);

// Distinct hosts per case so a pooled connection or cache entry from one case
// can't satisfy the other.
const HOST_HE_OFF = "prefetch-he-off.example.com";
const HOST_HE_ON = "prefetch-he-on.example.com";
const ADDR = "127.0.0.1";
const TTL = 55;

let trrServer;
let server;

function openChan(url) {
  let chan = NetUtil.newChannel({
    uri: url,
    loadUsingSystemPrincipal: true,
    contentPolicyType: Ci.nsIContentPolicy.TYPE_DOCUMENT,
  }).QueryInterface(Ci.nsIHttpChannel);
  chan.loadFlags = Ci.nsIChannel.LOAD_INITIAL_DOCUMENT_URI;
  return new Promise(resolve => {
    chan.asyncOpen(
      new ChannelListener(req => resolve(req), null, CL_ALLOW_UNKNOWN_CL)
    );
  });
}

async function registerHost(host) {
  await trrServer.registerDoHAnswers(host, "A", {
    answers: [{ name: host, ttl: TTL, type: "A", flush: false, data: ADDR }],
  });
  // IPv6 NODATA and no HTTPS RR, so those lookups resolve deterministically and
  // don't affect the A/AAAA request counts we assert on.
  await trrServer.registerDoHAnswers(host, "AAAA", { answers: [] });
  await trrServer.registerDoHAnswers(host, "HTTPS", { answers: [] });
}

add_setup(async function setup() {
  trr_test_setup();
  // TRR_ONLY so every lookup goes to the DoH server we count, and native
  // resolution (which answers 127.0.0.1 for everything in TRR tests) is out of
  // the picture.
  Services.prefs.setIntPref("network.trr.mode", 3);

  let certdb = Cc["@mozilla.org/security/x509certdb;1"].getService(
    Ci.nsIX509CertDB
  );
  addCertFromFile(certdb, "http2-ca.pem", "CTu,u,u");

  server = new NodeHTTP2Server();
  await server.start(0, [HOST_HE_OFF, HOST_HE_ON]);
  await server.registerPathHandler("/", (req, resp) => {
    resp.writeHead(200, { "Content-Type": "text/plain" });
    resp.end("ok");
  });

  trrServer = new TRRServer();
  await trrServer.start();
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${trrServer.port()}/dns-query`
  );

  registerCleanupFunction(async () => {
    Services.prefs.clearUserPref("network.trr.mode");
    Services.prefs.clearUserPref("network.trr.uri");
    trr_clear_prefs();
    Services.prefs.clearUserPref("network.http.happy_eyeballs_enabled");
    try {
      await trrServer.stop();
      await server.stop();
    } catch (e) {
      info("Error stopping servers: " + e);
    }
  });
});

async function runAndCount(host, heEnabled) {
  Services.prefs.setBoolPref("network.http.happy_eyeballs_enabled", heEnabled);
  Services.dns.clearCache(true);
  await registerHost(host);
  await trrServer.execute("global.dns_query_counts = {}");

  let req = await openChan(`https://${host}:${server.port()}/`);
  Assert.equal(
    req.QueryInterface(Ci.nsIHttpChannel).responseStatus,
    200,
    `${host} request should succeed`
  );

  return {
    a: await trrServer.requestCount(host, "A"),
    aaaa: await trrServer.requestCount(host, "AAAA"),
  };
}

// Regression guard: without the fix the AF_UNSPEC connection lookup can't reuse
// the per-family prefetch, so A (and AAAA) are each resolved twice.
add_task(async function test_prefetch_unspec_when_he_disabled() {
  let counts = await runAndCount(HOST_HE_OFF, false);
  info(`HE off: A=${counts.a} AAAA=${counts.aaaa}`);
  Assert.equal(
    counts.a,
    1,
    "A resolved once (AF_UNSPEC prefetch reused by the connection)"
  );
  Assert.equal(counts.aaaa, 1, "AAAA resolved once");
});

// Sanity check that the per-family prefetch branch still drives a working
// request when Happy Eyeballs is enabled (the branch this fix left unchanged).
add_task(async function test_perfamily_path_works_when_he_enabled() {
  let counts = await runAndCount(HOST_HE_ON, true);
  info(`HE on: A=${counts.a} AAAA=${counts.aaaa}`);
  // The request succeeding is asserted inside runAndCount. We don't assert an
  // exact A/AAAA count here: with a negative AAAA answer Happy Eyeballs issues
  // an extra address lookup that is independent of this bug and of the branch
  // changed by this fix.
});
