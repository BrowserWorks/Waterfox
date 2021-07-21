/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global statusBar */

const EXPORTED_SYMBOLS = ["StatusBar"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { CustomizableUI } = ChromeUtils.import(
  "resource:///modules/CustomizableUI.jsm"
);

const { PrefUtils } = ChromeUtils.import("resource:///modules/PrefUtils.jsm");

const StatusBar = {
  PREF_ENABLED: "browser.statusbar.enabled",
  PREF_STATUSTEXT: "browser.statusbar.appendStatusText",

  get enabled() {
    return PrefUtils.get(this.PREF_ENABLED);
  },

  get textInBar() {
    return this.enabled && PrefUtils.get(this.PREF_STATUSTEXT);
  },

  initPrefListeners() {
    PrefUtils.set(this.PREF_ENABLED, false, true);
    PrefUtils.set(this.PREF_STATUSTEXT, true, true);
    this.enabledListener = PrefUtils.addListener(
      this.PREF_ENABLED,
      isEnabled => {
        CustomizableUI.getWidget("status-dummybar").instances.forEach(
          dummyBar => {
            dummyBar.node.setAttribute("collapsed", !isEnabled);
          }
        );
      }
    );
    this.textListener = PrefUtils.addListener(
      this.PREF_STATUSTEXT,
      isEnabled => {
        if (!statusBar.enabled) {
          return;
        }
        StatusBar.executeInAllWindows((doc, win) => {
          let StatusPanel = win.StatusPanel;
          if (isEnabled) {
            win.statusbar.textNode.appendChild(StatusPanel._labelElement);
          } else {
            StatusPanel.panel.firstChild.appendChild(StatusPanel._labelElement);
          }
        });
      }
    );
  },

  executeInAllWindows(aFunc) {
    let windows = Services.wm.getEnumerator("navigator:browser");
    while (windows.hasMoreElements()) {
      let win = windows.getNext();
      if (!win.statusBar) {
        continue;
      }
      let { document } = win;
      aFunc(document, win);
    }
  },

  setStyle() {
    let styleSheetService = Cc[
      "@mozilla.org/content/style-sheet-service;1"
    ].getService(Ci.nsIStyleSheetService);

    let url = Services.io.newURI(
      "data:text/css;charset=UTF-8," +
        encodeURIComponent(`
           @-moz-document url('chrome://browser/content/browser.xhtml') {
            #status-bar {
                color: initial !important;
                background-color: var(--toolbar-non-lwt-bgcolor) !important;
              }
              #status-text > #statuspanel-label {
                border-top: 0 !important;
                background-color: unset !important;
                color: #444 !important;
              }
              #browser-bottombox:not([collapsed]) {
                border-top: 1px solid var(--chrome-content-separator-color) !important;
              }
              #wrapper-status-text label::after {
                content: "Status text" !important;
                color: red !important;
                border: 1px #aaa solid !important;
                border-radius: 3px !important;
                font-weight: bold !important;
              }
              #status-bar > #status-text {
                display: flex !important;
                justify-content: center !important;
                align-content: center !important;
                flex-direction: column !important;
              }
            }
          `)
    );
    let type = styleSheetService.USER_SHEET;

    styleSheetService.loadAndRegisterSheet(url, type);
  },

  registerArea(aArea) {
    CustomizableUI.registerArea(aArea, {});
  },

  configureDummyBar(aWindow, aId) {
    let { document } = aWindow;
    let el = document.getElementById(aId);
    el.collapsed = !this.enabled;
    el.setAttribute = function(att, value) {
      let result = Element.prototype.setAttribute.apply(this, arguments);

      if (att == "collapsed") {
        let StatusPanel = aWindow.StatusPanel;
        if (value === true) {
          PrefUtils.set(aWindow.statusBar.PREF_ENABLED, false);
          aWindow.statusbar.node.setAttribute("collapsed", true);
          StatusPanel.panel.firstChild.appendChild(StatusPanel._labelElement);
          aWindow.statusbar.node.parentNode.collapsed = true;
        } else {
          PrefUtils.set(aWindow.statusBar.PREF_ENABLED, true);
          aWindow.statusbar.node.setAttribute("collapsed", false);
          if (aWindow.statusBar.textInBar) {
            aWindow.statusbar.textNode.appendChild(StatusPanel._labelElement);
          }
          aWindow.statusbar.node.parentNode.collapsed = false;
        }
      }

      return result;
    };
  },

  configureStatusBar(aWindow) {
    let StatusPanel = aWindow.StatusPanel;
    if (this.textInBar) {
      aWindow.statusbar.textNode.appendChild(StatusPanel._labelElement);
    }
    aWindow.statusbar.node.appendChild(aWindow.statusbar.textNode);
  },

  overrideStatusPanelLabel(aWindow) {
    let { StatusPanel, MousePosTracker } = aWindow;
    let window = aWindow;
    eval(
      'Object.defineProperty(StatusPanel, "_label", {' +
        Object.getOwnPropertyDescriptor(StatusPanel, "_label")
          .set.toString()
          .replace(/^set _label/, "set")
          .replace(
            /((\s+)this\.panel\.setAttribute\("inactive", "true"\);)/,
            "$2this._labelElement.value = val;$1"
          ) +
        ", enumerable: true, configurable: true});"
    );
  },

  configureBottomBox(aWindow) {
    let { document } = aWindow;
    let bottomBox = document.getElementById("browser-bottombox");
    if (!this.enabled) {
      bottomBox.collapsed = true;
    }
    CustomizableUI.registerToolbarNode(aWindow.statusbar.node);
    bottomBox.appendChild(aWindow.statusbar.node);
  },
};
