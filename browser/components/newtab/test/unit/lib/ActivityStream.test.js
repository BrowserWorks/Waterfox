import { CONTENT_MESSAGE_TYPE } from "common/Actions.jsm";
import injector from "inject!lib/ActivityStream.jsm";

describe("ActivityStream", () => {
  let sandbox;
  let as;
  let ActivityStream;
  let PREFS_CONFIG;
  function Fake() {}
  function FakeStore() {
    return { init: () => {}, uninit: () => {}, feeds: { get: () => {} } };
  }

  beforeEach(() => {
    sandbox = sinon.createSandbox();
    ({ ActivityStream, PREFS_CONFIG } = injector({
      "lib/Store.jsm": { Store: FakeStore },
      "lib/AboutPreferences.jsm": { AboutPreferences: Fake },
      "lib/NewTabInit.jsm": { NewTabInit: Fake },
      "lib/PlacesFeed.jsm": { PlacesFeed: Fake },
      "lib/PrefsFeed.jsm": { PrefsFeed: Fake },
      "lib/SectionsManager.jsm": { SectionsFeed: Fake },
      "lib/SystemTickFeed.jsm": { SystemTickFeed: Fake },
      "lib/TelemetryFeed.jsm": { TelemetryFeed: Fake },
      "lib/FaviconFeed.jsm": { FaviconFeed: Fake },
      "lib/TopSitesFeed.jsm": { TopSitesFeed: Fake },
      "lib/TopStoriesFeed.jsm": { TopStoriesFeed: Fake },
      "lib/HighlightsFeed.jsm": { HighlightsFeed: Fake },
      "lib/ASRouterFeed.jsm": { ASRouterFeed: Fake },
      "lib/RecommendationProviderSwitcher.jsm": {
        RecommendationProviderSwitcher: Fake,
      },
      "lib/DiscoveryStreamFeed.jsm": { DiscoveryStreamFeed: Fake },
    }));
    as = new ActivityStream();
    sandbox.stub(as.store, "init");
    sandbox.stub(as.store, "uninit");
    sandbox.stub(as._defaultPrefs, "init");
  });

  afterEach(() => sandbox.restore());

  it("should exist", () => {
    assert.ok(ActivityStream);
  });
  it("should initialize with .initialized=false", () => {
    assert.isFalse(as.initialized, ".initialized");
  });
  describe("#init", () => {
    beforeEach(() => {
      as.init();
    });
    it("should initialize default prefs", () => {
      assert.calledOnce(as._defaultPrefs.init);
    });
    it("should set .initialized to true", () => {
      assert.isTrue(as.initialized, ".initialized");
    });
    it("should call .store.init", () => {
      assert.calledOnce(as.store.init);
    });
    it("should pass to Store an INIT event for content", () => {
      as.init();

      const [, action] = as.store.init.firstCall.args;
      assert.equal(action.meta.to, CONTENT_MESSAGE_TYPE);
    });
    it("should pass to Store an UNINIT event", () => {
      as.init();

      const [, , action] = as.store.init.firstCall.args;
      assert.equal(action.type, "UNINIT");
    });
    it("should clear old default discoverystream config pref", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox
        .stub(global.Services.prefs, "getStringPref")
        .returns(
          `{"api_key_pref":"extensions.pocket.oAuthConsumerKey","enabled":false,"show_spocs":true,"layout_endpoint":"https://getpocket.cdn.mozilla.net/v3/newtab/layout?version=1&consumer_key=$apiKey&layout_variant=basic"}`
        );
      sandbox.stub(global.Services.prefs, "clearUserPref");

      as.init();

      assert.calledWith(
        global.Services.prefs.clearUserPref,
        "browser.newtabpage.activity-stream.discoverystream.config"
      );
    });
  });
  describe("#uninit", () => {
    beforeEach(() => {
      as.init();
      as.uninit();
    });
    it("should set .initialized to false", () => {
      assert.isFalse(as.initialized, ".initialized");
    });
    it("should call .store.uninit", () => {
      assert.calledOnce(as.store.uninit);
    });
  });
  describe("feeds", () => {
    it("should create a NewTabInit feed", () => {
      const feed = as.feeds.get("feeds.newtabinit")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a Places feed", () => {
      const feed = as.feeds.get("feeds.places")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a TopSites feed", () => {
      const feed = as.feeds.get("feeds.system.topsites")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a Telemetry feed", () => {
      const feed = as.feeds.get("feeds.telemetry")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a Prefs feed", () => {
      const feed = as.feeds.get("feeds.prefs")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a HighlightsFeed feed", () => {
      const feed = as.feeds.get("feeds.section.highlights")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a TopStoriesFeed feed", () => {
      const feed = as.feeds.get("feeds.system.topstories")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a AboutPreferences feed", () => {
      const feed = as.feeds.get("feeds.aboutpreferences")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a SectionsFeed", () => {
      const feed = as.feeds.get("feeds.sections")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a SystemTick feed", () => {
      const feed = as.feeds.get("feeds.systemtick")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a Favicon feed", () => {
      const feed = as.feeds.get("feeds.favicon")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a ASRouter feed", () => {
      const feed = as.feeds.get("feeds.asrouterfeed")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a RecommendationProviderSwitcher feed", () => {
      const feed = as.feeds.get("feeds.recommendationproviderswitcher")();
      assert.instanceOf(feed, Fake);
    });
    it("should create a DiscoveryStreamFeed feed", () => {
      const feed = as.feeds.get("feeds.discoverystreamfeed")();
      assert.instanceOf(feed, Fake);
    });
  });
  describe("_migratePref", () => {
    it("should migrate a pref if the user has set a custom value", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox.stub(global.Services.prefs, "getPrefType").returns("integer");
      sandbox.stub(global.Services.prefs, "getIntPref").returns(10);
      as._migratePref("oldPrefName", result => assert.equal(10, result));
    });
    it("should not migrate a pref if the user has not set a custom value", () => {
      // we bailed out early so we don't check the pref type later
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(false);
      sandbox.stub(global.Services.prefs, "getPrefType");
      as._migratePref("oldPrefName");
      assert.notCalled(global.Services.prefs.getPrefType);
    });
    it("should use the proper pref getter for each type", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);

      // Integer
      sandbox.stub(global.Services.prefs, "getIntPref");
      sandbox.stub(global.Services.prefs, "getPrefType").returns("integer");
      as._migratePref("oldPrefName", () => {});
      assert.calledWith(global.Services.prefs.getIntPref, "oldPrefName");

      // Boolean
      sandbox.stub(global.Services.prefs, "getBoolPref");
      global.Services.prefs.getPrefType.returns("boolean");
      as._migratePref("oldPrefName", () => {});
      assert.calledWith(global.Services.prefs.getBoolPref, "oldPrefName");

      // String
      sandbox.stub(global.Services.prefs, "getStringPref");
      global.Services.prefs.getPrefType.returns("string");
      as._migratePref("oldPrefName", () => {});
      assert.calledWith(global.Services.prefs.getStringPref, "oldPrefName");
    });
    it("should clear the old pref after setting the new one", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox.stub(global.Services.prefs, "clearUserPref");
      sandbox.stub(global.Services.prefs, "getPrefType").returns("integer");
      as._migratePref("oldPrefName", () => {});
      assert.calledWith(global.Services.prefs.clearUserPref, "oldPrefName");
    });
  });
  describe("_updateDynamicPrefs Discovery Stream", () => {
    it("should be true with expected en-US geo and locale", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox.stub(global.Services.prefs, "getStringPref").returns("US");
      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-US");

      as._updateDynamicPrefs();

      assert.isTrue(
        JSON.parse(PREFS_CONFIG.get("discoverystream.config").value).enabled
      );
    });
    it("should be true with expected en-CA geo and locale", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox.stub(global.Services.prefs, "getStringPref").returns("CA");
      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-CA");

      as._updateDynamicPrefs();

      assert.isTrue(
        JSON.parse(PREFS_CONFIG.get("discoverystream.config").value).enabled
      );
    });
    it("should be true with expected de geo and locale", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      sandbox.stub(global.Services.prefs, "getStringPref").returns("DE");
      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "de-DE");

      as._updateDynamicPrefs();

      assert.isTrue(
        JSON.parse(PREFS_CONFIG.get("discoverystream.config").value).enabled
      );
    });
    it("should enable spocs based on region based pref", () => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      const getStringPrefStub = sandbox.stub(
        global.Services.prefs,
        "getStringPref"
      );
      getStringPrefStub.withArgs("browser.search.region").returns("CA");
      getStringPrefStub
        .withArgs(
          "browser.newtabpage.activity-stream.discoverystream.region-spocs-config"
        )
        .returns("US,CA");

      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-CA");

      as._updateDynamicPrefs();

      assert.isTrue(
        JSON.parse(PREFS_CONFIG.get("discoverystream.config").value).show_spocs
      );
    });
  });
  describe("discoverystream.region-basic-layout config", () => {
    let getStringPrefStub;
    beforeEach(() => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      getStringPrefStub = sandbox.stub(global.Services.prefs, "getStringPref");
      getStringPrefStub.withArgs("browser.search.region").returns("CA");

      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-CA");
    });
    it("should enable 1 row layout pref based on region layout pref", () => {
      getStringPrefStub
        .withArgs(
          "browser.newtabpage.activity-stream.discoverystream.region-layout-config"
        )
        .returns("US");

      as._updateDynamicPrefs();

      assert.isTrue(
        PREFS_CONFIG.get("discoverystream.region-basic-layout").value
      );
    });
    it("should enable 7 row layout pref based on region layout pref", () => {
      getStringPrefStub
        .withArgs(
          "browser.newtabpage.activity-stream.discoverystream.region-layout-config"
        )
        .returns("US,CA");

      as._updateDynamicPrefs();

      assert.isFalse(
        PREFS_CONFIG.get("discoverystream.region-basic-layout").value
      );
    });
  });
  describe("_updateDynamicPrefs topstories default value", () => {
    let getStringPrefStub;
    let getBoolPrefStub;
    let appLocaleAsBCP47Stub;
    let prefHasUserValueStub;
    beforeEach(() => {
      prefHasUserValueStub = sandbox.stub(
        global.Services.prefs,
        "prefHasUserValue"
      );
      getStringPrefStub = sandbox.stub(global.Services.prefs, "getStringPref");
      appLocaleAsBCP47Stub = sandbox.stub(
        global.Services.locale,
        "appLocaleAsBCP47"
      );

      getBoolPrefStub = sandbox.stub(global.Services.prefs, "getBoolPref");
      getBoolPrefStub
        .withArgs("browser.newtabpage.activity-stream.feeds.section.topstories")
        .returns(true);

      prefHasUserValueStub.returns(true);
      appLocaleAsBCP47Stub.get(() => "en-US");

      getStringPrefStub.withArgs("browser.search.region").returns("US");

      getStringPrefStub
        .withArgs(
          "browser.newtabpage.activity-stream.discoverystream.region-stories-config"
        )
        .returns("US,CA");
    });
    it("should be false with no geo/locale", () => {
      prefHasUserValueStub.returns(false);
      appLocaleAsBCP47Stub.get(() => "");
      getStringPrefStub.withArgs("browser.search.region").returns("");

      as._updateDynamicPrefs();

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should be false with unexpected geo", () => {
      getStringPrefStub.withArgs("browser.search.region").returns("NOGEO");

      as._updateDynamicPrefs();

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should be false with expected geo and unexpected locale", () => {
      appLocaleAsBCP47Stub.get(() => "no-LOCALE");

      as._updateDynamicPrefs();

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should be true with expected geo and locale", () => {
      as._updateDynamicPrefs();
      assert.isTrue(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should be false after expected geo and locale then unexpected", () => {
      getStringPrefStub
        .withArgs("browser.search.region")
        .onFirstCall()
        .returns("US")
        .onSecondCall()
        .returns("NOGEO");

      as._updateDynamicPrefs();
      as._updateDynamicPrefs();

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should be true with updated pref change", () => {
      appLocaleAsBCP47Stub.get(() => "en-GB");
      getStringPrefStub.withArgs("browser.search.region").returns("GB");
      getStringPrefStub
        .withArgs(
          "browser.newtabpage.activity-stream.discoverystream.region-stories-config"
        )
        .returns("US,CA,GB");

      as._updateDynamicPrefs();

      assert.isTrue(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
  });
  describe("_updateDynamicPrefs topstories delayed default value", () => {
    let clock;
    beforeEach(() => {
      clock = sinon.useFakeTimers();

      // Have addObserver cause prefHasUserValue to now return true then observe
      sandbox
        .stub(global.Services.prefs, "addObserver")
        .callsFake((pref, obs) => {
          sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
          setTimeout(() => obs.observe(null, "nsPref:changed", pref)); // eslint-disable-line max-nested-callbacks
        });
    });
    afterEach(() => clock.restore());

    it("should set false with unexpected geo", () => {
      sandbox.stub(global.Services.prefs, "getStringPref").returns("NOGEO");

      as._updateDynamicPrefs();
      clock.tick(1);

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should set true with expected geo and locale", () => {
      sandbox.stub(global.Services.prefs, "getStringPref").returns("US");
      sandbox.stub(global.Services.prefs, "getBoolPref").returns(true);
      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-US");

      as._updateDynamicPrefs();
      clock.tick(1);

      assert.isTrue(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
    it("should not change default even with expected geo and locale", () => {
      as._defaultPrefs.set("feeds.system.topstories", false);
      sandbox.stub(global.Services.prefs, "getStringPref").returns("US");
      sandbox
        .stub(global.Services.locale, "appLocaleAsBCP47")
        .get(() => "en-US");

      as._updateDynamicPrefs();
      clock.tick(1);

      assert.isFalse(PREFS_CONFIG.get("feeds.system.topstories").value);
    });
  });
  describe("telemetry reporting on init failure", () => {
    it("should send a ping on init error", () => {
      as = new ActivityStream();
      const telemetry = { handleUndesiredEvent: sandbox.spy() };
      sandbox.stub(as.store, "init").throws();
      sandbox.stub(as.store.feeds, "get").returns(telemetry);
      try {
        as.init();
      } catch (e) {}
      assert.calledOnce(telemetry.handleUndesiredEvent);
    });
  });

  describe("searchs shortcuts shouldPin pref", () => {
    const SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF =
      "improvesearch.topSiteSearchShortcuts.searchEngines";
    let stub;

    beforeEach(() => {
      sandbox.stub(global.Services.prefs, "prefHasUserValue").returns(true);
      stub = sandbox.stub(global.Services.prefs, "getStringPref");
    });

    it("should be an empty string when no geo is available", () => {
      as._updateDynamicPrefs();
      assert.equal(
        PREFS_CONFIG.get(SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF).value,
        ""
      );
    });

    it("should be 'baidu' in China", () => {
      stub.returns("CN");
      as._updateDynamicPrefs();
      assert.equal(
        PREFS_CONFIG.get(SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF).value,
        "baidu"
      );
    });

    it("should be 'yandex' in Russia, Belarus, Kazakhstan, and Turkey", () => {
      const geos = ["BY", "KZ", "RU", "TR"];
      for (const geo of geos) {
        stub.returns(geo);
        as._updateDynamicPrefs();
        assert.equal(
          PREFS_CONFIG.get(SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF).value,
          "yandex"
        );
      }
    });

    it("should be 'google,amazon' in Germany, France, the UK, Japan, Italy, and the US", () => {
      const geos = ["DE", "FR", "GB", "IT", "JP", "US"];
      for (const geo of geos) {
        stub.returns(geo);
        as._updateDynamicPrefs();
        assert.equal(
          PREFS_CONFIG.get(SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF).value,
          "google,amazon"
        );
      }
    });

    it("should be 'google' elsewhere", () => {
      // A selection of other geos
      const geos = ["BR", "CA", "ES", "ID", "IN"];
      for (const geo of geos) {
        stub.returns(geo);
        as._updateDynamicPrefs();
        assert.equal(
          PREFS_CONFIG.get(SEARCH_SHORTCUTS_SEARCH_ENGINES_PREF).value,
          "google"
        );
      }
    });
  });
});
