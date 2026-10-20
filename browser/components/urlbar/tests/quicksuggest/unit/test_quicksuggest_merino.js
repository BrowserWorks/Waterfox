/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Tests Merino integration with UrlbarProviderQuickSuggest.

"use strict";

ChromeUtils.defineESModuleGetters(this, {
  AmpSuggestions:
    "moz-src:///browser/components/urlbar/private/AmpSuggestions.sys.mjs",
});

const SEARCH_STRING = "frab";

const { DEFAULT_SUGGESTION_SCORE } = UrlbarProviderQuickSuggest;
const { TIMESTAMP_TEMPLATE } = AmpSuggestions;

const REMOTE_SETTINGS_RESULTS = [
  QuickSuggestTestUtils.ampRemoteSettings({
    keywords: [SEARCH_STRING],
  }),
];

const EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT = QuickSuggestTestUtils.ampResult({
  keyword: SEARCH_STRING,
  suggestedIndex: -1,
});

const EXPECTED_MERINO_URLBAR_RESULT = QuickSuggestTestUtils.ampResult({
  source: "merino",
  provider: "adm",
  requestId: "request_id",
  suggestedIndex: -1,
});

add_setup(async () => {
  await MerinoTestUtils.server.start();

  // Set up the remote settings client with the test data.
  await QuickSuggestTestUtils.ensureQuickSuggestInit({
    prefs: [
      ["suggest.quicksuggest.all", true],
      ["suggest.quicksuggest.sponsored", true],
      ["quicksuggest.ampTopPickCharThreshold", 0],
    ],
  });
  await resetRemoteSettingsData();

  Assert.equal(
    typeof DEFAULT_SUGGESTION_SCORE,
    "number",
    "Sanity check: DEFAULT_SUGGESTION_SCORE is defined"
  );
});

// Tests with the Merino endpoint URL set to an empty string, which disables
// fetching from Merino.
add_task(async function merinoDisabled() {
  let mockEndpointUrl = UrlbarPrefs.get("merino.endpointURL");
  UrlbarPrefs.set("merino.endpointURL", "");
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // Clear the remote settings suggestions so that if Merino is actually queried
  // -- which would be a bug -- we don't accidentally mask the Merino suggestion
  // by also matching an RS suggestion with the same or higher score.
  await QuickSuggestTestUtils.setRemoteSettingsRecords([]);

  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [],
  });

  UrlbarPrefs.set("merino.endpointURL", mockEndpointUrl);

  await resetRemoteSettingsData();
});

// The Merino backend should be disabled when the `suggest.quicksuggest.all`
// pref is false.
add_task(async function suggestAllPref() {
  // Make sure the `online` prefs are true so we can verify that disabling
  // `suggest.quicksuggest.all` alone disables the backend.
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // First, start with `all` set to true so that the backend is enabled.
  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  await QuickSuggestTestUtils.forceSync();

  Assert.ok(
    QuickSuggest.getFeature("SuggestBackendMerino").isEnabled,
    "SuggestBackendMerino should be enabled"
  );

  // With the backend enabled, do a search and check the request.
  await check_results({
    context: createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [EXPECTED_MERINO_URLBAR_RESULT],
  });
  MerinoTestUtils.server.checkAndClearRequests([
    {
      params: {
        [MerinoTestUtils.SEARCH_PARAMS.QUERY]: SEARCH_STRING,
        [MerinoTestUtils.SEARCH_PARAMS.SEQUENCE_NUMBER]: 0,
      },
    },
  ]);

  // Now set `all` to false, which should disable the backend.
  UrlbarPrefs.set("suggest.quicksuggest.all", false);
  await QuickSuggestTestUtils.forceSync();

  Assert.ok(
    !QuickSuggest.getFeature("SuggestBackendMerino").isEnabled,
    "SuggestBackendMerino should be disabled after setting `suggest.quicksuggest.all` to false"
  );

  // With the backend disabled, do a search and make sure no request was sent.
  await check_results({
    context: createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [],
  });
  MerinoTestUtils.server.checkAndClearRequests([]);

  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  await QuickSuggestTestUtils.forceSync();
});

