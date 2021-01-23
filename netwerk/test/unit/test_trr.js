"use strict";

const { HttpServer } = ChromeUtils.import("resource://testing-common/httpd.js");
const dns = Cc["@mozilla.org/network/dns-service;1"].getService(
  Ci.nsIDNSService
);
const { MockRegistrar } = ChromeUtils.import(
  "resource://testing-common/MockRegistrar.jsm"
);
const mainThread = Services.tm.currentThread;

const gDefaultPref = Services.prefs.getDefaultBranch("");

const defaultOriginAttributes = {};
let h2Port = null;

async function SetParentalControlEnabled(aEnabled) {
  let parentalControlsService = {
    parentalControlsEnabled: aEnabled,
    QueryInterface: ChromeUtils.generateQI([Ci.nsIParentalControlsService]),
  };
  let cid = MockRegistrar.register(
    "@mozilla.org/parental-controls-service;1",
    parentalControlsService
  );
  dns.reloadParentalControlEnabled();
  MockRegistrar.unregister(cid);
}

function setup() {
  dump("start!\n");

  let env = Cc["@mozilla.org/process/environment;1"].getService(
    Ci.nsIEnvironment
  );
  h2Port = env.get("MOZHTTP2_PORT");
  Assert.notEqual(h2Port, null);
  Assert.notEqual(h2Port, "");

  // Set to allow the cert presented by our H2 server
  do_get_profile();

  Services.prefs.setBoolPref("network.http.spdy.enabled", true);
  Services.prefs.setBoolPref("network.http.spdy.enabled.http2", true);
  // the TRR server is on 127.0.0.1
  Services.prefs.setCharPref("network.trr.bootstrapAddress", "127.0.0.1");

  // use the h2 server as DOH provider
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh`
  );
  // make all native resolve calls "secretly" resolve localhost instead
  Services.prefs.setBoolPref("network.dns.native-is-localhost", true);

  // 0 - off, 1 - reserved, 2 - TRR first, 3  - TRR only, 4 - reserved
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR first
  Services.prefs.setBoolPref("network.trr.wait-for-portal", false);
  // By default wait for all responses before notifying the listeners.
  Services.prefs.setBoolPref("network.trr.wait-for-A-and-AAAA", true);
  // don't confirm that TRR is working, just go!
  Services.prefs.setCharPref("network.trr.confirmationNS", "skip");
  // some tests rely on the cache not being cleared on pref change.
  // we specifically test that this works
  Services.prefs.setBoolPref("network.trr.clear-cache-on-pref-change", false);

  // The moz-http2 cert is for foo.example.com and is signed by http2-ca.pem
  // so add that cert to the trust list as a signing cert.  // the foo.example.com domain name.
  let certdb = Cc["@mozilla.org/security/x509certdb;1"].getService(
    Ci.nsIX509CertDB
  );
  addCertFromFile(certdb, "http2-ca.pem", "CTu,u,u");

  SetParentalControlEnabled(false);
}

setup();
registerCleanupFunction(() => {
  Services.prefs.clearUserPref("network.trr.mode");
  Services.prefs.clearUserPref("network.trr.uri");
  Services.prefs.clearUserPref("network.trr.credentials");
  Services.prefs.clearUserPref("network.trr.wait-for-portal");
  Services.prefs.clearUserPref("network.trr.allow-rfc1918");
  Services.prefs.clearUserPref("network.trr.useGET");
  Services.prefs.clearUserPref("network.trr.confirmationNS");
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");
  Services.prefs.clearUserPref("network.trr.blacklist-duration");
  Services.prefs.clearUserPref("network.trr.request_timeout_ms");
  Services.prefs.clearUserPref("network.trr.request_timeout_mode_trronly_ms");
  Services.prefs.clearUserPref("network.trr.disable-ECS");
  Services.prefs.clearUserPref("network.trr.early-AAAA");
  Services.prefs.clearUserPref("network.trr.skip-AAAA-when-not-supported");
  Services.prefs.clearUserPref("network.trr.wait-for-A-and-AAAA");
  Services.prefs.clearUserPref("network.trr.excluded-domains");
  Services.prefs.clearUserPref("network.trr.builtin-excluded-domains");
  Services.prefs.clearUserPref("network.trr.clear-cache-on-pref-change");
  Services.prefs.clearUserPref("captivedetect.canonicalURL");

  Services.prefs.clearUserPref("network.http.spdy.enabled");
  Services.prefs.clearUserPref("network.http.spdy.enabled.http2");
  Services.prefs.clearUserPref("network.dns.localDomains");
  Services.prefs.clearUserPref("network.dns.native-is-localhost");
  Services.prefs.clearUserPref(
    "network.trr.send_empty_accept-encoding_headers"
  );
});

// This is an IP that is local, so we don't crash when connecting to it,
// but also connecting to it fails, so we attempt to retry with regular DNS.
const BAD_IP = (() => {
  if (mozinfo.os == "linux" || mozinfo.os == "android") {
    return "127.9.9.9";
  }
  return "0.0.0.0";
})();

class DNSListener {
  constructor(
    name,
    expectedAnswer,
    expectedSuccess = true,
    delay,
    trrServer = "",
    expectEarlyFail = false,
    flags = 0
  ) {
    this.name = name;
    this.expectedAnswer = expectedAnswer;
    this.expectedSuccess = expectedSuccess;
    this.delay = delay;
    this.promise = new Promise(resolve => {
      this.resolve = resolve;
    });
    if (trrServer == "") {
      this.request = dns.asyncResolve(
        name,
        flags,
        this,
        mainThread,
        defaultOriginAttributes
      );
    } else {
      try {
        this.request = dns.asyncResolveWithTrrServer(
          name,
          trrServer,
          flags,
          this,
          mainThread,
          defaultOriginAttributes
        );
        Assert.ok(!expectEarlyFail);
      } catch (e) {
        Assert.ok(expectEarlyFail);
        this.resolve([e]);
      }
    }
  }

  onLookupComplete(inRequest, inRecord, inStatus) {
    Assert.ok(
      inRequest == this.request,
      "Checking that this is the correct callback"
    );

    // If we don't expect success here, just resolve and the caller will
    // decide what to do with the results.
    if (!this.expectedSuccess) {
      this.resolve([inRequest, inRecord, inStatus]);
      return;
    }

    Assert.equal(inStatus, Cr.NS_OK, "Checking status");
    let answer = inRecord.getNextAddrAsString();
    Assert.equal(
      answer,
      this.expectedAnswer,
      `Checking result for ${this.name}`
    );

    if (this.delay !== undefined) {
      Assert.greaterOrEqual(
        inRecord.trrFetchDurationNetworkOnly,
        this.delay,
        `the response should take at least ${this.delay}`
      );

      Assert.greaterOrEqual(
        inRecord.trrFetchDuration,
        this.delay,
        `the response should take at least ${this.delay}`
      );

      if (this.delay == 0) {
        // The response timing should be really 0
        Assert.equal(
          inRecord.trrFetchDurationNetworkOnly,
          0,
          `the response time should be 0`
        );

        Assert.equal(
          inRecord.trrFetchDuration,
          this.delay,
          `the response time should be 0`
        );
      }
    }

    this.resolve([inRequest, inRecord, inStatus]);
  }

  QueryInterface(aIID) {
    if (aIID.equals(Ci.nsIDNSListener) || aIID.equals(Ci.nsISupports)) {
      return this;
    }
    throw Components.Exception("", Cr.NS_ERROR_NO_INTERFACE);
  }

  // Implement then so we can await this as a promise.
  then() {
    return this.promise.then.apply(this.promise, arguments);
  }
}

add_task(async function test0_nodeExecute() {
  // This test checks that moz-http2.js running in node is working.
  // This should always be the first test in this file (except for setup)
  // otherwise we may encounter random failures when the http2 server is down.

  await NodeServer.execute("bad_id", `"hello"`)
    .then(() => ok(false, "expecting to throw"))
    .catch(e => equal(e.message, "Error: could not find id"));
});

function makeChan(url, mode) {
  let chan = NetUtil.newChannel({
    uri: url,
    loadUsingSystemPrincipal: true,
  }).QueryInterface(Ci.nsIHttpChannel);
  chan.setTRRMode(mode);
  return chan;
}

add_task(
  { skip_if: () => mozinfo.os == "mac" },
  async function test_trr_flags() {
    let httpserv = new HttpServer();
    httpserv.registerPathHandler("/", function handler(metadata, response) {
      let content = "ok";
      response.setHeader("Content-Length", `${content.length}`);
      response.bodyOutputStream.write(content, content.length);
    });
    httpserv.start(-1);
    const URL = `http://example.com:${httpserv.identity.primaryPort}/`;

    dns.clearCache(true);
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://localhost:${h2Port}/doh?responseIP=${BAD_IP}`
    );

    Services.prefs.setIntPref("network.trr.mode", 0);
    dns.clearCache(true);
    let chan = makeChan(URL, Ci.nsIRequest.TRR_DEFAULT_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    equal(chan.getTRRMode(), Ci.nsIRequest.TRR_DEFAULT_MODE);
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DISABLED_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    equal(chan.getTRRMode(), Ci.nsIRequest.TRR_DISABLED_MODE);
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_FIRST_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    equal(chan.getTRRMode(), Ci.nsIRequest.TRR_FIRST_MODE);
    dns.clearCache(true);
    chan = makeChan(
      `http://example.com:${httpserv.identity.primaryPort}/`,
      Ci.nsIRequest.TRR_ONLY_MODE
    );
    // Should fail as it tries to connect to local but unavailable IP
    await new Promise(resolve =>
      chan.asyncOpen(new ChannelListener(resolve, null, CL_EXPECT_FAILURE))
    );
    equal(chan.getTRRMode(), Ci.nsIRequest.TRR_ONLY_MODE);

    dns.clearCache(true);
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://localhost:${h2Port}/doh?responseIP=${BAD_IP}`
    );
    Services.prefs.setIntPref("network.trr.mode", 2);

    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DEFAULT_MODE);
    // Does get the IP from TRR, but failure means it falls back to DNS.
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DISABLED_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    // Does get the IP from TRR, but failure means it falls back to DNS.
    chan = makeChan(URL, Ci.nsIRequest.TRR_FIRST_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_ONLY_MODE);
    await new Promise(resolve =>
      chan.asyncOpen(new ChannelListener(resolve, null, CL_EXPECT_FAILURE))
    );

    dns.clearCache(true);
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://localhost:${h2Port}/doh?responseIP=${BAD_IP}`
    );
    Services.prefs.setIntPref("network.trr.mode", 3);

    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DEFAULT_MODE);
    await new Promise(resolve =>
      chan.asyncOpen(new ChannelListener(resolve, null, CL_EXPECT_FAILURE))
    );
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DISABLED_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_FIRST_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_ONLY_MODE);
    await new Promise(resolve =>
      chan.asyncOpen(new ChannelListener(resolve, null, CL_EXPECT_FAILURE))
    );

    dns.clearCache(true);
    Services.prefs.setIntPref("network.trr.mode", 5);
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://localhost:${h2Port}/doh?responseIP=1.1.1.1`
    );

    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DEFAULT_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_DISABLED_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_FIRST_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));
    dns.clearCache(true);
    chan = makeChan(URL, Ci.nsIRequest.TRR_ONLY_MODE);
    await new Promise(resolve => chan.asyncOpen(new ChannelListener(resolve)));

    await new Promise(resolve => httpserv.stop(resolve));
  }
);

