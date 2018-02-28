/*
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * This file is generated from kinto-http.js - do not modify directly.
 */

const global = this;

this.EXPORTED_SYMBOLS = ["KintoHttpClient"];

/*
 * Version 4.3.4 - 1294207
 */

(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.KintoHttpClient = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/*
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _base = require("../src/base");

var _base2 = _interopRequireDefault(_base);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const Cu = Components.utils;

Cu.import("resource://gre/modules/Timer.jsm");
Cu.importGlobalProperties(['fetch']);
const { EventEmitter } = Cu.import("resource://gre/modules/EventEmitter.jsm", {});

let KintoHttpClient = class KintoHttpClient extends _base2.default {
  constructor(remote, options = {}) {
    const events = {};
    EventEmitter.decorate(events);
    super(remote, _extends({ events }, options));
  }
};

// This fixes compatibility with CommonJS required by browserify.
// See http://stackoverflow.com/questions/33505992/babel-6-changes-how-it-exports-default/33683495#33683495

exports.default = KintoHttpClient;
if (typeof module === "object") {
  module.exports = KintoHttpClient;
}

},{"../src/base":7}],2:[function(require,module,exports){
var v1 = require('./v1');
var v4 = require('./v4');

var uuid = v4;
uuid.v1 = v1;
uuid.v4 = v4;

module.exports = uuid;

},{"./v1":5,"./v4":6}],3:[function(require,module,exports){
/**
 * Convert array of 16 byte values to UUID string format of the form:
 * XXXXXXXX-XXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
 */
var byteToHex = [];
for (var i = 0; i < 256; ++i) {
  byteToHex[i] = (i + 0x100).toString(16).substr(1);
}

function bytesToUuid(buf, offset) {
  var i = offset || 0;
  var bth = byteToHex;
  return  bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] + '-' +
          bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]] +
          bth[buf[i++]] + bth[buf[i++]];
}

module.exports = bytesToUuid;

},{}],4:[function(require,module,exports){
// Unique ID creation requires a high quality random # generator.  In the
// browser this is a little complicated due to unknown quality of Math.random()
// and inconsistent support for the `crypto` API.  We do the best we can via
// feature-detection
var rng;

var crypto = global.crypto || global.msCrypto; // for IE 11
if (crypto && crypto.getRandomValues) {
  // WHATWG crypto RNG - http://wiki.whatwg.org/wiki/Crypto
  var rnds8 = new Uint8Array(16);
  rng = function whatwgRNG() {
    crypto.getRandomValues(rnds8);
    return rnds8;
  };
}

if (!rng) {
  // Math.random()-based (RNG)
  //
  // If all else fails, use Math.random().  It's fast, but is of unspecified
  // quality.
  var  rnds = new Array(16);
  rng = function() {
    for (var i = 0, r; i < 16; i++) {
      if ((i & 0x03) === 0) r = Math.random() * 0x100000000;
      rnds[i] = r >>> ((i & 0x03) << 3) & 0xff;
    }

    return rnds;
  };
}

module.exports = rng;

},{}],5:[function(require,module,exports){
// Unique ID creation requires a high quality random # generator.  We feature
// detect to determine the best RNG source, normalizing to a function that
// returns 128-bits of randomness, since that's what's usually required
var rng = require('./lib/rng');
var bytesToUuid = require('./lib/bytesToUuid');

// **`v1()` - Generate time-based UUID**
//
// Inspired by https://github.com/LiosK/UUID.js
// and http://docs.python.org/library/uuid.html

// random #'s we need to init node and clockseq
var _seedBytes = rng();

// Per 4.5, create and 48-bit node id, (47 random bits + multicast bit = 1)
var _nodeId = [
  _seedBytes[0] | 0x01,
  _seedBytes[1], _seedBytes[2], _seedBytes[3], _seedBytes[4], _seedBytes[5]
];

// Per 4.2.2, randomize (14 bit) clockseq
var _clockseq = (_seedBytes[6] << 8 | _seedBytes[7]) & 0x3fff;

// Previous uuid creation time
var _lastMSecs = 0, _lastNSecs = 0;

// See https://github.com/broofa/node-uuid for API details
function v1(options, buf, offset) {
  var i = buf && offset || 0;
  var b = buf || [];

  options = options || {};

  var clockseq = options.clockseq !== undefined ? options.clockseq : _clockseq;

  // UUID timestamps are 100 nano-second units since the Gregorian epoch,
  // (1582-10-15 00:00).  JSNumbers aren't precise enough for this, so
  // time is handled internally as 'msecs' (integer milliseconds) and 'nsecs'
  // (100-nanoseconds offset from msecs) since unix epoch, 1970-01-01 00:00.
  var msecs = options.msecs !== undefined ? options.msecs : new Date().getTime();

  // Per 4.2.1.2, use count of uuid's generated during the current clock
  // cycle to simulate higher resolution clock
  var nsecs = options.nsecs !== undefined ? options.nsecs : _lastNSecs + 1;

  // Time since last uuid creation (in msecs)
  var dt = (msecs - _lastMSecs) + (nsecs - _lastNSecs)/10000;

  // Per 4.2.1.2, Bump clockseq on clock regression
  if (dt < 0 && options.clockseq === undefined) {
    clockseq = clockseq + 1 & 0x3fff;
  }

  // Reset nsecs if clock regresses (new clockseq) or we've moved onto a new
  // time interval
  if ((dt < 0 || msecs > _lastMSecs) && options.nsecs === undefined) {
    nsecs = 0;
  }

  // Per 4.2.1.2 Throw error if too many uuids are requested
  if (nsecs >= 10000) {
    throw new Error('uuid.v1(): Can\'t create more than 10M uuids/sec');
  }

  _lastMSecs = msecs;
  _lastNSecs = nsecs;
  _clockseq = clockseq;

  // Per 4.1.4 - Convert from unix epoch to Gregorian epoch
  msecs += 12219292800000;

  // `time_low`
  var tl = ((msecs & 0xfffffff) * 10000 + nsecs) % 0x100000000;
  b[i++] = tl >>> 24 & 0xff;
  b[i++] = tl >>> 16 & 0xff;
  b[i++] = tl >>> 8 & 0xff;
  b[i++] = tl & 0xff;

  // `time_mid`
  var tmh = (msecs / 0x100000000 * 10000) & 0xfffffff;
  b[i++] = tmh >>> 8 & 0xff;
  b[i++] = tmh & 0xff;

  // `time_high_and_version`
  b[i++] = tmh >>> 24 & 0xf | 0x10; // include version
  b[i++] = tmh >>> 16 & 0xff;

  // `clock_seq_hi_and_reserved` (Per 4.2.2 - include variant)
  b[i++] = clockseq >>> 8 | 0x80;

  // `clock_seq_low`
  b[i++] = clockseq & 0xff;

  // `node`
  var node = options.node || _nodeId;
  for (var n = 0; n < 6; ++n) {
    b[i + n] = node[n];
  }

  return buf ? buf : bytesToUuid(b);
}

module.exports = v1;

},{"./lib/bytesToUuid":3,"./lib/rng":4}],6:[function(require,module,exports){
var rng = require('./lib/rng');
var bytesToUuid = require('./lib/bytesToUuid');

function v4(options, buf, offset) {
  var i = buf && offset || 0;

  if (typeof(options) == 'string') {
    buf = options == 'binary' ? new Array(16) : null;
    options = null;
  }
  options = options || {};

  var rnds = options.random || (options.rng || rng)();

  // Per 4.4, set bits for version and `clock_seq_hi_and_reserved`
  rnds[6] = (rnds[6] & 0x0f) | 0x40;
  rnds[8] = (rnds[8] & 0x3f) | 0x80;

  // Copy bytes to buffer, if provided
  if (buf) {
    for (var ii = 0; ii < 16; ++ii) {
      buf[i + ii] = rnds[ii];
    }
  }

  return buf || bytesToUuid(rnds);
}

module.exports = v4;

},{"./lib/bytesToUuid":3,"./lib/rng":4}],7:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = exports.SUPPORTED_PROTOCOL_VERSION = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _dec, _dec2, _dec3, _dec4, _dec5, _dec6, _dec7, _desc, _value, _class;

var _utils = require("./utils");

var _http = require("./http");

var _http2 = _interopRequireDefault(_http);

var _endpoint = require("./endpoint");

var _endpoint2 = _interopRequireDefault(_endpoint);

var _requests = require("./requests");

var requests = _interopRequireWildcard(_requests);

var _batch = require("./batch");

var _bucket = require("./bucket");

var _bucket2 = _interopRequireDefault(_bucket);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) {
  var desc = {};
  Object['ke' + 'ys'](descriptor).forEach(function (key) {
    desc[key] = descriptor[key];
  });
  desc.enumerable = !!desc.enumerable;
  desc.configurable = !!desc.configurable;

  if ('value' in desc || desc.initializer) {
    desc.writable = true;
  }

  desc = decorators.slice().reverse().reduce(function (desc, decorator) {
    return decorator(target, property, desc) || desc;
  }, desc);

  if (context && desc.initializer !== void 0) {
    desc.value = desc.initializer ? desc.initializer.call(context) : void 0;
    desc.initializer = undefined;
  }

  if (desc.initializer === void 0) {
    Object['define' + 'Property'](target, property, desc);
    desc = null;
  }

  return desc;
}

/**
 * Currently supported protocol version.
 * @type {String}
 */
const SUPPORTED_PROTOCOL_VERSION = exports.SUPPORTED_PROTOCOL_VERSION = "v1";