// Results should be fetched from Merino only when online is both available and
// enabled.
add_task(async function onlineAvailableAndEnabled() {
  // Clear the remote settings suggestions so that if Merino is actually queried
  // -- which would be a bug -- we don't accidentally mask the Merino suggestion
  // by also matching an RS suggestion with the same or higher score.
  await QuickSuggestTestUtils.setRemoteSettingsRecords([]);

  for (let onlineAvailable of [false, true]) {
    for (let onlineEnabled of [false, true]) {
      info(
        "Doing subtest: " + JSON.stringify({ onlineAvailable, onlineEnabled })
      );

      UrlbarPrefs.set("quicksuggest.online.available", onlineAvailable);
      UrlbarPrefs.set("quicksuggest.online.enabled", onlineEnabled);

      let shouldBeEnabled = onlineAvailable && onlineEnabled;
      Assert.equal(
        QuickSuggest.getFeature("SuggestBackendMerino").isEnabled,
        shouldBeEnabled,
        "SuggestBackendMerino should be enabled as expected"
      );

      await check_results({
        context: createContext(SEARCH_STRING, {
          providers: [UrlbarProviderQuickSuggest.name],
          isPrivate: false,
        }),
        matches: shouldBeEnabled ? [EXPECTED_MERINO_URLBAR_RESULT] : [],
      });
      MerinoTestUtils.server.checkAndClearRequests(
        shouldBeEnabled
          ? [
              {
                params: {
                  [MerinoTestUtils.SEARCH_PARAMS.QUERY]: SEARCH_STRING,
                  [MerinoTestUtils.SEARCH_PARAMS.SEQUENCE_NUMBER]: 0,
                },
              },
            ]
          : []
      );
    }
  }

  await resetRemoteSettingsData();
});

