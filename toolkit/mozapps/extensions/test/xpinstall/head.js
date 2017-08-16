/* eslint no-unused-vars: ["error", {vars: "local", args: "none"}] */

const RELATIVE_DIR = "toolkit/mozapps/extensions/test/xpinstall/";

const TESTROOT = "http://example.com/browser/" + RELATIVE_DIR;
const TESTROOT2 = "http://example.org/browser/" + RELATIVE_DIR;
const XPINSTALL_URL = "chrome://mozapps/content/xpinstall/xpinstallConfirm.xul";
const PROMPT_URL = "chrome://global/content/commonDialog.xul";
const ADDONS_URL = "chrome://mozapps/content/extensions/extensions.xul";
const PREF_LOGGING_ENABLED = "extensions.logging.enabled";
const PREF_INSTALL_REQUIREBUILTINCERTS = "extensions.install.requireBuiltInCerts";
const PREF_INSTALL_REQUIRESECUREORIGIN = "extensions.install.requireSecureOrigin";
const PREF_CUSTOM_CONFIRMATION_UI = "xpinstall.customConfirmationUI";
const CHROME_NAME = "mochikit";

function getChromeRoot(path) {
  if (path === undefined) {
    return "chrome://" + CHROME_NAME + "/content/browser/" + RELATIVE_DIR
  }
  return getRootDirectory(path);
}

function extractChromeRoot(path) {
  var chromeRootPath = getChromeRoot(path);
  var jar = getJar(chromeRootPath);
  if (jar) {
    var tmpdir = extractJarToTmp(jar);
    return "file://" + tmpdir.path + "/";
  }
  return chromeRootPath;
}

Services.prefs.setBoolPref(PREF_CUSTOM_CONFIRMATION_UI, false);
registerCleanupFunction(() => {
  Services.prefs.clearUserPref(PREF_CUSTOM_CONFIRMATION_UI);
});

/**
 * This is a test harness designed to handle responding to UI during the process
 * of installing an XPI. A test can set callbacks to hear about specific parts
 * of the sequence.
 * Before use setup must be called and finish must be called afterwards.
 */
