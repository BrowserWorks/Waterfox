/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

XPCOMUtils.defineLazyServiceGetter(this, "aboutNewTabService",
                                   "@mozilla.org/browser/aboutnewtab-service;1",
                                   "nsIAboutNewTabService");

XPCOMUtils.defineLazyModuleGetter(this, "MatchPattern",
                                  "resource://gre/modules/MatchPattern.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PrivateBrowsingUtils",
                                  "resource://gre/modules/PrivateBrowsingUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PromiseUtils",
                                  "resource://gre/modules/PromiseUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Services",
                                  "resource://gre/modules/Services.jsm");

Cu.import("resource://gre/modules/ExtensionUtils.jsm");

var {
  EventManager,
  ignoreEvent,
} = ExtensionUtils;

// This function is pretty tightly tied to Extension.jsm.
// Its job is to fill in the |tab| property of the sender.
function getSender(extension, target, sender) {
  if ("tabId" in sender) {
    // The message came from an ExtensionContext. In that case, it should
    // include a tabId property (which is filled in by the page-open
    // listener below).
    let tab = TabManager.getTab(sender.tabId, null, null);
    delete sender.tabId;
    if (tab) {
      sender.tab = TabManager.convert(extension, tab);
      return;
    }
  }
  if (target instanceof Ci.nsIDOMXULElement) {
    // If the message was sent from a content script to a <browser> element,
    // then we can just get the `tab` from `target`.
    let tabbrowser = target.ownerGlobal.gBrowser;
    if (tabbrowser) {
      let tab = tabbrowser.getTabForBrowser(target);

      // `tab` can be `undefined`, e.g. for extension popups. This condition is
      // reached if `getSender` is called for a popup without a valid `tabId`.
      if (tab) {
        sender.tab = TabManager.convert(extension, tab);
      }
    }
  }
}

// Used by Extension.jsm
global.tabGetSender = getSender;

/* eslint-disable mozilla/balanced-listeners */

extensions.on("page-shutdown", (type, context) => {
  if (context.viewType == "tab") {
    if (context.extension.id !== context.xulBrowser.contentPrincipal.addonId) {
      // Only close extension tabs.
      // This check prevents about:addons from closing when it contains a
      // WebExtension as an embedded inline options page.
      return;
    }
    let {gBrowser} = context.xulBrowser.ownerGlobal;
    if (gBrowser) {
      let tab = gBrowser.getTabForBrowser(context.xulBrowser);
      if (tab) {
        gBrowser.removeTab(tab);
      }
    }
  }
});

extensions.on("fill-browser-data", (type, browser, data) => {
  data.tabId = browser ? TabManager.getBrowserId(browser) : -1;
});
/* eslint-enable mozilla/balanced-listeners */

global.currentWindow = function(context) {
  let {xulWindow} = context;
  if (xulWindow && context.viewType != "background") {
    return xulWindow;
  }
  return WindowManager.topWindow;
};

