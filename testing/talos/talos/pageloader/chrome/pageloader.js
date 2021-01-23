/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from report.js */
/* eslint mozilla/avoid-Date-timing: "off" */

var { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);
var { E10SUtils } = ChromeUtils.import("resource://gre/modules/E10SUtils.jsm");
ChromeUtils.defineModuleGetter(
  this,
  "TalosParentProfiler",
  "resource://talos-powers/TalosParentProfiler.jsm"
);

var NUM_CYCLES = 5;
var numPageCycles = 1;

var numRetries = 0;
var maxRetries = 3;

var pageFilterRegexp = null;
var winWidth = 1024;
var winHeight = 768;

var pages;
var pageIndex;
var start_time;
var cycle;
var pageCycle;
var report;
var timeout = -1;
var delay = 250;
var running = false;
var forceCC = true;

var useMozAfterPaint = false;
var useFNBPaint = false;
var isFNBPaintPending = false;
var usePDFPaint = false;
var isPDFPaintPending = false;
var useHero = false;
var gPaintWindow = window;
var gPaintListener = false;
var loadNoCache = false;
var scrollTest = false;
var profilingInfo = false;
var baseVsRef = false;
var useBrowserChrome = false;
var useA11y = false;

var isIdleCallbackPending = false;

// when TEST_DOES_OWN_TIMING, we need to store the time from the page as MozAfterPaint can be slower than pageload
var gTime = -1;
var gStartTime = -1;
var gReference = -1;

var content;

// These are binary flags. Use 1/2/4/8/...
var TEST_DOES_OWN_TIMING = 1;
var EXECUTE_SCROLL_TEST = 2;

var browserWindow = null;

var recordedName = null;
var pageUrls;

/**
 * SingleTimeout class. Allow to register one and only one callback using
 * setTimeout at a time.
 */
var SingleTimeout = function() {
  this.timeoutEvent = undefined;
};

/**
 * Register a callback with the given timeout.
 *
 * If timeout is < 0, this is a no-op.
 *
 * If a callback was previously registered and has not been called yet, it is
 * first cleared with clear().
 */
SingleTimeout.prototype.register = function(callback, timeout) {
  if (timeout >= 0) {
    if (this.timeoutEvent !== undefined) {
      this.clear();
    }
    var that = this;
    this.timeoutEvent = setTimeout(function() {
      that.timeoutEvent = undefined;
      callback();
    }, timeout);
  }
};

/**
 * Clear a registered callback.
 */
SingleTimeout.prototype.clear = function() {
  if (this.timeoutEvent !== undefined) {
    clearTimeout(this.timeoutEvent);
    this.timeoutEvent = undefined;
  }
};

var failTimeout = new SingleTimeout();

