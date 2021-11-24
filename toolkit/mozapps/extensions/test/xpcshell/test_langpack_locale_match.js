/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

/**
 * Tests that lang-packs matching the packaged locale do not register
 * their sources.
 */

createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");

const enUSID = "langpack-en-US@tests.mozilla.org";

add_task(async function testInstallMatchingLangpack() {
  Services.locale.requestedLocales = ["en-US"];
  Assert.equal(Services.locale.requestedLocale, "en-US");

  await promiseStartupManager();

  let langpack = {
    "manifest.json": {
      name: "Test en-US Language Pack",
      version: "1.0",
      manifest_version: 2,
      langpack_id: "en-US",
      applications: { gecko: { id: enUSID } },
      languages: {
        "en-US": {
          version: "20211012155819",
          chrome_resources: {},
        },
      },
    },
  };

  await Promise.all([
    TestUtils.topicObserved("webextension-langpack-startup-aborted"),
    AddonTestUtils.promiseInstallXPI(langpack),
  ]);

  let a1 = await AddonManager.getAddonByID(enUSID);
  await a1.uninstall();
  await promiseShutdownManager();
});
