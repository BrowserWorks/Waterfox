/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/* import-globals-from head_appinfo.js */
/* import-globals-from ../../../common/tests/unit/head_helpers.js */
/* import-globals-from head_errorhandler_common.js */
/* import-globals-from head_http_server.js */

// This file expects Service to be defined in the global scope when EHTestsCommon
// is used (from service.js).
/* global Service */

Cu.import("resource://services-common/async.js");
Cu.import("resource://testing-common/services/common/utils.js");
Cu.import("resource://testing-common/PlacesTestUtils.jsm");
Cu.import("resource://services-sync/util.js");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/PlacesUtils.jsm");
Cu.import("resource://gre/modules/ObjectUtils.jsm");

XPCOMUtils.defineLazyGetter(this, "SyncPingSchema", function() {
  let ns = {};
  Cu.import("resource://gre/modules/FileUtils.jsm", ns);
  let stream = Cc["@mozilla.org/network/file-input-stream;1"]
               .createInstance(Ci.nsIFileInputStream);
  let jsonReader = Cc["@mozilla.org/dom/json;1"]
                   .createInstance(Components.interfaces.nsIJSON);
  let schema;
  try {
    let schemaFile = do_get_file("sync_ping_schema.json");
    stream.init(schemaFile, ns.FileUtils.MODE_RDONLY, ns.FileUtils.PERMS_FILE, 0);
    schema = jsonReader.decodeFromStream(stream, stream.available());
  } finally {
    stream.close();
  }

  // Allow tests to make whatever engines they want, this shouldn't cause
  // validation failure.
  schema.definitions.engine.properties.name = { type: "string" };
  return schema;
});

XPCOMUtils.defineLazyGetter(this, "SyncPingValidator", function() {
  let ns = {};
  Cu.import("resource://testing-common/ajv-4.1.1.js", ns);
  let ajv = new ns.Ajv({ async: "co*" });
  return ajv.compile(SyncPingSchema);
});

var provider = {
  getFile(prop, persistent) {
    persistent.value = true;
    switch (prop) {
      case "ExtPrefDL":
        return [Services.dirsvc.get("CurProcD", Ci.nsIFile)];
      default:
        throw Cr.NS_ERROR_FAILURE;
    }
  },
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIDirectoryServiceProvider])
};
Services.dirsvc.QueryInterface(Ci.nsIDirectoryService).registerProvider(provider);

// This is needed for loadAddonTestFunctions().
var gGlobalScope = this;

function ExtensionsTestPath(path) {
  if (path[0] != "/") {
    throw Error("Path must begin with '/': " + path);
  }

  return "../../../../toolkit/mozapps/extensions/test/xpcshell" + path;
}

/**
 * Loads the AddonManager test functions by importing its test file.
 *
 * This should be called in the global scope of any test file needing to
 * interface with the AddonManager. It should only be called once, or the
 * universe will end.
 */
function loadAddonTestFunctions() {
  const path = ExtensionsTestPath("/head_addons.js");
  let file = do_get_file(path);
  let uri = Services.io.newFileURI(file);
  /* import-globals-from ../../../../toolkit/mozapps/extensions/test/xpcshell/head_addons.js */
  Services.scriptloader.loadSubScript(uri.spec, gGlobalScope);
  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");
}

function webExtensionsTestPath(path) {
  if (path[0] != "/") {
    throw Error("Path must begin with '/': " + path);
  }

  return "../../../../toolkit/components/extensions/test/xpcshell" + path;
}

/**
 * Loads the WebExtension test functions by importing its test file.
 */
function loadWebExtensionTestFunctions() {
  /* import-globals-from ../../../../toolkit/components/extensions/test/xpcshell/head_sync.js */
  const path = webExtensionsTestPath("/head_sync.js");
  let file = do_get_file(path);
  let uri = Services.io.newFileURI(file);
  Services.scriptloader.loadSubScript(uri.spec, gGlobalScope);
}

