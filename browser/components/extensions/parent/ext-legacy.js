/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

ChromeUtils.defineModuleGetter(this, "ChromeManifest", "resource:///modules/ChromeManifest.jsm");
ChromeUtils.defineModuleGetter(this, "ExtensionSupport", "resource:///modules/ExtensionSupport.jsm");
ChromeUtils.defineModuleGetter(this, "Overlays", "resource:///modules/Overlays.jsm");
ChromeUtils.defineModuleGetter(this, "XPIInternal", "resource://gre/modules/addons/XPIProvider.jsm");

Cu.importGlobalProperties(["fetch"]);

var {ExtensionError} = ExtensionUtils;

this.legacy = class extends ExtensionAPI {
  async onManifestEntry(entryName) {
    if (this.extension.manifest.legacy) {
      await this.register();
    }
  }

  async register() {
    this.extension.legacyLoaded = true;

    let state = {
      id: this.extension.id,
      pendingOperation: null,
      version: this.extension.version,
    };
    if (ExtensionSupport.loadedLegacyExtensions.has(this.extension.id)) {
      state = ExtensionSupport.loadedLegacyExtensions.get(this.extension.id);
      let versionComparison = Services.vc.compare(this.extension.version, state.version);
      if (versionComparison > 0) {
        state.pendingOperation = "upgrade";
        ExtensionSupport.loadedLegacyExtensions.notifyObservers(state);
      } else if (versionComparison < 0) {
        state.pendingOperation = "downgrade";
        ExtensionSupport.loadedLegacyExtensions.notifyObservers(state);
      }
      console.log(`Legacy WebExtension ${this.extension.id} has already been loaded in this run, refusing to do so again. Please restart.`);
      return;
    }

    ExtensionSupport.loadedLegacyExtensions.set(this.extension.id, state);
    if (this.extension.startupReason == "ADDON_INSTALL") {
      // Usually, sideloaded extensions are disabled when they first appear,
      // but for MozMill to run calendar tests, we disable this.
      let scope = XPIInternal.XPIStates.findAddon(this.extension.id).location.scope;
      let autoDisableScopes = Services.prefs.getIntPref("extensions.autoDisableScopes");

      // If the extension was just installed from the distribution folder,
      // it's in the profile extensions folder. We don't want to disable it.
      let isDistroAddon = Services.prefs.getBoolPref(
        "extensions.installedDistroAddon." + this.extension.id, false
      );

      if (!isDistroAddon && (scope & autoDisableScopes)) {
        state.pendingOperation = "install";
        console.log(`Legacy WebExtension ${this.extension.id} loading for other reason than startup (${this.extension.startupReason}), refusing to load immediately.`);
        ExtensionSupport.loadedLegacyExtensions.notifyObservers(state);
        return;
      }
    }
    if (this.extension.startupReason == "ADDON_ENABLE") {
      state.pendingOperation = "enable";
      console.log(`Legacy WebExtension ${this.extension.id} loading for other reason than startup (${this.extension.startupReason}), refusing to load immediately.`);
      ExtensionSupport.loadedLegacyExtensions.notifyObservers(state);
      return;
    }

    let extensionRoot;
    if (this.extension.rootURI instanceof Ci.nsIJARURI) {
      extensionRoot = this.extension.rootURI.JARFile.QueryInterface(Ci.nsIFileURL).file;
      console.log("Loading packed extension from", extensionRoot.path);
    } else {
      extensionRoot = this.extension.rootURI.QueryInterface(Ci.nsIFileURL).file;
      console.log("Loading unpacked extension from", extensionRoot.path);
    }

    // Have Gecko do as much loading as is still possible
    try {
      Cc["@mozilla.org/component-manager-extra;1"]
         .getService(Ci.nsIComponentManagerExtra)
         .addLegacyExtensionManifestLocation(extensionRoot);
    } catch (e) {
      throw new ExtensionError(e.message, e.fileName, e.lineNumber);
    }

    // Load chrome.manifest
    let appinfo = Services.appinfo;
    let options = {
      application: appinfo.ID,
      appversion: appinfo.version,
      platformversion: appinfo.platformVersion,
      os: appinfo.OS,
      osversion: Services.sysinfo.getProperty("version"),
      abi: appinfo.XPCOMABI,
    };
    let loader = async (filename) => {
      let url = this.extension.getURL(filename);
      return fetch(url).then(response => response.text());
    };
    let chromeManifest = new ChromeManifest(loader, options);
    await chromeManifest.parse("chrome.manifest");

    // Load preference files
    console.log("Loading add-on preferences from ", extensionRoot.path);
    ExtensionSupport.loadAddonPrefs(extensionRoot);

    // Fire profile-after-change notifications, because we are past that event by now
    console.log("Firing profile-after-change listeners for", this.extension.id);
    let profileAfterChange = chromeManifest.category.get("profile-after-change");
    for (let contractid of profileAfterChange.values()) {
      let service = contractid.startsWith("service,");
      let instance;
      try {
        if (service) {
          instance = Cc[contractid.substr(8)].getService(Ci.nsIObserver);
        } else {
          instance = Cc[contractid].createInstance(Ci.nsIObserver);
        }

        instance.observe(null, "profile-after-change", null);
      } catch (e) {
        console.error("Error firing profile-after-change listener for", contractid);
      }
    }

    // Add overlays to all existing windows.
    let enumerator = Services.wm.getEnumerator("navigator:browser");
    if (enumerator.hasMoreElements() && enumerator.getNext().document.readyState == "complete") {
      getAllWindows().forEach(w => Overlays.load(chromeManifest, w));
    }

    // Listen for new windows to overlay.
    let documentObserver = {
      observe(document) {
        if (ExtensionCommon.instanceOf(document, "XULDocument")) {
          Overlays.load(chromeManifest, document.defaultView);
        }
      },
    };
    Services.obs.addObserver(documentObserver, "chrome-document-interactive");

    this.extension.callOnClose({
      close: () => {
        Services.obs.removeObserver(documentObserver, "chrome-document-interactive");
      },
    });
  }
};

function getAllWindows() {
  function getChildDocShells(parentDocShell) {
    let docShellEnum = parentDocShell.getDocShellEnumerator(
      Ci.nsIDocShellTreeItem.typeAll,
      Ci.nsIDocShell.ENUMERATE_FORWARDS
    );

    for (let docShell of docShellEnum) {
      docShell.QueryInterface(Ci.nsIInterfaceRequestor)
               .getInterface(Ci.nsIWebProgress);
      domWindows.push(docShell.domWindow);
    }
  }

  let domWindows = [];
  for (let win of Services.ww.getWindowEnumerator()) {
    let parentDocShell = win.QueryInterface(Ci.nsIInterfaceRequestor)
                             .getInterface(Ci.nsIWebNavigation)
                             .QueryInterface(Ci.nsIDocShell);
    getChildDocShells(parentDocShell);
  }
  return domWindows;
}
