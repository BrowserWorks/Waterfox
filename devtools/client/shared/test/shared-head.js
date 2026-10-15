/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint no-unused-vars: [2, {"vars": "local", caughtErrors: "none"}] */

/* import-globals-from ../../inspector/test/shared-head.js */

"use strict";

// This shared-head.js file is used by most mochitests
// and we start using it in xpcshell tests as well.
// It contains various common helper functions.

// Recording already set preferences.
const devtoolsPreferences = Services.prefs.getBranch("devtools");
const alreadySetPreferences = new Set();
for (const pref of devtoolsPreferences.getChildList("")) {
  if (devtoolsPreferences.prefHasUserValue(pref)) {
    alreadySetPreferences.add(pref);
  }
}

{
  const { PromiseTestUtils } = ChromeUtils.importESModule(
    "resource://testing-common/PromiseTestUtils.sys.mjs"
  );
  PromiseTestUtils.allowMatchingRejectionsGlobally(
    /REDUX_MIDDLEWARE_IGNORED_REDUX_ACTION/
  );
}

async function resetPreferencesModifiedDuringTest() {
  if (!isXpcshell) {
    await SpecialPowers.flushPrefEnv();
  }

  // Reset devtools preferences modified by the test.
  for (const pref of devtoolsPreferences.getChildList("")) {
    if (
      devtoolsPreferences.prefHasUserValue(pref) &&
      !alreadySetPreferences.has(pref)
    ) {
      devtoolsPreferences.clearUserPref(pref);
    }
  }

  // Cleanup some generic Firefox preferences set indirectly by tests.
  for (const pref of [
    "browser.firefox-view.button-clicks",
    "extensions.ui.lastCategory",
    "sidebar.old-sidebar.has-used",
  ]) {
    Services.prefs.clearUserPref(pref);
  }
}

const isMochitest = "gTestPath" in this;
const isXpcshell = !isMochitest;
if (isXpcshell) {
  // gTestPath isn't exposed to xpcshell tests
  // _TEST_FILE is an array for a unique string
  /* global _TEST_FILE */
  this.gTestPath = _TEST_FILE[0];
}

const { Constructor: CC } = Components;

// Print allocation count if DEBUG_DEVTOOLS_ALLOCATIONS is set to "normal",
// and allocation sites if DEBUG_DEVTOOLS_ALLOCATIONS is set to "verbose".
const DEBUG_ALLOCATIONS = Services.env.get("DEBUG_DEVTOOLS_ALLOCATIONS");
if (DEBUG_ALLOCATIONS) {
  // Load the allocation tracker from the distinct privileged loader in order
  // to be able to debug all privileged code (ESMs, XPCOM,...) running in the shared privileged global.
  const {
    useDistinctSystemPrincipalLoader,
    releaseDistinctSystemPrincipalLoader,
  } = ChromeUtils.importESModule(
    "resource://devtools/shared/loader/DistinctSystemPrincipalLoader.sys.mjs",
    { global: "shared" }
  );
  const requester = {};
  const loader = useDistinctSystemPrincipalLoader(requester);
  registerCleanupFunction(() =>
    releaseDistinctSystemPrincipalLoader(requester)
  );

  const { allocationTracker } = loader.require(
    "resource://devtools/shared/test-helpers/allocation-tracker.js"
  );
  const tracker = allocationTracker({ watchAllGlobals: true });
  registerCleanupFunction(() => {
    if (DEBUG_ALLOCATIONS == "normal") {
      tracker.logCount();
    } else if (DEBUG_ALLOCATIONS == "verbose") {
      tracker.logAllocationSites();
    }
    tracker.stop();
  });
}

// When DEBUG_STEP environment variable is set,
// automatically start a tracer which will log all line being executed
// in the running test (and nothing else) and also pause its execution
// for the given amount of milliseconds.
//
// Be careful that these pause have significant side effect.
// This will pause the test script event loop and allow running the other
// tasks queued in the parent process's main thread event loop queue.
//
// Passing any non-number value, like `DEBUG_STEP=true` will still
// log the executed lines without any pause, and without this side effect.
//
// For now, the tracer can only work once per thread.
// So when using this feature you will not be able to use the JS tracer
// in any other way on parent process's main thread.
const DEBUG_STEP = Services.env.get("DEBUG_STEP");
if (DEBUG_STEP) {
  // Load the stepper code from the distinct privileged loader in order
  // to be able to debug all privileged code (ESMs, XPCOM,...) running in the shared privileged global.
  const {
    useDistinctSystemPrincipalLoader,
    releaseDistinctSystemPrincipalLoader,
  } = ChromeUtils.importESModule(
    "resource://devtools/shared/loader/DistinctSystemPrincipalLoader.sys.mjs",
    { global: "shared" }
  );
  const requester = {};
  const loader = useDistinctSystemPrincipalLoader(requester);

  const stepper = loader.require(
    "resource://devtools/shared/test-helpers/test-stepper.js"
  );
  stepper.start(globalThis, gTestPath, DEBUG_STEP);
  registerCleanupFunction(() => {
    stepper.stop();
    releaseDistinctSystemPrincipalLoader(requester);
  });
}

const DEBUG_TRACE_LINE = Services.env.get("DEBUG_TRACE_LINE");
if (DEBUG_TRACE_LINE) {
  // Load the tracing code from the distinct privileged loader in order
  // to be able to debug all privileged code (ESMs, XPCOM,...) running in the shared privileged global.
  const {
    useDistinctSystemPrincipalLoader,
    releaseDistinctSystemPrincipalLoader,
  } = ChromeUtils.importESModule(
    "resource://devtools/shared/loader/DistinctSystemPrincipalLoader.sys.mjs"
  );
  const requester = {};
  const loader = useDistinctSystemPrincipalLoader(requester);

  const lineTracer = loader.require(
    "resource://devtools/shared/test-helpers/test-line-tracer.js"
  );
  lineTracer.start(globalThis, gTestPath, DEBUG_TRACE_LINE);
  registerCleanupFunction(() => {
    lineTracer.stop();
    releaseDistinctSystemPrincipalLoader(requester);
  });
}

/**
 * Test helper to start a JavaScript tracer which would trace DevTools modules.
 *
 * @param {object} options
 *        See https://firefox-source-docs.mozilla.org/devtools/tests/mochitest-devtools.html#tracing-javascript
 *        for a list of handy additional options.
 * @return {function}
 *         Callback to stop the tracing.
 */
function startTracing(options = {}) {
  const { JSTracer } = ChromeUtils.importESModule(
    "resource://devtools/server/tracer/tracer.sys.mjs",
    { global: "devtools" }
  );
  // You have to at least pass an empty object to startTracing,
  // otherwise, all the attributes at optional.
  JSTracer.startTracing({
    traceAllGlobals: true,
    ...options,
  });

  return function () {
    JSTracer.stopTracing();
  };
}

const { loader, require } = ChromeUtils.importESModule(
  "resource://devtools/shared/loader/Loader.sys.mjs"
);
const { sinon } = ChromeUtils.importESModule(
  "resource://testing-common/Sinon.sys.mjs"
);

// When loaded from xpcshell test, this file is loaded via xpcshell.toml's head property
// and so it loaded first before anything else and isn't having access to Services global.
// Whereas many head.js files from mochitest import this file via loadSubScript
// and already expose Services as a global.

const {
  gDevTools,
} = require("resource://devtools/client/framework/devtools.js");
const {
  CommandsFactory,
} = require("resource://devtools/shared/commands/commands-factory.js");
const DevToolsUtils = require("resource://devtools/shared/DevToolsUtils.js");

const KeyShortcuts = require("resource://devtools/client/shared/key-shortcuts.js");

const { LocalizationHelper } = require("resource://devtools/shared/l10n.js");

loader.lazyRequireGetter(
  this,
  "ResponsiveUIManager",
  "resource://devtools/client/responsive/manager.js"
);
loader.lazyRequireGetter(
  this,
  "localTypes",
  "resource://devtools/client/responsive/types.js"
);
loader.lazyRequireGetter(
  this,
  "ResponsiveMessageHelper",
  "resource://devtools/client/responsive/utils/message.js"
);

loader.lazyRequireGetter(
  this,
  "FluentReact",
  "resource://devtools/client/shared/vendor/fluent-react.js"
);

const TEST_DIR = gTestPath.substr(0, gTestPath.lastIndexOf("/"));
const CHROME_URL_ROOT = TEST_DIR + "/";
const URL_ROOT = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "http://example.com/"
);
const URL_ROOT_SSL = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "https://example.com/"
);

// Add aliases which make it more explicit that URL_ROOT uses a com TLD.
const URL_ROOT_COM = URL_ROOT;
const URL_ROOT_COM_SSL = URL_ROOT_SSL;

// Also expose http://example.org, http://example.net, https://example.org to
// test Fission scenarios easily.
// Note: example.net is not available for https.
const URL_ROOT_ORG = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "http://example.org/"
);
const URL_ROOT_ORG_SSL = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "https://example.org/"
);
const URL_ROOT_NET = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "http://example.net/"
);
const URL_ROOT_NET_SSL = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "https://example.net/"
);
// mochi.test:8888 is the actual primary location where files are served.
const URL_ROOT_MOCHI_8888 = CHROME_URL_ROOT.replace(
  "chrome://mochitests/content/",
  "http://mochi.test:8888/"
);

// Force devtools to be initialized so menu items and keyboard shortcuts get installed
require("resource://devtools/client/framework/devtools-browser.js");

// All tests are asynchronous
if (isMochitest) {
  waitForExplicitFinish();
}

var EXPECTED_DTU_ASSERT_FAILURE_COUNT = 0;

registerCleanupFunction(function () {
  if (
    DevToolsUtils.assertionFailureCount !== EXPECTED_DTU_ASSERT_FAILURE_COUNT
  ) {
    ok(
      false,
      "Should have had the expected number of DevToolsUtils.assert() failures." +
        " Expected " +
        EXPECTED_DTU_ASSERT_FAILURE_COUNT +
        ", got " +
        DevToolsUtils.assertionFailureCount
    );
  }
});

// Uncomment this pref to dump all devtools emitted events to the console.
// Services.prefs.setBoolPref("devtools.dump.emit", true);

/**
 * Watch console messages for failed propType definitions in React components.
 */
function onConsoleMessage(subject) {
  const message = subject.wrappedJSObject.arguments[0];

  if (message && /Failed propType/.test(message.toString())) {
    ok(false, message);
  }
}

const ConsoleAPIStorage = Cc["@mozilla.org/consoleAPI-storage;1"].getService(
  Ci.nsIConsoleAPIStorage
);

ConsoleAPIStorage.addLogEventListener(
  onConsoleMessage,
  Cc["@mozilla.org/systemprincipal;1"].createInstance(Ci.nsIPrincipal)
);
registerCleanupFunction(() => {
  ConsoleAPIStorage.removeLogEventListener(onConsoleMessage);
});

