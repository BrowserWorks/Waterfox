/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global browser Services window navigator statusBar */

const StatusBar = {
  get dummyItems() {
    return [
      {
        tag: "toolbar",
        attrs: {
          id: "status-dummybar",
          toolbarname: browser.i18n.getMessage("statusBar"),
          hidden: true,
        },
        appendTo: "gNavToolbox",
      },
    ];
  },

  get barItems() {
    return [
      {
        tag: "toolbar",
        attrs: {
          id: "status-bar",
          customizable: "true",
          context: "toolbar-context-menu",
          mode: "icons",
        },
        setAs: "win.statusbar.node",
      },
      {
        tag: "toolbaritem",
        attrs: {
          id: "status-text",
          flex: "1",
          width: "100",
        },
        setAs: "win.statusbar.textNode",
      },
    ];
  },

  async init() {
    // init statusbar helper in window object
    browser.extensibles.statusbar.registerStatusBar();
    // init dummy bar
    this.dummyItems.forEach(item => {
      this.createAppendElement(item);
    });
    browser.extensibles.statusbar.configureStatusBar("status-dummybar");
    // init statusbar nodes
    this.barItems.forEach(item => {
      this.createElementAs(item);
    });
    browser.extensibles.statusbar.configureStatusBar("status-bar");
    // init resizer
    browser.extensibles.statusbar.configureResizer();
    // override status panel
    browser.extensibles.statusbar.overrideStatusPanelLabel();
    browser.extensibles.statusbar.configureBottomBox();
  },

  createAdjacentElement(item) {
    const { tag, attrs, adjacentTo, position } = item;
    browser.extensibles.utils.createAndPositionElement(
      tag,
      attrs,
      adjacentTo,
      position
    );
  },

  createAppendElement(item) {
    const { tag, attrs, appendTo } = item;
    browser.extensibles.utils.createAndPositionElement(tag, attrs, appendTo);
  },

  createElementAs(item) {
    const { tag, attrs, setAs } = item;
    browser.extensibles.utils.createElementAs(tag, attrs, setAs);
  },
};

(async function() {
  // init in primary window
  await StatusBar.init();
  // init in window on created if not already initialized
  browser.windows.onCreated.addListener(async windowId => {
    if (
      !(await browser.extensibles.utils.initialized("statusBar")) &&
      windowId
    ) {
      await StatusBar.init();
    }
  });
})();
