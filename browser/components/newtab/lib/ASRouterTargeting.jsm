/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

const SEARCH_REGION_PREF = "browser.search.region";
const FXA_ENABLED_PREF = "identity.fxaccounts.enabled";
const DISTRIBUTION_ID_PREF = "distribution.id";
const DISTRIBUTION_ID_CHINA_REPACK = "MozillaOnline";

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  ASRouterPreferences: "resource://activity-stream/lib/ASRouterPreferences.jsm",
  AddonManager: "resource://gre/modules/AddonManager.jsm",
  ClientEnvironment: "resource://normandy/lib/ClientEnvironment.jsm",
  NewTabUtils: "resource://gre/modules/NewTabUtils.jsm",
  ProfileAge: "resource://gre/modules/ProfileAge.jsm",
  ShellService: "resource:///modules/ShellService.jsm",
  TelemetryEnvironment: "resource://gre/modules/TelemetryEnvironment.jsm",
  AppConstants: "resource://gre/modules/AppConstants.jsm",
  AttributionCode: "resource:///modules/AttributionCode.jsm",
  FilterExpressions:
    "resource://gre/modules/components-utils/FilterExpressions.jsm",
  fxAccounts: "resource://gre/modules/FxAccounts.jsm",
});

XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "cfrFeaturesUserPref",
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features",
  true
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "cfrAddonsUserPref",
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons",
  true
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "isWhatsNewPanelEnabled",
  "browser.messaging-system.whatsNewPanel.enabled",
  false
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "hasAccessedFxAPanel",
  "identity.fxaccounts.toolbar.accessed",
  false
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "clientsDevicesDesktop",
  "services.sync.clients.devices.desktop",
  0
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "clientsDevicesMobile",
  "services.sync.clients.devices.mobile",
  0
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "syncNumClients",
  "services.sync.numClients",
  0
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "devtoolsSelfXSSCount",
  "devtools.selfxss.count",
  0
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "browserSearchRegion",
  SEARCH_REGION_PREF,
  ""
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "isFxAEnabled",
  FXA_ENABLED_PREF,
  true
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "isXPIInstallEnabled",
  "xpinstall.enabled",
  true
);
XPCOMUtils.defineLazyPreferenceGetter(
  this,
  "snippetsUserPref",
  "browser.newtabpage.activity-stream.feeds.snippets",
  true
);
XPCOMUtils.defineLazyServiceGetter(
  this,
  "TrackingDBService",
  "@mozilla.org/tracking-db-service;1",
  "nsITrackingDBService"
);

const FXA_USERNAME_PREF = "services.sync.username";
const MOZ_JEXL_FILEPATH = "mozjexl";

const { activityStreamProvider: asProvider } = NewTabUtils;

const FXA_ATTACHED_CLIENTS_UPDATE_INTERVAL = 2 * 60 * 60 * 1000; // Two hours
const FRECENT_SITES_UPDATE_INTERVAL = 6 * 60 * 60 * 1000; // Six hours
const FRECENT_SITES_IGNORE_BLOCKED = false;
const FRECENT_SITES_NUM_ITEMS = 25;
const FRECENT_SITES_MIN_FRECENCY = 100;

const CACHE_EXPIRATION = 5 * 60 * 1000;
const jexlEvaluationCache = new Map();

/**
 * CachedTargetingGetter
 * @param property {string} Name of the method called on ActivityStreamProvider
 * @param options {{}?} Options object passsed to ActivityStreamProvider method
 * @param updateInterval {number?} Update interval for query. Defaults to FRECENT_SITES_UPDATE_INTERVAL
 */
function CachedTargetingGetter(
  property,
  options = null,
  updateInterval = FRECENT_SITES_UPDATE_INTERVAL
) {
  return {
    _lastUpdated: 0,
    _value: null,
    // For testing
    expire() {
      this._lastUpdated = 0;
      this._value = null;
    },
    async get() {
      const now = Date.now();
      if (now - this._lastUpdated >= updateInterval) {
        this._value = await asProvider[property](options);
        this._lastUpdated = now;
      }
      return this._value;
    },
  };
}

function CacheListAttachedOAuthClients() {
  return {
    _lastUpdated: 0,
    _value: null,
    expire() {
      this._lastUpdated = 0;
      this._value = null;
    },
    get() {
      const now = Date.now();
      if (now - this._lastUpdated >= FXA_ATTACHED_CLIENTS_UPDATE_INTERVAL) {
        this._value = new Promise(resolve => {
          fxAccounts
            .listAttachedOAuthClients()
            .then(clients => {
              resolve(clients);
            })
            .catch(() => resolve([]));
        });
        this._lastUpdated = now;
      }
      return this._value;
    },
  };
}

