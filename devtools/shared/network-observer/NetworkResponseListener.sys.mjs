/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const lazy = {};

ChromeUtils.defineESModuleGetters(
  lazy,
  {
    NetUtil: "resource://gre/modules/NetUtil.sys.mjs",
    NetworkHelper:
      "resource://devtools/shared/network-observer/NetworkHelper.sys.mjs",
    NetworkTimings:
      "resource://devtools/shared/network-observer/NetworkTimings.sys.mjs",
    NetworkUtils:
      "resource://devtools/shared/network-observer/NetworkUtils.sys.mjs",
    getResponseCacheObject:
      "resource://devtools/shared/platform/CacheEntry.sys.mjs",
  },
  { global: "contextual" }
);

// Network logging

/**
 * The network response listener implements the nsIStreamListener and
 * nsIRequestObserver interfaces. This is used within the NetworkObserver feature
 * to get the response body of the request.
 *
 * The code is mostly based on code listings from:
 *
 *   http://www.softwareishard.com/blog/firebug/
 *      nsitraceablechannel-intercept-http-traffic/
 *
 * @class
 * @param {object} httpActivity
 *        HttpActivity object associated with this request. See NetworkObserver
 *        more information.
 * @param {object} options
 * @param {Map} options.decodedCertificateCache
 *        A Map of certificate fingerprints to decoded certificates, to avoid
 *        repeatedly decoding previously-seen certificates.
 * @param {boolean} options.decodeResponseBody
 *        Whether the response body should be dynamically decoded or not.
 * @param {boolean} options.fromServiceWorker
 *        Whether the response is coming from a service worker.
 * @param {number} options.responseBodyLimit
 *        The maximum size (in bytes) to store the response body. A value of 0
 *        means no maximum size.
 */
export class NetworkResponseListener {
  /**
   * The compressed and encoded response body size. Will progressively increase
   * until the full response is received.
   *
   * @type {number}
   */
  #bodySize = 0;
  /**
   * nsIStreamListener created by nsIStreamConverterService.asyncConvertData
   *
   * @type {nsIStreamListener}
   */
  #converter = null;
  /**
   * See constructor argument of the same name.
   *
   * @type {Map}
   */
  #decodedCertificateCache;
  /**
   * See constructor argument of the same name.
   *
   * @type {boolean}
   */
  #decodeResponseBody;
  /**
   * Array of compression encodings
   */
  #compressionEncodings = [];
  /**
   * Is the channel from a service worker
   *
   * @type {boolean}
   */
  #fromServiceWorker;
  /**
   * See constructor argument of the same name.
   *
   * @type {object}
   */
  #httpActivity;
  /**
   * Set from sink.inputStream, mainly to prevent GC.
   *
   * @type {nsIInputStream}
   */
  // eslint-disable-next-line no-unused-private-class-members
  #inputStream = null;
  /**
   * Internal promise used to hold the completion of #getSecurityInfo.
   *
   * @type {Promise}
   */
  #onSecurityInfo = null;
  /**
   * Offset for the onDataAvailable calls where we pass the data from our pipe
   * to the converter.
   *
   * @type {number}
   */
  #offset = 0;
  /**
   * The received response body size.
   *
   * @type {number}
   */
  #receivedBodySize = 0;
  /**
   * Stores the received data as ArrayBuffer of byte chunks.
   *
   * @type {Array}
   */
  #receivedEncodedChunks = [];
  /**
   * Stores the received data as a string.
   *
   * @type {string}
   */
  #receivedData = "";
  /**
   * The nsIRequest we are started for.
   *
   * @type {nsIRequest}
   */
  #request = null;
  /**
   * The maximum size (in bytes) to store the response body.
   *
   * @type {number}
   */
  #responseBodyLimit = 0;
  /**
   * Is true after the events which should be added at the start of a response
   * are added. This is only used for overridden requests.
   *
   * @type {boolean}
   */
  #sentStartEvents = false;
  /**
   * The response will be written into the outputStream of this nsIPipe.
   * Both ends of the pipe must be blocking.
   *
   * @type {nsIPipe}
   */
  #sink = null;
  /**
   * Used to decode the response body.
   *
   * @type {nsIScriptableUnicodeConverter}
   */
  #uconv = null;
  /**
   * Indicates if the response had a size greater than response body limit.
   *
   * @type {boolean}
   */
  #truncated = false;
  /**
   * Backup for existing notificationCallbacks set on the monitored channel.
   * Initialized in the constructor.
   *
   * @type {object}
   */
  #wrappedNotificationCallbacks;

