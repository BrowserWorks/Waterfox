/* jshint moz: true, esnext: true */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;
const Cr = Components.results;

const {PushDB} = Cu.import("resource://gre/modules/PushDB.jsm");
const {PushRecord} = Cu.import("resource://gre/modules/PushRecord.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/NetUtil.jsm");
Cu.import("resource://gre/modules/IndexedDBHelper.jsm");
Cu.import("resource://gre/modules/Timer.jsm");
Cu.import("resource://gre/modules/Preferences.jsm");
Cu.import("resource://gre/modules/Promise.jsm");

const {
  PushCrypto,
  concatArray,
} = Cu.import("resource://gre/modules/PushCrypto.jsm");

this.EXPORTED_SYMBOLS = ["PushServiceHttp2"];

XPCOMUtils.defineLazyGetter(this, "console", () => {
  let {ConsoleAPI} = Cu.import("resource://gre/modules/Console.jsm", {});
  return new ConsoleAPI({
    maxLogLevelPref: "dom.push.loglevel",
    prefix: "PushServiceHttp2",
  });
});

const prefs = new Preferences("dom.push.");

const kPUSHHTTP2DB_DB_NAME = "pushHttp2";
const kPUSHHTTP2DB_DB_VERSION = 5; // Change this if the IndexedDB format changes
const kPUSHHTTP2DB_STORE_NAME = "pushHttp2";

/**
 * A proxy between the PushService and connections listening for incoming push
 * messages. The PushService can silence messages from the connections by
 * setting PushSubscriptionListener._pushService to null. This is required
 * because it can happen that there is an outstanding push message that will
 * be send on OnStopRequest but the PushService may not be interested in these.
 * It's easier to stop listening than to have checks at specific points.
 */
var PushSubscriptionListener = function(pushService, uri) {
  console.debug("PushSubscriptionListener()");
  this._pushService = pushService;
  this.uri = uri;
};

