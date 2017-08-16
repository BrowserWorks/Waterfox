/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Dumping ground for simple services for which the isolation of a full global
 * is overkill. Be careful about namespace pollution, and be mindful about
 * importing lots of JSMs in global scope, since this file will almost certainly
 * be loaded from enough callsites that any such imports will always end up getting
 * eagerly loaded at startup.
 */

"use strict";

const Cc = Components.classes;
const Cu = Components.utils;
const Ci = Components.interfaces;
const Cr = Components.results;

/* globals WebExtensionPolicy */

Cu.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "NetUtil",
                                  "resource://gre/modules/NetUtil.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Services",
                                  "resource://gre/modules/Services.jsm");

/*
 * This class provides a stream filter for locale messages in CSS files served
 * by the moz-extension: protocol handler.
 *
 * See SubstituteChannel in netwerk/protocol/res/ExtensionProtocolHandler.cpp
 * for usage.
 */
function AddonLocalizationConverter() {
}

AddonLocalizationConverter.prototype = {
  classID: Components.ID("{ded150e3-c92e-4077-a396-0dba9953e39f}"),
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIStreamConverter]),

  FROM_TYPE: "application/vnd.mozilla.webext.unlocalized",
  TO_TYPE: "text/css",

  checkTypes(aFromType, aToType) {
    if (aFromType != this.FROM_TYPE) {
      throw Components.Exception("Invalid aFromType value", Cr.NS_ERROR_INVALID_ARG,
                                 Components.stack.caller.caller);
    }
    if (aToType != this.TO_TYPE) {
      throw Components.Exception("Invalid aToType value", Cr.NS_ERROR_INVALID_ARG,
                                 Components.stack.caller.caller);
    }
  },

  // aContext must be a nsIURI object for a valid moz-extension: URL.
  getAddon(aContext) {
    // In this case, we want the add-on ID even if the URL is web accessible,
    // so check the root rather than the exact path.
    let uri = Services.io.newURI("/", null, aContext);

    let addon = WebExtensionPolicy.getByURI(uri);
    if (!addon) {
      throw new Components.Exception("Invalid context", Cr.NS_ERROR_INVALID_ARG);
    }
    return addon;
  },

  convertToStream(aAddon, aString) {
    let stream = Cc["@mozilla.org/io/string-input-stream;1"]
      .createInstance(Ci.nsIStringInputStream);

    stream.data = aAddon.localize(aString);
    return stream;
  },

  convert(aStream, aFromType, aToType, aContext) {
    this.checkTypes(aFromType, aToType);
    let addon = this.getAddon(aContext);

    let string = (
      aStream.available() ?
      NetUtil.readInputStreamToString(aStream, aStream.available()) : ""
    );
    return this.convertToStream(addon, string);
  },

  asyncConvertData(aFromType, aToType, aListener, aContext) {
    this.checkTypes(aFromType, aToType);
    this.addon = this.getAddon(aContext);
    this.listener = aListener;
  },

  onStartRequest(aRequest, aContext) {
    this.parts = [];
  },

  onDataAvailable(aRequest, aContext, aInputStream, aOffset, aCount) {
    this.parts.push(NetUtil.readInputStreamToString(aInputStream, aCount));
  },

  onStopRequest(aRequest, aContext, aStatusCode) {
    try {
      this.listener.onStartRequest(aRequest, null);
      if (Components.isSuccessCode(aStatusCode)) {
        let string = this.parts.join("");
        let stream = this.convertToStream(this.addon, string);

        this.listener.onDataAvailable(aRequest, null, stream, 0, stream.data.length);
      }
    } catch (e) {
      aStatusCode = e.result || Cr.NS_ERROR_FAILURE;
    }
    this.listener.onStopRequest(aRequest, null, aStatusCode);
  },
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([AddonLocalizationConverter]);