function plInit() {
  if (running) {
    return;
  }
  running = true;

  cycle = 0;
  pageCycle = 1;

  try {
    /*
     * Desktop firefox:
     * non-chrome talos runs - tp-cmdline will create and load pageloader
     * into the main window of the app which displays and tests content.
     * chrome talos runs - tp-cmdline does the same however pageloader
     * creates a new chromed browser window below for content.
     */

    var manifestURI = Services.prefs.getCharPref("talos.tpmanifest", null);
    if (manifestURI.length == null) {
      dumpLine("tp abort: talos.tpmanifest browser pref is not set");
      plStop(true);
    }

    NUM_CYCLES = Services.prefs.getIntPref("talos.tpcycles", 1);
    numPageCycles = Services.prefs.getIntPref("talos.tppagecycles", 1);
    timeout = Services.prefs.getIntPref("talos.tptimeout", -1);
    useMozAfterPaint = Services.prefs.getBoolPref(
      "talos.tpmozafterpaint",
      false
    );
    useHero = Services.prefs.getBoolPref("talos.tphero", false);
    useFNBPaint = Services.prefs.getBoolPref("talos.fnbpaint", false);
    usePDFPaint = Services.prefs.getBoolPref("talos.pdfpaint", false);
    loadNoCache = Services.prefs.getBoolPref("talos.tploadnocache", false);
    scrollTest = Services.prefs.getBoolPref("talos.tpscrolltest", false);
    useBrowserChrome = Services.prefs.getBoolPref("talos.tpchrome", false);
    useA11y = Services.prefs.getBoolPref("talos.a11y", false);

    // for pageloader tests the profiling info is found in an env variable
    // because it is not available early enough to set it as a browser pref
    var env = Cc["@mozilla.org/process/environment;1"].getService(
      Ci.nsIEnvironment
    );

    if (env.exists("TPPROFILINGINFO")) {
      profilingInfo = env.get("TPPROFILINGINFO");
      if (profilingInfo !== null) {
        TalosParentProfiler.initFromObject(JSON.parse(profilingInfo));
      }
    }

    if (forceCC && !window.windowUtils.garbageCollect) {
      forceCC = false;
    }

    var fileURI = Services.io.newURI(manifestURI);
    pages = plLoadURLsFromURI(fileURI);

    if (!pages) {
      dumpLine("tp: could not load URLs, quitting");
      plStop(true);
    }

    if (pages.length == 0) {
      dumpLine("tp: no pages to test, quitting");
      plStop(true);
    }

    pageUrls = pages.map(function(p) {
      return p.url.spec.toString();
    });
    report = new Report();

    pageIndex = 0;
    if (profilingInfo) {
      TalosParentProfiler.beginTest(getCurrentPageShortName());
    }

    // Create a new chromed browser window for content
    var blank = Cc["@mozilla.org/supports-string;1"].createInstance(
      Ci.nsISupportsString
    );
    blank.data = "about:blank";

    let toolbars = "all";
    if (!useBrowserChrome) {
      toolbars = "titlebar,resizable";
    }

    browserWindow = Services.ww.openWindow(
      null,
      AppConstants.BROWSER_CHROME_URL,
      "_blank",
      `chrome,${toolbars},dialog=no,width=${winWidth},height=${winHeight}`,
      blank
    );

    gPaintWindow = browserWindow;
    // get our window out of the way
    window.resizeTo(10, 10);

    var browserLoadFunc = function(ev) {
      browserWindow.removeEventListener("load", browserLoadFunc, true);

      // do this half a second after load, because we need to be
      // able to resize the window and not have it get clobbered
      // by the persisted values
      setTimeout(function() {
        // Since bug 1261842, the initial browser is remote unless it attempts
        // to browse to a URI that should be non-remote (landed at bug 1047603).
        //
        // However, when it loads a URI that requires a different remote type,
        // we lose the load listener and the injected tpRecordTime.remote,
        //
        // It also probably means that per test (or, in fact, per pageloader browser
        // instance which adds the load listener and injects tpRecordTime), all the
        // pages should be able to load in the same mode as the initial page - due
        // to this reinitialization on the switch.
        let remoteType = E10SUtils.getRemoteTypeForURI(
          pageUrls[0],
          /* remote */ true,
          /* fission */ Services.prefs.getBoolPref("fission.autostart")
        );
        let tabbrowser = browserWindow.gBrowser;
        if (remoteType) {
          tabbrowser.updateBrowserRemoteness(tabbrowser.selectedBrowser, {
            remoteType,
          });
        } else {
          tabbrowser.updateBrowserRemoteness(tabbrowser.selectedBrowser, {
            remoteType: E10SUtils.NOT_REMOTE,
          });
        }

        browserWindow.resizeTo(winWidth, winHeight);
        browserWindow.moveTo(0, 0);
        browserWindow.focus();
        content = browserWindow.gBrowser;
        content.selectedBrowser.messageManager.loadFrameScript(
          "chrome://pageloader/content/utils.js",
          false,
          true
        );

        // pick the right load handler
        if (useFNBPaint) {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/lh_fnbpaint.js",
            false,
            true
          );
        } else if (useMozAfterPaint) {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/lh_moz.js",
            false,
            true
          );
        } else if (useHero) {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/lh_hero.js",
            false,
            true
          );
        } else if (usePDFPaint) {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/lh_pdfpaint.js",
            false,
            true
          );
        } else {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/lh_dummy.js",
            false,
            true
          );
        }
        content.selectedBrowser.messageManager.loadFrameScript(
          "chrome://pageloader/content/talos-content.js",
          false
        );
        content.selectedBrowser.messageManager.loadFrameScript(
          "resource://talos-powers/TalosContentProfiler.js",
          false,
          true
        );
        content.selectedBrowser.messageManager.loadFrameScript(
          "chrome://pageloader/content/tscroll.js",
          false,
          true
        );
        content.selectedBrowser.messageManager.loadFrameScript(
          "chrome://pageloader/content/Profiler.js",
          false,
          true
        );
        if (useA11y) {
          content.selectedBrowser.messageManager.loadFrameScript(
            "chrome://pageloader/content/a11y.js",
            false,
            true
          );
        }

        // Ensure that any webextensions that need to do setup have a chance
        // to do so. e.g. the 'tabswitch' talos test registers a about:tabswitch
        // handler during initialization, and if we don't wait for that, then
        // attempting to load that URL will result in an error and hang the
        // test.
        setTimeout(plLoadPage, 2000);
      }, 500);
    };

    browserWindow.addEventListener("load", browserLoadFunc, true);
  } catch (e) {
    dumpLine("pageloader exception: " + e);
    plStop(true);
  }
}