// verify basic A record
add_task(async function test1() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener("bar.example.com", "2.2.2.2");
});

// verify basic A record - without bootstrapping
add_task(async function test1b() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");
  Services.prefs.setCharPref("network.dns.localDomains", "foo.example.com");

  await new DNSListener("bar.example.com", "3.3.3.3");

  Services.prefs.setCharPref("network.trr.bootstrapAddress", "127.0.0.1");
  Services.prefs.clearUserPref("network.dns.localDomains");
});

// verify that the name was put in cache - it works with bad DNS URI
add_task(async function test2() {
  // Don't clear the cache. That is what we're checking.
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404`
  );

  await new DNSListener("bar.example.com", "3.3.3.3");
});

// verify working credentials in DOH request
add_task(async function test3() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=4.4.4.4&auth=true`
  );
  Services.prefs.setCharPref("network.trr.credentials", "user:password");

  await new DNSListener("bar.example.com", "4.4.4.4");
});

// verify failing credentials in DOH request
add_task(async function test4() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=4.4.4.4&auth=true`
  );
  Services.prefs.setCharPref("network.trr.credentials", "evil:person");

  let [, , inStatus] = await new DNSListener(
    "wrong.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
});

// verify DOH push, part A
add_task(async function test5() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=5.5.5.5&push=true`
  );

  await new DNSListener("first.example.com", "5.5.5.5");
});

