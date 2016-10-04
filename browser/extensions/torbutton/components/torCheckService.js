/*************************************************************************
 * Copyright (c) 2013, The Tor Project, Inc.
 * See LICENSE for licensing information.
 *
 * vim: set sw=2 sts=2 ts=8 et syntax=javascript:
 * 
 * Tor check service
 *************************************************************************/

// Module specific constants
const kMODULE_NAME = "Torbutton Tor Check Service";
const kMODULE_CONTRACTID = "@torproject.org/torbutton-torCheckService;1";
const kMODULE_CID = Components.ID("5d57312b-5d8c-4169-b4af-e80d6a28a72e");

const Cr = Components.results;
const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;

function TBTorCheckService() {
  this._logger = Cc["@torproject.org/torbutton-logger;1"]
                   .getService(Ci.nsISupports).wrappedJSObject;
  this._logger.log(3, "Torbutton Tor Check Service initialized");

  this._statusOfTorCheck = this.kCheckNotInitiated;
  this.wrappedJSObject = this;
}

TBTorCheckService.prototype =
{
  QueryInterface: function(iid) {
    if (!iid.equals(Ci.nsIClassInfo) &&
        !iid.equals(Ci.nsISupports)) {
      Components.returnCode = Cr.NS_ERROR_NO_INTERFACE;
      return null;
    }

    return this;
  },

  kCheckNotInitiated: 0, // Possible values for statusOfTorCheck.
  kCheckSuccessful: 1,
  kCheckFailed: 2,

  wrappedJSObject: null,
  _logger: null,
  _statusOfTorCheck: 0, // this.kCheckNotInitiated,

  // make this an nsIClassInfo object
  flags: Ci.nsIClassInfo.DOM_OBJECT,

  // method of nsIClassInfo
  classDescription: kMODULE_NAME,
  classID: kMODULE_CID,
  contractID: kMODULE_CONTRACTID,

  // method of nsIClassInfo
  getInterfaces: function(count) {
    var interfaceList = [Ci.nsIClassInfo];
    count.value = interfaceList.length;
    return interfaceList;
  },

  // method of nsIClassInfo
  getHelperForLanguage: function(count) { return null; },

  // Public methods.
  get statusOfTorCheck()
  {
    return this._statusOfTorCheck;
  },

  set statusOfTorCheck(aStatus)
  {
    this._statusOfTorCheck = aStatus;
  },

  createCheckRequest: function(aAsync)
  {
    let req = Cc["@mozilla.org/xmlextras/xmlhttprequest;1"]
                      .createInstance(Ci.nsIXMLHttpRequest);
    //let req = new XMLHttpRequest(); Blocked by content policy
    let prefs =  Cc["@mozilla.org/preferences-service;1"]
                   .getService(Ci.nsIPrefBranch);
    let url = prefs.getCharPref("extensions.torbutton.test_url");
    req.open('GET', url, aAsync);
    req.channel.loadFlags |= Ci.nsIRequest.LOAD_BYPASS_CACHE;
    req.overrideMimeType("text/xml");
    req.timeout = 120000;  // Wait at most two minutes for a response.
    return req;
  },

  parseCheckResponse: function(aReq)
  {
    let ret = 0;
    if(aReq.status == 200) {
        if(!aReq.responseXML) {
            this._logger.log(5, "Check failed! Not text/xml!");
            ret = 1;
        } else {
          let result = aReq.responseXML.getElementById('TorCheckResult');

          if(result===null) {
              this._logger.log(5, "Test failed! No TorCheckResult element");
              ret = 2;
          } else if(typeof(result.target) == 'undefined' 
                  || result.target === null) {
              this._logger.log(5, "Test failed! No target");
              ret = 3;
          } else if(result.target === "success") {
              this._logger.log(3, "Test Successful");
              ret = 4;
          } else if(result.target === "failure") {
              this._logger.log(5, "Tor test failed!");
              ret = 5;
          } else if(result.target === "unknown") {
              this._logger.log(5, "Tor test failed. TorDNSEL Failure?");
              ret = 6;
          } else {
              this._logger.log(5, "Tor test failed. Strange target.");
              ret = 7;
          }
        }
      } else {
        if (0 == aReq.status) {
          try {
            var req = aReq.channel.QueryInterface(Ci.nsIRequest);
            if (req.status == Cr.NS_ERROR_PROXY_CONNECTION_REFUSED)
            {
              this._logger.log(5, "Tor test failed. Proxy connection refused");
              ret = 8;
            }
          } catch (e) {}
        }

        if (ret == 0)
        {
          this._logger.log(5, "Tor test failed. HTTP Error: "+aReq.status);
          ret = -aReq.status;
        }
      }

    return ret;
  }
};

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
var NSGetFactory = XPCOMUtils.generateNSGetFactory([TBTorCheckService]);
