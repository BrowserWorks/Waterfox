/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from preferences.js */
/* import-globals-from ../../../base/content/aboutDialog-appUpdater.js */

var { Downloads } = ChromeUtils.import("resource://gre/modules/Downloads.jsm");
var { FileUtils } = ChromeUtils.import("resource://gre/modules/FileUtils.jsm");
var { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

const AUTO_UPDATE_CHANGED_TOPIC = "auto-update-config-change";

XPCOMUtils.defineLazyServiceGetters(this, {
  gHandlerService: [
    "@mozilla.org/uriloader/handler-service;1",
    "nsIHandlerService",
  ],
  gMIMEService: ["@mozilla.org/mime;1", "nsIMIMEService"],
});

ChromeUtils.defineModuleGetter(
  this,
  "UpdateUtils",
  "resource://gre/modules/UpdateUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "CloudStorage",
  "resource://gre/modules/CloudStorage.jsm"
);

Preferences.addAll([
  // Downloads
  { id: "browser.download.useDownloadDir", type: "bool" },
  { id: "browser.download.folderList", type: "int" },
  { id: "browser.download.dir", type: "file" },

  // Update
  { id: "browser.preferences.advanced.selectedTabIndex", type: "int" },
  { id: "browser.search.update", type: "bool" },
]);

if (AppConstants.MOZ_UPDATER) {
  Preferences.addAll([
    { id: "app.update.disable_button.showUpdateHistory", type: "bool" },
  ]);

  if (AppConstants.MOZ_MAINTENANCE_SERVICE) {
    Preferences.addAll([{ id: "app.update.service.enabled", type: "bool" }]);
  }
}

var gDownloadsPane = {
  init() {
    function setEventListener(aId, aEventType, aCallback) {
      document
        .getElementById(aId)
        .addEventListener(aEventType, aCallback.bind(gDownloadsPane));
    }

    // Initialize the Waterfox Updates section.
    let version = AppConstants.MOZ_APP_VERSION_DISPLAY;

    // Include the build ID if this is an "a#" (nightly) build
    if (/a\d+$/.test(version)) {
      let buildID = Services.appinfo.appBuildID;
      let year = buildID.slice(0, 4);
      let month = buildID.slice(4, 6);
      let day = buildID.slice(6, 8);
      version += ` (${year}-${month}-${day})`;
    }

    // Append "(32-bit)" or "(64-bit)" build architecture to the version number:
    let bundle = Services.strings.createBundle(
      "chrome://browser/locale/browser.properties"
    );
    let archResource = Services.appinfo.is64Bit
      ? "aboutDialog.architecture.sixtyFourBit"
      : "aboutDialog.architecture.thirtyTwoBit";
    let arch = bundle.GetStringFromName(archResource);
    version += ` (${arch})`;

    document.l10n.setAttributes(
      document.getElementById("updateAppInfo"),
      "update-application-version",
      { version }
    );

    // Show a release notes link if we have a URL.
    let relNotesLink = document.getElementById("releasenotes");
    let relNotesPrefType = Services.prefs.getPrefType("app.releaseNotesURL");
    if (relNotesPrefType != Services.prefs.PREF_INVALID) {
      let relNotesURL = Services.urlFormatter.formatURLPref(
        "app.releaseNotesURL"
      );
      if (relNotesURL != "about:blank") {
        relNotesLink.href = relNotesURL;
        relNotesLink.hidden = false;
      }
    }

    let distroId = Services.prefs.getCharPref("distribution.id", "");
    if (distroId) {
      let distroString = distroId;

      let distroVersion = Services.prefs.getCharPref(
        "distribution.version",
        ""
      );
      if (distroVersion) {
        distroString += " - " + distroVersion;
      }

      let distroIdField = document.getElementById("distributionId");
      distroIdField.value = distroString;
      distroIdField.hidden = false;

      let distroAbout = Services.prefs.getStringPref("distribution.about", "");
      if (distroAbout) {
        let distroField = document.getElementById("distribution");
        distroField.value = distroAbout;
        distroField.hidden = false;
      }
    }

    if (AppConstants.MOZ_UPDATER) {
      // XXX Workaround bug 1523453 -- changing selectIndex of a <deck> before
      // frame construction could confuse nsDeckFrame::RemoveFrame().
      window.requestAnimationFrame(() => {
        window.requestAnimationFrame(() => {
          gAppUpdater = new appUpdater();
        });
      });
      setEventListener(
        "showUpdateHistory",
        "command",
        gDownloadsPane.showUpdates
      );

      if (Services.policies && !Services.policies.isAllowed("appUpdate")) {
        document.getElementById("updateAllowDescription").hidden = true;
        document.getElementById("updateRadioGroup").hidden = true;
        if (AppConstants.MOZ_MAINTENANCE_SERVICE) {
          document.getElementById("useService").hidden = true;
        }
      } else {
        // Start with no option selected since we are still reading the value
        document.getElementById("autoDesktop").removeAttribute("selected");
        document.getElementById("manualDesktop").removeAttribute("selected");
        // Start reading the correct value from the disk
        this.updateReadPrefs();
        setEventListener(
          "updateRadioGroup",
          "command",
          gDownloadsPane.updateWritePrefs
        );
      }

      if (AppConstants.platform == "win") {
        // On Windows, the Application Update setting is an installation-
        // specific preference, not a profile-specific one. Show a warning to
        // inform users of this.
        let updateContainer = document.getElementById(
          "updateSettingsContainer"
        );
        updateContainer.classList.add("updateSettingCrossUserWarningContainer");
        document.getElementById("updateSettingCrossUserWarning").hidden = false;
      }

      if (AppConstants.MOZ_MAINTENANCE_SERVICE) {
        // Check to see if the maintenance service is installed.
        // If it isn't installed, don't show the preference at all.
        let installed;
        try {
          let wrk = Cc["@mozilla.org/windows-registry-key;1"].createInstance(
            Ci.nsIWindowsRegKey
          );
          wrk.open(
            wrk.ROOT_KEY_LOCAL_MACHINE,
            "SOFTWARE\\Mozilla\\MaintenanceService",
            wrk.ACCESS_READ | wrk.WOW64_64
          );
          installed = wrk.readIntValue("Installed");
          wrk.close();
        } catch (e) {}
        if (installed != 1) {
          document.getElementById("useService").hidden = true;
        }
      }
    }

    Services.obs.addObserver(this, AUTO_UPDATE_CHANGED_TOPIC);

    setEventListener("chooseFolder", "command", gDownloadsPane.chooseFolder);
    setEventListener(
      "saveWhere",
      "command",
      gDownloadsPane.handleSaveToCommand
    );
    Preferences.get("browser.download.folderList").on(
      "change",
      gDownloadsPane.displayDownloadDirPref.bind(gDownloadsPane)
    );
    Preferences.get("browser.download.dir").on(
      "change",
      gDownloadsPane.displayDownloadDirPref.bind(gDownloadsPane)
    );
    gDownloadsPane.displayDownloadDirPref();

    // Listen for window unload so we can remove our preference observers.
    window.addEventListener("unload", this);

    // Notify observers that the UI is now ready
    Services.obs.notifyObservers(window, "downloads-pane-loaded");

    this.setInitialized();
  },
  /**
   * Selects the correct item in the update radio group
   */
  async updateReadPrefs() {
    if (
      AppConstants.MOZ_UPDATER &&
      (!Services.policies || Services.policies.isAllowed("appUpdate"))
    ) {
      let radiogroup = document.getElementById("updateRadioGroup");
      radiogroup.disabled = true;
      try {
        let enabled = await UpdateUtils.getAppUpdateAutoEnabled();
        radiogroup.value = enabled;
        radiogroup.disabled = false;
      } catch (error) {
        Cu.reportError(error);
      }
    }
  },

  /**
   * Writes the value of the update radio group to the disk
   */
  async updateWritePrefs() {
    if (
      AppConstants.MOZ_UPDATER &&
      (!Services.policies || Services.policies.isAllowed("appUpdate"))
    ) {
      let radiogroup = document.getElementById("updateRadioGroup");
      let updateAutoValue = radiogroup.value == "true";
      radiogroup.disabled = true;
      try {
        await UpdateUtils.setAppUpdateAutoEnabled(updateAutoValue);
        radiogroup.disabled = false;
      } catch (error) {
        Cu.reportError(error);
        await this.updateReadPrefs();
        await this.reportUpdatePrefWriteError(error);
      }
    }
  },

  async reportUpdatePrefWriteError(error) {
    let [title, message] = await document.l10n.formatValues([
      { id: "update-pref-write-failure-title" },
      { id: "update-pref-write-failure-message", args: { path: error.path } },
    ]);

    // Set up the Ok Button
    let buttonFlags =
      Services.prompt.BUTTON_POS_0 * Services.prompt.BUTTON_TITLE_OK;
    Services.prompt.confirmEx(
      window,
      title,
      message,
      buttonFlags,
      null,
      null,
      null,
      null,
      {}
    );
  },

  /**
   * Displays the history of installed updates.
   */
  showUpdates() {
    gSubDialog.open("chrome://mozapps/content/update/history.xul");
  },

  destroy() {
    window.removeEventListener("unload", this);

    Services.obs.removeObserver(this, AUTO_UPDATE_CHANGED_TOPIC);
  },
  // nsISupports

  QueryInterface: ChromeUtils.generateQI([Ci.nsIObserver]),

  // nsIObserver

  async observe(aSubject, aTopic, aData) {
    if (aTopic == AUTO_UPDATE_CHANGED_TOPIC) {
      if (aData != "true" && aData != "false") {
        throw new Error("Invalid preference value for app.update.auto");
      }
      document.getElementById("updateRadioGroup").value = aData;
    }
  },
  // EventListener

  handleEvent(aEvent) {
    if (aEvent.type == "unload") {
      this.destroy();
      if (AppConstants.MOZ_UPDATER) {
        onUnload();
      }
    }
  },

  // DOWNLOADS

  /*
   * Preferences:
   *
   * browser.download.useDownloadDir - bool
   *   True - Save files directly to the folder configured via the
   *   browser.download.folderList preference.
   *   False - Always ask the user where to save a file and default to
   *   browser.download.lastDir when displaying a folder picker dialog.
   * browser.download.dir - local file handle
   *   A local folder the user may have selected for downloaded files to be
   *   saved. Migration of other browser settings may also set this path.
   *   This folder is enabled when folderList equals 2.
   * browser.download.lastDir - local file handle
   *   May contain the last folder path accessed when the user browsed
   *   via the file save-as dialog. (see contentAreaUtils.js)
   * browser.download.folderList - int
   *   Indicates the location users wish to save downloaded files too.
   *   It is also used to display special file labels when the default
   *   download location is either the Desktop or the Downloads folder.
   *   Values:
   *     0 - The desktop is the default download location.
   *     1 - The system's downloads folder is the default download location.
   *     2 - The default download location is elsewhere as specified in
   *         browser.download.dir.
   *     3 - The default download location is elsewhere as specified by
   *         cloud storage API getDownloadFolder
   * browser.download.downloadDir
   *   deprecated.
   * browser.download.defaultFolder
   *   deprecated.
   */

  /**
   * Enables/disables the folder field and Browse button based on whether a
   * default download directory is being used.
   */
  readUseDownloadDir() {
    var downloadFolder = document.getElementById("downloadFolder");
    var chooseFolder = document.getElementById("chooseFolder");
    var useDownloadDirPreference = Preferences.get(
      "browser.download.useDownloadDir"
    );
    var dirPreference = Preferences.get("browser.download.dir");

    downloadFolder.disabled =
      !useDownloadDirPreference.value || dirPreference.locked;
    chooseFolder.disabled =
      !useDownloadDirPreference.value || dirPreference.locked;

    this.readCloudStorage().catch(Cu.reportError);
    // don't override the preference's value in UI
    return undefined;
  },

  /**
   * Show/Hide the cloud storage radio button with provider name as label if
   * cloud storage provider is in use.
   * Select cloud storage radio button if browser.download.useDownloadDir is true
   * and browser.download.folderList has value 3. Enables/disables the folder field
   * and Browse button if cloud storage radio button is selected.
   *
   */
  async readCloudStorage() {
    // Get preferred provider in use display name
    let providerDisplayName = await CloudStorage.getProviderIfInUse();
    if (providerDisplayName) {
      // Show cloud storage radio button with provider name in label
      let saveToCloudRadio = document.getElementById("saveToCloud");
      document.l10n.setAttributes(
        saveToCloudRadio,
        "save-files-to-cloud-storage",
        {
          "service-name": providerDisplayName,
        }
      );
      saveToCloudRadio.hidden = false;

      let useDownloadDirPref = Preferences.get(
        "browser.download.useDownloadDir"
      );
      let folderListPref = Preferences.get("browser.download.folderList");

      // Check if useDownloadDir is true and folderListPref is set to Cloud Storage value 3
      // before selecting cloudStorageradio button. Disable folder field and Browse button if
      // 'Save to Cloud Storage Provider' radio option is selected
      if (useDownloadDirPref.value && folderListPref.value === 3) {
        document.getElementById("saveWhere").selectedItem = saveToCloudRadio;
        document.getElementById("downloadFolder").disabled = true;
        document.getElementById("chooseFolder").disabled = true;
      }
    }
  },

  /**
   * Handle clicks to 'Save To <custom path> or <system default downloads>' and
   * 'Save to <cloud storage provider>' if cloud storage radio button is displayed in UI.
   * Sets browser.download.folderList value and Enables/disables the folder field and Browse
   * button based on option selected.
   */
  handleSaveToCommand(event) {
    return this.handleSaveToCommandTask(event).catch(Cu.reportError);
  },
  async handleSaveToCommandTask(event) {
    if (event.target.id !== "saveToCloud" && event.target.id !== "saveTo") {
      return;
    }
    // Check if Save To Cloud Storage Provider radio option is displayed in UI
    // before continuing.
    let saveToCloudRadio = document.getElementById("saveToCloud");
    if (!saveToCloudRadio.hidden) {
      // When switching between SaveTo and SaveToCloud radio button
      // with useDownloadDirPref value true, if selectedIndex is other than
      // SaveTo radio button disable downloadFolder filefield and chooseFolder button
      let saveWhere = document.getElementById("saveWhere");
      let useDownloadDirPref = Preferences.get(
        "browser.download.useDownloadDir"
      );
      if (useDownloadDirPref.value) {
        let downloadFolder = document.getElementById("downloadFolder");
        let chooseFolder = document.getElementById("chooseFolder");
        downloadFolder.disabled =
          saveWhere.selectedIndex || useDownloadDirPref.locked;
        chooseFolder.disabled =
          saveWhere.selectedIndex || useDownloadDirPref.locked;
      }

      // Set folderListPref value depending on radio option
      // selected. folderListPref should be set to 3 if Save To Cloud Storage Provider
      // option is selected. If user switch back to 'Save To' custom path or system
      // default Downloads, check pref 'browser.download.dir' before setting respective
      // folderListPref value. If currentDirPref is unspecified folderList should
      // default to 1
      let folderListPref = Preferences.get("browser.download.folderList");
      let saveTo = document.getElementById("saveTo");
      if (saveWhere.selectedItem == saveToCloudRadio) {
        folderListPref.value = 3;
      } else if (saveWhere.selectedItem == saveTo) {
        let currentDirPref = Preferences.get("browser.download.dir");
        folderListPref.value = currentDirPref.value
          ? await this._folderToIndex(currentDirPref.value)
          : 1;
      }
    }
  },

  /**
   * Displays a file picker in which the user can choose the location where
   * downloads are automatically saved, updating preferences and UI in
   * response to the choice, if one is made.
   */
  chooseFolder() {
    return this.chooseFolderTask().catch(Cu.reportError);
  },
  async chooseFolderTask() {
    let [title] = await document.l10n.formatValues([
      { id: "choose-download-folder-title" },
    ]);
    let folderListPref = Preferences.get("browser.download.folderList");
    let currentDirPref = await this._indexToFolder(folderListPref.value);
    let defDownloads = await this._indexToFolder(1);
    let fp = Cc["@mozilla.org/filepicker;1"].createInstance(Ci.nsIFilePicker);

    fp.init(window, title, Ci.nsIFilePicker.modeGetFolder);
    fp.appendFilters(Ci.nsIFilePicker.filterAll);
    // First try to open what's currently configured
    if (currentDirPref && currentDirPref.exists()) {
      fp.displayDirectory = currentDirPref;
    } else if (defDownloads && defDownloads.exists()) {
      // Try the system's download dir
      fp.displayDirectory = defDownloads;
    } else {
      // Fall back to Desktop
      fp.displayDirectory = await this._indexToFolder(0);
    }

    let result = await new Promise(resolve => fp.open(resolve));
    if (result != Ci.nsIFilePicker.returnOK) {
      return;
    }

    let downloadDirPref = Preferences.get("browser.download.dir");
    downloadDirPref.value = fp.file;
    folderListPref.value = await this._folderToIndex(fp.file);
    // Note, the real prefs will not be updated yet, so dnld manager's
    // userDownloadsDirectory may not return the right folder after
    // this code executes. displayDownloadDirPref will be called on
    // the assignment above to update the UI.
  },

  /**
   * Initializes the download folder display settings based on the user's
   * preferences.
   */
  displayDownloadDirPref() {
    this.displayDownloadDirPrefTask().catch(Cu.reportError);

    // don't override the preference's value in UI
    return undefined;
  },

  async displayDownloadDirPrefTask() {
    var folderListPref = Preferences.get("browser.download.folderList");
    var downloadFolder = document.getElementById("downloadFolder");
    var currentDirPref = Preferences.get("browser.download.dir");

    // Used in defining the correct path to the folder icon.
    var fph = Services.io
      .getProtocolHandler("file")
      .QueryInterface(Ci.nsIFileProtocolHandler);
    var iconUrlSpec;

    let folderIndex = folderListPref.value;
    if (folderIndex == 3) {
      // When user has selected cloud storage, use value in currentDirPref to
      // compute index to display download folder label and icon to avoid
      // displaying blank downloadFolder label and icon on load of preferences UI
      // Set folderIndex to 1 if currentDirPref is unspecified
      folderIndex = currentDirPref.value
        ? await this._folderToIndex(currentDirPref.value)
        : 1;
    }

    // Display a 'pretty' label or the path in the UI.
    // note: downloadFolder.value is not read elsewhere in the code, its only purpose is to display to the user
    if (folderIndex == 2) {
      // Force the left-to-right direction when displaying a custom path.
      downloadFolder.value = currentDirPref.value
        ? `\u2066${currentDirPref.value.path}\u2069`
        : "";
      iconUrlSpec = fph.getURLSpecFromFile(currentDirPref.value);
    } else if (folderIndex == 1) {
      // 'Downloads'
      [downloadFolder.value] = await document.l10n.formatValues([
        { id: "downloads-folder-name" },
      ]);
      iconUrlSpec = fph.getURLSpecFromFile(await this._indexToFolder(1));
    } else {
      // 'Desktop'
      [downloadFolder.value] = await document.l10n.formatValues([
        { id: "desktop-folder-name" },
      ]);
      iconUrlSpec = fph.getURLSpecFromFile(
        await this._getDownloadsFolder("Desktop")
      );
    }
    downloadFolder.style.backgroundImage =
      "url(moz-icon://" + iconUrlSpec + "?size=16)";
  },

  /**
   * Returns the Downloads folder.  If aFolder is "Desktop", then the Downloads
   * folder returned is the desktop folder; otherwise, it is a folder whose name
   * indicates that it is a download folder and whose path is as determined by
   * the XPCOM directory service via the download manager's attribute
   * defaultDownloadsDirectory.
   *
   * @throws if aFolder is not "Desktop" or "Downloads"
   */
  async _getDownloadsFolder(aFolder) {
    switch (aFolder) {
      case "Desktop":
        return Services.dirsvc.get("Desk", Ci.nsIFile);
      case "Downloads":
        let downloadsDir = await Downloads.getSystemDownloadsDirectory();
        return new FileUtils.File(downloadsDir);
    }
    throw new Error(
      "ASSERTION FAILED: folder type should be 'Desktop' or 'Downloads'"
    );
  },

  /**
   * Determines the type of the given folder.
   *
   * @param   aFolder
   *          the folder whose type is to be determined
   * @returns integer
   *          0 if aFolder is the Desktop or is unspecified,
   *          1 if aFolder is the Downloads folder,
   *          2 otherwise
   */
  async _folderToIndex(aFolder) {
    if (!aFolder || aFolder.equals(await this._getDownloadsFolder("Desktop"))) {
      return 0;
    } else if (aFolder.equals(await this._getDownloadsFolder("Downloads"))) {
      return 1;
    }
    return 2;
  },

  /**
   * Converts an integer into the corresponding folder.
   *
   * @param   aIndex
   *          an integer
   * @returns the Desktop folder if aIndex == 0,
   *          the Downloads folder if aIndex == 1,
   *          the folder stored in browser.download.dir
   */
  _indexToFolder(aIndex) {
    switch (aIndex) {
      case 0:
        return this._getDownloadsFolder("Desktop");
      case 1:
        return this._getDownloadsFolder("Downloads");
    }
    var currentDirPref = Preferences.get("browser.download.dir");
    return currentDirPref.value;
  },
};

gDownloadsPane.initialized = new Promise(res => {
  gDownloadsPane.setInitialized = res;
});