add_task(async function test5b() {
  // At this point the second host name should've been pushed and we can resolve it using
  // cache only. Set back the URI to a path that fails.
  // Don't clear the cache, otherwise we lose the pushed record.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404`
  );
  dump("test5b - resolve push.example.org please\n");

  await new DNSListener("push.example.org", "2018::2018");
});

// verify AAAA entry
add_task(async function test6() {
  Services.prefs.setBoolPref("network.trr.wait-for-A-and-AAAA", true);

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020&delayIPv4=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030&delayIPv4=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020&delayIPv6=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030&delayIPv6=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false); // ignored when wait-for-A-and-AAAA is true
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  Services.prefs.setBoolPref("network.trr.wait-for-A-and-AAAA", false);

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020&delayIPv4=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030&delayIPv4=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020&delayIPv6=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030&delayIPv6=100`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2020`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2020");

  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.early-AAAA", false);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2020:2020::2030`
  );
  await new DNSListener("aaaa.example.com", "2020:2020::2030");

  Services.prefs.clearUserPref("network.trr.early-AAAA");
  Services.prefs.clearUserPref("network.trr.wait-for-A-and-AAAA");
});

// verify RFC1918 address from the server is rejected
add_task(async function test7() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.168.0.1`
  );
  let [, , inStatus] = await new DNSListener(
    "rfc1918.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=::ffff:192.168.0.1`
  );
  [, , inStatus] = await new DNSListener(
    "rfc1918-ipv6.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
});

// verify RFC1918 address from the server is fine when told so
add_task(async function test8() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.168.0.1`
  );
  Services.prefs.setBoolPref("network.trr.allow-rfc1918", true);
  await new DNSListener("rfc1918.example.com", "192.168.0.1");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=::ffff:192.168.0.1`
  );
  await new DNSListener("rfc1918-ipv6.example.com", "::ffff:192.168.0.1");
});

// use GET and disable ECS (makes a larger request)
// verify URI template cutoff
add_task(async function test8b() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh{?dns}`
  );
  Services.prefs.clearUserPref("network.trr.allow-rfc1918");
  Services.prefs.setBoolPref("network.trr.useGET", true);
  Services.prefs.setBoolPref("network.trr.disable-ECS", true);
  await new DNSListener("ecs.example.com", "5.5.5.5");
});

// use GET
add_task(async function test9() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh`
  );
  Services.prefs.clearUserPref("network.trr.allow-rfc1918");
  Services.prefs.setBoolPref("network.trr.useGET", true);
  Services.prefs.setBoolPref("network.trr.disable-ECS", false);
  await new DNSListener("get.example.com", "5.5.5.5");
});

// confirmationNS set without confirmed NS yet
add_task(async function test10() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.clearUserPref("network.trr.useGET");
  Services.prefs.clearUserPref("network.trr.disable-ECS");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=1::ffff`
  );
  Services.prefs.setCharPref(
    "network.trr.confirmationNS",
    "confirm.example.com"
  );

  await new DNSListener("skipConfirmationForMode3.example.com", "1::ffff");
});

// use a slow server and short timeout!
add_task(async function test11() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.confirmationNS", "skip");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/dns-750ms`
  );
  Services.prefs.setIntPref("network.trr.request_timeout_mode_trronly_ms", 10);
  let [, , inStatus] = await new DNSListener(
    "test11.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
});

// gets an no answers back from DoH. Falls back to regular DNS
add_task(async function test12() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setIntPref("network.trr.request_timeout_ms", 10);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=none`
  );
  Services.prefs.clearUserPref("network.trr.request_timeout_ms");
  Services.prefs.clearUserPref("network.trr.request_timeout_mode_trronly_ms");
  await new DNSListener("confirm.example.com", "127.0.0.1");
});

// TRR-first gets a 404 back from DOH
add_task(async function test13() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404`
  );
  await new DNSListener("test13.example.com", "127.0.0.1");
});

// Test that MODE_RESERVED4 (previously MODE_SHADOW) is treated as TRR off.
add_task(async function test14() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404`
  );
  await new DNSListener("test14.example.com", "127.0.0.1");

  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// Test that MODE_RESERVED4 (previously MODE_SHADOW) is treated as TRR off.
add_task(async function test15() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/dns-750ms`
  );
  Services.prefs.setIntPref("network.trr.request_timeout_ms", 10);
  Services.prefs.setIntPref("network.trr.request_timeout_mode_trronly_ms", 10);
  await new DNSListener("test15.example.com", "127.0.0.1");

  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first and timed out TRR
add_task(async function test16() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/dns-750ms`
  );
  Services.prefs.setIntPref("network.trr.request_timeout_ms", 10);
  Services.prefs.setIntPref("network.trr.request_timeout_mode_trronly_ms", 10);
  await new DNSListener("test16.example.com", "127.0.0.1");
});

// TRR-only and chase CNAME
add_task(async function test17() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/dns-cname`
  );
  Services.prefs.clearUserPref("network.trr.request_timeout_ms");
  Services.prefs.clearUserPref("network.trr.request_timeout_mode_trronly_ms");
  await new DNSListener("cname.example.com", "99.88.77.66");
});

// TRR-only and a CNAME loop
add_task(async function test18() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=none&cnameloop=true`
  );
  let [, , inStatus] = await new DNSListener(
    "test18.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
});

// Test that MODE_RESERVED1 (previously MODE_PARALLEL) is treated as TRR off.
add_task(async function test19() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 1); // MODE_RESERVED1. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=none&cnameloop=true`
  );
  await new DNSListener("test19.example.com", "127.0.0.1");

  Services.prefs.setIntPref("network.trr.mode", 1); // MODE_RESERVED1. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first and a CNAME loop
add_task(async function test20() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=none&cnameloop=true`
  );
  await new DNSListener("test20.example.com", "127.0.0.1");
});

// Test that MODE_RESERVED4 (previously MODE_SHADOW) is treated as TRR off.
add_task(async function test21() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=none&cnameloop=true`
  );
  await new DNSListener("test21.example.com", "127.0.0.1");

  Services.prefs.setIntPref("network.trr.mode", 4); // MODE_RESERVED4. Interpreted as TRR off.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// verify that basic A record name mismatch gets rejected.
// Gets a response for bar.example.com instead of what it requested
add_task(async function test22() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only to avoid native fallback
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?hostname=bar.example.com`
  );
  let [, , inStatus] = await new DNSListener(
    "mismatch.example.com",
    undefined,
    false
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
});

// TRR-only, with a CNAME response with a bundled A record for that CNAME!
add_task(async function test23() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/dns-cname-a`
  );
  await new DNSListener("cname-a.example.com", "9.8.7.6");
});

