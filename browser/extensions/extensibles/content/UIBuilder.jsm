"use strict";

const EXPORTED_SYMBOLS = ["UIBuilder"];

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetters(this, {
  ChromeManifest: "resource:///modules/ChromeManifest.jsm",
  Overlays: "resource:///modules/OverlaysNew.jsm",
});

XPCOMUtils.defineLazyGlobalGetters(this, ["fetch"]);

const UIBuilder = {
  async init() {
    // Parse chrome.manifest
    this.startupManifest = await this.getChromeManifest("startup");

    // Observe chrome-document-loaded topic to detect window open
    Services.obs.addObserver(this, "chrome-document-loaded");
    // Observe main-pane-loaded topic to detect about:preferences open
    Services.obs.addObserver(this, "main-pane-loaded");
  },

  async getChromeManifest(manifest) {
    let uri;
    switch (manifest) {
      case "startup":
        uri = "resource://waterfox/overlays/chrome.manifest";
        break;
      case "preferences":
        uri = "resource://waterfox/overlays/preferences.manifest";
        break;
    }
    let chromeManifest = new ChromeManifest(async () => {
      let res = await fetch(uri);
      return res.text();
    }, this.options);
    await chromeManifest.parse();
    return chromeManifest;
  },

  options: {
    application: Services.appinfo.ID,
    appversion: Services.appinfo.version,
    platformversion: Services.appinfo.platformVersion,
    os: Services.appinfo.OS,
    osversion: Services.sysinfo.getProperty("version"),
    abi: Services.appinfo.XPCOMABI,
  },

  async observe(subject, topic, data) {
    switch (topic) {
      case "chrome-document-loaded":
        // Only load overlays in new browser windows
        // baseURI for about:blank is also browser.xhtml, so use URL
        if (subject.URL.includes("browser.xhtml")) {
          const window = subject.defaultView;
          Overlays.load(this.startupManifest, window);
        }
        break;
      case "main-pane-loaded":
        // subject is preferences page content window
        if (!subject.initialized) {
          await Overlays.load(
            await this.getChromeManifest("preferences"),
            subject
          );
          subject.initialized = true;
        }
        break;
    }
  },
};
