/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {Utils: WebConsoleUtils} = require("devtools/client/webconsole/utils");
const EventEmitter = require("devtools/shared/event-emitter");
const promise = require("promise");
const defer = require("devtools/shared/defer");
const Services = require("Services");
const { gDevTools } = require("devtools/client/framework/devtools");
const { JSTerm } = require("devtools/client/webconsole/jsterm");
const { WebConsoleConnectionProxy } = require("devtools/client/webconsole/webconsole-connection-proxy");
const KeyShortcuts = require("devtools/client/shared/key-shortcuts");
const { l10n } = require("devtools/client/webconsole/new-console-output/utils/messages");
const system = require("devtools/shared/system");
const { ZoomKeys } = require("devtools/client/shared/zoom-keys");

const PREF_MESSAGE_TIMESTAMP = "devtools.webconsole.timestampMessages";
const PREF_PERSISTLOG = "devtools.webconsole.persistlog";

// XXX: This file is incomplete (see bug 1326937).
// It's used when loading the webconsole with devtools-launchpad, but will ultimately be
// the entry point for the new frontend

/**
 * A WebConsoleFrame instance is an interactive console initialized *per target*
 * that displays console log data as well as provides an interactive terminal to
 * manipulate the target's document content.
 *
 * The WebConsoleFrame is responsible for the actual Web Console UI
 * implementation.
 *
 * @constructor
 * @param object webConsoleOwner
 *        The WebConsole owner object.
 */
