/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["RemotePages", "RemotePageManager", "PageListener"];

const { classes: Cc, interfaces: Ci, utils: Cu, results: Cr } = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

function MessageListener() {
  this.listeners = new Map();
}

MessageListener.prototype = {
  keys() {
    return this.listeners.keys();
  },

  has(name) {
    return this.listeners.has(name);
  },

  callListeners(message) {
    let listeners = this.listeners.get(message.name);
    if (!listeners) {
      return;
    }

    for (let listener of listeners.values()) {
      try {
        listener(message);
      } catch (e) {
        Cu.reportError(e);
      }
    }
  },

  addMessageListener(name, callback) {
    if (!this.listeners.has(name))
      this.listeners.set(name, new Set([callback]));
    else
      this.listeners.get(name).add(callback);
  },

  removeMessageListener(name, callback) {
    if (!this.listeners.has(name))
      return;

    this.listeners.get(name).delete(callback);
  },
}


/**
 * Creates a RemotePages object which listens for new remote pages of a
 * particular URL. A "RemotePage:Init" message will be dispatched to this object
 * for every page loaded. Message listeners added to this object receive
 * messages from all loaded pages from the requested url.
 */
this.RemotePages = function(url) {
  this.url = url;
  this.messagePorts = new Set();
  this.listener = new MessageListener();
  this.destroyed = false;

  RemotePageManager.addRemotePageListener(url, this.portCreated.bind(this));
  this.portMessageReceived = this.portMessageReceived.bind(this);
}

RemotePages.prototype = {
  url: null,
  messagePorts: null,
  listener: null,
  destroyed: null,

  destroy() {
    RemotePageManager.removeRemotePageListener(this.url);

    for (let port of this.messagePorts.values()) {
      this.removeMessagePort(port);
    }

    this.messagePorts = null;
    this.listener = null;
    this.destroyed = true;
  },

  // Called when a page matching the url has loaded in a frame.
  portCreated(port) {
    this.messagePorts.add(port);

    port.addMessageListener("RemotePage:Unload", this.portMessageReceived);

    for (let name of this.listener.keys()) {
      this.registerPortListener(port, name);
    }

    this.listener.callListeners({ target: port, name: "RemotePage:Init" });
  },

  // A message has been received from one of the pages
  portMessageReceived(message) {
    if (message.name == "RemotePage:Unload")
      this.removeMessagePort(message.target);

    this.listener.callListeners(message);
  },

  // A page has closed
  removeMessagePort(port) {
    for (let name of this.listener.keys()) {
      port.removeMessageListener(name, this.portMessageReceived);
    }

    port.removeMessageListener("RemotePage:Unload", this.portMessageReceived);
    this.messagePorts.delete(port);
  },

  registerPortListener(port, name) {
    port.addMessageListener(name, this.portMessageReceived);
  },

  // Sends a message to all known pages
  sendAsyncMessage(name, data = null) {
    for (let port of this.messagePorts.values()) {
      try {
        port.sendAsyncMessage(name, data);
      } catch (e) {
        // Unless the port is in the process of unloading, something strange
        // happened but allow other ports to receive the message
        if (e.result !== Cr.NS_ERROR_NOT_INITIALIZED)
          Cu.reportError(e);
      }
    }
  },

  addMessageListener(name, callback) {
    if (this.destroyed) {
      throw new Error("RemotePages has been destroyed");
    }

    if (!this.listener.has(name)) {
      for (let port of this.messagePorts.values()) {
        this.registerPortListener(port, name)
      }
    }

    this.listener.addMessageListener(name, callback);
  },

  removeMessageListener(name, callback) {
    if (this.destroyed) {
      throw new Error("RemotePages has been destroyed");
    }

    this.listener.removeMessageListener(name, callback);
  },

  portsForBrowser(browser) {
    return [...this.messagePorts].filter(port => port.browser == browser);
  },
};


// Only exposes the public properties of the MessagePort
function publicMessagePort(port) {
  let properties = ["addMessageListener", "removeMessageListener",
                    "sendAsyncMessage", "destroy"];

  let clean = {};
  for (let property of properties) {
    clean[property] = port[property].bind(port);
  }

  Object.defineProperty(clean, "portID", {
    get() {
      return port.portID;
    }
  });

  if (port instanceof ChromeMessagePort) {
    Object.defineProperty(clean, "browser", {
      get() {
        return port.browser;
      }
    });
  }

  return clean;
}


/*
 * A message port sits on each side of the process boundary for every remote
 * page. Each has a port ID that is unique to the message manager it talks
 * through.
 *
 * We roughly implement the same contract as nsIMessageSender and
 * nsIMessageListenerManager
 */
function MessagePort(messageManager, portID) {
  this.messageManager = messageManager;
  this.portID = portID;
  this.destroyed = false;
  this.listener = new MessageListener();

  this.message = this.message.bind(this);
  this.messageManager.addMessageListener("RemotePage:Message", this.message);
}

