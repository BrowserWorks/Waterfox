/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const DevToolsUtils = require("devtools/shared/DevToolsUtils");
const { LongStringFront } = require("devtools/client/fronts/string");
const {
  FrontClassWithSpec,
  registerFront,
} = require("devtools/shared/protocol");
const { webconsoleSpec } = require("devtools/shared/specs/webconsole");
const {
  getAdHocFrontOrPrimitiveGrip,
} = require("devtools/client/fronts/object");

/**
 * A WebConsoleFront is used as a front end for the WebConsoleActor that is
 * created on the server, hiding implementation details.
 *
 * @param object client
 *        The DevToolsClient instance we live for.
 */
class WebConsoleFront extends FrontClassWithSpec(webconsoleSpec) {
  constructor(client, targetFront, parentFront) {
    super(client, targetFront, parentFront);
    this._client = client;
    this.traits = {};
    this._longStrings = {};
    this.events = [];

    // Attribute name from which to retrieve the actorID out of the target actor's form
    this.formAttributeName = "consoleActor";
    /**
     * Holds the network requests currently displayed by the Web Console. Each key
     * represents the connection ID and the value is network request information.
     * @private
     * @type object
     */
    this._networkRequests = new Map();

    this.pendingEvaluationResults = new Map();
    this.onEvaluationResult = this.onEvaluationResult.bind(this);
    this.onNetworkEvent = this._onNetworkEvent.bind(this);
    this.onNetworkEventUpdate = this._onNetworkEventUpdate.bind(this);

    this.on("evaluationResult", this.onEvaluationResult);
    this.on("serverNetworkEvent", this.onNetworkEvent);
    this.before("consoleAPICall", this.beforeConsoleAPICall);
    this.before("pageError", this.beforePageError);

    this._client.on("networkEventUpdate", this.onNetworkEventUpdate);
  }

  getNetworkRequest(actorId) {
    return this._networkRequests.get(actorId);
  }

  getNetworkEvents() {
    return this._networkRequests.values();
  }

  get actor() {
    return this.actorID;
  }

  /**
   * The "networkEvent" message type handler. We redirect any message to
   * the UI for displaying.
   *
   * @private
   * @param string type
   *        Message type.
   * @param object packet
   *        The message received from the server.
   */
  _onNetworkEvent(packet) {
    const actor = packet.eventActor;
    const networkInfo = {
      type: "networkEvent",
      timeStamp: actor.timeStamp,
      node: null,
      actor: actor.actor,
      discardRequestBody: true,
      discardResponseBody: true,
      startedDateTime: actor.startedDateTime,
      request: {
        url: actor.url,
        method: actor.method,
      },
      isXHR: actor.isXHR,
      cause: actor.cause,
      response: {},
      timings: {},
      // track the list of network event updates
      updates: [],
      private: actor.private,
      fromCache: actor.fromCache,
      fromServiceWorker: actor.fromServiceWorker,
      isThirdPartyTrackingResource: actor.isThirdPartyTrackingResource,
      referrerPolicy: actor.referrerPolicy,
      blockedReason: actor.blockedReason,
      blockingExtension: actor.blockingExtension,
      channelId: actor.channelId,
    };
    this._networkRequests.set(actor.actor, networkInfo);

    this.emit("networkEvent", networkInfo);
  }

  /**
   * The "networkEventUpdate" message type handler. We redirect any message to
   * the UI for displaying.
   *
   * @private
   * @param string type
   *        Message type.
   * @param object packet
   *        The message received from the server.
   */
  _onNetworkEventUpdate(packet) {
    const networkInfo = this.getNetworkRequest(packet.from);
    if (!networkInfo) {
      return;
    }

    networkInfo.updates.push(packet.updateType);

    switch (packet.updateType) {
      case "requestHeaders":
        networkInfo.request.headersSize = packet.headersSize;
        break;
      case "requestPostData":
        networkInfo.discardRequestBody = packet.discardRequestBody;
        networkInfo.request.bodySize = packet.dataSize;
        break;
      case "responseStart":
        networkInfo.response.httpVersion = packet.response.httpVersion;
        networkInfo.response.status = packet.response.status;
        networkInfo.response.statusText = packet.response.statusText;
        networkInfo.response.headersSize = packet.response.headersSize;
        networkInfo.response.remoteAddress = packet.response.remoteAddress;
        networkInfo.response.remotePort = packet.response.remotePort;
        networkInfo.discardResponseBody = packet.response.discardResponseBody;
        break;
      case "responseContent":
        networkInfo.response.content = {
          mimeType: packet.mimeType,
        };
        networkInfo.response.bodySize = packet.contentSize;
        networkInfo.response.transferredSize = packet.transferredSize;
        networkInfo.discardResponseBody = packet.discardResponseBody;
        break;
      case "eventTimings":
        networkInfo.totalTime = packet.totalTime;
        break;
      case "securityInfo":
        networkInfo.securityState = packet.state;
        break;
      case "responseCache":
        networkInfo.response.responseCache = packet.responseCache;
        break;
    }

    this.emit("networkEventUpdate", {
      packet: packet,
      networkInfo,
    });
  }

