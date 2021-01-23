/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* eslint-env mozilla/frame-script */
/* global XPCNativeWrapper */
/* eslint-disable no-restricted-globals */

"use strict";

const winUtil = content.windowUtils;

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

const { accessibility } = ChromeUtils.import(
  "chrome://marionette/content/accessibility.js"
);
const { action } = ChromeUtils.import("chrome://marionette/content/action.js");
const { atom } = ChromeUtils.import("chrome://marionette/content/atom.js");
const { Capabilities, PageLoadStrategy } = ChromeUtils.import(
  "chrome://marionette/content/capabilities.js"
);
const { element, WebElement } = ChromeUtils.import(
  "chrome://marionette/content/element.js"
);
const {
  ElementNotInteractableError,
  InsecureCertificateError,
  InvalidArgumentError,
  InvalidSelectorError,
  NoSuchElementError,
  NoSuchFrameError,
  TimeoutError,
  UnknownError,
} = ChromeUtils.import("chrome://marionette/content/error.js");
const { Sandboxes, evaluate, sandbox } = ChromeUtils.import(
  "chrome://marionette/content/evaluate.js"
);
const { event } = ChromeUtils.import("chrome://marionette/content/event.js");
const { ContentEventObserverService } = ChromeUtils.import(
  "chrome://marionette/content/dom.js"
);
const { pprint, truncate } = ChromeUtils.import(
  "chrome://marionette/content/format.js"
);
const { interaction } = ChromeUtils.import(
  "chrome://marionette/content/interaction.js"
);
const { legacyaction } = ChromeUtils.import(
  "chrome://marionette/content/legacyaction.js"
);
const { Log } = ChromeUtils.import("chrome://marionette/content/log.js");
const { navigate } = ChromeUtils.import(
  "chrome://marionette/content/navigate.js"
);
const { proxy } = ChromeUtils.import("chrome://marionette/content/proxy.js");

XPCOMUtils.defineLazyGetter(this, "logger", () =>
  Log.getWithPrefix(outerWindowID)
);
XPCOMUtils.defineLazyGlobalGetters(this, ["URL"]);

let { outerWindowID } = winUtil;
let curContainer = { frame: content, shadowRoot: null };

// Listen for click event to indicate one click has happened, so actions
// code can send dblclick event
addEventListener("click", event.DoubleClickTracker.setClick);
addEventListener("dblclick", event.DoubleClickTracker.resetClick);
addEventListener("unload", event.DoubleClickTracker.resetClick, true);

const seenEls = new element.Store();
const SUPPORTED_STRATEGIES = new Set([
  element.Strategy.ClassName,
  element.Strategy.Selector,
  element.Strategy.ID,
  element.Strategy.Name,
  element.Strategy.LinkText,
  element.Strategy.PartialLinkText,
  element.Strategy.TagName,
  element.Strategy.XPath,
]);

Object.defineProperty(this, "capabilities", {
  get() {
    let payload = sendSyncMessage("Marionette:WebDriver:GetCapabilities");
    return Capabilities.fromJSON(payload[0]);
  },
  configurable: true,
});

let legacyactions = new legacyaction.Chain();

// last touch for each fingerId
let multiLast = {};

// sandbox storage and name of the current sandbox
const sandboxes = new Sandboxes(() => curContainer.frame);

const eventObservers = new ContentEventObserverService(
  content,
  sendAsyncMessage.bind(this)
);

/**
 * The load listener singleton helps to keep track of active page load
 * activities, and can be used by any command which might cause a navigation
 * to happen. In the specific case of a process change of the frame script it
 * allows to continue observing the current page load.
 */
