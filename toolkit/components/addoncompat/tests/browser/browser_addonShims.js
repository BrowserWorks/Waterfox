var {AddonManager} = Cu.import("resource://gre/modules/AddonManager.jsm", {});
var {Services} = Cu.import("resource://gre/modules/Services.jsm", {});

const ADDON_URL = "http://example.com/browser/toolkit/components/addoncompat/tests/browser/addon.xpi";
const COMPAT_ADDON_URL = "http://example.com/browser/toolkit/components/addoncompat/tests/browser/compat-addon.xpi";

// Install a test add-on that will exercise e10s shims.
//   url: Location of the add-on.
function addAddon(url) {
  info("Installing add-on: " + url);

  return new Promise(function(resolve, reject) {
    AddonManager.getInstallForURL(url, installer => {
      installer.install();
      let listener = {
        onInstallEnded(addon, addonInstall) {
          installer.removeListener(listener);

          // Wait for add-on's startup scripts to execute. See bug 997408
          executeSoon(function() {
            resolve(addonInstall);
          });
        }
      };
      installer.addListener(listener);
    }, "application/x-xpinstall");
  });
}

// Uninstall a test add-on.
//   addon: The addon reference returned from addAddon.
function removeAddon(addon) {
  info("Removing addon.");

  return new Promise(function(resolve, reject) {
    let listener = {
      onUninstalled(uninstalledAddon) {
        if (uninstalledAddon != addon) {
          return;
        }
        AddonManager.removeAddonListener(listener);
        resolve();
      }
    };
    AddonManager.addAddonListener(listener);
    addon.uninstall();
  });
}

add_task(async function test_addon_shims() {
  await SpecialPowers.pushPrefEnv({set: [["dom.ipc.shims.enabledWarnings", true]]});

  let addon = await addAddon(ADDON_URL);
  await window.runAddonShimTests({ok, is, info});
  await removeAddon(addon);

  if (Services.appinfo.browserTabsRemoteAutostart) {
    addon = await addAddon(COMPAT_ADDON_URL);
    await window.runAddonTests({ok, is, info});
    await removeAddon(addon);
  }
});
