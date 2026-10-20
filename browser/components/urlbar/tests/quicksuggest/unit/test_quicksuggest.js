/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Tests for AMP and Wikipedia suggestions and some aspects of the Suggest
// urlbar provider that aren't tested elsewhere. See also
// `test_quicksuggest_merino.js`.

"use strict";

const lazy = {};
ChromeUtils.defineESModuleGetters(lazy, {
  SuggestBackendRust:
    "moz-src:///browser/components/urlbar/private/SuggestBackendRust.sys.mjs",
});

add_setup(async function init() {
  UrlbarPrefs.set("maxRichResults", 10);
  await QuickSuggestTestUtils.ensureQuickSuggestInit();
});

// The Rust backend should remain enabled regardless of the
// `suggest.quicksuggest.all` pref.
add_task(async function suggestAllPref() {
  UrlbarPrefs.set("suggest.quicksuggest.all", false);
  UrlbarPrefs.set("suggest.quicksuggest.sponsored", false);
  await QuickSuggestTestUtils.forceSync();

  Assert.ok(
    QuickSuggest.getFeature("SuggestBackendRust").isEnabled,
    "SuggestBackendRust should remain enabled when `suggest.quicksuggest.all` is false"
  );

  UrlbarPrefs.clear("suggest.quicksuggest.all");
  UrlbarPrefs.clear("suggest.quicksuggest.sponsored");
  await QuickSuggestTestUtils.forceSync();
});

add_task(async function maxResults() {
  UrlbarPrefs.set("suggest.quicksuggest.sponsored", true);
  await QuickSuggestTestUtils.forceSync();

  let attachment = [];
  for (let i = 0; i < 2 * UrlbarPrefs.get("maxRichResults"); i++) {
    attachment.push(
      QuickSuggestTestUtils.ampRemoteSettings({
        title: "test " + i,
        url: "https://example.com/test/" + i,
      })
    );
  }

  await QuickSuggestTestUtils.setRemoteSettingsRecords([
    {
      collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
      type: QuickSuggestTestUtils.RS_TYPE.AMP,
      attachment,
    },
  ]);

  let suggestions = await QuickSuggest.rustBackend.query("amp");
  Assert.equal(
    suggestions.length,
    attachment.length,
    "The backend should return all matching suggestions"
  );

  let context = createContext("amp", {
    providers: [UrlbarProviderQuickSuggest.name],
    isPrivate: false,
  });

  // Spy on `muxer.sort()` so we can verify the provider limited the number of
  // results it added to the query.
  let muxerName = context.muxer || "UnifiedComplete";
  let providersManager = ProvidersManager.getInstanceForSap("urlbar");
  let muxer = providersManager.muxers.get(muxerName);
  Assert.ok(!!muxer, "Muxer should exist");

  let sandbox = sinon.createSandbox();
  let spy = sandbox.spy(muxer, "sort");

  // Use `check_results()` to do the query.
  await check_results({
    context,
    matches: [
      QuickSuggestTestUtils.ampResult({
        title: "test 0",
        url: "https://example.com/test/0",
        suggestedIndex: -1,
      }),
    ],
  });

  // Check the `sort()` calls.
  let calls = spy.getCalls();
  Assert.greater(
    calls.length,
    0,
    "muxer.sort() should have been called at least once"
  );

  for (let c of calls) {
    let unsortedResults = c.args[1];
    Assert.lessOrEqual(
      unsortedResults.length,
      UrlbarPrefs.get("maxRichResults"),
      "Provider should have added no more than maxRichResults results"
    );
  }

  sandbox.restore();
});

