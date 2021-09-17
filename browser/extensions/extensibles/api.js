/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/* globals ExtensionAPI Services */

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

const { PanelMultiView } = ChromeUtils.import(
  "resource:///modules/PanelMultiView.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "BrowserUtils",
  "resource:///modules/BrowserUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "PrefUtils",
  "resource:///modules/PrefUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "StatusBar",
  "resource:///modules/StatusBar.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "PrivateTab",
  "resource:///modules/PrivateTab.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "TabFeatures",
  "resource:///modules/TabFeatures.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "PrefsExt",
  "resource:///modules/AboutPreferencesExtension.jsm"
);

this.extensibles = class extends ExtensionAPI {
  getAPI(context) {
    return {
      extensibles: {
        utils: {
          // internal functions/props
          get mostRecentWindow() {
            return Services.wm.getMostRecentWindow("navigator:browser");
          },

          get document() {
            return Services.wm.getMostRecentWindow("navigator:browser")
              .document;
          },

          get content() {
            return Services.wm.getMostRecentWindow("navigator:browser").content
              .document;
          },

          createElement(aDoc, aTag, aAttrs) {
            // Create element
            let el = aDoc.createXULElement(aTag);
            for (let att in aAttrs) {
              // don't set null attrs
              if (aAttrs[att]) {
                el.setAttribute(att, aAttrs[att]);
              }
            }
            return el;
          },

          // api endpoints
          createAndPositionElement(
            aTag,
            aAttrs,
            aAdjacentTo,
            aPosition,
            aContent = false
          ) {
            let doc = this.document;
            if (aContent) {
              doc = this.content;
            }
            // Create element
            let el = this.createElement(doc, aTag, aAttrs);
            // Place it in certain location
            let pos = doc.getElementById(aAdjacentTo);
            if (aPosition) {
              // App Menu items are not retrieved successfully with doc.getElementById
              if (!pos) {
                pos = PanelMultiView.getViewNode(this.document, aAdjacentTo);
              }
              // If neither method to retrieve a positional element succeeded
              // don't attempt to insert as it will fail
              if (pos) {
                pos.insertAdjacentElement(aPosition, el);
              }
            } else if (aAdjacentTo == "gNavToolbox") {
              this.mostRecentWindow.gNavToolbox.appendChild(el);
            } else {
              pos.appendChild(el);
            }
          },

          createElementAs(aTag, aAttrs, aSetAs) {
            let doc = this.document;
            // create element
            if (aSetAs == "win.statusbar.node") {
              this.mostRecentWindow.statusbar.node = this.createElement(
                doc,
                aTag,
                aAttrs
              );
            } else if (aSetAs == "win.statusbar.textNode") {
              this.mostRecentWindow.statusbar.textNode = this.createElement(
                doc,
                aTag,
                aAttrs
              );
            }
          },

          async elementExistsInContent(aId) {
            return this.content.getElementById(aId);
          },

          async getElementAttr(aId, aAttr) {
            let doc = this.document;
            let el = doc.getElementById(aId);
            return el.getAttribute(aAttr);
          },

          setAttributes(aId, aAttrs) {
            let el = this.document.getElementById(aId);
            Object.entries(aAttrs).forEach(([id, val]) => {
              el.setAttribute(id, val);
            });
          },

          isTopWindowPrivate() {
            let win = this.mostRecentWindow;
            return win.PrivateBrowsingUtils.isWindowPrivate(win);
          },

          windowIsChromeWindow() {
            return (
              this.mostRecentWindow.location.href ==
              "chrome://browser/content/browser.xhtml"
            );
          },

          async getContainer(aName) {
            let win = this.mostRecentWindow;
            if (!win.privateTab.container) {
              let container = win.privateTab.initContainer(aName);
              win.privateTab.container = container;
            }
            // rebuild container obj as cloning/returning privateTab.containber returns undefined
            let returnObj = {};
            Object.entries(win.privateTab.container).forEach(([key, value]) => {
              returnObj[key] = value;
            });
            return returnObj;
          },

          async addElementListener(aId, aEvent, aSubject) {
            let func;
            switch (aSubject) {
              case "places":
                func = PrivateTab.placesContext;
                break;
              case "showContent":
                func = PrivateTab.contentContext;
                break;
              case "hideContent":
                func = PrivateTab.hideContext;
                break;
              case "openLink":
                func = PrivateTab.openLink;
                break;
              case "toggleTab":
                func = PrivateTab.tabContext;
                break;
              case "toolbarClick":
                func = PrivateTab.toolbarClick;
                break;
              case "tabContext":
                func = TabFeatures.tabContext;
                break;
            }
            this.document.getElementById(aId).addEventListener(aEvent, func);
          },

          registerPref(aName, aValue) {
            // Add the below if we move from boolean to string aValue type
            // if (aValue === "true" || aValue === "false") {
            //   aValue = aValue === "true";
            // }
            PrefUtils.set(aName, aValue, true);
          },

          addPreference(aId, aType) {
            this.mostRecentWindow.content.Preferences.add({
              id: aId,
              type: aType,
            });
          },

          async getPlatform() {
            return AppConstants.platform;
          },

          async append(aId, aText) {
            this.content.getElementById(aId).append(aText);
          },

          async initialized(aName) {
            return typeof this.mostRecentWindow[aName] == "object";
          },
        },
        statusbar: {
          // internal functions/props
          get mostRecentWindow() {
            return Services.wm.getMostRecentWindow("navigator:browser");
          },

          get document() {
            return Services.wm.getMostRecentWindow("navigator:browser")
              .document;
          },
          createElement(aDoc, aTag, aAttrs) {
            // Create element
            let el = aDoc.createXULElement(aTag);
            for (let att in aAttrs) {
              // don't set null attrs
              if (aAttrs[att]) {
                el.setAttribute(att, aAttrs[att]);
              }
            }
            return el;
          },
          registerStatusBar() {
            let win = this.mostRecentWindow;
            if (!win.statusBar) {
              win.statusBar = StatusBar;
              win.statusBar.initPrefListeners();
              win.statusBar.setStyle();
              win.statusBar.registerArea("status-bar");
            }
          },

          configureStatusBar(aId) {
            let win = this.mostRecentWindow;
            if (aId == "status-dummybar") {
              win.statusBar.configureDummyBar(win, aId);
            } else if (aId == "status-bar") {
              win.statusBar.configureStatusBar(win);
            }
          },

          configureResizer() {
            let win = this.mostRecentWindow;
            let { document } = win;
            let resizerContainer = this.createElement(document, "toolbaritem", {
              id: "resizer-container",
            });
            let resizer = this.createElement(document, "resizer");
            resizerContainer.appendChild(resizer);
            win.statusbar.node.appendChild(resizerContainer);
          },

          overrideStatusPanelLabel() {
            let win = this.mostRecentWindow;
            win.statusBar.overrideStatusPanelLabel(win);
          },

          configureBottomBox() {
            let win = this.mostRecentWindow;
            win.statusBar.configureBottomBox(win);
          },
        },
        privatetab: {
          // internal functions/props
          get mostRecentWindow() {
            return Services.wm.getMostRecentWindow("navigator:browser");
          },

          get document() {
            return Services.wm.getMostRecentWindow("navigator:browser")
              .document;
          },
          registerPrivateTab(aName, aAttrs) {
            let win = this.mostRecentWindow;
            if (!win.privateTab) {
              win.privateTab = PrivateTab;
              if (!win.privateTab.container) {
                win.privateTab.container = win.privateTab.initContainer(aName);
              }
              win.privateTab.setStyle(win);
              win.privateTab.overridePlacesUIUtils();
              win.privateTab.createPrivateWidget(win, aAttrs);
              win.privateTab.setPrivateObserver();
            }
          },

          async updatePrivateMaskId(aId) {
            let privateMask = this.document.getElementsByClassName(
              "private-browsing-indicator"
            )[0];
            privateMask.id = aId;
          },

          async initPrivateTabListeners() {
            let win = this.mostRecentWindow;
            win.privateTab.initPrivateTabListeners(win);
          },

          async initCustomFunctions() {
            let win = this.mostRecentWindow;
            win.privateTab.initCustomFunctions(win);
          },
        },
        tabfeatures: {
          // internal functions/props
          get mostRecentWindow() {
            return Services.wm.getMostRecentWindow("navigator:browser");
          },

          get document() {
            return Services.wm.getMostRecentWindow("navigator:browser")
              .document;
          },
          registerTabFeatures() {
            let win = this.mostRecentWindow;
            if (!win.tabFeatures) {
              win.tabFeatures = TabFeatures;
              win.tabFeatures.setPrefs();
              win.tabFeatures.initPrefListeners();
              win.tabFeatures.moveTabBar(win);
              BrowserUtils.setStyle(TabFeatures.style);
            }
          },
        },
        prefsext: {
          setStyle() {
            BrowserUtils.setStyle(PrefsExt.style);
          },
        },
      },
    };
  }
};
