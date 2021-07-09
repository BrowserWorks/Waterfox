/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/* globals ExtensionAPI */

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "PrivateTab",
  "resource:///modules/PrivateTab.jsm"
);

this.privatetab = class extends ExtensionAPI {
  getAPI(context) {
    return {
      privatetab: {
        // internal functions/props
        get mostRecentWindow() {
          return Services.wm.getMostRecentWindow("navigator:browser");
        },

        get document() {
          return Services.wm.getMostRecentWindow("navigator:browser").document;
        },

        // api endpoints
        createAndPositionElement(aTag, aAttrs, aAdjacentTo, aPosition) {
          let doc = this.document;
          // Create element
          let el = doc.createXULElement(aTag);
          for (let att in aAttrs) {
            // don't set null attrs
            if (aAttrs[att]) {
              el.setAttribute(att, aAttrs[att]);
            }
          }
          // Place it in certain location
          let pos = doc.getElementById(aAdjacentTo);
          if (aPosition) {
            pos.insertAdjacentElement(aPosition, el);
          } else {
            pos.appendChild(el);
          }
        },

        async getElementAttr(aId, aAttr) {
          let doc = this.document;
          let el = doc.getElementById(aId);
          return el.getAttribute(aAttr);
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
          }
          this.document.getElementById(aId).addEventListener(aEvent, func);
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

        async initialized() {
          return typeof this.mostRecentWindow.privateTab == "object";
        },
      },
    };
  }
};
