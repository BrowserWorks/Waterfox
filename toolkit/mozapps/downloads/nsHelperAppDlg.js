/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const {utils: Cu, interfaces: Ci, classes: Cc, results: Cr} = Components;
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/AppConstants.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "EnableDelayHelper",
                                  "resource://gre/modules/SharedPromptUtils.jsm");

///////////////////////////////////////////////////////////////////////////////
//// Helper Functions

/**
 * Determines if a given directory is able to be used to download to.
 *
 * @param aDirectory
 *        The directory to check.
 * @return true if we can use the directory, false otherwise.
 */
function isUsableDirectory(aDirectory)
{
  return aDirectory.exists() && aDirectory.isDirectory() &&
         aDirectory.isWritable();
}

// Web progress listener so we can detect errors while mLauncher is
// streaming the data to a temporary file.
function nsUnknownContentTypeDialogProgressListener(aHelperAppDialog) {
  this.helperAppDlg = aHelperAppDialog;
}

nsUnknownContentTypeDialogProgressListener.prototype = {
  // nsIWebProgressListener methods.
  // Look for error notifications and display alert to user.
  onStatusChange: function( aWebProgress, aRequest, aStatus, aMessage ) {
    if ( aStatus != Components.results.NS_OK ) {
      // Display error alert (using text supplied by back-end).
      // FIXME this.dialog is undefined?
      Services.prompt.alert( this.dialog, this.helperAppDlg.mTitle, aMessage );
      // Close the dialog.
      this.helperAppDlg.onCancel();
      if ( this.helperAppDlg.mDialog ) {
        this.helperAppDlg.mDialog.close();
      }
    }
  },

  // Ignore onProgressChange, onProgressChange64, onStateChange, onLocationChange, onSecurityChange, and onRefreshAttempted notifications.
  onProgressChange: function( aWebProgress,
                              aRequest,
                              aCurSelfProgress,
                              aMaxSelfProgress,
                              aCurTotalProgress,
                              aMaxTotalProgress ) {
  },

  onProgressChange64: function( aWebProgress,
                                aRequest,
                                aCurSelfProgress,
                                aMaxSelfProgress,
                                aCurTotalProgress,
                                aMaxTotalProgress ) {
  },



  onStateChange: function( aWebProgress, aRequest, aStateFlags, aStatus ) {
  },

  onLocationChange: function( aWebProgress, aRequest, aLocation, aFlags ) {
  },

  onSecurityChange: function( aWebProgress, aRequest, state ) {
  },

  onRefreshAttempted: function( aWebProgress, aURI, aDelay, aSameURI ) {
    return true;
  }
};

///////////////////////////////////////////////////////////////////////////////
//// nsUnknownContentTypeDialog

/* This file implements the nsIHelperAppLauncherDialog interface.
 *
 * The implementation consists of a JavaScript "class" named nsUnknownContentTypeDialog,
 * comprised of:
 *   - a JS constructor function
 *   - a prototype providing all the interface methods and implementation stuff
 *
 * In addition, this file implements an nsIModule object that registers the
 * nsUnknownContentTypeDialog component.
 */

const PREF_BD_USEDOWNLOADDIR = "browser.download.useDownloadDir";
const nsITimer = Components.interfaces.nsITimer;

var downloadModule = {};
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/DownloadLastDir.jsm", downloadModule);
Components.utils.import("resource://gre/modules/DownloadPaths.jsm");
Components.utils.import("resource://gre/modules/DownloadUtils.jsm");
Components.utils.import("resource://gre/modules/Downloads.jsm");
Components.utils.import("resource://gre/modules/FileUtils.jsm");
Components.utils.import("resource://gre/modules/Task.jsm");

/* ctor
 */
function nsUnknownContentTypeDialog() {
  // Initialize data properties.
  this.mLauncher = null;
  this.mContext  = null;
  this.mReason   = null;
  this.chosenApp = null;
  this.givenDefaultApp = false;
  this.updateSelf = true;
  this.mTitle    = "";
}

