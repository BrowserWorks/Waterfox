/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const TEST_URL = "http://adapt.mozilla.org/";
const SEARCH_STRING = "adapt";
const SUGGEST_TYPES = ["history", "bookmark", "openpage"];

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

var os = Cc["@mozilla.org/observer-service;1"].
         getService(Ci.nsIObserverService);
var ps = Cc["@mozilla.org/preferences-service;1"].
         getService(Ci.nsIPrefBranch);

const PLACES_AUTOCOMPLETE_FEEDBACK_UPDATED_TOPIC =
  "places-autocomplete-feedback-updated";

function cleanup() {
  for (let type of SUGGEST_TYPES) {
    ps.clearUserPref("browser.urlbar.suggest." + type);
  }
}

function AutoCompleteInput(aSearches) {
  this.searches = aSearches;
}
AutoCompleteInput.prototype = {
  constructor: AutoCompleteInput,
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

  getSearchAt: function ACI_getSearchAt(aIndex) {
    return this.searches[aIndex];
  },

  onSearchComplete: function ACI_onSearchComplete() {},

  popupOpen: false,

  popup: {
    setSelectedIndex() {},
    invalidate() {},

    QueryInterface(iid) {
      if (iid.equals(Ci.nsISupports) ||
          iid.equals(Ci.nsIAutoCompletePopup))
        return this;

      throw Components.results.NS_ERROR_NO_INTERFACE;
    }
  },

  onSearchBegin() {},

  QueryInterface(iid) {
    if (iid.equals(Ci.nsISupports) ||
        iid.equals(Ci.nsIAutoCompleteInput))
      return this;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  }
}


function check_results() {
  return new Promise(resolve => {
    let controller = Cc["@mozilla.org/autocomplete/controller;1"].
                     getService(Ci.nsIAutoCompleteController);
    let input = new AutoCompleteInput(["unifiedcomplete"]);
    controller.input = input;

    input.onSearchComplete = function() {
      do_check_eq(controller.searchStatus,
                  Ci.nsIAutoCompleteController.STATUS_COMPLETE_NO_MATCH);
      do_check_eq(controller.matchCount, 0);

      PlacesUtils.bookmarks.eraseEverything().then(() => {
        cleanup();
        resolve();
      });
    };

    controller.startSearch(SEARCH_STRING);
  });
}


function addAdaptiveFeedback(aUrl, aSearch) {
  return new Promise(resolve => {
    let observer = {
      observe(aSubject, aTopic, aData) {
        os.removeObserver(observer, PLACES_AUTOCOMPLETE_FEEDBACK_UPDATED_TOPIC);
        do_timeout(0, resolve);
      }
    };
    os.addObserver(observer, PLACES_AUTOCOMPLETE_FEEDBACK_UPDATED_TOPIC);

    let thing = {
      QueryInterface: XPCOMUtils.generateQI([Ci.nsIAutoCompleteInput,
                                             Ci.nsIAutoCompletePopup,
                                             Ci.nsIAutoCompleteController]),
      get popup() { return thing; },
      get controller() { return thing; },
      popupOpen: true,
      selectedIndex: 0,
      getValueAt: () => aUrl,
      searchString: aSearch
    };

    os.notifyObservers(thing, "autocomplete-will-enter-text");
  });
}


add_task(async function test_adaptive_search_specific() {
  // Add a bookmark to our url.
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    title: "test_book",
    url: TEST_URL,
  });

  // We want to search only history.
  for (let type of SUGGEST_TYPES) {
    type == "history" ? ps.setBoolPref("browser.urlbar.suggest." + type, true)
                      : ps.setBoolPref("browser.urlbar.suggest." + type, false);
  }

  // Add an adaptive entry.
  await addAdaptiveFeedback(TEST_URL, SEARCH_STRING);

  await check_results();

  await PlacesTestUtils.promiseAsyncUpdates();
});
