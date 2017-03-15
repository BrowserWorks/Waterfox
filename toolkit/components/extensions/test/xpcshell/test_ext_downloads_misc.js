/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

Cu.import("resource://gre/modules/Downloads.jsm");

const server = createHttpServer();
server.registerDirectory("/data/", do_get_file("data"));

const ROOT = `http://localhost:${server.identity.primaryPort}`;
const BASE = `${ROOT}/data`;
const TXT_FILE = "file_download.txt";
const TXT_URL = BASE + "/" + TXT_FILE;

// Keep these in sync with code in interruptible.sjs
const INT_PARTIAL_LEN = 15;
const INT_TOTAL_LEN = 31;

const TEST_DATA = "This is 31 bytes of sample data";
const TOTAL_LEN = TEST_DATA.length;
const PARTIAL_LEN = 15;

// A handler to let us systematically test pausing/resuming/canceling
// of downloads.  This target represents a small text file but a simple
// GET will stall after sending part of the data, to give the test code
// a chance to pause or do other operations on an in-progress download.
// A resumed download (ie, a GET with a Range: header) will allow the
// download to complete.
function handleRequest(request, response) {
  response.setHeader("Content-Type", "text/plain", false);

  if (request.hasHeader("Range")) {
    let start, end;
    let matches = request.getHeader("Range")
        .match(/^\s*bytes=(\d+)?-(\d+)?\s*$/);
    if (matches != null) {
      start = matches[1] ? parseInt(matches[1], 10) : 0;
      end = matches[2] ? parseInt(matches[2], 10) : (TOTAL_LEN - 1);
    }

    if (end == undefined || end >= TOTAL_LEN) {
      response.setStatusLine(request.httpVersion, 416, "Requested Range Not Satisfiable");
      response.setHeader("Content-Range", `*/${TOTAL_LEN}`, false);
      response.finish();
      return;
    }

    response.setStatusLine(request.httpVersion, 206, "Partial Content");
    response.setHeader("Content-Range", `${start}-${end}/${TOTAL_LEN}`, false);
    response.write(TEST_DATA.slice(start, end + 1));
  } else {
    response.processAsync();
    response.setHeader("Content-Length", `${TOTAL_LEN}`, false);
    response.write(TEST_DATA.slice(0, PARTIAL_LEN));
  }

  do_register_cleanup(() => {
    try {
      response.finish();
    } catch (e) {
      // This will throw, but we don't care at this point.
    }
  });
}

server.registerPathHandler("/interruptible.html", handleRequest);

let interruptibleCount = 0;
function getInterruptibleUrl() {
  let n = interruptibleCount++;
  return `${ROOT}/interruptible.html?count=${n}`;
}

