/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* eslint-env mozilla/frame-script */

const { PageThumbUtils } = ChromeUtils.import(
  "resource://gre/modules/PageThumbUtils.jsm"
);
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyGlobalGetters(this, ["Blob", "FileReader"]);

// Let the page settle for this amount of milliseconds before capturing to allow
// for any in-page changes or redirects.
const SETTLE_WAIT_TIME = 2500;
// For testing, the above timeout is excessive, and makes our tests overlong.
const TESTING_SETTLE_WAIT_TIME = 0;

const STATE_LOADING = 1;
const STATE_CAPTURING = 2;
const STATE_CANCELED = 3;

// NOTE: Copied from nsSandboxFlags.h
/**
 * This flag prevents content from creating new auxiliary browsing contexts,
 * e.g. using the target attribute, or the window.open() method.
 */
const SANDBOXED_AUXILIARY_NAVIGATION = 0x2;

const backgroundPageThumbsContent = {
  init() {
    Services.obs.addObserver(this, "document-element-inserted", true);

    // We want a low network priority for this service - lower than b/g tabs
    // etc - so set it to the lowest priority available.
    this._webNav
      .QueryInterface(Ci.nsIDocumentLoader)
      .loadGroup.QueryInterface(Ci.nsISupportsPriority).priority =
      Ci.nsISupportsPriority.PRIORITY_LOWEST;

    docShell.allowMedia = false;
    docShell.allowPlugins = false;
    docShell.allowContentRetargeting = false;
    let defaultFlags =
      Ci.nsIRequest.LOAD_ANONYMOUS |
      Ci.nsIRequest.LOAD_BYPASS_CACHE |
      Ci.nsIRequest.INHIBIT_CACHING;
    docShell.defaultLoadFlags = defaultFlags;
    BrowsingContext.getFromWindow(
      content
    ).sandboxFlags |= SANDBOXED_AUXILIARY_NAVIGATION;
    docShell.useTrackingProtection = true;

    addMessageListener(
      "BackgroundPageThumbs:capture",
      this._onCapture.bind(this)
    );
    docShell
      .QueryInterface(Ci.nsIInterfaceRequestor)
      .getInterface(Ci.nsIWebProgress)
      .addProgressListener(this, Ci.nsIWebProgress.NOTIFY_STATE_WINDOW);
  },

  observe(subj, topic, data) {
    // Arrange to prevent (most) popup dialogs for this window - popups done
    // in the parent (eg, auth) aren't prevented, but alert() etc are.
    // disableDialogs only works on the current inner window, so it has
    // to be called every page load, but before scripts run.
    if (content && subj == content.document) {
      content.windowUtils.disableDialogs();
    }
  },

  get _webNav() {
    return docShell.QueryInterface(Ci.nsIWebNavigation);
  },

  _onCapture(msg) {
    this._nextCapture = {
      id: msg.data.id,
      url: msg.data.url,
      isImage: msg.data.isImage,
      targetWidth: msg.data.targetWidth,
      backgroundColor: msg.data.backgroundColor,
    };
    if (this._currentCapture) {
      if (this._state == STATE_LOADING) {
        // Cancel the current capture.
        this._state = STATE_CANCELED;
        this._loadAboutBlank();
      }
      // Let the current capture finish capturing, or if it was just canceled,
      // wait for onStateChange due to the about:blank load.
      return;
    }
    this._startNextCapture();
  },

  _startNextCapture() {
    if (!this._nextCapture) {
      return;
    }
    this._currentCapture = this._nextCapture;
    delete this._nextCapture;
    this._state = STATE_LOADING;
    this._currentCapture.pageLoadStartDate = new Date();

    try {
      // Bug 1498603 verify usages of systemPrincipal here
      let loadURIOptions = {
        triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
        loadFlags: Ci.nsIWebNavigation.LOAD_FLAGS_STOP_CONTENT,
      };
      this._webNav.loadURI(this._currentCapture.url, loadURIOptions);
    } catch (e) {
      this._failCurrentCapture("BAD_URI");
    }
  },

  onStateChange(webProgress, req, flags, status) {
    if (
      webProgress.isTopLevel &&
      flags & Ci.nsIWebProgressListener.STATE_STOP &&
      this._currentCapture
    ) {
      if (req.name == "about:blank") {
        if (this._state == STATE_CAPTURING) {
          // about:blank has loaded, ending the current capture.
          this._finishCurrentCapture();
          delete this._currentCapture;
          this._startNextCapture();
        } else if (this._state == STATE_CANCELED) {
          delete this._currentCapture;
          this._startNextCapture();
        }
      } else if (
        this._state == STATE_LOADING &&
        (Components.isSuccessCode(status) || status === Cr.NS_BINDING_ABORTED)
      ) {
        let waitTime = Cu.isInAutomation
          ? TESTING_SETTLE_WAIT_TIME
          : SETTLE_WAIT_TIME;
        // The requested page has loaded or stopped/aborted, so capture the page
        // soon but first let it settle in case of in-page redirects
        if (this._captureTimer) {
          // There was additional activity, so restart the wait timer
          this._captureTimer.delay = waitTime;
        } else {
          // Stay in LOADING until we're actually ready to be CAPTURING
          this._captureTimer = Cc["@mozilla.org/timer;1"].createInstance(
            Ci.nsITimer
          );
          this._captureTimer.init(
            () => {
              this._state = STATE_CAPTURING;
              this._captureCurrentPage();
              delete this._captureTimer;
            },
            waitTime,
            Ci.nsITimer.TYPE_ONE_SHOT
          );
        }
      } else if (this._state != STATE_CANCELED) {
        // Something went wrong.  Cancel the capture.  Loading about:blank
        // while onStateChange is still on the stack does not actually stop
        // the request if it redirects, so do it asyncly.
        this._state = STATE_CANCELED;
        if (!this._cancelTimer) {
          this._cancelTimer = Cc["@mozilla.org/timer;1"].createInstance(
            Ci.nsITimer
          );
          this._cancelTimer.init(
            () => {
              this._loadAboutBlank();
              delete this._cancelTimer;
            },
            0,
            Ci.nsITimer.TYPE_ONE_SHOT
          );
        }
      }
    }
  },

  _captureCurrentPage() {
    const doCapture = async () => {
      let capture = this._currentCapture;
      capture.finalURL = this._webNav.currentURI.spec;
      capture.pageLoadTime = new Date() - capture.pageLoadStartDate;

      let canvasDrawDate = new Date();

      docShell.isActive = true;

      let finalCanvas;
      if (
        capture.isImage ||
        content.document instanceof content.ImageDocument
      ) {
        finalCanvas = await PageThumbUtils.createImageThumbnailCanvas(
          content,
          capture.url,
          capture.targetWidth,
          capture.backgroundColor
        );
      } else {
        finalCanvas = PageThumbUtils.createSnapshotThumbnail(content, null);
      }

      docShell.isActive = false;
      capture.canvasDrawTime = new Date() - canvasDrawDate;

      finalCanvas.toBlob(blob => {
        capture.imageBlob = new Blob([blob]);
        // Load about:blank to finish the capture and wait for onStateChange.
        this._loadAboutBlank();
      });
    };
    let win = docShell.domWindow;

    let runCapture = () => {
      doCapture().catch(ex => this._failCurrentCapture(ex.message));
    };

    // When testing, especially on debug builds, this idle callback might
    // be called too late (or never called at all - see bug 1596781), and
    // the test will time out. So if we're running in automation, we begin
    // the capture on the next tick.
    if (Cu.isInAutomation) {
      Services.tm.dispatchToMainThread(runCapture);
    } else {
      win.requestIdleCallback(runCapture);
    }
  },

  _finishCurrentCapture() {
    let capture = this._currentCapture;
    let fileReader = new FileReader();
    fileReader.onloadend = () => {
      sendAsyncMessage("BackgroundPageThumbs:didCapture", {
        id: capture.id,
        imageData: fileReader.result,
        finalURL: capture.finalURL,
        telemetry: {
          CAPTURE_PAGE_LOAD_TIME_MS: capture.pageLoadTime,
          CAPTURE_CANVAS_DRAW_TIME_MS: capture.canvasDrawTime,
        },
      });
    };
    fileReader.readAsArrayBuffer(capture.imageBlob);
  },

  _failCurrentCapture(reason) {
    let capture = this._currentCapture;
    sendAsyncMessage("BackgroundPageThumbs:didCapture", {
      id: capture.id,
      failReason: reason,
    });
    delete this._currentCapture;
    this._startNextCapture();
  },

  // We load about:blank to finish all captures, even canceled captures.  Two
  // reasons: GC the captured page, and ensure it can't possibly load any more
  // resources.
  _loadAboutBlank: function _loadAboutBlank() {
    // It's possible we've been destroyed by now, if so don't do anything:
    if (!docShell) {
      return;
    }
    let loadURIOptions = {
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
      loadFlags: Ci.nsIWebNavigation.LOAD_FLAGS_STOP_CONTENT,
    };
    this._webNav.loadURI("about:blank", loadURIOptions);
  },

  QueryInterface: ChromeUtils.generateQI([
    Ci.nsIWebProgressListener,
    Ci.nsISupportsWeakReference,
    Ci.nsIObserver,
  ]),
};

backgroundPageThumbsContent.init();