function plPageFlags() {
  return pages[pageIndex].flags;
}

var ContentListener = {
  receiveMessage(message) {
    switch (message.name) {
      case "PageLoader:LoadEvent":
        return plLoadHandlerMessage(message);
      case "PageLoader:Error":
        return plErrorMessage(message);
      case "PageLoader:RecordTime":
        return plRecordTimeMessage(message);
      case "PageLoader:IdleCallbackSet":
        return plIdleCallbackSet();
      case "PageLoader:IdleCallbackReceived":
        return plIdleCallbackReceived();
    }
    return undefined;
  },
};

// load the current page, start timing
var removeLastAddedMsgListener = null;
function plLoadPage() {
  if (profilingInfo) {
    TalosParentProfiler.beginTest(
      getCurrentPageShortName() + "_pagecycle_" + pageCycle
    );
  }

  var pageName = pages[pageIndex].url.spec;

  if (removeLastAddedMsgListener) {
    removeLastAddedMsgListener();
    removeLastAddedMsgListener = null;
  }

  // messages to watch for page load
  let mm = content.selectedBrowser.messageManager;
  mm.addMessageListener("PageLoader:LoadEvent", ContentListener);
  mm.addMessageListener("PageLoader:RecordTime", ContentListener);
  mm.addMessageListener("PageLoader:IdleCallbackSet", ContentListener);
  mm.addMessageListener("PageLoader:IdleCallbackReceived", ContentListener);
  mm.addMessageListener("PageLoader:Error", ContentListener);

  removeLastAddedMsgListener = function() {
    mm.removeMessageListener("PageLoader:LoadEvent", ContentListener);
    mm.removeMessageListener("PageLoader:RecordTime", ContentListener);
    mm.removeMessageListener("PageLoader:IdleCallbackSet", ContentListener);
    mm.removeMessageListener(
      "PageLoader:IdleCallbackReceived",
      ContentListener
    );
    mm.removeMessageListener("PageLoader:Error", ContentListener);
  };
  failTimeout.register(loadFail, timeout);
  // record which page we are about to open
  TalosParentProfiler.mark("Opening " + pages[pageIndex].url.pathQueryRef);

  if (useFNBPaint) {
    isFNBPaintPending = true;
  }

  if (usePDFPaint) {
    isPDFPaintPending = true;
  }

  startAndLoadURI(pageName);
}

