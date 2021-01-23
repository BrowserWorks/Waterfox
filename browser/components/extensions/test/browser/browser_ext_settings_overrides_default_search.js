/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */

"use strict";

ChromeUtils.defineModuleGetter(
  this,
  "AddonManager",
  "resource://gre/modules/AddonManager.jsm"
);

const { AddonTestUtils } = ChromeUtils.import(
  "resource://testing-common/AddonTestUtils.jsm"
);
const { SearchTestUtils } = ChromeUtils.import(
  "resource://testing-common/SearchTestUtils.jsm"
);

const EXTENSION1_ID = "extension1@mozilla.com";
const EXTENSION2_ID = "extension2@mozilla.com";
const DEFAULT_SEARCH_STORE_TYPE = "default_search";
const DEFAULT_SEARCH_SETTING_NAME = "defaultSearch";

AddonTestUtils.initMochitest(this);

var defaultEngineName;

async function restoreDefaultEngine() {
  let engine = Services.search.getEngineByName(defaultEngineName);
  await Services.search.setDefault(engine);
}

add_task(async function setup() {
  defaultEngineName = (await Services.search.getDefault()).name;
  registerCleanupFunction(restoreDefaultEngine);
});

/* This tests setting a default engine. */
add_task(async function test_extension_setting_default_engine() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
});

/* This tests what happens when the engine you're setting it to is hidden. */
add_task(async function test_extension_setting_default_engine_hidden() {
  let engine = Services.search.getEngineByName("DuckDuckGo");
  engine.hidden = true;

  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    "Default engine should have remained as the default"
  );
  is(
    ExtensionSettingsStore.getSetting("default_search", "defaultSearch"),
    null,
    "The extension should not have been recorded as having set the default search"
  );

  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
  engine.hidden = false;
});

// Test the popup displayed when trying to add a non-built-in default
// search engine.
add_task(async function test_extension_setting_default_engine_external() {
  const NAME = "Example Engine";

  // Load an extension that tries to set the default engine,
  // and wait for the ensuing prompt.
  async function startExtension(win = window) {
    let extension = ExtensionTestUtils.loadExtension({
      manifest: {
        applications: {
          gecko: {
            id: EXTENSION1_ID,
          },
        },
        chrome_settings_overrides: {
          search_provider: {
            name: NAME,
            search_url: "https://example.com/?q={searchTerms}",
            is_default: true,
          },
        },
      },
      useAddonManager: "temporary",
    });

    let [panel] = await Promise.all([
      promisePopupNotificationShown("addon-webext-defaultsearch", win),
      extension.startup(),
    ]);

    isnot(
      panel,
      null,
      "Doorhanger was displayed for non-built-in default engine"
    );

    return { panel, extension };
  }

  // First time around, don't accept the default engine.
  let { panel, extension } = await startExtension();
  panel.secondaryButton.click();

  // There is no explicit event we can wait for to know when the click
  // callback has been fully processed.  One spin through the Promise
  // microtask queue should be enough.  If this wait isn't long enough,
  // the test below where we accept the prompt will fail.
  await Promise.resolve();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    "Default engine was not changed after rejecting prompt"
  );

  await extension.unload();

  // Do it again, this time accept the prompt.
  ({ panel, extension } = await startExtension());

  panel.button.click();
  await Promise.resolve();

  is(
    (await Services.search.getDefault()).name,
    NAME,
    "Default engine was changed after accepting prompt"
  );

  // Do this twice to make sure we're definitely handling disable/enable
  // correctly.
  let disabledPromise = awaitEvent("shutdown", EXTENSION1_ID);
  let addon = await AddonManager.getAddonByID(EXTENSION1_ID);
  await addon.disable();
  await disabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "Google",
    "Default engine is Google after disabling"
  );

  let processedPromise = awaitEvent("searchEngineProcessed", EXTENSION1_ID);
  await addon.enable();
  await processedPromise;

  is(
    (await Services.search.getDefault()).name,
    NAME,
    `Default engine is ${NAME} after enabling`
  );

  await extension.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    "Default engine is reverted after uninstalling extension."
  );

  // One more time, this time close the window where the prompt
  // appears instead of explicitly accepting or denying it.
  let win = await BrowserTestUtils.openNewBrowserWindow();
  await BrowserTestUtils.openNewForegroundTab(win.gBrowser, "about:blank");

  ({ extension } = await startExtension(win));

  await BrowserTestUtils.closeWindow(win);

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    "Default engine is unchanged when prompt is dismissed"
  );

  await extension.unload();
});

/* This tests that uninstalling add-ons maintains the proper
 * search default. */