function backgroundScript() {
  let events = new Set();
  let eventWaiter = null;

  browser.downloads.onCreated.addListener(data => {
    events.add({type: "onCreated", data});
    if (eventWaiter) {
      eventWaiter();
    }
  });

  browser.downloads.onChanged.addListener(data => {
    events.add({type: "onChanged", data});
    if (eventWaiter) {
      eventWaiter();
    }
  });

  browser.downloads.onErased.addListener(data => {
    events.add({type: "onErased", data});
    if (eventWaiter) {
      eventWaiter();
    }
  });

  // Returns a promise that will resolve when the given list of expected
  // events have all been seen.  By default, succeeds only if the exact list
  // of expected events is seen in the given order.  options.exact can be
  // set to false to allow other events and options.inorder can be set to
  // false to allow the events to arrive in any order.
  function waitForEvents(expected, options = {}) {
    function compare(a, b) {
      if (typeof b == "object" && b != null) {
        if (typeof a != "object") {
          return false;
        }
        return Object.keys(b).every(fld => compare(a[fld], b[fld]));
      }
      return (a == b);
    }

    const exact = ("exact" in options) ? options.exact : true;
    const inorder = ("inorder" in options) ? options.inorder : true;
    return new Promise((resolve, reject) => {
      function check() {
        function fail(msg) {
          browser.test.fail(msg);
          reject(new Error(msg));
        }
        if (events.size < expected.length) {
          return;
        }
        if (exact && expected.length < events.size) {
          fail(`Got ${events.size} events but only expected ${expected.length}`);
          return;
        }

        let remaining = new Set(events);
        if (inorder) {
          for (let event of events) {
            if (compare(event, expected[0])) {
              expected.shift();
              remaining.delete(event);
            }
          }
        } else {
          expected = expected.filter(val => {
            for (let remainingEvent of remaining) {
              if (compare(remainingEvent, val)) {
                remaining.delete(remainingEvent);
                return false;
              }
            }
            return true;
          });
        }

        // Events that did occur have been removed from expected so if
        // expected is empty, we're done.  If we didn't see all the
        // expected events and we're not looking for an exact match,
        // then we just may not have seen the event yet, so return without
        // failing and check() will be called again when a new event arrives.
        if (expected.length == 0) {
          events = remaining;
          eventWaiter = null;
          resolve();
        } else if (exact) {
          fail(`Mismatched event: expecting ${JSON.stringify(expected[0])} but got ${JSON.stringify(Array.from(remaining)[0])}`);
        }
      }
      eventWaiter = check;
      check();
    });
  }

  browser.test.onMessage.addListener(async (msg, ...args) => {
    let match = msg.match(/(\w+).request$/);
    if (!match) {
      return;
    }

    let what = match[1];
    if (what == "waitForEvents") {
      try {
        await waitForEvents(...args);
        browser.test.sendMessage("waitForEvents.done", {status: "success"});
      } catch (error) {
        browser.test.sendMessage("waitForEvents.done", {status: "error", errmsg: error.message});
      }
    } else if (what == "clearEvents") {
      events = new Set();
      browser.test.sendMessage("clearEvents.done", {status: "success"});
    } else {
      try {
        let result = await browser.downloads[what](...args);
        browser.test.sendMessage(`${what}.done`, {status: "success", result});
      } catch (error) {
        browser.test.sendMessage(`${what}.done`, {status: "error", errmsg: error.message});
      }
    }
  });

  browser.test.sendMessage("ready");
}

let downloadDir;
let extension;

async function clearDownloads(callback) {
  let list = await Downloads.getList(Downloads.ALL);
  let downloads = await list.getAll();

  await Promise.all(downloads.map(download => list.remove(download)));

  return downloads;
}

function runInExtension(what, ...args) {
  extension.sendMessage(`${what}.request`, ...args);
  return extension.awaitMessage(`${what}.done`);
}

// This is pretty simplistic, it looks for a progress update for a
// download of the given url in which the total bytes are exactly equal
// to the given value.  Unless you know exactly how data will arrive from
// the server (eg see interruptible.sjs), it probably isn't very useful.
async function waitForProgress(url, bytes) {
  let list = await Downloads.getList(Downloads.ALL);

  return new Promise(resolve => {
    const view = {
      onDownloadChanged(download) {
        if (download.source.url == url && download.currentBytes == bytes) {
          list.removeView(view);
          resolve();
        }
      },
    };
    list.addView(view);
  });
}

add_task(function* setup() {
  const nsIFile = Ci.nsIFile;
  downloadDir = FileUtils.getDir("TmpD", ["downloads"]);
  downloadDir.createUnique(nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
  do_print(`downloadDir ${downloadDir.path}`);

  Services.prefs.setIntPref("browser.download.folderList", 2);
  Services.prefs.setComplexValue("browser.download.dir", nsIFile, downloadDir);

  do_register_cleanup(() => {
    Services.prefs.clearUserPref("browser.download.folderList");
    Services.prefs.clearUserPref("browser.download.dir");
    downloadDir.remove(true);

    return clearDownloads();
  });

  yield clearDownloads().then(downloads => {
    do_print(`removed ${downloads.length} pre-existing downloads from history`);
  });

  extension = ExtensionTestUtils.loadExtension({
    background: backgroundScript,
    manifest: {
      permissions: ["downloads"],
    },
  });

  yield extension.startup();
  yield extension.awaitMessage("ready");
});

add_task(function* test_events() {
  let msg = yield runInExtension("download", {url: TXT_URL});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id, url: TXT_URL}},
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "complete",
        },
      },
    },
  ]);
  equal(msg.status, "success", "got onCreated and onChanged events");
});

