/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const mainShippedRegions = [
  "at",
  "au",
  "ca",
  "ch",
  "cn",
  "de",
  "es",
  "fr",
  "mc",
  "gb",
  "ie",
  "it",
  "jp",
  "pt",
  "se",
  "sm",
  "us",
  "va",
];

const amazondotcomLocales = [
  "ach",
  "af",
  "ar",
  "az",
  "bg",
  "cak",
  "cy",
  "da",
  "el",
  "en-US",
  "en-GB",
  "eo",
  "es-AR",
  "eu",
  "fa",
  "ga-IE",
  "gd",
  "gl",
  "gn",
  "hr",
  "hy-AM",
  "ia",
  "is",
  "ka",
  "km",
  "lt",
  "mk",
  "ms",
  "my",
  "nb-NO",
  "nn-NO",
  "pt-PT",
  "ro",
  "si",
  "sq",
  "sr",
  "th",
  "tl",
  "trs",
  "uz",
];

const test = new SearchConfigTest({
  identifier: "amazon",
  default: {
    // Not default anywhere.
  },
  available: {
    included: [
      {
        // The main regions we ship Amazon to. Below this are special cases.
        regions: mainShippedRegions,
      },
      {
        // Amazon.com ships to all of these locales, excluding the ones where
        // we ship other items, but it does not matter that they are duplicated
        // in the available list.
        locales: {
          matches: amazondotcomLocales,
        },
      },
      {
        // Amazon.in
        regions: ["in"],
        locales: {
          matches: ["bn", "gu-IN", "kn", "mr", "pa-IN", "ta", "te", "ur"],
        },
      },
      {
        // Amazon.fr
        regions: ["be"],
        locales: {
          matches: ["fr"],
        },
      },
    ],
    excluded: [
      {
        // Extra special case for fr and cn as that only ships to the one locale.
        regions: ["be", "in", "nl"],
        locales: {
          matches: amazondotcomLocales,
        },
      },
    ],
  },
  details: [
    {
      domain: "amazon.com.au",
      telemetryId: "amazon-au",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["au"],
        },
      ],
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.ca",
      telemetryId: "amazon-ca",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["ca"],
        },
      ],
      searchUrlCode: "tag=mozillacanada-20",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.cn",
      telemetryId: "amazondotcn",
      included: [
        {
          regions: ["cn"],
        },
      ],
      searchUrlCode: "ix=sunray",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.co.jp",
      telemetryId: "amazon-jp",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["jp"],
        },
      ],
      searchUrlCode: "tag=mozillajapan-fx-22",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.co.uk",
      telemetryId: "amazon-en-GB",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["gb", "ie"],
        },
      ],
      searchUrlCode: "tag=firefox-uk-21",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.com",
      telemetryId: "amazondotcom",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["us"],
        },
      ],
      searchUrlCode: "tag=mozilla-20",
    },
    {
      domain: "amazon.com",
      telemetryId: "amazondotcom",
      aliases: ["@amazon"],
      included: [
        {
          locales: {
            matches: amazondotcomLocales,
          },
        },
      ],
      excluded: [{ regions: mainShippedRegions }],
      searchUrlCode: "tag=mozilla-20",
    },
    {
      domain: "amazon.de",
      telemetryId: "amazon-de",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["at", "ch", "de"],
        },
      ],
      searchUrlCode: "tag=firefox-de-21",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.es",
      telemetryId: "amazon-es",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["es", "pt"],
        },
      ],
      searchUrlCode: "tag=mozillaspain-21",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.fr",
      telemetryId: "amazon-france",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["fr", "mc"],
        },
        {
          regions: ["be"],
          locales: {
            matches: ["fr"],
          },
        },
      ],
      searchUrlCode: "tag=firefox-fr-21",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.in",
      telemetryId: "amazon-in",
      aliases: ["@amazon"],
      included: [
        {
          locales: {
            matches: ["bn", "gu-IN", "kn", "mr", "pa-IN", "ta", "te", "ur"],
          },
          regions: ["in"],
        },
      ],
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.it",
      telemetryId: "amazon-it",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["it", "sm", "va"],
        },
      ],
      searchUrlCode: "tag=firefoxit-21",
      noSuggestionsURL: true,
    },
    {
      domain: "amazon.se",
      telemetryId: "amazon-se",
      aliases: ["@amazon"],
      included: [
        {
          regions: ["se"],
        },
      ],
      searchUrlCode: "tag=mozillasweede-21",
      noSuggestionsURL: true,
    },
  ],
});

add_task(async function setup() {
  // We only need to do setup on one of the tests.
  await test.setup();
});

add_task(async function test_searchConfig_amazon() {
  await test.run(true);
});
