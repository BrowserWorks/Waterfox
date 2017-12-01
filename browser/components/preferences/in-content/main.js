/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from preferences.js */

Components.utils.import("resource://gre/modules/Downloads.jsm");
Components.utils.import("resource://gre/modules/FileUtils.jsm");
Components.utils.import("resource:///modules/ShellService.jsm");
Components.utils.import("resource:///modules/TransientPrefs.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "OS",
                                  "resource://gre/modules/osfile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "CloudStorage",
                                  "resource://gre/modules/CloudStorage.jsm");

if (AppConstants.E10S_TESTING_ONLY) {
  XPCOMUtils.defineLazyModuleGetter(this, "UpdateUtils",
                                    "resource://gre/modules/UpdateUtils.jsm");
}

if (AppConstants.MOZ_DEV_EDITION) {
  XPCOMUtils.defineLazyModuleGetter(this, "fxAccounts",
                                    "resource://gre/modules/FxAccounts.jsm");
}

var gMainPane = {
  /**
   * Initialization of this.
   */
  init() {
    function setEventListener(aId, aEventType, aCallback) {
      document.getElementById(aId)
              .addEventListener(aEventType, aCallback.bind(gMainPane));
    }
    this.getDefaultLocale();
    if (AppConstants.HAVE_SHELL_SERVICE) {
      this.updateSetDefaultBrowser();
      if (AppConstants.platform == "win") {
        // In Windows 8 we launch the control panel since it's the only
        // way to get all file type association prefs. So we don't know
        // when the user will select the default.  We refresh here periodically
        // in case the default changes. On other Windows OS's defaults can also
        // be set while the prefs are open.
        window.setInterval(this.updateSetDefaultBrowser.bind(this), 1000);
      }
    }

    this.buildContentProcessCountMenuList();
    this.updateDefaultPerformanceSettingsPref();

    let defaultPerformancePref =
      document.getElementById("browser.preferences.defaultPerformanceSettings.enabled");
    defaultPerformancePref.addEventListener("change", () => {
      this.updatePerformanceSettingsBox({duringChangeEvent: true});
    });
    this.updatePerformanceSettingsBox({duringChangeEvent: false});

    let performanceSettingsLink = document.getElementById("performanceSettingsLearnMore");
    let performanceSettingsUrl = Services.urlFormatter.formatURLPref("app.support.baseURL") + "performance";
    performanceSettingsLink.setAttribute("href", performanceSettingsUrl);

    // set up the "use current page" label-changing listener
    this._updateUseCurrentButton();
    window.addEventListener("focus", this._updateUseCurrentButton.bind(this));

    this.updateBrowserStartupLastSession();

    if (AppConstants.platform == "win") {
      // Functionality for "Show tabs in taskbar" on Windows 7 and up.
      try {
        let sysInfo = Cc["@mozilla.org/system-info;1"].
                      getService(Ci.nsIPropertyBag2);
        let ver = parseFloat(sysInfo.getProperty("version"));
        let showTabsInTaskbar = document.getElementById("showTabsInTaskbar");
        showTabsInTaskbar.hidden = ver < 6.1;
      } catch (ex) {}
    }

    // The "closing multiple tabs" and "opening multiple tabs might slow down
    // &brandShortName;" warnings provide options for not showing these
    // warnings again. When the user disabled them, we provide checkboxes to
    // re-enable the warnings.
    if (!TransientPrefs.prefShouldBeVisible("browser.tabs.warnOnClose"))
      document.getElementById("warnCloseMultiple").hidden = true;
    if (!TransientPrefs.prefShouldBeVisible("browser.tabs.warnOnOpen"))
      document.getElementById("warnOpenMany").hidden = true;

    setEventListener("browser.privatebrowsing.autostart", "change",
                     gMainPane.updateBrowserStartupLastSession);
    setEventListener("browser.download.dir", "change",
                     gMainPane.displayDownloadDirPref);
    setEventListener("saveWhere", "command",
                     gMainPane.handleSaveToCommand);
    if (AppConstants.HAVE_SHELL_SERVICE) {
      setEventListener("setDefaultButton", "command",
                       gMainPane.setDefaultBrowser);
    }
    setEventListener("useCurrent", "command",
                     gMainPane.setHomePageToCurrent);
    setEventListener("useBookmark", "command",
                     gMainPane.setHomePageToBookmark);
    setEventListener("restoreDefaultHomePage", "command",
                     gMainPane.restoreDefaultHomePage);
    setEventListener("chooseFolder", "command",
                     gMainPane.chooseFolder);

    setEventListener("localeSelect", "popuphidden", function () {
      gMainPane.updateLocale();
    });
    setEventListener("localeSelect", "keypress", function (e) {
      gMainPane._updateLocale(e);
    });

    if (AppConstants.E10S_TESTING_ONLY) {
      setEventListener("e10sAutoStart", "command",
                       gMainPane.enableE10SChange);
      let e10sCheckbox = document.getElementById("e10sAutoStart");

      let e10sPref = document.getElementById("browser.tabs.remote.autostart");
      let e10sTempPref = document.getElementById("e10sTempPref");
      let e10sForceEnable = document.getElementById("e10sForceEnable");

      let preffedOn = e10sPref.value || e10sTempPref.value || e10sForceEnable.value;

      if (preffedOn) {
        // The checkbox is checked if e10s is preffed on and enabled.
        e10sCheckbox.checked = Services.appinfo.browserTabsRemoteAutostart;

        // but if it's force disabled, then the checkbox is disabled.
        e10sCheckbox.disabled = !Services.appinfo.browserTabsRemoteAutostart;
      }
    }

    if (AppConstants.MOZ_DEV_EDITION) {
      let uAppData = OS.Constants.Path.userApplicationDataDir;
      let ignoreSeparateProfile = OS.Path.join(uAppData, "ignore-dev-edition-profile");

      setEventListener("separateProfileMode", "command", gMainPane.separateProfileModeChange);
      let separateProfileModeCheckbox = document.getElementById("separateProfileMode");
      setEventListener("getStarted", "click", gMainPane.onGetStarted);

      OS.File.stat(ignoreSeparateProfile).then(() => separateProfileModeCheckbox.checked = false,
                                               () => separateProfileModeCheckbox.checked = true);

      fxAccounts.getSignedInUser().then(data => {
        document.getElementById("getStarted").selectedIndex = data ? 1 : 0;
      });
    }

    // Notify observers that the UI is now ready
    Components.classes["@mozilla.org/observer-service;1"]
              .getService(Components.interfaces.nsIObserverService)
              .notifyObservers(window, "main-pane-loaded");
  },

  isE10SEnabled() {
    let e10sEnabled;
    try {
      let e10sStatus = Components.classes["@mozilla.org/supports-PRUint64;1"]
                         .createInstance(Ci.nsISupportsPRUint64);
      let appinfo = Services.appinfo.QueryInterface(Ci.nsIObserver);
      appinfo.observe(e10sStatus, "getE10SBlocked", "");
      e10sEnabled = e10sStatus.data < 2;
    } catch (e) {
      e10sEnabled = false;
    }

    return e10sEnabled;
  },

  // Sets language selector to current locale value
  getDefaultLocale: function(){
	  let selectedLocale = document.getElementById("localeSelect");
	  if (selectedLocale){
	  	selectedLocale.value = Services.prefs.getCharPref('general.useragent.locale');
	  }
  },
  
  updateLocale: function ()
  {
    let alertsService = Cc["@mozilla.org/alerts-service;1"].getService(Ci.nsIAlertsService);
    let selectedLocale = document.getElementById("localeSelect").value;
    let contentLocaleUpdate = selectedLocale + ",en-us,en";
    let contentLocaleUpdated = contentLocaleUpdate.toLowerCase();

    if (selectedLocale === Services.prefs.getCharPref('general.useragent.locale')) return;
	
    if (selectedLocale != "") {
      Services.prefs.setCharPref('general.useragent.locale', selectedLocale);
      Services.prefs.setCharPref('intl.accept_languages', contentLocaleUpdated);
      Services.prefs.setBoolPref('intl.locale.matchOS', false);
      alertsService.showAlertNotification("",  "Restart Waterfox", "You'll need to restart Waterfox to see your selected locale.");
    }
  },
  _updateLocale: function (e)
  {
    if (e.which == 13 || e.keyCode == 13){
		  this.updateLocale();
    }
},
    
  enableE10SChange() {
    if (AppConstants.E10S_TESTING_ONLY) {
      let e10sCheckbox = document.getElementById("e10sAutoStart");
      let e10sPref = document.getElementById("browser.tabs.remote.autostart");
      let e10sTempPref = document.getElementById("e10sTempPref");

      let prefsToChange;
      if (e10sCheckbox.checked) {
        // Enabling e10s autostart
        prefsToChange = [e10sPref];
      } else {
        // Disabling e10s autostart
        prefsToChange = [e10sPref];
        if (e10sTempPref.value) {
         prefsToChange.push(e10sTempPref);
        }
      }

      let buttonIndex = confirmRestartPrompt(e10sCheckbox.checked, 0,
                                             true, false);
      if (buttonIndex == CONFIRM_RESTART_PROMPT_RESTART_NOW) {
        for (let prefToChange of prefsToChange) {
          prefToChange.value = e10sCheckbox.checked;
        }

        Services.startup.quit(Ci.nsIAppStartup.eAttemptQuit | Ci.nsIAppStartup.eRestart);
      }

      // Revert the checkbox in case we didn't quit
      e10sCheckbox.checked = e10sPref.value || e10sTempPref.value;
    }
  },

  separateProfileModeChange() {
    if (AppConstants.MOZ_DEV_EDITION) {
      function quitApp() {
        Services.startup.quit(Ci.nsIAppStartup.eAttemptQuit | Ci.nsIAppStartup.eRestartNotSameProfile);
      }
      function revertCheckbox(error) {
        separateProfileModeCheckbox.checked = !separateProfileModeCheckbox.checked;
        if (error) {
          Cu.reportError("Failed to toggle separate profile mode: " + error);
        }
      }
      function createOrRemoveSpecialDevEditionFile(onSuccess) {
        let uAppData = OS.Constants.Path.userApplicationDataDir;
        let ignoreSeparateProfile = OS.Path.join(uAppData, "ignore-dev-edition-profile");

        if (separateProfileModeCheckbox.checked) {
          OS.File.remove(ignoreSeparateProfile).then(onSuccess, revertCheckbox);
        } else {
          OS.File.writeAtomic(ignoreSeparateProfile, new Uint8Array()).then(onSuccess, revertCheckbox);
        }
      }

      let separateProfileModeCheckbox = document.getElementById("separateProfileMode");
      let button_index = confirmRestartPrompt(separateProfileModeCheckbox.checked,
                                              0, false, true);
      switch (button_index) {
        case CONFIRM_RESTART_PROMPT_CANCEL:
          revertCheckbox();
          return;
        case CONFIRM_RESTART_PROMPT_RESTART_NOW:
          const Cc = Components.classes, Ci = Components.interfaces;
          let cancelQuit = Cc["@mozilla.org/supports-PRBool;1"]
                             .createInstance(Ci.nsISupportsPRBool);
          Services.obs.notifyObservers(cancelQuit, "quit-application-requested",
                                        "restart");
          if (!cancelQuit.data) {
            createOrRemoveSpecialDevEditionFile(quitApp);
            return;
          }

          // Revert the checkbox in case we didn't quit
          revertCheckbox();
          return;
        case CONFIRM_RESTART_PROMPT_RESTART_LATER:
          createOrRemoveSpecialDevEditionFile();
      }
    }
  },

  onGetStarted(aEvent) {
    if (AppConstants.MOZ_DEV_EDITION) {
      const Cc = Components.classes, Ci = Components.interfaces;
      let wm = Cc["@mozilla.org/appshell/window-mediator;1"]
                  .getService(Ci.nsIWindowMediator);
      let win = wm.getMostRecentWindow("navigator:browser");

      fxAccounts.getSignedInUser().then(data => {
        if (win) {
          if (data) {
            // We have a user, open Sync preferences in the same tab
            win.openUILinkIn("about:preferences#sync", "current");
            return;
          }
          let accountsTab = win.gBrowser.addTab("about:accounts?action=signin&entrypoint=dev-edition-setup");
          win.gBrowser.selectedTab = accountsTab;
        }
      });
    }
  },

  // HOME PAGE

  /*
   * Preferences:
   *
   * browser.startup.homepage
   * - the user's home page, as a string; if the home page is a set of tabs,
   *   this will be those URLs separated by the pipe character "|"
   * browser.startup.page
   * - what page(s) to show when the user starts the application, as an integer:
   *
   *     0: a blank page
   *     1: the home page (as set by the browser.startup.homepage pref)
   *     2: the last page the user visited (DEPRECATED)
   *     3: windows and tabs from the last session (a.k.a. session restore)
   *
   *   The deprecated option is not exposed in UI; however, if the user has it
   *   selected and doesn't change the UI for this preference, the deprecated
   *   option is preserved.
   */

  syncFromHomePref() {
    let homePref = document.getElementById("browser.startup.homepage");

    // If the pref is set to about:home or about:newtab, set the value to ""
    // to show the placeholder text (about:home title) rather than
    // exposing those URLs to users.
    let defaultBranch = Services.prefs.getDefaultBranch("");
    let defaultValue = defaultBranch.getComplexValue("browser.startup.homepage",
                                                     Ci.nsIPrefLocalizedString).data;
    let currentValue = homePref.value.toLowerCase();
    if (currentValue == "about:home" ||
        (currentValue == defaultValue && currentValue == "about:newtab")) {
      return "";
    }

    // If the pref is actually "", show about:blank.  The actual home page
    // loading code treats them the same, and we don't want the placeholder text
    // to be shown.
    if (homePref.value == "")
      return "about:blank";

    // Otherwise, show the actual pref value.
    return undefined;
  },

  syncToHomePref(value) {
    // If the value is "", use about:home.
    if (value == "")
      return "about:home";

    // Otherwise, use the actual textbox value.
    return undefined;
  },

  /**
   * Sets the home page to the current displayed page (or frontmost tab, if the
   * most recent browser window contains multiple tabs), updating preference
   * window UI to reflect this.
   */
  setHomePageToCurrent() {
    let homePage = document.getElementById("browser.startup.homepage");
    let tabs = this._getTabsForHomePage();
    function getTabURI(t) {
      return t.linkedBrowser.currentURI.spec;
    }

    // FIXME Bug 244192: using dangerous "|" joiner!
    if (tabs.length)
      homePage.value = tabs.map(getTabURI).join("|");
  },

  /**
   * Displays a dialog in which the user can select a bookmark to use as home
   * page.  If the user selects a bookmark, that bookmark's name is displayed in
   * UI and the bookmark's address is stored to the home page preference.
   */
  setHomePageToBookmark() {
    var rv = { urls: null, names: null };
    gSubDialog.open("chrome://browser/content/preferences/selectBookmark.xul",
                    "resizable=yes, modal=yes", rv,
                    this._setHomePageToBookmarkClosed.bind(this, rv));
  },

  _setHomePageToBookmarkClosed(rv, aEvent) {
    if (aEvent.detail.button != "accept")
      return;
    if (rv.urls && rv.names) {
      var homePage = document.getElementById("browser.startup.homepage");

      // XXX still using dangerous "|" joiner!
      homePage.value = rv.urls.join("|");
    }
  },

  /**
   * Switches the "Use Current Page" button between its singular and plural
   * forms.
   */
  _updateUseCurrentButton() {
    let useCurrent = document.getElementById("useCurrent");


    let tabs = this._getTabsForHomePage();

    if (tabs.length > 1)
      useCurrent.label = useCurrent.getAttribute("label2");
    else
      useCurrent.label = useCurrent.getAttribute("label1");

    // In this case, the button's disabled state is set by preferences.xml.
    let prefName = "pref.browser.homepage.disable_button.current_page";
    if (document.getElementById(prefName).locked)
      return;

    useCurrent.disabled = !tabs.length
  },

  _getTabsForHomePage() {
    var win;
    var tabs = [];

    const Cc = Components.classes, Ci = Components.interfaces;
    var wm = Cc["@mozilla.org/appshell/window-mediator;1"]
                .getService(Ci.nsIWindowMediator);
    win = wm.getMostRecentWindow("navigator:browser");

    if (win && win.document.documentElement
                  .getAttribute("windowtype") == "navigator:browser") {
      // We should only include visible & non-pinned tabs

      tabs = win.gBrowser.visibleTabs.slice(win.gBrowser._numPinnedTabs);
      tabs = tabs.filter(this.isNotAboutPreferences);
    }

    return tabs;
  },

  /**
   * Check to see if a tab is not about:preferences
   */
  isNotAboutPreferences(aElement, aIndex, aArray) {
    return !aElement.linkedBrowser.currentURI.spec.startsWith("about:preferences");
  },

  /**
   * Restores the default home page as the user's home page.
   */
  restoreDefaultHomePage() {
    var homePage = document.getElementById("browser.startup.homepage");
    homePage.value = homePage.defaultValue;
  },

  updateDefaultPerformanceSettingsPref() {
    let defaultPerformancePref =
      document.getElementById("browser.preferences.defaultPerformanceSettings.enabled");
    let processCountPref = document.getElementById("dom.ipc.processCount");
    let accelerationPref = document.getElementById("layers.acceleration.disabled");
    if (processCountPref.value != processCountPref.defaultValue ||
        accelerationPref.value != accelerationPref.defaultValue) {
      defaultPerformancePref.value = false;
    }
  },

  updatePerformanceSettingsBox({duringChangeEvent}) {
    let defaultPerformancePref =
      document.getElementById("browser.preferences.defaultPerformanceSettings.enabled");
    let performanceSettings = document.getElementById("performanceSettings");
    let processCountPref = document.getElementById("dom.ipc.processCount");
    if (defaultPerformancePref.value) {
      let accelerationPref = document.getElementById("layers.acceleration.disabled");
      // Unset the value so process count will be decided by e10s rollout.
      processCountPref.value = processCountPref.defaultValue;
      accelerationPref.value = accelerationPref.defaultValue;
      performanceSettings.hidden = true;
    } else {
      let e10sRolloutProcessCountPref =
        document.getElementById("dom.ipc.processCount.web");
      // Take the e10s rollout value as the default value (if it exists),
      // but don't overwrite the user set value.
      if (duringChangeEvent &&
          e10sRolloutProcessCountPref.value &&
          processCountPref.value == processCountPref.defaultValue) {
        processCountPref.value = e10sRolloutProcessCountPref.value;
      }
      performanceSettings.hidden = false;
    }
  },

  buildContentProcessCountMenuList() {
    if (gMainPane.isE10SEnabled()) {
      let processCountPref = document.getElementById("dom.ipc.processCount");
      let e10sRolloutProcessCountPref =
        document.getElementById("dom.ipc.processCount.web");
      let defaultProcessCount =
        e10sRolloutProcessCountPref.value || processCountPref.defaultValue;
      let bundlePreferences = document.getElementById("bundlePreferences");
      let label = bundlePreferences.getFormattedString("defaultContentProcessCount",
        [defaultProcessCount]);
      let contentProcessCount =
        document.querySelector(`#contentProcessCount > menupopup >
                                menuitem[value="${defaultProcessCount}"]`);
      contentProcessCount.label = label;

      document.getElementById("limitContentProcess").disabled = false;
      document.getElementById("contentProcessCount").disabled = false;
      document.getElementById("contentProcessCountEnabledDescription").hidden = false;
      document.getElementById("contentProcessCountDisabledDescription").hidden = true;
    } else {
      document.getElementById("limitContentProcess").disabled = true;
      document.getElementById("contentProcessCount").disabled = true;
      document.getElementById("contentProcessCountEnabledDescription").hidden = true;
      document.getElementById("contentProcessCountDisabledDescription").hidden = false;
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
    var preference = document.getElementById("browser.download.useDownloadDir");
    downloadFolder.disabled = !preference.value || preference.locked;
    chooseFolder.disabled = !preference.value || preference.locked;

    this.readCloudStorage().catch(Components.utils.reportError);
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
      let cloudStrings = Services.strings.createBundle("resource://cloudstorage/preferences.properties");
      saveToCloudRadio.label = cloudStrings.formatStringFromName("saveFilesToCloudStorage",
                                                                 [providerDisplayName], 1);
      saveToCloudRadio.hidden = false;

      let useDownloadDirPref = document.getElementById("browser.download.useDownloadDir");
      let folderListPref = document.getElementById("browser.download.folderList");

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
    return this.handleSaveToCommandTask(event).catch(Components.utils.reportError);
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
      let useDownloadDirPref = document.getElementById("browser.download.useDownloadDir");
      if (useDownloadDirPref.value) {
        let downloadFolder = document.getElementById("downloadFolder");
        let chooseFolder = document.getElementById("chooseFolder");
        downloadFolder.disabled = saveWhere.selectedIndex || useDownloadDirPref.locked;
        chooseFolder.disabled = saveWhere.selectedIndex || useDownloadDirPref.locked;
      }

      // Set folderListPref value depending on radio option
      // selected. folderListPref should be set to 3 if Save To Cloud Storage Provider
      // option is selected. If user switch back to 'Save To' custom path or system
      // default Downloads, check pref 'browser.download.dir' before setting respective
      // folderListPref value. If currentDirPref is unspecified folderList should
      // default to 1
      let folderListPref = document.getElementById("browser.download.folderList");
      let saveTo = document.getElementById("saveTo");
      if (saveWhere.selectedItem == saveToCloudRadio) {
        folderListPref.value = 3;
      } else if (saveWhere.selectedItem == saveTo) {
        let currentDirPref = document.getElementById("browser.download.dir");
        folderListPref.value = currentDirPref.value ? await this._folderToIndex(currentDirPref.value) : 1;
      }
    }
  },

  /**
   * Displays a file picker in which the user can choose the location where
   * downloads are automatically saved, updating preferences and UI in
   * response to the choice, if one is made.
   */
  chooseFolder() {
    return this.chooseFolderTask().catch(Components.utils.reportError);
  },
  async chooseFolderTask() {
    let bundlePreferences = document.getElementById("bundlePreferences");
    let title = bundlePreferences.getString("chooseDownloadFolderTitle");
    let folderListPref = document.getElementById("browser.download.folderList");
    let currentDirPref = await this._indexToFolder(folderListPref.value);
    let defDownloads = await this._indexToFolder(1);
    let fp = Components.classes["@mozilla.org/filepicker;1"].
             createInstance(Components.interfaces.nsIFilePicker);

    fp.init(window, title, Components.interfaces.nsIFilePicker.modeGetFolder);
    fp.appendFilters(Components.interfaces.nsIFilePicker.filterAll);
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
    if (result != Components.interfaces.nsIFilePicker.returnOK) {
      return;
    }

    let downloadDirPref = document.getElementById("browser.download.dir");
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
    this.displayDownloadDirPrefTask().catch(Components.utils.reportError);

    // don't override the preference's value in UI
    return undefined;
  },

  async displayDownloadDirPrefTask() {
    var folderListPref = document.getElementById("browser.download.folderList");
    var bundlePreferences = document.getElementById("bundlePreferences");
    var downloadFolder = document.getElementById("downloadFolder");
    var currentDirPref = document.getElementById("browser.download.dir");

    // Used in defining the correct path to the folder icon.
    var ios = Components.classes["@mozilla.org/network/io-service;1"]
                        .getService(Components.interfaces.nsIIOService);
    var fph = ios.getProtocolHandler("file")
                 .QueryInterface(Components.interfaces.nsIFileProtocolHandler);
    var iconUrlSpec;

    let folderIndex = folderListPref.value;
    if (folderIndex == 3) {
      // When user has selected cloud storage, use value in currentDirPref to
      // compute index to display download folder label and icon to avoid
      // displaying blank downloadFolder label and icon on load of preferences UI
      // Set folderIndex to 1 if currentDirPref is unspecified
      folderIndex = currentDirPref.value ? await this._folderToIndex(currentDirPref.value) : 1;
    }

    // Display a 'pretty' label or the path in the UI.
    if (folderIndex == 2) {
      // Custom path selected and is configured
      downloadFolder.label = this._getDisplayNameOfFile(currentDirPref.value);
      iconUrlSpec = fph.getURLSpecFromFile(currentDirPref.value);
    } else if (folderIndex == 1) {
      // 'Downloads'
      downloadFolder.label = bundlePreferences.getString("downloadsFolderName");
      iconUrlSpec = fph.getURLSpecFromFile(await this._indexToFolder(1));
    } else {
      // 'Desktop'
      downloadFolder.label = bundlePreferences.getString("desktopFolderName");
      iconUrlSpec = fph.getURLSpecFromFile(await this._getDownloadsFolder("Desktop"));
    }
    downloadFolder.image = "moz-icon://" + iconUrlSpec + "?size=16";
  },

  /**
   * Returns the textual path of a folder in readable form.
   */
  _getDisplayNameOfFile(aFolder) {
    // TODO: would like to add support for 'Downloads on Macintosh HD'
    //       for OS X users.
    return aFolder ? aFolder.path : "";
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
        var fileLoc = Components.classes["@mozilla.org/file/directory_service;1"]
                                    .getService(Components.interfaces.nsIProperties);
        return fileLoc.get("Desk", Components.interfaces.nsILocalFile);
      case "Downloads":
        let downloadsDir = await Downloads.getSystemDownloadsDirectory();
        return new FileUtils.File(downloadsDir);
    }
    throw "ASSERTION FAILED: folder type should be 'Desktop' or 'Downloads'";
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
    if (!aFolder || aFolder.equals(await this._getDownloadsFolder("Desktop")))
      return 0;
    else if (aFolder.equals(await this._getDownloadsFolder("Downloads")))
      return 1;
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
    var currentDirPref = document.getElementById("browser.download.dir");
    return currentDirPref.value;
  },

  /**
   * Hide/show the "Show my windows and tabs from last time" option based
   * on the value of the browser.privatebrowsing.autostart pref.
   */
  updateBrowserStartupLastSession() {
    let pbAutoStartPref = document.getElementById("browser.privatebrowsing.autostart");
    let startupPref = document.getElementById("browser.startup.page");
    let menu = document.getElementById("browserStartupPage");
    let option = document.getElementById("browserStartupLastSession");
    if (pbAutoStartPref.value) {
      option.setAttribute("disabled", "true");
      if (option.selected) {
        menu.selectedItem = document.getElementById("browserStartupHomePage");
      }
    } else {
      option.removeAttribute("disabled");
      startupPref.updateElements(); // select the correct index in the startup menulist
    }
  },

  // TABS

  /*
   * Preferences:
   *
   * browser.link.open_newwindow - int
   *   Determines where links targeting new windows should open.
   *   Values:
   *     1 - Open in the current window or tab.
   *     2 - Open in a new window.
   *     3 - Open in a new tab in the most recent window.
   * browser.tabs.loadInBackground - bool
   *   True - Whether browser should switch to a new tab opened from a link.
   * browser.tabs.warnOnClose - bool
   *   True - If when closing a window with multiple tabs the user is warned and
   *          allowed to cancel the action, false to just close the window.
   * browser.tabs.warnOnOpen - bool
   *   True - Whether the user should be warned when trying to open a lot of
   *          tabs at once (e.g. a large folder of bookmarks), allowing to
   *          cancel the action.
   * browser.taskbar.previews.enable - bool
   *   True - Tabs are to be shown in Windows 7 taskbar.
   *   False - Only the window is to be shown in Windows 7 taskbar.
   */

  /**
   * Determines where a link which opens a new window will open.
   *
   * @returns |true| if such links should be opened in new tabs
   */
  readLinkTarget() {
    var openNewWindow = document.getElementById("browser.link.open_newwindow");
    return openNewWindow.value != 2;
  },

  /**
   * Determines where a link which opens a new window will open.
   *
   * @returns 2 if such links should be opened in new windows,
   *          3 if such links should be opened in new tabs
   */
  writeLinkTarget() {
    var linkTargeting = document.getElementById("linkTargeting");
    return linkTargeting.checked ? 3 : 2;
  },
  /*
   * Preferences:
   *
   * browser.shell.checkDefault
   * - true if a default-browser check (and prompt to make it so if necessary)
   *   occurs at startup, false otherwise
   */

  /**
   * Show button for setting browser as default browser or information that
   * browser is already the default browser.
   */
  updateSetDefaultBrowser() {
    if (AppConstants.HAVE_SHELL_SERVICE) {
      let shellSvc = getShellService();
      let defaultBrowserBox = document.getElementById("defaultBrowserBox");
      if (!shellSvc) {
        defaultBrowserBox.hidden = true;
        return;
      }
      let setDefaultPane = document.getElementById("setDefaultPane");
      let isDefault = shellSvc.isDefaultBrowser(false, true);
      setDefaultPane.selectedIndex = isDefault ? 1 : 0;
      let alwaysCheck = document.getElementById("alwaysCheckDefault");
      alwaysCheck.disabled = alwaysCheck.disabled ||
                             isDefault && alwaysCheck.checked;
    }
  },

  /**
   * Set browser as the operating system default browser.
   */
  setDefaultBrowser() {
    if (AppConstants.HAVE_SHELL_SERVICE) {
      let alwaysCheckPref = document.getElementById("browser.shell.checkDefaultBrowser");
      alwaysCheckPref.value = true;

      let shellSvc = getShellService();
      if (!shellSvc)
        return;
      try {
        shellSvc.setDefaultBrowser(true, false);
      } catch (ex) {
        Cu.reportError(ex);
        return;
      }

      let selectedIndex = shellSvc.isDefaultBrowser(false, true) ? 1 : 0;
      document.getElementById("setDefaultPane").selectedIndex = selectedIndex;
    }
  },
};
