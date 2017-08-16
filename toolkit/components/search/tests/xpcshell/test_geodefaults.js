/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

var requests = [];
var gServerCohort = "";

const kUrlPref = "geoSpecificDefaults.url";

const kDayInSeconds = 86400;
const kYearInSeconds = kDayInSeconds * 365;

function run_test() {
  installTestEngine();

  let srv = new HttpServer();

  srv.registerPathHandler("/lookup_defaults", (metadata, response) => {
    response.setStatusLine("1.1", 200, "OK");
    let data = {interval: kYearInSeconds,
                settings: {searchDefault: "Test search engine"}};
    if (gServerCohort)
      data.cohort = gServerCohort;
    response.write(JSON.stringify(data));
    requests.push(metadata);
  });

  srv.registerPathHandler("/lookup_fail", (metadata, response) => {
    response.setStatusLine("1.1", 404, "Not Found");
    requests.push(metadata);
  });

  srv.registerPathHandler("/lookup_unavailable", (metadata, response) => {
    response.setStatusLine("1.1", 503, "Service Unavailable");
    response.setHeader("Retry-After", kDayInSeconds.toString());
    requests.push(metadata);
  });

  srv.start(-1);
  do_register_cleanup(() => srv.stop(() => {}));

  let url = "http://localhost:" + srv.identity.primaryPort + "/lookup_defaults?";
  Services.prefs.getDefaultBranch(BROWSER_SEARCH_PREF).setCharPref(kUrlPref, url);
  // Set a bogus user value so that running the test ensures we ignore it.
  Services.prefs.setCharPref(BROWSER_SEARCH_PREF + kUrlPref, "about:blank");
  Services.prefs.setCharPref("browser.search.geoip.url",
                             'data:application/json,{"country_code": "FR"}');

  run_next_test();
}

function checkNoRequest() {
  do_check_eq(requests.length, 0);
}

function checkRequest(cohort = "") {
  do_check_eq(requests.length, 1);
  let req = requests.pop();
  do_check_eq(req._method, "GET");
  do_check_eq(req._queryString, cohort ? "/" + cohort : "");
}

add_task(async function no_request_if_prefed_off() {
  // Disable geoSpecificDefaults and check no HTTP request is made.
  Services.prefs.setBoolPref("browser.search.geoSpecificDefaults", false);
  await asyncInit();
  checkNoRequest();
  await promiseAfterCache();

  // The default engine should be set based on the prefs.
  do_check_eq(Services.search.currentEngine.name, getDefaultEngineName(false));

  // Ensure nothing related to geoSpecificDefaults has been written in the metadata.
  let metadata = await promiseGlobalMetadata();
  do_check_eq(typeof metadata.searchDefaultExpir, "undefined");
  do_check_eq(typeof metadata.searchDefault, "undefined");
  do_check_eq(typeof metadata.searchDefaultHash, "undefined");

  Services.prefs.setBoolPref("browser.search.geoSpecificDefaults", true);
});

add_task(async function should_get_geo_defaults_only_once() {
  // (Re)initializing the search service should trigger a request,
  // and set the default engine based on it.
  // Due to the previous initialization, we expect the countryCode to already be set.
  do_check_true(Services.prefs.prefHasUserValue("browser.search.countryCode"));
  do_check_eq(Services.prefs.getCharPref("browser.search.countryCode"), "FR");
  await asyncReInit();
  checkRequest();
  do_check_eq(Services.search.currentEngine.name, kTestEngineName);
  await promiseAfterCache();

  // Verify the metadata was written correctly.
  let metadata = await promiseGlobalMetadata();
  do_check_eq(typeof metadata.searchDefaultExpir, "number");
  do_check_true(metadata.searchDefaultExpir > Date.now());
  do_check_eq(typeof metadata.searchDefault, "string");
  do_check_eq(metadata.searchDefault, "Test search engine");
  do_check_eq(typeof metadata.searchDefaultHash, "string");
  do_check_eq(metadata.searchDefaultHash.length, 44);

  // The next restart shouldn't trigger a request.
  await asyncReInit();
  checkNoRequest();
  do_check_eq(Services.search.currentEngine.name, kTestEngineName);
});

add_task(async function should_request_when_countryCode_not_set() {
  Services.prefs.clearUserPref("browser.search.countryCode");
  await asyncReInit();
  checkRequest();
  await promiseAfterCache();
});

add_task(async function should_recheck_if_interval_expired() {
  await forceExpiration();

  let date = Date.now();
  await asyncReInit();
  checkRequest();
  await promiseAfterCache();

  // Check that the expiration timestamp has been updated.
  let metadata = await promiseGlobalMetadata();
  do_check_eq(typeof metadata.searchDefaultExpir, "number");
  do_check_true(metadata.searchDefaultExpir >= date + kYearInSeconds * 1000);
  do_check_true(metadata.searchDefaultExpir < date + (kYearInSeconds + 3600) * 1000);
});

