// This file is loaded into the browser window scope.
/* eslint-env mozilla/browser-window */

// -*- tab-width: 2; indent-tabs-mode: nil; js-indent-level: 2 -*-

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * PrintUtils is a utility for front-end code to trigger common print
 * operations (printing, show print preview, show page settings).
 *
 * Unfortunately, likely due to inconsistencies in how different operating
 * systems do printing natively, our XPCOM-level printing interfaces
 * are a bit confusing and the method by which we do something basic
 * like printing a page is quite circuitous.
 *
 * To compound that, we need to support remote browsers, and that means
 * kicking off the print jobs in the content process. This means we send
 * messages back and forth to that process. browser-content.js contains
 * the object that listens and responds to the messages that PrintUtils
 * sends.
 *
 * This also means that <xul:browser>'s that hope to use PrintUtils must have
 * their type attribute set to "content".
 *
 * PrintUtils sends messages at different points in its implementation, but
 * their documentation is consolidated here for ease-of-access.
 *
 *
 * Messages sent:
 *
 *   Printing:Print
 *     Kick off a print job for a nsIDOMWindow, passing the outer window ID as
 *     windowID.
 *
 *   Printing:Preview:Enter
 *     This message is sent to put content into print preview mode. We pass
 *     the content window of the browser we're showing the preview of, and
 *     the target of the message is the browser that we'll be showing the
 *     preview in.
 *
 *   Printing:Preview:Exit
 *     This message is sent to take content out of print preview mode.
 *
 *
 * Messages Received
 *
 *   Printing:Preview:Entered
 *     This message is sent by the content process once it has completed
 *     putting the content into print preview mode. We must wait for that to
 *     to complete before switching the chrome UI to print preview mode,
 *     otherwise we have layout issues.
 *
 *   Printing:Preview:StateChange, Printing:Preview:ProgressChange
 *     Due to a timing issue resulting in a main-process crash, we have to
 *     manually open the progress dialog for print preview. The progress
 *     dialog is opened here in PrintUtils, and then we listen for update
 *     messages from the child. Bug 1088061 has been filed to investigate
 *     other solutions.
 *
 */

var gFocusedElement = null;