// Disable this preference to reduce exceptions related to pending `listWorkers`
// requests occuring after a process is created/destroyed. See Bug 1620983.
add_setup(async () => {
  if (!isXpcshell) {
    await pushPref("dom.ipc.processPrelaunch.enabled", false);
  }
});

// On some Linux platforms, prefers-reduced-motion is enabled, which would
// trigger the notification to be displayed in the toolbox. Dismiss the message
// by default.
Services.prefs.setBoolPref(
  "devtools.inspector.simple-highlighters.message-dismissed",
  true
);

// Enable dumping scope variables when a test failure occurs.
Services.prefs.setBoolPref("devtools.testing.testScopes", true);

var {
  BrowserConsoleManager,
} = require("resource://devtools/client/webconsole/browser-console-manager.js");

registerCleanupFunction(async function cleanup() {
  // Closing the browser console if there's one
  const browserConsole = BrowserConsoleManager.getBrowserConsole();
  if (browserConsole) {
    await safeCloseBrowserConsole({ clearOutput: true });
  }

  // Close any tab opened by the test.
  // There should be only one tab opened by default when firefox starts the test.
  while (isMochitest && gBrowser.tabs.length > 1) {
    await closeTabAndToolbox(gBrowser.selectedTab);
  }

  // Note that this will run before cleanup functions registered by tests or other head.js files.
  // So all connections must be cleaned up by the test when the test ends,
  // before the harness starts invoking the cleanup functions
  await waitForTick();

  // All connections must be cleaned up by the test when the test ends.
  const {
    DevToolsServer,
  } = require("resource://devtools/server/devtools-server.js");
  ok(
    !DevToolsServer.hasConnection(),
    "The main process DevToolsServer has no pending connection when the test ends"
  );
  // If there is still open connection, close all of them so that following tests
  // could pass.
  if (DevToolsServer.hasConnection()) {
    for (const conn of Object.values(DevToolsServer._connections)) {
      conn.close();
    }
  }

  // Reset all preferences AFTER the toolbox is closed.
  // NOTE: Doing it before toolbox destruction could trigger observers.
  await resetPreferencesModifiedDuringTest();
});

async function safeCloseBrowserConsole({ clearOutput = false } = {}) {
  const hud = BrowserConsoleManager.getBrowserConsole();
  if (!hud) {
    return;
  }

  if (clearOutput) {
    info("Clear the browser console output");
    const { ui } = hud;
    const promises = [ui.once("messages-cleared")];
    // If there's an object inspector, we need to wait for the actors to be released.
    if (ui.outputNode.querySelector(".object-inspector")) {
      promises.push(ui.once("fronts-released"));
    }
    await ui.clearOutput(true);
    await Promise.all(promises);
    info("Browser console cleared");
  }

  info("Wait for all Browser Console targets to be attached");
  // It might happen that waitForAllTargetsToBeAttached does not resolve, so we set a
  // timeout of 1s before closing
  await Promise.race([
    waitForAllTargetsToBeAttached(hud.commands.targetCommand),
    wait(1000),
  ]);

  info("Close the Browser Console");
  await BrowserConsoleManager.closeBrowserConsole();
  info("Browser Console closed");
}

/**
 * Observer code to register the test actor in every DevTools server which
 * starts registering its own actors.
 *
 * We require immediately the highlighter test actor file, because it will force to load and
 * register the front and the spec for HighlighterTestActor. Normally specs and fronts are
 * in separate files registered in specs/index.js. But here to simplify the
 * setup everything is in the same file and we force to load it here.
 *
 * DevToolsServer will emit "devtools-server-initialized" after finishing its
 * initialization. We watch this observable to add our custom actor.
 *
 * As a single test may create several DevTools servers, we keep the observer
 * alive until the test ends.
 *
 * To avoid leaks, the observer needs to be removed at the end of each test.
 * The test cleanup will send the async message "remove-devtools-highlightertestactor-observer",
 * we listen to this message to cleanup the observer.
 */
function highlighterTestActorBootstrap() {
  const HIGHLIGHTER_TEST_ACTOR_URL =
    "chrome://mochitests/content/browser/devtools/client/shared/test/highlighter-test-actor.js";

  const { require: _require } = ChromeUtils.importESModule(
    "resource://devtools/shared/loader/Loader.sys.mjs"
  );
  _require(HIGHLIGHTER_TEST_ACTOR_URL);

  const actorRegistryObserver = subject => {
    const actorRegistry = subject.wrappedJSObject;
    actorRegistry.registerModule(HIGHLIGHTER_TEST_ACTOR_URL, {
      prefix: "highlighterTest",
      constructor: "HighlighterTestActor",
      type: { target: true },
    });
  };
  Services.obs.addObserver(
    actorRegistryObserver,
    "devtools-server-initialized"
  );

  const unloadListener = () => {
    Services.cpmm.removeMessageListener(
      "remove-devtools-testactor-observer",
      unloadListener
    );
    Services.obs.removeObserver(
      actorRegistryObserver,
      "devtools-server-initialized"
    );
  };
  Services.cpmm.addMessageListener(
    "remove-devtools-testactor-observer",
    unloadListener
  );
}

if (isMochitest) {
  const highlighterTestActorBootstrapScript =
    "data:,(" + highlighterTestActorBootstrap + ")()";
  Services.ppmm.loadProcessScript(
    highlighterTestActorBootstrapScript,
    // Load this script in all processes (created or to be created)
    true
  );

  registerCleanupFunction(() => {
    Services.ppmm.broadcastAsyncMessage("remove-devtools-testactor-observer");
    Services.ppmm.removeDelayedProcessScript(
      highlighterTestActorBootstrapScript
    );
  });
}

/**
 * Spawn an instance of the highlighter test actor for the given toolbox
 *
 * @param {Toolbox} toolbox
 * @param {object} options
 * @param {Function} options.target: Optional target to get the highlighterTestFront for.
 *        If not provided, the top level target will be used.
 * @returns {HighlighterTestFront}
 */
async function getHighlighterTestFront(toolbox, { target } = {}) {
  // Loading the Inspector panel in order to overwrite the TestActor getter for the
  // highlighter instance with a method that points to the currently visible
  // Box Model Highlighter managed by the Inspector panel.
  const inspector = await toolbox.loadTool("inspector");

  const highlighterTestFront = await (target || toolbox.target).getFront(
    "highlighterTest"
  );
  // Override the highligher getter with a method to return the active box model
  // highlighter. Adaptation for multi-process scenarios where there can be multiple
  // highlighters, one per process.
  highlighterTestFront.highlighter = () => {
    return inspector.highlighters.getActiveHighlighter(
      inspector.highlighters.TYPES.BOXMODEL
    );
  };
  return highlighterTestFront;
}

/**
 * Spawn an instance of the highlighter test actor for the given tab, when we need the
 * highlighter test front before opening or without a toolbox.
 *
 * @param {Tab} tab
 * @returns {HighlighterTestFront}
 */
async function getHighlighterTestFrontWithoutToolbox(tab) {
  const commands = await CommandsFactory.forTab(tab);
  // Initialize the TargetCommands which require some async stuff to be done
  // before being fully ready. This will define the `targetCommand.targetFront` attribute.
  await commands.targetCommand.startListening();

  const targetFront = commands.targetCommand.targetFront;
  return targetFront.getFront("highlighterTest");
}

/**
 * Returns a Promise that resolves when all the targets are fully attached.
 *
 * @param {TargetCommand} targetCommand
 */
function waitForAllTargetsToBeAttached(targetCommand) {
  return Promise.allSettled(
    targetCommand
      .getAllTargets(targetCommand.ALL_TYPES)
      .map(target => target.initialized)
  );
}

/**
 * Add a new test tab in the browser and load the given url.
 *
 * @param {string} url The url to be loaded in the new tab
 * @param {object} options Object with various optional fields:
 *   - {Boolean} background If true, open the tab in background
 *   - {ChromeWindow} window Firefox top level window we should use to open the tab
 *   - {Number} userContextId The userContextId of the tab.
 *   - {String} preferredRemoteType
 *   - {Boolean} waitForLoad Wait for the page in the new tab to load. (Defaults to true.)
 * @return a promise that resolves to the tab object when the url is loaded
 */
async function addTab(url, options = {}) {
  info("Adding a new tab with URL: " + url);

  const {
    background = false,
    userContextId,
    preferredRemoteType,
    waitForLoad = true,
  } = options;
  const { gBrowser } = options.window ? options.window : window;

  const tab = BrowserTestUtils.addTab(gBrowser, url, {
    userContextId,
    preferredRemoteType,
  });

  if (!background) {
    gBrowser.selectedTab = tab;
  }

  if (waitForLoad) {
    // accept any URL as url arg might not be serialized or redirects might happen
    await BrowserTestUtils.browserLoaded(tab.linkedBrowser, {
      wantLoad: () => true,
    });
    // Waiting for presShell helps with test timeouts in webrender platforms.
    await waitForPresShell(tab.linkedBrowser);
    info("Tab added and finished loading");
  } else {
    info("Tab added");
  }

  return tab;
}

/**
 * Remove the given tab.
 *
 * @param {object} tab The tab to be removed.
 * @return Promise<undefined> resolved when the tab is successfully removed.
 */
async function removeTab(tab) {
  info("Removing tab.");

  const { gBrowser } = tab.ownerDocument.defaultView;
  const onClose = once(gBrowser.tabContainer, "TabClose");
  gBrowser.removeTab(tab);
  await onClose;

  info("Tab removed and finished closing");
}

/**
 * Alias for navigateTo which will reuse the current URI of the provided browser
 * to trigger a navigation.
 */
async function reloadSelectedTab({
  isErrorPage = false,
  waitForLoad = true,
} = {}) {
  return navigateTo(gBrowser.selectedBrowser.currentURI.spec, {
    browser: gBrowser.selectedBrowser,
    isErrorPage,
    waitForLoad,
  });
}

/**
 * Navigate the currently selected tab to a new URL and wait for it to load.
 * Also wait for the toolbox to attach to the new target, if we navigated
 * to a new process.
 *
 * @param {string} url The url to be loaded in the current tab.
 * @param {JSON} options Optional dictionary object with the following keys:
 *        - {XULBrowser} browser
 *          The browser element which should navigate. Defaults to the selected
 *          browser.
 *        - {Boolean} isErrorPage
 *          You may pass `true` if the URL is an error page. Otherwise
 *          BrowserTestUtils.browserLoaded will wait for 'load' event, which
 *          never fires for error pages.
 *        - {Boolean} waitForLoad
 *          You may pass `false` if the page load is expected to be blocked by
 *          a script or a breakpoint.
 *
 * @return a promise that resolves when the page has fully loaded.
 */