// TRR-first check that TRR result is used
add_task(async function test24() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  Services.prefs.setCharPref("network.trr.builtin-excluded-domains", "");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );
  await new DNSListener("bar.example.com", "192.192.192.192");
});

// TRR-first check that DNS result is used if domain is part of the excluded-domains pref
add_task(async function test24b() {
  dns.clearCache(true);
  Services.prefs.setCharPref("network.trr.excluded-domains", "bar.example.com");
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the excluded-domains pref
add_task(async function test24c() {
  dns.clearCache(true);
  Services.prefs.setCharPref("network.trr.excluded-domains", "example.com");
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the excluded-domains pref that contains things before it.
add_task(async function test24d() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.excluded-domains",
    "foo.test.com, bar.example.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the excluded-domains pref that contains things after it.
add_task(async function test24e() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.excluded-domains",
    "bar.example.com, foo.test.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

function observerPromise(topic) {
  return new Promise(resolve => {
    let observer = {
      QueryInterface: ChromeUtils.generateQI([Ci.nsIObserver]),
      observe(aSubject, aTopic, aData) {
        dump(`observe: ${aSubject}, ${aTopic}, ${aData} \n`);
        if (aTopic == topic) {
          Services.obs.removeObserver(observer, topic);
          resolve(aData);
        }
      },
    };
    Services.obs.addObserver(observer, topic);
  });
}

// TRR-first check that captivedetect.canonicalURL is resolved via native DNS
add_task(async function test24f() {
  dns.clearCache(true);

  const cpServer = new HttpServer();
  cpServer.registerPathHandler("/cp", function handleRawData(
    request,
    response
  ) {
    response.setHeader("Content-Type", "text/plain", false);
    response.setHeader("Cache-Control", "no-cache", false);
    response.bodyOutputStream.write("data", 4);
  });
  cpServer.start(-1);
  cpServer.identity.setPrimary(
    "http",
    "detectportal.firefox.com",
    cpServer.identity.primaryPort
  );
  let cpPromise = observerPromise("captive-portal-login");

  Services.prefs.setCharPref(
    "captivedetect.canonicalURL",
    `http://detectportal.firefox.com:${cpServer.identity.primaryPort}/cp`
  );
  Services.prefs.setBoolPref("network.captive-portal-service.testMode", true);
  Services.prefs.setBoolPref("network.captive-portal-service.enabled", true);

  // The captive portal has to have used native DNS, otherwise creating
  // a socket to a non-local IP would trigger a crash.
  await cpPromise;
  // Simply resolving the captive portal domain should still use TRR
  await new DNSListener("detectportal.firefox.com", "192.192.192.192");

  Services.prefs.clearUserPref("network.captive-portal-service.enabled");
  Services.prefs.clearUserPref("network.captive-portal-service.testMode");
  Services.prefs.clearUserPref("captivedetect.canonicalURL");

  await new Promise(resolve => cpServer.stop(resolve));
});

// TRR-first check that a domain is resolved via native DNS when parental control is enabled.
add_task(async function test24g() {
  dns.clearCache(true);
  await SetParentalControlEnabled(true);
  await new DNSListener("www.example.com", "127.0.0.1");
  await SetParentalControlEnabled(false);
});

// TRR-first check that DNS result is used if domain is part of the builtin-excluded-domains pref
add_task(async function test24h() {
  dns.clearCache(true);
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "bar.example.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the builtin-excluded-domains pref
add_task(async function test24i() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "example.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the builtin-excluded-domains pref that contains things before it.
add_task(async function test24j() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "foo.test.com, bar.example.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-first check that DNS result is used if domain is part of the builtin-excluded-domains pref that contains things after it.
add_task(async function test24k() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "bar.example.com, foo.test.com"
  );
  await new DNSListener("bar.example.com", "127.0.0.1");
});

// TRR-only that resolving localhost with TRR-only mode will use the remote
// resolver if it's not in the excluded domains
add_task(async function test25() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  Services.prefs.setCharPref("network.trr.builtin-excluded-domains", "");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("localhost", "192.192.192.192", true);
});

// TRR-only check that localhost goes directly to native lookup when in the excluded-domains
add_task(async function test25b() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "localhost");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("localhost", "127.0.0.1");
});

// TRR-only check that test.local is resolved via native DNS
add_task(async function test25c() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "localhost,local");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("test.local", "127.0.0.1");
});

// TRR-only check that .other is resolved via native DNS when the pref is set
add_task(async function test25d() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.excluded-domains",
    "localhost,local,other"
  );
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("domain.other", "127.0.0.1");
});

// TRR-only check that captivedetect.canonicalURL is resolved via native DNS
add_task({ skip_if: () => true }, async function test25e() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  const cpServer = new HttpServer();
  cpServer.registerPathHandler("/cp", function handleRawData(
    request,
    response
  ) {
    response.setHeader("Content-Type", "text/plain", false);
    response.setHeader("Cache-Control", "no-cache", false);
    response.bodyOutputStream.write("data", 4);
  });
  cpServer.start(-1);
  cpServer.identity.setPrimary(
    "http",
    "detectportal.firefox.com",
    cpServer.identity.primaryPort
  );
  let cpPromise = observerPromise("captive-portal-login");

  Services.prefs.setCharPref(
    "captivedetect.canonicalURL",
    `http://detectportal.firefox.com:${cpServer.identity.primaryPort}/cp`
  );
  Services.prefs.setBoolPref("network.captive-portal-service.testMode", true);
  Services.prefs.setBoolPref("network.captive-portal-service.enabled", true);

  // The captive portal has to have used native DNS, otherwise creating
  // a socket to a non-local IP would trigger a crash.
  await cpPromise;
  // // Simply resolving the captive portal domain should still use TRR
  await new DNSListener("detectportal.firefox.com", "192.192.192.192");

  Services.prefs.clearUserPref("network.captive-portal-service.enabled");
  Services.prefs.clearUserPref("network.captive-portal-service.testMode");
  Services.prefs.clearUserPref("captivedetect.canonicalURL");

  await new Promise(resolve => cpServer.stop(resolve));
});

// TRR-only check that a domain is resolved via native DNS when parental control is enabled.
add_task(async function test25f() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  await SetParentalControlEnabled(true);
  await new DNSListener("www.example.com", "127.0.0.1");
  await SetParentalControlEnabled(false);
});