function startAndLoadURI(pageName) {
  if (!(plPageFlags() & TEST_DOES_OWN_TIMING)) {
    // Resume the profiler because we're really measuring page load time.
    // If the test is doing its own timing, it'll also need to do its own
    // profiler pausing / resuming.
    TalosParentProfiler.resume("Starting to load URI " + pageName);
  }

  start_time = Date.now();
  if (loadNoCache) {
    content.loadURI(pageName, {
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
      flags: Ci.nsIWebNavigation.LOAD_FLAGS_BYPASS_CACHE,
    });
  } else {
    content.loadURI(pageName, {
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
    });
  }
}

function getTestName() {
  // returns tp5n
  var pageName = pages[pageIndex].url.spec;
  let parts = pageName.split("/");
  if (parts.length > 4) {
    return parts[4];
  }
  return "pageloader";
}

function getCurrentPageShortName() {
  // this is also used by gecko profiling for the profile
  // file name; so ensure it is valid on Windows/Linux/OSX
  var pageName = pages[pageIndex].url.spec;
  let parts = pageName.split("/");
  if (parts.length > 5) {
    if (parts[5].indexOf("?" != -1)) {
      // page name is something like 'tpaint.html?auto=1'
      return parts[5].split("?")[0];
    }
    return parts[5];
  }
  return "page_" + pageIndex;
}

function loadFail() {
  var pageName = pages[pageIndex].url.spec;
  numRetries++;

  if (numRetries >= maxRetries) {
    dumpLine("__FAILTimeout in " + getTestName() + "__FAIL");
    dumpLine(
      "__FAILTimeout (" +
        numRetries +
        "/" +
        maxRetries +
        ") exceeded on " +
        pageName +
        "__FAIL"
    );
    TalosParentProfiler.finishTest().then(() => {
      plStop(true);
    });
  } else {
    dumpLine(
      "__WARNTimeout (" +
        numRetries +
        "/" +
        maxRetries +
        ") exceeded on " +
        pageName +
        "__WARN"
    );
    // TODO: make this a cleaner cleanup
    pageCycle--;
    content.removeEventListener("load", plLoadHandler, true);
    content.removeEventListener("load", plLoadHandlerCapturing, true);
    content.removeEventListener("MozAfterPaint", plPaintedCapturing, true);
    content.removeEventListener("MozAfterPaint", plPainted, true);
    gPaintWindow.removeEventListener("MozAfterPaint", plPaintedCapturing, true);
    gPaintWindow.removeEventListener("MozAfterPaint", plPainted, true);
    removeLastAddedMsgListener = null;
    gPaintListener = false;

    // TODO: consider adding a tab and removing the old tab?!?
    setTimeout(plLoadPage, delay);
  }
}

var plNextPage = async function() {
  var doNextPage = false;

  // ensure we've receive idle-callback before proceeding
  if (isIdleCallbackPending) {
    dumpLine("Waiting for idle-callback");
    await waitForIdleCallback();
  }

  if (useFNBPaint) {
    // don't move to next page until we've received fnbpaint
    if (isFNBPaintPending) {
      dumpLine("Waiting for fnbpaint");
      await waitForFNBPaint();
    }
  }

  if (usePDFPaint) {
    // don't move to next page until we've received pdfpaint
    if (isPDFPaintPending) {
      dumpLine("Waiting for pdfpaint");
      await waitForPDFPaint();
    }
  }

  if (profilingInfo) {
    await TalosParentProfiler.finishTest();
  }

  if (pageCycle < numPageCycles) {
    pageCycle++;
    doNextPage = true;
  } else if (pageIndex < pages.length - 1) {
    pageIndex++;
    recordedName = null;
    pageCycle = 1;
    doNextPage = true;
  }

  if (doNextPage) {
    if (forceCC) {
      var tccstart = new Date();
      window.windowUtils.garbageCollect();
      var tccend = new Date();
      report.recordCCTime(tccend - tccstart);

      // Now asynchronously trigger GC / CC in the content process
      await forceContentGC();
    }

    setTimeout(plLoadPage, delay);
  } else {
    plStop(false);
  }
};