add_task(function* test_cancel() {
  let url = getInterruptibleUrl();
  do_print(url);
  let msg = yield runInExtension("download", {url});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  let progressPromise = waitForProgress(url, INT_PARTIAL_LEN);

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id}},
  ]);
  equal(msg.status, "success", "got created and changed events");

  yield progressPromise;
  do_print(`download reached ${INT_PARTIAL_LEN} bytes`);

  msg = yield runInExtension("cancel", id);
  equal(msg.status, "success", "cancel() succeeded");

  // This sequence of events is bogus (bug 1256243)
  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        state: {
          previous: "in_progress",
          current: "interrupted",
        },
        paused: {
          previous: false,
          current: true,
        },
      },
    }, {
      type: "onChanged",
      data: {
        id,
        error: {
          previous: null,
          current: "USER_CANCELED",
        },
      },
    }, {
      type: "onChanged",
      data: {
        id,
        paused: {
          previous: true,
          current: false,
        },
      },
    },
  ]);
  equal(msg.status, "success", "got onChanged events corresponding to cancel()");

  msg = yield runInExtension("search", {error: "USER_CANCELED"});
  equal(msg.status, "success", "search() succeeded");
  equal(msg.result.length, 1, "search() found 1 download");
  equal(msg.result[0].id, id, "download.id is correct");
  equal(msg.result[0].state, "interrupted", "download.state is correct");
  equal(msg.result[0].paused, false, "download.paused is correct");
  equal(msg.result[0].canResume, false, "download.canResume is correct");
  equal(msg.result[0].error, "USER_CANCELED", "download.error is correct");
  equal(msg.result[0].totalBytes, INT_TOTAL_LEN, "download.totalBytes is correct");
  equal(msg.result[0].exists, false, "download.exists is correct");

  msg = yield runInExtension("pause", id);
  equal(msg.status, "error", "cannot pause a canceled download");

  msg = yield runInExtension("resume", id);
  equal(msg.status, "error", "cannot resume a canceled download");
});

add_task(function* test_pauseresume() {
  let url = getInterruptibleUrl();
  let msg = yield runInExtension("download", {url});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  let progressPromise = waitForProgress(url, INT_PARTIAL_LEN);

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id}},
  ]);
  equal(msg.status, "success", "got created and changed events");

  yield progressPromise;
  do_print(`download reached ${INT_PARTIAL_LEN} bytes`);

  msg = yield runInExtension("pause", id);
  equal(msg.status, "success", "pause() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "interrupted",
        },
        paused: {
          previous: false,
          current: true,
        },
        canResume: {
          previous: false,
          current: true,
        },
      },
    }, {
      type: "onChanged",
      data: {
        id,
        error: {
          previous: null,
          current: "USER_CANCELED",
        },
      },
    }]);
  equal(msg.status, "success", "got onChanged event corresponding to pause");

  msg = yield runInExtension("search", {paused: true});
  equal(msg.status, "success", "search() succeeded");
  equal(msg.result.length, 1, "search() found 1 download");
  equal(msg.result[0].id, id, "download.id is correct");
  equal(msg.result[0].state, "interrupted", "download.state is correct");
  equal(msg.result[0].paused, true, "download.paused is correct");
  equal(msg.result[0].canResume, true, "download.canResume is correct");
  equal(msg.result[0].error, "USER_CANCELED", "download.error is correct");
  equal(msg.result[0].bytesReceived, INT_PARTIAL_LEN, "download.bytesReceived is correct");
  equal(msg.result[0].totalBytes, INT_TOTAL_LEN, "download.totalBytes is correct");
  equal(msg.result[0].exists, false, "download.exists is correct");

  msg = yield runInExtension("search", {error: "USER_CANCELED"});
  equal(msg.status, "success", "search() succeeded");
  let found = msg.result.filter(item => item.id == id);
  equal(found.length, 1, "search() by error found the paused download");

  msg = yield runInExtension("pause", id);
  equal(msg.status, "error", "cannot pause an already paused download");

  msg = yield runInExtension("resume", id);
  equal(msg.status, "success", "resume() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "interrupted",
          current: "in_progress",
        },
        paused: {
          previous: true,
          current: false,
        },
        canResume: {
          previous: true,
          current: false,
        },
        error: {
          previous: "USER_CANCELED",
          current: null,
        },
      },
    },
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "complete",
        },
      },
    },
  ]);
  equal(msg.status, "success", "got onChanged events for resume and complete");

  msg = yield runInExtension("search", {id});
  equal(msg.status, "success", "search() succeeded");
  equal(msg.result.length, 1, "search() found 1 download");
  equal(msg.result[0].state, "complete", "download.state is correct");
  equal(msg.result[0].paused, false, "download.paused is correct");
  equal(msg.result[0].canResume, false, "download.canResume is correct");
  equal(msg.result[0].error, null, "download.error is correct");
  equal(msg.result[0].bytesReceived, INT_TOTAL_LEN, "download.bytesReceived is correct");
  equal(msg.result[0].totalBytes, INT_TOTAL_LEN, "download.totalBytes is correct");
  equal(msg.result[0].exists, true, "download.exists is correct");

  msg = yield runInExtension("pause", id);
  equal(msg.status, "error", "cannot pause a completed download");

  msg = yield runInExtension("resume", id);
  equal(msg.status, "error", "cannot resume a completed download");
});

