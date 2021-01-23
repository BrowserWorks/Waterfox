// -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

ChromeUtils.defineModuleGetter(
  this,
  "Services",
  "resource://gre/modules/Services.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm"
);

class RemoteWebNavigation {
  constructor(aBrowser) {
    this._browser = aBrowser;
    this._cancelContentJSEpoch = 1;
    this._currentURI = null;
    this.canGoBack = false;
    this.canGoForward = false;
    this.referringURI = null;
    this.wrappedJSObject = this;
  }

  swapBrowser(aBrowser) {
    this._browser = aBrowser;
  }

  maybeCancelContentJSExecution(aNavigationType, aOptions = {}) {
    const epoch = this._cancelContentJSEpoch++;
    this._browser.frameLoader.remoteTab.maybeCancelContentJSExecution(
      aNavigationType,
      { ...aOptions, epoch }
    );
    return epoch;
  }

  goBack() {
    let cancelContentJSEpoch = this.maybeCancelContentJSExecution(
      Ci.nsIRemoteTab.NAVIGATE_BACK
    );
    this._sendMessage("WebNavigation:GoBack", { cancelContentJSEpoch });
  }
  goForward() {
    let cancelContentJSEpoch = this.maybeCancelContentJSExecution(
      Ci.nsIRemoteTab.NAVIGATE_FORWARD
    );
    this._sendMessage("WebNavigation:GoForward", { cancelContentJSEpoch });
  }
  gotoIndex(aIndex) {
    let cancelContentJSEpoch = this.maybeCancelContentJSExecution(
      Ci.nsIRemoteTab.NAVIGATE_INDEX,
      { index: aIndex }
    );
    this._sendMessage("WebNavigation:GotoIndex", {
      index: aIndex,
      cancelContentJSEpoch,
    });
  }
  loadURI(aURI, aLoadURIOptions) {
    let uri;
    try {
      let fixupFlags = Services.uriFixup.webNavigationFlagsToFixupFlags(
        aURI,
        aLoadURIOptions.loadFlags
      );
      let isBrowserPrivate = PrivateBrowsingUtils.isBrowserPrivate(
        this._browser
      );
      if (isBrowserPrivate) {
        fixupFlags |= Services.uriFixup.FIXUP_FLAG_PRIVATE_CONTEXT;
      }
      uri = Services.uriFixup.createFixupURI(aURI, fixupFlags);

      // We know the url is going to be loaded, let's start requesting network
      // connection before the content process asks.
      // Note that we might have already setup the speculative connection in
      // some cases, especially when the url is from location bar or its popup
      // menu.
      if (uri.schemeIs("http") || uri.schemeIs("https")) {
        let principal = aLoadURIOptions.triggeringPrincipal;
        // We usually have a triggeringPrincipal assigned, but in case we
        // don't have one or if it's a SystemPrincipal, let's create it with OA
        // inferred from the current context.
        if (!principal || principal.isSystemPrincipal) {
          let attrs = {
            userContextId: this._browser.getAttribute("usercontextid") || 0,
            privateBrowsingId: isBrowserPrivate ? 1 : 0,
          };
          principal = Services.scriptSecurityManager.createContentPrincipal(
            uri,
            attrs
          );
        }
        Services.io.speculativeConnect(uri, principal, null);
      }
    } catch (ex) {
      // Can't setup speculative connection for this uri string for some
      // reason (such as failing to parse the URI), just ignore it.
    }

    let cancelContentJSEpoch = this.maybeCancelContentJSExecution(
      Ci.nsIRemoteTab.NAVIGATE_URL,
      { uri }
    );
    this._browser.frameLoader.browsingContext.loadURI(aURI, {
      ...aLoadURIOptions,
      cancelContentJSEpoch,
    });
  }
  reload(aReloadFlags) {
    this._sendMessage("WebNavigation:Reload", { loadFlags: aReloadFlags });
  }
  stop(aStopFlags) {
    this._sendMessage("WebNavigation:Stop", { loadFlags: aStopFlags });
  }

  get document() {
    return this._browser.contentDocument;
  }

  get currentURI() {
    if (!this._currentURI) {
      this._currentURI = Services.io.newURI("about:blank");
    }
    return this._currentURI;
  }
  set currentURI(aURI) {
    // Bug 1498600 verify usages of systemPrincipal here
    let loadURIOptions = {
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
    };
    this.loadURI(aURI.spec, loadURIOptions);
  }

  // Bug 1233803 - accessing the sessionHistory of remote browsers should be
  // done in content scripts.
  get sessionHistory() {
    throw new Components.Exception(
      "Not implemented",
      Cr.NS_ERROR_NOT_IMPLEMENTED
    );
  }
  set sessionHistory(aValue) {
    throw new Components.Exception(
      "Not implemented",
      Cr.NS_ERROR_NOT_IMPLEMENTED
    );
  }

  _sendMessage(aMessage, aData) {
    try {
      this._browser.sendMessageToActor(aMessage, aData, "WebNavigation");
    } catch (e) {
      Cu.reportError(e);
    }
  }
}

RemoteWebNavigation.prototype.QueryInterface = ChromeUtils.generateQI([
  Ci.nsIWebNavigation,
]);

var EXPORTED_SYMBOLS = ["RemoteWebNavigation"];
