/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim: sw=2 ts=2 sts=2 expandtab
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* eslint complexity: ["error", 53] */

"use strict";

// Constants

const MS_PER_DAY = 86400000; // 24 * 60 * 60 * 1000

// AutoComplete query type constants.
// Describes the various types of queries that we can process rows for.
const QUERYTYPE_FILTERED = 0;

// The default frecency value used when inserting matches with unknown frecency.
const FRECENCY_DEFAULT = 1000;

// Regex used to match userContextId.
const REGEXP_USER_CONTEXT_ID = /(?:^| )user-context-id:(\d+)/;

// Regex used to match maxResults.
const REGEXP_MAX_RESULTS = /(?:^| )max-results:(\d+)/;

// Regex used to match one or more whitespace.
const REGEXP_SPACES = /\s+/;

// Regex used to strip prefixes from URLs.  See stripAnyPrefix().
const REGEXP_STRIP_PREFIX = /^[a-z]+:(?:\/){0,2}/i;

// The result is notified on a delay, to avoid rebuilding the panel at every match.
const NOTIFYRESULT_DELAY_MS = 16;

// Sqlite result row index constants.
const QUERYINDEX_QUERYTYPE = 0;
const QUERYINDEX_URL = 1;
const QUERYINDEX_TITLE = 2;
const QUERYINDEX_BOOKMARKED = 3;
const QUERYINDEX_BOOKMARKTITLE = 4;
const QUERYINDEX_TAGS = 5;
//    QUERYINDEX_VISITCOUNT    = 6;
//    QUERYINDEX_TYPED         = 7;
const QUERYINDEX_PLACEID = 8;
const QUERYINDEX_SWITCHTAB = 9;
const QUERYINDEX_FRECENCY = 10;

// This SQL query fragment provides the following:
//   - whether the entry is bookmarked (QUERYINDEX_BOOKMARKED)
//   - the bookmark title, if it is a bookmark (QUERYINDEX_BOOKMARKTITLE)
//   - the tags associated with a bookmarked entry (QUERYINDEX_TAGS)
const SQL_BOOKMARK_TAGS_FRAGMENT = `EXISTS(SELECT 1 FROM moz_bookmarks WHERE fk = h.id) AS bookmarked,
   ( SELECT title FROM moz_bookmarks WHERE fk = h.id AND title NOTNULL
     ORDER BY lastModified DESC LIMIT 1
   ) AS btitle,
   ( SELECT GROUP_CONCAT(t.title, ', ')
     FROM moz_bookmarks b
     JOIN moz_bookmarks t ON t.id = +b.parent AND t.parent = :parent
     WHERE b.fk = h.id
   ) AS tags`;

// TODO bug 412736: in case of a frecency tie, we might break it with h.typed
// and h.visit_count.  That is slower though, so not doing it yet...
// NB: as a slight performance optimization, we only evaluate the "bookmarked"
// condition once, and avoid evaluating "btitle" and "tags" when it is false.
function defaultQuery(conditions = "") {
  let query = `SELECT :query_type, h.url, h.title, ${SQL_BOOKMARK_TAGS_FRAGMENT},
            h.visit_count, h.typed, h.id, t.open_count, h.frecency
     FROM moz_places h
     LEFT JOIN moz_openpages_temp t
            ON t.url = h.url
           AND t.userContextId = :userContextId
     WHERE h.frecency <> 0
       AND CASE WHEN bookmarked
         THEN
           AUTOCOMPLETE_MATCH(:searchString, h.url,
                              IFNULL(btitle, h.title), tags,
                              h.visit_count, h.typed,
                              1, t.open_count,
                              :matchBehavior, :searchBehavior)
         ELSE
           AUTOCOMPLETE_MATCH(:searchString, h.url,
                              h.title, '',
                              h.visit_count, h.typed,
                              0, t.open_count,
                              :matchBehavior, :searchBehavior)
         END
       ${conditions ? "AND" : ""} ${conditions}
     ORDER BY h.frecency DESC, h.id DESC
     LIMIT :maxResults`;
  return query;
}

const SQL_SWITCHTAB_QUERY = `SELECT :query_type, t.url, t.url, NULL, NULL, NULL, NULL, NULL, NULL,
          t.open_count, NULL
   FROM moz_openpages_temp t
   LEFT JOIN moz_places h ON h.url_hash = hash(t.url) AND h.url = t.url
   WHERE h.id IS NULL
     AND t.userContextId = :userContextId
     AND AUTOCOMPLETE_MATCH(:searchString, t.url, t.url, NULL,
                            NULL, NULL, NULL, t.open_count,
                            :matchBehavior, :searchBehavior)
   ORDER BY t.ROWID DESC
   LIMIT :maxResults`;

// Getters

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyGlobalGetters(this, ["fetch"]);

XPCOMUtils.defineLazyModuleGetters(this, {
  KeywordUtils: "resource://gre/modules/KeywordUtils.jsm",
  ObjectUtils: "resource://gre/modules/ObjectUtils.jsm",
  PlacesUtils: "resource://gre/modules/PlacesUtils.jsm",
  PrivateBrowsingUtils: "resource://gre/modules/PrivateBrowsingUtils.jsm",
  ProfileAge: "resource://gre/modules/ProfileAge.jsm",
  PromiseUtils: "resource://gre/modules/PromiseUtils.jsm",
  Sqlite: "resource://gre/modules/Sqlite.jsm",
  UrlbarPrefs: "resource:///modules/UrlbarPrefs.jsm",
  UrlbarProvidersManager: "resource:///modules/UrlbarProvidersManager.jsm",
  UrlbarSearchUtils: "resource:///modules/UrlbarSearchUtils.jsm",
  UrlbarTokenizer: "resource:///modules/UrlbarTokenizer.jsm",
  UrlbarUtils: "resource:///modules/UrlbarUtils.jsm",
});

function setTimeout(callback, ms) {
  let timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
  timer.initWithCallback(callback, ms, timer.TYPE_ONE_SHOT);
  return timer;
}

const kProtocolsWithIcons = [
  "chrome:",
  "moz-extension:",
  "about:",
  "http:",
  "https:",
  "ftp:",
];
function iconHelper(url) {
  if (typeof url == "string") {
    return kProtocolsWithIcons.some(p => url.startsWith(p))
      ? "page-icon:" + url
      : PlacesUtils.favicons.defaultFavicon.spec;
  }
  if (url && url instanceof URL && kProtocolsWithIcons.includes(url.protocol)) {
    return "page-icon:" + url.href;
  }
  return PlacesUtils.favicons.defaultFavicon.spec;
}

// Preloaded Sites related

function PreloadedSite(url, title) {
  this.uri = Services.io.newURI(url);
  this.title = title;
  this._matchTitle = title.toLowerCase();
  this._hasWWW = this.uri.host.startsWith("www.");
  this._hostWithoutWWW = this._hasWWW ? this.uri.host.slice(4) : this.uri.host;
}

/**
 * Storage object for Preloaded Sites.
 *   add(url, title): adds a site to storage
 *   populate(sites) : populates the  storage with array of [url,title]
 *   sites[]: resulting array of sites (PreloadedSite objects)
 */
XPCOMUtils.defineLazyGetter(this, "PreloadedSiteStorage", () =>
  Object.seal({
    sites: [],

    add(url, title) {
      let site = new PreloadedSite(url, title);
      this.sites.push(site);
    },

    populate(sites) {
      this.sites = [];
      for (let site of sites) {
        this.add(site[0], site[1]);
      }
    },
  })
);

XPCOMUtils.defineLazyGetter(this, "ProfileAgeCreatedPromise", async () => {
  let times = await ProfileAge();
  return times.created;
});

