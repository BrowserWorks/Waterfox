/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["PrivateBrowsingUtils"];

Components.utils.import("resource://gre/modules/Services.jsm");

const kAutoStartPref = "browser.privatebrowsing.autostart";

// This will be set to true when the PB mode is autostarted from the command
// line for the current session.
var gTemporaryAutoStartMode = false;

const Cc = Components.classes;
const Ci = Components.interfaces;

this.PrivateBrowsingUtils = {
  // Rather than passing content windows to this function, please use
  // isBrowserPrivate since it works with e10s.
  isWindowPrivate: function pbu_isWindowPrivate(aWindow) {
    if (!(aWindow instanceof Components.interfaces.nsIDOMChromeWindow)) {
      dump("WARNING: content window passed to PrivateBrowsingUtils.isWindowPrivate. " +
           "Use isContentWindowPrivate instead (but only for frame scripts).\n"
           + new Error().stack);
    }

    return this.privacyContextFromWindow(aWindow).usePrivateBrowsing;
  },

  // This should be used only in frame scripts.
  isContentWindowPrivate: function pbu_isWindowPrivate(aWindow) {
    return this.privacyContextFromWindow(aWindow).usePrivateBrowsing;
  },

  isBrowserPrivate(aBrowser) {
    let chromeWin = aBrowser.ownerGlobal;
    if (chromeWin.gMultiProcessBrowser || !aBrowser.isConnected) {
      // In e10s we have to look at the chrome window's private
      // browsing status since the only alternative is to check the
      // content window, which is in another process.  If the browser
      // is lazy then the content window doesn't exist.
      return this.isWindowPrivate(chromeWin);
    }
    return this.privacyContextFromWindow(aBrowser.contentWindow).usePrivateBrowsing;
  },

  privacyContextFromWindow: function pbu_privacyContextFromWindow(aWindow) {
    return aWindow.QueryInterface(Ci.nsIInterfaceRequestor)
                  .getInterface(Ci.nsIWebNavigation)
                  .QueryInterface(Ci.nsILoadContext);
  },

  addToTrackingAllowlist(aURI) {
    let pbmtpWhitelist = Cc["@mozilla.org/pbm-tp-whitelist;1"]
                           .getService(Ci.nsIPrivateBrowsingTrackingProtectionWhitelist);
    pbmtpWhitelist.addToAllowList(aURI);
  },

  removeFromTrackingAllowlist(aURI) {
    let pbmtpWhitelist = Cc["@mozilla.org/pbm-tp-whitelist;1"]
                           .getService(Ci.nsIPrivateBrowsingTrackingProtectionWhitelist);
    pbmtpWhitelist.removeFromAllowList(aURI);
  },

  get permanentPrivateBrowsing() {
    try {
      return gTemporaryAutoStartMode ||
             Services.prefs.getBoolPref(kAutoStartPref);
    } catch (e) {
      // The pref does not exist
      return false;
    }
  },

  // These should only be used from internal code
  enterTemporaryAutoStartMode: function pbu_enterTemporaryAutoStartMode() {
    gTemporaryAutoStartMode = true;
  },
  get isInTemporaryAutoStartMode() {
    return gTemporaryAutoStartMode;
  },
};