add_task(async function manySuggestResults() {
  let attachment = [];
  for (let i = 0; i < UrlbarPrefs.get("maxRichResults"); i++) {
    attachment.push(
      QuickSuggestTestUtils.ampRemoteSettings({
        url: "https://example.com/" + i,
      })
    );
  }

  let additionals = [];
  for (let i = 0; i < UrlbarPrefs.get("maxRichResults"); i++) {
    additionals.push(
      new UrlbarResult({
        type: UrlbarUtils.RESULT_TYPE.URL,
        source: UrlbarUtils.RESULT_SOURCE.HISTORY,
        payload: { url: "http://example.org/" + i },
      })
    );
  }

  await doResultCheckTest({
    env: {
      prefs: [
        ["suggest.quicksuggest.all", true],
        ["suggest.quicksuggest.sponsored", true],
      ],
      remoteSettingRecords: [
        {
          collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
          type: QuickSuggestTestUtils.RS_TYPE.AMP,
          attachment,
        },
      ],
      additionalProvider: {
        name: "additionalProvider",
        results: additionals,
      },
    },
    tests: [
      {
        // When the Suggest provider adds more than one result and they are not hidden
        // exposures, the muxer should add the first one to the final results list and
        // discard the rest, and the discarded results should not prevent the muxer from
        // adding other non-Suggest results.
        context: createContext("amp", {
          providers: [UrlbarProviderQuickSuggest.name, "additionalProvider"],
          isPrivate: false,
        }),
        expected: [
          ...additionals.slice(0, additionals.length - 1),
          QuickSuggestTestUtils.ampResult({
            url: "https://example.com/0",
            suggestedIndex: -1,
          }),
        ],
      },
      {
        // When the Suggest provider adds more than one result and they are hidden
        // exposures, the muxer should add up to `queryContext.maxResults` of them to
        // the final results list, and they should not prevent the muxer from adding
        // other non-Suggest results.
        prefs: [
          ["exposureResults", "rust_adm_sponsored"],
          ["showExposureResults", false],
        ],
        context: createContext("amp", {
          providers: [UrlbarProviderQuickSuggest.name, "additionalProvider"],
          isPrivate: false,
        }),
        expected: [
          ...additionals,
          ...attachment
            .map(record =>
              Object.assign(
                QuickSuggestTestUtils.ampResult({
                  url: record.url,
                  suggestedIndex: -1,
                }),
                { exposureTelemetry: UrlbarUtils.EXPOSURE_TELEMETRY.HIDDEN }
              )
            )
            .reverse(),
        ],
      },
    ],
  });
});

/**
 * Tests how the muxer dedupes URL results against quick suggest results.
 * Depending on prefix rank, quick suggest results should be preferred over
 * other URL results with the same stripped URL: Other results should be
 * discarded when their prefix rank is lower than the prefix rank of the quick
 * suggest. They should not be discarded when their prefix rank is higher, and
 * in that case both results should be included.
 */
add_task(async function dedupeAgainstURL_prefix() {
  const HTTP_QUERY = "http prefix";
  const HTTP_URL = "http://example.com/prefix-test";
  const httpContext = createContext(HTTP_QUERY, { isPrivate: false });

  const HTTPS_QUERY = "https prefix";
  const HTTPS_URL = "https://example.com/prefix-test";
  const httpsContext = createContext(HTTPS_QUERY, { isPrivate: false });

  await doResultCheckTest({
    env: {
      prefs: [
        ["suggest.searches", false],
        ["quicksuggest.ampTopPickCharThreshold", 0],
      ],
      remoteSettingRecords: [
        {
          collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
          type: QuickSuggestTestUtils.RS_TYPE.AMP,
          attachment: [
            QuickSuggestTestUtils.ampRemoteSettings({
              url: HTTP_URL,
              keywords: [HTTP_QUERY],
            }),
            QuickSuggestTestUtils.ampRemoteSettings({
              url: HTTPS_URL,
              keywords: [HTTPS_QUERY],
            }),
          ],
        },
      ],
    },
    tests: [
      {
        description:
          "History and Suggest results have same prefix: Suggest should be shown instead of history",
        prefs: [
          ["suggest.quicksuggest.all", true],
          ["suggest.quicksuggest.sponsored", true],
        ],
        histories: [{ uri: HTTP_URL, title: HTTP_QUERY }],
        context: httpContext,
        expected: [
          makeSearchResult(httpContext, {
            heuristic: true,
            query: HTTP_QUERY,
            engineName: SearchService.defaultEngine.name,
          }),
          QuickSuggestTestUtils.ampResult({
            url: HTTP_URL,
            keyword: HTTP_QUERY,
            suggestedIndex: -1,
          }),
        ],
      },
      {
        description:
          "Suggest result has a higher prefix than history: Suggest should be shown instead of history",
        prefs: [
          ["suggest.quicksuggest.all", true],
          ["suggest.quicksuggest.sponsored", true],
        ],
        histories: [{ uri: HTTP_URL, title: HTTP_QUERY }],
        context: httpsContext,
        expected: [
          makeSearchResult(httpsContext, {
            heuristic: true,
            query: HTTPS_QUERY,
            engineName: SearchService.defaultEngine.name,
          }),
          QuickSuggestTestUtils.ampResult({
            url: HTTPS_URL,
            keyword: HTTPS_QUERY,
            suggestedIndex: -1,
          }),
        ],
      },
      {
        description:
          "History result has a higher prefix than Suggest: Both results should be shown",
        prefs: [
          ["suggest.quicksuggest.all", true],
          ["suggest.quicksuggest.sponsored", true],
        ],
        histories: [{ uri: HTTPS_URL, title: HTTPS_QUERY }],
        context: httpContext,
        expected: [
          makeSearchResult(httpContext, {
            heuristic: true,
            query: HTTP_QUERY,
            engineName: SearchService.defaultEngine.name,
          }),
          makeVisitResult(httpsContext, {
            uri: HTTPS_URL,
            title: HTTPS_QUERY,
          }),
          QuickSuggestTestUtils.ampResult({
            url: HTTP_URL,
            keyword: HTTP_QUERY,
            suggestedIndex: -1,
          }),
        ],
      },
    ],
  });
});

