/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { addDebuggerToGlobal } = ChromeUtils.import(
  "resource://gre/modules/jsdebugger.jsm"
);
addDebuggerToGlobal(this);

/**
 * Ensure that sandboxes created via the Dev Tools loader respect the
 * invisibleToDebugger flag.
 */
function run_test() {
  visible_loader();
  invisible_loader();
}

function visible_loader() {
  const loader = new DevToolsLoader({
    invisibleToDebugger: false,
  });
  loader.require("devtools/shared/indentation");

  const dbg = new Debugger();
  const sandbox = loader.loader.sharedGlobalSandbox;

  try {
    dbg.addDebuggee(sandbox);
    Assert.ok(true);
  } catch (e) {
    do_throw("debugger could not add visible value");
  }

  // Check that for common loader used for tabs, promise modules is Promise.jsm
  // Which is required to support unhandled promises rejection in mochitests
  const promise = ChromeUtils.import("resource://gre/modules/Promise.jsm")
    .Promise;
  Assert.equal(loader.require("promise"), promise);
}

function invisible_loader() {
  const loader = new DevToolsLoader({
    invisibleToDebugger: true,
  });
  loader.require("devtools/shared/indentation");

  const dbg = new Debugger();
  const sandbox = loader.loader.sharedGlobalSandbox;

  try {
    dbg.addDebuggee(sandbox);
    do_throw("debugger added invisible value");
  } catch (e) {
    Assert.ok(true);
  }

  // But for browser toolbox loader, promise is loaded as a regular modules out
  // of Promise-backend.js, that to be invisible to the debugger and not step
  // into it.
  const promise = loader.require("promise");
  const promiseModule =
    loader.loader.modules["resource://gre/modules/Promise-backend.js"];
  Assert.equal(promise, promiseModule.exports);
}