function getAddonInstall(name) {
  let f = do_get_file(ExtensionsTestPath("/addons/" + name + ".xpi"));
  let cb = Async.makeSyncCallback();
  AddonManager.getInstallForFile(f, cb);

  return Async.waitForSyncCallback(cb);
}

/**
 * Obtains an addon from the add-on manager by id.
 *
 * This is merely a synchronous wrapper.
 *
 * @param  id
 *         ID of add-on to fetch
 * @return addon object on success or undefined or null on failure
 */
function getAddonFromAddonManagerByID(id) {
   let cb = Async.makeSyncCallback();
   AddonManager.getAddonByID(id, cb);
   return Async.waitForSyncCallback(cb);
}

/**
 * Installs an add-on synchronously from an addonInstall
 *
 * @param  install addonInstall instance to install
 */
function installAddonFromInstall(install) {
  let cb = Async.makeSyncCallback();
  let listener = {onInstallEnded: cb};
  AddonManager.addInstallListener(listener);
  install.install();
  Async.waitForSyncCallback(cb);
  AddonManager.removeAddonListener(listener);

  do_check_neq(null, install.addon);
  do_check_neq(null, install.addon.syncGUID);

  return install.addon;
}

/**
 * Convenience function to install an add-on from the extensions unit tests.
 *
 * @param  name
 *         String name of add-on to install. e.g. test_install1
 * @return addon object that was installed
 */
function installAddon(name) {
  let install = getAddonInstall(name);
  do_check_neq(null, install);
  return installAddonFromInstall(install);
}

/**
 * Convenience function to uninstall an add-on synchronously.
 *
 * @param addon
 *        Addon instance to uninstall
 */
function uninstallAddon(addon) {
  let cb = Async.makeSyncCallback();
  let listener = {onUninstalled(uninstalled) {
    if (uninstalled.id == addon.id) {
      AddonManager.removeAddonListener(listener);
      cb(uninstalled);
    }
  }};

  AddonManager.addAddonListener(listener);
  addon.uninstall();
  Async.waitForSyncCallback(cb);
}

function generateNewKeys(collectionKeys, collections = null) {
  let wbo = collectionKeys.generateNewKeysWBO(collections);
  let modified = new_timestamp();
  collectionKeys.setContents(wbo.cleartext, modified);
}

// Helpers for testing open tabs.
// These reflect part of the internal structure of TabEngine,
// and stub part of Service.wm.

function mockShouldSkipWindow(win) {
  return win.closed ||
         win.mockIsPrivate;
}

function mockGetTabState(tab) {
  return tab;
}

function mockGetWindowEnumerator(url, numWindows, numTabs, indexes, moreURLs) {
  let elements = [];

  function url2entry(urlToConvert) {
    return {
      url: ((typeof urlToConvert == "function") ? urlToConvert() : urlToConvert),
      title: "title"
    };
  }

  for (let w = 0; w < numWindows; ++w) {
    let tabs = [];
    let win = {
      closed: false,
      mockIsPrivate: false,
      gBrowser: {
        tabs,
      },
    };
    elements.push(win);

    for (let t = 0; t < numTabs; ++t) {
      tabs.push(TestingUtils.deepCopy({
        index: indexes ? indexes() : 1,
        entries: (moreURLs ? [url].concat(moreURLs()) : [url]).map(url2entry),
        attributes: {
          image: "image"
        },
        lastAccessed: 1499
      }));
    }
  }

  // Always include a closed window and a private window.
  elements.push({
    closed: true,
    mockIsPrivate: false,
    gBrowser: {
      tabs: [],
    },
  });

  elements.push({
    closed: false,
    mockIsPrivate: true,
    gBrowser: {
      tabs: [],
    },
  });

  return {
    hasMoreElements() {
      return elements.length;
    },
    getNext() {
      return elements.shift();
    },
  };
}

// Helper that allows checking array equality.
function do_check_array_eq(a1, a2) {
  do_check_eq(a1.length, a2.length);
  for (let i = 0; i < a1.length; ++i) {
    do_check_eq(a1[i], a2[i]);
  }
}

