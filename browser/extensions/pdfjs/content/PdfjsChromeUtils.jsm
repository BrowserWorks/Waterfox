/* Copyright 2012 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

var EXPORTED_SYMBOLS = ["PdfjsChromeUtils"];

const PREF_PREFIX = "pdfjs";

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "PdfJsDefaultPreferences",
  "resource://pdf.js/PdfJsDefaultPreferences.jsm"
);

var Svc = {};
XPCOMUtils.defineLazyServiceGetter(
  Svc,
  "mime",
  "@mozilla.org/mime;1",
  "nsIMIMEService"
);

XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "matchesCountLimit",
  "accessibility.typeaheadfind.matchesCountLimit"
);

var PdfjsChromeUtils = {
  // For security purposes when running remote, we restrict preferences
  // content can access.
  _allowedPrefNames: Object.keys(PdfJsDefaultPreferences),
  _ppmm: null,
  _mmg: null,

  /*
   * Public API
   */

  init() {
    this._browsers = new WeakSet();
    if (!this._ppmm) {
      // global parent process message manager (PPMM)
      this._ppmm = Services.ppmm;
      this._ppmm.addMessageListener("PDFJS:Parent:clearUserPref", this);
      this._ppmm.addMessageListener("PDFJS:Parent:setIntPref", this);
      this._ppmm.addMessageListener("PDFJS:Parent:setBoolPref", this);
      this._ppmm.addMessageListener("PDFJS:Parent:setCharPref", this);
      this._ppmm.addMessageListener("PDFJS:Parent:setStringPref", this);

      // global dom message manager (MMg)
      this._mmg = Services.mm;
      this._mmg.addMessageListener("PDFJS:Parent:displayWarning", this);

      this._mmg.addMessageListener("PDFJS:Parent:addEventListener", this);
      this._mmg.addMessageListener("PDFJS:Parent:removeEventListener", this);
      this._mmg.addMessageListener("PDFJS:Parent:updateControlState", this);
      this._mmg.addMessageListener("PDFJS:Parent:updateMatchesCount", this);

      // Observer to handle shutdown.
      Services.obs.addObserver(this, "quit-application");
    }
  },

  uninit() {
    if (this._ppmm) {
      this._ppmm.removeMessageListener("PDFJS:Parent:clearUserPref", this);
      this._ppmm.removeMessageListener("PDFJS:Parent:setIntPref", this);
      this._ppmm.removeMessageListener("PDFJS:Parent:setBoolPref", this);
      this._ppmm.removeMessageListener("PDFJS:Parent:setCharPref", this);
      this._ppmm.removeMessageListener("PDFJS:Parent:setStringPref", this);

      this._mmg.removeMessageListener("PDFJS:Parent:displayWarning", this);

      this._mmg.removeMessageListener("PDFJS:Parent:addEventListener", this);
      this._mmg.removeMessageListener("PDFJS:Parent:removeEventListener", this);
      this._mmg.removeMessageListener("PDFJS:Parent:updateControlState", this);
      this._mmg.removeMessageListener("PDFJS:Parent:updateMatchesCount", this);

      Services.obs.removeObserver(this, "quit-application");

      this._mmg = null;
      this._ppmm = null;
    }
  },

  /*
   * Events
   */

  observe(aSubject, aTopic, aData) {
    if (aTopic === "quit-application") {
      this.uninit();
    }
  },

  receiveMessage(aMsg) {
    switch (aMsg.name) {
      case "PDFJS:Parent:clearUserPref":
        this._clearUserPref(aMsg.data.name);
        break;
      case "PDFJS:Parent:setIntPref":
        this._setIntPref(aMsg.data.name, aMsg.data.value);
        break;
      case "PDFJS:Parent:setBoolPref":
        this._setBoolPref(aMsg.data.name, aMsg.data.value);
        break;
      case "PDFJS:Parent:setCharPref":
        this._setCharPref(aMsg.data.name, aMsg.data.value);
        break;
      case "PDFJS:Parent:setStringPref":
        this._setStringPref(aMsg.data.name, aMsg.data.value);
        break;
      case "PDFJS:Parent:displayWarning":
        this._displayWarning(aMsg);
        break;

      case "PDFJS:Parent:updateControlState":
        return this._updateControlState(aMsg);
      case "PDFJS:Parent:updateMatchesCount":
        return this._updateMatchesCount(aMsg);
      case "PDFJS:Parent:addEventListener":
        return this._addEventListener(aMsg);
      case "PDFJS:Parent:removeEventListener":
        return this._removeEventListener(aMsg);
    }
    return undefined;
  },

  /*
   * Internal
   */

  _updateControlState(aMsg) {
    let data = aMsg.data;
    let browser = aMsg.target;
    let tabbrowser = browser.getTabBrowser();
    let tab = tabbrowser.getTabForBrowser(browser);
    tabbrowser.getFindBar(tab).then(fb => {
      if (!fb) {
        // The tab or window closed.
        return;
      }
      fb.updateControlState(data.result, data.findPrevious);

      const matchesCount = this._requestMatchesCount(data.matchesCount);
      fb.onMatchesCountResult(matchesCount);
    });
  },

  _updateMatchesCount(aMsg) {
    let data = aMsg.data;
    let browser = aMsg.target;
    let tabbrowser = browser.getTabBrowser();
    let tab = tabbrowser.getTabForBrowser(browser);
    tabbrowser.getFindBar(tab).then(fb => {
      if (!fb) {
        // The tab or window closed.
        return;
      }
      const matchesCount = this._requestMatchesCount(data);
      fb.onMatchesCountResult(matchesCount);
    });
  },

  _requestMatchesCount(data) {
    if (!data) {
      return { current: 0, total: 0 };
    }
    let result = {
      current: data.current,
      total: data.total,
      limit: typeof matchesCountLimit === "number" ? matchesCountLimit : 0,
    };
    if (result.total > result.limit) {
      result.total = -1;
    }
    return result;
  },

  handleEvent(aEvent) {
    const type = aEvent.type;
    // Handle the tab find initialized event specially:
    if (type == "TabFindInitialized") {
      let browser = aEvent.target.linkedBrowser;
      this._hookupEventListeners(browser);
      aEvent.target.removeEventListener(type, this);
      return;
    }

    // To avoid forwarding the message as a CPOW, create a structured cloneable
    // version of the event for both performance, and ease of usage, reasons.
    let detail = null;
    if (type !== "findbarclose") {
      detail = {
        query: aEvent.detail.query,
        caseSensitive: aEvent.detail.caseSensitive,
        entireWord: aEvent.detail.entireWord,
        highlightAll: aEvent.detail.highlightAll,
        findPrevious: aEvent.detail.findPrevious,
      };
    }

    let browser = aEvent.currentTarget.browser;
    if (!this._browsers.has(browser)) {
      throw new Error(
        "FindEventManager was not bound for the current browser."
      );
    }
    // Only forward the events if the current browser is a registered browser.
    let mm = browser.messageManager;
    mm.sendAsyncMessage("PDFJS:Child:handleEvent", { type, detail });
    aEvent.preventDefault();
  },

  _types: [
    "find",
    "findagain",
    "findhighlightallchange",
    "findcasesensitivitychange",
    "findbarclose",
  ],

  _addEventListener(aMsg) {
    let browser = aMsg.target;
    if (this._browsers.has(browser)) {
      throw new Error(
        "FindEventManager was bound 2nd time without unbinding it first."
      );
    }

    // Since this jsm is global, we need to store all the browsers
    // we have to forward the messages for.
    this._browsers.add(browser);

    this._hookupEventListeners(browser);
  },

  /**
   * Either hook up all the find event listeners if a findbar exists,
   * or listen for a find bar being created and hook up event listeners
   * when it does get created.
   */
  _hookupEventListeners(aBrowser) {
    let tabbrowser = aBrowser.getTabBrowser();
    let tab = tabbrowser.getTabForBrowser(aBrowser);
    let findbar = tabbrowser.getCachedFindBar(tab);
    if (findbar) {
      // And we need to start listening to find events.
      for (var i = 0; i < this._types.length; i++) {
        var type = this._types[i];
        findbar.addEventListener(type, this, true);
      }
    } else {
      tab.addEventListener("TabFindInitialized", this);
    }
    return !!findbar;
  },

  _removeEventListener(aMsg) {
    let browser = aMsg.target;
    if (!this._browsers.has(browser)) {
      throw new Error("FindEventManager was unbound without binding it first.");
    }

    this._browsers.delete(browser);

    let tabbrowser = browser.getTabBrowser();
    let tab = tabbrowser.getTabForBrowser(browser);
    tab.removeEventListener("TabFindInitialized", this);
    let findbar = tabbrowser.getCachedFindBar(tab);
    if (findbar) {
      // No reason to listen to find events any longer.
      for (var i = 0; i < this._types.length; i++) {
        var type = this._types[i];
        findbar.removeEventListener(type, this, true);
      }
    }
  },

  _ensurePreferenceAllowed(aPrefName) {
    let unPrefixedName = aPrefName.split(PREF_PREFIX + ".");
    if (
      unPrefixedName[0] !== "" ||
      !this._allowedPrefNames.includes(unPrefixedName[1])
    ) {
      let msg =
        '"' +
        aPrefName +
        '" ' +
        "can't be accessed from content. See PdfjsChromeUtils.";
      throw new Error(msg);
    }
  },

  _clearUserPref(aPrefName) {
    this._ensurePreferenceAllowed(aPrefName);
    Services.prefs.clearUserPref(aPrefName);
  },

  _setIntPref(aPrefName, aPrefValue) {
    this._ensurePreferenceAllowed(aPrefName);
    Services.prefs.setIntPref(aPrefName, aPrefValue);
  },

  _setBoolPref(aPrefName, aPrefValue) {
    this._ensurePreferenceAllowed(aPrefName);
    Services.prefs.setBoolPref(aPrefName, aPrefValue);
  },

  _setCharPref(aPrefName, aPrefValue) {
    this._ensurePreferenceAllowed(aPrefName);
    Services.prefs.setCharPref(aPrefName, aPrefValue);
  },

  _setStringPref(aPrefName, aPrefValue) {
    this._ensurePreferenceAllowed(aPrefName);
    Services.prefs.setStringPref(aPrefName, aPrefValue);
  },

  /*
   * Display a notification warning when the renderer isn't sure
   * a pdf displayed correctly.
   */
  _displayWarning(aMsg) {
    let data = aMsg.data;
    let browser = aMsg.target;

    let tabbrowser = browser.getTabBrowser();
    let notificationBox = tabbrowser.getNotificationBox(browser);

    // Flag so we don't send the message twice, since if the user clicks
    // "open with different viewer" both the button callback and
    // eventCallback will be called.
    let messageSent = false;
    function sendMessage(download) {
      let mm = browser.messageManager;
      mm.sendAsyncMessage("PDFJS:Child:fallbackDownload", { download });
    }
    let buttons = [
      {
        label: data.label,
        accessKey: data.accessKey,
        callback() {
          messageSent = true;
          sendMessage(true);
        },
      },
    ];
    notificationBox.appendNotification(
      data.message,
      "pdfjs-fallback",
      null,
      notificationBox.PRIORITY_WARNING_LOW,
      buttons,
      function eventsCallback(eventType) {
        // Currently there is only one event "removed" but if there are any other
        // added in the future we still only care about removed at the moment.
        if (eventType !== "removed") {
          return;
        }
        // Don't send a response again if we already responded when the button was
        // clicked.
        if (messageSent) {
          return;
        }
        sendMessage(false);
      }
    );
  },
};
