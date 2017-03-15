/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

const { utils: Cu, interfaces: Ci, classes: Cc, results: Cr } = Components;

const URI_EXTENSION_BLOCKLIST_DIALOG = "chrome://mozapps/content/extensions/blocklist.xul";

Cu.import("resource://gre/modules/NetUtil.jsm");
Cu.import("resource://testing-common/MockRegistrar.jsm");

// Allow insecure updates
Services.prefs.setBoolPref("extensions.checkUpdateSecurity", false)

const testserver = createHttpServer();
gPort = testserver.identity.primaryPort;
testserver.registerDirectory("/data/", do_get_file("data"));

// Don't need the full interface, attempts to call other methods will just
// throw which is just fine
var WindowWatcher = {
  openWindow: function(parent, url, name, features, openArgs) {
    // Should be called to list the newly blocklisted items
    do_check_eq(url, URI_EXTENSION_BLOCKLIST_DIALOG);

    // Simulate auto-disabling any softblocks
    var list = openArgs.wrappedJSObject.list;
    list.forEach(function(aItem) {
      if (!aItem.blocked)
        aItem.disable = true;
    });

    // run the code after the blocklist is closed
    Services.obs.notifyObservers(null, "addon-blocklist-closed", null);
  },

  QueryInterface: function(iid) {
    if (iid.equals(Ci.nsIWindowWatcher)
     || iid.equals(Ci.nsISupports))
      return this;

    throw Cr.NS_ERROR_NO_INTERFACE;
  }
};

MockRegistrar.register("@mozilla.org/embedcomp/window-watcher;1", WindowWatcher);

const profileDir = gProfD.clone();
profileDir.append("extensions");

function load_blocklist(aFile) {
  return new Promise((resolve, reject) => {
    Services.obs.addObserver(function() {
      Services.obs.removeObserver(arguments.callee, "blocklist-updated");

      resolve();
    }, "blocklist-updated", false);

    Services.prefs.setCharPref("extensions.blocklist.url", `http://localhost:${gPort}/data/${aFile}`);
    var blocklist = Cc["@mozilla.org/extensions/blocklist;1"].
                    getService(Ci.nsITimerCallback);
    blocklist.notify(null);
  });
}

function run_test() {
  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1");
  run_next_test();
}

// Tests that an appDisabled add-on that becomes softBlocked remains disabled
// when becoming appEnabled
add_task(function* () {
  writeInstallRDFForExtension({
    id: "softblock1@tests.mozilla.org",
    version: "1.0",
    name: "Softblocked add-on",
    targetApplications: [{
      id: "xpcshell@tests.mozilla.org",
      minVersion: "2",
      maxVersion: "3"
    }]
  }, profileDir);

  startupManager();

  let s1 = yield promiseAddonByID("softblock1@tests.mozilla.org");

  // Make sure to mark it as previously enabled.
  s1.userDisabled = false;

  do_check_false(s1.softDisabled);
  do_check_true(s1.appDisabled);
  do_check_false(s1.isActive);

  yield load_blocklist("test_softblocked1.xml");

  do_check_true(s1.softDisabled);
  do_check_true(s1.appDisabled);
  do_check_false(s1.isActive);

  yield promiseRestartManager("2");

  s1 = yield promiseAddonByID("softblock1@tests.mozilla.org");

  do_check_true(s1.softDisabled);
  do_check_false(s1.appDisabled);
  do_check_false(s1.isActive);
});