// Maps restriction character types to textual behaviors.
XPCOMUtils.defineLazyGetter(this, "typeToBehaviorMap", () => {
  return new Map([
    [UrlbarTokenizer.TYPE.RESTRICT_HISTORY, "history"],
    [UrlbarTokenizer.TYPE.RESTRICT_BOOKMARK, "bookmark"],
    [UrlbarTokenizer.TYPE.RESTRICT_TAG, "tag"],
    [UrlbarTokenizer.TYPE.RESTRICT_OPENPAGE, "openpage"],
    [UrlbarTokenizer.TYPE.RESTRICT_SEARCH, "search"],
    [UrlbarTokenizer.TYPE.RESTRICT_TITLE, "title"],
    [UrlbarTokenizer.TYPE.RESTRICT_URL, "url"],
  ]);
});

XPCOMUtils.defineLazyGetter(this, "sourceToBehaviorMap", () => {
  return new Map([
    [UrlbarUtils.RESULT_SOURCE.HISTORY, "history"],
    [UrlbarUtils.RESULT_SOURCE.BOOKMARKS, "bookmark"],
    [UrlbarUtils.RESULT_SOURCE.TABS, "openpage"],
    [UrlbarUtils.RESULT_SOURCE.SEARCH, "search"],
  ]);
});

// Helper functions

/**
 * Strips the prefix from a URL and returns the prefix and the remainder of the
 * URL.  "Prefix" is defined to be the scheme and colon, plus, if present, two
 * slashes.  If the given string is not actually a URL, then an empty prefix and
 * the string itself is returned.
 *
 * @param  str
 *         The possible URL to strip.
 * @return If `str` is a URL, then [prefix, remainder].  Otherwise, ["", str].
 */
function stripAnyPrefix(str) {
  let match = REGEXP_STRIP_PREFIX.exec(str);
  if (!match) {
    return ["", str];
  }
  let prefix = match[0];
  if (prefix.length < str.length && str[prefix.length] == " ") {
    return ["", str];
  }
  return [prefix, str.substr(prefix.length)];
}

/**
 * Strips parts of a URL defined in `options`.
 *
 * @param {string} spec
 *        The text to modify.
 * @param {object} options
 * @param {boolean} options.stripHttp
 *        Whether to strip http.
 * @param {boolean} options.stripHttps
 *        Whether to strip https.
 * @param {boolean} options.stripWww
 *        Whether to strip `www.`.
 * @param {boolean} options.trimSlash
 *        Whether to trim the trailing slash.
 * @param {boolean} options.trimEmptyQuery
 *        Whether to trim a trailing `?`.
 * @param {boolean} options.trimEmptyHash
 *        Whether to trim a trailing `#`.
 * @returns {array} [modified, prefix, suffix]
 *          modified: {string} The modified spec.
 *          prefix: {string} The parts stripped from the prefix, if any.
 *          suffix: {string} The parts trimmed from the suffix, if any.
 */
function stripPrefixAndTrim(spec, options = {}) {
  let prefix = "";
  let suffix = "";
  if (options.stripHttp && spec.startsWith("http://")) {
    spec = spec.slice(7);
    prefix = "http://";
  } else if (options.stripHttps && spec.startsWith("https://")) {
    spec = spec.slice(8);
    prefix = "https://";
  }
  if (options.stripWww && spec.startsWith("www.")) {
    spec = spec.slice(4);
    prefix += "www.";
  }
  if (options.trimEmptyHash && spec.endsWith("#")) {
    spec = spec.slice(0, -1);
    suffix = "#" + suffix;
  }
  if (options.trimEmptyQuery && spec.endsWith("?")) {
    spec = spec.slice(0, -1);
    suffix = "?" + suffix;
  }
  if (options.trimSlash && spec.endsWith("/")) {
    spec = spec.slice(0, -1);
    suffix = "/" + suffix;
  }
  return [spec, prefix, suffix];
}

/**
 * Returns the key to be used for a match in a map for the purposes of removing
 * duplicate entries - any 2 matches that should be considered the same should
 * return the same key.  The type of the returned key depends on the type of the
 * match, so don't assume you can compare keys using ==.  Instead, use
 * ObjectUtils.deepEqual().
 *
 * @param   {object} match
 *          The match object.
 * @returns {value} Some opaque key object.  Use ObjectUtils.deepEqual() to
 *          compare keys.
 */
function makeKeyForMatch(match) {
  // For autofill entries, we need to have a key based on the finalCompleteValue
  // rather than the value field, because the latter may have been trimmed.
  let key, prefix;
  if (match.style && match.style.includes("autofill")) {
    [key, prefix] = stripPrefixAndTrim(match.finalCompleteValue, {
      stripHttp: true,
      stripHttps: true,
      stripWww: true,
      trimEmptyQuery: true,
      trimSlash: true,
    });

    return [key, prefix, null];
  }

  let action = PlacesUtils.parseActionUrl(match.value);
  if (!action) {
    [key, prefix] = stripPrefixAndTrim(match.value, {
      stripHttp: true,
      stripHttps: true,
      stripWww: true,
      trimSlash: true,
      trimEmptyQuery: true,
      trimEmptyHash: true,
    });
    return [key, prefix, null];
  }

  switch (action.type) {
    case "searchengine":
      // We want to exclude search suggestion matches that simply echo back the
      // query string in the heuristic result.  For example, if the user types
      // "@engine test", we want to exclude a "test" suggestion match.
      key = [
        action.type,
        action.params.engineName,
        (
          action.params.searchSuggestion || action.params.searchQuery
        ).toLocaleLowerCase(),
      ];
      break;
    default:
      [key, prefix] = stripPrefixAndTrim(action.params.url || match.value, {
        stripHttp: true,
        stripHttps: true,
        stripWww: true,
        trimEmptyQuery: true,
        trimSlash: true,
      });
      break;
  }

  return [key, prefix, action];
}

/**
 * Makes a moz-action url for the given action and set of parameters.
 *
 * @param   type
 *          The action type.
 * @param   params
 *          A JS object of action params.
 * @returns A moz-action url as a string.
 */
function makeActionUrl(type, params) {
  let encodedParams = {};
  for (let key in params) {
    // Strip null or undefined.
    // Regardless, don't encode them or they would be converted to a string.
    if (params[key] === null || params[key] === undefined) {
      continue;
    }
    encodedParams[key] = encodeURIComponent(params[key]);
  }
  return `moz-action:${type},${JSON.stringify(encodedParams)}`;
}

const MATCH_TYPE = {
  HEURISTIC: "heuristic",
  GENERAL: "general",
  SUGGESTION: "suggestion",
  EXTENSION: "extension",
};

/**
 * Manages a single instance of an autocomplete search.
 *
 * The first three parameters all originate from the similarly named parameters
 * of nsIAutoCompleteSearch.startSearch().
 *
 * @param searchString
 *        The search string.
 * @param searchParam
 *        A space-delimited string of search parameters.  The following
 *        parameters are supported:
 *        * enable-actions: Include "actions", such as switch-to-tab and search
 *          engine aliases, in the results.
 *        * disable-private-actions: The search is taking place in a private
 *          window outside of permanent private-browsing mode.  The search
 *          should exclude privacy-sensitive results as appropriate.
 *        * private-window: The search is taking place in a private window,
 *          possibly in permanent private-browsing mode.  The search
 *          should exclude privacy-sensitive results as appropriate.
 *        * user-context-id: The userContextId of the selected tab.
 * @param autocompleteListener
 *        An nsIAutoCompleteObserver.
 * @param autocompleteSearch
 *        An nsIAutoCompleteSearch.
 * @param {UrlbarQueryContext} [queryContext]
 *        The query context, undefined for legacy consumers.
 */
