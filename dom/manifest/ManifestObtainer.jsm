/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
 /*
 * ManifestObtainer is an implementation of:
 * http://w3c.github.io/manifest/#obtaining
 *
 * Exposes 2 public method:
 *
 *  .contentObtainManifest(aContent) - used in content process
 *  .browserObtainManifest(aBrowser) - used in browser/parent process
 *
 * both return a promise. If successful, you get back a manifest object.
 *
 * Import it with URL:
 *   'chrome://global/content/manifestMessages.js'
 *
 * e10s IPC message from this components are handled by:
 *   dom/ipc/manifestMessages.js
 *
 * Which is injected into every browser instance via browser.js.
 *
 * exported ManifestObtainer
 */
/*globals Components, Task, PromiseMessage, XPCOMUtils, ManifestProcessor, BrowserUtils*/
"use strict";
const {
  utils: Cu,
  classes: Cc,
  interfaces: Ci
} = Components;
Cu.import("resource://gre/modules/PromiseMessage.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/ManifestProcessor.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "BrowserUtils",  // jshint ignore:line
  "resource://gre/modules/BrowserUtils.jsm");

this.ManifestObtainer = { // jshint ignore:line
  /**
  * Public interface for obtaining a web manifest from a XUL browser, to use
  * on the parent process.
  * @param  {XULBrowser} The browser to check for the manifest.
  * @return {Promise<Object>} The processed manifest.
  */
  async browserObtainManifest(aBrowser) {
    const msgKey = "DOM:ManifestObtainer:Obtain";
    if (!isXULBrowser(aBrowser)) {
      throw new TypeError("Invalid input. Expected XUL browser.");
    }
    const mm = aBrowser.messageManager;
    const {data: {success, result}} = await PromiseMessage.send(mm, msgKey);
    if (!success) {
      const error = toError(result);
      throw error;
    }
    return result;
  },
  /**
   * Public interface for obtaining a web manifest from a XUL browser.
   * @param  {Window} The content Window from which to extract the manifest.
   * @return {Promise<Object>} The processed manifest.
   */
  async contentObtainManifest(aContent) {
    if (!aContent || isXULBrowser(aContent)) {
      throw new TypeError("Invalid input. Expected a DOM Window.");
    }
    let manifest;
    try {
      manifest = await fetchManifest(aContent);
    } catch (err) {
      throw err;
    }
    return manifest;
  }
};

function toError(aErrorClone) {
  let error;
  switch (aErrorClone.name) {
  case "TypeError":
    error = new TypeError();
    break;
  default:
    error = new Error();
  }
  Object.getOwnPropertyNames(aErrorClone)
    .forEach(name => error[name] = aErrorClone[name]);
  return error;
}

function isXULBrowser(aBrowser) {
  if (!aBrowser || !aBrowser.namespaceURI || !aBrowser.localName) {
    return false;
  }
  const XUL = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
  return (aBrowser.namespaceURI === XUL && aBrowser.localName === "browser");
}

/**
 * Asynchronously processes the result of response after having fetched
 * a manifest.
 * @param {Response} aResp Response from fetch().
 * @param {Window} aContentWindow The content window.
 * @return {Promise<Object>} The processed manifest.
 */
const processResponse = async function(aResp, aContentWindow) {
  const badStatus = aResp.status < 200 || aResp.status >= 300;
  if (aResp.type === "error" || badStatus) {
    const msg =
      `Fetch error: ${aResp.status} - ${aResp.statusText} at ${aResp.url}`;
    throw new Error(msg);
  }
  const text = await aResp.text();
  const args = {
    jsonText: text,
    manifestURL: aResp.url,
    docURL: aContentWindow.location.href
  };
  const manifest = ManifestProcessor.process(args);
  return manifest;
};

/**
 * Asynchronously fetches a web manifest.
 * @param {Window} a The content Window from where to extract the manifest.
 * @return {Promise<Object>}
 */
const fetchManifest = async function(aWindow) {
  if (!aWindow || aWindow.top !== aWindow) {
    let msg = "Window must be a top-level browsing context.";
    throw new Error(msg);
  }
  const elem = aWindow.document.querySelector("link[rel~='manifest']");
  if (!elem || !elem.getAttribute("href")) {
    let msg = `No manifest to fetch at ${aWindow.location}`;
    throw new Error(msg);
  }
  // Throws on malformed URLs
  const manifestURL = new aWindow.URL(elem.href, elem.baseURI);
  const reqInit = {
    mode: "cors"
  };
  if (elem.crossOrigin === "use-credentials") {
    reqInit.credentials = "include";
  }
  const request = new aWindow.Request(manifestURL, reqInit);
  request.overrideContentPolicyType(Ci.nsIContentPolicy.TYPE_WEB_MANIFEST);
  let response;
  try {
    response = await aWindow.fetch(request);
  } catch (err) {
    throw err;
  }
  const manifest = await processResponse(response, aWindow);
  return manifest;
};

this.EXPORTED_SYMBOLS = ["ManifestObtainer"]; // jshint ignore:line