function waitForIdleCallback() {
  return new Promise(resolve => {
    function checkForIdleCallback() {
      if (!isIdleCallbackPending) {
        resolve();
      } else {
        setTimeout(checkForIdleCallback, 5);
      }
    }
    checkForIdleCallback();
  });
}

function plIdleCallbackSet() {
  if (!scrollTest) {
    isIdleCallbackPending = true;
  }
}

function plIdleCallbackReceived() {
  isIdleCallbackPending = false;
}

function waitForFNBPaint() {
  return new Promise(resolve => {
    function checkForFNBPaint() {
      if (!isFNBPaintPending) {
        resolve();
      } else {
        setTimeout(checkForFNBPaint, 200);
      }
    }
    checkForFNBPaint();
  });
}

function waitForPDFPaint() {
  return new Promise(resolve => {
    function checkForPDFPaint() {
      if (!isPDFPaintPending) {
        resolve();
      } else {
        setTimeout(checkForPDFPaint, 200);
      }
    }
    checkForPDFPaint();
  });
}

function forceContentGC() {
  return new Promise(resolve => {
    let mm = browserWindow.gBrowser.selectedBrowser.messageManager;
    mm.addMessageListener("Talos:ForceGC:OK", function onTalosContentForceGC(
      msg
    ) {
      mm.removeMessageListener("Talos:ForceGC:OK", onTalosContentForceGC);
      resolve();
    });
    mm.sendAsyncMessage("Talos:ForceGC");
  });
}

function plRecordTime(time) {
  var pageName = pages[pageIndex].url.spec;
  var i = pageIndex;
  if (i < pages.length - 1) {
    i++;
  } else {
    i = 0;
  }
  var nextName = pages[i].url.spec;
  if (!recordedName) {
    // when doing base vs ref type of test, add pre 'base' or 'ref' to reported page name;
    // this is necessary so that if multiple subtests use same reference page, results for
    // each ref page run will be kept separate for each base vs ref run, and not grouped
    // into just one set of results values for everytime that reference page was loaded
    if (baseVsRef) {
      recordedName = pages[pageIndex].pre + pageUrls[pageIndex];
    } else {
      recordedName = pageUrls[pageIndex];
    }
  }
  if (typeof time == "string") {
    var times = time.split(",");
    var names = recordedName.split(",");
    for (var t = 0; t < times.length; t++) {
      if (names.length == 1) {
        report.recordTime(names, times[t]);
      } else {
        report.recordTime(names[t], times[t]);
      }
    }
  } else {
    report.recordTime(recordedName, time);
  }
  dumpLine(
    "Cycle " +
      (cycle + 1) +
      "(" +
      pageCycle +
      "): loaded " +
      pageName +
      " (next: " +
      nextName +
      ")"
  );
}

function plLoadHandlerCapturing(evt) {
  // make sure we pick up the right load event
  if (evt.type != "load" || evt.originalTarget.defaultView.frameElement) {
    return;
  }

  // set the tpRecordTime function (called from test pages we load) to store a global time.
  content.contentWindow.wrappedJSObject.tpRecordTime = function(
    time,
    startTime,
    testName
  ) {
    gTime = time;
    gStartTime = startTime;
    recordedName = testName;
    setTimeout(plWaitForPaintingCapturing, 0);
  };

  content.contentWindow.wrappedJSObject.plGarbageCollect = function() {
    window.windowUtils.garbageCollect();
  };

  content.removeEventListener("load", plLoadHandlerCapturing, true);

  setTimeout(plWaitForPaintingCapturing, 0);
}

// Shim function this is really defined in tscroll.js
function sendScroll() {
  const SCROLL_TEST_STEP_PX = 10;
  const SCROLL_TEST_NUM_STEPS = 100;
  // The page doesn't really use tpRecordTime. Instead, we trigger the scroll test,
  // and the scroll test will call tpRecordTime which will take us to the next page
  let details = {
    target: "content",
    stepSize: SCROLL_TEST_STEP_PX,
    opt_numSteps: SCROLL_TEST_NUM_STEPS,
  };
  let mm = content.selectedBrowser.messageManager;
  mm.sendAsyncMessage("PageLoader:ScrollTest", { details });
}

