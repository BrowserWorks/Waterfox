/* Copyright 2012 Mozilla Foundation
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

// NOTE: Be careful what goes in this file, as it is also used from the context
// of the addon. So using warn/error in here will break the addon.

'use strict';

(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    define('pdfjs/core/network', ['exports', 'pdfjs/shared/util',
      'pdfjs/core/worker'], factory);
  } else if (typeof exports !== 'undefined') {
    factory(exports, require('../shared/util.js'), require('./worker.js'));
  } else {
    factory((root.pdfjsCoreNetwork = {}), root.pdfjsSharedUtil,
      root.pdfjsCoreWorker);
  }
}(this, function (exports, sharedUtil, coreWorker) {
if (typeof PDFJSDev !== 'undefined' && PDFJSDev.test('FIREFOX || MOZCENTRAL')) {
  throw new Error('Module "pdfjs/core/network" shall not ' +
                  'be used with FIREFOX or MOZCENTRAL build.');
}

  var OK_RESPONSE = 200;
  var PARTIAL_CONTENT_RESPONSE = 206;

  function NetworkManager(url, args) {
    this.url = url;
    args = args || {};
    this.isHttp = /^https?:/i.test(url);
    this.httpHeaders = (this.isHttp && args.httpHeaders) || {};
    this.withCredentials = args.withCredentials || false;
    this.getXhr = args.getXhr ||
      function NetworkManager_getXhr() {
        return new XMLHttpRequest();
      };

    this.currXhrId = 0;
    this.pendingRequests = Object.create(null);
    this.loadedRequests = Object.create(null);
  }

  function getArrayBuffer(xhr) {
    var data = xhr.response;
    if (typeof data !== 'string') {
      return data;
    }
    var length = data.length;
    var array = new Uint8Array(length);
    for (var i = 0; i < length; i++) {
      array[i] = data.charCodeAt(i) & 0xFF;
    }
    return array.buffer;
  }

  var supportsMozChunked =
    typeof PDFJSDev !== 'undefined' && PDFJSDev.test('CHROME') ? false :
      (function supportsMozChunkedClosure() {
    try {
      var x = new XMLHttpRequest();
      // Firefox 37- required .open() to be called before setting responseType.
      // https://bugzilla.mozilla.org/show_bug.cgi?id=707484
      // Even though the URL is not visited, .open() could fail if the URL is
      // blocked, e.g. via the connect-src CSP directive or the NoScript addon.
      // When this error occurs, this feature detection method will mistakenly
      // report that moz-chunked-arraybuffer is not supported in Firefox 37-.
      x.open('GET', 'https://example.com');
      x.responseType = 'moz-chunked-arraybuffer';
      return x.responseType === 'moz-chunked-arraybuffer';
    } catch (e) {
      return false;
    }
  })();

  NetworkManager.prototype = {
    requestRange: function NetworkManager_requestRange(begin, end, listeners) {
      var args = {
        begin: begin,
        end: end
      };
      for (var prop in listeners) {
        args[prop] = listeners[prop];
      }
      return this.request(args);
    },

    requestFull: function NetworkManager_requestFull(listeners) {
      return this.request(listeners);
    },

    request: function NetworkManager_request(args) {
      var xhr = this.getXhr();
      var xhrId = this.currXhrId++;
      var pendingRequest = this.pendingRequests[xhrId] = {
        xhr: xhr
      };

      xhr.open('GET', this.url);
      xhr.withCredentials = this.withCredentials;
      for (var property in this.httpHeaders) {
        var value = this.httpHeaders[property];
        if (typeof value === 'undefined') {
          continue;
        }
        xhr.setRequestHeader(property, value);
      }
      if (this.isHttp && 'begin' in args && 'end' in args) {
        var rangeStr = args.begin + '-' + (args.end - 1);
        xhr.setRequestHeader('Range', 'bytes=' + rangeStr);
        pendingRequest.expectedStatus = 206;
      } else {
        pendingRequest.expectedStatus = 200;
      }

      var useMozChunkedLoading = supportsMozChunked && !!args.onProgressiveData;
      if (useMozChunkedLoading) {
        xhr.responseType = 'moz-chunked-arraybuffer';
        pendingRequest.onProgressiveData = args.onProgressiveData;
        pendingRequest.mozChunked = true;
      } else {
        xhr.responseType = 'arraybuffer';
      }

      if (args.onError) {
        xhr.onerror = function(evt) {
          args.onError(xhr.status);
        };
      }
      xhr.onreadystatechange = this.onStateChange.bind(this, xhrId);
      xhr.onprogress = this.onProgress.bind(this, xhrId);

      pendingRequest.onHeadersReceived = args.onHeadersReceived;
      pendingRequest.onDone = args.onDone;
      pendingRequest.onError = args.onError;
      pendingRequest.onProgress = args.onProgress;

      xhr.send(null);

      return xhrId;
    },

    onProgress: function NetworkManager_onProgress(xhrId, evt) {
      var pendingRequest = this.pendingRequests[xhrId];
      if (!pendingRequest) {
        // Maybe abortRequest was called...
        return;
      }

      if (pendingRequest.mozChunked) {
        var chunk = getArrayBuffer(pendingRequest.xhr);
        pendingRequest.onProgressiveData(chunk);
      }

      var onProgress = pendingRequest.onProgress;
      if (onProgress) {
        onProgress(evt);
      }
    },

    onStateChange: function NetworkManager_onStateChange(xhrId, evt) {
      var pendingRequest = this.pendingRequests[xhrId];
      if (!pendingRequest) {
        // Maybe abortRequest was called...
        return;
      }

      var xhr = pendingRequest.xhr;
      if (xhr.readyState >= 2 && pendingRequest.onHeadersReceived) {
        pendingRequest.onHeadersReceived();
        delete pendingRequest.onHeadersReceived;
      }

      if (xhr.readyState !== 4) {
        return;
      }

      if (!(xhrId in this.pendingRequests)) {
        // The XHR request might have been aborted in onHeadersReceived()
        // callback, in which case we should abort request
        return;
      }

      delete this.pendingRequests[xhrId];

      // success status == 0 can be on ftp, file and other protocols
      if (xhr.status === 0 && this.isHttp) {
        if (pendingRequest.onError) {
          pendingRequest.onError(xhr.status);
        }
        return;
      }
      var xhrStatus = xhr.status || OK_RESPONSE;

      // From http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.2:
      // "A server MAY ignore the Range header". This means it's possible to
      // get a 200 rather than a 206 response from a range request.
      var ok_response_on_range_request =
          xhrStatus === OK_RESPONSE &&
          pendingRequest.expectedStatus === PARTIAL_CONTENT_RESPONSE;

      if (!ok_response_on_range_request &&
          xhrStatus !== pendingRequest.expectedStatus) {
        if (pendingRequest.onError) {
          pendingRequest.onError(xhr.status);
        }
        return;
      }

      this.loadedRequests[xhrId] = true;

      var chunk = getArrayBuffer(xhr);
      if (xhrStatus === PARTIAL_CONTENT_RESPONSE) {
        var rangeHeader = xhr.getResponseHeader('Content-Range');
        var matches = /bytes (\d+)-(\d+)\/(\d+)/.exec(rangeHeader);
        var begin = parseInt(matches[1], 10);
        pendingRequest.onDone({
          begin: begin,
          chunk: chunk
        });
      } else if (pendingRequest.onProgressiveData) {
        pendingRequest.onDone(null);
      } else if (chunk) {
        pendingRequest.onDone({
          begin: 0,
          chunk: chunk
        });
      } else if (pendingRequest.onError) {
        pendingRequest.onError(xhr.status);
      }
    },

    hasPendingRequests: function NetworkManager_hasPendingRequests() {
      for (var xhrId in this.pendingRequests) {
        return true;
      }
      return false;
    },

    getRequestXhr: function NetworkManager_getXhr(xhrId) {
      return this.pendingRequests[xhrId].xhr;
    },

    isStreamingRequest: function NetworkManager_isStreamingRequest(xhrId) {
      return !!(this.pendingRequests[xhrId].onProgressiveData);
    },

    isPendingRequest: function NetworkManager_isPendingRequest(xhrId) {
      return xhrId in this.pendingRequests;
    },

    isLoadedRequest: function NetworkManager_isLoadedRequest(xhrId) {
      return xhrId in this.loadedRequests;
    },

    abortAllRequests: function NetworkManager_abortAllRequests() {
      for (var xhrId in this.pendingRequests) {
        this.abortRequest(xhrId | 0);
      }
    },

    abortRequest: function NetworkManager_abortRequest(xhrId) {
      var xhr = this.pendingRequests[xhrId].xhr;
      delete this.pendingRequests[xhrId];
      xhr.abort();
    }
  };

  var assert = sharedUtil.assert;
  var createPromiseCapability = sharedUtil.createPromiseCapability;
  var isInt = sharedUtil.isInt;
  var MissingPDFException = sharedUtil.MissingPDFException;
  var UnexpectedResponseException = sharedUtil.UnexpectedResponseException;

  /** @implements {IPDFStream} */
  function PDFNetworkStream(options) {
    this._options = options;
    var source = options.source;
    this._manager = new NetworkManager(source.url, {
      httpHeaders: source.httpHeaders,
      withCredentials: source.withCredentials
    });
    this._rangeChunkSize = source.rangeChunkSize;
    this._fullRequestReader = null;
    this._rangeRequestReaders = [];
  }

  PDFNetworkStream.prototype = {
    _onRangeRequestReaderClosed:
        function PDFNetworkStream_onRangeRequestReaderClosed(reader) {
      var i = this._rangeRequestReaders.indexOf(reader);
      if (i >= 0) {
        this._rangeRequestReaders.splice(i, 1);
      }
    },

    getFullReader: function PDFNetworkStream_getFullReader() {
      assert(!this._fullRequestReader);
      this._fullRequestReader =
        new PDFNetworkStreamFullRequestReader(this._manager, this._options);
      return this._fullRequestReader;
    },

    getRangeReader: function PDFNetworkStream_getRangeReader(begin, end) {
      var reader = new PDFNetworkStreamRangeRequestReader(this._manager,
                                                          begin, end);
      reader.onClosed = this._onRangeRequestReaderClosed.bind(this);
      this._rangeRequestReaders.push(reader);
      return reader;
    },

    cancelAllRequests: function PDFNetworkStream_cancelAllRequests(reason) {
      if (this._fullRequestReader) {
        this._fullRequestReader.cancel(reason);
      }
      var readers = this._rangeRequestReaders.slice(0);
      readers.forEach(function (reader) {
        reader.cancel(reason);
      });
    }
  };

  /** @implements {IPDFStreamReader} */
  function PDFNetworkStreamFullRequestReader(manager, options) {
    this._manager = manager;

    var source = options.source;
    var args = {
      onHeadersReceived: this._onHeadersReceived.bind(this),
      onProgressiveData: source.disableStream ? null :
                         this._onProgressiveData.bind(this),
      onDone: this._onDone.bind(this),
      onError: this._onError.bind(this),
      onProgress: this._onProgress.bind(this)
    };
    this._url = source.url;
    this._fullRequestId = manager.requestFull(args);
    this._headersReceivedCapability = createPromiseCapability();
    this._disableRange = options.disableRange || false;
    this._contentLength = source.length; // optional
    this._rangeChunkSize = source.rangeChunkSize;
    if (!this._rangeChunkSize && !this._disableRange) {
      this._disableRange = true;
    }

    this._isStreamingSupported = false;
    this._isRangeSupported = false;

    this._cachedChunks = [];
    this._requests = [];
    this._done = false;
    this._storedError = undefined;

    this.onProgress = null;
  }

  PDFNetworkStreamFullRequestReader.prototype = {
    _validateRangeRequestCapabilities: function
        PDFNetworkStreamFullRequestReader_validateRangeRequestCapabilities() {

      if (this._disableRange) {
        return false;
      }

      var networkManager = this._manager;
      var fullRequestXhrId = this._fullRequestId;
      var fullRequestXhr = networkManager.getRequestXhr(fullRequestXhrId);
      if (fullRequestXhr.getResponseHeader('Accept-Ranges') !== 'bytes') {
        return false;
      }

      var contentEncoding =
        fullRequestXhr.getResponseHeader('Content-Encoding') || 'identity';
      if (contentEncoding !== 'identity') {
        return false;
      }

      var length = fullRequestXhr.getResponseHeader('Content-Length');
      length = parseInt(length, 10);
      if (!isInt(length)) {
        return false;
      }

      this._contentLength = length; // setting right content length

      if (length <= 2 * this._rangeChunkSize) {
        // The file size is smaller than the size of two chunks, so it does
        // not make any sense to abort the request and retry with a range
        // request.
        return false;
      }

      return true;
    },

    _onHeadersReceived:
        function PDFNetworkStreamFullRequestReader_onHeadersReceived() {

      if (this._validateRangeRequestCapabilities()) {
        this._isRangeSupported = true;
      }

      var networkManager = this._manager;
      var fullRequestXhrId = this._fullRequestId;
      if (networkManager.isStreamingRequest(fullRequestXhrId)) {
        // We can continue fetching when progressive loading is enabled,
        // and we don't need the autoFetch feature.
        this._isStreamingSupported = true;
      } else if (this._isRangeSupported) {
        // NOTE: by cancelling the full request, and then issuing range
        // requests, there will be an issue for sites where you can only
        // request the pdf once. However, if this is the case, then the
        // server should not be returning that it can support range
        // requests.
        networkManager.abortRequest(fullRequestXhrId);
      }

      this._headersReceivedCapability.resolve();
    },

    _onProgressiveData:
        function PDFNetworkStreamFullRequestReader_onProgressiveData(chunk) {
      if (this._requests.length > 0) {
        var requestCapability = this._requests.shift();
        requestCapability.resolve({value: chunk, done: false});
      } else {
        this._cachedChunks.push(chunk);
      }
    },

    _onDone: function PDFNetworkStreamFullRequestReader_onDone(args) {
      if (args) {
        this._onProgressiveData(args.chunk);
      }
      this._done = true;
      if (this._cachedChunks.length > 0) {
        return;
      }
      this._requests.forEach(function (requestCapability) {
        requestCapability.resolve({value: undefined, done: true});
      });
      this._requests = [];
    },

    _onError: function PDFNetworkStreamFullRequestReader_onError(status) {
      var url = this._url;
      var exception;
      if (status === 404 || status === 0 && /^file:/.test(url)) {
        exception = new MissingPDFException('Missing PDF "' + url + '".');
      } else {
        exception = new UnexpectedResponseException(
          'Unexpected server response (' + status +
          ') while retrieving PDF "' + url + '".', status);
      }
      this._storedError = exception;
      this._headersReceivedCapability.reject(exception);
      this._requests.forEach(function (requestCapability) {
        requestCapability.reject(exception);
      });
      this._requests = [];
      this._cachedChunks = [];
    },

    _onProgress: function PDFNetworkStreamFullRequestReader_onProgress(data) {
      if (this.onProgress) {
        this.onProgress({
          loaded: data.loaded,
          total: data.lengthComputable ? data.total : this._contentLength
        });
      }
    },

    get isRangeSupported() {
      return this._isRangeSupported;
    },

    get isStreamingSupported() {
      return this._isStreamingSupported;
    },

    get contentLength() {
      return this._contentLength;
    },

    get headersReady() {
      return this._headersReceivedCapability.promise;
    },

    read: function PDFNetworkStreamFullRequestReader_read() {
      if (this._storedError) {
        return Promise.reject(this._storedError);
      }
      if (this._cachedChunks.length > 0) {
        var chunk = this._cachedChunks.shift();
        return Promise.resolve(chunk);
      }
      if (this._done) {
        return Promise.resolve({value: undefined, done: true});
      }
      var requestCapability = createPromiseCapability();
      this._requests.push(requestCapability);
      return requestCapability.promise;
    },

    cancel: function PDFNetworkStreamFullRequestReader_cancel(reason) {
      this._done = true;
      this._headersReceivedCapability.reject(reason);
      this._requests.forEach(function (requestCapability) {
        requestCapability.resolve({value: undefined, done: true});
      });
      this._requests = [];
      if (this._manager.isPendingRequest(this._fullRequestId)) {
        this._manager.abortRequest(this._fullRequestId);
      }
      this._fullRequestReader = null;
    }
  };

  /** @implements {IPDFStreamRangeReader} */
  function PDFNetworkStreamRangeRequestReader(manager, begin, end) {
    this._manager = manager;
    var args = {
      onDone: this._onDone.bind(this),
      onProgress: this._onProgress.bind(this)
    };
    this._requestId = manager.requestRange(begin, end, args);
    this._requests = [];
    this._queuedChunk = null;
    this._done = false;

    this.onProgress = null;
    this.onClosed = null;
  }

  PDFNetworkStreamRangeRequestReader.prototype = {
    _close: function PDFNetworkStreamRangeRequestReader_close() {
      if (this.onClosed) {
        this.onClosed(this);
      }
    },

    _onDone: function PDFNetworkStreamRangeRequestReader_onDone(data) {
      var chunk = data.chunk;
      if (this._requests.length > 0) {
        var requestCapability = this._requests.shift();
        requestCapability.resolve({value: chunk, done: false});
      } else {
        this._queuedChunk = chunk;
      }
      this._done = true;
      this._requests.forEach(function (requestCapability) {
        requestCapability.resolve({value: undefined, done: true});
      });
      this._requests = [];
      this._close();
    },

    _onProgress: function PDFNetworkStreamRangeRequestReader_onProgress(evt) {
      if (!this.isStreamingSupported && this.onProgress) {
        this.onProgress({
          loaded: evt.loaded
        });
      }
    },

    get isStreamingSupported() {
      return false; // TODO allow progressive range bytes loading
    },

    read: function PDFNetworkStreamRangeRequestReader_read() {
      if (this._queuedChunk !== null) {
        var chunk = this._queuedChunk;
        this._queuedChunk = null;
        return Promise.resolve({value: chunk, done: false});
      }
      if (this._done) {
        return Promise.resolve({value: undefined, done: true});
      }
      var requestCapability = createPromiseCapability();
      this._requests.push(requestCapability);
      return requestCapability.promise;
    },

    cancel: function PDFNetworkStreamRangeRequestReader_cancel(reason) {
      this._done = true;
      this._requests.forEach(function (requestCapability) {
        requestCapability.resolve({value: undefined, done: true});
      });
      this._requests = [];
      if (this._manager.isPendingRequest(this._requestId)) {
        this._manager.abortRequest(this._requestId);
      }
      this._close();
    }
  };

  coreWorker.setPDFNetworkStreamClass(PDFNetworkStream);

  exports.PDFNetworkStream = PDFNetworkStream;
  exports.NetworkManager = NetworkManager;
}));

