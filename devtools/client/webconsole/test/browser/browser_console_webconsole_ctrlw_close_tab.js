/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Check that Ctrl-W closes the Browser Console and that Ctrl-W closes the
// current tab when using the Web Console - bug 871156.

"use strict";

add_task(async function() {
  const TEST_URI =
    "data:text/html;charset=utf8,<title>bug871156</title>\n" + "<p>hello world";
  const firstTab = gBrowser.selectedTab;

  let hud = await openNewTabAndConsole(TEST_URI);

  const tabClosed = defer();
  const toolboxDestroyed = defer();
  const tabSelected = defer();

  const target = await TargetFactory.forTab(gBrowser.selectedTab);
  const toolbox = gDevTools.getToolbox(target);

  gBrowser.tabContainer.addEventListener(
    "TabClose",
    function() {
      info("tab closed");
      tabClosed.resolve(null);
    },
    { once: true }
  );

  gBrowser.tabContainer.addEventListener(
    "TabSelect",
    function() {
      if (gBrowser.selectedTab == firstTab) {
        info("tab selected");
        tabSelected.resolve(null);
      }
    },
    { once: true }
  );

  toolbox.once("destroyed", () => {
    info("toolbox destroyed");
    toolboxDestroyed.resolve(null);
  });

  // Get out of the web console initialization.
  executeSoon(() => {
    EventUtils.synthesizeKey("w", { accelKey: true });
  });

  await promise.all([
    tabClosed.promise,
    toolboxDestroyed.promise,
    tabSelected.promise,
  ]);
  info("promise.all resolved. start testing the Browser Console");

  hud = await BrowserConsoleManager.toggleBrowserConsole();
  ok(hud, "Browser Console opened");

  const deferred = defer();

  Services.obs.addObserver(function onDestroy() {
    Services.obs.removeObserver(onDestroy, "web-console-destroyed");
    ok(true, "the Browser Console closed");

    deferred.resolve(null);
  }, "web-console-destroyed");

  waitForFocus(() => {
    EventUtils.synthesizeKey("w", { accelKey: true }, hud.iframeWindow);
  }, hud.iframeWindow);

  await deferred.promise;
});
