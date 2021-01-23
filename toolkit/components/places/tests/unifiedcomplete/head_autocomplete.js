/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

const FRECENCY_DEFAULT = 10000;

var { ObjectUtils } = ChromeUtils.import(
  "resource://gre/modules/ObjectUtils.jsm"
);
var { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
var {
  HTTP_400,
  HTTP_401,
  HTTP_402,
  HTTP_403,
  HTTP_404,
  HTTP_405,
  HTTP_406,
  HTTP_407,
  HTTP_408,
  HTTP_409,
  HTTP_410,
  HTTP_411,
  HTTP_412,
  HTTP_413,
  HTTP_414,
  HTTP_415,
  HTTP_417,
  HTTP_500,
  HTTP_501,
  HTTP_502,
  HTTP_503,
  HTTP_504,
  HTTP_505,
  HttpError,
  HttpServer,
} = ChromeUtils.import("resource://testing-common/httpd.js");

// Import common head.
{
  /* import-globals-from ../head_common.js */
  let commonFile = do_get_file("../head_common.js", false);
  let uri = Services.io.newFileURI(commonFile);
  Services.scriptloader.loadSubScript(uri.spec, this);
}

// Add a lazy getter for common autofill test tasks used by some tests.
{
  /* import-globals-from ./autofill_tasks.js */
  let file = do_get_file("autofill_tasks.js", false);
  let uri = Services.io.newFileURI(file);
  XPCOMUtils.defineLazyScriptGetter(this, "addAutofillTasks", uri.spec);
}

// Put any other stuff relative to this test folder below.

XPCOMUtils.defineLazyModuleGetters(this, {
  UrlbarPrefs: "resource:///modules/UrlbarPrefs.jsm",
  UrlbarProviderOpenTabs: "resource:///modules/UrlbarProviderOpenTabs.jsm",
  UrlbarTokenizer: "resource:///modules/UrlbarTokenizer.jsm",
  UrlbarUtils: "resource:///modules/UrlbarUtils.jsm",
});

const { AddonTestUtils } = ChromeUtils.import(
  "resource://testing-common/AddonTestUtils.jsm"
);
AddonTestUtils.init(this, false);
AddonTestUtils.createAppInfo(
  "xpcshell@tests.mozilla.org",
  "XPCShell",
  "42",
  "42"
);

add_task(async function setup() {
  await AddonTestUtils.promiseStartupManager();
});

async function cleanup() {
  Services.prefs.clearUserPref("browser.urlbar.autoFill");
  Services.prefs.clearUserPref("browser.urlbar.autoFill.searchEngines");
  let suggestPrefs = ["history", "bookmark", "openpage", "searches"];
  for (let type of suggestPrefs) {
    Services.prefs.clearUserPref("browser.urlbar.suggest." + type);
  }
  Services.prefs.clearUserPref("browser.search.suggest.enabled");
  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
}
registerCleanupFunction(cleanup);

/**
 * @param {Array} aSearches Array of AutoCompleteSearch names.
 */
function AutoCompleteInput(aSearches) {
  this.searches = aSearches;
}
AutoCompleteInput.prototype = {
  popup: {
    selectedIndex: -1,
    invalidate() {},
    QueryInterface: ChromeUtils.generateQI([Ci.nsIAutoCompletePopup]),
  },
  popupOpen: false,

  disableAutoComplete: false,
  completeDefaultIndex: true,
  completeSelectedIndex: true,
  forceComplete: false,

  minResultsForPopup: 0,
  maxRows: 0,

  timeout: 10,
  searchParam: "",

  get searchCount() {
    return this.searches.length;
  },
  getSearchAt(aIndex) {
    return this.searches[aIndex];
  },

  textValue: "",
  // Text selection range
  _selStart: 0,
  _selEnd: 0,
  get selectionStart() {
    return this._selStart;
  },
  get selectionEnd() {
    return this._selEnd;
  },
  selectTextRange(aStart, aEnd) {
    this._selStart = aStart;
    this._selEnd = aEnd;
  },

  onSearchBegin() {},
  onSearchComplete() {},

  onTextEntered: () => false,
  onTextReverted: () => false,

  QueryInterface: ChromeUtils.generateQI([Ci.nsIAutoCompleteInput]),
};

/**
 * A helper for check_autocomplete to check a specific match against data from
 * the controller.
 *
 * @param {Object} match The expected match for the result, in the following form:
 * {
 *   uri: {String|nsIURI} The expected uri. Note: nsIURI should be considered
 *        deprecated.
 *   title: {String} The title of the entry.
 *   tags: {String} The tags for the entry.
 *   style: {Array} The style of the entry.
 * }
 * @param {Object} result The result to compare the result against with the same
 *                        properties as the match param.
 * @returns {boolean} Returns true if the result matches.
 */
async function _check_autocomplete_matches(match, result) {
  let { uri, tags, style } = match;
  if (uri instanceof Ci.nsIURI) {
    uri = uri.spec;
  }
  let title = match.comment || match.title;

  if (tags) {
    title += UrlbarUtils.TITLE_TAGS_SEPARATOR + tags.sort().join(", ");
  }
  if (style) {
    style = style.sort();
  } else {
    style = ["favicon"];
  }

  let actual = { value: result.value, comment: result.comment };
  let expected = { value: match.value || uri, comment: title };
  info(
    `Checking match: ` +
      `actual=${JSON.stringify(actual)} ... ` +
      `expected=${JSON.stringify(expected)}`
  );

  let actualAction = PlacesUtils.parseActionUrl(actual.value);
  let expectedAction = PlacesUtils.parseActionUrl(expected.value);
  if (actualAction && expectedAction) {
    if (!ObjectUtils.deepEqual(actualAction, expectedAction)) {
      return false;
    }
  } else if (actual.value != expected.value) {
    return false;
  }

  if (actual.comment != expected.comment) {
    return false;
  }

  let actualStyle = result.style.split(/\s+/).sort();
  if (style) {
    Assert.equal(
      actualStyle.toString(),
      style.toString(),
      "Match should have expected style"
    );
  }
  if (uri && uri.startsWith("moz-action:")) {
    Assert.ok(
      actualStyle.includes("action"),
      "moz-action results should always have 'action' in their style"
    );
  }

  if (match.icon) {
    await compareFavicons(
      result.image,
      match.icon,
      "Match should have the expected icon"
    );
  }

  return true;
}

/**
 * Helper function to test an autocomplete entry and check the resultant matches.
 *
 * @param {Object} test An object representing the test to run, in the following form:
 * {
 *   search: {String} The string to enter for autocompleting.
 *   searchParam: {String} The search parameters to apply to the
 *                         autocomplete search.
 *   matches: {Object[]} The expected results in match format. see
 *                       _check_autocomplete_matches.
 * }
 */
async function check_autocomplete(test) {
  // At this point frecency could still be updating due to latest pages
  // updates.
  // This is not a problem in real life, but autocomplete tests should
  // return reliable resultsets, thus we have to wait.
  await PlacesTestUtils.promiseAsyncUpdates();

  // Make an AutoCompleteInput that uses our searches and confirms results.
  let input = test.input || new AutoCompleteInput(["unifiedcomplete"]);
  input.textValue = test.search;

  if (test.searchParam) {
    input.searchParam = test.searchParam;
  }

  // Caret must be at the end for autoFill to happen.
  let strLen = test.search.length;
  input.selectTextRange(strLen, strLen);
  Assert.equal(input.selectionStart, strLen, "Selection starts at end");
  Assert.equal(input.selectionEnd, strLen, "Selection ends at the end");

  let controller = Cc["@mozilla.org/autocomplete/controller;1"].getService(
    Ci.nsIAutoCompleteController
  );
  controller.input = input;

  let numSearchesStarted = 0;
  input.onSearchBegin = () => {
    info("onSearchBegin received");
    numSearchesStarted++;
  };
  let searchCompletePromise = new Promise(resolve => {
    input.onSearchComplete = () => {
      info("onSearchComplete received");
      resolve();
    };
  });
  let expectedSearches = 1;
  if (test.incompleteSearch) {
    controller.startSearch(test.incompleteSearch);
    expectedSearches++;
  }

  info("Searching for: '" + test.search + "'");
  controller.startSearch(test.search);
  await searchCompletePromise;

  Assert.equal(numSearchesStarted, expectedSearches, "All searches started");

  // Check to see the expected uris and titles match up. If 'enable-actions'
  // is specified, we check that the first specified match is the first
  // controller value (as this is the "special" always selected item), but the
  // rest can match in any order.
  // If 'enable-actions' is not specified, they can match in any order.
  if (test.matches) {
    // Do not modify the test original matches.
    let matches = test.matches.slice();

    if (matches.length) {
      let firstIndexToCheck = 0;
      if (test.searchParam && test.searchParam.includes("enable-actions")) {
        firstIndexToCheck = 1;
        info("Checking first match is first autocomplete entry");
        let result = {
          value: controller.getValueAt(0),
          comment: controller.getCommentAt(0),
          style: controller.getStyleAt(0),
          image: controller.getImageAt(0),
        };
        info(`First match is "${result.value}", "${result.comment}"`);
        Assert.ok(
          await _check_autocomplete_matches(matches[0], result),
          "first item is correct"
        );
        info("Checking rest of the matches");
      }

      for (let i = firstIndexToCheck; i < controller.matchCount; i++) {
        let result = {
          value: controller.getValueAt(i),
          comment: controller.getCommentAt(i),
          style: controller.getStyleAt(i),
          image: controller.getImageAt(i),
        };
        info(`Actual result at index ${i}: ${JSON.stringify(result)}`);
        let lowerBound = test.checkSorting ? i : firstIndexToCheck;
        let upperBound = test.checkSorting ? i + 1 : matches.length;
        let found = false;
        for (let j = lowerBound; j < upperBound; ++j) {
          // Skip processed expected results
          if (matches[j] == undefined) {
            continue;
          }
          if (await _check_autocomplete_matches(matches[j], result)) {
            info("Got a match at index " + j + "!");
            // Make it undefined so we don't process it again
            matches[j] = undefined;
            found = true;
            break;
          }
        }

        if (!found) {
          do_throw(
            `Didn't find the current result ("${result.value}", "${result.comment}") in matches`
          );
        } // ' (Emacs syntax highlighting fix)
      }
    }

    Assert.equal(
      controller.matchCount,
      matches.length,
      "Got as many results as expected"
    );

    // If we expect results, make sure we got matches.
    Assert.equal(
      controller.searchStatus,
      matches.length
        ? Ci.nsIAutoCompleteController.STATUS_COMPLETE_MATCH
        : Ci.nsIAutoCompleteController.STATUS_COMPLETE_NO_MATCH
    );
  }

  if (test.autofilled) {
    // Check the autoFilled result.
    Assert.equal(
      input.textValue,
      test.autofilled,
      "Autofilled value is correct"
    );

    // Now force completion and check correct casing of the result.
    // This ensures the controller is able to do its magic case-preserving
    // stuff and correct replacement of the user's casing with result's one.
    controller.handleEnter(false);
    Assert.equal(input.textValue, test.completed, "Completed value is correct");
  }
  return input;
}

async function addOpenPages(aUri, aCount = 1, aUserContextId = 0) {
  for (let i = 0; i < aCount; i++) {
    await UrlbarProviderOpenTabs.registerOpenTab(aUri.spec, aUserContextId);
  }
}

async function removeOpenPages(aUri, aCount = 1, aUserContextId = 0) {
  for (let i = 0; i < aCount; i++) {
    await UrlbarProviderOpenTabs.unregisterOpenTab(aUri.spec, aUserContextId);
  }
}

/**
 * Strip prefixes from the URI that we don't care about for searching.
 *
 * @param {String} spec
 *        The text to modify.
 * @return {String} the modified spec.
 */
function stripPrefix(spec) {
  ["http://", "https://", "ftp://"].some(scheme => {
    if (spec.startsWith(scheme)) {
      spec = spec.slice(scheme.length);
      return true;
    }
    return false;
  });

  if (spec.startsWith("www.")) {
    spec = spec.slice(4);
  }
  return spec;
}

function makeActionURI(action, params) {
  let encodedParams = {};
  for (let key in params) {
    encodedParams[key] = encodeURIComponent(params[key]);
  }
  let url = "moz-action:" + action + "," + JSON.stringify(encodedParams);
  return Services.io.newURI(url);
}

// Creates a full "match" entry for a search result, suitable for passing as
// an entry to check_autocomplete.
function makeSearchMatch(input, extra = {}) {
  let params = {
    engineName: extra.engineName || "MozSearch",
    input,
    searchQuery: "searchQuery" in extra ? extra.searchQuery : input,
  };
  let style = ["action", "searchengine"];
  if ("style" in extra && Array.isArray(extra.style)) {
    style.push(...extra.style);
  }
  if (extra.heuristic) {
    style.push("heuristic");
  }
  if ("alias" in extra) {
    params.alias = extra.alias;
    style.push("alias");
  }
  if ("searchSuggestion" in extra) {
    params.searchSuggestion = extra.searchSuggestion;
    style.push("suggestion");
  }
  if ("isSearchHistory" in extra) {
    params.isSearchHistory = extra.isSearchHistory;
  }
  return {
    uri: makeActionURI("searchengine", params),
    title: params.engineName,
    style,
  };
}

// Creates a full "match" entry for a search result, suitable for passing as
// an entry to check_autocomplete.
function makeVisitMatch(input, url, extra = {}) {
  // Note that counter-intuitively, the order the object properties are defined
  // in the object passed to makeActionURI is important for check_autocomplete
  // to match them :(
  let params = {
    url,
    input,
  };
  let style = ["action", "visiturl"];
  if (extra.heuristic) {
    style.push("heuristic");
  }
  let displaySpec = Services.textToSubURI.unEscapeURIForUI(url);
  return {
    uri: makeActionURI("visiturl", params),
    title: extra.title || displaySpec,
    style,
  };
}

function makeSwitchToTabMatch(url, extra = {}) {
  let displaySpec = Services.textToSubURI.unEscapeURIForUI(url);
  return {
    uri: makeActionURI("switchtab", { url }),
    title: extra.title || displaySpec,
    style: ["action", "switchtab"],
  };
}

function makeExtensionMatch(extra = {}) {
  let style = ["action", "extension"];
  if (extra.heuristic) {
    style.push("heuristic");
  }

  return {
    uri: makeActionURI("extension", {
      content: extra.content,
      keyword: extra.keyword,
    }),
    title: extra.description,
    style,
  };
}

function makeTestServer(port = -1) {
  let httpServer = new HttpServer();
  httpServer.start(port);
  registerCleanupFunction(() => httpServer.stop(() => {}));
  return httpServer;
}

function addTestEngine(basename, httpServer = undefined) {
  httpServer = httpServer || makeTestServer();
  httpServer.registerDirectory("/", do_get_cwd());
  let dataUrl =
    "http://localhost:" + httpServer.identity.primaryPort + "/data/";

  info("Adding engine: " + basename);
  return new Promise(resolve => {
    Services.obs.addObserver(function obs(subject, topic, data) {
      let engine = subject.QueryInterface(Ci.nsISearchEngine);
      info("Observed " + data + " for " + engine.name);
      if (data != "engine-added" || engine.name != basename) {
        return;
      }

      Services.obs.removeObserver(obs, "browser-search-engine-modified");
      registerCleanupFunction(() => Services.search.removeEngine(engine));
      resolve(engine);
    }, "browser-search-engine-modified");

    info("Adding engine from URL: " + dataUrl + basename);
    Services.search.addEngine(dataUrl + basename, null, false);
  });
}

/**
 * Sets up a search engine that provides some suggestions by appending strings
 * onto the search query.
 *
 * @param   {function} suggestionsFn
 *          A function that returns an array of suggestion strings given a
 *          search string.  If not given, a default function is used.
 * @returns {nsISearchEngine} The new engine.
 */
async function addTestSuggestionsEngine(suggestionsFn = null) {
  // This port number should match the number in engine-suggestions.xml.
  let server = makeTestServer(9000);
  server.registerPathHandler("/suggest", (req, resp) => {
    // URL query params are x-www-form-urlencoded, which converts spaces into
    // plus signs, so un-convert any plus signs back to spaces.
    let searchStr = decodeURIComponent(req.queryString.replace(/\+/g, " "));
    let suggestions = suggestionsFn
      ? suggestionsFn(searchStr)
      : [searchStr].concat(["foo", "bar"].map(s => searchStr + " " + s));
    let data = [searchStr, suggestions];
    resp.setHeader("Content-Type", "application/json", false);
    resp.write(JSON.stringify(data));
  });
  let engine = await addTestEngine("engine-suggestions.xml", server);
  return engine;
}

// Ensure we have a default search engine and the keyword.enabled preference
// set.
add_task(async function ensure_search_engine() {
  // keyword.enabled is necessary for the tests to see keyword searches.
  Services.prefs.setBoolPref("keyword.enabled", true);

  // Before initializing the search service, set the geo IP url pref to a dummy
  // string.  When the search service is initialized, it contacts the URI named
  // in this pref, causing unnecessary error logs.
  let geoPref = "browser.search.geoip.url";
  Services.prefs.setCharPref(geoPref, "");
  registerCleanupFunction(() => Services.prefs.clearUserPref(geoPref));
  // Remove any existing engines before adding ours.
  for (let engine of await Services.search.getEngines()) {
    await Services.search.removeEngine(engine);
  }
  await Services.search.addEngineWithDetails("MozSearch", {
    method: "GET",
    template: "http://s.example.com/search",
  });
  let engine = Services.search.getEngineByName("MozSearch");
  await Services.search.setDefault(engine);
});
