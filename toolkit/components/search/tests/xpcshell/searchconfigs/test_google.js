/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const test = new SearchConfigTest({
  identifier: "google",
  aliases: ["@google"],
  default: {
    // Included everywhere apart from the exclusions below. These are basically
    // just excluding what Yandex and Baidu include.
    excluded: [
      {
        regions: ["cn"],
        locales: {
          matches: ["zh-CN"],
        },
      },
    ],
  },
  available: {
    excluded: [
      // Should be available everywhere.
    ],
  },
  details: [
    {
      included: [{ regions: ["us"] }],
      domain: "google.com",
      telemetryId: AppConstants.IS_ESR ? "google-b-1-e" : "google-b-1-d",
      codes: AppConstants.IS_ESR
        ? "client=firefox-b-1-e"
        : "client=firefox-b-1-d",
    },
    {
      excluded: [{ regions: ["us", "by", "kz", "ru", "tr"] }],
      included: [{}],
      domain: "google.com",
      telemetryId: AppConstants.IS_ESR ? "google-b-e" : "google-b-d",
      codes: AppConstants.IS_ESR ? "client=firefox-b-e" : "client=firefox-b-d",
    },
    {
      included: [{ regions: ["by", "kz", "ru", "tr"] }],
      domain: "google.com",
      telemetryId: "google-com-nocodes",
    },
  ],
});

add_task(async function setup() {
  await test.setup();
});

add_task(async function test_searchConfig_google() {
  await test.run();
});

add_task(async function test_searchConfig_google_with_mozparam() {
  // Test a couple of configurations with a MozParam set up.
  const TEST_DATA = [
    {
      locale: "en-US",
      region: "US",
      pref: "google_channel_us",
      expected: "us_param",
    },
    {
      locale: "en-US",
      region: "GB",
      pref: "google_channel_row",
      expected: "row_param",
    },
  ];

  const defaultBranch = Services.prefs.getDefaultBranch(
    SearchUtils.BROWSER_SEARCH_PREF
  );
  for (const testData of TEST_DATA) {
    defaultBranch.setCharPref("param." + testData.pref, testData.expected);
  }

  for (const testData of TEST_DATA) {
    info(`Checking region ${testData.region}, locale ${testData.locale}`);
    const engines = await test._getEngines(testData.region, testData.locale);

    Assert.ok(
      engines[0].identifier.startsWith("google"),
      "Should have the correct engine"
    );
    console.log(engines[0]);

    const submission = engines[0].getSubmission("test", URLTYPE_SEARCH_HTML);
    Assert.ok(
      submission.uri.query.split("&").includes("channel=" + testData.expected),
      "Should be including the correct MozParam parameter for the engine"
    );
  }
});