/**
 * High level HTTP client for the Kinto API.
 *
 * @example
 * const client = new KintoClient("https://kinto.dev.mozaws.net/v1");
 * client.bucket("default")
*    .collection("my-blog")
*    .createRecord({title: "First article"})
 *   .then(console.log.bind(console))
 *   .catch(console.error.bind(console));
 */
let KintoClientBase = (_dec = (0, _utils.nobatch)("This operation is not supported within a batch operation."), _dec2 = (0, _utils.nobatch)("This operation is not supported within a batch operation."), _dec3 = (0, _utils.nobatch)("This operation is not supported within a batch operation."), _dec4 = (0, _utils.nobatch)("This operation is not supported within a batch operation."), _dec5 = (0, _utils.nobatch)("Can't use batch within a batch!"), _dec6 = (0, _utils.capable)(["permissions_endpoint"]), _dec7 = (0, _utils.support)("1.4", "2.0"), (_class = class KintoClientBase {
  /**
   * Constructor.
   *
   * @param  {String}       remote  The remote URL.
   * @param  {Object}       [options={}]                  The options object.
   * @param  {Boolean}      [options.safe=true]           Adds concurrency headers to every requests.
   * @param  {EventEmitter} [options.events=EventEmitter] The events handler instance.
   * @param  {Object}       [options.headers={}]          The key-value headers to pass to each request.
   * @param  {Object}       [options.retry=0]             Number of retries when request fails (default: 0)
   * @param  {String}       [options.bucket="default"]    The default bucket to use.
   * @param  {String}       [options.requestMode="cors"]  The HTTP request mode (from ES6 fetch spec).
   * @param  {Number}       [options.timeout=null]        The request timeout in ms, if any.
   */
  constructor(remote, options = {}) {
    if (typeof remote !== "string" || !remote.length) {
      throw new Error("Invalid remote URL: " + remote);
    }
    if (remote[remote.length - 1] === "/") {
      remote = remote.slice(0, -1);
    }
    this._backoffReleaseTime = null;

    this._requests = [];
    this._isBatch = !!options.batch;
    this._retry = options.retry || 0;
    this._safe = !!options.safe;
    this._headers = options.headers || {};

    // public properties
    /**
     * The remote server base URL.
     * @type {String}
     */
    this.remote = remote;
    /**
     * Current server information.
     * @ignore
     * @type {Object|null}
     */
    this.serverInfo = null;
    /**
     * The event emitter instance. Should comply with the `EventEmitter`
     * interface.
     * @ignore
     * @type {Class}
     */
    this.events = options.events;

    const { requestMode, timeout } = options;
    /**
     * The HTTP instance.
     * @ignore
     * @type {HTTP}
     */
    this.http = new _http2.default(this.events, { requestMode, timeout });
    this._registerHTTPEvents();
  }

  /**
   * The remote endpoint base URL. Setting the value will also extract and
   * validate the version.
   * @type {String}
   */
  get remote() {
    return this._remote;
  }

  /**
   * @ignore
   */
  set remote(url) {
    let version;
    try {
      version = url.match(/\/(v\d+)\/?$/)[1];
    } catch (err) {
      throw new Error("The remote URL must contain the version: " + url);
    }
    if (version !== SUPPORTED_PROTOCOL_VERSION) {
      throw new Error(`Unsupported protocol version: ${version}`);
    }
    this._remote = url;
    this._version = version;
  }

  /**
   * The current server protocol version, eg. `v1`.
   * @type {String}
   */
  get version() {
    return this._version;
  }

  /**
   * Backoff remaining time, in milliseconds. Defaults to zero if no backoff is
   * ongoing.
   *
   * @type {Number}
   */
  get backoff() {
    const currentTime = new Date().getTime();
    if (this._backoffReleaseTime && currentTime < this._backoffReleaseTime) {
      return this._backoffReleaseTime - currentTime;
    }
    return 0;
  }

  /**
   * Registers HTTP events.
   * @private
   */
  _registerHTTPEvents() {
    // Prevent registering event from a batch client instance
    if (!this._isBatch) {
      this.events.on("backoff", backoffMs => {
        this._backoffReleaseTime = backoffMs;
      });
    }
  }

  /**
   * Retrieve a bucket object to perform operations on it.
   *
   * @param  {String}  name              The bucket name.
   * @param  {Object}  [options={}]      The request options.
   * @param  {Boolean} [options.safe]    The resulting safe option.
   * @param  {Number}  [options.retry]   The resulting retry option.
   * @param  {Object}  [options.headers] The extended headers object option.
   * @return {Bucket}
   */
  bucket(name, options = {}) {
    return new _bucket2.default(this, name, {
      batch: this._isBatch,
      headers: this._getHeaders(options),
      safe: this._getSafe(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Get the value of "headers" for a given request, merging the
   * per-request headers with our own "default" headers.
   *
   * Note that unlike other options, headers aren't overridden, but
   * merged instead.
   *
   * @private
   * @param {Object} options The options for a request.
   * @returns {Object}
   */
  _getHeaders(options) {
    return _extends({}, this._headers, options.headers);
  }

  /**
   * Get the value of "safe" for a given request, using the
   * per-request option if present or falling back to our default
   * otherwise.
   *
   * @private
   * @param {Object} options The options for a request.
   * @returns {Boolean}
   */
  _getSafe(options) {
    return _extends({ safe: this._safe }, options).safe;
  }

  /**
   * As _getSafe, but for "retry".
   *
   * @private
   */
  _getRetry(options) {
    return _extends({ retry: this._retry }, options).retry;
  }

  /**
   * Retrieves the server's "hello" endpoint. This endpoint reveals
   * server capabilities and settings as well as telling the client
   * "who they are" according to their given authorization headers.
   *
   * @private
   * @param  {Object}  [options={}] The request options.
   * @param  {Object}  [options.headers={}] Headers to use when making
   *     this request.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async _getHello(options = {}) {
    const path = this.remote + (0, _endpoint2.default)("root");
    const { json } = await this.http.request(path, { headers: this._getHeaders(options) }, { retry: this._getRetry(options) });
    return json;
  }

  /**
   * Retrieves server information and persist them locally. This operation is
   * usually performed a single time during the instance lifecycle.
   *
   * @param  {Object}  [options={}] The request options.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async fetchServerInfo(options = {}) {
    if (this.serverInfo) {
      return this.serverInfo;
    }
    this.serverInfo = await this._getHello({ retry: this._getRetry(options) });
    return this.serverInfo;
  }

  /**
   * Retrieves Kinto server settings.
   *
   * @param  {Object}  [options={}] The request options.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */

  async fetchServerSettings(options) {
    const { settings } = await this.fetchServerInfo(options);
    return settings;
  }

  /**
   * Retrieve server capabilities information.
   *
   * @param  {Object}  [options={}] The request options.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */

  async fetchServerCapabilities(options = {}) {
    const { capabilities } = await this.fetchServerInfo(options);
    return capabilities;
  }

  /**
   * Retrieve authenticated user information.
   *
   * @param  {Object}  [options={}] The request options.
   * @param  {Object}  [options.headers={}] Headers to use when making
   *     this request.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */

  async fetchUser(options = {}) {
    const { user } = await this._getHello(options);
    return user;
  }

  /**
   * Retrieve authenticated user information.
   *
   * @param  {Object}  [options={}] The request options.
   * @param  {Number}  [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */

  async fetchHTTPApiVersion(options = {}) {
    const { http_api_version } = await this.fetchServerInfo(options);
    return http_api_version;
  }

  /**
   * Process batch requests, chunking them according to the batch_max_requests
   * server setting when needed.
   *
   * @param  {Array}  requests     The list of batch subrequests to perform.
   * @param  {Object} [options={}] The options object.
   * @return {Promise<Object, Error>}
   */
  async _batchRequests(requests, options = {}) {
    const headers = this._getHeaders(options);
    if (!requests.length) {
      return [];
    }
    const serverSettings = await this.fetchServerSettings({
      retry: this._getRetry(options)
    });
    const maxRequests = serverSettings["batch_max_requests"];
    if (maxRequests && requests.length > maxRequests) {
      const chunks = (0, _utils.partition)(requests, maxRequests);
      return (0, _utils.pMap)(chunks, chunk => this._batchRequests(chunk, options));
    }
    const { responses } = await this.execute({
      // FIXME: is this really necessary, since it's also present in
      // the "defaults"?
      headers,
      path: (0, _endpoint2.default)("batch"),
      method: "POST",
      body: {
        defaults: { headers },
        requests
      }
    }, { retry: this._getRetry(options) });
    return responses;
  }

  /**
   * Sends batch requests to the remote server.
   *
   * Note: Reserved for internal use only.
   *
   * @ignore
   * @param  {Function} fn                        The function to use for describing batch ops.
   * @param  {Object}   [options={}]              The options object.
   * @param  {Boolean}  [options.safe]            The safe option.
   * @param  {Number}   [options.retry]           The retry option.
   * @param  {String}   [options.bucket]          The bucket name option.
   * @param  {String}   [options.collection]      The collection name option.
   * @param  {Object}   [options.headers]         The headers object option.
   * @param  {Boolean}  [options.aggregate=false] Produces an aggregated result object.
   * @return {Promise<Object, Error>}
   */

  async batch(fn, options = {}) {
    const rootBatch = new KintoClientBase(this.remote, {
      events: this.events,
      batch: true,
      safe: this._getSafe(options),
      retry: this._getRetry(options)
    });
    let bucketBatch, collBatch;
    if (options.bucket) {
      bucketBatch = rootBatch.bucket(options.bucket);
      if (options.collection) {
        collBatch = bucketBatch.collection(options.collection);
      }
    }
    const batchClient = collBatch || bucketBatch || rootBatch;
    fn(batchClient);
    const responses = await this._batchRequests(rootBatch._requests, options);
    if (options.aggregate) {
      return (0, _batch.aggregate)(responses, rootBatch._requests);
    } else {
      return responses;
    }
  }

  /**
   * Executes an atomic HTTP request.
   *
   * @private
   * @param  {Object}  request             The request object.
   * @param  {String}  request.path        The path to fetch, relative
   *     to the Kinto server root.
   * @param  {String}  [request.method="GET"] The method to use in the
   *     request.
   * @param  {Body}    [request.body]      The request body.
   * @param  {Object}  [request.headers={}] The request headers.
   * @param  {Object}  [options={}]        The options object.
   * @param  {Boolean} [options.raw=false] If true, resolve with full response
   * @param  {Boolean} [options.stringify=true] If true, serialize body data to
   * @param  {Number}  [options.retry=0]   The number of times to
   *     retry a request if the server responds with Retry-After.
   * JSON.
   * @return {Promise<Object, Error>}
   */
  async execute(request, options = {}) {
    const { raw = false, stringify = true } = options;
    // If we're within a batch, add the request to the stack to send at once.
    if (this._isBatch) {
      this._requests.push(request);
      // Resolve with a message in case people attempt at consuming the result
      // from within a batch operation.
      const msg = "This result is generated from within a batch " + "operation and should not be consumed.";
      return raw ? { json: msg, headers: { get() {} } } : msg;
    }
    const result = await this.http.request(this.remote + request.path, (0, _utils.cleanUndefinedProperties)({
      // Limit requests to only those parts that would be allowed in
      // a batch request -- don't pass through other fancy fetch()
      // options like integrity, redirect, mode because they will
      // break on a batch request.  A batch request only allows
      // headers, method, path (above), and body.
      method: request.method,
      headers: request.headers,
      body: stringify ? JSON.stringify(request.body) : request.body
    }), { retry: this._getRetry(options) });
    return raw ? result : result.json;
  }

  /**
   * Fetch some pages from a paginated list, following the `next-page`
   * header automatically until we have fetched the requested number
   * of pages. Return a response with a `.next()` method that can be
   * called to fetch more results.
   *
   * @private
   * @param  {String}  path
   *     The path to make the request to.
   * @param  {Object}  params
   *     The parameters to use when making the request.
   * @param  {String}  [params.sort="-last_modified"]
   *     The sorting order to use when fetching.
   * @param  {Object}  [params.filters={}]
   *     The filters to send in the request.
   * @param  {Number}  [params.limit=undefined]
   *     The limit to send in the request. Undefined means no limit.
   * @param  {Number}  [params.pages=undefined]
   *     The number of pages to fetch. Undefined means one page. Pass
   *     Infinity to fetch everything.
   * @param  {String}  [params.since=undefined]
   *     The ETag from which to start fetching.
   * @param  {Object}  [options={}]
   *     Additional request-level parameters to use in all requests.
   * @param  {Object}  [options.headers={}]
   *     Headers to use during all requests.
   * @param  {Number}  [options.retry=0]
   *     Number of times to retry each request if the server responds
   *     with Retry-After.
   */
  async paginatedList(path, params, options = {}) {
    // FIXME: this is called even in batch requests, which doesn't
    // make any sense (since all batch requests get a "dummy"
    // response; see execute() above).
    const { sort, filters, limit, pages, since } = _extends({
      sort: "-last_modified"
    }, params);
    // Safety/Consistency check on ETag value.
    if (since && typeof since !== "string") {
      throw new Error(`Invalid value for since (${since}), should be ETag value.`);
    }

    const querystring = (0, _utils.qsify)(_extends({}, filters, {
      _sort: sort,
      _limit: limit,
      _since: since
    }));
    let results = [],
        current = 0;

    const next = async function (nextPage) {
      if (!nextPage) {
        throw new Error("Pagination exhausted.");
      }
      return processNextPage(nextPage);
    };

    const processNextPage = async nextPage => {
      const { headers } = options;
      return handleResponse((await this.http.request(nextPage, { headers })));
    };

    const pageResults = (results, nextPage, etag, totalRecords) => {
      // ETag string is supposed to be opaque and stored «as-is».
      // ETag header values are quoted (because of * and W/"foo").
      return {
        last_modified: etag ? etag.replace(/"/g, "") : etag,
        data: results,
        next: next.bind(null, nextPage),
        hasNextPage: !!nextPage,
        totalRecords
      };
    };

    const handleResponse = async function ({ headers, json }) {
      const nextPage = headers.get("Next-Page");
      const etag = headers.get("ETag");
      const totalRecords = parseInt(headers.get("Total-Records"), 10);

      if (!pages) {
        return pageResults(json.data, nextPage, etag, totalRecords);
      }
      // Aggregate new results with previous ones
      results = results.concat(json.data);
      current += 1;
      if (current >= pages || !nextPage) {
        // Pagination exhausted
        return pageResults(results, nextPage, etag, totalRecords);
      }
      // Follow next page
      return processNextPage(nextPage);
    };

    return handleResponse((await this.execute(
    // N.B.: This doesn't use _getHeaders, because all calls to
    // `paginatedList` are assumed to come from calls that already
    // have headers merged at e.g. the bucket or collection level.
    { headers: options.headers, path: path + "?" + querystring },
    // N.B. This doesn't use _getRetry, because all calls to
    // `paginatedList` are assumed to come from calls that already
    // used `_getRetry` at e.g. the bucket or collection level.
    { raw: true, retry: options.retry || 0 })));
  }

  /**
   * Lists all permissions.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers={}] Headers to use when making
   *     this request.
   * @param  {Number} [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object[], Error>}
   */

  async listPermissions(options = {}) {
    const path = (0, _endpoint2.default)("permissions");
    // Ensure the default sort parameter is something that exists in permissions
    // entries, as `last_modified` doesn't; here, we pick "id".
    const paginationOptions = _extends({ sort: "id" }, options);
    return this.paginatedList(path, paginationOptions, {
      headers: this._getHeaders(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Retrieves the list of buckets.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers={}] Headers to use when making
   *     this request.
   * @param  {Number} [options.retry=0]    Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object[], Error>}
   */
  async listBuckets(options = {}) {
    const path = (0, _endpoint2.default)("bucket");
    return this.paginatedList(path, options, {
      headers: this._getHeaders(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Creates a new bucket on the server.
   *
   * @param  {String|null}  id                The bucket name (optional).
   * @param  {Object}       [options={}]      The options object.
   * @param  {Boolean}      [options.data]    The bucket data option.
   * @param  {Boolean}      [options.safe]    The safe option.
   * @param  {Object}       [options.headers] The headers object option.
   * @param  {Number}       [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async createBucket(id, options = {}) {
    const { data = {}, permissions } = options;
    if (id != null) {
      data.id = id;
    }
    const path = data.id ? (0, _endpoint2.default)("bucket", data.id) : (0, _endpoint2.default)("bucket");
    return this.execute(requests.createRequest(path, { data, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    }), { retry: this._getRetry(options) });
  }

  /**
   * Deletes a bucket from the server.
   *
   * @ignore
   * @param  {Object|String} bucket                  The bucket to delete.
   * @param  {Object}        [options={}]            The options object.
   * @param  {Boolean}       [options.safe]          The safe option.
   * @param  {Object}        [options.headers]       The headers object option.
   * @param  {Number}        [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Number}        [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async deleteBucket(bucket, options = {}) {
    const bucketObj = (0, _utils.toDataBody)(bucket);
    if (!bucketObj.id) {
      throw new Error("A bucket id is required.");
    }
    const path = (0, _endpoint2.default)("bucket", bucketObj.id);
    const { last_modified } = _extends({}, bucketObj, options);
    return this.execute(requests.deleteRequest(path, {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    }), { retry: this._getRetry(options) });
  }

  /**
   * Deletes all buckets on the server.
   *
   * @ignore
   * @param  {Object}  [options={}]            The options object.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */

  async deleteBuckets(options = {}) {
    const path = (0, _endpoint2.default)("bucket");
    return this.execute(requests.deleteRequest(path, {
      last_modified: options.last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    }), { retry: this._getRetry(options) });
  }
}, (_applyDecoratedDescriptor(_class.prototype, "fetchServerSettings", [_dec], Object.getOwnPropertyDescriptor(_class.prototype, "fetchServerSettings"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "fetchServerCapabilities", [_dec2], Object.getOwnPropertyDescriptor(_class.prototype, "fetchServerCapabilities"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "fetchUser", [_dec3], Object.getOwnPropertyDescriptor(_class.prototype, "fetchUser"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "fetchHTTPApiVersion", [_dec4], Object.getOwnPropertyDescriptor(_class.prototype, "fetchHTTPApiVersion"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "batch", [_dec5], Object.getOwnPropertyDescriptor(_class.prototype, "batch"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "listPermissions", [_dec6], Object.getOwnPropertyDescriptor(_class.prototype, "listPermissions"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "deleteBuckets", [_dec7], Object.getOwnPropertyDescriptor(_class.prototype, "deleteBuckets"), _class.prototype)), _class));
exports.default = KintoClientBase;

},{"./batch":8,"./bucket":9,"./endpoint":11,"./http":13,"./requests":14,"./utils":15}],8:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.aggregate = aggregate;
/**
 * Exports batch responses as a result object.
 *
 * @private
 * @param  {Array} responses The batch subrequest responses.
 * @param  {Array} requests  The initial issued requests.
 * @return {Object}
 */
function aggregate(responses = [], requests = []) {
  if (responses.length !== requests.length) {
    throw new Error("Responses length should match requests one.");
  }
  const results = {
    errors: [],
    published: [],
    conflicts: [],
    skipped: []
  };
  return responses.reduce((acc, response, index) => {
    const { status } = response;
    const request = requests[index];
    if (status >= 200 && status < 400) {
      acc.published.push(response.body);
    } else if (status === 404) {
      // Extract the id manually from request path while waiting for Kinto/kinto#818
      const regex = /(buckets|groups|collections|records)\/([^\/]+)$/;
      const extracts = request.path.match(regex);
      const id = extracts.length === 3 ? extracts[2] : undefined;
      acc.skipped.push({
        id,
        path: request.path,
        error: response.body
      });
    } else if (status === 412) {
      acc.conflicts.push({
        // XXX: specifying the type is probably superfluous
        type: "outgoing",
        local: request.body,
        remote: response.body.details && response.body.details.existing || null
      });
    } else {
      acc.errors.push({
        path: request.path,
        sent: request,
        error: response.body
      });
    }
    return acc;
  }, results);
}

},{}],9:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _dec, _desc, _value, _class;

var _utils = require("./utils");

var _collection = require("./collection");

var _collection2 = _interopRequireDefault(_collection);

var _requests = require("./requests");

var requests = _interopRequireWildcard(_requests);

var _endpoint = require("./endpoint");

var _endpoint2 = _interopRequireDefault(_endpoint);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) {
  var desc = {};
  Object['ke' + 'ys'](descriptor).forEach(function (key) {
    desc[key] = descriptor[key];
  });
  desc.enumerable = !!desc.enumerable;
  desc.configurable = !!desc.configurable;

  if ('value' in desc || desc.initializer) {
    desc.writable = true;
  }

  desc = decorators.slice().reverse().reduce(function (desc, decorator) {
    return decorator(target, property, desc) || desc;
  }, desc);

  if (context && desc.initializer !== void 0) {
    desc.value = desc.initializer ? desc.initializer.call(context) : void 0;
    desc.initializer = undefined;
  }

  if (desc.initializer === void 0) {
    Object['define' + 'Property'](target, property, desc);
    desc = null;
  }

  return desc;
}

/**
 * Abstract representation of a selected bucket.
 *
 */
let Bucket = (_dec = (0, _utils.capable)(["history"]), (_class = class Bucket {
  /**
   * Constructor.
   *
   * @param  {KintoClient} client            The client instance.
   * @param  {String}      name              The bucket name.
   * @param  {Object}      [options={}]      The headers object option.
   * @param  {Object}      [options.headers] The headers object option.
   * @param  {Boolean}     [options.safe]    The safe option.
   * @param  {Number}      [options.retry]   The retry option.
   */
  constructor(client, name, options = {}) {
    /**
     * @ignore
     */
    this.client = client;
    /**
     * The bucket name.
     * @type {String}
     */
    this.name = name;
    /**
     * @ignore
     */
    this._isBatch = !!options.batch;
    /**
     * @ignore
     */
    this._headers = options.headers || {};
    this._retry = options.retry || 0;
    this._safe = !!options.safe;
  }

  /**
   * Get the value of "headers" for a given request, merging the
   * per-request headers with our own "default" headers.
   *
   * @private
   */
  _getHeaders(options) {
    return _extends({}, this._headers, options.headers);
  }

  /**
   * Get the value of "safe" for a given request, using the
   * per-request option if present or falling back to our default
   * otherwise.
   *
   * @private
   * @param {Object} options The options for a request.
   * @returns {Boolean}
   */
  _getSafe(options) {
    return _extends({ safe: this._safe }, options).safe;
  }

  /**
   * As _getSafe, but for "retry".
   *
   * @private
   */
  _getRetry(options) {
    return _extends({ retry: this._retry }, options).retry;
  }

  /**
   * Selects a collection.
   *
   * @param  {String}  name              The collection name.
   * @param  {Object}  [options={}]      The options object.
   * @param  {Object}  [options.headers] The headers object option.
   * @param  {Boolean} [options.safe]    The safe option.
   * @return {Collection}
   */
  collection(name, options = {}) {
    return new _collection2.default(this.client, this, name, {
      batch: this._isBatch,
      headers: this._getHeaders(options),
      retry: this._getRetry(options),
      safe: this._getSafe(options)
    });
  }

  /**
   * Retrieves bucket data.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getData(options = {}) {
    const request = {
      headers: this._getHeaders(options),
      path: (0, _endpoint2.default)("bucket", this.name)
    };
    const { data } = await this.client.execute(request, {
      retry: this._getRetry(options)
    });
    return data;
  }

  /**
   * Set bucket data.
   * @param  {Object}  data                    The bucket data object.
   * @param  {Object}  [options={}]            The options object.
   * @param  {Object}  [options.headers={}]    The headers object option.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean} [options.patch]         The patch option.
   * @param  {Number}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async setData(data, options = {}) {
    if (!(0, _utils.isObject)(data)) {
      throw new Error("A bucket object is required.");
    }

    const bucket = _extends({}, data, { id: this.name });

    // For default bucket, we need to drop the id from the data object.
    // Bug in Kinto < 3.1.1
    const bucketId = bucket.id;
    if (bucket.id === "default") {
      delete bucket.id;
    }

    const path = (0, _endpoint2.default)("bucket", bucketId);
    const { patch, permissions } = options;
    const { last_modified } = _extends({}, data, options);
    const request = requests.updateRequest(path, { data: bucket, permissions }, {
      last_modified,
      patch,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Retrieves the list of history entries in the current bucket.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Array<Object>, Error>}
   */

  async listHistory(options = {}) {
    const path = (0, _endpoint2.default)("history", this.name);
    return this.client.paginatedList(path, options, {
      headers: this._getHeaders(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Retrieves the list of collections in the current bucket.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Array<Object>, Error>}
   */
  async listCollections(options = {}) {
    const path = (0, _endpoint2.default)("collection", this.name);
    return this.client.paginatedList(path, options, {
      headers: this._getHeaders(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Creates a new collection in current bucket.
   *
   * @param  {String|undefined}  id          The collection id.
   * @param  {Object}  [options={}]          The options object.
   * @param  {Boolean} [options.safe]        The safe option.
   * @param  {Object}  [options.headers]     The headers object option.
   * @param  {Number}  [options.retry=0]     Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.permissions] The permissions object.
   * @param  {Object}  [options.data]        The data object.
   * @return {Promise<Object, Error>}
   */
  async createCollection(id, options = {}) {
    const { permissions, data = {} } = options;
    data.id = id;
    const path = (0, _endpoint2.default)("collection", this.name, id);
    const request = requests.createRequest(path, { data, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Deletes a collection from the current bucket.
   *
   * @param  {Object|String} collection              The collection to delete.
   * @param  {Object}        [options={}]            The options object.
   * @param  {Object}        [options.headers]       The headers object option.
   * @param  {Number}        [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean}       [options.safe]          The safe option.
   * @param  {Number}        [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async deleteCollection(collection, options = {}) {
    const collectionObj = (0, _utils.toDataBody)(collection);
    if (!collectionObj.id) {
      throw new Error("A collection id is required.");
    }
    const { id } = collectionObj;
    const { last_modified } = _extends({}, collectionObj, options);
    const path = (0, _endpoint2.default)("collection", this.name, id);
    const request = requests.deleteRequest(path, {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Retrieves the list of groups in the current bucket.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Array<Object>, Error>}
   */
  async listGroups(options = {}) {
    const path = (0, _endpoint2.default)("group", this.name);
    return this.client.paginatedList(path, options, {
      headers: this._getHeaders(options),
      retry: this._getRetry(options)
    });
  }

  /**
   * Creates a new group in current bucket.
   *
   * @param  {String} id                The group id.
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getGroup(id, options = {}) {
    const request = {
      headers: this._getHeaders(options),
      path: (0, _endpoint2.default)("group", this.name, id)
    };
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Creates a new group in current bucket.
   *
   * @param  {String|undefined}  id                    The group id.
   * @param  {Array<String>}     [members=[]]          The list of principals.
   * @param  {Object}            [options={}]          The options object.
   * @param  {Object}            [options.data]        The data object.
   * @param  {Object}            [options.permissions] The permissions object.
   * @param  {Boolean}           [options.safe]        The safe option.
   * @param  {Object}            [options.headers]     The headers object option.
   * @param  {Number}            [options.retry=0]     Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async createGroup(id, members = [], options = {}) {
    const data = _extends({}, options.data, {
      id,
      members
    });
    const path = (0, _endpoint2.default)("group", this.name, id);
    const { permissions } = options;
    const request = requests.createRequest(path, { data, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Updates an existing group in current bucket.
   *
   * @param  {Object}  group                   The group object.
   * @param  {Object}  [options={}]            The options object.
   * @param  {Object}  [options.data]          The data object.
   * @param  {Object}  [options.permissions]   The permissions object.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Number}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async updateGroup(group, options = {}) {
    if (!(0, _utils.isObject)(group)) {
      throw new Error("A group object is required.");
    }
    if (!group.id) {
      throw new Error("A group id is required.");
    }
    const data = _extends({}, options.data, group);
    const path = (0, _endpoint2.default)("group", this.name, group.id);
    const { patch, permissions } = options;
    const { last_modified } = _extends({}, data, options);
    const request = requests.updateRequest(path, { data, permissions }, {
      last_modified,
      patch,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Deletes a group from the current bucket.
   *
   * @param  {Object|String} group                   The group to delete.
   * @param  {Object}        [options={}]            The options object.
   * @param  {Object}        [options.headers]       The headers object option.
   * @param  {Number}        [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean}       [options.safe]          The safe option.
   * @param  {Number}        [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async deleteGroup(group, options = {}) {
    const groupObj = (0, _utils.toDataBody)(group);
    const { id } = groupObj;
    const { last_modified } = _extends({}, groupObj, options);
    const path = (0, _endpoint2.default)("group", this.name, id);
    const request = requests.deleteRequest(path, {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Retrieves the list of permissions for this bucket.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getPermissions(options = {}) {
    const request = {
      headers: this._getHeaders(options),
      path: (0, _endpoint2.default)("bucket", this.name)
    };
    const { permissions } = await this.client.execute(request, {
      retry: this._getRetry(options)
    });
    return permissions;
  }

  /**
   * Replaces all existing bucket permissions with the ones provided.
   *
   * @param  {Object}  permissions             The permissions object.
   * @param  {Object}  [options={}]            The options object
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers={}]    The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async setPermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("bucket", this.name);
    const { last_modified } = options;
    const data = { last_modified };
    const request = requests.updateRequest(path, { data, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Append principals to the bucket permissions.
   *
   * @param  {Object}  permissions             The permissions object.
   * @param  {Object}  [options={}]            The options object
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async addPermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("bucket", this.name);
    const { last_modified } = options;
    const request = requests.jsonPatchPermissionsRequest(path, permissions, "add", {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Remove principals from the bucket permissions.
   *
   * @param  {Object}  permissions             The permissions object.
   * @param  {Object}  [options={}]            The options object
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async removePermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("bucket", this.name);
    const { last_modified } = options;
    const request = requests.jsonPatchPermissionsRequest(path, permissions, "remove", {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Performs batch operations at the current bucket level.
   *
   * @param  {Function} fn                   The batch operation function.
   * @param  {Object}   [options={}]         The options object.
   * @param  {Object}   [options.headers]    The headers object option.
   * @param  {Boolean}  [options.safe]       The safe option.
   * @param  {Number}   [options.retry=0]    The retry option.
   * @param  {Boolean}  [options.aggregate]  Produces a grouped result object.
   * @return {Promise<Object, Error>}
   */
  async batch(fn, options = {}) {
    return this.client.batch(fn, {
      bucket: this.name,
      headers: this._getHeaders(options),
      retry: this._getRetry(options),
      safe: this._getSafe(options),
      aggregate: !!options.aggregate
    });
  }
}, (_applyDecoratedDescriptor(_class.prototype, "listHistory", [_dec], Object.getOwnPropertyDescriptor(_class.prototype, "listHistory"), _class.prototype)), _class));
exports.default = Bucket;

},{"./collection":10,"./endpoint":11,"./requests":14,"./utils":15}],10:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _dec, _dec2, _dec3, _desc, _value, _class;

var _uuid = require("uuid");

var _utils = require("./utils");

var _requests = require("./requests");

var requests = _interopRequireWildcard(_requests);

var _endpoint = require("./endpoint");

var _endpoint2 = _interopRequireDefault(_endpoint);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) {
  var desc = {};
  Object['ke' + 'ys'](descriptor).forEach(function (key) {
    desc[key] = descriptor[key];
  });
  desc.enumerable = !!desc.enumerable;
  desc.configurable = !!desc.configurable;

  if ('value' in desc || desc.initializer) {
    desc.writable = true;
  }

  desc = decorators.slice().reverse().reduce(function (desc, decorator) {
    return decorator(target, property, desc) || desc;
  }, desc);

  if (context && desc.initializer !== void 0) {
    desc.value = desc.initializer ? desc.initializer.call(context) : void 0;
    desc.initializer = undefined;
  }

  if (desc.initializer === void 0) {
    Object['define' + 'Property'](target, property, desc);
    desc = null;
  }

  return desc;
}

/**
 * Abstract representation of a selected collection.
 *
 */
let Collection = (_dec = (0, _utils.capable)(["attachments"]), _dec2 = (0, _utils.capable)(["attachments"]), _dec3 = (0, _utils.capable)(["history"]), (_class = class Collection {
  /**
   * Constructor.
   *
   * @param  {KintoClient}  client            The client instance.
   * @param  {Bucket}       bucket            The bucket instance.
   * @param  {String}       name              The collection name.
   * @param  {Object}       [options={}]      The options object.
   * @param  {Object}       [options.headers] The headers object option.
   * @param  {Boolean}      [options.safe]    The safe option.
   * @param  {Number}       [options.retry]   The retry option.
   * @param  {Boolean}      [options.batch]   (Private) Whether this
   *     Collection is operating as part of a batch.
   */
  constructor(client, bucket, name, options = {}) {
    /**
     * @ignore
     */
    this.client = client;
    /**
     * @ignore
     */
    this.bucket = bucket;
    /**
     * The collection name.
     * @type {String}
     */
    this.name = name;

    /**
     * @ignore
     */
    this._isBatch = !!options.batch;

    /**
     * @ignore
     */
    this._retry = options.retry || 0;
    this._safe = !!options.safe;
    // FIXME: This is kind of ugly; shouldn't the bucket be responsible
    // for doing the merge?
    this._headers = _extends({}, this.bucket._headers, options.headers);
  }

  /**
   * Get the value of "headers" for a given request, merging the
   * per-request headers with our own "default" headers.
   *
   * @private
   */
  _getHeaders(options) {
    return _extends({}, this._headers, options.headers);
  }

  /**
   * Get the value of "safe" for a given request, using the
   * per-request option if present or falling back to our default
   * otherwise.
   *
   * @private
   * @param {Object} options The options for a request.
   * @returns {Boolean}
   */
  _getSafe(options) {
    return _extends({ safe: this._safe }, options).safe;
  }

  /**
   * As _getSafe, but for "retry".
   *
   * @private
   */
  _getRetry(options) {
    return _extends({ retry: this._retry }, options).retry;
  }

  /**
   * Retrieves the total number of records in this collection.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Number, Error>}
   */
  async getTotalRecords(options = {}) {
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name);
    const request = {
      headers: this._getHeaders(options),
      path,
      method: "HEAD"
    };
    const { headers } = await this.client.execute(request, {
      raw: true,
      retry: this._getRetry(options)
    });
    return parseInt(headers.get("Total-Records"), 10);
  }

  /**
   * Retrieves collection data.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getData(options = {}) {
    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const request = { headers: this._getHeaders(options), path };
    const { data } = await this.client.execute(request, {
      retry: this._getRetry(options)
    });
    return data;
  }

  /**
   * Set collection data.
   * @param  {Object}   data                    The collection data object.
   * @param  {Object}   [options={}]            The options object.
   * @param  {Object}   [options.headers]       The headers object option.
   * @param  {Number}   [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean}  [options.safe]          The safe option.
   * @param  {Boolean}  [options.patch]         The patch option.
   * @param  {Number}   [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async setData(data, options = {}) {
    if (!(0, _utils.isObject)(data)) {
      throw new Error("A collection object is required.");
    }
    const { patch, permissions } = options;
    const { last_modified } = _extends({}, data, options);

    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const request = requests.updateRequest(path, { data, permissions }, {
      last_modified,
      patch,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Retrieves the list of permissions for this collection.
   *
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getPermissions(options = {}) {
    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const request = { headers: this._getHeaders(options), path };
    const { permissions } = await this.client.execute(request, {
      retry: this._getRetry(options)
    });
    return permissions;
  }

  /**
   * Replaces all existing collection permissions with the ones provided.
   *
   * @param  {Object}   permissions             The permissions object.
   * @param  {Object}   [options={}]            The options object
   * @param  {Object}   [options.headers]       The headers object option.
   * @param  {Number}   [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean}  [options.safe]          The safe option.
   * @param  {Number}   [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async setPermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const data = { last_modified: options.last_modified };
    const request = requests.updateRequest(path, { data, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Append principals to the collection permissions.
   *
   * @param  {Object}  permissions             The permissions object.
   * @param  {Object}  [options={}]            The options object
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async addPermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const { last_modified } = options;
    const request = requests.jsonPatchPermissionsRequest(path, permissions, "add", {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Remove principals from the collection permissions.
   *
   * @param  {Object}  permissions             The permissions object.
   * @param  {Object}  [options={}]            The options object
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}  [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async removePermissions(permissions, options = {}) {
    if (!(0, _utils.isObject)(permissions)) {
      throw new Error("A permissions object is required.");
    }
    const path = (0, _endpoint2.default)("collection", this.bucket.name, this.name);
    const { last_modified } = options;
    const request = requests.jsonPatchPermissionsRequest(path, permissions, "remove", {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Creates a record in current collection.
   *
   * @param  {Object}  record                The record to create.
   * @param  {Object}  [options={}]          The options object.
   * @param  {Object}  [options.headers]     The headers object option.
   * @param  {Number}  [options.retry=0]     Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean} [options.safe]        The safe option.
   * @param  {Object}  [options.permissions] The permissions option.
   * @return {Promise<Object, Error>}
   */
  async createRecord(record, options = {}) {
    const { permissions } = options;
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name, record.id);
    const request = requests.createRequest(path, { data: record, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Adds an attachment to a record, creating the record when it doesn't exist.
   *
   * @param  {String}  dataURL                 The data url.
   * @param  {Object}  [record={}]             The record data.
   * @param  {Object}  [options={}]            The options object.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Number}  [options.last_modified] The last_modified option.
   * @param  {Object}  [options.permissions]   The permissions option.
   * @param  {String}  [options.filename]      Force the attachment filename.
   * @param  {String}  [options.gzipped]       Force the attachment to be gzipped or not.
   * @return {Promise<Object, Error>}
   */

  async addAttachment(dataURI, record = {}, options = {}) {
    const { permissions } = options;
    const id = record.id || _uuid.v4.v4();
    const path = (0, _endpoint2.default)("attachment", this.bucket.name, this.name, id);
    const { last_modified } = _extends({}, record, options);
    const addAttachmentRequest = requests.addAttachmentRequest(path, dataURI, { data: record, permissions }, {
      last_modified,
      filename: options.filename,
      gzipped: options.gzipped,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    await this.client.execute(addAttachmentRequest, {
      stringify: false,
      retry: this._getRetry(options)
    });
    return this.getRecord(id);
  }

  /**
   * Removes an attachment from a given record.
   *
   * @param  {Object}  recordId                The record id.
   * @param  {Object}  [options={}]            The options object.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Number}  [options.last_modified] The last_modified option.
   */

  async removeAttachment(recordId, options = {}) {
    const { last_modified } = options;
    const path = (0, _endpoint2.default)("attachment", this.bucket.name, this.name, recordId);
    const request = requests.deleteRequest(path, {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Updates a record in current collection.
   *
   * @param  {Object}  record                  The record to update.
   * @param  {Object}  [options={}]            The options object.
   * @param  {Object}  [options.headers]       The headers object option.
   * @param  {Number}  [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean} [options.safe]          The safe option.
   * @param  {Number}  [options.last_modified] The last_modified option.
   * @param  {Object}  [options.permissions]   The permissions option.
   * @return {Promise<Object, Error>}
   */
  async updateRecord(record, options = {}) {
    if (!(0, _utils.isObject)(record)) {
      throw new Error("A record object is required.");
    }
    if (!record.id) {
      throw new Error("A record id is required.");
    }
    const { permissions } = options;
    const { last_modified } = _extends({}, record, options);
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name, record.id);
    const request = requests.updateRequest(path, { data: record, permissions }, {
      headers: this._getHeaders(options),
      safe: this._getSafe(options),
      last_modified,
      patch: !!options.patch
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Deletes a record from the current collection.
   *
   * @param  {Object|String} record                  The record to delete.
   * @param  {Object}        [options={}]            The options object.
   * @param  {Object}        [options.headers]       The headers object option.
   * @param  {Number}        [options.retry=0]       Number of retries to make
   *     when faced with transient errors.
   * @param  {Boolean}       [options.safe]          The safe option.
   * @param  {Number}        [options.last_modified] The last_modified option.
   * @return {Promise<Object, Error>}
   */
  async deleteRecord(record, options = {}) {
    const recordObj = (0, _utils.toDataBody)(record);
    if (!recordObj.id) {
      throw new Error("A record id is required.");
    }
    const { id } = recordObj;
    const { last_modified } = _extends({}, recordObj, options);
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name, id);
    const request = requests.deleteRequest(path, {
      last_modified,
      headers: this._getHeaders(options),
      safe: this._getSafe(options)
    });
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Retrieves a record from the current collection.
   *
   * @param  {String} id                The record id to retrieve.
   * @param  {Object} [options={}]      The options object.
   * @param  {Object} [options.headers] The headers object option.
   * @param  {Number} [options.retry=0] Number of retries to make
   *     when faced with transient errors.
   * @return {Promise<Object, Error>}
   */
  async getRecord(id, options = {}) {
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name, id);
    const request = { headers: this._getHeaders(options), path };
    return this.client.execute(request, { retry: this._getRetry(options) });
  }

  /**
   * Lists records from the current collection.
   *
   * Sorting is done by passing a `sort` string option:
   *
   * - The field to order the results by, prefixed with `-` for descending.
   * Default: `-last_modified`.
   *
   * @see http://kinto.readthedocs.io/en/stable/api/1.x/sorting.html
   *
   * Filtering is done by passing a `filters` option object:
   *
   * - `{fieldname: "value"}`
   * - `{min_fieldname: 4000}`
   * - `{in_fieldname: "1,2,3"}`
   * - `{not_fieldname: 0}`
   * - `{exclude_fieldname: "0,1"}`
   *
   * @see http://kinto.readthedocs.io/en/stable/api/1.x/filtering.html
   *
   * Paginating is done by passing a `limit` option, then calling the `next()`
   * method from the resolved result object to fetch the next page, if any.
   *
   * @param  {Object}   [options={}]                    The options object.
   * @param  {Object}   [options.headers]               The headers object option.
   * @param  {Number}   [options.retry=0]               Number of retries to make
   *     when faced with transient errors.
   * @param  {Object}   [options.filters=[]]            The filters object.
   * @param  {String}   [options.sort="-last_modified"] The sort field.
   * @param  {String}   [options.at]                    The timestamp to get a snapshot at.
   * @param  {String}   [options.limit=null]            The limit field.
   * @param  {String}   [options.pages=1]               The number of result pages to aggregate.
   * @param  {Number}   [options.since=null]            Only retrieve records modified since the provided timestamp.
   * @return {Promise<Object, Error>}
   */
  async listRecords(options = {}) {
    const path = (0, _endpoint2.default)("record", this.bucket.name, this.name);
    if (options.hasOwnProperty("at")) {
      return this.getSnapshot(options.at);
    } else {
      return this.client.paginatedList(path, options, {
        headers: this._getHeaders(options),
        retry: this._getRetry(options)
      });
    }
  }

  /**
   * @private
   */
  async isHistoryComplete() {
    // We consider that if we have the collection creation event part of the
    // history, then all records change events have been tracked.
    const { data: [oldestHistoryEntry] } = await this.bucket.listHistory({
      limit: 1,
      filters: {
        action: "create",
        resource_name: "collection",
        collection_id: this.name
      }
    });
    return !!oldestHistoryEntry;
  }

  /**
   * @private
   */
  async listChangesBackTo(at) {
    // Ensure we have enough history data to retrieve the complete list of
    // changes.
    if (!(await this.isHistoryComplete())) {
      throw new Error("Computing a snapshot is only possible when the full history for a " + "collection is available. Here, the history plugin seems to have " + "been enabled after the creation of the collection.");
    }
    const { data: changes } = await this.bucket.listHistory({
      pages: Infinity, // all pages up to target timestamp are required
      sort: "-target.data.last_modified",
      filters: {
        resource_name: "record",
        collection_id: this.name,
        "max_target.data.last_modified": String(at) }
    });
    return changes;
  }

  /**
   * @private
   */

  async getSnapshot(at) {
    if (!Number.isInteger(at) || at <= 0) {
      throw new Error("Invalid argument, expected a positive integer.");
    }
    // Retrieve history and check it covers the required time range.
    const changes = await this.listChangesBackTo(at);
    // Replay changes to compute the requested snapshot.
    const seenIds = new Set();
    let snapshot = [];
    for (const _ref of changes) {
      const { action, target: { data: record } } = _ref;

      if (action == "delete") {
        seenIds.add(record.id); // ensure not reprocessing deleted entries
        snapshot = snapshot.filter(r => r.id !== record.id);
      } else if (!seenIds.has(record.id)) {
        seenIds.add(record.id);
        snapshot.push(record);
      }
    }
    return {
      last_modified: String(at),
      data: snapshot.sort((a, b) => b.last_modified - a.last_modified),
      next: () => {
        throw new Error("Snapshots don't support pagination");
      },
      hasNextPage: false,
      totalRecords: snapshot.length
    };
  }

  /**
   * Performs batch operations at the current collection level.
   *
   * @param  {Function} fn                   The batch operation function.
   * @param  {Object}   [options={}]         The options object.
   * @param  {Object}   [options.headers]    The headers object option.
   * @param  {Boolean}  [options.safe]       The safe option.
   * @param  {Number}   [options.retry]      The retry option.
   * @param  {Boolean}  [options.aggregate]  Produces a grouped result object.
   * @return {Promise<Object, Error>}
   */
  async batch(fn, options = {}) {
    return this.client.batch(fn, {
      bucket: this.bucket.name,
      collection: this.name,
      headers: this._getHeaders(options),
      retry: this._getRetry(options),
      safe: this._getSafe(options),
      aggregate: !!options.aggregate
    });
  }
}, (_applyDecoratedDescriptor(_class.prototype, "addAttachment", [_dec], Object.getOwnPropertyDescriptor(_class.prototype, "addAttachment"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "removeAttachment", [_dec2], Object.getOwnPropertyDescriptor(_class.prototype, "removeAttachment"), _class.prototype), _applyDecoratedDescriptor(_class.prototype, "getSnapshot", [_dec3], Object.getOwnPropertyDescriptor(_class.prototype, "getSnapshot"), _class.prototype)), _class));
exports.default = Collection;

},{"./endpoint":11,"./requests":14,"./utils":15,"uuid":2}],11:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = endpoint;
/**
 * Endpoints templates.
 * @type {Object}
 */
const ENDPOINTS = {
  root: () => "/",
  batch: () => "/batch",
  permissions: () => "/permissions",
  bucket: bucket => "/buckets" + (bucket ? `/${bucket}` : ""),
  history: bucket => `${ENDPOINTS.bucket(bucket)}/history`,
  collection: (bucket, coll) => `${ENDPOINTS.bucket(bucket)}/collections` + (coll ? `/${coll}` : ""),
  group: (bucket, group) => `${ENDPOINTS.bucket(bucket)}/groups` + (group ? `/${group}` : ""),
  record: (bucket, coll, id) => `${ENDPOINTS.collection(bucket, coll)}/records` + (id ? `/${id}` : ""),
  attachment: (bucket, coll, id) => `${ENDPOINTS.record(bucket, coll, id)}/attachment`
};

/**
 * Retrieves a server enpoint by its name.
 *
 * @private
 * @param  {String}    name The endpoint name.
 * @param  {...string} args The endpoint parameters.
 * @return {String}
 */
function endpoint(name, ...args) {
  return ENDPOINTS[name](...args);
}

},{}],12:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
/**
 * Kinto server error code descriptors.
 * @type {Object}
 */
exports.default = {
  104: "Missing Authorization Token",
  105: "Invalid Authorization Token",
  106: "Request body was not valid JSON",
  107: "Invalid request parameter",
  108: "Missing request parameter",
  109: "Invalid posted data",
  110: "Invalid Token / id",
  111: "Missing Token / id",
  112: "Content-Length header was not provided",
  113: "Request body too large",
  114: "Resource was created, updated or deleted meanwhile",
  115: "Method not allowed on this end point (hint: server may be readonly)",
  116: "Requested version not available on this server",
  117: "Client has sent too many requests",
  121: "Resource access is forbidden for this user",
  122: "Another resource violates constraint",
  201: "Service Temporary unavailable due to high load",
  202: "Service deprecated",
  999: "Internal Server Error"
};

},{}],13:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _utils = require("./utils");

var _errors = require("./errors");

var _errors2 = _interopRequireDefault(_errors);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * Enhanced HTTP client for the Kinto protocol.
 * @private
 */
let HTTP = class HTTP {
  /**
   * Default HTTP request headers applied to each outgoing request.
   *
   * @type {Object}
   */
  static get DEFAULT_REQUEST_HEADERS() {
    return {
      Accept: "application/json",
      "Content-Type": "application/json"
    };
  }

  /**
   * Default options.
   *
   * @type {Object}
   */
  static get defaultOptions() {
    return { timeout: null, requestMode: "cors" };
  }

  /**
   * Constructor.
   *
   * @param {EventEmitter} events                       The event handler.
   * @param {Object}       [options={}}                 The options object.
   * @param {Number}       [options.timeout=null]       The request timeout in ms, if any (default: `null`).
   * @param {String}       [options.requestMode="cors"] The HTTP request mode (default: `"cors"`).
   */
  constructor(events, options = {}) {
    // public properties
    /**
     * The event emitter instance.
     * @type {EventEmitter}
     */
    if (!events) {
      throw new Error("No events handler provided");
    }
    this.events = events;

    /**
     * The request mode.
     * @see  https://fetch.spec.whatwg.org/#requestmode
     * @type {String}
     */
    this.requestMode = options.requestMode || HTTP.defaultOptions.requestMode;

    /**
     * The request timeout.
     * @type {Number}
     */
    this.timeout = options.timeout || HTTP.defaultOptions.timeout;
  }

  /**
   * @private
   */
  timedFetch(url, options) {
    let hasTimedout = false;
    return new Promise((resolve, reject) => {
      // Detect if a request has timed out.
      let _timeoutId;
      if (this.timeout) {
        _timeoutId = setTimeout(() => {
          hasTimedout = true;
          reject(new Error("Request timeout."));
        }, this.timeout);
      }
      function proceedWithHandler(fn) {
        return arg => {
          if (!hasTimedout) {
            if (_timeoutId) {
              clearTimeout(_timeoutId);
            }
            fn(arg);
          }
        };
      }
      fetch(url, options).then(proceedWithHandler(resolve)).catch(proceedWithHandler(reject));
    });
  }

  /**
   * @private
   */
  async processResponse(response) {
    const { status } = response;
    const text = await response.text();
    // Check if we have a body; if so parse it as JSON.
    if (text.length === 0) {
      return this.formatResponse(response, null);
    }
    try {
      return this.formatResponse(response, JSON.parse(text));
    } catch (err) {
      const error = new Error(`HTTP ${status || 0}; ${err}`);
      error.response = response;
      error.stack = err.stack;
      throw error;
    }
  }

  /**
   * @private
   */
  formatResponse(response, json) {
    const { status, statusText, headers } = response;
    if (json && status >= 400) {
      let message = `HTTP ${status} ${json.error || ""}: `;
      if (json.errno && json.errno in _errors2.default) {
        const errnoMsg = _errors2.default[json.errno];
        message += errnoMsg;
        if (json.message && json.message !== errnoMsg) {
          message += ` (${json.message})`;
        }
      } else {
        message += statusText || "";
      }
      const error = new Error(message.trim());
      error.response = response;
      error.data = json;
      throw error;
    }
    return { status, json, headers };
  }

  /**
   * @private
   */
  async retry(url, retryAfter, request, options) {
    await (0, _utils.delay)(retryAfter);
    return this.request(url, request, _extends({}, options, { retry: options.retry - 1 }));
  }

  /**
   * Performs an HTTP request to the Kinto server.
   *
   * Resolves with an objet containing the following HTTP response properties:
   * - `{Number}  status`  The HTTP status code.
   * - `{Object}  json`    The JSON response body.
   * - `{Headers} headers` The response headers object; see the ES6 fetch() spec.
   *
   * @param  {String} url               The URL.
   * @param  {Object} [request={}]      The request object, passed to
   *     fetch() as its options object.
   * @param  {Object} [request.headers] The request headers object (default: {})
   * @param  {Object} [options={}]      Options for making the
   *     request
   * @param  {Number} [options.retry]   Number of retries (default: 0)
   * @return {Promise}
   */
  async request(url, request = { headers: {} }, options = { retry: 0 }) {
    // Ensure default request headers are always set
    request.headers = _extends({}, HTTP.DEFAULT_REQUEST_HEADERS, request.headers);
    // If a multipart body is provided, remove any custom Content-Type header as
    // the fetch() implementation will add the correct one for us.
    if (request.body && typeof request.body.append === "function") {
      delete request.headers["Content-Type"];
    }
    request.mode = this.requestMode;

    const response = await this.timedFetch(url, request);
    const { status, headers } = response;

    this._checkForDeprecationHeader(headers);
    this._checkForBackoffHeader(status, headers);

    // Check if the server summons the client to retry after a while.
    const retryAfter = this._checkForRetryAfterHeader(status, headers);
    // If number of allowed of retries is not exhausted, retry the same request.
    if (retryAfter && options.retry > 0) {
      return this.retry(url, retryAfter, request, options);
    } else {
      return this.processResponse(response);
    }
  }

  _checkForDeprecationHeader(headers) {
    const alertHeader = headers.get("Alert");
    if (!alertHeader) {
      return;
    }
    let alert;
    try {
      alert = JSON.parse(alertHeader);
    } catch (err) {
      console.warn("Unable to parse Alert header message", alertHeader);
      return;
    }
    console.warn(alert.message, alert.url);
    this.events.emit("deprecated", alert);
  }

  _checkForBackoffHeader(status, headers) {
    let backoffMs;
    const backoffSeconds = parseInt(headers.get("Backoff"), 10);
    if (backoffSeconds > 0) {
      backoffMs = new Date().getTime() + backoffSeconds * 1000;
    } else {
      backoffMs = 0;
    }
    this.events.emit("backoff", backoffMs);
  }

  _checkForRetryAfterHeader(status, headers) {
    let retryAfter = headers.get("Retry-After");
    if (!retryAfter) {
      return;
    }
    const delay = parseInt(retryAfter, 10) * 1000;
    retryAfter = new Date().getTime() + delay;
    this.events.emit("retry-after", retryAfter);
    return delay;
  }
};
exports.default = HTTP;

},{"./errors":12,"./utils":15}],14:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

exports.createRequest = createRequest;
exports.updateRequest = updateRequest;
exports.jsonPatchPermissionsRequest = jsonPatchPermissionsRequest;
exports.deleteRequest = deleteRequest;
exports.addAttachmentRequest = addAttachmentRequest;

var _utils = require("./utils");

const requestDefaults = {
  safe: false,
  // check if we should set default content type here
  headers: {},
  permissions: undefined,
  data: undefined,
  patch: false
};

/**
 * @private
 */
function safeHeader(safe, last_modified) {
  if (!safe) {
    return {};
  }
  if (last_modified) {
    return { "If-Match": `"${last_modified}"` };
  }
  return { "If-None-Match": "*" };
}

/**
 * @private
 */
function createRequest(path, { data, permissions }, options = {}) {
  const { headers, safe } = _extends({}, requestDefaults, options);
  return {
    method: data && data.id ? "PUT" : "POST",
    path,
    headers: _extends({}, headers, safeHeader(safe)),
    body: { data, permissions }
  };
}

/**
 * @private
 */
function updateRequest(path, { data, permissions }, options = {}) {
  const { headers, safe, patch } = _extends({}, requestDefaults, options);
  const { last_modified } = _extends({}, data, options);

  if (Object.keys((0, _utils.omit)(data, "id", "last_modified")).length === 0) {
    data = undefined;
  }

  return {
    method: patch ? "PATCH" : "PUT",
    path,
    headers: _extends({}, headers, safeHeader(safe, last_modified)),
    body: { data, permissions }
  };
}

/**
 * @private
 */
function jsonPatchPermissionsRequest(path, permissions, opType, options = {}) {
  const { headers, safe, last_modified } = _extends({}, requestDefaults, options);

  const ops = [];

  for (const [type, principals] of Object.entries(permissions)) {
    for (const principal of principals) {
      ops.push({
        op: opType,
        path: `/permissions/${type}/${principal}`
      });
    }
  }

  return {
    method: "PATCH",
    path,
    headers: _extends({}, headers, safeHeader(safe, last_modified), {
      "Content-Type": "application/json-patch+json"
    }),
    body: ops
  };
}

/**
 * @private
 */
function deleteRequest(path, options = {}) {
  const { headers, safe, last_modified } = _extends({}, requestDefaults, options);
  if (safe && !last_modified) {
    throw new Error("Safe concurrency check requires a last_modified value.");
  }
  return {
    method: "DELETE",
    path,
    headers: _extends({}, headers, safeHeader(safe, last_modified))
  };
}

/**
 * @private
 */
function addAttachmentRequest(path, dataURI, { data, permissions } = {}, options = {}) {
  const { headers, safe, gzipped } = _extends({}, requestDefaults, options);
  const { last_modified } = _extends({}, data, options);

  const body = { data, permissions };
  const formData = (0, _utils.createFormData)(dataURI, body, options);

  let customPath = gzipped != null ? customPath = path + "?gzipped=" + (gzipped ? "true" : "false") : path;

  return {
    method: "POST",
    path: customPath,
    headers: _extends({}, headers, safeHeader(safe, last_modified)),
    body: formData
  };
}

},{"./utils":15}],15:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

exports.partition = partition;
exports.delay = delay;
exports.pMap = pMap;
exports.omit = omit;
exports.toDataBody = toDataBody;
exports.qsify = qsify;
exports.checkVersion = checkVersion;
exports.support = support;
exports.capable = capable;
exports.nobatch = nobatch;
exports.isObject = isObject;
exports.parseDataURL = parseDataURL;
exports.extractFileInfo = extractFileInfo;
exports.createFormData = createFormData;
exports.cleanUndefinedProperties = cleanUndefinedProperties;
/**
 * Chunks an array into n pieces.
 *
 * @private
 * @param  {Array}  array
 * @param  {Number} n
 * @return {Array}
 */
function partition(array, n) {
  if (n <= 0) {
    return array;
  }
  return array.reduce((acc, x, i) => {
    if (i === 0 || i % n === 0) {
      acc.push([x]);
    } else {
      acc[acc.length - 1].push(x);
    }
    return acc;
  }, []);
}

/**
 * Returns a Promise always resolving after the specified amount in milliseconds.
 *
 * @return Promise<void>
 */
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Maps a list to promises using the provided mapping function, executes them
 * sequentially then returns a Promise resolving with ordered results obtained.
 * Think of this as a sequential Promise.all.
 *
 * @private
 * @param  {Array}    list The list to map.
 * @param  {Function} fn   The mapping function.
 * @return {Promise}
 */
async function pMap(list, fn) {
  let results = [];
  await list.reduce(async function (promise, entry) {
    await promise;
    results = results.concat((await fn(entry)));
  }, Promise.resolve());
  return results;
}

/**
 * Takes an object and returns a copy of it with the provided keys omitted.
 *
 * @private
 * @param  {Object}    obj  The source object.
 * @param  {...String} keys The keys to omit.
 * @return {Object}
 */
function omit(obj, ...keys) {
  return Object.keys(obj).reduce((acc, key) => {
    if (keys.indexOf(key) === -1) {
      acc[key] = obj[key];
    }
    return acc;
  }, {});
}

/**
 * Always returns a resource data object from the provided argument.
 *
 * @private
 * @param  {Object|String} resource
 * @return {Object}
 */
function toDataBody(resource) {
  if (isObject(resource)) {
    return resource;
  }
  if (typeof resource === "string") {
    return { id: resource };
  }
  throw new Error("Invalid argument.");
}

/**
 * Transforms an object into an URL query string, stripping out any undefined
 * values.
 *
 * @param  {Object} obj
 * @return {String}
 */
function qsify(obj) {
  const encode = v => encodeURIComponent(typeof v === "boolean" ? String(v) : v);
  const stripUndefined = o => JSON.parse(JSON.stringify(o));
  const stripped = stripUndefined(obj);
  return Object.keys(stripped).map(k => {
    const ks = encode(k) + "=";
    if (Array.isArray(stripped[k])) {
      return ks + stripped[k].map(v => encode(v)).join(",");
    } else {
      return ks + encode(stripped[k]);
    }
  }).join("&");
}

/**
 * Checks if a version is within the provided range.
 *
 * @param  {String} version    The version to check.
 * @param  {String} minVersion The minimum supported version (inclusive).
 * @param  {String} maxVersion The minimum supported version (exclusive).
 * @throws {Error} If the version is outside of the provided range.
 */
function checkVersion(version, minVersion, maxVersion) {
  const extract = str => str.split(".").map(x => parseInt(x, 10));
  const [verMajor, verMinor] = extract(version);
  const [minMajor, minMinor] = extract(minVersion);
  const [maxMajor, maxMinor] = extract(maxVersion);
  const checks = [verMajor < minMajor, verMajor === minMajor && verMinor < minMinor, verMajor > maxMajor, verMajor === maxMajor && verMinor >= maxMinor];
  if (checks.some(x => x)) {
    throw new Error(`Version ${version} doesn't satisfy ${minVersion} <= x < ${maxVersion}`);
  }
}

/**
 * Generates a decorator function ensuring a version check is performed against
 * the provided requirements before executing it.
 *
 * @param  {String} min The required min version (inclusive).
 * @param  {String} max The required max version (inclusive).
 * @return {Function}
 */
function support(min, max) {
  return function (target, key, descriptor) {
    const fn = descriptor.value;
    return {
      configurable: true,
      get() {
        const wrappedMethod = (...args) => {
          // "this" is the current instance which its method is decorated.
          const client = "client" in this ? this.client : this;
          return client.fetchHTTPApiVersion().then(version => checkVersion(version, min, max)).then(() => fn.apply(this, args));
        };
        Object.defineProperty(this, key, {
          value: wrappedMethod,
          configurable: true,
          writable: true
        });
        return wrappedMethod;
      }
    };
  };
}

/**
 * Generates a decorator function ensuring that the specified capabilities are
 * available on the server before executing it.
 *
 * @param  {Array<String>} capabilities The required capabilities.
 * @return {Function}
 */
function capable(capabilities) {
  return function (target, key, descriptor) {
    const fn = descriptor.value;
    return {
      configurable: true,
      get() {
        const wrappedMethod = (...args) => {
          // "this" is the current instance which its method is decorated.
          const client = "client" in this ? this.client : this;
          return client.fetchServerCapabilities().then(available => {
            const missing = capabilities.filter(c => !(c in available));
            if (missing.length > 0) {
              const missingStr = missing.join(", ");
              throw new Error(`Required capabilities ${missingStr} not present on server`);
            }
          }).then(() => fn.apply(this, args));
        };
        Object.defineProperty(this, key, {
          value: wrappedMethod,
          configurable: true,
          writable: true
        });
        return wrappedMethod;
      }
    };
  };
}

/**
 * Generates a decorator function ensuring an operation is not performed from
 * within a batch request.
 *
 * @param  {String} message The error message to throw.
 * @return {Function}
 */
function nobatch(message) {
  return function (target, key, descriptor) {
    const fn = descriptor.value;
    return {
      configurable: true,
      get() {
        const wrappedMethod = (...args) => {
          // "this" is the current instance which its method is decorated.
          if (this._isBatch) {
            throw new Error(message);
          }
          return fn.apply(this, args);
        };
        Object.defineProperty(this, key, {
          value: wrappedMethod,
          configurable: true,
          writable: true
        });
        return wrappedMethod;
      }
    };
  };
}

/**
 * Returns true if the specified value is an object (i.e. not an array nor null).
 * @param  {Object} thing The value to inspect.
 * @return {bool}
 */
function isObject(thing) {
  return typeof thing === "object" && thing !== null && !Array.isArray(thing);
}

/**
 * Parses a data url.
 * @param  {String} dataURL The data url.
 * @return {Object}
 */
function parseDataURL(dataURL) {
  const regex = /^data:(.*);base64,(.*)/;
  const match = dataURL.match(regex);
  if (!match) {
    throw new Error(`Invalid data-url: ${String(dataURL).substr(0, 32)}...`);
  }
  const props = match[1];
  const base64 = match[2];
  const [type, ...rawParams] = props.split(";");
  const params = rawParams.reduce((acc, param) => {
    const [key, value] = param.split("=");
    return _extends({}, acc, { [key]: value });
  }, {});
  return _extends({}, params, { type, base64 });
}

/**
 * Extracts file information from a data url.
 * @param  {String} dataURL The data url.
 * @return {Object}
 */
function extractFileInfo(dataURL) {
  const { name, type, base64 } = parseDataURL(dataURL);
  const binary = atob(base64);
  const array = [];
  for (let i = 0; i < binary.length; i++) {
    array.push(binary.charCodeAt(i));
  }
  const blob = new Blob([new Uint8Array(array)], { type });
  return { blob, name };
}

/**
 * Creates a FormData instance from a data url and an existing JSON response
 * body.
 * @param  {String} dataURL            The data url.
 * @param  {Object} body               The response body.
 * @param  {Object} [options={}]       The options object.
 * @param  {Object} [options.filename] Force attachment file name.
 * @return {FormData}
 */
function createFormData(dataURL, body, options = {}) {
  const { filename = "untitled" } = options;
  const { blob, name } = extractFileInfo(dataURL);
  const formData = new FormData();
  formData.append("attachment", blob, name || filename);
  for (const property in body) {
    if (typeof body[property] !== "undefined") {
      formData.append(property, JSON.stringify(body[property]));
    }
  }
  return formData;
}

/**
 * Clones an object with all its undefined keys removed.
 * @private
 */
function cleanUndefinedProperties(obj) {
  const result = {};
  for (const key in obj) {
    if (typeof obj[key] !== "undefined") {
      result[key] = obj[key];
    }
  }
  return result;
}

},{}]},{},[1])(1)
});