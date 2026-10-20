/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { SuggestBackend } from "moz-src:///browser/components/urlbar/private/SuggestFeature.sys.mjs";
import { XPCOMUtils } from "resource://gre/modules/XPCOMUtils.sys.mjs";
import { AppConstants } from "resource://gre/modules/AppConstants.sys.mjs";

const lazy = {};

ChromeUtils.defineESModuleGetters(lazy, {
  AsyncShutdown: "resource://gre/modules/AsyncShutdown.sys.mjs",
  InterruptKind:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  ObjectUtils: "resource://gre/modules/ObjectUtils.sys.mjs",
  QuickSuggest: "moz-src:///browser/components/urlbar/QuickSuggest.sys.mjs",
  SharedRemoteSettingsService:
    "resource://gre/modules/RustSharedRemoteSettingsService.sys.mjs",
  SuggestIngestionConstraints:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  SuggestStoreBuilder:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  Suggestion:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  SuggestionProvider:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  SuggestionProviderConstraints:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  SuggestionQuery:
    "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs",
  TaskQueue: "moz-src:///browser/components/urlbar/UrlbarUtils.sys.mjs",
  UrlbarPrefs: "moz-src:///browser/components/urlbar/UrlbarPrefs.sys.mjs",
  Utils: "resource://services-settings/Utils.sys.mjs",
});

/**
 * @import {SuggestProvider} from "moz-src:///browser/components/urlbar/private/SuggestFeature.sys.mjs"
 * @import {
 *   GeonameAlternates, Geoname, GeonameMatch, GeonameType, Suggestion
 * } from "moz-src:///toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs"
 */

XPCOMUtils.defineLazyServiceGetter(
  lazy,
  "timerManager",
  "@mozilla.org/updates/timer-manager;1",
  Ci.nsIUpdateTimerManager
);

const SUGGEST_DATA_STORE_BASENAME = "suggest.sqlite";

// This ID is used to register our ingest timer with nsIUpdateTimerManager.
const INGEST_TIMER_ID = "suggest-ingest";
const INGEST_TIMER_LAST_UPDATE_PREF = `app.update.lastUpdateTime.${INGEST_TIMER_ID}`;

// Maps from `suggestion.constructor` to the corresponding name of the
// suggestion type. See `getSuggestionType()` for details.
const gSuggestionTypesByCtor = new WeakMap();

/**
 * The Suggest Rust backend. Not used when the remote settings JS backend is
 * enabled.
 *
 * This class returns suggestions served by the Rust component. These are the
 * primary related architectural pieces (see bug 1851256 for details):
 *
 * (1) The `suggest` Rust component, which lives in the application-services
 *     repo [1] and is periodically vendored into mozilla-central [2] and then
 *     built into the Firefox binary.
 * (2) `suggest.udl`, which is part of the Rust component's source files and
 *     defines the interface exposed to foreign-function callers like JS [3, 4].
 * (3) `RustSuggest.sys.mjs` [5], which contains the JS bindings generated from
 *     `suggest.udl` by UniFFI. The classes defined in `RustSuggest.sys.mjs` are
 *     what we consume here in this file. If you have a question about the JS
 *     interface to the Rust component, try checking `RustSuggest.sys.mjs`, but
 *     as you get accustomed to UniFFI JS conventions you may find it simpler to
 *     refer directly to `suggest.udl`.
 * (4) `config.toml` [6], which defines which functions in the JS bindings are
 *     sync and which are async. Functions default to the "worker" thread, which
 *     means they are async. Some functions are "main", which means they are
 *     sync. Async functions return promises. This information is reflected in
 *     `RustSuggest.sys.mjs` of course: If a function is "worker", its JS
 *     binding will return a promise, and if it's "main" it won't.
 *
 * [1] https://github.com/mozilla/application-services/tree/main/components/suggest
 * [2] https://searchfox.org/firefox-main/source/third_party/rust/suggest
 * [3] https://github.com/mozilla/application-services/blob/main/components/suggest/src/suggest.udl
 * [4] https://searchfox.org/firefox-main/source/third_party/rust/suggest/src/suggest.udl
 * [5] https://searchfox.org/firefox-main/source/toolkit/components/uniffi-bindgen-gecko-js/components/generated/RustSuggest.sys.mjs
 * [6] https://searchfox.org/firefox-main/source/toolkit/components/uniffi-bindgen-gecko-js/config.toml
 */
