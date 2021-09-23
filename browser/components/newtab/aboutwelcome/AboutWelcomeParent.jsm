/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const EXPORTED_SYMBOLS = ["AboutWelcomeParent"];
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  AddonManager: "resource://gre/modules/AddonManager.jsm",
  FxAccounts: "resource://gre/modules/FxAccounts.jsm",
  MigrationUtils: "resource:///modules/MigrationUtils.jsm",
  OS: "resource://gre/modules/osfile.jsm",
  SpecialMessageActions:
    "resource://messaging-system/lib/SpecialMessageActions.jsm",
  AboutWelcomeTelemetry:
    "resource://activity-stream/aboutwelcome/lib/AboutWelcomeTelemetry.jsm",
  SearchUtils: "resource://gre/modules/SearchUtils.jsm",
});

XPCOMUtils.defineLazyGetter(this, "log", () => {
  const { Logger } = ChromeUtils.import(
    "resource://messaging-system/lib/Logger.jsm"
  );
  return new Logger("AboutWelcomeParent");
});

XPCOMUtils.defineLazyGetter(
  this,
  "Telemetry",
  () => new AboutWelcomeTelemetry()
);

const DID_SEE_ABOUT_WELCOME_PREF = "trailhead.firstrun.didSeeAboutWelcome";
const AWTerminate = {
  UNKNOWN: "unknown",
  WINDOW_CLOSED: "welcome-window-closed",
  TAB_CLOSED: "welcome-tab-closed",
  APP_SHUT_DOWN: "app-shut-down",
  ADDRESS_BAR_NAVIGATED: "address-bar-navigated",
};
const LIGHT_WEIGHT_THEMES = {
  AUTOMATIC: "default-theme@mozilla.org",
  ABYSS: "abyss@waterfox.net",
  FLOE: "floe@waterfox.net",
};

async function getImportableSites() {
  const sites = [];

  // Just handle these chromium-based browsers for now
  for (const browserId of ["chrome", "chromium-edge", "chromium"]) {
    // Skip if there's no profile data.
    const migrator = await MigrationUtils.getMigrator(browserId);
    if (!migrator) {
      continue;
    }

    // Check each profile for top sites
    const dataPath = await migrator.wrappedJSObject._getChromeUserDataPathIfExists();
    for (const profile of await migrator.getSourceProfiles()) {
      let path = OS.Path.join(dataPath, profile.id, "Top Sites");
      // Skip if top sites data is missing
      if (!(await OS.File.exists(path))) {
        Cu.reportError(`Missing file at ${path}`);
        continue;
      }

      try {
        for (const row of await MigrationUtils.getRowsFromDBWithoutLocks(
          path,
          `Importable ${browserId} top sites`,
          `SELECT url
           FROM top_sites
           ORDER BY url_rank`
        )) {
          sites.push(row.getString(0));
        }
      } catch (ex) {
        Cu.reportError(
          `Failed to get importable top sites from ${browserId} ${ex}`
        );
      }
    }
  }
  return sites;
}

const DEFAULT_SEARCH_ENGINES = {
  BING: "Bing",
  STARTPAGE: "Startpage",
};

async function setThemeAuto(value) {
  Services.prefs.setBoolPref("browser.theme.auto", value);
  return;
}

async function setDefaultEngine(engine_name) {
  try {
    let engine = Services.search.getEngineByName(engine_name);
    Services.prefs.setCharPref("distribution.engine", engine_name);
    Services.search.setDefault(engine);
    Services.search.setDefaultPrivate(engine);
    if (engine_name == "Startpage") {
      engine = engine.wrappedJSObject;
      // Store original startpage segment
      Services.prefs.setCharPref(
        "distribution.startpage.segment",
        engine._urls[0].params[1].value
      );
      // Set the startpage defaults
      const mainURL = "https://www.startpage.com/do/search?q={searchTerms}";
      const segment = "startpage.waterfox.default";
      engine.__searchForm = mainURL + `&segment=${segment}`;
      engine._urls[0].params[1] = {
        name: "segment",
        value: segment,
        purpose: undefined,
      };
      // Update engine
      SearchUtils.notifyAction(engine, SearchUtils.MODIFIED_TYPE.CHANGED);
    } else {
      // Reset Startpage defaults
      const segment = Services.prefs.getCharPref(
        "distribution.startpage.segment",
        ""
      );
      // If no segment, Startpage hasn't been set as default through welcome flow
      if (segment) {
        engine = Services.search.getEngineByName("Startpage").wrappedJSObject;
        const mainURL = "https://www.startpage.com/";
        engine.__searchForm = mainURL;
        engine._urls[0].params[1] = {
          name: "segment",
          value: segment,
          purpose: undefined,
        };
        // Update engine
        SearchUtils.notifyAction(engine, SearchUtils.MODIFIED_TYPE.CHANGED);
        Services.prefs.clearUserPref("distribution.startpage.segment");
      }
    }
  } catch (e) {
    Cu.reportError(e);
  }
}