function Search(
  searchString,
  searchParam,
  autocompleteListener,
  autocompleteSearch,
  queryContext
) {
  // We want to store the original string for case sensitive searches.
  this._originalSearchString = searchString;
  this._trimmedOriginalSearchString = searchString.trim();
  let unescapedSearchString = Services.textToSubURI.unEscapeURIForUI(
    this._trimmedOriginalSearchString
  );
  let [prefix, suffix] = stripAnyPrefix(unescapedSearchString);
  this._searchString = suffix;
  this._strippedPrefix = prefix.toLowerCase();

  this._matchBehavior = Ci.mozIPlacesAutoComplete.MATCH_BOUNDARY;
  // Set the default behavior for this search.
  this._behavior = this._searchString
    ? UrlbarPrefs.get("defaultBehavior")
    : this._emptySearchDefaultBehavior;

  if (queryContext) {
    this._enableActions = true;
    this._inPrivateWindow = queryContext.isPrivate;
    this._disablePrivateActions =
      this._inPrivateWindow && !PrivateBrowsingUtils.permanentPrivateBrowsing;
    this._prohibitAutoFill = !queryContext.allowAutofill;
    this._maxResults = queryContext.maxResults;
    this._userContextId = queryContext.userContextId;
    this._currentPage = queryContext.currentPage;
    this._searchModeEngine = queryContext.searchMode?.engineName;
    this._searchMode = queryContext.searchMode;
    if (this._searchModeEngine) {
      // Filter Places results on host.
      let engine = Services.search.getEngineByName(this._searchModeEngine);
      this._filterOnHost = engine.getResultDomain();
    }
  } else {
    let params = new Set(searchParam.split(" "));
    this._enableActions = params.has("enable-actions");
    this._disablePrivateActions = params.has("disable-private-actions");
    this._inPrivateWindow = params.has("private-window");
    this._prohibitAutoFill = params.has("prohibit-autofill");
    // Extract the max-results param.
    let maxResults = searchParam.match(REGEXP_MAX_RESULTS);
    this._maxResults = maxResults
      ? parseInt(maxResults[1])
      : UrlbarPrefs.get("maxRichResults");
    // Extract the user-context-id param.
    let userContextId = searchParam.match(REGEXP_USER_CONTEXT_ID);
    this._userContextId = userContextId
      ? parseInt(userContextId[1], 10)
      : Ci.nsIScriptSecurityManager.DEFAULT_USER_CONTEXT_ID;
  }

  // Use the original string here, not the stripped one, so the tokenizer can
  // properly recognize token types.
  let { tokens } = UrlbarTokenizer.tokenize({
    searchString: unescapedSearchString,
    trimmedSearchString: unescapedSearchString.trim(),
  });

  // This allows to handle leading or trailing restriction characters specially.
  this._leadingRestrictionToken = null;
  if (tokens.length) {
    if (
      UrlbarTokenizer.isRestrictionToken(tokens[0]) &&
      (tokens.length > 1 ||
        tokens[0].type == UrlbarTokenizer.TYPE.RESTRICT_SEARCH)
    ) {
      this._leadingRestrictionToken = tokens[0].value;
    }

    // Check if the first token has a strippable prefix and remove it, but don't
    // create an empty token.
    if (prefix && tokens[0].value.length > prefix.length) {
      tokens[0].value = tokens[0].value.substring(prefix.length);
    }
  }

  // Eventually filter restriction tokens. In general it's a good idea, but if
  // the consumer requested search mode, we should use the full string to avoid
  // ignoring valid tokens.
  this._searchTokens =
    !queryContext || queryContext.restrictToken
      ? this.filterTokens(tokens)
      : tokens;

  // The behavior can be set through:
  // 1. a specific restrictSource in the QueryContext
  // 2. typed restriction tokens
  if (
    queryContext &&
    queryContext.restrictSource &&
    sourceToBehaviorMap.has(queryContext.restrictSource)
  ) {
    this._behavior = 0;
    this.setBehavior("restrict");
    let behavior = sourceToBehaviorMap.get(queryContext.restrictSource);
    this.setBehavior(behavior);

    // When we are in restrict mode, all the tokens are valid for searching, so
    // there is no _heuristicToken.
    this._heuristicToken = null;
  } else {
    // The heuristic token is the first filtered search token, but only when it's
    // actually the first thing in the search string.  If a prefix or restriction
    // character occurs first, then the heurstic token is null.  We use the
    // heuristic token to help determine the heuristic result.  It may be a Places
    // keyword, a search engine alias, or simply a URL or part of the search
    // string the user has typed.  We won't know until we create the heuristic
    // result.
    let firstToken = !!this._searchTokens.length && this._searchTokens[0].value;
    this._heuristicToken =
      firstToken && this._trimmedOriginalSearchString.startsWith(firstToken)
        ? firstToken
        : null;
  }

  // Set the right JavaScript behavior based on our preference.  Note that the
  // preference is whether or not we should filter JavaScript, and the
  // behavior is if we should search it or not.
  if (!UrlbarPrefs.get("filter.javascript")) {
    this.setBehavior("javascript");
  }

  this._listener = autocompleteListener;
  this._autocompleteSearch = autocompleteSearch;

  // Create a new result to add eventual matches.  Note we need a result
  // regardless having matches.
  let result = Cc["@mozilla.org/autocomplete/simple-result;1"].createInstance(
    Ci.nsIAutoCompleteSimpleResult
  );
  result.setSearchString(searchString);
  // Will be set later, if needed.
  result.setDefaultIndex(-1);
  this._result = result;

  // These are used to avoid adding duplicate entries to the results.
  this._usedURLs = [];
  this._usedPlaceIds = new Set();

  // Counters for the number of results per MATCH_TYPE.
  this._counts = Object.values(MATCH_TYPE).reduce((o, p) => {
    o[p] = 0;
    return o;
  }, {});
}