// Helper function to get the sync telemetry and add the typically used test
// engine names to its list of allowed engines.
function get_sync_test_telemetry() {
  let ns = {};
  Cu.import("resource://services-sync/telemetry.js", ns);
  let testEngines = ["rotary", "steam", "sterling", "catapult"];
  for (let engineName of testEngines) {
    ns.SyncTelemetry.allowedEngines.add(engineName);
  }
  ns.SyncTelemetry.submissionInterval = -1;
  return ns.SyncTelemetry;
}

function assert_valid_ping(record) {
  // This is called as the test harness tears down due to shutdown. This
  // will typically have no recorded syncs, and the validator complains about
  // it. So ignore such records (but only ignore when *both* shutdown and
  // no Syncs - either of them not being true might be an actual problem)
  if (record && (record.why != "shutdown" || record.syncs.length != 0)) {
    if (!SyncPingValidator(record)) {
      if (SyncPingValidator.errors.length) {
        // validation failed - using a simple |deepEqual([], errors)| tends to
        // truncate the validation errors in the output and doesn't show that
        // the ping actually was - so be helpful.
        do_print("telemetry ping validation failed");
        do_print("the ping data is: " + JSON.stringify(record, undefined, 2));
        do_print("the validation failures: " + JSON.stringify(SyncPingValidator.errors, undefined, 2));
        ok(false, "Sync telemetry ping validation failed - see output above for details");
      }
    }
    equal(record.version, 1);
    record.syncs.forEach(p => {
      lessOrEqual(p.when, Date.now());
      if (p.devices) {
        ok(!p.devices.some(device => device.id == record.deviceID));
        equal(new Set(p.devices.map(device => device.id)).size,
              p.devices.length, "Duplicate device ids in ping devices list");
      }
    });
  }
}

// Asserts that `ping` is a ping that doesn't contain any failure information
function assert_success_ping(ping) {
  ok(!!ping);
  assert_valid_ping(ping);
  ping.syncs.forEach(record => {
    ok(!record.failureReason, JSON.stringify(record.failureReason));
    equal(undefined, record.status);
    greater(record.engines.length, 0);
    for (let e of record.engines) {
      ok(!e.failureReason);
      equal(undefined, e.status);
      if (e.validation) {
        equal(undefined, e.validation.problems);
        equal(undefined, e.validation.failureReason);
      }
      if (e.outgoing) {
        for (let o of e.outgoing) {
          equal(undefined, o.failed);
          notEqual(undefined, o.sent);
        }
      }
      if (e.incoming) {
        equal(undefined, e.incoming.failed);
        equal(undefined, e.incoming.newFailed);
        notEqual(undefined, e.incoming.applied || e.incoming.reconciled);
      }
    }
  });
}

// Hooks into telemetry to validate all pings after calling.
function validate_all_future_pings() {
  let telem = get_sync_test_telemetry();
  telem.submit = assert_valid_ping;
}

function wait_for_pings(expectedPings) {
  return new Promise(resolve => {
    let telem = get_sync_test_telemetry();
    let oldSubmit = telem.submit;
    let pings = [];
    telem.submit = function(record) {
      pings.push(record);
      if (pings.length == expectedPings) {
        telem.submit = oldSubmit;
        resolve(pings);
      }
    };
  });
}

async function wait_for_ping(callback, allowErrorPings, getFullPing = false) {
  let pingsPromise = wait_for_pings(1);
  callback();
  let [record] = await pingsPromise;
  if (allowErrorPings) {
    assert_valid_ping(record);
  } else {
    assert_success_ping(record);
  }
  if (getFullPing) {
    return record;
  }
  equal(record.syncs.length, 1);
  return record.syncs[0];
}

// Short helper for wait_for_ping
function sync_and_validate_telem(allowErrorPings, getFullPing = false) {
  return wait_for_ping(() => Service.sync(), allowErrorPings, getFullPing);
}

