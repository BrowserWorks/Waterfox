/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Enable SCOPE_APPLICATION for builtin testing.  Default in tests is only SCOPE_PROFILE.
// AddonManager.SCOPE_PROFILE | AddonManager.SCOPE_APPLICATION == 5;
Services.prefs.setIntPref("extensions.enabledScopes", 5);

const {
  createAppInfo,
  promiseShutdownManager,
  promiseStartupManager,
} = AddonTestUtils;

SearchTestUtils.initXPCShellAddonManager(this);

const TEST_CONFIG = [
  {
    webExtension: {
      id: "multilocale@search.waterfox.net",
      locales: ["af", "an"],
    },
    appliesTo: [{ included: { everywhere: true } }],
  },
];

async function getEngineNames() {
  let engines = await Services.search.getEngines();
  return engines.map(engine => engine._name);
}

function makeExtension(version) {
  return {
    useAddonManager: "permanent",
    manifest: {
      name: "__MSG_searchName__",
      version,
      applications: {
        gecko: {
          id: "multilocale@search.waterfox.net",
        },
      },
      default_locale: "an",
      chrome_settings_overrides: {
        search_provider: {
          name: "__MSG_searchName__",
          search_url: "__MSG_searchUrl__",
        },
      },
    },
    files: {
      "_locales/af/messages.json": {
        searchUrl: {
          message: `https://example.af/?q={searchTerms}&version=${version}`,
          description: "foo",
        },
        searchName: {
          message: `Multilocale AF`,
          description: "foo",
        },
      },
      "_locales/an/messages.json": {
        searchUrl: {
          message: `https://example.an/?q={searchTerms}&version=${version}`,
          description: "foo",
        },
        searchName: {
          message: `Multilocale AN`,
          description: "foo",
        },
      },
    },
  };
}

add_task(async function setup() {
  Services.prefs.setBoolPref("browser.search.gModernConfig", true);

  await useTestEngines("test-extensions", null, TEST_CONFIG);
  await promiseStartupManager();

  registerCleanupFunction(promiseShutdownManager);
  await Services.search.init();
});

add_task(async function basic_multilocale_test() {
  Assert.deepEqual(await getEngineNames(), [
    "Multilocale AF",
    "Multilocale AN",
  ]);

  let ext = ExtensionTestUtils.loadExtension(makeExtension("2.0"));
  await ext.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext);

  Assert.deepEqual(await getEngineNames(), [
    "Multilocale AF",
    "Multilocale AN",
  ]);

  let engine = await Services.search.getEngineByName("Multilocale AF");
  Assert.equal(
    engine.getSubmission("test").uri.spec,
    "https://example.af/?q=test&version=2.0",
    "Engine got update"
  );
  engine = await Services.search.getEngineByName("Multilocale AN");
  Assert.equal(
    engine.getSubmission("test").uri.spec,
    "https://example.an/?q=test&version=2.0",
    "Engine got update"
  );

  await ext.unload();
  await promiseAfterCache();
});