class AboutWelcomeObserver {
  constructor() {
    Services.obs.addObserver(this, "quit-application");

    this.win = Services.focus.activeWindow;
    if (!this.win) {
      return;
    }

    this.terminateReason = AWTerminate.UNKNOWN;

    this.onWindowClose = () => {
      this.terminateReason = AWTerminate.WINDOW_CLOSED;
    };

    this.onTabClose = () => {
      this.terminateReason = AWTerminate.TAB_CLOSED;
    };

    this.win.addEventListener("TabClose", this.onTabClose, { once: true });
    this.win.addEventListener("unload", this.onWindowClose, { once: true });
  }

  observe(aSubject, aTopic, aData) {
    switch (aTopic) {
      case "quit-application":
        this.terminateReason = AWTerminate.APP_SHUT_DOWN;
        break;
    }
  }

  // Added for testing
  get AWTerminate() {
    return AWTerminate;
  }

  stop() {
    log.debug(`Terminate reason is ${this.terminateReason}`);
    Services.obs.removeObserver(this, "quit-application");
    if (!this.win) {
      return;
    }
    this.win.removeEventListener("TabClose", this.onTabClose);
    this.win.removeEventListener("unload", this.onWindowClose);
    this.win = null;
  }
}

class AboutWelcomeParent extends JSWindowActorParent {
  constructor() {
    super();
    this.AboutWelcomeObserver = new AboutWelcomeObserver(this);
  }

  didDestroy() {
    if (this.AboutWelcomeObserver) {
      this.AboutWelcomeObserver.stop();
    }

    Telemetry.sendTelemetry({
      event: "SESSION_END",
      event_context: {
        reason: this.AboutWelcomeObserver.terminateReason,
        page: "about:welcome",
      },
      message_id: this.AWMessageId,
      id: "ABOUT_WELCOME",
    });
  }

  /**
   * Handle messages from AboutWelcomeChild.jsm
   *
   * @param {string} type
   * @param {any=} data
   * @param {Browser} browser
   * @param {Window} window
   */
  onContentMessage(type, data, browser, window) {
    log.debug(`Received content event: ${type}`);
    switch (type) {
      case "AWPage:SET_WELCOME_MESSAGE_SEEN":
        this.AWMessageId = data;
        try {
          Services.prefs.setBoolPref(DID_SEE_ABOUT_WELCOME_PREF, true);
        } catch (e) {
          log.debug(`Fails to set ${DID_SEE_ABOUT_WELCOME_PREF}.`);
        }
        break;
      case "AWPage:SPECIAL_ACTION":
        SpecialMessageActions.handleAction(data, browser);
        break;
      case "AWPage:FXA_METRICS_FLOW_URI":
        return FxAccounts.config.promiseMetricsFlowURI("aboutwelcome");
      case "AWPage:IMPORTABLE_SITES":
        return getImportableSites();
      case "AWPage:TELEMETRY_EVENT":
        Telemetry.sendTelemetry(data);
        break;
      case "AWPage:LOCATION_CHANGED":
        this.AboutWelcomeObserver.terminateReason =
          AWTerminate.ADDRESS_BAR_NAVIGATED;
        break;
      case "AWPage:SELECT_THEME":
        return AddonManager.getAddonByID(
          LIGHT_WEIGHT_THEMES[data]
        ).then(addon => addon.enable());
      case "AWPage:WAIT_FOR_MIGRATION_CLOSE":
        return new Promise(resolve =>
          Services.ww.registerNotification(function observer(subject, topic) {
            if (
              topic === "domwindowclosed" &&
              subject.document.documentURI ===
                "chrome://browser/content/migration/migration.xhtml"
            ) {
              Services.ww.unregisterNotification(observer);
              resolve();
            }
          })
        );
      case "AWPage:SET_THEME_AUTO":
        return setThemeAuto(data);
      case "AWPage:SELECT_SEARCH_ENGINE":
        return setDefaultEngine(DEFAULT_SEARCH_ENGINES[data]);
      default:
        log.debug(`Unexpected event ${type} was not handled.`);
    }

    return undefined;
  }

  /**
   * @param {{name: string, data?: any}} message
   * @override
   */
  receiveMessage(message) {
    const { name, data } = message;
    let browser;
    let window;

    if (this.manager.rootFrameLoader) {
      browser = this.manager.rootFrameLoader.ownerElement;
      window = browser.ownerGlobal;
      return this.onContentMessage(name, data, browser, window);
    }

    log.warn(`Not handling ${name} because the browser doesn't exist.`);
    return null;
  }
}
