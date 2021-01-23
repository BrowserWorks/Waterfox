/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Main tests for SearchTelemetry - general engine visiting and link clicking.
 */

"use strict";

const { SearchTelemetry } = ChromeUtils.import(
  "resource:///modules/SearchTelemetry.jsm"
);
const { ADLINK_CHECK_TIMEOUT_MS } = ChromeUtils.import(
  "resource:///actors/SearchTelemetryChild.jsm"
);

const TEST_PROVIDER_INFO = {
  example: {
    regexp: /^http:\/\/mochi.test:.+\/browser\/browser\/components\/search\/test\/browser\/searchTelemetry(?:Ad)?.html/,
    queryParam: "s",
    codeParam: "abc",
    codePrefixes: ["ff"],
    followonParams: ["a"],
    extraAdServersRegexps: [/^https:\/\/example\.com\/ad2?/],
  },
};

const SEARCH_AD_CLICK_SCALARS = [
  "browser.search.with_ads",
  "browser.search.ad_clicks",
];

function getPageUrl(useExample = false, useAdPage = false) {
  let server = useExample ? "example.com" : "mochi.test:8888";
  let page = useAdPage ? "searchTelemetryAd.html" : "searchTelemetry.html";
  return `http://${server}/browser/browser/components/search/test/browser/${page}`;
}

function getSERPUrl(page) {
  return page + "?s=test&abc=ff";
}

function getSERPFollowOnUrl(page) {
  return page + "?s=test&abc=ff&a=foo";
}

const searchCounts = Services.telemetry.getKeyedHistogramById("SEARCH_COUNTS");

async function assertTelemetry(expectedHistograms, expectedScalars) {
  let histSnapshot = {};
  let scalars = {};

  await TestUtils.waitForCondition(() => {
    histSnapshot = searchCounts.snapshot();
    return (
      Object.getOwnPropertyNames(histSnapshot).length ==
      Object.getOwnPropertyNames(expectedHistograms).length
    );
  }, "should have the correct number of histograms");

  if (Object.entries(expectedScalars).length) {
    await TestUtils.waitForCondition(() => {
      scalars =
        Services.telemetry.getSnapshotForKeyedScalars("main", false).parent ||
        {};
      return Object.getOwnPropertyNames(expectedScalars).every(
        scalar => scalar in scalars
      );
    }, "should have the expected keyed scalars");
  }

  Assert.equal(
    Object.getOwnPropertyNames(histSnapshot).length,
    Object.getOwnPropertyNames(expectedHistograms).length,
    "Should only have one key"
  );

  for (let [key, value] of Object.entries(expectedHistograms)) {
    Assert.ok(
      key in histSnapshot,
      `Histogram should have the expected key: ${key}`
    );
    Assert.equal(
      histSnapshot[key].sum,
      value,
      `Should have counted the correct number of visits for ${key}`
    );
  }

  for (let [name, value] of Object.entries(expectedScalars)) {
    Assert.ok(name in scalars, `Scalar ${name} should have been added.`);
    Assert.deepEqual(
      scalars[name],
      value,
      `Should have counted the correct number of visits for ${name}`
    );
  }

  for (let name of SEARCH_AD_CLICK_SCALARS) {
    Assert.equal(
      name in scalars,
      name in expectedScalars,
      `Should have matched ${name} in scalars and expectedScalars`
    );
  }
}

// sharedData messages are only passed to the child on idle. Therefore
// we wait for a few idles to try and ensure the messages have been able
// to be passed across and handled.
async function waitForIdle() {
  for (let i = 0; i < 10; i++) {
    await new Promise(resolve => Services.tm.idleDispatchToMainThread(resolve));
  }
}

add_task(async function setup() {
  SearchTelemetry.overrideSearchTelemetryForTests(TEST_PROVIDER_INFO);
  await waitForIdle();
  // Enable local telemetry recording for the duration of the tests.
  let oldCanRecord = Services.telemetry.canRecordExtended;
  Services.telemetry.canRecordExtended = true;
  Services.prefs.setBoolPref("browser.search.log", true);

  registerCleanupFunction(async () => {
    Services.prefs.clearUserPref("browser.search.log");
    SearchTelemetry.overrideSearchTelemetryForTests();
    Services.telemetry.canRecordExtended = oldCanRecord;
    Services.telemetry.clearScalars();
  });
});

add_task(async function test_simple_search_page_visit() {
  searchCounts.clear();

  await BrowserTestUtils.withNewTab(
    {
      gBrowser,
      url: getSERPUrl(getPageUrl()),
    },
    async () => {
      await assertTelemetry({ "example.in-content:sap:ff": 1 }, {});
    }
  );
});

add_task(async function test_simple_search_page_visit_telemetry() {
  searchCounts.clear();
  Services.telemetry.clearScalars();

  await BrowserTestUtils.withNewTab(
    {
      gBrowser,
      /* URL must not be in the cache */
      url: getSERPUrl(getPageUrl()) + `&random=${Math.random()}`,
    },
    async () => {
      let scalars = {};
      const key = "browser.search.data_transferred";

      await TestUtils.waitForCondition(() => {
        scalars =
          Services.telemetry.getSnapshotForKeyedScalars("main", false).parent ||
          {};
        return key in scalars;
      }, "should have the expected keyed scalars");

      const scalar = scalars[key];
      Assert.ok("example" in scalar, "correct telemetry category");
      Assert.notEqual(scalars[key].example, 0, "bandwidth logged");
    }
  );
});

