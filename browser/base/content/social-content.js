/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* This content script is intended for use by iframes in the share panel. */

/* eslint-env mozilla/frame-script */

var {interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

// social frames are always treated as app tabs
docShell.isAppTab = true;

addEventListener("DOMContentLoaded", function(event) {
  if (event.target != content.document)
    return;
  // Some share panels (e.g. twitter and facebook) check content.opener, and if
  // it doesn't exist they act like they are in a browser tab.  We want them to
  // act like they are in a dialog (which is the typical case).
  if (content && !content.opener) {
    content.opener = content;
  }
  hookWindowClose();
  disableDialogs();
});

addMessageListener("Social:OpenGraphData", (message) => {
  let ev = new content.CustomEvent("OpenGraphData", { detail: JSON.stringify(message.data) });
  content.dispatchEvent(ev);
});

addMessageListener("Social:ClearFrame", () => {
  docShell.createAboutBlankContentViewer(null);
});

addEventListener("DOMWindowClose", (evt) => {
  // preventDefault stops the default window.close() function being called,
  // which doesn't actually close anything but causes things to get into
  // a bad state (an internal 'closed' flag is set and debug builds start
  // asserting as the window is used.).
  // None of the windows we inject this API into are suitable for this
  // default close behaviour, so even if we took no action above, we avoid
  // the default close from doing anything.
  evt.preventDefault();

  // Tells the SocialShare class to close the panel
  sendAsyncMessage("Social:DOMWindowClose");
});

function hookWindowClose() {
  // Allow scripts to close the "window".  Because we are in a panel and not
  // in a full dialog, the DOMWindowClose listener above will only receive the
  // event if we do this.
  let dwu = content.QueryInterface(Ci.nsIInterfaceRequestor)
     .getInterface(Ci.nsIDOMWindowUtils);
  dwu.allowScriptsToClose();
}

function disableDialogs() {
  let windowUtils = content.QueryInterface(Ci.nsIInterfaceRequestor).
                    getInterface(Ci.nsIDOMWindowUtils);
  windowUtils.disableDialogs();
}

// Error handling class used to listen for network errors in the social frames
// and replace them with a social-specific error page
const SocialErrorListener = {
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIDOMEventListener,
                                         Ci.nsIWebProgressListener,
                                         Ci.nsISupportsWeakReference,
                                         Ci.nsISupports]),

  defaultTemplate: "about:socialerror?mode=tryAgainOnly&url=%{url}&origin=%{origin}",
  urlTemplate: null,

  init() {
    addMessageListener("Social:SetErrorURL", this);
    let webProgress = docShell.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                              .getInterface(Components.interfaces.nsIWebProgress);
    webProgress.addProgressListener(this, Ci.nsIWebProgress.NOTIFY_STATE_REQUEST |
                                          Ci.nsIWebProgress.NOTIFY_LOCATION);
  },

  receiveMessage(message) {
    switch (message.name) {
      case "Social:SetErrorURL":
        // Either a url or null to reset to default template.
        this.urlTemplate = message.data.template;
        break;
    }
  },

  setErrorPage() {
    // if this is about:providerdirectory, use the directory iframe
    let frame = docShell.chromeEventHandler;
    let origin = frame.getAttribute("origin");
    let src = frame.getAttribute("src");
    if (src == "about:providerdirectory") {
      frame = content.document.getElementById("activation-frame");
      src = frame.getAttribute("src");
    }

    let url = this.urlTemplate || this.defaultTemplate;
    url = url.replace("%{url}", encodeURIComponent(src));
    url = url.replace("%{origin}", encodeURIComponent(origin));
    if (frame != docShell.chromeEventHandler) {
      // Unable to access frame.docShell here. This is our own frame and doesn't
      // provide reload, so we'll just set the src.
      frame.setAttribute("src", url);
    } else {
      let webNav = docShell.QueryInterface(Ci.nsIWebNavigation);
      webNav.loadURI(url, null, null, null, null);
    }
    sendAsyncMessage("Social:ErrorPageNotify", {
        origin,
        url: src
    });
  },

  onStateChange(aWebProgress, aRequest, aState, aStatus) {
    let failure = false;
    if ((aState & Ci.nsIWebProgressListener.STATE_IS_REQUEST))
      return;
    if ((aState & Ci.nsIWebProgressListener.STATE_STOP)) {
      if (aRequest instanceof Ci.nsIHttpChannel) {
        try {
          // Change the frame to an error page on 4xx (client errors)
          // and 5xx (server errors).  responseStatus throws if it is not set.
          failure = aRequest.responseStatus >= 400 &&
                    aRequest.responseStatus < 600;
        } catch (e) {
          failure = aStatus != Components.results.NS_OK;
        }
      }
    }

    // Calling cancel() will raise some OnStateChange notifications by itself,
    // so avoid doing that more than once
    if (failure && aStatus != Components.results.NS_BINDING_ABORTED) {
      // if tp is enabled and we get a failure, ignore failures (ie. STATE_STOP)
      // on child resources since they *may* have been blocked. We don't have an
      // easy way to know if a particular url is blocked by TP, only that
      // something was.
      if (docShell.hasTrackingContentBlocked) {
        let frame = docShell.chromeEventHandler;
        let src = frame.getAttribute("src");
        if (aRequest && aRequest.name != src) {
          Cu.reportError("SocialErrorListener ignoring blocked content error for " + aRequest.name);
          return;
        }
      }

      aRequest.cancel(Components.results.NS_BINDING_ABORTED);
      this.setErrorPage();
    }
  },

  onLocationChange(aWebProgress, aRequest, aLocation, aFlags) {
    if (aRequest && aFlags & Ci.nsIWebProgressListener.LOCATION_CHANGE_ERROR_PAGE) {
      aRequest.cancel(Components.results.NS_BINDING_ABORTED);
      this.setErrorPage();
    }
  },
};

SocialErrorListener.init();
