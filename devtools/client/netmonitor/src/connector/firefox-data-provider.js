/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* eslint-disable block-scoped-var */

"use strict";

const {
  EVENTS,
  TEST_EVENTS,
} = require("devtools/client/netmonitor/src/constants");
const { CurlUtils } = require("devtools/client/shared/curl");
const {
  fetchHeaders,
} = require("devtools/client/netmonitor/src/utils/request-utils");

/**
 * This object is responsible for fetching additional HTTP
 * data from the backend over RDP protocol.
 *
 * The object also keeps track of RDP requests in-progress,
 * so it's possible to determine whether all has been fetched
 * or not.
 */
class FirefoxDataProvider {
  /**
   * Constructor for data provider
   *
   * @param {Object} webConsoleFront represents the client object for Console actor.
   * @param {Object} actions set of actions fired during data fetching process
   * @params {Object} owner all events are fired on this object
   */
  constructor({ webConsoleFront, actions, owner }) {
    // Options
    this.webConsoleFront = webConsoleFront;
    this.actions = actions || {};
    this.actionsEnabled = true;
    this.owner = owner;

    // Internal properties
    this.payloadQueue = new Map();

    // Map[key string => Promise] used by `requestData` to prevent requesting the same
    // request data twice.
    this.lazyRequestData = new Map();

    // Fetching data from the backend
    this.getLongString = this.getLongString.bind(this);

    // Event handlers
    this.onNetworkEvent = this.onNetworkEvent.bind(this);
    this.onNetworkEventUpdate = this.onNetworkEventUpdate.bind(this);

    this.onWebSocketOpened = this.onWebSocketOpened.bind(this);
    this.onWebSocketClosed = this.onWebSocketClosed.bind(this);
    this.onFrameSent = this.onFrameSent.bind(this);
    this.onFrameReceived = this.onFrameReceived.bind(this);

    this.onEventSourceConnectionOpened = this.onEventSourceConnectionOpened.bind(
      this
    );
    this.onEventSourceConnectionClosed = this.onEventSourceConnectionClosed.bind(
      this
    );
    this.onEventReceived = this.onEventReceived.bind(this);
  }

  /**
   * Enable/disable firing redux actions (enabled by default).
   *
   * @param {boolean} enable Set to true to fire actions.
   */
  enableActions(enable) {
    this.actionsEnabled = enable;
  }

  /**
   * Add a new network request to application state.
   *
   * @param {string} id request id
   * @param {object} data data payload will be added to application state
   */
  async addRequest(id, data) {
    const {
      method,
      url,
      isXHR,
      cause,
      startedDateTime,
      fromCache,
      fromServiceWorker,
      isThirdPartyTrackingResource,
      referrerPolicy,
      blockedReason,
      blockingExtension,
      channelId,
    } = data;

    // Insert blocked reason in the payload queue as well, as we'll need it later
    // when deciding if the request is complete.
    this.pushRequestToQueue(id, {
      blockedReason,
    });

    if (this.actionsEnabled && this.actions.addRequest) {
      await this.actions.addRequest(
        id,
        {
          // Convert the received date/time string to a unix timestamp.
          startedMs: Date.parse(startedDateTime),
          method,
          url,
          isXHR,
          cause,

          // Compatibility code to support Firefox 58 and earlier that always
          // send stack-trace immediately on networkEvent message.
          // FF59+ supports fetching the traces lazily via requestData.
          stacktrace: cause.stacktrace,

          fromCache,
          fromServiceWorker,
          isThirdPartyTrackingResource,
          referrerPolicy,
          blockedReason,
          blockingExtension,
          channelId,
        },
        true
      );
    }

    this.emit(EVENTS.REQUEST_ADDED, id);
  }

  /**
   * Update a network request if it already exists in application state.
   *
   * @param {string} id request id
   * @param {object} data data payload will be updated to application state
   */
  async updateRequest(id, data) {
    const {
      responseContent,
      responseCookies,
      responseHeaders,
      requestCookies,
      requestHeaders,
      requestPostData,
      responseCache,
    } = data;

    // fetch request detail contents in parallel
    const [
      responseContentObj,
      requestHeadersObj,
      responseHeadersObj,
      postDataObj,
      requestCookiesObj,
      responseCookiesObj,
      responseCacheObj,
    ] = await Promise.all([
      this.fetchResponseContent(responseContent),
      this.fetchRequestHeaders(requestHeaders),
      this.fetchResponseHeaders(responseHeaders),
      this.fetchPostData(requestPostData),
      this.fetchRequestCookies(requestCookies),
      this.fetchResponseCookies(responseCookies),
      this.fetchResponseCache(responseCache),
    ]);

    const payload = Object.assign(
      {},
      data,
      responseContentObj,
      requestHeadersObj,
      responseHeadersObj,
      postDataObj,
      requestCookiesObj,
      responseCookiesObj,
      responseCacheObj
    );

    if (this.actionsEnabled && this.actions.updateRequest) {
      await this.actions.updateRequest(id, payload, true);
    }

    return payload;
  }

