/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var mDBConn = DBConn();

function promiseOnClearHistoryObserved() {
  return new Promise(resolve => {

    let historyObserver = {
      onBeginUpdateBatch() {},
      onEndUpdateBatch() {},
      onVisit() {},
      onTitleChanged() {},
      onDeleteURI(aURI) {},
      onPageChanged() {},
      onDeleteVisits() {},

      onClearHistory() {
        PlacesUtils.history.removeObserver(this, false);
        resolve();
      },

      QueryInterface: XPCOMUtils.generateQI([
        Ci.nsINavHistoryObserver,
      ])
    }
    PlacesUtils.history.addObserver(historyObserver);
  });
}

// This global variable is a promise object, initialized in run_test and waited
// upon in the first asynchronous test.  It is resolved when the
// "places-init-complete" notification is received. We cannot initialize it in
// the asynchronous test, because then it's too late to register the observer.
var promiseInit;

function run_test() {
  // places-init-complete is notified after run_test, and it will
  // run a first frecency fix through async statements.
  // To avoid random failures we have to run after all of this.
  promiseInit = promiseTopicObserved(PlacesUtils.TOPIC_INIT_COMPLETE);

  run_next_test();
}

add_task(async function test_history_clear() {
  await promiseInit;

  await PlacesTestUtils.addVisits([
    { uri: uri("http://typed.mozilla.org/"),
      transition: TRANSITION_TYPED },
    { uri: uri("http://link.mozilla.org/"),
      transition: TRANSITION_LINK },
    { uri: uri("http://download.mozilla.org/"),
      transition: TRANSITION_DOWNLOAD },
    { uri: uri("http://redir_temp.mozilla.org/"),
      transition: TRANSITION_REDIRECT_TEMPORARY,
      referrer: "http://link.mozilla.org/"},
    { uri: uri("http://redir_perm.mozilla.org/"),
      transition: TRANSITION_REDIRECT_PERMANENT,
      referrer: "http://link.mozilla.org/"},
  ]);

  // add a place: bookmark
  PlacesUtils.bookmarks.insertBookmark(PlacesUtils.unfiledBookmarksFolderId,
                                       uri("place:folder=4"),
                                       PlacesUtils.bookmarks.DEFAULT_INDEX,
                                       "shortcut");

  // Add an expire never annotation
  // Actually expire never annotations are removed as soon as a page is removed
  // from the database, so this should act as a normal visit.
  PlacesUtils.annotations.setPageAnnotation(uri("http://download.mozilla.org/"),
                                            "never", "never", 0,
                                            PlacesUtils.annotations.EXPIRE_NEVER);

  // Add a bookmark
  // Bookmarked page should have history cleared and frecency = -1
  PlacesUtils.bookmarks.insertBookmark(PlacesUtils.unfiledBookmarksFolderId,
                                       uri("http://typed.mozilla.org/"),
                                       PlacesUtils.bookmarks.DEFAULT_INDEX,
                                       "bookmark");

  await PlacesTestUtils.addVisits([
    { uri: uri("http://typed.mozilla.org/"),
      transition: TRANSITION_BOOKMARK },
    { uri: uri("http://frecency.mozilla.org/"),
      transition: TRANSITION_LINK },
  ]);
  await PlacesTestUtils.promiseAsyncUpdates();

  // Clear history and wait for the onClearHistory notification.
  let promiseWaitClearHistory = promiseOnClearHistoryObserved();
  PlacesUtils.history.clear();
  await promiseWaitClearHistory;

  // check browserHistory returns no entries
  do_check_eq(0, PlacesUtils.history.hasHistoryEntries);

  await promiseTopicObserved(PlacesUtils.TOPIC_EXPIRATION_FINISHED);
  await PlacesTestUtils.promiseAsyncUpdates();

  // Check that frecency for not cleared items (bookmarks) has been converted
  // to -1.
  let stmt = mDBConn.createStatement(
    "SELECT h.id FROM moz_places h WHERE h.frecency > 0 ");
  do_check_false(stmt.executeStep());
  stmt.finalize();

  stmt = mDBConn.createStatement(
    `SELECT h.id FROM moz_places h WHERE h.frecency < 0
       AND EXISTS (SELECT id FROM moz_bookmarks WHERE fk = h.id) LIMIT 1`);
  do_check_true(stmt.executeStep());
  stmt.finalize();

  // Check that all visit_counts have been brought to 0
  stmt = mDBConn.createStatement(
    "SELECT id FROM moz_places WHERE visit_count <> 0 LIMIT 1");
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that history tables are empty
  stmt = mDBConn.createStatement(
    "SELECT * FROM (SELECT id FROM moz_historyvisits LIMIT 1)");
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that all moz_places entries except bookmarks and place: have been removed
  stmt = mDBConn.createStatement(
    `SELECT h.id FROM moz_places h WHERE
       url_hash NOT BETWEEN hash('place', 'prefix_lo') AND hash('place', 'prefix_hi')
       AND NOT EXISTS (SELECT id FROM moz_bookmarks WHERE fk = h.id) LIMIT 1`);
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that we only have favicons for retained places
  stmt = mDBConn.createStatement(
    `SELECT 1
     FROM moz_pages_w_icons
     LEFT JOIN moz_places h ON url_hash = page_url_hash AND url = page_url
     WHERE h.id ISNULL`);
  do_check_false(stmt.executeStep());
  stmt.finalize();
  stmt = mDBConn.createStatement(
    `SELECT 1
     FROM moz_icons WHERE id NOT IN (
       SELECT icon_id FROM moz_icons_to_pages
     )`);
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that we only have annotations for retained places
  stmt = mDBConn.createStatement(
    `SELECT a.id FROM moz_annos a WHERE NOT EXISTS
       (SELECT id FROM moz_places WHERE id = a.place_id) LIMIT 1`);
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that we only have inputhistory for retained places
  stmt = mDBConn.createStatement(
    `SELECT i.place_id FROM moz_inputhistory i WHERE NOT EXISTS
       (SELECT id FROM moz_places WHERE id = i.place_id) LIMIT 1`);
  do_check_false(stmt.executeStep());
  stmt.finalize();

  // Check that place:uris have frecency 0
  stmt = mDBConn.createStatement(
    `SELECT h.id FROM moz_places h
     WHERE url_hash BETWEEN hash('place', 'prefix_lo')
                        AND hash('place', 'prefix_hi')
       AND h.frecency <> 0 LIMIT 1`);
  do_check_false(stmt.executeStep());
  stmt.finalize();
});
