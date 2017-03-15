/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests the weak crypto override

const TLS_RSA_WITH_RC4_128_MD5         = 0x0004;
const TLS_RSA_WITH_RC4_128_SHA         = 0x0005;
const TLS_ECDHE_ECDSA_WITH_RC4_128_SHA = 0xC007;
const TLS_ECDHE_RSA_WITH_RC4_128_SHA   = 0xC011;

// Need profile dir to store the key / cert
do_get_profile();
// Ensure PSM is initialized
Cc["@mozilla.org/psm;1"].getService(Ci.nsISupports);

const certService = Cc["@mozilla.org/security/local-cert-service;1"]
                    .getService(Ci.nsILocalCertService);
const certOverrideService = Cc["@mozilla.org/security/certoverride;1"]
                            .getService(Ci.nsICertOverrideService);
const weakCryptoOverride = Cc["@mozilla.org/security/weakcryptooverride;1"]
                           .getService(Ci.nsIWeakCryptoOverride);
const socketTransportService =
  Cc["@mozilla.org/network/socket-transport-service;1"]
  .getService(Ci.nsISocketTransportService);

function getCert() {
  let deferred = Promise.defer();
  certService.getOrCreateCert("tls-test", {
    handleCert: function(c, rv) {
      if (rv) {
        deferred.reject(rv);
        return;
      }
      deferred.resolve(c);
    }
  });
  return deferred.promise;
}

function startServer(cert, rc4only) {
  let tlsServer = Cc["@mozilla.org/network/tls-server-socket;1"]
                  .createInstance(Ci.nsITLSServerSocket);
  tlsServer.init(-1, true, -1);
  tlsServer.serverCert = cert;

  let input, output;

  let listener = {
    onSocketAccepted: function(socket, transport) {
      do_print("Accept TLS client connection");
      let connectionInfo = transport.securityInfo
                           .QueryInterface(Ci.nsITLSServerConnectionInfo);
      connectionInfo.setSecurityObserver(listener);
      input = transport.openInputStream(0, 0, 0);
      output = transport.openOutputStream(0, 0, 0);
    },
    onHandshakeDone: function(socket, status) {
      do_print("TLS handshake done");

      equal(status.tlsVersionUsed, Ci.nsITLSClientStatus.TLS_VERSION_1_2,
            "Using TLS 1.2");
      let expectedCipher = rc4only ? "TLS_ECDHE_ECDSA_WITH_RC4_128_SHA"
                                   : "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256";
      equal(status.cipherName, expectedCipher,
            "Using expected cipher");
      equal(status.keyLength, 128, "Using 128-bit key");
      equal(status.macLength, rc4only ? 160 : 128, "Using MAC of expected length");

      input.asyncWait({
        onInputStreamReady: function(streamReadyInput) {
          NetUtil.asyncCopy(streamReadyInput, output);
        }
      }, 0, 0, Services.tm.currentThread);
    },
    onStopListening: function() {}
  };

  tlsServer.setSessionCache(false);
  tlsServer.setSessionTickets(false);
  tlsServer.setRequestClientCertificate(Ci.nsITLSServerSocket.REQUEST_NEVER);
  if (rc4only) {
    let cipherSuites = [
      TLS_ECDHE_RSA_WITH_RC4_128_SHA,
      TLS_ECDHE_ECDSA_WITH_RC4_128_SHA,
      TLS_RSA_WITH_RC4_128_SHA,
      TLS_RSA_WITH_RC4_128_MD5
    ];
    tlsServer.setCipherSuites(cipherSuites, cipherSuites.length);
  }

  tlsServer.asyncListen(listener);

  return tlsServer.port;
}

function storeCertOverride(port, cert) {
  let overrideBits = Ci.nsICertOverrideService.ERROR_UNTRUSTED |
                     Ci.nsICertOverrideService.ERROR_MISMATCH;
  certOverrideService.rememberValidityOverride("127.0.0.1", port, cert,
                                               overrideBits, true);
}