async function navigateTo(
  uri,
  {
    browser = gBrowser.selectedBrowser,
    isErrorPage = false,
    waitForLoad = true,
  } = {}
) {
  const waitForDevToolsReload = await watchForDevToolsReload(browser, {
    isErrorPage,
    waitForLoad,
  });

  uri = uri.replaceAll("\n", "");
  info(`Navigating to "${uri}"`);

  const onBrowserLoaded = BrowserTestUtils.browserLoaded(
    browser,
    // includeSubFrames
    false,
    // resolve on this specific page to load (if null, it would be any page load)
    loadedUrl => {
      // loadedUrl is encoded, while uri might not be.
      return loadedUrl === uri || decodeURI(loadedUrl) === uri;
    },
    isErrorPage
  );

  if (uri === browser.currentURI.spec) {
    // As BrowserCommands.reload only supports reloading the currently selected tab,
    // only support reloading the selected tab.
    is(
      browser,
      gBrowser.selectedBrowser,
      "Only supports reloading the selected tab"
    );

    // If we're navigating to the same page we're already on,
    // uses `BrowserCommands.reload()`,
    // which is the method used to reload page from firefox UI.
    // Compared to `gBrowser.reloadTab()`, it actually reloads iframes.
    BrowserCommands.reload();
  } else {
    BrowserTestUtils.startLoadingURIString(browser, uri);
  }

  if (waitForLoad) {
    info(`Waiting for page to be loaded…`);
    await onBrowserLoaded;
    info(`→ page loaded`);
  }

  await waitForDevToolsReload();
}

/**
 * This method should be used to watch for completion of any browser navigation
 * performed with a DevTools UI.
 *
 * It should watch for:
 * - Toolbox reload
 * - Toolbox commands reload
 * - RDM reload
 * - RDM commands reload
 *
 * And it should work both for target switching or old-style navigations.
 *
 * This method, similarly to all the other watch* navigation methods in this file,
 * is async but returns another method which should be called after the navigation
 * is done. Browser navigation might be monitored differently depending on the
 * situation, so it's up to the caller to handle it as needed.
 *
 * Typically, this would be used as follows:
 * ```
 *   async function someNavigationHelper(browser) {
 *     const waitForDevToolsFn = await watchForDevToolsReload(browser);
 *
 *     // This step should wait for the load to be completed from the browser's
 *     // point of view, so that waitForDevToolsFn can compare pIds, browsing
 *     // contexts etc... and check if we should expect a target switch
 *     await performBrowserNavigation(browser);
 *
 *     await waitForDevToolsFn();
 *   }
 * ```
 */
async function watchForDevToolsReload(
  browser,
  { isErrorPage = false, waitForLoad = true } = {}
) {
  const waitForToolboxReload = await _watchForToolboxReload(browser, {
    isErrorPage,
    waitForLoad,
  });
  const waitForResponsiveReload = await _watchForResponsiveReload(browser, {
    isErrorPage,
    waitForLoad,
  });

  return async function () {
    info("Wait for the toolbox to reload");
    await waitForToolboxReload();

    info("Wait for Responsive UI to reload");
    await waitForResponsiveReload();
  };
}

/**
 * Start watching for the toolbox reload to be completed:
 * - watch for the toolbox's commands to be fully reloaded
 * - watch for the toolbox's current panel to be reloaded
 */
async function _watchForToolboxReload(
  browser,
  { isErrorPage, waitForLoad } = {}
) {
  const tab = gBrowser.getTabForBrowser(browser);

  const toolbox = gDevTools.getToolboxForTab(tab);

  if (!toolbox) {
    // No toolbox to wait for
    return function () {};
  }

  const waitForCurrentPanelReload = watchForCurrentPanelReload(toolbox);
  const waitForToolboxCommandsReload = await watchForCommandsReload(
    toolbox.commands,
    { isErrorPage, waitForLoad }
  );
  const checkTargetSwitching = await watchForTargetSwitching(
    toolbox.commands,
    browser
  );

  return async function () {
    const isTargetSwitching = checkTargetSwitching();

    info(`Waiting for toolbox commands to be reloaded…`);
    await waitForToolboxCommandsReload(isTargetSwitching);

    // TODO: We should wait for all loaded panels to reload here, because some
    // of them might still perform background updates.
    if (waitForCurrentPanelReload) {
      info(`Waiting for ${toolbox.currentToolId} to be reloaded…`);
      await waitForCurrentPanelReload();
      info(`→ panel reloaded`);
    }
  };
}

/**
 * Start watching for Responsive UI (RDM) reload to be completed:
 * - watch for the Responsive UI's commands to be fully reloaded
 * - watch for the Responsive UI's target switch to be done
 */
async function _watchForResponsiveReload(
  browser,
  { isErrorPage, waitForLoad } = {}
) {
  const tab = gBrowser.getTabForBrowser(browser);
  const ui = ResponsiveUIManager.getResponsiveUIForTab(tab);

  if (!ui) {
    // No responsive UI to wait for
    return function () {};
  }

  const onResponsiveTargetSwitch = ui.once("responsive-ui-target-switch-done");
  const waitForResponsiveCommandsReload = await watchForCommandsReload(
    ui.commands,
    { isErrorPage, waitForLoad }
  );
  const checkTargetSwitching = await watchForTargetSwitching(
    ui.commands,
    browser
  );

  return async function () {
    const isTargetSwitching = checkTargetSwitching();

    info(`Waiting for responsive ui commands to be reloaded…`);
    await waitForResponsiveCommandsReload(isTargetSwitching);

    if (isTargetSwitching) {
      await onResponsiveTargetSwitch;
    }
  };
}

/**
 * Watch for the current panel selected in the provided toolbox to be reloaded.
 * Some panels implement custom events that should be expected for every reload.
 *
 * Note about returning a method instead of a promise:
 * In general this pattern is useful so that we can check if a target switch
 * occurred or not, and decide which events to listen for. So far no panel is
 * behaving differently whether there was a target switch or not. But to remain
 * consistent with other watch* methods we still return a function here.
 *
 * @param {Toolbox}
 *        The Toolbox instance which is going to experience a reload
 * @return {function} An async method to be called and awaited after the reload
 *         started. Will return `null` for panels which don't implement any
 *         specific reload event.
 */
function watchForCurrentPanelReload(toolbox) {
  return _watchForPanelReload(toolbox, toolbox.currentToolId);
}

/**
 * Watch for all the panels loaded in the provided toolbox to be reloaded.
 * Some panels implement custom events that should be expected for every reload.
 *
 * Note about returning a method instead of a promise:
 * See comment for watchForCurrentPanelReload
 *
 * @param {Toolbox}
 *        The Toolbox instance which is going to experience a reload
 * @return {function} An async method to be called and awaited after the reload
 *         started.
 */
function watchForLoadedPanelsReload(toolbox) {
  const waitForPanels = [];
  for (const [id] of toolbox.getToolPanels()) {
    // Store a watcher method for each panel already loaded.
    waitForPanels.push(_watchForPanelReload(toolbox, id));
  }

  return function () {
    return Promise.all(
      waitForPanels.map(async watchPanel => {
        // Wait for all panels to be reloaded.
        if (watchPanel) {
          await watchPanel();
        }
      })
    );
  };
}

function _watchForPanelReload(toolbox, toolId) {
  const panel = toolbox.getPanel(toolId);

  if (toolId == "inspector") {
    const markuploaded = panel.once("markuploaded");
    const onNewRoot = panel.once("new-root");
    const onUpdated = panel.once("inspector-updated");
    const onReloaded = panel.once("reloaded");

    return async function () {
      info("Waiting for markup view to load after navigation.");
      await markuploaded;

      info("Waiting for new root.");
      await onNewRoot;

      info("Waiting for inspector to update after new-root event.");
      await onUpdated;

      info("Waiting for inspector updates after page reload");
      await onReloaded;

      info("Received 'reloaded' event for inspector");
    };
  } else if (
    ["netmonitor", "accessibility", "webconsole", "jsdebugger"].includes(toolId)
  ) {
    const onReloaded = panel.once("reloaded");
    return async function () {
      info(`Waiting for ${toolId} updates after page reload`);
      await onReloaded;

      info(`Received 'reloaded' event for ${toolId}`);
    };
  }
  return null;
}

/**
 * Watch for a Commands instance to be reloaded after a navigation.
 *
 * As for other navigation watch* methods, this should be called before the
 * navigation starts, and the function it returns should be called after the
 * navigation is done from a Browser point of view.
 *
 * !!! The wait function expects a `isTargetSwitching` argument to be provided,
 * which needs to be monitored using watchForTargetSwitching !!!
 */
async function watchForCommandsReload(
  commands,
  { isErrorPage = false, waitForLoad = true } = {}
) {
  // If we're switching origins, we need to wait for the 'switched-target'
  // event to make sure everything is ready.
  // Navigating from/to pages loaded in the parent process, like about:robots,
  // also spawn new targets.
  // (If target switching is disabled, the toolbox will reboot)
  const onTargetSwitched = commands.targetCommand.once("switched-target");

  // Wait until we received a page load resource:
  // - dom-complete if we can wait for a full page load
  // - dom-loading otherwise
  // This allows to wait for page load for consumers calling directly
  // waitForDevTools instead of navigateTo/reloadSelectedTab.
  // This is also useful as an alternative to target switching, when no target
  // switch is supposed to happen.
  const waitForCompleteLoad = waitForLoad && !isErrorPage;
  const documentEventName = waitForCompleteLoad
    ? "dom-complete"
    : "dom-loading";

  const { onResource: onTopLevelDomEvent } =
    await commands.resourceCommand.waitForNextResource(
      commands.resourceCommand.TYPES.DOCUMENT_EVENT,
      {
        ignoreExistingResources: true,
        predicate: resource =>
          resource.targetFront.isTopLevel &&
          resource.name === documentEventName,
      }
    );

  return async function (isTargetSwitching) {
    if (typeof isTargetSwitching === "undefined") {
      throw new Error("isTargetSwitching was not provided to the wait method");
    }

    if (isTargetSwitching) {
      info(`Waiting for target switch…`);
      await onTargetSwitched;
      info(`→ switched-target emitted`);
    }

    info(`Waiting for '${documentEventName}' resource…`);
    await onTopLevelDomEvent;
    info(`→ '${documentEventName}' resource emitted`);

    return isTargetSwitching;
  };
}

/**
 * Watch if an upcoming navigation will trigger a target switching, for the
 * provided Commands instance and the provided Browser.
 *
 * As for other navigation watch* methods, this should be called before the
 * navigation starts, and the function it returns should be called after the
 * navigation is done from a Browser point of view.
 */