const loadListener = {
  commandID: null,
  seenBeforeUnload: false,
  seenUnload: false,
  timeout: null,
  timerPageLoad: null,
  timerPageUnload: null,

  /**
   * Start listening for page unload/load events.
   *
   * @param {number} commandID
   *     ID of the currently handled message between the driver and
   *     listener.
   * @param {number} timeout
   *     Timeout in seconds the method has to wait for the page being
   *     finished loading.
   * @param {number} startTime
   *     Unix timestap when the navitation request got triggered.
   * @param {boolean=} waitForUnloaded
   *     If true wait for page unload events, otherwise only for page
   *     load events.
   */
  start(commandID, timeout, startTime, waitForUnloaded = true) {
    this.commandID = commandID;
    this.timeout = timeout;

    this.seenBeforeUnload = false;
    this.seenUnload = false;

    this.timerPageLoad = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    this.timerPageUnload = null;

    // In case the frame script has been moved to a differnt process,
    // wait the remaining time
    timeout = startTime + timeout - new Date().getTime();

    if (timeout <= 0) {
      this.notify(this.timerPageLoad);
      return;
    }

    if (waitForUnloaded) {
      addEventListener("beforeunload", this, true);
      addEventListener("hashchange", this, true);
      addEventListener("pagehide", this, true);
      addEventListener("popstate", this, true);
      addEventListener("unload", this, true);

      Services.obs.addObserver(this, "outer-window-destroyed");
    } else {
      // The frame script has been moved to a differnt content process.
      // Due to the time it takes to re-register the browser in Marionette,
      // it can happen that page load events are missed before the listeners
      // are getting attached again. By checking the document readyState the
      // command can return immediately if the page load is already done.
      let readyState = content.document.readyState;
      let documentURI = content.document.documentURI;
      logger.trace(truncate`Check readyState ${readyState} for ${documentURI}`);
      // If the page load has already finished, don't setup listeners and
      // timers but return immediatelly.
      if (this.handleReadyState(readyState, documentURI)) {
        return;
      }

      addEventListener("DOMContentLoaded", loadListener, true);
      addEventListener("pageshow", loadListener, true);
    }

    this.timerPageLoad.initWithCallback(
      this,
      timeout,
      Ci.nsITimer.TYPE_ONE_SHOT
    );
  },

  /**
   * Stop listening for page unload/load events.
   */
  stop() {
    if (this.timerPageLoad) {
      this.timerPageLoad.cancel();
    }

    if (this.timerPageUnload) {
      this.timerPageUnload.cancel();
    }

    removeEventListener("beforeunload", this, true);
    removeEventListener("hashchange", this, true);
    removeEventListener("pagehide", this, true);
    removeEventListener("popstate", this, true);
    removeEventListener("DOMContentLoaded", this, true);
    removeEventListener("pageshow", this, true);
    removeEventListener("unload", this, true);

    // In case the observer was added before the frame script has been moved
    // to a different process, it will no longer be available. Exceptions can
    // be ignored.
    try {
      Services.obs.removeObserver(this, "outer-window-destroyed");
    } catch (e) {}
  },

  /**
   * Callback for registered DOM events.
   */
  handleEvent(event) {
    // Only care about events from the currently selected browsing context,
    // whereby some of those do not bubble up to the window.
    if (
      event.target != curContainer.frame &&
      event.target != curContainer.frame.document
    ) {
      return;
    }

    let location = event.target.documentURI || event.target.location.href;
    logger.trace(truncate`Received DOM event ${event.type} for ${location}`);

    switch (event.type) {
      case "beforeunload":
        this.seenBeforeUnload = true;
        break;

      case "unload":
        this.seenUnload = true;
        break;

      case "pagehide":
        this.seenUnload = true;

        removeEventListener("hashchange", this, true);
        removeEventListener("pagehide", this, true);
        removeEventListener("popstate", this, true);

        // Now wait until the target page has been loaded
        addEventListener("DOMContentLoaded", this, true);
        addEventListener("pageshow", this, true);
        break;

      case "hashchange":
      case "popstate":
        this.stop();
        sendOk(this.commandID);
        break;

      case "DOMContentLoaded":
      case "pageshow":
        this.handleReadyState(
          event.target.readyState,
          event.target.documentURI
        );
        break;
    }
  },

  /**
   * Checks the value of readyState for the current page
   * load activity, and resolves the command if the load
   * has been finished. It also takes care of the selected
   * page load strategy.
   *
   * @param {string} readyState
   *     Current ready state of the document.
   * @param {string} documentURI
   *     Current document URI of the document.
   *
   * @return {boolean}
   *     True if the page load has been finished.
   */
  handleReadyState(readyState, documentURI) {
    let finished = false;

    switch (readyState) {
      case "interactive":
        if (documentURI.startsWith("about:certerror")) {
          this.stop();
          sendError(new InsecureCertificateError(), this.commandID);
          finished = true;
        } else if (/about:.*(error)\?/.exec(documentURI)) {
          this.stop();
          sendError(
            new UnknownError(`Reached error page: ${documentURI}`),
            this.commandID
          );
          finished = true;

          // Return early with a page load strategy of eager, and also
          // special-case about:blocked pages which should be treated as
          // non-error pages but do not raise a pageshow event. about:blank
          // is also treaded specifically here, because it gets temporary
          // loaded for new content processes, and we only want to rely on
          // complete loads for it.
        } else if (
          (capabilities.get("pageLoadStrategy") === PageLoadStrategy.Eager &&
            documentURI != "about:blank") ||
          /about:blocked\?/.exec(documentURI)
        ) {
          this.stop();
          sendOk(this.commandID);
          finished = true;
        }

        break;

      case "complete":
        this.stop();
        sendOk(this.commandID);
        finished = true;

        break;
    }

    return finished;
  },

  /**
   * Callback for navigation timeout timer.
   */
  notify(timer) {
    switch (timer) {
      case this.timerPageUnload:
        // In the case when a document has a beforeunload handler
        // registered, the currently active command will return immediately
        // due to the modal dialog observer in proxy.js.
        //
        // Otherwise the timeout waiting for the document to start
        // navigating is increased by 5000 ms to ensure a possible load
        // event is not missed. In the common case such an event should
        // occur pretty soon after beforeunload, and we optimise for this.
        if (this.seenBeforeUnload) {
          this.seenBeforeUnload = null;
          this.timerPageUnload.initWithCallback(
            this,
            5000,
            Ci.nsITimer.TYPE_ONE_SHOT
          );

          // If no page unload has been detected, ensure to properly stop
          // the load listener, and return from the currently active command.
        } else if (!this.seenUnload) {
          logger.debug(
            "Canceled page load listener because no navigation " +
              "has been detected"
          );
          this.stop();
          sendOk(this.commandID);
        }
        break;

      case this.timerPageLoad:
        this.stop();
        sendError(
          new TimeoutError(`Timeout loading page after ${this.timeout}ms`),
          this.commandID
        );
        break;
    }
  },

  observe(subject, topic) {
    const win = curContainer.frame;
    const winID = subject.QueryInterface(Ci.nsISupportsPRUint64).data;
    const curWinID = win.windowUtils.outerWindowID;

    logger.trace(`Received observer notification ${topic}`);

    switch (topic) {
      // In the case when the currently selected frame is closed,
      // there will be no further load events. Stop listening immediately.
      case "outer-window-destroyed":
        if (curWinID === winID) {
          this.stop();
          sendOk(this.commandID);
        }
        break;
    }
  },

  /**
   * Continue to listen for page load events after the frame script has been
   * moved to a different content process.
   *
   * @param {number} commandID
   *     ID of the currently handled message between the driver and
   *     listener.
   * @param {number} timeout
   *     Timeout in milliseconds the method has to wait for the page
   *     being finished loading.
   * @param {number} startTime
   *     Unix timestap when the navitation request got triggered.
   */
  waitForLoadAfterFramescriptReload(commandID, timeout, startTime) {
    this.start(commandID, timeout, startTime, false);
  },

  /**
   * Use a trigger callback to initiate a page load, and attach listeners if
   * a page load is expected.
   *
   * @param {function} trigger
   *     Callback that triggers the page load.
   * @param {number} commandID
   *     ID of the currently handled message between the driver and listener.
   * @param {number} pageTimeout
   *     Timeout in milliseconds the method has to wait for the page
   *    finished loading.
   * @param {boolean=} loadEventExpected
   *     Optional flag, which indicates that navigate has to wait for the page
   *     finished loading.
   * @param {string=} url
   *     Optional URL, which is used to check if a page load is expected.
   */
  navigate(
    trigger,
    commandID,
    timeout,
    loadEventExpected = true,
    useUnloadTimer = false
  ) {
    // Only wait if the page load strategy is not `none`
    loadEventExpected =
      loadEventExpected &&
      capabilities.get("pageLoadStrategy") !== PageLoadStrategy.None;

    if (loadEventExpected) {
      let startTime = new Date().getTime();
      this.start(commandID, timeout, startTime, true);
    }

    return (async () => {
      await trigger();
    })()
      .then(() => {
        if (!loadEventExpected) {
          sendOk(commandID);
          return;
        }

        // If requested setup a timer to detect a possible page load
        if (useUnloadTimer) {
          this.timerPageUnload = Cc["@mozilla.org/timer;1"].createInstance(
            Ci.nsITimer
          );
          this.timerPageUnload.initWithCallback(
            this,
            200,
            Ci.nsITimer.TYPE_ONE_SHOT
          );
        }
      })
      .catch(err => {
        if (loadEventExpected) {
          this.stop();
        }

        sendError(err, commandID);
      });
  },
};

/**
 * Called when listener is first started up.  The listener sends its
 * unique window ID and its current URI to the actor.  If the actor returns
 * an ID, we start the listeners. Otherwise, nothing happens.
 */