export class SuggestBackendRust extends SuggestBackend {
  constructor() {
    super();
    this.#ingestQueue = new lazy.TaskQueue();

    // The remote settings server URL returned by `Utils.SERVER_URL` comes from
    // the `services.settings.server` pref. The xpcshell and browser test
    // harnesses set this pref to `"data:,#remote-settings-dummy/v1"` so that
    // browser features that use RS and remain enabled during tests don't hit
    // the real server. Suggest tests use a mock RS server and set this pref to
    // that server's URL, but during other tests the pref remains the dummy URL.
    // During those other tests, Suggest remains enabled, which means if we
    // initialize the Suggest store with the dummy URL, the Rust Suggest and RS
    // components will attempt to use it (when the store is initialized and on
    // initial ingest). Unfortunately the Rust RS component logs an error each
    // time it tries to manipulate the dummy URL because it's a `data` URI,
    // which is a "cannot-be-a-base" URL. The error is harmless, but it can be
    // logged many times during a test suite.
    //
    // To prevent Suggest from using the dummy URL, we skip setting the
    // remoteSettingsService, which prevents the Suggest store from being
    // created, effectively disabling Rust suggestions. Suggest tests manually
    // set the RS config when they set up the mock RS server, so they'll work
    // fine. Alternatively the test harnesses could disable Suggest by default
    // just like they set the server pref to the dummy URL, but Suggest is more
    // than Rust suggestions.
    if (!lazy.Utils.shouldSkipRemoteActivity) {
      this.#remoteSettingsService =
        lazy.SharedRemoteSettingsService.rustService();
    }
  }

  get enablingPreferences() {
    // This backend is *not* gated on `suggest.quicksuggest.all` because we want
    // features to be able to use the offline Suggest platform (i.e., the Rust
    // component) even when they aren't considered part of the Firefox Suggest
    // brand.
    return ["quicksuggest.rustEnabled"];
  }

  /**
   * @returns {object}
   *   The global Suggest config from the Rust component as returned from
   *   `SuggestStore.fetchGlobalConfig()`.
   */
  get config() {
    return this.#config || {};
  }

  /**
   * @returns {Promise}
   *   Resolved when all pending ingests are done.
   */
  get ingestPromise() {
    return this.#ingestQueue.emptyPromise;
  }

  enable(enabled) {
    if (enabled) {
      this.#init();
    } else {
      this.#uninit();
    }
  }

  /**
   * Queries the Rust component and returns all matching suggestions.
   *
   * @param {string} searchString
   *   The search string.
   * @param {object} [options]
   *   Options object.
   * @param {UrlbarQueryContext} [options._queryContext]
   *   The query context.
   * @param {?Array} [options.types]
   *   This is only intended to be used in special circumstances and normally
   *   should not be specified. Array of suggestion types to query. By default
   *   all enabled suggestion types are queried.
   * @returns {Promise<Array>}
   *   Matching Rust suggestions.
   */
  async query(searchString, { _queryContext, types = null } = {}) {
    if (!this.#store) {
      return [];
    }

    this.logger.debug("Handling query", { searchString });

    // Build a list of Rust providers to query and an object containing Rust
    // provider constraints for all queried providers.
    let uniqueProviders = new Set();
    let allProviderConstraints = {};
    let typeItems = types
      ? types.map(type => ({ type }))
      : this.#enabledSuggestionTypes;
    for (let { feature, type, provider } of typeItems) {
      if (!provider) {
        provider = this.#providerFromSuggestionType(type);
        if (!provider) {
          throw new Error("Unknown Rust suggestion type: " + type);
        }
      }
      this.logger.debug("Adding type to query", { type, provider });
      uniqueProviders.add(provider);
      if (feature) {
        allProviderConstraints = SuggestBackendRust.mergeProviderConstraints(
          allProviderConstraints,
          feature.rustProviderConstraints
        );
      }
    }

    // Do the query.
    const { suggestions, queryTimes } = await this.#store.queryWithMetrics(
      new lazy.SuggestionQuery({
        providers: [...uniqueProviders],
        keyword: searchString,
        providerConstraints: new lazy.SuggestionProviderConstraints(
          allProviderConstraints
        ),
      })
    );

