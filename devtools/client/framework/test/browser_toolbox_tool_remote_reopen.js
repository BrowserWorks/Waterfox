/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { DevToolsServer } = require("devtools/server/devtools-server");

// Bug 1277805: Too slow for debug runs
requestLongerTimeout(2);

/**
 * Bug 979536: Ensure fronts are destroyed after toolbox close.
 *
 * The fronts need to be destroyed manually to unbind their onPacket handlers.
 *
 * When you initialize a front and call |this.manage|, it adds a client actor
 * pool that the DevToolsClient uses to route packet replies to that actor.
 *
 * Most (all?) tools create a new front when they are opened.  When the destroy
 * step is skipped and the tool is reopened, a second front is created and also
 * added to the client actor pool.  When a packet reply is received, is ends up
 * being routed to the first (now unwanted) front that is still in the client
 * actor pool.  Since this is not the same front that was used to make the
 * request, an error occurs.
 *
 * This problem does not occur with the toolbox for a local tab because the
 * toolbox target creates its own DevToolsClient for the local tab, and the
 * client is destroyed when the toolbox is closed, which removes the client
 * actor pools, and avoids this issue.
 *
 * In remote debugging, we do not destroy the DevToolsClient on toolbox close
 * because it can still used for other targets.
 * Thus, the same client gets reused across multiple toolboxes,
 * which leads to the tools failing if they don't destroy their fronts.
 */

function runTools(target) {
  return (async function() {
    const toolIds = gDevTools
      .getToolDefinitionArray()
      .filter(def => def.isTargetSupported(target))
      .map(def => def.id);

    let toolbox;
    for (let index = 0; index < toolIds.length; index++) {
      const toolId = toolIds[index];

      info("About to open " + index + "/" + toolId);
      toolbox = await gDevTools.showToolbox(target, toolId, "window");
      ok(toolbox, "toolbox exists for " + toolId);
      is(toolbox.currentToolId, toolId, "currentToolId should be " + toolId);

      const panel = toolbox.getCurrentPanel();
      ok(panel.isReady, toolId + " panel should be ready");
    }

    await toolbox.destroy();
  })();
}

function test() {
  (async function() {
    toggleAllTools(true);
    const tab = await addTab("about:blank");

    const target = await TargetFactory.forTab(tab);
    const { client } = target;
    await runTools(target);

    const rootFronts = [...client.mainRoot.fronts.values()];

    // Actor fronts should be destroyed now that the toolbox has closed, but
    // look for any that remain.
    for (const pool of client.__pools) {
      if (!pool.__poolMap) {
        continue;
      }

      // Ignore the root fronts, which are top-level pools and aren't released
      // on toolbox destroy, but on client close.
      if (rootFronts.includes(pool)) {
        continue;
      }

      for (const actor of pool.__poolMap.keys()) {
        // Ignore the root front as it is only release on client close
        if (actor == "root") {
          continue;
        }
        // Bug 1056342: Profiler fails today because of framerate actor, but
        // this appears more complex to rework, so leave it for that bug to
        // resolve.
        if (actor.includes("framerateActor")) {
          todo(false, "Front for " + actor + " still held in pool!");
          continue;
        }
        ok(false, "Front for " + actor + " still held in pool!");
      }
    }

    gBrowser.removeCurrentTab();
    DevToolsServer.destroy();
    toggleAllTools(false);
    finish();
  })();
}
