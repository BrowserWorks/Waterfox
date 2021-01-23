/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { ACTIVITY_TYPE } = require("devtools/client/netmonitor/src/constants");
const {
  CDPConnector,
} = require("devtools/client/netmonitor/src/connector/chrome/events");

/**
 * DO NOT DELETE THIS FILE
 *
 * The ChromeConnector is currently not used, but is kept in tree to illustrate
 * the Connector abstraction.
 */
class ChromeConnector {
  constructor() {
    // Internal properties
    this.payloadQueue = [];
    this.connector = undefined;

    // Public methods
    this.connect = this.connect.bind(this);
    this.disconnect = this.disconnect.bind(this);
    this.willNavigate = this.willNavigate.bind(this);
    this.sendHTTPRequest = this.sendHTTPRequest.bind(this);
    this.setPreferences = this.setPreferences.bind(this);
    this.triggerActivity = this.triggerActivity.bind(this);
    this.viewSourceInDebugger = this.viewSourceInDebugger.bind(this);
  }

  async connect(connection, actions, getState) {
    const { tabConnection } = connection;
    this.actions = actions;
    this.connector = new CDPConnector();
    this.connector.setup(tabConnection, this.actions);
    this.connector.willNavigate(this.willNavigate);
  }

  disconnect() {
    this.connector.disconnect();
  }

  pause() {
    this.disconnect();
  }

  resume() {
    this.setup();
  }

  enableActions(enable) {
    // TODO : implement.
  }

  /**
   * currently all events are about "navigation" is not support on CDP
   */
  willNavigate() {
    this.actions.batchReset();
    this.actions.clearRequests();
  }

  /**
   * Triggers a specific "activity" to be performed by the frontend.
   * This can be, for example, triggering reloads or enabling/disabling cache.
   *
   * @param {number} type The activity type. See the ACTIVITY_TYPE const.
   * @return {object} A promise resolved once the activity finishes and the frontend
   *                  is back into "standby" mode.
   */
  triggerActivity(type) {
    switch (type) {
      case ACTIVITY_TYPE.RELOAD.WITH_CACHE_ENABLED:
      case ACTIVITY_TYPE.RELOAD.WITH_CACHE_DEFAULT:
        return this.connector.reset().then(() =>
          this.connector.Page.reload().then(() => {
            this.currentActivity = ACTIVITY_TYPE.NONE;
          })
        );
    }
    this.currentActivity = ACTIVITY_TYPE.NONE;
    return Promise.reject(new Error("Invalid activity type"));
  }

  /**
   * Send a HTTP request data payload
   *
   * @param {object} data data payload would like to sent to backend
   * @param {function} callback callback will be invoked after the request finished
   */
  sendHTTPRequest(data, callback) {
    // TODO : not support. currently didn't provide this feature in CDP API.
  }

  /**
   * Updates the list of block requests
   *
   * @param {array} urls An array of URLS which are blocked
   */
  setBlockedUrls(urls) {
    // TODO : implement.
  }

  setPreferences() {
    // TODO : implement.
  }

  viewSourceInDebugger() {
    // TODO : implement.
  }
}

module.exports = ChromeConnector;
