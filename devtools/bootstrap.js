/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global content, APP_SHUTDOWN */
/* exported startup, shutdown, install, uninstall */

"use strict";

const Cu = Components.utils;
const Ci = Components.interfaces;
const {Services} = Cu.import("resource://gre/modules/Services.jsm", {});
const {NetUtil} = Cu.import("resource://gre/modules/NetUtil.jsm", {});
const {AppConstants} = Cu.import("resource://gre/modules/AppConstants.jsm", {});

// MultiWindowKeyListener instance for Ctrl+Alt+R key
let listener;
// nsIURI to the addon root folder
let resourceURI;

function actionOccurred(id) {
  let {require} = Cu.import("resource://devtools/shared/Loader.jsm", {});
  let Telemetry = require("devtools/client/shared/telemetry");
  let telemetry = new Telemetry();
  telemetry.actionOccurred(id);
}

// Synchronously fetch the content of a given URL
function readURI(uri) {
  let stream = NetUtil.newChannel({
    uri: NetUtil.newURI(uri, "UTF-8"),
    loadUsingSystemPrincipal: true}
  ).open2();
  let count = stream.available();
  let data = NetUtil.readInputStreamToString(stream, count, {
    charset: "UTF-8"
  });

  stream.close();

  return data;
}

/**
 * Interpret the processing instructions contained in a preferences file, based on a
 * limited set of supported #if statements. After we ship as an addon, we don't want to
 * introduce anymore processing instructions, so all unrecognized preprocessing
 * instructions will be treated as an error.
 *
 * This function is mostly copied from devtools/client/inspector/webpack/prefs-loader.js
 *
 * @param  {String} content
 *         The string content of a preferences file.
 * @return {String} the content stripped of preprocessing instructions.
 */
function interpretPreprocessingInstructions(content) {
  const ifMap = {
    "#if MOZ_UPDATE_CHANNEL == beta": AppConstants.MOZ_UPDATE_CHANNEL === "beta",
    "#if defined(NIGHTLY_BUILD)": AppConstants.NIGHTLY_BUILD,
    "#ifdef MOZ_DEV_EDITION": AppConstants.MOZ_DEV_EDITION,
    "#ifdef RELEASE_OR_BETA": AppConstants.RELEASE_OR_BETA,
  };

  let lines = content.split("\n");
  let ignoring = false;
  let newLines = [];
  let continuation = false;
  for (let line of lines) {
    if (line.startsWith("#if")) {
      if (!(line in ifMap)) {
        throw new Error("missing line in ifMap: " + line);
      }
      ignoring = !ifMap[line];
    } else if (line.startsWith("#else")) {
      ignoring = !ignoring;
    } else if (line.startsWith("#endif")) {
      ignoring = false;
    }

    let isPrefLine = /^ *(sticky_)?pref\("([^"]+)"/.test(line);
    if (continuation || (!ignoring && isPrefLine)) {
      newLines.push(line);

      // The call to pref(...); might span more than one line.
      continuation = !/\);/.test(line);
    }
  }
  return newLines.join("\n");
}

// Read a preference file and set all of its defined pref as default values
// (This replicates the behavior of preferences files from mozilla-central)
function processPrefFile(url) {
  let content = readURI(url);
  content = interpretPreprocessingInstructions(content);
  content.match(/pref\("[^"]+",\s*.+\s*\)/g).forEach(item => {
    let m = item.match(/pref\("([^"]+)",\s*(.+)\s*\)/);
    let name = m[1];
    let val = m[2].trim();

    // Prevent overriding prefs that have been changed by the user
    if (Services.prefs.prefHasUserValue(name)) {
      return;
    }
    let defaultBranch = Services.prefs.getDefaultBranch("");
    if ((val.startsWith("\"") && val.endsWith("\"")) ||
        (val.startsWith("'") && val.endsWith("'"))) {
      val = val.substr(1, val.length - 2);
      val = val.replace(/\\"/g, '"');
      defaultBranch.setCharPref(name, val);
    } else if (val.match(/[0-9]+/)) {
      defaultBranch.setIntPref(name, parseInt(val, 10));
    } else if (val == "true" || val == "false") {
      defaultBranch.setBoolPref(name, val == "true");
    } else {
      console.log("Unable to match preference type for value:", val);
    }
  });
}

