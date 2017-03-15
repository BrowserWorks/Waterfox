/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

var prefs = Cc["@mozilla.org/preferences-service;1"]
            .getService(Ci.nsIPrefBranch);

Services.scriptloader.loadSubScript("chrome://mochitests/content/browser/" +
    "security/sandbox/test/browser_content_sandbox_utils.js", this);

/*
 * This test is for executing system calls in content processes to validate
 * that calls that are meant to be blocked by content sandboxing are blocked.
 * We use the term system calls loosely so that any OS API call such as
 * fopen could be included.
 */

// Calls the native execv library function. Include imports so this can be
// safely serialized and run remotely by ContentTask.spawn.
function callExec(args) {
  Components.utils.import("resource://gre/modules/ctypes.jsm");
  let {lib, cmd} = args;
  let libc = ctypes.open(lib);
  let exec = libc.declare("execv", ctypes.default_abi,
      ctypes.int, ctypes.char.ptr);
  let rv = exec(cmd);
  libc.close();
  return (rv);
}

// Calls the native fork syscall.
function callFork(args) {
  Components.utils.import("resource://gre/modules/ctypes.jsm");
  let {lib} = args;
  let libc = ctypes.open(lib);
  let fork = libc.declare("fork", ctypes.default_abi, ctypes.int);
  let rv = fork();
  libc.close();
  return (rv);
}

// Calls the native open/close syscalls.
function callOpen(args) {
  Components.utils.import("resource://gre/modules/ctypes.jsm");
  let {lib, path, flags} = args;
  let libc = ctypes.open(lib);
  let open = libc.declare("open", ctypes.default_abi,
                          ctypes.int, ctypes.char.ptr, ctypes.int);
  let close = libc.declare("close", ctypes.default_abi,
                           ctypes.int, ctypes.int);
  let fd = open(path, flags);
  close(fd);
  libc.close();
  return (fd);
}

// open syscall flags
function openWriteCreateFlags() {
  Assert.ok(isMac() || isLinux());
  if (isMac()) {
    let O_WRONLY = 0x001;
    let O_CREAT  = 0x200;
    return (O_WRONLY | O_CREAT);
  } else {
    // Linux
    let O_WRONLY = 0x01;
    let O_CREAT  = 0x40;
    return (O_WRONLY | O_CREAT);
  }
}

// Returns the name of the native library needed for native syscalls
function getOSLib() {
  switch (Services.appinfo.OS) {
    case "WINNT":
      return "kernel32.dll";
    case "Darwin":
      return "libc.dylib";
    case "Linux":
      return "libc.so.6";
    default:
      Assert.ok(false, "Unknown OS");
  }
}

// Returns a harmless command to execute with execv
function getOSExecCmd() {
  Assert.ok(!isWin());
  return ("/bin/cat");
}

// Returns true if the current content sandbox level, passed in
// the |level| argument, supports syscall sandboxing.
function areContentSyscallsSandboxed(level) {
  let syscallsSandboxMinLevel = 0;

  // Set syscallsSandboxMinLevel to the lowest level that has
  // syscall sandboxing enabled. For now, this varies across
  // Windows, Mac, Linux, other.
  switch (Services.appinfo.OS) {
    case "WINNT":
      syscallsSandboxMinLevel = 1;
      break;
    case "Darwin":
      syscallsSandboxMinLevel = 1;
      break;
    case "Linux":
      syscallsSandboxMinLevel = 2;
      break;
    default:
      Assert.ok(false, "Unknown OS");
  }

  return (level >= syscallsSandboxMinLevel);
}

//
// Drive tests for a single content process.
//
// Tests executing OS API calls in the content process. Limited to Mac
// and Linux calls for now.
//
add_task(function*() {
  // This test is only relevant in e10s
  if (!gMultiProcessBrowser) {
    ok(false, "e10s is enabled");
    info("e10s is not enabled, exiting");
    return;
  }

  let level = 0;
  let prefExists = true;

  // Read the security.sandbox.content.level pref.
  // If the pref isn't set and we're running on Linux on !isNightly(),
  // exit without failing. The Linux content sandbox is only enabled
  // on Nightly at this time.
  try {
    level = prefs.getIntPref("security.sandbox.content.level");
  } catch (e) {
    prefExists = false;
  }

  // Special case Linux on !isNightly
  if (isLinux() && !isNightly()) {
    todo(prefExists, "pref security.sandbox.content.level exists");
    if (!prefExists) {
      return;
    }
  }

  ok(prefExists, "pref security.sandbox.content.level exists");
  if (!prefExists) {
    return;
  }

  // Special case Linux on !isNightly
  if (isLinux() && !isNightly()) {
    todo(level > 0, "content sandbox enabled for !nightly.");
    return;
  }

  info(`security.sandbox.content.level=${level}`);
  ok(level > 0, "content sandbox is enabled.");
  if (level == 0) {
    info("content sandbox is not enabled, exiting");
    return;
  }

  let areSyscallsSandboxed = areContentSyscallsSandboxed(level);

  // Special case Linux on !isNightly
  if (isLinux() && !isNightly()) {
    todo(areSyscallsSandboxed, "content syscall sandbox enabled for !nightly.");
    return;
  }

  // Content sandbox enabled, but level doesn't include syscall sandboxing.
  ok(areSyscallsSandboxed, "content syscall sandboxing is enabled.");
  if (!areSyscallsSandboxed) {
    info("content sandbox level too low for syscall tests, exiting\n");
    return;
  }

  let browser = gBrowser.selectedBrowser;
  let lib = getOSLib();

  // use execv syscall
  // (causes content process to be killed on Linux)
  if (isMac()) {
    // exec something harmless, this should fail
    let cmd = getOSExecCmd();
    let rv = yield ContentTask.spawn(browser, {lib, cmd}, callExec);
    ok(rv == -1, `exec(${cmd}) is not permitted`);
  }

  // use open syscall
  if (isLinux() || isMac())
  {
    // open a file for writing in $HOME, this should fail
    let path = fileInHomeDir().path;
    let flags = openWriteCreateFlags();
    let fd = yield ContentTask.spawn(browser, {lib, path, flags}, callOpen);
    ok(fd < 0, "opening a file for writing in home is not permitted");
  }

  // use open syscall
  if (isLinux() || isMac())
  {
    // open a file for writing in the content temp dir, this should work
    // and the open handler in the content process closes the file for us
    let path = fileInTempDir().path;
    let flags = openWriteCreateFlags();
    let fd = yield ContentTask.spawn(browser, {lib, path, flags}, callOpen);
    ok(fd >= 0, "opening a file for writing in content temp is permitted");
  }

  // use fork syscall
  if (isLinux() || isMac())
  {
    let rv = yield ContentTask.spawn(browser, {lib}, callFork);
    ok(rv == -1, "calling fork is not permitted");
  }
});
