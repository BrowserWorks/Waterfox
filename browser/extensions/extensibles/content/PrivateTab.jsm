/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const EXPORTED_SYMBOLS = ["PrivateTab"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { ContextualIdentityService } = ChromeUtils.import(
  "resource://gre/modules/ContextualIdentityService.jsm"
);

const { PlacesUIUtils } = ChromeUtils.import(
  "resource:///modules/PlacesUIUtils.jsm"
);

const { TabStateCache } = ChromeUtils.import(
  "resource:///modules/sessionstore/TabStateCache.jsm"
);

const { TabStateFlusher } = ChromeUtils.import(
  "resource:///modules/sessionstore/TabStateFlusher.jsm"
);

const { ExtensiblesElements } = ChromeUtils.import(
  "resource:///modules/ExtensiblesElements.jsm"
);

const { BrowserUtils } = ChromeUtils.import(
  "resource:///modules/BrowserUtils.jsm"
);

const { PrefUtils } = ChromeUtils.import("resource:///modules/PrefUtils.jsm");

const PrivateTab = {
  config: {
    neverClearData: false, // TODO: change to pref controlled value; if you want to not record history but don"t care about other data, maybe even want to keep private logins
    restoreTabsOnRestart: true,
    doNotClearDataUntilFxIsClosed: false,
  },

  openTabs: new Set(),

  BTN_ID: "privateTab-button",
  BTN2_ID: "newPrivateTab-button",

  get style() {
    return `
    @-moz-document url('chrome://browser/content/browser.xhtml') {
      #private-mask[enabled="true"] {
        display: block !important;
      }

      @media (-wfx-default-theme) {
        .privatetab-icon {
          list-style-image: url(chrome://browser/skin/privatebrowsing/favicon.svg) !important;
        }
      }

      #${this.BTN_ID}, #${this.BTN2_ID} {
        list-style-image: url(chrome://browser/skin/privateBrowsing.svg);
      }
      #tabbrowser-tabs[hasadjacentnewprivatetabbutton]:not([overflow="true"]) ~ #${this.BTN_ID},
      #tabbrowser-tabs[overflow="true"] > #tabbrowser-arrowscrollbox > #${this.BTN2_ID},
      #tabbrowser-tabs:not([hasadjacentnewprivatetabbutton]) > #tabbrowser-arrowscrollbox > #${this.BTN2_ID},
      #TabsToolbar[customizing="true"] #${this.BTN2_ID} {
        display: none;
      }
      .tabbrowser-tab[usercontextid="${this.container.userContextId}"] .tab-label {
        text-decoration: underline !important;
        text-decoration-color: -moz-nativehyperlinktext !important;
        text-decoration-style: dashed !important;
      }
      .tabbrowser-tab[usercontextid="${this.container.userContextId}"][pinned] .tab-icon-image,
      .tabbrowser-tab[usercontextid="${this.container.userContextId}"][pinned] .tab-throbber {
        border-bottom: 1px dashed -moz-nativehyperlinktext !important;
      }
    }
  `;
  },

  init(window) {
    // Only init in a non-private window
    if (!window.PrivateBrowsingUtils.isWindowPrivate(window)) {
      this.initContainer("Private");
      this.initElements(window);
      this.initObservers(window);
      this.initListeners(window);
      this.initCustomFunctions(window);
      this.overridePlacesUIUtils();
      this.createPrivateWidget();
      this.updatePrivateMaskId(window);
      BrowserUtils.setStyle(this.style);
    }
  },

  initContainer(aName) {
    ContextualIdentityService.ensureDataReady();
    this.container = ContextualIdentityService._identities.find(
      container => container.name == aName
    );
    if (this.container && this.container.icon == "private") {
      ContextualIdentityService.remove(this.container.userContextId);
      this.container = undefined;
    }
    if (!this.container) {
      ContextualIdentityService.create(aName, "fingerprint", "purple");
      this.container = ContextualIdentityService._identities.find(
        container => container.name == aName
      );
    } else if (!this.config.neverClearData) {
      this.clearData();
    }
    return this.container;
  },

  clearData() {
    Services.clearData.deleteDataFromOriginAttributesPattern({
      userContextId: this.container.userContextId,
    });
  },

  initElements(window) {
    ExtensiblesElements.elements.forEach(item => {
      const { tag, attrs, adjacentTo, position } = item;
      BrowserUtils.createAndPositionElement(
        window,
        tag,
        attrs,
        adjacentTo,
        position
      );
    });
    ExtensiblesElements.appendElements.forEach(item => {
      const { tag, attrs, appendTo } = item;
      BrowserUtils.createAndPositionElement(window, tag, attrs, appendTo);
    });
  },

  initObservers(aWindow) {
    this.setPrivateObserver();
  },

  initListeners(aWindow) {
    this.initPrivateTabListeners(aWindow);
    aWindow.document
      .getElementById("placesContext")
      ?.addEventListener("popupshowing", this.placesContext);
    aWindow.document
      .getElementById("contentAreaContextMenu")
      ?.addEventListener("popupshowing", this.contentContext);
    aWindow.document
      .getElementById("contentAreaContextMenu")
      ?.addEventListener("popuphidden", this.hideContext);
    aWindow.document
      .getElementById("openLinkInPrivateTab")
      ?.addEventListener("command", this.openLink);
    aWindow.document
      .getElementById("tabContextMenu")
      ?.addEventListener("popupshowing", this.tabContext);
    aWindow.document
      .getElementById("newPrivateTab-button")
      ?.addEventListener("click", this.toolbarClick);
  },

  createPrivateWidget() {
    let { CustomizableUI } = ChromeUtils.import(
      "resource:///modules/CustomizableUI.jsm"
    );
    let attrs = ExtensiblesElements.widgetAttrs;
    // if widget exists, don't attempt to create it again
    if (!CustomizableUI.getWidget(PrivateTab.BTN_ID)) {
      CustomizableUI.createWidget({
        id: PrivateTab.BTN_ID,
        type: "custom",
        defaultArea: null,
        showInPrivateBrowsing: false,
        onBuild: doc => {
          let el = doc.createXULElement("toolbarbutton");
          for (let att in attrs) {
            // don't set null attrs
            if (attrs[att]) {
              el.setAttribute(att, attrs[att]);
            }
          }
          return el;
        },
      });
    }
  },

  async updatePrivateMaskId(aWindow) {
    let privateMask = aWindow.document.getElementsByClassName(
      "private-browsing-indicator"
    )[0];
    privateMask.id = "private-mask";
  },

  setPrivateObserver() {
    if (!this.config.neverClearData) {
      let observe = () => {
        this.clearData();
        if (!this.config.restoreTabsOnRestart) {
          this.closeTabs();
        }
      };
      Services.obs.addObserver(observe, "quit-application-granted");
    }
  },

  closeTabs() {
    ContextualIdentityService._forEachContainerTab((tab, tabbrowser) => {
      if (tab.userContextId == this.container.userContextId) {
        tabbrowser.removeTab(tab);
      }
    });
  },

  placesContext(aEvent) {
    let win = aEvent.view;
    if (!win) {
      return;
    }
    let { document } = win;
    let openAll = "placesContext_openBookmarkContainer:tabs";
    let openAllLinks = "placesContext_openLinks:tabs";
    let openTab = "placesContext_open:newtab";
    // let document = event.target.ownerDocument;
    document.getElementById("openPrivate").disabled = document.getElementById(
      openTab
    ).disabled;
    document.getElementById("openPrivate").hidden = document.getElementById(
      openTab
    ).hidden;
    document.getElementById(
      "openAllPrivate"
    ).disabled = document.getElementById(openAll).disabled;
    document.getElementById("openAllPrivate").hidden = document.getElementById(
      openAll
    ).hidden;
    document.getElementById(
      "openAllLinksPrivate"
    ).disabled = document.getElementById(openAllLinks).disabled;
    document.getElementById(
      "openAllLinksPrivate"
    ).hidden = document.getElementById(openAllLinks).hidden;
  },

  isPrivate(aTab) {
    return aTab.getAttribute("usercontextid") == this.container.userContextId;
  },

  contentContext(aEvent) {
    let win = aEvent.view;
    if (!win) {
      return;
    }
    let { gContextMenu, gBrowser, PrivateTab } = win;
    let tab = gBrowser.getTabForBrowser(gContextMenu.browser);
    gContextMenu.showItem(
      "openLinkInPrivateTab",
      gContextMenu.onSaveableLink || gContextMenu.onPlainTextLink
    );
    let isPrivate = PrivateTab.isPrivate(tab);
    if (isPrivate) {
      gContextMenu.showItem("context-openlinkincontainertab", false);
    }
  },

  hideContext(aEvent) {
    if (!aEvent.view) {
      return;
    }
    if (aEvent.target == this) {
      aEvent.view.document.getElementById("openLinkInPrivateTab").hidden = true;
    }
  },

  tabContext(aEvent) {
    let win = aEvent.view;
    if (!win) {
      return;
    }
    let { document, PrivateTab } = win;
    document
      .getElementById("toggleTabPrivateState")
      .setAttribute(
        "checked",
        win.TabContextMenu.contextTab.userContextId ==
          PrivateTab.container.userContextId
      );
  },

  openLink(aEvent) {
    let win = aEvent.view;
    if (!win) {
      return;
    }
    let { gContextMenu, PrivateTab, document } = win;
    win.openLinkIn(
      gContextMenu.linkURL,
      "tab",
      gContextMenu._openLinkInParameters({
        userContextId: PrivateTab.container.userContextId,
        triggeringPrincipal: document.nodePrincipal,
      })
    );
  },

  toolbarClick(aEvent) {
    let win = aEvent.view;
    if (!win) {
      return;
    }
    let { PrivateTab, document } = win;
    if (aEvent.button == 0) {
      PrivateTab.browserOpenTabPrivate(win);
    } else if (aEvent.button == 2) {
      document.popupNode = document.getElementById(PrivateTab.BTN_ID);
      document
        .getElementById("toolbar-context-menu")
        .openPopup(this, "after_start", 14, -10, false, false);
      document.getElementsByClassName(
        "customize-context-removeFromToolbar"
      )[0].disabled = false;
      document.getElementsByClassName(
        "customize-context-moveToPanel"
      )[0].disabled = false;
      aEvent.preventDefault();
    }
  },

  overridePlacesUIUtils() {
    // required for eval to execute
    const { PlacesUtils } = ChromeUtils.import(
      "resource://gre/modules/PlacesUtils.jsm"
    );
    const { PrivateBrowsingUtils } = ChromeUtils.import(
      "resource://gre/modules/PrivateBrowsingUtils.jsm"
    );
    const { getBrowserWindow } = ChromeUtils.import(
      "resource:///modules/PlacesUIUtils.jsm",
      null
    );

    // TODO: replace eval with new Function()();
    try {
      eval(
        "PlacesUIUtils.openTabset = function " +
          PlacesUIUtils.openTabset
            .toString()
            .replace(
              /(\s+)(inBackground: loadInBackground,)/,
              "$1$2$1userContextId: aEvent.userContextId || 0,"
            )
      );

      eval(
        "PlacesUIUtils._openNodeIn = " +
          PlacesUIUtils._openNodeIn
            .toString()
            .replace(/(\s+)(aPrivate = false)\n/, "$1$2,$1userContextId = 0\n")
            .replace(/(\s+)(private: aPrivate,)\n/, "$1$2$1userContextId,\n")
      );
    } catch (ex) {}

    // let openTabsetStr = PlacesUIUtils.openTabset
    //   .toString()
    //   .replace(
    //     /(\s+)(inBackground: loadInBackground,)/,
    //     "$1$2$1userContextId: aEvent.userContextId || 0,"
    //   );
    // let openNodeStr = PlacesUIUtils._openNodeIn
    //   .toString()
    //   .replace(/(\s+)(aPrivate = false)\n/, "$1$2,$1userContextId = 0\n")
    //   .replace(/(\s+)(private: aPrivate,)\n/, "$1$2$1userContextId,\n");

    // aWindow.PlacesUIUtils.openTabset = new Function(
    //   "return function " + openTabsetStr
    // )();
    // aWindow.PlacesUIUtils._openNodeIn = new Function("return " + openNodeStr)();
  },

  openAllPrivate(event) {
    event.userContextId = this.container.userContextId;
    PlacesUIUtils.openSelectionInTabs(event);
  },

  openPrivateTab(event) {
    let view = event.target.parentElement._view;
    PlacesUIUtils._openNodeIn(
      view.selectedNode,
      "tab",
      view.ownerWindow,
      false,
      this.container.userContextId
    );
  },

  togglePrivate(aWindow, aTab = aWindow.gBrowser.selectedTab) {
    let { gBrowser } = aWindow;
    aTab.setAttribute("isToggling", true);
    let shouldSelect = aTab == aWindow.gBrowser.selectedTab;
    let newTab = gBrowser.duplicateTab(aTab);
    if (shouldSelect) {
      let gURLBar = aWindow.gURLBar;
      let focusUrlbar = gURLBar.focused;
      gBrowser.selectedTab = newTab;
      if (focusUrlbar) {
        gURLBar.focus();
      }
    }
    gBrowser.removeTab(aTab);
  },

  browserOpenTabPrivate(aWindow) {
    aWindow.openTrustedLinkIn(aWindow.BROWSER_NEW_TAB_URL, "tab", {
      userContextId: this.container.userContextId,
    });
  },

  initPrivateTabListeners(aWindow) {
    let { gBrowser } = aWindow;
    gBrowser.tabContainer.addEventListener("TabSelect", this.onTabSelect);
    gBrowser.tabContainer.addEventListener("TabOpen", this.onTabOpen);

    gBrowser.privateListener = e => {
      let browser = e.target;
      let tab = gBrowser.getTabForBrowser(browser);
      if (!tab) {
        return;
      }
      let isPrivate = this.isPrivate(tab);

      if (!isPrivate) {
        if (this.observePrivateTabs) {
          this.openTabs.delete(tab);
          if (!this.openTabs.size) {
            this.clearData();
          }
        }
        return;
      }

      if (this.observePrivateTabs) {
        this.openTabs.add(tab);
      }

      browser.browsingContext.useGlobalHistory = false;
    };

    aWindow.addEventListener("XULFrameLoaderCreated", gBrowser.privateListener);

    if (this.observePrivateTabs) {
      gBrowser.tabContainer.addEventListener("TabClose", this.onTabClose);
    }
  },

  onTabSelect(aEvent) {
    let tab = aEvent.target;
    if (!tab) {
      return;
    }
    let win = tab.ownerGlobal;
    let { PrivateTab } = win;
    let prevTab = aEvent.detail.previousTab;
    let isPrivate = PrivateTab.isPrivate(tab);

    if (tab.userContextId != prevTab.userContextId) {
      // Show/hide private mask on browser window
      PrivateTab.toggleMask(win);
      // Ensure we don't save search suggestions for PrivateTab
      win.gURLBar.isPrivate = isPrivate;
      // Update selected tab private status for autofill
      PrefUtils.set("browser.tabs.selectedTabPrivate", isPrivate);
    }
  },

  onTabOpen(aEvent) {
    // Update tab state cache
    let tab = aEvent.target;
    if (!tab) {
      return;
    }
    let win = tab.ownerGlobal;
    let { PrivateTab } = win;
    let prevTab = aEvent.detail.previousTab;
    // Don't need to worry about force updating tab state unless
    // the usercontextid's are different, as otherwise we know the
    // usercontextid will be correct and just need to assert whether
    // the tab is private or not.
    let isPrivate = PrivateTab.isPrivate(tab);
    if (tab.userContextId != prevTab.userContextId) {
      let userContextId = isPrivate ? PrivateTab.container.userContextId : 0;
      // Duplicating a tab copies the tab state cache from the parent tab.
      // Therefore we need to flush the tab state to ensure it's updated,
      // then overwrite the tab usercontextid so that any restored tabs
      // are opened in the correct container, rather than that of their
      // parent tab.
      let browser = tab.linkedBrowser;
      TabStateFlusher.flush(browser).then(() => {
        TabStateCache.update(tab.linkedBrowser.permanentKey, {
          isPrivate,
          userContextId,
        });
      });
    } else {
      TabStateCache.update(tab.linkedBrowser.permanentKey, {
        isPrivate,
      });
    }
  },

  onTabClose(aEvent) {
    let tab = aEvent.target;
    if (!tab) {
      return;
    }
    let { PrivateTab } = tab.ownerGlobal;
    if (PrivateTab.isPrivate(tab)) {
      PrivateTab.openTabs.delete(tab);
      if (!PrivateTab.openTabs.size) {
        PrivateTab.clearData();
      }
    }
  },

  toggleMask(aWindow) {
    let { gBrowser } = aWindow;
    let privateMask = aWindow.document.getElementById("private-mask");
    if (gBrowser.selectedTab.isToggling) {
      privateMask.setAttribute(
        "enabled",
        gBrowser.selectedTab.userContextId == this.container.userContextId
          ? "false"
          : "true"
      );
    } else {
      privateMask.setAttribute(
        "enabled",
        gBrowser.selectedTab.userContextId == this.container.userContextId
          ? "true"
          : "false"
      );
    }
  },

  get observePrivateTabs() {
    return (
      !this.config.neverClearData && !this.config.doNotClearDataUntilFxIsClosed
    );
  },

  initCustomFunctions(aWindow) {
    let { MozElements, customElements, PrivateTab } = aWindow;
    MozElements.MozTab.prototype.getAttribute = function(att) {
      if (att == "usercontextid" && this.getAttribute("isToggling", false)) {
        this.removeAttribute("isToggling");
        // If in private tab and we attempt to toggle, remove container, else convert to private tab
        return PrivateTab.orig_getAttribute.call(this, att) ==
          PrivateTab.container.userContextId
          ? 0
          : PrivateTab.container.userContextId;
      }
      return PrivateTab.orig_getAttribute.call(this, att);
    };

    aWindow.Object.defineProperty(
      customElements.get("tabbrowser-tabs").prototype,
      "allTabs",
      {
        get: function allTabs() {
          let children = Array.from(this.arrowScrollbox.children);
          while (
            children.length &&
            children[children.length - 1].tagName != "tab"
          ) {
            children.pop();
          }
          return children;
        },
      }
    );

    customElements.get("tabbrowser-tabs").prototype.insertBefore = function(
      tab,
      node
    ) {
      if (!this.arrowScrollbox) {
        throw new Error("Shouldn't call this without arrowscrollbox");
      }

      let { arrowScrollbox } = this;
      if (node == null) {
        node = arrowScrollbox.lastChild.previousSibling.previousSibling;
      }
      return arrowScrollbox.insertBefore(tab, node);
    };

    customElements.get(
      "tabbrowser-tabs"
    ).prototype._updateNewTabVisibility = function() {
      let wrap = n =>
        n.parentNode.localName == "toolbarpaletteitem" ? n.parentNode : n;
      let unwrap = n =>
        n && n.localName == "toolbarpaletteitem" ? n.firstElementChild : n;

      let newTabFirst = false;
      let sibling = (id, otherId) => {
        let sib = this;
        do {
          if (sib.id == "new-tab-button") {
            newTabFirst = true;
          }
          sib = unwrap(wrap(sib).nextElementSibling);
        } while (
          sib &&
          (sib.hidden || sib.id == "alltabs-button" || sib.id == otherId)
        );
        return sib?.id == id && sib;
      };

      const kAttr = "hasadjacentnewtabbutton";
      let adjacentNetTab = sibling("new-tab-button", PrivateTab.BTN_ID);
      if (adjacentNetTab) {
        this.setAttribute(kAttr, "true");
      } else {
        this.removeAttribute(kAttr);
      }

      const kAttr2 = "hasadjacentnewprivatetabbutton";
      let adjacentPrivateTab = sibling(PrivateTab.BTN_ID, "new-tab-button");
      if (adjacentPrivateTab) {
        this.setAttribute(kAttr2, "true");
      } else {
        this.removeAttribute(kAttr2);
      }

      if (adjacentNetTab && adjacentPrivateTab) {
        let doc = adjacentPrivateTab.ownerDocument;
        if (newTabFirst) {
          doc
            .getElementById("tabs-newtab-button")
            .insertAdjacentElement(
              "afterend",
              doc.getElementById(PrivateTab.BTN2_ID)
            );
        } else {
          doc
            .getElementById(PrivateTab.BTN2_ID)
            .insertAdjacentElement(
              "afterend",
              doc.getElementById("tabs-newtab-button")
            );
        }
      }
    };
  },

  orig_getAttribute: Services.wm.getMostRecentBrowserWindow("navigator:browser")
    .MozElements.MozTab.prototype.getAttribute,
};
