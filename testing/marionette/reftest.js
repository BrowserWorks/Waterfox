/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { Preferences } = ChromeUtils.import(
  "resource://gre/modules/Preferences.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

const { assert } = ChromeUtils.import("chrome://marionette/content/assert.js");
const { capture } = ChromeUtils.import(
  "chrome://marionette/content/capture.js"
);
const { InvalidArgumentError } = ChromeUtils.import(
  "chrome://marionette/content/error.js"
);
const { Log } = ChromeUtils.import("chrome://marionette/content/log.js");

XPCOMUtils.defineLazyGetter(this, "logger", Log.get);

ChromeUtils.defineModuleGetter(
  this,
  "E10SUtils",
  "resource://gre/modules/E10SUtils.jsm"
);

this.EXPORTED_SYMBOLS = ["reftest"];

const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
const PREF_E10S = "browser.tabs.remote.autostart";
const PREF_FISSION = "fission.autostart";

const SCREENSHOT_MODE = {
  unexpected: 0,
  fail: 1,
  always: 2,
};

const STATUS = {
  PASS: "PASS",
  FAIL: "FAIL",
  ERROR: "ERROR",
  TIMEOUT: "TIMEOUT",
};

const DEFAULT_REFTEST_WIDTH = 600;
const DEFAULT_REFTEST_HEIGHT = 600;

/**
 * Implements an fast runner for web-platform-tests format reftests
 * c.f. http://web-platform-tests.org/writing-tests/reftests.html.
 *
 * @namespace
 */
this.reftest = {};

/**
 * @memberof reftest
 * @class Runner
 */
reftest.Runner = class {
  constructor(driver) {
    this.driver = driver;
    this.canvasCache = new DefaultMap(undefined, () => new Map([[null, []]]));
    this.windowUtils = null;
    this.lastURL = null;
    this.useRemoteTabs = Preferences.get(PREF_E10S);
    this.useRemoteSubframes = Preferences.get(PREF_FISSION);
  }

  /**
   * Setup the required environment for running reftests.
   *
   * This will open a non-browser window in which the tests will
   * be loaded, and set up various caches for the reftest run.
   *
   * @param {Object.<Number>} urlCount
   *     Object holding a map of URL: number of times the URL
   *     will be opened during the reftest run, where that's
   *     greater than 1.
   * @param {string} screenshotMode
   *     String enum representing when screenshots should be taken
   */
  setup(urlCount, screenshotMode) {
    this.parentWindow = assert.open(this.driver.getCurrentWindow());

    this.screenshotMode =
      SCREENSHOT_MODE[screenshotMode] || SCREENSHOT_MODE.unexpected;

    this.urlCount = Object.keys(urlCount || {}).reduce(
      (map, key) => map.set(key, urlCount[key]),
      new Map()
    );
  }

  async ensureWindow(timeout, width, height) {
    logger.debug(`ensuring we have a window ${width}x${height}`);

    if (this.reftestWin && !this.reftestWin.closed) {
      let browserRect = this.reftestWin.gBrowser.getBoundingClientRect();
      if (browserRect.width === width && browserRect.height === height) {
        return this.reftestWin;
      }
      logger.debug(`current: ${browserRect.width}x${browserRect.height}`);
    }

    let reftestWin;
    if (Services.appinfo.OS == "Android") {
      logger.debug("Using current window");
      reftestWin = this.parentWindow;
      await this.driver.listener.get({
        commandID: this.driver.listener.activeMessageId,
        pageTimeout: timeout,
        url: "about:blank",
        loadEventExpected: false,
      });
    } else {
      logger.debug("Using separate window");
      if (this.reftestWin && !this.reftestWin.closed) {
        this.reftestWin.close();
      }
      reftestWin = await this.openWindow(width, height);
    }

    this.setupWindow(reftestWin, width, height);
    this.windowUtils = reftestWin.windowUtils;
    this.reftestWin = reftestWin;

    let found = this.driver.findWindow([reftestWin], () => true);
    await this.driver.setWindowHandle(found, true);

    let browserRect = reftestWin.gBrowser.getBoundingClientRect();
    logger.debug(`new: ${browserRect.width}x${browserRect.height}`);

    return reftestWin;
  }

  async openWindow(width, height) {
    assert.positiveInteger(width);
    assert.positiveInteger(height);

    let reftestWin = this.parentWindow.open(
      "chrome://marionette/content/reftest.xhtml",
      "reftest",
      `chrome,height=${height},width=${width}`
    );

    await new Promise(resolve => {
      reftestWin.addEventListener("load", resolve, { once: true });
    });
    return reftestWin;
  }

  setupWindow(reftestWin, width, height) {
    let browser;
    if (Services.appinfo.OS === "Android") {
      browser = reftestWin.document.getElementsByTagName("browser")[0];
      browser.setAttribute("remote", "false");
    } else {
      browser = reftestWin.document.createElementNS(XUL_NS, "xul:browser");
      browser.permanentKey = {};
      browser.setAttribute("id", "browser");
      browser.setAttribute("type", "content");
      browser.setAttribute("primary", "true");
      browser.setAttribute("remote", this.useRemoteTabs ? "true" : "false");
    }
    // Make sure the browser element is exactly the right size, no matter
    // what size our window is
    const windowStyle = `padding: 0px; margin: 0px; border:none;
min-width: ${width}px; min-height: ${height}px;
max-width: ${width}px; max-height: ${height}px`;
    browser.setAttribute("style", windowStyle);

    if (Services.appinfo.OS !== "Android") {
      let doc = reftestWin.document.documentElement;
      while (doc.firstChild) {
        doc.firstChild.remove();
      }
      doc.appendChild(browser);
    }
    if (reftestWin.BrowserApp) {
      reftestWin.BrowserApp = browser;
    }
    reftestWin.gBrowser = browser;
    return reftestWin;
  }

  async abort() {
    if (this.reftestWin && this.reftestWin != this.parentWindow) {
      this.driver.closeChromeWindow();
      let parentHandle = this.driver.findWindow(
        [this.parentWindow],
        () => true
      );
      await this.driver.setWindowHandle(parentHandle);
    }
    this.reftestWin = null;
  }

  /**
   * Run a specific reftest.
   *
   * The assumed semantics are those of web-platform-tests where
   * references form a tree and each test must meet all the conditions
   * to reach one leaf node of the tree in order for the overall test
   * to pass.
   *
   * @param {string} testUrl
   *     URL of the test itself.
   * @param {Array.<Array>} references
   *     Array representing a tree of references to try.
   *
   *     Each item in the array represents a single reference node and
   *     has the form <code>[referenceUrl, references, relation]</code>,
   *     where <var>referenceUrl</var> is a string to the URL, relation
   *     is either <code>==</code> or <code>!=</code> depending on the
   *     type of reftest, and references is another array containing
   *     items of the same form, representing further comparisons treated
   *     as AND with the current item. Sibling entries are treated as OR.
   *
   *     For example with testUrl of T:
   *
   *     <pre><code>
   *       references = [[A, [[B, [], ==]], ==]]
   *       Must have T == A AND A == B to pass
   *
   *       references = [[A, [], ==], [B, [], !=]
   *       Must have T == A OR T != B
   *
   *       references = [[A, [[B, [], ==], [C, [], ==]], ==], [D, [], ]]
   *       Must have (T == A AND A == B) OR (T == A AND A == C) OR (T == D)
   *     </code></pre>
   *
   * @param {string} expected
   *     Expected test outcome (e.g. <tt>PASS</tt>, <tt>FAIL</tt>).
   * @param {number} timeout
   *     Test timeout in milliseconds.
   *
   * @return {Object}
   *     Result object with fields status, message and extra.
   */
  async run(
    testUrl,
    references,
    expected,
    timeout,
    width = DEFAULT_REFTEST_WIDTH,
    height = DEFAULT_REFTEST_HEIGHT
  ) {
    let timeoutHandle;

    let timeoutPromise = new Promise(resolve => {
      timeoutHandle = this.parentWindow.setTimeout(() => {
        resolve({ status: STATUS.TIMEOUT, message: null, extra: {} });
      }, timeout);
    });

    let testRunner = (async () => {
      let result;
      try {
        result = await this.runTest(
          testUrl,
          references,
          expected,
          timeout,
          width,
          height
        );
      } catch (e) {
        result = {
          status: STATUS.ERROR,
          message: String(e),
          stack: e.stack,
          extra: {},
        };
      }
      return result;
    })();

    let result = await Promise.race([testRunner, timeoutPromise]);
    this.parentWindow.clearTimeout(timeoutHandle);
    if (result.status === STATUS.TIMEOUT) {
      await this.abort();
    }

    return result;
  }

  async runTest(testUrl, references, expected, timeout, width, height) {
    let win = await this.ensureWindow(timeout, width, height);

    function toBase64(screenshot) {
      let dataURL = screenshot.canvas.toDataURL();
      return dataURL.split(",")[1];
    }

    let result = {
      status: STATUS.FAIL,
      message: "",
      stack: null,
      extra: {},
    };

    let screenshotData = [];

    let stack = [];
    for (let i = references.length - 1; i >= 0; i--) {
      let item = references[i];
      stack.push([testUrl, ...item]);
    }

    let done = false;

    while (stack.length && !done) {
      let [lhsUrl, rhsUrl, references, relation, extras = {}] = stack.pop();
      result.message += `Testing ${lhsUrl} ${relation} ${rhsUrl}\n`;

      let comparison;
      try {
        comparison = await this.compareUrls(
          win,
          lhsUrl,
          rhsUrl,
          relation,
          timeout,
          extras
        );
      } catch (e) {
        comparison = {
          lhs: null,
          rhs: null,
          passed: false,
          error: e,
          msg: null,
        };
      }
      if (comparison.msg) {
        result.message += `${comparison.msg}\n`;
      }
      if (comparison.error !== null) {
        result.status = STATUS.ERROR;
        result.message += String(comparison.error);
        result.stack = comparison.error.stack;
      }

      function recordScreenshot() {
        let encodedLHS = comparison.lhs ? toBase64(comparison.lhs) : "";
        let encodedRHS = comparison.rhs ? toBase64(comparison.rhs) : "";
        screenshotData.push([
          { url: lhsUrl, screenshot: encodedLHS },
          relation,
          { url: rhsUrl, screenshot: encodedRHS },
        ]);
      }

      if (this.screenshotMode === SCREENSHOT_MODE.always) {
        recordScreenshot();
      }

      if (comparison.passed) {
        if (references.length) {
          for (let i = references.length - 1; i >= 0; i--) {
            let item = references[i];
            stack.push([rhsUrl, ...item]);
          }
        } else {
          // Reached a leaf node so all of one reference chain passed
          result.status = STATUS.PASS;
          if (
            this.screenshotMode <= SCREENSHOT_MODE.fail &&
            expected != result.status
          ) {
            recordScreenshot();
          }
          done = true;
        }
      } else if (!stack.length || result.status == STATUS.ERROR) {
        // If we don't have any alternatives to try then this will be
        // the last iteration, so save the failing screenshots if required.
        let isFail = this.screenshotMode === SCREENSHOT_MODE.fail;
        let isUnexpected = this.screenshotMode === SCREENSHOT_MODE.unexpected;
        if (isFail || (isUnexpected && expected != result.status)) {
          recordScreenshot();
        }
      }

      // Return any reusable canvases to the pool
      let cacheKey = width + "x" + height;
      let canvasPool = this.canvasCache.get(cacheKey).get(null);
      [comparison.lhs, comparison.rhs].map(screenshot => {
        if (screenshot !== null && screenshot.reuseCanvas) {
          canvasPool.push(screenshot.canvas);
        }
      });
      logger.debug(
        `Canvas pool (${cacheKey}) is of length ${canvasPool.length}`
      );
    }

    if (screenshotData.length) {
      // For now the tbpl formatter only accepts one screenshot, so just
      // return the last one we took.
      let lastScreenshot = screenshotData[screenshotData.length - 1];
      // eslint-disable-next-line camelcase
      result.extra.reftest_screenshots = lastScreenshot;
    }

    return result;
  }

  async compareUrls(win, lhsUrl, rhsUrl, relation, timeout, extras) {
    logger.info(`Testing ${lhsUrl} ${relation} ${rhsUrl}`);

    // Take the reference screenshot first so that if we pause
    // we see the test rendering
    let rhs = await this.screenshot(win, rhsUrl, timeout);
    let lhs = await this.screenshot(win, lhsUrl, timeout);

    logger.debug(`lhs canvas size ${lhs.canvas.width}x${lhs.canvas.height}`);
    logger.debug(`rhs canvas size ${rhs.canvas.width}x${rhs.canvas.height}`);

    let passed;
    let error = null;
    let pixelsDifferent = null;
    let maxDifferences = {};
    let msg = null;

    try {
      pixelsDifferent = this.windowUtils.compareCanvases(
        lhs.canvas,
        rhs.canvas,
        maxDifferences
      );
    } catch (e) {
      passed = false;
      error = e;
    }

    if (error === null) {
      passed = this.isAcceptableDifference(
        maxDifferences.value,
        pixelsDifferent,
        extras.fuzzy
      );
      switch (relation) {
        case "==":
          if (!passed) {
            msg =
              `Found ${pixelsDifferent} pixels different, ` +
              `maximum difference per channel ${maxDifferences.value}`;
          }
          break;
        case "!=":
          passed = !passed;
          break;
        default:
          throw new InvalidArgumentError(
            "Reftest operator should be '==' or '!='"
          );
      }
    }
    return { lhs, rhs, passed, error, msg };
  }

  isAcceptableDifference(maxDifference, pixelsDifferent, allowed) {
    if (!allowed) {
      logger.info(`No differences allowed`);
      return pixelsDifferent === 0;
    }
    let [allowedDiff, allowedPixels] = allowed;
    logger.info(
      `Allowed ${allowedPixels.join("-")} pixels different, ` +
        `maximum difference per channel ${allowedDiff.join("-")}`
    );
    return (
      (pixelsDifferent === 0 && allowedPixels[0] == 0) ||
      (maxDifference === 0 && allowedDiff[0] == 0) ||
      (maxDifference >= allowedDiff[0] &&
        maxDifference <= allowedDiff[1] &&
        (pixelsDifferent >= allowedPixels[0] ||
          pixelsDifferent <= allowedPixels[1]))
    );
  }

  ensureFocus(win) {
    const focusManager = Services.focus;
    if (focusManager.activeWindow != win) {
      win.focus();
    }
    this.driver.curBrowser.contentBrowser.focus();
  }

  updateBrowserRemotenessByURL(browser, url) {
    // We don't use remote tabs on Android.
    if (Services.appinfo.OS === "Android") {
      return;
    }

    let remoteType = E10SUtils.getRemoteTypeForURI(
      url,
      this.useRemoteTabs,
      this.useRemoteSubframes
    );

    // Only re-construct the browser if its remote type needs to change.
    if (browser.remoteType !== remoteType) {
      if (remoteType === E10SUtils.NOT_REMOTE) {
        browser.removeAttribute("remote");
        browser.removeAttribute("remoteType");
      } else {
        browser.setAttribute("remote", "true");
        browser.setAttribute("remoteType", remoteType);
      }

      browser.changeRemoteness({ remoteType });
      browser.construct();

      // XXX: This appears to be working fine as is, should we be reinitializing
      // something here? If so, what? The listener.js framescript is registered
      // on the reftest.xhtml chrome window (which shouldn't be changing?), and
      // driver.js uses the global message manager to listen for messages.
    }
  }

  async screenshot(win, url, timeout) {
    // On windows the above doesn't *actually* set the window to be the
    // reftest size; but *does* set the content area to be the right size;
    // the window is given some extra borders that aren't explicable from CSS
    let browserRect = win.gBrowser.getBoundingClientRect();
    let canvas = null;
    let remainingCount = this.urlCount.get(url) || 1;
    let cache = remainingCount > 1;
    let cacheKey = browserRect.width + "x" + browserRect.height;
    logger.debug(
      `screenshot ${url} remainingCount: ` +
        `${remainingCount} cache: ${cache} cacheKey: ${cacheKey}`
    );
    let reuseCanvas = false;
    let sizedCache = this.canvasCache.get(cacheKey);
    if (sizedCache.has(url)) {
      logger.debug(`screenshot ${url} taken from cache`);
      canvas = sizedCache.get(url);
      if (!cache) {
        sizedCache.delete(url);
      }
    } else {
      let canvasPool = sizedCache.get(null);
      if (canvasPool.length) {
        logger.debug("reusing canvas from canvas pool");
        canvas = canvasPool.pop();
      } else {
        logger.debug("using new canvas");
        canvas = null;
      }
      reuseCanvas = !cache;

      let ctxInterface = win.CanvasRenderingContext2D;
      let flags =
        ctxInterface.DRAWWINDOW_DRAW_CARET |
        ctxInterface.DRAWWINDOW_DRAW_VIEW |
        ctxInterface.DRAWWINDOW_USE_WIDGET_LAYERS;

      if (
        !(
          0 <= browserRect.left &&
          0 <= browserRect.top &&
          win.innerWidth >= browserRect.width &&
          win.innerHeight >= browserRect.height
        )
      ) {
        logger.error(`Invalid window dimensions:
browserRect.left: ${browserRect.left}
browserRect.top: ${browserRect.top}
win.innerWidth: ${win.innerWidth}
browserRect.width: ${browserRect.width}
win.innerHeight: ${win.innerHeight}
browserRect.height: ${browserRect.height}`);
        throw new Error("Window has incorrect dimensions");
      }

      url = new URL(url).href; // normalize the URL
      logger.debug(`Starting load of ${url}`);
      let navigateOpts = {
        commandId: this.driver.listener.activeMessageId,
        pageTimeout: timeout,
      };
      if (this.lastURL === url) {
        logger.debug(`Refreshing page`);
        await this.driver.listener.refresh(navigateOpts);
      } else {
        // HACK: DocumentLoadListener currently doesn't know how to
        // process-switch loads in a non-tabbed <browser>. We need to manually
        // set the browser's remote type in order to ensure that the load
        // happens in the correct process.
        //
        // See bug 1636169.
        this.updateBrowserRemotenessByURL(win.gBrowser, url);

        navigateOpts.url = url;
        navigateOpts.loadEventExpected = false;
        await this.driver.listener.get(navigateOpts);
        this.lastURL = url;
      }

      this.ensureFocus(win);
      await this.driver.listener.reftestWait(url, this.useRemoteTabs);

      canvas = await capture.canvas(
        win,
        win.docShell.browsingContext,
        0, // left
        0, // top
        browserRect.width,
        browserRect.height,
        { canvas, flags, readback: true }
      );
    }
    if (
      canvas.width !== browserRect.width ||
      canvas.height !== browserRect.height
    ) {
      logger.warn(
        `Canvas dimensions changed to ${canvas.width}x${canvas.height}`
      );
      reuseCanvas = false;
      cache = false;
    }
    if (cache) {
      sizedCache.set(url, canvas);
    }
    this.urlCount.set(url, remainingCount - 1);
    return { canvas, reuseCanvas };
  }
};

class DefaultMap extends Map {
  constructor(iterable, defaultFactory) {
    super(iterable);
    this.defaultFactory = defaultFactory;
  }

  get(key) {
    if (this.has(key)) {
      return super.get(key);
    }

    let v = this.defaultFactory();
    this.set(key, v);
    return v;
  }
}