nsUnknownContentTypeDialog.prototype = {
  classID: Components.ID("{F68578EB-6EC2-4169-AE19-8C6243F0ABE1}"),

  nsIMIMEInfo  : Components.interfaces.nsIMIMEInfo,

  QueryInterface: function (iid) {
    if (!iid.equals(Components.interfaces.nsIHelperAppLauncherDialog) &&
        !iid.equals(Components.interfaces.nsITimerCallback) &&
        !iid.equals(Components.interfaces.nsISupports)) {
      throw Components.results.NS_ERROR_NO_INTERFACE;
    }
    return this;
  },

  // ---------- nsIHelperAppLauncherDialog methods ----------

  // show: Open XUL dialog using window watcher.  Since the dialog is not
  //       modal, it needs to be a top level window and the way to open
  //       one of those is via that route).
  show: function(aLauncher, aContext, aReason)  {
    this.mLauncher = aLauncher;
    this.mContext  = aContext;
    this.mReason   = aReason;

    // Cache some information in case this context goes away:
    try {
      let parent = aContext.QueryInterface(Ci.nsIInterfaceRequestor).getInterface(Ci.nsIDOMWindow);
      this._mDownloadDir = new downloadModule.DownloadLastDir(parent);
    } catch (ex) {
      Cu.reportError("Missing window information when showing nsIHelperAppLauncherDialog: " + ex);
    }

    const nsITimer = Components.interfaces.nsITimer;
    this._showTimer = Components.classes["@mozilla.org/timer;1"]
                                .createInstance(nsITimer);
    this._showTimer.initWithCallback(this, 0, nsITimer.TYPE_ONE_SHOT);
  },

  // When opening from new tab, if tab closes while dialog is opening,
  // (which is a race condition on the XUL file being cached and the timer
  // in nsExternalHelperAppService), the dialog gets a blur and doesn't
  // activate the OK button.  So we wait a bit before doing opening it.
  reallyShow: function() {
    try {
      let ir = this.mContext.QueryInterface(Components.interfaces.nsIInterfaceRequestor);
      let docShell = ir.getInterface(Components.interfaces.nsIDocShell);
      let rootWin = docShell.QueryInterface(Ci.nsIDocShellTreeItem)
                                 .rootTreeItem
                                 .QueryInterface(Ci.nsIInterfaceRequestor)
                                 .getInterface(Ci.nsIDOMWindow);
      let ww = Components.classes["@mozilla.org/embedcomp/window-watcher;1"]
                         .getService(Components.interfaces.nsIWindowWatcher);
      this.mDialog = ww.openWindow(rootWin,
                                   "chrome://mozapps/content/downloads/unknownContentType.xul",
                                   null,
                                   "chrome,centerscreen,titlebar,dialog=yes,dependent",
                                   null);
    } catch (ex) {
      // The containing window may have gone away.  Break reference
      // cycles and stop doing the download.
      this.mLauncher.cancel(Components.results.NS_BINDING_ABORTED);
      return;
    }

    // Hook this object to the dialog.
    this.mDialog.dialog = this;

    // Hook up utility functions.
    this.getSpecialFolderKey = this.mDialog.getSpecialFolderKey;

    // Watch for error notifications.
    var progressListener = new nsUnknownContentTypeDialogProgressListener(this);
    this.mLauncher.setWebProgressListener(progressListener);
  },

  //
  // displayBadPermissionAlert()
  //
  // Diplay an alert panel about the bad permission of folder/directory.
  //
  displayBadPermissionAlert: function () {
    let bundle =
      Services.strings.createBundle("chrome://mozapps/locale/downloads/unknownContentType.properties");

    Services.prompt.alert(this.dialog,
                   bundle.GetStringFromName("badPermissions.title"),
                   bundle.GetStringFromName("badPermissions"));
  },

  promptForSaveToFileAsync: function(aLauncher, aContext, aDefaultFile, aSuggestedFileExtension, aForcePrompt) {
    var result = null;

    this.mLauncher = aLauncher;

    let prefs = Components.classes["@mozilla.org/preferences-service;1"]
                          .getService(Components.interfaces.nsIPrefBranch);
    let bundle =
      Services.strings
              .createBundle("chrome://mozapps/locale/downloads/unknownContentType.properties");

    let parent;
    let gDownloadLastDir;
    try {
      parent = aContext.QueryInterface(Ci.nsIInterfaceRequestor).getInterface(Ci.nsIDOMWindow);
    } catch (ex) {}

    if (parent) {
      gDownloadLastDir = new downloadModule.DownloadLastDir(parent);
    } else {
      // Use the cached download info, but pick an arbitrary parent window
      // because the original one is definitely gone (and nsIFilePicker doesn't like
      // a null parent):
      gDownloadLastDir = this._mDownloadDir;
      let windowsEnum = Services.wm.getEnumerator("");
      while (windowsEnum.hasMoreElements()) {
        let someWin = windowsEnum.getNext();
        // We need to make sure we don't end up with this dialog, because otherwise
        // that's going to go away when the user clicks "Save", and that breaks the
        // windows file picker that's supposed to show up if we let the user choose
        // where to save files...
        if (someWin != this.mDialog) {
          parent = someWin;
        }
      }
      if (!parent) {
        Cu.reportError("No candidate parent windows were found for the save filepicker." +
                       "This should never happen.");
      }
    }

    Task.spawn(function() {
      if (!aForcePrompt) {
        // Check to see if the user wishes to auto save to the default download
        // folder without prompting. Note that preference might not be set.
        let autodownload = false;
        try {
          autodownload = prefs.getBoolPref(PREF_BD_USEDOWNLOADDIR);
        } catch (e) { }

        if (autodownload) {
          // Retrieve the user's default download directory
          let preferredDir = yield Downloads.getPreferredDownloadsDirectory();
          let defaultFolder = new FileUtils.File(preferredDir);

          try {
            result = this.validateLeafName(defaultFolder, aDefaultFile, aSuggestedFileExtension);
          }
          catch (ex) {
            // When the default download directory is write-protected,
            // prompt the user for a different target file.
          }

          // Check to make sure we have a valid directory, otherwise, prompt
          if (result) {
            // This path is taken when we have a writable default download directory.
            aLauncher.saveDestinationAvailable(result);
            return;
          }
        }
      }

      // Use file picker to show dialog.
      var nsIFilePicker = Components.interfaces.nsIFilePicker;
      var picker = Components.classes["@mozilla.org/filepicker;1"].createInstance(nsIFilePicker);
      var windowTitle = bundle.GetStringFromName("saveDialogTitle");
      picker.init(parent, windowTitle, nsIFilePicker.modeSave);
      picker.defaultString = aDefaultFile;

      if (aSuggestedFileExtension) {
        // aSuggestedFileExtension includes the period, so strip it
        picker.defaultExtension = aSuggestedFileExtension.substring(1);
      }
      else {
        try {
          picker.defaultExtension = this.mLauncher.MIMEInfo.primaryExtension;
        }
        catch (ex) { }
      }

      var wildCardExtension = "*";
      if (aSuggestedFileExtension) {
        wildCardExtension += aSuggestedFileExtension;
        picker.appendFilter(this.mLauncher.MIMEInfo.description, wildCardExtension);
      }

      picker.appendFilters( nsIFilePicker.filterAll );

      // Default to lastDir if it is valid, otherwise use the user's default
      // downloads directory.  getPreferredDownloadsDirectory should always
      // return a valid directory path, so we can safely default to it.
      let preferredDir = yield Downloads.getPreferredDownloadsDirectory();
      picker.displayDirectory = new FileUtils.File(preferredDir);

      gDownloadLastDir.getFileAsync(aLauncher.source, function LastDirCallback(lastDir) {
        if (lastDir && isUsableDirectory(lastDir))
          picker.displayDirectory = lastDir;

        if (picker.show() == nsIFilePicker.returnCancel) {
          // null result means user cancelled.
          aLauncher.saveDestinationAvailable(null);
          return;
        }

        // Be sure to save the directory the user chose through the Save As...
        // dialog  as the new browser.download.dir since the old one
        // didn't exist.
        result = picker.file;

        if (result) {
          try {
            // Remove the file so that it's not there when we ensure non-existence later;
            // this is safe because for the file to exist, the user would have had to
            // confirm that he wanted the file overwritten.
            // Only remove file if final name exists
            if (result.exists() && this.getFinalLeafName(result.leafName) == result.leafName)
              result.remove(false);
          }
          catch (ex) {
            // As it turns out, the failure to remove the file, for example due to
            // permission error, will be handled below eventually somehow.
          }

          var newDir = result.parent.QueryInterface(Components.interfaces.nsILocalFile);

          // Do not store the last save directory as a pref inside the private browsing mode
          gDownloadLastDir.setFile(aLauncher.source, newDir);

          try {
            result = this.validateLeafName(newDir, result.leafName, null);
          }
          catch (ex) {
            // When the chosen download directory is write-protected,
            // display an informative error message.
            // In all cases, download will be stopped.

            if (ex.result == Components.results.NS_ERROR_FILE_ACCESS_DENIED) {
              this.displayBadPermissionAlert();
              aLauncher.saveDestinationAvailable(null);
              return;
            }

          }
        }
        aLauncher.saveDestinationAvailable(result);
      }.bind(this));
    }.bind(this)).then(null, Components.utils.reportError);
  },

  getFinalLeafName: function (aLeafName, aFileExt)
  {
    // Remove any leading periods, since we don't want to save hidden files
    // automatically.
    aLeafName = aLeafName.replace(/^\.+/, "");

    if (aLeafName == "")
      aLeafName = "unnamed" + (aFileExt ? "." + aFileExt : "");

    return aLeafName;
  },

  /**
   * Ensures that a local folder/file combination does not already exist in
   * the file system (or finds such a combination with a reasonably similar
   * leaf name), creates the corresponding file, and returns it.
   *
   * @param   aLocalFolder
   *          the folder where the file resides
   * @param   aLeafName
   *          the string name of the file (may be empty if no name is known,
   *          in which case a name will be chosen)
   * @param   aFileExt
   *          the extension of the file, if one is known; this will be ignored
   *          if aLeafName is non-empty
   * @return  nsILocalFile
   *          the created file
   * @throw   an error such as permission doesn't allow creation of
   *          file, etc.
   */
  validateLeafName: function (aLocalFolder, aLeafName, aFileExt)
  {
    if (!(aLocalFolder && isUsableDirectory(aLocalFolder))) {
      throw new Components.Exception("Destination directory non-existing or permission error",
                                     Components.results.NS_ERROR_FILE_ACCESS_DENIED);
    }

    aLeafName = this.getFinalLeafName(aLeafName, aFileExt);
    aLocalFolder.append(aLeafName);

    // The following assignment can throw an exception, but
    // is now caught properly in the caller of validateLeafName.
    var createdFile = DownloadPaths.createNiceUniqueFile(aLocalFolder);

    if (AppConstants.platform == "win") {
      let ext;
      try {
        // We can fail here if there's no primary extension set
        ext = "." + this.mLauncher.MIMEInfo.primaryExtension;
      } catch (e) { }

      // Append a file extension if it's an executable that doesn't have one
      // but make sure we actually have an extension to add
      let leaf = createdFile.leafName;
      if (ext && leaf.slice(-ext.length) != ext && createdFile.isExecutable()) {
        createdFile.remove(false);
        aLocalFolder.leafName = leaf + ext;
        createdFile = DownloadPaths.createNiceUniqueFile(aLocalFolder);
      }
    }

    return createdFile;
  },

  // ---------- implementation methods ----------

  // initDialog:  Fill various dialog fields with initial content.
  initDialog : function() {
    // Put file name in window title.
    var suggestedFileName = this.mLauncher.suggestedFileName;

    // Some URIs do not implement nsIURL, so we can't just QI.
    var url = this.mLauncher.source;
    if (url instanceof Components.interfaces.nsINestedURI)
      url = url.innermostURI;

    var fname = "";
    var iconPath = "goat";
    this.mSourcePath = url.prePath;
    if (url instanceof Components.interfaces.nsIURL) {
      // A url, use file name from it.
      fname = iconPath = url.fileName;
      this.mSourcePath += url.directory;
    } else {
      // A generic uri, use path.
      fname = url.path;
      this.mSourcePath += url.path;
    }

    if (suggestedFileName)
      fname = iconPath = suggestedFileName;

    var displayName = fname.replace(/ +/g, " ");

    this.mTitle = this.dialogElement("strings").getFormattedString("title", [displayName]);
    this.mDialog.document.title = this.mTitle;

    // Put content type, filename and location into intro.
    this.initIntro(url, fname, displayName);

    var iconString = "moz-icon://" + iconPath + "?size=16&contentType=" + this.mLauncher.MIMEInfo.MIMEType;
    this.dialogElement("contentTypeImage").setAttribute("src", iconString);

    // if always-save and is-executable and no-handler
    // then set up simple ui
    var mimeType = this.mLauncher.MIMEInfo.MIMEType;
    var shouldntRememberChoice = (mimeType == "application/octet-stream" ||
                                  mimeType == "application/x-msdownload" ||
                                  this.mLauncher.targetFileIsExecutable);
    if ((shouldntRememberChoice && !this.openWithDefaultOK()) ||
        Services.prefs.getBoolPref("browser.download.forbid_open_with")) {
      // hide featured choice
      this.dialogElement("normalBox").collapsed = true;
      // show basic choice
      this.dialogElement("basicBox").collapsed = false;
      // change button labels and icons; use "save" icon for the accept
      // button since it's the only action possible
      let acceptButton = this.mDialog.document.documentElement
                                              .getButton("accept");
      acceptButton.label = this.dialogElement("strings")
                               .getString("unknownAccept.label");
      acceptButton.setAttribute("icon", "save");
      this.mDialog.document.documentElement.getButton("cancel").label = this.dialogElement("strings").getString("unknownCancel.label");
      // hide other handler
      this.dialogElement("openHandler").collapsed = true;
      // set save as the selected option
      this.dialogElement("mode").selectedItem = this.dialogElement("save");
    }
    else {
      this.initAppAndSaveToDiskValues();

      // Initialize "always ask me" box. This should always be disabled
      // and set to true for the ambiguous type application/octet-stream.
      // We don't also check for application/x-msdownload here since we
      // want users to be able to autodownload .exe files.
      var rememberChoice = this.dialogElement("rememberChoice");

      // Just because we have a content-type of application/octet-stream
      // here doesn't actually mean that the content is of that type. Many
      // servers default to sending text/plain for file types they don't know
      // about. To account for this, the uriloader does some checking to see
      // if a file sent as text/plain contains binary characters, and if so (*)
      // it morphs the content-type into application/octet-stream so that
      // the file can be properly handled. Since this is not generic binary
      // data, rather, a data format that the system probably knows about,
      // we don't want to use the content-type provided by this dialog's
      // opener, as that's the generic application/octet-stream that the
      // uriloader has passed, rather we want to ask the MIME Service.
      // This is so we don't needlessly disable the "autohandle" checkbox.

      // commented out to close the opening brace in the if statement.
      // var mimeService = Components.classes["@mozilla.org/mime;1"].getService(Components.interfaces.nsIMIMEService);
      // var type = mimeService.getTypeFromURI(this.mLauncher.source);
      // this.realMIMEInfo = mimeService.getFromTypeAndExtension(type, "");

      // if (type == "application/octet-stream") {
      if (shouldntRememberChoice) {
        rememberChoice.checked = false;
        rememberChoice.disabled = true;
      }
      else {
        rememberChoice.checked = !this.mLauncher.MIMEInfo.alwaysAskBeforeHandling &&
                                 this.mLauncher.MIMEInfo.preferredAction != this.nsIMIMEInfo.handleInternally;
      }
      this.toggleRememberChoice(rememberChoice);

      // XXXben - menulist won't init properly, hack.
      var openHandler = this.dialogElement("openHandler");
      openHandler.parentNode.removeChild(openHandler);
      var openHandlerBox = this.dialogElement("openHandlerBox");
      openHandlerBox.appendChild(openHandler);
    }

    this.mDialog.setTimeout("dialog.postShowCallback()", 0);

    this.delayHelper = new EnableDelayHelper({
      disableDialog: () => {
        this.mDialog.document.documentElement.getButton("accept").disabled = true;
      },
      enableDialog: () => {
        this.mDialog.document.documentElement.getButton("accept").disabled = false;
      },
      focusTarget: this.mDialog
    });
  },

  notify: function (aTimer) {
    if (aTimer == this._showTimer) {
      if (!this.mDialog) {
        this.reallyShow();
      }
      // The timer won't release us, so we have to release it.
      this._showTimer = null;
    }
    else if (aTimer == this._saveToDiskTimer) {
      // Since saveToDisk may open a file picker and therefore block this routine,
      // we should only call it once the dialog is closed.
      this.mLauncher.saveToDisk(null, false);
      this._saveToDiskTimer = null;
    }
  },

  postShowCallback: function () {
    this.mDialog.sizeToContent();

    // Set initial focus
    this.dialogElement("mode").focus();
  },

  // initIntro:
  initIntro: function(url, filename, displayname) {
    this.dialogElement( "location" ).value = displayname;
    this.dialogElement( "location" ).setAttribute("realname", filename);
    this.dialogElement( "location" ).setAttribute("tooltiptext", displayname);

    // if mSourcePath is a local file, then let's use the pretty path name
    // instead of an ugly url...
    var pathString;
    if (url instanceof Components.interfaces.nsIFileURL) {
      try {
        // Getting .file might throw, or .parent could be null
        pathString = url.file.parent.path;
      } catch (ex) {}
    }

    if (!pathString) {
      // wasn't a fileURL
      var tmpurl = url.clone(); // don't want to change the real url
      try {
        tmpurl.userPass = "";
      } catch (ex) {}
      pathString = tmpurl.prePath;
    }

    // Set the location text, which is separate from the intro text so it can be cropped
    var location = this.dialogElement( "source" );
    location.value = pathString;
    location.setAttribute("tooltiptext", this.mSourcePath);

    // Show the type of file.
    var type = this.dialogElement("type");
    var mimeInfo = this.mLauncher.MIMEInfo;

    // 1. Try to use the pretty description of the type, if one is available.
    var typeString = mimeInfo.description;

    if (typeString == "") {
      // 2. If there is none, use the extension to identify the file, e.g. "ZIP file"
      var primaryExtension = "";
      try {
        primaryExtension = mimeInfo.primaryExtension;
      }
      catch (ex) {
      }
      if (primaryExtension != "")
        typeString = this.dialogElement("strings").getFormattedString("fileType", [primaryExtension.toUpperCase()]);
      // 3. If we can't even do that, just give up and show the MIME type.
      else
        typeString = mimeInfo.MIMEType;
    }
    // When the length is unknown, contentLength would be -1
    if (this.mLauncher.contentLength >= 0) {
      let [size, unit] = DownloadUtils.
                         convertByteUnits(this.mLauncher.contentLength);
      type.value = this.dialogElement("strings")
                       .getFormattedString("orderedFileSizeWithType", 
                                           [typeString, size, unit]);
    }
    else {
      type.value = typeString;
    }
  },

  // Returns true if opening the default application makes sense.
  openWithDefaultOK: function() {
    // The checking is different on Windows...
    if (AppConstants.platform == "win") {
      // Windows presents some special cases.
      // We need to prevent use of "system default" when the file is
      // executable (so the user doesn't launch nasty programs downloaded
      // from the web), and, enable use of "system default" if it isn't
      // executable (because we will prompt the user for the default app
      // in that case).

      //  Default is Ok if the file isn't executable (and vice-versa).
      return !this.mLauncher.targetFileIsExecutable;
    }
    // On other platforms, default is Ok if there is a default app.
    // Note that nsIMIMEInfo providers need to ensure that this holds true
    // on each platform.
    return this.mLauncher.MIMEInfo.hasDefaultHandler;
  },

  // Set "default" application description field.
  initDefaultApp: function() {
    // Use description, if we can get one.
    var desc = this.mLauncher.MIMEInfo.defaultDescription;
    if (desc) {
      var defaultApp = this.dialogElement("strings").getFormattedString("defaultApp", [desc]);
      this.dialogElement("defaultHandler").label = defaultApp;
    }
    else {
      this.dialogElement("modeDeck").setAttribute("selectedIndex", "1");
      // Hide the default handler item too, in case the user picks a
      // custom handler at a later date which triggers the menulist to show.
      this.dialogElement("defaultHandler").hidden = true;
    }
  },

  // getPath:
  getPath: function (aFile) {
    if (AppConstants.platform == "macosx") {
      return aFile.leafName || aFile.path;
    }
    return aFile.path;
  },

  // initAppAndSaveToDiskValues:
  initAppAndSaveToDiskValues: function() {
    var modeGroup = this.dialogElement("mode");

    // We don't let users open .exe files or random binary data directly
    // from the browser at the moment because of security concerns.
    var openWithDefaultOK = this.openWithDefaultOK();
    var mimeType = this.mLauncher.MIMEInfo.MIMEType;
    if (this.mLauncher.targetFileIsExecutable || (
      (mimeType == "application/octet-stream" ||
       mimeType == "application/x-msdownload") &&
        !openWithDefaultOK)) {
      this.dialogElement("open").disabled = true;
      var openHandler = this.dialogElement("openHandler");
      openHandler.disabled = true;
      openHandler.selectedItem = null;
      modeGroup.selectedItem = this.dialogElement("save");
      return;
    }

    // Fill in helper app info, if there is any.
    try {
      this.chosenApp =
        this.mLauncher.MIMEInfo.preferredApplicationHandler
                               .QueryInterface(Components.interfaces.nsILocalHandlerApp);
    } catch (e) {
      this.chosenApp = null;
    }
    // Initialize "default application" field.
    this.initDefaultApp();

    var otherHandler = this.dialogElement("otherHandler");

    // Fill application name textbox.
    if (this.chosenApp && this.chosenApp.executable &&
        this.chosenApp.executable.path) {
      otherHandler.setAttribute("path",
                                this.getPath(this.chosenApp.executable));

      otherHandler.label = this.getFileDisplayName(this.chosenApp.executable);
      otherHandler.hidden = false;
    }

    var openHandler = this.dialogElement("openHandler");
    openHandler.selectedIndex = 0;
    var defaultOpenHandler = this.dialogElement("defaultHandler");

    if (this.mLauncher.MIMEInfo.preferredAction == this.nsIMIMEInfo.useSystemDefault) {
      // Open (using system default).
      modeGroup.selectedItem = this.dialogElement("open");
    } else if (this.mLauncher.MIMEInfo.preferredAction == this.nsIMIMEInfo.useHelperApp) {
      // Open with given helper app.
      modeGroup.selectedItem = this.dialogElement("open");
      openHandler.selectedItem = (otherHandler && !otherHandler.hidden) ?
                                 otherHandler : defaultOpenHandler;
    } else {
      // Save to disk.
      modeGroup.selectedItem = this.dialogElement("save");
    }

    // If we don't have a "default app" then disable that choice.
    if (!openWithDefaultOK) {
      var isSelected = defaultOpenHandler.selected;

      // Disable that choice.
      defaultOpenHandler.hidden = true;
      // If that's the default, then switch to "save to disk."
      if (isSelected) {
        openHandler.selectedIndex = 1;
        modeGroup.selectedItem = this.dialogElement("save");
      }
    }

    otherHandler.nextSibling.hidden = otherHandler.nextSibling.nextSibling.hidden = false;
    this.updateOKButton();
  },

  // Returns the user-selected application
  helperAppChoice: function() {
    return this.chosenApp;
  },

  get saveToDisk() {
    return this.dialogElement("save").selected;
  },

  get useOtherHandler() {
    return this.dialogElement("open").selected && this.dialogElement("openHandler").selectedIndex == 1;
  },

  get useSystemDefault() {
    return this.dialogElement("open").selected && this.dialogElement("openHandler").selectedIndex == 0;
  },

  toggleRememberChoice: function (aCheckbox) {
    this.dialogElement("settingsChange").hidden = !aCheckbox.checked;
    this.mDialog.sizeToContent();
  },

  openHandlerCommand: function () {
    var openHandler = this.dialogElement("openHandler");
    if (openHandler.selectedItem.id == "choose")
      this.chooseApp();
    else
      openHandler.setAttribute("lastSelectedItemID", openHandler.selectedItem.id);
  },

  updateOKButton: function() {
    var ok = false;
    if (this.dialogElement("save").selected) {
      // This is always OK.
      ok = true;
    }
    else if (this.dialogElement("open").selected) {
      switch (this.dialogElement("openHandler").selectedIndex) {
      case 0:
        // No app need be specified in this case.
        ok = true;
        break;
      case 1:
        // only enable the OK button if we have a default app to use or if
        // the user chose an app....
        ok = this.chosenApp || /\S/.test(this.dialogElement("otherHandler").getAttribute("path")); 
        break;
      }
    }

    // Enable Ok button if ok to press.
    this.mDialog.document.documentElement.getButton("accept").disabled = !ok;
  },

  // Returns true iff the user-specified helper app has been modified.
  appChanged: function() {
    return this.helperAppChoice() != this.mLauncher.MIMEInfo.preferredApplicationHandler;
  },

  updateMIMEInfo: function() {
    // Don't update mime type preferences when the preferred action is set to
    // the internal handler -- this dialog is the result of the handler fallback
    // (e.g. Content-Disposition was set as attachment)
    var discardUpdate = this.mLauncher.MIMEInfo.preferredAction == this.nsIMIMEInfo.handleInternally &&
                        !this.dialogElement("rememberChoice").checked;

    var needUpdate = false;
    // If current selection differs from what's in the mime info object,
    // then we need to update.
    if (this.saveToDisk) {
      needUpdate = this.mLauncher.MIMEInfo.preferredAction != this.nsIMIMEInfo.saveToDisk;
      if (needUpdate)
        this.mLauncher.MIMEInfo.preferredAction = this.nsIMIMEInfo.saveToDisk;
    }
    else if (this.useSystemDefault) {
      needUpdate = this.mLauncher.MIMEInfo.preferredAction != this.nsIMIMEInfo.useSystemDefault;
      if (needUpdate)
        this.mLauncher.MIMEInfo.preferredAction = this.nsIMIMEInfo.useSystemDefault;
    }
    else {
      // For "open with", we need to check both preferred action and whether the user chose
      // a new app.
      needUpdate = this.mLauncher.MIMEInfo.preferredAction != this.nsIMIMEInfo.useHelperApp || this.appChanged();
      if (needUpdate) {
        this.mLauncher.MIMEInfo.preferredAction = this.nsIMIMEInfo.useHelperApp;
        // App may have changed - Update application
        var app = this.helperAppChoice();
        this.mLauncher.MIMEInfo.preferredApplicationHandler = app;
      }
    }
    // We will also need to update if the "always ask" flag has changed.
    needUpdate = needUpdate || this.mLauncher.MIMEInfo.alwaysAskBeforeHandling != (!this.dialogElement("rememberChoice").checked);

    // One last special case: If the input "always ask" flag was false, then we always
    // update.  In that case we are displaying the helper app dialog for the first
    // time for this mime type and we need to store the user's action in the mimeTypes.rdf
    // data source (whether that action has changed or not; if it didn't change, then we need
    // to store the "always ask" flag so the helper app dialog will or won't display
    // next time, per the user's selection).
    needUpdate = needUpdate || !this.mLauncher.MIMEInfo.alwaysAskBeforeHandling;

    // Make sure mime info has updated setting for the "always ask" flag.
    this.mLauncher.MIMEInfo.alwaysAskBeforeHandling = !this.dialogElement("rememberChoice").checked;

    return needUpdate && !discardUpdate;
  },

  // See if the user changed things, and if so, update the
  // mimeTypes.rdf entry for this mime type.
  updateHelperAppPref: function() {
    var handlerInfo = this.mLauncher.MIMEInfo;
    var hs = Cc["@mozilla.org/uriloader/handler-service;1"].getService(Ci.nsIHandlerService);
    hs.store(handlerInfo);
  },

  // onOK:
  onOK: function() {
    // Verify typed app path, if necessary.
    if (this.useOtherHandler) {
      var helperApp = this.helperAppChoice();
      if (!helperApp || !helperApp.executable ||
          !helperApp.executable.exists()) {
        // Show alert and try again.
        var bundle = this.dialogElement("strings");
        var msg = bundle.getFormattedString("badApp", [this.dialogElement("otherHandler").getAttribute("path")]);
        Services.prompt.alert(this.mDialog, bundle.getString("badApp.title"), msg);

        // Disable the OK button.
        this.mDialog.document.documentElement.getButton("accept").disabled = true;
        this.dialogElement("mode").focus();

        // Clear chosen application.
        this.chosenApp = null;

        // Leave dialog up.
        return false;
      }
    }

    // Remove our web progress listener (a progress dialog will be
    // taking over).
    this.mLauncher.setWebProgressListener(null);

    // saveToDisk and launchWithApplication can return errors in
    // certain circumstances (e.g. The user clicks cancel in the
    // "Save to Disk" dialog. In those cases, we don't want to
    // update the helper application preferences in the RDF file.
    try {
      var needUpdate = this.updateMIMEInfo();

      if (this.dialogElement("save").selected) {
        // If we're using a default download location, create a path
        // for the file to be saved to to pass to |saveToDisk| - otherwise
        // we must ask the user to pick a save name.

        /*
        var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
        var targetFile = null;
        try {
          targetFile = prefs.getComplexValue("browser.download.defaultFolder",
                                             Components.interfaces.nsILocalFile);
          var leafName = this.dialogElement("location").getAttribute("realname");
          // Ensure that we don't overwrite any existing files here.
          targetFile = this.validateLeafName(targetFile, leafName, null);
        }
        catch(e) { }

        this.mLauncher.saveToDisk(targetFile, false);
        */

        // see @notify
        // we cannot use opener's setTimeout, see bug 420405
        this._saveToDiskTimer = Components.classes["@mozilla.org/timer;1"]
                                          .createInstance(nsITimer);
        this._saveToDiskTimer.initWithCallback(this, 0,
                                               nsITimer.TYPE_ONE_SHOT);
      }
      else
        this.mLauncher.launchWithApplication(null, false);

      // Update user pref for this mime type (if necessary). We do not
      // store anything in the mime type preferences for the ambiguous
      // type application/octet-stream. We do NOT do this for
      // application/x-msdownload since we want users to be able to
      // autodownload these to disk.
      if (needUpdate && this.mLauncher.MIMEInfo.MIMEType != "application/octet-stream")
        this.updateHelperAppPref();
    } catch(e) { }

    // Unhook dialog from this object.
    this.mDialog.dialog = null;

    // Close up dialog by returning true.
    return true;
  },

  // onCancel:
  onCancel: function() {
    // Remove our web progress listener.
    this.mLauncher.setWebProgressListener(null);

    // Cancel app launcher.
    try {
      this.mLauncher.cancel(Components.results.NS_BINDING_ABORTED);
    } catch(exception) {
    }

    // Unhook dialog from this object.
    this.mDialog.dialog = null;

    // Close up dialog by returning true.
    return true;
  },

  // dialogElement:  Convenience.
  dialogElement: function(id) {
    return this.mDialog.document.getElementById(id);
  },

  // Retrieve the pretty description from the file
  getFileDisplayName: function getFileDisplayName(file)
  {
    if (AppConstants.platform == "win") {
      if (file instanceof Components.interfaces.nsILocalFileWin) {
        try {
          return file.getVersionInfoField("FileDescription");
        } catch (e) {}
      }
    } else if (AppConstants.platform == "macosx") {
      if (file instanceof Components.interfaces.nsILocalFileMac) {
        try {
          return file.bundleDisplayName;
        } catch (e) {}
      }
    }
    return file.leafName;
  },

  finishChooseApp: function() {
    if (this.chosenApp) {
      // Show the "handler" menulist since we have a (user-specified)
      // application now.
      this.dialogElement("modeDeck").setAttribute("selectedIndex", "0");

      // Update dialog.
      var otherHandler = this.dialogElement("otherHandler");
      otherHandler.removeAttribute("hidden");
      otherHandler.setAttribute("path", this.getPath(this.chosenApp.executable));
      if (AppConstants.platform == "win")
        otherHandler.label = this.getFileDisplayName(this.chosenApp.executable);
      else
        otherHandler.label = this.chosenApp.name;
      this.dialogElement("openHandler").selectedIndex = 1;
      this.dialogElement("openHandler").setAttribute("lastSelectedItemID", "otherHandler");

      this.dialogElement("mode").selectedItem = this.dialogElement("open");
    }
    else {
      var openHandler = this.dialogElement("openHandler");
      var lastSelectedID = openHandler.getAttribute("lastSelectedItemID");
      if (!lastSelectedID)
        lastSelectedID = "defaultHandler";
      openHandler.selectedItem = this.dialogElement(lastSelectedID);
    }
  },
  // chooseApp:  Open file picker and prompt user for application.
  chooseApp: function() {
    if (AppConstants.platform == "win") {
      // Protect against the lack of an extension
      var fileExtension = "";
      try {
        fileExtension = this.mLauncher.MIMEInfo.primaryExtension;
      } catch(ex) {
      }

      // Try to use the pretty description of the type, if one is available.
      var typeString = this.mLauncher.MIMEInfo.description;

      if (!typeString) {
        // If there is none, use the extension to
        // identify the file, e.g. "ZIP file"
        if (fileExtension) {
          typeString =
            this.dialogElement("strings").
            getFormattedString("fileType", [fileExtension.toUpperCase()]);
        } else {
          // If we can't even do that, just give up and show the MIME type.
          typeString = this.mLauncher.MIMEInfo.MIMEType;
        }
      }

      var params = {};
      params.title =
        this.dialogElement("strings").getString("chooseAppFilePickerTitle");
      params.description = typeString;
      params.filename    = this.mLauncher.suggestedFileName;
      params.mimeInfo    = this.mLauncher.MIMEInfo;
      params.handlerApp  = null;

      this.mDialog.openDialog("chrome://global/content/appPicker.xul", null,
                              "chrome,modal,centerscreen,titlebar,dialog=yes",
                              params);

      if (params.handlerApp &&
          params.handlerApp.executable &&
          params.handlerApp.executable.isFile()) {
        // Remember the file they chose to run.
        this.chosenApp = params.handlerApp;
      }
    }
    else {
#if MOZ_WIDGET_GTK == 3
      var nsIApplicationChooser = Components.interfaces.nsIApplicationChooser;
      var appChooser = Components.classes["@mozilla.org/applicationchooser;1"]
                                 .createInstance(nsIApplicationChooser);
      appChooser.init(this.mDialog, this.dialogElement("strings").getString("chooseAppFilePickerTitle"));
      var contentTypeDialogObj = this;
      let appChooserCallback = function appChooserCallback_done(aResult) {
        if (aResult) {
           contentTypeDialogObj.chosenApp = aResult.QueryInterface(Components.interfaces.nsILocalHandlerApp);
        }
        contentTypeDialogObj.finishChooseApp();
      };
      appChooser.open(this.mLauncher.MIMEInfo.MIMEType, appChooserCallback);
      // The finishChooseApp is called from appChooserCallback
      return;
#else
      var nsIFilePicker = Components.interfaces.nsIFilePicker;
      var fp = Components.classes["@mozilla.org/filepicker;1"]
                         .createInstance(nsIFilePicker);
      fp.init(this.mDialog,
              this.dialogElement("strings").getString("chooseAppFilePickerTitle"),
              nsIFilePicker.modeOpen);

      fp.appendFilters(nsIFilePicker.filterApps);

      if (fp.show() == nsIFilePicker.returnOK && fp.file) {
        // Remember the file they chose to run.
        var localHandlerApp =
          Components.classes["@mozilla.org/uriloader/local-handler-app;1"].
                     createInstance(Components.interfaces.nsILocalHandlerApp);
        localHandlerApp.executable = fp.file;
        this.chosenApp = localHandlerApp;
      }
#endif // MOZ_WIDGET_GTK == 3
    }
    this.finishChooseApp();
  },

  // Turn this on to get debugging messages.
  debug: false,

  // Dump text (if debug is on).
  dump: function( text ) {
    if ( this.debug ) {
      dump( text );
    }
  },

  // dumpObj:
  dumpObj: function( spec ) {
    var val = "<undefined>";
    try {
      val = eval( "this."+spec ).toString();
    } catch( exception ) {
    }
    this.dump( spec + "=" + val + "\n" );
  },

  // dumpObjectProperties
  dumpObjectProperties: function( desc, obj ) {
    for( prop in obj ) {
      this.dump( desc + "." + prop + "=" );
      var val = "<undefined>";
      try {
        val = obj[ prop ];
      } catch ( exception ) {
      }
      this.dump( val + "\n" );
    }
  }
}

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([nsUnknownContentTypeDialog]);