function CheckBrowserNeedsUpdate(
  updateInterval = FRECENT_SITES_UPDATE_INTERVAL
) {
  const UpdateChecker = Cc["@mozilla.org/updates/update-checker;1"];
  const checker = {
    _lastUpdated: 0,
    _value: null,
    // For testing. Avoid update check network call.
    setUp(value) {
      this._lastUpdated = Date.now();
      this._value = value;
    },
    expire() {
      this._lastUpdated = 0;
      this._value = null;
    },
    get() {
      return new Promise((resolve, reject) => {
        const now = Date.now();
        const updateServiceListener = {
          onCheckComplete(request, updates) {
            checker._value = !!updates.length;
            resolve(checker._value);
          },
          onError(request, update) {
            reject(request);
          },

          QueryInterface: ChromeUtils.generateQI(["nsIUpdateCheckListener"]),
        };

        if (UpdateChecker && now - this._lastUpdated >= updateInterval) {
          const checkerInstance = UpdateChecker.createInstance(
            Ci.nsIUpdateChecker
          );
          checkerInstance.checkForUpdates(updateServiceListener, true);
          this._lastUpdated = now;
        } else {
          resolve(this._value);
        }
      });
    },
  };

  return checker;
}

const QueryCache = {
  expireAll() {
    Object.keys(this.queries).forEach(query => {
      this.queries[query].expire();
    });
  },
  queries: {
    TopFrecentSites: new CachedTargetingGetter("getTopFrecentSites", {
      ignoreBlocked: FRECENT_SITES_IGNORE_BLOCKED,
      numItems: FRECENT_SITES_NUM_ITEMS,
      topsiteFrecency: FRECENT_SITES_MIN_FRECENCY,
      onePerDomain: true,
      includeFavicon: false,
    }),
    TotalBookmarksCount: new CachedTargetingGetter("getTotalBookmarksCount"),
    CheckBrowserNeedsUpdate: new CheckBrowserNeedsUpdate(),
    RecentBookmarks: new CachedTargetingGetter("getRecentBookmarks"),
    ListAttachedOAuthClients: new CacheListAttachedOAuthClients(),
  },
};

/**
 * sortMessagesByWeightedRank
 *
 * Each message has an associated weight, which is guaranteed to be strictly
 * positive. Sort the messages so that higher weighted messages are more likely
 * to come first.
 *
 * Specifically, sort them so that the probability of message x_1 with weight
 * w_1 appearing before message x_2 with weight w_2 is (w_1 / (w_1 + w_2)).
 *
 * This is equivalent to requiring that x_1 appearing before x_2 is (w_1 / w_2)
 * "times" as likely as x_2 appearing before x_1.
 *
 * See Bug 1484996, Comment 2 for a justification of the method.
 *
 * @param {Array} messages - A non-empty array of messages to sort, all with
 *                           strictly positive weights
 * @returns the sorted array
 */
function sortMessagesByWeightedRank(messages) {
  return messages
    .map(message => ({
      message,
      rank: Math.pow(Math.random(), 1 / message.weight),
    }))
    .sort((a, b) => b.rank - a.rank)
    .map(({ message }) => message);
}

/**
 * getSortedMessages - Given an array of Messages, applies sorting and filtering rules
 *                     in expected order.
 *
 * @param {Array<Message>} messages
 * @param {{}} options
 * @param {boolean} options.ordered - Should .order be used instead of random weighted sorting?
 * @returns {Array<Message>}
 */
function getSortedMessages(messages, options = {}) {
  let { ordered } = { ordered: false, ...options };
  let result = messages;
  let hasScores;

  if (!ordered) {
    result = sortMessagesByWeightedRank(result);
  }

  result.sort((a, b) => {
    // If we find at least one score, we need to apply filtering by threshold at the end.
    if (!isNaN(a.score) || !isNaN(b.score)) {
      hasScores = true;
    }

    // First sort by score if we're doing personalization:
    if (a.score > b.score || (!isNaN(a.score) && isNaN(b.score))) {
      return -1;
    }
    if (a.score < b.score || (isNaN(a.score) && !isNaN(b.score))) {
      return 1;
    }

    // Next, sort by priority
    if (a.priority > b.priority || (!isNaN(a.priority) && isNaN(b.priority))) {
      return -1;
    }
    if (a.priority < b.priority || (isNaN(a.priority) && !isNaN(b.priority))) {
      return 1;
    }

    // Sort messages with targeting expressions higher than those with none
    if (a.targeting && !b.targeting) {
      return -1;
    }
    if (!a.targeting && b.targeting) {
      return 1;
    }

    // Next, sort by order *ascending* if ordered = true
    if (ordered) {
      if (a.order > b.order || (!isNaN(a.order) && isNaN(b.order))) {
        return 1;
      }
      if (a.order < b.order || (isNaN(a.order) && !isNaN(b.order))) {
        return -1;
      }
    }

    return 0;
  });

  if (hasScores && !isNaN(ASRouterPreferences.personalizedCfrThreshold)) {
    return result.filter(
      message =>
        isNaN(message.score) ||
        message.score >= ASRouterPreferences.personalizedCfrThreshold
    );
  }

  return result;
}