  constructor(httpActivity, options) {
    const {
      decodedCertificateCache,
      decodeResponseBody,
      fromServiceWorker,
      responseBodyLimit,
    } = options;

    this.#httpActivity = httpActivity;
    this.#decodedCertificateCache = decodedCertificateCache;
    this.#decodeResponseBody = decodeResponseBody;
    this.#fromServiceWorker = fromServiceWorker;
    this.#responseBodyLimit = responseBodyLimit;

    // Note that this is really only needed for the non-e10s case.
    // See bug 1309523.
    const channel = this.#httpActivity.channel;
    // If the channel already had notificationCallbacks, hold them here
    // internally so that we can forward getInterface requests to that object.
    this.#wrappedNotificationCallbacks = channel.notificationCallbacks;
    channel.notificationCallbacks = this;
  }

  set inputStream(inputStream) {
    this.#inputStream = inputStream;
  }

  set sink(sink) {
    this.#sink = sink;
  }

  // nsIInterfaceRequestor implementation

  /**
   * This object implements nsIProgressEventSink, but also needs to forward
   * interface requests to the notification callbacks of other objects.
   */
  getInterface(iid) {
    if (iid.equals(Ci.nsIProgressEventSink)) {
      return this;
    }
    if (this.#wrappedNotificationCallbacks) {
      return this.#wrappedNotificationCallbacks.getInterface(iid);
    }
    throw Components.Exception("", Cr.NS_ERROR_NO_INTERFACE);
  }