// Used for the (many) cases where we do a 'partial' sync, where only a single
// engine is actually synced, but we still want to ensure we're generating a
// valid ping. Returns a promise that resolves to the ping, or rejects with the
// thrown error after calling an optional callback.
function sync_engine_and_validate_telem(engine, allowErrorPings, onError) {
  return new Promise((resolve, reject) => {
    let telem = get_sync_test_telemetry();
    let caughtError = null;
    // Clear out status, so failures from previous syncs won't show up in the
    // telemetry ping.
    let ns = {};
    Cu.import("resource://services-sync/status.js", ns);
    ns.Status._engines = {};
    ns.Status.partial = false;
    // Ideally we'd clear these out like we do with engines, (probably via
    // Status.resetSync()), but this causes *numerous* tests to fail, so we just
    // assume that if no failureReason or engine failures are set, and the
    // status properties are the same as they were initially, that it's just
    // a leftover.
    // This is only an issue since we're triggering the sync of just one engine,
    // without doing any other parts of the sync.
    let initialServiceStatus = ns.Status._service;
    let initialSyncStatus = ns.Status._sync;

    let oldSubmit = telem.submit;
    telem.submit = function(ping) {
      telem.submit = oldSubmit;
      ping.syncs.forEach(record => {
        if (record && record.status) {
          // did we see anything to lead us to believe that something bad actually happened
          let realProblem = record.failureReason || record.engines.some(e => {
            if (e.failureReason || e.status) {
              return true;
            }
            if (e.outgoing && e.outgoing.some(o => o.failed > 0)) {
              return true;
            }
            return e.incoming && e.incoming.failed;
          });
          if (!realProblem) {
            // no, so if the status is the same as it was initially, just assume
            // that its leftover and that we can ignore it.
            if (record.status.sync && record.status.sync == initialSyncStatus) {
              delete record.status.sync;
            }
            if (record.status.service && record.status.service == initialServiceStatus) {
              delete record.status.service;
            }
            if (!record.status.sync && !record.status.service) {
              delete record.status;
            }
          }
        }
      });
      if (allowErrorPings) {
        assert_valid_ping(ping);
      } else {
        assert_success_ping(ping);
      }
      equal(ping.syncs.length, 1);
      if (caughtError) {
        if (onError) {
          onError(ping.syncs[0], ping);
        }
        reject(caughtError);
      } else {
        resolve(ping.syncs[0]);
      }
    }
    Svc.Obs.notify("weave:service:sync:start");
    try {
      engine.sync();
    } catch (e) {
      caughtError = e;
    }
    if (caughtError) {
      Svc.Obs.notify("weave:service:sync:error", caughtError);
    } else {
      Svc.Obs.notify("weave:service:sync:finish");
    }
  });
}

// Returns a promise that resolves once the specified observer notification
// has fired.
function promiseOneObserver(topic, callback) {
  return new Promise((resolve, reject) => {
    let observer = function(subject, data) {
      Svc.Obs.remove(topic, observer);
      resolve({ subject, data });
    }
    Svc.Obs.add(topic, observer)
  });
}

function promiseStopServer(server) {
  return new Promise(resolve => server.stop(resolve));
}

function promiseNextTick() {
  return new Promise(resolve => {
    Utils.nextTick(resolve);
  });
}
// Avoid an issue where `client.name2` containing unicode characters causes
// a number of tests to fail, due to them assuming that we do not need to utf-8
// encode or decode data sent through the mocked server (see bug 1268912).
// We stash away the original implementation so test_utils_misc.js can test it.
Utils._orig_getDefaultDeviceName = Utils.getDefaultDeviceName;
Utils.getDefaultDeviceName = function() {
  return "Test device name";
};

function registerRotaryEngine() {
  let {RotaryEngine} =
    Cu.import("resource://testing-common/services/sync/rotaryengine.js", {});
  Service.engineManager.clear();

  Service.engineManager.register(RotaryEngine);
  let engine = Service.engineManager.get("rotary");
  engine.enabled = true;

  return { engine, tracker: engine._tracker };
}