const TargetingGetters = {
  get locale() {
    return Services.locale.appLocaleAsBCP47;
  },
  get localeLanguageCode() {
    return (
      Services.locale.appLocaleAsBCP47 &&
      Services.locale.appLocaleAsBCP47.substr(0, 2)
    );
  },
  get browserSettings() {
    const { settings } = TelemetryEnvironment.currentEnvironment;
    return {
      // This way of getting attribution is deprecated - use atttributionData instead
      attribution: settings.attribution,
      update: settings.update,
    };
  },
  get attributionData() {
    // Attribution is determined at startup - so we can use the cached attribution at this point
    return AttributionCode.getCachedAttributionData();
  },
  get currentDate() {
    return new Date();
  },
  get profileAgeCreated() {
    return ProfileAge().then(times => times.created);
  },
  get profileAgeReset() {
    return ProfileAge().then(times => times.reset);
  },
  get usesFirefoxSync() {
    return Services.prefs.prefHasUserValue(FXA_USERNAME_PREF);
  },
  get isFxAEnabled() {
    return isFxAEnabled;
  },
  get trailheadInterrupt() {
    return ASRouterPreferences.trailhead.trailheadInterrupt;
  },
  get trailheadTriplet() {
    return ASRouterPreferences.trailhead.trailheadTriplet;
  },
  get sync() {
    return {
      desktopDevices: clientsDevicesDesktop,
      mobileDevices: clientsDevicesMobile,
      totalDevices: syncNumClients,
    };
  },
  get xpinstallEnabled() {
    // This is needed for all add-on recommendations, to know if we allow xpi installs in the first place
    return isXPIInstallEnabled;
  },
  get addonsInfo() {
    return AddonManager.getActiveAddons(["extension", "service"]).then(
      ({ addons, fullData }) => {
        const info = {};
        for (const addon of addons) {
          info[addon.id] = {
            version: addon.version,
            type: addon.type,
            isSystem: addon.isSystem,
            isWebExtension: addon.isWebExtension,
          };
          if (fullData) {
            Object.assign(info[addon.id], {
              name: addon.name,
              userDisabled: addon.userDisabled,
              installDate: addon.installDate,
            });
          }
        }
        return { addons: info, isFullData: fullData };
      }
    );
  },
  get searchEngines() {
    return new Promise(resolve => {
      // Note: calling init ensures this code is only executed after Search has been initialized
      Services.search
        .getVisibleEngines()
        .then(engines => {
          resolve({
            current: Services.search.defaultEngine.identifier,
            installed: engines
              .map(engine => engine.identifier)
              .filter(engine => engine),
          });
        })
        .catch(() => resolve({ installed: [], current: "" }));
    });
  },
  get isDefaultBrowser() {
    try {
      return ShellService.isDefaultBrowser();
    } catch (e) {}
    return null;
  },
  get devToolsOpenedCount() {
    return devtoolsSelfXSSCount;
  },
  get topFrecentSites() {
    return QueryCache.queries.TopFrecentSites.get().then(sites =>
      sites.map(site => ({
        url: site.url,
        host: new URL(site.url).hostname,
        frecency: site.frecency,
        lastVisitDate: site.lastVisitDate,
      }))
    );
  },
  get recentBookmarks() {
    return QueryCache.queries.RecentBookmarks.get();
  },
  get pinnedSites() {
    return NewTabUtils.pinnedLinks.links.map(site =>
      site
        ? {
            url: site.url,
            host: new URL(site.url).hostname,
            searchTopSite: site.searchTopSite,
          }
        : {}
    );
  },
  get providerCohorts() {
    return ASRouterPreferences.providers.reduce((prev, current) => {
      prev[current.id] = current.cohort || "";
      return prev;
    }, {});
  },
  get totalBookmarksCount() {
    return QueryCache.queries.TotalBookmarksCount.get();
  },
  get firefoxVersion() {
    return parseInt(AppConstants.MOZ_APP_VERSION.match(/\d+/), 10);
  },
  get region() {
    return browserSearchRegion;
  },
  get needsUpdate() {
    return QueryCache.queries.CheckBrowserNeedsUpdate.get();
  },
  get hasPinnedTabs() {
    for (let win of Services.wm.getEnumerator("navigator:browser")) {
      if (win.closed || !win.ownerGlobal.gBrowser) {
        continue;
      }
      if (win.ownerGlobal.gBrowser.visibleTabs.filter(t => t.pinned).length) {
        return true;
      }
    }

    return false;
  },
  get hasAccessedFxAPanel() {
    return hasAccessedFxAPanel;
  },
  get isWhatsNewPanelEnabled() {
    return isWhatsNewPanelEnabled;
  },
  get userPrefs() {
    return {
      cfrFeatures: cfrFeaturesUserPref,
      cfrAddons: cfrAddonsUserPref,
      snippets: snippetsUserPref,
    };
  },
  get totalBlockedCount() {
    return TrackingDBService.sumAllEvents();
  },
  get blockedCountByType() {
    const idToTextMap = new Map([
      [Ci.nsITrackingDBService.TRACKERS_ID, "trackerCount"],
      [Ci.nsITrackingDBService.TRACKING_COOKIES_ID, "cookieCount"],
      [Ci.nsITrackingDBService.CRYPTOMINERS_ID, "cryptominerCount"],
      [Ci.nsITrackingDBService.FINGERPRINTERS_ID, "fingerprinterCount"],
      [Ci.nsITrackingDBService.SOCIAL_ID, "socialCount"],
    ]);

    const dateTo = new Date();
    const dateFrom = new Date(dateTo.getTime() - 42 * 24 * 60 * 60 * 1000);
    return TrackingDBService.getEventsByDateRange(dateFrom, dateTo).then(
      eventsByDate => {
        let totalEvents = {};
        for (let blockedType of idToTextMap.values()) {
          totalEvents[blockedType] = 0;
        }

        return eventsByDate.reduce((acc, day) => {
          const type = day.getResultByName("type");
          const count = day.getResultByName("count");
          acc[idToTextMap.get(type)] = acc[idToTextMap.get(type)] + count;
          return acc;
        }, totalEvents);
      }
    );
  },
  get attachedFxAOAuthClients() {
    return this.usesFirefoxSync
      ? QueryCache.queries.ListAttachedOAuthClients.get()
      : [];
  },
  get platformName() {
    return AppConstants.platform;
  },
  get scores() {
    return ASRouterPreferences.personalizedCfrScores;
  },
  get scoreThreshold() {
    return ASRouterPreferences.personalizedCfrThreshold;
  },
  get isChinaRepack() {
    return (
      Services.prefs
        .getDefaultBranch(null)
        .getCharPref(DISTRIBUTION_ID_PREF, "default") ===
      DISTRIBUTION_ID_CHINA_REPACK
    );
  },
  get userId() {
    return ClientEnvironment.userId;
  },
};