function registerSelf() {
  logger.trace("Frame script loaded");

  sandboxes.clear();
  curContainer = {
    frame: content,
    shadowRoot: null,
  };
  legacyactions.mouseEventsOnly = false;
  action.inputStateMap = new Map();
  action.inputsToCancel = [];

  let reply = sendSyncMessage("Marionette:Register", { outerWindowID });
  if (reply.length == 0) {
    logger.error("No reply from Marionette:Register");
    return;
  }

  if (reply[0].outerWindowID === outerWindowID) {
    logger.trace("Frame script registered");
    startListeners();
    sendAsyncMessage("Marionette:ListenersAttached", { outerWindowID });
  }
}

// Eventually we will not have a closure for every single command,
// but use a generic dispatch for all listener commands.
//
// Worth nothing that this shares many characteristics with
// server.TCPConnection#execute.  Perhaps this could be generalised
// at the point.
function dispatch(fn) {
  if (typeof fn != "function") {
    throw new TypeError("Provided dispatch handler is not a function");
  }

  return msg => {
    const id = msg.json.commandID;

    let req = new Promise(resolve => {
      const args = evaluate.fromJSON(msg.json, seenEls, curContainer.frame);

      let rv;
      if (typeof args == "undefined" || args instanceof Array) {
        rv = fn.apply(null, args);
      } else {
        rv = fn(args);
      }
      resolve(rv);
    });

    req
      .then(
        rv => sendResponse(rv, id),
        err => sendError(err, id)
      )
      .catch(err => sendError(err, id));
  };
}

let getActiveElementFn = dispatch(getActiveElement);
let getBrowsingContextIdFn = dispatch(getBrowsingContextId);
let getElementAttributeFn = dispatch(getElementAttribute);
let getElementPropertyFn = dispatch(getElementProperty);
let getElementTextFn = dispatch(getElementText);
let getElementTagNameFn = dispatch(getElementTagName);
let getElementRectFn = dispatch(getElementRect);
let getPageSourceFn = dispatch(getPageSource);
let getScreenshotRectFn = dispatch(getScreenshotRect);
let isElementEnabledFn = dispatch(isElementEnabled);
let findElementContentFn = dispatch(findElementContent);
let findElementsContentFn = dispatch(findElementsContent);
let isElementSelectedFn = dispatch(isElementSelected);
let clearElementFn = dispatch(clearElement);
let isElementDisplayedFn = dispatch(isElementDisplayed);
let getElementValueOfCssPropertyFn = dispatch(getElementValueOfCssProperty);
let switchToShadowRootFn = dispatch(switchToShadowRoot);
let singleTapFn = dispatch(singleTap);
let performActionsFn = dispatch(performActions);
let releaseActionsFn = dispatch(releaseActions);
let actionChainFn = dispatch(actionChain);
let multiActionFn = dispatch(multiAction);
let executeFn = dispatch(execute);
let executeInSandboxFn = dispatch(executeInSandbox);
let sendKeysToElementFn = dispatch(sendKeysToElement);
let reftestWaitFn = dispatch(reftestWait);

function startListeners() {
  addMessageListener("Marionette:actionChain", actionChainFn);
  addMessageListener("Marionette:cancelRequest", cancelRequest);
  addMessageListener("Marionette:clearElement", clearElementFn);
  addMessageListener("Marionette:clickElement", clickElement);
  addMessageListener("Marionette:Deregister", deregister);
  addMessageListener("Marionette:DOM:AddEventListener", domAddEventListener);
  addMessageListener(
    "Marionette:DOM:RemoveEventListener",
    domRemoveEventListener
  );
  addMessageListener("Marionette:execute", executeFn);
  addMessageListener("Marionette:executeInSandbox", executeInSandboxFn);
  addMessageListener("Marionette:findElementContent", findElementContentFn);
  addMessageListener("Marionette:findElementsContent", findElementsContentFn);
  addMessageListener("Marionette:getActiveElement", getActiveElementFn);
  addMessageListener("Marionette:getBrowsingContextId", getBrowsingContextIdFn);
  addMessageListener("Marionette:getElementAttribute", getElementAttributeFn);
  addMessageListener("Marionette:getElementProperty", getElementPropertyFn);
  addMessageListener("Marionette:getElementRect", getElementRectFn);
  addMessageListener("Marionette:getElementTagName", getElementTagNameFn);
  addMessageListener("Marionette:getElementText", getElementTextFn);
  addMessageListener(
    "Marionette:getElementValueOfCssProperty",
    getElementValueOfCssPropertyFn
  );
  addMessageListener("Marionette:get", get);
  addMessageListener("Marionette:getPageSource", getPageSourceFn);
  addMessageListener("Marionette:getScreenshotRect", getScreenshotRectFn);
  addMessageListener("Marionette:goBack", goBack);
  addMessageListener("Marionette:goForward", goForward);
  addMessageListener("Marionette:isElementDisplayed", isElementDisplayedFn);
  addMessageListener("Marionette:isElementEnabled", isElementEnabledFn);
  addMessageListener("Marionette:isElementSelected", isElementSelectedFn);
  addMessageListener("Marionette:multiAction", multiActionFn);
  addMessageListener("Marionette:performActions", performActionsFn);
  addMessageListener("Marionette:refresh", refresh);
  addMessageListener("Marionette:reftestWait", reftestWaitFn);
  addMessageListener("Marionette:releaseActions", releaseActionsFn);
  addMessageListener("Marionette:sendKeysToElement", sendKeysToElementFn);
  addMessageListener("Marionette:Session:Delete", deleteSession);
  addMessageListener("Marionette:singleTap", singleTapFn);
  addMessageListener("Marionette:switchToFrame", switchToFrame);
  addMessageListener("Marionette:switchToParentFrame", switchToParentFrame);
  addMessageListener("Marionette:switchToShadowRoot", switchToShadowRootFn);
  addMessageListener("Marionette:waitForPageLoaded", waitForPageLoaded);
}

