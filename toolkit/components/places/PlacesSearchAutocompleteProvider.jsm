/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Provides functions to handle search engine URLs in the browser history.
 */

"use strict";

var EXPORTED_SYMBOLS = ["PlacesSearchAutocompleteProvider"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const SEARCH_ENGINE_TOPIC = "browser-search-engine-modified";

const SearchAutocompleteProviderInternal = {
  /**
   * {Map<string: nsISearchEngine>} Maps from each domain to the engine with
   * that domain.  If more than one engine has the same domain, the last one
   * passed to _addEngine will be the one in this map.
   */
  enginesByDomain: new Map(),

  /**
   * {Map<string: nsISearchEngine>} Maps from each lowercased alias to the
   * engine with that alias.  If more than one engine has the same alias, the
   * last one passed to _addEngine will be the one in this map.
   */
  enginesByAlias: new Map(),

  /**
   * {array<{ {nsISearchEngine} engine, {array<string>} tokenAliases }>} Array
   * of engines that have "@" aliases.
   */
  tokenAliasEngines: [],

  async initialize() {
    try {
      await Services.search.init();
    } catch (errorCode) {
      throw new Error("Unable to initialize search service.");
    }

    // The initial loading of the search engines must succeed.
    this._refreshedPromise = this._refresh();
    await this._refreshedPromise;

    Services.obs.addObserver(this, SEARCH_ENGINE_TOPIC, true);

    this.initialized = true;
  },

  initialized: false,

  observe(subject, topic, data) {
    switch (data) {
      case "engine-added":
      case "engine-changed":
      case "engine-removed":
      case "engine-default":
        this._refreshedPromise = this._refresh();
    }
  },

  async _refresh() {
    this.enginesByDomain.clear();
    this.enginesByAlias.clear();
    this.tokenAliasEngines = [];

    // The search engines will always be processed in the order returned by the
    // search service, which can be defined by the user.
    (await Services.search.getEngines()).forEach(e => this._addEngine(e));
  },

  _addEngine(engine) {
    if (engine.hidden) {
      return;
    }

    let domain = engine.getResultDomain();
    if (domain) {
      this.enginesByDomain.set(domain, engine);
    }

    let aliases = [];
    if (engine.alias) {
      aliases.push(engine.alias);
    }
    aliases.push(...engine.wrappedJSObject._internalAliases);
    for (let alias of aliases) {
      this.enginesByAlias.set(alias.toLocaleLowerCase(), engine);
    }

    let tokenAliases = aliases.filter(a => a.startsWith("@"));
    if (tokenAliases.length) {
      this.tokenAliasEngines.push({ engine, tokenAliases });
    }
  },

  QueryInterface: ChromeUtils.generateQI([
    Ci.nsIObserver,
    Ci.nsISupportsWeakReference,
  ]),
};

var gInitializationPromise = null;

var PlacesSearchAutocompleteProvider = Object.freeze({
  /**
   * Starts initializing the component and returns a promise that is resolved or
   * rejected when initialization and updates are finished.
   */
  ensureReady() {
    if (!gInitializationPromise) {
      gInitializationPromise = SearchAutocompleteProviderInternal.initialize();
    }

    return Promise.all([
      gInitializationPromise,
      SearchAutocompleteProviderInternal._refreshedPromise,
    ]);
  },

  /**
   * Gets the engine whose domain matches a given prefix.
   *
   * @param   {string} prefix
   *          String containing the first part of the matching domain name.
   * @returns {nsISearchEngine} The matching engine or null if there isn't one.
   */
  async engineForDomainPrefix(prefix) {
    await this.ensureReady();

    // Match at the beginning for now.  In the future, an "options" argument may
    // allow the matching behavior to be tuned.
    let tuples = SearchAutocompleteProviderInternal.enginesByDomain.entries();
    for (let [domain, engine] of tuples) {
      if (domain.startsWith(prefix) || domain.startsWith("www." + prefix)) {
        return engine;
      }
    }
    return null;
  },

  /**
   * Gets the engine with a given alias.
   *
   * @param   {string} alias
   *          A search engine alias.
   * @returns {nsISearchEngine} The matching engine or null if there isn't one.
   */
  async engineForAlias(alias) {
    await this.ensureReady();

    return (
      SearchAutocompleteProviderInternal.enginesByAlias.get(
        alias.toLocaleLowerCase()
      ) || null
    );
  },

  /**
   * Gets the list of engines with token ("@") aliases.
   *
   * @returns {array<{ {nsISearchEngine} engine, {array<string>} tokenAliases }>}
   *          Array of objects { engine, tokenAliases } for token alias engines.
   */
  async tokenAliasEngines() {
    await this.ensureReady();

    return SearchAutocompleteProviderInternal.tokenAliasEngines.slice();
  },

  /**
   * Use this to get the current engine rather than Services.search.defaultEngine
   * directly.  This method makes sure that the service is first initialized.
   *
   * @param {boolean} inPrivateWindow
   *   Set to true if this search is being run in a private window.
   * @returns {nsISearchEngine} The current search engine.
   */
  async currentEngine(inPrivateWindow) {
    await this.ensureReady();

    return inPrivateWindow
      ? Services.search.defaultPrivateEngine
      : Services.search.defaultEngine;
  },

  /**
   * Synchronously determines if the provided URL represents results from a
   * search engine, and provides details about the match.
   *
   * @param url
   *        String containing the URL to parse.
   *
   * @return An object with the following properties, or null if the URL does
   *         not represent a search result:
   *         {
   *           engine: The search engine, as an nsISearchEngine.
   *           terms: The originally sought terms extracted from the URI.
   *           termsParameterName: The engine's search-string parameter.
   *         }
   *
   * @remarks The asynchronous ensureInitialized function must be called before
   *          this synchronous method can be used.
   *
   * @note This API function needs to be synchronous because it is called inside
   *       a row processing callback of Sqlite.jsm, in UnifiedComplete.js.
   */
  parseSubmissionURL(url) {
    if (!SearchAutocompleteProviderInternal.initialized) {
      throw new Error("The component has not been initialized.");
    }

    let parseUrlResult = Services.search.parseSubmissionURL(url);
    return (
      parseUrlResult.engine && {
        engine: parseUrlResult.engine,
        terms: parseUrlResult.terms,
        termsParameterName: parseUrlResult.termsParameterName,
      }
    );
  },
});
