/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Child-written alt-data (e.g. JS bytecode) must be bound to the origin that
// produced it, so a different origin loading the same cache entry is not served
// it. The test:
//
//   1. In a top-level document at origin A, writes alt-data for a shared script
//      URL through the child cache-write handle, then reads it back same-origin
//      (served).
//   2. In an origin B iframe embedded in that document, reads the same cache
//      entry. The partition key only contains the top-level site, so both loads
//      share one cache entry. The alt-data must be rejected, so origin B gets
//      the original script instead.

const RESOURCE_URL =
  "https://example.net/browser/netwerk/test/browser/alt_data_cross_origin.sjs";
const PAGE_A = "https://example.com/browser/netwerk/test/browser/dummy.html";
const IFRAME_B = "https://example.org/browser/netwerk/test/browser/dummy.html";

const ALT_TYPE = "text/binary";
const ALT_CONTENT = "bytecode-like-alt-data";
const ORIGINAL = "var original = 1;\n"; // must match alt_data_cross_origin.sjs

// Content-process task: write alt-data for `url` through the child write handle.
async function writeAltDataTask(url, altType, altContent) {
  const { NetUtil } = ChromeUtils.importESModule(
    "resource://gre/modules/NetUtil.sys.mjs"
  );

  const handle = await new Promise(resolve => {
    NetUtil.newChannel({
      uri: url,
      loadingNode: content.document,
      securityFlags: Ci.nsILoadInfo.SEC_ALLOW_CROSS_ORIGIN_INHERITS_SEC_CONTEXT,
      contentPolicyType: Ci.nsIContentPolicy.TYPE_SCRIPT,
    }).asyncOpen({
      QueryInterface: ChromeUtils.generateQI([
        "nsIStreamListener",
        "nsIRequestObserver",
      ]),
      onStartRequest() {},
      onDataAvailable(request, stream, offset, count) {
        const s = Cc["@mozilla.org/scriptableinputstream;1"].createInstance(
          Ci.nsIScriptableInputStream
        );
        s.init(stream);
        s.read(count);
      },
      onStopRequest(request) {
        resolve(
          request
            .QueryInterface(Ci.nsICacheInfoChannel)
            .getCacheEntryWriteHandle()
        );
      },
    });
  });

  const os = handle.openAlternativeOutputStream(altType, altContent.length);
  os.write(altContent, altContent.length);
  os.close();
}

// Content-process task: like writeAltDataTask, but the channel claims
// `forgedOrigin` as its loading and triggering principal, as a compromised
// content process could. The document's cookie jar settings are reused so the
// load shares a cache entry with `forgedOrigin` iframes in this document.
async function writeForgedAltDataTask(url, altType, altContent, forgedOrigin) {
  const { NetUtil } = ChromeUtils.importESModule(
    "resource://gre/modules/NetUtil.sys.mjs"
  );
  const forged =
    Services.scriptSecurityManager.createContentPrincipalFromOrigin(
      forgedOrigin
    );

  const chan = NetUtil.newChannel({
    uri: url,
    loadingPrincipal: forged,
    triggeringPrincipal: forged,
    securityFlags: Ci.nsILoadInfo.SEC_ALLOW_CROSS_ORIGIN_INHERITS_SEC_CONTEXT,
    contentPolicyType: Ci.nsIContentPolicy.TYPE_SCRIPT,
  });
  chan.loadInfo.cookieJarSettings = content.document.cookieJarSettings;

  const handle = await new Promise(resolve => {
    chan.asyncOpen({
      QueryInterface: ChromeUtils.generateQI([
        "nsIStreamListener",
        "nsIRequestObserver",
      ]),
      onStartRequest() {},
      onDataAvailable(request, stream, offset, count) {
        const s = Cc["@mozilla.org/scriptableinputstream;1"].createInstance(
          Ci.nsIScriptableInputStream
        );
        s.init(stream);
        s.read(count);
      },
      onStopRequest(request) {
        resolve(
          request
            .QueryInterface(Ci.nsICacheInfoChannel)
            .getCacheEntryWriteHandle()
        );
      },
    });
  });

  const os = handle.openAlternativeOutputStream(altType, altContent.length);
  os.write(altContent, altContent.length);
  os.close();
}