MessagePort.prototype = {
  messageManager: null,
  portID: null,
  destroyed: null,
  listener: null,
  _browser: null,
  remotePort: null,

  // Called when the message manager used to connect to the other process has
  // changed, i.e. when a tab is detached.
  swapMessageManager(messageManager) {
    this.messageManager.removeMessageListener("RemotePage:Message", this.message);

    this.messageManager = messageManager;

    this.messageManager.addMessageListener("RemotePage:Message", this.message);
  },

  /* Adds a listener for messages. Many callbacks can be registered for the
   * same message if necessary. An attempt to register the same callback for the
   * same message twice will be ignored. When called the callback is passed an
   * object with these properties:
   *   target: This message port
   *   name:   The message name
   *   data:   Any data sent with the message
   */
  addMessageListener(name, callback) {
    if (this.destroyed) {
      throw new Error("Message port has been destroyed");
    }

    this.listener.addMessageListener(name, callback);
  },

  /*
   * Removes a listener for messages.
   */
  removeMessageListener(name, callback) {
    if (this.destroyed) {
      throw new Error("Message port has been destroyed");
    }

    this.listener.removeMessageListener(name, callback);
  },

  // Sends a message asynchronously to the other process
  sendAsyncMessage(name, data = null) {
    if (this.destroyed) {
      throw new Error("Message port has been destroyed");
    }

    this.messageManager.sendAsyncMessage("RemotePage:Message", {
      portID: this.portID,
      name,
      data,
    });
  },

  // Called to destroy this port
  destroy() {
    try {
      // This can fail in the child process if the tab has already been closed
      this.messageManager.removeMessageListener("RemotePage:Message", this.message);
    } catch (e) { }
    this.messageManager = null;
    this.destroyed = true;
    this.portID = null;
    this.listener = null;
  },
};


// The chome side of a message port
function ChromeMessagePort(browser, portID) {
  MessagePort.call(this, browser.messageManager, portID);

  this._browser = browser;
  this._permanentKey = browser.permanentKey;

  Services.obs.addObserver(this, "message-manager-disconnect");
  this.publicPort = publicMessagePort(this);

  this.swapBrowsers = this.swapBrowsers.bind(this);
  this._browser.addEventListener("SwapDocShells", this.swapBrowsers);
}

ChromeMessagePort.prototype = Object.create(MessagePort.prototype);

Object.defineProperty(ChromeMessagePort.prototype, "browser", {
  get() {
    return this._browser;
  }
});

// Called when the docshell is being swapped with another browser. We have to
// update to use the new browser's message manager
ChromeMessagePort.prototype.swapBrowsers = function({ detail: newBrowser }) {
  // We can see this event for the new browser before the swap completes so
  // check that the browser we're tracking has our permanentKey.
  if (this._browser.permanentKey != this._permanentKey)
    return;

  this._browser.removeEventListener("SwapDocShells", this.swapBrowsers);

  this._browser = newBrowser;
  this.swapMessageManager(newBrowser.messageManager);

  this._browser.addEventListener("SwapDocShells", this.swapBrowsers);
}

// Called when a message manager has been disconnected indicating that the
// tab has closed or crashed
ChromeMessagePort.prototype.observe = function(messageManager) {
  if (messageManager != this.messageManager)
    return;

  this.listener.callListeners({
    target: this.publicPort,
    name: "RemotePage:Unload",
    data: null,
  });
  this.destroy();
};

// Called when a message is received from the message manager. This could
// have come from any port in the message manager so verify the port ID.
ChromeMessagePort.prototype.message = function({ data: messagedata }) {
  if (this.destroyed || (messagedata.portID != this.portID)) {
    return;
  }

  let message = {
    target: this.publicPort,
    name: messagedata.name,
    data: messagedata.data,
  };
  this.listener.callListeners(message);

  if (messagedata.name == "RemotePage:Unload")
    this.destroy();
};

ChromeMessagePort.prototype.destroy = function() {
  try {
    this._browser.removeEventListener(
        "SwapDocShells", this.swapBrowsers);
  } catch (e) {
    // It's possible the browser instance is already dead so we can just ignore
    // this error.
  }

  this._browser = null;
  Services.obs.removeObserver(this, "message-manager-disconnect");
  MessagePort.prototype.destroy.call(this);
};