add_task(function* test_pausecancel() {
  let url = getInterruptibleUrl();
  let msg = yield runInExtension("download", {url});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  let progressPromise = waitForProgress(url, INT_PARTIAL_LEN);

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id}},
  ]);
  equal(msg.status, "success", "got created and changed events");

  yield progressPromise;
  do_print(`download reached ${INT_PARTIAL_LEN} bytes`);

  msg = yield runInExtension("pause", id);
  equal(msg.status, "success", "pause() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "interrupted",
        },
        paused: {
          previous: false,
          current: true,
        },
        canResume: {
          previous: false,
          current: true,
        },
      },
    }, {
      type: "onChanged",
      data: {
        id,
        error: {
          previous: null,
          current: "USER_CANCELED",
        },
      },
    }]);
  equal(msg.status, "success", "got onChanged event corresponding to pause");

  msg = yield runInExtension("search", {paused: true});
  equal(msg.status, "success", "search() succeeded");
  equal(msg.result.length, 1, "search() found 1 download");
  equal(msg.result[0].id, id, "download.id is correct");
  equal(msg.result[0].state, "interrupted", "download.state is correct");
  equal(msg.result[0].paused, true, "download.paused is correct");
  equal(msg.result[0].canResume, true, "download.canResume is correct");
  equal(msg.result[0].error, "USER_CANCELED", "download.error is correct");
  equal(msg.result[0].bytesReceived, INT_PARTIAL_LEN, "download.bytesReceived is correct");
  equal(msg.result[0].totalBytes, INT_TOTAL_LEN, "download.totalBytes is correct");
  equal(msg.result[0].exists, false, "download.exists is correct");

  msg = yield runInExtension("search", {error: "USER_CANCELED"});
  equal(msg.status, "success", "search() succeeded");
  let found = msg.result.filter(item => item.id == id);
  equal(found.length, 1, "search() by error found the paused download");

  msg = yield runInExtension("cancel", id);
  equal(msg.status, "success", "cancel() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        paused: {
          previous: true,
          current: false,
        },
        canResume: {
          previous: true,
          current: false,
        },
      },
    },
  ]);
  equal(msg.status, "success", "got onChanged event for cancel");

  msg = yield runInExtension("search", {id});
  equal(msg.status, "success", "search() succeeded");
  equal(msg.result.length, 1, "search() found 1 download");
  equal(msg.result[0].state, "interrupted", "download.state is correct");
  equal(msg.result[0].paused, false, "download.paused is correct");
  equal(msg.result[0].canResume, false, "download.canResume is correct");
  equal(msg.result[0].error, "USER_CANCELED", "download.error is correct");
  equal(msg.result[0].totalBytes, INT_TOTAL_LEN, "download.totalBytes is correct");
  equal(msg.result[0].exists, false, "download.exists is correct");
});

