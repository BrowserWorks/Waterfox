/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

Cu.import("resource://services-crypto/utils.js");
Cu.import("resource://services-sync/engines/extension-storage.js");
Cu.import("resource://services-sync/util.js");

/**
 * Like Assert.throws, but for generators.
 *
 * @param {string | Object | function} constraint
 *        What to use to check the exception.
 * @param {function} f
 *        The function to call.
 */
function* throwsGen(constraint, f) {
  let threw = false;
  let exception;
  try {
    yield* f();
  }
  catch (e) {
    threw = true;
    exception = e;
  }

  ok(threw, "did not throw an exception");

  const debuggingMessage = `got ${exception}, expected ${constraint}`;
  let message = exception;
  if (typeof exception === "object") {
    message = exception.message;
  }

  if (typeof constraint === "function") {
    ok(constraint(message), debuggingMessage);
  } else {
    ok(constraint === message, debuggingMessage);
  }

}

/**
 * An EncryptionRemoteTransformer that uses a fixed key bundle,
 * suitable for testing.
 */
class StaticKeyEncryptionRemoteTransformer extends EncryptionRemoteTransformer {
  constructor(keyBundle) {
    super();
    this.keyBundle = keyBundle;
  }

  getKeys() {
    return Promise.resolve(this.keyBundle);
  }
}
const BORING_KB = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";
const STRETCHED_KEY = CryptoUtils.hkdf(BORING_KB, undefined, `testing storage.sync encryption`, 2*32);
const KEY_BUNDLE = {
  sha256HMACHasher: Utils.makeHMACHasher(Ci.nsICryptoHMAC.SHA256, Utils.makeHMACKey(STRETCHED_KEY.slice(0, 32))),
  encryptionKeyB64: btoa(STRETCHED_KEY.slice(32, 64)),
};
const transformer = new StaticKeyEncryptionRemoteTransformer(KEY_BUNDLE);

add_task(function* test_encryption_transformer_roundtrip() {
  const POSSIBLE_DATAS = [
    "string",
    2,          // number
    [1, 2, 3],  // array
    {key: "value"}, // object
  ];

  for (let data of POSSIBLE_DATAS) {
    const record = {data: data, id: "key-some_2D_key", key: "some-key"};

    deepEqual(record, yield transformer.decode(yield transformer.encode(record)));
  }
});

add_task(function* test_refuses_to_decrypt_tampered() {
  const encryptedRecord = yield transformer.encode({data: [1, 2, 3], id: "key-some_2D_key", key: "some-key"});
  const tamperedHMAC = Object.assign({}, encryptedRecord, {hmac: "0000000000000000000000000000000000000000000000000000000000000001"});
  yield* throwsGen(Utils.isHMACMismatch, function*() {
    yield transformer.decode(tamperedHMAC);
  });

  const tamperedIV = Object.assign({}, encryptedRecord, {IV: "aaaaaaaaaaaaaaaaaaaaaa=="});
  yield* throwsGen(Utils.isHMACMismatch, function*() {
    yield transformer.decode(tamperedIV);
  });
});
