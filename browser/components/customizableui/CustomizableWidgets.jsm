/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["CustomizableWidgets"];

const { CustomizableUI } = ChromeUtils.import(
  "resource:///modules/CustomizableUI.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  PanelView: "resource:///modules/PanelMultiView.jsm",
  RecentlyClosedTabsAndWindowsMenuUtils:
    "resource:///modules/sessionstore/RecentlyClosedTabsAndWindowsMenuUtils.jsm",
  ShortcutUtils: "resource://gre/modules/ShortcutUtils.jsm",
  CharsetMenu: "resource://gre/modules/CharsetMenu.jsm",
  PrivateBrowsingUtils: "resource://gre/modules/PrivateBrowsingUtils.jsm",
  Sanitizer: "resource:///modules/Sanitizer.jsm",
  SyncedTabs: "resource://services-sync/SyncedTabs.jsm",
});

XPCOMUtils.defineLazyGetter(this, "CharsetBundle", function() {
  const kCharsetBundle = "chrome://global/locale/charsetMenu.properties";
  return Services.strings.createBundle(kCharsetBundle);
});

const kPrefCustomizationDebug = "browser.uiCustomization.debug";

XPCOMUtils.defineLazyGetter(this, "log", () => {
  let scope = {};
  ChromeUtils.import("resource://gre/modules/Console.jsm", scope);
  let debug = Services.prefs.getBoolPref(kPrefCustomizationDebug, false);
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
      if (aNode.hasAttribute(name)) {
        aNode.removeAttribute(name);
      }
    } else {
      if (name == "shortcutId") {
        continue;
      }
      if (name == "label" || name == "tooltiptext") {
        let stringId = typeof value == "string" ? value : name;
        let additionalArgs = [];
        if (aAttrs.shortcutId) {
          let shortcut = doc.getElementById(aAttrs.shortcutId);
          if (shortcut) {
            additionalArgs.push(ShortcutUtils.prettifyShortcut(shortcut));
          }
        }
        value = CustomizableUI.getLocalizedProperty(
          { id: aAttrs.id },
          stringId,
          additionalArgs
        );
      }
      aNode.setAttribute(name, value);
    }
  }
}

