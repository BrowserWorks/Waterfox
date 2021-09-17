/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global browser Services window navigator tabFeatures */

const TabFeatures = {
  get contextItems() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "context_copyTabUrl",
          class: "tabFeature",
          oncommand:
            "tabFeatures.copyTabUrl(TabContextMenu.contextTab.linkedBrowser.currentURI.spec, window);",
          label: browser.i18n.getMessage("copyUrl"),
          preference: "browser.tabs.copyurl",
        },
        adjacentTo: "context_duplicateTabs",
        position: "afterend",
        defaultPref: true,
      },
      {
        tag: "menuitem",
        attrs: {
          id: "context_copyAllTabUrls",
          class: "tabFeature",
          oncommand: "tabFeatures.copyAllTabUrls(window);",
          label: browser.i18n.getMessage("copyAllUrls"),
          preference: "browser.tabs.copyallurls",
        },
        adjacentTo: "context_copyTabUrl",
        position: "afterend",
      },
    ];
  },

  get updateItems() {
    return [
      {
        id: "context_duplicateTab",
        attrs: {
          class: "tabFeature",
          preference: "browser.tabs.duplicateTab",
        },
        defaultPref: true,
      },
    ];
  },

  get menuBarItems() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "app_restartBrowser",
          class: "tabFeature",
          oncommand: "tabFeatures.restartBrowser(window);",
          label: browser.i18n.getMessage("restartBrowser"),
          preference: "browser.restart_menu.showpanelmenubtn",
        },
        adjacentTo: "goOfflineMenuitem",
        position: "afterend",
      },
    ];
  },

  get appMenuItems() {
    return [
      {
        tag: "toolbarbutton",
        attrs: {
          id: "appMenu-restart-button",
          class: "subviewbutton subviewbutton-iconic tabFeature",
          oncommand: "tabFeatures.restartBrowser(window);",
          label: browser.i18n.getMessage("restartBrowser"),
          preference: "browser.restart_menu.showpanelmenubtn",
        },
        adjacentTo: "appMenu-quit-button2",
        position: "beforebegin",
      },
    ];
  },

  async init() {
    // init tabfeatures helper in window
    browser.extensibles.tabfeatures.registerTabFeatures();
    // create required tab context menu elements
    this.contextItems.forEach(item => {
      this.createAdjacentElement(item);
    });
    // add additional attributes to existing elements for functionality
    this.updateItems.forEach(item => {
      this.setAttributes(item);
    });
    // add on popupshowing listener to display elements if prefs allow
    browser.extensibles.utils.addElementListener(
      "tabContextMenu",
      "popupshowing",
      "tabContext"
    );
    // get platform as restart button location differs based on platform
    let platform = await browser.extensibles.utils.getPlatform();
    // create required appmenu/menubar elements
    if (platform == "macosx") {
      this.menuBarItems.forEach(item => {
        this.createAdjacentElement(item);
      });
      // add on popupshowing listener to display elements if prefs allow
      browser.extensibles.utils.addElementListener(
        // "toolbar-menubar",
        "file-menu",
        "popupshowing",
        "tabContext"
      );
    } else {
      this.appMenuItems.forEach(item => {
        this.createAdjacentElement(item);
      });
      // add on popupshowing listener to display elements if prefs allow
      browser.extensibles.utils.addElementListener(
        "appMenu-popup",
        "popupshowing",
        "tabContext"
      );
    }
  },

  createAdjacentElement(item) {
    const { tag, attrs, adjacentTo, position } = item;
    browser.extensibles.utils.createAndPositionElement(
      tag,
      attrs,
      adjacentTo,
      position
    );
    if (attrs.preference) {
      this.setPref(item);
    }
  },

  createAppendElement(item) {
    const { tag, attrs, appendTo } = item;
    browser.extensibles.utils.createAndPositionElement(tag, attrs, appendTo);
    if (attrs.preference) {
      this.setPref(item);
    }
  },

  setAttributes(item) {
    const { id, attrs } = item;
    browser.extensibles.utils.setAttributes(id, attrs);
    if (attrs.preference) {
      this.setPref(item);
    }
  },

  setPref(item) {
    const { attrs } = item;
    let { defaultPref } = item;
    if (!defaultPref) {
      // Don't show added features by default
      defaultPref = false;
    }
    browser.extensibles.utils.registerPref(attrs.preference, defaultPref);
  },
};

(async function() {
  // init in primary window
  await TabFeatures.init();
  // init in window on created if not already initialized
  browser.windows.onCreated.addListener(async windowId => {
    if (
      !(await browser.extensibles.utils.initialized("tabFeatures")) &&
      windowId
    ) {
      await TabFeatures.init();
    }
  });
})();
