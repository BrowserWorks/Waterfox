/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["Services"];

const Ci = Components.interfaces;
const Cc = Components.classes;
const Cr = Components.results;

Components.utils.import("resource://gre/modules/AppConstants.jsm");
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

this.Services = {};

XPCOMUtils.defineLazyGetter(Services, "prefs", function() {
  return Cc["@mozilla.org/preferences-service;1"]
           .getService(Ci.nsIPrefService)
           .QueryInterface(Ci.nsIPrefBranch);
});

XPCOMUtils.defineLazyGetter(Services, "appinfo", function() {
  let appinfo = Cc["@mozilla.org/xre/app-info;1"]
                  .getService(Ci.nsIXULRuntime);
  try {
    appinfo.QueryInterface(Ci.nsIXULAppInfo);
  } catch (ex) {
    // Not all applications implement nsIXULAppInfo (e.g. xpcshell doesn't).
    if (!(ex instanceof Components.Exception) || ex.result != Cr.NS_NOINTERFACE) {
      throw ex;
    }
  }
  return appinfo;
});

XPCOMUtils.defineLazyGetter(Services, "dirsvc", function() {
  return Cc["@mozilla.org/file/directory_service;1"]
           .getService(Ci.nsIDirectoryService)
           .QueryInterface(Ci.nsIProperties);
});

if (AppConstants.MOZ_CRASHREPORTER) {
  XPCOMUtils.defineLazyGetter(Services, "crashmanager", () => {
    let ns = {};
    Components.utils.import("resource://gre/modules/CrashManager.jsm", ns);

    return ns.CrashManager.Singleton;
  });
}

XPCOMUtils.defineLazyGetter(Services, "mm", () => {
  return Cc["@mozilla.org/globalmessagemanager;1"]
           .getService(Ci.nsIMessageBroadcaster)
           .QueryInterface(Ci.nsIFrameScriptLoader);
});

XPCOMUtils.defineLazyGetter(Services, "ppmm", () => {
  return Cc["@mozilla.org/parentprocessmessagemanager;1"]
           .getService(Ci.nsIMessageBroadcaster)
           .QueryInterface(Ci.nsIProcessScriptLoader);
});

var initTable = [
  ["androidBridge", "@mozilla.org/android/bridge;1", "nsIAndroidBridge",
   AppConstants.platform == "android"],
  ["appShell", "@mozilla.org/appshell/appShellService;1", "nsIAppShellService"],
  ["cache", "@mozilla.org/network/cache-service;1", "nsICacheService"],
  ["cache2", "@mozilla.org/netwerk/cache-storage-service;1", "nsICacheStorageService"],
  ["cpmm", "@mozilla.org/childprocessmessagemanager;1", "nsIMessageSender"],
  ["console", "@mozilla.org/consoleservice;1", "nsIConsoleService"],
  ["contentPrefs", "@mozilla.org/content-pref/service;1", "nsIContentPrefService"],
  ["cookies", "@mozilla.org/cookiemanager;1", "nsICookieManager2"],
  ["downloads", "@mozilla.org/download-manager;1", "nsIDownloadManager"],
  ["droppedLinkHandler", "@mozilla.org/content/dropped-link-handler;1", "nsIDroppedLinkHandler"],
  ["els", "@mozilla.org/eventlistenerservice;1", "nsIEventListenerService"],
  ["eTLD", "@mozilla.org/network/effective-tld-service;1", "nsIEffectiveTLDService"],
  ["io", "@mozilla.org/network/io-service;1", "nsIIOService2"],
  ["intl", "@mozilla.org/mozintl;1", "mozIMozIntl"],
  ["locale", "@mozilla.org/intl/localeservice;1", "mozILocaleService"],
  ["logins", "@mozilla.org/login-manager;1", "nsILoginManager"],
  ["obs", "@mozilla.org/observer-service;1", "nsIObserverService"],
  ["perms", "@mozilla.org/permissionmanager;1", "nsIPermissionManager"],
  ["prompt", "@mozilla.org/embedcomp/prompt-service;1", "nsIPromptService"],
  ["profiler", "@mozilla.org/tools/profiler;1", "nsIProfiler",
   AppConstants.MOZ_GECKO_PROFILER],
  ["scriptloader", "@mozilla.org/moz/jssubscript-loader;1", "mozIJSSubScriptLoader"],
  ["scriptSecurityManager", "@mozilla.org/scriptsecuritymanager;1", "nsIScriptSecurityManager"],
  ["search", "@mozilla.org/browser/search-service;1", "nsIBrowserSearchService",
   AppConstants.MOZ_TOOLKIT_SEARCH],
  ["storage", "@mozilla.org/storage/service;1", "mozIStorageService"],
  ["domStorageManager", "@mozilla.org/dom/localStorage-manager;1", "nsIDOMStorageManager"],
  ["strings", "@mozilla.org/intl/stringbundle;1", "nsIStringBundleService"],
  ["telemetry", "@mozilla.org/base/telemetry;1", "nsITelemetry"],
  ["tm", "@mozilla.org/thread-manager;1", "nsIThreadManager"],
  ["urlFormatter", "@mozilla.org/toolkit/URLFormatterService;1", "nsIURLFormatter"],
  ["vc", "@mozilla.org/xpcom/version-comparator;1", "nsIVersionComparator"],
  ["wm", "@mozilla.org/appshell/window-mediator;1", "nsIWindowMediator"],
  ["ww", "@mozilla.org/embedcomp/window-watcher;1", "nsIWindowWatcher"],
  ["startup", "@mozilla.org/toolkit/app-startup;1", "nsIAppStartup"],
  ["sysinfo", "@mozilla.org/system-info;1", "nsIPropertyBag2"],
  ["clipboard", "@mozilla.org/widget/clipboard;1", "nsIClipboard"],
  ["DOMRequest", "@mozilla.org/dom/dom-request-service;1", "nsIDOMRequestService"],
  ["focus", "@mozilla.org/focus-manager;1", "nsIFocusManager"],
  ["uriFixup", "@mozilla.org/docshell/urifixup;1", "nsIURIFixup"],
  ["blocklist", "@mozilla.org/extensions/blocklist;1", "nsIBlocklistService"],
  ["netUtils", "@mozilla.org/network/util;1", "nsINetUtil"],
  ["loadContextInfo", "@mozilla.org/load-context-info-factory;1", "nsILoadContextInfoFactory"],
  ["qms", "@mozilla.org/dom/quota-manager-service;1", "nsIQuotaManagerService"],
];

initTable.forEach(([name, contract, intf, enabled = true]) => {
  if (enabled) {
    XPCOMUtils.defineLazyServiceGetter(Services, name, contract, intf);
  }
});


initTable = undefined;
