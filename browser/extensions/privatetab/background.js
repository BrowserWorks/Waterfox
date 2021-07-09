/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global browser Services window navigator privateTab */

const PrivateTab = {
  openAll: "placesContext_openBookmarkContainer:tabs",
  openAllLinks: "placesContext_openLinks:tabs",
  openTab: "placesContext_open:newtab",

  get privateTooltip() {
    let key = "(Ctrl+Alt+P)" // add a key getter to determine key based on OS
    let tooltip = browser.i18n.getMessage("newPrivateTooltip") + key;
    return tooltip;
  },

  get containerName() {
    return browser.i18n.getMessage("containerName");
  },
  get widgetAttrs() {
    return {
      id: "privateTab-button",
      label: browser.i18n.getMessage("newPrivateTab"),
      tooltiptext: this.privateTooltip,
      class: "toolbarbutton-1 chromeclass-toolbar-additional",
      oncommand: "privateTab.BrowserOpenTabPrivate(window)",
    };
  },

  async getPlacesContextAttrs() {
    this.openAllOncommand = await browser.privatetab.getElementAttr(
      this.openAll,
      "oncommand"
    );
    this.openAllOnclick = await browser.privatetab.getElementAttr(
      this.openAll,
      "onclick"
    );
    this.openAllLinksOncommand = await browser.privatetab.getElementAttr(
      this.openAllLinks,
      "oncommand"
    );
    this.openAllLinksOnclick = await browser.privatetab.getElementAttr(
      this.openAllLinks,
      "onclick"
    );
  },

  get placesContextItems() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "openAllPrivate",
          label: browser.i18n.getMessage("openAllPrivate"),
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand:
            "event.userContextId = " +
            this.container.userContextId +
            "; " +
            this.openAllOncommand,
          onclick:
            "event.userContextId = " +
            this.container.userContextId +
            "; " +
            this.openAllOnclick,
        },
        adjacentTo: this.openAll,
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openAllLinksPrivate",
          label: browser.i18n.getMessage("openAllPrivate"),
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand:
            "event.userContextId = " +
            this.container.userContextId +
            "; " +
            this.openAllLinksOncommand,
          onclick:
            "event.userContextId = " +
            this.container.userContextId +
            "; " +
            this.openAllLinksOnclick,
        },
        adjacentTo: this.openAllLinks,
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openPrivate",
          label: browser.i18n.getMessage("openPrivateTab"),
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand:
            'let view = event.target.parentElement._view; PlacesUIUtils._openNodeIn(view.selectedNode, "tab", view.ownerWindow, false, ' +
            this.container.userContextId +
            ")",
        },
        adjacentTo: this.openTab,
        position: "afterend",
      },
    ];
  },

  get keysetItems() {
    return [
      {
        tag: "keyset",
        attrs: {
          id: "privateTab-keyset",
        },
        adjacentTo: "mainKeyset",
        position: "afterend",
      },
    ];
  },

  get keyItems() {
    return [
      {
        tag: "key",
        attrs: {
          id: "togglePrivateTab-key",
          modifiers: "alt control",
          key: "T",
          oncommand: "privateTab.togglePrivate(window)",
        },
        appendTo: "privateTab-keyset",
      },
      {
        tag: "key",
        attrs: {
          id: "newPrivateTab-key",
          modifiers: "alt control",
          key: "P",
          oncommand: "privateTab.BrowserOpenTabPrivate(window)",
        },
        appendTo: "privateTab-keyset",
      },
    ];
  },

  get openLinkItems() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "menu_newPrivateTab",
          label: browser.i18n.getMessage("newPrivateTab"),
          accesskey: "v",
          acceltext: "Ctrl+Alt+P", // TODO: change to key getter
          class: "menuitem-iconic privatetab-icon",
          oncommand: "privateTab.BrowserOpenTabPrivate(window)",
        },
        adjacentTo: "menu_newNavigatorTab",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openLinkInPrivateTab",
          label: browser.i18n.getMessage("openLinkPrivate"),
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          hidden: true,
        },
        adjacentTo: "context-openlinkintab",
        position: "afterend",
      },
    ];
  },

  get toggleItems() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "toggleTabPrivateState",
          label: browser.i18n.getMessage("privateTab"),
          type: "checkbox",
          accesskey: "v",
          acceltext: "Ctrl+Alt+T", // TODO: change to key getter
          oncommand:
            "privateTab.togglePrivate(window, TabContextMenu.contextTab)",
        },
        adjacentTo: "context_pinTab",
        position: "afterend",
      },
    ];
  },

  get toolbarItems() {
    return [
      {
        tag: "toolbarbutton",
        attrs: {
          id: "newPrivateTab-button",
          label: browser.i18n.getMessage("newPrivateTab"),
          tooltiptext: this.privateTooltip,
          class: "toolbarbutton-1 chromeclass-toolbar-additional",
        },
        adjacentTo: "tabs-newtab-button",
        position: "afterend",
      },
    ];
  },

  async init() {
    // init privatetab helper in window object
    browser.privatetab.registerPrivateTab(this.containerName, this.widgetAttrs);
    // init privatetab in window
    if (browser.privatetab.isTopWindowPrivate()) {
      return;
    }
    this.container = await browser.privatetab.getContainer(this.containerName);
    // init placesContext
    await this.getPlacesContextAttrs();
    this.placesContextItems.forEach(item => {
      this.createAdjacentElement(item);
    });

    browser.privatetab.addElementListener(
      "placesContext",
      "popupshowing",
      "places"
    );

    if (!browser.privatetab.windowIsChromeWindow()) {
      return;
    }
    // init keyset
    this.keysetItems.forEach(item => {
      this.createAdjacentElement(item);
    });

    this.keyItems.forEach(item => {
      this.createAppendElement(item);
    });

    // init openLink
    this.openLinkItems.forEach(item => {
      this.createAdjacentElement(item);
    });

    browser.privatetab.addElementListener(
      "contentAreaContextMenu",
      "popupshowing",
      "showContent"
    );
    browser.privatetab.addElementListener(
      "contentAreaContextMenu",
      "popuphidden",
      "hideContent"
    );
    browser.privatetab.addElementListener(
      "openLinkInPrivateTab",
      "command",
      "openLink"
    );

    // init toggleTab
    this.toggleItems.forEach(item => {
      this.createAdjacentElement(item);
    });

    browser.privatetab.addElementListener(
      "tabContextMenu",
      "popupshowing",
      "toggleTab"
    );

    // init privateMask
    browser.privatetab.updatePrivateMaskId("private-mask");

    // init toolbarbutton
    this.toolbarItems.forEach(item => {
      this.createAdjacentElement(item);
    });

    browser.privatetab.addElementListener(
      "newPrivateTab-button",
      "click",
      "toolbarClick"
    );

    // init privateTab listeners
    browser.privatetab.initPrivateTabListeners();

    // register additional functions
    browser.privatetab.initCustomFunctions();
  },

  createAdjacentElement(item) {
    const { tag, attrs, adjacentTo, position } = item;
    browser.privatetab.createAndPositionElement(
      tag,
      attrs,
      adjacentTo,
      position
    );
  },

  createAppendElement(item) {
    const { tag, attrs, appendTo } = item;
    browser.privatetab.createAndPositionElement(tag, attrs, appendTo);
  },
};

(async function() {
  // init in primary window
  await PrivateTab.init();
  // init in window on created if not already initialized
  browser.windows.onCreated.addListener(async windowId => {
    if (!(await browser.privatetab.initialized()) && windowId) {
      await PrivateTab.init();
    }
  });
})();
