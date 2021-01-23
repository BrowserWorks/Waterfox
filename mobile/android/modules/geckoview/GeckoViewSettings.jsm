/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["GeckoViewSettings"];

const { GeckoViewModule } = ChromeUtils.import(
  "resource://gre/modules/GeckoViewModule.jsm"
);

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  Services: "resource://gre/modules/Services.jsm",
});

XPCOMUtils.defineLazyGetter(this, "MOBILE_USER_AGENT", function() {
  return Cc["@mozilla.org/network/protocol;1?name=http"].getService(
    Ci.nsIHttpProtocolHandler
  ).userAgent;
});

XPCOMUtils.defineLazyGetter(this, "DESKTOP_USER_AGENT", function() {
  return MOBILE_USER_AGENT.replace(
    /Android \d.+?; [a-zA-Z]+/,
    "X11; Linux x86_64"
  ).replace(/Gecko\/[0-9\.]+/, "Gecko/20100101");
});

XPCOMUtils.defineLazyGetter(this, "VR_USER_AGENT", function() {
  return MOBILE_USER_AGENT.replace(/Mobile/, "Mobile VR");
});

// This needs to match GeckoSessionSettings.java
const USER_AGENT_MODE_MOBILE = 0;
const USER_AGENT_MODE_DESKTOP = 1;
const USER_AGENT_MODE_VR = 2;

// Handles GeckoSession settings.
class GeckoViewSettings extends GeckoViewModule {
  static get useMultiprocess() {
    return Services.prefs.getBoolPref("browser.tabs.remote.autostart", true);
  }

  onInit() {
    debug`onInit`;
    this._userAgentMode = USER_AGENT_MODE_MOBILE;
    this._userAgentOverride = null;
    this._sessionContextId = null;

    this.registerListener(["GeckoView:GetUserAgent"]);
  }

  onEvent(aEvent, aData, aCallback) {
    debug`onEvent ${aEvent} ${aData}`;

    switch (aEvent) {
      case "GeckoView:GetUserAgent": {
        aCallback.onSuccess(this.userAgent);
      }
    }
  }

  onSettingsUpdate() {
    const settings = this.settings;
    debug`onSettingsUpdate: ${settings}`;

    this.displayMode = settings.displayMode;
    this.unsafeSessionContextId = settings.unsafeSessionContextId;
    this.userAgentMode = settings.userAgentMode;
    this.userAgentOverride = settings.userAgentOverride;
    this.sessionContextId = settings.sessionContextId;
    this.suspendMediaWhenInactive = settings.suspendMediaWhenInactive;
  }

  get userAgent() {
    if (this.userAgentOverride !== null) {
      return this.userAgentOverride;
    }
    if (this.userAgentMode === USER_AGENT_MODE_DESKTOP) {
      return DESKTOP_USER_AGENT;
    }
    if (this.userAgentMode === USER_AGENT_MODE_VR) {
      return VR_USER_AGENT;
    }
    return MOBILE_USER_AGENT;
  }

  get userAgentMode() {
    return this._userAgentMode;
  }

  set userAgentMode(aMode) {
    if (this.userAgentMode === aMode) {
      return;
    }
    this._userAgentMode = aMode;
  }

  get userAgentOverride() {
    return this._userAgentOverride;
  }

  set userAgentOverride(aUserAgent) {
    this._userAgentOverride = aUserAgent;
  }

  get suspendMediaWhenInactive() {
    return this.browser.suspendMediaWhenInactive;
  }

  set suspendMediaWhenInactive(aSuspendMediaWhenInactive) {
    if (aSuspendMediaWhenInactive != this.browser.suspendMediaWhenInactive) {
      this.browser.suspendMediaWhenInactive = aSuspendMediaWhenInactive;
    }
  }

  get displayMode() {
    return this.window.docShell.displayMode;
  }

  set displayMode(aMode) {
    this.window.docShell.displayMode = aMode;
  }

  set sessionContextId(aAttribute) {
    this._sessionContextId = aAttribute;
  }

  get sessionContextId() {
    return this._sessionContextId;
  }
}

const { debug, warn } = GeckoViewSettings.initLogging("GeckoViewSettings"); // eslint-disable-line no-unused-vars