var Harness = {
  // If set then the callback is called when an install is attempted and
  // software installation is disabled.
  installDisabledCallback: null,
  // If set then the callback is called when an install is attempted and
  // then canceled.
  installCancelledCallback: null,
  // If set then the callback will be called when an install's origin is blocked.
  installOriginBlockedCallback: null,
  // If set then the callback will be called when an install is blocked by the
  // whitelist. The callback should return true to continue with the install
  // anyway.
  installBlockedCallback: null,
  // If set will be called in the event of authentication being needed to get
  // the xpi. Should return a 2 element array of username and password, or
  // null to not authenticate.
  authenticationCallback: null,
  // If set this will be called to allow checking the contents of the xpinstall
  // confirmation dialog. The callback should return true to continue the install.
  installConfirmCallback: null,
  // If set will be called when downloading of an item has begun.
  downloadStartedCallback: null,
  // If set will be called during the download of an item.
  downloadProgressCallback: null,
  // If set will be called when an xpi fails to download.
  downloadFailedCallback: null,
  // If set will be called when an xpi download is cancelled.
  downloadCancelledCallback: null,
  // If set will be called when downloading of an item has ended.
  downloadEndedCallback: null,
  // If set will be called when installation by the extension manager of an xpi
  // item starts
  installStartedCallback: null,
  // If set will be called when an xpi fails to install.
  installFailedCallback: null,
  // If set will be called when each xpi item to be installed completes
  // installation.
  installEndedCallback: null,
  // If set will be called when all triggered items are installed or the install
  // is canceled.
  installsCompletedCallback: null,
  // If set the harness will wait for this DOM event before calling
  // installsCompletedCallback
  finalContentEvent: null,

  waitingForEvent: false,
  pendingCount: null,
  installCount: null,
  runningInstalls: null,

  waitingForFinish: false,

  // A unique value to return from the installConfirmCallback to indicate that
  // the install UI shouldn't be closed automatically
  leaveOpen: {},

  // Setup and tear down functions
  setup() {
    if (!this.waitingForFinish) {
      waitForExplicitFinish();
      this.waitingForFinish = true;

      Services.prefs.setBoolPref(PREF_INSTALL_REQUIRESECUREORIGIN, false);

      Services.prefs.setBoolPref(PREF_LOGGING_ENABLED, true);
      Services.obs.addObserver(this, "addon-install-started");
      Services.obs.addObserver(this, "addon-install-disabled");
      // XXX this breaks a bunch of stuff, see comment in onInstallCancelled
      // Services.obs.addObserver(this, "addon-install-cancelled", false);
      Services.obs.addObserver(this, "addon-install-origin-blocked");
      Services.obs.addObserver(this, "addon-install-blocked");
      Services.obs.addObserver(this, "addon-install-failed");
      Services.obs.addObserver(this, "addon-install-complete");

      AddonManager.addInstallListener(this);

      Services.wm.addListener(this);

      var self = this;
      registerCleanupFunction(function() {
        Services.prefs.clearUserPref(PREF_LOGGING_ENABLED);
        Services.prefs.clearUserPref(PREF_INSTALL_REQUIRESECUREORIGIN);
        Services.obs.removeObserver(self, "addon-install-started");
        Services.obs.removeObserver(self, "addon-install-disabled");
        // Services.obs.removeObserver(self, "addon-install-cancelled");
        Services.obs.removeObserver(self, "addon-install-origin-blocked");
        Services.obs.removeObserver(self, "addon-install-blocked");
        Services.obs.removeObserver(self, "addon-install-failed");
        Services.obs.removeObserver(self, "addon-install-complete");

        AddonManager.removeInstallListener(self);

        Services.wm.removeListener(self);

        AddonManager.getAllInstalls(function(aInstalls) {
          is(aInstalls.length, 0, "Should be no active installs at the end of the test");
          aInstalls.forEach(function(aInstall) {
            info("Install for " + aInstall.sourceURI + " is in state " + aInstall.state);
            aInstall.cancel();
          });
        });
      });
    }

    this.installCount = 0;
    this.pendingCount = 0;
    this.runningInstalls = [];
  },

  finish() {
    finish();
  },

  endTest() {
    let callback = this.installsCompletedCallback;
    let count = this.installCount;

    is(this.runningInstalls.length, 0, "Should be no running installs left");
    this.runningInstalls.forEach(function(aInstall) {
      info("Install for " + aInstall.sourceURI + " is in state " + aInstall.state);
    });

    this.installOriginBlockedCallback = null;
    this.installBlockedCallback = null;
    this.authenticationCallback = null;
    this.installConfirmCallback = null;
    this.downloadStartedCallback = null;
    this.downloadProgressCallback = null;
    this.downloadCancelledCallback = null;
    this.downloadFailedCallback = null;
    this.downloadEndedCallback = null;
    this.installStartedCallback = null;
    this.installFailedCallback = null;
    this.installEndedCallback = null;
    this.installsCompletedCallback = null;
    this.runningInstalls = null;

    if (callback)
      executeSoon(() => callback(count));
  },

  // Window open handling
  windowReady(window) {
    if (window.document.location.href == XPINSTALL_URL) {
      if (this.installBlockedCallback)
        ok(false, "Should have been blocked by the whitelist");
      this.pendingCount = window.document.getElementById("itemList").childNodes.length;

      // If there is a confirm callback then its return status determines whether
      // to install the items or not. If not the test is over.
      let result = true;
      if (this.installConfirmCallback) {
        result = this.installConfirmCallback(window);
        if (result === this.leaveOpen)
          return;
      }

      if (!result) {
        window.document.documentElement.cancelDialog();
      } else {
        // Initially the accept button is disabled on a countdown timer
        var button = window.document.documentElement.getButton("accept");
        button.disabled = false;
        window.document.documentElement.acceptDialog();
      }
    } else if (window.document.location.href == PROMPT_URL) {
        var promptType = window.args.promptType;
        switch (promptType) {
          case "alert":
          case "alertCheck":
          case "confirmCheck":
          case "confirm":
          case "confirmEx":
                window.document.documentElement.acceptDialog();
                break;
          case "promptUserAndPass":
                  // This is a login dialog, hopefully an authentication prompt
                  // for the xpi.
                  if (this.authenticationCallback) {
                    var auth = this.authenticationCallback();
                    if (auth && auth.length == 2) {
                      window.document.getElementById("loginTextbox").value = auth[0];
                      window.document.getElementById("password1Textbox").value = auth[1];
                      window.document.documentElement.acceptDialog();
                    } else {
                      window.document.documentElement.cancelDialog();
                    }
                  } else {
                    window.document.documentElement.cancelDialog();
                  }
                break;
          default:
                ok(false, "prompt type " + promptType + " not handled in test.");
                break;
      }
    }
  },

  // Install blocked handling

  installDisabled(installInfo) {
    ok(!!this.installDisabledCallback, "Installation shouldn't have been disabled");
    if (this.installDisabledCallback)
      this.installDisabledCallback(installInfo);
    this.expectingCancelled = true;
    this.expectingCancelled = false;
    this.endTest();
  },

  installCancelled(installInfo) {
    if (this.expectingCancelled)
      return;

    ok(!!this.installCancelledCallback, "Installation shouldn't have been cancelled");
    if (this.installCancelledCallback)
      this.installCancelledCallback(installInfo);
    this.endTest();
  },

  installOriginBlocked(installInfo) {
    ok(!!this.installOriginBlockedCallback, "Shouldn't have been blocked");
    if (this.installOriginBlockedCallback)
      this.installOriginBlockedCallback(installInfo);
    this.endTest();
  },

  installBlocked(installInfo) {
    ok(!!this.installBlockedCallback, "Shouldn't have been blocked by the whitelist");
    if (this.installBlockedCallback && this.installBlockedCallback(installInfo)) {
      this.installBlockedCallback = null;
      installInfo.install();
    } else {
      this.expectingCancelled = true;
      installInfo.installs.forEach(function(install) {
        install.cancel();
      });
      this.expectingCancelled = false;
      this.endTest();
    }
  },

  // nsIWindowMediatorListener

  onWindowTitleChange(window, title) {
  },

  onOpenWindow(window) {
    var domwindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                          .getInterface(Components.interfaces.nsIDOMWindow);
    var self = this;
    waitForFocus(function() {
      self.windowReady(domwindow);
    }, domwindow);
  },

  onCloseWindow(window) {
  },

  // Addon Install Listener

  onNewInstall(install) {
    this.runningInstalls.push(install);

    if (this.finalContentEvent && !this.waitingForEvent) {
      this.waitingForEvent = true;
      info("Waiting for " + this.finalContentEvent);
      let mm = gBrowser.selectedBrowser.messageManager;
      mm.loadFrameScript(`data:,content.addEventListener("${this.finalContentEvent}", () => { sendAsyncMessage("Test:GotNewInstallEvent"); });`, false);
      let listener = () => {
        info("Saw " + this.finalContentEvent);
        mm.removeMessageListener("Test:GotNewInstallEvent", listener);
        this.waitingForEvent = false;
        if (this.pendingCount == 0)
          this.endTest();
      }
      mm.addMessageListener("Test:GotNewInstallEvent", listener);
    }
  },

  onDownloadStarted(install) {
    this.pendingCount++;
    if (this.downloadStartedCallback)
      this.downloadStartedCallback(install);
  },

  onDownloadProgress(install) {
    if (this.downloadProgressCallback)
      this.downloadProgressCallback(install);
  },

  onDownloadEnded(install) {
    if (this.downloadEndedCallback)
      this.downloadEndedCallback(install);
  },

  onDownloadCancelled(install) {
    isnot(this.runningInstalls.indexOf(install), -1,
          "Should only see cancelations for started installs");
    this.runningInstalls.splice(this.runningInstalls.indexOf(install), 1);

    if (this.downloadCancelledCallback)
      this.downloadCancelledCallback(install);
    this.checkTestEnded();
  },

  onDownloadFailed(install) {
    if (this.downloadFailedCallback)
      this.downloadFailedCallback(install);
    this.checkTestEnded();
  },

  onInstallStarted(install) {
    if (this.installStartedCallback)
      this.installStartedCallback(install);
  },

  onInstallEnded(install, addon) {
    if (this.installEndedCallback)
      this.installEndedCallback(install, addon);
    this.installCount++;
    this.checkTestEnded();
  },

  onInstallFailed(install) {
    if (this.installFailedCallback)
      this.installFailedCallback(install);
    this.checkTestEnded();
  },

  onInstallCancelled(install) {
    // This is ugly.  We have a bunch of tests that cancel installs
    // but don't expect this event to be raised (they also don't
    // expecte addon-install-cancelled to be raised but even though
    // we have code to handle that, it is never attached, see setup() above)
    // For at least one test (browser_whitelist3.js), we used to generate
    // onDownloadCancelled when the user cancelled the installation at the
    // confirmation prompt.  We're now generating onInstallCancelled instead
    // of onDownloadCancelled but making this code unconditional breaks a
    // bunch of other tests.  Ugh.
    let idx = this.runningInstalls.indexOf(install);
    if (idx != -1) {
      this.runningInstalls.splice(this.runningInstalls.indexOf(install), 1);
      this.checkTestEnded();
    }
  },

  checkTestEnded() {
    if (--this.pendingCount == 0 && !this.waitingForEvent)
      this.endTest();
  },

  // nsIObserver

  observe(subject, topic, data) {
    var installInfo = subject.wrappedJSObject;
    switch (topic) {
    case "addon-install-started":
      is(this.runningInstalls.length, installInfo.installs.length,
         "Should have seen the expected number of installs started");
      break;
    case "addon-install-disabled":
      this.installDisabled(installInfo);
      break;
    case "addon-install-cancelled":
      this.installCancelled(installInfo);
      break;
    case "addon-install-origin-blocked":
      this.installOriginBlocked(installInfo);
      break;
    case "addon-install-blocked":
      this.installBlocked(installInfo);
      break;
    case "addon-install-failed":
      installInfo.installs.forEach(function(aInstall) {
        isnot(this.runningInstalls.indexOf(aInstall), -1,
              "Should only see failures for started installs");

        ok(aInstall.error != 0 || aInstall.addon.appDisabled,
           "Failed installs should have an error or be appDisabled");

        this.runningInstalls.splice(this.runningInstalls.indexOf(aInstall), 1);
      }, this);
      break;
    case "addon-install-complete":
      installInfo.installs.forEach(function(aInstall) {
        isnot(this.runningInstalls.indexOf(aInstall), -1,
              "Should only see completed events for started installs");

        is(aInstall.error, 0, "Completed installs should have no error");
        ok(!aInstall.appDisabled, "Completed installs should not be appDisabled");

        // Complete installs are either in the INSTALLED or CANCELLED state
        // since the test may cancel installs the moment they complete.
        ok(aInstall.state == AddonManager.STATE_INSTALLED ||
           aInstall.state == AddonManager.STATE_CANCELLED,
           "Completed installs should be in the right state");

        this.runningInstalls.splice(this.runningInstalls.indexOf(aInstall), 1);
      }, this);
      break;
    }
  },

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
                                         Ci.nsIWindowMediatorListener,
                                         Ci.nsISupports])
}