function plWaitForPaintingCapturing() {
  if (gPaintListener) {
    return;
  }

  var utils = gPaintWindow.windowUtils;

  if (utils.isMozAfterPaintPending && useMozAfterPaint) {
    if (!gPaintListener) {
      gPaintWindow.addEventListener("MozAfterPaint", plPaintedCapturing, true);
    }
    gPaintListener = true;
    return;
  }

  _loadHandlerCapturing();
}

function plPaintedCapturing() {
  gPaintWindow.removeEventListener("MozAfterPaint", plPaintedCapturing, true);
  gPaintListener = false;
  _loadHandlerCapturing();
}

function _loadHandlerCapturing() {
  failTimeout.clear();

  if (!(plPageFlags() & TEST_DOES_OWN_TIMING)) {
    dumpLine(
      "tp: Capturing onload handler used with page that doesn't do its own timing?"
    );
    plStop(true);
  }

  if (useMozAfterPaint) {
    if (gStartTime != null && gStartTime >= 0) {
      gTime = new Date() - gStartTime;
      gStartTime = -1;
    }
  }

  if (gTime !== -1) {
    plRecordTime(gTime);
    TalosParentProfiler.pause("capturing load handler fired");
    gTime = -1;
    recordedName = null;
    setTimeout(plNextPage, delay);
  }
}

// the onload handler
function plLoadHandler(evt) {
  // make sure we pick up the right load event
  if (evt.type != "load" || evt.originalTarget.defaultView.frameElement) {
    return;
  }

  content.removeEventListener("load", plLoadHandler, true);
  setTimeout(waitForPainted, 0);
}

// This is called after we have received a load event, now we wait for painted
function waitForPainted() {
  var utils = gPaintWindow.windowUtils;

  if (!utils.isMozAfterPaintPending || !useMozAfterPaint) {
    _loadHandler();
    return;
  }

  if (!gPaintListener) {
    gPaintWindow.addEventListener("MozAfterPaint", plPainted, true);
  }
  gPaintListener = true;
}

function plPainted() {
  gPaintWindow.removeEventListener("MozAfterPaint", plPainted, true);
  gPaintListener = false;
  _loadHandler();
}

function _loadHandler(paint_time = 0) {
  failTimeout.clear();
  var end_time = 0;

  if (paint_time !== 0) {
    // window.performance.timing.timeToNonBlankPaint is a timestamp
    // this may have a value for hero element (also a timestamp)
    end_time = paint_time;
  } else {
    end_time = Date.now();
  }

  var duration;
  if (usePDFPaint) {
    // PDF paint uses performance.now(), so the time does not need to be
    // adjusted from the start time.
    duration = end_time;
  } else {
    duration = end_time - start_time;
  }
  TalosParentProfiler.pause("Bubbling load handler fired.");

  // does this page want to do its own timing?
  // if so, we shouldn't be here
  if (plPageFlags() & TEST_DOES_OWN_TIMING) {
    dumpLine(
      "tp: Bubbling onload handler used with page that does its own timing?"
    );
    plStop(true);
  }

  plRecordTime(duration);
  plNextPage();
}

// the core handler
function plLoadHandlerMessage(message) {
  let paint_time = 0;
  // XXX message.json.name contains the name
  // of the load handler, so in future versions
  // we can record several times per load.
  if (message.json.time !== undefined) {
    paint_time = message.json.time;
    if (message.json.name == "fnbpaint") {
      // we've received fnbpaint; no longer pending for this current pageload
      isFNBPaintPending = false;
    } else if (message.json.name == "pdfpaint") {
      isPDFPaintPending = false;
    }
  }

  failTimeout.clear();

  if (plPageFlags() & EXECUTE_SCROLL_TEST) {
    // Let the page settle down after its load event, then execute the scroll test.
    setTimeout(sendScroll, 500);
  } else if (plPageFlags() & TEST_DOES_OWN_TIMING) {
    var time;

    if (typeof gStartTime != "number") {
      gStartTime = Date.parse(gStartTime);
    }
    if (gTime !== -1) {
      if (useMozAfterPaint && gStartTime >= 0) {
        time = Date.now() - gStartTime;
        gStartTime = -1;
      } else if (!useMozAfterPaint) {
        time = gTime;
      }
      gTime = -1;
    }

    if (time !== undefined) {
      plRecordTime(time);
      plNextPage();
    }
  } else {
    _loadHandler(paint_time);
  }
}

