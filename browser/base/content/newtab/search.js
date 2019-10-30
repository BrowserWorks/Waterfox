#ifdef 0
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */
#endif

var gSearch = {
  init: function () {
    if (isSearchEnabled){
      document.getElementById("newtab-search-submit")
      .addEventListener("click", e => this._contentSearchController.search(e));
      let textbox = document.getElementById("newtab-search-text");
      this._contentSearchController =
      new ContentSearchUIController(textbox, textbox.parentNode, "newtab", "newtab");
    }
    else {
      try{
        let searchFormElement = document.getElementById("newtab-search-form");
        if (searchFormElement === null){return;}
        searchFormElement.parentNode.removeChild(searchFormElement);
      }
      catch (e){}
    }
  },
};