  async fetchResponseContent(responseContent) {
    const payload = {};
    if (responseContent?.content) {
      const { text } = responseContent.content;
      const response = await this.getLongString(text);
      responseContent.content.text = response;
      payload.responseContent = responseContent;
    }
    return payload;
  }

  async fetchRequestHeaders(requestHeaders) {
    const payload = {};
    if (requestHeaders?.headers?.length) {
      const headers = await fetchHeaders(requestHeaders, this.getLongString);
      if (headers) {
        payload.requestHeaders = headers;
      }
    }
    return payload;
  }

  async fetchResponseHeaders(responseHeaders) {
    const payload = {};
    if (responseHeaders?.headers?.length) {
      const headers = await fetchHeaders(responseHeaders, this.getLongString);
      if (headers) {
        payload.responseHeaders = headers;
      }
    }
    return payload;
  }

  async fetchPostData(requestPostData) {
    const payload = {};
    if (requestPostData?.postData) {
      const { text } = requestPostData.postData;
      const postData = await this.getLongString(text);
      const headers = CurlUtils.getHeadersFromMultipartText(postData);

      // Calculate total header size and don't forget to include
      // two new-line characters at the end.
      const headersSize = headers.reduce((acc, { name, value }) => {
        return acc + name.length + value.length + 2;
      }, 0);

      requestPostData.postData.text = postData;
      payload.requestPostData = {
        ...requestPostData,
        uploadHeaders: { headers, headersSize },
      };
    }
    return payload;
  }

  async fetchRequestCookies(requestCookies) {
    const payload = {};
    if (requestCookies) {
      const reqCookies = [];
      // request store cookies in requestCookies or requestCookies.cookies
      const cookies = requestCookies.cookies
        ? requestCookies.cookies
        : requestCookies;
      // make sure cookies is iterable
      if (typeof cookies[Symbol.iterator] === "function") {
        for (const cookie of cookies) {
          reqCookies.push(
            Object.assign({}, cookie, {
              value: await this.getLongString(cookie.value),
            })
          );
        }
        if (reqCookies.length) {
          payload.requestCookies = reqCookies;
        }
      }
    }
    return payload;
  }

  async fetchResponseCookies(responseCookies) {
    const payload = {};
    if (responseCookies) {
      const resCookies = [];
      // response store cookies in responseCookies or responseCookies.cookies
      const cookies = responseCookies.cookies
        ? responseCookies.cookies
        : responseCookies;
      // make sure cookies is iterable
      if (typeof cookies[Symbol.iterator] === "function") {
        for (const cookie of cookies) {
          resCookies.push(
            Object.assign({}, cookie, {
              value: await this.getLongString(cookie.value),
            })
          );
        }
        if (resCookies.length) {
          payload.responseCookies = resCookies;
        }
      }
    }
    return payload;
  }

  async fetchResponseCache(responseCache) {
    const payload = {};
    if (responseCache) {
      payload.responseCache = await responseCache;
      payload.responseCacheAvailable = false;
    }
    return payload;
  }

  /**
   * Public API used by the Toolbox: Tells if there is still any pending request.
   *
   * @return {boolean} returns true if the payload queue is empty
   */
  isPayloadQueueEmpty() {
    return this.payloadQueue.size === 0;
  }

  /**
   * Merge upcoming networkEventUpdate payload into existing one.
   *
   * @param {string} id request actor id
   * @param {object} payload request data payload
   */
  pushRequestToQueue(id, payload) {
    let payloadFromQueue = this.payloadQueue.get(id);
    if (!payloadFromQueue) {
      payloadFromQueue = {};
      this.payloadQueue.set(id, payloadFromQueue);
    }
    Object.assign(payloadFromQueue, payload);
  }

  /**
   * Fetches the network information packet from actor server
   *
   * @param {string} id request id
   * @return {object} networkInfo data packet
   */
  getNetworkRequest(id) {
    return this.webConsoleFront.getNetworkRequest(id);
  }

