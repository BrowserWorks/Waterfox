/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Firefox Accounts OAuth Grant Client allows clients to obtain
 * an OAuth token from a BrowserID assertion. Only certain client
 * IDs support this privilage.
 */

this.EXPORTED_SYMBOLS = ["FxAccountsOAuthGrantClient", "FxAccountsOAuthGrantClientError"];

const {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://gre/modules/FxAccountsCommon.js");
Cu.import("resource://services-common/rest.js");

Cu.importGlobalProperties(["URL"]);

const AUTH_ENDPOINT = "/authorization";
const DESTROY_ENDPOINT = "/destroy";

/**
 * Create a new FxAccountsOAuthClient for browser some service.
 *
 * @param {Object} options Options
 *   @param {Object} options.parameters
 *     @param {String} options.parameters.client_id
 *     OAuth id returned from client registration
 *     @param {String} options.parameters.serverURL
 *     The FxA OAuth server URL
 *   @param [authorizationEndpoint] {String}
 *   Optional authorization endpoint for the OAuth server
 * @constructor
 */
this.FxAccountsOAuthGrantClient = function(options) {

  this._validateOptions(options);
  this.parameters = options;

  try {
    this.serverURL = new URL(this.parameters.serverURL);
  } catch (e) {
    throw new Error("Invalid 'serverURL'");
  }

  log.debug("FxAccountsOAuthGrantClient Initialized");
};

this.FxAccountsOAuthGrantClient.prototype = {

  /**
   * Retrieves an OAuth access token for the signed in user
   *
   * @param {Object} assertion BrowserID assertion
   * @param {String} scope OAuth scope
   * @return Promise
   *        Resolves: {Object} Object with access_token property
   */
  getTokenFromAssertion(assertion, scope) {
    if (!assertion) {
      throw new Error("Missing 'assertion' parameter");
    }
    if (!scope) {
      throw new Error("Missing 'scope' parameter");
    }
    let params = {
      scope,
      client_id: this.parameters.client_id,
      assertion,
      response_type: "token"
    };

    return this._createRequest(AUTH_ENDPOINT, "POST", params);
  },

  /**
   * Destroys a previously fetched OAuth access token.
   *
   * @param {String} token The previously fetched token
   * @return Promise
   *        Resolves: {Object} with the server response, which is typically
   *        ignored.
   */
  destroyToken(token) {
    if (!token) {
      throw new Error("Missing 'token' parameter");
    }
    let params = {
      token,
    };

    return this._createRequest(DESTROY_ENDPOINT, "POST", params);
  },

  /**
   * Validates the required FxA OAuth parameters
   *
   * @param options {Object}
   *        OAuth client options
   * @private
   */
  _validateOptions(options) {
    if (!options) {
      throw new Error("Missing configuration options");
    }

    ["serverURL", "client_id"].forEach(option => {
      if (!options[option]) {
        throw new Error("Missing '" + option + "' parameter");
      }
    });
  },

  /**
   * Interface for making remote requests.
   */
  _Request: RESTRequest,

  /**
   * Remote request helper
   *
   * @param {String} path
   *        Profile server path, i.e "/profile".
   * @param {String} [method]
   *        Type of request, i.e "GET".
   * @return Promise
   *         Resolves: {Object} Successful response from the Profile server.
   *         Rejects: {FxAccountsOAuthGrantClientError} Profile client error.
   * @private
   */
  _createRequest(path, method = "POST", params) {
    return new Promise((resolve, reject) => {
      let profileDataUrl = this.serverURL + path;
      let request = new this._Request(profileDataUrl);
      method = method.toUpperCase();

      request.setHeader("Accept", "application/json");
      request.setHeader("Content-Type", "application/json");

      request.onComplete = function(error) {
        if (error) {
          reject(new FxAccountsOAuthGrantClientError({
            error: ERROR_NETWORK,
            errno: ERRNO_NETWORK,
            message: error.toString(),
          }));
          return;
        }

        let body = null;
        try {
          body = JSON.parse(request.response.body);
        } catch (e) {
          reject(new FxAccountsOAuthGrantClientError({
            error: ERROR_PARSE,
            errno: ERRNO_PARSE,
            code: request.response.status,
            message: request.response.body,
          }));
          return;
        }

        // "response.success" means status code is 200
        if (request.response.success) {
          resolve(body);
          return;
        }

        if (typeof body.errno === "number") {
          // Offset oauth server errnos to avoid conflict with other FxA server errnos
          body.errno += OAUTH_SERVER_ERRNO_OFFSET;
        } else if (body.errno) {
          body.errno = ERRNO_UNKNOWN_ERROR;
        }
        reject(new FxAccountsOAuthGrantClientError(body));
      };

      if (method === "POST") {
        request.post(params);
      } else {
        // method not supported
        reject(new FxAccountsOAuthGrantClientError({
          error: ERROR_NETWORK,
          errno: ERRNO_NETWORK,
          code: ERROR_CODE_METHOD_NOT_ALLOWED,
          message: ERROR_MSG_METHOD_NOT_ALLOWED,
        }));
      }
    });
  },

};

/**
 * Normalized profile client errors
 * @param {Object} [details]
 *        Error details object
 *   @param {number} [details.code]
 *          Error code
 *   @param {number} [details.errno]
 *          Error number
 *   @param {String} [details.error]
 *          Error description
 *   @param {String|null} [details.message]
 *          Error message
 * @constructor
 */
this.FxAccountsOAuthGrantClientError = function(details) {
  details = details || {};

  this.name = "FxAccountsOAuthGrantClientError";
  this.code = details.code || null;
  this.errno = details.errno || ERRNO_UNKNOWN_ERROR;
  this.error = details.error || ERROR_UNKNOWN;
  this.message = details.message || null;
};

/**
 * Returns error object properties
 *
 * @returns {{name: *, code: *, errno: *, error: *, message: *}}
 * @private
 */
FxAccountsOAuthGrantClientError.prototype._toStringFields = function() {
  return {
    name: this.name,
    code: this.code,
    errno: this.errno,
    error: this.error,
    message: this.message,
  };
};

/**
 * String representation of a oauth grant client error
 *
 * @returns {String}
 */
FxAccountsOAuthGrantClientError.prototype.toString = function() {
  return this.name + "(" + JSON.stringify(this._toStringFields()) + ")";
};