function NewWebConsoleFrame(webConsoleOwner) {
  this.owner = webConsoleOwner;
  this.hudId = this.owner.hudId;
  this.isBrowserConsole = this.owner._browserConsole;
  this.NEW_CONSOLE_OUTPUT_ENABLED = true;
  this.window = this.owner.iframeWindow;

  this._onToolboxPrefChanged = this._onToolboxPrefChanged.bind(this);

  EventEmitter.decorate(this);
}
NewWebConsoleFrame.prototype = {
  /**
   * Getter for the debugger WebConsoleClient.
   * @type object
   */
  get webConsoleClient() {
    return this.proxy ? this.proxy.webConsoleClient : null;
  },

  /**
   * Getter for the persistent logging preference.
   * @type boolean
   */
  get persistLog() {
    // For the browser console, we receive tab navigation
    // when the original top level window we attached to is closed,
    // but we don't want to reset console history and just switch to
    // the next available window.
    return this.isBrowserConsole ||
           Services.prefs.getBoolPref(PREF_PERSISTLOG);
  },

  /**
   * Initialize the WebConsoleFrame instance.
   * @return object
   *         A promise object that resolves once the frame is ready to use.
   */
  init() {
    this._initUI();
    let connectionInited = this._initConnection();

    // Don't reject if the history fails to load for some reason.
    // This would be fine, the panel will just start with empty history.
    let allReady = this.jsterm.historyLoaded.catch(() => {}).then(() => {
      return connectionInited;
    });

    // This notification is only used in tests. Don't chain it onto
    // the returned promise because the console panel needs to be attached
    // to the toolbox before the web-console-created event is receieved.
    let notifyObservers = () => {
      let id = WebConsoleUtils.supportsString(this.hudId);
      if (Services.obs) {
        Services.obs.notifyObservers(id, "web-console-created");
      }
    };
    allReady.then(notifyObservers, notifyObservers)
            .then(this.newConsoleOutput.init);

    return allReady;
  },
  destroy() {
    if (this._destroyer) {
      return this._destroyer.promise;
    }
    this._destroyer = defer();
    Services.prefs.removeObserver(PREF_MESSAGE_TIMESTAMP, this._onToolboxPrefChanged);
    this.React = this.ReactDOM = this.FrameView = null;
    if (this.jsterm) {
      this.jsterm.off("sidebar-opened", this.resize);
      this.jsterm.off("sidebar-closed", this.resize);
      this.jsterm.destroy();
      this.jsterm = null;
    }

    let toolbox = gDevTools.getToolbox(this.owner.target);
    if (toolbox) {
      toolbox.off("webconsole-selected", this._onPanelSelected);
    }

    this.window = this.owner = this.newConsoleOutput = null;

    let onDestroy = () => {
      this._destroyer.resolve(null);
    };
    if (this.proxy) {
      this.proxy.disconnect().then(onDestroy);
      this.proxy = null;
    } else {
      onDestroy();
    }

    return this._destroyer.promise;
  },

  _onUpdateListeners() {

  },

  logWarningAboutReplacedAPI() {

  },

  handleNetworkEventUpdate() {

  },

  /**
   * Setter for saving of network request and response bodies.
   *
   * @param boolean value
   *        The new value you want to set.
   */
  setSaveRequestAndResponseBodies(value) {
    if (!this.webConsoleClient) {
      // Don't continue if the webconsole disconnected.
      return promise.resolve(null);
    }

    let deferred = defer();
    let newValue = !!value;
    let toSet = {
      "NetworkMonitor.saveRequestAndResponseBodies": newValue,
    };

    // Make sure the web console client connection is established first.
    this.webConsoleClient.setPreferences(toSet, response => {
      if (!response.error) {
        this._saveRequestAndResponseBodies = newValue;
        deferred.resolve(response);
      } else {
        deferred.reject(response.error);
      }
    });

    return deferred.promise;
  },

  /**
   * Connect to the server using the remote debugging protocol.
   *
   * @private
   * @return object
   *         A promise object that is resolved/reject based on the connection
   *         result.
   */
  _initConnection: function () {
    if (this._initDefer) {
      return this._initDefer.promise;
    }

    this._initDefer = defer();
    this.proxy = new WebConsoleConnectionProxy(this, this.owner.target);

    this.proxy.connect().then(() => {
      // on success
      this._initDefer.resolve(this);
    }, (reason) => {
      // on failure
      // TODO Print a message to console
      this._initDefer.reject(reason);
    });

    return this._initDefer.promise;
  },

  _initUI: function () {
    this.document = this.window.document;
    this.rootElement = this.document.documentElement;

    this.outputNode = this.document.getElementById("output-container");
    this.completeNode = this.document.querySelector(".jsterm-complete-node");
    this.inputNode = this.document.querySelector(".jsterm-input-node");

    this.jsterm = new JSTerm(this);
    this.jsterm.init();

    let toolbox = gDevTools.getToolbox(this.owner.target);

    // @TODO Remove this once JSTerm is handled with React/Redux.
    this.window.jsterm = this.jsterm;
    // @TODO Once the toolbox has been converted to React, see if passing
    // in JSTerm is still necessary.

    // Handle both launchpad and toolbox loading
    let Wrapper = this.owner.NewConsoleOutputWrapper || this.window.NewConsoleOutput;
    this.newConsoleOutput = new Wrapper(
      this.outputNode, this.jsterm, toolbox, this.owner, this.document);
    // Toggle the timestamp on preference change
    Services.prefs.addObserver(PREF_MESSAGE_TIMESTAMP, this._onToolboxPrefChanged);
    this._onToolboxPrefChanged();

    this._initShortcuts();
  },

  _initShortcuts: function () {
    let shortcuts = new KeyShortcuts({
      window: this.window
    });

    shortcuts.on(l10n.getStr("webconsole.find.key"),
                 (name, event) => {
                   this.filterBox.focus();
                   event.preventDefault();
                 });

    let clearShortcut;
    if (system.constants.platform === "macosx") {
      clearShortcut = l10n.getStr("webconsole.clear.keyOSX");
    } else {
      clearShortcut = l10n.getStr("webconsole.clear.key");
    }

    shortcuts.on(clearShortcut, () => this.jsterm.clearOutput(true));

    if (this.isBrowserConsole) {
      shortcuts.on(l10n.getStr("webconsole.close.key"),
                   this.window.close.bind(this.window));

      ZoomKeys.register(this.window);
    }
  },
  /**
   * Handler for page location changes.
   *
   * @param string uri
   *        New page location.
   * @param string title
   *        New page title.
   */
  onLocationChange: function (uri, title) {
    this.contentLocation = uri;
    if (this.owner.onLocationChange) {
      this.owner.onLocationChange(uri, title);
    }
  },

  /**
   * Release an actor.
   *
   * @private
   * @param string actor
   *        The actor ID you want to release.
   */
  _releaseObject: function (actor) {
    if (this.proxy) {
      this.proxy.releaseActor(actor);
    }
  },

  /**
   * Called when the message timestamp pref changes.
   */
  _onToolboxPrefChanged: function () {
    let newValue = Services.prefs.getBoolPref(PREF_MESSAGE_TIMESTAMP);
    this.newConsoleOutput.dispatchTimestampsToggle(newValue);
  },

  /**
   * Handler for the tabNavigated notification.
   *
   * @param string event
   *        Event name.
   * @param object packet
   *        Notification packet received from the server.
   */
  handleTabNavigated: function (event, packet) {
    if (event == "will-navigate") {
      if (this.persistLog) {
        // Add a _type to hit convertCachedPacket.
        packet._type = true;
        this.newConsoleOutput.dispatchMessageAdd(packet);
      } else {
        this.clearOutput(false);
      }
    }

    if (packet.url) {
      this.onLocationChange(packet.url, packet.title);
    }

    if (event == "navigate" && !packet.nativeConsoleAPI) {
      this.logWarningAboutReplacedAPI();
    }
  },

  clearOutput(clearStorage) {
    this.newConsoleOutput.dispatchMessagesClear();
    this.webConsoleClient.clearNetworkRequests();
    if (clearStorage) {
      this.webConsoleClient.clearMessagesCache();
    }
  },
};

exports.NewWebConsoleFrame = NewWebConsoleFrame;