  /**
   * Fetches the full text of a LongString.
   *
   * @param {object|string} stringGrip
   *        The long string grip containing the corresponding actor.
   *        If you pass in a plain string (by accident or because you're lazy),
   *        then a promise of the same string is simply returned.
   * @return {object}
   *         A promise that is resolved when the full string contents
   *         are available, or rejected if something goes wrong.
   */
  getLongString(stringGrip) {
    return this.webConsoleFront.getString(stringGrip).then(payload => {
      this.emitForTests(TEST_EVENTS.LONGSTRING_RESOLVED, { payload });
      return payload;
    });
  }

  /**
   * The "networkEvent" message type handler.
   *
   * @param {object} networkInfo network request information
   */
  async onNetworkEvent(networkInfo) {
    const {
      actor,
      cause,
      fromCache,
      fromServiceWorker,
      isXHR,
      request: { method, url },
      startedDateTime,
      isThirdPartyTrackingResource,
      referrerPolicy,
      blockedReason,
      blockingExtension,
      channelId,
    } = networkInfo;

    await this.addRequest(actor, {
      cause,
      fromCache,
      fromServiceWorker,
      isXHR,
      method,
      startedDateTime,
      url,
      isThirdPartyTrackingResource,
      referrerPolicy,
      blockedReason,
      blockingExtension,
      channelId,
    });

    this.emitForTests(TEST_EVENTS.NETWORK_EVENT, actor);
  }

  /**
   * The "networkEventUpdate" message type handler.
   *
   * @param {object} packet the message received from the server.
   * @param {object} networkInfo the network request information.
   */
  onNetworkEventUpdate(data) {
    const { packet, networkInfo } = data;
    const { actor } = networkInfo;
    const { updateType } = packet;

    switch (updateType) {
      case "securityInfo":
        this.pushRequestToQueue(actor, {
          securityState: networkInfo.securityState,
          isRacing: packet.isRacing,
        });
        break;
      case "responseStart":
        this.pushRequestToQueue(actor, {
          httpVersion: networkInfo.response.httpVersion,
          remoteAddress: networkInfo.response.remoteAddress,
          remotePort: networkInfo.response.remotePort,
          status: networkInfo.response.status,
          statusText: networkInfo.response.statusText,
          headersSize: networkInfo.response.headersSize,
        });
        this.emitForTests(TEST_EVENTS.STARTED_RECEIVING_RESPONSE, actor);
        break;
      case "responseContent":
        this.pushRequestToQueue(actor, {
          contentSize: networkInfo.response.bodySize,
          transferredSize: networkInfo.response.transferredSize,
          mimeType: networkInfo.response.content.mimeType,
          blockingExtension: packet.blockingExtension,
          blockedReason: packet.blockedReason,
        });
        break;
      case "eventTimings":
        // Total time doesn't have to be always set e.g. net provider enhancer
        // in Console panel is using this method to fetch data when network log
        // is expanded. So, make sure to not push undefined into the payload queue
        // (it could overwrite an existing value).
        if (typeof networkInfo.totalTime !== "undefined") {
          this.pushRequestToQueue(actor, { totalTime: networkInfo.totalTime });
        }
        break;
    }

    // This available field helps knowing when/if updateType property is arrived
    // and can be requested via `requestData`
    this.pushRequestToQueue(actor, { [`${updateType}Available`]: true });

    this.onPayloadDataReceived(actor);

    this.emitForTests(TEST_EVENTS.NETWORK_EVENT_UPDATED, actor);
  }

  /**
   * The "webSocketOpened" message type handler.
   *
   * @param {number} httpChannelId the channel ID
   * @param {string} effectiveURI the effective URI of the page
   * @param {string} protocols webSocket protocols
   * @param {string} extensions
   */
  async onWebSocketOpened(httpChannelId, effectiveURI, protocols, extensions) {}

  /**
   * The "webSocketClosed" message type handler.
   *
   * @param {number} httpChannelId
   * @param {boolean} wasClean
   * @param {number} code
   * @param {string} reason
   */
  async onWebSocketClosed(httpChannelId, wasClean, code, reason) {
    if (this.actionsEnabled && this.actions.closeConnection) {
      await this.actions.closeConnection(httpChannelId, wasClean, code, reason);
    }
  }

  /**
   * The "frameSent" message type handler.
   *
   * @param {number} httpChannelId the channel ID
   * @param {object} data websocket frame information
   */
  async onFrameSent(httpChannelId, data) {
    this.addFrame(httpChannelId, data);
  }

  /**
   * The "frameReceived" message type handler.
   *
   * @param {number} httpChannelId the channel ID
   * @param {object} data websocket frame information
   */
  async onFrameReceived(httpChannelId, data) {
    this.addFrame(httpChannelId, data);
  }