function deregister() {
  removeMessageListener("Marionette:actionChain", actionChainFn);
  removeMessageListener("Marionette:cancelRequest", cancelRequest);
  removeMessageListener("Marionette:clearElement", clearElementFn);
  removeMessageListener("Marionette:clickElement", clickElement);
  removeMessageListener("Marionette:Deregister", deregister);
  removeMessageListener("Marionette:execute", executeFn);
  removeMessageListener("Marionette:executeInSandbox", executeInSandboxFn);
  removeMessageListener("Marionette:findElementContent", findElementContentFn);
  removeMessageListener(
    "Marionette:findElementsContent",
    findElementsContentFn
  );
  removeMessageListener("Marionette:getActiveElement", getActiveElementFn);
  removeMessageListener(
    "Marionette:getBrowsingContextId",
    getBrowsingContextIdFn
  );
  removeMessageListener(
    "Marionette:getElementAttribute",
    getElementAttributeFn
  );
  removeMessageListener("Marionette:getElementProperty", getElementPropertyFn);
  removeMessageListener("Marionette:getElementRect", getElementRectFn);
  removeMessageListener("Marionette:getElementTagName", getElementTagNameFn);
  removeMessageListener("Marionette:getElementText", getElementTextFn);
  removeMessageListener(
    "Marionette:getElementValueOfCssProperty",
    getElementValueOfCssPropertyFn
  );
  removeMessageListener("Marionette:get", get);
  removeMessageListener("Marionette:getPageSource", getPageSourceFn);
  removeMessageListener("Marionette:getScreenshotRect", getScreenshotRectFn);
  removeMessageListener("Marionette:goBack", goBack);
  removeMessageListener("Marionette:goForward", goForward);
  removeMessageListener("Marionette:isElementDisplayed", isElementDisplayedFn);
  removeMessageListener("Marionette:isElementEnabled", isElementEnabledFn);
  removeMessageListener("Marionette:isElementSelected", isElementSelectedFn);
  removeMessageListener("Marionette:multiAction", multiActionFn);
  removeMessageListener("Marionette:performActions", performActionsFn);
  removeMessageListener("Marionette:refresh", refresh);
  removeMessageListener("Marionette:releaseActions", releaseActionsFn);
  removeMessageListener("Marionette:sendKeysToElement", sendKeysToElementFn);
  removeMessageListener("Marionette:Session:Delete", deleteSession);
  removeMessageListener("Marionette:singleTap", singleTapFn);
  removeMessageListener("Marionette:switchToFrame", switchToFrame);
  removeMessageListener("Marionette:switchToParentFrame", switchToParentFrame);
  removeMessageListener("Marionette:switchToShadowRoot", switchToShadowRootFn);
  removeMessageListener("Marionette:waitForPageLoaded", waitForPageLoaded);
}

function deleteSession() {
  seenEls.clear();
  // reset container frame to the top-most frame
  curContainer = { frame: content, shadowRoot: null };
  curContainer.frame.focus();
  legacyactions.touchIds = {};
  if (action.inputStateMap !== undefined) {
    action.inputStateMap.clear();
  }
  if (action.inputsToCancel !== undefined) {
    action.inputsToCancel.length = 0;
  }
}

/**
 * Send asynchronous reply to chrome.
 *
 * @param {UUID} uuid
 *     Unique identifier of the request.
 * @param {AsyncContentSender.ResponseType} type
 *     Type of response.
 * @param {*} [Object] data
 *     JSON serialisable object to accompany the message.  Defaults to
 *     an empty dictionary.
 */
let sendToServer = (uuid, data = undefined) => {
  let channel = new proxy.AsyncMessageChannel(sendAsyncMessage.bind(this));
  channel.reply(uuid, data);
};

/**
 * Send asynchronous reply with value to chrome.
 *
 * @param {Object} obj
 *     JSON serialisable object of arbitrary type and complexity.
 * @param {UUID} uuid
 *     Unique identifier of the request.
 */
function sendResponse(obj, uuid) {
  let payload = evaluate.toJSON(obj, seenEls);
  sendToServer(uuid, payload);
}

/**
 * Send asynchronous reply to chrome.
 *
 * @param {UUID} uuid
 *     Unique identifier of the request.
 */
function sendOk(uuid) {
  sendToServer(uuid);
}

/**
 * Send asynchronous error reply to chrome.
 *
 * @param {Error} err
 *     Error to notify chrome of.
 * @param {UUID} uuid
 *     Unique identifier of the request.
 */
function sendError(err, uuid) {
  sendToServer(uuid, err);
}

async function execute(script, args, opts) {
  let sb = sandbox.createMutable(curContainer.frame);
  return evaluate.sandbox(sb, script, args, opts);
}

async function executeInSandbox(script, args, opts) {
  let sb = sandboxes.get(opts.sandboxName, opts.newSandbox);
  return evaluate.sandbox(sb, script, args, opts);
}

function emitTouchEvent(type, touch) {
  logger.info(
    `Emitting Touch event of type ${type} ` +
      `to element with id: ${touch.target.id} ` +
      `and tag name: ${touch.target.tagName} ` +
      `at coordinates (${touch.clientX}), ` +
      `${touch.clientY}) relative to the viewport`
  );

  const win = curContainer.frame;
  let docShell = win.docShell;
  if (docShell.asyncPanZoomEnabled && legacyactions.scrolling) {
    let ev = {
      index: 0,
      type,
      id: touch.identifier,
      clientX: touch.clientX,
      clientY: touch.clientY,
      screenX: touch.screenX,
      screenY: touch.screenY,
      radiusX: touch.radiusX,
      radiusY: touch.radiusY,
      rotation: touch.rotationAngle,
      force: touch.force,
    };
    sendSyncMessage("Marionette:emitTouchEvent", ev);
    return;
  }

  // we get here if we're not in asyncPacZoomEnabled land, or if we're
  // the main process
  win.windowUtils.sendTouchEvent(
    type,
    [touch.identifier],
    [touch.clientX],
    [touch.clientY],
    [touch.radiusX],
    [touch.radiusY],
    [touch.rotationAngle],
    [touch.force],
    0
  );
}

/**
 * Function that perform a single tap
 */
async function singleTap(el, corx, cory) {
  // after this block, the element will be scrolled into view
  let visible = element.isVisible(el, corx, cory);
  if (!visible) {
    throw new ElementNotInteractableError(
      "Element is not currently visible and may not be manipulated"
    );
  }

  let a11y = accessibility.get(capabilities.get("moz:accessibilityChecks"));
  let acc = await a11y.getAccessible(el, true);
  a11y.assertVisible(acc, el, visible);
  a11y.assertActionable(acc, el);
  if (!curContainer.frame.document.createTouch) {
    legacyactions.mouseEventsOnly = true;
  }
  let c = element.coordinates(el, corx, cory);
  if (!legacyactions.mouseEventsOnly) {
    let touchId = legacyactions.nextTouchId++;
    let touch = createATouch(el, c.x, c.y, touchId);
    emitTouchEvent("touchstart", touch);
    emitTouchEvent("touchend", touch);
  }
  legacyactions.mouseTap(el.ownerDocument, c.x, c.y);
}

/**
 * Function to create a touch based on the element
 * corx and cory are relative to the viewport, id is the touchId
 */
function createATouch(el, corx, cory, touchId) {
  let doc = el.ownerDocument;
  let win = doc.defaultView;
  let [
    clientX,
    clientY,
    pageX,
    pageY,
    screenX,
    screenY,
  ] = legacyactions.getCoordinateInfo(el, corx, cory);
  let atouch = doc.createTouch(
    win,
    el,
    touchId,
    pageX,
    pageY,
    screenX,
    screenY,
    clientX,
    clientY
  );
  return atouch;
}