// TRR-only check that localhost goes directly to native lookup when in the builtin-excluded-domains
add_task(async function test25g() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "localhost"
  );
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("localhost", "127.0.0.1");
});

// TRR-only check that test.local is resolved via native DNS
add_task(async function test25h() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "localhost,local"
  );
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("test.local", "127.0.0.1");
});

// TRR-only check that .other is resolved via native DNS when the pref is set
add_task(async function test25i() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.builtin-excluded-domains",
    "localhost,local,other"
  );
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.192.192.192`
  );

  await new DNSListener("domain.other", "127.0.0.1");
});

// Check that none of the requests have set any cookies.
add_task(async function count_cookies() {
  let cm = Cc["@mozilla.org/cookiemanager;1"].getService(Ci.nsICookieManager);
  Assert.equal(cm.countCookiesFromHost("example.com"), 0);
  Assert.equal(cm.countCookiesFromHost("foo.example.com."), 0);
});

add_task(async function test_connection_closed() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  // We don't need to wait for 30 seconds for the request to fail
  Services.prefs.setIntPref("network.trr.request_timeout_mode_trronly_ms", 500);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );
  // bootstrap
  Services.prefs.clearUserPref("network.dns.localDomains");
  Services.prefs.setCharPref("network.trr.bootstrapAddress", "127.0.0.1");

  await new DNSListener("bar.example.com", "2.2.2.2");

  // makes the TRR connection shut down.
  let [, , inStatus] = await new DNSListener("closeme.com", undefined, false);
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
  await new DNSListener("bar2.example.com", "2.2.2.2");
});

add_task(async function test_connection_closed_no_bootstrap() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "localhost,local");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );
  Services.prefs.setCharPref("network.dns.localDomains", "foo.example.com");
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");

  await new DNSListener("bar.example.com", "3.3.3.3");

  // makes the TRR connection shut down.
  let [, , inStatus] = await new DNSListener("closeme.com", undefined, false);
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
  await new DNSListener("bar2.example.com", "3.3.3.3");
});

add_task(async function test_connection_closed_no_bootstrap_localhost() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "localhost");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://localhost:${h2Port}/doh?responseIP=3.3.3.3`
  );
  Services.prefs.clearUserPref("network.dns.localDomains");
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");

  await new DNSListener("bar.example.com", "3.3.3.3");

  // makes the TRR connection shut down.
  let [, , inStatus] = await new DNSListener("closeme.com", undefined, false);
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
  await new DNSListener("bar2.example.com", "3.3.3.3");
});

add_task(async function test_connection_closed_no_bootstrap_no_excluded() {
  // This test makes sure that even in mode 3 without a bootstrap address
  // we are able to restart the TRR connection if it drops - the TRR service
  // channel will use regular DNS to resolve the TRR address.
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref("network.trr.excluded-domains", "");
  Services.prefs.setCharPref("network.trr.builtin-excluded-domains", "");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://localhost:${h2Port}/doh?responseIP=3.3.3.3`
  );
  Services.prefs.clearUserPref("network.dns.localDomains");
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");

  await new DNSListener("bar.example.com", "3.3.3.3");

  // makes the TRR connection shut down.
  let [, , inStatus] = await new DNSListener("closeme.com", undefined, false);
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );
  dns.clearCache(true);
  await new DNSListener("bar2.example.com", "3.3.3.3");
});

add_task(async function test_connection_closed_trr_first() {
  // This test exists to document what happens when we're in TRR only mode
  // and we don't set a bootstrap address. We use DNS to resolve the
  // initial URI, but if the connection fails, we don't fallback to DNS
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://localhost:${h2Port}/doh?responseIP=9.9.9.9`
  );
  Services.prefs.setCharPref("network.dns.localDomains", "closeme.com");
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");

  await new DNSListener("bar.example.com", "9.9.9.9");

  // makes the TRR connection shut down. Should fallback to DNS
  await new DNSListener("closeme.com", "127.0.0.1");
  // TRR should be back up again
  await new DNSListener("bar2.example.com", "9.9.9.9");
});

add_task(async function test_clearCacheOnURIChange() {
  dns.clearCache(true);
  Services.prefs.setBoolPref("network.trr.clear-cache-on-pref-change", true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://localhost:${h2Port}/doh?responseIP=7.7.7.7`
  );

  await new DNSListener("bar.example.com", "7.7.7.7");

  // The TRR cache should be cleared by this pref change.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://localhost:${h2Port}/doh?responseIP=8.8.8.8`
  );

  await new DNSListener("bar.example.com", "8.8.8.8");
  Services.prefs.setBoolPref("network.trr.clear-cache-on-pref-change", false);
});

add_task(async function test_dnsSuffix() {
  async function checkDnsSuffixInMode(mode) {
    dns.clearCache(true);
    Services.prefs.setIntPref("network.trr.mode", mode);
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://foo.example.com:${h2Port}/doh?responseIP=1.2.3.4&push=true`
    );
    await new DNSListener("example.org", "1.2.3.4");
    await new DNSListener("push.example.org", "2018::2018");
    await new DNSListener("test.com", "1.2.3.4");

    let networkLinkService = {
      dnsSuffixList: ["example.org"],
      QueryInterface: ChromeUtils.generateQI([Ci.nsINetworkLinkService]),
    };
    Services.obs.notifyObservers(
      networkLinkService,
      "network:dns-suffix-list-updated"
    );
    await new DNSListener("test.com", "1.2.3.4");
    await new DNSListener("example.org", "127.0.0.1");
    // Also test that we don't use the pushed entry.
    await new DNSListener("push.example.org", "127.0.0.1");

    // Attempt to clean up, just in case
    networkLinkService.dnsSuffixList = [];
    Services.obs.notifyObservers(
      networkLinkService,
      "network:dns-suffix-list-updated"
    );
  }

  await checkDnsSuffixInMode(2);
  Services.prefs.setCharPref("network.trr.bootstrapAddress", "127.0.0.1");
  await checkDnsSuffixInMode(3);
  Services.prefs.clearUserPref("network.trr.bootstrapAddress");
});

