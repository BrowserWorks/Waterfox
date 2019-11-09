/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from extensionControlled.js */
/* import-globals-from preferences.js */
/* import-globals-from main.js */
/* import-globals-from ../../../../toolkit/mozapps/preferences/fontbuilder.js */

XPCOMUtils.defineLazyServiceGetters(this, {
  gHandlerService: [
    "@mozilla.org/uriloader/handler-service;1",
    "nsIHandlerService",
  ],
  gMIMEService: ["@mozilla.org/mime;1", "nsIMIMEService"],
});

Preferences.addAll([
  {
    id: "browser.preferences.defaultPerformanceSettings.enabled",
    type: "bool",
  },
  { id: "dom.ipc.processCount", type: "int" },
  { id: "dom.ipc.processCount.web", type: "int" },
  { id: "layers.acceleration.disabled", type: "bool", inverted: true },
  /* Accessibility
   * accessibility.browsewithcaret
     - true enables keyboard navigation and selection within web pages using a
       visible caret, false uses normal keyboard navigation with no caret
   * accessibility.typeaheadfind
     - when set to true, typing outside text areas and input boxes will
       automatically start searching for what's typed within the current
       document; when set to false, no search action happens */
  { id: "accessibility.browsewithcaret", type: "bool" },
  { id: "accessibility.typeaheadfind", type: "bool" },
  { id: "accessibility.blockautorefresh", type: "bool" },

  /* Browsing
        * general.autoScroll
          - when set to true, clicking the scroll wheel on the mouse activates a
            mouse mode where moving the mouse down scrolls the document downward with
            speed correlated with the distance of the cursor from the original
            position at which the click occurred (and likewise with movement upward);
            if false, this behavior is disabled
        * general.smoothScroll
          - set to true to enable finer page scrolling than line-by-line on page-up,
            page-down, and other such page movements */
  { id: "general.autoScroll", type: "bool" },
  { id: "general.smoothScroll", type: "bool" },
  { id: "layout.spellcheckDefault", type: "int" },

  // Applications
  { id: "pref.downloads.disable_button.edit_actions", type: "bool" },

  // DRM content
  { id: "media.eme.enabled", type: "bool" },

  // Fonts
  { id: "font.language.group", type: "wstring" },

  // CFR
  {
    id: "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons",
    type: "bool",
  },
  {
    id: "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features",
    type: "bool",
  },
]);

var { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

// A promise that resolves when the list of application handlers is loaded.
// We store this in a global so tests can await it.
var promiseLoadHandlersList;

const TYPE_PDF = "application/pdf";

const PREF_PDFJS_DISABLED = "pdfjs.disabled";
const TOPIC_PDFJS_HANDLER_CHANGED = "pdfjs:handlerChanged";

const PREF_DISABLED_PLUGIN_TYPES = "plugin.disable_full_page_plugin_for_types";

// Preferences that affect which entries to show in the list.
const PREF_SHOW_PLUGINS_IN_LIST = "browser.download.show_plugins_in_list";
const PREF_HIDE_PLUGINS_WITHOUT_EXTENSIONS =
  "browser.download.hide_plugins_without_extensions";

const AUTO_UPDATE_CHANGED_TOPIC = "auto-update-config-change";

// The nsHandlerInfoAction enumeration values in nsIHandlerInfo identify
// the actions the application can take with content of various types.
// But since nsIHandlerInfo doesn't support plugins, there's no value
// identifying the "use plugin" action, so we use this constant instead.
const kActionUsePlugin = 5;

const ICON_URL_APP =
  AppConstants.platform == "linux"
    ? "moz-icon://dummy.exe?size=16"
    : "chrome://browser/skin/preferences/application.png";

// For CSS. Can be one of "ask", "save" or "plugin". If absent, the icon URL
// was set by us to a custom handler icon and CSS should not try to override it.
const APP_ICON_ATTR_NAME = "appHandlerIcon";

ChromeUtils.defineModuleGetter(this, "OS", "resource://gre/modules/osfile.jsm");

var gWebpagesPane = {

  // The list of types we can show, sorted by the sort column/direction.
  // An array of HandlerInfoWrapper objects.  We build this list when we first
  // load the data and then rebuild it when users change a pref that affects
  // what types we can show or change the sort column/direction.
  // Note: this isn't necessarily the list of types we *will* show; if the user
  // provides a filter string, we'll only show the subset of types in this list
  // that match that string.
  _visibleTypes: [],

  // The set of types the app knows how to handle.  A hash of HandlerInfoWrapper
  // objects, indexed by type.
  _handledTypes: {},

  init() {
    function setEventListener(aId, aEventType, aCallback) {
      document
        .getElementById(aId)
        .addEventListener(aEventType, aCallback.bind(gWebpagesPane));
    }

    this.buildContentProcessCountMenuList();

    let performanceSettingsLink = document.getElementById(
      "performanceSettingsLearnMore"
    );
    let performanceSettingsUrl =
      Services.urlFormatter.formatURLPref("app.support.baseURL") +
      "performance";
    performanceSettingsLink.setAttribute("href", performanceSettingsUrl);

    this.updateDefaultPerformanceSettingsPref();

    let defaultPerformancePref = Preferences.get(
      "browser.preferences.defaultPerformanceSettings.enabled"
    );
    defaultPerformancePref.on("change", () => {
      this.updatePerformanceSettingsBox({ duringChangeEvent: true });
    });
    this.updatePerformanceSettingsBox({ duringChangeEvent: false });

    Preferences.get("layers.acceleration.disabled").on(
      "change",
      gWebpagesPane.updateHardwareAcceleration.bind(gWebpagesPane)
    );

    this.updateOnScreenKeyboardVisibility();
    let cfrLearnMoreUrl =
      Services.urlFormatter.formatURLPref("app.support.baseURL") +
      "extensionrecommendations";
    for (const id of ["cfrLearnMore", "cfrFeaturesLearnMore"]) {
      let link = document.getElementById(id);
      link.setAttribute("href", cfrLearnMoreUrl);
    }

    Preferences.get("font.language.group").on(
      "change",
      gWebpagesPane._rebuildFonts.bind(gWebpagesPane)
    );
    setEventListener("colors", "command", gWebpagesPane.configureColors);
    setEventListener("advancedFonts", "command", gWebpagesPane.configureFonts);

    // Initializes the fonts dropdowns displayed in this pane.
    this._rebuildFonts();
    let drmInfoURL =
      Services.urlFormatter.formatURLPref("app.support.baseURL") +
      "drm-content";
    document
      .getElementById("playDRMContentLink")
      .setAttribute("href", drmInfoURL);
    let emeUIEnabled = Services.prefs.getBoolPref("browser.eme.ui.enabled");
    // Force-disable/hide on WinXP:
    if (navigator.platform.toLowerCase().startsWith("win")) {
      emeUIEnabled =
        emeUIEnabled && parseFloat(Services.sysinfo.get("version")) >= 6;
    }
    if (!emeUIEnabled) {
      // Don't want to rely on .hidden for the toplevel groupbox because
      // of the pane hiding/showing code potentially interfering:
      document
        .getElementById("drmGroup")
        .setAttribute("style", "display: none !important");
    }

    // Initilize Application section.

    // Observe preferences that influence what we display so we can rebuild
    // the view when they change.
    Services.prefs.addObserver(PREF_SHOW_PLUGINS_IN_LIST, this);
    Services.prefs.addObserver(PREF_HIDE_PLUGINS_WITHOUT_EXTENSIONS, this);

    setEventListener("filter", "command", gWebpagesPane.filter);
    setEventListener("typeColumn", "click", gWebpagesPane.sort);
    setEventListener("actionColumn", "click", gWebpagesPane.sort);

    // Listen for window unload so we can remove our preference observers.
    window.addEventListener("unload", this);

    // Figure out how we should be sorting the list.  We persist sort settings
    // across sessions, so we can't assume the default sort column/direction.
    // XXX should we be using the XUL sort service instead?
    if (document.getElementById("actionColumn").hasAttribute("sortDirection")) {
      this._sortColumn = document.getElementById("actionColumn");
      // The typeColumn element always has a sortDirection attribute,
      // either because it was persisted or because the default value
      // from the xul file was used.  If we are sorting on the other
      // column, we should remove it.
      document.getElementById("typeColumn").removeAttribute("sortDirection");
    } else {
      this._sortColumn = document.getElementById("typeColumn");
    }

    // Notify observers that the UI is now ready
    Services.obs.notifyObservers(window, "webpages-pane-loaded");

    this.setInitialized();
  },

  preInit() {
    promiseLoadHandlersList = new Promise((resolve, reject) => {
      // Load the data and build the list of handlers for applications pane.
      // By doing this after pageshow, we ensure it doesn't delay painting
      // of the preferences page.
      window.addEventListener(
        "pageshow",
        async () => {
          await this.initialized;
          try {
            this._initListEventHandlers();
            this._loadData();
            await this._rebuildVisibleTypes();
            this._sortVisibleTypes();
            this._rebuildView();
            resolve();
          } catch (ex) {
            reject(ex);
          }
        },
        { once: true }
      );
    });
  },

  get _brandShortName() {
    delete this._brandShortName;
    return (this._brandShortName = document
      .getElementById("bundleBrand")
      .getString("brandShortName"));
  },

  get _prefsBundle() {
    delete this._prefsBundle;
    return (this._prefsBundle = document.getElementById("bundlePreferences"));
  },

  get _list() {
    delete this._list;
    return (this._list = document.getElementById("handlersView"));
  },

  get _filter() {
    delete this._filter;
    return (this._filter = document.getElementById("filter"));
  },

  updateDefaultPerformanceSettingsPref() {
    let defaultPerformancePref = Preferences.get(
      "browser.preferences.defaultPerformanceSettings.enabled"
    );
    let processCountPref = Preferences.get("dom.ipc.processCount");
    let accelerationPref = Preferences.get("layers.acceleration.disabled");
    if (
      processCountPref.value != processCountPref.defaultValue ||
      accelerationPref.value != accelerationPref.defaultValue
    ) {
      defaultPerformancePref.value = false;
    }
  },

  updatePerformanceSettingsBox({ duringChangeEvent }) {
    let defaultPerformancePref = Preferences.get(
      "browser.preferences.defaultPerformanceSettings.enabled"
    );
    let performanceSettings = document.getElementById("performanceSettings");
    let processCountPref = Preferences.get("dom.ipc.processCount");
    if (defaultPerformancePref.value) {
      let accelerationPref = Preferences.get("layers.acceleration.disabled");
      // Unset the value so process count will be decided by the platform.
      processCountPref.value = processCountPref.defaultValue;
      accelerationPref.value = accelerationPref.defaultValue;
      performanceSettings.hidden = true;
    } else {
      performanceSettings.hidden = false;
    }
  },

  buildContentProcessCountMenuList() {
    if (Services.appinfo.browserTabsRemoteAutostart) {
      let processCountPref = Preferences.get("dom.ipc.processCount");
      let defaultProcessCount = processCountPref.defaultValue;

      let contentProcessCount = document.querySelector(`#contentProcessCount > menupopup >
                                menuitem[value="${defaultProcessCount}"]`);

      document.l10n.setAttributes(
        contentProcessCount,
        "performance-default-content-process-count",
        { num: defaultProcessCount }
      );

      document.getElementById("limitContentProcess").disabled = false;
      document.getElementById("contentProcessCount").disabled = false;
      document.getElementById(
        "contentProcessCountEnabledDescription"
      ).hidden = false;
      document.getElementById(
        "contentProcessCountDisabledDescription"
      ).hidden = true;
    } else {
      document.getElementById("limitContentProcess").disabled = true;
      document.getElementById("contentProcessCount").disabled = true;
      document.getElementById(
        "contentProcessCountEnabledDescription"
      ).hidden = true;
      document.getElementById(
        "contentProcessCountDisabledDescription"
      ).hidden = false;
    }
  },

  /**
   * ui.osk.enabled
   * - when set to true, subject to other conditions, we may sometimes invoke
   *   an on-screen keyboard when a text input is focused.
   *   (Currently Windows-only, and depending on prefs, may be Windows-8-only)
   */
  updateOnScreenKeyboardVisibility() {
    if (AppConstants.platform == "win") {
      let minVersion = Services.prefs.getBoolPref("ui.osk.require_win10")
        ? 10
        : 6.2;
      if (
        Services.vc.compare(
          Services.sysinfo.getProperty("version"),
          minVersion
        ) >= 0
      ) {
        document.getElementById("useOnScreenKeyboard").hidden = false;
      }
    }
  },

  updateHardwareAcceleration() {
    // Placeholder for restart on change
  },

  destroy() {
    window.removeEventListener("unload", this);
    Services.prefs.removeObserver(PREF_SHOW_PLUGINS_IN_LIST, this);
    Services.prefs.removeObserver(PREF_HIDE_PLUGINS_WITHOUT_EXTENSIONS, this);

    Services.obs.removeObserver(this, AUTO_UPDATE_CHANGED_TOPIC);
  },

  // nsISupports

  QueryInterface: ChromeUtils.generateQI([Ci.nsIObserver]),

  // nsIObserver

  async observe(aSubject, aTopic, aData) {
    if (aTopic == "nsPref:changed") {
      // Rebuild the list when there are changes to preferences that influence
      // whether or not to show certain entries in the list.
      if (!this._storingAction) {
        // These two prefs alter the list of visible types, so we have to rebuild
        // that list when they change.
        if (
          aData == PREF_SHOW_PLUGINS_IN_LIST ||
          aData == PREF_HIDE_PLUGINS_WITHOUT_EXTENSIONS
        ) {
          await this._rebuildVisibleTypes();
          this._sortVisibleTypes();
        }

        // All the prefs we observe can affect what we display, so we rebuild
        // the view when any of them changes.
        this._rebuildView();
      }
    }
  },

  // Composed Model Construction
  _loadData() {
    this._loadInternalHandlers();
    this._loadPluginHandlers();
    this._loadApplicationHandlers();
  },

  // EventListener

  handleEvent(aEvent) {
    if (aEvent.type == "unload") {
      this.destroy();
    }
  },

  /**
   * Load higher level internal handlers so they can be turned on/off in the
   * applications menu.
   */
  _loadInternalHandlers() {
    var internalHandlers = [new PDFHandlerInfoWrapper()];
    for (let internalHandler of internalHandlers) {
      if (internalHandler.enabled) {
        this._handledTypes[internalHandler.type] = internalHandler;
      }
    }
  },

  /**
   * Load the set of handlers defined by plugins.
   *
   * Note: if there's more than one plugin for a given MIME type, we assume
   * the last one is the one that the application will use.  That may not be
   * correct, but it's how we've been doing it for years.
   *
   * Perhaps we should instead query navigator.mimeTypes for the set of types
   * supported by the application and then get the plugin from each MIME type's
   * enabledPlugin property.  But if there's a plugin for a type, we need
   * to know about it even if it isn't enabled, since we're going to give
   * the user an option to enable it.
   *
   * Also note that enabledPlugin does not get updated when
   * plugin.disable_full_page_plugin_for_types changes, so even if we could use
   * enabledPlugin to get the plugin that would be used, we'd still need to
   * check the pref ourselves to find out if it's enabled.
   */
  _loadPluginHandlers() {
    "use strict";

    let mimeTypes = navigator.mimeTypes;

    for (let mimeType of mimeTypes) {
      let handlerInfoWrapper;
      if (mimeType.type in this._handledTypes) {
        handlerInfoWrapper = this._handledTypes[mimeType.type];
      } else {
        let wrappedHandlerInfo = gMIMEService.getFromTypeAndExtension(
          mimeType.type,
          null
        );
        handlerInfoWrapper = new HandlerInfoWrapper(
          mimeType.type,
          wrappedHandlerInfo
        );
        handlerInfoWrapper.handledOnlyByPlugin = true;
        this._handledTypes[mimeType.type] = handlerInfoWrapper;
      }
      handlerInfoWrapper.pluginName = mimeType.enabledPlugin.name;
    }
  },

  /**
   * Load the set of handlers defined by the application datastore.
   */
  _loadApplicationHandlers() {
    for (let wrappedHandlerInfo of gHandlerService.enumerate()) {
      let type = wrappedHandlerInfo.type;

      let handlerInfoWrapper;
      if (type in this._handledTypes) {
        handlerInfoWrapper = this._handledTypes[type];
      } else {
        handlerInfoWrapper = new HandlerInfoWrapper(type, wrappedHandlerInfo);
        this._handledTypes[type] = handlerInfoWrapper;
      }

      handlerInfoWrapper.handledOnlyByPlugin = false;
    }
  },

  // View Construction

  selectedHandlerListItem: null,

  _initListEventHandlers() {
    this._list.addEventListener("select", event => {
      if (event.target != this._list) {
        return;
      }

      let handlerListItem =
        this._list.selectedItem &&
        HandlerListItem.forNode(this._list.selectedItem);
      if (this.selectedHandlerListItem == handlerListItem) {
        return;
      }

      if (this.selectedHandlerListItem) {
        this.selectedHandlerListItem.showActionsMenu = false;
      }
      this.selectedHandlerListItem = handlerListItem;
      if (handlerListItem) {
        this.rebuildActionsMenu();
        handlerListItem.showActionsMenu = true;
      }
    });
  },

  async _rebuildVisibleTypes() {
    this._visibleTypes = [];

    // Map whose keys are string descriptions and values are references to the
    // first visible HandlerInfoWrapper that has this description. We use this
    // to determine whether or not to annotate descriptions with their types to
    // distinguish duplicate descriptions from each other.
    let visibleDescriptions = new Map();

    // Get the preferences that help determine what types to show.
    var showPlugins = Services.prefs.getBoolPref(PREF_SHOW_PLUGINS_IN_LIST);
    var hidePluginsWithoutExtensions = Services.prefs.getBoolPref(
      PREF_HIDE_PLUGINS_WITHOUT_EXTENSIONS
    );

    for (let type in this._handledTypes) {
      // Yield before processing each handler info object to avoid monopolizing
      // the main thread, as the objects are retrieved lazily, and retrieval
      // can be expensive on Windows.
      await new Promise(resolve => Services.tm.dispatchToMainThread(resolve));

      let handlerInfo = this._handledTypes[type];

      // Hide plugins without associated extensions if so prefed so we don't
      // show a whole bunch of obscure types handled by plugins on Mac.
      // Note: though protocol types don't have extensions, we still show them;
      // the pref is only meant to be applied to MIME types, since plugins are
      // only associated with MIME types.
      // FIXME: should we also check the "suffixes" property of the plugin?
      // Filed as bug 395135.
      if (
        hidePluginsWithoutExtensions &&
        handlerInfo.handledOnlyByPlugin &&
        handlerInfo.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo &&
        !handlerInfo.primaryExtension
      ) {
        continue;
      }

      // Hide types handled only by plugins if so prefed.
      if (handlerInfo.handledOnlyByPlugin && !showPlugins) {
        continue;
      }

      // We couldn't find any reason to exclude the type, so include it.
      this._visibleTypes.push(handlerInfo);

      let otherHandlerInfo = visibleDescriptions.get(handlerInfo.description);
      if (!otherHandlerInfo) {
        // This is the first type with this description that we encountered
        // while rebuilding the _visibleTypes array this time. Make sure the
        // flag is reset so we won't add the type to the description.
        handlerInfo.disambiguateDescription = false;
        visibleDescriptions.set(handlerInfo.description, handlerInfo);
      } else {
        // There is at least another type with this description. Make sure we
        // add the type to the description on both HandlerInfoWrapper objects.
        handlerInfo.disambiguateDescription = true;
        otherHandlerInfo.disambiguateDescription = true;
      }
    }
  },
  _rebuildView() {
    let lastSelectedType =
      this.selectedHandlerListItem &&
      this.selectedHandlerListItem.handlerInfoWrapper.type;
    this.selectedHandlerListItem = null;

    // Clear the list of entries.
    this._list.textContent = "";

    var visibleTypes = this._visibleTypes;

    // If the user is filtering the list, then only show matching types.
    if (this._filter.value) {
      visibleTypes = visibleTypes.filter(this._matchesFilter, this);
    }

    let items = visibleTypes.map(
      visibleType => new HandlerListItem(visibleType)
    );
    let itemsFragment = document.createDocumentFragment();
    let lastSelectedItem;
    for (let item of items) {
      item.createNode(itemsFragment);
      if (item.handlerInfoWrapper.type == lastSelectedType) {
        lastSelectedItem = item;
      }
    }
    this._list.appendChild(itemsFragment);
    for (let item of items) {
      item.setupNode();
    }

    if (lastSelectedItem) {
      this._list.selectedItem = lastSelectedItem.node;
    }
  },

  _matchesFilter(aType) {
    var filterValue = this._filter.value.toLowerCase();
    return (
      aType.typeDescription.toLowerCase().includes(filterValue) ||
      aType.actionDescription.toLowerCase().includes(filterValue)
    );
  },

  /**
   * Whether or not the given handler app is valid.
   *
   * @param aHandlerApp {nsIHandlerApp} the handler app in question
   *
   * @returns {boolean} whether or not it's valid
   */
  isValidHandlerApp(aHandlerApp) {
    if (!aHandlerApp) {
      return false;
    }

    if (aHandlerApp instanceof Ci.nsILocalHandlerApp) {
      return this._isValidHandlerExecutable(aHandlerApp.executable);
    }

    if (aHandlerApp instanceof Ci.nsIWebHandlerApp) {
      return aHandlerApp.uriTemplate;
    }

    if (aHandlerApp instanceof Ci.nsIGIOMimeApp) {
      return aHandlerApp.command;
    }

    return false;
  },

  _isValidHandlerExecutable(aExecutable) {
    let leafName;
    if (AppConstants.platform == "win") {
      leafName = `${AppConstants.MOZ_APP_NAME}.exe`;
    } else if (AppConstants.platform == "macosx") {
      leafName = AppConstants.MOZ_MACBUNDLE_NAME;
    } else {
      leafName = `${AppConstants.MOZ_APP_NAME}-bin`;
    }
    return (
      aExecutable &&
      aExecutable.exists() &&
      aExecutable.isExecutable() &&
      // XXXben - we need to compare this with the running instance executable
      //          just don't know how to do that via script...
      // XXXmano TBD: can probably add this to nsIShellService
      aExecutable.leafName != leafName
    );
  },

  /**
   * Rebuild the actions menu for the selected entry.  Gets called by
   * the richlistitem constructor when an entry in the list gets selected.
   */
  rebuildActionsMenu() {
    var typeItem = this._list.selectedItem;
    var handlerInfo = this.selectedHandlerListItem.handlerInfoWrapper;
    var menu = typeItem.querySelector(".actionsMenu");
    var menuPopup = menu.menupopup;

    // Clear out existing items.
    while (menuPopup.hasChildNodes()) {
      menuPopup.removeChild(menuPopup.lastChild);
    }

    let internalMenuItem;
    // Add the "Preview in Firefox" option for optional internal handlers.
    if (handlerInfo instanceof InternalHandlerInfoWrapper) {
      internalMenuItem = document.createXULElement("menuitem");
      internalMenuItem.setAttribute(
        "action",
        Ci.nsIHandlerInfo.handleInternally
      );
      let label = gWebpagesPane._prefsBundle.getFormattedString(
        "previewInApp",
        [this._brandShortName]
      );
      internalMenuItem.setAttribute("label", label);
      internalMenuItem.setAttribute("tooltiptext", label);
      internalMenuItem.setAttribute(APP_ICON_ATTR_NAME, "ask");
      menuPopup.appendChild(internalMenuItem);
    }

    {
      var askMenuItem = document.createXULElement("menuitem");
      askMenuItem.setAttribute("action", Ci.nsIHandlerInfo.alwaysAsk);
      let label = gWebpagesPane._prefsBundle.getString("alwaysAsk");
      askMenuItem.setAttribute("label", label);
      askMenuItem.setAttribute("tooltiptext", label);
      askMenuItem.setAttribute(APP_ICON_ATTR_NAME, "ask");
      menuPopup.appendChild(askMenuItem);
    }

    // Create a menu item for saving to disk.
    // Note: this option isn't available to protocol types, since we don't know
    // what it means to save a URL having a certain scheme to disk.
    if (handlerInfo.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo) {
      var saveMenuItem = document.createXULElement("menuitem");
      saveMenuItem.setAttribute("action", Ci.nsIHandlerInfo.saveToDisk);
      let label = gWebpagesPane._prefsBundle.getString("saveFile");
      saveMenuItem.setAttribute("label", label);
      saveMenuItem.setAttribute("tooltiptext", label);
      saveMenuItem.setAttribute(APP_ICON_ATTR_NAME, "save");
      menuPopup.appendChild(saveMenuItem);
    }

    // Add a separator to distinguish these items from the helper app items
    // that follow them.
    let menuseparator = document.createXULElement("menuseparator");
    menuPopup.appendChild(menuseparator);

    // Create a menu item for the OS default application, if any.
    if (handlerInfo.hasDefaultHandler) {
      var defaultMenuItem = document.createXULElement("menuitem");
      defaultMenuItem.setAttribute(
        "action",
        Ci.nsIHandlerInfo.useSystemDefault
      );
      let label = gWebpagesPane._prefsBundle.getFormattedString("useDefault", [
        handlerInfo.defaultDescription,
      ]);
      defaultMenuItem.setAttribute("label", label);
      defaultMenuItem.setAttribute(
        "tooltiptext",
        handlerInfo.defaultDescription
      );
      defaultMenuItem.setAttribute(
        "image",
        handlerInfo.iconURLForSystemDefault
      );

      menuPopup.appendChild(defaultMenuItem);
    }

    // Create menu items for possible handlers.
    let preferredApp = handlerInfo.preferredApplicationHandler;
    var possibleAppMenuItems = [];
    for (let possibleApp of handlerInfo.possibleApplicationHandlers.enumerate()) {
      if (!this.isValidHandlerApp(possibleApp)) {
        continue;
      }

      let menuItem = document.createXULElement("menuitem");
      menuItem.setAttribute("action", Ci.nsIHandlerInfo.useHelperApp);
      let label;
      if (possibleApp instanceof Ci.nsILocalHandlerApp) {
        label = getFileDisplayName(possibleApp.executable);
      } else {
        label = possibleApp.name;
      }
      label = gWebpagesPane._prefsBundle.getFormattedString("useApp", [label]);
      menuItem.setAttribute("label", label);
      menuItem.setAttribute("tooltiptext", label);
      menuItem.setAttribute(
        "image",
        this._getIconURLForHandlerApp(possibleApp)
      );

      // Attach the handler app object to the menu item so we can use it
      // to make changes to the datastore when the user selects the item.
      menuItem.handlerApp = possibleApp;

      menuPopup.appendChild(menuItem);
      possibleAppMenuItems.push(menuItem);
    }
    // Add gio handlers
    if (Cc["@mozilla.org/gio-service;1"]) {
      let gIOSvc = Cc["@mozilla.org/gio-service;1"].getService(
        Ci.nsIGIOService
      );
      var gioApps = gIOSvc.getAppsForURIScheme(handlerInfo.type);
      let possibleHandlers = handlerInfo.possibleApplicationHandlers;
      for (let handler of gioApps.enumerate(Ci.nsIHandlerApp)) {
        // OS handler share the same name, it's most likely the same app, skipping...
        if (handler.name == handlerInfo.defaultDescription) {
          continue;
        }
        // Check if the handler is already in possibleHandlers
        let appAlreadyInHandlers = false;
        for (let i = possibleHandlers.length - 1; i >= 0; --i) {
          let app = possibleHandlers.queryElementAt(i, Ci.nsIHandlerApp);
          // nsGIOMimeApp::Equals is able to compare with nsILocalHandlerApp
          if (handler.equals(app)) {
            appAlreadyInHandlers = true;
            break;
          }
        }
        if (!appAlreadyInHandlers) {
          let menuItem = document.createXULElement("menuitem");
          menuItem.setAttribute("action", Ci.nsIHandlerInfo.useHelperApp);
          let label = gWebpagesPane._prefsBundle.getFormattedString("useApp", [
            handler.name,
          ]);
          menuItem.setAttribute("label", label);
          menuItem.setAttribute("tooltiptext", label);
          menuItem.setAttribute(
            "image",
            this._getIconURLForHandlerApp(handler)
          );

          // Attach the handler app object to the menu item so we can use it
          // to make changes to the datastore when the user selects the item.
          menuItem.handlerApp = handler;

          menuPopup.appendChild(menuItem);
          possibleAppMenuItems.push(menuItem);
        }
      }
    }

    // Create a menu item for the plugin.
    if (handlerInfo.pluginName) {
      var pluginMenuItem = document.createXULElement("menuitem");
      pluginMenuItem.setAttribute("action", kActionUsePlugin);
      let label = gWebpagesPane._prefsBundle.getFormattedString("usePluginIn", [
        handlerInfo.pluginName,
        this._brandShortName,
      ]);
      pluginMenuItem.setAttribute("label", label);
      pluginMenuItem.setAttribute("tooltiptext", label);
      pluginMenuItem.setAttribute(APP_ICON_ATTR_NAME, "plugin");
      menuPopup.appendChild(pluginMenuItem);
    }

    // Create a menu item for selecting a local application.
    let canOpenWithOtherApp = true;
    if (AppConstants.platform == "win") {
      // On Windows, selecting an application to open another application
      // would be meaningless so we special case executables.
      let executableType = Cc["@mozilla.org/mime;1"]
        .getService(Ci.nsIMIMEService)
        .getTypeFromExtension("exe");
      canOpenWithOtherApp = handlerInfo.type != executableType;
    }
    if (canOpenWithOtherApp) {
      let menuItem = document.createXULElement("menuitem");
      menuItem.className = "choose-app-item";
      menuItem.addEventListener("command", function(e) {
        gWebpagesPane.chooseApp(e);
      });
      let label = gWebpagesPane._prefsBundle.getString("useOtherApp");
      menuItem.setAttribute("label", label);
      menuItem.setAttribute("tooltiptext", label);
      menuPopup.appendChild(menuItem);
    }

    // Create a menu item for managing applications.
    if (possibleAppMenuItems.length) {
      let menuItem = document.createXULElement("menuseparator");
      menuPopup.appendChild(menuItem);
      menuItem = document.createXULElement("menuitem");
      menuItem.className = "manage-app-item";
      menuItem.addEventListener("command", function(e) {
        gWebpagesPane.manageApp(e);
      });
      menuItem.setAttribute(
        "label",
        gWebpagesPane._prefsBundle.getString("manageApp")
      );
      menuPopup.appendChild(menuItem);
    }

    // Select the item corresponding to the preferred action.  If the always
    // ask flag is set, it overrides the preferred action.  Otherwise we pick
    // the item identified by the preferred action (when the preferred action
    // is to use a helper app, we have to pick the specific helper app item).
    if (handlerInfo.alwaysAskBeforeHandling) {
      menu.selectedItem = askMenuItem;
    } else {
      switch (handlerInfo.preferredAction) {
        case Ci.nsIHandlerInfo.handleInternally:
          if (internalMenuItem) {
            menu.selectedItem = internalMenuItem;
          } else {
            Cu.reportError("No menu item defined to set!");
          }
          break;
        case Ci.nsIHandlerInfo.useSystemDefault:
          menu.selectedItem = defaultMenuItem;
          break;
        case Ci.nsIHandlerInfo.useHelperApp:
          if (preferredApp) {
            menu.selectedItem = possibleAppMenuItems.filter(v =>
              v.handlerApp.equals(preferredApp)
            )[0];
          }
          break;
        case kActionUsePlugin:
          menu.selectedItem = pluginMenuItem;
          break;
        case Ci.nsIHandlerInfo.saveToDisk:
          menu.selectedItem = saveMenuItem;
          break;
      }
    }
  },

  // Sorting & Filtering

  _sortColumn: null,

  /**
   * Sort the list when the user clicks on a column header.
   */
  sort(event) {
    var column = event.target;

    // If the user clicked on a new sort column, remove the direction indicator
    // from the old column.
    if (this._sortColumn && this._sortColumn != column) {
      this._sortColumn.removeAttribute("sortDirection");
    }

    this._sortColumn = column;

    // Set (or switch) the sort direction indicator.
    if (column.getAttribute("sortDirection") == "ascending") {
      column.setAttribute("sortDirection", "descending");
    } else {
      column.setAttribute("sortDirection", "ascending");
    }

    this._sortVisibleTypes();
    this._rebuildView();
  },

  /**
   * Sort the list of visible types by the current sort column/direction.
   */
  _sortVisibleTypes() {
    if (!this._sortColumn) {
      return;
    }

    function sortByType(a, b) {
      return a.typeDescription
        .toLowerCase()
        .localeCompare(b.typeDescription.toLowerCase());
    }

    function sortByAction(a, b) {
      return a.actionDescription
        .toLowerCase()
        .localeCompare(b.actionDescription.toLowerCase());
    }

    switch (this._sortColumn.getAttribute("value")) {
      case "type":
        this._visibleTypes.sort(sortByType);
        break;
      case "action":
        this._visibleTypes.sort(sortByAction);
        break;
    }

    if (this._sortColumn.getAttribute("sortDirection") == "descending") {
      this._visibleTypes.reverse();
    }
  },

  /**
   * Filter the list when the user enters a filter term into the filter field.
   */
  filter() {
    this._rebuildView();
  },

  focusFilterBox() {
    this._filter.focus();
    this._filter.select();
  },

  // Changes

  // Whether or not we are currently storing the action selected by the user.
  // We use this to suppress notification-triggered updates to the list when
  // we make changes that may spawn such updates.
  // XXXgijs: this was definitely necessary when we changed feed preferences
  // from within _storeAction and its calltree. Now, it may still be
  // necessary, either to avoid calling _rebuildView or to avoid the plugin-
  // related prefs change code. bug 1499350 has more details.
  _storingAction: false,

  onSelectAction(aActionItem) {
    this._storingAction = true;

    try {
      this._storeAction(aActionItem);
    } finally {
      this._storingAction = false;
    }
  },

  _storeAction(aActionItem) {
    var handlerInfo = this.selectedHandlerListItem.handlerInfoWrapper;

    let action = parseInt(aActionItem.getAttribute("action"));

    // Set the plugin state if we're enabling or disabling a plugin.
    if (action == kActionUsePlugin) {
      handlerInfo.enablePluginType();
    } else if (handlerInfo.pluginName && !handlerInfo.isDisabledPluginType) {
      handlerInfo.disablePluginType();
    }

    // Set the preferred application handler.
    // We leave the existing preferred app in the list when we set
    // the preferred action to something other than useHelperApp so that
    // legacy datastores that don't have the preferred app in the list
    // of possible apps still include the preferred app in the list of apps
    // the user can choose to handle the type.
    if (action == Ci.nsIHandlerInfo.useHelperApp) {
      handlerInfo.preferredApplicationHandler = aActionItem.handlerApp;
    }

    // Set the "always ask" flag.
    if (action == Ci.nsIHandlerInfo.alwaysAsk) {
      handlerInfo.alwaysAskBeforeHandling = true;
    } else {
      handlerInfo.alwaysAskBeforeHandling = false;
    }

    // Set the preferred action.
    handlerInfo.preferredAction = action;

    handlerInfo.store();

    // Make sure the handler info object is flagged to indicate that there is
    // now some user configuration for the type.
    handlerInfo.handledOnlyByPlugin = false;

    // Update the action label and image to reflect the new preferred action.
    this.selectedHandlerListItem.refreshAction();
  },

  manageApp(aEvent) {
    // Don't let the normal "on select action" handler get this event,
    // as we handle it specially ourselves.
    aEvent.stopPropagation();

    var handlerInfo = this.selectedHandlerListItem.handlerInfoWrapper;

    let onComplete = () => {
      // Rebuild the actions menu so that we revert to the previous selection,
      // or "Always ask" if the previous default application has been removed
      this.rebuildActionsMenu();

      // update the richlistitem too. Will be visible when selecting another row
      this.selectedHandlerListItem.refreshAction();
    };

    gSubDialog.open(
      "chrome://browser/content/preferences/applicationManager.xul",
      "resizable=no",
      handlerInfo,
      onComplete
    );
  },

  chooseApp(aEvent) {
    // Don't let the normal "on select action" handler get this event,
    // as we handle it specially ourselves.
    aEvent.stopPropagation();

    var handlerApp;
    let chooseAppCallback = aHandlerApp => {
      // Rebuild the actions menu whether the user picked an app or canceled.
      // If they picked an app, we want to add the app to the menu and select it.
      // If they canceled, we want to go back to their previous selection.
      this.rebuildActionsMenu();

      // If the user picked a new app from the menu, select it.
      if (aHandlerApp) {
        let typeItem = this._list.selectedItem;
        let actionsMenu = typeItem.querySelector(".actionsMenu");
        let menuItems = actionsMenu.menupopup.childNodes;
        for (let i = 0; i < menuItems.length; i++) {
          let menuItem = menuItems[i];
          if (menuItem.handlerApp && menuItem.handlerApp.equals(aHandlerApp)) {
            actionsMenu.selectedIndex = i;
            this.onSelectAction(menuItem);
            break;
          }
        }
      }
    };

    if (AppConstants.platform == "win") {
      var params = {};
      var handlerInfo = this.selectedHandlerListItem.handlerInfoWrapper;

      params.mimeInfo = handlerInfo.wrappedHandlerInfo;
      params.title = gWebpagesPane._prefsBundle.getString("fpTitleChooseApp");
      params.description = handlerInfo.description;
      params.filename = null;
      params.handlerApp = null;

      let onAppSelected = () => {
        if (this.isValidHandlerApp(params.handlerApp)) {
          handlerApp = params.handlerApp;

          // Add the app to the type's list of possible handlers.
          handlerInfo.addPossibleApplicationHandler(handlerApp);
        }

        chooseAppCallback(handlerApp);
      };

      gSubDialog.open(
        "chrome://global/content/appPicker.xul",
        null,
        params,
        onAppSelected
      );
    } else {
      let winTitle = gWebpagesPane._prefsBundle.getString("fpTitleChooseApp");
      let fp = Cc["@mozilla.org/filepicker;1"].createInstance(Ci.nsIFilePicker);
      let fpCallback = aResult => {
        if (
          aResult == Ci.nsIFilePicker.returnOK &&
          fp.file &&
          this._isValidHandlerExecutable(fp.file)
        ) {
          handlerApp = Cc[
            "@mozilla.org/uriloader/local-handler-app;1"
          ].createInstance(Ci.nsILocalHandlerApp);
          handlerApp.name = getFileDisplayName(fp.file);
          handlerApp.executable = fp.file;

          // Add the app to the type's list of possible handlers.
          let handler = this.selectedHandlerListItem.handlerInfoWrapper;
          handler.addPossibleApplicationHandler(handlerApp);

          chooseAppCallback(handlerApp);
        }
      };

      // Prompt the user to pick an app.  If they pick one, and it's a valid
      // selection, then add it to the list of possible handlers.
      fp.init(window, winTitle, Ci.nsIFilePicker.modeOpen);
      fp.appendFilters(Ci.nsIFilePicker.filterApps);
      fp.open(fpCallback);
    }
  },

  _getIconURLForHandlerApp(aHandlerApp) {
    if (aHandlerApp instanceof Ci.nsILocalHandlerApp) {
      return this._getIconURLForFile(aHandlerApp.executable);
    }

    if (aHandlerApp instanceof Ci.nsIWebHandlerApp) {
      return this._getIconURLForWebApp(aHandlerApp.uriTemplate);
    }

    // We know nothing about other kinds of handler apps.
    return "";
  },

  _getIconURLForFile(aFile) {
    var fph = Services.io
      .getProtocolHandler("file")
      .QueryInterface(Ci.nsIFileProtocolHandler);
    var urlSpec = fph.getURLSpecFromFile(aFile);

    return "moz-icon://" + urlSpec + "?size=16";
  },

  _getIconURLForWebApp(aWebAppURITemplate) {
    var uri = Services.io.newURI(aWebAppURITemplate);

    // Unfortunately we can't use the favicon service to get the favicon,
    // because the service looks in the annotations table for a record with
    // the exact URL we give it, and users won't have such records for URLs
    // they don't visit, and users won't visit the web app's URL template,
    // they'll only visit URLs derived from that template (i.e. with %s
    // in the template replaced by the URL of the content being handled).

    if (
      /^https?$/.test(uri.scheme) &&
      Services.prefs.getBoolPref("browser.chrome.site_icons")
    ) {
      return uri.prePath + "/favicon.ico";
    }

    return "";
  },
  /**
   * Displays the fonts dialog, where web page font names and sizes can be
   * configured.
   */
  configureFonts() {
    gSubDialog.open(
      "chrome://browser/content/preferences/fonts.xul",
      "resizable=no"
    );
  },

  /**
   * Displays the colors dialog, where default web page/link/etc. colors can be
   * configured.
   */
  configureColors() {
    gSubDialog.open(
      "chrome://browser/content/preferences/colors.xul",
      "resizable=no"
    );
  },

  // FONTS

  /**
   * Populates the default font list in UI.
   */
  _rebuildFonts() {
    var langGroupPref = Preferences.get("font.language.group");
    var isSerif =
      this._readDefaultFontTypeForLanguage(langGroupPref.value) == "serif";
    this._selectDefaultLanguageGroup(langGroupPref.value, isSerif);
  },

  /**
   * Returns the type of the current default font for the language denoted by
   * aLanguageGroup.
   */
  _readDefaultFontTypeForLanguage(aLanguageGroup) {
    const kDefaultFontType = "font.default.%LANG%";
    var defaultFontTypePref = kDefaultFontType.replace(
      /%LANG%/,
      aLanguageGroup
    );
    var preference = Preferences.get(defaultFontTypePref);
    if (!preference) {
      preference = Preferences.add({ id: defaultFontTypePref, type: "string" });
      preference.on("change", gWebpagesPane._rebuildFonts.bind(gWebpagesPane));
    }
    return preference.value;
  },
  _selectDefaultLanguageGroupPromise: Promise.resolve(),

  _selectDefaultLanguageGroup(aLanguageGroup, aIsSerif) {
    this._selectDefaultLanguageGroupPromise = (async () => {
      // Avoid overlapping language group selections by awaiting the resolution
      // of the previous one.  We do this because this function is re-entrant,
      // as inserting <preference> elements into the DOM sometimes triggers a call
      // back into this function.  And since this function is also asynchronous,
      // that call can enter this function before the previous run has completed,
      // which would corrupt the font menulists.  Awaiting the previous call's
      // resolution avoids that fate.
      await this._selectDefaultLanguageGroupPromise;

      const kFontNameFmtSerif = "font.name.serif.%LANG%";
      const kFontNameFmtSansSerif = "font.name.sans-serif.%LANG%";
      const kFontNameListFmtSerif = "font.name-list.serif.%LANG%";
      const kFontNameListFmtSansSerif = "font.name-list.sans-serif.%LANG%";
      const kFontSizeFmtVariable = "font.size.variable.%LANG%";

      var prefs = [
        {
          format: aIsSerif ? kFontNameFmtSerif : kFontNameFmtSansSerif,
          type: "fontname",
          element: "defaultFont",
          fonttype: aIsSerif ? "serif" : "sans-serif",
        },
        {
          format: aIsSerif ? kFontNameListFmtSerif : kFontNameListFmtSansSerif,
          type: "unichar",
          element: null,
          fonttype: aIsSerif ? "serif" : "sans-serif",
        },
        {
          format: kFontSizeFmtVariable,
          type: "int",
          element: "defaultFontSize",
          fonttype: null,
        },
      ];
      for (var i = 0; i < prefs.length; ++i) {
        var preference = Preferences.get(
          prefs[i].format.replace(/%LANG%/, aLanguageGroup)
        );
        if (!preference) {
          var name = prefs[i].format.replace(/%LANG%/, aLanguageGroup);
          preference = Preferences.add({ id: name, type: prefs[i].type });
        }

        if (!prefs[i].element) {
          continue;
        }

        var element = document.getElementById(prefs[i].element);
        if (element) {
          element.setAttribute("preference", preference.id);

          if (prefs[i].fonttype) {
            await FontBuilder.buildFontList(
              aLanguageGroup,
              prefs[i].fonttype,
              element
            );
          }

          preference.setElementValue(element);
        }
      }
    })().catch(Cu.reportError);
  },
};

// Utilities

function getFileDisplayName(file) {
  if (AppConstants.platform == "win") {
    if (file instanceof Ci.nsILocalFileWin) {
      try {
        return file.getVersionInfoField("FileDescription");
      } catch (e) {}
    }
  }
  if (AppConstants.platform == "macosx") {
    if (file instanceof Ci.nsILocalFileMac) {
      try {
        return file.bundleDisplayName;
      } catch (e) {}
    }
  }
  return file.leafName;
}

function getLocalHandlerApp(aFile) {
  var localHandlerApp = Cc[
    "@mozilla.org/uriloader/local-handler-app;1"
  ].createInstance(Ci.nsILocalHandlerApp);
  localHandlerApp.name = getFileDisplayName(aFile);
  localHandlerApp.executable = aFile;

  return localHandlerApp;
}

// eslint-disable-next-line no-undef
let gHandlerListItemFragment = MozXULElement.parseXULToFragment(`
    <richlistitem>
      <hbox flex="1" equalsize="always">
        <hbox class="typeContainer" flex="1" align="center">
          <image class="typeIcon" width="16" height="16"
                 src="moz-icon://goat?size=16"/>
          <label class="typeDescription" flex="1" crop="end"/>
        </hbox>
        <hbox class="actionContainer" flex="1" align="center">
          <image class="actionIcon" width="16" height="16"/>
          <label class="actionDescription" flex="1" crop="end"/>
        </hbox>
        <hbox class="actionsMenuContainer" flex="1">
          <menulist class="actionsMenu" flex="1" crop="end" selectedIndex="1">
            <menupopup/>
          </menulist>
        </hbox>
      </hbox>
    </richlistitem>
  `);

/**
 * This is associated to <richlistitem> elements in the handlers view.
 */
class HandlerListItem {
  static forNode(node) {
    return gNodeToObjectMap.get(node);
  }

  constructor(handlerInfoWrapper) {
    this.handlerInfoWrapper = handlerInfoWrapper;
  }

  setOrRemoveAttributes(iterable) {
    for (let [selector, name, value] of iterable) {
      let node = selector ? this.node.querySelector(selector) : this.node;
      if (value) {
        node.setAttribute(name, value);
      } else {
        node.removeAttribute(name);
      }
    }
  }

  createNode(list) {
    list.appendChild(document.importNode(gHandlerListItemFragment, true));
    this.node = list.lastChild;
    gNodeToObjectMap.set(this.node, this);
  }

  setupNode() {
    this.node
      .querySelector(".actionsMenu")
      .addEventListener("command", event =>
        gWebpagesPane.onSelectAction(event.originalTarget)
      );

    let typeDescription = this.handlerInfoWrapper.typeDescription;
    this.setOrRemoveAttributes([
      [null, "type", this.handlerInfoWrapper.type],
      [".typeContainer", "tooltiptext", typeDescription],
      [".typeDescription", "value", typeDescription],
      [".typeIcon", "src", this.handlerInfoWrapper.smallIcon],
    ]);
    this.refreshAction();
    this.showActionsMenu = false;
  }

  refreshAction() {
    let { actionIconClass, actionDescription } = this.handlerInfoWrapper;
    this.setOrRemoveAttributes([
      [null, APP_ICON_ATTR_NAME, actionIconClass],
      [".actionContainer", "tooltiptext", actionDescription],
      [".actionDescription", "value", actionDescription],
      [
        ".actionIcon",
        "src",
        actionIconClass ? null : this.handlerInfoWrapper.actionIcon,
      ],
    ]);
  }

  set showActionsMenu(value) {
    this.setOrRemoveAttributes([
      [".actionContainer", "hidden", value],
      [".actionsMenuContainer", "hidden", !value],
    ]);
  }
}

/**
 * This object wraps nsIHandlerInfo with some additional functionality
 * the Applications prefpane needs to display and allow modification of
 * the list of handled types.
 *
 * We create an instance of this wrapper for each entry we might display
 * in the prefpane, and we compose the instances from various sources,
 * including plugins and the handler service.
 *
 * We don't implement all the original nsIHandlerInfo functionality,
 * just the stuff that the prefpane needs.
 */
class HandlerInfoWrapper {
  constructor(type, handlerInfo) {
    this.type = type;
    this.wrappedHandlerInfo = handlerInfo;
    this.disambiguateDescription = false;

    // A plugin that can handle this type, if any.
    //
    // Note: just because we have one doesn't mean it *will* handle the type.
    // That depends on whether or not the type is in the list of types for which
    // plugin handling is disabled.
    this.pluginName = "";

    // Whether or not this type is only handled by a plugin or is also handled
    // by some user-configured action as specified in the handler info object.
    //
    // Note: we can't just check if there's a handler info object for this type,
    // because OS and user configuration is mixed up in the handler info object,
    // so we always need to retrieve it for the OS info and can't tell whether
    // it represents only OS-default information or user-configured information.
    //
    // FIXME: once handler info records are broken up into OS-provided records
    // and user-configured records, stop using this boolean flag and simply
    // check for the presence of a user-configured record to determine whether
    // or not this type is only handled by a plugin.  Filed as bug 395142.
    this.handledOnlyByPlugin = false;
  }

  get description() {
    if (this.wrappedHandlerInfo.description) {
      return this.wrappedHandlerInfo.description;
    }

    if (this.primaryExtension) {
      var extension = this.primaryExtension.toUpperCase();
      return gWebpagesPane._prefsBundle.getFormattedString("fileEnding", [
        extension,
      ]);
    }

    return this.type;
  }

  /**
   * Describe, in a human-readable fashion, the type represented by the given
   * handler info object.  Normally this is just the description, but if more
   * than one object presents the same description, "disambiguateDescription"
   * is set and we annotate the duplicate descriptions with the type itself
   * to help users distinguish between those types.
   */
  get typeDescription() {
    if (this.disambiguateDescription) {
      return gWebpagesPane._prefsBundle.getFormattedString(
        "typeDescriptionWithType",
        [this.description, this.type]
      );
    }

    return this.description;
  }

  /**
   * Describe, in a human-readable fashion, the preferred action to take on
   * the type represented by the given handler info object.
   */
  get actionDescription() {
    // alwaysAskBeforeHandling overrides the preferred action, so if that flag
    // is set, then describe that behavior instead.
    if (this.alwaysAskBeforeHandling) {
      return gWebpagesPane._prefsBundle.getString("alwaysAsk");
    }

    switch (this.preferredAction) {
      case Ci.nsIHandlerInfo.saveToDisk:
        return gWebpagesPane._prefsBundle.getString("saveFile");

      case Ci.nsIHandlerInfo.useHelperApp:
        var preferredApp = this.preferredApplicationHandler;
        var name;
        if (preferredApp instanceof Ci.nsILocalHandlerApp) {
          name = getFileDisplayName(preferredApp.executable);
        } else {
          name = preferredApp.name;
        }
        return gWebpagesPane._prefsBundle.getFormattedString("useApp", [name]);

      case Ci.nsIHandlerInfo.handleInternally:
        if (this instanceof InternalHandlerInfoWrapper) {
          return gWebpagesPane._prefsBundle.getFormattedString("previewInApp", [
            gWebpagesPane._brandShortName,
          ]);
        }

        // For other types, handleInternally looks like either useHelperApp
        // or useSystemDefault depending on whether or not there's a preferred
        // handler app.
        if (gWebpagesPane.isValidHandlerApp(this.preferredApplicationHandler)) {
          return this.preferredApplicationHandler.name;
        }

        return this.defaultDescription;

      // XXX Why don't we say the app will handle the type internally?
      // Is it because the app can't actually do that?  But if that's true,
      // then why would a preferredAction ever get set to this value
      // in the first place?

      case Ci.nsIHandlerInfo.useSystemDefault:
        return gWebpagesPane._prefsBundle.getFormattedString("useDefault", [
          this.defaultDescription,
        ]);

      case kActionUsePlugin:
        return gWebpagesPane._prefsBundle.getFormattedString("usePluginIn", [
          this.pluginName,
          gWebpagesPane._brandShortName,
        ]);
      default:
        throw new Error(`Unexpected preferredAction: ${this.preferredAction}`);
    }
  }

  get actionIconClass() {
    if (this.alwaysAskBeforeHandling) {
      return "ask";
    }

    switch (this.preferredAction) {
      case Ci.nsIHandlerInfo.saveToDisk:
        return "save";

      case Ci.nsIHandlerInfo.handleInternally:
        if (this instanceof InternalHandlerInfoWrapper) {
          return "ask";
        }

      case kActionUsePlugin:
        return "plugin";
    }

    return "";
  }

  get actionIcon() {
    switch (this.preferredAction) {
      case Ci.nsIHandlerInfo.useSystemDefault:
        return this.iconURLForSystemDefault;

      case Ci.nsIHandlerInfo.useHelperApp:
        let preferredApp = this.preferredApplicationHandler;
        if (gWebpagesPane.isValidHandlerApp(preferredApp)) {
          return gWebpagesPane._getIconURLForHandlerApp(preferredApp);
        }
      // Explicit fall-through

      // This should never happen, but if preferredAction is set to some weird
      // value, then fall back to the generic application icon.
      default:
        return ICON_URL_APP;
    }
  }

  get iconURLForSystemDefault() {
    // Handler info objects for MIME types on some OSes implement a property bag
    // interface from which we can get an icon for the default app, so if we're
    // dealing with a MIME type on one of those OSes, then try to get the icon.
    if (
      this.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo &&
      this.wrappedHandlerInfo instanceof Ci.nsIPropertyBag
    ) {
      try {
        let url = this.wrappedHandlerInfo.getProperty(
          "defaultApplicationIconURL"
        );
        if (url) {
          return url + "?size=16";
        }
      } catch (ex) {}
    }

    // If this isn't a MIME type object on an OS that supports retrieving
    // the icon, or if we couldn't retrieve the icon for some other reason,
    // then use a generic icon.
    return ICON_URL_APP;
  }

  get preferredApplicationHandler() {
    return this.wrappedHandlerInfo.preferredApplicationHandler;
  }

  set preferredApplicationHandler(aNewValue) {
    this.wrappedHandlerInfo.preferredApplicationHandler = aNewValue;

    // Make sure the preferred handler is in the set of possible handlers.
    if (aNewValue) {
      this.addPossibleApplicationHandler(aNewValue);
    }
  }

  get possibleApplicationHandlers() {
    return this.wrappedHandlerInfo.possibleApplicationHandlers;
  }

  addPossibleApplicationHandler(aNewHandler) {
    for (let app of this.possibleApplicationHandlers.enumerate()) {
      if (app.equals(aNewHandler)) {
        return;
      }
    }
    this.possibleApplicationHandlers.appendElement(aNewHandler);
  }

  removePossibleApplicationHandler(aHandler) {
    var defaultApp = this.preferredApplicationHandler;
    if (defaultApp && aHandler.equals(defaultApp)) {
      // If the app we remove was the default app, we must make sure
      // it won't be used anymore
      this.alwaysAskBeforeHandling = true;
      this.preferredApplicationHandler = null;
    }

    var handlers = this.possibleApplicationHandlers;
    for (var i = 0; i < handlers.length; ++i) {
      var handler = handlers.queryElementAt(i, Ci.nsIHandlerApp);
      if (handler.equals(aHandler)) {
        handlers.removeElementAt(i);
        break;
      }
    }
  }

  get hasDefaultHandler() {
    return this.wrappedHandlerInfo.hasDefaultHandler;
  }

  get defaultDescription() {
    return this.wrappedHandlerInfo.defaultDescription;
  }

  // What to do with content of this type.
  get preferredAction() {
    // If we have an enabled plugin, then the action is to use that plugin.
    if (this.pluginName && !this.isDisabledPluginType) {
      return kActionUsePlugin;
    }

    // If the action is to use a helper app, but we don't have a preferred
    // handler app, then switch to using the system default, if any; otherwise
    // fall back to saving to disk, which is the default action in nsMIMEInfo.
    // Note: "save to disk" is an invalid value for protocol info objects,
    // but the alwaysAskBeforeHandling getter will detect that situation
    // and always return true in that case to override this invalid value.
    if (
      this.wrappedHandlerInfo.preferredAction ==
        Ci.nsIHandlerInfo.useHelperApp &&
      !gWebpagesPane.isValidHandlerApp(this.preferredApplicationHandler)
    ) {
      if (this.wrappedHandlerInfo.hasDefaultHandler) {
        return Ci.nsIHandlerInfo.useSystemDefault;
      }
      return Ci.nsIHandlerInfo.saveToDisk;
    }

    return this.wrappedHandlerInfo.preferredAction;
  }

  set preferredAction(aNewValue) {
    // If the action is to use the plugin,
    // we must set the preferred action to "save to disk".
    // But only if it's not currently the preferred action.
    if (
      aNewValue == kActionUsePlugin &&
      this.preferredAction != Ci.nsIHandlerInfo.saveToDisk
    ) {
      aNewValue = Ci.nsIHandlerInfo.saveToDisk;
    }

    // We don't modify the preferred action if the new action is to use a plugin
    // because handler info objects don't understand our custom "use plugin"
    // value.  Also, leaving it untouched means that we can automatically revert
    // to the old setting if the user ever removes the plugin.

    if (aNewValue != kActionUsePlugin) {
      this.wrappedHandlerInfo.preferredAction = aNewValue;
    }
  }

  get alwaysAskBeforeHandling() {
    // If this type is handled only by a plugin, we can't trust the value
    // in the handler info object, since it'll be a default based on the absence
    // of any user configuration, and the default in that case is to always ask,
    // even though we never ask for content handled by a plugin, so special case
    // plugin-handled types by returning false here.
    if (this.pluginName && this.handledOnlyByPlugin) {
      return false;
    }

    // If this is a protocol type and the preferred action is "save to disk",
    // which is invalid for such types, then return true here to override that
    // action.  This could happen when the preferred action is to use a helper
    // app, but the preferredApplicationHandler is invalid, and there isn't
    // a default handler, so the preferredAction getter returns save to disk
    // instead.
    if (
      !(this.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo) &&
      this.preferredAction == Ci.nsIHandlerInfo.saveToDisk
    ) {
      return true;
    }

    return this.wrappedHandlerInfo.alwaysAskBeforeHandling;
  }

  set alwaysAskBeforeHandling(aNewValue) {
    this.wrappedHandlerInfo.alwaysAskBeforeHandling = aNewValue;
  }

  // The primary file extension associated with this type, if any.
  //
  // XXX Plugin objects contain an array of MimeType objects with "suffixes"
  // properties; if this object has an associated plugin, shouldn't we check
  // those properties for an extension?
  get primaryExtension() {
    try {
      if (
        this.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo &&
        this.wrappedHandlerInfo.primaryExtension
      ) {
        return this.wrappedHandlerInfo.primaryExtension;
      }
    } catch (ex) {}

    return null;
  }

  get isDisabledPluginType() {
    return this._getDisabledPluginTypes().includes(this.type);
  }

  _getDisabledPluginTypes() {
    var types = "";

    if (Services.prefs.prefHasUserValue(PREF_DISABLED_PLUGIN_TYPES)) {
      types = Services.prefs.getCharPref(PREF_DISABLED_PLUGIN_TYPES);
    }

    // Only split if the string isn't empty so we don't end up with an array
    // containing a single empty string.
    if (types != "") {
      return types.split(",");
    }

    return [];
  }

  disablePluginType() {
    var disabledPluginTypes = this._getDisabledPluginTypes();

    if (!disabledPluginTypes.includes(this.type)) {
      disabledPluginTypes.push(this.type);
    }

    Services.prefs.setCharPref(
      PREF_DISABLED_PLUGIN_TYPES,
      disabledPluginTypes.join(",")
    );

    // Update the category manager so existing browser windows update.
    Services.catMan.deleteCategoryEntry(
      "Gecko-Content-Viewers",
      this.type,
      false
    );
  }

  enablePluginType() {
    var disabledPluginTypes = this._getDisabledPluginTypes();

    var type = this.type;
    disabledPluginTypes = disabledPluginTypes.filter(v => v != type);

    Services.prefs.setCharPref(
      PREF_DISABLED_PLUGIN_TYPES,
      disabledPluginTypes.join(",")
    );

    // Update the category manager so existing browser windows update.
    Services.catMan.addCategoryEntry(
      "Gecko-Content-Viewers",
      this.type,
      "@mozilla.org/content/plugin/document-loader-factory;1",
      false,
      true
    );
  }

  store() {
    gHandlerService.store(this.wrappedHandlerInfo);
  }

  get smallIcon() {
    return this._getIcon(16);
  }

  _getIcon(aSize) {
    if (this.primaryExtension) {
      return "moz-icon://goat." + this.primaryExtension + "?size=" + aSize;
    }

    if (this.wrappedHandlerInfo instanceof Ci.nsIMIMEInfo) {
      return "moz-icon://goat?size=" + aSize + "&contentType=" + this.type;
    }

    // FIXME: consider returning some generic icon when we can't get a URL for
    // one (for example in the case of protocol schemes).  Filed as bug 395141.
    return null;
  }
}

/**
 * InternalHandlerInfoWrapper provides a basic mechanism to create an internal
 * mime type handler that can be enabled/disabled in the applications preference
 * menu.
 */
class InternalHandlerInfoWrapper extends HandlerInfoWrapper {
  constructor(mimeType) {
    super(mimeType, gMIMEService.getFromTypeAndExtension(mimeType, null));
  }

  // Override store so we so we can notify any code listening for registration
  // or unregistration of this handler.
  store() {
    super.store();
    Services.obs.notifyObservers(null, this._handlerChanged);
  }

  get enabled() {
    throw Cr.NS_ERROR_NOT_IMPLEMENTED;
  }

  get description() {
    return gWebpagesPane._prefsBundle.getString(this._appPrefLabel);
  }
}

class PDFHandlerInfoWrapper extends InternalHandlerInfoWrapper {
  constructor() {
    super(TYPE_PDF);
  }

  get _handlerChanged() {
    return TOPIC_PDFJS_HANDLER_CHANGED;
  }

  get _appPrefLabel() {
    return "portableDocumentFormat";
  }

  get enabled() {
    return !Services.prefs.getBoolPref(PREF_PDFJS_DISABLED);
  }
}

gWebpagesPane.initialized = new Promise(res => {
  gWebpagesPane.setInitialized = res;
});