/**
 * Perform a series of grouped actions at the specified points in time.
 *
 * @param {obj} msg
 *      Object with an |actions| attribute that is an Array of objects
 *      each of which represents an action sequence.
 */
async function performActions(msg) {
  let chain = action.Chain.fromJSON(msg.actions);
  await action.dispatch(
    chain,
    curContainer.frame,
    !capabilities.get("moz:useNonSpecCompliantPointerOrigin")
  );
}

/**
 * The release actions command is used to release all the keys and pointer
 * buttons that are currently depressed. This causes events to be fired
 * as if the state was released by an explicit series of actions. It also
 * clears all the internal state of the virtual devices.
 */
async function releaseActions() {
  await action.dispatchTickActions(
    action.inputsToCancel.reverse(),
    0,
    curContainer.frame
  );
  action.inputsToCancel.length = 0;
  action.inputStateMap.clear();

  event.DoubleClickTracker.resetClick();
}

/**
 * Start action chain on one finger.
 */
function actionChain(chain, touchId) {
  let touchProvider = {};
  touchProvider.createATouch = createATouch;
  touchProvider.emitTouchEvent = emitTouchEvent;

  return legacyactions.dispatchActions(
    chain,
    touchId,
    curContainer,
    seenEls,
    touchProvider
  );
}

function emitMultiEvents(type, touch, touches) {
  let target = touch.target;
  let doc = target.ownerDocument;
  let win = doc.defaultView;
  // touches that are in the same document
  let documentTouches = doc.createTouchList(
    touches.filter(function(t) {
      return t.target.ownerDocument === doc && type != "touchcancel";
    })
  );
  // touches on the same target
  let targetTouches = doc.createTouchList(
    touches.filter(function(t) {
      return (
        t.target === target && (type != "touchcancel" || type != "touchend")
      );
    })
  );
  // Create changed touches
  let changedTouches = doc.createTouchList(touch);
  // Create the event object
  let event = doc.createEvent("TouchEvent");
  event.initTouchEvent(
    type,
    true,
    true,
    win,
    0,
    false,
    false,
    false,
    false,
    documentTouches,
    targetTouches,
    changedTouches
  );
  target.dispatchEvent(event);
}

function setDispatch(batches, touches, batchIndex = 0) {
  // check if all the sets have been fired
  if (batchIndex >= batches.length) {
    multiLast = {};
    return;
  }

  // a set of actions need to be done
  let batch = batches[batchIndex];
  // each action for some finger
  let pack;
  // the touch id for the finger (pack)
  let touchId;
  // command for the finger
  let command;
  // touch that will be created for the finger
  let el;
  let touch;
  let lastTouch;
  let touchIndex;
  let waitTime = 0;
  let maxTime = 0;
  let c;

  // loop through the batch
  batchIndex++;
  for (let i = 0; i < batch.length; i++) {
    pack = batch[i];
    touchId = pack[0];
    command = pack[1];

    switch (command) {
      case "press":
        el = seenEls.get(pack[2], curContainer.frame);
        c = element.coordinates(el, pack[3], pack[4]);
        touch = createATouch(el, c.x, c.y, touchId);
        multiLast[touchId] = touch;
        touches.push(touch);
        emitMultiEvents("touchstart", touch, touches);
        break;

      case "release":
        touch = multiLast[touchId];
        // the index of the previous touch for the finger may change in
        // the touches array
        touchIndex = touches.indexOf(touch);
        touches.splice(touchIndex, 1);
        emitMultiEvents("touchend", touch, touches);
        break;

      case "move":
        el = seenEls.get(pack[2], curContainer.frame);
        c = element.coordinates(el);
        touch = createATouch(multiLast[touchId].target, c.x, c.y, touchId);
        touchIndex = touches.indexOf(lastTouch);
        touches[touchIndex] = touch;
        multiLast[touchId] = touch;
        emitMultiEvents("touchmove", touch, touches);
        break;

      case "moveByOffset":
        el = multiLast[touchId].target;
        lastTouch = multiLast[touchId];
        touchIndex = touches.indexOf(lastTouch);
        let doc = el.ownerDocument;
        let win = doc.defaultView;
        // since x and y are relative to the last touch, therefore,
        // it's relative to the position of the last touch
        let clientX = lastTouch.clientX + pack[2];
        let clientY = lastTouch.clientY + pack[3];
        let pageX = clientX + win.pageXOffset;
        let pageY = clientY + win.pageYOffset;
        let screenX = clientX + win.mozInnerScreenX;
        let screenY = clientY + win.mozInnerScreenY;
        touch = doc.createTouch(
          win,
          el,
          touchId,
          pageX,
          pageY,
          screenX,
          screenY,
          clientX,
          clientY
        );
        touches[touchIndex] = touch;
        multiLast[touchId] = touch;
        emitMultiEvents("touchmove", touch, touches);
        break;

      case "wait":
        if (typeof pack[2] != "undefined") {
          waitTime = pack[2] * 1000;
          if (waitTime > maxTime) {
            maxTime = waitTime;
          }
        }
        break;
    }
  }

  if (maxTime != 0) {
    let timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    timer.initWithCallback(
      function() {
        setDispatch(batches, touches, batchIndex);
      },
      maxTime,
      Ci.nsITimer.TYPE_ONE_SHOT
    );
  } else {
    setDispatch(batches, touches, batchIndex);
  }
}

/**
 * Start multi-action.
 *
 * @param {Number} maxLen
 *     Longest action chain for one finger.
 */
function multiAction(args, maxLen) {
  // unwrap the original nested array
  let commandArray = evaluate.fromJSON(args, seenEls, curContainer.frame);
  let concurrentEvent = [];
  let temp;
  for (let i = 0; i < maxLen; i++) {
    let row = [];
    for (let j = 0; j < commandArray.length; j++) {
      if (typeof commandArray[j][i] != "undefined") {
        // add finger id to the front of each action,
        // i.e. [finger_id, action, element]
        temp = commandArray[j][i];
        temp.unshift(j);
        row.push(temp);
      }
    }
    concurrentEvent.push(row);
  }

  // Now concurrent event is made of sets where each set contain a list
  // of actions that need to be fired.
  //
  // But note that each action belongs to a different finger
  // pendingTouches keeps track of current touches that's on the screen.
  let pendingTouches = [];
  setDispatch(concurrentEvent, pendingTouches);
}

/**
 * Cancel the polling and remove the event listener associated with a
 * current navigation request in case we're interupted by an onbeforeunload
 * handler and navigation doesn't complete.
 */
function cancelRequest() {
  loadListener.stop();
}

