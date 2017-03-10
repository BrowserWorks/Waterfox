/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// IndexedDB storage constants.
const DATABASE_NAME = "abouthome";
const DATABASE_VERSION = 1;
var searchText;

// This global tracks if the page has been set up before, to prevent double inits
var gObserver = new MutationObserver(function (mutations) {
  for (let mutation of mutations) {
    // The addition of the restore session button changes our width:
    if (mutation.attributeName == "session") {
      fitToWidth();
    }
  }
});

window.addEventListener("pageshow", function () {
  // Delay search engine setup, cause browser.js::BrowserOnAboutPageLoad runs
  // later and may use asynchronous getters.
  window.gObserver.observe(document.documentElement, { attributes: true });
  window.gObserver.observe(document.getElementById("launcher"), { attributes: true });
  fitToWidth();
  setupSearch();
  window.addEventListener("resize", fitToWidth);

  var event = new CustomEvent("AboutHomeLoad", {bubbles:true});
  document.dispatchEvent(event);
});

window.addEventListener("pagehide", function() {
  window.gObserver.disconnect();
  window.removeEventListener("resize", fitToWidth);
});

window.addEventListener("keypress", ev => {
  if (ev.defaultPrevented) {
    return;
  }

  // don't focus the search-box on keypress if something other than the
  // body or document element has focus - don't want to steal input from other elements
  // Make an exception for <a> and <button> elements (and input[type=button|submit])
  // which don't usefully take keypresses anyway.
  // (except space, which is handled below)
  if (document.activeElement && document.activeElement != document.body &&
      document.activeElement != document.documentElement &&
      !["a", "button"].includes(document.activeElement.localName) &&
      !document.activeElement.matches("input:-moz-any([type=button],[type=submit])")) {
    return;
  }

  let modifiers = ev.ctrlKey + ev.altKey + ev.metaKey;
  // ignore Ctrl/Cmd/Alt, but not Shift
  // also ignore Tab, Insert, PageUp, etc., and Space
  if (modifiers != 0 || ev.charCode == 0 || ev.charCode == 32)
    return;

  searchText.focus();
  // need to send the first keypress outside the search-box manually to it
  searchText.value += ev.key;
});

function onSearchSubmit(aEvent)
{
  gContentSearchController.search(aEvent);
}


var gContentSearchController;

function setupSearch()
{
  // Set submit button label for when CSS background are disabled (e.g.
  // high contrast mode).
  document.getElementById("searchSubmit").value =
    document.body.getAttribute("dir") == "ltr" ? "\u25B6" : "\u25C0";

  // The "autofocus" attribute doesn't focus the form element
  // immediately when the element is first drawn, so the
  // attribute is also used for styling when the page first loads.
  searchText = document.getElementById("searchText");
  searchText.addEventListener("blur", function searchText_onBlur() {
    searchText.removeEventListener("blur", searchText_onBlur);
    searchText.removeAttribute("autofocus");
  });

  if (!gContentSearchController) {
    gContentSearchController =
      new ContentSearchUIController(searchText, searchText.parentNode,
                                    "abouthome", "homepage");
  }
}

function fitToWidth() {
  if (document.documentElement.scrollWidth > window.innerWidth) {
    document.body.setAttribute("narrow", "true");
  } else if (document.body.hasAttribute("narrow")) {
    document.body.removeAttribute("narrow");
    fitToWidth();
  }
}
