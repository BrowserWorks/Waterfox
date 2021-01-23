/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  Services: "resource://gre/modules/Services.jsm",
  setInterval: "resource://gre/modules/Timer.jsm",
  clearInterval: "resource://gre/modules/Timer.jsm",
});

// Frequency at which to check for new messages
const SYSTEM_TICK_INTERVAL = 5 * 60 * 1000;
const HOMEPAGE_OVERRIDE_PREF = "browser.startup.homepage_override.once";

class _MomentsPageHub {
  constructor() {
    this.id = "moments-page-hub";
    this.state = {};
    this.checkHomepageOverridePref = this.checkHomepageOverridePref.bind(this);
  }

  async init(
    waitForInitialized,
    { handleMessageRequest, addImpression, blockMessageById, dispatch }
  ) {
    this._handleMessageRequest = handleMessageRequest;
    this._addImpression = addImpression;
    this._blockMessageById = blockMessageById;
    this._dispatch = dispatch;

    // Need to wait for ASRouter to initialize before trying to fetch messages
    await waitForInitialized;

    this.messageRequest({
      triggerId: "momentsUpdate",
      template: "update_action",
    });

    const _intervalId = setInterval(
      () => this.checkHomepageOverridePref(),
      SYSTEM_TICK_INTERVAL
    );
    this.state = { _intervalId };
  }

  _sendTelemetry(ping) {
    this._dispatch({
      type: "MOMENTS_PAGE_TELEMETRY",
      data: { action: "moments_user_event", ...ping },
    });
  }

  sendUserEventTelemetry(message) {
    this._sendTelemetry({
      message_id: message.id,
      bucket_id: message.id,
      event: "MOMENTS_PAGE_SET",
    });
  }

  /**
   * If we don't have `expire` defined with the message it could be because
   * it depends on user dependent parameters. Since the message matched
   * targeting we calculate `expire` based on the current timestamp and the
   * `expireDelta` which defines for how long it should be available.
   * @param expireDelta {number} - Offset in milliseconds from the current date
   */
  getExpirationDate(expireDelta) {
    return Date.now() + expireDelta;
  }

  executeAction(message) {
    const { id, data } = message.content.action;
    switch (id) {
      case "moments-wnp":
        const { url, expireDelta } = data;
        let { expire } = data;
        if (!expire) {
          expire = this.getExpirationDate(expireDelta);
        }
        // In order to reset this action we can dispatch a new message that
        // will overwrite the prev value with an expiration date from the past.
        Services.prefs.setStringPref(
          HOMEPAGE_OVERRIDE_PREF,
          JSON.stringify({ message_id: message.id, url, expire })
        );
        // Add impression and block immediately after taking the action
        this.sendUserEventTelemetry(message);
        this._addImpression(message);
        this._blockMessageById(message.id);
        break;
    }
  }

  async messageRequest({ triggerId, template }) {
    const telemetryObject = { triggerId };
    TelemetryStopwatch.start("MS_MESSAGE_REQUEST_TIME_MS", telemetryObject);
    const message = await this._handleMessageRequest({
      triggerId,
      template,
    });
    TelemetryStopwatch.finish("MS_MESSAGE_REQUEST_TIME_MS", telemetryObject);
    if (message) {
      this.executeAction(message);
    }
  }

  /**
   * Pref is set via Remote Settings message. We want to continously
   * monitor new messages that come in to ensure the one with the
   * highest priority is set.
   */
  checkHomepageOverridePref() {
    this.messageRequest({
      triggerId: "momentsUpdate",
      template: "update_action",
    });
  }

  uninit() {
    clearInterval(this.state._intervalId);
    this.state = {};
  }
}

this._MomentsPageHub = _MomentsPageHub;

/**
 * ToolbarBadgeHub - singleton instance of _ToolbarBadgeHub that can initiate
 * message requests and render messages.
 */
this.MomentsPageHub = new _MomentsPageHub();

const EXPORTED_SYMBOLS = ["_MomentsPageHub", "MomentsPageHub"];