function startClient(port, expectedResult, options = {}) {
  let transport =
    socketTransportService.createTransport(["ssl"], 1, "127.0.0.1", port, null);
  if (options.isPrivate) {
    transport.connectionFlags |= Ci.nsISocketTransport.NO_PERMANENT_STORAGE;
  }
  let input;
  let output;

  let deferred = Promise.defer();

  let handler = {

    onTransportStatus: function(unused, status) {
      if (status === Ci.nsISocketTransport.STATUS_CONNECTED_TO) {
        output.asyncWait(handler, 0, 0, Services.tm.currentThread);
      }
    },

    onInputStreamReady: function(streamReadyInput) {
      try {
        let data =
          NetUtil.readInputStreamToString(streamReadyInput,
                                          streamReadyInput.available());
        equal(Cr.NS_OK, expectedResult, "Connection should succeed");
        equal(data, "HELLO", "Echoed data received");
      } catch (e) {
        if (!((e.result == Cr.NS_ERROR_NET_RESET) && options.allowReset) &&
            (e.result != expectedResult)) {
          deferred.reject(e);
        }
      }
      streamReadyInput.close();
      output.close();
      deferred.resolve();
    },

    onOutputStreamReady: function(streamReadyOutput) {
      try {
        try {
          streamReadyOutput.write("HELLO", 5);
        } catch (e) {
          if (e.result == Cr.NS_BASE_STREAM_WOULD_BLOCK) {
            streamReadyOutput.asyncWait(handler, 0, 0, Services.tm.currentThread);
            return;
          }
          if (e.result != Cr.NS_OK) {
            ok((e.result === expectedResult) ||
               (options.allowReset && (e.result === Cr.NS_ERROR_NET_RESET)),
               "Actual and expected connection result should match");
            streamReadyOutput.close();
            deferred.resolve();
            return;
          }
        }
        do_print("Output to server written");
        input = transport.openInputStream(0, 0, 0);
        input.asyncWait(handler, 0, 0, Services.tm.currentThread);
      } catch (e) {
        deferred.reject(e);
      }
    }

  };

  transport.setEventSink(handler, Services.tm.currentThread);
  output = transport.openOutputStream(Ci.nsITransport.OPEN_UNBUFFERED, 0, 0);
  output.QueryInterface(Ci.nsIAsyncOutputStream);

  return deferred.promise;
}

function run_test() {
  Services.prefs.setBoolPref("security.tls.unrestricted_rc4_fallback", false);
  run_next_test();
}

// for sanity check
add_task(function* () {
  let cert = yield getCert();
  ok(!!cert, "Got self-signed cert");
  let port = startServer(cert, false);
  storeCertOverride(port, cert);
  yield startClient(port, Cr.NS_OK);
  yield startClient(port, Cr.NS_OK, {isPrivate: true});
});

add_task(function* () {
  let cert = yield getCert();
  ok(!!cert, "Got self-signed cert");
  let port = startServer(cert, true);
  storeCertOverride(port, cert);
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP));
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  weakCryptoOverride.addWeakCryptoOverride("127.0.0.1", true);
  // private browsing should not affect the permanent storage.
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP));
  // The auto-retry on connection reset is implemented in our HTTP layer.
  // So we will see the crafted NS_ERROR_NET_RESET when we use
  // nsISocketTransport directly.
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true, allowReset: true});
  // retry manually to simulate the HTTP layer
  yield startClient(port, Cr.NS_OK, {isPrivate: true});

  weakCryptoOverride.removeWeakCryptoOverride("127.0.0.1", port, true);
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP));
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  weakCryptoOverride.addWeakCryptoOverride("127.0.0.1", false, true);
  // temporary override should not change the pref.
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {allowReset: true});
  yield startClient(port, Cr.NS_OK);
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  weakCryptoOverride.removeWeakCryptoOverride("127.0.0.1", port, false);
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP));
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  weakCryptoOverride.addWeakCryptoOverride("127.0.0.1", false);
  // permanent override should change the pref.
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "127.0.0.1");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {allowReset: true});
  yield startClient(port, Cr.NS_OK);
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  weakCryptoOverride.removeWeakCryptoOverride("127.0.0.1", port, false);
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP));
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {isPrivate: true});

  // add a host to the pref to prepare the next test
  weakCryptoOverride.addWeakCryptoOverride("127.0.0.1", false);
  yield startClient(port, getXPCOMStatusFromNSS(SSL_ERROR_NO_CYPHER_OVERLAP),
                    {allowReset: true});
  yield startClient(port, Cr.NS_OK);
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "127.0.0.1");
});

add_task(function* () {
  let cert = yield getCert();
  ok(!!cert, "Got self-signed cert");
  let port = startServer(cert, false);
  storeCertOverride(port, cert);
  yield startClient(port, Cr.NS_OK);
  // Successful strong cipher will remove the host from the pref.
  equal(Services.prefs.getCharPref("security.tls.insecure_fallback_hosts"),
        "");
});