add_task(async function should_recheck_when_broken_hash() {
  // This test verifies both that we ignore saved geo-defaults if the
  // hash is invalid, and that we keep the local preferences-based
  // default for all of the session in case a synchronous
  // initialization was triggered before our HTTP request completed.

  let metadata = await promiseGlobalMetadata();

  // Break the hash.
  let hash = metadata.searchDefaultHash;
  metadata.searchDefaultHash = "broken";
  await promiseSaveGlobalMetadata(metadata);

  let commitPromise = promiseAfterCache();
  let unInitPromise = waitForSearchNotification("uninit-complete");
  let reInitPromise = asyncReInit();
  await unInitPromise;

  // Synchronously check the current default engine, to force a sync init.
  // The hash is wrong, so we should fallback to the default engine from prefs.
  do_check_false(Services.search.isInitialized)
  do_check_eq(Services.search.currentEngine.name, getDefaultEngineName(false));
  do_check_true(Services.search.isInitialized)

  await reInitPromise;
  checkRequest();
  await commitPromise;

  // Check that the hash is back to its previous value.
  metadata = await promiseGlobalMetadata();
  do_check_eq(typeof metadata.searchDefaultHash, "string");
  if (metadata.searchDefaultHash == "broken") {
    // If the server takes more than 1000ms to return the result,
    // the commitPromise was resolved by a first save of the cache
    // that saved the engines, but not the request's results.
    do_print("waiting for the cache to be saved a second time");
    await promiseAfterCache();
    metadata = await promiseGlobalMetadata();
  }
  do_check_eq(metadata.searchDefaultHash, hash);

  // The current default engine shouldn't change during a session.
  do_check_eq(Services.search.currentEngine.name, getDefaultEngineName(false));

  // After another restart, the current engine should be back to the geo default,
  // without doing yet another request.
  await asyncReInit();
  checkNoRequest();
  do_check_eq(Services.search.currentEngine.name, kTestEngineName);
});

add_task(async function should_remember_cohort_id() {
  // Check that initially the cohort pref doesn't exist.
  const cohortPref = "browser.search.cohort";
  do_check_eq(Services.prefs.getPrefType(cohortPref), Services.prefs.PREF_INVALID);

  // Make the server send a cohort id.
  let cohort = gServerCohort = "xpcshell";

  // Trigger a new request.
  await forceExpiration();
  let commitPromise = promiseAfterCache();
  await asyncReInit();
  checkRequest();
  await commitPromise;

  // Check that the cohort was saved.
  do_check_eq(Services.prefs.getPrefType(cohortPref), Services.prefs.PREF_STRING);
  do_check_eq(Services.prefs.getCharPref(cohortPref), cohort);

  // Make the server stop sending the cohort.
  gServerCohort = "";

  // Check that the next request sends the previous cohort id, and
  // will remove it from the prefs due to the server no longer sending it.
  await forceExpiration();
  commitPromise = promiseAfterCache();
  await asyncReInit();
  checkRequest(cohort);
  await commitPromise;
  do_check_eq(Services.prefs.getPrefType(cohortPref), Services.prefs.PREF_INVALID);
});

add_task(async function should_retry_after_failure() {
  let defaultBranch = Services.prefs.getDefaultBranch(BROWSER_SEARCH_PREF);
  let originalUrl = defaultBranch.getCharPref(kUrlPref);
  defaultBranch.setCharPref(kUrlPref, originalUrl.replace("defaults", "fail"));

  // Trigger a new request.
  await forceExpiration();
  await asyncReInit();
  checkRequest();

  // After another restart, a new request should be triggered automatically without
  // the test having to call forceExpiration again.
  await asyncReInit();
  checkRequest();
});

add_task(async function should_honor_retry_after_header() {
  let defaultBranch = Services.prefs.getDefaultBranch(BROWSER_SEARCH_PREF);
  let originalUrl = defaultBranch.getCharPref(kUrlPref);
  defaultBranch.setCharPref(kUrlPref, originalUrl.replace("fail", "unavailable"));

  // Trigger a new request.
  await forceExpiration();
  let date = Date.now();
  let commitPromise = promiseAfterCache();
  await asyncReInit();
  checkRequest();
  await commitPromise;

  // Check that the expiration timestamp has been updated.
  let metadata = await promiseGlobalMetadata();
  do_check_eq(typeof metadata.searchDefaultExpir, "number");
  do_check_true(metadata.searchDefaultExpir >= date + kDayInSeconds * 1000);
  do_check_true(metadata.searchDefaultExpir < date + (kDayInSeconds + 3600) * 1000);

  // After another restart, a new request should not be triggered.
  await asyncReInit();
  checkNoRequest();
});
