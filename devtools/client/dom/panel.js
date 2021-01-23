/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const { Cu } = require("chrome");

const EventEmitter = require("devtools/shared/event-emitter");
loader.lazyRequireGetter(
  this,
  "openContentLink",
  "devtools/client/shared/link",
  true
);

/**
 * This object represents DOM panel. It's responsibility is to
 * render Document Object Model of the current debugger target.
 */
function DomPanel(iframeWindow, toolbox) {
  this.panelWin = iframeWindow;
  this._toolbox = toolbox;

  this.onTabNavigated = this.onTabNavigated.bind(this);
  this.onTargetAvailable = this.onTargetAvailable.bind(this);
  this.onContentMessage = this.onContentMessage.bind(this);
  this.onPanelVisibilityChange = this.onPanelVisibilityChange.bind(this);

  this.pendingRequests = new Map();

  EventEmitter.decorate(this);
}

DomPanel.prototype = {
  /**
   * Open is effectively an asynchronous constructor.
   *
   * @return object
   *         A promise that is resolved when the DOM panel completes opening.
   */
  async open() {
    // Wait for the retrieval of root object properties before resolving open
    const onGetProperties = new Promise(resolve => {
      this._resolveOpen = resolve;
    });

    this.initialize();

    await onGetProperties;

    this.isReady = true;
    this.emit("ready");

    return this;
  },

  // Initialization

  initialize: function() {
    this.panelWin.addEventListener(
      "devtools/content/message",
      this.onContentMessage,
      true
    );

    this._toolbox.on("select", this.onPanelVisibilityChange);

    this._toolbox.targetList.watchTargets(
      [this._toolbox.targetList.TYPES.FRAME],
      this.onTargetAvailable
    );

    // Export provider object with useful API for DOM panel.
    const provider = {
      getToolbox: this.getToolbox.bind(this),
      getPrototypeAndProperties: this.getPrototypeAndProperties.bind(this),
      openLink: this.openLink.bind(this),
      // Resolve DomPanel.open once the object properties are fetched
      onPropertiesFetched: () => {
        if (this._resolveOpen) {
          this._resolveOpen();
          this._resolveOpen = null;
        }
      },
    };

    exportIntoContentScope(this.panelWin, provider, "DomProvider");
  },

  destroy() {
    if (this._destroyed) {
      return;
    }
    this._destroyed = true;

    this.currentTarget.off("navigate", this.onTabNavigated);
    this._toolbox.off("select", this.onPanelVisibilityChange);

    this.emit("destroyed");
  },

  // Events

  refresh: function() {
    // Do not refresh if the panel isn't visible.
    if (!this.isPanelVisible()) {
      return;
    }

    // Do not refresh if it isn't necessary.
    if (!this.shouldRefresh) {
      return;
    }

    // Alright reset the flag we are about to refresh the panel.
    this.shouldRefresh = false;

    this.getRootGrip().then(rootGrip => {
      this.postContentMessage("initialize", rootGrip);
    });
  },

  /**
   * Make sure the panel is refreshed when navigation occurs.
   * The panel is refreshed immediately if it's currently selected or lazily when the user
   * actually selects it.
   */
  onTabNavigated: function() {
    this.shouldRefresh = true;
    this.refresh();
  },

  onTargetAvailable: function({ targetFront }) {
    // Only care about top-level targets.
    if (!targetFront.isTopLevel) {
      return;
    }

    this.shouldRefresh = true;
    this.refresh();

    // Whenever a new target is available, listen to navigate events on it so we can
    // refresh the panel when we navigate within the same process.
    this.currentTarget.on("navigate", this.onTabNavigated);
  },

  /**
   * Make sure the panel is refreshed (if needed) when it's selected.
   */
  onPanelVisibilityChange: function() {
    this.refresh();
  },

  // Helpers

  /**
   * Return true if the DOM panel is currently selected.
   */
  isPanelVisible: function() {
    return this._toolbox.currentToolId === "dom";
  },

  getPrototypeAndProperties: async function(objectFront) {
    if (!objectFront.actorID) {
      console.error("No actor!", objectFront);
      throw new Error("Failed to get object front.");
    }

    // Bail out if target doesn't exist (toolbox maybe closed already).
    if (!this.currentTarget) {
      return null;
    }

    // Check for a previously stored request for grip.
    let request = this.pendingRequests.get(objectFront.actorID);

    // If no request is in progress create a new one.
    if (!request) {
      request = objectFront.getPrototypeAndProperties();
      this.pendingRequests.set(objectFront.actorID, request);
    }

    const response = await request;
    this.pendingRequests.delete(objectFront.actorID);

    // Fire an event about not having any pending requests.
    if (!this.pendingRequests.size) {
      this.emit("no-pending-requests");
    }

    return response;
  },

  openLink: function(url) {
    openContentLink(url);
  },

  getRootGrip: async function() {
    // Attach Console. It might involve RDP communication, so wait
    // asynchronously for the result
    const consoleFront = await this.currentTarget.getFront("console");
    const { result } = await consoleFront.evaluateJSAsync("window");
    return result;
  },

  postContentMessage: function(type, args) {
    const data = {
      type: type,
      args: args,
    };

    const event = new this.panelWin.MessageEvent("devtools/chrome/message", {
      bubbles: true,
      cancelable: true,
      data: data,
    });

    this.panelWin.dispatchEvent(event);
  },

  onContentMessage: function(event) {
    const data = event.data;
    const method = data.type;
    if (typeof this[method] == "function") {
      this[method](data.args);
    }
  },

  getToolbox: function() {
    return this._toolbox;
  },

  get currentTarget() {
    return this._toolbox.target;
  },
};

// Helpers

function exportIntoContentScope(win, obj, defineAs) {
  const clone = Cu.createObjectIn(win, {
    defineAs: defineAs,
  });

  const props = Object.getOwnPropertyNames(obj);
  for (let i = 0; i < props.length; i++) {
    const propName = props[i];
    const propValue = obj[propName];
    if (typeof propValue == "function") {
      Cu.exportFunction(propValue, clone, {
        defineAs: propName,
      });
    }
  }
}

// Exports from this module
exports.DomPanel = DomPanel;