PushSubscriptionListener.prototype = {

  QueryInterface: function (aIID) {
    if (aIID.equals(Ci.nsIHttpPushListener) ||
        aIID.equals(Ci.nsIStreamListener)) {
      return this;
    }
    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  getInterface: function(aIID) {
    return this.QueryInterface(aIID);
  },

  onStartRequest: function(aRequest, aContext) {
    console.debug("PushSubscriptionListener: onStartRequest()");
    // We do not do anything here.
  },

  onDataAvailable: function(aRequest, aContext, aStream, aOffset, aCount) {
    console.debug("PushSubscriptionListener: onDataAvailable()");
    // Nobody should send data, but just to be sure, otherwise necko will
    // complain.
    if (aCount === 0) {
      return;
    }

    let inputStream = Cc["@mozilla.org/scriptableinputstream;1"]
                        .createInstance(Ci.nsIScriptableInputStream);

    inputStream.init(aStream);
    var data = inputStream.read(aCount);
  },

  onStopRequest: function(aRequest, aContext, aStatusCode) {
    console.debug("PushSubscriptionListener: onStopRequest()");
    if (!this._pushService) {
        return;
    }

    this._pushService.connOnStop(aRequest,
                                 Components.isSuccessCode(aStatusCode),
                                 this.uri);
  },

  onPush: function(associatedChannel, pushChannel) {
    console.debug("PushSubscriptionListener: onPush()");
    var pushChannelListener = new PushChannelListener(this);
    pushChannel.asyncOpen2(pushChannelListener);
  },

  disconnect: function() {
    this._pushService = null;
  }
};

/**
 * The listener for pushed messages. The message data is collected in
 * OnDataAvailable and send to the app in OnStopRequest.
 */
var PushChannelListener = function(pushSubscriptionListener) {
  console.debug("PushChannelListener()");
  this._mainListener = pushSubscriptionListener;
  this._message = [];
  this._ackUri = null;
};

PushChannelListener.prototype = {

  onStartRequest: function(aRequest, aContext) {
    this._ackUri = aRequest.URI.spec;
  },

  onDataAvailable: function(aRequest, aContext, aStream, aOffset, aCount) {
    console.debug("PushChannelListener: onDataAvailable()");

    if (aCount === 0) {
      return;
    }

    let inputStream = Cc["@mozilla.org/binaryinputstream;1"]
                        .createInstance(Ci.nsIBinaryInputStream);

    inputStream.setInputStream(aStream);
    let chunk = new ArrayBuffer(aCount);
    inputStream.readArrayBuffer(aCount, chunk);
    this._message.push(chunk);
  },

  onStopRequest: function(aRequest, aContext, aStatusCode) {
    console.debug("PushChannelListener: onStopRequest()", "status code",
      aStatusCode);
    if (Components.isSuccessCode(aStatusCode) &&
        this._mainListener &&
        this._mainListener._pushService) {
      let headers = {
        encryption_key: getHeaderField(aRequest, "Encryption-Key"),
        crypto_key: getHeaderField(aRequest, "Crypto-Key"),
        encryption: getHeaderField(aRequest, "Encryption"),
        encoding: getHeaderField(aRequest, "Content-Encoding"),
      };
      let msg = concatArray(this._message);

      this._mainListener._pushService._pushChannelOnStop(this._mainListener.uri,
                                                         this._ackUri,
                                                         headers,
                                                         msg);
    }
  }
};

function getHeaderField(aRequest, name) {
  try {
    return aRequest.getRequestHeader(name);
  } catch(e) {
    // getRequestHeader can throw.
    return null;
  }
}

var PushServiceDelete = function(resolve, reject) {
  this._resolve = resolve;
  this._reject = reject;
};

PushServiceDelete.prototype = {

  onStartRequest: function(aRequest, aContext) {},

  onDataAvailable: function(aRequest, aContext, aStream, aOffset, aCount) {
    // Nobody should send data, but just to be sure, otherwise necko will
    // complain.
    if (aCount === 0) {
      return;
    }

    let inputStream = Cc["@mozilla.org/scriptableinputstream;1"]
                        .createInstance(Ci.nsIScriptableInputStream);

    inputStream.init(aStream);
    var data = inputStream.read(aCount);
  },

  onStopRequest: function(aRequest, aContext, aStatusCode) {

    if (Components.isSuccessCode(aStatusCode)) {
       this._resolve();
    } else {
       this._reject(new Error("Error removing subscription: " + aStatusCode));
    }
  }
};

var SubscriptionListener = function(aSubInfo, aResolve, aReject,
                                    aServerURI, aPushServiceHttp2) {
  console.debug("SubscriptionListener()");
  this._subInfo = aSubInfo;
  this._resolve = aResolve;
  this._reject = aReject;
  this._data = '';
  this._serverURI = aServerURI;
  this._service = aPushServiceHttp2;
  this._ctime = Date.now();
  this._retryTimeoutID = null;
};

SubscriptionListener.prototype = {

  onStartRequest: function(aRequest, aContext) {},

  onDataAvailable: function(aRequest, aContext, aStream, aOffset, aCount) {
    console.debug("SubscriptionListener: onDataAvailable()");

    // We do not expect any data, but necko will complain if we do not consume
    // it.
    if (aCount === 0) {
      return;
    }

    let inputStream = Cc["@mozilla.org/scriptableinputstream;1"]
                        .createInstance(Ci.nsIScriptableInputStream);

    inputStream.init(aStream);
    this._data.concat(inputStream.read(aCount));
  },

  onStopRequest: function(aRequest, aContext, aStatus) {
    console.debug("SubscriptionListener: onStopRequest()");

    // Check if pushService is still active.
    if (!this._service.hasmainPushService()) {
      this._reject(new Error("Push service unavailable"));
      return;
    }

    if (!Components.isSuccessCode(aStatus)) {
      this._reject(new Error("Error listening for messages: " + aStatus));
      return;
    }

    var statusCode = aRequest.QueryInterface(Ci.nsIHttpChannel).responseStatus;

    if (Math.floor(statusCode / 100) == 5) {
      if (this._subInfo.retries < prefs.get("http2.maxRetries")) {
        this._subInfo.retries++;
        var retryAfter = retryAfterParser(aRequest);
        this._retryTimeoutID = setTimeout(_ =>
          {
            this._reject(
              {
                retry: true,
                subInfo: this._subInfo
              });
            this._service.removeListenerPendingRetry(this);
            this._retryTimeoutID = null;
          }, retryAfter);
        this._service.addListenerPendingRetry(this);
      } else {
        this._reject(new Error("Unexpected server response: " + statusCode));
      }
      return;
    } else if (statusCode != 201) {
      this._reject(new Error("Unexpected server response: " + statusCode));
      return;
    }

    var subscriptionUri;
    try {
      subscriptionUri = aRequest.getResponseHeader("location");
    } catch (err) {
      this._reject(new Error("Missing Location header"));
      return;
    }

    console.debug("onStopRequest: subscriptionUri", subscriptionUri);

    var linkList;
    try {
      linkList = aRequest.getResponseHeader("link");
    } catch (err) {
      this._reject(new Error("Missing Link header"));
      return;
    }

    var linkParserResult;
    try {
      linkParserResult = linkParser(linkList, this._serverURI);
    } catch (e) {
      this._reject(e);
      return;
    }

    if (!subscriptionUri) {
      this._reject(new Error("Invalid Location header"));
      return;
    }
    try {
      let uriTry = Services.io.newURI(subscriptionUri, null, null);
    } catch (e) {
      console.error("onStopRequest: Invalid subscription URI",
        subscriptionUri);
      this._reject(new Error("Invalid subscription endpoint: " +
        subscriptionUri));
      return;
    }

    let reply = new PushRecordHttp2({
      subscriptionUri: subscriptionUri,
      pushEndpoint: linkParserResult.pushEndpoint,
      pushReceiptEndpoint: linkParserResult.pushReceiptEndpoint,
      scope: this._subInfo.record.scope,
      originAttributes: this._subInfo.record.originAttributes,
      systemRecord: this._subInfo.record.systemRecord,
      appServerKey: this._subInfo.record.appServerKey,
      ctime: Date.now(),
    });

    Services.telemetry.getHistogramById("PUSH_API_SUBSCRIBE_HTTP2_TIME").add(Date.now() - this._ctime);
    this._resolve(reply);
  },

  abortRetry: function() {
    if (this._retryTimeoutID != null) {
      clearTimeout(this._retryTimeoutID);
      this._retryTimeoutID = null;
    } else {
      console.debug("SubscriptionListener.abortRetry: aborting non-existent retry?");
    }
  },
};

function retryAfterParser(aRequest) {
  var retryAfter = 0;
  try {
    var retryField = aRequest.getResponseHeader("retry-after");
    if (isNaN(retryField)) {
      retryAfter = Date.parse(retryField) - (new Date().getTime());
    } else {
      retryAfter = parseInt(retryField, 10) * 1000;
    }
    retryAfter = (retryAfter > 0) ? retryAfter : 0;
  } catch(e) {}

  return retryAfter;
}

function linkParser(linkHeader, serverURI) {

  var linkList = linkHeader.split(',');
  if ((linkList.length < 1)) {
    throw new Error("Invalid Link header");
  }

  var pushEndpoint;
  var pushReceiptEndpoint;

  linkList.forEach(link => {
    var linkElems = link.split(';');

    if (linkElems.length == 2) {
      if (linkElems[1].trim() === 'rel="urn:ietf:params:push"') {
        pushEndpoint = linkElems[0].substring(linkElems[0].indexOf('<') + 1,
                                              linkElems[0].indexOf('>'));

      } else if (linkElems[1].trim() === 'rel="urn:ietf:params:push:receipt"') {
        pushReceiptEndpoint = linkElems[0].substring(linkElems[0].indexOf('<') + 1,
                                                     linkElems[0].indexOf('>'));
      }
    }
  });

  console.debug("linkParser: pushEndpoint", pushEndpoint);
  console.debug("linkParser: pushReceiptEndpoint", pushReceiptEndpoint);
  // Missing pushReceiptEndpoint is allowed.
  if (!pushEndpoint) {
    throw new Error("Missing push endpoint");
  }

  var pushURI = Services.io.newURI(pushEndpoint, null, serverURI);
  var pushReceiptURI;
  if (pushReceiptEndpoint) {
    pushReceiptURI = Services.io.newURI(pushReceiptEndpoint, null,
                                        serverURI);
  }

  return {
    pushEndpoint: pushURI.spec,
    pushReceiptEndpoint: (pushReceiptURI) ? pushReceiptURI.spec : "",
  };
}

/**
 * The implementation of the WebPush.
 */
this.PushServiceHttp2 = {
  _mainPushService: null,
  _serverURI: null,

  // Keep information about all connections, e.g. the channel, listener...
  _conns: {},
  _started: false,

  // Set of SubscriptionListeners that are pending a subscription retry attempt.
  _listenersPendingRetry: new Set(),

  newPushDB: function() {
    return new PushDB(kPUSHHTTP2DB_DB_NAME,
                      kPUSHHTTP2DB_DB_VERSION,
                      kPUSHHTTP2DB_STORE_NAME,
                      "subscriptionUri",
                      PushRecordHttp2);
  },

  hasmainPushService: function() {
    return this._mainPushService !== null;
  },

  validServerURI: function(serverURI) {
    if (serverURI.scheme == "http") {
      return !!prefs.get("testing.allowInsecureServerURL");
    }
    return serverURI.scheme == "https";
  },

  connect: function(subscriptions) {
    this.startConnections(subscriptions);
  },

  isConnected: function() {
    return this._mainPushService != null;
  },

  disconnect: function() {
    this._shutdownConnections(false);
  },

  _makeChannel: function(aUri) {
    var chan = NetUtil.newChannel({uri: aUri, loadUsingSystemPrincipal: true})
                      .QueryInterface(Ci.nsIHttpChannel);

    var loadGroup = Cc["@mozilla.org/network/load-group;1"]
                      .createInstance(Ci.nsILoadGroup);
    chan.loadGroup = loadGroup;
    return chan;
  },

  /**
   * Subscribe new resource.
   */
  register: function(aRecord) {
    console.debug("subscribeResource()");

    return this._subscribeResourceInternal({
      record: aRecord,
      retries: 0
    })
    .then(result =>
      PushCrypto.generateKeys()
        .then(([publicKey, privateKey]) => {
        result.p256dhPublicKey = publicKey;
        result.p256dhPrivateKey = privateKey;
        result.authenticationSecret = PushCrypto.generateAuthenticationSecret();
        this._conns[result.subscriptionUri] = {
          channel: null,
          listener: null,
          countUnableToConnect: 0,
          lastStartListening: 0,
          retryTimerID: 0,
        };
        this._listenForMsgs(result.subscriptionUri);
        return result;
      })
    );
  },

  _subscribeResourceInternal: function(aSubInfo) {
    console.debug("subscribeResourceInternal()");

    return new Promise((resolve, reject) => {
      var listener = new SubscriptionListener(aSubInfo,
                                              resolve,
                                              reject,
                                              this._serverURI,
                                              this);

      var chan = this._makeChannel(this._serverURI.spec);
      chan.requestMethod = "POST";
      chan.asyncOpen2(listener);
    })
    .catch(err => {
      if ("retry" in err) {
        return this._subscribeResourceInternal(err.subInfo);
      } else {
        throw err;
      }
    })
  },

  _deleteResource: function(aUri) {

    return new Promise((resolve,reject) => {
      var chan = this._makeChannel(aUri);
      chan.requestMethod = "DELETE";
      chan.asyncOpen2(new PushServiceDelete(resolve, reject));
    });
  },

  /**
   * Unsubscribe the resource with a subscription uri aSubscriptionUri.
   * We can't do anything about it if it fails, so we don't listen for response.
   */
  _unsubscribeResource: function(aSubscriptionUri) {
    console.debug("unsubscribeResource()");

    return this._deleteResource(aSubscriptionUri);
  },

  /**
   * Start listening for messages.
   */
  _listenForMsgs: function(aSubscriptionUri) {
    console.debug("listenForMsgs()", aSubscriptionUri);
    if (!this._conns[aSubscriptionUri]) {
      console.warn("listenForMsgs: We do not have this subscription",
        aSubscriptionUri);
      return;
    }

    var chan = this._makeChannel(aSubscriptionUri);
    var conn = {};
    conn.channel = chan;
    var listener = new PushSubscriptionListener(this, aSubscriptionUri);
    conn.listener = listener;

    chan.notificationCallbacks = listener;

    try {
      chan.asyncOpen2(listener);
    } catch (e) {
      console.error("listenForMsgs: Error connecting to push server.",
        "asyncOpen2 failed", e);
      conn.listener.disconnect();
      chan.cancel(Cr.NS_ERROR_ABORT);
      this._retryAfterBackoff(aSubscriptionUri, -1);
      return;
    }

    this._conns[aSubscriptionUri].lastStartListening = Date.now();
    this._conns[aSubscriptionUri].channel = conn.channel;
    this._conns[aSubscriptionUri].listener = conn.listener;

  },

  _ackMsgRecv: function(aAckUri) {
    console.debug("ackMsgRecv()", aAckUri);
    return this._deleteResource(aAckUri);
  },

  init: function(aOptions, aMainPushService, aServerURL) {
    console.debug("init()");
    this._mainPushService = aMainPushService;
    this._serverURI = aServerURL;

    return Promise.resolve();
  },

  _retryAfterBackoff: function(aSubscriptionUri, retryAfter) {
    console.debug("retryAfterBackoff()");

    var resetRetryCount = prefs.get("http2.reset_retry_count_after_ms");
    // If it was running for some time, reset retry counter.
    if ((Date.now() - this._conns[aSubscriptionUri].lastStartListening) >
        resetRetryCount) {
      this._conns[aSubscriptionUri].countUnableToConnect = 0;
    }

    let maxRetries = prefs.get("http2.maxRetries");
    if (this._conns[aSubscriptionUri].countUnableToConnect >= maxRetries) {
      this._shutdownSubscription(aSubscriptionUri);
      this._resubscribe(aSubscriptionUri);
      return;
    }

    if (retryAfter !== -1) {
      // This is a 5xx response.
      this._conns[aSubscriptionUri].countUnableToConnect++;
      this._conns[aSubscriptionUri].retryTimerID =
        setTimeout(_ => this._listenForMsgs(aSubscriptionUri), retryAfter);
      return;
    }

    retryAfter = prefs.get("http2.retryInterval") *
      Math.pow(2, this._conns[aSubscriptionUri].countUnableToConnect);

    retryAfter = retryAfter * (0.8 + Math.random() * 0.4); // add +/-20%.

    this._conns[aSubscriptionUri].countUnableToConnect++;
    this._conns[aSubscriptionUri].retryTimerID =
      setTimeout(_ => this._listenForMsgs(aSubscriptionUri), retryAfter);

    console.debug("retryAfterBackoff: Retry in", retryAfter);
  },

  // Close connections.
  _shutdownConnections: function(deleteInfo) {
    console.debug("shutdownConnections()");

    for (let subscriptionUri in this._conns) {
      if (this._conns[subscriptionUri]) {
        if (this._conns[subscriptionUri].listener) {
          this._conns[subscriptionUri].listener._pushService = null;
        }

        if (this._conns[subscriptionUri].channel) {
          try {
            this._conns[subscriptionUri].channel.cancel(Cr.NS_ERROR_ABORT);
          } catch (e) {}
        }
        this._conns[subscriptionUri].listener = null;
        this._conns[subscriptionUri].channel = null;

        if (this._conns[subscriptionUri].retryTimerID > 0) {
          clearTimeout(this._conns[subscriptionUri].retryTimerID);
        }

        if (deleteInfo) {
          delete this._conns[subscriptionUri];
        }
      }
    }
  },

  // Start listening if subscriptions present.
  startConnections: function(aSubscriptions) {
    console.debug("startConnections()", aSubscriptions.length);

    for (let i = 0; i < aSubscriptions.length; i++) {
      let record = aSubscriptions[i];
      this._mainPushService.ensureCrypto(record).then(record => {
        this._startSingleConnection(record);
      }, error => {
        console.error("startConnections: Error updating record",
          record.keyID, error);
      });
    }
  },

  _startSingleConnection: function(record) {
    console.debug("_startSingleConnection()");
    if (typeof this._conns[record.subscriptionUri] != "object") {
      this._conns[record.subscriptionUri] = {channel: null,
                                             listener: null,
                                             countUnableToConnect: 0,
                                             retryTimerID: 0};
    }
    if (!this._conns[record.subscriptionUri].conn) {
      this._listenForMsgs(record.subscriptionUri);
    }
  },

  // Close connection and notify apps that subscription are gone.
  _shutdownSubscription: function(aSubscriptionUri) {
    console.debug("shutdownSubscriptions()");

    if (typeof this._conns[aSubscriptionUri] == "object") {
      if (this._conns[aSubscriptionUri].listener) {
        this._conns[aSubscriptionUri].listener._pushService = null;
      }

      if (this._conns[aSubscriptionUri].channel) {
        try {
          this._conns[aSubscriptionUri].channel.cancel(Cr.NS_ERROR_ABORT);
        } catch (e) {}
      }
      delete this._conns[aSubscriptionUri];
    }
  },

  uninit: function() {
    console.debug("uninit()");
    this._abortPendingSubscriptionRetries();
    this._shutdownConnections(true);
    this._mainPushService = null;
  },

  _abortPendingSubscriptionRetries: function() {
    this._listenersPendingRetry.forEach((listener) => listener.abortRetry());
    this._listenersPendingRetry.clear();
  },

  unregister: function(aRecord) {
    this._shutdownSubscription(aRecord.subscriptionUri);
    return this._unsubscribeResource(aRecord.subscriptionUri);
  },

  reportDeliveryError: function(messageID, reason) {
    console.warn("reportDeliveryError: Ignoring message delivery error",
      messageID, reason);
  },

  /** Push server has deleted subscription.
   *  Re-subscribe - if it succeeds send update db record and send
   *                 pushsubscriptionchange,
   *               - on error delete record and send pushsubscriptionchange
   *  TODO: maybe pushsubscriptionerror will be included.
   */
  _resubscribe: function(aSubscriptionUri) {
    this._mainPushService.getByKeyID(aSubscriptionUri)
      .then(record => this.register(record)
        .then(recordNew => {
          if (this._mainPushService) {
            this._mainPushService
                .updateRegistrationAndNotifyApp(aSubscriptionUri, recordNew)
                .catch(Cu.reportError);
          }
        }, error => {
          if (this._mainPushService) {
            this._mainPushService
                .dropRegistrationAndNotifyApp(aSubscriptionUri)
                .catch(Cu.reportError);
          }
        })
      );
  },

  connOnStop: function(aRequest, aSuccess,
                       aSubscriptionUri) {
    console.debug("connOnStop() succeeded", aSuccess);

    var conn = this._conns[aSubscriptionUri];
    if (!conn) {
      // there is no connection description that means that we closed
      // connection, so do nothing. But we should have already deleted
      // the listener.
      return;
    }

    conn.channel = null;
    conn.listener = null;

    if (!aSuccess) {
      this._retryAfterBackoff(aSubscriptionUri, -1);

    } else if (Math.floor(aRequest.responseStatus / 100) == 5) {
      var retryAfter = retryAfterParser(aRequest);
      this._retryAfterBackoff(aSubscriptionUri, retryAfter);

    } else if (Math.floor(aRequest.responseStatus / 100) == 4) {
      this._shutdownSubscription(aSubscriptionUri);
      this._resubscribe(aSubscriptionUri);
    } else if (Math.floor(aRequest.responseStatus / 100) == 2) { // This should be 204
      setTimeout(_ => this._listenForMsgs(aSubscriptionUri), 0);
    } else {
      this._retryAfterBackoff(aSubscriptionUri, -1);
    }
  },

  addListenerPendingRetry: function(aListener) {
    this._listenersPendingRetry.add(aListener);
  },

  removeListenerPendingRetry: function(aListener) {
    if (!this._listenersPendingRetry.remove(aListener)) {
      console.debug("removeListenerPendingRetry: listener not in list?");
    }
  },

  _pushChannelOnStop: function(aUri, aAckUri, aHeaders, aMessage) {
    console.debug("pushChannelOnStop()");

    this._mainPushService.receivedPushMessage(
      aUri, "", aHeaders, aMessage, record => {
        // Always update the stored record.
        return record;
      }
    )
    .then(_ => this._ackMsgRecv(aAckUri))
    .catch(err => {
      console.error("pushChannelOnStop: Error receiving message",
        err);
    });
  },
};

function PushRecordHttp2(record) {
  PushRecord.call(this, record);
  this.subscriptionUri = record.subscriptionUri;
  this.pushReceiptEndpoint = record.pushReceiptEndpoint;
}

PushRecordHttp2.prototype = Object.create(PushRecord.prototype, {
  keyID: {
    get() {
      return this.subscriptionUri;
    },
  },
});

PushRecordHttp2.prototype.toSubscription = function() {
  let subscription = PushRecord.prototype.toSubscription.call(this);
  subscription.pushReceiptEndpoint = this.pushReceiptEndpoint;
  return subscription;
};
