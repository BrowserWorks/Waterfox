/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const EXPORTED_SYMBOLS = ["WebRequest"];

/* exported WebRequest */

const Ci = Components.interfaces;
const Cc = Components.classes;
const Cu = Components.utils;
const Cr = Components.results;

const {nsIHttpActivityObserver, nsISocketTransport} = Ci;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Task.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "AppConstants",
                                  "resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "BrowserUtils",
                                  "resource://gre/modules/BrowserUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ExtensionUtils",
                                  "resource://gre/modules/ExtensionUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "WebRequestCommon",
                                  "resource://gre/modules/WebRequestCommon.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "WebRequestUpload",
                                  "resource://gre/modules/WebRequestUpload.jsm");

XPCOMUtils.defineLazyGetter(this, "ExtensionError", () => ExtensionUtils.ExtensionError);

function attachToChannel(channel, key, data) {
  if (channel instanceof Ci.nsIWritablePropertyBag2) {
    let wrapper = {wrappedJSObject: data};
    channel.setPropertyAsInterface(key, wrapper);
  }
  return data;
}

function extractFromChannel(channel, key) {
  if (channel instanceof Ci.nsIPropertyBag2 && channel.hasKey(key)) {
    let data = channel.get(key);
    return data && data.wrappedJSObject;
  }
  return null;
}

function getData(channel) {
  const key = "mozilla.webRequest.data";
  return extractFromChannel(channel, key) || attachToChannel(channel, key, {});
}

var RequestId = {
  count: 1,
  create(channel = null) {
    let id = (this.count++).toString();
    if (channel) {
      getData(channel).requestId = id;
    }
    return id;
  },

  get(channel) {
    return channel && getData(channel).requestId || this.create(channel);
  },
};

function runLater(job) {
  Services.tm.currentThread.dispatch(job, Ci.nsIEventTarget.DISPATCH_NORMAL);
}

function parseFilter(filter) {
  if (!filter) {
    filter = {};
  }

  // FIXME: Support windowId filtering.
  return {urls: filter.urls || null, types: filter.types || null};
}

function parseExtra(extra, allowed = []) {
  if (extra) {
    for (let ex of extra) {
      if (allowed.indexOf(ex) == -1) {
        throw new ExtensionError(`Invalid option ${ex}`);
      }
    }
  }

  let result = {};
  for (let al of allowed) {
    if (extra && extra.indexOf(al) != -1) {
      result[al] = true;
    }
  }
  return result;
}

function mergeStatus(data, channel, event) {
  try {
    data.statusCode = channel.responseStatus;
    let statusText = channel.responseStatusText;
    let maj = {};
    let min = {};
    channel.QueryInterface(Ci.nsIHttpChannelInternal).getResponseVersion(maj, min);
    data.statusLine = `HTTP/${maj.value}.${min.value} ${data.statusCode} ${statusText}`;
  } catch (e) {
    // NS_ERROR_NOT_AVAILABLE might be thrown if it's an internal redirect, happening before
    // any actual HTTP traffic. Otherwise, let's report.
    if (event !== "onRedirect" || e.result !== Cr.NS_ERROR_NOT_AVAILABLE) {
      Cu.reportError(`webRequest Error: ${e} trying to merge status in ${event}@${channel.name}`);
    }
  }
}

function isThenable(value) {
  return value && typeof value === "object" && typeof value.then === "function";
}

class HeaderChanger {
  constructor(channel) {
    this.channel = channel;

    this.originalHeaders = new Map();
    this.visitHeaders((name, value) => {
      this.originalHeaders.set(name.toLowerCase(), value);
    });
  }

  toArray() {
    return Array.from(this.originalHeaders,
                      ([name, value]) => ({name, value}));
  }

  validateHeaders(headers) {
    // We should probably use schema validation for this.

    if (!Array.isArray(headers)) {
      return false;
    }

    return headers.every(header => {
      if (typeof header !== "object" || header === null) {
        return false;
      }

      if (typeof header.name !== "string") {
        return false;
      }

      return (typeof header.value === "string" ||
              Array.isArray(header.binaryValue));
    });
  }

