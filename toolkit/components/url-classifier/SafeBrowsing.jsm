/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["SafeBrowsing"];

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;

Cu.import("resource://gre/modules/Services.jsm");

// Log only if browser.safebrowsing.debug is true
function log(...stuff) {
  let logging = Services.prefs.getBoolPref("browser.safebrowsing.debug", false);
  if (!logging) {
    return;
  }

  var d = new Date();
  let msg = "SafeBrowsing: " + d.toTimeString() + ": " + stuff.join(" ");
  dump(Services.urlFormatter.trimSensitiveURLs(msg) + "\n");
}

function getLists(prefName) {
  log("getLists: " + prefName);
  let pref = Services.prefs.getCharPref(prefName, "");

  // Splitting an empty string returns [''], we really want an empty array.
  if (!pref) {
    return [];
  }

  return pref.split(",").map(value => value.trim());
}

const tablePreferences = [
  "urlclassifier.phishTable",
  "urlclassifier.malwareTable",
  "urlclassifier.downloadBlockTable",
  "urlclassifier.downloadAllowTable",
  "urlclassifier.trackingTable",
  "urlclassifier.trackingWhitelistTable",
  "urlclassifier.blockedTable",
  "urlclassifier.flashAllowTable",
  "urlclassifier.flashAllowExceptTable",
  "urlclassifier.flashTable",
  "urlclassifier.flashExceptTable",
  "urlclassifier.flashSubDocTable",
  "urlclassifier.flashSubDocExceptTable",
  "urlclassifier.flashInfobarTable"
];

