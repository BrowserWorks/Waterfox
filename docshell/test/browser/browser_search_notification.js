/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

function test() {
  waitForExplicitFinish();

  const kSearchEngineID = "test_urifixup_search_engine";
  const kSearchEngineURL = "http://localhost/?search={searchTerms}";
  Services.search.addEngineWithDetails(kSearchEngineID, "", "", "", "get",
                                       kSearchEngineURL);

  let oldDefaultEngine = Services.search.defaultEngine;
  Services.search.defaultEngine = Services.search.getEngineByName(kSearchEngineID);

  let selectedName = Services.search.defaultEngine.name;
  is(selectedName, kSearchEngineID, "Check fake search engine is selected");

  registerCleanupFunction(function() {
    if (oldDefaultEngine) {
      Services.search.defaultEngine = oldDefaultEngine;
    }
    let engine = Services.search.getEngineByName(kSearchEngineID);
    if (engine) {
      Services.search.removeEngine(engine);
    }
  });

  let tab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.selectedTab = tab;

  function observer(subject, topic, data) {
    Services.obs.removeObserver(observer, "keyword-search");
    is(topic, "keyword-search", "Got keyword-search notification");

    let engine = Services.search.defaultEngine;
    ok(engine, "Have default search engine.");
    is(engine, subject, "Notification subject is engine.");
    is("firefox health report", data, "Notification data is search term.");

    executeSoon(function cleanup() {
      gBrowser.removeTab(tab);
      finish();
    });
  }

  Services.obs.addObserver(observer, "keyword-search");

  gURLBar.value = "firefox health report";
  gURLBar.handleCommand();
}