    // Update query telemetry.
    for (let { label, value } of queryTimes) {
      Glean.suggest.queryTime[label].accumulateSingleSample(value);
    }

    // Build the list of suggestions to return.
    let liftedSuggestions = [];
    for (let s of suggestions) {
      let type = getSuggestionType(s);
      if (!type) {
        continue;
      }

      let suggestion = liftSuggestion(s);
      if (!suggestion) {
        continue;
      }

      // Set `suggestion.source` and `provider`, which `QuickSuggest` uses to
      // look up the feature that manages the suggestion.
      suggestion.source = "rust";
      suggestion.provider = type;

      if (suggestion.icon) {
        suggestion.icon_blob = new Blob([suggestion.icon], {
          type: suggestion.iconMimetype ?? "",
        });
        delete suggestion.icon;
        delete suggestion.iconMimetype;
      }

      liftedSuggestions.push(suggestion);
    }

    this.logger.debug("Got suggestions", liftedSuggestions);

    return liftedSuggestions;
  }

  cancelQuery() {
    this.#store?.interrupt(lazy.InterruptKind.READ);
  }

  /**
   * Returns suggestion-type-specific configuration data set by the Rust
   * backend.
   *
   * @param {string} type
   *   A suggestion type name as defined in Rust, e.g., "Amp", "Wikipedia",
   *   "Mdn", etc.
   * @returns {object} config
   *   The config data for the type.
   */
  getConfigForSuggestionType(type) {
    return this.#configsBySuggestionType.get(type);
  }

  /**
   * Ingests a feature's enabled suggestion types and updates staleness
   * bookkeeping. By default only stale suggestion types are ingested. A
   * suggestion type is stale if (a) it hasn't been ingested during this app
   * session or (b) the last time this method was called the suggestion type or
   * its feature was disabled.
   *
   * @param {SuggestProvider} feature
   *   A feature that manages Rust suggestion types.
   * @param {object} [options]
   *   Options object.
   * @param {boolean} [options.evenIfFresh]
   *   Set to true to force ingest for all the feature's suggestion types, even
   *   ones that aren't stale.
   */
  ingestEnabledSuggestions(feature, { evenIfFresh = false } = {}) {
    let type = feature.rustSuggestionType;
    if (!type) {
      return;
    }

    if (!this.isEnabled || !feature.isEnabled) {
      // Mark this type as stale so we'll ingest next time this method is
      // called.
      this.#providerConstraintsOnLastIngestByFeature.delete(feature);
    } else {
      let providerConstraints = feature.rustProviderConstraints;
      if (
        evenIfFresh ||
        !this.#providerConstraintsOnLastIngestByFeature.has(feature) ||
        !lazy.ObjectUtils.deepEqual(
          providerConstraints,
          this.#providerConstraintsOnLastIngestByFeature.get(feature)
        )
      ) {
        this.#providerConstraintsOnLastIngestByFeature.set(
          feature,
          providerConstraints
        );
        this.#ingestSuggestionType({ type, providerConstraints });
      }
    }
  }

  /**
   * Registers a dismissal for a Rust suggestion.
   *
   * @param {Suggestion} suggestion
   *   The suggestion to dismiss, an instance of one of the `Suggestion`
   *   subclasses exposed over FFI, e.g., `Suggestion.Wikipedia`. Typically the
   *   suggestion will have been returned from the Rust component, but tests may
   *   find it useful to make a `Suggestion` object directly.
   */
  async dismissRustSuggestion(suggestion) {
    let lowered = lowerSuggestion(suggestion);
    try {
      await this.#store?.dismissBySuggestion(lowered);
    } catch (error) {
      this.logger.error("Error: dismissRustSuggestion", { error, suggestion });
    }
  }

  /**
   * Registers a dismissal using a dismissal key. If you have a suggestion
   * object returned from the Rust component, use `dismissRustSuggestion()`
   * instead. This method can be used to record dismissals for suggestions from
   * other backends, like Merino.
   *
   * @param {string} dismissalKey
   *   The dismissal key.
   */
  async dismissByKey(dismissalKey) {
    try {
      await this.#store?.dismissByKey(dismissalKey);
    } catch (error) {
      this.logger.error("Error: dismissByKey", { error, dismissalKey });
    }
  }

  /**
   * Returns whether a dismissal is recorded for a Rust suggestion.
   *
   * @param {Suggestion} suggestion
   *   The suggestion to dismiss, an instance of one of the `Suggestion`
   *   subclasses exposed over FFI, e.g., `Suggestion.Wikipedia`. Typically the
   *   suggestion will have been returned from the Rust component, but tests may
   *   find it useful to make a `Suggestion` object directly.
   * @returns {Promise<boolean>}
   *   Whether the suggestion has been dismissed.
   */
  async isRustSuggestionDismissed(suggestion) {
    let lowered = lowerSuggestion(suggestion);
    try {
      return await this.#store?.isDismissedBySuggestion(lowered);
    } catch (error) {
      this.logger.error("Error: isDismissedBySuggestion", {
        error,
        suggestion,
      });
    }
    return false;
  }

  /**
   * Returns whether a dismissal is recorded for a dismissal key. If you have a
   * suggestion object returned from the Rust component, use
   * `isRustSuggestionDismissed()` instead. This method can be used to determine
   * whether suggestions from other backends, like Merino, have been dismissed.
   *
   * @param {string} dismissalKey
   *   The dismissal key.
   * @returns {Promise<boolean>}
   *   Whether a dismissal is recorded for the key.
   */
  async isDismissedByKey(dismissalKey) {
    try {
      return await this.#store?.isDismissedByKey(dismissalKey);
    } catch (error) {
      this.logger.error("Error: isDismissedByKey", { error, dismissalKey });
    }
    return false;
  }

  /**
   * Returns whether any dismissals are recorded.
   *
   * @returns {Promise<boolean>}
   *   Whether any suggestions have been dismissed.
   */
  async anyDismissedSuggestions() {
    try {
      return await this.#store?.anyDismissedSuggestions();
    } catch (error) {
      this.logger.error("Error: anyDismissedSuggestions", error);
    }
    // Return true because there may be dismissed suggestions, we don't know.
    return true;
  }

  /**
   * Removes all registered dismissals.
   */
  async clearDismissedSuggestions() {
    try {
      await this.#store?.clearDismissedSuggestions();
    } catch (error) {
      this.logger.error("Error clearing dismissed suggestions", error);
    }
  }

  /**
   * Fetches geonames stored in the Suggest database. A geoname represents a
   * geographic place.
   *
   * See `SuggestStore::fetch_geonames()` in the Rust component for full
   * documentation.
   *
   * @param {string} searchString
   *   The string to match against geonames.
   * @param {boolean} matchNamePrefix
   *   Whether prefix matching is performed on names excluding abbreviations and
   *   airport codes.
   * @param {GeonameType} geonameType
   *   Restricts returned geonames to a type.
   * @param {Array} filter
   *   Restricts returned geonames to certain cities or regions. Optional.
   * @returns {Promise<GeonameMatch[]>}
   *   Array of `GeonameMatch` objects. An empty array if there are no matches.
   */
  async fetchGeonames(searchString, matchNamePrefix, geonameType, filter) {
    if (!this.#store) {
      return [];
    }
    let geonames = await this.#store.fetchGeonames(
      searchString,
      matchNamePrefix,
      geonameType,
      filter
    );
    return geonames;
  }

  /**
   * Fetches geonames alternate names stored in the Suggest database. A single
   * geoname can have many alternate names since a place can have many different
   * variations of its name. Alternate names also include translations of names
   * into different languages.
   *
   * See `SuggestStore::fetch_geoname_alternates()` in the Rust component for
   * full documentation.
   *
   * @param {Geoname} geoname
   *   A `Geoname` object returned from `fetchGeonames()`.
   * @returns {Promise<GeonameAlternates>}
   *   A `GeonameAlternates` object containing the alternates for the geoname,
   *   its administrative divisions, and its country. See the Rust component for
   *   details.
   */
  async fetchGeonameAlternates(geoname) {
    let alts = await this.#store?.fetchGeonameAlternates(geoname);
    return alts;
  }

  /**
   * nsITimerCallback
   */
  notify() {
    this.logger.info("Ingest timer fired");
    this.#ingestAll();
  }

  /**
   * Merges two Rust provider constraints and returns a new object. The
   * constraints should be plain JS objects appropriate for passing to the
   * `SuggestionProviderConstraints` constructor.
   *
   * TODO: This should be a function in the Rust component.
   *
   * @param {object} a
   *   The first constraints object.
   * @param {object} b
   *   The second constraints object.
   * @returns {object}
   *   A plain JS object resulting from merging `a` and `b`.
   */
  static mergeProviderConstraints(a, b) {
    if (!a || !b) {
      return a ?? b;
    }

    let merged = { ...a, ...b };

    // Merge the `dynamicSuggestionTypes` arrays.
    if (
      a.hasOwnProperty("dynamicSuggestionTypes") ||
      b.hasOwnProperty("dynamicSuggestionTypes")
    ) {
      if (!a.dynamicSuggestionTypes || !b.dynamicSuggestionTypes) {
        merged.dynamicSuggestionTypes =
          a.dynamicSuggestionTypes ?? b.dynamicSuggestionTypes;
      } else {
        // We only sort to make the behavior stable for tests.
        merged.dynamicSuggestionTypes = [
          ...new Set(
            a.dynamicSuggestionTypes.concat(b.dynamicSuggestionTypes).sort()
          ),
        ];
      }
    }

    return merged;
  }

  /**
   * @returns {string}
   *   The path of `suggest.sqlite`, where the Rust component stores ingested
   *   suggestions. It also stores dismissed suggestions, which is why we keep
   *   this file in the profile directory, but desktop doesn't currently use the
   *   Rust component for that.
   */
  get #storeDataPath() {
    return PathUtils.join(
      Services.dirsvc.get("ProfD", Ci.nsIFile).path,
      SUGGEST_DATA_STORE_BASENAME
    );
  }

  /**
   * @returns {Array}
   *   Each item in this array identifies an enabled Rust suggestion type and
   *   related data. Items have the following properties:
   *
   *   {SuggestProvider} feature
   *     The feature that manages the Rust suggestion type.
   *   {string} type
   *     A Rust suggestion type name as defined in Rust, e.g., "Amp",
   *     "Wikipedia", "Mdn", etc.
   *   {number} provider
   *     An integer that identifies the provider of the suggestion type to Rust.
   */
  get #enabledSuggestionTypes() {
    let items = [];
    for (let feature of lazy.QuickSuggest.rustFeatures) {
      if (feature.isEnabled) {
        let type = feature.rustSuggestionType;
        let provider = this.#providerFromSuggestionType(type);
        if (provider) {
          items.push({ feature, type, provider });
        }
      }
    }
    return items;
  }

  #init() {
    this.#store = this.#makeStore();
    if (!this.#store) {
      return;
    }

    // Log the last ingest time for debugging.
    let lastIngestSecs = Services.prefs.getIntPref(
      INGEST_TIMER_LAST_UPDATE_PREF,
      0
    );
    this.logger.debug("Last ingest time (seconds)", lastIngestSecs);

    // Add our shutdown blocker.
    this.#shutdownBlocker = () => {
      // Interrupt any ongoing ingests (WRITE) and queries (READ).
      // `interrupt()` runs on the main thread and is not async; see
      // toolkit/components/uniffi-bindgen-gecko-js/config.toml
      this.#store?.interrupt(lazy.InterruptKind.READ_WRITE);

      // Null the store so it's destroyed now instead of later when `this` is
      // collected. The store's Sqlite DBs are synced when dropped (its DB and
      // its RS client's DB), which causes a `LateWriteObserver` test failure if
      // it happens too late during shutdown.
      this.#store = null;
      this.#shutdownBlocker = null;
    };
    lazy.AsyncShutdown.profileChangeTeardown.addBlocker(
      "QuickSuggest: Interrupt the Rust component",
      this.#shutdownBlocker
    );

    // Register the ingest timer.
    lazy.timerManager.registerTimer(
      INGEST_TIMER_ID,
      this,
      lazy.UrlbarPrefs.get("quicksuggest.rustIngestIntervalSeconds"),
      true // skipFirst
    );

    // Do an initial ingest for all enabled suggestion types. When a type
    // becomes enabled after this point, its `SuggestProvider` will update and
    // call `ingestEnabledSuggestions()`, which will be its initial ingest.
    this.#ingestAll();

    this.#migrateBlockedDigests().then(() => {
      // Now that the backend has finished initializing, send
      // `quicksuggest-dismissals-changed` to let consumers know that the
      // dismissal API is available. about:preferences relies on this to update
      // its "Restore" button if it's open at this time.
      Services.obs.notifyObservers(null, "quicksuggest-dismissals-changed");
    });
  }

  #makeStore() {
    this.logger.info("Creating SuggestStore");
    if (!this.#remoteSettingsService) {
      return null;
    }

    let builder;
    try {
      builder = lazy.SuggestStoreBuilder.init()
        .dataPath(this.#storeDataPath)
        .remoteSettingsService(this.#remoteSettingsService)
        .loadExtension(
          AppConstants.SQLITE_LIBRARY_FILENAME,
          "sqlite3_fts5_init"
        );
    } catch (error) {
      this.logger.error("Error creating SuggestStoreBuilder", error);
      return null;
    }

    let store;
    try {
      store = builder.build();
    } catch (error) {
      this.logger.error("Error creating SuggestStore", error);
      return null;
    }

    return store;
  }

  #uninit() {
    this.#store = null;
    this.#providerConstraintsOnLastIngestByFeature.clear();
    this.#configsBySuggestionType.clear();
    lazy.timerManager.unregisterTimer(INGEST_TIMER_ID);

    lazy.AsyncShutdown.profileChangeTeardown.removeBlocker(
      this.#shutdownBlocker
    );
    this.#shutdownBlocker = null;
  }

  /**
   * Ingests the given suggestion type.
   *
   * @param {object} options
   *   Options object.
   * @param {string} options.type
   *   A Rust suggestion type name as defined in `suggest.udl`, e.g., "Amp",
   *   "Wikipedia", "Mdn", etc.
   * @param {object|null} options.providerConstraints
   *   A plain JS object version of the type's provider constraints, if any.
   */
  #ingestSuggestionType({ type, providerConstraints }) {
    this.#ingestQueue.queueIdleCallback(async () => {
      if (!this.#store) {
        return;
      }

      let provider = this.#providerFromSuggestionType(type);
      if (!provider) {
        return;
      }

      this.logger.debug("Starting ingest", { type });
      try {
        const metrics = await this.#store.ingest(
          new lazy.SuggestIngestionConstraints({
            providers: [provider],
            providerConstraints: providerConstraints
              ? new lazy.SuggestionProviderConstraints(providerConstraints)
              : null,
          })
        );
        for (let { label, value } of metrics.downloadTimes) {
          Glean.suggest.ingestDownloadTime[label].accumulateSingleSample(value);
        }
        for (let { label, value } of metrics.ingestionTimes) {
          Glean.suggest.ingestTime[label].accumulateSingleSample(value);
        }
      } catch (error) {
        // Ingest can throw a `SuggestApiError` subclass called `Other` with a
        // `reason` message, which is very helpful for diagnosing problems with
        // remote settings data in tests in particular.
        this.logger.error("Ingest error", {
          type,
          error,
          reason: error.reason,
        });
      }
      this.logger.debug("Finished ingest", { type });

      if (!this.#store) {
        return;
      }

      // Fetch the provider config.
      this.logger.debug("Fetching provider config", { type });
      let config = await this.#store.fetchProviderConfig(provider);
      this.logger.debug("Got provider config", { type, config });
      this.#configsBySuggestionType.set(type, config);
      this.logger.debug("Finished fetching provider config", { type });
    });
  }

  #ingestAll() {
    // Ingest all enabled suggestion types.
    for (let feature of lazy.QuickSuggest.rustFeatures) {
      this.ingestEnabledSuggestions(feature, { evenIfFresh: true });
    }

    // Fetch the global config.
    this.#ingestQueue.queueIdleCallback(async () => {
      if (!this.#store) {
        return;
      }
      this.logger.debug("Fetching global config");
      this.#config = await this.#store.fetchGlobalConfig();
      this.logger.debug("Got global config", this.#config);
    });
  }

  /**
   * Given a Rust suggestion type, gets the integer value that identifies the
   * corresponding suggestion provider to Rust.
   *
   * @param {string} type
   *   A Rust suggestion type name as defined in `suggest.udl`, e.g., "Amp",
   *   "Wikipedia", "Mdn", etc.
   * @returns {number}
   *   An integer that identifies the provider of the suggestion type to Rust.
   */
  #providerFromSuggestionType(type) {
    let key = type.toUpperCase();
    if (!lazy.SuggestionProvider.hasOwnProperty(key)) {
      // Normally this shouldn't happen but it can during development when the
      // Rust component and desktop integration are out of sync.
      this.logger.error("SuggestionProvider[key] not defined!", { key });
      return null;
    }
    return lazy.SuggestionProvider[key];
  }

  /**
   * Dismissals are stored in the Rust component but were previously stored as
   * URL digests in a pref. This method migrates the pref to the Rust component
   * by registering each digest as a dismissal key in the Rust component. The
   * pref is cleared when the migration successfully finishes.
   */
  async #migrateBlockedDigests() {
    if (!this.#store) {
      return;
    }

    let pref = "browser.urlbar.quicksuggest.blockedDigests";
    this.logger.debug("Checking blockedDigests migration", { pref });

    let json;
    // eslint-disable-next-line mozilla/use-default-preference-values
    try {
      json = Services.prefs.getCharPref(pref);
    } catch (error) {
      if (error.result != Cr.NS_ERROR_UNEXPECTED) {
        throw error;
      }
      this.logger.debug(
        "blockedDigests pref does not exist, migration not necessary"
      );
      return;
    }

    await this.#migrateBlockedDigestsJson(json);

    // Don't clear the pref until migration finishes successfully, in case
    // there's some uncaught error. We don't want to lose the user's data.
    Services.prefs.clearUserPref(pref);
  }

  // This assumes `this.#store` is non-null!
  async #migrateBlockedDigestsJson(json) {
    let digests;
    try {
      digests = JSON.parse(json);
    } catch (error) {
      this.logger.debug("blockedDigests is not valid JSON, discarding it");
      return;
    }

    if (!digests) {
      this.logger.debug("blockedDigests is falsey, discarding it");
      return;
    }

    if (!Array.isArray(digests)) {
      this.logger.debug("blockedDigests is not an array, discarding it");
      return;
    }

    let promises = [];
    for (let digest of digests) {
      if (typeof digest != "string") {
        continue;
      }
      promises.push(this.#store.dismissByKey(digest));
    }
    await Promise.all(promises);
  }

  get _test_store() {
    return this.#store;
  }

  get _test_enabledSuggestionTypes() {
    return this.#enabledSuggestionTypes;
  }

  async _test_setRemoteSettingsService(remoteSettingsService) {
    this.#remoteSettingsService = remoteSettingsService;
    if (this.isEnabled) {
      // Recreate the store and re-ingest.
      Services.prefs.clearUserPref(INGEST_TIMER_LAST_UPDATE_PREF);
      this.#uninit();
      this.#init();
      await this.ingestPromise;
    }
  }

  async _test_ingest() {
    this.#ingestAll();
    await this.ingestPromise;
  }

  // The `SuggestStore` instance.
  #store;

  // Global Suggest config as returned from `SuggestStore.fetchGlobalConfig()`.
  #config = {};

  // Maps from suggestion type to provider config as returned from
  // `SuggestStore.fetchProviderConfig()`.
  #configsBySuggestionType = new Map();

  // Keeps track of features with fresh (non-stale) ingests. Maps
  // `SuggestProvider`s to their `rustProviderConstraints` on last ingest.
  #providerConstraintsOnLastIngestByFeature = new Map();

  #ingestQueue;
  #shutdownBlocker;
  #remoteSettingsService;
}