// When the Merino suggestion has a higher score than the remote settings
// suggestion, the Merino suggestion should be used.
add_task(async function higherScore() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  MerinoTestUtils.server.response.body.suggestions[0].score =
    2 * DEFAULT_SUGGESTION_SCORE;

  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [EXPECTED_MERINO_URLBAR_RESULT],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// When the Merino suggestion has a lower score than the remote settings
// suggestion, the remote settings suggestion should be used.
add_task(async function lowerScore() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  MerinoTestUtils.server.response.body.suggestions[0].score =
    DEFAULT_SUGGESTION_SCORE / 2;

  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// When remote settings doesn't return a suggestion but Merino does, the Merino
// suggestion should be used.
add_task(async function noSuggestion_remoteSettings() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  let context = createContext("this doesn't match remote settings", {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [EXPECTED_MERINO_URLBAR_RESULT],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// When Merino doesn't return a suggestion but remote settings does, the remote
// settings suggestion should be used.
add_task(async function noSuggestion_merino() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  MerinoTestUtils.server.response.body.suggestions = [];

  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// When Merino returns multiple suggestions, the one with the largest score
// should be used.
add_task(async function multipleMerinoSuggestions() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  MerinoTestUtils.server.response.body.suggestions = [
    {
      provider: "adm",
      full_keyword: "multipleMerinoSuggestions 0 full_keyword",
      title: "multipleMerinoSuggestions 0 title",
      url: "multipleMerinoSuggestions 0 url",
      icon: "multipleMerinoSuggestions 0 icon",
      impression_url: "multipleMerinoSuggestions 0 impression_url",
      click_url: "multipleMerinoSuggestions 0 click_url",
      block_id: 0,
      advertiser: "multipleMerinoSuggestions 0 advertiser",
      iab_category: "22 - Shopping",
      is_sponsored: true,
      score: 0.1,
    },
    {
      provider: "adm",
      full_keyword: "multipleMerinoSuggestions 1 full_keyword",
      title: "multipleMerinoSuggestions 1 title",
      url: "multipleMerinoSuggestions 1 url",
      icon: "multipleMerinoSuggestions 1 icon",
      impression_url: "multipleMerinoSuggestions 1 impression_url",
      click_url: "multipleMerinoSuggestions 1 click_url",
      block_id: 1,
      advertiser: "multipleMerinoSuggestions 1 advertiser",
      iab_category: "22 - Shopping",
      is_sponsored: true,
      score: 1,
    },
    {
      provider: "adm",
      full_keyword: "multipleMerinoSuggestions 2 full_keyword",
      title: "multipleMerinoSuggestions 2 title",
      url: "multipleMerinoSuggestions 2 url",
      icon: "multipleMerinoSuggestions 2 icon",
      impression_url: "multipleMerinoSuggestions 2 impression_url",
      click_url: "multipleMerinoSuggestions 2 click_url",
      block_id: 2,
      advertiser: "multipleMerinoSuggestions 2 advertiser",
      iab_category: "22 - Shopping",
      is_sponsored: true,
      score: 0.2,
    },
  ];

  let context = createContext("test", {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [
      QuickSuggestTestUtils.ampResult({
        keyword: "multipleMerinoSuggestions 1 full_keyword",
        title: "multipleMerinoSuggestions 1 title",
        url: "multipleMerinoSuggestions 1 url",
        originalUrl: "multipleMerinoSuggestions 1 url",
        icon: "multipleMerinoSuggestions 1 icon",
        impressionUrl: "multipleMerinoSuggestions 1 impression_url",
        clickUrl: "multipleMerinoSuggestions 1 click_url",
        blockId: 1,
        advertiser: "multipleMerinoSuggestions 1 advertiser",
        requestId: "request_id",
        source: "merino",
        provider: "adm",
        suggestedIndex: -1,
      }),
    ],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Timestamp templates in URLs should be replaced with real timestamps.
add_task(async function timestamps() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // Set up the Merino response with template URLs.
  let suggestion = MerinoTestUtils.server.response.body.suggestions[0];
  suggestion.url = `http://example.com/time-${TIMESTAMP_TEMPLATE}`;
  suggestion.click_url = `http://example.com/time-${TIMESTAMP_TEMPLATE}-foo`;

  // Do a search.
  let context = createContext("test", {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  let controller = UrlbarTestUtils.newMockController({
    input: {
      isPrivate: context.isPrivate,
      onFirstResult() {
        return false;
      },
      getSearchSource() {
        return "dummy-search-source";
      },
      window: {
        location: {
          href: AppConstants.BROWSER_CHROME_URL,
        },
      },
    },
  });
  await controller.startQuery(context);

  // Should be one quick suggest result.
  Assert.equal(context.results.length, 1, "One result returned");
  let result = context.results[0];

  QuickSuggestTestUtils.assertTimestampsReplaced(result, {
    url: suggestion.click_url,
    sponsoredClickUrl: suggestion.click_url,
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests dismissals of managed Merino suggestions (suggestions that are managed
// by a `SuggestFeature`).
add_task(async function dismissals_managed() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // Set up a single Merino AMP suggestion with a unique URL.
  let url = "https://example.com/merino-amp-url";
  MerinoTestUtils.server.response =
    MerinoTestUtils.server.makeDefaultResponse();
  MerinoTestUtils.server.response.body.suggestions[0].url = url;

  let expectedMerinoResult = QuickSuggestTestUtils.ampResult({
    url,
    source: "merino",
    provider: "adm",
    requestId: "request_id",
    suggestedIndex: -1,
  });

  // Do a search. The Merino suggestion should be matched.
  const context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [expectedMerinoResult],
  });

  let result = context.results[0];
  Assert.ok(
    QuickSuggest.getFeatureByResult(result),
    "Sanity check: The actual result should be managed by a feature"
  );

  // Dismiss the Merino result.
  await QuickSuggest.dismissResult(result);
  Assert.ok(
    await QuickSuggest.isResultDismissed(result),
    "isResultDismissed should return true after dismissing result"
  );

  // Do another search. The remote settings suggestion should now be matched.
  await check_results({
    context: createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT],
  });

  // Clear dismissals.
  await QuickSuggest.clearDismissedSuggestions();
  Assert.ok(
    !(await QuickSuggest.isResultDismissed(result)),
    "isResultDismissed should return false after clearing dismissals"
  );

  // The Merino suggestion should be matched again.
  await check_results({
    context: createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [expectedMerinoResult],
  });

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests dismissals of Merino AMP suggestions, which have special handling
// around their dismissal keys.
add_task(async function dismissals_amp() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  UrlbarPrefs.set("suggest.quicksuggest.sponsored", true);
  await QuickSuggestTestUtils.forceSync();

  let tests = [
    {
      suggestion: {
        url: "https://example.com/0",
      },
      expected: {
        // dismissal key should be the `url` value
        dismissalKey: "https://example.com/0",
      },
    },
    {
      suggestion: {
        url: `https://example.com/1-${TIMESTAMP_TEMPLATE}`,
      },
      expected: {
        // dismissal key should be the original `url` value with the timestamp
        // template
        dismissalKey: `https://example.com/1-${TIMESTAMP_TEMPLATE}`,
      },
    },
    {
      suggestion: {
        url: "https://example.com/2",
        full_keyword: "full keyword 2",
      },
      expected: {
        // dismissal key should be the `url` value
        dismissalKey: "https://example.com/2",
        notDismissalKeys: ["full keyword 2"],
      },
    },
    {
      suggestion: {
        url: `https://example.com/3-${TIMESTAMP_TEMPLATE}`,
        full_keyword: "full keyword 3",
      },
      expected: {
        // dismissal key should be the `url` value
        dismissalKey: `https://example.com/3-${TIMESTAMP_TEMPLATE}`,
        notDismissalKeys: ["full keyword 3"],
      },
    },
    {
      suggestion: {
        url: "https://example.com/4",
        dismissal_key: "4-dismissal-key",
      },
      expected: {
        // dismissal key should be the `dismissal_key` value
        dismissalKey: "4-dismissal-key",
        notDismissalKeys: ["https://example.com/4"],
      },
    },
    {
      suggestion: {
        url: `https://example.com/5-${TIMESTAMP_TEMPLATE}`,
        dismissal_key: "5-dismissal-key",
      },
      expected: {
        // dismissal key should be the `dismissal_key` value
        dismissalKey: "5-dismissal-key",
        notDismissalKeys: [`https://example.com/5-${TIMESTAMP_TEMPLATE}`],
      },
    },
    {
      suggestion: {
        url: "https://example.com/6",
        full_keyword: "full keyword 6",
        dismissal_key: "6-dismissal-key",
      },
      expected: {
        // dismissal key should be the `dismissal_key` value
        dismissalKey: "6-dismissal-key",
        notDismissalKeys: ["full keyword 6", "https://example.com/6"],
      },
    },
    {
      suggestion: {
        url: `https://example.com/7-${TIMESTAMP_TEMPLATE}`,
        full_keyword: "full keyword 7",
        dismissal_key: "7-dismissal-key",
      },
      expected: {
        // dismissal key should be the `dismissal_key` value
        dismissalKey: "7-dismissal-key",
        notDismissalKeys: [
          "full keyword 7",
          `https://example.com/7-${TIMESTAMP_TEMPLATE}`,
        ],
      },
    },
  ];

  for (let test of tests) {
    info("Doing subtest: " + JSON.stringify(test));

    let { suggestion, expected } = test;

    suggestion = {
      provider: "adm",
      title: "title",
      icon: null,
      impression_url: "https://example.com/impression",
      click_url: "https://example.com/click",
      block_id: 1,
      advertiser: "advertiser",
      iab_category: "22 - Shopping",
      is_sponsored: true,
      request_id: "request_id",
      score: 1,
      ...suggestion,
    };

    MerinoTestUtils.server.response =
      MerinoTestUtils.server.makeDefaultResponse();
    MerinoTestUtils.server.response.body.suggestions = [suggestion];

    let expectedResult = QuickSuggestTestUtils.ampResult({
      suggestedIndex: -1,
      provider: suggestion.provider,
      title: suggestion.title,
      fullKeyword: suggestion.full_keyword,
      url: suggestion.url,
      originalUrl: suggestion.original_url || suggestion.url,
      dismissalKey: suggestion.dismissal_key,
      requestId: suggestion.request_id,
      impressionUrl: suggestion.impression_url,
      clickUrl: suggestion.click_url,
      blockId: suggestion.block_id,
      advertiser: suggestion.advertiser,
      iabCategory: suggestion.iab_category,
      source: "merino",
    });

    if (!suggestion.full_keyword) {
      delete expectedResult.payload.title;
    }

    // Do a search. The Merino suggestion should be matched.
    let context = createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    });
    await check_results({
      context,
      matches: [expectedResult],
      // Ignore values related to the timestamp template. They're not important
      // for this test.
      conditionalPayloadProperties: {
        url: { ignore: true },
        urlTimestampIndex: { ignore: true },
      },
    });

    let result = context.results[0];
    Assert.equal(
      QuickSuggest.getFeatureByResult(result)?.name,
      "AmpSuggestions",
      "Sanity check: The actual result should be managed by AmpSuggestions"
    );

    // Dismiss the Merino result.
    await QuickSuggest.dismissResult(result);
    Assert.ok(
      await QuickSuggest.isResultDismissed(result),
      "isResultDismissed should return true after dismissing result"
    );

    Assert.ok(
      await QuickSuggest.rustBackend.isDismissedByKey(expected.dismissalKey),
      "isDismissedByKey should return true after dismissing result"
    );
    if (expected.notDismissalKeys) {
      for (let value of expected.notDismissalKeys) {
        Assert.ok(
          !(await QuickSuggest.rustBackend.isDismissedByKey(value)),
          "isDismissedByKey should return false for notDismissalKey: " + value
        );
      }
    }

    // Do another search. The remote settings suggestion should now be matched.
    await check_results({
      context: createContext(SEARCH_STRING, {
        providers: [UrlbarProviderQuickSuggest.name],
        isPrivate: false,
      }),
      matches: [EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT],
    });

    // Clear dismissals.
    await QuickSuggest.clearDismissedSuggestions();
    Assert.ok(
      !(await QuickSuggest.isResultDismissed(result)),
      "isResultDismissed should return false after clearing dismissals"
    );

    // The Merino suggestion should be matched again.
    await check_results({
      context: createContext(SEARCH_STRING, {
        providers: [UrlbarProviderQuickSuggest.name],
        isPrivate: false,
      }),
      matches: [expectedResult],
      conditionalPayloadProperties: {
        url: { ignore: true },
        urlTimestampIndex: { ignore: true },
      },
    });
  }

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests dismissals of unmanaged Merino suggestions (suggestions that are not
// managed by a `SuggestFeature`).
add_task(async function dismissals_unmanaged_1() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // The "top_picks" provider is the only supported unmanaged suggestion.
  let provider = "top_picks";

  let tests = [
    {
      suggestion: {
        provider,
        url: "https://example.com/0",
        score: 1,
      },
      expected: {
        // dismissal key should be the `url` value
        dismissalKey: "https://example.com/0",
      },
    },
    {
      suggestion: {
        provider,
        url: "https://example.com/1",
        original_url: "https://example.com/1-original-url",
        score: 1,
      },
      expected: {
        // dismissal key should be the `original_url` value
        dismissalKey: "https://example.com/1-original-url",
        notDismissalKeys: ["https://example.com/1"],
      },
    },
    {
      suggestion: {
        provider,
        url: "https://example.com/2",
        original_url: "https://example.com/2-original-url",
        dismissal_key: "2-dismissal-key",
        score: 1,
      },
      expected: {
        // dismissal key should be the `dismissal_key` value
        dismissalKey: "2-dismissal-key",
        notDismissalKeys: [
          "https://example.com/2",
          "https://example.com/2-original-url",
        ],
      },
    },
  ];

  for (let test of tests) {
    info("Doing subtest: " + JSON.stringify(test));

    let { suggestion, expected } = test;

    MerinoTestUtils.server.response =
      MerinoTestUtils.server.makeDefaultResponse();
    MerinoTestUtils.server.response.body.suggestions = [suggestion];

    let expectedResult = {
      type: UrlbarUtils.RESULT_TYPE.URL,
      source: UrlbarUtils.RESULT_SOURCE.SEARCH,
      heuristic: false,
      payload: {
        provider,
        url: suggestion.url,
        originalUrl: suggestion.original_url,
        dismissalKey: suggestion.dismissal_key,
        source: "merino",
        isSponsored: false,
        shouldShowUrl: true,
        isBlockable: true,
        isManageable: true,
        telemetryType: provider,
      },
    };

    // Do a search. The Merino suggestion should be matched.
    let context = createContext(SEARCH_STRING, {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    });
    await check_results({
      context,
      matches: [expectedResult],
    });

    let result = context.results[0];
    Assert.ok(
      !QuickSuggest.getFeatureByResult(result),
      "Sanity check: The actual result should not be managed by a feature"
    );

    // Dismiss the Merino result.
    await QuickSuggest.dismissResult(result);
    Assert.ok(
      await QuickSuggest.isResultDismissed(result),
      "isResultDismissed should return true after dismissing result"
    );

    Assert.ok(
      await QuickSuggest.rustBackend.isDismissedByKey(expected.dismissalKey),
      "isDismissedByKey should return true after dismissing result"
    );
    if (expected.notDismissalKeys) {
      for (let value of expected.notDismissalKeys) {
        Assert.ok(
          !(await QuickSuggest.rustBackend.isDismissedByKey(value)),
          "isDismissedByKey should return false for notDismissalKey: " + value
        );
      }
    }

    // Do another search. The remote settings suggestion should now be matched.
    await check_results({
      context: createContext(SEARCH_STRING, {
        providers: [UrlbarProviderQuickSuggest.name],
        isPrivate: false,
      }),
      matches: [EXPECTED_REMOTE_SETTINGS_URLBAR_RESULT],
    });

    // Clear dismissals.
    await QuickSuggest.clearDismissedSuggestions();
    Assert.ok(
      !(await QuickSuggest.isResultDismissed(result)),
      "isResultDismissed should return false after clearing dismissals"
    );

    // The Merino suggestion should be matched again.
    await check_results({
      context: createContext(SEARCH_STRING, {
        providers: [UrlbarProviderQuickSuggest.name],
        isPrivate: false,
      }),
      matches: [expectedResult],
    });
  }

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests dismissals of unmanaged Merino suggestions (suggestions that are not
// managed by a `SuggestFeature`) that all have the same URL but different
// original URLs and dismissal keys.
add_task(async function dismissals_unmanaged_2() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  // The "top_picks" provider is the only supported unmanaged suggestion.
  let provider = "top_picks";

  MerinoTestUtils.server.response =
    MerinoTestUtils.server.makeDefaultResponse();
  MerinoTestUtils.server.response.body.suggestions = [
    // all three: url, original_url, dismissal_key
    {
      provider,
      url: "https://example.com/url",
      original_url: "https://example.com/original_url",
      dismissal_key: "dismissal-key",
      score: 1.0,
    },
    // two: url, original_url
    {
      provider,
      url: "https://example.com/url",
      original_url: "https://example.com/original_url",
      score: 0.9,
    },
    // only one: url
    {
      provider,
      url: "https://example.com/url",
      score: 0.8,
    },
  ];

  let expectedBaseResult = {
    type: UrlbarUtils.RESULT_TYPE.URL,
    source: UrlbarUtils.RESULT_SOURCE.SEARCH,
    heuristic: false,
    payload: {
      provider,
      url: "https://example.com/url",
      source: "merino",
      isSponsored: false,
      shouldShowUrl: true,
      isBlockable: true,
      isManageable: true,
      telemetryType: provider,
    },
  };

  // Do a search. The first Merino suggestion should be matched.
  info("Doing search 1");
  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [
      {
        ...expectedBaseResult,
        payload: {
          ...expectedBaseResult.payload,
          originalUrl: "https://example.com/original_url",
          dismissalKey: "dismissal-key",
        },
      },
    ],
  });

  let result = context.results[0];
  Assert.ok(
    !QuickSuggest.getFeatureByResult(result),
    "Sanity check: The actual result should not be managed by a feature"
  );

  // Dismiss it.
  await QuickSuggest.dismissResult(result);
  Assert.ok(
    await QuickSuggest.isResultDismissed(result),
    "isResultDismissed should return true after dismissing result 1"
  );

  Assert.ok(
    await QuickSuggest.rustBackend.isDismissedByKey("dismissal-key"),
    "isDismissedByKey should return true after dismissing suggestion 1"
  );

  for (let value of [
    "https://example.com/url",
    "https://example.com/original_url",
  ]) {
    Assert.ok(
      !(await QuickSuggest.rustBackend.isDismissedByKey(value)),
      "isDismissedByKey should return false after dismissing suggestion 1: " +
        value
    );
  }

  // Do another search. The second suggestion should be matched.
  info("Doing search 2");
  context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [
      {
        ...expectedBaseResult,
        payload: {
          ...expectedBaseResult.payload,
          originalUrl: "https://example.com/original_url",
          // no dismissal_key
        },
      },
    ],
  });

  // Dismiss it.
  result = context.results[0];
  await QuickSuggest.dismissResult(result);
  Assert.ok(
    await QuickSuggest.isResultDismissed(result),
    "isResultDismissed should return true after dismissing result 2"
  );

  for (let value of ["dismissal-key", "https://example.com/original_url"]) {
    Assert.ok(
      await QuickSuggest.rustBackend.isDismissedByKey(value),
      "isDismissedByKey should return true after dismissing suggestion 2: " +
        value
    );
  }

  Assert.ok(
    !(await QuickSuggest.rustBackend.isDismissedByKey(
      "https://example.com/url"
    )),
    "isDismissedByKey should return false after dismissing suggestion 2"
  );

  // Do another search. The third suggestion should be matched.
  info("Doing search 3");
  context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [
      // no dismissal_key or original_url
      expectedBaseResult,
    ],
  });

  // Dismiss it.
  result = context.results[0];
  await QuickSuggest.dismissResult(result);
  Assert.ok(
    await QuickSuggest.isResultDismissed(result),
    "isResultDismissed should return true after dismissing result 3"
  );

  for (let value of [
    "dismissal-key",
    "https://example.com/original_url",
    "https://example.com/url",
  ]) {
    Assert.ok(
      await QuickSuggest.rustBackend.isDismissedByKey(value),
      "isDismissedByKey should return true after dismissing suggestion 3: " +
        value
    );
  }

  await QuickSuggest.clearDismissedSuggestions();
  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests a mock `top_picks` Merino suggestion, which
// `UrlbarProviderQuickSuggest` handles as an unmanaged suggestion type.
add_task(async function topPicks() {
  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);

  let provider = "top_picks";
  MerinoTestUtils.server.response.body.suggestions = [
    {
      is_top_pick: true,
      provider,
      full_keyword: "full_keyword",
      title: "title",
      url: "url",
      icon: null,
      score: 1,
    },
  ];

  let context = createContext(SEARCH_STRING, {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [
      {
        isBestMatch: true,
        type: UrlbarUtils.RESULT_TYPE.URL,
        source: UrlbarUtils.RESULT_SOURCE.SEARCH,
        heuristic: false,
        payload: {
          telemetryType: provider,
          title: "full_keyword — title",
          url: "url",
          icon: null,
          isSponsored: false,
          isBlockable: true,
          isManageable: true,
          source: "merino",
          provider,
        },
      },
    ],
  });

  // This isn't necessary since `check_results()` checks `isBestMatch`, but
  // check it here explicitly for good measure.
  Assert.ok(context.results[0].isBestMatch, "Result is a best match");

  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
});

// Tests a sponsored suggestion that isn't managed by a feature. When the `all`
// pref is disabled, a result for the suggestion should not be added.
add_task(async function unmanaged_sponsored_allDisabled() {
  await doUnmanagedTest({
    pref: "suggest.quicksuggest.all",
    suggestion: {
      title: "Sponsored without feature",
      url: "https://example.com/sponsored-without-feature",
      is_sponsored: true,
    },
    shouldBeAdded: false,
  });
});

// Tests a sponsored suggestion that isn't managed by a feature. When the
// sponsored pref is disabled, a result for the suggestion should not be added.
add_task(async function unmanaged_sponsored_sponsoredDisabled() {
  await doUnmanagedTest({
    pref: "suggest.quicksuggest.sponsored",
    suggestion: {
      title: "Sponsored without feature",
      url: "https://example.com/sponsored-without-feature",
      is_sponsored: true,
    },
    shouldBeAdded: false,
  });
});

// Tests a nonsponsored suggestion that isn't managed by a feature. When the
// `all` pref is disabled, a result for the suggestion should not be added.
add_task(async function unmanaged_nonsponsored_allDisabled() {
  await doUnmanagedTest({
    pref: "suggest.quicksuggest.all",
    suggestion: {
      title: "Nonsponsored without feature",
      url: "https://example.com/nonsponsored-without-feature",
      // no is_sponsored
    },
    shouldBeAdded: false,
  });
});

// Tests a nonsponsored suggestion that isn't managed by a feature. When the
// `all` pref is enabled and the sponsored pref is disabled, a result for the
// suggestion should be added.
add_task(async function unmanaged_nonsponsored_sponsoredDisabled() {
  await doUnmanagedTest({
    pref: "suggest.quicksuggest.sponsored",
    suggestion: {
      title: "Nonsponsored without feature",
      url: "https://example.com/nonsponsored-without-feature",
      // no is_sponsored
    },
    shouldBeAdded: true,
  });
});

async function doUnmanagedTest({ pref, suggestion, shouldBeAdded }) {
  // The "top_picks" provider is the only supported unmanaged suggestion.
  suggestion.provider = "top_picks";

  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  UrlbarPrefs.set("suggest.quicksuggest.sponsored", true);
  await QuickSuggestTestUtils.forceSync();

  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);
  MerinoTestUtils.server.response.body.suggestions = [suggestion];

  let expectedResult = {
    type: UrlbarUtils.RESULT_TYPE.URL,
    source: UrlbarUtils.RESULT_SOURCE.SEARCH,
    heuristic: false,
    payload: {
      title: suggestion.title,
      url: suggestion.url,
      provider: suggestion.provider,
      telemetryType: suggestion.provider,
      isSponsored: !!suggestion.is_sponsored,
      source: "merino",
      isBlockable: true,
      isManageable: true,
      shouldShowUrl: true,
    },
  };

  // Do an initial search. The `all` pref and sponsored suggestions are both
  // enabled, so the suggestion should be matched.
  info("Doing search 1");
  await check_results({
    context: createContext("test", {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [expectedResult],
  });

  // Set the passed-in pref to false and do another search. The suggestion
  // should be matched as expected.
  UrlbarPrefs.set(pref, false);
  await QuickSuggestTestUtils.forceSync();

  info("Doing search 2");
  await check_results({
    context: createContext("test", {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: shouldBeAdded ? [expectedResult] : [],
  });

  // Flip the pref back to true and do a third search.
  UrlbarPrefs.set(pref, true);
  await QuickSuggestTestUtils.forceSync();

  info("Doing search 3");
  let context = createContext("test", {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });
  await check_results({
    context,
    matches: [expectedResult],
  });

  // Trigger the dismiss command on the result.
  let dismissalPromise = TestUtils.topicObserved(
    "quicksuggest-dismissals-changed"
  );
  let providersManager = ProvidersManager.getInstanceForSap("urlbar");
  triggerCommand({
    feature: providersManager.getProvider(UrlbarProviderQuickSuggest.name),
    command: "dismiss",
    result: context.results[0],
    expectedCountsByCall: {
      removeResult: 1,
    },
  });
  await dismissalPromise;

  Assert.ok(
    await QuickSuggest.isResultDismissed(context.results[0]),
    "The result should be dismissed"
  );

  await QuickSuggest.clearDismissedSuggestions();
  MerinoTestUtils.server.reset();
  merinoClient().resetSession();
}

// An unmanaged suggestion with an unrecognized Merino provider (i.e., not
// "top_picks") should not be added.
add_task(async function unmanaged_unrecognized() {
  UrlbarPrefs.set("suggest.quicksuggest.all", true);
  UrlbarPrefs.set("suggest.quicksuggest.sponsored", true);
  await QuickSuggestTestUtils.forceSync();

  UrlbarPrefs.set("quicksuggest.online.available", true);
  UrlbarPrefs.set("quicksuggest.online.enabled", true);
  MerinoTestUtils.server.response.body.suggestions = [
    {
      title: "Some unrecognized suggestion",
      url: "https://example.com/unmanaged_unrecognized",
      provider: "unmanaged-unrecognized-provider",
    },
  ];

  await check_results({
    context: createContext("test", {
      providers: [UrlbarProviderQuickSuggest.name],
      isPrivate: false,
    }),
    matches: [],
  });
});

function merinoClient() {
  return QuickSuggest.getFeature("SuggestBackendMerino")?.client;
}

async function resetRemoteSettingsData() {
  await QuickSuggestTestUtils.setRemoteSettingsRecords([
    {
      collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
      type: QuickSuggestTestUtils.RS_TYPE.AMP,
      attachment: REMOTE_SETTINGS_RESULTS,
    },
  ]);
}