async function watchForTargetSwitching(commands, browser) {
  browser = browser || gBrowser.selectedBrowser;
  const currentPID = browser.browsingContext.currentWindowGlobal.osPid;
  const currentBrowsingContextID = browser.browsingContext.id;

  // If the current top-level target follows the window global lifecycle, a
  // target switch will occur regardless of process changes.
  const targetFollowsWindowLifecycle =
    commands.targetCommand.targetFront.targetForm.followWindowGlobalLifeCycle;

  return function () {
    // Compare the PIDs (and not the toolbox's targets) as PIDs are updated also immediately,
    // while target may be updated slightly later.
    const switchedProcess =
      currentPID !== browser.browsingContext.currentWindowGlobal.osPid;
    const switchedBrowsingContext =
      currentBrowsingContextID !== browser.browsingContext.id;

    return (
      targetFollowsWindowLifecycle || switchedProcess || switchedBrowsingContext
    );
  };
}

/**
 * Create a Target for the provided tab and attach to it before resolving.
 * This should only be used for tests which don't involve the frontend or a
 * toolbox. Typically, retrieving the target and attaching to it should be
 * handled at framework level when a Toolbox is used.
 *
 * @param {XULTab} tab
 *        The tab for which a target should be created.
 * @return {WindowGlobalTargetFront} The attached target front.
 */
async function createAndAttachTargetForTab(tab) {
  info("Creating and attaching to a local tab target");

  const commands = await CommandsFactory.forTab(tab);

  // Initialize the TargetCommands which require some async stuff to be done
  // before being fully ready. This will define the `targetCommand.targetFront` attribute.
  await commands.targetCommand.startListening();

  const target = commands.targetCommand.targetFront;
  return target;
}

/**
 * Open the inspector in a tab with given URL.
 *
 * @param {string} url  The URL to open.
 * @param {string} hostType Optional hostType, as defined in Toolbox.HostType
 * @return A promise that is resolved once the tab and inspector have loaded
 *         with an object: { tab, toolbox, inspector, highlighterTestFront }.
 */
async function openInspectorForURL(url, hostType) {
  const tab = await addTab(url);
  const { inspector, toolbox, highlighterTestFront } =
    await openInspector(hostType);
  return { tab, inspector, toolbox, highlighterTestFront };
}

function getActiveInspector() {
  const toolbox = gDevTools.getToolboxForTab(gBrowser.selectedTab);
  return toolbox.getPanel("inspector");
}

/**
 * Simulate a key event from an electron key shortcut string:
 * https://github.com/electron/electron/blob/master/docs/api/accelerator.md
 *
 * @param {string} key
 * @param {DOMWindow} target
 *        Optional window where to fire the key event
 */
function synthesizeKeyShortcut(key, target) {
  const shortcut = KeyShortcuts.parseElectronKey(key);
  const keyEvent = {
    altKey: shortcut.alt,
    ctrlKey: shortcut.ctrl,
    metaKey: shortcut.meta,
    shiftKey: shortcut.shift,
  };
  if (shortcut.keyCode) {
    keyEvent.keyCode = shortcut.keyCode;
  }

  info("Synthesizing key shortcut: " + key);
  EventUtils.synthesizeKey(shortcut.key || "", keyEvent, target);
}

var waitForTime = DevToolsUtils.waitForTime;

/**
 * Wait for a tick.
 *
 * @return {Promise}
 */
function waitForTick() {
  return new Promise(resolve => DevToolsUtils.executeSoon(resolve));
}

/**
 * This shouldn't be used in the tests, but is useful when writing new tests or
 * debugging existing tests in order to introduce delays in the test steps
 *
 * @param {number} ms
 *        The time to wait
 * @return A promise that resolves when the time is passed
 */
function wait(ms) {
  return new Promise(resolve => {
    setTimeout(resolve, ms);
    info("Waiting " + ms / 1000 + " seconds.");
  });
}

/**
 * Wait for a predicate to return a result.
 *
 * @param function condition
 *        Invoked once in a while until it returns a truthy value. This should be an
 *        idempotent function, since we have to run it a second time after it returns
 *        true in order to return the value.
 * @param string message [optional]
 *        A message to output if the condition fails.
 * @param number interval [optional]
 *        How often the predicate is invoked, in milliseconds.
 *        Can be set globally for a test via `waitFor.overrideIntervalForTestFile = someNumber;`.
 * @param number maxTries [optional]
 *        How many times the predicate is invoked before timing out.
 *        Can be set globally for a test via `waitFor.overrideMaxTriesForTestFile = someNumber;`.
 * @param boolean expectTimeout [optional]
 *        Whether the helper is expected to reach the timeout or not. Consider
 *        using waitForTimeout instead of passing this to true.
 * @return object
 *         A promise that is resolved with the result of the condition.
 */
async function waitFor(
  condition,
  message = "",
  interval = 10,
  maxTries = 500,
  expectTimeout = false
) {
  // Update interval & maxTries if overrides are defined on the waitFor object.
  interval =
    typeof waitFor.overrideIntervalForTestFile !== "undefined"
      ? waitFor.overrideIntervalForTestFile
      : interval;
  maxTries =
    typeof waitFor.overrideMaxTriesForTestFile !== "undefined"
      ? waitFor.overrideMaxTriesForTestFile
      : maxTries;

  try {
    const value = await BrowserTestUtils.waitForCondition(
      condition,
      message,
      interval,
      maxTries
    );
    if (expectTimeout) {
      // If we expected a timeout, fail the test here.
      const errorMessage = `Expected timeout in waitFor(): ${message} \nUnexpected condition: ${condition} \n`;
      ok(false, errorMessage);
    }
    return value;
  } catch (e) {
    if (expectTimeout) {
      // If we expected a timeout, simply return null, the consumer should not
      // need any return value.
      return null;
    }

    // If we didn't expect a timeout, fail the test here.
    const errorMessage = `Failed waitFor(): ${message} \nFailed condition: ${condition} \nException Message: ${e}`;
    // Use both assert ok(false) and throw.
    // Assert captures the correct frame to log variables with dump-scope.js.
    // Error will make sure the test stops.
    ok(false, errorMessage);
    throw new Error(errorMessage);
  }
}

/**
 * Similar to @see waitFor defined above but expect the predicate to never
 * be satisfied and therefore to timeout.
 *
 * Arguments are identical to `waitFor` but the default values for interval and
 * maxTries are more conservative since this method expects a timeout.
 *
 */
async function waitForTimeout(
  condition,
  message = "",
  interval = 100,
  maxTries = 10
) {
  return waitFor(condition, message, interval, maxTries, true);
}

/**
 * Wait for eventName on target to be delivered a number of times.
 *
 * @param {object} target
 *        An observable object that either supports on/off or
 *        addEventListener/removeEventListener
 * @param {string} eventName
 * @param {number} numTimes
 *        Number of deliveries to wait for.
 * @param {boolean} useCapture
 *        Optional, for addEventListener/removeEventListener
 * @return A promise that resolves when the event has been handled
 */
function waitForNEvents(target, eventName, numTimes, useCapture = false) {
  info("Waiting for event: '" + eventName + "' on " + target + ".");

  let count = 0;

  return new Promise(resolve => {
    for (const [add, remove] of [
      ["on", "off"],
      ["addEventListener", "removeEventListener"],
      ["addListener", "removeListener"],
      ["addMessageListener", "removeMessageListener"],
    ]) {
      if (add in target && remove in target) {
        target[add](
          eventName,
          function onEvent(...args) {
            if (typeof info === "function") {
              info("Got event: '" + eventName + "' on " + target + ".");
            }

            if (++count == numTimes) {
              target[remove](eventName, onEvent, useCapture);
              resolve(...args);
            }
          },
          useCapture
        );
        break;
      }
    }
  });
}

/**
 * Wait until the browser element is no longer loading a document. In general
 * if you are loading an existing browser element, prefer the shared helper
 * BrowserTestUtils.isLoaded(browser).
 *
 * However in cases where the browser element is dynamically created and the
 * load might be missed because the event loop had time to spin before calling
 * isLoaded, this helper can be used as a fallback.
 *
 * @param {XULBrowser} browser
 *        The browser to wait the load for.
 */
async function waitForBrowserLoaded(browser) {
  return waitFor(
    () =>
      !browser.webProgress.isLoadingDocument &&
      browser.currentURI?.spec &&
      browser.currentURI?.spec !== "about:blank",
    {
      toString() {
        return (
          `Browser element did not load as expected. ` +
          `isLoadingDocument=${browser.webProgress.isLoadingDocument} and ` +
          `URI.spec=${browser.currentURI?.spec}.`
        );
      },
    }
  );
}

/**
 * Wait for DOM to be updated until the number of elements matching the provided
 * selector correspond to the expectation.
 *
 * @param {object} target
 *        The Node on which to query the selector.
 * @param {string} selector
 *        Given a selector to watch whether the expected element is changed
 *        on target.
 * @param {number} expectedLength
 *        Optional, default set to 1
 *        There may be more than one element match an array match the selector,
 *        give an expected length to wait for more elements.
 * @return A promise that resolves with the NodeList of the elements matching
 *         the selector.
 */
async function waitForDOM(target, selector, expectedLength = 1) {
  info(`Wait for ${expectedLength} elements to match selector "${selector}"`);
  await waitFor(
    () => target.querySelectorAll(selector).length === expectedLength,
    {
      toString() {
        return (
          `Expected ${expectedLength} elements for selector: "${selector}", ` +
          `got ${target.querySelectorAll(selector).length}.`
        );
      },
    }
  );

  info(`Successfully found ${expectedLength} elements matching "${selector}"`);
  return target.querySelectorAll(selector);
}

/**
 * Wait for eventName on target.
 *
 * @param {object} target
 *        An observable object that either supports on/off or
 *        addEventListener/removeEventListener
 * @param {string} eventName
 * @param {boolean} useCapture
 *        Optional, for addEventListener/removeEventListener
 * @return A promise that resolves when the event has been handled
 */
function once(target, eventName, useCapture = false) {
  return waitForNEvents(target, eventName, 1, useCapture);
}

/**
 * Some tests may need to import one or more of the test helper scripts.
 * A test helper script is simply a js file that contains common test code that
 * is either not common-enough to be in head.js, or that is located in a
 * separate directory.
 * The script will be loaded synchronously and in the test's scope.
 *
 * @param {string} filePath The file path, relative to the current directory.
 *                 Examples:
 *                 - "helper_attributes_test_runner.js"
 */
function loadHelperScript(filePath) {
  const testDir = gTestPath.substr(0, gTestPath.lastIndexOf("/"));
  Services.scriptloader.loadSubScript(testDir + "/" + filePath, this);
}

/**
 * Open the toolbox in a given tab.
 *
 * @param {XULNode} tab The tab the toolbox should be opened in.
 * @param {string} toolId Optional. The ID of the tool to be selected.
 * @param {string} hostType Optional. The type of toolbox host to be used.
 * @return {Promise} Resolves with the toolbox, when it has been opened.
 */