Search.prototype = {
  /**
   * Enables the desired AutoComplete behavior.
   *
   * @param type
   *        The behavior type to set.
   */
  setBehavior(type) {
    type = type.toUpperCase();
    this._behavior |= Ci.mozIPlacesAutoComplete["BEHAVIOR_" + type];
  },

  /**
   * Determines if the specified AutoComplete behavior is set.
   *
   * @param aType
   *        The behavior type to test for.
   * @return true if the behavior is set, false otherwise.
   */
  hasBehavior(type) {
    let behavior = Ci.mozIPlacesAutoComplete["BEHAVIOR_" + type.toUpperCase()];

    if (
      this._disablePrivateActions &&
      behavior == Ci.mozIPlacesAutoComplete.BEHAVIOR_OPENPAGE
    ) {
      return false;
    }

    return this._behavior & behavior;
  },

  /**
   * Used to delay the most complex queries, to save IO while the user is
   * typing.
   */
  _sleepResolve: null,
  _sleep(aTimeMs) {
    // Reuse a single instance to try shaving off some usless work before
    // the first query.
    if (!this._sleepTimer) {
      this._sleepTimer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    }
    return new Promise(resolve => {
      this._sleepResolve = resolve;
      this._sleepTimer.initWithCallback(
        resolve,
        aTimeMs,
        Ci.nsITimer.TYPE_ONE_SHOT
      );
    });
  },

  /**
   * Given an array of tokens, this function determines which query should be
   * ran.  It also removes any special search tokens.
   *
   * @param tokens
   *        An array of search tokens.
   * @return A new, filtered array of tokens.
   */
  filterTokens(tokens) {
    let foundToken = false;
    // Set the proper behavior while filtering tokens.
    let filtered = [];
    for (let token of tokens) {
      if (!UrlbarTokenizer.isRestrictionToken(token)) {
        filtered.push(token);
        continue;
      }
      let behavior = typeToBehaviorMap.get(token.type);
      if (!behavior) {
        throw new Error(`Unknown token type ${token.type}`);
      }
      // Don't remove the token if it didn't match, or if it's an action but
      // actions are not enabled.
      if (behavior != "openpage" || this._enableActions) {
        // Don't use the suggest preferences if it is a token search and
        // set the restrict bit to 1 (to intersect the search results).
        if (!foundToken) {
          foundToken = true;
          // Do not take into account previous behavior (e.g.: history, bookmark)
          this._behavior = 0;
          this.setBehavior("restrict");
        }
        this.setBehavior(behavior);
        // We return tags only for bookmarks, thus when tags are enforced, we
        // must also set the bookmark behavior.
        if (behavior == "tag") {
          this.setBehavior("bookmark");
        }
      }
    }
    return filtered;
  },

  /**
   * Stop this search.
   * After invoking this method, we won't run any more searches or heuristics,
   * and no new matches may be added to the current result.
   */
  stop() {
    // Avoid multiple calls or re-entrance.
    if (!this.pending) {
      return;
    }
    if (this._notifyTimer) {
      this._notifyTimer.cancel();
    }
    this._notifyDelaysCount = 0;
    if (this._sleepTimer) {
      this._sleepTimer.cancel();
    }
    if (this._sleepResolve) {
      this._sleepResolve();
      this._sleepResolve = null;
    }
    if (typeof this.interrupt == "function") {
      this.interrupt();
    }
    this.pending = false;
  },

  /**
   * Whether this search is active.
   */
  pending: true,

  /**
   * Execute the search and populate results.
   * @param conn
   *        The Sqlite connection.
   */
  async execute(conn) {
    // A search might be canceled before it starts.
    if (!this.pending) {
      return;
    }

    // Used by stop() to interrupt an eventual running statement.
    this.interrupt = () => {
      // Interrupt any ongoing statement to run the search sooner.
      if (!UrlbarProvidersManager.interruptLevel) {
        conn.interrupt();
      }
    };

    // For any given search, we run many queries/heuristics:
    // 1) by alias (as defined in SearchService)
    // 2) inline completion from search engine resultDomains
    // 3) submission for the current search engine
    // 4) Places keywords
    // 5) open pages not supported by history (this._switchToTabQuery)
    // 6) query based on match behavior
    //
    // (4) only gets run if we get any filtered tokens, since if there are no
    // tokens, there is nothing to match.
    //
    // (1) only runs if actions are enabled. When actions are
    // enabled, the first result is always a special result (resulting from one
    // of the queries between (1) and (4) inclusive). As such, the UI is
    // expected to auto-select the first result when actions are enabled. If the
    // first result is an inline completion result, that will also be the
    // default result and therefore be autofilled (this also happens if actions
    // are not enabled).

    // Check for Preloaded Sites Expiry before Autofill
    await this._checkPreloadedSitesExpiry();

    // If the query is simply "@" and we have tokenAliasEngines then return
    // early. UrlbarProviderTokenAliasEngines will add engine results.
    let tokenAliasEngines = await UrlbarSearchUtils.tokenAliasEngines();
    if (this._trimmedOriginalSearchString == "@" && tokenAliasEngines.length) {
      this._autocompleteSearch.finishSearch(true);
      return;
    }

    // Add the first heuristic result, if any.  Set _addingHeuristicResult
    // to true so that when the result is added, "heuristic" can be included in
    // its style.
    this._addingHeuristicResult = true;
    await this._matchFirstHeuristicResult(conn);
    this._addingHeuristicResult = false;
    if (!this.pending) {
      return;
    }

    // We sleep a little between adding the heuristic result and matching
    // any other searches so we aren't kicking off potentially expensive
    // searches on every keystroke. We check trimmedOriginalSearchString instead
    // of whether we have a heurisitic because several sources of heuristic
    // results have been factored out of UnifiedComplete. See discussion in
    // bug 1655034.
    // If there's no string, we search immediately because the user wants
    // the empty search results ASAP.
    if (this._trimmedOriginalSearchString) {
      await this._sleep(UrlbarPrefs.get("delay"));
      if (!this.pending) {
        return;
      }

      // If the heuristic result is an engine from a token alias, the search
      // restriction char, or we're in search-restriction mode, then we're done.
      // UrlbarProviderSearchSuggestions will handle suggestions, if any.
      let emptySearchRestriction =
        this._trimmedOriginalSearchString.length <= 3 &&
        this._leadingRestrictionToken == UrlbarTokenizer.RESTRICT.SEARCH &&
        /\s*\S?$/.test(this._trimmedOriginalSearchString);
      if (
        emptySearchRestriction ||
        (tokenAliasEngines &&
          this._trimmedOriginalSearchString.startsWith("@")) ||
        (this.hasBehavior("search") && this.hasBehavior("restrict"))
      ) {
        this._autocompleteSearch.finishSearch(true);
        return;
      }
    }

    // Run our standard Places query.
    let queries = [];
    // "openpage" behavior is supported by the default query.
    // _switchToTabQuery instead returns only pages not supported by history.
    if (this.hasBehavior("openpage")) {
      queries.push(this._switchToTabQuery);
    }
    queries.push(this._searchQuery);
    for (let [query, params] of queries) {
      await conn.executeCached(query, params, this._onResultRow.bind(this));
      if (!this.pending) {
        return;
      }
    }

    // If we do not have enough matches search again with MATCH_ANYWHERE, to
    // get more matches.
    let count =
      this._counts[MATCH_TYPE.GENERAL] + this._counts[MATCH_TYPE.HEURISTIC];
    if (count < this._maxResults) {
      this._matchBehavior = Ci.mozIPlacesAutoComplete.MATCH_ANYWHERE;
      let queries = [this._searchQuery];
      if (this.hasBehavior("openpage")) {
        queries.unshift(this._switchToTabQuery);
      }
      for (let [query, params] of queries) {
        await conn.executeCached(query, params, this._onResultRow.bind(this));
        if (!this.pending) {
          return;
        }
      }
    }

    this._matchPreloadedSites();
  },

  async _checkPreloadedSitesExpiry() {
    if (!UrlbarPrefs.get("usepreloadedtopurls.enabled")) {
      return;
    }
    let profileCreationDate = await ProfileAgeCreatedPromise;
    let daysSinceProfileCreation =
      (Date.now() - profileCreationDate) / MS_PER_DAY;
    if (
      daysSinceProfileCreation >
      UrlbarPrefs.get("usepreloadedtopurls.expire_days")
    ) {
      Services.prefs.setBoolPref(
        "browser.urlbar.usepreloadedtopurls.enabled",
        false
      );
    }
  },

  _matchPreloadedSites() {
    if (!UrlbarPrefs.get("usepreloadedtopurls.enabled")) {
      return;
    }

    if (!this._searchString) {
      // The user hasn't typed anything, or they've only typed a scheme.
      return;
    }

    for (let site of PreloadedSiteStorage.sites) {
      let url = site.uri.spec;
      if (
        (!this._strippedPrefix || url.startsWith(this._strippedPrefix)) &&
        (site.uri.host.includes(this._searchString) ||
          site._matchTitle.includes(this._searchString))
      ) {
        this._addMatch({
          value: url,
          comment: site.title,
          style: "preloaded-top-site",
          frecency: FRECENCY_DEFAULT - 1,
        });
      }
    }
  },

  _matchPreloadedSiteForAutofill() {
    if (!UrlbarPrefs.get("usepreloadedtopurls.enabled")) {
      return false;
    }

    let matchedSite = PreloadedSiteStorage.sites.find(site => {
      return (
        (!this._strippedPrefix ||
          site.uri.spec.startsWith(this._strippedPrefix)) &&
        (site.uri.host.startsWith(this._searchString) ||
          site.uri.host.startsWith("www." + this._searchString))
      );
    });
    if (!matchedSite) {
      return false;
    }

    this._result.setDefaultIndex(0);

    let url = matchedSite.uri.spec;
    let value = stripAnyPrefix(url)[1];
    value = value.substr(value.indexOf(this._searchString));

    this._addAutofillMatch(value, url, Infinity, ["preloaded-top-site"]);
    return true;
  },

  async _matchFirstHeuristicResult(conn) {
    if (this._searchMode) {
      // Use UrlbarProviderHeuristicFallback.
      return false;
    }

    // We always try to make the first result a special "heuristic" result.  The
    // heuristics below determine what type of result it will be, if any.

    if (this.pending && this._enableActions && this._heuristicToken) {
      // It may be a search engine with an alias - which works like a keyword.
      let matched = await this._matchSearchEngineAlias(this._heuristicToken);
      if (matched) {
        return true;
      }
    }

    if (this.pending && this._heuristicToken) {
      // It may be a Places keyword.
      let matched = await this._matchPlacesKeyword(this._heuristicToken);
      if (matched) {
        return true;
      }
    }

    let shouldAutofill = this._shouldAutofill;

    if (this.pending && shouldAutofill) {
      let matched = this._matchPreloadedSiteForAutofill();
      if (matched) {
        return true;
      }
    }

    // Fall back to UrlbarProviderHeuristicFallback.
    return false;
  },

  async _matchPlacesKeyword(keyword) {
    let entry = await PlacesUtils.keywords.fetch(keyword);
    if (!entry) {
      return false;
    }

    let searchString = UrlbarUtils.substringAfter(
      this._originalSearchString,
      keyword
    ).trim();

    let url = null;
    let postData = null;
    try {
      [url, postData] = await KeywordUtils.parseUrlAndPostData(
        entry.url.href,
        entry.postData,
        searchString
      );
    } catch (ex) {
      // It's not possible to bind a param to this keyword.
      return false;
    }

    let style = "keyword";
    let value = url;
    if (this._enableActions) {
      style = "action " + style;
      value = makeActionUrl("keyword", {
        url,
        keyword,
        input: this._originalSearchString,
        postData,
      });
    }

    let match = {
      value,
      // Don't use the url with replaced strings, since the icon doesn't change
      // but the string does, it may cause pointless icon flicker on typing.
      icon: iconHelper(entry.url),
      style,
      frecency: Infinity,
    };
    // If there is a query string, the title will be "host: queryString".
    if (this._searchTokens.length > 1) {
      match.comment = entry.url.host;
    }

    this._firstTokenIsKeyword = true;
    this._filterOnHost = entry.url.host;
    this._addMatch(match);
    return true;
  },

  async _matchSearchEngineAlias(alias) {
    let engine = await UrlbarSearchUtils.engineForAlias(alias);
    if (!engine) {
      return false;
    }

    let query = UrlbarUtils.substringAfter(this._originalSearchString, alias);

    // Match an alias only when it has a space after it.  If there's no trailing
    // space, then continue to treat it as part of the search string.
    if (!UrlbarTokenizer.REGEXP_SPACES_START.test(query)) {
      return false;
    }

    this._searchEngineAliasMatch = {
      engine,
      alias,
      query: query.trimStart(),
    };
    this._firstTokenIsKeyword = true;
    this._filterOnHost = engine.getResultDomain();
    this._addSearchEngineMatch(this._searchEngineAliasMatch);
    return true;
  },

  /**
   * Adds a search engine match.
   *
   * @param {nsISearchEngine} engine
   *        The search engine associated with the match.
   * @param {string} [query]
   *        The search query string.
   * @param {string} [alias]
   *        The search engine alias associated with the match, if any.
   * @param {bool} [historical]
   *        True if you're adding a suggestion match and the suggestion is from
   *        the user's local history (and not the search engine).
   */
  _addSearchEngineMatch({
    engine,
    query = "",
    alias = undefined,
    historical = false,
  }) {
    let actionURLParams = {
      engineName: engine.name,
      searchQuery: query,
    };

    if (alias && !query) {
      // `input` should have a trailing space so that when the user selects the
      // result, they can start typing their query without first having to enter
      // a space between the alias and query.
      actionURLParams.input = `${alias} `;
    } else {
      actionURLParams.input = this._originalSearchString;
    }

    let match = {
      comment: engine.name,
      icon: engine.iconURI ? engine.iconURI.spec : null,
      style: "action searchengine",
      frecency: FRECENCY_DEFAULT,
    };

    if (alias) {
      actionURLParams.alias = alias;
      match.style += " alias";
    }

    match.value = makeActionUrl("searchengine", actionURLParams);
    this._addMatch(match);
  },

  _onResultRow(row, cancel) {
    let queryType = row.getResultByIndex(QUERYINDEX_QUERYTYPE);
    switch (queryType) {
      case QUERYTYPE_FILTERED:
        this._addFilteredQueryMatch(row);
        break;
    }
    // If the search has been canceled by the user or by _addMatch, or we
    // fetched enough results, we can stop the underlying Sqlite query.
    let count =
      this._counts[MATCH_TYPE.GENERAL] + this._counts[MATCH_TYPE.HEURISTIC];
    if (!this.pending || count >= this._maxResults) {
      cancel();
    }
  },

  /**
   * Maybe restyle a SERP in history as a search-type result. To do this,
   * we extract the search term from the SERP in history then generate a search
   * URL with that search term. We restyle the SERP in history if its query
   * parameters are a subset of those of the generated SERP. We check for a
   * subset instead of exact equivalence since the generated URL may contain
   * attribution parameters while a SERP in history from an organic search would
   * not. We don't allow extra params in the history URL since they might
   * indicate the search is not a first-page web SERP (as opposed to a image or
   * other non-web SERP).
   *
   * @note We will mistakenly dedupe SERPs for engines that have the same
   *   hostname as another engine. One example is if the user installed a
   *   Google Image Search engine. That engine's search URLs might only be
   *   distinguished by query params from search URLs from the default Google
   *   engine.
   */
  _maybeRestyleSearchMatch(match) {
    // Return if the URL does not represent a search result.
    let historyUrl = match.value;
    let parseResult = Services.search.parseSubmissionURL(historyUrl);
    if (!parseResult?.engine) {
      return false;
    }

    // Here we check that the user typed all or part of the search string in the
    // search history result.
    let terms = parseResult.terms.toLowerCase();
    if (
      this._searchTokens.length &&
      this._searchTokens.every(token => !terms.includes(token.value))
    ) {
      return false;
    }

    // The URL for the search suggestion formed by the user's typed query.
    let [generatedSuggestionUrl] = UrlbarUtils.getSearchQueryUrl(
      parseResult.engine,
      this._searchTokens.map(t => t.value).join(" ")
    );

    // We ignore termsParameterName when checking for a subset because we
    // already checked that the typed query is a subset of the search history
    // query above with this._searchTokens.every(...).
    if (
      !UrlbarSearchUtils.serpsAreEquivalent(
        historyUrl,
        generatedSuggestionUrl,
        [parseResult.termsParameterName]
      )
    ) {
      return false;
    }

    // Turn the match into a searchengine action with a favicon.
    match.value = makeActionUrl("searchengine", {
      engineName: parseResult.engine.name,
      input: parseResult.terms,
      searchSuggestion: parseResult.terms,
      searchQuery: parseResult.terms,
      isSearchHistory: true,
    });
    match.comment = parseResult.engine.name;
    match.icon = match.icon || match.iconUrl;
    match.style = "action searchengine favicon suggestion";
    return true;
  },

  _addMatch(match) {
    if (typeof match.frecency != "number") {
      throw new Error("Frecency not provided");
    }

    if (this._addingHeuristicResult) {
      match.type = MATCH_TYPE.HEURISTIC;
    } else if (typeof match.type != "string") {
      match.type = MATCH_TYPE.GENERAL;
    }

    // A search could be canceled between a query start and its completion,
    // in such a case ensure we won't notify any result for it.
    if (!this.pending) {
      return;
    }

    match.style = match.style || "favicon";

    // Restyle past searches, unless they are bookmarks or special results.
    if (
      match.style == "favicon" &&
      (UrlbarPrefs.get("restyleSearches") || this._searchModeEngine)
    ) {
      let restyled = this._maybeRestyleSearchMatch(match);
      if (restyled && UrlbarPrefs.get("maxHistoricalSearchSuggestions") == 0) {
        // The user doesn't want search history.
        return;
      }
    }

    if (this._addingHeuristicResult) {
      match.style += " heuristic";
    }

    match.icon = match.icon || "";
    match.finalCompleteValue = match.finalCompleteValue || "";

    let { index, replace } = this._getInsertIndexForMatch(match);
    if (index == -1) {
      return;
    }
    if (replace) {
      // Replacing an existing match from the previous search.
      this._result.removeMatchAt(index);
    }
    this._result.insertMatchAt(
      index,
      match.value,
      match.comment,
      match.icon,
      match.style,
      match.finalCompleteValue
    );
    this._counts[match.type]++;

    this.notifyResult(true, match.type == MATCH_TYPE.HEURISTIC);
  },

  /**
   * Check for duplicates and either discard the duplicate or replace the
   * original match, in case the new one is more specific. For example,
   * a Remote Tab wins over History, and a Switch to Tab wins over a Remote Tab.
   * We must check both id and url for duplication, because keywords may change
   * the url by replacing the %s placeholder.
   * @param match
   * @returns {object} matchPosition
   * @returns {number} matchPosition.index
   *   The index the match should take in the results. Return -1 if the match
   *   should be discarded.
   * @returns {boolean} matchPosition.replace
   *   True if the match should replace the result already at
   *   matchPosition.index.
   *
   */
  _getInsertIndexForMatch(match) {
    let [urlMapKey, prefix, action] = makeKeyForMatch(match);
    if (
      (match.placeId && this._usedPlaceIds.has(match.placeId)) ||
      this._usedURLs.some(e => ObjectUtils.deepEqual(e.key, urlMapKey))
    ) {
      let isDupe = true;
      if (action && ["switchtab", "remotetab"].includes(action.type)) {
        // The new entry is a switch/remote tab entry, look for the duplicate
        // among current matches.
        for (let i = 0; i < this._usedURLs.length; ++i) {
          let {
            key: matchKey,
            action: matchAction,
            type: matchType,
          } = this._usedURLs[i];
          if (ObjectUtils.deepEqual(matchKey, urlMapKey)) {
            isDupe = true;
            // Don't replace the match if the existing one is heuristic and the
            // new one is a switchtab, instead also add the switchtab match.
            if (
              matchType == MATCH_TYPE.HEURISTIC &&
              action.type == "switchtab"
            ) {
              isDupe = false;
              // Since we allow to insert a dupe in this case, we must continue
              // checking the next matches to be sure we won't insert more than
              // one dupe. For this same reason we must reset isDupe = true for
              // each found dupe.
              continue;
            }
            if (!matchAction || action.type == "switchtab") {
              this._usedURLs[i] = {
                key: urlMapKey,
                action,
                type: match.type,
                prefix,
                comment: match.comment,
              };
              return { index: i, replace: true };
            }
            break; // Found the duplicate, no reason to continue.
          }
        }
      } else {
        // Dedupe with this flow:
        // 1. If the two URLs are the same, dedupe whichever is not the
        //    heuristic result.
        // 2. If they both contain www. or both do not contain it, prefer https.
        // 3. If they differ by www., send both results to the Muxer and allow
        //    it to decide based on results from other providers.
        let prefixRank = UrlbarUtils.getPrefixRank(prefix);
        for (let i = 0; i < this._usedURLs.length; ++i) {
          if (!this._usedURLs[i]) {
            // This is true when the result at [i] is a searchengine result.
            continue;
          }

          let {
            key: existingKey,
            prefix: existingPrefix,
            type: existingType,
          } = this._usedURLs[i];

          let existingPrefixRank = UrlbarUtils.getPrefixRank(existingPrefix);
          if (ObjectUtils.deepEqual(existingKey, urlMapKey)) {
            isDupe = true;

            if (prefix == existingPrefix) {
              // The URLs are identical. Throw out the new result, unless it's
              // the heuristic.
              if (match.type != MATCH_TYPE.HEURISTIC) {
                break; // Replace match.
              } else {
                this._usedURLs[i] = {
                  key: urlMapKey,
                  action,
                  type: match.type,
                  prefix,
                  comment: match.comment,
                };
                return { index: i, replace: true };
              }
            }

            if (prefix.endsWith("www.") == existingPrefix.endsWith("www.")) {
              // The results differ only by protocol.

              if (match.type == MATCH_TYPE.HEURISTIC) {
                isDupe = false;
                continue;
              }

              if (prefixRank <= existingPrefixRank) {
                break; // Replace match.
              } else if (existingType != MATCH_TYPE.HEURISTIC) {
                this._usedURLs[i] = {
                  key: urlMapKey,
                  action,
                  type: match.type,
                  prefix,
                  comment: match.comment,
                };
                return { index: i, replace: true };
              } else {
                isDupe = false;
                continue;
              }
            } else {
              // We have two identical URLs that differ only by www. We need to
              // be sure what the heuristic result is before deciding how we
              // should dedupe. We mark these as non-duplicates and let the
              // muxer handle it.
              isDupe = false;
              continue;
            }
          }
        }
      }

      // Discard the duplicate.
      if (isDupe) {
        return { index: -1, replace: false };
      }
    }

    // Add this to our internal tracker to ensure duplicates do not end up in
    // the result.
    // Not all entries have a place id, thus we fallback to the url for them.
    // We cannot use only the url since keywords entries are modified to
    // include the search string, and would be returned multiple times.  Ids
    // are faster too.
    if (match.placeId) {
      this._usedPlaceIds.add(match.placeId);
    }

    let index = 0;
    if (!this._buckets) {
      this._buckets = [];
      this._makeBuckets(UrlbarPrefs.get("resultGroups"), this._maxResults);
    }

    let replace = 0;
    for (let bucket of this._buckets) {
      // Move to the next bucket if the match type is incompatible, or if there
      // is no available space or if the frecency is below the threshold.
      if (match.type != bucket.type || !bucket.available) {
        index += bucket.count;
        continue;
      }

      index += bucket.insertIndex;
      bucket.available--;
      if (bucket.insertIndex < bucket.count) {
        replace = true;
      } else {
        bucket.count++;
      }
      bucket.insertIndex++;
      break;
    }
    this._usedURLs[index] = {
      key: urlMapKey,
      action,
      type: match.type,
      prefix,
      comment: match.comment || "",
    };
    return { index, replace };
  },

  _makeBuckets(resultBucket, maxResultCount) {
    if (!resultBucket.children) {
      let type;
      switch (resultBucket.group) {
        case UrlbarUtils.RESULT_GROUP.FORM_HISTORY:
        case UrlbarUtils.RESULT_GROUP.REMOTE_SUGGESTION:
        case UrlbarUtils.RESULT_GROUP.TAIL_SUGGESTION:
          type = MATCH_TYPE.SUGGESTION;
          break;
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_AUTOFILL:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_EXTENSION:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_FALLBACK:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_OMNIBOX:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_SEARCH_TIP:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_TEST:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_TOKEN_ALIAS_ENGINE:
        case UrlbarUtils.RESULT_GROUP.HEURISTIC_UNIFIED_COMPLETE:
          type = MATCH_TYPE.HEURISTIC;
          break;
        case UrlbarUtils.RESULT_GROUP.OMNIBOX:
          type = MATCH_TYPE.EXTENSION;
          break;
        default:
          type = MATCH_TYPE.GENERAL;
          break;
      }
      if (this._buckets.length) {
        let last = this._buckets[this._buckets.length - 1];
        if (last.type == type) {
          return;
        }
      }
      // - `available` is the number of available slots in the bucket
      // - `insertIndex` is the index of the first available slot in the bucket
      // - `count` is the number of matches in the bucket, note that it also
      //   accounts for matches from the previous search, while `available` and
      //   `insertIndex` don't.
      this._buckets.push({
        type,
        available: maxResultCount,
        insertIndex: 0,
        count: 0,
      });
      return;
    }

    let childMaxResultCount = Math.min(
      typeof resultBucket.maxResultCount == "number"
        ? resultBucket.maxResultCount
        : this._maxResults,
      maxResultCount
    );
    for (let child of resultBucket.children) {
      this._makeBuckets(child, childMaxResultCount);
    }
  },

  _addAutofillMatch(
    autofilledValue,
    finalCompleteValue,
    frecency = Infinity,
    extraStyles = []
  ) {
    // The match's comment is only for display.  Set it to finalCompleteValue,
    // the actual URL that will be visited when the user chooses the match, so
    // that the user knows exactly where the match will take them.  To make it
    // look a little nicer, remove "http://", and if the user typed a host
    // without a trailing slash, remove any trailing slash, too.
    let [comment] = stripPrefixAndTrim(finalCompleteValue, {
      stripHttp: true,
      trimEmptyQuery: true,
      trimSlash: !this._searchString.includes("/"),
    });

    this._addMatch({
      value: this._strippedPrefix + autofilledValue,
      finalCompleteValue,
      comment,
      frecency,
      style: ["autofill"].concat(extraStyles).join(" "),
      icon: iconHelper(finalCompleteValue),
    });
  },

  _addFilteredQueryMatch(row) {
    let placeId = row.getResultByIndex(QUERYINDEX_PLACEID);
    let url = row.getResultByIndex(QUERYINDEX_URL);
    let openPageCount = row.getResultByIndex(QUERYINDEX_SWITCHTAB) || 0;
    let historyTitle = row.getResultByIndex(QUERYINDEX_TITLE) || "";
    let bookmarked = row.getResultByIndex(QUERYINDEX_BOOKMARKED);
    let bookmarkTitle = bookmarked
      ? row.getResultByIndex(QUERYINDEX_BOOKMARKTITLE)
      : null;
    let tags = row.getResultByIndex(QUERYINDEX_TAGS) || "";
    let frecency = row.getResultByIndex(QUERYINDEX_FRECENCY);

    let match = {
      placeId,
      value: url,
      comment: bookmarkTitle || historyTitle,
      icon: iconHelper(url),
      frecency: frecency || FRECENCY_DEFAULT,
    };

    if (
      this._enableActions &&
      openPageCount > 0 &&
      this.hasBehavior("openpage")
    ) {
      if (this._currentPage == match.value) {
        // Don't suggest switching to the current tab.
        return;
      }
      // Actions are enabled and the page is open.  Add a switch-to-tab result.
      match.value = makeActionUrl("switchtab", { url: match.value });
      match.style = "action switchtab";
    } else if (
      this.hasBehavior("history") &&
      !this.hasBehavior("bookmark") &&
      !tags
    ) {
      // The consumer wants only history and not bookmarks and there are no
      // tags.  We'll act as if the page is not bookmarked.
      match.style = "favicon";
    } else if (tags) {
      // Store the tags in the title.  It's up to the consumer to extract them.
      match.comment += UrlbarUtils.TITLE_TAGS_SEPARATOR + tags;
      // If we're not suggesting bookmarks, then this shouldn't display as one.
      match.style = this.hasBehavior("bookmark") ? "bookmark-tag" : "tag";
    } else if (bookmarked) {
      match.style = "bookmark";
    }

    this._addMatch(match);
  },

  /**
   * @return a string consisting of the search query to be used based on the
   * previously set urlbar suggestion preferences.
   */
  get _suggestionPrefQuery() {
    let conditions = [];
    if (this._filterOnHost) {
      conditions.push("h.rev_host = get_unreversed_host(:host || '.') || '.'");
      // When filtering on a host we are in some sort of site specific search,
      // thus we want a cleaner set of results, compared to a general search.
      // This means removing less interesting urls, like redirects or
      // non-bookmarked title-less pages.

      if (UrlbarPrefs.get("restyleSearches") || this._searchModeEngine) {
        // If restyle is enabled, we want to filter out redirect targets,
        // because sources are urls built using search engines definitions that
        // we can reverse-parse.
        // In this case we can't filter on title-less pages because redirect
        // sources likely don't have a title and recognizing sources is costly.
        // Bug 468710 may help with this.
        conditions.push(`NOT EXISTS (
          WITH visits(type) AS (
            SELECT visit_type
            FROM moz_historyvisits
            WHERE place_id = h.id
            ORDER BY visit_date DESC
            LIMIT 10 /* limit to the last 10 visits */
          )
          SELECT 1 FROM visits
          WHERE type IN (5,6)
        )`);
      } else {
        // If instead restyle is disabled, we want to keep redirect targets,
        // because sources are often unreadable title-less urls.
        conditions.push(`NOT EXISTS (
          WITH visits(id) AS (
            SELECT id
            FROM moz_historyvisits
            WHERE place_id = h.id
            ORDER BY visit_date DESC
            LIMIT 10 /* limit to the last 10 visits */
            )
           SELECT 1
           FROM visits src
           JOIN moz_historyvisits dest ON src.id = dest.from_visit
           WHERE dest.visit_type IN (5,6)
        )`);
        // Filter out empty-titled pages, they could be redirect sources that
        // we can't recognize anymore because their target was wrongly expired
        // due to Bug 1664252.
        conditions.push("(h.foreign_count > 0 OR h.title NOTNULL)");
      }
    }

    if (
      this.hasBehavior("restrict") ||
      !this.hasBehavior("history") ||
      !this.hasBehavior("bookmark")
    ) {
      if (this.hasBehavior("history")) {
        // Enforce ignoring the visit_count index, since the frecency one is much
        // faster in this case.  ANALYZE helps the query planner to figure out the
        // faster path, but it may not have up-to-date information yet.
        conditions.push("+h.visit_count > 0");
      }
      if (this.hasBehavior("bookmark")) {
        conditions.push("bookmarked");
      }
      if (this.hasBehavior("tag")) {
        conditions.push("tags NOTNULL");
      }
    }

    return defaultQuery(conditions.join(" AND "));
  },

  get _emptySearchDefaultBehavior() {
    // Further restrictions to apply for "empty searches" (searching for
    // "").  The empty behavior is typed history, if history is enabled.
    // Otherwise, it is bookmarks, if they are enabled. If both history and
    // bookmarks are disabled, it defaults to open pages.
    let val = Ci.mozIPlacesAutoComplete.BEHAVIOR_RESTRICT;
    if (UrlbarPrefs.get("suggest.history")) {
      val |= Ci.mozIPlacesAutoComplete.BEHAVIOR_HISTORY;
    } else if (UrlbarPrefs.get("suggest.bookmark")) {
      val |= Ci.mozIPlacesAutoComplete.BEHAVIOR_BOOKMARK;
    } else {
      val |= Ci.mozIPlacesAutoComplete.BEHAVIOR_OPENPAGE;
    }
    return val;
  },

  /**
   * If the user-provided string starts with a keyword that gave a heuristic
   * result, this will strip it.
   * @returns {string} The filtered search string.
   */
  get _keywordFilteredSearchString() {
    let tokens = this._searchTokens.map(t => t.value);
    if (this._firstTokenIsKeyword) {
      tokens = tokens.slice(1);
    }
    return tokens.join(" ");
  },

  /**
   * Obtains the search query to be used based on the previously set search
   * preferences (accessed by this.hasBehavior).
   *
   * @return an array consisting of the correctly optimized query to search the
   *         database with and an object containing the params to bound.
   */
  get _searchQuery() {
    let params = {
      parent: PlacesUtils.tagsFolderId,
      query_type: QUERYTYPE_FILTERED,
      matchBehavior: this._matchBehavior,
      searchBehavior: this._behavior,
      // We only want to search the tokens that we are left with - not the
      // original search string.
      searchString: this._keywordFilteredSearchString,
      userContextId: this._userContextId,
      // Limit the query to the the maximum number of desired results.
      // This way we can avoid doing more work than needed.
      maxResults: this._maxResults,
    };
    if (this._filterOnHost) {
      params.host = this._filterOnHost;
    }
    return [this._suggestionPrefQuery, params];
  },

  /**
   * Obtains the query to search for switch-to-tab entries.
   *
   * @return an array consisting of the correctly optimized query to search the
   *         database with and an object containing the params to bound.
   */
  get _switchToTabQuery() {
    return [
      SQL_SWITCHTAB_QUERY,
      {
        query_type: QUERYTYPE_FILTERED,
        matchBehavior: this._matchBehavior,
        searchBehavior: this._behavior,
        // We only want to search the tokens that we are left with - not the
        // original search string.
        searchString: this._keywordFilteredSearchString,
        userContextId: this._userContextId,
        maxResults: this._maxResults,
      },
    ];
  },

  /**
   * Whether we should try to autoFill.
   */
  get _shouldAutofill() {
    // First of all, check for the autoFill pref.
    if (!UrlbarPrefs.get("autoFill")) {
      return false;
    }

    if (this._searchTokens.length != 1) {
      return false;
    }

    // autoFill can only cope with history, bookmarks, and about: entries.
    if (!this.hasBehavior("history") && !this.hasBehavior("bookmark")) {
      return false;
    }

    // autoFill doesn't search titles or tags.
    if (this.hasBehavior("title") || this.hasBehavior("tag")) {
      return false;
    }

    // Don't try to autofill if the search term includes any whitespace.
    // This may confuse completeDefaultIndex cause the AUTOCOMPLETE_MATCH
    // tokenizer ends up trimming the search string and returning a value
    // that doesn't match it, or is even shorter.
    if (REGEXP_SPACES.test(this._originalSearchString)) {
      return false;
    }

    if (!this._searchString.length) {
      return false;
    }

    if (this._prohibitAutoFill) {
      return false;
    }

    return true;
  },

  // The result is notified to the search listener on a timer, to chunk multiple
  // match updates together and avoid rebuilding the popup at every new match.
  _notifyTimer: null,

  /**
   * Notifies the current result to the listener.
   *
   * @param searchOngoing
   *        Indicates whether the search result should be marked as ongoing.
   * @param skipDelay
   *        Whether to notify immediately.
   */
  _notifyDelaysCount: 0,
  notifyResult(searchOngoing, skipDelay = false) {
    let notify = () => {
      if (!this.pending) {
        return;
      }
      this._notifyDelaysCount = 0;
      let resultCode = this._result.matchCount
        ? "RESULT_SUCCESS"
        : "RESULT_NOMATCH";
      if (searchOngoing) {
        resultCode += "_ONGOING";
      }
      let result = this._result;
      result.setSearchResult(Ci.nsIAutoCompleteResult[resultCode]);
      this._listener.onSearchResult(this._autocompleteSearch, result);
      if (!searchOngoing) {
        // Break possible cycles.
        this._listener = null;
        this._autocompleteSearch = null;
        this.stop();
      }
    };
    if (this._notifyTimer) {
      this._notifyTimer.cancel();
    }
    // In the worst case, we may get evenly spaced matches that would end up
    // delaying the UI by N_MATCHES * NOTIFYRESULT_DELAY_MS. Thus, we clamp the
    // number of times we may delay matches.
    if (skipDelay || this._notifyDelaysCount > 3) {
      notify();
    } else {
      this._notifyDelaysCount++;
      this._notifyTimer = setTimeout(notify, NOTIFYRESULT_DELAY_MS);
    }
  },
};