// the record time handler
function plRecordTimeMessage(message) {
  gTime = message.json.time;
  gStartTime = message.json.startTime;
  recordedName = message.json.testName;

  if (useMozAfterPaint) {
    gStartTime = message.json.startTime;
  }
  _loadHandlerCapturing();
}

// error
function plErrorMessage(message) {
  if (message.json.msg) {
    dumpLine(message.json.msg);
  }
  plStop(true);
}

function plStop(force) {
  plStopAll(force);
}

function plStopAll(force) {
  try {
    if (!force) {
      pageIndex = 0;
      pageCycle = 1;
      if (cycle < NUM_CYCLES - 1) {
        cycle++;
        recordedName = null;
        setTimeout(plLoadPage, delay);
        return;
      }

      /* output report */
      dumpLine(report.getReport());
      dumpLine(report.getReportSummary());
    }
  } catch (e) {
    dumpLine(e);
  }

  if (content) {
    content.removeEventListener("load", plLoadHandlerCapturing, true);
    content.removeEventListener("load", plLoadHandler, true);

    if (useMozAfterPaint) {
      content.removeEventListener("MozAfterPaint", plPaintedCapturing, true);
      content.removeEventListener("MozAfterPaint", plPainted, true);
    }

    let mm = content.selectedBrowser.messageManager;
    mm.removeMessageListener("PageLoader:LoadEvent", ContentListener);
    mm.removeMessageListener("PageLoader:RecordTime", ContentListener);
    mm.removeMessageListener("PageLoader:Error", ContentListener);

    if (isIdleCallbackPending) {
      mm.removeMessageListener("PageLoader:IdleCallbackSet", ContentListener);
      mm.removeMessageListener(
        "PageLoader:IdleCallbackReceived",
        ContentListener
      );
    }
    mm.loadFrameScript(
      "data:,removeEventListener('load', _contentLoadHandler, true);",
      false,
      true
    );
  }

  if (MozillaFileLogger && MozillaFileLogger._foStream) {
    MozillaFileLogger.close();
  }

  goQuitApplication();
}

