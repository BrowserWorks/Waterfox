/* -*- mode: js; indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["ProcessHangMonitor"];

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

/**
 * This JSM is responsible for observing content process hang reports
 * and asking the user what to do about them. See nsIHangReport for
 * the platform interface.
 */

var ProcessHangMonitor = {
  /**
   * This timeout is the wait period applied after a user selects "Wait" in
   * an existing notification.
   */
  get WAIT_EXPIRATION_TIME() {
    try {
      return Services.prefs.getIntPref("browser.hangNotification.waitPeriod");
    } catch (ex) {
      return 10000;
    }
  },

  /**
   * Should only be set to true once the quit-application-granted notification
   * has been fired.
   */
  _shuttingDown: false,

  /**
   * Collection of hang reports that haven't expired or been dismissed
   * by the user. These are nsIHangReports.
   */
  _activeReports: new Set(),

  /**
   * Collection of hang reports that have been suppressed for a short
   * period of time. Value is an nsITimer for when the wait time
   * expires.
   */
  _pausedReports: new Map(),

  /**
   * Initialize hang reporting. Called once in the parent process.
   */
  init() {
    Services.obs.addObserver(this, "process-hang-report");
    Services.obs.addObserver(this, "clear-hang-report");
    Services.obs.addObserver(this, "quit-application-granted");
    Services.obs.addObserver(this, "xpcom-shutdown");
    Services.ww.registerNotification(this);
  },

  /**
   * Terminate JavaScript associated with the hang being reported for
   * the selected browser in |win|.
   */
  terminateScript(win) {
    this.handleUserInput(win, report => report.terminateScript());
  },

  /**
   * Terminate Sandbox globals associated with the hang being reported
   * for the selected browser in |win|.
   */
  terminateGlobal(win) {
    this.handleUserInput(win, report => report.terminateGlobal());
  },

  /**
   * Start devtools debugger for JavaScript associated with the hang
   * being reported for the selected browser in |win|.
   */
  debugScript(win) {
    this.handleUserInput(win, report => {
      function callback() {
        report.endStartingDebugger();
      }

      report.beginStartingDebugger();

      let svc = Cc["@mozilla.org/dom/slow-script-debug;1"].getService(
        Ci.nsISlowScriptDebug
      );
      let handler = svc.remoteActivationHandler;
      handler.handleSlowScriptDebug(report.scriptBrowser, callback);
    });
  },

  /**
   * Terminate the plugin process associated with a hang being reported
   * for the selected browser in |win|. Will attempt to generate a combined
   * crash report for all processes.
   */
  terminatePlugin(win) {
    this.handleUserInput(win, report => report.terminatePlugin());
  },

  /**
   * Dismiss the browser notification and invoke an appropriate action based on
   * the hang type.
   */
  stopIt(win) {
    let report = this.findActiveReport(win.gBrowser.selectedBrowser);
    if (!report) {
      return;
    }

    switch (report.hangType) {
      case report.SLOW_SCRIPT:
        this.terminateScript(win);
        break;
      case report.PLUGIN_HANG:
        this.terminatePlugin(win);
        break;
    }
  },

  /**
   * Stop all scripts from running in the Sandbox global attached to
   * this window.
   */
  stopGlobal(win) {
    let report = this.findActiveReport(win.gBrowser.selectedBrowser);
    if (!report) {
      return;
    }

    switch (report.hangType) {
      case report.SLOW_SCRIPT:
        this.terminateGlobal(win);
        break;
    }
  },

  /**
   * Terminate whatever is causing this report, be it an add-on, page script,
   * or plug-in. This is done without updating any report notifications.
   */
  stopHang(report) {
    switch (report.hangType) {
      case report.SLOW_SCRIPT: {
        if (report.addonId) {
          report.terminateGlobal();
        } else {
          report.terminateScript();
        }
        break;
      }
      case report.PLUGIN_HANG: {
        report.terminatePlugin();
        break;
      }
    }
  },

  /**
   * Dismiss the notification, clear the report from the active list and set up
   * a new timer to track a wait period during which we won't notify.
   */
  waitLonger(win) {
    let report = this.findActiveReport(win.gBrowser.selectedBrowser);
    if (!report) {
      return;
    }
    // Remove the report from the active list.
    this.removeActiveReport(report);

    // NOTE, we didn't call userCanceled on nsIHangReport here. This insures
    // we don't repeatedly generate and cache crash report data for this hang
    // in the process hang reporter. It already has one report for the browser
    // process we want it hold onto.

    // Create a new wait timer with notify callback
    let timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    timer.initWithCallback(
      () => {
        for (let [stashedReport, otherTimer] of this._pausedReports) {
          if (otherTimer === timer) {
            this.removePausedReport(stashedReport);

            // We're still hung, so move the report back to the active
            // list and update the UI.
            this._activeReports.add(report);
            this.updateWindows();
            break;
          }
        }
      },
      this.WAIT_EXPIRATION_TIME,
      timer.TYPE_ONE_SHOT
    );

    this._pausedReports.set(report, timer);

    // remove the browser notification associated with this hang
    this.updateWindows();
  },

  /**
   * If there is a hang report associated with the selected browser in
   * |win|, invoke |func| on that report and stop notifying the user
   * about it.
   */
  handleUserInput(win, func) {
    let report = this.findActiveReport(win.gBrowser.selectedBrowser);
    if (!report) {
      return null;
    }
    this.removeActiveReport(report);

    return func(report);
  },

  observe(subject, topic, data) {
    switch (topic) {
      case "xpcom-shutdown": {
        Services.obs.removeObserver(this, "xpcom-shutdown");
        Services.obs.removeObserver(this, "process-hang-report");
        Services.obs.removeObserver(this, "clear-hang-report");
        Services.obs.removeObserver(this, "quit-application-granted");
        Services.ww.unregisterNotification(this);
        break;
      }

      case "quit-application-granted": {
        this.onQuitApplicationGranted();
        break;
      }

      case "process-hang-report": {
        this.reportHang(subject.QueryInterface(Ci.nsIHangReport));
        break;
      }

      case "clear-hang-report": {
        this.clearHang(subject.QueryInterface(Ci.nsIHangReport));
        break;
      }

      case "domwindowopened": {
        // Install event listeners on the new window in case one of
        // its tabs is already hung.
        let win = subject;
        let listener = ev => {
          win.removeEventListener("load", listener, true);
          this.updateWindows();
        };
        win.addEventListener("load", listener, true);
        break;
      }

      case "domwindowclosed": {
        let win = subject;
        this.onWindowClosed(win);
        break;
      }
    }
  },

  /**
   * Called early on in the shutdown sequence. We take this opportunity to
   * take any pre-existing hang reports, and terminate them. We also put
   * ourselves in a state so that if any more hang reports show up while
   * we're shutting down, we terminate them immediately.
   */
  onQuitApplicationGranted() {
    this._shuttingDown = true;
    this.stopAllHangs();
    this.updateWindows();
  },

  onWindowClosed(win) {
    let maybeStopHang = report => {
      if (report.hangType == report.SLOW_SCRIPT) {
        let hungBrowserWindow = null;
        try {
          hungBrowserWindow = report.scriptBrowser.ownerGlobal;
        } catch (e) {
          // Ignore failures to get the script browser - we'll be
          // conservative, and assume that if we cannot access the
          // window that belongs to this report that we should stop
          // the hang.
        }
        if (!hungBrowserWindow || hungBrowserWindow == win) {
          this.stopHang(report);
          return true;
        }
      } else if (report.hangType == report.PLUGIN_HANG) {
        // If any window has closed during a plug-in hang, we'll
        // do the conservative thing and terminate the plug-in.
        this.stopHang(report);
        return true;
      }
      return false;
    };

    // If there are any script hangs for browsers that are in this window
    // that is closing, we can stop them now.
    for (let report of this._activeReports) {
      if (maybeStopHang(report)) {
        this._activeReports.delete(report);
      }
    }

    for (let [pausedReport] of this._pausedReports) {
      if (maybeStopHang(pausedReport)) {
        this.removePausedReport(pausedReport);
      }
    }

    this.updateWindows();
  },

  stopAllHangs() {
    for (let report of this._activeReports) {
      this.stopHang(report);
    }

    this._activeReports = new Set();

    for (let [pausedReport] of this._pausedReports) {
      this.stopHang(pausedReport);
      this.removePausedReport(pausedReport);
    }
  },

  /**
   * Find a active hang report for the given <browser> element.
   */
  findActiveReport(browser) {
    let frameLoader = browser.frameLoader;
    for (let report of this._activeReports) {
      if (report.isReportForBrowser(frameLoader)) {
        return report;
      }
    }
    return null;
  },

  /**
   * Find a paused hang report for the given <browser> element.
   */
  findPausedReport(browser) {
    let frameLoader = browser.frameLoader;
    for (let [report] of this._pausedReports) {
      if (report.isReportForBrowser(frameLoader)) {
        return report;
      }
    }
    return null;
  },

  /**
   * Remove an active hang report from the active list and cancel the timer
   * associated with it.
   */
  removeActiveReport(report) {
    this._activeReports.delete(report);
    this.updateWindows();
  },

  /**
   * Remove a paused hang report from the paused list and cancel the timer
   * associated with it.
   */
  removePausedReport(report) {
    let timer = this._pausedReports.get(report);
    if (timer) {
      timer.cancel();
    }
    this._pausedReports.delete(report);
  },

  /**
   * Iterate over all XUL windows and ensure that the proper hang
   * reports are shown for each one. Also install event handlers in
   * each window to watch for events that would cause a different hang
   * report to be displayed.
   */
  updateWindows() {
    let e = Services.wm.getEnumerator("navigator:browser");

    // If it turns out we have no windows (this can happen on macOS),
    // we have no opportunity to ask the user whether or not they want
    // to stop the hang or wait, so we'll opt for stopping the hang.
    if (!e.hasMoreElements()) {
      this.stopAllHangs();
      return;
    }

    for (let win of e) {
      this.updateWindow(win);

      // Only listen for these events if there are active hang reports.
      if (this._activeReports.size) {
        this.trackWindow(win);
      } else {
        this.untrackWindow(win);
      }
    }
  },

  /**
   * If there is a hang report for the current tab in |win|, display it.
   */
  updateWindow(win) {
    let report = this.findActiveReport(win.gBrowser.selectedBrowser);

    if (report) {
      this.showNotification(win, report);
    } else {
      this.hideNotification(win);
    }
  },

  /**
   * Show the notification for a hang.
   */
  showNotification(win, report) {
    let notification = win.gHighPriorityNotificationBox.getNotificationWithValue(
      "process-hang"
    );
    if (notification) {
      return;
    }

    let bundle = win.gNavigatorBundle;

    let buttons = [
      {
        label: bundle.getString("processHang.button_stop.label"),
        accessKey: bundle.getString("processHang.button_stop.accessKey"),
        callback() {
          ProcessHangMonitor.stopIt(win);
        },
      },
      {
        label: bundle.getString("processHang.button_wait.label"),
        accessKey: bundle.getString("processHang.button_wait.accessKey"),
        callback() {
          ProcessHangMonitor.waitLonger(win);
        },
      },
    ];

    let message = bundle.getString("processHang.label");
    if (report.addonId) {
      let aps = Cc["@mozilla.org/addons/policy-service;1"].getService(
        Ci.nsIAddonPolicyService
      );

      let doc = win.document;
      let brandBundle = doc.getElementById("bundle_brand");

      let addonName = aps.getExtensionName(report.addonId);

      let label = bundle.getFormattedString("processHang.add-on.label", [
        addonName,
        brandBundle.getString("brandShortName"),
      ]);

      let linkText = bundle.getString("processHang.add-on.learn-more.text");
      let linkURL =
        "https://support.mozilla.org/kb/warning-unresponsive-script#w_other-causes";

      let link = doc.createXULElement("label", { is: "text-link" });
      link.setAttribute("role", "link");
      link.setAttribute(
        "onclick",
        `openTrustedLinkIn(${JSON.stringify(linkURL)}, "tab")`
      );
      link.setAttribute("value", linkText);

      message = doc.createDocumentFragment();
      message.appendChild(doc.createTextNode(label + " "));
      message.appendChild(link);

      buttons.unshift({
        label: bundle.getString("processHang.button_stop_sandbox.label"),
        accessKey: bundle.getString(
          "processHang.button_stop_sandbox.accessKey"
        ),
        callback() {
          ProcessHangMonitor.stopGlobal(win);
        },
      });
    }

    if (AppConstants.MOZ_DEV_EDITION && report.hangType == report.SLOW_SCRIPT) {
      buttons.push({
        label: bundle.getString("processHang.button_debug.label"),
        accessKey: bundle.getString("processHang.button_debug.accessKey"),
        callback() {
          ProcessHangMonitor.debugScript(win);
        },
      });
    }

    win.gHighPriorityNotificationBox.appendNotification(
      message,
      "process-hang",
      "chrome://browser/content/aboutRobots-icon.png",
      win.gHighPriorityNotificationBox.PRIORITY_WARNING_HIGH,
      buttons
    );
  },

  /**
   * Ensure that no hang notifications are visible in |win|.
   */
  hideNotification(win) {
    let notification = win.gHighPriorityNotificationBox.getNotificationWithValue(
      "process-hang"
    );
    if (notification) {
      win.gHighPriorityNotificationBox.removeNotification(notification);
    }
  },

  /**
   * Install event handlers on |win| to watch for events that would
   * cause a different hang report to be displayed.
   */
  trackWindow(win) {
    win.gBrowser.tabContainer.addEventListener("TabSelect", this, true);
    win.gBrowser.tabContainer.addEventListener(
      "TabRemotenessChange",
      this,
      true
    );
  },

  untrackWindow(win) {
    win.gBrowser.tabContainer.removeEventListener("TabSelect", this, true);
    win.gBrowser.tabContainer.removeEventListener(
      "TabRemotenessChange",
      this,
      true
    );
  },

  handleEvent(event) {
    let win = event.target.ownerGlobal;

    // If a new tab is selected or if a tab changes remoteness, then
    // we may need to show or hide a hang notification.

    if (event.type == "TabSelect" || event.type == "TabRemotenessChange") {
      this.updateWindow(win);
    }
  },

  /**
   * Handle a potentially new hang report. If it hasn't been seen
   * before, show a notification for it in all open XUL windows.
   */
  reportHang(report) {
    if (this._shuttingDown) {
      this.stopHang(report);
      return;
    }

    // If this hang was already reported reset the timer for it.
    if (this._activeReports.has(report)) {
      // if this report is in active but doesn't have a notification associated
      // with it, display a notification.
      this.updateWindows();
      return;
    }

    // If this hang was already reported and paused by the user ignore it.
    if (this._pausedReports.has(report)) {
      return;
    }

    // On e10s this counts slow-script/hanged-plugin notice only once.
    // This code is not reached on non-e10s.
    if (report.hangType == report.SLOW_SCRIPT) {
      // On non-e10s, SLOW_SCRIPT_NOTICE_COUNT is probed at nsGlobalWindow.cpp
      Services.telemetry.getHistogramById("SLOW_SCRIPT_NOTICE_COUNT").add();
    } else if (report.hangType == report.PLUGIN_HANG) {
      // On non-e10s we have sufficient plugin telemetry probes,
      // so PLUGIN_HANG_NOTICE_COUNT is only probed on e10s.
      Services.telemetry.getHistogramById("PLUGIN_HANG_NOTICE_COUNT").add();
    }

    this._activeReports.add(report);
    this.updateWindows();
  },

  clearHang(report) {
    this.removeActiveReport(report);
    this.removePausedReport(report);
    report.userCanceled();
  },
};
