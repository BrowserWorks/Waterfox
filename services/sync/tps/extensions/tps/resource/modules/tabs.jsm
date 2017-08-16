/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

 /* This is a JavaScript module (JSM) to be imported via
   Components.utils.import() and acts as a singleton.
   Only the following listed symbols will exposed on import, and only when
   and where imported. */

const EXPORTED_SYMBOLS = ["BrowserTabs"];

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://services-sync/main.js");

var BrowserTabs = {
  /**
   * Add
   *
   * Opens a new tab in the current browser window for the
   * given uri.  Throws on error.
   *
   * @param uri The uri to load in the new tab
   * @return nothing
   */
  Add(uri, fn) {
    // Open the uri in a new tab in the current browser window, and calls
    // the callback fn from the tab's onload handler.
    let wm = Cc["@mozilla.org/appshell/window-mediator;1"]
               .getService(Ci.nsIWindowMediator);
    let mainWindow = wm.getMostRecentWindow("navigator:browser");
    let browser = mainWindow.getBrowser();
    browser.addEventListener("load", fn, { once: true });
    let newtab = browser.addTab(uri);
    browser.selectedTab = newtab;
  },

  /**
   * Find
   *
   * Finds the specified uri and title in Weave's list of remote tabs
   * for the specified profile.
   *
   * @param uri The uri of the tab to find
   * @param title The page title of the tab to find
   * @param profile The profile to search for tabs
   * @return true if the specified tab could be found, otherwise false
   */
  Find(uri, title, profile) {
    // Find the uri in Weave's list of tabs for the given profile.
    let engine = Weave.Service.engineManager.get("tabs");
    for (let [, client] of Object.entries(engine.getAllClients())) {
      if (!client.tabs) {
        continue;
      }
      for (let key in client.tabs) {
        let tab = client.tabs[key];
        let weaveTabUrl = tab.urlHistory[0];
        if (uri == weaveTabUrl && profile == client.clientName)
          if (title == undefined || title == tab.title)
            return true;
      }
    }
    return false;
  },
};

