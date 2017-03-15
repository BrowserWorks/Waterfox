/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";
const {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

this.EXPORTED_SYMBOLS = ["CustomizableWidgets"];

Cu.import("resource:///modules/CustomizableUI.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "BrowserUITelemetry",
  "resource:///modules/BrowserUITelemetry.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
  "resource://gre/modules/PlacesUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PlacesUIUtils",
  "resource:///modules/PlacesUIUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "RecentlyClosedTabsAndWindowsMenuUtils",
  "resource:///modules/sessionstore/RecentlyClosedTabsAndWindowsMenuUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ShortcutUtils",
  "resource://gre/modules/ShortcutUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "CharsetMenu",
  "resource://gre/modules/CharsetMenu.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "SyncedTabs",
  "resource://services-sync/SyncedTabs.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ContextualIdentityService",
  "resource://gre/modules/ContextualIdentityService.jsm");

XPCOMUtils.defineLazyGetter(this, "CharsetBundle", function() {
  const kCharsetBundle = "chrome://global/locale/charsetMenu.properties";
  return Services.strings.createBundle(kCharsetBundle);
});
XPCOMUtils.defineLazyGetter(this, "BrandBundle", function() {
  const kBrandBundle = "chrome://branding/locale/brand.properties";
  return Services.strings.createBundle(kBrandBundle);
});

const kNSXUL = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
const kPrefCustomizationDebug = "browser.uiCustomization.debug";
const kWidePanelItemClass = "panel-wide-item";

XPCOMUtils.defineLazyGetter(this, "log", () => {
  let scope = {};
  Cu.import("resource://gre/modules/Console.jsm", scope);
  let debug;
  try {
    debug = Services.prefs.getBoolPref(kPrefCustomizationDebug);
  } catch (ex) {}
  let consoleOptions = {
    maxLogLevel: debug ? "all" : "log",
    prefix: "CustomizableWidgets",
  };
  return new scope.ConsoleAPI(consoleOptions);
});



function setAttributes(aNode, aAttrs) {
  let doc = aNode.ownerDocument;
  for (let [name, value] of Object.entries(aAttrs)) {
    if (!value) {
      if (aNode.hasAttribute(name))
        aNode.removeAttribute(name);
    } else {
      if (name == "shortcutId") {
        continue;
      }
      if (name == "label" || name == "tooltiptext") {
        let stringId = (typeof value == "string") ? value : name;
        let additionalArgs = [];
        if (aAttrs.shortcutId) {
          let shortcut = doc.getElementById(aAttrs.shortcutId);
          if (shortcut) {
            additionalArgs.push(ShortcutUtils.prettifyShortcut(shortcut));
          }
        }
        value = CustomizableUI.getLocalizedProperty({id: aAttrs.id}, stringId, additionalArgs);
      }
      aNode.setAttribute(name, value);
    }
  }
}

function updateCombinedWidgetStyle(aNode, aArea, aModifyCloseMenu) {
  let inPanel = (aArea == CustomizableUI.AREA_PANEL);
  let cls = inPanel ? "panel-combined-button" : "toolbarbutton-1 toolbarbutton-combined";
  let attrs = {class: cls};
  if (aModifyCloseMenu) {
    attrs.closemenu = inPanel ? "none" : null;
  }
  for (let i = 0, l = aNode.childNodes.length; i < l; ++i) {
    if (aNode.childNodes[i].localName == "separator")
      continue;
    setAttributes(aNode.childNodes[i], attrs);
  }
}

function fillSubviewFromMenuItems(aMenuItems, aSubview) {
  let attrs = ["oncommand", "onclick", "label", "key", "disabled",
               "command", "observes", "hidden", "class", "origin",
               "image", "checked"];

  let doc = aSubview.ownerDocument;
  let fragment = doc.createDocumentFragment();
  for (let menuChild of aMenuItems) {
    if (menuChild.hidden)
      continue;

    let subviewItem;
    if (menuChild.localName == "menuseparator") {
      // Don't insert duplicate or leading separators. This can happen if there are
      // menus (which we don't copy) above the separator.
      if (!fragment.lastChild || fragment.lastChild.localName == "menuseparator") {
        continue;
      }
      subviewItem = doc.createElementNS(kNSXUL, "menuseparator");
    } else if (menuChild.localName == "menuitem") {
      subviewItem = doc.createElementNS(kNSXUL, "toolbarbutton");
      CustomizableUI.addShortcut(menuChild, subviewItem);

      let item = menuChild;
      if (!item.hasAttribute("onclick")) {
        subviewItem.addEventListener("click", event => {
          let newEvent = new doc.defaultView.MouseEvent(event.type, event);
          item.dispatchEvent(newEvent);
        });
      }

      if (!item.hasAttribute("oncommand")) {
        subviewItem.addEventListener("command", event => {
          let newEvent = doc.createEvent("XULCommandEvent");
          newEvent.initCommandEvent(
            event.type, event.bubbles, event.cancelable, event.view,
            event.detail, event.ctrlKey, event.altKey, event.shiftKey,
            event.metaKey, event.sourceEvent);
          item.dispatchEvent(newEvent);
        });
      }
    } else {
      continue;
    }
    for (let attr of attrs) {
      let attrVal = menuChild.getAttribute(attr);
      if (attrVal)
        subviewItem.setAttribute(attr, attrVal);
    }
    // We do this after so the .subviewbutton class doesn't get overriden.
    if (menuChild.localName == "menuitem") {
      subviewItem.classList.add("subviewbutton");
    }
    fragment.appendChild(subviewItem);
  }
  aSubview.appendChild(fragment);
}

function clearSubview(aSubview) {
  let parent = aSubview.parentNode;
  // We'll take the container out of the document before cleaning it out
  // to avoid reflowing each time we remove something.
  parent.removeChild(aSubview);

  while (aSubview.firstChild) {
    aSubview.firstChild.remove();
  }

  parent.appendChild(aSubview);
}

const CustomizableWidgets = [
  {
    id: "history-panelmenu",
    type: "view",
    viewId: "PanelUI-history",
    shortcutId: "key_gotoHistory",
    tooltiptext: "history-panelmenu.tooltiptext2",
    defaultArea: CustomizableUI.AREA_PANEL,
    onViewShowing: function(aEvent) {
      // Populate our list of history
      const kMaxResults = 15;
      let doc = aEvent.target.ownerDocument;
      let win = doc.defaultView;

      let options = PlacesUtils.history.getNewQueryOptions();
      options.excludeQueries = true;
      options.queryType = options.QUERY_TYPE_HISTORY;
      options.sortingMode = options.SORT_BY_DATE_DESCENDING;
      options.maxResults = kMaxResults;
      let query = PlacesUtils.history.getNewQuery();

      let items = doc.getElementById("PanelUI-historyItems");
      // Clear previous history items.
      while (items.firstChild) {
        items.firstChild.remove();
      }

      // Get all statically placed buttons to supply them with keyboard shortcuts.
      let staticButtons = items.parentNode.getElementsByTagNameNS(kNSXUL, "toolbarbutton");
      for (let i = 0, l = staticButtons.length; i < l; ++i)
        CustomizableUI.addShortcut(staticButtons[i]);

      PlacesUtils.history.QueryInterface(Ci.nsPIPlacesDatabase)
                         .asyncExecuteLegacyQueries([query], 1, options, {
        handleResult: function (aResultSet) {
          let onItemCommand = function (aEvent) {
            // Only handle the click event for middle clicks, we're using the command
            // event otherwise.
            if (aEvent.type == "click" && aEvent.button != 1) {
              return;
            }
            let item = aEvent.target;
            win.openUILink(item.getAttribute("targetURI"), aEvent);
            CustomizableUI.hidePanelForNode(item);
          };
          let fragment = doc.createDocumentFragment();
          let row;
          while ((row = aResultSet.getNextRow())) {
            let uri = row.getResultByIndex(1);
            let title = row.getResultByIndex(2);
            let icon = row.getResultByIndex(6);

            let item = doc.createElementNS(kNSXUL, "toolbarbutton");
            item.setAttribute("label", title || uri);
            item.setAttribute("targetURI", uri);
            item.setAttribute("class", "subviewbutton");
            item.addEventListener("command", onItemCommand);
            item.addEventListener("click", onItemCommand);
            if (icon) {
              let iconURL = "moz-anno:favicon:" + icon;
              item.setAttribute("image", iconURL);
            }
            fragment.appendChild(item);
          }
          items.appendChild(fragment);
        },
        handleError: function (aError) {
          log.debug("History view tried to show but had an error: " + aError);
        },
        handleCompletion: function (aReason) {
          log.debug("History view is being shown!");
        },
      });

      let recentlyClosedTabs = doc.getElementById("PanelUI-recentlyClosedTabs");
      while (recentlyClosedTabs.firstChild) {
        recentlyClosedTabs.removeChild(recentlyClosedTabs.firstChild);
      }

      let recentlyClosedWindows = doc.getElementById("PanelUI-recentlyClosedWindows");
      while (recentlyClosedWindows.firstChild) {
        recentlyClosedWindows.removeChild(recentlyClosedWindows.firstChild);
      }

      let utils = RecentlyClosedTabsAndWindowsMenuUtils;
      let tabsFragment = utils.getTabsFragment(doc.defaultView, "toolbarbutton", true,
                                               "menuRestoreAllTabsSubview.label");
      let separator = doc.getElementById("PanelUI-recentlyClosedTabs-separator");
      let elementCount = tabsFragment.childElementCount;
      separator.hidden = !elementCount;
      while (--elementCount >= 0) {
        tabsFragment.children[elementCount].classList.add("subviewbutton", "cui-withicon");
      }
      recentlyClosedTabs.appendChild(tabsFragment);

      let windowsFragment = utils.getWindowsFragment(doc.defaultView, "toolbarbutton", true,
                                                     "menuRestoreAllWindowsSubview.label");
      separator = doc.getElementById("PanelUI-recentlyClosedWindows-separator");
      elementCount = windowsFragment.childElementCount;
      separator.hidden = !elementCount;
      while (--elementCount >= 0) {
        windowsFragment.children[elementCount].classList.add("subviewbutton", "cui-withicon");
      }
      recentlyClosedWindows.appendChild(windowsFragment);
    },
    onCreated: function(aNode) {
      // Middle clicking recently closed items won't close the panel - cope:
      let onRecentlyClosedClick = function(aEvent) {
        if (aEvent.button == 1) {
          CustomizableUI.hidePanelForNode(this);
        }
      };
      let doc = aNode.ownerDocument;
      let recentlyClosedTabs = doc.getElementById("PanelUI-recentlyClosedTabs");
      let recentlyClosedWindows = doc.getElementById("PanelUI-recentlyClosedWindows");
      recentlyClosedTabs.addEventListener("click", onRecentlyClosedClick);
      recentlyClosedWindows.addEventListener("click", onRecentlyClosedClick);
    },
    onViewHiding: function(aEvent) {
      log.debug("History view is being hidden!");
    }
  }, {
    id: "sync-button",
    label: "remotetabs-panelmenu.label",
    tooltiptext: "remotetabs-panelmenu.tooltiptext2",
    type: "view",
    viewId: "PanelUI-remotetabs",
    defaultArea: CustomizableUI.AREA_PANEL,
    deckIndices: {
      DECKINDEX_TABS: 0,
      DECKINDEX_TABSDISABLED: 1,
      DECKINDEX_FETCHING: 2,
      DECKINDEX_NOCLIENTS: 3,
    },
    onCreated(aNode) {
      // Add an observer to the button so we get the animation during sync.
      // (Note the observer sets many attributes, including label and
      // tooltiptext, but we only want the 'syncstatus' attribute for the
      // animation)
      let doc = aNode.ownerDocument;
      let obnode = doc.createElementNS(kNSXUL, "observes");
      obnode.setAttribute("element", "sync-status");
      obnode.setAttribute("attribute", "syncstatus");
      aNode.appendChild(obnode);

      // A somewhat complicated dance to format the mobilepromo label.
      let bundle = doc.getElementById("bundle_browser");
      let formatArgs = ["android", "ios"].map(os => {
        let link = doc.createElement("label");
        link.textContent = bundle.getString(`appMenuRemoteTabs.mobilePromo.${os}`);
        link.setAttribute("mobile-promo-os", os);
        link.className = "text-link remotetabs-promo-link";
        return link.outerHTML;
      });
      let promoParentElt = doc.getElementById("PanelUI-remotetabs-mobile-promo");
      // Put it all together...
      let contents = bundle.getFormattedString("appMenuRemoteTabs.mobilePromo.text2", formatArgs);
      promoParentElt.innerHTML = contents;
      // We manually manage the "click" event to open the promo links because
      // allowing the "text-link" widget handle it has 2 problems: (1) it only
      // supports button 0 and (2) it's tricky to intercept when it does the
      // open and auto-close the panel. (1) can probably be fixed, but (2) is
      // trickier without hard-coding here the knowledge of exactly what buttons
      // it does support.
      // So we allow left and middle clicks to open the link in a new tab and
      // close the panel; not setting a "href" attribute prevents the text-link
      // widget handling it, and we build the final URL in the click handler to
      // make testing easier (ie, so tests can change the pref after the links
      // were created and have the new pref value used.)
      promoParentElt.addEventListener("click", e => {
        let os = e.target.getAttribute("mobile-promo-os");
        if (!os || e.button > 1) {
          return;
        }
        let link = Services.prefs.getCharPref(`identity.mobilepromo.${os}`) + "synced-tabs";
        doc.defaultView.openUILinkIn(link, "tab");
        CustomizableUI.hidePanelForNode(e.target);
      });
    },
    onViewShowing(aEvent) {
      let doc = aEvent.target.ownerDocument;
      this._tabsList = doc.getElementById("PanelUI-remotetabs-tabslist");
      Services.obs.addObserver(this, SyncedTabs.TOPIC_TABS_CHANGED, false);

      if (SyncedTabs.isConfiguredToSyncTabs) {
        if (SyncedTabs.hasSyncedThisSession) {
          this.setDeckIndex(this.deckIndices.DECKINDEX_TABS);
        } else {
          // Sync hasn't synced tabs yet, so show the "fetching" panel.
          this.setDeckIndex(this.deckIndices.DECKINDEX_FETCHING);
        }
        // force a background sync.
        SyncedTabs.syncTabs().catch(ex => {
          Cu.reportError(ex);
        });
        // show the current list - it will be updated by our observer.
        this._showTabs();
      } else {
        // not configured to sync tabs, so no point updating the list.
        this.setDeckIndex(this.deckIndices.DECKINDEX_TABSDISABLED);
      }
    },
    onViewHiding() {
      Services.obs.removeObserver(this, SyncedTabs.TOPIC_TABS_CHANGED);
      this._tabsList = null;
    },
    _tabsList: null,
    observe(subject, topic, data) {
      switch (topic) {
        case SyncedTabs.TOPIC_TABS_CHANGED:
          this._showTabs();
          break;
        default:
          break;
      }
    },
    setDeckIndex(index) {
      let deck = this._tabsList.ownerDocument.getElementById("PanelUI-remotetabs-deck");
      // We call setAttribute instead of relying on the XBL property setter due
      // to things going wrong when we try and set the index before the XBL
      // binding has been created - see bug 1241851 for the gory details.
      deck.setAttribute("selectedIndex", index);
    },

    _showTabsPromise: Promise.resolve(),
    // Update the tab list after any existing in-flight updates are complete.
    _showTabs() {
      this._showTabsPromise = this._showTabsPromise.then(() => {
        return this.__showTabs();
      });
    },
    // Return a new promise to update the tab list.
    __showTabs() {
      let doc = this._tabsList.ownerDocument;
      return SyncedTabs.getTabClients().then(clients => {
        // The view may have been hidden while the promise was resolving.
        if (!this._tabsList) {
          return;
        }
        if (clients.length === 0 && !SyncedTabs.hasSyncedThisSession) {
          // the "fetching tabs" deck is being shown - let's leave it there.
          // When that first sync completes we'll be notified and update.
          return;
        }

        if (clients.length === 0) {
          this.setDeckIndex(this.deckIndices.DECKINDEX_NOCLIENTS);
          return;
        }

        this.setDeckIndex(this.deckIndices.DECKINDEX_TABS);
        this._clearTabList();
        SyncedTabs.sortTabClientsByLastUsed(clients, 50 /* maxTabs */);
        let fragment = doc.createDocumentFragment();

        for (let client of clients) {
          // add a menu separator for all clients other than the first.
          if (fragment.lastChild) {
            let separator = doc.createElementNS(kNSXUL, "menuseparator");
            fragment.appendChild(separator);
          }
          this._appendClient(client, fragment);
        }
        this._tabsList.appendChild(fragment);
      }).catch(err => {
        Cu.reportError(err);
      }).then(() => {
        // an observer for tests.
        Services.obs.notifyObservers(null, "synced-tabs-menu:test:tabs-updated", null);
      });
    },
    _clearTabList () {
      let list = this._tabsList;
      while (list.lastChild) {
        list.lastChild.remove();
      }
    },
    _showNoClientMessage() {
      this._appendMessageLabel("notabslabel");
    },
    _appendMessageLabel(messageAttr, appendTo = null) {
      if (!appendTo) {
        appendTo = this._tabsList;
      }
      let message = this._tabsList.getAttribute(messageAttr);
      let doc = this._tabsList.ownerDocument;
      let messageLabel = doc.createElementNS(kNSXUL, "label");
      messageLabel.textContent = message;
      appendTo.appendChild(messageLabel);
      return messageLabel;
    },
    _appendClient: function (client, attachFragment) {
      let doc = attachFragment.ownerDocument;
      // Create the element for the remote client.
      let clientItem = doc.createElementNS(kNSXUL, "label");
      clientItem.setAttribute("itemtype", "client");
      let window = doc.defaultView;
      clientItem.setAttribute("tooltiptext",
        window.gSyncUI.formatLastSyncDate(new Date(client.lastModified)));
      clientItem.textContent = client.name;

      attachFragment.appendChild(clientItem);

      if (client.tabs.length == 0) {
        let label = this._appendMessageLabel("notabsforclientlabel", attachFragment);
        label.setAttribute("class", "PanelUI-remotetabs-notabsforclient-label");
      } else {
        for (let tab of client.tabs) {
          let tabEnt = this._createTabElement(doc, tab);
          attachFragment.appendChild(tabEnt);
        }
      }
    },
    _createTabElement(doc, tabInfo) {
      let item = doc.createElementNS(kNSXUL, "toolbarbutton");
      let tooltipText = (tabInfo.title ? tabInfo.title + "\n" : "") + tabInfo.url;
      item.setAttribute("itemtype", "tab");
      item.setAttribute("class", "subviewbutton");
      item.setAttribute("targetURI", tabInfo.url);
      item.setAttribute("label", tabInfo.title != "" ? tabInfo.title : tabInfo.url);
      item.setAttribute("image", tabInfo.icon);
      item.setAttribute("tooltiptext", tooltipText);
      // We need to use "click" instead of "command" here so openUILink
      // respects different buttons (eg, to open in a new tab).
      item.addEventListener("click", e => {
        doc.defaultView.openUILink(tabInfo.url, e);
        CustomizableUI.hidePanelForNode(item);
        BrowserUITelemetry.countSyncedTabEvent("open", "toolbarbutton-subview");
      });
      return item;
    },
  }, {
    id: "privatebrowsing-button",
    shortcutId: "key_privatebrowsing",
    defaultArea: CustomizableUI.AREA_PANEL,
    onCommand: function(e) {
      let win = e.target.ownerGlobal;
      win.OpenBrowserWindow({private: true});
    }
  }, {
    id: "save-page-button",
    shortcutId: "key_savePage",
    tooltiptext: "save-page-button.tooltiptext3",
    defaultArea: CustomizableUI.AREA_PANEL,
    onCommand: function(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.saveBrowser(win.gBrowser.selectedBrowser);
    }
  }, {
    id: "find-button",
    shortcutId: "key_find",
    tooltiptext: "find-button.tooltiptext3",
    defaultArea: CustomizableUI.AREA_PANEL,
    onCommand: function(aEvent) {
      let win = aEvent.target.ownerGlobal;
      if (win.gFindBar) {
        win.gFindBar.onFindCommand();
      }
    }
  }, {
    id: "open-file-button",
    shortcutId: "openFileKb",
    tooltiptext: "open-file-button.tooltiptext3",
    defaultArea: CustomizableUI.AREA_PANEL,
    onCommand: function(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.BrowserOpenFileWindow();
    }
  }, {
    id: "sidebar-button",
    type: "view",
    viewId: "PanelUI-sidebar",
    tooltiptext: "sidebar-button.tooltiptext2",
    onViewShowing: function(aEvent) {
      // Populate the subview with whatever menuitems are in the
      // sidebar menu. We skip menu elements, because the menu panel has no way
      // of dealing with those right now.
      let doc = aEvent.target.ownerDocument;
      let menu = doc.getElementById("viewSidebarMenu");

      // First clear any existing menuitems then populate. Add it to the
      // standard menu first, then copy all sidebar options to the panel.
      let sidebarItems = doc.getElementById("PanelUI-sidebarItems");
      clearSubview(sidebarItems);
      fillSubviewFromMenuItems([...menu.children], sidebarItems);
    }
  }, {
    id: "social-share-button",
    // custom build our button so we can attach to the share command
    type: "custom",
    onBuild: function(aDocument) {
      let node = aDocument.createElementNS(kNSXUL, "toolbarbutton");
      node.setAttribute("id", this.id);
      node.classList.add("toolbarbutton-1");
      node.classList.add("chromeclass-toolbar-additional");
      node.setAttribute("label", CustomizableUI.getLocalizedProperty(this, "label"));
      node.setAttribute("tooltiptext", CustomizableUI.getLocalizedProperty(this, "tooltiptext"));
      node.setAttribute("removable", "true");
      node.setAttribute("observes", "Social:PageShareable");
      node.setAttribute("command", "Social:SharePage");

      let listener = {
        onWidgetAdded: (aWidgetId) => {
          if (aWidgetId != this.id)
            return;

          Services.obs.notifyObservers(null, "social:" + this.id + "-added", null);
        },

        onWidgetRemoved: aWidgetId => {
          if (aWidgetId != this.id)
            return;

          Services.obs.notifyObservers(null, "social:" + this.id + "-removed", null);
        },

        onWidgetInstanceRemoved: (aWidgetId, aDoc) => {
          if (aWidgetId != this.id || aDoc != aDocument)
            return;

          CustomizableUI.removeListener(listener);
        }
      };
      CustomizableUI.addListener(listener);

      return node;
    }
  }, {
    id: "add-ons-button",
    shortcutId: "key_openAddons",
    tooltiptext: "add-ons-button.tooltiptext3",
    defaultArea: CustomizableUI.AREA_PANEL,
    onCommand: function(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.BrowserOpenAddonsMgr();
    }
  }, {
    id: "zoom-controls",
    type: "custom",
    tooltiptext: "zoom-controls.tooltiptext2",
    defaultArea: CustomizableUI.AREA_PANEL,
    onBuild: function(aDocument) {
      const kPanelId = "PanelUI-popup";
      let areaType = CustomizableUI.getAreaType(this.currentArea);
      let inPanel = areaType == CustomizableUI.TYPE_MENU_PANEL;
      let inToolbar = areaType == CustomizableUI.TYPE_TOOLBAR;

      let buttons = [{
        id: "zoom-out-button",
        command: "cmd_fullZoomReduce",
        label: true,
        tooltiptext: "tooltiptext2",
        shortcutId: "key_fullZoomReduce",
      }, {
        id: "zoom-reset-button",
        command: "cmd_fullZoomReset",
        tooltiptext: "tooltiptext2",
        shortcutId: "key_fullZoomReset",
      }, {
        id: "zoom-in-button",
        command: "cmd_fullZoomEnlarge",
        label: true,
        tooltiptext: "tooltiptext2",
        shortcutId: "key_fullZoomEnlarge",
      }];

      let node = aDocument.createElementNS(kNSXUL, "toolbaritem");
      node.setAttribute("id", "zoom-controls");
      node.setAttribute("label", CustomizableUI.getLocalizedProperty(this, "label"));
      node.setAttribute("title", CustomizableUI.getLocalizedProperty(this, "tooltiptext"));
      // Set this as an attribute in addition to the property to make sure we can style correctly.
      node.setAttribute("removable", "true");
      node.classList.add("chromeclass-toolbar-additional");
      node.classList.add("toolbaritem-combined-buttons");
      node.classList.add(kWidePanelItemClass);

      buttons.forEach(function(aButton, aIndex) {
        if (aIndex != 0)
          node.appendChild(aDocument.createElementNS(kNSXUL, "separator"));
        let btnNode = aDocument.createElementNS(kNSXUL, "toolbarbutton");
        setAttributes(btnNode, aButton);
        node.appendChild(btnNode);
      });

      // The middle node is the 'Reset Zoom' button.
      let zoomResetButton = node.childNodes[2];
      let window = aDocument.defaultView;
      function updateZoomResetButton() {
        let updateDisplay = true;
        // Label should always show 100% in customize mode, so don't update:
        if (aDocument.documentElement.hasAttribute("customizing")) {
          updateDisplay = false;
        }
        // XXXgijs in some tests we get called very early, and there's no docShell on the
        // tabbrowser. This breaks the zoom toolkit code (see bug 897410). Don't let that happen:
        let zoomFactor = 100;
        try {
          zoomFactor = Math.round(window.ZoomManager.zoom * 100);
        } catch (e) {}
        zoomResetButton.setAttribute("label", CustomizableUI.getLocalizedProperty(
          buttons[1], "label", [updateDisplay ? zoomFactor : 100]
        ));
      }

      // Register ourselves with the service so we know when the zoom prefs change.
      Services.obs.addObserver(updateZoomResetButton, "browser-fullZoom:zoomChange", false);
      Services.obs.addObserver(updateZoomResetButton, "browser-fullZoom:zoomReset", false);
      Services.obs.addObserver(updateZoomResetButton, "browser-fullZoom:location-change", false);

      if (inPanel) {
        let panel = aDocument.getElementById(kPanelId);
        panel.addEventListener("popupshowing", updateZoomResetButton);
      } else {
        if (inToolbar) {
          let container = window.gBrowser.tabContainer;
          container.addEventListener("TabSelect", updateZoomResetButton);
        }
        updateZoomResetButton();
      }
      updateCombinedWidgetStyle(node, this.currentArea, true);

      let listener = {
        onWidgetAdded: function(aWidgetId, aArea, aPosition) {
          if (aWidgetId != this.id)
            return;

          updateCombinedWidgetStyle(node, aArea, true);
          updateZoomResetButton();

          let areaType = CustomizableUI.getAreaType(aArea);
          if (areaType == CustomizableUI.TYPE_MENU_PANEL) {
            let panel = aDocument.getElementById(kPanelId);
            panel.addEventListener("popupshowing", updateZoomResetButton);
          } else if (areaType == CustomizableUI.TYPE_TOOLBAR) {
            let container = window.gBrowser.tabContainer;
            container.addEventListener("TabSelect", updateZoomResetButton);
          }
        }.bind(this),

        onWidgetRemoved: function(aWidgetId, aPrevArea) {
          if (aWidgetId != this.id)
            return;

          let areaType = CustomizableUI.getAreaType(aPrevArea);
          if (areaType == CustomizableUI.TYPE_MENU_PANEL) {
            let panel = aDocument.getElementById(kPanelId);
            panel.removeEventListener("popupshowing", updateZoomResetButton);
          } else if (areaType == CustomizableUI.TYPE_TOOLBAR) {
            let container = window.gBrowser.tabContainer;
            container.removeEventListener("TabSelect", updateZoomResetButton);
          }

          // When a widget is demoted to the palette ('removed'), it's visual
          // style should change.
          updateCombinedWidgetStyle(node, null, true);
          updateZoomResetButton();
        }.bind(this),

        onWidgetReset: function(aWidgetNode) {
          if (aWidgetNode != node)
            return;
          updateCombinedWidgetStyle(node, this.currentArea, true);
          updateZoomResetButton();
        }.bind(this),

        onWidgetUndoMove: function(aWidgetNode) {
          if (aWidgetNode != node)
            return;
          updateCombinedWidgetStyle(node, this.currentArea, true);
          updateZoomResetButton();
        }.bind(this),

        onWidgetMoved: function(aWidgetId, aArea) {
          if (aWidgetId != this.id)
            return;
          updateCombinedWidgetStyle(node, aArea, true);
          updateZoomResetButton();
        }.bind(this),

        onWidgetInstanceRemoved: function(aWidgetId, aDoc) {
          if (aWidgetId != this.id || aDoc != aDocument)
            return;

          CustomizableUI.removeListener(listener);
          Services.obs.removeObserver(updateZoomResetButton, "browser-fullZoom:zoomChange");
          Services.obs.removeObserver(updateZoomResetButton, "browser-fullZoom:zoomReset");
          Services.obs.removeObserver(updateZoomResetButton, "browser-fullZoom:location-change");
          let panel = aDoc.getElementById(kPanelId);
          panel.removeEventListener("popupshowing", updateZoomResetButton);
          let container = aDoc.defaultView.gBrowser.tabContainer;
          container.removeEventListener("TabSelect", updateZoomResetButton);
        }.bind(this),

        onCustomizeStart: function(aWindow) {
          if (aWindow.document == aDocument) {
            updateZoomResetButton();
          }
        },

        onCustomizeEnd: function(aWindow) {
          if (aWindow.document == aDocument) {
            updateZoomResetButton();
          }
        },

        onWidgetDrag: function(aWidgetId, aArea) {
          if (aWidgetId != this.id)
            return;
          aArea = aArea || this.currentArea;
          updateCombinedWidgetStyle(node, aArea, true);
        }.bind(this)
      };
      CustomizableUI.addListener(listener);

      return node;
    }
  }, {
    id: "edit-controls",
    type: "custom",
    tooltiptext: "edit-controls.tooltiptext2",
    defaultArea: CustomizableUI.AREA_PANEL,
    onBuild: function(aDocument) {
      let buttons = [{
        id: "cut-button",
        command: "cmd_cut",
        label: true,
        tooltiptext: "tooltiptext2",
        shortcutId: "key_cut",
      }, {
        id: "copy-button",
        command: "cmd_copy",
        label: true,
        tooltiptext: "tooltiptext2",
        shortcutId: "key_copy",
      }, {
        id: "paste-button",
        command: "cmd_paste",
        label: true,
        tooltiptext: "tooltiptext2",
        shortcutId: "key_paste",
      }];

      let node = aDocument.createElementNS(kNSXUL, "toolbaritem");
      node.setAttribute("id", "edit-controls");
      node.setAttribute("label", CustomizableUI.getLocalizedProperty(this, "label"));
      node.setAttribute("title", CustomizableUI.getLocalizedProperty(this, "tooltiptext"));
      // Set this as an attribute in addition to the property to make sure we can style correctly.
      node.setAttribute("removable", "true");
      node.classList.add("chromeclass-toolbar-additional");
      node.classList.add("toolbaritem-combined-buttons");
      node.classList.add(kWidePanelItemClass);

      buttons.forEach(function(aButton, aIndex) {
        if (aIndex != 0)
          node.appendChild(aDocument.createElementNS(kNSXUL, "separator"));
        let btnNode = aDocument.createElementNS(kNSXUL, "toolbarbutton");
        setAttributes(btnNode, aButton);
        node.appendChild(btnNode);
      });

      updateCombinedWidgetStyle(node, this.currentArea);

      let listener = {
        onWidgetAdded: function(aWidgetId, aArea, aPosition) {
          if (aWidgetId != this.id)
            return;
          updateCombinedWidgetStyle(node, aArea);
        }.bind(this),

        onWidgetRemoved: function(aWidgetId, aPrevArea) {
          if (aWidgetId != this.id)
            return;
          // When a widget is demoted to the palette ('removed'), it's visual
          // style should change.
          updateCombinedWidgetStyle(node);
        }.bind(this),

        onWidgetReset: function(aWidgetNode) {
          if (aWidgetNode != node)
            return;
          updateCombinedWidgetStyle(node, this.currentArea);
        }.bind(this),

        onWidgetUndoMove: function(aWidgetNode) {
          if (aWidgetNode != node)
            return;
          updateCombinedWidgetStyle(node, this.currentArea);
        }.bind(this),

        onWidgetMoved: function(aWidgetId, aArea) {
          if (aWidgetId != this.id)
            return;
          updateCombinedWidgetStyle(node, aArea);
        }.bind(this),

        onWidgetInstanceRemoved: function(aWidgetId, aDoc) {
          if (aWidgetId != this.id || aDoc != aDocument)
            return;
          CustomizableUI.removeListener(listener);
        }.bind(this),

        onWidgetDrag: function(aWidgetId, aArea) {
          if (aWidgetId != this.id)
            return;
          aArea = aArea || this.currentArea;
          updateCombinedWidgetStyle(node, aArea);
        }.bind(this)
      };
      CustomizableUI.addListener(listener);

      return node;
    }
  },
  {
    id: "feed-button",
    type: "view",
    viewId: "PanelUI-feeds",
    tooltiptext: "feed-button.tooltiptext2",
    defaultArea: CustomizableUI.AREA_PANEL,
    onClick: function(aEvent) {
      let win = aEvent.target.ownerGlobal;
      let feeds = win.gBrowser.selectedBrowser.feeds;

      // Here, we only care about the case where we have exactly 1 feed and the
      // user clicked...
      let isClick = (aEvent.button == 0 || aEvent.button == 1);
      if (feeds && feeds.length == 1 && isClick) {
        aEvent.preventDefault();
        aEvent.stopPropagation();
        win.FeedHandler.subscribeToFeed(feeds[0].href, aEvent);
        CustomizableUI.hidePanelForNode(aEvent.target);
      }
    },
    onViewShowing: function(aEvent) {
      let doc = aEvent.target.ownerDocument;
      let container = doc.getElementById("PanelUI-feeds");
      let gotView = doc.defaultView.FeedHandler.buildFeedList(container, true);

      // For no feeds or only a single one, don't show the panel.
      if (!gotView) {
        aEvent.preventDefault();
        aEvent.stopPropagation();
        return;
      }
    },
    onCreated: function(node) {
      let win = node.ownerGlobal;
      let selectedBrowser = win.gBrowser.selectedBrowser;
      let feeds = selectedBrowser && selectedBrowser.feeds;
      if (!feeds || !feeds.length) {
        node.setAttribute("disabled", "true");
      }
    }
  }, {
    id: "characterencoding-button",
    label: "characterencoding-button2.label",
    type: "view",
    viewId: "PanelUI-characterEncodingView",
    tooltiptext: "characterencoding-button2.tooltiptext",
    defaultArea: CustomizableUI.AREA_PANEL,
    maybeDisableMenu: function(aDocument) {
      let window = aDocument.defaultView;
      return !(window.gBrowser &&
               window.gBrowser.selectedBrowser.mayEnableCharacterEncodingMenu);
    },
    populateList: function(aDocument, aContainerId, aSection) {
      let containerElem = aDocument.getElementById(aContainerId);

      containerElem.addEventListener("command", this.onCommand, false);

      let list = this.charsetInfo[aSection];

      for (let item of list) {
        let elem = aDocument.createElementNS(kNSXUL, "toolbarbutton");
        elem.setAttribute("label", item.label);
        elem.setAttribute("type", "checkbox");
        elem.section = aSection;
        elem.value = item.value;
        elem.setAttribute("class", "subviewbutton");
        containerElem.appendChild(elem);
      }
    },
    updateCurrentCharset: function(aDocument) {
      let currentCharset = aDocument.defaultView.gBrowser.selectedBrowser.characterSet;
      currentCharset = CharsetMenu.foldCharset(currentCharset);

      let pinnedContainer = aDocument.getElementById("PanelUI-characterEncodingView-pinned");
      let charsetContainer = aDocument.getElementById("PanelUI-characterEncodingView-charsets");
      let elements = [...(pinnedContainer.childNodes), ...(charsetContainer.childNodes)];

      this._updateElements(elements, currentCharset);
    },
    updateCurrentDetector: function(aDocument) {
      let detectorContainer = aDocument.getElementById("PanelUI-characterEncodingView-autodetect");
      let currentDetector;
      try {
        currentDetector = Services.prefs.getComplexValue(
          "intl.charset.detector", Ci.nsIPrefLocalizedString).data;
      } catch (e) {}

      this._updateElements(detectorContainer.childNodes, currentDetector);
    },
    _updateElements: function(aElements, aCurrentItem) {
      if (!aElements.length) {
        return;
      }
      let disabled = this.maybeDisableMenu(aElements[0].ownerDocument);
      for (let elem of aElements) {
        if (disabled) {
          elem.setAttribute("disabled", "true");
        } else {
          elem.removeAttribute("disabled");
        }
        if (elem.value.toLowerCase() == aCurrentItem.toLowerCase()) {
          elem.setAttribute("checked", "true");
        } else {
          elem.removeAttribute("checked");
        }
      }
    },
    onViewShowing: function(aEvent) {
      let document = aEvent.target.ownerDocument;

      let autoDetectLabelId = "PanelUI-characterEncodingView-autodetect-label";
      let autoDetectLabel = document.getElementById(autoDetectLabelId);
      if (!autoDetectLabel.hasAttribute("value")) {
        let label = CharsetBundle.GetStringFromName("charsetMenuAutodet");
        autoDetectLabel.setAttribute("value", label);
        this.populateList(document,
                          "PanelUI-characterEncodingView-pinned",
                          "pinnedCharsets");
        this.populateList(document,
                          "PanelUI-characterEncodingView-charsets",
                          "otherCharsets");
        this.populateList(document,
                          "PanelUI-characterEncodingView-autodetect",
                          "detectors");
      }
      this.updateCurrentDetector(document);
      this.updateCurrentCharset(document);
    },
    onCommand: function(aEvent) {
      let node = aEvent.target;
      if (!node.hasAttribute || !node.section) {
        return;
      }

      let window = node.ownerGlobal;
      let section = node.section;
      let value = node.value;

      // The behavior as implemented here is directly based off of the
      // `MultiplexHandler()` method in browser.js.
      if (section != "detectors") {
        window.BrowserSetForcedCharacterSet(value);
      } else {
        // Set the detector pref.
        try {
          let str = Cc["@mozilla.org/supports-string;1"]
                      .createInstance(Ci.nsISupportsString);
          str.data = value;
          Services.prefs.setComplexValue("intl.charset.detector", Ci.nsISupportsString, str);
        } catch (e) {
          Cu.reportError("Failed to set the intl.charset.detector preference.");
        }
        // Prepare a browser page reload with a changed charset.
        window.BrowserCharsetReload();
      }
    },
    onCreated: function(aNode) {
      const kPanelId = "PanelUI-popup";
      let document = aNode.ownerDocument;

      let updateButton = () => {
        if (this.maybeDisableMenu(document))
          aNode.setAttribute("disabled", "true");
        else
          aNode.removeAttribute("disabled");
      };

      if (this.currentArea == CustomizableUI.AREA_PANEL) {
        let panel = document.getElementById(kPanelId);
        panel.addEventListener("popupshowing", updateButton);
      }

      let listener = {
        onWidgetAdded: (aWidgetId, aArea) => {
          if (aWidgetId != this.id)
            return;
          if (aArea == CustomizableUI.AREA_PANEL) {
            let panel = document.getElementById(kPanelId);
            panel.addEventListener("popupshowing", updateButton);
          }
        },
        onWidgetRemoved: (aWidgetId, aPrevArea) => {
          if (aWidgetId != this.id)
            return;
          aNode.removeAttribute("disabled");
          if (aPrevArea == CustomizableUI.AREA_PANEL) {
            let panel = document.getElementById(kPanelId);
            panel.removeEventListener("popupshowing", updateButton);
          }
        },
        onWidgetInstanceRemoved: (aWidgetId, aDoc) => {
          if (aWidgetId != this.id || aDoc != document)
            return;

          CustomizableUI.removeListener(listener);
          let panel = aDoc.getElementById(kPanelId);
          panel.removeEventListener("popupshowing", updateButton);
        }
      };
      CustomizableUI.addListener(listener);
      if (!this.charsetInfo) {
        this.charsetInfo = CharsetMenu.getData();
      }
    }
  }, {
    id: "email-link-button",
    tooltiptext: "email-link-button.tooltiptext3",
    onCommand: function(aEvent) {
      let win = aEvent.view;
      win.MailIntegration.sendLinkForBrowser(win.gBrowser.selectedBrowser)
    }
  }, {
    id: "containers-panelmenu",
    type: "view",
    viewId: "PanelUI-containers",
    hasObserver: false,
    onCreated: function(aNode) {
      let doc = aNode.ownerDocument;
      let win = doc.defaultView;
      let items = doc.getElementById("PanelUI-containersItems");

      let onItemCommand = function (aEvent) {
        let item = aEvent.target;
        if (item.hasAttribute("usercontextid")) {
          let userContextId = parseInt(item.getAttribute("usercontextid"));
          win.openUILinkIn(win.BROWSER_NEW_TAB_URL, "tab", {userContextId});
        }
      };
      items.addEventListener("command", onItemCommand);

      if (PrivateBrowsingUtils.isWindowPrivate(win)) {
        aNode.setAttribute("disabled", "true");
      }

      this.updateVisibility(aNode);

      if (!this.hasObserver) {
        Services.prefs.addObserver("privacy.userContext.enabled", this, true);
        this.hasObserver = true;
      }
    },
    onViewShowing: function(aEvent) {
      let doc = aEvent.target.ownerDocument;

      let items = doc.getElementById("PanelUI-containersItems");

      while (items.firstChild) {
        items.firstChild.remove();
      }

      let fragment = doc.createDocumentFragment();
      let bundle = doc.getElementById("bundle_browser");

      ContextualIdentityService.getIdentities().forEach(identity => {
        let label = ContextualIdentityService.getUserContextLabel(identity.userContextId);

        let item = doc.createElementNS(kNSXUL, "toolbarbutton");
        item.setAttribute("label", label);
        item.setAttribute("usercontextid", identity.userContextId);
        item.setAttribute("class", "subviewbutton");
        item.setAttribute("data-identity-color", identity.color);
        item.setAttribute("data-identity-icon", identity.icon);

        fragment.appendChild(item);
      });

      fragment.appendChild(doc.createElementNS(kNSXUL, "menuseparator"));

      let item = doc.createElementNS(kNSXUL, "toolbarbutton");
      item.setAttribute("label", bundle.getString("userContext.aboutPage.label"));
      item.setAttribute("command", "Browser:OpenAboutContainers");
      item.setAttribute("class", "subviewbutton");
      fragment.appendChild(item);

      items.appendChild(fragment);
    },

    updateVisibility(aNode) {
      aNode.hidden = !Services.prefs.getBoolPref("privacy.userContext.enabled");
    },

    observe(aSubject, aTopic, aData) {
      let {instances} = CustomizableUI.getWidget("containers-panelmenu");
      for (let {node} of instances) {
	if (node) {
	  this.updateVisibility(node);
	}
      }
    },

    QueryInterface: XPCOMUtils.generateQI([
      Ci.nsISupportsWeakReference,
      Ci.nsIObserver
    ]),
  }];

let preferencesButton = {
  id: "preferences-button",
  defaultArea: CustomizableUI.AREA_PANEL,
  onCommand: function(aEvent) {
    let win = aEvent.target.ownerGlobal;
    win.openPreferences();
  }
};
if (AppConstants.platform == "win") {
  preferencesButton.label = "preferences-button.labelWin";
  preferencesButton.tooltiptext = "preferences-button.tooltipWin2";
} else if (AppConstants.platform == "macosx") {
  preferencesButton.tooltiptext = "preferences-button.tooltiptext.withshortcut";
  preferencesButton.shortcutId = "key_preferencesCmdMac";
} else {
  preferencesButton.tooltiptext = "preferences-button.tooltiptext2";
}
CustomizableWidgets.push(preferencesButton);

if (Services.prefs.getBoolPref("privacy.panicButton.enabled")) {
  CustomizableWidgets.push({
    id: "panic-button",
    type: "view",
    viewId: "PanelUI-panicView",
    _sanitizer: null,
    _ensureSanitizer: function() {
      if (!this.sanitizer) {
        let scope = {};
        Services.scriptloader.loadSubScript("chrome://browser/content/sanitize.js",
                                            scope);
        this._Sanitizer = scope.Sanitizer;
        this._sanitizer = new scope.Sanitizer();
        this._sanitizer.ignoreTimespan = false;
      }
    },
    _getSanitizeRange: function(aDocument) {
      let group = aDocument.getElementById("PanelUI-panic-timeSpan");
      return this._Sanitizer.getClearRange(+group.value);
    },
    forgetButtonCalled: function(aEvent) {
      let doc = aEvent.target.ownerDocument;
      this._ensureSanitizer();
      this._sanitizer.range = this._getSanitizeRange(doc);
      let group = doc.getElementById("PanelUI-panic-timeSpan");
      BrowserUITelemetry.countPanicEvent(group.selectedItem.id);
      group.selectedItem = doc.getElementById("PanelUI-panic-5min");
      let itemsToClear = [
        "cookies", "history", "openWindows", "formdata", "sessions", "cache", "downloads"
      ];
      let newWindowPrivateState = PrivateBrowsingUtils.isWindowPrivate(doc.defaultView) ?
                                  "private" : "non-private";
      this._sanitizer.items.openWindows.privateStateForNewWindow = newWindowPrivateState;
      let promise = this._sanitizer.sanitize(itemsToClear);
      promise.then(function() {
        let otherWindow = Services.wm.getMostRecentWindow("navigator:browser");
        if (otherWindow.closed) {
          Cu.reportError("Got a closed window!");
        }
        if (otherWindow.PanicButtonNotifier) {
          otherWindow.PanicButtonNotifier.notify();
        } else {
          otherWindow.PanicButtonNotifierShouldNotify = true;
        }
      });
    },
    handleEvent: function(aEvent) {
      switch (aEvent.type) {
        case "command":
          this.forgetButtonCalled(aEvent);
          break;
      }
    },
    onViewShowing: function(aEvent) {
      let forgetButton = aEvent.target.querySelector("#PanelUI-panic-view-button");
      forgetButton.addEventListener("command", this);
    },
    onViewHiding: function(aEvent) {
      let forgetButton = aEvent.target.querySelector("#PanelUI-panic-view-button");
      forgetButton.removeEventListener("command", this);
    },
  });
}

if (AppConstants.E10S_TESTING_ONLY) {
  if (Services.appinfo.browserTabsRemoteAutostart) {
    CustomizableWidgets.push({
      id: "e10s-button",
      defaultArea: CustomizableUI.AREA_PANEL,
      onBuild: function(aDocument) {
        let node = aDocument.createElementNS(kNSXUL, "toolbarbutton");
        node.setAttribute("label", CustomizableUI.getLocalizedProperty(this, "label"));
        node.setAttribute("tooltiptext", CustomizableUI.getLocalizedProperty(this, "tooltiptext"));
      },
      onCommand: function(aEvent) {
        let win = aEvent.view;
        win.OpenBrowserWindow({remote: false});
      },
    });
  }
}