  /**
   * Evaluate a JavaScript expression asynchronously.
   *
   * @param {String} string: The code you want to evaluate.
   * @param {Object} opts: Options for evaluation:
   *
   *        - {String} frameActor: a FrameActor ID. The FA holds a reference to
   *        a Debugger.Frame. This option allows you to evaluate the string in
   *        the frame of the given FA.
   *
   *        - {String} url: the url to evaluate the script as. Defaults to
   *        "debugger eval code".
   *
   *        - {String} selectedNodeActor: the NodeActor ID of the current
   *        selection in the Inspector, if such a selection
   *        exists. This is used by helper functions that can
   *        reference the currently selected node in the Inspector, like $0.
   *
   *        - {String} selectedObjectActor: the actorID of a given objectActor.
   *        This is used by context menu entries to get a reference to an object, in order
   *        to perform some operation on it (copy it, store it as a global variable, …).
   *
   *        - {Integer} innerWindowID: An optional window id to be used for the evaluation,
   *        instead of the regular webConsoleActor.evalWindow.
   *        This is used by functions that may want to evaluate in a different window (for
   *        example a non-remote iframe), like getting the elements of a given document.
   *
   * @return {Promise}: A promise that resolves with the response.
   */
  async evaluateJSAsync(string, opts = {}) {
    const options = {
      text: string,
      frameActor: opts.frameActor,
      url: opts.url,
      selectedNodeActor: opts.selectedNodeActor,
      selectedObjectActor: opts.selectedObjectActor,
      innerWindowID: opts.innerWindowID,
      mapped: opts.mapped,
      eager: opts.eager,
    };

    this._pendingAsyncEvaluation = super.evaluateJSAsync(options);
    const { resultID } = await this._pendingAsyncEvaluation;
    this._pendingAsyncEvaluation = null;

    return new Promise((resolve, reject) => {
      // Null check this in case the client has been detached while sending
      // the one way request
      if (this.pendingEvaluationResults) {
        this.pendingEvaluationResults.set(resultID, resp => {
          if (resp.error) {
            reject(resp);
          } else {
            if (resp.result) {
              resp.result = getAdHocFrontOrPrimitiveGrip(resp.result, this);
            }

            if (resp.helperResult?.object) {
              resp.helperResult.object = getAdHocFrontOrPrimitiveGrip(
                resp.helperResult.object,
                this
              );
            }

            if (resp.exception) {
              resp.exception = getAdHocFrontOrPrimitiveGrip(
                resp.exception,
                this
              );
            }

            if (resp.exceptionMessage) {
              resp.exceptionMessage = getAdHocFrontOrPrimitiveGrip(
                resp.exceptionMessage,
                this
              );
            }

            resolve(resp);
          }
        });
      }
    });
  }

  /**
   * Handler for the actors's unsolicited evaluationResult packet.
   */
  async onEvaluationResult(packet) {
    // In some cases, the evaluationResult event can be received before the initial call
    // to evaluationJSAsync completes. So make sure to wait for the corresponding promise
    // before handling the event.
    await this._pendingAsyncEvaluation;

    // Find the associated callback based on this ID, and fire it.
    // In a sync evaluation, this would have already been called in
    // direct response to the client.request function.
    const onResponse = this.pendingEvaluationResults.get(packet.resultID);
    if (onResponse) {
      onResponse(packet);
      this.pendingEvaluationResults.delete(packet.resultID);
    } else {
      DevToolsUtils.reportException(
        "onEvaluationResult",
        "No response handler for an evaluateJSAsync result (resultID: " +
          packet.resultID +
          ")"
      );
    }
  }

  beforeConsoleAPICall(packet) {
    if (packet.message && Array.isArray(packet.message.arguments)) {
      // We might need to create fronts for each of the message arguments.
      packet.message.arguments = packet.message.arguments.map(arg =>
        getAdHocFrontOrPrimitiveGrip(arg, this)
      );
    }
    return packet;
  }

  beforePageError(packet) {
    if (packet?.pageError?.errorMessage) {
      packet.pageError.errorMessage = getAdHocFrontOrPrimitiveGrip(
        packet.pageError.errorMessage,
        this
      );
    }

    if (packet?.pageError?.exception) {
      packet.pageError.exception = getAdHocFrontOrPrimitiveGrip(
        packet.pageError.exception,
        this
      );
    }
    return packet;
  }

