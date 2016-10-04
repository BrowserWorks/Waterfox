/*************************************************************************
 * Copyright (c) 2013, The Tor Project, Inc.
 * See LICENSE for licensing information.
 *
 * vim: set sw=2 sts=2 ts=8 et syntax=javascript:
 * 
 * about:tor component
 *************************************************************************/

// Module specific constants
const kMODULE_NAME = "about:tor";
const kMODULE_CONTRACTID = "@mozilla.org/network/protocol/about;1?what=tor";
const kMODULE_CID = Components.ID("84d47da6-79c3-4661-aa9f-8049476f7bf5");

const kAboutTorURL = "chrome://torbutton/content/aboutTor/aboutTor.xhtml";

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;
 
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
 
function AboutTor()
{
}


AboutTor.prototype =
{
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIAboutModule]),

  // nsIClassInfo implementation:
  classDescription: kMODULE_NAME,
  classID: kMODULE_CID,
  contractID: kMODULE_CONTRACTID,

  // nsIAboutModule implementation:
  newChannel: function(aURI)
  {
    let ioSvc = Cc["@mozilla.org/network/io-service;1"]
                  .getService(Ci.nsIIOService);
    let channel = ioSvc.newChannel(kAboutTorURL, null, null);
    channel.originalURI = aURI;

    return channel;
  },

  getURIFlags: function(aURI)
  {
    return Ci.nsIAboutModule.ALLOW_SCRIPT;
  }
};


const NSGetFactory = XPCOMUtils.generateNSGetFactory([AboutTor]);
