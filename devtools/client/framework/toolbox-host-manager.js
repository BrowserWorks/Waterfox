/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Services = require("Services");
const { LocalizationHelper } = require("devtools/shared/l10n");
const L10N = new LocalizationHelper(
  "devtools/client/locales/toolbox.properties"
);
const DevToolsUtils = require("devtools/shared/DevToolsUtils");
const Telemetry = require("devtools/client/shared/telemetry");
const { DOMHelpers } = require("devtools/shared/dom-helpers");

// The min-width of toolbox and browser toolbox.
const WIDTH_CHEVRON_AND_MEATBALL = 50;
const WIDTH_CHEVRON_AND_MEATBALL_AND_CLOSE = 74;
const ZOOM_VALUE_PREF = "devtools.toolbox.zoomValue";

loader.lazyRequireGetter(
  this,
  "Toolbox",
  "devtools/client/framework/toolbox",
  true
);
loader.lazyRequireGetter(
  this,
  "Hosts",
  "devtools/client/framework/toolbox-hosts",
  true
);

/**
 * Implement a wrapper on the chrome side to setup a Toolbox within Firefox UI.
 *
 * This component handles iframe creation within Firefox, in which we are loading
 * the toolbox document. Then both the chrome and the toolbox document communicate
 * via "message" events.
 *
 * Messages sent by the toolbox to the chrome:
 * - switch-host:
 *   Order to display the toolbox in another host (side, bottom, window, or the
 *   previously used one)
 * - raise-host:
 *   Focus the tools
 * - set-host-title:
 *   When using the window host, update the window title
 *
 * Messages sent by the chrome to the toolbox:
 * - switched-host:
 *   The `switch-host` command sent by the toolbox is done
 */

const LAST_HOST = "devtools.toolbox.host";
const PREVIOUS_HOST = "devtools.toolbox.previousHost";
let ID_COUNTER = 1;

function ToolboxHostManager(target, hostType, hostOptions) {
  this.target = target;

  this.frameId = ID_COUNTER++;

  if (!hostType) {
    hostType = Services.prefs.getCharPref(LAST_HOST);
    if (!Hosts[hostType]) {
      // If the preference value is unexpected, restore to the default value.
      Services.prefs.clearUserPref(LAST_HOST);
      hostType = Services.prefs.getCharPref(LAST_HOST);
    }
  }
  this.host = this.createHost(hostType, hostOptions);
  this.hostType = hostType;
  this.telemetry = new Telemetry();
  this.setMinWidthWithZoom = this.setMinWidthWithZoom.bind(this);
  Services.prefs.addObserver(ZOOM_VALUE_PREF, this.setMinWidthWithZoom);
}