// Set the validation prefs to attempt validation every time to avoid non-determinism.
function enableValidationPrefs() {
  Svc.Prefs.set("engine.bookmarks.validation.interval", 0);
  Svc.Prefs.set("engine.bookmarks.validation.percentageChance", 100);
  Svc.Prefs.set("engine.bookmarks.validation.maxRecords", -1);
  Svc.Prefs.set("engine.bookmarks.validation.enabled", true);
}

function serverForEnginesWithKeys(users, engines, callback) {
  // Generate and store a fake default key bundle to avoid resetting the client
  // before the first sync.
  let wbo = Service.collectionKeys.generateNewKeysWBO();
  let modified = new_timestamp();
  Service.collectionKeys.setContents(wbo.cleartext, modified);

  let allEngines = [Service.clientsEngine].concat(engines);

  let globalEngines = allEngines.reduce((entries, engine) => {
    let { name, version, syncID } = engine;
    entries[name] = { version, syncID };
    return entries;
  }, {});

  let contents = allEngines.reduce((collections, engine) => {
    collections[engine.name] = {};
    return collections;
  }, {
    meta: {
      global: {
        syncID: Service.syncID,
        storageVersion: STORAGE_VERSION,
        engines: globalEngines,
      },
    },
    crypto: {
      keys: encryptPayload(wbo.cleartext),
    },
  });

  return serverForUsers(users, contents, callback);
}

function serverForFoo(engine, callback) {
  // The bookmarks engine *always* tracks changes, meaning we might try
  // and sync due to the bookmarks we ourselves create! Worse, because we
  // do an engine sync only, there's no locking - so we end up with multiple
  // syncs running. Neuter that by making the threshold very large.
  Service.scheduler.syncThreshold = 10000000;
  return serverForEnginesWithKeys({"foo": "password"}, engine, callback);
}

// Places notifies history observers asynchronously, so `addVisits` might return
// before the tracker receives the notification. This helper registers an
// observer that resolves once the expected notification fires.
async function promiseVisit(expectedType, expectedURI) {
  return new Promise(resolve => {
    function done(type, uri) {
      if (uri.equals(expectedURI) && type == expectedType) {
        PlacesUtils.history.removeObserver(observer);
        resolve();
      }
    }
    let observer = {
      onVisit(uri) {
        done("added", uri);
      },
      onBeginUpdateBatch() {},
      onEndUpdateBatch() {},
      onTitleChanged() {},
      onFrecencyChanged() {},
      onManyFrecenciesChanged() {},
      onDeleteURI(uri) {
        done("removed", uri);
      },
      onClearHistory() {},
      onPageChanged() {},
      onDeleteVisits() {},
    };
    PlacesUtils.history.addObserver(observer, false);
  });
}

async function addVisit(suffix, referrer = null, transition = PlacesUtils.history.TRANSITION_LINK) {
  let uriString = "http://getfirefox.com/" + suffix;
  let uri = Utils.makeURI(uriString);
  _("Adding visit for URI " + uriString);

  let visitAddedPromise = promiseVisit("added", uri);
  await PlacesTestUtils.addVisits({
    uri,
    visitDate: Date.now() * 1000,
    transition,
    referrer,
  });
  await visitAddedPromise;

  return uri;
}

function bookmarkNodesToInfos(nodes) {
  return nodes.map(node => {
    let info = {
      guid: node.guid,
      index: node.index,
    };
    if (node.children) {
      info.children = bookmarkNodesToInfos(node.children);
    }
    if (node.annos) {
      let orphanAnno = node.annos.find(anno =>
        anno.name == "sync/parent"
      );
      if (orphanAnno) {
        info.requestedParent = orphanAnno.value;
      }
    }
    return info;
  });
}

async function assertBookmarksTreeMatches(rootGuid, expected, message) {
  let root = await PlacesUtils.promiseBookmarksTree(rootGuid);
  let actual = bookmarkNodesToInfos(root.children);

  if (!ObjectUtils.deepEqual(actual, expected)) {
    _(`Expected structure for ${rootGuid}`, JSON.stringify(expected));
    _(`Actual structure for ${rootGuid}`, JSON.stringify(actual));
    throw new Assert.constructor.AssertionError({ actual, expected, message });
  }
}
