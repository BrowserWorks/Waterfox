"use strict";

// With network.dns.blockDotOnion, .onion names (RFC 7686) are not resolved,
// in any case and in their fully qualified form ("x.onion.") too. They are
// all listed in network.dns.localDomains, so that a lookup that is not
// blocked succeeds with a loopback address.
const ONION_NAMES = [
  "private.onion",
  "private.onion.",
  "PRIVATE.ONION",
  "Private.Onion.",
];

// Blocked as well, but only checked when blocked: network.dns.localDomains
// matches a name with at most one trailing dot.
const BLOCKED_ONLY_NAMES = ["private.onion.."];

// A blocked name is refused before any lookup: asyncResolve throws, whereas a
// failed lookup is reported to the listener.

function resolve(host) {
  return new Promise(resolvePromise => {
    try {
      Services.dns.asyncResolve(
        host,
        Ci.nsIDNSService.RESOLVE_TYPE_DEFAULT,
        0,
        null, // resolverInfo
        {
          onLookupComplete(inRequest, inRecord, inStatus) {
            resolvePromise({
              status: inStatus,
              record: inRecord,
              refused: false,
            });
          },
          QueryInterface: ChromeUtils.generateQI(["nsIDNSListener"]),
        },
        Services.tm.currentThread,
        {} // defaultOriginAttributes
      );
    } catch (e) {
      resolvePromise({ status: e.result, record: null, refused: true });
    }
  });
}

add_setup(function () {
  Services.prefs.setCharPref(
    "network.dns.localDomains",
    "private.onion, PRIVATE.ONION, Private.Onion"
  );
  registerCleanupFunction(() => {
    Services.prefs.clearUserPref("network.dns.localDomains");
    Services.prefs.clearUserPref("network.dns.blockDotOnion");
  });
});

add_task(async function test_block() {
  Services.prefs.setBoolPref("network.dns.blockDotOnion", true);
  for (const host of [...ONION_NAMES, ...BLOCKED_ONLY_NAMES]) {
    const { status, refused } = await resolve(host);
    Assert.ok(refused, `${host} is refused before any lookup`);
    Assert.equal(status, Cr.NS_ERROR_UNKNOWN_HOST, `${host} is not resolved`);
  }
});

add_task(async function test_dont_block() {
  Services.prefs.setBoolPref("network.dns.blockDotOnion", false);
  for (const host of ONION_NAMES) {
    const { status, record } = await resolve(host);
    Assert.ok(Components.isSuccessCode(status), `${host} is resolved`);
    const answer = record
      .QueryInterface(Ci.nsIDNSAddrRecord)
      .getNextAddrAsString();
    Assert.ok(
      answer == "127.0.0.1" || answer == "::1",
      `${host} is resolved to a loopback address`
    );
  }
});