add_task(async function test_vpnDetection() {
  Services.prefs.setIntPref("network.trr.mode", 2);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=1.2.3.4&push=true`
  );
  dns.clearCache(true);
  await new DNSListener("example.org", "1.2.3.4");
  await new DNSListener("push.example.org", "2018::2018");

  let networkLinkService = {
    platformDNSIndications: Ci.nsINetworkLinkService.VPN_DETECTED,
    QueryInterface: ChromeUtils.generateQI([Ci.nsINetworkLinkService]),
  };

  Services.obs.notifyObservers(
    networkLinkService,
    "network:link-status-changed",
    "changed"
  );
  await new DNSListener("example.org", "127.0.0.1");
  await new DNSListener("test.com", "127.0.0.1");
  // Also test that we don't use the pushed entry.
  await new DNSListener("push.example.org", "127.0.0.1");

  Services.prefs.setCharPref("network.trr.bootstrapAddress", "127.0.0.1");
  Services.prefs.setIntPref("network.trr.mode", 3);
  dns.clearCache(true);

  await new DNSListener("example.org", "127.0.0.1");
  await new DNSListener("test.com", "127.0.0.1");
  // Also test that we don't use the pushed entry.
  await new DNSListener("push.example.org", "127.0.0.1");

  Services.prefs.clearUserPref("network.trr.bootstrapAddress");

  // Attempt to clean up, just in case
  networkLinkService.platformDNSIndications =
    Ci.nsINetworkLinkService.NONE_DETECTED;
  Services.obs.notifyObservers(
    networkLinkService,
    "network:link-status-changed",
    "changed"
  );
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_1() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 0); // TRR-disabled

  await new DNSListener(
    "bar_with_trr1.example.com",
    "2.2.2.2",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  // Test request without trr server, it should return a native dns response.
  await new DNSListener("bar_with_trr1.example.com", "127.0.0.1");
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_2() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener(
    "bar_with_trr2.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );

  // Test request without trr server, it should return a response from trr server defined in the pref.
  await new DNSListener("bar_with_trr2.example.com", "2.2.2.2");
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_3() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener(
    "bar_with_trr3.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );

  // Test request without trr server, it should return a response from trr server defined in the pref.
  await new DNSListener("bar_with_trr3.example.com", "2.2.2.2");
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_5() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 5); // TRR-user-disabled

  // When dns is resolved in socket process, we can't set |expectEarlyFail| to true.
  let inSocketProcess = mozinfo.socketprocess_networking;
  let [_] = await new DNSListener(
    "bar_with_trr3.example.com",
    undefined,
    false,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`,
    !inSocketProcess
  );

  // Call normal AsyncOpen, it will return result from the native resolver.
  await new DNSListener("bar_with_trr3.example.com", "127.0.0.1");
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_different_cache() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener("bar_with_trr4.example.com", "2.2.2.2", true);

  // The record will be fetch again.
  await new DNSListener(
    "bar_with_trr4.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );
});

// Test AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_different_servers() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener("bar_with_trr5.example.com", "2.2.2.2", true);

  // The record will be fetch again.
  await new DNSListener(
    "bar_with_trr5.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );

  // The record will be fetch again.
  await new DNSListener(
    "bar_with_trr5.example.com",
    "4.4.4.4",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=4.4.4.4`
  );
});

// Test AsyncResoleWithTrrServer.
// AsyncResoleWithTrrServer will failed.
// There will be no fallback to native and the host will not be blacklisted.
add_task(async function test_async_resolve_with_trr_server_no_blacklist() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  let [, , inStatus] = await new DNSListener(
    "bar_with_trr6.example.com",
    undefined,
    false,
    undefined,
    `https://foo.example.com:${h2Port}/404`
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );

  await new DNSListener("bar_with_trr6.example.com", "2.2.2.2", true);
});

// verify that DOH push does not work with AsyncResoleWithTrrServer.
add_task(async function test_async_resolve_with_trr_server_no_push() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener(
    "bar_with_trr7.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3&push=true`
  );
});

add_task(async function test_async_resolve_with_trr_server_no_push_part_2() {
  // AsyncResoleWithTrrServer rejects server pushes and the entry for push.example.org
  // shouldn't be neither in the default cache not in AsyncResoleWithTrrServer cache.
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404`
  );
  dump(
    "test_async_resolve_with_trr_server_no_push_part_2 - resolve push.example.org will not be in the cache.\n"
  );

  await new DNSListener(
    "push.example.org",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3&push=true`
  );

  await new DNSListener("push.example.org", "127.0.0.1");
});

// Verify that AsyncResoleWithTrrServer is not block on confirmationNS of the defaut serveer.
add_task(async function test_async_resolve_with_trr_server_confirmation_ns() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-only
  Services.prefs.clearUserPref("network.trr.useGET");
  Services.prefs.clearUserPref("network.trr.disable-ECS");
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=1::ffff`
  );
  Services.prefs.setCharPref(
    "network.trr.confirmationNS",
    "confirm.example.com"
  );

  // AsyncResoleWithTrrServer will succeed
  await new DNSListener(
    "bar_with_trr8.example.com",
    "3.3.3.3",
    true,
    undefined,
    `https://foo.example.com:${h2Port}/doh?responseIP=3.3.3.3`
  );

  Services.prefs.setCharPref("network.trr.confirmationNS", "skip");
});

// verify TRR timings
add_task(async function test_fetch_time() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2&delayIPv4=20`
  );

  await new DNSListener("bar_time.example.com", "2.2.2.2", true, 20);
});

// gets an error from DoH. It will fall back to regular DNS. The TRR timing should be 0.
add_task(async function test_no_fetch_time_on_trr_error() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/404&delayIPv4=20`
  );

  await new DNSListener("bar_time1.example.com", "127.0.0.1", true, 0);
});

// check an excluded domain. It should fall back to regular DNS. The TRR timing should be 0.
add_task(async function test_no_fetch_time_for_excluded_domains() {
  dns.clearCache(true);
  Services.prefs.setCharPref(
    "network.trr.excluded-domains",
    "bar_time2.example.com"
  );
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2&delayIPv4=20`
  );

  await new DNSListener("bar_time2.example.com", "127.0.0.1", true, 0);

  Services.prefs.setCharPref("network.trr.excluded-domains", "");
});

// verify RFC1918 address from the server is rejected and the TRR timing will be not set because the response will be from the native resolver.
add_task(async function test_no_fetch_time_for_rfc1918_not_allowed() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=192.168.0.1&delayIPv4=20`
  );
  await new DNSListener("rfc1918_time.example.com", "127.0.0.1", true, 0);
});

add_task(async function test_content_encoding_gzip() {
  dns.clearCache(true);
  Services.prefs.setBoolPref(
    "network.trr.send_empty_accept-encoding_headers",
    false
  );
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  await new DNSListener("bar.example.com", "2.2.2.2");
});