ToolboxHostManager.prototype = {
  async create(toolId) {
    await this.host.create();

    this.host.frame.setAttribute("aria-label", L10N.getStr("toolbox.label"));
    this.host.frame.ownerDocument.defaultView.addEventListener("message", this);
    // We have to listen on capture as no event fires on bubble
    this.host.frame.addEventListener("unload", this, true);

    const msSinceProcessStart = parseInt(
      this.telemetry.msSinceProcessStart(),
      10
    );
    const toolbox = new Toolbox(
      this.target,
      toolId,
      this.host.type,
      this.host.frame.contentWindow,
      this.frameId,
      msSinceProcessStart
    );

    // Prevent reloading the toolbox when loading the tools in a tab
    // (e.g. from about:debugging)
    const location = this.host.frame.contentWindow.location;
    if (!location.href.startsWith("about:devtools-toolbox")) {
      this.host.frame.setAttribute("src", "about:devtools-toolbox");
    }

    // We set an attribute on the toolbox iframe so that apps do not need
    // access to the toolbox internals in order to get the session ID.
    this.host.frame.setAttribute("session_id", msSinceProcessStart);

    this.setMinWidthWithZoom();
    return toolbox;
  },

  setMinWidthWithZoom: function() {
    const zoomValue = parseFloat(Services.prefs.getCharPref(ZOOM_VALUE_PREF));

    if (isNaN(zoomValue)) {
      return;
    }

    if (
      this.hostType === Toolbox.HostType.LEFT ||
      this.hostType === Toolbox.HostType.RIGHT
    ) {
      this.host.frame.minWidth =
        WIDTH_CHEVRON_AND_MEATBALL_AND_CLOSE * zoomValue;
    } else if (
      this.hostType === Toolbox.HostType.WINDOW ||
      this.hostType === Toolbox.HostType.PAGE ||
      this.hostType === Toolbox.HostType.BROWSERTOOLBOX
    ) {
      this.host.frame.minWidth = WIDTH_CHEVRON_AND_MEATBALL * zoomValue;
    }
  },

  handleEvent(event) {
    switch (event.type) {
      case "message":
        this.onMessage(event);
        break;
      case "unload":
        // On unload, host iframe already lost its contentWindow attribute, so
        // we can only compare against locations. Here we filter two very
        // different cases: preliminary about:blank document as well as iframes
        // like tool iframes.
        if (!event.target.location.href.startsWith("about:devtools-toolbox")) {
          break;
        }
        // Don't destroy the host during unload event (esp., don't remove the
        // iframe from DOM!). Otherwise the unload event for the toolbox
        // document doesn't fire within the toolbox *document*! This is
        // the unload event that fires on the toolbox *iframe*.
        DevToolsUtils.executeSoon(() => {
          this.destroy();
        });
        break;
    }
  },

  onMessage(event) {
    if (!event.data) {
      return;
    }
    const msg = event.data;
    // Toolbox document is still chrome and disallow identifying message
    // origin via event.source as it is null. So use a custom id.
    if (msg.frameId != this.frameId) {
      return;
    }
    switch (msg.name) {
      case "switch-host":
        this.switchHost(msg.hostType);
        break;
      case "raise-host":
        this.host.raise();
        break;
      case "set-host-title":
        this.host.setTitle(msg.title);
        break;
    }
  },

  postMessage(data) {
    const window = this.host.frame.contentWindow;
    window.postMessage(data, "*");
  },

  destroy() {
    Services.prefs.removeObserver(ZOOM_VALUE_PREF, this.setMinWidthWithZoom);
    this.destroyHost();
    this.host = null;
    this.hostType = null;
    this.target = null;
  },

  /**
   * Create a host object based on the given host type.
   *
   * Warning: bottom and sidebar hosts require that the toolbox target provides
   * a reference to the attached tab. Not all Targets have a tab property -
   * make sure you correctly mix and match hosts and targets.
   *
   * @param {string} hostType
   *        The host type of the new host object
   *
   * @return {Host} host
   *        The created host object
   */
  createHost(hostType, options) {
    if (!Hosts[hostType]) {
      throw new Error("Unknown hostType: " + hostType);
    }

    const newHost = new Hosts[hostType](this.target.localTab, options);
    return newHost;
  },

  async switchHost(hostType) {
    if (hostType == "previous") {
      // Switch to the last used host for the toolbox UI.
      // This is determined by the devtools.toolbox.previousHost pref.
      hostType = Services.prefs.getCharPref(PREVIOUS_HOST);

      // Handle the case where the previous host happens to match the current
      // host. If so, switch to bottom if it's not already used, and right side if not.
      if (hostType === this.hostType) {
        if (hostType === Toolbox.HostType.BOTTOM) {
          hostType = Toolbox.HostType.RIGHT;
        } else {
          hostType = Toolbox.HostType.BOTTOM;
        }
      }
    }
    const iframe = this.host.frame;
    const newHost = this.createHost(hostType);
    const newIframe = await newHost.create();

    // Load a blank document in the host frame. The new iframe must have a valid
    // document before using swapFrameLoaders().
    await new Promise(resolve => {
      newIframe.setAttribute("src", "about:blank");
      DOMHelpers.onceDOMReady(newIframe.contentWindow, resolve);
    });

    // change toolbox document's parent to the new host
    newIframe.swapFrameLoaders(iframe);

    this.destroyHost();

    if (
      this.hostType !== Toolbox.HostType.BROWSERTOOLBOX &&
      this.hostType !== Toolbox.HostType.PAGE
    ) {
      Services.prefs.setCharPref(PREVIOUS_HOST, this.hostType);
    }

    this.host = newHost;
    this.hostType = hostType;
    this.host.setTitle(this.host.frame.contentWindow.document.title);
    this.host.frame.ownerDocument.defaultView.addEventListener("message", this);
    this.host.frame.addEventListener("unload", this, true);

    this.setMinWidthWithZoom();

    if (
      hostType !== Toolbox.HostType.BROWSERTOOLBOX &&
      hostType !== Toolbox.HostType.PAGE
    ) {
      Services.prefs.setCharPref(LAST_HOST, hostType);
    }

    // Tell the toolbox the host changed
    this.postMessage({
      name: "switched-host",
      hostType,
    });
  },

  /**
   * Destroy the current host, and remove event listeners from its frame.
   *
   * @return {promise} to be resolved when the host is destroyed.
   */
  destroyHost() {
    // When Firefox toplevel is closed, the frame may already be detached and
    // the top level document gone
    if (this.host.frame.ownerDocument.defaultView) {
      this.host.frame.ownerDocument.defaultView.removeEventListener(
        "message",
        this
      );
    }
    this.host.frame.removeEventListener("unload", this, true);

    return this.host.destroy();
  },
};
exports.ToolboxHostManager = ToolboxHostManager;