var PrintUtils = {
  init() {
    window.messageManager.addMessageListener("Printing:Error", this);
  },

  get _bundle() {
    delete this._bundle;
    return (this._bundle = Services.strings.createBundle(
      "chrome://global/locale/printing.properties"
    ));
  },

  /**
   * Shows the page setup dialog, and saves any settings changed in
   * that dialog if print.save_print_settings is set to true.
   *
   * @return true on success, false on failure
   */
  showPageSetup() {
    try {
      var printSettings = this.getPrintSettings();
      var PRINTPROMPTSVC = Cc[
        "@mozilla.org/embedcomp/printingprompt-service;1"
      ].getService(Ci.nsIPrintingPromptService);
      PRINTPROMPTSVC.showPageSetupDialog(window, printSettings, null);
    } catch (e) {
      dump("showPageSetup " + e + "\n");
      return false;
    }
    return true;
  },

  _getLastUsedPrinterName() {
    try {
      let PSSVC = Cc["@mozilla.org/gfx/printsettings-service;1"].getService(
        Ci.nsIPrintSettingsService
      );

      return PSSVC.lastUsedPrinterName;
    } catch (e) {
      Cu.reportError(e);
    }

    return null;
  },

  /**
   * Starts the process of printing the contents of a window.
   *
   * @param aBrowsingContext
   *        The BrowsingContext of the window to print.
   */
  printWindow(aBrowsingContext) {
    let windowID = aBrowsingContext.currentWindowGlobal.outerWindowId;
    let topBrowser = aBrowsingContext.top.embedderElement;

    const printPreviewIsOpen = !!document.getElementById(
      "print-preview-toolbar"
    );

    if (printPreviewIsOpen) {
      this._logKeyedTelemetry("PRINT_DIALOG_OPENED_COUNT", "FROM_PREVIEW");
    } else {
      this._logKeyedTelemetry("PRINT_DIALOG_OPENED_COUNT", "FROM_PAGE");
    }

    topBrowser.messageManager.sendAsyncMessage("Printing:Print", {
      windowID,
      simplifiedMode: this._shouldSimplify,
      lastUsedPrinterName: this._getLastUsedPrinterName(),
    });

    if (printPreviewIsOpen) {
      if (this._shouldSimplify) {
        this._logKeyedTelemetry("PRINT_COUNT", "SIMPLIFIED");
      } else {
        this._logKeyedTelemetry("PRINT_COUNT", "WITH_PREVIEW");
      }
    } else {
      this._logKeyedTelemetry("PRINT_COUNT", "WITHOUT_PREVIEW");
    }
  },

  /**
   * Initializes print preview.
   *
   * @param aListenerObj
   *        An object that defines the following functions:
   *
   *        getPrintPreviewBrowser:
   *          Returns the <xul:browser> to display the print preview in. This
   *          <xul:browser> must have its type attribute set to "content".
   *
   *        getSimplifiedPrintPreviewBrowser:
   *          Returns the <xul:browser> to display the simplified print preview
   *          in. This <xul:browser> must have its type attribute set to
   *          "content".
   *
   *        getSourceBrowser:
   *          Returns the <xul:browser> that contains the document being
   *          printed. This <xul:browser> must have its type attribute set to
   *          "content".
   *
   *        getSimplifiedSourceBrowser:
   *          Returns the <xul:browser> that contains the simplified version
   *          of the document being printed. This <xul:browser> must have its
   *          type attribute set to "content".
   *
   *        getNavToolbox:
   *          Returns the primary toolbox for this window.
   *
   *        onEnter:
   *          Called upon entering print preview.
   *
   *        onExit:
   *          Called upon exiting print preview.
   *
   *        These methods must be defined. printPreview can be called
   *        with aListenerObj as null iff this window is already displaying
   *        print preview (in which case, the previous aListenerObj passed
   *        to it will be used).
   */
  printPreview(aListenerObj) {
    // If we already have a toolbar someone is calling printPreview() to get us
    // to refresh the display and aListenerObj won't be passed.
    let printPreviewTB = document.getElementById("print-preview-toolbar");
    if (!printPreviewTB) {
      this._listener = aListenerObj;
      this._sourceBrowser = aListenerObj.getSourceBrowser();
      this._originalTitle = this._sourceBrowser.contentTitle;
      this._originalURL = this._sourceBrowser.currentURI.spec;

      // Here we log telemetry data for when the user enters print preview.
      this.logTelemetry("PRINT_PREVIEW_OPENED_COUNT");
    } else {
      // Disable toolbar elements that can cause another update to be triggered
      // during this update.
      printPreviewTB.disableUpdateTriggers(true);

      // collapse the browser here -- it will be shown in
      // _enterPrintPreview; this forces a reflow which fixes display
      // issues in bug 267422.
      // We use the print preview browser as the source browser to avoid
      // re-initializing print preview with a document that might now have changed.
      this._sourceBrowser = this._shouldSimplify
        ? this._listener.getSimplifiedPrintPreviewBrowser()
        : this._listener.getPrintPreviewBrowser();
      this._sourceBrowser.collapsed = true;

      // If the user transits too quickly within preview and we have a pending
      // progress dialog, we will close it before opening a new one.
      this.ensureProgressDialogClosed();
    }

    this._webProgressPP = {};
    let ppParams = {};
    let notifyOnOpen = {};
    let printSettings = this.getPrintSettings();
    // Here we get the PrintingPromptService so we can display the PP Progress from script
    // For the browser implemented via XUL with the PP toolbar we cannot let it be
    // automatically opened from the print engine because the XUL scrollbars in the PP window
    // will layout before the content window and a crash will occur.
    // Doing it all from script, means it lays out before hand and we can let printing do its own thing
    let PPROMPTSVC = Cc[
      "@mozilla.org/embedcomp/printingprompt-service;1"
    ].getService(Ci.nsIPrintingPromptService);
    // just in case we are already printing,
    // an error code could be returned if the Progress Dialog is already displayed
    try {
      PPROMPTSVC.showPrintProgressDialog(
        window,
        printSettings,
        this._obsPP,
        false,
        this._webProgressPP,
        ppParams,
        notifyOnOpen
      );
      if (ppParams.value) {
        ppParams.value.docTitle = this._originalTitle;
        ppParams.value.docURL = this._originalURL;
      }

      // this tells us whether we should continue on with PP or
      // wait for the callback via the observer
      if (!notifyOnOpen.value.valueOf() || this._webProgressPP.value == null) {
        this._enterPrintPreview();
      }
    } catch (e) {
      this._enterPrintPreview();
    }
  },

  // "private" methods and members. Don't use them.

  _listener: null,
  _closeHandlerPP: null,
  _webProgressPP: null,
  _sourceBrowser: null,
  _originalTitle: "",
  _originalURL: "",
  _shouldSimplify: false,

  _getErrorCodeForNSResult(nsresult) {
    const MSG_CODES = [
      "GFX_PRINTER_NO_PRINTER_AVAILABLE",
      "GFX_PRINTER_NAME_NOT_FOUND",
      "GFX_PRINTER_COULD_NOT_OPEN_FILE",
      "GFX_PRINTER_STARTDOC",
      "GFX_PRINTER_ENDDOC",
      "GFX_PRINTER_STARTPAGE",
      "GFX_PRINTER_DOC_IS_BUSY",
      "ABORT",
      "NOT_AVAILABLE",
      "NOT_IMPLEMENTED",
      "OUT_OF_MEMORY",
      "UNEXPECTED",
    ];

    for (let code of MSG_CODES) {
      let nsErrorResult = "NS_ERROR_" + code;
      if (Cr[nsErrorResult] == nsresult) {
        return code;
      }
    }

    // PERR_FAILURE is the catch-all error message if we've gotten one that
    // we don't recognize.
    return "FAILURE";
  },

  _displayPrintingError(nsresult, isPrinting) {
    // The nsresults from a printing error are mapped to strings that have
    // similar names to the errors themselves. For example, for error
    // NS_ERROR_GFX_PRINTER_NO_PRINTER_AVAILABLE, the name of the string
    // for the error message is: PERR_GFX_PRINTER_NO_PRINTER_AVAILABLE. What's
    // more, if we're in the process of doing a print preview, it's possible
    // that there are strings specific for print preview for these errors -
    // if so, the names of those strings have _PP as a suffix. It's possible
    // that no print preview specific strings exist, in which case it is fine
    // to fall back to the original string name.
    let msgName = "PERR_" + this._getErrorCodeForNSResult(nsresult);
    let msg, title;
    if (!isPrinting) {
      // Try first with _PP suffix.
      let ppMsgName = msgName + "_PP";
      try {
        msg = this._bundle.GetStringFromName(ppMsgName);
      } catch (e) {
        // We allow localizers to not have the print preview error string,
        // and just fall back to the printing error string.
      }
    }

    if (!msg) {
      msg = this._bundle.GetStringFromName(msgName);
    }

    title = this._bundle.GetStringFromName(
      isPrinting
        ? "print_error_dialog_title"
        : "printpreview_error_dialog_title"
    );

    Services.prompt.alert(window, title, msg);
  },

  receiveMessage(aMessage) {
    if (aMessage.name == "Printing:Error") {
      this._displayPrintingError(
        aMessage.data.nsresult,
        aMessage.data.isPrinting
      );
      Services.telemetry.keyedScalarAdd(
        "printing.error",
        this._getErrorCodeForNSResult(aMessage.data.nsresult),
        1
      );
      return undefined;
    }

    // If we got here, then the message we've received must involve
    // updating the print progress UI.
    if (!this._webProgressPP.value) {
      // We somehow didn't get a nsIWebProgressListener to be updated...
      // I guess there's nothing to do.
      return undefined;
    }

    let listener = this._webProgressPP.value;
    let mm = aMessage.target.messageManager;
    let data = aMessage.data;

    switch (aMessage.name) {
      case "Printing:Preview:ProgressChange": {
        return listener.onProgressChange(
          null,
          null,
          data.curSelfProgress,
          data.maxSelfProgress,
          data.curTotalProgress,
          data.maxTotalProgress
        );
      }

      case "Printing:Preview:StateChange": {
        if (data.stateFlags & Ci.nsIWebProgressListener.STATE_STOP) {
          // Strangely, the printing engine sends 2 STATE_STOP messages when
          // print preview is finishing. One has the STATE_IS_DOCUMENT flag,
          // the other has the STATE_IS_NETWORK flag. However, the webProgressPP
          // listener stops listening once the first STATE_STOP is sent.
          // Any subsequent messages result in NS_ERROR_FAILURE errors getting
          // thrown. This should all get torn out once bug 1088061 is fixed.
          mm.removeMessageListener("Printing:Preview:StateChange", this);
          mm.removeMessageListener("Printing:Preview:ProgressChange", this);

          // Enable toobar elements that we disabled during update.
          let printPreviewTB = document.getElementById("print-preview-toolbar");
          printPreviewTB.disableUpdateTriggers(false);
        }

        return listener.onStateChange(null, null, data.stateFlags, data.status);
      }
    }
    return undefined;
  },

  _setPrinterDefaultsForSelectedPrinter(aPSSVC, aPrintSettings) {
    if (!aPrintSettings.printerName) {
      aPrintSettings.printerName = aPSSVC.lastUsedPrinterName;
    }

    // First get any defaults from the printer
    aPSSVC.initPrintSettingsFromPrinter(
      aPrintSettings.printerName,
      aPrintSettings
    );
    // now augment them with any values from last time
    aPSSVC.initPrintSettingsFromPrefs(
      aPrintSettings,
      true,
      aPrintSettings.kInitSaveAll
    );
  },

  getPrintSettings() {
    var printSettings;
    try {
      var PSSVC = Cc["@mozilla.org/gfx/printsettings-service;1"].getService(
        Ci.nsIPrintSettingsService
      );
      printSettings = PSSVC.globalPrintSettings;
      this._setPrinterDefaultsForSelectedPrinter(PSSVC, printSettings);
    } catch (e) {
      dump("getPrintSettings: " + e + "\n");
    }
    return printSettings;
  },

  // This observer is called once the progress dialog has been "opened"
  _obsPP: {
    observe(aSubject, aTopic, aData) {
      // Only process a null topic which means the progress dialog is open.
      if (aTopic) {
        return;
      }

      // delay the print preview to show the content of the progress dialog
      setTimeout(function() {
        PrintUtils._enterPrintPreview();
      }, 0);
    },

    QueryInterface: ChromeUtils.generateQI([
      "nsIObserver",
      "nsISupportsWeakReference",
    ]),
  },

  get shouldSimplify() {
    return this._shouldSimplify;
  },

  setSimplifiedMode(shouldSimplify) {
    this._shouldSimplify = shouldSimplify;
  },

  /**
   * Currently, we create a new print preview browser to host the simplified
   * cloned-document when Simplify Page option is used on preview. To accomplish
   * this, we need to keep track of what browser should be presented, based on
   * whether the 'Simplify page' checkbox is checked.
   *
   * _ppBrowsers
   *        Set of print preview browsers.
   * _currentPPBrowser
   *        References the current print preview browser that is being presented.
   */
  _ppBrowsers: new Set(),
  _currentPPBrowser: null,

  _enterPrintPreview() {
    // Send a message to the print preview browser to initialize
    // print preview. If we happen to have gotten a print preview
    // progress listener from nsIPrintingPromptService.showPrintProgressDialog
    // in printPreview, we add listeners to feed that progress
    // listener.
    let ppBrowser = this._shouldSimplify
      ? this._listener.getSimplifiedPrintPreviewBrowser()
      : this._listener.getPrintPreviewBrowser();
    this._ppBrowsers.add(ppBrowser);

    // If we're switching from 'normal' print preview to 'simplified' print
    // preview, we will want to run reader mode against the 'normal' print
    // preview browser's content:
    let oldPPBrowser = null;
    let changingPrintPreviewBrowsers = false;
    if (this._currentPPBrowser && ppBrowser != this._currentPPBrowser) {
      changingPrintPreviewBrowsers = true;
      oldPPBrowser = this._currentPPBrowser;
    }
    this._currentPPBrowser = ppBrowser;
    let mm = ppBrowser.messageManager;
    let lastUsedPrinterName = this._getLastUsedPrinterName();

    let sendEnterPreviewMessage = function(browser, simplified) {
      mm.sendAsyncMessage("Printing:Preview:Enter", {
        windowID: browser.outerWindowID,
        simplifiedMode: simplified,
        changingBrowsers: changingPrintPreviewBrowsers,
        lastUsedPrinterName,
      });
    };

    // If we happen to have gotten simplify page checked, we will lazily
    // instantiate a new tab that parses the original page using ReaderMode
    // primitives. When it's ready, and in order to enter on preview, we send
    // over a message to print preview browser passing up the simplified tab as
    // reference. If not, we pass the original tab instead as content source.
    if (this._shouldSimplify) {
      let simplifiedBrowser = this._listener.getSimplifiedSourceBrowser();
      if (simplifiedBrowser) {
        sendEnterPreviewMessage(simplifiedBrowser, true);
      } else {
        simplifiedBrowser = this._listener.createSimplifiedBrowser();

        // After instantiating the simplified tab, we attach a listener as
        // callback. Once we discover reader mode has been loaded, we fire
        // up a message to enter on print preview.
        let spMM = simplifiedBrowser.messageManager;
        spMM.addMessageListener(
          "Printing:Preview:ReaderModeReady",
          function onReaderReady() {
            spMM.removeMessageListener(
              "Printing:Preview:ReaderModeReady",
              onReaderReady
            );
            sendEnterPreviewMessage(simplifiedBrowser, true);
          }
        );

        // Here, we send down a message to simplified browser in order to parse
        // the original page. After we have parsed it, content will tell parent
        // that the document is ready for print previewing.
        spMM.sendAsyncMessage("Printing:Preview:ParseDocument", {
          URL: this._originalURL,
          windowID: oldPPBrowser.outerWindowID,
        });

        // Here we log telemetry data for when the user enters simplify mode.
        this.logTelemetry("PRINT_PREVIEW_SIMPLIFY_PAGE_OPENED_COUNT");
      }
    } else {
      sendEnterPreviewMessage(this._sourceBrowser, false);
    }

    let waitForPrintProgressToEnableToolbar = false;
    if (this._webProgressPP.value) {
      mm.addMessageListener("Printing:Preview:StateChange", this);
      mm.addMessageListener("Printing:Preview:ProgressChange", this);
      waitForPrintProgressToEnableToolbar = true;
    }

    let onEntered = message => {
      mm.removeMessageListener("Printing:Preview:Entered", onEntered);

      if (message.data.failed) {
        // Something went wrong while putting the document into print preview
        // mode. Bail out.
        this._ppBrowsers.clear();
        this._listener.onEnter();
        this._listener.onExit();
        return;
      }

      // Stash the focused element so that we can return to it after exiting
      // print preview.
      gFocusedElement = document.commandDispatcher.focusedElement;

      let printPreviewTB = document.getElementById("print-preview-toolbar");
      if (printPreviewTB) {
        if (message.data.changingBrowsers) {
          printPreviewTB.destroy();
          printPreviewTB.initialize(ppBrowser);
        } else {
          // printPreviewTB.initialize above already calls updateToolbar.
          printPreviewTB.updateToolbar();
        }

        // If we don't have a progress listener to enable the toolbar do it now.
        if (!waitForPrintProgressToEnableToolbar) {
          printPreviewTB.disableUpdateTriggers(false);
        }

        ppBrowser.collapsed = false;
        ppBrowser.focus();
        return;
      }

      // Set the original window as an active window so any mozPrintCallbacks can
      // run without delayed setTimeouts.
      if (this._listener.activateBrowser) {
        this._listener.activateBrowser(this._sourceBrowser);
      } else {
        this._sourceBrowser.docShellIsActive = true;
      }

      // show the toolbar after we go into print preview mode so
      // that we can initialize the toolbar with total num pages
      printPreviewTB = document.createXULElement("toolbar", {
        is: "printpreview-toolbar",
      });
      printPreviewTB.setAttribute("fullscreentoolbar", true);
      printPreviewTB.setAttribute("flex", "1");
      printPreviewTB.id = "print-preview-toolbar";

      let navToolbox = this._listener.getNavToolbox();
      navToolbox.parentNode.insertBefore(printPreviewTB, navToolbox);
      printPreviewTB.initialize(ppBrowser);

      // The print preview processing may not have fully completed, so if we
      // have a progress listener, disable the toolbar elements that can trigger
      // updates and it will enable them when completed.
      if (waitForPrintProgressToEnableToolbar) {
        printPreviewTB.disableUpdateTriggers(true);
      }

      // Enable simplify page checkbox when the page is an article
      if (this._sourceBrowser.isArticle) {
        printPreviewTB.enableSimplifyPage();
      } else {
        this.logTelemetry("PRINT_PREVIEW_SIMPLIFY_PAGE_UNAVAILABLE_COUNT");
        printPreviewTB.disableSimplifyPage();
      }

      // copy the window close handler
      if (window.onclose) {
        this._closeHandlerPP = window.onclose;
      } else {
        this._closeHandlerPP = null;
      }
      window.onclose = function() {
        PrintUtils.exitPrintPreview();
        return false;
      };

      // disable chrome shortcuts...
      window.addEventListener("keydown", this.onKeyDownPP, true);
      window.addEventListener("keypress", this.onKeyPressPP, true);

      ppBrowser.collapsed = false;
      ppBrowser.focus();
      // on Enter PP Call back
      this._listener.onEnter();
    };

    mm.addMessageListener("Printing:Preview:Entered", onEntered);
  },

  exitPrintPreview() {
    for (let browser of this._ppBrowsers) {
      let browserMM = browser.messageManager;
      browserMM.sendAsyncMessage("Printing:Preview:Exit");
    }
    this._ppBrowsers.clear();
    this._currentPPBrowser = null;
    window.removeEventListener("keydown", this.onKeyDownPP, true);
    window.removeEventListener("keypress", this.onKeyPressPP, true);

    // restore the old close handler
    if (this._closeHandlerPP) {
      window.onclose = this._closeHandlerPP;
    } else {
      window.onclose = null;
    }
    this._closeHandlerPP = null;

    // remove the print preview toolbar
    let printPreviewTB = document.getElementById("print-preview-toolbar");
    printPreviewTB.destroy();
    printPreviewTB.remove();

    if (gFocusedElement) {
      Services.focus.setFocus(gFocusedElement, Services.focus.FLAG_NOSCROLL);
    } else {
      this._sourceBrowser.focus();
    }
    gFocusedElement = null;

    this.setSimplifiedMode(false);

    this.ensureProgressDialogClosed();

    this._listener.onExit();
  },

  logTelemetry(ID) {
    let histogram = Services.telemetry.getHistogramById(ID);
    histogram.add(true);
  },

  _logKeyedTelemetry(id, key) {
    let histogram = Services.telemetry.getKeyedHistogramById(id);
    histogram.add(key);
  },

  onKeyDownPP(aEvent) {
    // Esc exits the PP
    if (aEvent.keyCode == aEvent.DOM_VK_ESCAPE) {
      PrintUtils.exitPrintPreview();
    }
  },

  onKeyPressPP(aEvent) {
    var closeKey;
    try {
      closeKey = document.getElementById("key_close").getAttribute("key");
      closeKey = aEvent["DOM_VK_" + closeKey];
    } catch (e) {}
    var isModif = aEvent.ctrlKey || aEvent.metaKey;
    // Ctrl-W exits the PP
    if (
      isModif &&
      (aEvent.charCode == closeKey || aEvent.charCode == closeKey + 32)
    ) {
      PrintUtils.exitPrintPreview();
    } else if (isModif) {
      var printPreviewTB = document.getElementById("print-preview-toolbar");
      var printKey = document
        .getElementById("printKb")
        .getAttribute("key")
        .toUpperCase();
      var pressedKey = String.fromCharCode(aEvent.charCode).toUpperCase();
      if (printKey == pressedKey) {
        printPreviewTB.print();
      }
    }
    // cancel shortkeys
    if (isModif) {
      aEvent.preventDefault();
      aEvent.stopPropagation();
    }
  },

  /**
   * If there's a printing or print preview progress dialog displayed, force
   * it to close now.
   */
  ensureProgressDialogClosed() {
    if (this._webProgressPP && this._webProgressPP.value) {
      this._webProgressPP.value.onStateChange(
        null,
        null,
        Ci.nsIWebProgressListener.STATE_STOP,
        0
      );
    }
  },
};

PrintUtils.init();
