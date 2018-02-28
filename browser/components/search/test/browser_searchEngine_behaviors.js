/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Test search plugin URLs
 */

"use strict";

const SEARCH_ENGINE_DETAILS = [{
  alias: "a",
  baseURL: "https://www.amazon.com/exec/obidos/external-search/?field-keywords=foo&ie=UTF-8&mode=blended&tag=mozilla-20&sourceid=Mozilla-search",
  codes: {
    context: "",
    keyword: "",
    newTab: "",
    submission: "",
  },
  name: "Amazon.com",
}, {
  alias: "b",
  baseURL: "https://www.bing.com/search?q=foo&pc=MOZI",
  codes: {
    context: "&form=MOZCON",
    keyword: "&form=MOZLBR",
    newTab: "&form=MOZTSB",
    submission: "&form=MOZSBR",
  },
  name: "Bing",
}, {
  alias: "d",
  baseURL: "https://duckduckgo.com/?q=foo",
  codes: {
    context: "&t=ffcm",
    keyword: "&t=ffab",
    newTab: "&t=ffnt",
    submission: "&t=ffsb",
  },
  name: "DuckDuckGo",
}, {
// TODO: Google is tested in browser_google_behaviors.js - we can't test it here
// yet because of bug 1315953.
//   alias: "g",
//   baseURL: "https://www.google.com/search?q=foo&ie=utf-8&oe=utf-8",
//   codes: {
//     context: "",
//     keyword: "",
//     newTab: "",
//     submission: "",
//   },
//   name: "Google",
// }, {
  alias: "y",
  baseURL: "https://search.yahoo.com/yhs/search?p=foo&ei=UTF-8&hspart=mozilla",
  codes: {
    context: "&hsimp=yhs-005",
    keyword: "&hsimp=yhs-002",
    newTab: "&hsimp=yhs-004",
    submission: "&hsimp=yhs-001",
  },
  name: "Yahoo",
}];

function promiseStateChangeURI() {
  return new Promise(resolve => {
    let listener = {
      onStateChange: function onStateChange(webProgress, req, flags, status) {
        info("onStateChange");
        // Only care about top-level document starts
        let docStart = Ci.nsIWebProgressListener.STATE_IS_DOCUMENT |
                       Ci.nsIWebProgressListener.STATE_START;
        if (!(flags & docStart) || !webProgress.isTopLevel)
          return;

        if (req.originalURI.spec == "about:blank")
          return;

        gBrowser.removeProgressListener(listener);

        info("received document start");

        Assert.ok(req instanceof Ci.nsIChannel, "req is a channel");

        req.cancel(Components.results.NS_ERROR_FAILURE);

        executeSoon(() => {
          resolve(req.originalURI.spec);
        });
      }
    }

    gBrowser.addProgressListener(listener);
  });
}

function promiseContentSearchReady(browser) {
  return ContentTask.spawn(browser, {}, async function(args) {
    return new Promise(resolve => {
      content.addEventListener("ContentSearchService", function listener(aEvent) {
        if (aEvent.detail.type == "State") {
          content.removeEventListener("ContentSearchService", listener);
          resolve();
        }
      });
    });
  });
}

for (let engine of SEARCH_ENGINE_DETAILS) {
  add_task(async function() {
    let previouslySelectedEngine = Services.search.currentEngine;

    registerCleanupFunction(function() {
      Services.search.currentEngine = previouslySelectedEngine;
    });

    await testSearchEngine(engine);
  });
}

async function testSearchEngine(engineDetails) {
  let engine = Services.search.getEngineByName(engineDetails.name);
  Assert.ok(engine, `${engineDetails.name} is installed`);

  Services.search.currentEngine = engine;
  engine.alias = engineDetails.alias;

  let base = engineDetails.baseURL;

  // Test search URLs (including purposes).
  let url = engine.getSubmission("foo").uri.spec;
  Assert.equal(url, base + engineDetails.codes.submission, "Check search URL for 'foo'");

  let engineTests = [
    {
      name: "context menu search",
      searchURL: base + engineDetails.codes.context,
      run() {
        // Simulate a contextmenu search
        // FIXME: This is a bit "low-level"...
        BrowserSearch.loadSearch("foo", false, "contextmenu");
      }
    },
    {
      name: "keyword search",
      searchURL: base + engineDetails.codes.keyword,
      run() {
        gURLBar.value = "? foo";
        gURLBar.focus();
        EventUtils.synthesizeKey("VK_RETURN", {});
      }
    },
    {
      name: "keyword search with alias",
      searchURL: base + engineDetails.codes.keyword,
      run() {
        gURLBar.value = `${engineDetails.alias} foo`;
        gURLBar.focus();
        EventUtils.synthesizeKey("VK_RETURN", {});
      }
    },
    {
      name: "search bar search",
      searchURL: base + engineDetails.codes.submission,
      run() {
        let sb = BrowserSearch.searchBar;
        sb.focus();
        sb.value = "foo";
        registerCleanupFunction(function() {
          sb.value = "";
        });
        EventUtils.synthesizeKey("VK_RETURN", {});
      }
    },
    {
      name: "new tab search",
      searchURL: base + engineDetails.codes.newTab,
      async preTest(tab) {
        let browser = tab.linkedBrowser
        await BrowserTestUtils.loadURI(browser, "about:newtab");
        await BrowserTestUtils.browserLoaded(browser);

        await promiseContentSearchReady(browser);
      },
      async run(tab) {
        await ContentTask.spawn(tab.linkedBrowser, {}, async function(args) {
          let input = content.document.querySelector("input[id*=search-]");
          input.focus();
          input.value = "foo";
        });
        EventUtils.synthesizeKey("VK_RETURN", {});
      }
    }
  ];

  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser);

  for (let test of engineTests) {
    info(`Running: ${test.name}`);

    if (test.preTest) {
      await test.preTest(tab);
    }

    let stateChangePromise = promiseStateChangeURI();

    await test.run(tab);

    let receivedURI = await stateChangePromise;

    Assert.equal(receivedURI, test.searchURL);
  }

  engine.alias = undefined;
  await BrowserTestUtils.removeTab(tab);
}
