/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

// This test is designed to check the search service keeps working if there's
// a built-in engine missing from the configuration.

"use strict";

const { MockRegistrar } = ChromeUtils.import(
  "resource://testing-common/MockRegistrar.jsm"
);

const SEARCH_SERVICE_TOPIC = "browser-search-service";
const SEARCH_ENGINE_TOPIC = "browser-search-engine-modified";

const GOOD_CONFIG = [
  {
    webExtension: {
      id: "engine@search.waterfox.net",
    },
    appliesTo: [
      {
        included: { everywhere: true },
      },
    ],
  },
];

const BAD_CONFIG = [
  ...GOOD_CONFIG,
  {
    webExtension: {
      id: "engine-missing@search.waterfox.net",
    },
    appliesTo: [
      {
        included: { everywhere: true },
      },
    ],
  },
];

// The mock idle service.
var idleService = {
  _observers: new Set(),

  _reset() {
    this._observers.clear();
  },

  _fireObservers(state) {
    for (let observer of this._observers.values()) {
      observer.observe(observer, state, null);
    }
  },

  QueryInterface: ChromeUtils.generateQI([Ci.nsIIdleService]),
  idleTime: 19999,

  addIdleObserver(observer, time) {
    this._observers.add(observer);
  },

  removeIdleObserver(observer, time) {
    this._observers.delete(observer);
  },
};

function listenFor(name, key) {
  let notifyObserved = false;
  let obs = (subject, topic, data) => {
    if (data == key) {
      notifyObserved = true;
    }
  };
  Services.obs.addObserver(obs, name);

  return () => {
    Services.obs.removeObserver(obs, name);
    return notifyObserved;
  };
}

let configurationStub;

add_task(async function setup() {
  let fakeIdleService = MockRegistrar.register(
    "@mozilla.org/widget/idleservice;1",
    idleService
  );
  registerCleanupFunction(() => {
    MockRegistrar.unregister(fakeIdleService);
  });

  await AddonTestUtils.promiseStartupManager();
});

add_task(async function test_startup_with_missing() {
  configurationStub = await useTestEngines("data", null, BAD_CONFIG);

  const result = await Services.search.init();
  Assert.ok(
    Components.isSuccessCode(result),
    "Should have started the search service successfully."
  );

  const engines = await Services.search.getEngines();

  Assert.deepEqual(
    engines.map(e => e.name),
    ["Test search engine"],
    "Should have listed just the good engine"
  );
});

add_task(async function test_update_with_missing() {
  configurationStub.returns(GOOD_CONFIG);

  await Services.search.reInit();

  const engines = await Services.search.getEngines();

  Assert.deepEqual(
    engines.map(e => e.name),
    ["Test search engine"],
    "Should have just the good engine"
  );

  // TODO: Bug 1542269: When remote settings is enabled, remove the reInit
  // and uncomment the code below.
  await Services.search.reInit();

  // const reloadObserved = SearchTestUtils.promiseSearchNotification(
  //   "engines-reloaded"
  // );
  //
  // await RemoteSettings(SearchUtils.SETTINGS_KEY).emit("sync", {
  //   data: {
  //     current: BAD_CONFIG,
  //   },
  // });
  //
  // idleService._fireObservers("idle");
  //
  // await reloadObserved;

  Assert.deepEqual(
    engines.map(e => e.name),
    ["Test search engine"],
    "Should still have just the good engine"
  );
});