// Content-process task: cache-only read of `url` preferring alt-data. Returns
// { altType, buffer, status, partitionKey }.
async function readAltDataTask(url, altType) {
  const { NetUtil } = ChromeUtils.importESModule(
    "resource://gre/modules/NetUtil.sys.mjs"
  );

  const chan = NetUtil.newChannel({
    uri: url,
    loadingNode: content.document,
    securityFlags: Ci.nsILoadInfo.SEC_ALLOW_CROSS_ORIGIN_INHERITS_SEC_CONTEXT,
    contentPolicyType: Ci.nsIContentPolicy.TYPE_SCRIPT,
  });
  chan
    .QueryInterface(Ci.nsICacheInfoChannel)
    .preferAlternativeDataType(altType, "", Ci.nsICacheInfoChannel.ASYNC);
  // Cache-only, so a miss fails rather than refetching (which has no alt-data).
  chan.loadFlags |= Ci.nsICachingChannel.LOAD_ONLY_FROM_CACHE;

  return new Promise(resolve => {
    let buffer = "";
    chan.asyncOpen({
      QueryInterface: ChromeUtils.generateQI([
        "nsIStreamListener",
        "nsIRequestObserver",
      ]),
      onStartRequest() {},
      onDataAvailable(request, stream, offset, count) {
        const bi = Cc["@mozilla.org/binaryinputstream;1"].createInstance(
          Ci.nsIBinaryInputStream
        );
        bi.setInputStream(stream);
        while (count > 0) {
          const bytes = bi.readByteArray(Math.min(65535, count));
          buffer += String.fromCharCode.apply(null, bytes);
          count -= bytes.length;
        }
      },
      onStopRequest(request, status) {
        resolve({
          altType: request.QueryInterface(Ci.nsICacheInfoChannel)
            .alternativeDataType,
          buffer,
          status,
          partitionKey: request.loadInfo.cookieJarSettings.partitionKey,
        });
      },
    });
  });
}

add_task(async function test_cross_origin_alt_data_is_rejected() {
  await BrowserTestUtils.withNewTab(PAGE_A, async browser => {
    // Step 1: origin A writes the alt-data and confirms it can read it back.
    await SpecialPowers.spawn(
      browser,
      [RESOURCE_URL, ALT_TYPE, ALT_CONTENT],
      writeAltDataTask
    );

    const control = await SpecialPowers.spawn(
      browser,
      [RESOURCE_URL, ALT_TYPE],
      readAltDataTask
    );
    isnot(control.partitionKey, "", "the cache entry is partitioned");
    is(control.altType, ALT_TYPE, "same-origin read is served the alt-data");
    is(control.buffer, ALT_CONTENT, "same-origin alt-data content matches");

    // Step 2: an origin B iframe reads the same cache entry. It must NOT get
    // A's alt-data.
    await SpecialPowers.spawn(browser, [IFRAME_B], async url => {
      const iframe = content.document.createElement("iframe");
      const loaded = new Promise(resolve =>
        iframe.addEventListener("load", resolve, { once: true })
      );
      iframe.src = url;
      content.document.body.appendChild(iframe);
      await loaded;
    });

    const res = await SpecialPowers.spawn(
      browser.browsingContext.children[0],
      [RESOURCE_URL, ALT_TYPE],
      readAltDataTask
    );
    is(
      res.partitionKey,
      control.partitionKey,
      "the iframe load uses the same partition key as the top-level load"
    );
    ok(
      Components.isSuccessCode(res.status),
      "cross-origin read is a cache hit (LOAD_ONLY_FROM_CACHE)"
    );
    is(
      res.altType,
      "",
      "cross-origin read must NOT be served the other origin's alt-data"
    );
    is(
      res.buffer,
      ORIGINAL,
      "cross-origin read gets the original script instead of the alt-data"
    );
  });
});

// A content process must not be able to bind alt-data to another origin by
// claiming that origin's principal for the load that writes it.
add_task(async function test_forged_principal_alt_data_is_rejected() {
  const url = RESOURCE_URL + "?forged";
  await BrowserTestUtils.withNewTab(PAGE_A, async browser => {
    await SpecialPowers.spawn(
      browser,
      [url, ALT_TYPE, ALT_CONTENT, new URL(IFRAME_B).origin],
      writeForgedAltDataTask
    );

    await SpecialPowers.spawn(browser, [IFRAME_B], async iframeUrl => {
      const iframe = content.document.createElement("iframe");
      const loaded = new Promise(resolve =>
        iframe.addEventListener("load", resolve, { once: true })
      );
      iframe.src = iframeUrl;
      content.document.body.appendChild(iframe);
      await loaded;
    });

    const res = await SpecialPowers.spawn(
      browser.browsingContext.children[0],
      [url, ALT_TYPE],
      readAltDataTask
    );
    ok(
      Components.isSuccessCode(res.status),
      "the read is a cache hit (LOAD_ONLY_FROM_CACHE)"
    );
    is(
      res.altType,
      "",
      "alt-data written under a forged principal must NOT be served"
    );
    is(res.buffer, ORIGINAL, "the read gets the original script instead");
  });
});