/**
 * This implements the latter part of a get request (for the case we need
 * to resume one when the frame script has been moved to a different content
 * process in the middle of a navigate request). This is most of of the work
 * of a navigate request, but doesn't assume DOMContentLoaded is yet to fire.
 *
 * @param {number} commandID
 *     ID of the currently handled message between the driver and
 *     listener.
 * @param {number} pageTimeout
 *     Timeout in seconds the method has to wait for the page being
 *     finished loading.
 * @param {number} startTime
 *     Unix timestap when the navitation request got triggered.
 */
function waitForPageLoaded(msg) {
  let { commandID, pageTimeout, startTime } = msg.json;
  loadListener.waitForLoadAfterFramescriptReload(
    commandID,
    pageTimeout,
    startTime
  );
}

/**
 * Navigate to the given URL.  The operation will be performed on the
 * current browsing context, which means it handles the case where we
 * navigate within an iframe.  All other navigation is handled by the driver
 * (in chrome space).
 */
function get(msg) {
  let { commandID, pageTimeout, url, loadEventExpected = null } = msg.json;

  try {
    if (typeof url == "string") {
      try {
        if (loadEventExpected === null) {
          loadEventExpected = navigate.isLoadEventExpected(
            curContainer.frame.location,
            url
          );
        }
      } catch (e) {
        let err = new InvalidArgumentError("Malformed URL: " + e.message);
        sendError(err, commandID);
        return;
      }
    }

    // We need to move to the top frame before navigating
    sendSyncMessage("Marionette:switchedToFrame", { frameValue: null });
    curContainer.frame = content;

    loadListener.navigate(
      () => {
        curContainer.frame.location = url;
      },
      commandID,
      pageTimeout,
      loadEventExpected
    );
  } catch (e) {
    sendError(e, commandID);
  }
}

/**
 * Cause the browser to traverse one step backward in the joint history
 * of the current browsing context.
 *
 * @param {number} commandID
 *     ID of the currently handled message between the driver and
 *     listener.
 * @param {number} pageTimeout
 *     Timeout in milliseconds the method has to wait for the page being
 *     finished loading.
 */
function goBack(msg) {
  let { commandID, pageTimeout } = msg.json;

  try {
    loadListener.navigate(
      () => {
        curContainer.frame.history.back();
      },
      commandID,
      pageTimeout
    );
  } catch (e) {
    sendError(e, commandID);
  }
}

/**
 * Cause the browser to traverse one step forward in the joint history
 * of the current browsing context.
 *
 * @param {number} commandID
 *     ID of the currently handled message between the driver and
 *     listener.
 * @param {number} pageTimeout
 *     Timeout in milliseconds the method has to wait for the page being
 *     finished loading.
 */
function goForward(msg) {
  let { commandID, pageTimeout } = msg.json;

  try {
    loadListener.navigate(
      () => {
        curContainer.frame.history.forward();
      },
      commandID,
      pageTimeout
    );
  } catch (e) {
    sendError(e, commandID);
  }
}

/**
 * Causes the browser to reload the page in in current top-level browsing
 * context.
 *
 * @param {number} commandID
 *     ID of the currently handled message between the driver and
 *     listener.
 * @param {number} pageTimeout
 *     Timeout in milliseconds the method has to wait for the page being
 *     finished loading.
 */
function refresh(msg) {
  let { commandID, pageTimeout } = msg.json;

  try {
    // We need to move to the top frame before navigating
    sendSyncMessage("Marionette:switchedToFrame", { frameValue: null });
    curContainer.frame = content;

    loadListener.navigate(
      () => {
        curContainer.frame.location.reload(true);
      },
      commandID,
      pageTimeout
    );
  } catch (e) {
    sendError(e, commandID);
  }
}

/**
 * Get source of the current browsing context's DOM.
 */
function getPageSource() {
  return curContainer.frame.document.documentElement.outerHTML;
}

/**
 * Find an element in the current browsing context's document using the
 * given search strategy.
 */
async function findElementContent(strategy, selector, opts = {}) {
  if (!SUPPORTED_STRATEGIES.has(strategy)) {
    throw new InvalidSelectorError("Strategy not supported: " + strategy);
  }

  opts.all = false;
  let el = await element.find(curContainer, strategy, selector, opts);
  return seenEls.add(el);
}

/**
 * Find elements in the current browsing context's document using the
 * given search strategy.
 */
async function findElementsContent(strategy, selector, opts = {}) {
  if (!SUPPORTED_STRATEGIES.has(strategy)) {
    throw new InvalidSelectorError("Strategy not supported: " + strategy);
  }

  opts.all = true;
  let els = await element.find(curContainer, strategy, selector, opts);
  let webEls = seenEls.addAll(els);
  return webEls;
}

/**
 * Return the active element in the document.
 *
 * @return {WebElement}
 *     Active element of the current browsing context's document
 *     element, if the document element is non-null.
 *
 * @throws {NoSuchElementError}
 *     If the document does not have an active element, i.e. if
 *     its document element has been deleted.
 */
function getActiveElement() {
  let el = curContainer.frame.document.activeElement;
  if (!el) {
    throw new NoSuchElementError();
  }
  return evaluate.toJSON(el, seenEls);
}

/**
 * Return the current browsing context id.
 *
 * @param {boolean=} topContext
 *     If set to true use the window's top-level browsing context,
 *     otherwise the one from the currently selected frame. Defaults to false.
 *
 * @return {number}
 *     Id of the browsing context.
 */
function getBrowsingContextId(topContext = false) {
  if (topContext) {
    return content.docShell.browsingContext.id;
  }

  return curContainer.frame.docShell.browsingContext.id;
}

/**
 * Send click event to element.
 *
 * @param {number} commandID
 *     ID of the currently handled message between the driver and
 *     listener.
 * @param {WebElement} webElRef
 *     Reference to the web element to click.
 * @param {number} pageTimeout
 *     Timeout in milliseconds the method has to wait for the page being
 *     finished loading.
 */
function clickElement(msg) {
  let { commandID, webElRef, pageTimeout } = msg.json;

  try {
    let webEl = WebElement.fromJSON(webElRef);
    let el = seenEls.get(webEl, curContainer.frame);

    let loadEventExpected = true;
    let target = getElementAttribute(el, "target");

    if (target === "_blank") {
      loadEventExpected = false;
    }

    loadListener.navigate(
      () => {
        return interaction.clickElement(
          el,
          capabilities.get("moz:accessibilityChecks"),
          capabilities.get("moz:webdriverClick")
        );
      },
      commandID,
      pageTimeout,
      loadEventExpected,
      true
    );
  } catch (e) {
    sendError(e, commandID);
  }
}

function getElementAttribute(el, name) {
  if (element.isBooleanAttribute(el, name)) {
    if (el.hasAttribute(name)) {
      return "true";
    }
    return null;
  }
  return el.getAttribute(name);
}

function getElementProperty(el, name) {
  return typeof el[name] != "undefined" ? el[name] : null;
}

