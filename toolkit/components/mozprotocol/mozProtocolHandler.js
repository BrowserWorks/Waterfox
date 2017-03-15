/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/NetUtil.jsm");

function mozProtocolHandler() {
  XPCOMUtils.defineLazyPreferenceGetter(this, "urlToLoad", "toolkit.mozprotocol.url",
                                        "https://www.mozilla.org/protocol");
}

mozProtocolHandler.prototype = {
  scheme: "moz",
  defaultPort: -1,
  protocolFlags: Ci.nsIProtocolHandler.URI_DANGEROUS_TO_LOAD,

  newURI(spec, charset, base) {
    let uri = Cc["@mozilla.org/network/simple-uri;1"].createInstance(Ci.nsIURI);
    if (base) {
      uri.spec = base.resolve(spec);
    } else {
      uri.spec = spec;
    }
    return uri;
  },

  newChannel2(uri, loadInfo) {
    let realURL = NetUtil.newURI(this.urlToLoad);
    let channel = Services.io.newChannelFromURIWithLoadInfo(realURL, loadInfo)
    channel.loadFlags |= Ci.nsIChannel.LOAD_REPLACE;
    return channel;
  },

  newChannel(uri) {
    return this.newChannel(uri, null);
  },

  classID: Components.ID("{47a45e5f-691e-4799-8686-14f8d3fc0f8c}"),

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIProtocolHandler]),
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([mozProtocolHandler]);
