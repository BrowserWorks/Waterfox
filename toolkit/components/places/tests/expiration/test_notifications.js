/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim: sw=2 ts=2 et lcs=trail\:.,tab\:>~ :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * What this is aimed to test:
 *
 * Ensure that History (through category cache) notifies us just once.
 */

var os = Cc["@mozilla.org/observer-service;1"].
         getService(Ci.nsIObserverService);

var gObserver = {
  notifications: 0,
  observe(aSubject, aTopic, aData) {
    this.notifications++;
  }
};
os.addObserver(gObserver, PlacesUtils.TOPIC_EXPIRATION_FINISHED);

function run_test() {
  // Set interval to a large value so we don't expire on it.
  setInterval(3600); // 1h

  PlacesTestUtils.clearHistory();

  do_timeout(2000, check_result);
  do_test_pending();
}

function check_result() {
  os.removeObserver(gObserver, PlacesUtils.TOPIC_EXPIRATION_FINISHED);
  do_check_eq(gObserver.notifications, 1);
  do_test_finished();
}
