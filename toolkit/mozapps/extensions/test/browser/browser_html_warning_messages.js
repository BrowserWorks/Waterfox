/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint max-len: ["error", 80] */

"use strict";

let gProvider;
const {
  STATE_BLOCKED,
  STATE_OUTDATED,
  STATE_SOFTBLOCKED,
  STATE_VULNERABLE_NO_UPDATE,
  STATE_VULNERABLE_UPDATE_AVAILABLE,
} = Ci.nsIBlocklistService;

const brandBundle = Services.strings.createBundle(
  "chrome://branding/locale/brand.properties"
);
const appName = brandBundle.GetStringFromName("brandShortName");
const appVersion = Services.appinfo.version;
const SUPPORT_URL = Services.urlFormatter.formatURL(
  Services.prefs.getStringPref("app.support.baseURL")
);

add_task(async function setup() {
  gProvider = new MockProvider();
});

async function checkMessageState(id, addonType, expected) {
  async function checkAddonCard() {
    let card = doc.querySelector(`addon-card[addon-id="${id}"]`);
    let messageBar = card.querySelector(".addon-card-message");

    if (!expected) {
      ok(messageBar.hidden, "message is hidden");
    } else {
      let { linkText, linkUrl, text, type } = expected;

      ok(!messageBar.hidden, "message is visible");
      is(messageBar.getAttribute("type"), type, "message has the right type");
      is(
        messageBar.querySelector("span").textContent,
        text,
        "message has the right text"
      );

      let link = messageBar.querySelector("button");
      if (linkUrl) {
        ok(!link.hidden, "link is visible");
        is(link.textContent, linkText, "link text is correct");
        let newTab = BrowserTestUtils.waitForNewTab(gBrowser, linkUrl);
        link.click();
        BrowserTestUtils.removeTab(await newTab);
      } else {
        ok(link.hidden, "link is hidden");
      }
    }

    return card;
  }

  let win = await loadInitialView(addonType);
  let doc = win.document;

  // Check the list view.
  ok(doc.querySelector("addon-list"), "this is a list view");
  let card = await checkAddonCard();

  // Load the detail view.
  let loaded = waitForViewLoad(win);
  card.querySelector('[action="expand"]').click();
  await loaded;

  // Check the detail view.
  ok(!doc.querySelector("addon-list"), "this isn't a list view");
  await checkAddonCard();

  await closeView(win);
}

add_task(async function testNoMessageExtension() {
  let id = "no-message@mochi.test";
  let extension = ExtensionTestUtils.loadExtension({
    manifest: { applications: { gecko: { id } } },
    useAddonManager: "temporary",
  });
  await extension.startup();

  await checkMessageState(id, "extension", null);

  await extension.unload();
});

add_task(async function testNoMessageLangpack() {
  let id = "no-message@mochi.test";
  gProvider.createAddons([
    {
      appDisabled: true,
      id,
      name: "Signed Langpack",
      signedState: AddonManager.SIGNEDSTATE_SIGNED,
      type: "locale",
    },
  ]);

  await checkMessageState(id, "locale", null);
});