this.ASRouterTargeting = {
  Environment: TargetingGetters,

  ERROR_TYPES: {
    MALFORMED_EXPRESSION: "MALFORMED_EXPRESSION",
    ATTRIBUTE_ERROR: "JEXL_ATTRIBUTE_GETTER_ERROR",
    OTHER_ERROR: "OTHER_ERROR",
  },

  // Combines the getter properties of two objects without evaluating them
  combineContexts(contextA = {}, contextB = {}, onError) {
    return {
      get: (obj, prop) => {
        try {
          return contextA[prop] || contextB[prop];
        } catch (error) {
          onError(this.ERROR_TYPES.ATTRIBUTE_ERROR, error, prop);
        }

        return null;
      },
    };
  },

  isMatch(filterExpression, customContext, onError) {
    return FilterExpressions.eval(
      filterExpression,
      new Proxy(
        {},
        this.combineContexts(customContext, this.Environment, onError)
      )
    );
  },

  isTriggerMatch(trigger = {}, candidateMessageTrigger = {}) {
    if (trigger.id !== candidateMessageTrigger.id) {
      return false;
    } else if (
      !candidateMessageTrigger.params &&
      !candidateMessageTrigger.patterns
    ) {
      return true;
    }

    if (!trigger.param) {
      return false;
    }

    return (
      (candidateMessageTrigger.params &&
        trigger.param.host &&
        candidateMessageTrigger.params.includes(trigger.param.host)) ||
      (candidateMessageTrigger.params &&
        trigger.param.type &&
        candidateMessageTrigger.params.filter(
          t => (t & trigger.param.type) === t
        ).length) ||
      (candidateMessageTrigger.patterns &&
        trigger.param.url &&
        new MatchPatternSet(candidateMessageTrigger.patterns).matches(
          trigger.param.url
        ))
    );
  },

  /**
   * getCachedEvaluation - Return a cached jexl evaluation if available
   *
   * @param {string} targeting JEXL expression to lookup
   * @returns {obj|null} Object with value result or null if not available
   */
  getCachedEvaluation(targeting) {
    if (jexlEvaluationCache.has(targeting)) {
      const { timestamp, value } = jexlEvaluationCache.get(targeting);
      if (Date.now() - timestamp <= CACHE_EXPIRATION) {
        return { value };
      }
      jexlEvaluationCache.delete(targeting);
    }

    return null;
  },

  /**
   * checkMessageTargeting - Checks is a message's targeting parameters are satisfied
   *
   * @param {*} message An AS router message
   * @param {obj} context A FilterExpression context
   * @param {func} onError A function to handle errors (takes two params; error, message)
   * @param {boolean} shouldCache Should the JEXL evaluations be cached and reused.
   * @returns
   */
  async checkMessageTargeting(message, context, onError, shouldCache) {
    // If no targeting is specified,
    if (!message.targeting) {
      return true;
    }
    let result;
    try {
      if (shouldCache) {
        result = this.getCachedEvaluation(message.targeting);
        if (result) {
          return result.value;
        }
      }
      result = await this.isMatch(message.targeting, context, onError);
      if (shouldCache) {
        jexlEvaluationCache.set(message.targeting, {
          timestamp: Date.now(),
          value: result,
        });
      }
    } catch (error) {
      Cu.reportError(error);
      if (onError) {
        const type = error.fileName.includes(MOZ_JEXL_FILEPATH)
          ? this.ERROR_TYPES.MALFORMED_EXPRESSION
          : this.ERROR_TYPES.OTHER_ERROR;
        onError(type, error, message);
      }
      result = false;
    }
    return result;
  },

  _isMessageMatch(message, trigger, context, onError, shouldCache = false) {
    return (
      message &&
      (trigger
        ? this.isTriggerMatch(trigger, message.trigger)
        : !message.trigger) &&
      // If a trigger expression was passed to this function, the message should match it.
      // Otherwise, we should choose a message with no trigger property (i.e. a message that can show up at any time)
      this.checkMessageTargeting(message, context, onError, shouldCache)
    );
  },

  /**
   * findMatchingMessage - Given an array of messages, returns one message
   *                       whos targeting expression evaluates to true
   *
   * @param {Array<Message>} messages An array of AS router messages
   * @param {trigger} string A trigger expression if a message for that trigger is desired
   * @param {obj|null} context A FilterExpression context. Defaults to TargetingGetters above.
   * @param {func} onError A function to handle errors (takes two params; error, message)
   * @param {func} ordered An optional param when true sort message by order specified in message
   * @param {boolean} shouldCache Should the JEXL evaluations be cached and reused.
   * @param {boolean} returnAll Should we return all matching messages, not just the first one found.
   * @returns {obj|Array<Message>} If returnAll is false, a single message. If returnAll is true, an array of messages.
   */
  async findMatchingMessage({
    messages,
    trigger,
    context,
    onError,
    ordered = false,
    shouldCache = false,
    returnAll = false,
  }) {
    const sortedMessages = getSortedMessages(messages, { ordered });
    const combinedContext = new Proxy(
      {},
      this.combineContexts(trigger && trigger.context, context, onError)
    );
    const matching = returnAll ? [] : null;

    const isMatch = candidate =>
      this._isMessageMatch(
        candidate,
        trigger,
        combinedContext,
        onError,
        shouldCache
      );

    for (const candidate of sortedMessages) {
      if (await isMatch(candidate)) {
        // If not returnAll, we should return the first message we find that matches.
        if (!returnAll) {
          return candidate;
        }

        matching.push(candidate);
      }
    }
    return matching;
  },
};

// Export for testing
this.getSortedMessages = getSortedMessages;
this.QueryCache = QueryCache;
this.CachedTargetingGetter = CachedTargetingGetter;
this.EXPORTED_SYMBOLS = [
  "ASRouterTargeting",
  "QueryCache",
  "CachedTargetingGetter",
  "getSortedMessages",
];