  /**
   * Add a new WebSocket frame to application state.
   *
   * @param {number} httpChannelId the channel ID
   * @param {object} data websocket frame information
   */
  async addFrame(httpChannelId, data) {
    if (this.actionsEnabled && this.actions.addFrame) {
      await this.actions.addFrame(httpChannelId, data, true);
    }
    // TODO: Emit an event for test here
  }

  /**
   * Notify actions when messages from onNetworkEventUpdate are done, networkEventUpdate
   * messages contain initial network info for each updateType and then we can invoke
   * requestData to fetch its corresponded data lazily.
   * Once all updateTypes of networkEventUpdate message are arrived, we flush merged
   * request payload from pending queue and then update component.
   */
  async onPayloadDataReceived(actor) {
    const payload = this.payloadQueue.get(actor) || {};

    // For blocked requests, we should only expect the request portions and not
    // the response portions to be available.
    if (!payload.requestHeadersAvailable || !payload.requestCookiesAvailable) {
      return;
    }
    // For unblocked requests, we should wait for all major portions to be available.
    if (
      !payload.blockedReason &&
      (!payload.eventTimingsAvailable || !payload.responseContentAvailable)
    ) {
      return;
    }

    this.payloadQueue.delete(actor);

    if (this.actionsEnabled && this.actions.updateRequest) {
      await this.actions.updateRequest(actor, payload, true);
    }

    // This event is fired only once per request, once all the properties are fetched
    // from `onNetworkEventUpdate`. There should be no more RDP requests after this.
    // Note that this event might be consumed by extension so, emit it in production
    // release as well.
    this.emit(EVENTS.PAYLOAD_READY, actor);
  }

  /**
   * Public connector API to lazily request HTTP details from the backend.
   *
   * The method focus on:
   * - calling the right actor method,
   * - emitting an event to tell we start fetching some request data,
   * - call data processing method.
   *
   * @param {string} actor actor id (used as request id)
   * @param {string} method identifier of the data we want to fetch
   *
   * @return {Promise} return a promise resolved when data is received.
   */
  requestData(actor, method) {
    // Key string used in `lazyRequestData`. We use this Map to prevent requesting
    // the same data twice at the same time.
    const key = `${actor}-${method}`;
    let promise = this.lazyRequestData.get(key);
    // If a request is pending, reuse it.
    if (promise) {
      return promise;
    }
    // Fetch the data
    promise = this._requestData(actor, method).then(async payload => {
      // Remove the request from the cache, any new call to requestData will fetch the
      // data again.
      this.lazyRequestData.delete(key);

      if (this.actionsEnabled && this.actions.updateRequest) {
        await this.actions.updateRequest(
          actor,
          {
            ...payload,
            // Lockdown *Available property once we fetch data from back-end.
            // Using this as a flag to prevent fetching arrived data again.
            [`${method}Available`]: false,
          },
          true
        );
      }

      return payload;
    });

    this.lazyRequestData.set(key, promise);

    return promise;
  }

  /**
   * Internal helper used to request HTTP details from the backend.
   *
   * This is internal method that focus on:
   * - calling the right actor method,
   * - emitting an event to tell we start fetching some request data,
   * - call data processing method.
   *
   * @param {string} actor actor id (used as request id)
   * @param {string} method identifier of the data we want to fetch
   *
   * @return {Promise} return a promise resolved when data is received.
   */
  async _requestData(actor, method) {
    // Calculate real name of the client getter.
    const clientMethodName = `get${method
      .charAt(0)
      .toUpperCase()}${method.slice(1)}`;
    // The name of the callback that processes request response
    const callbackMethodName = `on${method
      .charAt(0)
      .toUpperCase()}${method.slice(1)}`;
    // And the event to fire before updating this data
    const updatingEventName = `UPDATING_${method
      .replace(/([A-Z])/g, "_$1")
      .toUpperCase()}`;

    // Emit event that tell we just start fetching some data
    this.emitForTests(EVENTS[updatingEventName], actor);

    let response = await new Promise((resolve, reject) => {
      // Do a RDP request to fetch data from the actor.
      if (typeof this.webConsoleFront[clientMethodName] === "function") {
        // Make sure we fetch the real actor data instead of cloned actor
        // e.g. CustomRequestPanel will clone a request with additional '-clone' actor id
        this.webConsoleFront[clientMethodName](
          actor.replace("-clone", ""),
          res => {
            if (res.error) {
              reject(
                new Error(
                  `Error while calling method ${clientMethodName}: ${res.message}`
                )
              );
            }
            resolve(res);
          }
        );
      } else {
        reject(
          new Error(`Error: No such client method '${clientMethodName}'!`)
        );
      }
    });

    // Restore clone actor id
    if (actor.includes("-clone")) {
      // Because response's properties are read-only, we create a new response
      response = { ...response, from: `${response.from}-clone` };
    }

    // Call data processing method.
    return this[callbackMethodName](response);
  }

