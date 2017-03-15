/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* Test that user-set metadata isn't lost on engine update */

"use strict";

function run_test() {
  updateAppInfo();
  useHttpServer();

  run_next_test();
}

add_task(function* test_engineUpdate() {
  const KEYWORD = "keyword";
  const FILENAME = "engine.xml"
  const TOPIC = "browser-search-engine-modified";
  const ONE_DAY_IN_MS = 24 * 60 * 60 * 1000;

  yield asyncInit();

  let [engine] = yield addTestEngines([
    { name: "Test search engine", xmlFileName: FILENAME },
  ]);

  engine.alias = KEYWORD;
  Services.search.moveEngine(engine, 0);
  // can't have an accurate updateURL in the file since we can't know the test
  // server origin, so manually set it
  engine.wrappedJSObject._updateURL = gDataUrl + FILENAME;

  yield new Promise(resolve => {
    Services.obs.addObserver(function obs(subject, topic, data) {
      if (data == "engine-loaded") {
        let loadedEngine = subject.QueryInterface(Ci.nsISearchEngine);
        let rawEngine = loadedEngine.wrappedJSObject;
        equal(loadedEngine.alias, KEYWORD, "Keyword not cleared by update");
        equal(rawEngine.getAttr("order"), 1, "Order not cleared by update");
        Services.obs.removeObserver(obs, TOPIC, false);
        resolve();
      }
    }, TOPIC, false);

    // set last update to 8 days ago, since the default interval is 7, then
    // trigger an update
    engine.wrappedJSObject.setAttr("updateexpir", Date.now() - (ONE_DAY_IN_MS * 8));
    Services.search.QueryInterface(Components.interfaces.nsITimerCallback).notify(null);
  });
});