/* Returns array */
function plLoadURLsFromURI(manifestUri) {
  var fstream = Cc["@mozilla.org/network/file-input-stream;1"].createInstance(
    Ci.nsIFileInputStream
  );

  var uriFile = manifestUri.QueryInterface(Ci.nsIFileURL);

  if (uriFile.file.isFile() === false) {
    dumpLine("tp: invalid file: %s" % uriFile.file);
    return null;
  }

  try {
    fstream.init(uriFile.file, -1, 0, 0);
  } catch (ex) {
    dumpLine("tp: the file %s doesn't exist" % uriFile.file);
    return null;
  }

  var lstream = fstream.QueryInterface(Ci.nsILineInputStream);

  var url_array = [];

  var lineNo = 0;
  var line = { value: null };
  var baseVsRefIndex = 0;
  var more;
  do {
    lineNo++;
    more = lstream.readLine(line);
    var s = line.value;

    // strip comments (only leading ones)
    s = s.replace(/^#.*/, "");

    // strip leading and trailing whitespace
    s = s.replace(/^\s*/, "").replace(/\s*$/, "");

    if (!s) {
      continue;
    }

    var flags = 0;
    var urlspec = s;
    baseVsRefIndex += 1;

    // split on whitespace, and figure out if we have any flags
    var items = s.split(/\s+/);
    if (items[0] == "include") {
      if (items.length != 2) {
        dumpLine(
          "tp: Error on line " +
            lineNo +
            " in " +
            manifestUri.spec +
            ": include must be followed by the manifest to include!"
        );
        return null;
      }

      var subManifest = Services.io.newURI(items[1], null, manifestUri);
      if (subManifest == null) {
        dumpLine(
          "tp: invalid URI on line " +
            manifestUri.spec +
            ":" +
            lineNo +
            " : '" +
            line.value +
            "'"
        );
        return null;
      }

      var subItems = plLoadURLsFromURI(subManifest);
      if (subItems == null) {
        return null;
      }
      url_array = url_array.concat(subItems);
    } else {
      // For scrollTest flag, we accept "normal" pages but treat them as TEST_DOES_OWN_TIMING
      // together with EXECUTE_SCROLL_TEST which makes us run the scroll test on load.
      // We do this by artificially "injecting" the TEST_DOES_OWN_TIMING flag ("%") to the item
      // and then let the default flow for this flag run without further modifications
      // (other than calling the scroll test once the page is loaded).
      // Note that if we have the scrollTest flag but the item already has "%", then we do
      // nothing (the scroll test will not execute, and the page will report with its
      // own tpRecordTime and not the one from the scroll test).
      if (scrollTest && items.length == 1) {
        // scroll enabled and no "%"
        items.unshift("%");
        flags |= EXECUTE_SCROLL_TEST;
      }

      if (items.length == 2) {
        if (items[0].includes("%")) {
          flags |= TEST_DOES_OWN_TIMING;
        }

        urlspec = items[1];
      } else if (items.length == 3) {
        // base vs ref type of talos test
        // expect each manifest line to be in the format of:
        // & http://localhost/tests/perf-reftest/base-page.html, http://localhost/tests/perf-reftest/reference-page.html
        // test will run with the base page, then with the reference page; and ultimately the actual test results will
        // be the comparison values of those two pages; more than one line will result in base vs ref subtests
        if (items[0].includes("&")) {
          baseVsRef = true;
          flags |= TEST_DOES_OWN_TIMING;
          // for the base, must remove the comma on the end of the actual url
          var urlspecBase = items[1].slice(0, -1);
          var urlspecRef = items[2];
        } else {
          dumpLine(
            "tp: Error on line " +
              lineNo +
              " in " +
              manifestUri.spec +
              ": unknown manifest format!"
          );
          return null;
        }
      } else if (items.length != 1) {
        dumpLine(
          "tp: Error on line " +
            lineNo +
            " in " +
            manifestUri.spec +
            ": whitespace must be %-escaped!"
        );
        return null;
      }

      var url;

      if (!baseVsRef) {
        url = Services.io.newURI(urlspec, null, manifestUri);

        if (pageFilterRegexp && !pageFilterRegexp.test(url.spec)) {
          continue;
        }

        url_array.push({ url, flags });
      } else {
        // base vs ref type of talos test
        // we add a 'pre' prefix here indicating that this particular page is a base page or a reference
        // page; later on this 'pre' is used when recording the actual time value/result; because in
        // the results we use the url as the results key; but we might use the same test page as a reference
        // page in the same test suite, so we need to add a prefix so this results key is always unique
        url = Services.io.newURI(urlspecBase, null, manifestUri);
        if (pageFilterRegexp && !pageFilterRegexp.test(url.spec)) {
          continue;
        }
        var pre = "base_page_" + baseVsRefIndex + "_";
        url_array.push({ url, flags, pre });

        url = Services.io.newURI(urlspecRef, null, manifestUri);
        if (pageFilterRegexp && !pageFilterRegexp.test(url.spec)) {
          continue;
        }
        pre = "ref_page_" + baseVsRefIndex + "_";
        url_array.push({ url, flags, pre });
      }
    }
  } while (more);

  return url_array;
}

function dumpLine(str) {
  if (MozillaFileLogger && MozillaFileLogger._foStream) {
    MozillaFileLogger.log(str + "\n");
  }
  dump(str);
  dump("\n");
}