add_task(async function test_redirect_get() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3); // TRR-only
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?redirect=4.4.4.4{&dns}`
  );
  Services.prefs.clearUserPref("network.trr.allow-rfc1918");
  Services.prefs.setBoolPref("network.trr.useGET", true);
  Services.prefs.setBoolPref("network.trr.disable-ECS", true);
  await new DNSListener("ecs.example.com", "4.4.4.4");
});

// test redirect
add_task(async function test_redirect_post() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.setBoolPref("network.trr.useGET", false);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?redirect=4.4.4.4`
  );

  await new DNSListener("bar.example.com", "4.4.4.4");
});

// confirmationNS set without confirmed NS yet
// checks that we properly fall back to DNS is confirmation is not ready yet
add_task(async function test_resolve_not_confirmed() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=7.7.7.7`
  );
  Services.prefs.setCharPref(
    "network.trr.confirmationNS",
    "confirm.example.com"
  );

  await new DNSListener("example.org", "127.0.0.1");

  // Check that the confirmation eventually completes.
  let count = 100;
  while (count > 0) {
    if (count == 50 || count == 10) {
      // At these two points we do a longer timeout to account for a slow
      // response on the server side. This is usually a problem on the Android
      // because of the increased delay between the emulator and host.
      await new Promise(resolve => do_timeout(100 * (100 / count), resolve));
    }
    let [inRequest, inRecord, inStatus] = await new DNSListener(
      `ip${count}.example.org`,
      undefined,
      false
    );
    let responseIP = inRecord.getNextAddrAsString();
    if (responseIP == "7.7.7.7") {
      break;
    }
    count--;
  }

  Assert.greater(count, 0, "Finished confirmation before 100 iterations");

  Services.prefs.setCharPref("network.trr.confirmationNS", "skip");
});

// Tests that we handle FQDN encoding and decoding properly
add_task(async function test_fqdn() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=9.8.7.6`
  );
  await new DNSListener("fqdn.example.org.", "9.8.7.6");
});

add_task(async function test_fqdn_get() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.setBoolPref("network.trr.useGET", true);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=9.8.7.6`
  );
  await new DNSListener("fqdn_get.example.org.", "9.8.7.6");

  Services.prefs.setBoolPref("network.trr.useGET", false);
});

add_task(async function test_detected_uri() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.clearUserPref("network.trr.uri");
  let defaultURI = gDefaultPref.getCharPref("network.trr.uri");
  gDefaultPref.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=3.4.5.6`
  );
  await new DNSListener("domainA.example.org.", "3.4.5.6");
  dns.setDetectedTrrURI(
    `https://foo.example.com:${h2Port}/doh?responseIP=1.2.3.4`
  );
  await new DNSListener("domainB.example.org.", "1.2.3.4");
  gDefaultPref.setCharPref("network.trr.uri", defaultURI);
});

add_task(async function test_detected_uri_userSet() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=4.5.6.7`
  );
  await new DNSListener("domainA.example.org.", "4.5.6.7");
  // This should be a no-op, since we have a user-set URI
  dns.setDetectedTrrURI(
    `https://foo.example.com:${h2Port}/doh?responseIP=1.2.3.4`
  );
  await new DNSListener("domainB.example.org.", "4.5.6.7");
});

add_task(async function test_detected_uri_link_change() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 3);
  Services.prefs.clearUserPref("network.trr.uri");
  let defaultURI = gDefaultPref.getCharPref("network.trr.uri");
  gDefaultPref.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=3.4.5.6`
  );
  await new DNSListener("domainA.example.org.", "3.4.5.6");
  dns.setDetectedTrrURI(
    `https://foo.example.com:${h2Port}/doh?responseIP=1.2.3.4`
  );
  await new DNSListener("domainB.example.org.", "1.2.3.4");

  let networkLinkService = {
    platformDNSIndications: 0,
    QueryInterface: ChromeUtils.generateQI([Ci.nsINetworkLinkService]),
  };

  Services.obs.notifyObservers(
    networkLinkService,
    "network:link-status-changed",
    "changed"
  );

  await new DNSListener("domainC.example.org.", "3.4.5.6");

  gDefaultPref.setCharPref("network.trr.uri", defaultURI);
});

add_task(async function test_pref_changes() {
  Services.prefs.clearUserPref("network.trr.uri");
  let defaultURI = gDefaultPref.getCharPref("network.trr.uri");

  async function doThenCheckURI(closure, expectedURI, expectChange = false) {
    let uriChanged;
    if (expectChange) {
      uriChanged = observerPromise("network:trr-uri-changed");
    }
    closure();
    if (expectChange) {
      await uriChanged;
    }
    equal(dns.currentTrrURI, expectedURI);
  }

  // setting the default value of the pref should be reflected in the URI
  await doThenCheckURI(() => {
    gDefaultPref.setCharPref(
      "network.trr.uri",
      `https://foo.example.com:${h2Port}/doh?default`
    );
  }, `https://foo.example.com:${h2Port}/doh?default`);

  // the user set value should be reflected in the URI
  await doThenCheckURI(() => {
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://foo.example.com:${h2Port}/doh?user`
    );
  }, `https://foo.example.com:${h2Port}/doh?user`);

  // A user set pref is selected, so it should be chosen instead of the rollout
  await doThenCheckURI(
    () => {
      Services.prefs.setCharPref(
        "doh-rollout.uri",
        `https://foo.example.com:${h2Port}/doh?rollout`
      );
    },
    `https://foo.example.com:${h2Port}/doh?user`,
    false
  );

  // There is no user set pref, so we go to the rollout pref
  await doThenCheckURI(() => {
    Services.prefs.clearUserPref("network.trr.uri");
  }, `https://foo.example.com:${h2Port}/doh?rollout`);

  // When the URI is set by the rollout addon, detection is allowed
  await doThenCheckURI(() => {
    dns.setDetectedTrrURI(`https://foo.example.com:${h2Port}/doh?detected`);
  }, `https://foo.example.com:${h2Port}/doh?detected`);

  // Should switch back to the default provided by the rollout addon
  await doThenCheckURI(() => {
    let networkLinkService = {
      platformDNSIndications: 0,
      QueryInterface: ChromeUtils.generateQI([Ci.nsINetworkLinkService]),
    };
    Services.obs.notifyObservers(
      networkLinkService,
      "network:link-status-changed",
      "changed"
    );
  }, `https://foo.example.com:${h2Port}/doh?rollout`);

  // Again the user set pref should be chosen
  await doThenCheckURI(() => {
    Services.prefs.setCharPref(
      "network.trr.uri",
      `https://foo.example.com:${h2Port}/doh?user`
    );
  }, `https://foo.example.com:${h2Port}/doh?user`);

  // Detection should not work with a user set pref
  await doThenCheckURI(
    () => {
      dns.setDetectedTrrURI(`https://foo.example.com:${h2Port}/doh?detected`);
    },
    `https://foo.example.com:${h2Port}/doh?user`,
    false
  );

  // Should stay the same on network changes
  await doThenCheckURI(
    () => {
      let networkLinkService = {
        platformDNSIndications: 0,
        QueryInterface: ChromeUtils.generateQI([Ci.nsINetworkLinkService]),
      };
      Services.obs.notifyObservers(
        networkLinkService,
        "network:link-status-changed",
        "changed"
      );
    },
    `https://foo.example.com:${h2Port}/doh?user`,
    false
  );

  // Restore the pref
  gDefaultPref.setCharPref("network.trr.uri", defaultURI);
});

