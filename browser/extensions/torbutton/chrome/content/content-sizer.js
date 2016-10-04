// The purpose of this file is to ensure that window.innerWidth and window.innerHeight
// always return rounded values.

// This file is formatted for docco.js. Later functions call earlier ones.

/*
TODO:
* Decide on quantization amount. 100x100? 200x100? Maybe gradually increase, like 50, 100, 150, 200, 300, 500, 600, 800, etc.?
* Understand gBrowser.contentWindow.document.body.getBoundingClientRect(). Does this leak some fingerprintable information?
* Modify Tor Browser C++ code to allow precise setting of zoom? (Would allow more precise fit of content height in window.)
*/

/* jshint esnext: true */

// __quantizeBrowserSize(window, xStep, yStep)__.
// Ensures that gBrowser width and height are multiples of
// xStep and yStep.
let quantizeBrowserSize = function (window, xStep, yStep) {
"use strict";

// __currentDefaultZoom__.
// The settings of gBrowser.fullZoom used to quantize the content window dimensions,
// except if the user has pressed zoom+ or zoom-. Stateful.
let currentDefaultZoom = 1;

// ## Utilities

// Mozilla abbreviations.
let {classes: Cc, interfaces: Ci, results: Cr, Constructor: CC, utils: Cu } = Components;

// Use Task.jsm to avoid callback hell.
Cu.import("resource://gre/modules/Task.jsm");

// Make the TorButton logger available.
let logger = Cc["@torproject.org/torbutton-logger;1"]
               .getService(Ci.nsISupports).wrappedJSObject;

// __torbuttonBundle__.
// Bundle of localized strings for torbutton UI.
let torbuttonBundle = Services.strings.createBundle(
                        "chrome://torbutton/locale/torbutton.properties");

// Import utility functions
let { bindPrefAndInit, getEnv } = Cu.import("resource://torbutton/modules/utils.js");

// __windowUtils(window)__.
// See nsIDOMWindowUtils on MDN.
let windowUtils = window => window.QueryInterface(Ci.nsIInterfaceRequestor)
                                  .getInterface(Ci.nsIDOMWindowUtils);

// __isNumber(value)__.
// Returns true iff the value is a number.
let isNumber = x => typeof x === "number";

// __sortBy(array, scoreFn)__.
// Returns a copy of the array, sorted from least to best
// according to scoreFn.
let sortBy = function (array, scoreFn) {
  let compareFn = (a, b) => scoreFn(a) - scoreFn(b);
  return array.slice().sort(compareFn);
};

// __isMac__.
// Constant, set to true if we are using a Mac (Darwin).
let isMac = Services.appinfo.OS === "Darwin";

// __isWindows__.
// Constant, set to true if we are using Windows.
let isWindows = Services.appinfo.OS === "WINNT";

// __isTilingWindowManager__.
// Constant, set to true if we are using a (known) tiling window
// manager in linux.
let isTilingWindowManager = (function () {
  if (isMac || isWindows) return false;
  let gdmSession = getEnv("GDMSESSION");
  if (!gdmSession) return false;
  let gdmSessionLower = gdmSession.toLowerCase();
  return ["9wm", "alopex", "awesome", "bspwm", "catwm", "dswm", "dwm",
          "echinus", "euclid-wm", "frankenwm", "herbstluftwm", "i3",
          "i3wm", "ion", "larswm", "monsterwm", "musca", "notion",
          "qtile", "ratpoison", "snapwm", "spectrwm", "stumpwm",
          "subtle", "tinywm", "ttwm", "wingo", "wmfs", "wmii", "xmonad"]
            .filter(x => x.startsWith(gdmSessionLower)).length > 0;
})();

// __largestMultipleLessThan(factor, max)__.
// Returns the largest number that is a multiple of factor
// and is less or equal to max.
let largestMultipleLessThan = function (factor, max) {
  return Math.max(1, Math.floor(max / factor, 1)) * factor;
};

// ## Task.jsm helper functions

// __sleep(timeMs)__.
// Returns a Promise that sleeps for the specified time interval,
// and returns an Event object of type "wake".
let sleep = function (timeMs) {
  return new Promise(function (resolve, reject) {
    window.setTimeout(function () {
      resolve(new Event("wake"));
    }, timeMs);
  });
};

// __listen(target, eventType, useCapture, timeoutMs)__.
// Listens for a single event of eventType on target.
// Returns a Promise that resolves to an Event object, if the event fires.
// If a timeout occurs, then Promise is rejected with a "Timed out" error.
let listen = function (target, eventType, useCapture, timeoutMs) {
  return new Promise(function (resolve, reject) {
    let listenFunction = function (event) {
      target.removeEventListener(eventType, listenFunction, useCapture);
      resolve(event);
    };
    target.addEventListener(eventType, listenFunction, useCapture);
    if (timeoutMs !== undefined && timeoutMs !== null) {
      window.setTimeout(function () {
        target.removeEventListener(eventType, listenFunction, useCapture);
        resolve(new Event("timeout"));
      }, timeoutMs);
    }
  });
};

// __listenForTrueResize(window, timeoutMs)__.
// Task.jsm function. Call `yield listenForTrueResize(window)` to
// wait until the window changes its outer dimensions. Ignores
// resize events where window dimensions are unchanged. Returns
// the resize event object.
let listenForTrueResize = function* (window, timeoutMs) {
  let [originalWidth, originalHeight] = [window.outerWidth, window.outerHeight],
      event,
      finishTime = timeoutMs ? Date.now() + timeoutMs : null;
  do {
    event = yield listen(window, "resize", true,
			 finishTime ? finishTime - Date.now() : undefined);
  } while (event.type === "resize" &&
	         originalWidth === window.outerWidth &&
           originalHeight === window.outerHeight);
  return event;
};

// ## Window state queries

// __trueZoom(window)__.
// Returns the true magnification of the content in the window
// object. (In contrast, the `gBrowser.fullZoom` value is only approximated
// by the display zoom.)
let trueZoom = window => windowUtils(window).screenPixelsPerCSSPixel;

// __systemZoom__.
// On Windows, if the user sets the DPI to be 125% or 150% (instead of 100%),
// then we get an overall zoom that needs to be accounted for.
let systemZoom = trueZoom(window);

// __canBeResized(window)__.
// Returns true iff the window is in a state that can
// be resized. Namely, not fullscreen, not maximized,
// and not running in a tiling window manager.
let canBeResized = function (window) {
  // Note that window.fullScreen and (window.windowState === window.STATE_FULLSCREEN)
  // sometimes disagree, so we only allow resizing when both are false.
  return !isTilingWindowManager &&
         !window.fullScreen &&
         window.windowState === window.STATE_NORMAL;
};

// __isDocked(window)__.
// On Windows and some linux desktops, you can "dock" a window
// at the right or left, so that it is maximized only in height.
// Returns true in this case. (Note we use mozInnerScreenY instead
// of screenY to take into account title bar space sometimes left
// out of outerHeight in certain desktop environments.)
let isDocked = window => ((window.mozInnerScreenY + window.outerHeight) >=
                          (window.screen.availTop + window.screen.availHeight) &&
                         (window.screenY <= window.screen.availTop));

// ## Window appearance

// __marginToolTip__.
// A constant. The tooltip string shown in the margin.
let marginToolTip = torbuttonBundle.GetStringFromName("torbutton.content_sizer.margin_tooltip");

// __updateContainerAppearance(container, on)__.
// Get the color and position of margins correct.
let updateContainerAppearance = function (container, on) {
  // Align the browser at top left, so any gray margin will be visible
  // at right and bottom. Except in fullscreen, where we have black
  // margins and gBrowser in top center, and when using a tiling
  // window manager, when we have gray margins and gBrowser in top
  // center.
  container.align = on ?
                       (canBeResized(window) ? "start" : "center")
                       : "";
  container.pack = on ? "start" : "";
  container.tooltipText = on ? marginToolTip : "";
};

// __updateBackground(window)__.
// Sets the margin background to black or dim gray, depending on
// whether the window is full screen.
let updateBackground = function (window) {
  window.gBrowser.parentElement.style
        .backgroundColor = window.fullScreen ? "Black" : "LightGray";
};

// ## Window Zooming

// __computeTargetZoom(parentWidth, parentHeight, xStep, yStep, fillHeight)__.
// Given a parent width and height for gBrowser's container, returns the
// desired zoom for the content window.
let computeTargetZoom = function (parentWidth, parentHeight, xStep, yStep, fillHeight) {
  if (fillHeight) {
    // Return the estimated zoom need to fill the height of the browser.
    let h = largestMultipleLessThan(yStep, parentHeight);
    return parentHeight / h;
  } else {
    // Here we attempt to find a zoom with the best fit for the window size that will
    // provide a content window with appropriately quantized dimensions.
    let w = largestMultipleLessThan(xStep, parentWidth),
        h = largestMultipleLessThan(yStep, parentHeight),
        parentAspectRatio = parentWidth / parentHeight,
        possibilities = [[w, h],
                         [Math.min(w, w - xStep), h],
                         [w, Math.min(h - yStep)]],
        // Find the [w, h] pair with the closest aspect ratio to the parent window.
        score = ([w, h]) => Math.abs(Math.log(w / h / parentAspectRatio)),
        [W, H] = sortBy(possibilities, score)[0];
    // Return the estimated zoom.
    return Math.min(parentHeight / H, parentWidth / W);
  }
};

// __updateDimensions(window, xStep, yStep)__.
// Changes the width and height of the gBrowser XUL element to be a multiple of x/yStep.
let updateDimensions = function (window, xStep, yStep) {
  // Don't run if window is minimized.
  if (window.windowState === window.STATE_MINIMIZED) return;
  let gBrowser = window.gBrowser,
      container = gBrowser.parentElement;
  updateContainerAppearance(container, true);
  let parentWidth = container.clientWidth,
      parentHeight = container.clientHeight,
      longPage = !gBrowser.contentWindow.fullScreen,
      targetZoom = (canBeResized(window) && !isDocked(window)) ?
                     1 : computeTargetZoom(parentWidth,
                                           parentHeight, xStep, yStep, longPage),
      zoomOffset = 1;
  for (let i = 0; i < 8; ++i) {
    // We set `gBrowser.fullZoom` to 99% of the needed zoom, unless
    // it's `1`. That's because the "true zoom" is sometimes larger
    // than fullZoom, and we need to ensure the gBrowser width and
    // height do not exceed the container size.
    gBrowser.fullZoom = (targetZoom === 1 ? 1 : 0.99) * targetZoom * zoomOffset;
    currentDefaultZoom = gBrowser.fullZoom;
    let zoom = trueZoom(gBrowser.contentWindow) / systemZoom,
    targetContentWidth = largestMultipleLessThan(xStep, parentWidth / zoom),
    targetContentHeight = largestMultipleLessThan(yStep, parentHeight / zoom),
    targetBrowserWidth = Math.round(targetContentWidth * zoom),
    targetBrowserHeight = Math.round(targetContentHeight * zoom);
    // Because gBrowser is inside a vbox, width and height behave differently. It turns
    // out we need to set `gBrowser.width` and `gBrowser.maxHeight`.
    gBrowser.width = targetBrowserWidth;
    gBrowser.maxHeight = targetBrowserHeight;
    // When using Windows DPI != 100%, we can get rounding errors. We'll need
    // to try again if we failed to get rounded content width x height.
    // Unfortunately, this is not detectable if search bar or dev console is open.
    if ((// Some weird sidebar is open, or
         gBrowser.clientWidth !== gBrowser.selectedBrowser.clientWidth ||
         // content width is correct.
         gBrowser.contentWindow.innerWidth === targetContentWidth) &&
        (// Search bar or dev console is open, or
         gBrowser.clientHeight !== gBrowser.selectedBrowser.clientHeight ||
         // content height is correct.
         gBrowser.contentWindow.innerHeight === targetContentHeight)) {
      logger.eclog(3,
		   " chromeWin " + window.outerWidth + "x" +  window.outerHeight +
		   " container " + parentWidth + "x" + parentHeight +
		   " gBrowser.fullZoom " + gBrowser.fullZoom + "X" +
		   " targetContent " + targetContentWidth + "x" + targetContentHeight +
		   " zoom " + zoom + "X" +
		   " targetBrowser " + targetBrowserWidth + "x" + targetBrowserHeight +
		   " gBrowser " + gBrowser.clientWidth + "x" + gBrowser.clientHeight +
		   " content " + gBrowser.contentWindow.innerWidth + "x" +  gBrowser.contentWindow.innerHeight);
	     break;
     }
    zoomOffset *= 1.02;
  }
};

// __resetZoomOnDomainChanges(gBrowser, on)__.
// If `on` is true, then every time a tab location changes
// to a new domain, the tab's zoom level is set back to the
// "default zoom" level.
let resetZoomOnDomainChanges = (function () {
  let tabToDomainMap = new Map(),
      onLocationChange = function (browser) {
        let lastHost = tabToDomainMap.get(browser),
            currentHost = browser &&
                          browser.currentURI &&
                          browser.currentURI.asciiHost;
        if (lastHost !== currentHost) {
          browser.fullZoom = currentDefaultZoom;
          // Record the tab's current domain, so that we
          // can see when it changes.
          tabToDomainMap.set(browser, currentHost);
        }
      },
      listener = { onLocationChange : onLocationChange };
  return function (gBrowser, on) {
    if (on) {
      gBrowser.addTabsProgressListener(listener);
    } else {
      gBrowser.removeTabsProgressListener(listener);
    }
  };
})();

// ## Window Resizing

// __reshape(window, {left, top, width, height}, timeoutMs)__.
// Reshapes the window to rectangle {left, top, width, height} and yields
// until the window reaches its target size, or the timeout occurs.
let reshape = function* (window, {left, top, width, height}, timeoutMs) {
  let finishTime = Date.now() + timeoutMs,
      x = isNumber(left) ? left : window.screenX,
      y = isNumber(top) ? top : window.screenY,
      w = isNumber(width) ? width : window.outerWidth,
      h = isNumber(height) ? height : window.outerHeight;
  // Make sure we are in a new event.
  yield sleep(0);
  // Sometimes we get a race condition in linux when maximizing,
  // so check again at the last minute that resizing is allowed.
  if (!canBeResized(window)) return;
  if (w !== window.outerWidth || h !== window.outerHeight) {
    window.resizeTo(w, h);
  }
  if (x !== window.screenX || y !== window.screenY) {
    window.moveTo(x, y);
  }
  // Yield until we have the correct screen position and size, or
  // we timeout. Multiple resize events often fire in a resize.
  while (x !== window.screenX ||
         y !== window.screenY ||
         w !== window.outerWidth ||
         h !== window.outerHeight) {
    let timeLeft = finishTime - Date.now();
    if (timeLeft <= 0) break;
    yield listenForTrueResize(window, timeLeft);
  }
};

// __gaps(window)__.
// Deltas between gBrowser and its container. Returns null if there is no gap.
let gaps = function (window) {
  let gBrowser = window.gBrowser,
      container = gBrowser.parentElement,
      deltaWidth = Math.max(0, container.clientWidth - gBrowser.clientWidth),
      deltaHeight = Math.max(0, container.clientHeight - gBrowser.clientHeight);
  return (deltaWidth === 0 && deltaHeight === 0) ? null
           : { deltaWidth : deltaWidth, deltaHeight : deltaHeight };
};

// __shrinkwrap(window)__.
// Shrinks the window so that it encloses the gBrowser with no gaps.
let shrinkwrap = function* (window) {
  // Figure out what size change we need.
  let currentGaps = gaps(window),
      screenRightEdge = window.screen.availWidth + window.screen.availLeft,
      windowRightEdge = window.screenX + window.outerWidth;
  if (currentGaps) {
    // Now resize to close the gaps.
    yield reshape(window,
                  {width : (window.outerWidth - currentGaps.deltaWidth),
                   // Shrink in height only if we are not docked.
                   height : !isDocked(window) ?
                              (window.outerHeight -
                               currentGaps.deltaHeight) : null,
                   left : (isDocked(window) &&
                           (windowRightEdge >= screenRightEdge)) ?
                             (window.screenX + currentGaps.deltaWidth)
                             : null },
                  500);
  }
};

// __rebuild(window)__.
// Jog the size of the window slightly, to remind the window manager
// to redraw the window.
let rebuild = function* (window) {
  let h = window.outerHeight;
  yield reshape(window, {height : (h + 1)}, 300);
  yield reshape(window, {height : h}, 300);
};

// __fixWindow(window)__.
// An async function for Task.jsm. Makes sure the window looks okay
// given the quantized browser element.
let fixWindow = function* (window) {
  if (canBeResized(window)) {
    yield shrinkwrap(window);
    if (!isMac && !isWindows) {
      // Unfortunately, on some linux desktops,
      // the window resize fails if the user is still holding on
      // to the drag-resize handle. Even more unfortunately, the
      // only way to know that the user if finished dragging
      // if we detect the mouse cursor inside the window or the
      // user presses a key.
      // So, after the first mousemove, or keydown event occurs, we
      // rebuild the window.
      let event = yield Promise.race(
        [listen(window, "mousemove", true),
         listen(window, "keydown", true),
         listen(window, "resize", true)]);
      if (event !== "resize") {
        yield rebuild(window);
      }
      return event;
    }
  }
};

// __autoresize(window, stepMs)__.
// Automatically resize the gBrowser, and then shrink the window
// if the user has attempted to resize it.
let autoresize = function (window, stepMs, xStep, yStep) {
  let stop = false;
  Task.spawn(function* () {
    // Fix the content dimensions once at startup, and
    // keep updating the dimensions whenever the user resizes
    // the window.
    while (!stop) {
      updateDimensions(window, xStep, yStep);
      let event = yield fixWindow(window);
      // Do nothing until the user starts to resize window.
      if ((!event || event.type !== "resize") && !stop) {
        event = yield listenForTrueResize(window);
      }
      if (!isTilingWindowManager) {
        while (event.type !== "timeout" && !stop) {
          if (!stop) {
            updateDimensions(window, xStep, yStep);
            event = yield listenForTrueResize(window, stepMs);
          }
        }
      }
      // The user has likely released the mouse cursor on the window's
      // drag/resize handle, so loop and call fixWindow.
    }
  });
  return () => { stop = true; };
};

// ## Main Function

// __quantizeBrowserSizeMain(window, xStep, yStep)__.
// Ensures that gBrowser width and height are multiples of xStep and yStep, and always as
// large as possible inside the chrome window.
let quantizeBrowserSizeMain = function (window, xStep, yStep) {
  let gBrowser = window.gBrowser,
      container = window.gBrowser.parentElement,
      fullscreenHandler = function () {
        // Use setTimeout to make sure we only update dimensions after
        // full screen mode is fully established.
        window.setTimeout(function () {
          updateDimensions(window, xStep, yStep);
	        updateBackground(window);
        }, 0);
      },
      originalMinWidth = container.minWidth,
      originalMinHeight = container.minHeight,
      stopAutoresizing,
      activate = function (on) {
        console.log("activate:", on);
        // Don't let the browser shrink below a single xStep x yStep size.
        container.minWidth = on ? xStep : originalMinWidth;
        container.minHeight = on ? yStep : originalMinHeight;
        updateContainerAppearance(container, on);
        updateBackground(window);
        resetZoomOnDomainChanges(gBrowser, on);
        if (on) {
          shrinkwrap(window);
          window.addEventListener("sizemodechange", fullscreenHandler, false);
          stopAutoresizing = autoresize(window,
                                        (isMac || isWindows) ? 250 : 500,
                                        xStep, yStep);
          console.log("activated");
        } else {
          if (stopAutoresizing) stopAutoresizing();
          // Ignore future resize events.
          window.removeEventListener("sizemodechange", fullscreenHandler, false);
          // Let gBrowser expand with its parent vbox.
          gBrowser.width = "";
          gBrowser.maxHeight = "";
          console.log("deactivated");
        }
     };
  let unbind = bindPrefAndInit("extensions.torbutton.resize_windows", activate);
  window.addEventListener("unload", unbind, true);
};

quantizeBrowserSizeMain(window, xStep, yStep);

// end of quantizeBrowserSize definition
};