async function openToolboxForTab(tab, toolId, hostType) {
  info("Opening the toolbox");

  // Check if the toolbox is already loaded.
  let toolbox = gDevTools.getToolboxForTab(tab);
  if (toolbox) {
    if (!toolId || (toolId && toolbox.getPanel(toolId))) {
      info("Toolbox is already opened");
      return toolbox;
    }
  }

  // If not, load it now.
  toolbox = await gDevTools.showToolboxForTab(tab, { toolId, hostType });

  // Make sure that the toolbox frame is focused.
  await new Promise(resolve => waitForFocus(resolve, toolbox.win));

  info("Toolbox opened and focused");

  return toolbox;
}

/**
 * Add a new tab and open the toolbox in it.
 *
 * @param {string} url The URL for the tab to be opened.
 * @param {string} toolId Optional. The ID of the tool to be selected.
 * @param {string} hostType Optional. The type of toolbox host to be used.
 * @return {Promise} Resolves when the tab has been added, loaded and the
 * toolbox has been opened. Resolves to the toolbox.
 */
async function openNewTabAndToolbox(url, toolId, hostType) {
  const tab = await addTab(url);
  return openToolboxForTab(tab, toolId, hostType);
}

/**
 * Close a tab and if necessary, the toolbox that belongs to it
 *
 * @param {Tab} tab The tab to close.
 * @return {Promise} Resolves when the toolbox and tab have been destroyed and
 * closed.
 */
async function closeTabAndToolbox(tab = gBrowser.selectedTab) {
  if (gDevTools.hasToolboxForTab(tab)) {
    await gDevTools.closeToolboxForTab(tab);
  }

  await removeTab(tab);

  await new Promise(resolve => setTimeout(resolve, 0));
}

/**
 * Close a toolbox and the current tab.
 *
 * @param {Toolbox} toolbox The toolbox to close.
 * @return {Promise} Resolves when the toolbox and tab have been destroyed and
 * closed.
 */
async function closeToolboxAndTab(toolbox) {
  await toolbox.destroy();
  await removeTab(gBrowser.selectedTab);
}

/**
 * Waits until a predicate returns true.
 *
 * @param function predicate
 *        Invoked once in a while until it returns true.
 * @param number interval [optional]
 *        How often the predicate is invoked, in milliseconds.
 */
function waitUntil(predicate, interval = 10) {
  if (predicate()) {
    return Promise.resolve(true);
  }
  return new Promise(resolve => {
    setTimeout(function () {
      waitUntil(predicate, interval).then(() => resolve(true));
    }, interval);
  });
}

/**
 * Variant of waitUntil that accepts a predicate returning a promise.
 */
async function asyncWaitUntil(predicate, interval = 10) {
  let success = await predicate();
  while (!success) {
    // Wait for X milliseconds.
    await new Promise(resolve => setTimeout(resolve, interval));
    // Test the predicate again.
    success = await predicate();
  }
}

/**
 * Wait for a context menu popup to open.
 *
 * @param Element popup
 *        The XUL popup you expect to open.
 * @param Element button
 *        The button/element that receives the contextmenu event. This is
 *        expected to open the popup.
 * @param function onShown
 *        Function to invoke on popupshown event.
 * @param function onHidden
 *        Function to invoke on popuphidden event.
 * @return object
 *         A Promise object that is resolved after the popuphidden event
 *         callback is invoked.
 */
function waitForContextMenu(popup, button, onShown, onHidden) {
  return new Promise(resolve => {
    function onPopupShown() {
      info("onPopupShown");
      popup.removeEventListener("popupshown", onPopupShown);

      onShown && onShown();

      // Use executeSoon() to get out of the popupshown event.
      popup.addEventListener("popuphidden", onPopupHidden);
      DevToolsUtils.executeSoon(() => popup.hidePopup());
    }
    function onPopupHidden() {
      info("onPopupHidden");
      popup.removeEventListener("popuphidden", onPopupHidden);

      onHidden && onHidden();

      resolve(popup);
    }

    popup.addEventListener("popupshown", onPopupShown);

    info("wait for the context menu to open");
    synthesizeContextMenuEvent(button);
  });
}

function synthesizeContextMenuEvent(el) {
  el.scrollIntoView();
  const eventDetails = { type: "contextmenu", button: 2 };
  EventUtils.synthesizeMouse(
    el,
    5,
    2,
    eventDetails,
    el.ownerDocument.defaultView
  );
}

/**
 * Promise wrapper around SimpleTest.waitForClipboard
 */
function waitForClipboardPromise(setup, expected) {
  return new Promise((resolve, reject) => {
    SimpleTest.waitForClipboard(expected, setup, resolve, reject);
  });
}

/**
 * Simple helper to push a temporary preference. Wrapper on SpecialPowers
 * pushPrefEnv that returns a promise resolving when the preferences have been
 * updated.
 *
 * @param {string} preferenceName
 *        The name of the preference to updated
 * @param {} value
 *        The preference value, type can vary
 * @return {Promise} resolves when the preferences have been updated
 */
function pushPref(preferenceName, value) {
  const options = { set: [[preferenceName, value]] };
  return SpecialPowers.pushPrefEnv(options);
}

/**
 * Close the toolbox for the selected tab if needed.
 */
async function closeToolboxIfOpen() {
  // `closeToolboxForTab` will be a noop if the selected tab does not have any
  // toolbox.
  await gDevTools.closeToolboxForTab(gBrowser.selectedTab);
}

/**
 * Clean the logical clipboard content. This method only clears the OS clipboard on
 * Windows (see Bug 666254).
 */
function emptyClipboard() {
  const clipboard = Services.clipboard;
  clipboard.emptyClipboard(clipboard.kGlobalClipboard);
}

/**
 * Check if the current operating system is Windows.
 */
function isWindows() {
  return Services.appinfo.OS === "WINNT";
}

/**
 * Create an HTTP server that can be used to simulate custom requests within
 * a test.  It is automatically cleaned up when the test ends, so no need to
 * call `destroy`.
 *
 * See https://developer.mozilla.org/en-US/docs/Httpd.js/HTTP_server_for_unit_tests
 * for more information about how to register handlers.
 *
 * The server can be accessed like:
 *
 * ```js
 * const server = createTestHTTPServer();
 * let url = "http://localhost: " + server.identity.primaryPort + "/path";
 * ```
 *
 * @returns {HttpServer}
 */
function createTestHTTPServer() {
  const { HttpServer } = ChromeUtils.importESModule(
    "resource://testing-common/httpd.sys.mjs"
  );
  const server = new HttpServer();

  registerCleanupFunction(async function cleanup() {
    await new Promise(resolve => server.stop(resolve));
  });

  server.start(-1);
  return server;
}

/**
 * Register an actor in the content process of the current tab.
 *
 * Calling ActorRegistry.registerModule only registers the actor in the current process.
 * As all test scripts are ran in the parent process, it is only registered here.
 * This function helps register them in the content process used for the current tab.
 *
 * @param {string} url
 *        Actor module URL or absolute require path
 * @param {json} options
 *        Arguments to be passed to DevToolsServer.registerModule
 */
async function registerActorInContentProcess(url, options) {
  return SpecialPowers.spawn(
    gBrowser.selectedBrowser,
    [{ url, options }],
    args => {
      // eslint-disable-next-line no-shadow
      const { require } = ChromeUtils.importESModule(
        "resource://devtools/shared/loader/Loader.sys.mjs"
      );
      const {
        ActorRegistry,
      } = require("resource://devtools/server/actors/utils/actor-registry.js");
      ActorRegistry.registerModule(args.url, args.options);
    }
  );
}

/**
 * Move the provided Window to the provided left, top coordinates and wait for
 * the window position to be updated.
 */
async function moveWindowTo(win, left, top) {
  // Check that the expected coordinates are within the window available area.
  left = Math.max(win.screen.availLeft, left);
  left = Math.min(win.screen.width, left);
  top = Math.max(win.screen.availTop, top);
  top = Math.min(win.screen.height, top);

  info(`Moving window to {${left}, ${top}}`);
  win.moveTo(left, top);

  // Bug 1600809: window move/resize can be async on Linux sometimes.
  // Wait so that the anchor's position is correctly measured.
  return waitUntil(() => {
    info(
      `Wait for window screenLeft and screenTop to be updated: (${win.screenLeft}, ${win.screenTop})`
    );
    return win.screenLeft === left && win.screenTop === top;
  });
}

function getCurrentTestFilePath() {
  return gTestPath.replace("chrome://mochitests/content/browser/", "");
}

/**
 * Unregister all registered service workers.
 *
 * @param {DevToolsClient} client
 */
async function unregisterAllServiceWorkers(client) {
  info("Wait until all workers have a valid registrationFront");
  let workers;
  await asyncWaitUntil(async function () {
    workers = await client.mainRoot.listAllWorkers();
    const allWorkersRegistered = workers.service.every(
      worker => !!worker.registrationFront
    );
    return allWorkersRegistered;
  });

  info("Unregister all service workers");
  const promises = [];
  for (const worker of workers.service) {
    promises.push(worker.registrationFront.unregister());
  }
  await Promise.all(promises);
}

/**********************
 * Screenshot helpers *
 **********************/

/**
 * Returns an object containing the r,g and b colors of the provided image at
 * the passed position
 *
 * @param {Image} image
 * @param {Int} x
 * @param {Int} y
 * @returns Object with the following properties:
 *           - {Int} r: The red component of the pixel
 *           - {Int} g: The green component of the pixel
 *           - {Int} b: The blue component of the pixel
 */
function colorAt(image, x, y) {
  // Create a test canvas element.
  const HTML_NS = "http://www.w3.org/1999/xhtml";
  const canvas = document.createElementNS(HTML_NS, "canvas");
  canvas.width = image.width;
  canvas.height = image.height;

  // Draw the image in the canvas
  const context = canvas.getContext("2d");
  context.drawImage(image, 0, 0, image.width, image.height);

  // Return the color found at the provided x,y coordinates as a "r, g, b" string.
  const [r, g, b] = context.getImageData(x, y, 1, 1).data;
  return { r, g, b };
}

let allDownloads = [];
/**
 * Returns a Promise that resolves when a new file (e.g. screenshot, JSON, …) is available
 * in the download folder.
 *
 * @param {object} [options]
 * @param {boolean} options.isWindowPrivate: Set to true if the window from which the file
 *                  is downloaded is a private window. This will ensure that we check that the
 *                  file appears in the private window, not the non-private one (See Bug 1783373)
 */