  applyChanges(headers) {
    if (!this.validateHeaders(headers)) {
      /* globals uneval */
      Cu.reportError(`Invalid header array: ${uneval(headers)}`);
      return;
    }

    let newHeaders = new Set(headers.map(
      ({name}) => name.toLowerCase()));

    // Remove missing headers.
    for (let name of this.originalHeaders.keys()) {
      if (!newHeaders.has(name)) {
        this.setHeader(name, "");
      }
    }

    // Set new or changed headers.
    for (let {name, value, binaryValue} of headers) {
      if (binaryValue) {
        value = String.fromCharCode(...binaryValue);
      }
      if (value !== this.originalHeaders.get(name.toLowerCase())) {
        this.setHeader(name, value);
      }
    }
  }
}

class RequestHeaderChanger extends HeaderChanger {
  setHeader(name, value) {
    try {
      this.channel.setRequestHeader(name, value, false);
    } catch (e) {
      Cu.reportError(new Error(`Error setting request header ${name}: ${e}`));
    }
  }

  visitHeaders(visitor) {
    if (this.channel instanceof Ci.nsIHttpChannel) {
      this.channel.visitRequestHeaders(visitor);
    }
  }
}

class ResponseHeaderChanger extends HeaderChanger {
  setHeader(name, value) {
    try {
      if (name.toLowerCase() === "content-type" && value) {
        // The Content-Type header value can't be modified, so we
        // set the channel's content type directly, instead, and
        // record that we made the change for the sake of
        // subsequent observers.
        this.channel.contentType = value;

        getData(this.channel).contentType = value;
      } else {
        this.channel.setResponseHeader(name, value, false);
      }
    } catch (e) {
      Cu.reportError(new Error(`Error setting response header ${name}: ${e}`));
    }
  }

  visitHeaders(visitor) {
    if (this.channel instanceof Ci.nsIHttpChannel) {
      try {
        this.channel.visitResponseHeaders((name, value) => {
          if (name.toLowerCase() === "content-type") {
            value = getData(this.channel).contentType || value;
          }

          visitor(name, value);
        });
      } catch (e) {
        // Throws if response headers aren't available yet.
      }
    }
  }
}

var HttpObserverManager;

var ContentPolicyManager = {
  policyData: new Map(),
  policies: new Map(),
  idMap: new Map(),
  nextId: 0,

  init() {
    Services.ppmm.initialProcessData.webRequestContentPolicies = this.policyData;

    Services.ppmm.addMessageListener("WebRequest:ShouldLoad", this);
    Services.mm.addMessageListener("WebRequest:ShouldLoad", this);
  },

  receiveMessage(msg) {
    let browser = msg.target instanceof Ci.nsIDOMXULElement ? msg.target : null;

    let requestId = RequestId.create();
    for (let id of msg.data.ids) {
      let callback = this.policies.get(id);
      if (!callback) {
        // It's possible that this listener has been removed and the
        // child hasn't learned yet.
        continue;
      }
      let response = null;
      let listenerKind = "onStop";
      let data = Object.assign({requestId, browser}, msg.data);
      delete data.ids;
      try {
        response = callback(data);
        if (response) {
          if (response.cancel) {
            listenerKind = "onError";
            data.error = "NS_ERROR_ABORT";
            return {cancel: true};
          }
          // FIXME: Need to handle redirection here (for non-HTTP URIs only)
        }
      } catch (e) {
        Cu.reportError(e);
      } finally {
        runLater(() => this.runChannelListener(listenerKind, data));
      }
    }

    return {};
  },

  runChannelListener(kind, data) {
    let listeners = HttpObserverManager.listeners[kind];
    let uri = BrowserUtils.makeURI(data.url);
    let policyType = data.type;
    for (let [callback, opts] of listeners.entries()) {
      if (!HttpObserverManager.shouldRunListener(policyType, uri, opts.filter)) {
        continue;
      }
      callback(data);
    }
  },

  addListener(callback, opts) {
    // Clone opts, since we're going to modify them for IPC.
    opts = Object.assign({}, opts);
    let id = this.nextId++;
    opts.id = id;
    if (opts.filter.urls) {
      opts.filter = Object.assign({}, opts.filter);
      opts.filter.urls = opts.filter.urls.serialize();
    }
    Services.ppmm.broadcastAsyncMessage("WebRequest:AddContentPolicy", opts);

    this.policyData.set(id, opts);

    this.policies.set(id, callback);
    this.idMap.set(callback, id);
  },

  removeListener(callback) {
    let id = this.idMap.get(callback);
    Services.ppmm.broadcastAsyncMessage("WebRequest:RemoveContentPolicy", {id});

    this.policyData.delete(id);
    this.idMap.delete(callback);
    this.policies.delete(id);
  },
};
ContentPolicyManager.init();

