"use strict";

const TEST_PLUGIN_NAME = "Test Plug-in";
const HIDDEN_CTP_PLUGIN_PREF = "plugins.navigator.hidden_ctp_plugin";
const DOMAIN_1 = "http://example.com";
const DOMAIN_2 = "http://mochi.test:8888";

/**
 * If a plugin is click-to-play and named in HIDDEN_CTP_PLUGIN_PREF,
 * then the plugin should be hidden in the navigator.plugins list by
 * default. However, if a plugin has been allowed on a top-level
 * document, we should let subframes of that document access
 * navigator.plugins.
 */
add_task(async function setup() {
  // We'll make the Test Plugin click-to-play.
  let originalPluginState = getTestPluginEnabledState();
  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_CLICKTOPLAY);
  registerCleanupFunction(() => {
    setTestPluginEnabledState(originalPluginState);
    clearAllPluginPermissions();
  });

  // And then make the plugin hidden.
  await SpecialPowers.pushPrefEnv({
    set: [[HIDDEN_CTP_PLUGIN_PREF, TEST_PLUGIN_NAME]],
  });
});

add_task(async function test_plugin_accessible_in_subframe() {
  // Let's make it so that DOMAIN_1 allows the test plugin to
  // be activated. This permission will be cleaned up inside
  // our registerCleanupFunction when the test ends.
  let ssm = Services.scriptSecurityManager;
  let principal = ssm.createContentPrincipalFromOrigin(DOMAIN_1);
  let pluginHost = Cc["@mozilla.org/plugin/host;1"].getService(
    Ci.nsIPluginHost
  );
  let permString = pluginHost.getPermissionStringForType("application/x-test");
  Services.perms.addFromPrincipal(
    principal,
    permString,
    Ci.nsIPermissionManager.ALLOW_ACTION,
    Ci.nsIPermissionManager.EXPIRE_NEVER,
    0 /* expireTime */
  );

  await BrowserTestUtils.withNewTab(
    {
      gBrowser,
      url: DOMAIN_1,
    },
    async function(browser) {
      await SpecialPowers.spawn(
        browser,
        [[TEST_PLUGIN_NAME, DOMAIN_2]],
        async function([pluginName, domain2]) {
          Assert.ok(
            content.navigator.plugins[pluginName],
            "Top-level document should find Test Plugin"
          );

          // Now manually create a subframe hosted at domain2...
          let subframe = content.document.createElement("iframe");
          subframe.src = domain2;
          let loadedPromise = ContentTaskUtils.waitForEvent(subframe, "load");
          content.document.body.appendChild(subframe);
          await loadedPromise;

          // Make sure that the HiddenPlugin event never fires in content.
          let sawEvent = false;
          docShell.chromeEventHandler.addEventListener(
            "HiddenPlugin",
            function onHiddenPlugin(e) {
              sawEvent = true;
              docShell.chromeEventHandler.removeEventListener(
                "HiddenPlugin",
                onHiddenPlugin,
                true
              );
            },
            true
          );

          Assert.ok(
            subframe.contentWindow.navigator.plugins[pluginName],
            "Subframe should find Test Plugin"
          );
          Assert.ok(!sawEvent, "Should not have seen the HiddenPlugin event.");
        }
      );
    }
  );
});