add_task(function* test_pause_resume_cancel_badargs() {
  let BAD_ID = 1000;

  let msg = yield runInExtension("pause", BAD_ID);
  equal(msg.status, "error", "pause() failed with a bad download id");
  ok(/Invalid download id/.test(msg.errmsg), "error message is descriptive");

  msg = yield runInExtension("resume", BAD_ID);
  equal(msg.status, "error", "resume() failed with a bad download id");
  ok(/Invalid download id/.test(msg.errmsg), "error message is descriptive");

  msg = yield runInExtension("cancel", BAD_ID);
  equal(msg.status, "error", "cancel() failed with a bad download id");
  ok(/Invalid download id/.test(msg.errmsg), "error message is descriptive");
});

add_task(function* test_file_removal() {
  let msg = yield runInExtension("download", {url: TXT_URL});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id, url: TXT_URL}},
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "complete",
        },
      },
    },
  ]);

  equal(msg.status, "success", "got onCreated and onChanged events");

  msg = yield runInExtension("removeFile", id);
  equal(msg.status, "success", "removeFile() succeeded");

  msg = yield runInExtension("removeFile", id);
  equal(msg.status, "error", "removeFile() fails since the file was already removed.");
  ok(/file doesn't exist/.test(msg.errmsg), "removeFile() failed on removed file.");

  msg = yield runInExtension("removeFile", 1000);
  ok(/Invalid download id/.test(msg.errmsg), "removeFile() failed due to non-existent id");
});

add_task(function* test_removal_of_incomplete_download() {
  let url = getInterruptibleUrl();
  let msg = yield runInExtension("download", {url});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  let progressPromise = waitForProgress(url, INT_PARTIAL_LEN);

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id}},
  ]);
  equal(msg.status, "success", "got created and changed events");

  yield progressPromise;
  do_print(`download reached ${INT_PARTIAL_LEN} bytes`);

  msg = yield runInExtension("pause", id);
  equal(msg.status, "success", "pause() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "interrupted",
        },
        paused: {
          previous: false,
          current: true,
        },
        canResume: {
          previous: false,
          current: true,
        },
      },
    }, {
      type: "onChanged",
      data: {
        id,
        error: {
          previous: null,
          current: "USER_CANCELED",
        },
      },
    }]);
  equal(msg.status, "success", "got onChanged event corresponding to pause");

  msg = yield runInExtension("removeFile", id);
  equal(msg.status, "error", "removeFile() on paused download failed");

  ok(/Cannot remove incomplete download/.test(msg.errmsg), "removeFile() failed due to download being incomplete");

  msg = yield runInExtension("resume", id);
  equal(msg.status, "success", "resume() succeeded");

  msg = yield runInExtension("waitForEvents", [
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "interrupted",
          current: "in_progress",
        },
        paused: {
          previous: true,
          current: false,
        },
        canResume: {
          previous: true,
          current: false,
        },
        error: {
          previous: "USER_CANCELED",
          current: null,
        },
      },
    },
    {
      type: "onChanged",
      data: {
        id,
        state: {
          previous: "in_progress",
          current: "complete",
        },
      },
    },
  ]);
  equal(msg.status, "success", "got onChanged events for resume and complete");

  msg = yield runInExtension("removeFile", id);
  equal(msg.status, "success", "removeFile() succeeded following completion of resumed download.");
});