// When a Suggest best match and a tab-to-search (TTS) are shown in the same
// search, both will have a `suggestedIndex` value of 1. The TTS should appear
// first.
add_task(async function tabToSearch() {
  // Install a test engine. The main part of its domain name needs to match the
  // best match result too so we can trigger both its TTS and the best match.
  let engineURL = `https://foo.amp.com/`;
  let extension = await SearchTestUtils.installSearchExtension(
    {
      name: "Test",
      search_url: engineURL,
    },
    { skipUnload: true }
  );
  let engine = SearchService.getEngineByName("Test");

  let context = createContext("amp", { isPrivate: false });
  await doResultCheckTest({
    env: {
      remoteSettingRecords: [
        {
          collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
          type: QuickSuggestTestUtils.RS_TYPE.AMP,
          attachment: [QuickSuggestTestUtils.ampRemoteSettings()],
        },
      ],
    },
    tests: [
      {
        prefs: [
          // We'll use a sponsored priority result as the best match result.
          // Different types of Suggest results can appear as best matches, and
          // they all should have the same behavior.
          ["suggest.quicksuggest.all", true],
          ["suggest.quicksuggest.sponsored", true],
          ["suggest.quickactions", false],
          // Disable tab-to-search onboarding results so we get a regular TTS
          // result, which we can test a little more easily with
          // `makeSearchResult()`.
          ["tabToSearch.onboard.interactionsLeft", 0],
          // Disable search suggestions so we don't need to expect them below.
          ["browser.search.suggest.enabled", false],
        ],
        nimbus: {
          quickSuggestSponsoredPriority: true,
        },
        histories: [
          { uri: engineURL, transition: PlacesUtils.history.TRANSITION_TYPED },
        ],
        context,
        expected: [
          // search heuristic
          makeSearchResult(context, {
            engineName: SearchService.defaultEngine.name,
            engineIconUri: await SearchService.defaultEngine.getIconURL(),
            heuristic: true,
          }),
          // tab to search
          makeSearchResult(context, {
            engineName: engine.name,
            engineIconUri: UrlbarUtils.ICON.SEARCH_GLASS,
            searchUrlDomainWithoutSuffix: UrlbarUtils.stripPublicSuffixFromHost(
              engine.searchUrlDomain
            ),
            providesSearchMode: true,
            query: "",
            providerName: "UrlbarProviderTabToSearch",
            satisfiesAutofillThreshold: true,
          }),
          // Suggest best match
          QuickSuggestTestUtils.ampResult({
            isBestMatch: true,
            suggestedIndex: 1,
            isSuggestedIndexRelativeToGroup: false,
          }),
          // visit
          makeVisitResult(context, {
            uri: engineURL,
            title: `test visit for ${engineURL}`,
          }),
        ],
      },
    ],
  });

  await extension.unload();
});

// When a Suggest best match and a global action are shown in the same search,
// both will have a `suggestedIndex` value of 1. The global action should appear
// first.
add_task(async function globalAction() {
  let engineURL = "https://example.com/";
  let extension = await SearchTestUtils.installSearchExtension(
    {
      name: "Amp",
      search_url: engineURL,
    },
    { skipUnload: true }
  );
  await PlacesTestUtils.addVisits(engineURL);

  let context = createContext("amp", { isPrivate: false });
  await doResultCheckTest({
    env: {
      remoteSettingRecords: [
        {
          collection: QuickSuggestTestUtils.RS_COLLECTION.AMP,
          type: QuickSuggestTestUtils.RS_TYPE.AMP,
          attachment: [QuickSuggestTestUtils.ampRemoteSettings()],
        },
      ],
    },
    tests: [
      {
        prefs: [
          // We'll use a sponsored priority result as the best match result.
          // Different types of Suggest results can appear as best matches, and
          // they all should
          // have the same behavior.
          ["suggest.quicksuggest.all", true],
          ["suggest.quicksuggest.sponsored", true],
          // Disable search suggestions so we don't need to expect them below.
          ["browser.search.suggest.enabled", false],
          // Set prefs to prevent quick actions onboarding label from showing.
          ["quickactions.timesToShowOnboardingLabel", 3],
          ["quickactions.timesShownOnboardingLabel", 3],
        ],
        nimbus: {
          quickSuggestSponsoredPriority: true,
        },
        histories: [engineURL],
        context,
        expected: [
          // search heuristic
          makeSearchResult(context, {
            engineName: SearchService.defaultEngine.name,
            engineIconUri: await SearchService.defaultEngine.getIconURL(),
            heuristic: true,
          }),
          // "Search with engine" global action.
          makeGlobalActionsResult({
            actionsResults: [
              {
                providerName: "ActionsProviderContextualSearch",
              },
            ],
            query: "",
            input: "",
            inputLength: context.searchString.length,
            showOnboardingLabel: false,
          }),
          // Suggest best match
          QuickSuggestTestUtils.ampResult({
            isBestMatch: true,
            suggestedIndex: 1,
            isSuggestedIndexRelativeToGroup: false,
          }),
          // visit
          makeVisitResult(context, {
            uri: engineURL,
            title: `test visit for ${engineURL}`,
          }),
        ],
      },
    ],
  });

  await extension.unload();
});