add_task(async function test_extension_setting_multiple_default_engine() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  let ext2 = ExtensionTestUtils.loadExtension({
    manifest: {
      chrome_settings_overrides: {
        search_provider: {
          name: "Bing",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  await ext2.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext2);

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  await ext2.unload();

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
});

/* This tests that uninstalling add-ons in reverse order maintains the proper
 * search default. */
add_task(
  async function test_extension_setting_multiple_default_engine_reversed() {
    let ext1 = ExtensionTestUtils.loadExtension({
      manifest: {
        chrome_settings_overrides: {
          search_provider: {
            name: "DuckDuckGo",
            search_url: "https://example.com/?q={searchTerms}",
            is_default: true,
          },
        },
      },
      useAddonManager: "temporary",
    });

    let ext2 = ExtensionTestUtils.loadExtension({
      manifest: {
        chrome_settings_overrides: {
          search_provider: {
            name: "Bing",
            search_url: "https://example.com/?q={searchTerms}",
            is_default: true,
          },
        },
      },
      useAddonManager: "temporary",
    });

    await ext1.startup();
    await AddonTestUtils.waitForSearchProviderStartup(ext1);

    is(
      (await Services.search.getDefault()).name,
      "DuckDuckGo",
      "Default engine is DuckDuckGo"
    );

    await ext2.startup();
    await AddonTestUtils.waitForSearchProviderStartup(ext2);

    is(
      (await Services.search.getDefault()).name,
      "Bing",
      "Default engine is Bing"
    );

    await ext1.unload();

    is(
      (await Services.search.getDefault()).name,
      "Bing",
      "Default engine is Bing"
    );

    await ext2.unload();

    is(
      (await Services.search.getDefault()).name,
      defaultEngineName,
      `Default engine is ${defaultEngineName}`
    );
  }
);

/* This tests that when the user changes the search engine and the add-on
 * is unistalled, search stays with the user's choice. */
add_task(async function test_user_changing_default_engine() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  let engine = Services.search.getEngineByName("Bing");
  await Services.search.setDefault(engine);
  // This simulates the preferences UI when the setting is changed.
  ExtensionSettingsStore.select(
    ExtensionSettingsStore.SETTING_USER_SET,
    DEFAULT_SEARCH_STORE_TYPE,
    DEFAULT_SEARCH_SETTING_NAME
  );

  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );
  restoreDefaultEngine();
});

/* This tests that when the user changes the search engine while it is
 * disabled, user choice is maintained when the add-on is reenabled. */
add_task(async function test_user_change_with_disabling() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION1_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  let engine = Services.search.getEngineByName("Bing");
  await Services.search.setDefault(engine);
  // This simulates the preferences UI when the setting is changed.
  ExtensionSettingsStore.select(
    ExtensionSettingsStore.SETTING_USER_SET,
    DEFAULT_SEARCH_STORE_TYPE,
    DEFAULT_SEARCH_SETTING_NAME
  );

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let disabledPromise = awaitEvent("shutdown", EXTENSION1_ID);
  let addon = await AddonManager.getAddonByID(EXTENSION1_ID);
  await addon.disable();
  await disabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let processedPromise = awaitEvent("searchEngineProcessed", EXTENSION1_ID);
  await addon.enable();
  await processedPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );
  await ext1.unload();
  await restoreDefaultEngine();
});

/* This tests that when two add-ons are installed that change default
 * search and the first one is disabled, before the second one is installed,
 * when the first one is reenabled, the second add-on keeps the search. */
add_task(async function test_two_addons_with_first_disabled_before_second() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION1_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  let ext2 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION2_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "Bing",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  let disabledPromise = awaitEvent("shutdown", EXTENSION1_ID);
  let addon1 = await AddonManager.getAddonByID(EXTENSION1_ID);
  await addon1.disable();
  await disabledPromise;

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );

  await ext2.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext2);

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let enabledPromise = awaitEvent("ready", EXTENSION1_ID);
  await addon1.enable();
  await enabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );
  await ext2.unload();

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );
  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
});

/* This tests that when two add-ons are installed that change default
 * search and the first one is disabled, the second one maintains
 * the search. */
add_task(async function test_two_addons_with_first_disabled() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION1_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  let ext2 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION2_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "Bing",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  await ext2.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext2);

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let disabledPromise = awaitEvent("shutdown", EXTENSION1_ID);
  let addon1 = await AddonManager.getAddonByID(EXTENSION1_ID);
  await addon1.disable();
  await disabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let enabledPromise = awaitEvent("ready", EXTENSION1_ID);
  await addon1.enable();
  await enabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );
  await ext2.unload();

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );
  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
});

/* This tests that when two add-ons are installed that change default
 * search and the second one is disabled, the first one properly
 * gets the search. */
add_task(async function test_two_addons_with_second_disabled() {
  let ext1 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION1_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "DuckDuckGo",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  let ext2 = ExtensionTestUtils.loadExtension({
    manifest: {
      applications: {
        gecko: {
          id: EXTENSION2_ID,
        },
      },
      chrome_settings_overrides: {
        search_provider: {
          name: "Bing",
          search_url: "https://example.com/?q={searchTerms}",
          is_default: true,
        },
      },
    },
    useAddonManager: "temporary",
  });

  await ext1.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext1);

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  await ext2.startup();
  await AddonTestUtils.waitForSearchProviderStartup(ext2);

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );

  let disabledPromise = awaitEvent("shutdown", EXTENSION2_ID);
  let addon2 = await AddonManager.getAddonByID(EXTENSION2_ID);
  await addon2.disable();
  await disabledPromise;

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );

  let defaultPromise = SearchTestUtils.promiseSearchNotification(
    "engine-default",
    "browser-search-engine-modified"
  );
  let enabledPromise = awaitEvent("ready", EXTENSION2_ID);
  await addon2.enable();
  await enabledPromise;
  await defaultPromise;

  is(
    (await Services.search.getDefault()).name,
    "Bing",
    "Default engine is Bing"
  );
  await ext2.unload();

  is(
    (await Services.search.getDefault()).name,
    "DuckDuckGo",
    "Default engine is DuckDuckGo"
  );
  await ext1.unload();

  is(
    (await Services.search.getDefault()).name,
    defaultEngineName,
    `Default engine is ${defaultEngineName}`
  );
});
