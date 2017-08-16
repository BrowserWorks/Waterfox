/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

this.EXPORTED_SYMBOLS = [
  "HAWKAuthenticatedRESTRequest",
  "deriveHawkCredentials"
];

Cu.import("resource://gre/modules/Preferences.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://services-common/rest.js");
Cu.import("resource://services-common/utils.js");
Cu.import("resource://gre/modules/Credentials.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "CryptoUtils",
                                  "resource://services-crypto/utils.js");

const Prefs = new Preferences("services.common.rest.");

/**
 * Single-use HAWK-authenticated HTTP requests to RESTish resources.
 *
 * @param uri
 *        (String) URI for the RESTRequest constructor
 *
 * @param credentials
 *        (Object) Optional credentials for computing HAWK authentication
 *        header.
 *
 * @param payloadObj
 *        (Object) Optional object to be converted to JSON payload
 *
 * @param extra
 *        (Object) Optional extra params for HAWK header computation.
 *        Valid properties are:
 *
 *          now:                 <current time in milliseconds>,
 *          localtimeOffsetMsec: <local clock offset vs server>,
 *          headers:             <An object with header/value pairs to be sent
 *                                as headers on the request>
 *
 * extra.localtimeOffsetMsec is the value in milliseconds that must be added to
 * the local clock to make it agree with the server's clock.  For instance, if
 * the local clock is two minutes ahead of the server, the time offset in
 * milliseconds will be -120000.
 */

this.HAWKAuthenticatedRESTRequest =
 function HawkAuthenticatedRESTRequest(uri, credentials, extra = {}) {
  RESTRequest.call(this, uri);

  this.credentials = credentials;
  this.now = extra.now || Date.now();
  this.localtimeOffsetMsec = extra.localtimeOffsetMsec || 0;
  this._log.trace("local time, offset: " + this.now + ", " + (this.localtimeOffsetMsec));
  this.extraHeaders = extra.headers || {};

  // Expose for testing
  this._intl = getIntl();
};
HAWKAuthenticatedRESTRequest.prototype = {
  __proto__: RESTRequest.prototype,

  dispatch: function dispatch(method, data, onComplete, onProgress) {
    let contentType = "text/plain";
    if (method == "POST" || method == "PUT" || method == "PATCH") {
      contentType = "application/json";
    }
    if (this.credentials) {
      let options = {
        now: this.now,
        localtimeOffsetMsec: this.localtimeOffsetMsec,
        credentials: this.credentials,
        payload: data && JSON.stringify(data) || "",
        contentType,
      };
      let header = CryptoUtils.computeHAWK(this.uri, method, options);
      this.setHeader("Authorization", header.field);
      this._log.trace("hawk auth header: " + header.field);
    }

    for (let header in this.extraHeaders) {
      this.setHeader(header, this.extraHeaders[header]);
    }

    this.setHeader("Content-Type", contentType);

    this.setHeader("Accept-Language", this._intl.accept_languages);

    return RESTRequest.prototype.dispatch.call(
      this, method, data, onComplete, onProgress
    );
  }
};


/**
  * Generic function to derive Hawk credentials.
  *
  * Hawk credentials are derived using shared secrets, which depend on the token
  * in use.
  *
  * @param tokenHex
  *        The current session token encoded in hex
  * @param context
  *        A context for the credentials. A protocol version will be prepended
  *        to the context, see Credentials.keyWord for more information.
  * @param size
  *        The size in bytes of the expected derived buffer,
  *        defaults to 3 * 32.
  * @return credentials
  *        Returns an object:
  *        {
  *          algorithm: sha256
  *          id: the Hawk id (from the first 32 bytes derived)
  *          key: the Hawk key (from bytes 32 to 64)
  *          extra: size - 64 extra bytes (if size > 64)
  *        }
  */
this.deriveHawkCredentials = function deriveHawkCredentials(tokenHex,
                                                            context,
                                                            size = 96,
                                                            hexKey = false) {
  let token = CommonUtils.hexToBytes(tokenHex);
  let out = CryptoUtils.hkdf(token, undefined, Credentials.keyWord(context), size);

  let result = {
    algorithm: "sha256",
    key: hexKey ? CommonUtils.bytesAsHex(out.slice(32, 64)) : out.slice(32, 64),
    id: CommonUtils.bytesAsHex(out.slice(0, 32))
  };
  if (size > 64) {
    result.extra = out.slice(64);
  }

  return result;
}

// With hawk request, we send the user's accepted-languages with each request.
// To keep the number of times we read this pref at a minimum, maintain the
// preference in a stateful object that notices and updates itself when the
// pref is changed.
this.Intl = function Intl() {
  // We won't actually query the pref until the first time we need it
  this._accepted = "";
  this._everRead = false;
  this._log = Log.repository.getLogger("Services.common.RESTRequest");
  this._log.level = Log.Level[Prefs.get("log.logger.rest.request")];
  this.init();
};

this.Intl.prototype = {
  init() {
    Services.prefs.addObserver("intl.accept_languages", this);
  },

  uninit() {
    Services.prefs.removeObserver("intl.accept_languages", this);
  },

  observe(subject, topic, data) {
    this.readPref();
  },

  readPref() {
    this._everRead = true;
    try {
      this._accepted = Services.prefs.getComplexValue(
        "intl.accept_languages", Ci.nsIPrefLocalizedString).data;
    } catch (err) {
      this._log.error("Error reading intl.accept_languages pref", err);
    }
  },

  get accept_languages() {
    if (!this._everRead) {
      this.readPref();
    }
    return this._accepted;
  },
};

// Singleton getter for Intl, creating an instance only when we first need it.
var intl = null;
function getIntl() {
  if (!intl) {
    intl = new Intl();
  }
  return intl;
}