add_task(async function mergeRustProviderConstraints() {
  let tests = [
    {
      a: null,
      b: null,
      expected: null,
    },

    // b is null
    {
      a: {},
      b: null,
      expected: {},
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: null,
      expected: { ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: null,
      expected: { dynamicSuggestionTypes: [] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: null,
      expected: { dynamicSuggestionTypes: ["aaa"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: null,
      expected: { dynamicSuggestionTypes: ["aaa", "bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"], ampAlternativeMatching: 1 },
      b: null,
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },

    // b is an empty object
    {
      a: {},
      b: {},
      expected: {},
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: {},
      expected: { ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: {},
      expected: { dynamicSuggestionTypes: [] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: {},
      expected: { dynamicSuggestionTypes: ["aaa"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: {},
      expected: { dynamicSuggestionTypes: ["aaa", "bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"], ampAlternativeMatching: 1 },
      b: {},
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },

    // b is { ampAlternativeMatching: 1 }
    {
      a: {},
      b: { ampAlternativeMatching: 1 },
      expected: { ampAlternativeMatching: 1 },
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: { ampAlternativeMatching: 1 },
      expected: { ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: { ampAlternativeMatching: 1 },
      expected: { dynamicSuggestionTypes: [], ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: { ampAlternativeMatching: 1 },
      expected: { dynamicSuggestionTypes: ["aaa"], ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: { ampAlternativeMatching: 1 },
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"], ampAlternativeMatching: 1 },
      b: { ampAlternativeMatching: 1 },
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },

    // b is { dynamicSuggestionTypes: [] }
    {
      a: {},
      b: { dynamicSuggestionTypes: [] },
      expected: { dynamicSuggestionTypes: [] },
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: { dynamicSuggestionTypes: [] },
      expected: { dynamicSuggestionTypes: [], ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: { dynamicSuggestionTypes: [] },
      expected: { dynamicSuggestionTypes: [] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: { dynamicSuggestionTypes: [] },
      expected: { dynamicSuggestionTypes: ["aaa"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: { dynamicSuggestionTypes: [] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"], ampAlternativeMatching: 1 },
      b: { dynamicSuggestionTypes: [] },
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },

    // b is { dynamicSuggestionTypes: ["bbb"] }
    {
      a: {},
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["bbb"] },
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["bbb"], ampAlternativeMatching: 1 },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["bbb"] },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"], ampAlternativeMatching: 1 },
      b: { dynamicSuggestionTypes: ["bbb"] },
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb"],
        ampAlternativeMatching: 1,
      },
    },

    // b is { dynamicSuggestionTypes: ["bbb", "ddd"] }
    {
      a: {},
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["bbb", "ddd"] },
    },
    {
      a: { ampAlternativeMatching: 1 },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: {
        dynamicSuggestionTypes: ["bbb", "ddd"],
        ampAlternativeMatching: 1,
      },
    },
    {
      a: { dynamicSuggestionTypes: [] },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["bbb", "ddd"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa"] },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb", "ddd"] },
    },
    {
      a: { dynamicSuggestionTypes: ["bbb"] },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["bbb", "ddd"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb"] },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb", "ddd"] },
    },
    {
      a: { dynamicSuggestionTypes: ["aaa", "bbb", "ccc"] },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: { dynamicSuggestionTypes: ["aaa", "bbb", "ccc", "ddd"] },
    },
    {
      a: {
        dynamicSuggestionTypes: ["aaa", "bbb", "ccc"],
        ampAlternativeMatching: 1,
      },
      b: { dynamicSuggestionTypes: ["bbb", "ddd"] },
      expected: {
        dynamicSuggestionTypes: ["aaa", "bbb", "ccc", "ddd"],
        ampAlternativeMatching: 1,
      },
    },
  ];

  for (let { a, b, expected } of tests) {
    for (let [first, second] of [
      [a, b],
      [b, a],
    ]) {
      info("Doing test: " + JSON.stringify({ first, second }));
      let actual = lazy.SuggestBackendRust.mergeProviderConstraints(
        first,
        second
      );
      Assert.deepEqual(
        actual,
        expected,
        "Expected merged constraints with " + JSON.stringify({ first, second })
      );
    }
  }
});
