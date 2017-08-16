/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

function run_test() {
  run_next_test();
}

// Each of these tests a path that triggers a frecency update.  Together they
// hit all sites that update a frecency.

// InsertVisitedURIs::UpdateFrecency and History::InsertPlace
add_task(async function test_InsertVisitedURIs_UpdateFrecency_and_History_InsertPlace() {
  // InsertPlace is at the end of a path that UpdateFrecency is also on, so kill
  // two birds with one stone and expect two notifications.  Trigger the path by
  // adding a download.
  let uri = NetUtil.newURI("http://example.com/a");
  Cc["@mozilla.org/browser/download-history;1"].
    getService(Ci.nsIDownloadHistory).
    addDownload(uri);
  await Promise.all([onFrecencyChanged(uri), onFrecencyChanged(uri)]);
});

// nsNavHistory::UpdateFrecency
add_task(async function test_nsNavHistory_UpdateFrecency() {
  let bm = PlacesUtils.bookmarks;
  let uri = NetUtil.newURI("http://example.com/b");
  bm.insertBookmark(bm.unfiledBookmarksFolder, uri,
                    Ci.nsINavBookmarksService.DEFAULT_INDEX, "test");
  await onFrecencyChanged(uri);
});

// nsNavHistory::invalidateFrecencies for particular pages
add_task(async function test_nsNavHistory_invalidateFrecencies_somePages() {
  let uri = NetUtil.newURI("http://test-nsNavHistory-invalidateFrecencies-somePages.com/");
  // Bookmarking the URI is enough to add it to moz_places, and importantly, it
  // means that removePagesFromHost doesn't remove it from moz_places, so its
  // frecency is able to be changed.
  let bm = PlacesUtils.bookmarks;
  bm.insertBookmark(bm.unfiledBookmarksFolder, uri,
                    Ci.nsINavBookmarksService.DEFAULT_INDEX, "test");
  PlacesUtils.history.removePagesFromHost(uri.host, false);
  await onFrecencyChanged(uri);
});

// nsNavHistory::invalidateFrecencies for all pages
add_task(async function test_nsNavHistory_invalidateFrecencies_allPages() {
  await Promise.all([onManyFrecenciesChanged(), PlacesTestUtils.clearHistory()]);
});

// nsNavHistory::DecayFrecency and nsNavHistory::FixInvalidFrecencies
add_task(async function test_nsNavHistory_DecayFrecency_and_nsNavHistory_FixInvalidFrecencies() {
  // FixInvalidFrecencies is at the end of a path that DecayFrecency is also on,
  // so expect two notifications.  Trigger the path by making nsNavHistory
  // observe the idle-daily notification.
  PlacesUtils.history.QueryInterface(Ci.nsIObserver).
    observe(null, "idle-daily", "");
  await Promise.all([onManyFrecenciesChanged(), onManyFrecenciesChanged()]);
});

function onFrecencyChanged(expectedURI) {
  return new Promise(resolve => {
    let obs = new NavHistoryObserver();
    obs.onFrecencyChanged =
      (uri, newFrecency, guid, hidden, visitDate) => {
        PlacesUtils.history.removeObserver(obs);
        do_check_true(!!uri);
        do_check_true(uri.equals(expectedURI));
        resolve();
      };
    PlacesUtils.history.addObserver(obs);
  });
}

function onManyFrecenciesChanged() {
  return new Promise(resolve => {
    let obs = new NavHistoryObserver();
    obs.onManyFrecenciesChanged = () => {
      PlacesUtils.history.removeObserver(obs);
      do_check_true(true);
      resolve();
    };
    PlacesUtils.history.addObserver(obs);
  });
}