  async getCachedMessages(messageTypes) {
    const response = await super.getCachedMessages(messageTypes);
    if (Array.isArray(response.messages)) {
      response.messages = response.messages.map(packet => {
        if (Array.isArray(packet?.message?.arguments)) {
          // We might need to create fronts for each of the message arguments.
          packet.message.arguments = packet.message.arguments.map(arg =>
            getAdHocFrontOrPrimitiveGrip(arg, this)
          );
        }

        if (packet.pageError?.exception) {
          packet.pageError.exception = getAdHocFrontOrPrimitiveGrip(
            packet.pageError.exception,
            this
          );
        }

        return packet;
      });
    }
    return response;
  }

  /**
   * Retrieve the request headers from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getRequestHeaders(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getRequestHeaders",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the request cookies from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getRequestCookies(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getRequestCookies",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the request post data from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getRequestPostData(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getRequestPostData",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the response headers from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getResponseHeaders(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getResponseHeaders",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the response cookies from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getResponseCookies(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getResponseCookies",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the response content from the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getResponseContent(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getResponseContent",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the response cache from the given NetworkEventActor
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces.
   */
  getResponseCache(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getResponseCache",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the timing information for the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getEventTimings(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getEventTimings",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the security information for the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the response is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getSecurityInfo(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getSecurityInfo",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Retrieve the stack-trace information for the given NetworkEventActor.
   *
   * @param string actor
   *        The NetworkEventActor ID.
   * @param function onResponse
   *        The function invoked when the stack-trace is received.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  getStackTrace(actor, onResponse) {
    const packet = {
      to: actor,
      type: "getStackTrace",
    };
    return this._client.request(packet, onResponse);
  }

  /**
   * Start the given Web Console listeners.
   * TODO: remove once the front is retrieved via getFront, and we use form()
   *
   * @see this.LISTENERS
   * @param array listeners
   *        Array of listeners you want to start. See this.LISTENERS for
   *        known listeners.
   * @return request
   *         Request object that implements both Promise and EventEmitter interfaces
   */
  async startListeners(listeners) {
    const response = await super.startListeners(listeners);
    this.hasNativeConsoleAPI = response.nativeConsoleAPI;
    this.traits = response.traits;
    return response;
  }

  /**
   * Return an instance of LongStringFront for the given long string grip.
   *
   * @param object grip
   *        The long string grip returned by the protocol.
   * @return {LongStringFront} the front for the given long string grip.
   */
  longString(grip) {
    if (grip.actor in this._longStrings) {
      return this._longStrings[grip.actor];
    }

    const front = new LongStringFront(this._client, this.targetFront, this);
    front.form(grip);
    this.manage(front);
    this._longStrings[grip.actor] = front;
    return front;
  }

  /**
   * Fetches the full text of a LongString.
   *
   * @param object | string stringGrip
   *        The long string grip containing the corresponding actor.
   *        If you pass in a plain string (by accident or because you're lazy),
   *        then a promise of the same string is simply returned.
   * @return object Promise
   *         A promise that is resolved when the full string contents
   *         are available, or rejected if something goes wrong.
   */
  async getString(stringGrip) {
    // Make sure this is a long string.
    if (typeof stringGrip !== "object" || stringGrip.type !== "longString") {
      // Go home string, you're drunk.
      return stringGrip;
    }

    // Fetch the long string only once.
    if (stringGrip._fullText) {
      return stringGrip._fullText;
    }

    const { initial, length } = stringGrip;
    const longStringFront = this.longString(stringGrip);

    try {
      const response = await longStringFront.substring(initial.length, length);
      return initial + response;
    } catch (e) {
      DevToolsUtils.reportException("getString", e.message);
      throw e;
    }
  }

  clearNetworkRequests() {
    // Prevent exception if the front has already been destroyed.
    if (this._networkRequests) {
      this._networkRequests.clear();
    }
  }

  /**
   * Close the WebConsoleFront.
   *
   */
  destroy() {
    if (!this._client) {
      return null;
    }

    this._client.off("networkEventUpdate", this.onNetworkEventUpdate);
    // This will make future calls to this function harmless because of the early return
    // at the top of the function.
    this._client = null;

    this.off("evaluationResult", this.onEvaluationResult);
    this.off("serverNetworkEvent", this.onNetworkEvent);
    this._longStrings = null;
    this.pendingEvaluationResults.clear();
    this.pendingEvaluationResults = null;
    this.clearNetworkRequests();
    this._networkRequests = null;
    return super.destroy();
  }
}

exports.WebConsoleFront = WebConsoleFront;
registerFront(WebConsoleFront);
