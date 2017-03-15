// Returns a function suitable for add_task which loads startURL, runs
// transitionTask and waits for endURL to load, checking that the URLs were
// loaded in the correct process.
function makeTest(name, startURL, startProcessIsRemote, endURL, endProcessIsRemote, transitionTask) {
  return function*() {
    info("Running test " + name + ", " + transitionTask.name);
    let browser = gBrowser.selectedBrowser;

    // In non-e10s nothing should be remote
    if (!gMultiProcessBrowser) {
      startProcessIsRemote = false;
      endProcessIsRemote = false;
    }

    // Load the initial URL and make sure we are in the right initial process
    info("Loading initial URL");
    browser.loadURI(startURL);
    yield waitForDocLoadComplete();

    is(browser.currentURI.spec, startURL, "Shouldn't have been redirected");
    is(browser.isRemoteBrowser, startProcessIsRemote, "Should be displayed in the right process");

    let docLoadedPromise = waitForDocLoadComplete();
    let asyncTask = Task.async(transitionTask);
    let expectSyncChange = yield asyncTask(browser, endURL);
    if (expectSyncChange) {
      is(browser.isRemoteBrowser, endProcessIsRemote, "Should have switched to the right process synchronously");
    }
    yield docLoadedPromise;

    is(browser.currentURI.spec, endURL, "Should have made it to the final URL");
    is(browser.isRemoteBrowser, endProcessIsRemote, "Should be displayed in the right process");
  }
}

const CHROME_PROCESS = Ci.nsIXULRuntime.PROCESS_TYPE_DEFAULT;
const CONTENT_PROCESS = Ci.nsIXULRuntime.PROCESS_TYPE_CONTENT;
const PATH = (getRootDirectory(gTestPath) + "test_process_flags_chrome.html").replace("chrome://mochitests", "");

const CHROME = "chrome://mochitests" + PATH;
const CANREMOTE = "chrome://mochitests-any" + PATH;
const MUSTREMOTE = "chrome://mochitests-content" + PATH;

add_task(function* init() {
  gBrowser.selectedTab = gBrowser.addTab("about:blank");
});

registerCleanupFunction(() => {
  gBrowser.removeCurrentTab();
});

function test_url(url, chromeResult, contentResult) {
  is(E10SUtils.canLoadURIInProcess(url, CHROME_PROCESS),
     chromeResult, "Check URL in chrome process.");
  is(E10SUtils.canLoadURIInProcess(url, CONTENT_PROCESS),
     contentResult, "Check URL in content process.");

  is(E10SUtils.canLoadURIInProcess(url + "#foo", CHROME_PROCESS),
     chromeResult, "Check URL with ref in chrome process.");
  is(E10SUtils.canLoadURIInProcess(url + "#foo", CONTENT_PROCESS),
     contentResult, "Check URL with ref in content process.");

  is(E10SUtils.canLoadURIInProcess(url + "?foo", CHROME_PROCESS),
     chromeResult, "Check URL with query in chrome process.");
  is(E10SUtils.canLoadURIInProcess(url + "?foo", CONTENT_PROCESS),
     contentResult, "Check URL with query in content process.");

  is(E10SUtils.canLoadURIInProcess(url + "?foo#bar", CHROME_PROCESS),
     chromeResult, "Check URL with query and ref in chrome process.");
  is(E10SUtils.canLoadURIInProcess(url + "?foo#bar", CONTENT_PROCESS),
     contentResult, "Check URL with query and ref in content process.");
}

add_task(function* test_chrome() {
  test_url(CHROME, true, false);
});

add_task(function* test_any() {
  test_url(CANREMOTE, true, true);
});

add_task(function* test_remote() {
  test_url(MUSTREMOTE, false, true);
});

// The set of page transitions
var TESTS = [
  [
    "chrome -> chrome",
    CHROME, false,
    CHROME, false,
  ],
  [
    "chrome -> canremote",
    CHROME, false,
    CANREMOTE, false,
  ],
  [
    "chrome -> mustremote",
    CHROME, false,
    MUSTREMOTE, true,
  ],
  [
    "remote -> chrome",
    MUSTREMOTE, true,
    CHROME, false,
  ],
  [
    "remote -> canremote",
    MUSTREMOTE, true,
    CANREMOTE, true,
  ],
  [
    "remote -> mustremote",
    MUSTREMOTE, true,
    MUSTREMOTE, true,
  ],
];

// The different ways to transition from one page to another
var TRANSITIONS = [
// Loads the new page by calling browser.loadURI directly
function* loadURI(browser, uri) {
  info("Calling browser.loadURI");
  yield BrowserTestUtils.loadURI(browser, uri);
  return true;
},

// Loads the new page by finding a link with the right href in the document and
// clicking it
function* clickLink(browser, uri) {
  info("Clicking link");

  function frame_script(frameUri) {
    let link = content.document.querySelector("a[href='" + frameUri + "']");
    link.click();
  }

  browser.messageManager.loadFrameScript("data:,(" + frame_script.toString() + ")(" + JSON.stringify(uri) + ");", false);

  return false;
},
];

// Creates a set of test tasks, one for each combination of TESTS and TRANSITIONS.
for (let test of TESTS) {
  for (let transition of TRANSITIONS) {
    add_task(makeTest(...test, transition));
  }
}
