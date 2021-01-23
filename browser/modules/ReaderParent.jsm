// -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["ReaderParent"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "PlacesUtils",
  "resource://gre/modules/PlacesUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ReaderMode",
  "resource://gre/modules/ReaderMode.jsm"
);

const gStringBundle = Services.strings.createBundle(
  "chrome://global/locale/aboutReader.properties"
);

var ReaderParent = {
  // Listeners are added in BrowserGlue.jsm
  receiveMessage(message) {
    switch (message.name) {
      case "Reader:FaviconRequest": {
        if (message.target.messageManager) {
          try {
            let preferredWidth = message.data.preferredWidth || 0;
            let uri = Services.io.newURI(message.data.url);
            PlacesUtils.favicons.getFaviconURLForPage(
              uri,
              iconUri => {
                if (iconUri) {
                  iconUri = PlacesUtils.favicons.getFaviconLinkForIcon(iconUri);
                  message.target.messageManager.sendAsyncMessage(
                    "Reader:FaviconReturn",
                    {
                      url: message.data.url,
                      faviconUrl: iconUri.pathQueryRef.replace(/^favicon:/, ""),
                    }
                  );
                }
              },
              preferredWidth
            );
          } catch (ex) {
            Cu.reportError(
              "Error requesting favicon URL for about:reader content: " + ex
            );
          }
        }
        break;
      }

      case "Reader:UpdateReaderButton": {
        let browser = message.target;
        if (message.data && message.data.isArticle !== undefined) {
          browser.isArticle = message.data.isArticle;
        }
        this.updateReaderButton(browser);
        break;
      }
    }
  },

  updateReaderButton(browser) {
    let win = browser.ownerGlobal;
    if (browser != win.gBrowser.selectedBrowser) {
      return;
    }

    let button = win.document.getElementById("reader-mode-button");
    let menuitem = win.document.getElementById("menu_readerModeItem");
    let key = win.document.getElementById("key_toggleReaderMode");
    if (browser.currentURI.spec.startsWith("about:reader")) {
      let closeText = gStringBundle.GetStringFromName("readerView.close");

      button.setAttribute("readeractive", true);
      button.hidden = false;
      button.setAttribute("aria-label", closeText);

      menuitem.setAttribute("label", closeText);
      menuitem.setAttribute("hidden", false);
      menuitem.setAttribute(
        "accesskey",
        gStringBundle.GetStringFromName("readerView.close.accesskey")
      );

      key.setAttribute("disabled", false);

      Services.obs.notifyObservers(null, "reader-mode-available");
    } else {
      let enterText = gStringBundle.GetStringFromName("readerView.enter");

      button.removeAttribute("readeractive");
      button.hidden = !browser.isArticle;
      button.setAttribute("aria-label", enterText);

      menuitem.setAttribute("label", enterText);
      menuitem.setAttribute("hidden", !browser.isArticle);
      menuitem.setAttribute(
        "accesskey",
        gStringBundle.GetStringFromName("readerView.enter.accesskey")
      );

      key.setAttribute("disabled", !browser.isArticle);

      if (browser.isArticle) {
        Services.obs.notifyObservers(null, "reader-mode-available");
      }
    }
  },

  forceShowReaderIcon(browser) {
    browser.isArticle = true;
    this.updateReaderButton(browser);
  },

  buttonClick(event) {
    if (event.button != 0) {
      return;
    }
    this.toggleReaderMode(event);
  },

  toggleReaderMode(event) {
    let win = event.target.ownerGlobal;
    let browser = win.gBrowser.selectedBrowser;
    browser.messageManager.sendAsyncMessage("Reader:ToggleReaderMode");
  },

  /**
   * Gets an article for a given URL. This method will download and parse a document.
   *
   * @param url The article URL.
   * @param browser The browser where the article is currently loaded.
   * @return {Promise}
   * @resolves JS object representing the article, or null if no article is found.
   */
  async _getArticle(url, browser) {
    return ReaderMode.downloadAndParseDocument(url).catch(e => {
      if (e && e.newURL) {
        // Pass up the error so we can navigate the browser in question to the new URL:
        throw e;
      }
      Cu.reportError("Error downloading and parsing document: " + e);
      return null;
    });
  },
};