add_task(async function testBlocked() {
  let id = "blocked@mochi.test";
  let linkUrl = "https://example.com/addon-blocked";
  gProvider.createAddons([
    {
      appDisabled: true,
      blocklistState: STATE_BLOCKED,
      blocklistURL: linkUrl,
      id,
      isActive: false,
      name: "Blocked",
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "More Information",
    linkUrl,
    text: "Blocked has been disabled due to security or stability issues.",
    type: "error",
  });
});

add_task(async function testUnsignedDisabled() {
  await SpecialPowers.pushPrefEnv({
    set: [["xpinstall.signatures.required", true]],
  });

  let id = "unsigned@mochi.test";
  gProvider.createAddons([
    {
      appDisabled: true,
      id,
      name: "Unsigned",
      signedState: AddonManager.SIGNEDSTATE_MISSING,
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "More Information",
    linkUrl: SUPPORT_URL + "unsigned-addons",
    text:
      "Unsigned could not be verified for use in " +
      appName +
      " and has been disabled.",
    type: "error",
  });

  await SpecialPowers.popPrefEnv();
});

add_task(async function testUnsignedLangpackDisabled() {
  let id = "unsigned-langpack@mochi.test";
  gProvider.createAddons([
    {
      appDisabled: true,
      id,
      name: "Unsigned",
      signedState: AddonManager.SIGNEDSTATE_MISSING,
      type: "locale",
    },
  ]);
  await checkMessageState(id, "locale", {
    linkText: "More Information",
    linkUrl: SUPPORT_URL + "unsigned-addons",
    text:
      "Unsigned could not be verified for use in " +
      appName +
      " and has been disabled.",
    type: "error",
  });
});

add_task(async function testIncompatible() {
  let id = "incompatible@mochi.test";
  gProvider.createAddons([
    {
      appDisabled: true,
      id,
      isActive: false,
      isCompatible: false,
      name: "Incompatible",
    },
  ]);
  await checkMessageState(id, "extension", {
    text:
      "Incompatible is incompatible with " + appName + " " + appVersion + ".",
    type: "warning",
  });
});

add_task(async function testUnsignedEnabled() {
  let id = "unsigned-allowed@mochi.test";
  gProvider.createAddons([
    {
      id,
      name: "Unsigned",
      signedState: AddonManager.SIGNEDSTATE_MISSING,
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "More Information",
    linkUrl: SUPPORT_URL + "unsigned-addons",
    text:
      "Unsigned could not be verified for use in " +
      appName +
      ". Proceed with caution.",
    type: "warning",
  });
});

add_task(async function testUnsignedLangpackEnabled() {
  await SpecialPowers.pushPrefEnv({
    set: [["extensions.langpacks.signatures.required", false]],
  });

  let id = "unsigned-allowed-langpack@mochi.test";
  gProvider.createAddons([
    {
      id,
      name: "Unsigned Langpack",
      signedState: AddonManager.SIGNEDSTATE_MISSING,
      type: "locale",
    },
  ]);
  await checkMessageState(id, "locale", {
    linkText: "More Information",
    linkUrl: SUPPORT_URL + "unsigned-addons",
    text:
      "Unsigned Langpack could not be verified for use in " +
      appName +
      ". Proceed with caution.",
    type: "warning",
  });

  await SpecialPowers.popPrefEnv();
});

add_task(async function testSoftBlocked() {
  let id = "softblocked@mochi.test";
  let linkUrl = "https://example.com/addon-blocked";
  gProvider.createAddons([
    {
      appDisabled: true,
      blocklistState: STATE_SOFTBLOCKED,
      blocklistURL: linkUrl,
      id,
      isActive: false,
      name: "Soft Blocked",
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "More Information",
    linkUrl,
    text: "Soft Blocked is known to cause security or stability issues.",
    type: "warning",
  });
});

add_task(async function testOutdated() {
  let id = "outdated@mochi.test";
  let linkUrl = "https://example.com/addon-blocked";
  gProvider.createAddons([
    {
      blocklistState: STATE_OUTDATED,
      blocklistURL: linkUrl,
      id,
      name: "Outdated",
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "Update Now",
    linkUrl,
    text: "An important update is available for Outdated.",
    type: "warning",
  });
});

add_task(async function testVulnerableUpdate() {
  let id = "vulnerable-update@mochi.test";
  let linkUrl = "https://example.com/addon-blocked";
  gProvider.createAddons([
    {
      blocklistState: STATE_VULNERABLE_UPDATE_AVAILABLE,
      blocklistURL: linkUrl,
      id,
      name: "Vulnerable Update",
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "Update Now",
    linkUrl,
    text: "Vulnerable Update is known to be vulnerable and should be updated.",
    type: "error",
  });
});

add_task(async function testVulnerableNoUpdate() {
  let id = "vulnerable-no-update@mochi.test";
  let linkUrl = "https://example.com/addon-blocked";
  gProvider.createAddons([
    {
      blocklistState: STATE_VULNERABLE_NO_UPDATE,
      blocklistURL: linkUrl,
      id,
      name: "Vulnerable No Update",
    },
  ]);
  await checkMessageState(id, "extension", {
    linkText: "More Information",
    linkUrl,
    text: "Vulnerable No Update is known to be vulnerable. Use with caution.",
    type: "error",
  });
});

add_task(async function testPluginInstalling() {
  let id = "plugin-installing@mochi.test";
  gProvider.createAddons([
    {
      id,
      isActive: true,
      isGMPlugin: true,
      isInstalled: false,
      name: "Plugin Installing",
      type: "plugin",
    },
  ]);
  await checkMessageState(id, "plugin", {
    text: "Plugin Installing will be installed shortly.",
    type: "warning",
  });
});