// Test erase().  We don't do elaborate testing of the query handling
// since it uses the exact same engine as search() which is tested
// more thoroughly in test_chrome_ext_downloads_search.html
add_task(function* test_erase() {
  yield clearDownloads();

  yield runInExtension("clearEvents");

  function* download() {
    let msg = yield runInExtension("download", {url: TXT_URL});
    equal(msg.status, "success", "download succeeded");
    let id = msg.result;

    msg = yield runInExtension("waitForEvents", [{
      type: "onChanged", data: {id, state: {current: "complete"}},
    }], {exact: false});
    equal(msg.status, "success", "download finished");

    return id;
  }

  let ids = {};
  ids.dl1 = yield download();
  ids.dl2 = yield download();
  ids.dl3 = yield download();

  let msg = yield runInExtension("search", {});
  equal(msg.status, "success", "search succeded");
  equal(msg.result.length, 3, "search found 3 downloads");

  msg = yield runInExtension("clearEvents");

  msg = yield runInExtension("erase", {id: ids.dl1});
  equal(msg.status, "success", "erase by id succeeded");

  msg = yield runInExtension("waitForEvents", [
    {type: "onErased", data: ids.dl1},
  ]);
  equal(msg.status, "success", "received onErased event");

  msg = yield runInExtension("search", {});
  equal(msg.status, "success", "search succeded");
  equal(msg.result.length, 2, "search found 2 downloads");

  msg = yield runInExtension("erase", {});
  equal(msg.status, "success", "erase everything succeeded");

  msg = yield runInExtension("waitForEvents", [
    {type: "onErased", data: ids.dl2},
    {type: "onErased", data: ids.dl3},
  ], {inorder: false});
  equal(msg.status, "success", "received 2 onErased events");

  msg = yield runInExtension("search", {});
  equal(msg.status, "success", "search succeded");
  equal(msg.result.length, 0, "search found 0 downloads");
});

function loadImage(img, data) {
  return new Promise((resolve) => {
    img.src = data;
    img.onload = resolve;
  });
}

add_task(function* test_getFileIcon() {
  let webNav = Services.appShell.createWindowlessBrowser(false);
  let docShell = webNav.QueryInterface(Ci.nsIInterfaceRequestor)
                       .getInterface(Ci.nsIDocShell);

  let system = Services.scriptSecurityManager.getSystemPrincipal();
  docShell.createAboutBlankContentViewer(system);

  let img = webNav.document.createElement("img");

  let msg = yield runInExtension("download", {url: TXT_URL});
  equal(msg.status, "success", "download() succeeded");
  const id = msg.result;

  msg = yield runInExtension("getFileIcon", id);
  equal(msg.status, "success", "getFileIcon() succeeded");
  yield loadImage(img, msg.result);
  equal(img.height, 32, "returns an icon with the right height");
  equal(img.width, 32, "returns an icon with the right width");

  msg = yield runInExtension("waitForEvents", [
    {type: "onCreated", data: {id, url: TXT_URL}},
    {type: "onChanged"},
  ]);
  equal(msg.status, "success", "got events");

  msg = yield runInExtension("getFileIcon", id);
  equal(msg.status, "success", "getFileIcon() succeeded");
  yield loadImage(img, msg.result);
  equal(img.height, 32, "returns an icon with the right height after download");
  equal(img.width, 32, "returns an icon with the right width after download");

  msg = yield runInExtension("getFileIcon", id + 100);
  equal(msg.status, "error", "getFileIcon() failed");
  ok(msg.errmsg.includes("Invalid download id"), "download id is invalid");

  msg = yield runInExtension("getFileIcon", id, {size: 127});
  equal(msg.status, "success", "getFileIcon() succeeded");
  yield loadImage(img, msg.result);
  equal(img.height, 127, "returns an icon with the right custom height");
  equal(img.width, 127, "returns an icon with the right custom width");

  msg = yield runInExtension("getFileIcon", id, {size: 1});
  equal(msg.status, "success", "getFileIcon() succeeded");
  yield loadImage(img, msg.result);
  equal(img.height, 1, "returns an icon with the right custom height");
  equal(img.width, 1, "returns an icon with the right custom width");

  msg = yield runInExtension("getFileIcon", id, {size: "foo"});
  equal(msg.status, "error", "getFileIcon() fails");
  ok(msg.errmsg.includes("Error processing size"), "size is not a number");

  msg = yield runInExtension("getFileIcon", id, {size: 0});
  equal(msg.status, "error", "getFileIcon() fails");
  ok(msg.errmsg.includes("Error processing size"), "size is too small");

  msg = yield runInExtension("getFileIcon", id, {size: 128});
  equal(msg.status, "error", "getFileIcon() fails");
  ok(msg.errmsg.includes("Error processing size"), "size is too big");

  webNav.close();
});

add_task(function* cleanup() {
  yield extension.unload();
});
