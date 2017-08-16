/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/* global addEventListener, addMessageListener, removeMessageListener, sendAsyncMessage */

try {
  var chromeGlobal = this;

  // Encapsulate in its own scope to allows loading this frame script more than once.
  (function () {
    const Cu = Components.utils;
    const { require } = Cu.import("resource://devtools/shared/Loader.jsm", {});

    const DevToolsUtils = require("devtools/shared/DevToolsUtils");
    const { dumpn } = DevToolsUtils;
    const { DebuggerServer, ActorPool } = require("devtools/server/main");

    if (!DebuggerServer.initialized) {
      DebuggerServer.init();
    }
    // We want a special server without any root actor and only tab actors.
    // We are going to spawn a ContentActor instance in the next few lines,
    // it is going to act like a root actor without being one.
    DebuggerServer.registerActors({ root: false, browser: false, tab: true });

    let connections = new Map();

    let onConnect = DevToolsUtils.makeInfallible(function (msg) {
      removeMessageListener("debug:connect", onConnect);

      let mm = msg.target;
      let prefix = msg.data.prefix;
      let addonId = msg.data.addonId;

      let conn = DebuggerServer.connectToParent(prefix, mm);
      conn.parentMessageManager = mm;
      connections.set(prefix, conn);

      let actor;

      if (addonId) {
        const { WebExtensionChildActor } = require("devtools/server/actors/webextension");
        actor = new WebExtensionChildActor(conn, chromeGlobal, prefix, addonId);
      } else {
        const { ContentActor } = require("devtools/server/actors/childtab");
        actor = new ContentActor(conn, chromeGlobal, prefix);
      }

      let actorPool = new ActorPool(conn);
      actorPool.addActor(actor);
      conn.addActorPool(actorPool);

      sendAsyncMessage("debug:actor", {actor: actor.form(), prefix: prefix});
    });

    addMessageListener("debug:connect", onConnect);

    // Allows executing module setup helper from the parent process.
    // See also: DebuggerServer.setupInChild()
    let onSetupInChild = DevToolsUtils.makeInfallible(msg => {
      let { module, setupChild, args } = msg.data;
      let m;

      try {
        m = require(module);

        if (!(setupChild in m)) {
          dumpn(`ERROR: module '${module}' does not export '${setupChild}'`);
          return false;
        }

        m[setupChild].apply(m, args);
      } catch (e) {
        let errorMessage =
          "Exception during actor module setup running in the child process: ";
        DevToolsUtils.reportException(errorMessage + e);
        dumpn(`ERROR: ${errorMessage}\n\t module: '${module}'\n\t ` +
              `setupChild: '${setupChild}'\n${DevToolsUtils.safeErrorString(e)}`);
        return false;
      }
      if (msg.data.id) {
        // Send a message back to know when it is processed
        sendAsyncMessage("debug:setup-in-child-response", {id: msg.data.id});
      }
      return true;
    });

    addMessageListener("debug:setup-in-child", onSetupInChild);

    let onDisconnect = DevToolsUtils.makeInfallible(function (msg) {
      let prefix = msg.data.prefix;
      let conn = connections.get(prefix);
      if (!conn) {
        // Several copies of this frame script can be running for a single frame since it
        // is loaded once for each DevTools connection to the frame.  If this disconnect
        // request doesn't match a connection known here, ignore it.
        return;
      }

      removeMessageListener("debug:disconnect", onDisconnect);
      // Call DebuggerServerConnection.close to destroy all child actors. It should end up
      // calling DebuggerServerConnection.onClosed that would actually cleanup all actor
      // pools.
      conn.close();
      connections.delete(prefix);
    });
    addMessageListener("debug:disconnect", onDisconnect);

    // In non-e10s mode, the "debug:disconnect" message isn't always received before the
    // messageManager connection goes away.  Watching for "unload" here ensures we close
    // any connections when the frame is unloaded.
    addEventListener("unload", () => {
      for (let conn of connections.values()) {
        conn.close();
      }
      connections.clear();
    });
  })();
} catch (e) {
  dump(`Exception in app child process: ${e}\n`);
}
