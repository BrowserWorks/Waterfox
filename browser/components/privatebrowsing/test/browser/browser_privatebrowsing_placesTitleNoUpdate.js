/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Test to make sure that the visited page titles do not get updated inside the
// private browsing mode.
"use strict";

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/PlacesUtils.jsm");

add_task(async function test() {
  const TEST_URL = "http://mochi.test:8888/browser/browser/components/privatebrowsing/test/browser/browser_privatebrowsing_placesTitleNoUpdate.html"
  const TEST_URI = Services.io.newURI(TEST_URL);
  const TITLE_1 = "Title 1";
  const TITLE_2 = "Title 2";

  function waitForTitleChanged() {
    return new Promise(resolve => {
      let historyObserver = {
        onTitleChanged(uri, pageTitle) {
          PlacesUtils.history.removeObserver(historyObserver, false);
          resolve({uri, pageTitle});
        },
        onBeginUpdateBatch() {},
        onEndUpdateBatch() {},
        onVisit() {},
        onDeleteURI() {},
        onClearHistory() {},
        onPageChanged() {},
        onDeleteVisits() {},
        QueryInterface: XPCOMUtils.generateQI([Ci.nsINavHistoryObserver])
      };

      PlacesUtils.history.addObserver(historyObserver);
    });
  }

  await PlacesTestUtils.clearHistory();

  let tabToClose = gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser, TEST_URL);
  await waitForTitleChanged();
  is(PlacesUtils.history.getPageTitle(TEST_URI), TITLE_1, "The title matches the orignal title after first visit");

  let place = {
    uri: TEST_URI,
    title: TITLE_2,
    visits: [{
      visitDate: Date.now() * 1000,
      transitionType: Ci.nsINavHistoryService.TRANSITION_LINK
    }]
  };
  PlacesUtils.asyncHistory.updatePlaces(place, {
    handleError: () => ok(false, "Unexpected error in adding visit."),
    handleResult() { },
    handleCompletion() {}
  });

  await waitForTitleChanged();
  is(PlacesUtils.history.getPageTitle(TEST_URI), TITLE_2, "The title matches the updated title after updating visit");

  let privateWin = await BrowserTestUtils.openNewBrowserWindow({private: true});
  await BrowserTestUtils.browserLoaded(privateWin.gBrowser.addTab(TEST_URL).linkedBrowser);

  is(PlacesUtils.history.getPageTitle(TEST_URI), TITLE_2, "The title remains the same after visiting in private window");
  await PlacesTestUtils.clearHistory();

  // Cleanup
  BrowserTestUtils.closeWindow(privateWin);
  gBrowser.removeTab(tabToClose);
});