  /**
   * Forward notifications for interfaces this object implements, in case other
   * objects also implemented them.
   */
  #forwardNotification(iid, method, args) {
    if (!this.#wrappedNotificationCallbacks) {
      return;
    }
    try {
      const impl = this.#wrappedNotificationCallbacks.getInterface(iid);
      impl[method].apply(impl, args);
    } catch (e) {
      if (e.result != Cr.NS_ERROR_NO_INTERFACE) {
        throw e;
      }
    }
  }

  /**
   * Set the async listener for the given nsIAsyncInputStream. This allows us to
   * wait asynchronously for any data coming from the stream.
   *
   * @param nsIAsyncInputStream stream
   *        The input stream from where we are waiting for data to come in.
   * @param nsIInputStreamCallback listener
   *        The input stream callback you want. This is an object that must have
   *        the onInputStreamReady() method. If the argument is null, then the
   *        current callback is removed.
   * @return void
   */
  setAsyncListener(stream, listener) {
    // Asynchronously wait for the stream to be readable or closed.
    stream.asyncWait(listener, 0, 0, Services.tm.mainThread);
  }

  #convertToUnicode(text, charset) {
    // We need to keep using the same converter instance to properly decode
    // the streamed content.
    if (!this.#uconv) {
      this.#uconv = Cc[
        "@mozilla.org/intl/scriptableunicodeconverter"
      ].createInstance(Ci.nsIScriptableUnicodeConverter);
      try {
        this.#uconv.charset = charset;
      } catch (ex) {
        this.#uconv.charset = "UTF-8";
      }
    }
    try {
      return this.#uconv.ConvertToUnicode(text);
    } catch (ex) {
      return text;
    }
  }

  /**
   * Stores the received data, if request/response body logging is enabled. It
   * also does limit the number of stored bytes, based on the
   * `devtools.netmonitor.responseBodyLimit` pref.
   *
   * Learn more about nsIStreamListener at:
   * https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIStreamListener
   *
   * @param nsIRequest request
   * @param nsISupports context
   * @param nsIInputStream inputStream
   * @param unsigned long offset
   * @param unsigned long count
   */
  onDataAvailable(request, inputStream, offset, count) {
    this.#receivedBodySize += count;

    // Read response input stream as a string or array buffer.
    // Do this unconditionally because we wait until the stream is consumed to
    // finalize the event.
    const chunk = this.#decodeResponseBody
      ? lazy.NetUtil.readInputStreamToString(inputStream, count)
      : lazy.NetUtil.readInputStream(inputStream, count);

    // Bail out if we don't want to record response bodies.
    // If response bodies are discarded, or if the current body is already
    // truncated, return before updating the stored  content.
    if (this.#httpActivity.discardResponseBody || this.#truncated) {
      return;
    }

    // Update the stored data.
    if (this.#decodeResponseBody) {
      this.#receivedData += this.#convertToUnicode(
        chunk,
        request.contentCharset
      );
    } else {
      this.#receivedEncodedChunks.push(chunk);
    }

    // Check if the response should be truncated
    const limit = this.#responseBodyLimit;
    const shouldTruncate = this.#receivedBodySize > limit && limit > 0;

    // Truncate the content.
    if (shouldTruncate) {
      this.#truncated = true;
      if (this.#decodeResponseBody) {
        // Truncate the received string for decoded responses.
        this.#receivedData = this.#receivedData.substr(0, limit);
      } else {
        // Remove the last chunk for encoded responses. This means we are not
        // truncating exactly to match the `responseBodyLimit`, as done for the
        // decoded responses.
        this.#receivedEncodedChunks.pop();
      }
    }
  }

  /**
   * See documentation at
   * https://developer.mozilla.org/En/NsIRequestObserver
   *
   * @param nsIRequest request
   */
  async onStartRequest(request) {
    request = request.QueryInterface(Ci.nsIChannel);
    // Converter will call this again, we should just ignore that.
    if (this.#request) {
      return;
    }

    this.#request = request;
    this.#onSecurityInfo = this.#getSecurityInfo();
    // We need to track the offset for the onDataAvailable calls where
    // we pass the data from our pipe to the converter.
    this.#offset = 0;
    this.#uconv = null;

    const channel = this.#request;

    // Bug 1372115 - We should load bytecode cached requests from cache as the actual
    // channel content is going to be optimized data that reflects platform internals
    // instead of the content user expects (i.e. content served by HTTP server)
    // Note that bytecode cached is one example, there may be wasm or other usecase in
    // future.
    let isOptimizedContent = false;
    try {
      if (channel instanceof Ci.nsICacheInfoChannel) {
        isOptimizedContent = channel.alternativeDataType;
      }
    } catch (e) {
      // Accessing `alternativeDataType` for some SW requests throws.
    }
    if (isOptimizedContent) {
      const data = await this.#getContentFromCache();
      this.#getResponseContent(data);
      this.#getResponseContentComplete();
      return;
    }

    // In the multi-process mode, the conversion happens on the child
    // side while we can only monitor the channel on the parent
    // side. If the content is gzipped, we have to unzip it
    // ourself. For that we use the stream converter services.  Do not
    // do that for Service workers as they are run in the child
    // process.
    if (
      !this.#fromServiceWorker &&
      channel instanceof Ci.nsIEncodedChannel &&
      channel.contentEncodings &&
      !channel.applyConversion &&
      !channel.hasContentDecompressed
    ) {
      const encodingHeader = channel.getResponseHeader("Content-Encoding");
      this.#compressionEncodings = encodingHeader
        .split(/\s*\t*,\s*\t*/)
        .map(encoding => encoding.toLowerCase())
        .filter(encoding =>
          lazy.NetworkUtils.ACCEPTED_COMPRESSION_ENCODINGS.includes(encoding)
        );

      if (this.#compressionEncodings.length && this.#decodeResponseBody) {
        const scs = Cc["@mozilla.org/streamConverters;1"].getService(
          Ci.nsIStreamConverterService
        );
        let nextListener = this;
        for (const encoding of this.#compressionEncodings) {
          // There can be multiple conversions applied
          this.#converter = scs.asyncConvertData(
            encoding,
            "uncompressed",
            nextListener,
            null
          );
          nextListener = this.#converter;
        }

        if (this.#converter) {
          this.#converter.onStartRequest(this.#request, null);
        }
      }
    }
    // Asynchronously wait for the data coming from the request.
    this.setAsyncListener(this.#sink.inputStream, this);
  }

  /**
   * Parse security state of this request and report it to the client.
   */
  async #getSecurityInfo() {
    // Many properties of the securityInfo (e.g., the server certificate or HPKP
    // status) are not available in the content process and can't be even touched safely,
    // because their C++ getters trigger assertions. This function is called in content
    // process for synthesized responses from service workers, in the parent otherwise.
    if (Services.appinfo.processType == Ci.nsIXULRuntime.PROCESS_TYPE_CONTENT) {
      return;
    }

    // Take the security information from the original nsIHTTPChannel instead of
    // the nsIRequest received in onStartRequest. If response to this request
    // was a redirect from http to https, the request object seems to contain
    // security info for the https request after redirect.
    const secinfo = this.#httpActivity.channel.securityInfo;
    const info = await lazy.NetworkHelper.parseSecurityInfo(
      secinfo,
      this.#request.loadInfo.originAttributes,
      this.#httpActivity,
      this.#decodedCertificateCache
    );
    this.#httpActivity.owner.addSecurityInfo(info);
  }

  /**
   * Fetches cache information from CacheEntry
   *
   * @private
   */
  async #getCacheInformation() {
    // TODO: This method is async and #httpActivity is nullified in the #destroy
    // method of this class. Backup httpActivity to avoid errors here.
    const httpActivity = this.#httpActivity;
    const cacheEntry = await lazy.getResponseCacheObject(this.#request);
    httpActivity.owner.addResponseCache({
      responseCache: cacheEntry,
    });
  }

  /**
   * Handle the onStopRequest by closing the sink output stream.
   *
   * For more documentation about nsIRequestObserver go to:
   * https://developer.mozilla.org/En/NsIRequestObserver
   */
  onStopRequest() {
    // Bug 1429365: onStopRequest may be called after onComplete for resources loaded
    // from bytecode cache.
    if (!this.#httpActivity) {
      return;
    }
    this.#sink.outputStream.close();
  }

  /**
   * For the nsIProgressEventSink implementation
   * Handle progress event as data is transferred.  This is used to record the
   * size on the wire, which may be compressed / encoded.
   */
  onProgress(request, progress) {
    this.#bodySize = progress;

    // Need to forward as well to keep things like Download Manager's progress
    // bar working properly.
    this.#forwardNotification(Ci.nsIProgressEventSink, "onProgress", arguments);
  }

  /**
   * For the nsIProgressEventSink implementation
   * This is used to get the status information
   */
  onStatus() {
    this.#forwardNotification(Ci.nsIProgressEventSink, "onStatus", arguments);
  }

  /**
   * Clean up the response listener once the response input stream is closed.
   * This is called from from onInputStreamReady() when the stream is closed.
   *
   * @return void
   */
  #dataComplete() {
    if (!this.#httpActivity) {
      return;
    }

    // Remove our listener from the request input stream.
    this.setAsyncListener(this.#sink.inputStream, null);

    if (this.#httpActivity.responseStatus == 304) {
      this.#getCacheInformation().then(() => {
        this.#getResponseContentComplete();
      });
    } else {
      this.#getResponseContentComplete();
    }

    // Clear the data stored locally on this instance.
    this.#receivedEncodedChunks = [];
    this.#receivedData = "";
    this.#uconv = null;
  }

  async #dataChunkAvailable() {
    if (!this.#httpActivity) {
      return;
    }

    if (this.#httpActivity.discardResponseBody) {
      this.#getResponseContent("");
      return;
    }

    let data = "";
    if (this.#receivedData.length) {
      data = this.#receivedData;
    } else if (this.#receivedEncodedChunks.length) {
      data = this.#receivedEncodedChunks;
    } else if (this.#httpActivity.responseStatus == 304) {
      data = await this.#getContentFromCache();
    }
    this.#getResponseContent(data);
  }

  /**
   * Create the response object and send it to the client.
   */
  #getResponseContent(data) {
    const response = {
      mimeType: "",
    };
    // For overridden scripts, we will not get the usual start notification
    // for the request, so we add event timings and response start here.
    // Note: These events should be added once per overridden request
    if (this.#httpActivity.isOverridden && !this.#sentStartEvents) {
      const timings = lazy.NetworkTimings.extractHarTimings(this.#httpActivity);
      this.#httpActivity.owner.addEventTimings(
        timings.total,
        timings.timings,
        timings.offsets
      );

      this.#httpActivity.owner.addResponseStart({
        channel: this.#httpActivity.channel,
        fromCache: this.#httpActivity.fromCache,
        rawHeaders: "",
      });
      this.#sentStartEvents = true;
    }

    response.bodySize = this.#bodySize;

    try {
      response.size = lazy.NetworkUtils.isRedirect(
        this.#httpActivity.channel.responseStatus
      )
        ? 0
        : this.#receivedBodySize;
    } catch (e) {
      // this.#httpActivity.channel.responseStatus is likely to throw
      // NS_ERROR_NOT_AVAILABLE if the response has not been received.
      response.size = 0;
    }

    response.headersSize = this.#httpActivity.headersSize;
    response.transferredSize = this.#bodySize + this.#httpActivity.headersSize;

    try {
      response.mimeType = this.#request.contentType;
      response.contentCharset = this.#request.contentCharset;
    } catch (ex) {
      // Ignore.
    }

    const isTextMimeType =
      response.mimeType && lazy.NetworkHelper.isTextMimeType(response.mimeType);
    if (!isTextMimeType) {
      response.encoding = "base64";
    }

    response.mimeType = lazy.NetworkHelper.addCharsetToMimeType(
      response.mimeType,
      response.contentCharset
    );

    // For encoded responses, the data is stored as an array of chunks.
    response.isContentEncoded = Array.isArray(data);
    if (response.isContentEncoded) {
      // Add compression encodings used by the response to later decode chunks.
      response.compressionEncodings = this.#compressionEncodings;
      response.encodedData = data;
      response.encodedBodySize = this.#receivedBodySize;
    } else {
      // Otherwise for decoded responses (either live or from the cache),
      // prepare the response.text field.
      let text = data || "";
      try {
        text = isTextMimeType ? text : btoa(text);
      } catch {
        // Ignore.
      }

      response.text = text;
      response.decodedBodySize = this.#receivedBodySize;
    }
    this.#httpActivity.owner.addResponseContent(response);
  }

  #getResponseContentComplete() {
    // Check any errors or blocking scenarios which happen late in the cycle
    // e.g If a host is not found (NS_ERROR_UNKNOWN_HOST) or CORS blocking.
    const { extension, blockedReason } = lazy.NetworkUtils.getBlockedReason(
      this.#httpActivity.channel,
      this.#httpActivity.fromCache
    );

    this.#httpActivity.owner.addResponseContentComplete({
      blockedReason,
      extension,
      discardResponseBody: this.#httpActivity.discardResponseBody,
      truncated: this.#truncated,
      channel: this.#httpActivity.channel,
    });

    // Make sure all the security and response content info are sent
    // unconditionally.
    this.#onSecurityInfo.finally(() => this.#destroy());
  }

  /**
   * Loads the content from the cache
   *
   * @returns Promise
   */
  #getContentFromCache() {
    return new Promise(resolve => {
      // Response is cached, so we load it from cache.
      let charset;
      try {
        charset = this.#request.contentCharset;
      } catch (e) {
        // Accessing the charset sometimes throws NS_ERROR_NOT_AVAILABLE when
        // reloading the page
      }
      if (!charset) {
        charset = this.#httpActivity.charset;
      }
      lazy.NetworkHelper.loadFromCache(
        this.#httpActivity.url,
        charset,
        resolve
      );
    });
  }

  #destroy() {
    this.#wrappedNotificationCallbacks = null;
    this.#httpActivity = null;
    this.#sink = null;
    this.#inputStream = null;
    this.#converter = null;
    this.#request = null;
    this.#uconv = null;
    this.#sentStartEvents = false;
  }

  /**
   * The nsIInputStreamCallback for when the request input stream is ready -
   * either it has more data or it is closed.
   *
   * @param nsIAsyncInputStream stream
   *        The sink input stream from which data is coming.
   * @returns void
   */
  async onInputStreamReady(stream) {
    if (!(stream instanceof Ci.nsIAsyncInputStream) || !this.#httpActivity) {
      return;
    }

    let available = -1;
    try {
      // This may throw if the stream is closed normally or due to an error.
      available = stream.available();
    } catch (ex) {
      // Ignore.
    }

    if (available != -1) {
      if (available != 0) {
        const converter = this.#converter ? this.#converter : this;
        converter.onDataAvailable(
          this.#request,
          stream,
          this.#offset,
          available
        );
      }
      await this.#dataChunkAvailable();
      this.#offset += available;
      this.setAsyncListener(stream, this);
    } else {
      // Make sure the response content event is sent at least once
      if (this.#offset == 0) {
        await this.#dataChunkAvailable();
      } else {
        this.#offset = 0;
      }
      this.#dataComplete();
    }
  }

  QueryInterface = ChromeUtils.generateQI([
    "nsIStreamListener",
    "nsIInputStreamCallback",
    "nsIRequestObserver",
    "nsIInterfaceRequestor",
  ]);
}
