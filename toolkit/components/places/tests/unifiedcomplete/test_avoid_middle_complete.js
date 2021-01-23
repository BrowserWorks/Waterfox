/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

add_task(async function test_prefix_space_noautofill() {
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("http://moz.org/test/"),
    transition: TRANSITION_TYPED,
  });

  info("Should not try to autoFill if search string contains a space");
  await check_autocomplete({
    search: " mo",
    autofilled: " mo",
    completed: " mo",
  });

  await cleanup();
});

add_task(async function test_trailing_space_noautofill() {
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("http://moz.org/test/"),
    transition: TRANSITION_TYPED,
  });

  info("Should not try to autoFill if search string contains a space");
  await check_autocomplete({
    search: "mo ",
    autofilled: "mo ",
    completed: "mo ",
  });

  await cleanup();
});

add_task(async function test_searchEngine_autofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("CakeSearch", {
    method: "GET",
    template: "http://cake.search/",
  });
  let engine = Services.search.getEngineByName("CakeSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info(
    "Should autoFill search engine if search string does not contains a space"
  );
  await check_autocomplete({
    search: "ca",
    autofilled: "cake.search/",
    completed: "http://cake.search/",
  });

  await cleanup();
});

add_task(async function test_searchEngine_prefix_space_noautofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("CupcakeSearch", {
    method: "GET",
    template: "http://cupcake.search/",
  });
  let engine = Services.search.getEngineByName("CupcakeSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info(
    "Should not try to autoFill search engine if search string contains a space"
  );
  await check_autocomplete({
    search: " cu",
    autofilled: " cu",
    completed: " cu",
  });

  await cleanup();
});

add_task(async function test_searchEngine_trailing_space_noautofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("BaconSearch", {
    method: "GET",
    template: "http://bacon.search/",
  });
  let engine = Services.search.getEngineByName("BaconSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info(
    "Should not try to autoFill search engine if search string contains a space"
  );
  await check_autocomplete({
    search: "ba ",
    autofilled: "ba ",
    completed: "ba ",
  });

  await cleanup();
});

add_task(async function test_searchEngine_www_noautofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("HamSearch", {
    method: "GET",
    template: "http://ham.search/",
  });
  let engine = Services.search.getEngineByName("HamSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info(
    "Should not autoFill search engine if search string contains www. but engine doesn't"
  );
  await check_autocomplete({
    search: "www.ham",
    autofilled: "www.ham",
    completed: "www.ham",
  });

  await cleanup();
});

add_task(async function test_searchEngine_different_scheme_noautofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("PieSearch", {
    method: "GET",
    template: "https://pie.search/",
  });
  let engine = Services.search.getEngineByName("PieSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info(
    "Should not autoFill search engine if search string has a different scheme."
  );
  await check_autocomplete({
    search: "http://pie",
    autofilled: "http://pie",
    completed: "http://pie",
  });

  await cleanup();
});

add_task(async function test_searchEngine_matching_prefix_autofill() {
  Services.prefs.setBoolPref("browser.urlbar.autoFill.searchEngines", true);
  await Services.search.addEngineWithDetails("BeanSearch", {
    method: "GET",
    template: "http://www.bean.search/",
  });
  let engine = Services.search.getEngineByName("BeanSearch");
  engine.addParam("q", "{searchTerms}", null);
  registerCleanupFunction(async () => Services.search.removeEngine(engine));

  info("Should autoFill search engine if search string has matching prefix.");
  await check_autocomplete({
    search: "http://www.be",
    autofilled: "http://www.bean.search/",
    completed: "http://www.bean.search/",
  });

  info("Should autoFill search engine if search string has www prefix.");
  await check_autocomplete({
    search: "www.be",
    autofilled: "www.bean.search/",
    completed: "http://www.bean.search/",
  });

  info("Should autoFill search engine if search string has matching scheme.");
  await check_autocomplete({
    search: "http://be",
    autofilled: "http://bean.search/",
    completed: "http://www.bean.search/",
  });

  await cleanup();
});

add_task(async function test_prefix_autofill() {
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("http://mozilla.org/test/"),
  });
  await PlacesTestUtils.addVisits({
    uri: NetUtil.newURI("http://moz.org/test/"),
  });

  info(
    "Should not try to autoFill in-the-middle if a search is canceled immediately"
  );
  await check_autocomplete({
    incompleteSearch: "moz",
    search: "mozi",
    autofilled: "mozilla.org/",
    completed: "http://mozilla.org/",
  });

  await cleanup();
});
