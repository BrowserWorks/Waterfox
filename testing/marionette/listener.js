/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

var uuidGen = Cc["@mozilla.org/uuid-generator;1"]
    .getService(Ci.nsIUUIDGenerator);

var loader = Cc["@mozilla.org/moz/jssubscript-loader;1"]
    .getService(Ci.mozIJSSubScriptLoader);

Cu.import("chrome://marionette/content/accessibility.js");
Cu.import("chrome://marionette/content/action.js");
Cu.import("chrome://marionette/content/atom.js");
Cu.import("chrome://marionette/content/capture.js");
Cu.import("chrome://marionette/content/cookies.js");
Cu.import("chrome://marionette/content/element.js");
Cu.import("chrome://marionette/content/error.js");
Cu.import("chrome://marionette/content/evaluate.js");
Cu.import("chrome://marionette/content/event.js");
Cu.import("chrome://marionette/content/interaction.js");
Cu.import("chrome://marionette/content/legacyaction.js");
Cu.import("chrome://marionette/content/logging.js");
Cu.import("chrome://marionette/content/navigate.js");
Cu.import("chrome://marionette/content/proxy.js");
Cu.import("chrome://marionette/content/session.js");
Cu.import("chrome://marionette/content/simpletest.js");

Cu.import("resource://gre/modules/FileUtils.jsm");
Cu.import("resource://gre/modules/Task.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

Cu.importGlobalProperties(["URL"]);

var contentLog = new logging.ContentLogger();

var isB2G = false;

var marionetteTestName;
var winUtil = content.QueryInterface(Ci.nsIInterfaceRequestor)
    .getInterface(Ci.nsIDOMWindowUtils);
var listenerId = null; // unique ID of this listener
var curContainer = { frame: content, shadowRoot: null };
var isRemoteBrowser = () => curContainer.frame.contentWindow !== null;
var previousContainer = null;

var seenEls = new element.Store();
var SUPPORTED_STRATEGIES = new Set([
  element.Strategy.ClassName,
  element.Strategy.Selector,
  element.Strategy.ID,
  element.Strategy.Name,
  element.Strategy.LinkText,
  element.Strategy.PartialLinkText,
  element.Strategy.TagName,
  element.Strategy.XPath,
]);

var capabilities;

var legacyactions = new legacyaction.Chain(checkForInterrupted);

// the unload handler
var onunload;

// Flag to indicate whether an async script is currently running or not.
var asyncTestRunning = false;
var asyncTestCommandId;
var asyncTestTimeoutId;

var inactivityTimeoutId = null;

var originalOnError;
//timer for doc changes
var checkTimer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
//timer for readystate
var readyStateTimer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
// timer for navigation commands.
var navTimer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
var onDOMContentLoaded;
// Send move events about this often
var EVENT_INTERVAL = 30; // milliseconds
// last touch for each fingerId
var multiLast = {};
var asyncChrome = proxy.toChromeAsync({
  addMessageListener: addMessageListenerId.bind(this),
  removeMessageListener: removeMessageListenerId.bind(this),
  sendAsyncMessage: sendAsyncMessage.bind(this),
});
var syncChrome = proxy.toChrome(sendSyncMessage.bind(this));
var cookies = new Cookies(() => curContainer.frame.document, syncChrome);
var importedScripts = new evaluate.ScriptStorageServiceClient(syncChrome);

Cu.import("resource://gre/modules/Log.jsm");
var logger = Log.repository.getLogger("Marionette");
logger.debug("loaded listener.js");

var modalHandler = function() {
  // This gets called on the system app only since it receives the mozbrowserprompt event
  sendSyncMessage("Marionette:switchedToFrame", {frameValue: null, storePrevious: true});
  let isLocal = sendSyncMessage("MarionetteFrame:handleModal", {})[0].value;
  if (isLocal) {
    previousContainer = curContainer;
  }
  curContainer = {frame: content, shadowRoot: null};
};

// sandbox storage and name of the current sandbox
var sandboxes = new Sandboxes(() => curContainer.frame);
var sandboxName = "default";

/**
 * Called when listener is first started up.
 * The listener sends its unique window ID and its current URI to the actor.
 * If the actor returns an ID, we start the listeners. Otherwise, nothing happens.
 */
function registerSelf() {
  let msg = {value: winUtil.outerWindowID};
  // register will have the ID and a boolean describing if this is the main process or not
  let register = sendSyncMessage("Marionette:register", msg);

  if (register[0]) {
    let {id, remotenessChange} = register[0][0];
    capabilities = session.Capabilities.fromJSON(register[0][2]);
    listenerId = id;
    if (typeof id != "undefined") {
      // check if we're the main process
      if (register[0][1]) {
        addMessageListener("MarionetteMainListener:emitTouchEvent", emitTouchEventForIFrame);
      }
      startListeners();
      let rv = {};
      if (remotenessChange) {
        rv.listenerId = id;
      }
      sendAsyncMessage("Marionette:listenersAttached", rv);
    }
  }
}

function emitTouchEventForIFrame(message) {
  message = message.json;
  let identifier = legacyactions.nextTouchId;

  let domWindowUtils = curContainer.frame.
    QueryInterface(Components.interfaces.nsIInterfaceRequestor).
    getInterface(Components.interfaces.nsIDOMWindowUtils);
  var ratio = domWindowUtils.screenPixelsPerCSSPixel;

  var typeForUtils;
  switch (message.type) {
    case 'touchstart':
      typeForUtils = domWindowUtils.TOUCH_CONTACT;
      break;
    case 'touchend':
      typeForUtils = domWindowUtils.TOUCH_REMOVE;
      break;
    case 'touchcancel':
      typeForUtils = domWindowUtils.TOUCH_CANCEL;
      break;
    case 'touchmove':
      typeForUtils = domWindowUtils.TOUCH_CONTACT;
      break;
  }
  domWindowUtils.sendNativeTouchPoint(identifier, typeForUtils,
    Math.round(message.screenX * ratio), Math.round(message.screenY * ratio),
    message.force, 90);
}

// Eventually we will not have a closure for every single command, but
// use a generic dispatch for all listener commands.
//
// Perhaps one could even conceive having a separate instance of
// CommandProcessor for the listener, because the code is mostly the same.
function dispatch(fn) {
  if (typeof fn != "function") {
    throw new TypeError("Provided dispatch handler is not a function");
  }

  return function (msg) {
    let id = msg.json.command_id;

    let req = Task.spawn(function*() {
      if (typeof msg.json == "undefined" || msg.json instanceof Array) {
        return yield fn.apply(null, msg.json);
      } else {
        return yield fn(msg.json);
      }
    });

    let okOrValueResponse = rv => {
      if (typeof rv == "undefined") {
        sendOk(id);
      } else {
        sendResponse(rv, id);
      }
    };

    req.then(okOrValueResponse, err => sendError(err, id))
        .catch(error.report);
  };
}

/**
 * Add a message listener that's tied to our listenerId.
 */
function addMessageListenerId(messageName, handler) {
  addMessageListener(messageName + listenerId, handler);
}

/**
 * Remove a message listener that's tied to our listenerId.
 */
function removeMessageListenerId(messageName, handler) {
  removeMessageListener(messageName + listenerId, handler);
}

var getTitleFn = dispatch(getTitle);
var getPageSourceFn = dispatch(getPageSource);
var getActiveElementFn = dispatch(getActiveElement);
var clickElementFn = dispatch(clickElement);
var goBackFn = dispatch(goBack);
var getElementAttributeFn = dispatch(getElementAttribute);
var getElementPropertyFn = dispatch(getElementProperty);
var getElementTextFn = dispatch(getElementText);
var getElementTagNameFn = dispatch(getElementTagName);
var getElementRectFn = dispatch(getElementRect);
var isElementEnabledFn = dispatch(isElementEnabled);
var getCurrentUrlFn = dispatch(getCurrentUrl);
var findElementContentFn = dispatch(findElementContent);
var findElementsContentFn = dispatch(findElementsContent);
var isElementSelectedFn = dispatch(isElementSelected);
var clearElementFn = dispatch(clearElement);
var isElementDisplayedFn = dispatch(isElementDisplayed);
var getElementValueOfCssPropertyFn = dispatch(getElementValueOfCssProperty);
var switchToShadowRootFn = dispatch(switchToShadowRoot);
var getCookiesFn = dispatch(getCookies);
var singleTapFn = dispatch(singleTap);
var takeScreenshotFn = dispatch(takeScreenshot);
var performActionsFn = dispatch(performActions);
var releaseActionsFn = dispatch(releaseActions);
var actionChainFn = dispatch(actionChain);
var multiActionFn = dispatch(multiAction);
var addCookieFn = dispatch(addCookie);
var deleteCookieFn = dispatch(deleteCookie);
var deleteAllCookiesFn = dispatch(deleteAllCookies);
var executeFn = dispatch(execute);
var executeInSandboxFn = dispatch(executeInSandbox);
var executeSimpleTestFn = dispatch(executeSimpleTest);
var sendKeysToElementFn = dispatch(sendKeysToElement);

/**
 * Start all message listeners
 */
function startListeners() {
  addMessageListenerId("Marionette:newSession", newSession);
  addMessageListenerId("Marionette:execute", executeFn);
  addMessageListenerId("Marionette:executeInSandbox", executeInSandboxFn);
  addMessageListenerId("Marionette:executeSimpleTest", executeSimpleTestFn);
  addMessageListenerId("Marionette:singleTap", singleTapFn);
  addMessageListenerId("Marionette:performActions", performActionsFn);
  addMessageListenerId("Marionette:releaseActions", releaseActionsFn);
  addMessageListenerId("Marionette:actionChain", actionChainFn);
  addMessageListenerId("Marionette:multiAction", multiActionFn);
  addMessageListenerId("Marionette:get", get);
  addMessageListenerId("Marionette:pollForReadyState", pollForReadyState);
  addMessageListenerId("Marionette:cancelRequest", cancelRequest);
  addMessageListenerId("Marionette:getCurrentUrl", getCurrentUrlFn);
  addMessageListenerId("Marionette:getTitle", getTitleFn);
  addMessageListenerId("Marionette:getPageSource", getPageSourceFn);
  addMessageListenerId("Marionette:goBack", goBackFn);
  addMessageListenerId("Marionette:goForward", goForward);
  addMessageListenerId("Marionette:refresh", refresh);
  addMessageListenerId("Marionette:findElementContent", findElementContentFn);
  addMessageListenerId("Marionette:findElementsContent", findElementsContentFn);
  addMessageListenerId("Marionette:getActiveElement", getActiveElementFn);
  addMessageListenerId("Marionette:clickElement", clickElementFn);
  addMessageListenerId("Marionette:getElementAttribute", getElementAttributeFn);
  addMessageListenerId("Marionette:getElementProperty", getElementPropertyFn);
  addMessageListenerId("Marionette:getElementText", getElementTextFn);
  addMessageListenerId("Marionette:getElementTagName", getElementTagNameFn);
  addMessageListenerId("Marionette:isElementDisplayed", isElementDisplayedFn);
  addMessageListenerId("Marionette:getElementValueOfCssProperty", getElementValueOfCssPropertyFn);
  addMessageListenerId("Marionette:getElementRect", getElementRectFn);
  addMessageListenerId("Marionette:isElementEnabled", isElementEnabledFn);
  addMessageListenerId("Marionette:isElementSelected", isElementSelectedFn);
  addMessageListenerId("Marionette:sendKeysToElement", sendKeysToElementFn);
  addMessageListenerId("Marionette:clearElement", clearElementFn);
  addMessageListenerId("Marionette:switchToFrame", switchToFrame);
  addMessageListenerId("Marionette:switchToParentFrame", switchToParentFrame);
  addMessageListenerId("Marionette:switchToShadowRoot", switchToShadowRootFn);
  addMessageListenerId("Marionette:deleteSession", deleteSession);
  addMessageListenerId("Marionette:sleepSession", sleepSession);
  addMessageListenerId("Marionette:getAppCacheStatus", getAppCacheStatus);
  addMessageListenerId("Marionette:setTestName", setTestName);
  addMessageListenerId("Marionette:takeScreenshot", takeScreenshotFn);
  addMessageListenerId("Marionette:addCookie", addCookieFn);
  addMessageListenerId("Marionette:getCookies", getCookiesFn);
  addMessageListenerId("Marionette:deleteAllCookies", deleteAllCookiesFn);
  addMessageListenerId("Marionette:deleteCookie", deleteCookieFn);
}

/**
 * Used during newSession and restart, called to set up the modal dialog listener in b2g
 */
function waitForReady() {
  if (content.document.readyState == 'complete') {
    readyStateTimer.cancel();
    content.addEventListener("mozbrowsershowmodalprompt", modalHandler, false);
    content.addEventListener("unload", waitForReady, false);
  }
  else {
    readyStateTimer.initWithCallback(waitForReady, 100, Ci.nsITimer.TYPE_ONE_SHOT);
  }
}

/**
 * Called when we start a new session. It registers the
 * current environment, and resets all values
 */
function newSession(msg) {
  capabilities = session.Capabilities.fromJSON(msg.json);
  isB2G = capabilities.get("platformName") === "B2G";
  resetValues();
  if (isB2G) {
    readyStateTimer.initWithCallback(waitForReady, 100, Ci.nsITimer.TYPE_ONE_SHOT);
    // We have to set correct mouse event source to MOZ_SOURCE_TOUCH
    // to offer a way for event listeners to differentiate
    // events being the result of a physical mouse action.
    // This is especially important for the touch event shim,
    // in order to prevent creating touch event for these fake mouse events.
    legacyactions.inputSource = Ci.nsIDOMMouseEvent.MOZ_SOURCE_TOUCH;
  }
}

/**
 * Puts the current session to sleep, so all listeners are removed except
 * for the 'restart' listener. This is used to keep the content listener
 * alive for reuse in B2G instead of reloading it each time.
 */
function sleepSession(msg) {
  deleteSession();
  addMessageListener("Marionette:restart", restart);
}

/**
 * Restarts all our listeners after this listener was put to sleep
 */
function restart(msg) {
  removeMessageListener("Marionette:restart", restart);
  if (isB2G) {
    readyStateTimer.initWithCallback(waitForReady, 100, Ci.nsITimer.TYPE_ONE_SHOT);
  }
  registerSelf();
}

/**
 * Removes all listeners
 */
function deleteSession(msg) {
  removeMessageListenerId("Marionette:newSession", newSession);
  removeMessageListenerId("Marionette:execute", executeFn);
  removeMessageListenerId("Marionette:executeInSandbox", executeInSandboxFn);
  removeMessageListenerId("Marionette:executeSimpleTest", executeSimpleTestFn);
  removeMessageListenerId("Marionette:singleTap", singleTapFn);
  removeMessageListenerId("Marionette:performActions", performActionsFn);
  removeMessageListenerId("Marionette:releaseActions", releaseActionsFn);
  removeMessageListenerId("Marionette:actionChain", actionChainFn);
  removeMessageListenerId("Marionette:multiAction", multiActionFn);
  removeMessageListenerId("Marionette:get", get);
  removeMessageListenerId("Marionette:pollForReadyState", pollForReadyState);
  removeMessageListenerId("Marionette:cancelRequest", cancelRequest);
  removeMessageListenerId("Marionette:getTitle", getTitleFn);
  removeMessageListenerId("Marionette:getPageSource", getPageSourceFn);
  removeMessageListenerId("Marionette:getCurrentUrl", getCurrentUrlFn);
  removeMessageListenerId("Marionette:goBack", goBackFn);
  removeMessageListenerId("Marionette:goForward", goForward);
  removeMessageListenerId("Marionette:refresh", refresh);
  removeMessageListenerId("Marionette:findElementContent", findElementContentFn);
  removeMessageListenerId("Marionette:findElementsContent", findElementsContentFn);
  removeMessageListenerId("Marionette:getActiveElement", getActiveElementFn);
  removeMessageListenerId("Marionette:clickElement", clickElementFn);
  removeMessageListenerId("Marionette:getElementAttribute", getElementAttributeFn);
  removeMessageListenerId("Marionette:getElementProperty", getElementPropertyFn);
  removeMessageListenerId("Marionette:getElementText", getElementTextFn);
  removeMessageListenerId("Marionette:getElementTagName", getElementTagNameFn);
  removeMessageListenerId("Marionette:isElementDisplayed", isElementDisplayedFn);
  removeMessageListenerId("Marionette:getElementValueOfCssProperty", getElementValueOfCssPropertyFn);
  removeMessageListenerId("Marionette:getElementRect", getElementRectFn);
  removeMessageListenerId("Marionette:isElementEnabled", isElementEnabledFn);
  removeMessageListenerId("Marionette:isElementSelected", isElementSelectedFn);
  removeMessageListenerId("Marionette:sendKeysToElement", sendKeysToElementFn);
  removeMessageListenerId("Marionette:clearElement", clearElementFn);
  removeMessageListenerId("Marionette:switchToFrame", switchToFrame);
  removeMessageListenerId("Marionette:switchToParentFrame", switchToParentFrame);
  removeMessageListenerId("Marionette:switchToShadowRoot", switchToShadowRootFn);
  removeMessageListenerId("Marionette:deleteSession", deleteSession);
  removeMessageListenerId("Marionette:sleepSession", sleepSession);
  removeMessageListenerId("Marionette:getAppCacheStatus", getAppCacheStatus);
  removeMessageListenerId("Marionette:setTestName", setTestName);
  removeMessageListenerId("Marionette:takeScreenshot", takeScreenshotFn);
  removeMessageListenerId("Marionette:addCookie", addCookieFn);
  removeMessageListenerId("Marionette:getCookies", getCookiesFn);
  removeMessageListenerId("Marionette:deleteAllCookies", deleteAllCookiesFn);
  removeMessageListenerId("Marionette:deleteCookie", deleteCookieFn);
  if (isB2G) {
    content.removeEventListener("mozbrowsershowmodalprompt", modalHandler, false);
  }
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
 * @param {?=} data
 *     JSON serialisable object to accompany the message.  Defaults to
 *     an empty dictionary.
 */
function sendToServer(uuid, data = undefined) {
  let channel = new proxy.AsyncMessageChannel(
      () => this,
      sendAsyncMessage.bind(this));
  channel.reply(uuid, data);
}

/**
 * Send asynchronous reply with value to chrome.
 *
 * @param {?} obj
 *     JSON serialisable object of arbitrary type and complexity.
 * @param {UUID} uuid
 *     Unique identifier of the request.
 */
function sendResponse(obj, id) {
  sendToServer(id, obj);
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

/**
 * Send log message to server
 */
function sendLog(msg) {
  sendToServer("Marionette:log", {message: msg});
}

/**
 * Clear test values after completion of test
 */
function resetValues() {
  sandboxes.clear();
  curContainer = {frame: content, shadowRoot: null};
  legacyactions.mouseEventsOnly = false;
  action.inputStateMap = new Map();
  action.inputsToCancel = [];
}

/**
 * Dump a logline to stdout. Prepends logline with a timestamp.
 */
function dumpLog(logline) {
  dump(Date.now() + " Marionette: " + logline);
}

/**
 * Check if our context was interrupted
 */
function wasInterrupted() {
  if (previousContainer) {
    let element = content.document.elementFromPoint((content.innerWidth/2), (content.innerHeight/2));
    if (element.id.indexOf("modal-dialog") == -1) {
      return true;
    }
    else {
      return false;
    }
  }
  return sendSyncMessage("MarionetteFrame:getInterruptedState", {})[0].value;
}

function checkForInterrupted() {
    if (wasInterrupted()) {
      if (previousContainer) {
        // if previousContainer is set, then we're in a single process environment
        curContainer = legacyactions.container = previousContainer;
        previousContainer = null;
      }
      else {
        //else we're in OOP environment, so we'll switch to the original OOP frame
        sendSyncMessage("Marionette:switchToModalOrigin");
      }
      sendSyncMessage("Marionette:switchedToFrame", { restorePrevious: true });
    }
}

function* execute(script, args, timeout, opts) {
  opts.timeout = timeout;
  script = importedScripts.for("content").concat(script);

  let sb = sandbox.createMutable(curContainer.frame);
  let wargs = element.fromJson(
      args, seenEls, curContainer.frame, curContainer.shadowRoot);
  let res = yield evaluate.sandbox(sb, script, wargs, opts);

  return element.toJson(res, seenEls);
}

function* executeInSandbox(script, args, timeout, opts) {
  opts.timeout = timeout;
  script = importedScripts.for("content").concat(script);

  let sb = sandboxes.get(opts.sandboxName, opts.newSandbox);
  if (opts.sandboxName) {
    sb = sandbox.augment(sb, {global: sb});
    sb = sandbox.augment(sb, new logging.Adapter(contentLog));
  }

  let wargs = element.fromJson(
      args, seenEls, curContainer.frame, curContainer.shadowRoot);
  let evaluatePromise = evaluate.sandbox(sb, script, wargs, opts);

  let res = yield evaluatePromise;
  sendSyncMessage(
      "Marionette:shareData",
      {log: element.toJson(contentLog.get(), seenEls)});
  return element.toJson(res, seenEls);
}

function* executeSimpleTest(script, args, timeout, opts) {
  opts.timeout = timeout;
  let win = curContainer.frame;
  script = importedScripts.for("content").concat(script);

  let harness = new simpletest.Harness(
      win,
      "content",
      contentLog,
      timeout,
      marionetteTestName);
  let sb = sandbox.createSimpleTest(curContainer.frame, harness);
  // TODO(ato): Not sure this is needed:
  sb = sandbox.augment(sb, new logging.Adapter(contentLog));

  let wargs = element.fromJson(
      args, seenEls, curContainer.frame, curContainer.shadowRoot);
  let evaluatePromise = evaluate.sandbox(sb, script, wargs, opts);

  let res = yield evaluatePromise;
  sendSyncMessage(
      "Marionette:shareData",
      {log: element.toJson(contentLog.get(), seenEls)});
  return element.toJson(res, seenEls);
}

/**
 * Sets the test name, used in logging messages.
 */
function setTestName(msg) {
  marionetteTestName = msg.json.value;
  sendOk(msg.json.command_id);
}

/**
 * This function creates a touch event given a touch type and a touch
 */
function emitTouchEvent(type, touch) {
  if (!wasInterrupted()) {
    let loggingInfo = "emitting Touch event of type " + type + " to element with id: " + touch.target.id + " and tag name: " + touch.target.tagName + " at coordinates (" + touch.clientX + ", " + touch.clientY + ") relative to the viewport";
    dumpLog(loggingInfo);
    var docShell = curContainer.frame.document.defaultView.
                   QueryInterface(Components.interfaces.nsIInterfaceRequestor).
                   getInterface(Components.interfaces.nsIWebNavigation).
                   QueryInterface(Components.interfaces.nsIDocShell);
    if (docShell.asyncPanZoomEnabled && legacyactions.scrolling) {
      // if we're in APZ and we're scrolling, we must use sendNativeTouchPoint to dispatch our touchmove events
      let index = sendSyncMessage("MarionetteFrame:getCurrentFrameId");
      // only call emitTouchEventForIFrame if we're inside an iframe.
      if (index != null) {
        sendSyncMessage("Marionette:emitTouchEvent",
          { index: index, type: type, id: touch.identifier,
            clientX: touch.clientX, clientY: touch.clientY,
            screenX: touch.screenX, screenY: touch.screenY,
            radiusX: touch.radiusX, radiusY: touch.radiusY,
            rotation: touch.rotationAngle, force: touch.force });
        return;
      }
    }
    // we get here if we're not in asyncPacZoomEnabled land, or if we're the main process
    /*
    Disabled per bug 888303
    contentLog.log(loggingInfo, "TRACE");
    sendSyncMessage(
        "Marionette:shareData",
        {log: element.toJson(contentLog.get(), seenEls)});
    contentLog.clear();
    */
    let domWindowUtils = curContainer.frame.QueryInterface(Components.interfaces.nsIInterfaceRequestor).getInterface(Components.interfaces.nsIDOMWindowUtils);
    domWindowUtils.sendTouchEvent(type, [touch.identifier], [touch.clientX], [touch.clientY], [touch.radiusX], [touch.radiusY], [touch.rotationAngle], [touch.force], 1, 0);
  }
}

/**
 * Function that perform a single tap
 */
function singleTap(id, corx, cory) {
  let el = seenEls.get(id, curContainer);
  // after this block, the element will be scrolled into view
  let visible = element.isVisible(el, corx, cory);
  if (!visible) {
    throw new ElementNotVisibleError("Element is not currently visible and may not be manipulated");
  }

  let a11y = accessibility.get(capabilities.get("moz:accessibilityChecks"));
  return a11y.getAccessible(el, true).then(acc => {
    a11y.assertVisible(acc, el, visible);
    a11y.assertActionable(acc, el);
    if (!curContainer.frame.document.createTouch) {
      legacyactions.mouseEventsOnly = true;
    }
    let c = element.coordinates(el, corx, cory);
    if (!legacyactions.mouseEventsOnly) {
      let touchId = legacyactions.nextTouchId++;
      let touch = createATouch(el, c.x, c.y, touchId);
      emitTouchEvent('touchstart', touch);
      emitTouchEvent('touchend', touch);
    }
    legacyactions.mouseTap(el.ownerDocument, c.x, c.y);
  });
}

/**
 * Function to create a touch based on the element
 * corx and cory are relative to the viewport, id is the touchId
 */
function createATouch(el, corx, cory, touchId) {
  let doc = el.ownerDocument;
  let win = doc.defaultView;
  let [clientX, clientY, pageX, pageY, screenX, screenY] =
   legacyactions.getCoordinateInfo(el, corx, cory);
  let atouch = doc.createTouch(win, el, touchId, pageX, pageY, screenX, screenY, clientX, clientY);
  return atouch;
}

/**
 * Perform a series of grouped actions at the specified points in time.
 *
 * @param {obj} msg
 *      Object with an |actions| attribute that is an Array of objects
 *      each of which represents an action sequence.
 */
function performActions(msg) {
  let chain = action.Chain.fromJson(msg.actions);
  action.dispatch(chain, seenEls, curContainer);
}

/**
 * The Release Actions command is used to release all the keys and pointer
 * buttons that are currently depressed. This causes events to be fired as if
 * the state was released by an explicit series of actions. It also clears all
 * the internal state of the virtual devices.
 */
function releaseActions() {
  action.dispatchTickActions(action.inputsToCancel.reverse(), 0, seenEls, curContainer);
  action.inputsToCancel.length = 0;
  action.inputStateMap.clear();
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
      touchProvider);
}

/**
 * Function to emit touch events which allow multi touch on the screen
 * @param type represents the type of event, touch represents the current touch,touches are all pending touches
 */
function emitMultiEvents(type, touch, touches) {
  let target = touch.target;
  let doc = target.ownerDocument;
  let win = doc.defaultView;
  // touches that are in the same document
  let documentTouches = doc.createTouchList(touches.filter(function (t) {
    return ((t.target.ownerDocument === doc) && (type != 'touchcancel'));
  }));
  // touches on the same target
  let targetTouches = doc.createTouchList(touches.filter(function (t) {
    return ((t.target === target) && ((type != 'touchcancel') || (type != 'touchend')));
  }));
  // Create changed touches
  let changedTouches = doc.createTouchList(touch);
  // Create the event object
  let event = doc.createEvent('TouchEvent');
  event.initTouchEvent(type,
                       true,
                       true,
                       win,
                       0,
                       false, false, false, false,
                       documentTouches,
                       targetTouches,
                       changedTouches);
  target.dispatchEvent(event);
}

/**
 * Function to dispatch one set of actions
 * @param touches represents all pending touches, batchIndex represents the batch we are dispatching right now
 */
function setDispatch(batches, touches, batchIndex=0) {
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
  let corx;
  let cory;
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
        el = seenEls.get(pack[2], curContainer);
        c = element.coordinates(el, pack[3], pack[4]);
        touch = createATouch(el, c.x, c.y, touchId);
        multiLast[touchId] = touch;
        touches.push(touch);
        emitMultiEvents("touchstart", touch, touches);
        break;

      case "release":
        touch = multiLast[touchId];
        // the index of the previous touch for the finger may change in the touches array
        touchIndex = touches.indexOf(touch);
        touches.splice(touchIndex, 1);
        emitMultiEvents("touchend", touch, touches);
        break;

      case "move":
        el = seenEls.get(pack[2], curContainer);
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
        // since x and y are relative to the last touch, therefore, it's relative to the position of the last touch
        let clientX = lastTouch.clientX + pack[2],
            clientY = lastTouch.clientY + pack[3];
        let pageX = clientX + win.pageXOffset,
            pageY = clientY + win.pageYOffset;
        let screenX = clientX + win.mozInnerScreenX,
            screenY = clientY + win.mozInnerScreenY;
        touch = doc.createTouch(win, el, touchId, pageX, pageY, screenX, screenY, clientX, clientY);
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
    checkTimer.initWithCallback(function() {
      setDispatch(batches, touches, batchIndex);
    }, maxTime, Ci.nsITimer.TYPE_ONE_SHOT);
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
  let commandArray = element.fromJson(
      args, seenEls, curContainer.frame, curContainer.shadowRoot);
  let concurrentEvent = [];
  let temp;
  for (let i = 0; i < maxLen; i++) {
    let row = [];
    for (let j = 0; j < commandArray.length; j++) {
      if (typeof commandArray[j][i] != "undefined") {
        // add finger id to the front of each action, i.e. [finger_id, action, element]
        temp = commandArray[j][i];
        temp.unshift(j);
        row.push(temp);
      }
    }
    concurrentEvent.push(row);
  }

  // now concurrent event is made of sets where each set contain a list of actions that need to be fired.
  // note: each action belongs to a different finger
  // pendingTouches keeps track of current touches that's on the screen
  let pendingTouches = [];
  setDispatch(concurrentEvent, pendingTouches);
}

/*
 * This implements the latter part of a get request (for the case we need to resume one
 * when a remoteness update happens in the middle of a navigate request). This is most of
 * of the work of a navigate request, but doesn't assume DOMContentLoaded is yet to fire.
 */
function pollForReadyState(msg, start = undefined, callback = undefined) {
  let {pageTimeout, url, command_id} = msg.json;
  if (!start) {
    start = new Date().getTime();
  }
  if (!callback) {
    callback = () => {};
  }

  let checkLoad = function() {
    navTimer.cancel();

    let doc = curContainer.frame.document;
    let now = new Date().getTime();
    if (pageTimeout == null || (now - start) <= pageTimeout) {
      // document fully loaded
      if (doc.readyState == "complete") {
        callback();
        sendOk(command_id);

      // document with an insecure cert
      } else if (doc.readyState == "interactive" &&
          doc.baseURI.startsWith("about:certerror")) {
        callback();
        sendError(new InsecureCertificateError(), command_id);

      // we have reached an error url without requesting it
      } else if (doc.readyState == "interactive" &&
          /about:.+(error)\?/.exec(doc.baseURI)) {
        callback();
        sendError(new UnknownError("Reached error page: " + doc.baseURI), command_id);

      // return early for about: urls
      } else if (doc.readyState == "interactive" && doc.baseURI.startsWith("about:")) {
        callback();
        sendOk(command_id);

      // document not fully loaded
      } else {
        navTimer.initWithCallback(checkLoad, 100, Ci.nsITimer.TYPE_ONE_SHOT);
      }

    } else {
      callback();
      sendError(new TimeoutError("Error loading page, timed out (checkLoad)"), command_id);
    }
  };
  checkLoad();
}

/**
 * Navigate to the given URL.  The operation will be performed on the
 * current browsing context, which means it handles the case where we
 * navigate within an iframe.  All other navigation is handled by the
 * driver (in chrome space).
 */
function get(msg) {
  let start = new Date().getTime();
  let {pageTimeout, url, command_id} = msg.json;

  // We need to move to the top frame before navigating
  sendSyncMessage("Marionette:switchedToFrame", {frameValue: null});
  curContainer.frame = content;

  let docShell = curContainer.frame
      .document
      .defaultView
      .QueryInterface(Ci.nsIInterfaceRequestor)
      .getInterface(Ci.nsIWebNavigation)
      .QueryInterface(Ci.nsIDocShell);
  let webProgress = docShell.QueryInterface(Ci.nsIInterfaceRequestor)
      .getInterface(Ci.nsIWebProgress);
  let sawLoad = false;

  let requestedURL;
  let loadEventExpected = false;
  try {
    requestedURL = new URL(url).toString();
    let curURL = curContainer.frame.location;
    loadEventExpected = navigate.isLoadEventExpected(curURL, requestedURL);
  } catch (e) {
    sendError(new InvalidArgumentError("Malformed URL: " + e.message), command_id);
    return;
  }

  // It's possible that a site we're being sent to will end up redirecting
  // us before we end up on a page that fires DOMContentLoaded. We can ensure
  // This loadListener ensures that we don't send a success signal back to
  // the caller until we've seen the load of the requested URL attempted
  // on this frame.
  let loadListener = {
    QueryInterface: XPCOMUtils.generateQI(
        [Ci.nsIWebProgressListener, Ci.nsISupportsWeakReference]),

    onStateChange(webProgress, request, state, status) {
      if (!(request instanceof Ci.nsIChannel)) {
        return;
      }

      const isDocument = state & Ci.nsIWebProgressListener.STATE_IS_DOCUMENT;
      const loadedURL = request.URI.spec;

      // We have to look at the originalURL because of about: pages,
      // the loadedURL is what the about: page resolves to, and is
      // not the one that was requested.
      const originalURL = request.originalURI.spec;
      const isRequestedURL = loadedURL == requestedURL ||
          originalURL == requestedURL;

      if (!isDocument || !isRequestedURL) {
        return;
      }

      // We started loading the requested document. This document
      // might not be the one that ends up firing DOMContentLoaded
      // (if it, for example, redirects), but because we've started
      // loading this URL, we know that any future DOMContentLoaded's
      // are fair game to tell the Marionette client about.
      if (state & Ci.nsIWebProgressListener.STATE_START) {
        sawLoad = true;
      }

      // This indicates network stop or last request stop outside of
      // loading the document.  We hit this when DOMContentLoaded is
      // not triggered, which is the case for image documents.
      else if (state & Ci.nsIWebProgressListener.STATE_STOP &&
          content.document instanceof content.ImageDocument) {
        pollForReadyState(msg, start, () => {
          removeEventListener("DOMContentLoaded", onDOMContentLoaded, false);
        });
      }
    },

    onLocationChange() {},
    onProgressChange() {},
    onStatusChange() {},
    onSecurityChange() {},
  };

  webProgress.addProgressListener(
      loadListener, Ci.nsIWebProgress.NOTIFY_STATE_DOCUMENT);

  // Prevent DOMContentLoaded events from frames from invoking this
  // code, unless the event is coming from the frame associated with
  // the current window (i.e. someone has used switch_to_frame).
  onDOMContentLoaded = function onDOMContentLoaded(event) {
    let frameEl = event.originalTarget.defaultView.frameElement;
    let correctFrame = !frameEl || frameEl == curContainer.frame.frameElement;

    // If the page we're at fired DOMContentLoaded and appears
    // to be the one we asked to load, then we definitely
    // saw the load occur. We need this because for error
    // pages, like about:neterror for unsupported protocols,
    // we don't end up opening a channel that our
    // WebProgressListener can monitor.
    if (curContainer.frame.location == requestedURL) {
      sawLoad = true;
    }

    // We also need to make sure that if the requested URL is not about:blank
    // the DOMContentLoaded we saw isn't for the initial about:blank of a newly
    // created docShell.
    let loadedRequestedURI = (requestedURL == "about:blank") ||
        docShell.hasLoadedNonBlankURI;

    if (correctFrame && sawLoad && loadedRequestedURI) {
      webProgress.removeProgressListener(loadListener);
      pollForReadyState(msg, start, () => {
        removeEventListener("DOMContentLoaded", onDOMContentLoaded, false);
      });
    }
  };

  if (typeof pageTimeout != "undefined") {
    let onTimeout = function() {
      if (loadEventExpected) {
        removeEventListener("DOMContentLoaded", onDOMContentLoaded, false);
      }
      webProgress.removeProgressListener(loadListener);
      sendError(new TimeoutError("Error loading page, timed out (onDOMContentLoaded)"), command_id);
    }
    navTimer.initWithCallback(onTimeout, pageTimeout, Ci.nsITimer.TYPE_ONE_SHOT);
  }

  if (loadEventExpected) {
    addEventListener("DOMContentLoaded", onDOMContentLoaded, false);
  }
  curContainer.frame.location = requestedURL;
  if (!loadEventExpected) {
    sendOk(command_id);
  }
}

/**
 * Cancel the polling and remove the event listener associated with a
 * current navigation request in case we're interupted by an onbeforeunload
 * handler and navigation doesn't complete.
 */
function cancelRequest() {
  navTimer.cancel();
  if (onDOMContentLoaded) {
    removeEventListener("DOMContentLoaded", onDOMContentLoaded, false);
  }
}

/**
 * Get URL of the top-level browsing context.
 */
function getCurrentUrl(isB2G) {
  if (isB2G) {
    return curContainer.frame.location.href;
  } else {
    return content.location.href;
  }
}

/**
 * Get the title of the current browsing context.
 */
function getTitle() {
  return curContainer.frame.top.document.title;
}

/**
 * Get source of the current browsing context's DOM.
 */
function getPageSource() {
  return curContainer.frame.document.documentElement.outerHTML;
}

/**
 * Cause the browser to traverse one step backward in the joint history
 * of the current top-level browsing context.
 */
function goBack() {
  curContainer.frame.history.back();
}

/**
 * Go forward in history
 */
function goForward(msg) {
  curContainer.frame.history.forward();
  sendOk(msg.json.command_id);
}

/**
 * Refresh the page
 */
function refresh(msg) {
  let command_id = msg.json.command_id;
  curContainer.frame.location.reload(true);
  let listen = function() {
    removeEventListener("DOMContentLoaded", listen, false);
    sendOk(command_id);
  };
  addEventListener("DOMContentLoaded", listen, false);
}

/**
 * Find an element in the current browsing context's document using the
 * given search strategy.
 */
function* findElementContent(strategy, selector, opts = {}) {
  if (!SUPPORTED_STRATEGIES.has(strategy)) {
    throw new InvalidSelectorError("Strategy not supported: " + strategy);
  }

  opts.all = false;
  if (opts.startNode) {
    opts.startNode = seenEls.get(opts.startNode, curContainer);
  }

  let el = yield element.find(curContainer, strategy, selector, opts);
  let elRef = seenEls.add(el);
  let webEl = element.makeWebElement(elRef);
  return webEl;
}

/**
 * Find elements in the current browsing context's document using the
 * given search strategy.
 */
function* findElementsContent(strategy, selector, opts = {}) {
  if (!SUPPORTED_STRATEGIES.has(strategy)) {
    throw new InvalidSelectorError("Strategy not supported: " + strategy);
  }

  opts.all = true;
  if (opts.startNode) {
    opts.startNode = seenEls.get(opts.startNode, curContainer);
  }

  let els = yield element.find(curContainer, strategy, selector, opts);
  let elRefs = seenEls.addAll(els);
  let webEls = elRefs.map(element.makeWebElement);
  return webEls;
}

/** Find and return the active element on the page. */
function getActiveElement() {
  let el = curContainer.frame.document.activeElement;
  return element.toJson(el, seenEls);
}

/**
 * Send click event to element.
 *
 * @param {WebElement} id
 *     Reference to the web element to click.
 */
function clickElement(id) {
  let el = seenEls.get(id, curContainer);
  return interaction.clickElement(
      el,
      capabilities.get("moz:accessibilityChecks"),
      capabilities.get("specificationLevel") >= 1);
}

function getElementAttribute(id, name) {
  let el = seenEls.get(id, curContainer);
  if (element.isBooleanAttribute(el, name)) {
    if (el.hasAttribute(name)) {
      return "true";
    } else {
      return null;
    }
  } else {
    return el.getAttribute(name);
  }
}

function getElementProperty(id, name) {
  let el = seenEls.get(id, curContainer);
  return typeof el[name] != "undefined" ? el[name] : null;
}

/**
 * Get the text of this element. This includes text from child elements.
 *
 * @param {WebElement} id
 *     Reference to web element.
 *
 * @return {string}
 *     Text of element.
 */
function getElementText(id) {
  let el = seenEls.get(id, curContainer);
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
function getElementTagName(id) {
  let el = seenEls.get(id, curContainer);
  return el.tagName.toLowerCase();
}

/**
 * Determine the element displayedness of the given web element.
 *
 * Also performs additional accessibility checks if enabled by session
 * capability.
 */
function isElementDisplayed(id) {
  let el = seenEls.get(id, curContainer);
  return interaction.isElementDisplayed(
      el, capabilities.get("moz:accessibilityChecks"));
}

/**
 * Retrieves the computed value of the given CSS property of the given
 * web element.
 *
 * @param {String} id
 *     Web element reference.
 * @param {String} prop
 *     The CSS property to get.
 *
 * @return {String}
 *     Effective value of the requested CSS property.
 */
function getElementValueOfCssProperty(id, prop) {
  let el = seenEls.get(id, curContainer);
  let st = curContainer.frame.document.defaultView.getComputedStyle(el, null);
  return st.getPropertyValue(prop);
}

/**
 * Get the position and dimensions of the element.
 *
 * @param {WebElement} id
 *     Reference to web element.
 *
 * @return {Object.<string, number>}
 *     The x, y, width, and height properties of the element.
 */
function getElementRect(id) {
  let el = seenEls.get(id, curContainer);
  let clientRect = el.getBoundingClientRect();
  return {
    x: clientRect.x + curContainer.frame.pageXOffset,
    y: clientRect.y  + curContainer.frame.pageYOffset,
    width: clientRect.width,
    height: clientRect.height
  };
}

/**
 * Check if element is enabled.
 *
 * @param {WebElement} id
 *     Reference to web element.
 *
 * @return {boolean}
 *     True if enabled, false otherwise.
 */
function isElementEnabled(id) {
  let el = seenEls.get(id, curContainer);
  return interaction.isElementEnabled(
      el, capabilities.get("moz:accessibilityChecks"));
}

/**
 * Determines if the referenced element is selected or not.
 *
 * This operation only makes sense on input elements of the Checkbox-
 * and Radio Button states, or option elements.
 */
function isElementSelected(id) {
  let el = seenEls.get(id, curContainer);
  return interaction.isElementSelected(
      el, capabilities.get("moz:accessibilityChecks"));
}

function* sendKeysToElement(id, val) {
  let el = seenEls.get(id, curContainer);
  if (el.type == "file") {
    let path = val.join("");
    yield interaction.uploadFile(el, path);
  } else {
    yield interaction.sendKeysToElement(
        el, val, false, capabilities.get("moz:accessibilityChecks"));
  }
}

/**
 * Clear the text of an element.
 */
function clearElement(id) {
  try {
    let el = seenEls.get(id, curContainer);
    if (el.type == "file") {
      el.value = null;
    } else {
      atom.clearElement(el, curContainer.frame);
    }
  } catch (e) {
    // Bug 964738: Newer atoms contain status codes which makes wrapping
    // this in an error prototype that has a status property unnecessary
    if (e.name == "InvalidElementStateError") {
      throw new InvalidElementStateError(e.message);
    } else {
      throw e;
    }
  }
}

/**
 * Switch the current context to the specified host's Shadow DOM.
 * @param {WebElement} id
 *     Reference to web element.
 */
function switchToShadowRoot(id) {
  if (!id) {
    // If no host element is passed, attempt to find a parent shadow root or, if
    // none found, unset the current shadow root
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

  let foundShadowRoot;
  let hostEl = seenEls.get(id, curContainer);
  foundShadowRoot = hostEl.shadowRoot;
  if (!foundShadowRoot) {
    throw new NoSuchElementError('Unable to locate shadow root: ' + id);
  }
  curContainer.shadowRoot = foundShadowRoot;
}

/**
 * Switch to the parent frame of the current Frame. If the frame is the top most
 * is the current frame then no action will happen.
 */
 function switchToParentFrame(msg) {
   let command_id = msg.json.command_id;
   curContainer.frame = curContainer.frame.parent;
   let parentElement = seenEls.add(curContainer.frame);

   sendSyncMessage(
       "Marionette:switchedToFrame", {frameValue: parentElement});

   sendOk(msg.json.command_id);
 }

/**
 * Switch to frame given either the server-assigned element id,
 * its index in window.frames, or the iframe's name or id.
 */
function switchToFrame(msg) {
  let command_id = msg.json.command_id;
  function checkLoad() {
    let errorRegex = /about:.+(error)|(blocked)\?/;
    if (curContainer.frame.document.readyState == "complete") {
      sendOk(command_id);
      return;
    } else if (curContainer.frame.document.readyState == "interactive" &&
        errorRegex.exec(curContainer.frame.document.baseURI)) {
      sendError(new UnknownError("Error loading page"), command_id);
      return;
    }
    checkTimer.initWithCallback(checkLoad, 100, Ci.nsITimer.TYPE_ONE_SHOT);
  }
  let foundFrame = null;
  let frames = [];
  let parWindow = null;
  // Check of the curContainer.frame reference is dead
  try {
    frames = curContainer.frame.frames;
    //Until Bug 761935 lands, we won't have multiple nested OOP iframes. We will only have one.
    //parWindow will refer to the iframe above the nested OOP frame.
    parWindow = curContainer.frame.QueryInterface(Ci.nsIInterfaceRequestor)
                      .getInterface(Ci.nsIDOMWindowUtils).outerWindowID;
  } catch (e) {
    // We probably have a dead compartment so accessing it is going to make Firefox
    // very upset. Let's now try redirect everything to the top frame even if the
    // user has given us a frame since search doesnt look up.
    msg.json.id = null;
    msg.json.element = null;
  }

  if ((msg.json.id === null || msg.json.id === undefined) && (msg.json.element == null)) {
    // returning to root frame
    sendSyncMessage("Marionette:switchedToFrame", { frameValue: null });

    curContainer.frame = content;
    if(msg.json.focus == true) {
      curContainer.frame.focus();
    }

    checkTimer.initWithCallback(checkLoad, 100, Ci.nsITimer.TYPE_ONE_SHOT);
    return;
  }

  let id = msg.json.element;
  if (seenEls.has(id)) {
    let wantedFrame;
    try {
      wantedFrame = seenEls.get(id, curContainer);
    } catch (e) {
      sendError(e, command_id);
    }

    if (frames.length > 0) {
      for (let i = 0; i < frames.length; i++) {
        // use XPCNativeWrapper to compare elements; see bug 834266
        if (XPCNativeWrapper(frames[i].frameElement) == XPCNativeWrapper(wantedFrame)) {
          curContainer.frame = frames[i].frameElement;
          foundFrame = i;
        }
      }
    }

    if (foundFrame === null) {
      // Either the frame has been removed or we have a OOP frame
      // so lets just get all the iframes and do a quick loop before
      // throwing in the towel
      let iframes = curContainer.frame.document.getElementsByTagName("iframe");
      for (var i = 0; i < iframes.length; i++) {
        if (XPCNativeWrapper(iframes[i]) == XPCNativeWrapper(wantedFrame)) {
          curContainer.frame = iframes[i];
          foundFrame = i;
        }
      }
    }
  }

  if (foundFrame === null) {
    if (typeof(msg.json.id) === 'number') {
      try {
        foundFrame = frames[msg.json.id].frameElement;
        if (foundFrame !== null) {
          curContainer.frame = foundFrame;
          foundFrame = seenEls.add(curContainer.frame);
        }
        else {
          // If foundFrame is null at this point then we have the top level browsing
          // context so should treat it accordingly.
          sendSyncMessage("Marionette:switchedToFrame", { frameValue: null});
          curContainer.frame = content;
          if(msg.json.focus == true) {
            curContainer.frame.focus();
          }

          checkTimer.initWithCallback(checkLoad, 100, Ci.nsITimer.TYPE_ONE_SHOT);
          return;
        }
      } catch (e) {
        // Since window.frames does not return OOP frames it will throw
        // and we land up here. Let's not give up and check if there are
        // iframes and switch to the indexed frame there
        let iframes = curContainer.frame.document.getElementsByTagName("iframe");
        if (msg.json.id >= 0 && msg.json.id < iframes.length) {
          curContainer.frame = iframes[msg.json.id];
          foundFrame = msg.json.id;
        }
      }
    }
  }

  if (foundFrame === null) {
    sendError(new NoSuchFrameError("Unable to locate frame: " + (msg.json.id || msg.json.element)), command_id);
    return true;
  }

  // send a synchronous message to let the server update the currently active
  // frame element (for getActiveFrame)
  let frameValue = element.toJson(
      curContainer.frame.wrappedJSObject, seenEls)[element.Key];
  sendSyncMessage("Marionette:switchedToFrame", {frameValue: frameValue});

  let rv = null;
  if (curContainer.frame.contentWindow === null) {
    // The frame we want to switch to is a remote/OOP frame;
    // notify our parent to handle the switch
    curContainer.frame = content;
    rv = {win: parWindow, frame: foundFrame};
  } else {
    curContainer.frame = curContainer.frame.contentWindow;
    if (msg.json.focus) {
      curContainer.frame.focus();
    }
    checkTimer.initWithCallback(checkLoad, 100, Ci.nsITimer.TYPE_ONE_SHOT);
  }

  sendResponse(rv, command_id);
}

function addCookie(cookie) {
  cookies.add(cookie.name, cookie.value, cookie);
}

/**
 * Get all cookies for the current domain.
 */
function getCookies() {
  let rv = [];

  for (let cookie of cookies) {
    let expires = cookie.expires;
    // session cookie, don't return an expiry
    if (expires == 0) {
      expires = null;
    // date before epoch time, cap to epoch
    } else if (expires == 1) {
      expires = 0;
    }
    rv.push({
      'name': cookie.name,
      'value': cookie.value,
      'path': cookie.path,
      'domain': cookie.host,
      'secure': cookie.isSecure,
      'httpOnly': cookie.httpOnly,
      'expiry': expires
    });
  }

  return rv;
}

/**
 * Delete a cookie by name.
 */
function deleteCookie(name) {
  cookies.delete(name);
}

/**
 * Delete all the visibile cookies on a page.
 */
function deleteAllCookies() {
  for (let cookie of cookies) {
    cookies.delete(cookie);
  }
}

function getAppCacheStatus(msg) {
  sendResponse(
      curContainer.frame.applicationCache.status, msg.json.command_id);
}

/**
 * Perform a screen capture in content context.
 *
 * Accepted values for |opts|:
 *
 *     @param {UUID=} id
 *         Optional web element reference of an element to take a screenshot
 *         of.
 *     @param {boolean=} full
 *         True to take a screenshot of the entire document element.  Is not
 *         considered if {@code id} is not defined.  Defaults to true.
 *     @param {Array.<UUID>=} highlights
 *         Draw a border around the elements found by their web element
 *         references.
 *     @param {boolean=} scroll
 *         When |id| is given, scroll it into view before taking the
 *         screenshot.  Defaults to true.
 *
 * @param {capture.Format} format
 *     Format to return the screenshot in.
 * @param {Object.<string, ?>} opts
 *     Options.
 *
 * @return {string}
 *     Base64 encoded string or a SHA-256 hash of the screenshot.
 */
function takeScreenshot(format, opts = {}) {
  let id = opts.id;
  let full = !!opts.full;
  let highlights = opts.highlights || [];
  let scroll = !!opts.scroll;

  let highlightEls = highlights.map(ref => seenEls.get(ref, curContainer));

  let canvas;

  // viewport
  if (!id && !full) {
    canvas = capture.viewport(curContainer.frame, highlightEls);

  // element or full document element
  } else {
    let el;
    if (id) {
      el = seenEls.get(id, curContainer);
      if (scroll) {
        element.scrollIntoView(el);
      }
    } else {
      el = curContainer.frame.document.documentElement;
    }

    canvas = capture.element(el, highlightEls);
  }

  switch (format) {
    case capture.Format.Base64:
      return capture.toBase64(canvas);

    case capture.Format.Hash:
      return capture.toHash(canvas);

    default:
      throw new TypeError("Unknown screenshot format: " + format);
  }
}

// Call register self when we get loaded
registerSelf();