// The content side of a message port
function ChildMessagePort(contentFrame, window) {
  let portID = Services.appinfo.processID + ":" + ChildMessagePort.prototype.nextPortID++;
  MessagePort.call(this, contentFrame, portID);

  this.window = window;

  // Add functionality to the content page
  Cu.exportFunction(this.sendAsyncMessage.bind(this), window, {
    defineAs: "sendAsyncMessage",
  });
  Cu.exportFunction(this.addMessageListener.bind(this), window, {
    defineAs: "addMessageListener",
    allowCallbacks: true,
  });
  Cu.exportFunction(this.removeMessageListener.bind(this), window, {
    defineAs: "removeMessageListener",
    allowCallbacks: true,
  });

  // Send a message for load events
  let loadListener = () => {
    this.sendAsyncMessage("RemotePage:Load");
    window.removeEventListener("load", loadListener);
  };
  window.addEventListener("load", loadListener);

  // Destroy the port when the window is unloaded
  window.addEventListener("unload", () => {
    try {
      this.sendAsyncMessage("RemotePage:Unload");
    } catch (e) {
      // If the tab has been closed the frame message manager has already been
      // destroyed
    }
    this.destroy();
  });

  // Tell the main process to set up its side of the message pipe.
  this.messageManager.sendAsyncMessage("RemotePage:InitPort", {
    portID,
    url: window.document.documentURI.replace(/[\#|\?].*$/, ""),
  });
}

ChildMessagePort.prototype = Object.create(MessagePort.prototype);

ChildMessagePort.prototype.nextPortID = 0;

// Called when a message is received from the message manager. This could
// have come from any port in the message manager so verify the port ID.
ChildMessagePort.prototype.message = function({ data: messagedata }) {
  if (this.destroyed || (messagedata.portID != this.portID)) {
    return;
  }

  let message = {
    name: messagedata.name,
    data: messagedata.data,
  };
  this.listener.callListeners(Cu.cloneInto(message, this.window));
};

ChildMessagePort.prototype.destroy = function() {
  this.window = null;
  MessagePort.prototype.destroy.call(this);
}

// Allows callers to register to connect to specific content pages. Registration
// is done through the addRemotePageListener method
var RemotePageManagerInternal = {
  // The currently registered remote pages
  pages: new Map(),

  // Initialises all the needed listeners
  init() {
    Services.ppmm.addMessageListener("RemotePage:InitListener", this.initListener.bind(this));
    Services.mm.addMessageListener("RemotePage:InitPort", this.initPort.bind(this));
  },

  // Registers interest in a remote page. A callback is called with a port for
  // the new page when loading begins (i.e. the page hasn't actually loaded yet).
  // Only one callback can be registered per URL.
  addRemotePageListener(url, callback) {
    if (Services.appinfo.processType != Ci.nsIXULRuntime.PROCESS_TYPE_DEFAULT)
      throw new Error("RemotePageManager can only be used in the main process.");

    if (this.pages.has(url)) {
      throw new Error("Remote page already registered: " + url);
    }

    this.pages.set(url, callback);

    // Notify all the frame scripts of the new registration
    Services.ppmm.broadcastAsyncMessage("RemotePage:Register", { urls: [url] });
  },

  // Removes any interest in a remote page.
  removeRemotePageListener(url) {
    if (Services.appinfo.processType != Ci.nsIXULRuntime.PROCESS_TYPE_DEFAULT)
      throw new Error("RemotePageManager can only be used in the main process.");

    if (!this.pages.has(url)) {
      throw new Error("Remote page is not registered: " + url);
    }

    // Notify all the frame scripts of the removed registration
    Services.ppmm.broadcastAsyncMessage("RemotePage:Unregister", { urls: [url] });
    this.pages.delete(url);
  },

  // A listener is requesting the list of currently registered urls
  initListener({ target: messageManager }) {
    messageManager.sendAsyncMessage("RemotePage:Register", { urls: Array.from(this.pages.keys()) })
  },

  // A remote page has been created and a port is ready in the content side
  initPort({ target: browser, data: { url, portID } }) {
    let callback = this.pages.get(url);
    if (!callback) {
      Cu.reportError("Unexpected remote page load: " + url);
      return;
    }

    let port = new ChromeMessagePort(browser, portID);
    callback(port.publicPort);
  }
};

if (Services.appinfo.processType == Ci.nsIXULRuntime.PROCESS_TYPE_DEFAULT)
  RemotePageManagerInternal.init();

// The public API for the above object
this.RemotePageManager = {
  addRemotePageListener: RemotePageManagerInternal.addRemotePageListener.bind(RemotePageManagerInternal),
  removeRemotePageListener: RemotePageManagerInternal.removeRemotePageListener.bind(RemotePageManagerInternal),
};

// Listen for pages in any process we're loaded in
var registeredURLs = new Set();

var observer = (window) => {
  // Strip the hash from the URL, because it's not part of the origin.
  let url = window.document.documentURI.replace(/[\#|\?].*$/, "");
  if (!registeredURLs.has(url))
    return;

  // Get the frame message manager for this window so we can associate this
  // page with a browser element
  let messageManager = window.QueryInterface(Ci.nsIInterfaceRequestor)
                             .getInterface(Ci.nsIDocShell)
                             .QueryInterface(Ci.nsIInterfaceRequestor)
                             .getInterface(Ci.nsIContentFrameMessageManager);
  // Set up the child side of the message port
  new ChildMessagePort(messageManager, window);
};
Services.obs.addObserver(observer, "chrome-document-global-created");
Services.obs.addObserver(observer, "content-document-global-created");

// A message from chrome telling us what pages to listen for
Services.cpmm.addMessageListener("RemotePage:Register", ({ data }) => {
  for (let url of data.urls)
    registeredURLs.add(url);
});

// A message from chrome telling us what pages to stop listening for
Services.cpmm.addMessageListener("RemotePage:Unregister", ({ data }) => {
  for (let url of data.urls)
    registeredURLs.delete(url);
});

Services.cpmm.sendAsyncMessage("RemotePage:InitListener");