// UnifiedComplete class
// component @mozilla.org/autocomplete/search;1?name=unifiedcomplete

function UnifiedComplete() {
  if (UrlbarPrefs.get("usepreloadedtopurls.enabled")) {
    // force initializing the profile age check
    // to ensure the off-main-thread-IO happens ASAP
    // and we don't have to wait for it when doing an autocomplete lookup
    ProfileAgeCreatedPromise;

    fetch("chrome://global/content/unifiedcomplete-top-urls.json")
      .then(response => response.json())
      .then(sites => PreloadedSiteStorage.populate(sites))
      .catch(ex => Cu.reportError(ex));
  }
}

UnifiedComplete.prototype = {
  // Database handling

  /**
   * Promise resolved when the database initialization has completed, or null
   * if it has never been requested.
   */
  _promiseDatabase: null,

  /**
   * Gets a Sqlite database handle.
   *
   * @return {Promise}
   * @resolves to the Sqlite database handle (according to Sqlite.jsm).
   * @rejects javascript exception.
   */
  getDatabaseHandle() {
    if (!this._promiseDatabase) {
      this._promiseDatabase = (async () => {
        let conn = await PlacesUtils.promiseLargeCacheDBConnection();

        // We don't catch exceptions here as it is too late to block shutdown.
        Sqlite.shutdown.addBlocker("Places UnifiedComplete.js closing", () => {
          // Break a possible cycle through the
          // previous result, the controller and
          // ourselves.
          this._currentSearch = null;
        });

        return conn;
      })().catch(ex => {
        dump("Couldn't get database handle: " + ex + "\n");
        Cu.reportError(ex);
      });
    }
    return this._promiseDatabase;
  },

  // mozIPlacesAutoComplete

  populatePreloadedSiteStorage(json) {
    PreloadedSiteStorage.populate(json);
  },

  /**
   * This is a wrapper around startSearch, with a better interface towards
   * Quantum Bar. Long term this provider should be migrated to new separate
   * providers and this won't be necessary
   * @param {UrlbarQueryContext} queryContext
   *        The context for the current search.
   * @param {Function} onAutocompleteResult
   *        A callback to notify each result to.
   */
  startQuery(queryContext, onAutocompleteResult) {
    let deferred = PromiseUtils.defer();
    let listener = {
      onSearchResult(_, result) {
        let done =
          [
            Ci.nsIAutoCompleteResult.RESULT_IGNORED,
            Ci.nsIAutoCompleteResult.RESULT_FAILURE,
            Ci.nsIAutoCompleteResult.RESULT_NOMATCH,
            Ci.nsIAutoCompleteResult.RESULT_SUCCESS,
          ].includes(result.searchResult) || result.errorDescription;
        onAutocompleteResult(result);
        if (done) {
          deferred.resolve();
        }
      },
    };
    this.startSearch(
      queryContext.searchString,
      "",
      null,
      listener,
      queryContext
    );
    this._deferred = deferred;
    return this._deferred.promise;
  },

  // nsIAutoCompleteSearch

  startSearch(
    searchString,
    searchParam,
    acPreviousResult,
    listener,
    queryContext
  ) {
    // Stop the search in case the controller has not taken care of it.
    if (this._currentSearch) {
      this.stopSearch();
    }

    let search = (this._currentSearch = new Search(
      searchString,
      searchParam,
      listener,
      this,
      queryContext
    ));
    this.getDatabaseHandle()
      .then(conn => search.execute(conn))
      .catch(ex => {
        dump(`Query failed: ${ex}\n`);
        Cu.reportError(ex);
      })
      .then(() => {
        if (search == this._currentSearch) {
          this.finishSearch(true);
        }
      });
  },

  stopSearch() {
    if (this._currentSearch) {
      this._currentSearch.stop();
    }
    if (this._deferred) {
      this._deferred.resolve();
    }
    // Don't notify since we are canceling this search.  This also means we
    // won't fire onSearchComplete for this search.
    this.finishSearch();
  },

  /**
   * Properly cleans up when searching is completed.
   *
   * @param notify [optional]
   *        Indicates if we should notify the AutoComplete listener about our
   *        results or not.
   */
  finishSearch(notify = false) {
    // Clear state now to avoid race conditions, see below.
    let search = this._currentSearch;
    if (!search) {
      return;
    }
    this._lastLowResultsSearchSuggestion =
      search._lastLowResultsSearchSuggestion;

    if (!notify || !search.pending) {
      return;
    }

    // There is a possible race condition here.
    // When a search completes it calls finishSearch that notifies results
    // here.  When the controller gets the last result it fires
    // onSearchComplete.
    // If onSearchComplete immediately starts a new search it will set a new
    // _currentSearch, and on return the execution will continue here, after
    // notifyResult.
    // Thus, ensure that notifyResult is the last call in this method,
    // otherwise you might be touching the wrong search.
    search.notifyResult(false);
  },

  // nsIAutoCompleteSearchDescriptor

  get searchType() {
    return Ci.nsIAutoCompleteSearchDescriptor.SEARCH_TYPE_IMMEDIATE;
  },

  get clearingAutoFillSearchesAgain() {
    return true;
  },

  // nsISupports

  classID: Components.ID("f964a319-397a-4d21-8be6-5cdd1ee3e3ae"),

  QueryInterface: ChromeUtils.generateQI([
    "nsIAutoCompleteSearch",
    "nsIAutoCompleteSearchDescriptor",
    "mozIPlacesAutoComplete",
    "nsIObserver",
    "nsISupportsWeakReference",
  ]),
};

var EXPORTED_SYMBOLS = ["UnifiedComplete"];