function setPrefs() {
  processPrefFile(resourceURI.spec + "./client/preferences/devtools.js");
  processPrefFile(resourceURI.spec + "./client/preferences/debugger.js");
  processPrefFile(resourceURI.spec + "./client/webide/webide-prefs.js");
}

// Helper to listen to a key on all windows
function MultiWindowKeyListener({ keyCode, ctrlKey, altKey, callback }) {
  let keyListener = function (event) {
    if (event.ctrlKey == !!ctrlKey &&
        event.altKey == !!altKey &&
        event.keyCode === keyCode) {
      callback(event);

      // Call preventDefault to avoid duplicated events when
      // doing the key stroke within a tab.
      event.preventDefault();
    }
  };

  let observer = function (window, topic, data) {
    // Listen on keyup to call keyListener only once per stroke
    if (topic === "domwindowopened") {
      window.addEventListener("keyup", keyListener);
    } else {
      window.removeEventListener("keyup", keyListener);
    }
  };

  return {
    start: function () {
      // Automatically process already opened windows
      let e = Services.ww.getWindowEnumerator();
      while (e.hasMoreElements()) {
        let window = e.getNext();
        observer(window, "domwindowopened", null);
      }
      // And listen for new ones to come
      Services.ww.registerNotification(observer);
    },

    stop: function () {
      Services.ww.unregisterNotification(observer);
      let e = Services.ww.getWindowEnumerator();
      while (e.hasMoreElements()) {
        let window = e.getNext();
        observer(window, "domwindowclosed", null);
      }
    }
  };
}

let getTopLevelWindow = function (window) {
  return window.QueryInterface(Ci.nsIInterfaceRequestor)
               .getInterface(Ci.nsIWebNavigation)
               .QueryInterface(Ci.nsIDocShellTreeItem)
               .rootTreeItem
               .QueryInterface(Ci.nsIInterfaceRequestor)
               .getInterface(Ci.nsIDOMWindow);
};