const CustomizableWidgets = [
  {
    id: "history-panelmenu",
    type: "view",
    viewId: "PanelUI-history",
    shortcutId: "key_gotoHistory",
    tooltiptext: "history-panelmenu.tooltiptext2",
    recentlyClosedTabsPanel: "appMenu-library-recentlyClosedTabs",
    recentlyClosedWindowsPanel: "appMenu-library-recentlyClosedWindows",
    handleEvent(event) {
      switch (event.type) {
        case "PanelMultiViewHidden":
          this.onPanelMultiViewHidden(event);
          break;
        case "ViewShowing":
          this.onSubViewShowing(event);
          break;
        default:
          throw new Error(`Unsupported event for '${this.id}'`);
      }
    },
    onViewShowing(event) {
      if (this._panelMenuView) {
        return;
      }

      let panelview = event.target;
      let document = panelview.ownerDocument;
      let window = document.defaultView;

      // We restrict the amount of results to 42. Not 50, but 42. Why? Because 42.
      let query =
        "place:queryType=" +
        Ci.nsINavHistoryQueryOptions.QUERY_TYPE_HISTORY +
        "&sort=" +
        Ci.nsINavHistoryQueryOptions.SORT_BY_DATE_DESCENDING +
        "&maxResults=42&excludeQueries=1";

      this._panelMenuView = new window.PlacesPanelview(
        document.getElementById("appMenu_historyMenu"),
        panelview,
        query
      );
      // When either of these sub-subviews show, populate them with recently closed
      // objects data.
      document
        .getElementById(this.recentlyClosedTabsPanel)
        .addEventListener("ViewShowing", this);
      document
        .getElementById(this.recentlyClosedWindowsPanel)
        .addEventListener("ViewShowing", this);
      // When the popup is hidden (thus the panelmultiview node as well), make
      // sure to stop listening to PlacesDatabase updates.
      panelview.panelMultiView.addEventListener("PanelMultiViewHidden", this);
    },
    onViewHiding(event) {
      log.debug("History view is being hidden!");
    },
    onPanelMultiViewHidden(event) {
      let panelMultiView = event.target;
      let document = panelMultiView.ownerDocument;
      if (this._panelMenuView) {
        this._panelMenuView.uninit();
        delete this._panelMenuView;
        document
          .getElementById(this.recentlyClosedTabsPanel)
          .removeEventListener("ViewShowing", this);
        document
          .getElementById(this.recentlyClosedWindowsPanel)
          .removeEventListener("ViewShowing", this);
      }
      panelMultiView.removeEventListener("PanelMultiViewHidden", this);
    },
    onSubViewShowing(event) {
      let panelview = event.target;
      let document = event.target.ownerDocument;
      let window = document.defaultView;
      let viewType =
        panelview.id == this.recentlyClosedTabsPanel ? "Tabs" : "Windows";

      this._panelMenuView.clearAllContents(panelview);

      let utils = RecentlyClosedTabsAndWindowsMenuUtils;
      let method = `get${viewType}Fragment`;
      let fragment = utils[method](window, "toolbarbutton", true);
      let elementCount = fragment.childElementCount;
      this._panelMenuView._setEmptyPopupStatus(panelview, !elementCount);
      if (!elementCount) {
        return;
      }

      let body = document.createXULElement("vbox");
      body.className = "panel-subview-body";
      body.appendChild(fragment);
      let footer;
      while (--elementCount >= 0) {
        let element = body.children[elementCount];
        CustomizableUI.addShortcut(element);
        element.classList.add("subviewbutton");
        if (element.classList.contains("restoreallitem")) {
          footer = element;
          element.classList.add("panel-subview-footer");
        } else {
          element.classList.add("subviewbutton-iconic", "bookmark-item");
        }
      }
      panelview.appendChild(body);
      panelview.appendChild(footer);
    },
  },
  {
    id: "save-page-button",
    shortcutId: "key_savePage",
    tooltiptext: "save-page-button.tooltiptext3",
    onCommand(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.saveBrowser(win.gBrowser.selectedBrowser);
    },
  },
  {
    id: "find-button",
    shortcutId: "key_find",
    tooltiptext: "find-button.tooltiptext3",
    onCommand(aEvent) {
      let win = aEvent.target.ownerGlobal;
      if (win.gLazyFindCommand) {
        win.gLazyFindCommand("onFindCommand");
      }
    },
  },
  {
    id: "open-file-button",
    shortcutId: "openFileKb",
    tooltiptext: "open-file-button.tooltiptext3",
    onCommand(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.BrowserOpenFileWindow();
    },
  },
  {
    id: "sidebar-button",
    tooltiptext: "sidebar-button.tooltiptext2",
    onCommand(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.SidebarUI.toggle();
    },
    onCreated(aNode) {
      // Add an observer so the button is checked while the sidebar is open
      let doc = aNode.ownerDocument;
      let obChecked = doc.createXULElement("observes");
      obChecked.setAttribute("element", "sidebar-box");
      obChecked.setAttribute("attribute", "checked");
      let obPosition = doc.createXULElement("observes");
      obPosition.setAttribute("element", "sidebar-box");
      obPosition.setAttribute("attribute", "positionend");

      aNode.appendChild(obChecked);
      aNode.appendChild(obPosition);
    },
  },
  {
    id: "add-ons-button",
    shortcutId: "key_openAddons",
    tooltiptext: "add-ons-button.tooltiptext3",
    onCommand(aEvent) {
      let win = aEvent.target.ownerGlobal;
      win.BrowserOpenAddonsMgr();
    },
  },
  {
    id: "zoom-controls",
    type: "custom",
    tooltiptext: "zoom-controls.tooltiptext2",
    onBuild(aDocument) {
      let buttons = [
        {
          id: "zoom-out-button",
          command: "cmd_fullZoomReduce",
          label: true,
          closemenu: "none",
          tooltiptext: "tooltiptext2",
          shortcutId: "key_fullZoomReduce",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
        {
          id: "zoom-reset-button",
          command: "cmd_fullZoomReset",
          closemenu: "none",
          tooltiptext: "tooltiptext2",
          shortcutId: "key_fullZoomReset",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
        {
          id: "zoom-in-button",
          command: "cmd_fullZoomEnlarge",
          closemenu: "none",
          label: true,
          tooltiptext: "tooltiptext2",
          shortcutId: "key_fullZoomEnlarge",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
      ];

      let node = aDocument.createXULElement("toolbaritem");
      node.setAttribute("id", "zoom-controls");
      node.setAttribute(
        "label",
        CustomizableUI.getLocalizedProperty(this, "label")
      );
      node.setAttribute(
        "title",
        CustomizableUI.getLocalizedProperty(this, "tooltiptext")
      );
      // Set this as an attribute in addition to the property to make sure we can style correctly.
      node.setAttribute("removable", "true");
      node.classList.add("chromeclass-toolbar-additional");
      node.classList.add("toolbaritem-combined-buttons");

      buttons.forEach(function(aButton, aIndex) {
        if (aIndex != 0) {
          node.appendChild(aDocument.createXULElement("separator"));
        }
        let btnNode = aDocument.createXULElement("toolbarbutton");
        setAttributes(btnNode, aButton);
        node.appendChild(btnNode);
      });
      return node;
    },
  },
  {
    id: "edit-controls",
    type: "custom",
    tooltiptext: "edit-controls.tooltiptext2",
    onBuild(aDocument) {
      let buttons = [
        {
          id: "cut-button",
          command: "cmd_cut",
          label: true,
          tooltiptext: "tooltiptext2",
          shortcutId: "key_cut",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
        {
          id: "copy-button",
          command: "cmd_copy",
          label: true,
          tooltiptext: "tooltiptext2",
          shortcutId: "key_copy",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
        {
          id: "paste-button",
          command: "cmd_paste",
          label: true,
          tooltiptext: "tooltiptext2",
          shortcutId: "key_paste",
          class: "toolbarbutton-1 toolbarbutton-combined",
        },
      ];

      let node = aDocument.createXULElement("toolbaritem");
      node.setAttribute("id", "edit-controls");
      node.setAttribute(
        "label",
        CustomizableUI.getLocalizedProperty(this, "label")
      );
      node.setAttribute(
        "title",
        CustomizableUI.getLocalizedProperty(this, "tooltiptext")
      );
      // Set this as an attribute in addition to the property to make sure we can style correctly.
      node.setAttribute("removable", "true");
      node.classList.add("chromeclass-toolbar-additional");
      node.classList.add("toolbaritem-combined-buttons");

      buttons.forEach(function(aButton, aIndex) {
        if (aIndex != 0) {
          node.appendChild(aDocument.createXULElement("separator"));
        }
        let btnNode = aDocument.createXULElement("toolbarbutton");
        setAttributes(btnNode, aButton);
        node.appendChild(btnNode);
      });

      let listener = {
        onWidgetInstanceRemoved: (aWidgetId, aDoc) => {
          if (aWidgetId != this.id || aDoc != aDocument) {
            return;
          }
          CustomizableUI.removeListener(listener);
        },
        onWidgetOverflow(aWidgetNode) {
          if (aWidgetNode == node) {
            node.ownerGlobal.updateEditUIVisibility();
          }
        },
        onWidgetUnderflow(aWidgetNode) {
          if (aWidgetNode == node) {
            node.ownerGlobal.updateEditUIVisibility();
          }
        },
      };
      CustomizableUI.addListener(listener);

      return node;
    },
  },
  {
    id: "characterencoding-button",
    label: "characterencoding-button2.label",
    type: "view",
    viewId: "PanelUI-characterEncodingView",
    tooltiptext: "characterencoding-button2.tooltiptext",
    maybeDisableMenu(aDocument) {
      let window = aDocument.defaultView;
      return !(
        window.gBrowser &&
        window.gBrowser.selectedBrowser.mayEnableCharacterEncodingMenu
      );
    },
    populateList(aDocument, aContainerId, aSection) {
      let containerElem = aDocument.getElementById(aContainerId);

      containerElem.addEventListener("command", this.onCommand);

      let list = this.charsetInfo[aSection];

      for (let item of list) {
        let elem = aDocument.createXULElement("toolbarbutton");
        elem.setAttribute("label", item.label);
        elem.setAttribute("type", "checkbox");
        elem.section = aSection;
        elem.value = item.value;
        elem.setAttribute("class", "subviewbutton");
        containerElem.appendChild(elem);
      }
    },
    updateCurrentCharset(aDocument) {
      let currentCharset =
        aDocument.defaultView.gBrowser.selectedBrowser.characterSet;
      let {
        charsetAutodetected,
      } = aDocument.defaultView.gBrowser.selectedBrowser;
      currentCharset = CharsetMenu.foldCharset(
        currentCharset,
        charsetAutodetected
      );

      let pinnedContainer = aDocument.getElementById(
        "PanelUI-characterEncodingView-pinned"
      );
      let charsetContainer = aDocument.getElementById(
        "PanelUI-characterEncodingView-charsets"
      );
      let elements = [
        ...pinnedContainer.children,
        ...charsetContainer.children,
      ];

      this._updateElements(elements, currentCharset);
    },
    updateCurrentDetector(aDocument) {
      let detectorContainer = aDocument.getElementById(
        "PanelUI-characterEncodingView-autodetect"
      );
      let currentDetector;
      try {
        currentDetector = Services.prefs.getComplexValue(
          "intl.charset.detector",
          Ci.nsIPrefLocalizedString
        ).data;
      } catch (e) {}

      this._updateElements(detectorContainer.children, currentDetector);
      let hideDetector = Services.prefs.getBoolPref(
        "intl.charset.detector.ng.enabled"
      );
      aDocument.getElementById(
        "PanelUI-characterEncodingView-autodetect-container"
      ).hidden = hideDetector;
      aDocument.getElementById(
        "PanelUI-characterEncodingView-autodetect-separator"
      ).hidden = hideDetector;
    },
    _updateElements(aElements, aCurrentItem) {
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
    onViewShowing(aEvent) {
      if (!this._inited) {
        this.onInit();
      }
      let document = aEvent.target.ownerDocument;

      let autoDetectLabelId = "PanelUI-characterEncodingView-autodetect-label";
      let autoDetectLabel = document.getElementById(autoDetectLabelId);
      if (!autoDetectLabel.hasAttribute("value")) {
        let label = CharsetBundle.GetStringFromName("charsetMenuAutodet");
        autoDetectLabel.setAttribute("value", label);
        this.populateList(
          document,
          "PanelUI-characterEncodingView-pinned",
          "pinnedCharsets"
        );
        this.populateList(
          document,
          "PanelUI-characterEncodingView-charsets",
          "otherCharsets"
        );
        this.populateList(
          document,
          "PanelUI-characterEncodingView-autodetect",
          "detectors"
        );
      }
      this.updateCurrentDetector(document);
      this.updateCurrentCharset(document);
    },
    onCommand(aEvent) {
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
          Services.prefs.setStringPref("intl.charset.detector", value);
        } catch (e) {
          Cu.reportError("Failed to set the intl.charset.detector preference.");
        }
        // Prepare a browser page reload with a changed charset.
        window.BrowserCharsetReload();
      }
    },
    onCreated(aNode) {
      let document = aNode.ownerDocument;

      let updateButton = () => {
        if (this.maybeDisableMenu(document)) {
          aNode.setAttribute("disabled", "true");
        } else {
          aNode.removeAttribute("disabled");
        }
      };

      let getPanel = () => {
        let { PanelUI } = document.ownerGlobal;
        return PanelUI.overflowPanel;
      };

      if (
        CustomizableUI.getAreaType(this.currentArea) ==
        CustomizableUI.TYPE_MENU_PANEL
      ) {
        getPanel().addEventListener("popupshowing", updateButton);
      }

      let listener = {
        onWidgetAdded: (aWidgetId, aArea) => {
          if (aWidgetId != this.id) {
            return;
          }
          if (
            CustomizableUI.getAreaType(aArea) == CustomizableUI.TYPE_MENU_PANEL
          ) {
            getPanel().addEventListener("popupshowing", updateButton);
          }
        },
        onWidgetRemoved: (aWidgetId, aPrevArea) => {
          if (aWidgetId != this.id) {
            return;
          }
          aNode.removeAttribute("disabled");
          if (
            CustomizableUI.getAreaType(aPrevArea) ==
            CustomizableUI.TYPE_MENU_PANEL
          ) {
            getPanel().removeEventListener("popupshowing", updateButton);
          }
        },
        onWidgetInstanceRemoved: (aWidgetId, aDoc) => {
          if (aWidgetId != this.id || aDoc != document) {
            return;
          }

          CustomizableUI.removeListener(listener);
          getPanel().removeEventListener("popupshowing", updateButton);
        },
      };
      CustomizableUI.addListener(listener);
      this.onInit();
    },
    onInit() {
      this._inited = true;
      if (!this.charsetInfo) {
        this.charsetInfo = CharsetMenu.getData();
      }
    },
  },
  {
    id: "email-link-button",
    tooltiptext: "email-link-button.tooltiptext3",
    onCommand(aEvent) {
      let win = aEvent.view;
      win.MailIntegration.sendLinkForBrowser(win.gBrowser.selectedBrowser);
    },
  },
];

if (Services.prefs.getBoolPref("identity.fxaccounts.enabled")) {
  CustomizableWidgets.push({
    id: "sync-button",
    label: "remotetabs-panelmenu.label",
    tooltiptext: "remotetabs-panelmenu.tooltiptext2",
    type: "view",
    viewId: "PanelUI-remotetabs",
    deckIndices: {
      DECKINDEX_TABS: 0,
      DECKINDEX_TABSDISABLED: 1,
      DECKINDEX_FETCHING: 2,
      DECKINDEX_NOCLIENTS: 3,
    },
    TABS_PER_PAGE: 25,
    NEXT_PAGE_MIN_TABS: 5, // Minimum number of tabs displayed when we click "Show All"
    onViewShowing(aEvent) {
      let doc = aEvent.target.ownerDocument;
      this._tabsList = doc.getElementById("PanelUI-remotetabs-tabslist");
      Services.obs.addObserver(this, SyncedTabs.TOPIC_TABS_CHANGED);

      let deck = doc.getElementById("PanelUI-remotetabs-deck");
      if (SyncedTabs.isConfiguredToSyncTabs) {
        if (SyncedTabs.hasSyncedThisSession) {
          deck.selectedIndex = this.deckIndices.DECKINDEX_TABS;
        } else {
          // Sync hasn't synced tabs yet, so show the "fetching" panel.
          deck.selectedIndex = this.deckIndices.DECKINDEX_FETCHING;
        }
        // force a background sync.
        SyncedTabs.syncTabs().catch(ex => {
          Cu.reportError(ex);
        });
        // show the current list - it will be updated by our observer.
        this._showTabs();
      } else {
        // not configured to sync tabs, so no point updating the list.
        deck.selectedIndex = this.deckIndices.DECKINDEX_TABSDISABLED;
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

    _showTabsPromise: Promise.resolve(),
    // Update the tab list after any existing in-flight updates are complete.
    _showTabs(paginationInfo) {
      this._showTabsPromise = this._showTabsPromise.then(
        () => {
          return this.__showTabs(paginationInfo);
        },
        e => {
          Cu.reportError(e);
        }
      );
    },
    // Return a new promise to update the tab list.
    __showTabs(paginationInfo) {
      if (!this._tabsList) {
        // Closed between the previous `this._showTabsPromise`
        // resolving and now.
        return undefined;
      }
      let doc = this._tabsList.ownerDocument;
      let deck = doc.getElementById("PanelUI-remotetabs-deck");
      return SyncedTabs.getTabClients()
        .then(clients => {
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
            deck.selectedIndex = this.deckIndices.DECKINDEX_NOCLIENTS;
            return;
          }

          deck.selectedIndex = this.deckIndices.DECKINDEX_TABS;
          this._clearTabList();
          SyncedTabs.sortTabClientsByLastUsed(clients);
          let fragment = doc.createDocumentFragment();

          let clientNumber = 0;
          for (let client of clients) {
            // add a menu separator for all clients other than the first.
            if (fragment.lastElementChild) {
              let separator = doc.createXULElement("menuseparator");
              fragment.appendChild(separator);
            }
            // We add the client's elements to a container, and indicate which
            // element labels it.
            let labelId = `synced-tabs-client-${clientNumber++}`;
            let container = doc.createXULElement("vbox");
            container.classList.add("PanelUI-remotetabs-clientcontainer");
            container.setAttribute("role", "group");
            container.setAttribute("aria-labelledby", labelId);
            if (paginationInfo && paginationInfo.clientId == client.id) {
              this._appendClient(
                client,
                container,
                labelId,
                paginationInfo.maxTabs
              );
            } else {
              this._appendClient(client, container, labelId);
            }
            fragment.appendChild(container);
          }
          this._tabsList.appendChild(fragment);
          PanelView.forNode(
            this._tabsList.closest("panelview")
          ).descriptionHeightWorkaround();
        })
        .catch(err => {
          Cu.reportError(err);
        })
        .then(() => {
          // an observer for tests.
          Services.obs.notifyObservers(
            null,
            "synced-tabs-menu:test:tabs-updated"
          );
        });
    },
    _clearTabList() {
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
      let messageLabel = doc.createXULElement("label");
      messageLabel.textContent = message;
      appendTo.appendChild(messageLabel);
      return messageLabel;
    },
    _appendClient(client, container, labelId, maxTabs = this.TABS_PER_PAGE) {
      let doc = container.ownerDocument;
      // Create the element for the remote client.
      let clientItem = doc.createXULElement("label");
      clientItem.setAttribute("id", labelId);
      clientItem.setAttribute("itemtype", "client");
      let window = doc.defaultView;
      clientItem.setAttribute(
        "tooltiptext",
        window.gSync.formatLastSyncDate(new Date(client.lastModified))
      );
      clientItem.textContent = client.name;

      container.appendChild(clientItem);

      if (!client.tabs.length) {
        let label = this._appendMessageLabel("notabsforclientlabel", container);
        label.setAttribute("class", "PanelUI-remotetabs-notabsforclient-label");
      } else {
        // If this page will display all tabs, show no additional buttons.
        // If the next page will display all the remaining tabs, show a "Show All" button
        // Otherwise, show a "Shore More" button
        let hasNextPage = client.tabs.length > maxTabs;
        let nextPageIsLastPage =
          hasNextPage && maxTabs + this.TABS_PER_PAGE >= client.tabs.length;
        if (nextPageIsLastPage) {
          // When the user clicks "Show All", try to have at least NEXT_PAGE_MIN_TABS more tabs
          // to display in order to avoid user frustration
          maxTabs = Math.min(
            client.tabs.length - this.NEXT_PAGE_MIN_TABS,
            maxTabs
          );
        }
        if (hasNextPage) {
          client.tabs = client.tabs.slice(0, maxTabs);
        }
        for (let tab of client.tabs) {
          let tabEnt = this._createTabElement(doc, tab);
          container.appendChild(tabEnt);
        }
        if (hasNextPage) {
          let showAllEnt = this._createShowMoreElement(
            doc,
            client.id,
            nextPageIsLastPage ? Infinity : maxTabs + this.TABS_PER_PAGE
          );
          container.appendChild(showAllEnt);
        }
      }
    },
    _createTabElement(doc, tabInfo) {
      let item = doc.createXULElement("toolbarbutton");
      let tooltipText =
        (tabInfo.title ? tabInfo.title + "\n" : "") + tabInfo.url;
      item.setAttribute("itemtype", "tab");
      item.setAttribute("class", "subviewbutton");
      item.setAttribute("targetURI", tabInfo.url);
      item.setAttribute(
        "label",
        tabInfo.title != "" ? tabInfo.title : tabInfo.url
      );
      item.setAttribute("image", tabInfo.icon);
      item.setAttribute("tooltiptext", tooltipText);
      // We need to use "click" instead of "command" here so openUILink
      // respects different buttons (eg, to open in a new tab).
      item.addEventListener("click", e => {
        doc.defaultView.openUILink(tabInfo.url, e, {
          triggeringPrincipal: Services.scriptSecurityManager.createNullPrincipal(
            {}
          ),
        });
        if (doc.defaultView.whereToOpenLink(e) != "current") {
          e.preventDefault();
          e.stopPropagation();
        } else {
          CustomizableUI.hidePanelForNode(item);
        }
      });
      return item;
    },
    _createShowMoreElement(doc, clientId, showCount) {
      let labelAttr, tooltipAttr;
      if (showCount === Infinity) {
        labelAttr = "showAllLabel";
        tooltipAttr = "showAllTooltipText";
      } else {
        labelAttr = "showMoreLabel";
        tooltipAttr = "showMoreTooltipText";
      }
      let showAllItem = doc.createXULElement("toolbarbutton");
      showAllItem.setAttribute("itemtype", "showmorebutton");
      showAllItem.setAttribute("class", "subviewbutton");
      let label = this._tabsList.getAttribute(labelAttr);
      showAllItem.setAttribute("label", label);
      let tooltipText = this._tabsList.getAttribute(tooltipAttr);
      showAllItem.setAttribute("tooltiptext", tooltipText);
      showAllItem.addEventListener("click", e => {
        e.preventDefault();
        e.stopPropagation();
        this._showTabs({ clientId, maxTabs: showCount });
      });
      return showAllItem;
    },
  });
}

let preferencesButton = {
  id: "preferences-button",
  onCommand(aEvent) {
    let win = aEvent.target.ownerGlobal;
    win.openPreferences(undefined);
  },
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

    forgetButtonCalled(aEvent) {
      let doc = aEvent.target.ownerDocument;
      let group = doc.getElementById("PanelUI-panic-timeSpan");
      let itemsToClear = [
        "cookies",
        "history",
        "openWindows",
        "formdata",
        "sessions",
        "cache",
        "downloads",
        "offlineApps",
      ];
      let newWindowPrivateState = PrivateBrowsingUtils.isWindowPrivate(
        doc.defaultView
      )
        ? "private"
        : "non-private";
      let promise = Sanitizer.sanitize(itemsToClear, {
        ignoreTimespan: false,
        range: Sanitizer.getClearRange(+group.value),
        privateStateForNewWindow: newWindowPrivateState,
      });
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
    handleEvent(aEvent) {
      switch (aEvent.type) {
        case "command":
          this.forgetButtonCalled(aEvent);
          break;
      }
    },
    onViewShowing(aEvent) {
      let win = aEvent.target.ownerGlobal;
      let doc = win.document;
      let eventBlocker = null;
      if (!doc.querySelector("#PanelUI-panic-timeframe")) {
        win.MozXULElement.insertFTLIfNeeded("browser/panicButton.ftl");
        let frag = win.MozXULElement.parseXULToFragment(`
          <vbox class="panel-subview-body">
            <hbox id="PanelUI-panic-timeframe">
              <image id="PanelUI-panic-timeframe-icon" alt=""/>
              <vbox flex="1">
                <description data-l10n-id="panic-main-timeframe-desc" id="PanelUI-panic-mainDesc"></description>
                <radiogroup id="PanelUI-panic-timeSpan" aria-labelledby="PanelUI-panic-mainDesc" closemenu="none">
                  <radio id="PanelUI-panic-5min" data-l10n-id="panic-button-5min" selected="true"
                        value="5" class="subviewradio"/>
                  <radio id="PanelUI-panic-2hr" data-l10n-id="panic-button-2hr"
                        value="2" class="subviewradio"/>
                  <radio id="PanelUI-panic-day" data-l10n-id="panic-button-day"
                        value="6" class="subviewradio"/>
                </radiogroup>
              </vbox>
            </hbox>
            <vbox id="PanelUI-panic-explanations">
              <label id="PanelUI-panic-actionlist-main-label" data-l10n-id="panic-button-action-desc"></label>

              <label id="PanelUI-panic-actionlist-windows" class="PanelUI-panic-actionlist" data-l10n-id="panic-button-delete-tabs-and-windows"></label>
              <label id="PanelUI-panic-actionlist-cookies" class="PanelUI-panic-actionlist" data-l10n-id="panic-button-delete-cookies"></label>
              <label id="PanelUI-panic-actionlist-history" class="PanelUI-panic-actionlist" data-l10n-id="panic-button-delete-history"></label>
              <label id="PanelUI-panic-actionlist-newwindow" class="PanelUI-panic-actionlist" data-l10n-id="panic-button-open-new-window"></label>

              <label id="PanelUI-panic-warning" data-l10n-id="panic-button-undo-warning"></label>
            </vbox>
            <button id="PanelUI-panic-view-button"
                    data-l10n-id="panic-button-forget-button"/>
          </vbox>
        `);

        aEvent.target.appendChild(frag);
        eventBlocker = doc.l10n.translateElements([aEvent.target]);
      }

      let forgetButton = aEvent.target.querySelector(
        "#PanelUI-panic-view-button"
      );
      let group = doc.getElementById("PanelUI-panic-timeSpan");
      group.selectedItem = doc.getElementById("PanelUI-panic-5min");
      forgetButton.addEventListener("command", this);

      if (eventBlocker) {
        aEvent.detail.addBlocker(eventBlocker);
      }
    },
    onViewHiding(aEvent) {
      let forgetButton = aEvent.target.querySelector(
        "#PanelUI-panic-view-button"
      );
      forgetButton.removeEventListener("command", this);
    },
  });
}

if (PrivateBrowsingUtils.enabled) {
  CustomizableWidgets.push({
    id: "privatebrowsing-button",
    shortcutId: "key_privatebrowsing",
    onCommand(e) {
      let win = e.target.ownerGlobal;
      win.OpenBrowserWindow({ private: true });
    },
  });
}