add_task(async function test_async_resolve_with_trr_server_bad_port() {
  dns.clearCache(true);
  Services.prefs.setIntPref("network.trr.mode", 2); // TRR-first
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=2.2.2.2`
  );

  let [, , inStatus] = await new DNSListener(
    "only_once.example.com",
    undefined,
    false,
    undefined,
    `https://target.example.com:666/404`
  );
  Assert.ok(
    !Components.isSuccessCode(inStatus),
    `${inStatus} should be an error code`
  );

  // // MOZ_LOG=sync,timestamp,nsHostResolver:5 We should not keep resolving only_once.example.com
  // // TODO: find a way of automating this
  // await new Promise(resolve => {});
});

add_task(async function test_dohrollout_mode() {
  Services.prefs.clearUserPref("network.trr.mode");
  Services.prefs.clearUserPref("doh-rollout.mode");

  equal(dns.currentTrrMode, 0);

  async function doThenCheckMode(trrMode, rolloutMode, expectedMode, message) {
    let modeChanged;
    if (dns.currentTrrMode != expectedMode) {
      modeChanged = observerPromise("network:trr-mode-changed");
    }

    if (trrMode != undefined) {
      Services.prefs.setIntPref("network.trr.mode", trrMode);
    }

    if (rolloutMode != undefined) {
      Services.prefs.setIntPref("doh-rollout.mode", rolloutMode);
    }

    if (modeChanged) {
      await modeChanged;
    }
    equal(dns.currentTrrMode, expectedMode, message);
  }

  await doThenCheckMode(2, undefined, 2);
  await doThenCheckMode(3, undefined, 3);
  await doThenCheckMode(5, undefined, 5);
  await doThenCheckMode(2, undefined, 2);
  await doThenCheckMode(0, undefined, 0);
  await doThenCheckMode(1, undefined, 5);
  await doThenCheckMode(6, undefined, 5);

  await doThenCheckMode(2, 0, 2);
  await doThenCheckMode(2, 1, 2);
  await doThenCheckMode(2, 2, 2);
  await doThenCheckMode(2, 3, 2);
  await doThenCheckMode(2, 5, 2);
  await doThenCheckMode(3, 2, 3);
  await doThenCheckMode(5, 2, 5);

  Services.prefs.clearUserPref("network.trr.mode");
  Services.prefs.clearUserPref("doh-rollout.mode");

  await doThenCheckMode(undefined, 2, 2);
  await doThenCheckMode(undefined, 3, 3);

  // All modes that are not 0,2,3 are treated as 5
  await doThenCheckMode(undefined, 5, 5);
  await doThenCheckMode(undefined, 4, 5);
  await doThenCheckMode(undefined, 6, 5);

  await doThenCheckMode(undefined, 2, 2);
  await doThenCheckMode(3, undefined, 3);

  Services.prefs.clearUserPref("network.trr.mode");
  equal(dns.currentTrrMode, 2);
  Services.prefs.clearUserPref("doh-rollout.mode");
  equal(dns.currentTrrMode, 0);
});

add_task(async function test_ipv6_trr_fallback() {
  dns.clearCache(true);
  let httpserver = new HttpServer();
  httpserver.registerPathHandler("/content", (metadata, response) => {
    response.setHeader("Content-Type", "text/plain");
    response.setHeader("Cache-Control", "no-cache");

    const responseBody = "anybody";
    response.bodyOutputStream.write(responseBody, responseBody.length);
  });
  httpserver.start(-1);

  Services.prefs.setBoolPref("network.captive-portal-service.testMode", true);
  let url = `http://127.0.0.1:666/doom_port_should_not_be_open`;
  Services.prefs.setCharPref("network.connectivity-service.IPv6.url", url);
  let ncs = Cc[
    "@mozilla.org/network/network-connectivity-service;1"
  ].getService(Ci.nsINetworkConnectivityService);

  function promiseObserverNotification(topic, matchFunc) {
    return new Promise((resolve, reject) => {
      Services.obs.addObserver(function observe(subject, topic, data) {
        let matches =
          typeof matchFunc != "function" || matchFunc(subject, data);
        if (!matches) {
          return;
        }
        Services.obs.removeObserver(observe, topic);
        resolve({ subject, data });
      }, topic);
    });
  }

  let checks = promiseObserverNotification(
    "network:connectivity-service:ip-checks-complete"
  );

  ncs.recheckIPConnectivity();

  await checks;
  equal(
    ncs.IPv6,
    Ci.nsINetworkConnectivityService.NOT_AVAILABLE,
    "Check IPv6 support (expect NOT_AVAILABLE)"
  );

  Services.prefs.setIntPref("network.trr.mode", 2);
  Services.prefs.setCharPref(
    "network.trr.uri",
    `https://foo.example.com:${h2Port}/doh?responseIP=4.4.4.4`
  );
  const override = Cc["@mozilla.org/network/native-dns-override;1"].getService(
    Ci.nsINativeDNSResolverOverride
  );
  override.addIPOverride("ipv6.host.com", "1:1::2");

  await new DNSListener(
    "ipv6.host.com",
    "1:1::2",
    true,
    0,
    "",
    false,
    Ci.nsIDNSService.RESOLVE_DISABLE_IPV4
  );

  Services.prefs.clearUserPref("network.captive-portal-service.testMode");
  Services.prefs.clearUserPref("network.connectivity-service.IPv6.url");

  override.clearOverrides();
  await httpserver.stop();
}).only();