function unload(reason) {
  // This frame script is going to be executed in all processes:
  // parent and child
  Services.ppmm.loadProcessScript("data:,(" + function (scriptReason) {
    /* Flush message manager cached frame scripts as well as chrome locales */
    let obs = Components.classes["@mozilla.org/observer-service;1"]
                        .getService(Components.interfaces.nsIObserverService);
    obs.notifyObservers(null, "message-manager-flush-caches");

    /* Also purge cached modules in child processes, we do it a few lines after
       in the parent process */
    if (Services.appinfo.processType == Services.appinfo.PROCESS_TYPE_CONTENT) {
      Services.obs.notifyObservers(null, "devtools-unload", scriptReason);
    }
  } + ")(\"" + reason.replace(/"/g, '\\"') + "\")", false);

  // As we can't get a reference to existing Loader.jsm instances, we send them
  // an observer service notification to unload them.
  Services.obs.notifyObservers(null, "devtools-unload", reason);

  // Then spawn a brand new Loader.jsm instance and start the main module
  Cu.unload("resource://devtools/shared/Loader.jsm");
  // Also unload all resources loaded as jsm, hopefully all of them are going
  // to be converted into regular modules
  Cu.unload("resource://devtools/client/shared/browser-loader.js");
  Cu.unload("resource://devtools/client/framework/ToolboxProcess.jsm");
  Cu.unload("resource://devtools/shared/apps/Devices.jsm");
  Cu.unload("resource://devtools/client/scratchpad/scratchpad-manager.jsm");
  Cu.unload("resource://devtools/shared/Parser.jsm");
  Cu.unload("resource://devtools/client/shared/DOMHelpers.jsm");
  Cu.unload("resource://devtools/client/shared/widgets/VariablesView.jsm");
  Cu.unload("resource://devtools/client/responsivedesign/responsivedesign.jsm");
  Cu.unload("resource://devtools/client/shared/widgets/AbstractTreeItem.jsm");
  Cu.unload("resource://devtools/shared/deprecated-sync-thenables.js");
}

function reload(event) {
  // We automatically reload the toolbox if we are on a browser tab
  // with a toolbox already opened
  let reloadToolbox = false;
  if (event) {
    let top = getTopLevelWindow(event.view);
    let isBrowser = top.location.href.includes("/browser.xul");
    if (isBrowser && top.gBrowser) {
      // We do not use any devtools code before the call to Loader.jsm reload as
      // any attempt to use Loader.jsm to load a module will instanciate a new
      // Loader.
      let nbox = top.gBrowser.getNotificationBox();
      reloadToolbox =
        top.document.getAnonymousElementByAttribute(nbox, "class",
          "devtools-toolbox-bottom-iframe") ||
        top.document.getAnonymousElementByAttribute(nbox, "class",
          "devtools-toolbox-side-iframe") ||
        Services.wm.getMostRecentWindow("devtools:toolbox");
    }
  }
  let browserConsole = Services.wm.getMostRecentWindow("devtools:webconsole");
  let reopenBrowserConsole = false;
  if (browserConsole) {
    browserConsole.close();
    reopenBrowserConsole = true;
  }

  dump("Reload DevTools.  (reload-toolbox:" + reloadToolbox + ")\n");

  // Invalidate xul cache in order to see changes made to chrome:// files
  Services.obs.notifyObservers(null, "startupcache-invalidate");

  unload("reload");

  // Update the preferences before starting new code
  setPrefs();

  const {devtools} = Cu.import("resource://devtools/shared/Loader.jsm", {});
  devtools.require("devtools/client/framework/devtools-browser");

  // Go over all top level windows to reload all devtools related things
  let windowsEnum = Services.wm.getEnumerator(null);
  while (windowsEnum.hasMoreElements()) {
    let window = windowsEnum.getNext();
    let windowtype = window.document.documentElement.getAttribute("windowtype");
    if (windowtype == "navigator:browser" && window.gBrowser) {
      // Enumerate tabs on firefox windows
      for (let tab of window.gBrowser.tabs) {
        let browser = tab.linkedBrowser;
        let location = browser.documentURI.spec;
        let mm = browser.messageManager;
        // To reload JSON-View tabs and any devtools document
        if (location.startsWith("about:debugging") ||
            location.startsWith("chrome://devtools/")) {
          browser.reload();
        }
        // We have to use a frame script to query "baseURI"
        mm.loadFrameScript("data:text/javascript,new " + function () {
          let isJSONView =
            content.document.baseURI.startsWith("resource://devtools/");
          if (isJSONView) {
            content.location.reload();
          }
        }, false);
      }
    } else if (windowtype === "devtools:webide") {
      window.location.reload();
    }
  }

  if (reloadToolbox) {
    // Reopen the toolbox automatically if we are reloading from toolbox
    // shortcut and are on a browser window.
    // Wait for a second before opening the toolbox to avoid races
    // between the old and the new one.
    let {setTimeout} = Cu.import("resource://gre/modules/Timer.jsm", {});
    setTimeout(() => {
      let { TargetFactory } = devtools.require("devtools/client/framework/target");
      let { gDevTools } = devtools.require("devtools/client/framework/devtools");
      let top = getTopLevelWindow(event.view);
      let target = TargetFactory.forTab(top.gBrowser.selectedTab);
      gDevTools.showToolbox(target);
    }, 1000);
  }

  // Browser console document can't just be reloaded.
  // HUDService is going to close it on unload.
  // Instead we have to manually toggle it.
  if (reopenBrowserConsole) {
    let HUDService = devtools.require("devtools/client/webconsole/hudservice");
    HUDService.toggleBrowserConsole();
  }

  actionOccurred("reloadAddonReload");
}

function startup(data) {
  dump("DevTools addon started.\n");

  resourceURI = data.resourceURI;

  listener = new MultiWindowKeyListener({
    keyCode: Ci.nsIDOMKeyEvent.DOM_VK_R, ctrlKey: true, altKey: true,
    callback: reload
  });
  listener.start();

  reload();
}
function shutdown(data, reason) {
  // On browser shutdown, do not try to cleanup anything
  if (reason == APP_SHUTDOWN) {
    return;
  }

  listener.stop();
  listener = null;

  unload("disable");
}
function install() {
  try {
    actionOccurred("reloadAddonInstalled");
  } catch (e) {
    // When installing on Firefox builds without devtools, telemetry doesn't
    // work yet and throws.
  }
}
function uninstall() {}