/**
 * Get the text of this element.  This includes text from child
 * elements.
 */
function getElementText(el) {
  return atom.getElementText(el, curContainer.frame);
}

/**
 * Get the tag name of an element.
 *
 * @param {WebElement} id
 *     Reference to web element.
 *
 * @return {string}
 *     Tag name of element.
 */
function getElementTagName(el) {
  return el.tagName.toLowerCase();
}

/**
 * Determine the element displayedness of the given web element.
 *
 * Also performs additional accessibility checks if enabled by session
 * capability.
 */
function isElementDisplayed(el) {
  return interaction.isElementDisplayed(
    el,
    capabilities.get("moz:accessibilityChecks")
  );
}

/**
 * Retrieves the computed value of the given CSS property of the given
 * web element.
 */
function getElementValueOfCssProperty(el, prop) {
  let st = curContainer.frame.document.defaultView.getComputedStyle(el);
  return st.getPropertyValue(prop);
}

/**
 * Get the position and dimensions of the element.
 *
 * @return {Object.<string, number>}
 *     The x, y, width, and height properties of the element.
 */
function getElementRect(el) {
  let clientRect = el.getBoundingClientRect();
  return {
    x: clientRect.x + curContainer.frame.pageXOffset,
    y: clientRect.y + curContainer.frame.pageYOffset,
    width: clientRect.width,
    height: clientRect.height,
  };
}

function isElementEnabled(el) {
  return interaction.isElementEnabled(
    el,
    capabilities.get("moz:accessibilityChecks")
  );
}

/**
 * Determines if the referenced element is selected or not.
 *
 * This operation only makes sense on input elements of the Checkbox-
 * and Radio Button states, or option elements.
 */
function isElementSelected(el) {
  return interaction.isElementSelected(
    el,
    capabilities.get("moz:accessibilityChecks")
  );
}

async function sendKeysToElement(el, val) {
  let opts = {
    strictFileInteractability: capabilities.get("strictFileInteractability"),
    accessibilityChecks: capabilities.get("moz:accessibilityChecks"),
    webdriverClick: capabilities.get("moz:webdriverClick"),
  };
  await interaction.sendKeysToElement(el, val, opts);
}

/** Clear the text of an element. */
function clearElement(el) {
  interaction.clearElement(el);
}

/** Switch the current context to the specified host's Shadow DOM. */
function switchToShadowRoot(el) {
  if (!element.isElement(el)) {
    // If no host element is passed, attempt to find a parent shadow
    // root or, if none found, unset the current shadow root
    if (curContainer.shadowRoot) {
      let parent;
      try {
        parent = curContainer.shadowRoot.host;
      } catch (e) {
        // There is a chance that host element is dead and we are trying to
        // access a dead object.
        curContainer.shadowRoot = null;
        return;
      }
      while (parent && !(parent instanceof curContainer.frame.ShadowRoot)) {
        parent = parent.parentNode;
      }
      curContainer.shadowRoot = parent;
    }
    return;
  }

  let foundShadowRoot = el.shadowRoot;
  if (!foundShadowRoot) {
    throw new NoSuchElementError(pprint`Unable to locate shadow root: ${el}`);
  }
  curContainer.shadowRoot = foundShadowRoot;
}

/**
 * Switch to the parent frame of the current frame. If the frame is the
 * top most is the current frame then no action will happen.
 */
function switchToParentFrame(msg) {
  curContainer.frame = curContainer.frame.parent;
  let parentElement = seenEls.add(curContainer.frame);

  sendSyncMessage("Marionette:switchedToFrame", {
    frameValue: parentElement.uuid,
  });

  sendOk(msg.json.commandID);
}

/**
 * Switch to frame given either the server-assigned element id,
 * its index in window.frames, or the iframe's name or id.
 */
function switchToFrame(msg) {
  let commandID = msg.json.commandID;
  let foundFrame = null;

  // check if curContainer.frame reference is dead
  let frames = [];
  try {
    frames = curContainer.frame.frames;
  } catch (e) {
    // dead comparment, redirect to top frame
    msg.json.id = null;
    msg.json.element = null;
  }

  if (
    (msg.json.id === null || msg.json.id === undefined) &&
    msg.json.element == null
  ) {
    // returning to root frame
    sendSyncMessage("Marionette:switchedToFrame", { frameValue: null });

    curContainer.frame = content;
    if (msg.json.focus) {
      curContainer.frame.focus();
    }

    sendOk(commandID);
    return;
  }

  let webEl;
  if (typeof msg.json.element != "undefined") {
    webEl = WebElement.fromUUID(msg.json.element, "content");
  }

  if (webEl) {
    if (!seenEls.has(webEl)) {
      let err = new NoSuchElementError(`Unable to locate element: ${webEl}`);
      sendError(err, commandID);
      return;
    }

    let wantedFrame;
    try {
      wantedFrame = seenEls.get(webEl, curContainer.frame);
    } catch (e) {
      sendError(e, commandID);
      return;
    }

    if (frames.length > 0) {
      for (let i = 0; i < frames.length; i++) {
        // use XPCNativeWrapper to compare elements; see bug 834266
        let frameEl = frames[i].frameElement;
        let wrappedItem = new XPCNativeWrapper(frameEl);
        let wrappedWanted = new XPCNativeWrapper(wantedFrame);
        if (wrappedItem == wrappedWanted) {
          curContainer.frame = frameEl;
          foundFrame = i;
        }
      }
    }

    if (foundFrame === null) {
      // Either the frame has been removed or we have a OOP frame
      // so lets just get all the iframes and do a quick loop before
      // throwing in the towel
      const doc = curContainer.frame.document;
      let iframes = doc.getElementsByTagName("iframe");
      for (let i = 0; i < iframes.length; i++) {
        let frameEl = iframes[i];
        let wrappedEl = new XPCNativeWrapper(frameEl);
        let wrappedWanted = new XPCNativeWrapper(wantedFrame);
        if (wrappedEl == wrappedWanted) {
          curContainer.frame = iframes[i];
          foundFrame = i;
        }
      }
    }
  }

  if (foundFrame === null) {
    if (typeof msg.json.id === "number") {
      try {
        foundFrame = frames[msg.json.id].frameElement;
        if (foundFrame !== null) {
          curContainer.frame = foundFrame;
          foundFrame = seenEls.add(curContainer.frame);
        } else {
          // If foundFrame is null at this point then we have the top
          // level browsing context so should treat it accordingly.
          sendSyncMessage("Marionette:switchedToFrame", { frameValue: null });
          curContainer.frame = content;

          if (msg.json.focus) {
            curContainer.frame.focus();
          }

          sendOk(commandID);
          return;
        }
      } catch (e) {
        // Since window.frames does not return OOP frames it will throw
        // and we land up here. Let's not give up and check if there are
        // iframes and switch to the indexed frame there
        let doc = curContainer.frame.document;
        let iframes = doc.getElementsByTagName("iframe");
        if (msg.json.id >= 0 && msg.json.id < iframes.length) {
          curContainer.frame = iframes[msg.json.id];
          foundFrame = msg.json.id;
        }
      }
    }
  }

  if (foundFrame === null) {
    let failedFrame = msg.json.id || msg.json.element;
    let err = new NoSuchFrameError(`Unable to locate frame: ${failedFrame}`);
    sendError(err, commandID);
    return;
  }

  // send a synchronous message to let the server update the currently active
  // frame element (for getActiveFrame)
  let frameWebEl = seenEls.add(curContainer.frame.wrappedJSObject);
  sendSyncMessage("Marionette:switchedToFrame", {
    frameValue: frameWebEl.uuid,
  });

  curContainer.frame = curContainer.frame.contentWindow;
  if (msg.json.focus) {
    curContainer.frame.focus();
  }

  sendOk(commandID);
}

