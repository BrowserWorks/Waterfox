/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Unit test for Bug 438861 - Previous search results not returned to multiple
 * searches.
 */


/**
 * Dummy nsIAutoCompleteInput source that returns
 * the given list of AutoCompleteSearch names.
 *
 * Implements only the methods needed for this test.
 */
function AutoCompleteInput(aSearches) {
  this.searches = aSearches;
}
AutoCompleteInput.prototype = {
  constructor: AutoCompleteInput,

  // Array of AutoCompleteSearch names
  searches: null,

  minResultsForPopup: 0,
  timeout: 10,
  searchParam: "",
  textValue: "",
  disableAutoComplete: false,
  completeDefaultIndex: false,

  get searchCount() {
    return this.searches.length;
  },

  getSearchAt: function(aIndex) {
    return this.searches[aIndex];
  },

  onSearchBegin: function() {},
  onSearchComplete: function() {},

  popupOpen: false,

  popup: {
    setSelectedIndex: function(aIndex) {},
    invalidate: function() {},

    // nsISupports implementation
    QueryInterface: function(iid) {
      if (iid.equals(Ci.nsISupports) ||
          iid.equals(Ci.nsIAutoCompletePopup))
        return this;

      throw Components.results.NS_ERROR_NO_INTERFACE;
    }
  },

  // nsISupports implementation
  QueryInterface: function(iid) {
    if (iid.equals(Ci.nsISupports) ||
        iid.equals(Ci.nsIAutoCompleteInput))
      return this;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  }
}



/**
 * nsIAutoCompleteResult implementation
 */
function AutoCompleteResult(aValues, aComments, aStyles) {
  this._values = aValues;
  this._comments = aComments;
  this._styles = aStyles;
  if (this._values.length > 0) {
    this.searchResult = Ci.nsIAutoCompleteResult.RESULT_SUCCESS;
  } else {
    this.searchResult = Ci.nsIAutoCompleteResult.NOMATCH;
  }
}
AutoCompleteResult.prototype = {
  constructor: AutoCompleteResult,

  // Arrays
  _values: null,
  _comments: null,
  _styles: null,

  searchString: "",
  searchResult: null,

  defaultIndex: 0,

  get matchCount() {
    return this._values.length;
  },

  getValueAt: function(aIndex) {
    return this._values[aIndex];
  },

  getLabelAt: function(aIndex) {
    return this.getValueAt(aIndex);
  },

  getCommentAt: function(aIndex) {
    return this._comments[aIndex];
  },

  getStyleAt: function(aIndex) {
    return this._styles[aIndex];
  },

  getImageAt: function(aIndex) {
    return "";
  },

  getFinalCompleteValueAt: function(aIndex) {
    return this.getValueAt(aIndex);
  },

  removeValueAt: function (aRowIndex, aRemoveFromDb) {},

  // nsISupports implementation
  QueryInterface: function(iid) {
    if (iid.equals(Ci.nsISupports) ||
        iid.equals(Ci.nsIAutoCompleteResult))
      return this;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  }
}


/**
 * nsIAutoCompleteSearch implementation that always returns
 * the same result set.
 */
function AutoCompleteSearch(aName, aResult) {
  this.name = aName;
  this._result = aResult;
}
AutoCompleteSearch.prototype = {
  constructor: AutoCompleteSearch,

  // Search name. Used by AutoCompleteController
  name: null,

  // AutoCompleteResult
  _result: null,

  _previousResult: null,


  /**
   * Return the same result set for every search
   */
  startSearch: function(aSearchString,
                        aSearchParam,
                        aPreviousResult,
                        aListener)
  {
    this._previousResult = aPreviousResult;
    aListener.onSearchResult(this, this._result);
  },

  stopSearch: function() {},

  // nsISupports implementation
  QueryInterface: function(iid) {
    if (iid.equals(Ci.nsISupports) ||
        iid.equals(Ci.nsIFactory) ||
        iid.equals(Ci.nsIAutoCompleteSearch))
      return this;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  // nsIFactory implementation
  createInstance: function(outer, iid) {
    return this.QueryInterface(iid);
  }
}


/**
 * Helper to register an AutoCompleteSearch with the given name.
 * Allows the AutoCompleteController to find the search.
 */
function registerAutoCompleteSearch(aSearch) {
  var name = "@mozilla.org/autocomplete/search;1?name=" + aSearch.name;

  var uuidGenerator = Cc["@mozilla.org/uuid-generator;1"].
                      getService(Ci.nsIUUIDGenerator);
  var cid = uuidGenerator.generateUUID();

  var desc = "Test AutoCompleteSearch";

  var componentManager = Components.manager
                                   .QueryInterface(Ci.nsIComponentRegistrar);
  componentManager.registerFactory(cid, desc, name, aSearch);

  // Keep the id on the object so we can unregister later
  aSearch.cid = cid;
}


/**
 * Helper to unregister an AutoCompleteSearch.
 */
function unregisterAutoCompleteSearch(aSearch) {
  var componentManager = Components.manager
                                   .QueryInterface(Ci.nsIComponentRegistrar);
  componentManager.unregisterFactory(aSearch.cid, aSearch);
}


/**
 */
function run_test() {
  // Make an AutoCompleteSearch that always returns nothing
  var search1 = new AutoCompleteSearch("test-previous-result1",
    new AutoCompleteResult(["hello1"], [""], [""]));

  var search2 = new AutoCompleteSearch("test-previous-result2",
    new AutoCompleteResult(["hello2"], [""], [""]));

  // Register search so AutoCompleteController can find them
  registerAutoCompleteSearch(search1);
  registerAutoCompleteSearch(search2);

  var controller = Components.classes["@mozilla.org/autocomplete/controller;1"].
                   getService(Components.interfaces.nsIAutoCompleteController);

  // Make an AutoCompleteInput that uses our search
  // and confirms results on search complete
  var input = new AutoCompleteInput([search1.name,
                                     search2.name]);
  var numSearchesStarted = 0;

  input.onSearchBegin = function() {
    numSearchesStarted++;
  };

  input.onSearchComplete = function() {
    do_check_eq(controller.searchStatus,
                Ci.nsIAutoCompleteController.STATUS_COMPLETE_MATCH);
    do_check_eq(controller.matchCount, 2);

    if (numSearchesStarted == 1) {
      do_check_eq(search1._previousResult, null);
      do_check_eq(search2._previousResult, null);

      // Now start it again
      controller.startSearch("test");
      return;
    }
    do_check_neq(search1._previousResult, null);
    do_check_neq(search2._previousResult, null);

    // Unregister searches
    unregisterAutoCompleteSearch(search1);
    unregisterAutoCompleteSearch(search2);

    do_test_finished();
  };

  controller.input = input;

  // Search is asynchronous, so don't let the test finish immediately
  do_test_pending();

  controller.startSearch("test");
}