function StartStopListener(manager, loadContext) {
  this.manager = manager;
  this.loadContext = loadContext;
  this.orig = null;
}

StartStopListener.prototype = {
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIRequestObserver,
                                         Ci.nsIStreamListener]),

  onStartRequest: function(request, context) {
    this.manager.onStartRequest(request, this.loadContext);
    this.orig.onStartRequest(request, context);
  },

  onStopRequest(request, context, statusCode) {
    try {
      this.orig.onStopRequest(request, context, statusCode);
    } catch (e) {
      Cu.reportError(e);
    }
    this.manager.onStopRequest(request, this.loadContext);
  },

  onDataAvailable(...args) {
    return this.orig.onDataAvailable(...args);
  },
};

var ChannelEventSink = {
  _classDescription: "WebRequest channel event sink",
  _classID: Components.ID("115062f8-92f1-11e5-8b7f-080027b0f7ec"),
  _contractID: "@mozilla.org/webrequest/channel-event-sink;1",

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIChannelEventSink,
                                         Ci.nsIFactory]),

  init() {
    Components.manager.QueryInterface(Ci.nsIComponentRegistrar)
      .registerFactory(this._classID, this._classDescription, this._contractID, this);
  },

  register() {
    let catMan = Cc["@mozilla.org/categorymanager;1"].getService(Ci.nsICategoryManager);
    catMan.addCategoryEntry("net-channel-event-sinks", this._contractID, this._contractID, false, true);
  },

  unregister() {
    let catMan = Cc["@mozilla.org/categorymanager;1"].getService(Ci.nsICategoryManager);
    catMan.deleteCategoryEntry("net-channel-event-sinks", this._contractID, false);
  },

  // nsIChannelEventSink implementation
  asyncOnChannelRedirect(oldChannel, newChannel, flags, redirectCallback) {
    runLater(() => redirectCallback.onRedirectVerifyCallback(Cr.NS_OK));
    try {
      HttpObserverManager.onChannelReplaced(oldChannel, newChannel);
    } catch (e) {
      // we don't wanna throw: it would abort the redirection
    }
  },

  // nsIFactory implementation
  createInstance(outer, iid) {
    if (outer) {
      throw Cr.NS_ERROR_NO_AGGREGATION;
    }
    return this.QueryInterface(iid);
  },
};

ChannelEventSink.init();

