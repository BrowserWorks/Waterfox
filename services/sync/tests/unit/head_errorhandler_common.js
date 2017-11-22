/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* import-globals-from head_appinfo.js */
/* import-globals-from ../../../common/tests/unit/head_helpers.js */
/* import-globals-from head_helpers.js */
/* import-globals-from head_http_server.js */

// This file expects Service to be defined in the global scope when EHTestsCommon
// is used (from service.js).
/* global Service */

Cu.import("resource://services-sync/engines.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://services-sync/keys.js");

// Common code for test_errorhandler_{1,2}.js -- pulled out to make it less
// monolithic and take less time to execute.
const EHTestsCommon = {

  service_unavailable(request, response) {
    let body = "Service Unavailable";
    response.setStatusLine(request.httpVersion, 503, "Service Unavailable");
    response.setHeader("Retry-After", "42");
    response.bodyOutputStream.write(body, body.length);
  },

  async sync_httpd_setup() {
    let global = new ServerWBO("global", {
      syncID: Service.syncID,
      storageVersion: STORAGE_VERSION,
      engines: {clients: {version: Service.clientsEngine.version,
                          syncID: Service.clientsEngine.syncID},
                catapult: {version: Service.engineManager.get("catapult").version,
                           syncID: Service.engineManager.get("catapult").syncID}}
    });
    let clientsColl = new ServerCollection({}, true);

    // Tracking info/collections.
    let collectionsHelper = track_collections_helper();
    let upd = collectionsHelper.with_updated_collection;

    let handler_401 = httpd_handler(401, "Unauthorized");
    return httpd_setup({
      // Normal server behaviour.
      "/1.1/johndoe/storage/meta/global": upd("meta", global.handler()),
      "/1.1/johndoe/info/collections": collectionsHelper.handler,
      "/1.1/johndoe/storage/crypto/keys":
        upd("crypto", (new ServerWBO("keys")).handler()),
      "/1.1/johndoe/storage/clients": upd("clients", clientsColl.handler()),

      // Credentials are wrong or node reallocated.
      "/1.1/janedoe/storage/meta/global": handler_401,
      "/1.1/janedoe/info/collections": handler_401,

      // Maintenance or overloaded (503 + Retry-After) at info/collections.
      "/1.1/broken.info/info/collections": EHTestsCommon.service_unavailable,

      // Maintenance or overloaded (503 + Retry-After) at meta/global.
      "/1.1/broken.meta/storage/meta/global": EHTestsCommon.service_unavailable,
      "/1.1/broken.meta/info/collections": collectionsHelper.handler,

      // Maintenance or overloaded (503 + Retry-After) at crypto/keys.
      "/1.1/broken.keys/storage/meta/global": upd("meta", global.handler()),
      "/1.1/broken.keys/info/collections": collectionsHelper.handler,
      "/1.1/broken.keys/storage/crypto/keys": EHTestsCommon.service_unavailable,

      // Maintenance or overloaded (503 + Retry-After) at wiping collection.
      "/1.1/broken.wipe/info/collections": collectionsHelper.handler,
      "/1.1/broken.wipe/storage/meta/global": upd("meta", global.handler()),
      "/1.1/broken.wipe/storage/crypto/keys":
        upd("crypto", (new ServerWBO("keys")).handler()),
      "/1.1/broken.wipe/storage": EHTestsCommon.service_unavailable,
      "/1.1/broken.wipe/storage/clients": upd("clients", clientsColl.handler()),
      "/1.1/broken.wipe/storage/catapult": EHTestsCommon.service_unavailable
    });
  },

  CatapultEngine: (function() {
    function CatapultEngine() {
      SyncEngine.call(this, "Catapult", Service);
    }
    CatapultEngine.prototype = {
      __proto__: SyncEngine.prototype,
      exception: null, // tests fill this in
      async _sync() {
        if (this.exception) {
          throw this.exception;
        }
      }
    };

    return CatapultEngine;
  }()),


  generateCredentialsChangedFailure() {
    // Make sync fail due to changed credentials. We simply re-encrypt
    // the keys with a different Sync Key, without changing the local one.
    let newSyncKeyBundle = new BulkKeyBundle("crypto");
    newSyncKeyBundle.generateRandom();
    let keys = Service.collectionKeys.asWBO();
    keys.encrypt(newSyncKeyBundle);
    return keys.upload(Service.resource(Service.cryptoKeysURL));
  },

  async setUp(server) {
    await configureIdentity({ username: "johndoe" }, server);
    return EHTestsCommon.generateAndUploadKeys()
  },

  async generateAndUploadKeys() {
    generateNewKeys(Service.collectionKeys);
    let serverKeys = Service.collectionKeys.asWBO("crypto", "keys");
    serverKeys.encrypt(Service.identity.syncKeyBundle);
    let response = await serverKeys.upload(Service.resource(Service.cryptoKeysURL));
    return response.success;
  }
};