async function waitUntilDownload({ isWindowPrivate = false } = {}) {
  const { Downloads } = ChromeUtils.importESModule(
    "resource://gre/modules/Downloads.sys.mjs"
  );
  const list = await Downloads.getList(Downloads.ALL);

  return new Promise(function (resolve) {
    const view = {
      onDownloadAdded: async download => {
        await download.whenSucceeded();
        if (allDownloads.includes(download)) {
          return;
        }

        is(
          !!download.source.isPrivate,
          isWindowPrivate,
          `The download occured in the expected${
            isWindowPrivate ? " private" : ""
          } window`
        );

        allDownloads.push(download);
        resolve(download.target.path);
        list.removeView(view);
      },
    };

    list.addView(view);
  });
}

/**
 * Clear all the download references.
 */
async function resetDownloads() {
  info("Reset downloads");
  const { Downloads } = ChromeUtils.importESModule(
    "resource://gre/modules/Downloads.sys.mjs"
  );
  const downloadList = await Downloads.getList(Downloads.ALL);
  const downloads = await downloadList.getAll();
  for (const download of downloads) {
    downloadList.remove(download);
    await download.finalize(true);
  }
  allDownloads = [];
}

/**
 * Return a screenshot of the currently selected node in the inspector (using the internal
 * Inspector#screenshotNode method).
 *
 * @param {Inspector} inspector
 * @returns {Image}
 */
async function takeNodeScreenshot(inspector) {
  // Cleanup all downloads at the end of the test.
  registerCleanupFunction(resetDownloads);

  info(
    "Call screenshotNode() and wait until the screenshot is found in the Downloads"
  );
  const whenScreenshotSucceeded = waitUntilDownload();
  inspector.screenshotNode();
  const filePath = await whenScreenshotSucceeded;

  info("Create an image using the downloaded fileas source");
  const image = new Image();
  const onImageLoad = once(image, "load");
  image.src = PathUtils.toFileURI(filePath);
  await onImageLoad;

  info("Remove the downloaded screenshot file");
  await IOUtils.remove(filePath);

  // See intermittent Bug 1508435. Even after removing the file, tests still manage to
  // reuse files from the previous test if they have the same name. Since our file name
  // is based on a timestamp that has "second" precision, wait for one second to make sure
  // screenshots will have different names.
  info(
    "Wait for one second to make sure future screenshots will use a different name"
  );
  await new Promise(r => setTimeout(r, 1000));

  return image;
}

/**
 * Check that the provided image has the expected width, height, and color.
 * NOTE: This test assumes that the image is only made of a single color and will only
 * check one pixel.
 */
async function assertSingleColorScreenshotImage(
  image,
  width,
  height,
  { r, g, b }
) {
  info(`Assert ${image.src} content`);
  const ratio = await SpecialPowers.spawn(
    gBrowser.selectedBrowser,
    [],
    () => content.wrappedJSObject.devicePixelRatio
  );

  const expectedWidthAtPageDPR = Math.round(width * ratio);
  const expectedHeightAtPageDPR = Math.round(height * ratio);
  const expectedWidthAtOneDPR = Math.round(width * 1);
  const expectedHeightAtOneDPR = Math.round(height * 1);

  ok(
    image.width === expectedWidthAtPageDPR ||
      image.width === expectedWidthAtOneDPR,
    `node screenshot width is ${image.width}, expected ${expectedWidthAtPageDPR} (page DPR=${ratio}) or ${expectedWidthAtOneDPR} (DPR=1)`
  );
  ok(
    image.height === expectedHeightAtPageDPR ||
      image.height === expectedHeightAtOneDPR,
    `node screenshot height is ${image.height}, expected ${expectedHeightAtPageDPR} (page DPR=${ratio}) or ${expectedHeightAtOneDPR} (DPR=1)`
  );

  const color = colorAt(image, 0, 0);
  is(color.r, r, "node screenshot has the expected red component");
  is(color.g, g, "node screenshot has the expected green component");
  is(color.b, b, "node screenshot has the expected blue component");
}

/**
 * Check that the provided image has the expected color at a given position
 */
function checkImageColorAt({ image, x = 0, y, expectedColor, label }) {
  const color = colorAt(image, x, y);
  is(`rgb(${Object.values(color).join(", ")})`, expectedColor, label);
}

/**
 * Wait until the store has reached a state that matches the predicate.
 *
 * @param Store store
 *        The Redux store being used.
 * @param function predicate
 *        A function that returns true when the store has reached the expected
 *        state.
 * @return Promise
 *         Resolved once the store reaches the expected state.
 */
function waitUntilState(store, predicate) {
  return new Promise(resolve => {
    const unsubscribe = store.subscribe(check);

    info(`Waiting for state predicate "${predicate}"`);
    function check() {
      if (predicate(store.getState())) {
        info(`Found state predicate "${predicate}"`);
        unsubscribe();
        resolve();
      }
    }

    // Fire the check immediately in case the action has already occurred
    check();
  });
}

/**
 * Wait for a specific action type to be dispatched.
 *
 * If the action is async and defines a `status` property, this helper will wait
 * for the status to reach either "error" or "done".
 *
 * @param {object} store
 *        Redux store where the action should be dispatched.
 * @param {string} actionType
 *        The actionType to wait for.
 * @param {number} repeat
 *        Optional, number of time the action is expected to be dispatched.
 *        Defaults to 1
 * @return {Promise}
 */
function waitForDispatch(store, actionType, repeat = 1) {
  let count = 0;
  return new Promise(resolve => {
    store.dispatch({
      type: "@@service/waitUntil",
      predicate: action => {
        const isDone =
          !action.status ||
          action.status === "done" ||
          action.status === "error";

        if (action.type === actionType && isDone && ++count == repeat) {
          return true;
        }

        return false;
      },
      run: (dispatch, getState, action) => {
        resolve(action);
      },
    });
  });
}

/**
 * Retrieve a browsing context in nested frames.
 *
 * @param {BrowsingContext|XULBrowser} browsingContext
 *        The topmost browsing context under which we should search for the
 *        browsing context.
 * @param {Array<string>} selectors
 *        Array of CSS selectors that form a path to a specific nested frame.
 * @return {BrowsingContext} The nested browsing context.
 */
async function getBrowsingContextInFrames(browsingContext, selectors) {
  let context = browsingContext;

  if (!Array.isArray(selectors)) {
    throw new Error(
      "getBrowsingContextInFrames called with an invalid selectors argument"
    );
  }

  if (selectors.length === 0) {
    throw new Error(
      "getBrowsingContextInFrames called with an empty selectors array"
    );
  }

  const clonedSelectors = [...selectors];
  while (clonedSelectors.length) {
    const selector = clonedSelectors.shift();
    context = await SpecialPowers.spawn(context, [selector], _selector => {
      return content.document.querySelector(_selector).browsingContext;
    });
  }

  return context;
}

/**
 * Synthesize a mouse event on an element, after ensuring that it is visible
 * in the viewport.
 *
 * @param {string | Array} selector: The node selector to get the node target for the event.
 *        To target an element in a specific iframe, pass an array of CSS selectors
 *        (e.g. ["iframe", ".el-in-iframe"])
 * @param {number} x
 * @param {number} y
 * @param {object} options: Options that will be passed to BrowserTestUtils.synthesizeMouse
 */
async function safeSynthesizeMouseEventInContentPage(
  selector,
  x,
  y,
  options = {}
) {
  let context = gBrowser.selectedBrowser.browsingContext;

  // If an array of selector is passed, we need to retrieve the context in which the node
  // lives in.
  if (Array.isArray(selector)) {
    if (selector.length === 1) {
      selector = selector[0];
    } else {
      context = await getBrowsingContextInFrames(
        context,
        // only pass the iframe path
        selector.slice(0, -1)
      );
      // retrieve the last item of the selector, which should be the one for the node we want.
      selector = selector.at(-1);
    }
  }

  await scrollContentPageNodeIntoView(context, selector);
  BrowserTestUtils.synthesizeMouse(selector, x, y, options, context);
}

/**
 * Synthesize a mouse event at the center of an element, after ensuring that it is visible
 * in the viewport.
 *
 * @param {string | Array} selector: The node selector to get the node target for the event.
 *        To target an element in a specific iframe, pass an array of CSS selectors
 *        (e.g. ["iframe", ".el-in-iframe"])
 * @param {object} options: Options that will be passed to BrowserTestUtils.synthesizeMouse
 */
async function safeSynthesizeMouseEventAtCenterInContentPage(
  selector,
  options = {}
) {
  let context = gBrowser.selectedBrowser.browsingContext;

  // If an array of selector is passed, we need to retrieve the context in which the node
  // lives in.
  if (Array.isArray(selector)) {
    if (selector.length === 1) {
      selector = selector[0];
    } else {
      context = await getBrowsingContextInFrames(
        context,
        // only pass the iframe path
        selector.slice(0, -1)
      );
      // retrieve the last item of the selector, which should be the one for the node we want.
      selector = selector.at(-1);
    }
  }

  await scrollContentPageNodeIntoView(context, selector);
  BrowserTestUtils.synthesizeMouseAtCenter(selector, options, context);
}

/**
 * Scroll into view an element in the content page matching the passed selector
 *
 * @param {BrowsingContext} browsingContext: The browsing context the element lives in.
 * @param {string} selector: The node selector to get the node to scroll into view
 * @returns {Promise}
 */
function scrollContentPageNodeIntoView(browsingContext, selector) {
  return SpecialPowers.spawn(
    browsingContext,
    [selector],
    function (innerSelector) {
      const node =
        content.wrappedJSObject.document.querySelector(innerSelector);
      node.scrollIntoView();
    }
  );
}

/**
 * Change the zoom level of the selected page.
 *
 * @param {number} zoomLevel
 */
function setContentPageZoomLevel(zoomLevel) {
  gBrowser.selectedBrowser.fullZoom = zoomLevel;
}

/**
 * Wait for the next DOCUMENT_EVENT dom-complete resource on a top-level target
 *
 * @param {object} commands
 * @return {Promise<object>}
 *         Return a promise which resolves once we fully settle the resource listener.
 *         You should await for its resolution before doing the action which may fire
 *         your resource.
 *         This promise will resolve with an object containing a `onDomCompleteResource` property,
 *         which is also a promise, that will resolve once a "top-level" DOCUMENT_EVENT dom-complete
 *         is received.
 */
async function waitForNextTopLevelDomCompleteResource(commands) {
  const { onResource: onDomCompleteResource } =
    await commands.resourceCommand.waitForNextResource(
      commands.resourceCommand.TYPES.DOCUMENT_EVENT,
      {
        ignoreExistingResources: true,
        predicate: resource =>
          resource.name === "dom-complete" && resource.targetFront.isTopLevel,
      }
    );
  return { onDomCompleteResource };
}

/**
 * Wait for the provided context to have a valid presShell. This can be useful
 * for tests which try to create popup panels or interact with the document very
 * early.
 *
 * @param {BrowsingContext} context
 */
