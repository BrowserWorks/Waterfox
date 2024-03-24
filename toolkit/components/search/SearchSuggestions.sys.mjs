/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { FormAutoCompleteResult } from "resource://gre/modules/nsFormAutoCompleteResult.sys.mjs";

const lazy = {};
ChromeUtils.defineESModuleGetters(lazy, {
  FormAutoCompleteResult: "resource://gre/modules/FormAutoComplete.sys.mjs",
  FormHistoryClient: "resource://gre/modules/FormAutoComplete.sys.mjs",

  SearchSuggestionController:
    "resource://gre/modules/SearchSuggestionController.sys.mjs",
});

/**
 * SuggestAutoComplete is a base class that implements nsIAutoCompleteSearch
 * and can collect results for a given search by using this.#suggestionController.
 * We do it this way since the AutoCompleteController in Mozilla requires a
 * unique XPCOM Service for every search provider, even if the logic for two
 * providers is identical.
 *
 * @class
 */
class SuggestAutoComplete {
  constructor() {
    this.#suggestionController = new lazy.SearchSuggestionController();
    this.#suggestionController.maxLocalResults = this.#historyLimit;
  }

  /**
   * Notifies the front end of new results.
   *
   * @param {string} searchString
   *   The user's query string.
   * @param {Array} results
   *   An array of results to the search.
   * @param {object} formHistoryResult
   *   Any previous form history result.
   * @private
   */
  onResultsReady(searchString, results, formHistoryResult) {
    if (this.#listener) {
      let result = new FormAutoCompleteResult(
        searchString,
        Ci.nsIAutoCompleteResult.RESULT_SUCCESS,
        0,
        "",
        results.map(result => ({
          value: result,
          label: result,
          // We supply the comments field so that autocomplete does not kick
          // in the unescaping of the results for display which it uses for
          // urls.
          comment: result,
          removable: true,
        })),
        formHistoryResult
      );

      this.#listener.onSearchResult(this, result);

      // Null out listener to make sure we don't notify it twice
      this.#listener = null;
    }
  }

  /**
   * Initiates the search result gathering process. Part of
   * nsIAutoCompleteSearch implementation.
   *
   * @param {string} searchString
   *   The user's query string.
   * @param {string} searchParam
   *   unused, "an extra parameter"; even though this parameter and the
   *   next are unused, pass them through in case the form history
   *   service wants them
   * @param {object} previousResult
   *   unused, a client-cached store of the previous generated resultset
   *   for faster searching.
   * @param {object} listener
   *   object implementing nsIAutoCompleteObserver which we notify when
   *   results are ready.
   */
  startSearch(searchString, searchParam, previousResult, listener) {
    var formHistorySearchParam = searchParam.split("|")[0];

    // Receive the information about the privacy mode of the window to which
    // this search box belongs.  The front-end's search.xml bindings passes this
    // information in the searchParam parameter.  The alternative would have
    // been to modify nsIAutoCompleteSearch to add an argument to startSearch
    // and patch all of autocomplete to be aware of this, but the searchParam
    // argument is already an opaque argument, so this solution is hopefully
    // less hackish (although still gross.)
    var privacyMode = searchParam.split("|")[1] == "private";

    // Start search immediately if possible, otherwise once the search
    // service is initialized
    if (Services.search.isInitialized) {
      this.#triggerSearch(
        searchString,
        formHistorySearchParam,
        listener,
        privacyMode
      ).catch(console.error);
      return;
    }

    Services.search
      .init()
      .then(() => {
        this.#triggerSearch(
          searchString,
          formHistorySearchParam,
          listener,
          privacyMode
        ).catch(console.error);
      })
      .catch(result =>
        console.error(
          "Could not initialize search service, bailing out: " + result
        )
      );
  }

  /**
   * Ends the search result gathering process. Part of nsIAutoCompleteSearch
   * implementation.
   */
  stopSearch() {
    this.#suggestionController.stop();
  }

  #suggestionController;

  /**
   * Maximum number of history items displayed. This is capped at 7
   * because the primary consumer (Firefox search bar) displays 10 rows
   * by default, and so we want to leave some space for suggestions
   * to be visible.
   *
   * @type {number}
   */
  #historyLimit = 7;

  /**
   * The object implementing nsIAutoCompleteObserver that we notify when
   * we have found results.
   *
   *  @type {object|null}
   */
  #listener = null;

  /**
   * Actual implementation of search.
   *
   * @param {string} searchString
   *   The user's query string.
   * @param {string} searchParam
   *   unused
   * @param {object} listener
   *   object implementing nsIAutoCompleteObserver which we notify when
   *   results are ready.
   * @param {boolean} privacyMode
   *   True if the search was made from a private browsing mode context.
   */
  async #triggerSearch(searchString, searchParam, listener, privacyMode) {
    this.#listener = listener;
    let results = await this.#suggestionController.fetch(
      searchString,
      privacyMode,
      Services.search.defaultEngine
    );

    // Add a null check for results
    if (!results) {
      results = {
        local: [],
        remote: [],
        formHistoryResults: [],
        term: searchString
      };
    }

    // If form history has results, add them to the list.
    let finalResults = results.local.map(r => r.value);

    // If there are remote matches, add them.
    if (results.remote.length) {
      // now put the history results above the suggestions
      // We shouldn't show tail suggestions in their full-text form.
      let nonTailEntries = results.remote.filter(
        e => !e.matchPrefix && !e.tail
      );
      finalResults = finalResults.concat(nonTailEntries.map(e => e.value));
    }

    // Bug 1822297: This re-uses the wrappers from Satchel, to avoid re-writing
    // our own nsIAutoCompleteSimpleResult implementation for now. However,
    // we should do that at some stage to remove the dependency on satchel.
    let client = new lazy.FormHistoryClient({
      formField: null,
      inputName: this.#suggestionController.formHistoryParam,
    });
    let formHistoryResult = new lazy.FormAutoCompleteResult(
      client,
      results.formHistoryResults,
      this.#suggestionController.formHistoryParam,
      searchString
    );

    // Notify the FE of our new results
    this.onResultsReady(results.term, finalResults, formHistoryResult);
  }

  QueryInterface = ChromeUtils.generateQI([
    "nsIAutoCompleteSearch",
    "nsIAutoCompleteObserver",
  ]);
}

/**
 * SearchSuggestAutoComplete is a service implementation that handles suggest
 * results specific to web searches.
 *
 * @class
 */
export class SearchSuggestAutoComplete extends SuggestAutoComplete {
  classID = Components.ID("{aa892eb4-ffbf-477d-9f9a-06c995ae9f27}");
  serviceURL = "";
}