this.SafeBrowsing = {

  init: function() {
    if (this.initialized) {
      log("Already initialized");
      return;
    }

    Services.prefs.addObserver("browser.safebrowsing", this);
    Services.prefs.addObserver("privacy.trackingprotection", this);
    Services.prefs.addObserver("urlclassifier", this);
    Services.prefs.addObserver("plugins.flashBlock.enabled", this);

    this.readPrefs();
    this.addMozEntries();

    this.controlUpdateChecking();
    this.initialized = true;

    log("init() finished");
  },

  registerTableWithURLs: function(listname) {
    let listManager = Cc["@mozilla.org/url-classifier/listmanager;1"].
      getService(Ci.nsIUrlListManager);

    let providerName = this.listToProvider[listname];
    let provider = this.providers[providerName];

    if (!providerName || !provider) {
      log("No provider info found for " + listname);
      log("Check browser.safebrowsing.provider.[google/mozilla].lists");
      return;
    }

    if (!provider.updateURL) {
      log("Invalid update url " + listname);
      return;
    }

    listManager.registerTable(listname, providerName, provider.updateURL, provider.gethashURL);
  },

  registerTables: function() {
    for (let i = 0; i < this.phishingLists.length; ++i) {
      this.registerTableWithURLs(this.phishingLists[i]);
    }
    for (let i = 0; i < this.malwareLists.length; ++i) {
      this.registerTableWithURLs(this.malwareLists[i]);
    }
    for (let i = 0; i < this.downloadBlockLists.length; ++i) {
      this.registerTableWithURLs(this.downloadBlockLists[i]);
    }
    for (let i = 0; i < this.downloadAllowLists.length; ++i) {
      this.registerTableWithURLs(this.downloadAllowLists[i]);
    }
    for (let i = 0; i < this.trackingProtectionLists.length; ++i) {
      this.registerTableWithURLs(this.trackingProtectionLists[i]);
    }
    for (let i = 0; i < this.trackingProtectionWhitelists.length; ++i) {
      this.registerTableWithURLs(this.trackingProtectionWhitelists[i]);
    }
    for (let i = 0; i < this.blockedLists.length; ++i) {
      this.registerTableWithURLs(this.blockedLists[i]);
    }
    for (let i = 0; i < this.flashLists.length; ++i) {
      this.registerTableWithURLs(this.flashLists[i]);
    }
    for (let i = 0; i < this.flashInfobarLists.length; ++i) {
      this.registerTableWithURLs(this.flashInfobarLists[i]);
    }
  },


  initialized:          false,
  phishingEnabled:      false,
  malwareEnabled:       false,
  trackingEnabled:      false,
  blockedEnabled:       false,
  trackingAnnotations:  false,
  flashBlockEnabled:    false,
  flashInfobarListEnabled: true,

  phishingLists:                [],
  malwareLists:                 [],
  downloadBlockLists:           [],
  downloadAllowLists:           [],
  trackingProtectionLists:      [],
  trackingProtectionWhitelists: [],
  blockedLists:                 [],
  flashLists:                   [],
  flashInfobarLists:            [],

  updateURL:             null,
  gethashURL:            null,

  reportURL:             null,

  getReportURL: function(kind, info) {
    let pref;
    switch (kind) {
      case "Phish":
        pref = "browser.safebrowsing.reportPhishURL";
        break;

      case "PhishMistake":
      case "MalwareMistake":
        pref = "browser.safebrowsing.provider." + info.provider + ".report" + kind + "URL";
        break;

      default:
        let err = "SafeBrowsing getReportURL() called with unknown kind: " + kind;
        Components.utils.reportError(err);
        throw err;
    }

    // The "Phish" reports are about submitting new phishing URLs to Google so
    // they don't have an associated list URL
    if (kind != "Phish" && (!info.list || !info.uri)) {
      return null;
    }

    let reportUrl = Services.urlFormatter.formatURLPref(pref);
    // formatURLPref might return "about:blank" if getting the pref fails
    if (reportUrl == "about:blank") {
      reportUrl = null;
    }

    if (reportUrl) {
      reportUrl += encodeURIComponent(info.uri);
    }
    return reportUrl;
  },

  observe: function(aSubject, aTopic, aData) {
    // skip nextupdatetime and lastupdatetime
    if (aData.indexOf("lastupdatetime") >= 0 || aData.indexOf("nextupdatetime") >= 0) {
      return;
    }
    this.readPrefs();
  },

  readPrefs: function() {
    log("reading prefs");

    this.debug = Services.prefs.getBoolPref("browser.safebrowsing.debug");
    this.phishingEnabled = Services.prefs.getBoolPref("browser.safebrowsing.phishing.enabled");
    this.malwareEnabled = Services.prefs.getBoolPref("browser.safebrowsing.malware.enabled");
    this.trackingEnabled = Services.prefs.getBoolPref("privacy.trackingprotection.enabled") || Services.prefs.getBoolPref("privacy.trackingprotection.pbmode.enabled");
    this.blockedEnabled = Services.prefs.getBoolPref("browser.safebrowsing.blockedURIs.enabled");
    this.trackingAnnotations = Services.prefs.getBoolPref("privacy.trackingprotection.annotate_channels");
    this.flashBlockEnabled = Services.prefs.getBoolPref("plugins.flashBlock.enabled");

    let flashAllowTable, flashAllowExceptTable, flashTable,
        flashExceptTable, flashSubDocTable,
        flashSubDocExceptTable;

    [this.phishingLists,
     this.malwareLists,
     this.downloadBlockLists,
     this.downloadAllowLists,
     this.trackingProtectionLists,
     this.trackingProtectionWhitelists,
     this.blockedLists,
     flashAllowTable,
     flashAllowExceptTable,
     flashTable,
     flashExceptTable,
     flashSubDocTable,
     flashSubDocExceptTable,
     this.flashInfobarLists] = tablePreferences.map(getLists);

    this.flashLists = flashAllowTable.concat(flashAllowExceptTable,
                                             flashTable,
                                             flashExceptTable,
                                             flashSubDocTable,
                                             flashSubDocExceptTable)

    this.updateProviderURLs();
    this.registerTables();

    // XXX The listManager backend gets confused if this is called before the
    // lists are registered. So only call it here when a pref changes, and not
    // when doing initialization. I expect to refactor this later, so pardon the hack.
    if (this.initialized) {
      this.controlUpdateChecking();
    }
  },


  updateProviderURLs: function() {
    try {
      var clientID = Services.prefs.getCharPref("browser.safebrowsing.id");
    } catch(e) {
      clientID = Services.appinfo.name;
    }

    log("initializing safe browsing URLs, client id", clientID);

    // Get the different providers
    let branch = Services.prefs.getBranch("browser.safebrowsing.provider.");
    let children = branch.getChildList("", {});
    this.providers = {};
    this.listToProvider = {};

    for (let child of children) {
      log("Child: " + child);
      let prefComponents =  child.split(".");
      let providerName = prefComponents[0];
      this.providers[providerName] = {};
    }

    if (this.debug) {
      let providerStr = "";
      Object.keys(this.providers).forEach(function(provider) {
        if (providerStr === "") {
          providerStr = provider;
        } else {
          providerStr += ", " + provider;
        }
      });
      log("Providers: " + providerStr);
    }

    Object.keys(this.providers).forEach(function(provider) {
      let updateURL = Services.urlFormatter.formatURLPref(
        "browser.safebrowsing.provider." + provider + ".updateURL");
      let gethashURL = Services.urlFormatter.formatURLPref(
        "browser.safebrowsing.provider." + provider + ".gethashURL");
      updateURL = updateURL.replace("SAFEBROWSING_ID", clientID);
      gethashURL = gethashURL.replace("SAFEBROWSING_ID", clientID);

      // Disable updates and gethash if the Google API key is missing.
      let googleKey = Services.urlFormatter.formatURL("%GOOGLE_API_KEY%").trim();
      if ((provider == "google" || provider == "google4") &&
          (!googleKey || googleKey == "no-google-api-key")) {
        updateURL= "";
        gethashURL= "";
      }

      log("Provider: " + provider + " updateURL=" + updateURL);
      log("Provider: " + provider + " gethashURL=" + gethashURL);

      // Urls used to update DB
      this.providers[provider].updateURL  = updateURL;
      this.providers[provider].gethashURL = gethashURL;

      // Get lists this provider manages
      let lists = getLists("browser.safebrowsing.provider." + provider + ".lists");
      if (lists) {
        lists.forEach(function(list) {
          this.listToProvider[list] = provider;
        }, this);
      } else {
        log("Update URL given but no lists managed for provider: " + provider);
      }
    }, this);
  },

  controlUpdateChecking: function() {
    log("phishingEnabled:", this.phishingEnabled, "malwareEnabled:",
        this.malwareEnabled, "trackingEnabled:", this.trackingEnabled,
        "blockedEnabled:", this.blockedEnabled, "trackingAnnotations",
        this.trackingAnnotations, "flashBlockEnabled", this.flashBlockEnabled,
        "flashInfobarListEnabled:", this.flashInfobarListEnabled);

    let listManager = Cc["@mozilla.org/url-classifier/listmanager;1"].
                      getService(Ci.nsIUrlListManager);

    for (let i = 0; i < this.phishingLists.length; ++i) {
      if (this.phishingEnabled) {
        listManager.enableUpdate(this.phishingLists[i]);
      } else {
        listManager.disableUpdate(this.phishingLists[i]);
      }
    }
    for (let i = 0; i < this.malwareLists.length; ++i) {
      if (this.malwareEnabled) {
        listManager.enableUpdate(this.malwareLists[i]);
      } else {
        listManager.disableUpdate(this.malwareLists[i]);
      }
    }
    for (let i = 0; i < this.downloadBlockLists.length; ++i) {
      if (this.malwareEnabled) {
        listManager.enableUpdate(this.downloadBlockLists[i]);
      } else {
        listManager.disableUpdate(this.downloadBlockLists[i]);
      }
    }
    for (let i = 0; i < this.downloadAllowLists.length; ++i) {
      if (this.malwareEnabled) {
        listManager.enableUpdate(this.downloadAllowLists[i]);
      } else {
        listManager.disableUpdate(this.downloadAllowLists[i]);
      }
    }
    for (let i = 0; i < this.trackingProtectionLists.length; ++i) {
      if (this.trackingEnabled || this.trackingAnnotations) {
        listManager.enableUpdate(this.trackingProtectionLists[i]);
      } else {
        listManager.disableUpdate(this.trackingProtectionLists[i]);
      }
    }
    for (let i = 0; i < this.trackingProtectionWhitelists.length; ++i) {
      if (this.trackingEnabled || this.trackingAnnotations) {
        listManager.enableUpdate(this.trackingProtectionWhitelists[i]);
      } else {
        listManager.disableUpdate(this.trackingProtectionWhitelists[i]);
      }
    }
    for (let i = 0; i < this.blockedLists.length; ++i) {
      if (this.blockedEnabled) {
        listManager.enableUpdate(this.blockedLists[i]);
      } else {
        listManager.disableUpdate(this.blockedLists[i]);
      }
    }
    for (let i = 0; i < this.flashLists.length; ++i) {
      if (this.flashBlockEnabled) {
        listManager.enableUpdate(this.flashLists[i]);
      } else {
        listManager.disableUpdate(this.flashLists[i]);
      }
    }
    for (let i = 0; i < this.flashInfobarLists.length; ++i) {
      if (this.flashInfobarListEnabled) {
        listManager.enableUpdate(this.flashInfobarLists[i]);
      } else {
        listManager.disableUpdate(this.flashInfobarLists[i]);
      }
    }
    listManager.maybeToggleUpdateChecking();
  },


  addMozEntries: function() {
    // Add test entries to the DB.
    // XXX bug 779008 - this could be done by DB itself?
    const phishURL    = "itisatrap.org/firefox/its-a-trap.html";
    const malwareURL  = "itisatrap.org/firefox/its-an-attack.html";
    const unwantedURL = "itisatrap.org/firefox/unwanted.html";
    const trackerURLs = [
      "trackertest.org/",
      "itisatracker.org/",
    ];
    const whitelistURL  = "itisatrap.org/?resource=itisatracker.org";
    const blockedURL    = "itisatrap.org/firefox/blocked.html";

    const flashDenyURL = "flashblock.itisatrap.org/";
    const flashDenyExceptURL = "except.flashblock.itisatrap.org/";
    const flashAllowURL = "flashallow.itisatrap.org/";
    const flashAllowExceptURL = "except.flashallow.itisatrap.org/";
    const flashSubDocURL = "flashsubdoc.itisatrap.org/";
    const flashSubDocExceptURL = "except.flashsubdoc.itisatrap.org/";

    let update = "n:1000\ni:test-malware-simple\nad:1\n" +
                 "a:1:32:" + malwareURL.length + "\n" +
                 malwareURL + "\n";
    update += "n:1000\ni:test-phish-simple\nad:1\n" +
              "a:1:32:" + phishURL.length + "\n" +
              phishURL  + "\n";
    update += "n:1000\ni:test-unwanted-simple\nad:1\n" +
              "a:1:32:" + unwantedURL.length + "\n" +
              unwantedURL + "\n";
    update += "n:1000\ni:test-track-simple\n" +
              "ad:" + trackerURLs.length + "\n";
    trackerURLs.forEach((trackerURL, i) => {
      update += "a:" + (i + 1) + ":32:" + trackerURL.length + "\n" +
                trackerURL + "\n";
    });
    update += "n:1000\ni:test-trackwhite-simple\nad:1\n" +
              "a:1:32:" + whitelistURL.length + "\n" +
              whitelistURL;
    update += "n:1000\ni:test-block-simple\nad:1\n" +
              "a:1:32:" + blockedURL.length + "\n" +
              blockedURL;
    update += "n:1000\ni:test-flash-simple\nad:1\n" +
              "a:1:32:" + flashDenyURL.length + "\n" +
              flashDenyURL;
    update += "n:1000\ni:testexcept-flash-simple\nad:1\n" +
              "a:1:32:" + flashDenyExceptURL.length + "\n" +
              flashDenyExceptURL;
    update += "n:1000\ni:test-flashallow-simple\nad:1\n" +
              "a:1:32:" + flashAllowURL.length + "\n" +
              flashAllowURL;
    update += "n:1000\ni:testexcept-flashallow-simple\nad:1\n" +
              "a:1:32:" + flashAllowExceptURL.length + "\n" +
              flashAllowExceptURL;
    update += "n:1000\ni:test-flashsubdoc-simple\nad:1\n" +
              "a:1:32:" + flashSubDocURL.length + "\n" +
              flashSubDocURL;
    update += "n:1000\ni:testexcept-flashsubdoc-simple\nad:1\n" +
              "a:1:32:" + flashSubDocExceptURL.length + "\n" +
              flashSubDocExceptURL;
    log("addMozEntries:", update);

    let db = Cc["@mozilla.org/url-classifier/dbservice;1"].
             getService(Ci.nsIUrlClassifierDBService);

    // nsIUrlClassifierUpdateObserver
    let dummyListener = {
      updateUrlRequested: function() { },
      streamFinished:     function() { },
      // We notify observers when we're done in order to be able to make perf
      // test results more consistent
      updateError:        function() {
        Services.obs.notifyObservers(db, "mozentries-update-finished", "error");
      },
      updateSuccess:      function() {
        Services.obs.notifyObservers(db, "mozentries-update-finished", "success");
      }
    };

    try {
      let tables = "test-malware-simple,test-phish-simple,test-unwanted-simple,test-track-simple,test-trackwhite-simple,test-block-simple,test-flash-simple,testexcept-flash-simple,test-flashallow-simple,testexcept-flashallow-simple,test-flashsubdoc-simple,testexcept-flashsubdoc-simple";
      db.beginUpdate(dummyListener, tables, "");
      db.beginStream("", "");
      db.updateStream(update);
      db.finishStream();
      db.finishUpdate();
    } catch(ex) {
      // beginUpdate will throw harmlessly if there's an existing update in progress, ignore failures.
      log("addMozEntries failed!", ex);
      Services.obs.notifyObservers(db, "mozentries-update-finished", "exception");
    }
  },

  addMozEntriesFinishedPromise: new Promise(resolve => {
    let finished = (subject, topic, data) => {
      Services.obs.removeObserver(finished, "mozentries-update-finished");
      if (data == "error") {
        Cu.reportError("addMozEntries failed to update the db!");
      }
      resolve();
    };
    Services.obs.addObserver(finished, "mozentries-update-finished");
  }),
};