function waitForPresShell(context) {
  return SpecialPowers.spawn(context, [], async () => {
    const winUtils = SpecialPowers.getDOMWindowUtils(content);
    await ContentTaskUtils.waitForCondition(() => {
      try {
        return !!winUtils.getPresShellId();
      } catch (e) {
        return false;
      }
    }, "Waiting for a valid presShell");
  });
}

/**
 * In tests using Fluent localization, it is preferable to match DOM elements using
 * a message ID rather than the raw string as:
 *
 *  1. It allows testing infrastructure to be multilingual if needed.
 *  2. It isolates the tests from localization changes.
 *
 * @param {Array<string>} resourceIds A list of .ftl files to load.
 * @returns {(id: string, args?: Record<string, FluentVariable>) => string}
 */
async function getFluentStringHelper(resourceIds) {
  const locales = Services.locale.appLocalesAsBCP47;
  const generator = L10nRegistry.getInstance().generateBundles(
    locales,
    resourceIds
  );

  const bundles = [];
  for await (const bundle of generator) {
    bundles.push(bundle);
  }

  const reactLocalization = new FluentReact.ReactLocalization(bundles);

  /**
   * Get the string from a message id. It throws when the message is not found.
   *
   * @param {string} id
   * @param {string} attributeName: attribute name if you need to access a specific attribute
   *                 defined in the fluent string, e.g. setting "title" for this param
   *                 will retrieve the `title` string in
   *                    compatibility-issue-browsers-list =
   *                      .title = This is the title
   * @param {Record<string, FluentVariable>} [args] optional
   * @returns {string}
   */
  return (id, attributeName, args) => {
    let string;

    if (!attributeName) {
      string = reactLocalization.getString(id, args);
    } else {
      for (const bundle of reactLocalization.bundles) {
        const msg = bundle.getMessage(id);
        if (msg?.attributes[attributeName]) {
          string = bundle.formatPattern(
            msg.attributes[attributeName],
            args,
            []
          );
          break;
        }
      }
    }

    if (!string) {
      throw new Error(
        `Could not find a string for "${id}"${
          attributeName ? ` and attribute "${attributeName}")` : ""
        }. Was the correct resource bundle loaded?`
      );
    }
    return string;
  };
}

/**
 * Open responsive design mode for the given tab.
 */
async function openRDM(tab, { waitForDeviceList = true } = {}) {
  info("Opening responsive design mode");
  const manager = ResponsiveUIManager;
  const ui = await manager.openIfNeeded(tab.documentGlobal, tab, {
    trigger: "test",
  });
  info("Responsive design mode opened");

  await ResponsiveMessageHelper.wait(ui.toolWindow, "post-init");
  info("Responsive design initialized");

  await waitForRDMLoaded(ui, { waitForDeviceList });

  return { ui, manager };
}

async function waitForRDMLoaded(ui, { waitForDeviceList = true } = {}) {
  // Always wait for the viewport to be added.
  const { store } = ui.toolWindow;
  await waitUntilState(store, state => state.viewports.length == 1);

  if (waitForDeviceList) {
    // Wait until the device list has been loaded.
    await waitUntilState(
      store,
      state => state.devices.listState == localTypes.loadableState.LOADED
    );
  }
}

/**
 * Close responsive design mode for the given tab.
 */
async function closeRDM(tab, options) {
  info("Closing responsive design mode");
  const manager = ResponsiveUIManager;
  await manager.closeIfNeeded(tab.documentGlobal, tab, options);
  info("Responsive design mode closed");
}

function getInputStream(data) {
  const BufferStream = Components.Constructor(
    "@mozilla.org/io/arraybuffer-input-stream;1",
    "nsIArrayBufferInputStream",
    "setData"
  );
  const buffer = new TextEncoder().encode(data).buffer;
  return new BufferStream(buffer, 0, buffer.byteLength);
}

/**
 * Wait for a specific target to have been fully processed by targetCommand.
 *
 * @param {Commands} commands
 *        The commands instance
 * @param {Function} isExpectedTargetFn
 *        Predicate which will be called with a target front argument. Should
 *        return true if the target front is the expected one, false otherwise.
 * @return {Promise}
 *         Promise which resolves when a target matching `isExpectedTargetFn`
 *         has been processed by targetCommand.
 */
function waitForTargetProcessed(commands, isExpectedTargetFn) {
  return new Promise(resolve => {
    const onProcessed = targetFront => {
      try {
        if (isExpectedTargetFn(targetFront)) {
          commands.targetCommand.off("processed-available-target", onProcessed);
          resolve();
        }
      } catch {
        // Ignore errors from isExpectedTargetFn.
      }
    };

    commands.targetCommand.on("processed-available-target", onProcessed);
  });
}

/**
 * Instantiate a HTTP Server that serves files from a given test folder.
 * The test folder should be made of multiple sub folder named: v1, v2, v3,...
 * We will serve the content from one of these sub folder
 * and switch to the next one, each time `httpServer.switchToNextVersion()`
 * is called.
 *
 * @return Object Test server with two functions:
 *   - urlFor(path)
 *     Returns the absolute url for a given file.
 *   - switchToNextVersion()
 *     Start serving files from the next available sub folder.
 *   - backToFirstVersion()
 *     When running more than one test, helps restart from the first folder.
 */
function createVersionizedHttpTestServer(testFolderName) {
  const httpServer = createTestHTTPServer();

  let currentVersion = 1;

  httpServer.registerPrefixHandler("/", async (request, response) => {
    response.processAsync();
    response.setStatusLine(request.httpVersion, 200, "OK");
    if (request.path.endsWith(".js")) {
      response.setHeader("Content-Type", "application/javascript");
    } else if (request.path.endsWith(".js.map")) {
      response.setHeader("Content-Type", "application/json");
    }
    if (request.path == "/" || request.path.endsWith(".html")) {
      response.setHeader("Content-Type", "text/html");
    }
    // If a query string is passed, lookup with a matching file, if available
    // The '?' is replaced by '.'
    let fetchResponse;

    if (request.queryString) {
      const url = `${URL_ROOT_SSL}${testFolderName}/v${currentVersion}${request.path}.${request.queryString}`;
      try {
        fetchResponse = await fetch(url);
        // Log this only if the request succeed
        info(`[test-http-server] serving: ${url}`);
      } catch (e) {
        // Ignore any error and proceed without the query string
        fetchResponse = null;
      }
    }

    if (!fetchResponse) {
      const url = `${URL_ROOT_SSL}${testFolderName}/v${currentVersion}${request.path}`;
      info(`[test-http-server] serving: ${url}`);
      fetchResponse = await fetch(url);
    }

    // Ensure forwarding the response headers generated by the other http server
    // (this can be especially useful when query .sjs files)
    for (const [name, value] of fetchResponse.headers.entries()) {
      response.setHeader(name, value);
    }

    // Override cache settings so that versionized requests are never cached
    // and we get brand new content for any request.
    response.setHeader("Cache-Control", "no-store");

    const text = await fetchResponse.text();
    response.write(text);
    response.finish();
  });

  return {
    switchToNextVersion() {
      currentVersion++;
    },
    backToFirstVersion() {
      currentVersion = 1;
    },
    urlFor(path) {
      const port = httpServer.identity.primaryPort;
      return `http://localhost:${port}/${path}`;
    },
  };
}

/**
 * Fake clicking a link and return the URL we would have navigated to.
 * This function should be used to check external links since we can't access
 * network in tests.
 * This can also be used to test that a click will not be fired.
 *
 * @param ElementNode element
 *        The <a> element we want to simulate click on.
 * @returns Promise
 *          A Promise that is resolved when the link click simulation occured or
 *          when the click is not dispatched.
 *          The promise resolves with an object that holds the following properties
 *          - link: url of the link or null(if event not fired)
 *          - where: "tab" if tab is active or "tabshifted" if tab is inactive
 *            or null(if event not fired)
 */
function simulateLinkClick(element) {
  const browserWindow = Services.wm.getMostRecentWindow(
    gDevTools.chromeWindowType
  );

  const onOpenLink = new Promise(resolve => {
    const openLinkIn = (link, where) => resolve({ link, where });
    sinon.replace(browserWindow, "openTrustedLinkIn", openLinkIn);
    sinon.replace(browserWindow, "openWebLinkIn", openLinkIn);
  });

  element.click();

  // Declare a timeout Promise that we can use to make sure spied methods were not called.
  const onTimeout = new Promise(function (resolve) {
    setTimeout(() => {
      resolve({ link: null, where: null });
    }, 1000);
  });

  const raceResult = Promise.race([onOpenLink, onTimeout]);
  sinon.restore();
  return raceResult;
}

/**
 * Since the MDN data is updated frequently, it might happen that the properties used in
 * this test are not in the dataset anymore/now have URLs.
 * This function will return properties in the dataset that don't have MDN url so you
 * can easily find a replacement.
 */
function logCssCompatDataPropertiesWithoutMDNUrl() {
  const cssPropertiesCompatData = require("resource://devtools/shared/compatibility/dataset/css-properties.json");

  function walk(node) {
    for (const propertyName in node) {
      const property = node[propertyName];
      if (property.__compat) {
        if (!property.__compat.mdn_url) {
          dump(
            `"${propertyName}" - MDN URL: ${
              property.__compat.mdn_url || "❌"
            } - Spec URL: ${property.__compat.spec_url || "❌"}\n`
          );
        }
      } else if (typeof property == "object") {
        walk(property);
      }
    }
  }
  walk(cssPropertiesCompatData);
}

/**
 * Craft a CssProperties instance without involving RDP for tests
 * manually spawning OutputParser, CssCompleter, Editor...
 *
 * Otherwise this should instead be fetched from CssPropertiesFront.
 *
 * @return {CssProperties}
 */
function getClientCssProperties() {
  const {
    generateCssProperties,
  } = require("resource://devtools/server/actors/css-properties.js");
  const {
    CssProperties,
    normalizeCssData,
  } = require("resource://devtools/client/fronts/css-properties.js");
  return new CssProperties(
    normalizeCssData({ properties: generateCssProperties(document) })
  );
}

/**
 * Helper method to stop a Service Worker promptly.
 *
 * @param {string} workerUrl
 *        Absolute Worker URL to stop.
 */
