/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;

/**
 * Dummy nsIAutoCompleteInput source that returns
 * the given list of AutoCompleteSearch names.
 *
 * Implements only the methods needed for this test.
 */
function AutoCompleteInputBase(aSearches) {
  this.searches = aSearches;
}
AutoCompleteInputBase.prototype = {

  // Array of AutoCompleteSearch names
  searches: null,

  minResultsForPopup: 0,
  timeout: 10,
  searchParam: "",
  textValue: "",
  disableAutoComplete: false,
  completeDefaultIndex: false,

  // Text selection range
  _selStart: 0,
  _selEnd: 0,
  get selectionStart() {
    return this._selStart;
  },
  get selectionEnd() {
    return this._selEnd;
  },
  selectTextRange: function(aStart, aEnd) {
    this._selStart = aStart;
    this._selEnd = aEnd;
  },

  get searchCount() {
    return this.searches.length;
  },

  getSearchAt: function(aIndex) {
    return this.searches[aIndex];
  },

  onSearchBegin: function() {},
  onSearchComplete: function() {},

  popupOpen: false,

  get popup() {
    if (!this._popup) {
      this._popup = new AutocompletePopupBase(this);
    }
    return this._popup;
  },

  // nsISupports implementation
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIAutoCompleteInput])
}

/**
 * nsIAutoCompleteResult implementation
 */
function AutoCompleteResultBase(aValues) {
  this._values = aValues;
}
AutoCompleteResultBase.prototype = {

  // Arrays
  _values: null,
  _comments: [],
  _styles: [],
  _finalCompleteValues: [],

  searchString: "",
  searchResult: null,

  defaultIndex: -1,

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
    return this._finalCompleteValues[aIndex] || this._values[aIndex];
  },

  removeValueAt: function (aRowIndex, aRemoveFromDb) {},

  // nsISupports implementation
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIAutoCompleteResult])
}

/**
 * nsIAutoCompleteSearch implementation that always returns
 * the same result set.
 */
function AutoCompleteSearchBase(aName, aResult) {
  this.name = aName;
  this._result = aResult;
}
AutoCompleteSearchBase.prototype = {

  // Search name. Used by AutoCompleteController
  name: null,

  // AutoCompleteResult
  _result: null,

  startSearch: function(aSearchString,
                        aSearchParam,
                        aPreviousResult,
                        aListener) {
    var result = this._result;

    result.searchResult = Ci.nsIAutoCompleteResult.RESULT_SUCCESS;
    aListener.onSearchResult(this, result);
  },

  stopSearch: function() {},

  // nsISupports implementation
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIFactory,
                                         Ci.nsIAutoCompleteSearch]),

  // nsIFactory implementation
  createInstance: function(outer, iid) {
    return this.QueryInterface(iid);
  }
}

function AutocompletePopupBase(input) {
  this.input = input;
}
AutocompletePopupBase.prototype = {
  selectedIndex: 0,
  invalidate() {},
  selectBy(reverse, page) {
    let numRows = this.input.controller.matchCount;
    if (numRows > 0) {
      let delta = reverse ? -1 : 1;
      this.selectedIndex = (this.selectedIndex + delta) % numRows;
      if (this.selectedIndex < 0) {
        this.selectedIndex = numRows - 1;
      }
    }
  },
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIAutoCompletePopup]),
};

/**
 * Helper to register an AutoCompleteSearch with the given name.
 * Allows the AutoCompleteController to find the search.
 */
function registerAutoCompleteSearch(aSearch) {
  var name = "@mozilla.org/autocomplete/search;1?name=" + aSearch.name;
  var cid = Cc["@mozilla.org/uuid-generator;1"].
            getService(Ci.nsIUUIDGenerator).
            generateUUID();

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