/**
 * Returns the type of a suggestion.
 *
 * @param {Suggestion} suggestion
 *   A suggestion object, an instance of one of the `Suggestion` subclasses.
 * @returns {string}
 *   The suggestion's type, e.g., "Amp", "Wikipedia", etc.
 */
function getSuggestionType(suggestion) {
  // Suggestion objects served by the Rust component don't have any inherent
  // type information other than the classes they are instances of. There's no
  // `type` property, for example. There's a base `Suggestion` class and many
  // `Suggestion` subclasses, one per type of suggestion. Each suggestion object
  // is an instance of one of these subclasses. We derive a suggestion's type
  // from the subclass it's an instance of.
  //
  // Unfortunately the subclasses are all anonymous, which means
  // `suggestion.constructor.name` is always an empty string. (This is due to
  // how UniFFI generates JS bindings.) Instead, the subclasses are defined as
  // properties on the base `Suggestion` class. For example,
  // `Suggestion.Wikipedia` is the (anonymous) Wikipedia suggestion class. To
  // find a suggestion's subclass, we loop through the keys on `Suggestion`
  // until we find the value the suggestion is an instance of. To avoid doing
  // this every time, we cache the mapping from suggestion constructor to key
  // the first time we encounter a new suggestion subclass.
  let type = gSuggestionTypesByCtor.get(suggestion.constructor);
  if (!type) {
    type = Object.keys(lazy.Suggestion).find(
      key => suggestion instanceof lazy.Suggestion[key]
    );
    if (type) {
      gSuggestionTypesByCtor.set(suggestion.constructor, type);
    } else {
      console.error(
        "Unexpected error: Suggestion class not found on `Suggestion`. " +
          "Did the Rust component or its JS bindings change? ",
        { suggestion }
      );
    }
  }
  return type;
}