async function stopServiceWorker(workerUrl) {
  info(`Stop Service Worker: ${workerUrl}\n`);

  // Help the SW to be immediately destroyed after unregistering it.
  Services.prefs.setIntPref("dom.serviceWorkers.idle_timeout", 0);

  const swm = Cc["@mozilla.org/serviceworkers/manager;1"].getService(
    Ci.nsIServiceWorkerManager
  );
  // Unfortunately we can't use swm.getRegistrationByPrincipal, as it requires a "scope", which doesn't seem to be the worker URL.
  // So let's use getAllRegistrations to find the nsIServiceWorkerInfo in order to:
  // - retrieve its active worker,
  // - call attach+detachDebugger,
  // - reset the idle timeout.
  // This way, the unregister instruction is immediate, thanks to the 0 dom.serviceWorkers.idle_timeout we set at the beginning of the function
  const registrations = swm.getAllRegistrations();
  let matchedInfo;
  for (let i = 0; i < registrations.length; i++) {
    const info = registrations.queryElementAt(
      i,
      Ci.nsIServiceWorkerRegistrationInfo
    );
    // Lookup for an exact URL match.
    if (info.scriptSpec === workerUrl) {
      matchedInfo = info;
      break;
    }
  }
  ok(!!matchedInfo, "Found the service worker info");

  info("Wait for the worker to be active");
  await waitFor(() => matchedInfo.activeWorker, "Wait for the SW to be active");

  // We need to attach+detach the debugger in order to reset the idle timeout.
  // Otherwise the worker would still be waiting for a previously registered timeout
  // which would be the 0ms one we set by tweaking the preference.
  function resetWorkerTimeout(worker) {
    worker.attachDebugger();
    worker.detachDebugger();
  }
  resetWorkerTimeout(matchedInfo.activeWorker);
  // Also reset all the other possible worker instances
  if (matchedInfo.evaluatingWorker) {
    resetWorkerTimeout(matchedInfo.evaluatingWorker);
  }
  if (matchedInfo.installingWorker) {
    resetWorkerTimeout(matchedInfo.installingWorker);
  }
  if (matchedInfo.waitingWorker) {
    resetWorkerTimeout(matchedInfo.waitingWorker);
  }
  // Reset this preference in order to ensure other SW are not immediately destroyed.
  Services.prefs.clearUserPref("dom.serviceWorkers.idle_timeout");

  // Spin the event loop to ensure the worker had time to really be shut down.
  await wait(0);

  return matchedInfo;
}

/**
 * Helper method to stop and unregister a Service Worker promptly.
 *
 * @param {string} workerUrl
 *        Absolute Worker URL to unregister.
 */
async function unregisterServiceWorker(workerUrl) {
  const swInfo = await stopServiceWorker(workerUrl);

  info(`Unregister Service Worker: ${workerUrl}\n`);
  // Now call unregister on that worker so that it can be destroyed immediately
  const swm = Cc["@mozilla.org/serviceworkers/manager;1"].getService(
    Ci.nsIServiceWorkerManager
  );
  const unregisterSuccess = await new Promise(resolve => {
    swm.unregister(
      swInfo.principal,
      {
        unregisterSucceeded(success) {
          resolve(success);
        },
      },
      swInfo.scope
    );
  });
  ok(unregisterSuccess, "Service worker successfully unregistered");
}

/**
 * Toggle the JavavaScript tracer via its toolbox toolbar button.
 */
async function toggleJsTracer(toolbox) {
  const { tracerCommand } = toolbox.commands;
  const { isTracingEnabled } = tracerCommand;
  const { logMethod, traceOnNextInteraction, traceOnNextLoad } =
    toolbox.commands.tracerCommand.getTracingOptions();

  // When the tracer is waiting for user interaction or page load, it won't be made active
  // right away. The test should manually wait for its activation.
  const shouldWaitForToggle = !traceOnNextInteraction && !traceOnNextLoad;
  let onTracingToggled;
  if (shouldWaitForToggle) {
    onTracingToggled = new Promise(resolve => {
      tracerCommand.on("toggle", async function listener() {
        // Ignore the event, if we are still in the same state as before the click
        if (tracerCommand.isTracingActive == isTracingEnabled) {
          return;
        }
        tracerCommand.off("toggle", listener);
        resolve();
      });
    });
  }

  const toolbarButton = toolbox.doc.getElementById("command-button-jstracer");
  toolbarButton.click();

  if (shouldWaitForToggle) {
    info("Waiting for the tracer to be active");
    await onTracingToggled;
  }

  const {
    TRACER_LOG_METHODS,
  } = require("resource://devtools/shared/specs/tracer.js");
  if (logMethod != TRACER_LOG_METHODS.CONSOLE) {
    return;
  }

  // We were tracing and just requested to stop it.
  // Wait for the stop message to appear in the console before clearing its content.
  // This simplifies writting tests toggling the tracer ON multiple times and checking
  // for the display of traces in the console.
  if (isTracingEnabled) {
    const { hud } = await toolbox.getPanel("webconsole");
    info("Wait for tracing to be disabled");
    await waitFor(() =>
      [...hud.ui.outputNode.querySelectorAll(".message")].some(msg =>
        msg.textContent.includes("Stopped tracing")
      )
    );

    hud.ui.clearOutput();
    await waitFor(
      () => hud.ui.outputNode.querySelectorAll(".message").length === 0
    );
  } else {
    // We are enabling the tracing to the console, and the console may not be opened just yet.
    const { hud } = await toolbox.getPanelWhenReady("webconsole");
    if (!traceOnNextInteraction && !traceOnNextLoad) {
      await waitFor(() =>
        [...hud.ui.outputNode.querySelectorAll(".message")].some(msg =>
          msg.textContent.includes("Started tracing to Web Console")
        )
      );
    }
  }
}

/**
 * Retrieve the context menu element corresponding to the provided id, for the
 * provided netmonitor instance.
 *
 * @param {object} monitor
 *        The network monitor object
 * @param {string} id
 *        The id of the context menu item
 */
function getNetmonitorContextMenuItem(monitor, id) {
  const menuDoc = DevToolsUtils.getTopWindow(monitor.panelWin).document;
  return menuDoc.getElementById(id);
}

/**
 * Selects and clicks the context menu item of the netmonitor, it should
 * also wait for the popup to close.
 *
 * @param {object} monitor
 *        The network monitor object
 * @param {string} id
 *        The id of the context menu item
 */
async function selectNetmonitorContextMenuItem(monitor, id) {
  const contextMenuItem = getNetmonitorContextMenuItem(monitor, id);

  const popup = contextMenuItem.parentNode;
  await _maybeOpenAncestorMenu(contextMenuItem);
  const hidden = BrowserTestUtils.waitForEvent(popup, "popuphidden");
  popup.activateItem(contextMenuItem);
  await hidden;
}

async function _maybeOpenAncestorMenu(menuItem) {
  const parentPopup = menuItem.parentNode;
  if (parentPopup.state == "open") {
    return;
  }
  const shown = BrowserTestUtils.waitForEvent(parentPopup, "popupshown");
  if (parentPopup.state == "showing") {
    await shown;
    return;
  }
  const parentMenu = parentPopup.parentNode;
  await _maybeOpenAncestorMenu(parentMenu);
  parentMenu.openMenu(true);
  await shown;
}

/**
 * Returns the list of console messages DOM Element display in the Web Console
 * which contains a given string.
 *
 * @param {Toolbox} toolbox
 * @param {string} query
 * @return {Array<DOMElement>}
 */
async function findConsoleMessages(toolbox, query) {
  const webConsole = await toolbox.getPanel("webconsole");
  const win = webConsole._frameWindow;
  return Array.prototype.filter.call(
    win.document.querySelectorAll(".message"),
    e => e.innerText.includes(query)
  );
}

/**
 * Wait for a console message to appear with a given text and a given link to
 * a specific location in a JS source.
 * Returns the DOM Element in the Web Console for the link to the JS Source.
 *
 * @param {Toolbox} toolbox
 * @param {string} messageText
 * @param {string} linkText
 * @return {DOMElement}
 */
async function waitForConsoleMessageLink(toolbox, messageText, linkText) {
  await toolbox.selectTool("webconsole");

  return waitFor(async () => {
    // Wait until the message updates.
    const [message] = await findConsoleMessages(toolbox, messageText);
    if (!message) {
      return false;
    }
    const linkEl = message.querySelector(".frame-link-source");
    if (!linkEl || linkEl.textContent !== linkText) {
      return false;
    }

    return linkEl;
  });
}

/**
 * Click on a Frame component link and ensure it opens the debugger on the expected location
 *
 * @param {Toolbox} toolbox
 * @param {DOMElement} frameLinkNode
 * @param {Object] options
 * @param {string | null} options.url
 * @param {number | null} options.line
 * @param {number | null} options.column
 * @param {string | undefined} logPointExpr
 */
async function clickAndAssertFrameLinkNode(
  toolbox,
  frameLinkNode,
  { url, line, column },
  logPointExpr
) {
  info("checking click on node location");

  // If the debugger hasn't fully loaded yet and breakpoints are still being
  // added when we click on the logpoint link, the logpoint panel might not
  // render. Work around this for now, see bug 1592854.
  if (logPointExpr) {
    await waitForTime(1000);
  }

  const onSourceOpened = toolbox.once("source-opened-in-debugger");

  EventUtils.sendMouseEvent(
    { type: "click" },
    // The frame DOM Element may be coming from a Debugger Frame component, or a shared compoentn Frame component
    // and the link would be at a distinct selector.
    frameLinkNode.querySelector(".frame-link-filename") ||
      frameLinkNode.querySelector(".location")
  );

  // Wait for the source to finish loading, if it is pending.
  await onSourceOpened;

  // Wait for the debugger to have fully processed the opened source
  const dbg = toolbox.getPanel("jsdebugger");

  const selectedLocation = await waitFor(() =>
    dbg._selectors.getSelectedLocation(dbg._getState())
  );

  if (typeof url == "string") {
    const frameUrl = frameLinkNode.getAttribute("data-url");
    is(frameUrl, url, "Frame link url is correct");

    is(selectedLocation.source.url, url, "debugger opened url is correct");
  }
  if (typeof line == "number") {
    const frameLine = frameLinkNode.getAttribute("data-line");
    is(parseInt(frameLine, 10), line, "Frame link line is correct");

    is(selectedLocation.line, line, "debugger opened line is correct");
  }
  if (typeof column == "number") {
    // Note that debugger's Frame component doesn't show the column
    const frameColumn = frameLinkNode.getAttribute("data-column");
    is(parseInt(frameColumn, 10), column, "Frame link column is correct");

    // Redux location object uses 0-based column, while we display a 1-based one.
    is(
      selectedLocation.column + 1,
      column,
      "debugger opened column is correct"
    );
  }

  if (logPointExpr !== undefined && logPointExpr !== "") {
    const inputEl = dbg.panelWin.document.activeElement;

    const isPanelFocused =
      inputEl.classList.contains("cm-content") &&
      inputEl.closest(".conditional-breakpoint-panel.log-point");

    ok(isPanelFocused, "The textarea of logpoint panel is focused");

    const inputValue = inputEl.parentElement.parentElement.innerText.trim();
    is(
      inputValue,
      logPointExpr,
      "The input in the open logpoint panel matches the logpoint expression"
    );
  }
}