let tabListener = {
  init() {
    if (this.initialized) {
      return;
    }

    this.adoptedTabs = new WeakMap();

    this.handleWindowOpen = this.handleWindowOpen.bind(this);
    this.handleWindowClose = this.handleWindowClose.bind(this);

    AllWindowEvents.addListener("TabClose", this);
    AllWindowEvents.addListener("TabOpen", this);
    WindowListManager.addOpenListener(this.handleWindowOpen);
    WindowListManager.addCloseListener(this.handleWindowClose);

    EventEmitter.decorate(this);

    this.initialized = true;
  },

  handleEvent(event) {
    switch (event.type) {
      case "TabOpen":
        if (event.detail.adoptedTab) {
          this.adoptedTabs.set(event.detail.adoptedTab, event.target);
        }

        // We need to delay sending this event until the next tick, since the
        // tab does not have its final index when the TabOpen event is dispatched.
        Promise.resolve().then(() => {
          if (event.detail.adoptedTab) {
            this.emitAttached(event.originalTarget);
          } else {
            this.emitCreated(event.originalTarget);
          }
        });
        break;

      case "TabClose":
        let tab = event.originalTarget;

        if (event.detail.adoptedBy) {
          this.emitDetached(tab, event.detail.adoptedBy);
        } else {
          this.emitRemoved(tab, false);
        }
        break;
    }
  },

  handleWindowOpen(window) {
    if (window.arguments[0] instanceof window.XULElement) {
      // If the first window argument is a XUL element, it means the
      // window is about to adopt a tab from another window to replace its
      // initial tab.
      //
      // Note that this event handler depends on running before the
      // delayed startup code in browser.js, which is currently triggered
      // by the first MozAfterPaint event. That code handles finally
      // adopting the tab, and clears it from the arguments list in the
      // process, so if we run later than it, we're too late.
      let tab = window.arguments[0];
      this.adoptedTabs.set(tab, window.gBrowser.tabs[0]);

      // We need to be sure to fire this event after the onDetached event
      // for the original tab.
      let listener = (event, details) => {
        if (details.tab == tab) {
          this.off("tab-detached", listener);

          Promise.resolve().then(() => {
            this.emitAttached(details.adoptedBy);
          });
        }
      };

      this.on("tab-detached", listener);
    } else {
      for (let tab of window.gBrowser.tabs) {
        this.emitCreated(tab);
      }
    }
  },

  handleWindowClose(window) {
    for (let tab of window.gBrowser.tabs) {
      if (this.adoptedTabs.has(tab)) {
        this.emitDetached(tab, this.adoptedTabs.get(tab));
      } else {
        this.emitRemoved(tab, true);
      }
    }
  },

  emitAttached(tab) {
    let newWindowId = WindowManager.getId(tab.ownerGlobal);
    let tabId = TabManager.getId(tab);

    this.emit("tab-attached", {tab, tabId, newWindowId, newPosition: tab._tPos});
  },

  emitDetached(tab, adoptedBy) {
    let oldWindowId = WindowManager.getId(tab.ownerGlobal);
    let tabId = TabManager.getId(tab);

    this.emit("tab-detached", {tab, adoptedBy, tabId, oldWindowId, oldPosition: tab._tPos});
  },

  emitCreated(tab) {
    this.emit("tab-created", {tab});
  },

  emitRemoved(tab, isWindowClosing) {
    let windowId = WindowManager.getId(tab.ownerGlobal);
    let tabId = TabManager.getId(tab);

    // When addons run in-process, `window.close()` is synchronous. Most other
    // addon-invoked calls are asynchronous since they go through a proxy
    // context via the message manager. This includes event registrations such
    // as `tabs.onRemoved.addListener`.
    // So, even if `window.close()` were to be called (in-process) after calling
    // `tabs.onRemoved.addListener`, then the tab would be closed before the
    // event listener is registered. To make sure that the event listener is
    // notified, we dispatch `tabs.onRemoved` asynchronously.
    Services.tm.mainThread.dispatch(() => {
      this.emit("tab-removed", {tab, tabId, windowId, isWindowClosing});
    }, Ci.nsIThread.DISPATCH_NORMAL);
  },

  tabReadyInitialized: false,
  tabReadyPromises: new WeakMap(),
  initializingTabs: new WeakSet(),

  initTabReady() {
    if (!this.tabReadyInitialized) {
      AllWindowEvents.addListener("progress", this);

      this.tabReadyInitialized = true;
    }
  },

  onLocationChange(browser, webProgress, request, locationURI, flags) {
    if (webProgress.isTopLevel) {
      let gBrowser = browser.ownerGlobal.gBrowser;
      let tab = gBrowser.getTabForBrowser(browser);

      // Now we are certain that the first page in the tab was loaded.
      this.initializingTabs.delete(tab);

      // browser.innerWindowID is now set, resolve the promises if any.
      let deferred = this.tabReadyPromises.get(tab);
      if (deferred) {
        deferred.resolve(tab);
        this.tabReadyPromises.delete(tab);
      }
    }
  },

  /**
   * Returns a promise that resolves when the tab is ready.
   * Tabs created via the `tabs.create` method are "ready" once the location
   * changes to the requested URL. Other tabs are assumed to be ready once their
   * inner window ID is known.
   *
   * @param {XULElement} tab The <tab> element.
   * @returns {Promise} Resolves with the given tab once ready.
   */
  awaitTabReady(tab) {
    let deferred = this.tabReadyPromises.get(tab);
    if (!deferred) {
      deferred = PromiseUtils.defer();
      if (!this.initializingTabs.has(tab) && tab.linkedBrowser.innerWindowID) {
        deferred.resolve(tab);
      } else {
        this.initTabReady();
        this.tabReadyPromises.set(tab, deferred);
      }
    }
    return deferred.promise;
  },
};