HttpObserverManager = {
  modifyInitialized: false,
  examineInitialized: false,
  redirectInitialized: false,
  activityInitialized: false,
  needTracing: false,

  listeners: {
    opening: new Map(),
    modify: new Map(),
    afterModify: new Map(),
    headersReceived: new Map(),
    onRedirect: new Map(),
    onStart: new Map(),
    onError: new Map(),
    onStop: new Map(),
  },

  get activityDistributor() {
    return Cc["@mozilla.org/network/http-activity-distributor;1"].getService(Ci.nsIHttpActivityDistributor);
  },

  addOrRemove() {
    let needModify = this.listeners.opening.size || this.listeners.modify.size || this.listeners.afterModify.size;
    if (needModify && !this.modifyInitialized) {
      this.modifyInitialized = true;
      Services.obs.addObserver(this, "http-on-modify-request", false);
    } else if (!needModify && this.modifyInitialized) {
      this.modifyInitialized = false;
      Services.obs.removeObserver(this, "http-on-modify-request");
    }
    this.needTracing = this.listeners.onStart.size ||
                       this.listeners.onError.size ||
                       this.listeners.onStop.size;

    let needExamine = this.needTracing ||
                      this.listeners.headersReceived.size;

    if (needExamine && !this.examineInitialized) {
      this.examineInitialized = true;
      Services.obs.addObserver(this, "http-on-examine-response", false);
      Services.obs.addObserver(this, "http-on-examine-cached-response", false);
      Services.obs.addObserver(this, "http-on-examine-merged-response", false);
    } else if (!needExamine && this.examineInitialized) {
      this.examineInitialized = false;
      Services.obs.removeObserver(this, "http-on-examine-response");
      Services.obs.removeObserver(this, "http-on-examine-cached-response");
      Services.obs.removeObserver(this, "http-on-examine-merged-response");
    }

    let needRedirect = this.listeners.onRedirect.size;
    if (needRedirect && !this.redirectInitialized) {
      this.redirectInitialized = true;
      ChannelEventSink.register();
    } else if (!needRedirect && this.redirectInitialized) {
      this.redirectInitialized = false;
      ChannelEventSink.unregister();
    }

    let needActivity = this.listeners.onError.size;
    if (needActivity && !this.activityInitialized) {
      this.activityInitialized = true;
      this.activityDistributor.addObserver(this);
    } else if (!needActivity && this.activityInitialized) {
      this.activityInitialized = false;
      this.activityDistributor.removeObserver(this);
    }
  },

  addListener(kind, callback, opts) {
    this.listeners[kind].set(callback, opts);
    this.addOrRemove();
  },

  removeListener(kind, callback) {
    this.listeners[kind].delete(callback);
    this.addOrRemove();
  },

  getLoadContext(channel) {
    try {
      return channel.QueryInterface(Ci.nsIChannel)
                    .notificationCallbacks
                    .getInterface(Components.interfaces.nsILoadContext);
    } catch (e) {
      try {
        return channel.loadGroup
                      .notificationCallbacks
                      .getInterface(Components.interfaces.nsILoadContext);
      } catch (e) {
        return null;
      }
    }
  },

  observe(subject, topic, data) {
    let channel = subject.QueryInterface(Ci.nsIHttpChannel);
    switch (topic) {
      case "http-on-modify-request":
        let loadContext = this.getLoadContext(channel);

        this.runChannelListener(channel, loadContext, "opening");
        break;
      case "http-on-examine-cached-response":
      case "http-on-examine-merged-response":
        getData(channel).fromCache = true;
        // falls through
      case "http-on-examine-response":
        this.examine(channel, topic, data);
        break;
    }
  },

  // We map activity values with tentative error names, e.g. "STATUS_RESOLVING" => "NS_ERROR_NET_ON_RESOLVING".
  get activityErrorsMap() {
    let prefix = /^(?:ACTIVITY_SUBTYPE_|STATUS_)/;
    let map = new Map();
    for (let iface of [nsIHttpActivityObserver, nsISocketTransport]) {
      for (let c of Object.keys(iface).filter(name => prefix.test(name))) {
        map.set(iface[c], c.replace(prefix, "NS_ERROR_NET_ON_"));
      }
    }
    delete this.activityErrorsMap;
    this.activityErrorsMap = map;
    return this.activityErrorsMap;
  },
  GOOD_LAST_ACTIVITY: nsIHttpActivityObserver.ACTIVITY_SUBTYPE_RESPONSE_HEADER,
  observeActivity(channel, activityType, activitySubtype /* , aTimestamp, aExtraSizeData, aExtraStringData */) {
    let channelData = getData(channel);
    let lastActivity = channelData.lastActivity || 0;
    if (activitySubtype === nsIHttpActivityObserver.ACTIVITY_SUBTYPE_RESPONSE_COMPLETE &&
        lastActivity && lastActivity !== this.GOOD_LAST_ACTIVITY) {
      let loadContext = this.getLoadContext(channel);
      if (!this.errorCheck(channel, loadContext, channelData)) {
        this.runChannelListener(channel, loadContext, "onError",
                                {error: this.activityErrorsMap.get(lastActivity) ||
                                        `NS_ERROR_NET_UNKNOWN_${lastActivity}`});
      }
    } else if (lastActivity !== this.GOOD_LAST_ACTIVITY &&
               lastActivity !== nsIHttpActivityObserver.ACTIVITY_SUBTYPE_TRANSACTION_CLOSE) {
      channelData.lastActivity = activitySubtype;
    }
  },

  shouldRunListener(policyType, uri, filter) {
    return WebRequestCommon.typeMatches(policyType, filter.types) &&
           WebRequestCommon.urlMatches(uri, filter.urls);
  },

  get resultsMap() {
    delete this.resultsMap;
    this.resultsMap = new Map(Object.keys(Cr).map(name => [Cr[name], name]));
    return this.resultsMap;
  },
  maybeError(channel, extraData = null, channelData = null) {
    if (!(extraData && extraData.error)) {
      if (!Components.isSuccessCode(channel.status)) {
        extraData = {error: this.resultsMap.get(channel.status)};
      }
    }
    return extraData;
  },
  errorCheck(channel, loadContext, channelData = null) {
    let errorData = this.maybeError(channel, null, channelData);
    if (errorData) {
      this.runChannelListener(channel, loadContext, "onError", errorData);
    }
    return errorData;
  },

  /**
   * Resumes the channel if it is currently suspended due to this
   * listener.
   *
   * @param {nsIChannel} channel
   *        The channel to possibly suspend.
   */
  maybeResume(channel) {
    let data = getData(channel);
    if (data.suspended) {
      channel.resume();
      data.suspended = false;
    }
  },

  /**
   * Suspends the channel if it is not currently suspended due to this
   * listener. Returns true if the channel was suspended as a result of
   * this call.
   *
   * @param {nsIChannel} channel
   *        The channel to possibly suspend.
   * @returns {boolean}
   *        True if this call resulted in the channel being suspended.
   */
  maybeSuspend(channel) {
    let data = getData(channel);
    if (!data.suspended) {
      channel.suspend();
      data.suspended = true;
      return true;
    }
  },

  getRequestData(channel, loadContext, policyType, extraData) {
    let {loadInfo} = channel;

    let data = {
      requestId: RequestId.get(channel),
      url: channel.URI.spec,
      method: channel.requestMethod,
      browser: loadContext && loadContext.topFrameElement,
      type: WebRequestCommon.typeForPolicyType(policyType),
      fromCache: getData(channel).fromCache,
      windowId: 0,
      parentWindowId: 0,
    };

    if (loadInfo) {
      let originPrincipal = loadInfo.triggeringPrincipal;
      if (originPrincipal.URI) {
        data.originUrl = originPrincipal.URI.spec;
      }

      // If there is no loadingPrincipal, check that the request is not going to
      // inherit a system principal.  triggeringPrincipal is the context that
      // initiated the load, but is not necessarily the principal that the
      // request results in, only rely on that if no other principal is available.
      let {isSystemPrincipal} = Services.scriptSecurityManager;
      let isTopLevel = !loadInfo.loadingPrincipal && !!data.browser;
      data.isSystemPrincipal = !isTopLevel &&
                               isSystemPrincipal(loadInfo.loadingPrincipal ||
                                                 loadInfo.principalToInherit ||
                                                 loadInfo.triggeringPrincipal);

      if (loadInfo.frameOuterWindowID) {
        Object.assign(data, {
          windowId: loadInfo.frameOuterWindowID,
          parentWindowId: loadInfo.outerWindowID,
        });
      } else {
        Object.assign(data, {
          windowId: loadInfo.outerWindowID,
          parentWindowId: loadInfo.parentOuterWindowID,
        });
      }
    }

    if (channel instanceof Ci.nsIHttpChannelInternal) {
      try {
        data.ip = channel.remoteAddress;
      } catch (e) {
        // The remoteAddress getter throws if the address is unavailable,
        // but ip is an optional property so just ignore the exception.
      }
    }

    return Object.assign(data, extraData);
  },

  runChannelListener(channel, loadContext = null, kind, extraData = null) {
    let handlerResults = [];
    let requestHeaders;
    let responseHeaders;

    try {
      if (this.activityInitialized) {
        let channelData = getData(channel);
        if (kind === "onError") {
          if (channelData.errorNotified) {
            return;
          }
          channelData.errorNotified = true;
        } else if (this.errorCheck(channel, loadContext, channelData)) {
          return;
        }
      }

      let {loadInfo} = channel;
      let policyType = (loadInfo ? loadInfo.externalContentPolicyType
                                 : Ci.nsIContentPolicy.TYPE_OTHER);

      let includeStatus = (["headersReceived", "onRedirect", "onStart", "onStop"].includes(kind) &&
                           channel instanceof Ci.nsIHttpChannel);

      let commonData = null;
      let uri = channel.URI;
      let requestBody;
      for (let [callback, opts] of this.listeners[kind].entries()) {
        if (!this.shouldRunListener(policyType, uri, opts.filter)) {
          continue;
        }

        if (!commonData) {
          commonData = this.getRequestData(channel, loadContext, policyType, extraData);
        }
        let data = Object.assign({}, commonData);

        if (opts.requestHeaders) {
          requestHeaders = requestHeaders || new RequestHeaderChanger(channel);
          data.requestHeaders = requestHeaders.toArray();
        }

        if (opts.responseHeaders) {
          responseHeaders = responseHeaders || new ResponseHeaderChanger(channel);
          data.responseHeaders = responseHeaders.toArray();
        }

        if (opts.requestBody) {
          requestBody = requestBody || WebRequestUpload.createRequestBody(channel);
          data.requestBody = requestBody;
        }

        if (includeStatus) {
          mergeStatus(data, channel, kind);
        }

        try {
          let result = callback(data);

          if (result && typeof result === "object" && opts.blocking
              && !AddonManagerPermissions.isHostPermitted(uri.host)
              && (!loadInfo || !loadInfo.loadingPrincipal
                  || !loadInfo.loadingPrincipal.URI
                  || !AddonManagerPermissions.isHostPermitted(loadInfo.loadingPrincipal.URI.host))) {
            handlerResults.push({opts, result});
          }
        } catch (e) {
          Cu.reportError(e);
        }
      }
    } catch (e) {
      Cu.reportError(e);
    }

    return this.applyChanges(kind, channel, loadContext, handlerResults,
                             requestHeaders, responseHeaders);
  },

  applyChanges: Task.async(function* (kind, channel, loadContext, handlerResults, requestHeaders, responseHeaders) {
    let asyncHandlers = handlerResults.filter(({result}) => isThenable(result));
    let isAsync = asyncHandlers.length > 0;
    let shouldResume = false;

    try {
      if (isAsync) {
        shouldResume = this.maybeSuspend(channel);

        for (let value of asyncHandlers) {
          try {
            value.result = yield value.result;
          } catch (e) {
            Cu.reportError(e);
            value.result = {};
          }
        }
      }

      for (let {opts, result} of handlerResults) {
        if (!result || typeof result !== "object") {
          continue;
        }

        if (result.cancel) {
          this.maybeResume(channel);
          channel.cancel(Cr.NS_ERROR_ABORT);

          this.errorCheck(channel, loadContext);
          return;
        }

        if (result.redirectUrl) {
          try {
            this.maybeResume(channel);

            channel.redirectTo(BrowserUtils.makeURI(result.redirectUrl));
            return;
          } catch (e) {
            Cu.reportError(e);
          }
        }

        if (opts.requestHeaders && result.requestHeaders && requestHeaders) {
          requestHeaders.applyChanges(result.requestHeaders);
        }

        if (opts.responseHeaders && result.responseHeaders && responseHeaders) {
          responseHeaders.applyChanges(result.responseHeaders);
        }
      }

      if (kind === "opening") {
        yield this.runChannelListener(channel, loadContext, "modify");
      } else if (kind === "modify") {
        yield this.runChannelListener(channel, loadContext, "afterModify");
      }
    } catch (e) {
      Cu.reportError(e);
    }

    // Only resume the channel if it was suspended by this call.
    if (shouldResume) {
      this.maybeResume(channel);
    }
  }),

  examine(channel, topic, data) {
    let loadContext = this.getLoadContext(channel);

    if (this.needTracing) {
      // Check whether we've already added a listener to this channel,
      // so we don't wind up chaining multiple listeners.
      let channelData = getData(channel);
      if (!channelData.hasListener && channel instanceof Ci.nsITraceableChannel) {
        let responseStatus = channel.responseStatus;
        // skip redirections, https://bugzilla.mozilla.org/show_bug.cgi?id=728901#c8
        if (responseStatus < 300 || responseStatus >= 400) {
          let listener = new StartStopListener(this, loadContext);
          let orig = channel.setNewListener(listener);
          listener.orig = orig;
          channelData.hasListener = true;
        }
      }
    }

    this.runChannelListener(channel, loadContext, "headersReceived");
  },

  onChannelReplaced(oldChannel, newChannel) {
    this.runChannelListener(oldChannel, this.getLoadContext(oldChannel),
                            "onRedirect", {redirectUrl: newChannel.URI.spec});
  },

  onStartRequest(channel, loadContext) {
    this.runChannelListener(channel, loadContext, "onStart");
  },

  onStopRequest(channel, loadContext) {
    this.runChannelListener(channel, loadContext, "onStop");
  },
};