  /**
   * Handles additional information received for a "requestHeaders" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onRequestHeaders(response) {
    const payload = await this.updateRequest(response.from, {
      requestHeaders: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_REQUEST_HEADERS, response.from);
    return payload.requestHeaders;
  }

  /**
   * Handles additional information received for a "responseHeaders" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onResponseHeaders(response) {
    const payload = await this.updateRequest(response.from, {
      responseHeaders: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_RESPONSE_HEADERS, response.from);
    return payload.responseHeaders;
  }

  /**
   * Handles additional information received for a "requestCookies" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onRequestCookies(response) {
    const payload = await this.updateRequest(response.from, {
      requestCookies: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_REQUEST_COOKIES, response.from);
    return payload.requestCookies;
  }

  /**
   * Handles additional information received for a "requestPostData" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onRequestPostData(response) {
    const payload = await this.updateRequest(response.from, {
      requestPostData: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_REQUEST_POST_DATA, response.from);
    return payload.requestPostData;
  }

  /**
   * Handles additional information received for a "securityInfo" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onSecurityInfo(response) {
    const payload = await this.updateRequest(response.from, {
      securityInfo: response.securityInfo,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_SECURITY_INFO, response.from);
    return payload.securityInfo;
  }

  /**
   * Handles additional information received for a "responseCookies" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onResponseCookies(response) {
    const payload = await this.updateRequest(response.from, {
      responseCookies: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_RESPONSE_COOKIES, response.from);
    return payload.responseCookies;
  }

  /**
   * Handles additional information received for a "responseCache" packet.
   * @param {object} response the message received from the server.
   */
  async onResponseCache(response) {
    const payload = await this.updateRequest(response.from, {
      responseCache: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_RESPONSE_CACHE, response.from);
    return payload.responseCache;
  }

  /**
   * Handles additional information received via "getResponseContent" request.
   *
   * @param {object} response the message received from the server.
   */
  async onResponseContent(response) {
    const payload = await this.updateRequest(response.from, {
      // We have to ensure passing mimeType as fetchResponseContent needs it from
      // updateRequest. It will convert the LongString in `response.content.text` to a
      // string.
      mimeType: response.content.mimeType,
      responseContent: response,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_RESPONSE_CONTENT, response.from);
    return payload.responseContent;
  }

  /**
   * Handles additional information received for a "eventTimings" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onEventTimings(response) {
    const payload = await this.updateRequest(response.from, {
      eventTimings: response,
    });

    // This event is utilized only in tests but, DAMP is using it too
    // and running DAMP test doesn't set the `devtools.testing` flag.
    // So, emit this event even in the production mode.
    // See also: https://bugzilla.mozilla.org/show_bug.cgi?id=1578215
    this.emit(EVENTS.RECEIVED_EVENT_TIMINGS, response.from);
    return payload.eventTimings;
  }

  /**
   * Handles information received for a "stackTrace" packet.
   *
   * @param {object} response the message received from the server.
   */
  async onStackTrace(response) {
    const payload = await this.updateRequest(response.from, {
      stacktrace: response.stacktrace,
    });
    this.emitForTests(TEST_EVENTS.RECEIVED_EVENT_STACKTRACE, response.from);
    return payload.stacktrace;
  }

  /**
   * Handle EventSource events.
   */
  async onEventSourceConnectionOpened(httpChannelId) {
    // By default, an EventSource connection doesn't immediately get its mimeType, or
    // any info which could help us identify a connection is an SSE channel.
    // We can update the request's mimeType through this event.
    if (this.actionsEnabled && this.actions.updateMimeType) {
      // TODO: Implement action updateMimeType.
      await this.actions.updateMimeType(
        httpChannelId,
        "text/event-stream",
        true
      );
    }
  }

  async onEventSourceConnectionClosed(httpChannelId) {}

  async onEventReceived(httpChannelId, data) {
    // Dispatch the same action used by websocket inspector.
    this.addFrame(httpChannelId, data);
  }

  /**
   * Fire events for the owner object.
   */
  emit(type, data) {
    if (this.owner) {
      this.owner.emit(type, data);
    }
  }

  /**
   * Fire test events for the owner object. These events are
   * emitted only when tests are running.
   */
  emitForTests(type, data) {
    if (this.owner) {
      this.owner.emitForTests(type, data);
    }
  }
}

module.exports = FirefoxDataProvider;