/* eslint-disable mozilla/balanced-listeners */
extensions.on("startup", () => {
  tabListener.init();
});
/* eslint-enable mozilla/balanced-listeners */

extensions.registerSchemaAPI("tabs", "addon_parent", context => {
  let {extension} = context;
  let self = {
    tabs: {
      onActivated: new WindowEventManager(context, "tabs.onActivated", "TabSelect", (fire, event) => {
        let tab = event.originalTarget;
        let tabId = TabManager.getId(tab);
        let windowId = WindowManager.getId(tab.ownerGlobal);
        fire({tabId, windowId});
      }).api(),

      onCreated: new EventManager(context, "tabs.onCreated", fire => {
        let listener = (eventName, event) => {
          fire(TabManager.convert(extension, event.tab));
        };

        tabListener.on("tab-created", listener);
        return () => {
          tabListener.off("tab-created", listener);
        };
      }).api(),

      /**
       * Since multiple tabs currently can't be highlighted, onHighlighted
       * essentially acts an alias for self.tabs.onActivated but returns
       * the tabId in an array to match the API.
       * @see  https://developer.mozilla.org/en-US/Add-ons/WebExtensions/API/Tabs/onHighlighted
      */
      onHighlighted: new WindowEventManager(context, "tabs.onHighlighted", "TabSelect", (fire, event) => {
        let tab = event.originalTarget;
        let tabIds = [TabManager.getId(tab)];
        let windowId = WindowManager.getId(tab.ownerGlobal);
        fire({tabIds, windowId});
      }).api(),

      onAttached: new EventManager(context, "tabs.onAttached", fire => {
        let listener = (eventName, event) => {
          fire(event.tabId, {newWindowId: event.newWindowId, newPosition: event.newPosition});
        };

        tabListener.on("tab-attached", listener);
        return () => {
          tabListener.off("tab-attached", listener);
        };
      }).api(),

      onDetached: new EventManager(context, "tabs.onDetached", fire => {
        let listener = (eventName, event) => {
          fire(event.tabId, {oldWindowId: event.oldWindowId, oldPosition: event.oldPosition});
        };

        tabListener.on("tab-detached", listener);
        return () => {
          tabListener.off("tab-detached", listener);
        };
      }).api(),

      onRemoved: new EventManager(context, "tabs.onRemoved", fire => {
        let listener = (eventName, event) => {
          fire(event.tabId, {windowId: event.windowId, isWindowClosing: event.isWindowClosing});
        };

        tabListener.on("tab-removed", listener);
        return () => {
          tabListener.off("tab-removed", listener);
        };
      }).api(),

      onReplaced: ignoreEvent(context, "tabs.onReplaced"),

      onMoved: new EventManager(context, "tabs.onMoved", fire => {
        // There are certain circumstances where we need to ignore a move event.
        //
        // Namely, the first time the tab is moved after it's created, we need
        // to report the final position as the initial position in the tab's
        // onAttached or onCreated event. This is because most tabs are inserted
        // in a temporary location and then moved after the TabOpen event fires,
        // which generates a TabOpen event followed by a TabMove event, which
        // does not match the contract of our API.
        let ignoreNextMove = new WeakSet();

        let openListener = event => {
          ignoreNextMove.add(event.target);
          // Remove the tab from the set on the next tick, since it will already
          // have been moved by then.
          Promise.resolve().then(() => {
            ignoreNextMove.delete(event.target);
          });
        };

        let moveListener = event => {
          let tab = event.originalTarget;

          if (ignoreNextMove.has(tab)) {
            ignoreNextMove.delete(tab);
            return;
          }

          fire(TabManager.getId(tab), {
            windowId: WindowManager.getId(tab.ownerGlobal),
            fromIndex: event.detail,
            toIndex: tab._tPos,
          });
        };

        AllWindowEvents.addListener("TabMove", moveListener);
        AllWindowEvents.addListener("TabOpen", openListener);
        return () => {
          AllWindowEvents.removeListener("TabMove", moveListener);
          AllWindowEvents.removeListener("TabOpen", openListener);
        };
      }).api(),

      onUpdated: new EventManager(context, "tabs.onUpdated", fire => {
        function sanitize(extension, changeInfo) {
          let result = {};
          let nonempty = false;
          for (let prop in changeInfo) {
            if ((prop != "favIconUrl" && prop != "url") || extension.hasPermission("tabs")) {
              nonempty = true;
              result[prop] = changeInfo[prop];
            }
          }
          return [nonempty, result];
        }

        let fireForBrowser = (browser, changed) => {
          let [needed, changeInfo] = sanitize(extension, changed);
          if (needed) {
            let gBrowser = browser.ownerGlobal.gBrowser;
            let tabElem = gBrowser.getTabForBrowser(browser);

            let tab = TabManager.convert(extension, tabElem);
            fire(tab.id, changeInfo, tab);
          }
        };

        let listener = event => {
          let needed = [];
          if (event.type == "TabAttrModified") {
            let changed = event.detail.changed;
            if (changed.includes("image")) {
              needed.push("favIconUrl");
            }
            if (changed.includes("muted")) {
              needed.push("mutedInfo");
            }
            if (changed.includes("soundplaying")) {
              needed.push("audible");
            }
          } else if (event.type == "TabPinned") {
            needed.push("pinned");
          } else if (event.type == "TabUnpinned") {
            needed.push("pinned");
          }

          if (needed.length && !extension.hasPermission("tabs")) {
            needed = needed.filter(attr => attr != "url" && attr != "favIconUrl");
          }

          if (needed.length) {
            let tab = TabManager.convert(extension, event.originalTarget);

            let changeInfo = {};
            for (let prop of needed) {
              changeInfo[prop] = tab[prop];
            }
            fire(tab.id, changeInfo, tab);
          }
        };
        let progressListener = {
          onStateChange(browser, webProgress, request, stateFlags, statusCode) {
            if (!webProgress.isTopLevel) {
              return;
            }

            let status;
            if (stateFlags & Ci.nsIWebProgressListener.STATE_IS_WINDOW) {
              if (stateFlags & Ci.nsIWebProgressListener.STATE_START) {
                status = "loading";
              } else if (stateFlags & Ci.nsIWebProgressListener.STATE_STOP) {
                status = "complete";
              }
            } else if (stateFlags & Ci.nsIWebProgressListener.STATE_STOP &&
                       statusCode == Cr.NS_BINDING_ABORTED) {
              status = "complete";
            }

            fireForBrowser(browser, {status});
          },

          onLocationChange(browser, webProgress, request, locationURI, flags) {
            if (!webProgress.isTopLevel) {
              return;
            }

            fireForBrowser(browser, {
              status: webProgress.isLoadingDocument ? "loading" : "complete",
              url: locationURI.spec,
            });
          },
        };

        AllWindowEvents.addListener("progress", progressListener);
        AllWindowEvents.addListener("TabAttrModified", listener);
        AllWindowEvents.addListener("TabPinned", listener);
        AllWindowEvents.addListener("TabUnpinned", listener);

        return () => {
          AllWindowEvents.removeListener("progress", progressListener);
          AllWindowEvents.removeListener("TabAttrModified", listener);
          AllWindowEvents.removeListener("TabPinned", listener);
          AllWindowEvents.removeListener("TabUnpinned", listener);
        };
      }).api(),

      create: function(createProperties) {
        return new Promise((resolve, reject) => {
          let window = createProperties.windowId !== null ?
            WindowManager.getWindow(createProperties.windowId, context) :
            WindowManager.topWindow;
          if (!window.gBrowser) {
            let obs = (finishedWindow, topic, data) => {
              if (finishedWindow != window) {
                return;
              }
              Services.obs.removeObserver(obs, "browser-delayed-startup-finished");
              resolve(window);
            };
            Services.obs.addObserver(obs, "browser-delayed-startup-finished", false);
          } else {
            resolve(window);
          }
        }).then(window => {
          let url;

          if (createProperties.url !== null) {
            url = context.uri.resolve(createProperties.url);

            if (!context.checkLoadURL(url, {dontReportErrors: true})) {
              return Promise.reject({message: `Illegal URL: ${url}`});
            }
          }

          if (createProperties.cookieStoreId && !extension.hasPermission("cookies")) {
            return Promise.reject({message: `No permission for cookieStoreId: ${createProperties.cookieStoreId}`});
          }

          let options = {};
          if (createProperties.cookieStoreId) {
            if (!global.isValidCookieStoreId(createProperties.cookieStoreId)) {
              return Promise.reject({message: `Illegal cookieStoreId: ${createProperties.cookieStoreId}`});
            }

            let privateWindow = PrivateBrowsingUtils.isBrowserPrivate(window.gBrowser);
            if (privateWindow && !global.isPrivateCookieStoreId(createProperties.cookieStoreId)) {
              return Promise.reject({message: `Illegal to set non-private cookieStorageId in a private window`});
            }

            if (!privateWindow && global.isPrivateCookieStoreId(createProperties.cookieStoreId)) {
              return Promise.reject({message: `Illegal to set private cookieStorageId in a non-private window`});
            }

            if (global.isContainerCookieStoreId(createProperties.cookieStoreId)) {
              let containerId = global.getContainerForCookieStoreId(createProperties.cookieStoreId);
              if (!containerId) {
                return Promise.reject({message: `No cookie store exists with ID ${createProperties.cookieStoreId}`});
              }

              options.userContextId = containerId;
            }
          }

          tabListener.initTabReady();
          let tab = window.gBrowser.addTab(url || window.BROWSER_NEW_TAB_URL, options);

          let active = true;
          if (createProperties.active !== null) {
            active = createProperties.active;
          }
          if (active) {
            window.gBrowser.selectedTab = tab;
          }

          if (createProperties.index !== null) {
            window.gBrowser.moveTabTo(tab, createProperties.index);
          }

          if (createProperties.pinned) {
            window.gBrowser.pinTab(tab);
          }

          if (createProperties.url && !createProperties.url.startsWith("about:")) {
            // We can't wait for a location change event for about:newtab,
            // since it may be pre-rendered, in which case its initial
            // location change event has already fired.

            // Mark the tab as initializing, so that operations like
            // `executeScript` wait until the requested URL is loaded in
            // the tab before dispatching messages to the inner window
            // that contains the URL we're attempting to load.
            tabListener.initializingTabs.add(tab);
          }

          return TabManager.convert(extension, tab);
        });
      },

      remove: function(tabs) {
        if (!Array.isArray(tabs)) {
          tabs = [tabs];
        }

        for (let tabId of tabs) {
          let tab = TabManager.getTab(tabId, context);
          tab.ownerGlobal.gBrowser.removeTab(tab);
        }

        return Promise.resolve();
      },

      update: function(tabId, updateProperties) {
        let tab = tabId !== null ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let tabbrowser = tab.ownerGlobal.gBrowser;

        if (updateProperties.url !== null) {
          let url = context.uri.resolve(updateProperties.url);

          if (!context.checkLoadURL(url, {dontReportErrors: true})) {
            return Promise.reject({message: `Illegal URL: ${url}`});
          }

          tab.linkedBrowser.loadURI(url);
        }

        if (updateProperties.active !== null) {
          if (updateProperties.active) {
            tabbrowser.selectedTab = tab;
          } else {
            // Not sure what to do here? Which tab should we select?
          }
        }
        if (updateProperties.muted !== null) {
          if (tab.muted != updateProperties.muted) {
            tab.toggleMuteAudio(extension.uuid);
          }
        }
        if (updateProperties.pinned !== null) {
          if (updateProperties.pinned) {
            tabbrowser.pinTab(tab);
          } else {
            tabbrowser.unpinTab(tab);
          }
        }
        // FIXME: highlighted/selected, openerTabId

        return Promise.resolve(TabManager.convert(extension, tab));
      },

      reload: function(tabId, reloadProperties) {
        let tab = tabId !== null ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let flags = Ci.nsIWebNavigation.LOAD_FLAGS_NONE;
        if (reloadProperties && reloadProperties.bypassCache) {
          flags |= Ci.nsIWebNavigation.LOAD_FLAGS_BYPASS_CACHE;
        }
        tab.linkedBrowser.reloadWithFlags(flags);

        return Promise.resolve();
      },

      get: function(tabId) {
        let tab = TabManager.getTab(tabId, context);

        return Promise.resolve(TabManager.convert(extension, tab));
      },

      getCurrent() {
        let tab;
        if (context.tabId) {
          tab = TabManager.convert(extension, TabManager.getTab(context.tabId, context));
        }
        return Promise.resolve(tab);
      },

      query: function(queryInfo) {
        let pattern = null;
        if (queryInfo.url !== null) {
          if (!extension.hasPermission("tabs")) {
            return Promise.reject({message: 'The "tabs" permission is required to use the query API with the "url" parameter'});
          }

          pattern = new MatchPattern(queryInfo.url);
        }

        function matches(tab) {
          let props = ["active", "pinned", "highlighted", "status", "title", "index"];
          for (let prop of props) {
            if (queryInfo[prop] !== null && queryInfo[prop] != tab[prop]) {
              return false;
            }
          }

          if (queryInfo.audible !== null) {
            if (queryInfo.audible != tab.audible) {
              return false;
            }
          }

          if (queryInfo.muted !== null) {
            if (queryInfo.muted != tab.mutedInfo.muted) {
              return false;
            }
          }

          if (queryInfo.cookieStoreId !== null &&
              tab.cookieStoreId != queryInfo.cookieStoreId) {
            return false;
          }

          if (pattern && !pattern.matches(Services.io.newURI(tab.url, null, null))) {
            return false;
          }

          return true;
        }

        let result = [];
        for (let window of WindowListManager.browserWindows()) {
          let lastFocused = window === WindowManager.topWindow;
          if (queryInfo.lastFocusedWindow !== null && queryInfo.lastFocusedWindow !== lastFocused) {
            continue;
          }

          let windowType = WindowManager.windowType(window);
          if (queryInfo.windowType !== null && queryInfo.windowType !== windowType) {
            continue;
          }

          if (queryInfo.windowId !== null) {
            if (queryInfo.windowId === WindowManager.WINDOW_ID_CURRENT) {
              if (currentWindow(context) !== window) {
                continue;
              }
            } else if (queryInfo.windowId !== WindowManager.getId(window)) {
              continue;
            }
          }

          if (queryInfo.currentWindow !== null) {
            let eq = window === currentWindow(context);
            if (queryInfo.currentWindow != eq) {
              continue;
            }
          }

          let tabs = TabManager.for(extension).getTabs(window);
          for (let tab of tabs) {
            if (matches(tab)) {
              result.push(tab);
            }
          }
        }
        return Promise.resolve(result);
      },

      captureVisibleTab: function(windowId, options) {
        if (!extension.hasPermission("<all_urls>")) {
          return Promise.reject({message: "The <all_urls> permission is required to use the captureVisibleTab API"});
        }

        let window = windowId == null ?
          WindowManager.topWindow :
          WindowManager.getWindow(windowId, context);

        let tab = window.gBrowser.selectedTab;
        return tabListener.awaitTabReady(tab).then(() => {
          let browser = tab.linkedBrowser;
          let recipient = {
            innerWindowID: browser.innerWindowID,
          };

          if (!options) {
            options = {};
          }
          if (options.format == null) {
            options.format = "png";
          }
          if (options.quality == null) {
            options.quality = 92;
          }

          let message = {
            options,
            width: browser.clientWidth,
            height: browser.clientHeight,
          };

          return context.sendMessage(browser.messageManager, "Extension:Capture",
                                     message, {recipient});
        });
      },

      detectLanguage: function(tabId) {
        let tab = tabId !== null ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        return tabListener.awaitTabReady(tab).then(() => {
          let browser = tab.linkedBrowser;
          let recipient = {innerWindowID: browser.innerWindowID};

          return context.sendMessage(browser.messageManager, "Extension:DetectLanguage",
                                     {}, {recipient});
        });
      },

      // Used to executeScript, insertCSS and removeCSS.
      _execute: function(tabId, details, kind, method) {
        let tab = tabId !== null ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let options = {
          js: [],
          css: [],
          remove_css: method == "removeCSS",
        };

        // We require a `code` or a `file` property, but we can't accept both.
        if ((details.code === null) == (details.file === null)) {
          return Promise.reject({message: `${method} requires either a 'code' or a 'file' property, but not both`});
        }

        if (details.frameId !== null && details.allFrames) {
          return Promise.reject({message: `'frameId' and 'allFrames' are mutually exclusive`});
        }

        if (TabManager.for(extension).hasActiveTabPermission(tab)) {
          // If we have the "activeTab" permission for this tab, ignore
          // the host whitelist.
          options.matchesHost = ["<all_urls>"];
        } else {
          options.matchesHost = extension.whiteListedHosts.serialize();
        }

        if (details.code !== null) {
          options[kind + "Code"] = details.code;
        }
        if (details.file !== null) {
          let url = context.uri.resolve(details.file);
          if (!extension.isExtensionURL(url)) {
            return Promise.reject({message: "Files to be injected must be within the extension"});
          }
          options[kind].push(url);
        }
        if (details.allFrames) {
          options.all_frames = details.allFrames;
        }
        if (details.frameId !== null) {
          options.frame_id = details.frameId;
        }
        if (details.matchAboutBlank) {
          options.match_about_blank = details.matchAboutBlank;
        }
        if (details.runAt !== null) {
          options.run_at = details.runAt;
        } else {
          options.run_at = "document_idle";
        }

        return tabListener.awaitTabReady(tab).then(() => {
          let browser = tab.linkedBrowser;
          let recipient = {
            innerWindowID: browser.innerWindowID,
          };

          return context.sendMessage(browser.messageManager, "Extension:Execute", {options}, {recipient});
        });
      },

      executeScript: function(tabId, details) {
        return self.tabs._execute(tabId, details, "js", "executeScript");
      },

      insertCSS: function(tabId, details) {
        return self.tabs._execute(tabId, details, "css", "insertCSS").then(() => {});
      },

      removeCSS: function(tabId, details) {
        return self.tabs._execute(tabId, details, "css", "removeCSS").then(() => {});
      },

      move: function(tabIds, moveProperties) {
        let index = moveProperties.index;
        let tabsMoved = [];
        if (!Array.isArray(tabIds)) {
          tabIds = [tabIds];
        }

        let destinationWindow = null;
        if (moveProperties.windowId !== null) {
          destinationWindow = WindowManager.getWindow(moveProperties.windowId, context);
          // Fail on an invalid window.
          if (!destinationWindow) {
            return Promise.reject({message: `Invalid window ID: ${moveProperties.windowId}`});
          }
        }

        /*
          Indexes are maintained on a per window basis so that a call to
            move([tabA, tabB], {index: 0})
              -> tabA to 0, tabB to 1 if tabA and tabB are in the same window
            move([tabA, tabB], {index: 0})
              -> tabA to 0, tabB to 0 if tabA and tabB are in different windows
        */
        let indexMap = new Map();

        let tabs = tabIds.map(tabId => TabManager.getTab(tabId, context));
        for (let tab of tabs) {
          // If the window is not specified, use the window from the tab.
          let window = destinationWindow || tab.ownerGlobal;
          let gBrowser = window.gBrowser;

          let insertionPoint = indexMap.get(window) || index;
          // If the index is -1 it should go to the end of the tabs.
          if (insertionPoint == -1) {
            insertionPoint = gBrowser.tabs.length;
          }

          // We can only move pinned tabs to a point within, or just after,
          // the current set of pinned tabs. Unpinned tabs, likewise, can only
          // be moved to a position after the current set of pinned tabs.
          // Attempts to move a tab to an illegal position are ignored.
          let numPinned = gBrowser._numPinnedTabs;
          let ok = tab.pinned ? insertionPoint <= numPinned : insertionPoint >= numPinned;
          if (!ok) {
            continue;
          }

          indexMap.set(window, insertionPoint + 1);

          if (tab.ownerGlobal != window) {
            // If the window we are moving the tab in is different, then move the tab
            // to the new window.
            tab = gBrowser.adoptTab(tab, insertionPoint, false);
          } else {
            // If the window we are moving is the same, just move the tab.
            gBrowser.moveTabTo(tab, insertionPoint);
          }
          tabsMoved.push(tab);
        }

        return Promise.resolve(tabsMoved.map(tab => TabManager.convert(extension, tab)));
      },

      duplicate: function(tabId) {
        let tab = TabManager.getTab(tabId, context);

        let gBrowser = tab.ownerGlobal.gBrowser;
        let newTab = gBrowser.duplicateTab(tab);

        return new Promise(resolve => {
          // We need to use SSTabRestoring because any attributes set before
          // are ignored. SSTabRestored is too late and results in a jump in
          // the UI. See http://bit.ly/session-store-api for more information.
          newTab.addEventListener("SSTabRestoring", function listener() {
            // As the tab is restoring, move it to the correct position.
            newTab.removeEventListener("SSTabRestoring", listener);
            // Pinned tabs that are duplicated are inserted
            // after the existing pinned tab and pinned.
            if (tab.pinned) {
              gBrowser.pinTab(newTab);
            }
            gBrowser.moveTabTo(newTab, tab._tPos + 1);
          });

          newTab.addEventListener("SSTabRestored", function listener() {
            // Once it has been restored, select it and return the promise.
            newTab.removeEventListener("SSTabRestored", listener);
            gBrowser.selectedTab = newTab;
            return resolve(TabManager.convert(extension, newTab));
          });
        });
      },

      getZoom(tabId) {
        let tab = tabId ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let {ZoomManager} = tab.ownerGlobal;
        let zoom = ZoomManager.getZoomForBrowser(tab.linkedBrowser);

        return Promise.resolve(zoom);
      },

      setZoom(tabId, zoom) {
        let tab = tabId ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let {FullZoom, ZoomManager} = tab.ownerGlobal;

        if (zoom === 0) {
          // A value of zero means use the default zoom factor.
          return FullZoom.reset(tab.linkedBrowser);
        } else if (zoom >= ZoomManager.MIN && zoom <= ZoomManager.MAX) {
          FullZoom.setZoom(zoom, tab.linkedBrowser);
        } else {
          return Promise.reject({
            message: `Zoom value ${zoom} out of range (must be between ${ZoomManager.MIN} and ${ZoomManager.MAX})`,
          });
        }

        return Promise.resolve();
      },

      _getZoomSettings(tabId) {
        let tab = tabId ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let {FullZoom} = tab.ownerGlobal;

        return {
          mode: "automatic",
          scope: FullZoom.siteSpecific ? "per-origin" : "per-tab",
          defaultZoomFactor: 1,
        };
      },

      getZoomSettings(tabId) {
        return Promise.resolve(this._getZoomSettings(tabId));
      },

      setZoomSettings(tabId, settings) {
        let tab = tabId ? TabManager.getTab(tabId, context) : TabManager.activeTab;

        let currentSettings = this._getZoomSettings(tab.id);

        if (!Object.keys(settings).every(key => settings[key] === currentSettings[key])) {
          return Promise.reject(`Unsupported zoom settings: ${JSON.stringify(settings)}`);
        }
        return Promise.resolve();
      },

      onZoomChange: new EventManager(context, "tabs.onZoomChange", fire => {
        let getZoomLevel = browser => {
          let {ZoomManager} = browser.ownerGlobal;

          return ZoomManager.getZoomForBrowser(browser);
        };

        // Stores the last known zoom level for each tab's browser.
        // WeakMap[<browser> -> number]
        let zoomLevels = new WeakMap();

        // Store the zoom level for all existing tabs.
        for (let window of WindowListManager.browserWindows()) {
          for (let tab of window.gBrowser.tabs) {
            let browser = tab.linkedBrowser;
            zoomLevels.set(browser, getZoomLevel(browser));
          }
        }

        let tabCreated = (eventName, event) => {
          let browser = event.tab.linkedBrowser;
          zoomLevels.set(browser, getZoomLevel(browser));
        };


        let zoomListener = event => {
          let browser = event.originalTarget;

          // For non-remote browsers, this event is dispatched on the document
          // rather than on the <browser>.
          if (browser instanceof Ci.nsIDOMDocument) {
            browser = browser.defaultView.QueryInterface(Ci.nsIInterfaceRequestor)
                             .getInterface(Ci.nsIDocShell)
                             .chromeEventHandler;
          }

          let {gBrowser} = browser.ownerGlobal;
          let tab = gBrowser.getTabForBrowser(browser);
          if (!tab) {
            // We only care about zoom events in the top-level browser of a tab.
            return;
          }

          let oldZoomFactor = zoomLevels.get(browser);
          let newZoomFactor = getZoomLevel(browser);

          if (oldZoomFactor != newZoomFactor) {
            zoomLevels.set(browser, newZoomFactor);

            let tabId = TabManager.getId(tab);
            fire({
              tabId,
              oldZoomFactor,
              newZoomFactor,
              zoomSettings: self.tabs._getZoomSettings(tabId),
            });
          }
        };

        tabListener.on("tab-attached", tabCreated);
        tabListener.on("tab-created", tabCreated);

        AllWindowEvents.addListener("FullZoomChange", zoomListener);
        AllWindowEvents.addListener("TextZoomChange", zoomListener);
        return () => {
          tabListener.off("tab-attached", tabCreated);
          tabListener.off("tab-created", tabCreated);

          AllWindowEvents.removeListener("FullZoomChange", zoomListener);
          AllWindowEvents.removeListener("TextZoomChange", zoomListener);
        };
      }).api(),
    },
  };
  return self;
});