var onBeforeRequest = {
  get allowedOptions() {
    delete this.allowedOptions;
    this.allowedOptions = ["blocking"];
    if (!AppConstants.RELEASE_OR_BETA) {
      this.allowedOptions.push("requestBody");
    }
    return this.allowedOptions;
  },
  addListener(callback, filter = null, opt_extraInfoSpec = null) {
    let opts = parseExtra(opt_extraInfoSpec, this.allowedOptions);
    opts.filter = parseFilter(filter);
    ContentPolicyManager.addListener(callback, opts);
    HttpObserverManager.addListener("opening", callback, opts);
  },

  removeListener(callback) {
    HttpObserverManager.removeListener("opening", callback);
    ContentPolicyManager.removeListener(callback);
  },
};

function HttpEvent(internalEvent, options) {
  this.internalEvent = internalEvent;
  this.options = options;
}

HttpEvent.prototype = {
  addListener(callback, filter = null, opt_extraInfoSpec = null) {
    let opts = parseExtra(opt_extraInfoSpec, this.options);
    opts.filter = parseFilter(filter);
    HttpObserverManager.addListener(this.internalEvent, callback, opts);
  },

  removeListener(callback) {
    HttpObserverManager.removeListener(this.internalEvent, callback);
  },
};

var onBeforeSendHeaders = new HttpEvent("modify", ["requestHeaders", "blocking"]);
var onSendHeaders = new HttpEvent("afterModify", ["requestHeaders"]);
var onHeadersReceived = new HttpEvent("headersReceived", ["blocking", "responseHeaders"]);
var onBeforeRedirect = new HttpEvent("onRedirect", ["responseHeaders"]);
var onResponseStarted = new HttpEvent("onStart", ["responseHeaders"]);
var onCompleted = new HttpEvent("onStop", ["responseHeaders"]);
var onErrorOccurred = new HttpEvent("onError");

var WebRequest = {
  // http-on-modify observer for HTTP(S), content policy for the other protocols (notably, data:)
  onBeforeRequest: onBeforeRequest,

  // http-on-modify observer.
  onBeforeSendHeaders: onBeforeSendHeaders,

  // http-on-modify observer.
  onSendHeaders: onSendHeaders,

  // http-on-examine-*observer.
  onHeadersReceived: onHeadersReceived,

  // nsIChannelEventSink.
  onBeforeRedirect: onBeforeRedirect,

  // OnStartRequest channel listener.
  onResponseStarted: onResponseStarted,

  // OnStopRequest channel listener.
  onCompleted: onCompleted,

  // nsIHttpActivityObserver.
  onErrorOccurred: onErrorOccurred,
};

Services.ppmm.loadProcessScript("resource://gre/modules/WebRequestContent.js", true);