/**
 * Returns the rect of the element to screenshot.
 *
 * Because the screen capture takes place in the parent process the dimensions
 * for the screenshot have to be determined in the appropriate child process.
 *
 * Also it takes care of scrolling an element into view if requested.
 *
 * @param {Object.<string, ?>} opts
 *     Options.
 *
 * Accepted values for |opts|:
 *
 * @param {WebElement} webEl
 *     Optional element to take a screenshot of.
 * @param {boolean=} full
 *     True to take a screenshot of the entire document element. Is only
 *     considered if <var>id</var> is not defined. Defaults to true.
 * @param {boolean=} scroll
 *     When <var>id</var> is given, scroll it into view before taking the
 *     screenshot.  Defaults to true.
 * @param {capture.Format} format
 *     Format to return the screenshot in.
 * @param {Object.<string, ?>} opts
 *     Options.
 *
 * @return {DOMRect}
 *     The area to take a snapshot from
 */
function getScreenshotRect({ el, full = true, scroll = true } = {}) {
  let win = el ? curContainer.frame : content;

  let rect;

  if (el) {
    if (scroll) {
      element.scrollIntoView(el);
    }
    rect = getElementRect(el);
  } else if (full) {
    const docEl = win.document.documentElement;
    rect = new DOMRect(0, 0, docEl.scrollWidth, docEl.scrollHeight);
  } else {
    // viewport
    rect = new DOMRect(
      win.pageXOffset,
      win.pageYOffset,
      win.innerWidth,
      win.innerHeight
    );
  }

  return rect;
}

function flushRendering() {
  let content = curContainer.frame;
  let anyPendingPaintsGeneratedInDescendants = false;

  let windowUtils = content.windowUtils;

  function flushWindow(win) {
    let utils = win.windowUtils;
    let afterPaintWasPending = utils.isMozAfterPaintPending;

    let root = win.document.documentElement;
    if (root) {
      try {
        // Flush pending restyles and reflows for this window (layout)
        root.getBoundingClientRect();
      } catch (e) {
        logger.error("flushWindow failed", e);
      }
    }

    if (!afterPaintWasPending && utils.isMozAfterPaintPending) {
      anyPendingPaintsGeneratedInDescendants = true;
    }

    for (let i = 0; i < win.frames.length; ++i) {
      flushWindow(win.frames[i]);
    }
  }
  flushWindow(content);

  if (
    anyPendingPaintsGeneratedInDescendants &&
    !windowUtils.isMozAfterPaintPending
  ) {
    logger.error(
      "Descendant frame generated a MozAfterPaint event, " +
        "but the root document doesn't have one!"
    );
  }
}

async function reftestWait(url, remote) {
  let win = curContainer.frame;
  let document = curContainer.frame.document;
  let reftestWait;

  if (document.location.href !== url || document.readyState != "complete") {
    reftestWait = await documentLoad(win, url);
    win = curContainer.frame;
    document = curContainer.frame.document;
  } else {
    reftestWait = document.documentElement.classList.contains("reftest-wait");
  }

  logger.debug("Waiting for event loop to spin");
  await new Promise(resolve => win.setTimeout(resolve, 0));

  await paintComplete(win, remote);

  let root = document.documentElement;
  if (reftestWait) {
    let event = new Event("TestRendered", { bubbles: true });
    root.dispatchEvent(event);
    logger.info("Emitted TestRendered event");
    await reftestWaitRemoved(win, root);
    await paintComplete(win, remote);
  }
  if (
    win.innerWidth < document.documentElement.scrollWidth ||
    win.innerHeight < document.documentElement.scrollHeight
  ) {
    logger.warn(
      `${url} overflows viewport (width: ${document.documentElement.scrollWidth}, height: ${document.documentElement.scrollHeight})`
    );
  }
}

function documentLoad(win, url) {
  logger.debug(truncate`Waiting for page load of ${url}`);
  return new Promise(resolve => {
    let maybeResolve = event => {
      if (
        event.target === curContainer.frame.document &&
        event.target.location.href === url
      ) {
        let reftestWait = win.document.documentElement.classList.contains(
          "reftest-wait"
        );
        removeEventListener("load", maybeResolve, { once: true });
        resolve(reftestWait);
      }
    };
    addEventListener("load", maybeResolve, true);
  });
}

function paintComplete(win, remote) {
  logger.debug("Waiting for rendering");
  let windowUtils = content.windowUtils;
  return new Promise(resolve => {
    let maybeResolve = () => {
      flushRendering();
      if (remote) {
        // Flush display (paint)
        windowUtils.updateLayerTree();
      }
      if (windowUtils.isMozAfterPaintPending) {
        logger.debug(`reftestWait: ${windowUtils.isMozAfterPaintPending}`);
        win.addEventListener("MozAfterPaint", maybeResolve, { once: true });
      } else {
        // resolve at the start of the next frame in case of leftover paints
        win.requestAnimationFrame(() => {
          win.requestAnimationFrame(resolve);
        });
      }
    };
    maybeResolve();
  });
}

function reftestWaitRemoved(win, root) {
  logger.debug("Waiting for reftest-wait removal");
  return new Promise(resolve => {
    let observer = new win.MutationObserver(() => {
      if (!root.classList.contains("reftest-wait")) {
        observer.disconnect();
        logger.debug("reftest-wait removed");
        win.setTimeout(resolve, 0);
      }
    });
    if (root.classList.contains("reftest-wait")) {
      observer.observe(root, { attributes: true });
    } else {
      win.setTimeout(resolve, 0);
    }
  });
}

function domAddEventListener(msg) {
  eventObservers.add(msg.json.type);
}

function domRemoveEventListener(msg) {
  eventObservers.remove(msg.json.type);
}

// Call register self when we get loaded
registerSelf();