add_task(async function test_follow_on_visit() {
  await BrowserTestUtils.withNewTab(
    {
      gBrowser,
      url: getSERPFollowOnUrl(getPageUrl()),
    },
    async () => {
      await assertTelemetry(
        {
          "example.in-content:sap:ff": 1,
          "example.in-content:sap-follow-on:ff": 1,
        },
        {}
      );
    }
  );
});

add_task(async function test_track_ad() {
  searchCounts.clear();

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    getSERPUrl(getPageUrl(false, true))
  );

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
    }
  );

  BrowserTestUtils.removeTab(tab);
});

add_task(async function test_track_ad_new_window() {
  searchCounts.clear();
  Services.telemetry.clearScalars();

  let win = await BrowserTestUtils.openNewBrowserWindow();

  let url = getSERPUrl(getPageUrl(false, true));
  await BrowserTestUtils.loadURI(win.gBrowser.selectedBrowser, url);
  await BrowserTestUtils.browserLoaded(
    win.gBrowser.selectedBrowser,
    false,
    url
  );

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
    }
  );

  await BrowserTestUtils.closeWindow(win);
});

add_task(async function test_track_ad_pages_without_ads() {
  // Note: the above tests have already checked a page with no ad-urls.
  searchCounts.clear();
  Services.telemetry.clearScalars();

  let tabs = [];

  tabs.push(
    await BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      getSERPUrl(getPageUrl(false, false))
    )
  );
  tabs.push(
    await BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      getSERPUrl(getPageUrl(false, true))
    )
  );

  await assertTelemetry(
    { "example.in-content:sap:ff": 2 },
    {
      "browser.search.with_ads": { example: 1 },
    }
  );

  for (let tab of tabs) {
    BrowserTestUtils.removeTab(tab);
  }
});

add_task(async function test_track_ad_click() {
  // Note: the above tests have already checked a page with no ad-urls.
  searchCounts.clear();
  Services.telemetry.clearScalars();

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    getSERPUrl(getPageUrl(false, true))
  );

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
    }
  );

  let pageLoadPromise = BrowserTestUtils.waitForLocationChange(gBrowser);
  await SpecialPowers.spawn(tab.linkedBrowser, [], () => {
    content.document.getElementById("ad1").click();
  });
  await pageLoadPromise;
  /* eslint-disable-next-line mozilla/no-arbitrary-setTimeout */
  await new Promise(resolve => setTimeout(resolve, ADLINK_CHECK_TIMEOUT_MS));

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
      "browser.search.ad_clicks": { example: 1 },
    }
  );

  // Now go back, and click again.
  pageLoadPromise = BrowserTestUtils.waitForLocationChange(gBrowser);
  gBrowser.goBack();
  await pageLoadPromise;
  /* eslint-disable-next-line mozilla/no-arbitrary-setTimeout */
  await new Promise(resolve => setTimeout(resolve, ADLINK_CHECK_TIMEOUT_MS));

  // We've gone back, so we register an extra display & if it is with ads or not.
  await assertTelemetry(
    { "example.in-content:sap:ff": 2 },
    {
      "browser.search.with_ads": { example: 2 },
      "browser.search.ad_clicks": { example: 1 },
    }
  );

  pageLoadPromise = BrowserTestUtils.waitForLocationChange(gBrowser);
  await SpecialPowers.spawn(tab.linkedBrowser, [], () => {
    content.document.getElementById("ad1").click();
  });
  await pageLoadPromise;
  /* eslint-disable-next-line mozilla/no-arbitrary-setTimeout */
  await new Promise(resolve => setTimeout(resolve, ADLINK_CHECK_TIMEOUT_MS));

  await assertTelemetry(
    { "example.in-content:sap:ff": 2 },
    {
      "browser.search.with_ads": { example: 2 },
      "browser.search.ad_clicks": { example: 2 },
    }
  );

  BrowserTestUtils.removeTab(tab);
});

add_task(async function test_track_ad_click_with_location_change_other_tab() {
  searchCounts.clear();
  Services.telemetry.clearScalars();
  const url = getSERPUrl(getPageUrl(false, true));
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, url);

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
    }
  );

  const newTab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "https://example.com"
  );

  await BrowserTestUtils.switchTab(gBrowser, tab);

  let pageLoadPromise = BrowserTestUtils.waitForLocationChange(gBrowser);
  await SpecialPowers.spawn(tab.linkedBrowser, [], () => {
    content.document.getElementById("ad1").click();
  });
  await pageLoadPromise;

  await assertTelemetry(
    { "example.in-content:sap:ff": 1 },
    {
      "browser.search.with_ads": { example: 1 },
      "browser.search.ad_clicks": { example: 1 },
    }
  );

  BrowserTestUtils.removeTab(newTab);
  BrowserTestUtils.removeTab(tab);
});