/**
 * The Rust component exports a custom UniFFI type called `JsonValue`, which is
 * just an alias of `serde_json::Value`. The type represents any value that can
 * be serialized as JSON, but UniFFI exports it as its JSON serialization rather
 * than the value itself. The UniFFI JS bindings don't currently deserialize the
 * JSON back to the underlying value, so we use this function to do it
 * ourselves. The process of converting the exported Rust value into a more
 * convenient JS representation is called "lifting".
 *
 * Currently dynamic suggestions are the only objects exported from the Rust
 * component that include a `JsonValue`.
 *
 * @param {Suggestion} suggestion
 *   A `Suggestion` instance from the Rust component.
 * @returns {Suggestion}
 *   If any properties of the suggestion need to be lifted, returns a new
 *   `Suggestion` that's a copy of it except the appropriate properties are
 *   lifted. Otherwise returns the passed-in suggestion itself.
 */
function liftSuggestion(suggestion) {
  if (suggestion instanceof lazy.Suggestion.Dynamic) {
    let { data } = suggestion;
    if (typeof data == "string") {
      try {
        data = JSON.parse(data);
      } catch (error) {
        // This shouldn't ever happen since `suggestion.data` is serialized in
        // the Rust component and should therefore always be valid.
        return null;
      }
    }
    return new lazy.Suggestion.Dynamic({
      suggestionType: suggestion.suggestionType,
      data,
      dismissalKey: suggestion.dismissalKey,
      score: suggestion.score,
    });
  }

  return suggestion;
}

/**
 * This is the opposite of `liftSuggestion()`: It converts a lifted suggestion
 * object back to the value expected by the Rust component. This is only
 * necessary when passing a suggestion back in to the Rust component. This
 * process is called "lowering".
 *
 * @param {Suggestion|object} suggestion
 *   A suggestion object. Technically this can be a plain JS object or a
 *   `Suggestion` instance from the Rust component.
 * @returns {Suggestion}
 *   If any properties of the suggestion need to be lowered, returns a new
 *   `Suggestion` that's a copy of it except the appropriate properties are
 *   lowered. Otherwise returns the passed-in suggestion itself.
 */
function lowerSuggestion(suggestion) {
  if (suggestion.provider == "Dynamic") {
    let { data } = suggestion;
    if (data !== null && data !== undefined) {
      data = JSON.stringify(data);
    }
    return new lazy.Suggestion.Dynamic({
      suggestionType: suggestion.suggestionType,
      data,
      dismissalKey: suggestion.dismissalKey,
      score: suggestion.score,
    });
  }

  return suggestion;
}
