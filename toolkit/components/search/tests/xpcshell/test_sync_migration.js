/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* Test that legacy metadata from search-metadata.json is correctly
 * transferred to the new metadata storage. */

function run_test() {
  updateAppInfo();
  installTestEngine();

  do_get_file("data/metadata.json").copyTo(gProfD, "search-metadata.json");

  run_next_test();
}

add_task(function* test_sync_metadata_migration() {
  do_check_false(Services.search.isInitialized);
  Services.search.getEngines();
  do_check_true(Services.search.isInitialized);
  yield promiseAfterCache();

  // Check that the entries are placed as specified correctly
  let metadata = yield promiseEngineMetadata();
  do_check_eq(metadata["engine"].order, 1);
  do_check_eq(metadata["engine"].alias, "foo");

  metadata = yield promiseGlobalMetadata();
  do_check_eq(metadata["searchDefaultExpir"], 1471013469846);
});
