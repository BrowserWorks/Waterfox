/* vim:set ts=2 sw=2 sts=2 et: */
/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* Bug 661762 */

// Use the old webconsole since scratchpad focus isn't working on new one (Bug 1304794)
Services.prefs.setBoolPref("devtools.webconsole.new-frontend-enabled", false);
registerCleanupFunction(function* () {
  Services.prefs.clearUserPref("devtools.webconsole.new-frontend-enabled");
});

function test()
{
  waitForExplicitFinish();

  // To test for this bug we open a Scratchpad window, save its
  // reference and then open another one. This way the first window
  // loses its focus.
  //
  // Then we open a web console and execute a console.log statement
  // from the first Scratch window (that's why we needed to save its
  // reference).
  //
  // Then we wait for our message to appear in the console and click
  // on the location link. After that we check which Scratchpad window
  // is currently active (it should be the older one).

  gBrowser.selectedTab = gBrowser.addTab();
  gBrowser.selectedBrowser.addEventListener("load", function onLoad() {
    gBrowser.selectedBrowser.removeEventListener("load", onLoad, true);

    openScratchpad(function () {
      let sw = gScratchpadWindow;
      let {require} = Cu.import("resource://devtools/shared/Loader.jsm", {});
      let {TargetFactory} = require("devtools/client/framework/target");

      openScratchpad(function () {
        let target = TargetFactory.forTab(gBrowser.selectedTab);
        gDevTools.showToolbox(target, "webconsole").then((toolbox) => {
          let hud = toolbox.getCurrentPanel().hud;
          hud.jsterm.clearOutput(true);
          testFocus(sw, hud);
        });
      });
    });
  }, true);

  content.location = "data:text/html;charset=utf8,<p>test window focus for Scratchpad.";
}

function testFocus(sw, hud) {
  let sp = sw.Scratchpad;

  function onMessage(event, messages) {
    let msg = [...messages][0];
    let node = msg.node;

    var loc = node.querySelector(".frame-link");
    ok(loc, "location element exists");
    is(loc.getAttribute("data-url"), sw.Scratchpad.uniqueName, "location value is correct");
    is(loc.getAttribute("data-line"), "1", "line value is correct");
    is(loc.getAttribute("data-column"), "1", "column value is correct");

    sw.addEventListener("focus", function onFocus() {
      sw.removeEventListener("focus", onFocus, true);

      let win = Services.wm.getMostRecentWindow("devtools:scratchpad");

      ok(win, "there are active Scratchpad windows");
      is(win.Scratchpad.uniqueName, sw.Scratchpad.uniqueName,
          "correct window is in focus");

      // gScratchpadWindow will be closed automatically but we need to
      // close the second window ourselves.
      sw.close();
      finish();
    }, true);

    // Simulate a click on the "Scratchpad/N:1" link.
    EventUtils.synthesizeMouse(loc, 2, 2, {}, hud.iframeWindow);
  }

  // Sending messages to web console is an asynchronous operation. That's
  // why we have to setup an observer here.
  hud.ui.once("new-messages", onMessage);

  sp.setText("console.log('foo');");
  sp.run().then(function ([selection, error, result]) {
    is(selection, "console.log('foo');", "selection is correct");
    is(error, undefined, "error is correct");
    is(result.type, "undefined", "result is correct");
  });
}
