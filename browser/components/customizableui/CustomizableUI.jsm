/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["CustomizableUI"];

const {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PanelWideWidgetTracker",
  "resource:///modules/PanelWideWidgetTracker.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "CustomizableWidgets",
  "resource:///modules/CustomizableWidgets.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "DeferredTask",
  "resource://gre/modules/DeferredTask.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm");
XPCOMUtils.defineLazyGetter(this, "gWidgetsBundle", function() {
  const kUrl = "chrome://browser/locale/customizableui/customizableWidgets.properties";
  return Services.strings.createBundle(kUrl);
});
XPCOMUtils.defineLazyModuleGetter(this, "ShortcutUtils",
  "resource://gre/modules/ShortcutUtils.jsm");
XPCOMUtils.defineLazyServiceGetter(this, "gELS",
  "@mozilla.org/eventlistenerservice;1", "nsIEventListenerService");
XPCOMUtils.defineLazyModuleGetter(this, "LightweightThemeManager",
                                  "resource://gre/modules/LightweightThemeManager.jsm");

const kNSXUL = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

const kSpecialWidgetPfx = "customizableui-special-";

const kPrefCustomizationState        = "browser.uiCustomization.state";
const kPrefCustomizationAutoAdd      = "browser.uiCustomization.autoAdd";
const kPrefCustomizationDebug        = "browser.uiCustomization.debug";
const kPrefDrawInTitlebar            = "browser.tabs.drawInTitlebar";
const kPrefWebIDEInNavbar            = "devtools.webide.widget.inNavbarByDefault";

const kExpectedWindowURL = "chrome://browser/content/browser.xul";

/**
 * The keys are the handlers that are fired when the event type (the value)
 * is fired on the subview. A widget that provides a subview has the option
 * of providing onViewShowing and onViewHiding event handlers.
 */
const kSubviewEvents = [
  "ViewShowing",
  "ViewHiding"
];

/**
 * The current version. We can use this to auto-add new default widgets as necessary.
 * (would be const but isn't because of testing purposes)
 */
var kVersion = 6;

/**
 * Buttons removed from built-ins by version they were removed. kVersion must be
 * bumped any time a new id is added to this. Use the button id as key, and
 * version the button is removed in as the value.  e.g. "pocket-button": 5
 */
var ObsoleteBuiltinButtons = {
  "pocket-button": 6
};

/**
 * gPalette is a map of every widget that CustomizableUI.jsm knows about, keyed
 * on their IDs.
 */
var gPalette = new Map();

/**
 * gAreas maps area IDs to Sets of properties about those areas. An area is a
 * place where a widget can be put.
 */
var gAreas = new Map();

/**
 * gPlacements maps area IDs to Arrays of widget IDs, indicating that the widgets
 * are placed within that area (either directly in the area node, or in the
 * customizationTarget of the node).
 */
var gPlacements = new Map();

/**
 * gFuturePlacements represent placements that will happen for areas that have
 * not yet loaded (due to lazy-loading). This can occur when add-ons register
 * widgets.
 */
var gFuturePlacements = new Map();

// XXXunf Temporary. Need a nice way to abstract functions to build widgets
//       of these types.
var gSupportedWidgetTypes = new Set(["button", "view", "custom"]);

/**
 * gPanelsForWindow is a list of known panels in a window which we may need to close
 * should command events fire which target them.
 */
var gPanelsForWindow = new WeakMap();

/**
 * gSeenWidgets remembers which widgets the user has seen for the first time
 * before. This way, if a new widget is created, and the user has not seen it
 * before, it can be put in its default location. Otherwise, it remains in the
 * palette.
 */
var gSeenWidgets = new Set();

/**
 * gDirtyAreaCache is a set of area IDs for areas where items have been added,
 * moved or removed at least once. This set is persisted, and is used to
 * optimize building of toolbars in the default case where no toolbars should
 * be "dirty".
 */
var gDirtyAreaCache = new Set();

/**
 * gPendingBuildAreas is a map from area IDs to map from build nodes to their
 * existing children at the time of node registration, that are waiting
 * for the area to be registered
 */
var gPendingBuildAreas = new Map();

var gSavedState = null;
var gRestoring = false;
var gDirty = false;
var gInBatchStack = 0;
var gResetting = false;
var gUndoResetting = false;

/**
 * gBuildAreas maps area IDs to actual area nodes within browser windows.
 */
var gBuildAreas = new Map();

/**
 * gBuildWindows is a map of windows that have registered build areas, mapped
 * to a Set of known toolboxes in that window.
 */
var gBuildWindows = new Map();

var gNewElementCount = 0;
var gGroupWrapperCache = new Map();
var gSingleWrapperCache = new WeakMap();
var gListeners = new Set();

var gUIStateBeforeReset = {
  uiCustomizationState: null,
  drawInTitlebar: null,
  currentTheme: null,
};

XPCOMUtils.defineLazyGetter(this, "log", () => {
  let scope = {};
  Cu.import("resource://gre/modules/Console.jsm", scope);
  let debug;
  try {
    debug = Services.prefs.getBoolPref(kPrefCustomizationDebug);
  } catch (ex) {}
  let consoleOptions = {
    maxLogLevel: debug ? "all" : "log",
    prefix: "CustomizableUI",
  };
  return new scope.ConsoleAPI(consoleOptions);
});

var CustomizableUIInternal = {
  initialize: function() {
    log.debug("Initializing");

    this.addListener(this);
    this._defineBuiltInWidgets();
    this.loadSavedState();
    this._introduceNewBuiltinWidgets();
    this._markObsoleteBuiltinButtonsSeen();

    /**
     * Please be advised that adding items to the panel by default could
     * cause CART talos test regressions. This might happen when the
     * number of items in the panel causes the area to become "scrollable"
     * during the last phases of the transition. See bug 1230671 for an
     * example of this. Be sure that what you're adding really needs to go
     * into the panel by default, and if it does, consider swapping
     * something out for it.
     */
    let panelPlacements = [
      "edit-controls",
      "zoom-controls",
      "new-window-button",
      "privatebrowsing-button",
      "save-page-button",
      "print-button",
      "history-panelmenu",
      "fullscreen-button",
      "find-button",
      "preferences-button",
      "add-ons-button",
      "sync-button",
    ];

    if (!AppConstants.MOZ_DEV_EDITION) {
      panelPlacements.splice(-1, 0, "developer-button");
    }

    if (AppConstants.E10S_TESTING_ONLY) {
      if (gPalette.has("e10s-button")) {
        let newWindowIndex = panelPlacements.indexOf("new-window-button");
        if (newWindowIndex > -1) {
          panelPlacements.splice(newWindowIndex + 1, 0, "e10s-button");
        }
      }
    }

    let showCharacterEncoding = Services.prefs.getComplexValue(
      "browser.menu.showCharacterEncoding",
      Ci.nsIPrefLocalizedString
    ).data;
    if (showCharacterEncoding == "true") {
      panelPlacements.push("characterencoding-button");
    }

    this.registerArea(CustomizableUI.AREA_PANEL, {
      anchor: "PanelUI-menu-button",
      type: CustomizableUI.TYPE_MENU_PANEL,
      defaultPlacements: panelPlacements
    }, true);
    PanelWideWidgetTracker.init();

    let navbarPlacements = [
      "urlbar-container",
      "search-container",
      "bookmarks-menu-button",
      "downloads-button",
      "home-button",
    ];

    if (AppConstants.MOZ_DEV_EDITION) {
      navbarPlacements.splice(2, 0, "developer-button");
    }

    if (Services.prefs.getBoolPref(kPrefWebIDEInNavbar)) {
      navbarPlacements.push("webide-button");
    }

    // Place this last, when createWidget is called for pocket, it will
    // append to the toolbar.
    if (Services.prefs.getPrefType("extensions.pocket.enabled") != Services.prefs.PREF_INVALID &&
        Services.prefs.getBoolPref("extensions.pocket.enabled")) {
        navbarPlacements.push("pocket-button");
    }

    this.registerArea(CustomizableUI.AREA_NAVBAR, {
      legacy: true,
      type: CustomizableUI.TYPE_TOOLBAR,
      overflowable: true,
      defaultPlacements: navbarPlacements,
      defaultCollapsed: false,
    }, true);

    if (AppConstants.platform != "macosx") {
      this.registerArea(CustomizableUI.AREA_MENUBAR, {
        legacy: true,
        type: CustomizableUI.TYPE_TOOLBAR,
        defaultPlacements: [
          "menubar-items",
        ],
        get defaultCollapsed() {
          if (AppConstants.MENUBAR_CAN_AUTOHIDE) {
            if (AppConstants.platform == "linux") {
              return true;
            }
            // This is duplicated logic from /browser/base/jar.mn
            // for win6BrowserOverlay.xul.
            return AppConstants.isPlatformAndVersionAtLeast("win", 6);
          }
          return false;
        }
      }, true);
    }

    this.registerArea(CustomizableUI.AREA_TABSTRIP, {
      legacy: true,
      type: CustomizableUI.TYPE_TOOLBAR,
      defaultPlacements: [
        "tabbrowser-tabs",
        "new-tab-button",
        "alltabs-button",
      ],
      defaultCollapsed: null,
    }, true);
    this.registerArea(CustomizableUI.AREA_BOOKMARKS, {
      legacy: true,
      type: CustomizableUI.TYPE_TOOLBAR,
      defaultPlacements: [
        "personal-bookmarks",
      ],
      defaultCollapsed: true,
    }, true);

    this.registerArea(CustomizableUI.AREA_ADDONBAR, {
      type: CustomizableUI.TYPE_TOOLBAR,
      legacy: true,
      defaultPlacements: ["addonbar-closebutton", "status-bar"],
      defaultCollapsed: false,
    }, true);
  },

  get _builtinToolbars() {
    let toolbars = new Set([
      CustomizableUI.AREA_NAVBAR,
      CustomizableUI.AREA_BOOKMARKS,
      CustomizableUI.AREA_TABSTRIP,
      CustomizableUI.AREA_ADDONBAR,
    ]);
    if (AppConstants.platform != "macosx") {
      toolbars.add(CustomizableUI.AREA_MENUBAR);
    }
    return toolbars;
  },

  _defineBuiltInWidgets: function() {
    for (let widgetDefinition of CustomizableWidgets) {
      this.createBuiltinWidget(widgetDefinition);
    }
  },

  _introduceNewBuiltinWidgets: function() {
    // We should still enter even if gSavedState.currentVersion >= kVersion
    // because the per-widget pref facility is independent of versioning.
    if (!gSavedState) {
      // Flip all the prefs so we don't try to re-introduce later:
      for (let [, widget] of gPalette) {
        if (widget.defaultArea && widget._introducedInVersion === "pref") {
          let prefId = "browser.toolbarbuttons.introduced." + widget.id;
          Services.prefs.setBoolPref(prefId, true);
        }
      }
      return;
    }

    let currentVersion = gSavedState.currentVersion;
    for (let [id, widget] of gPalette) {
      if (widget.defaultArea) {
        let shouldAdd = false;
        let shouldSetPref = false;
        let prefId = "browser.toolbarbuttons.introduced." + widget.id;
        if (widget._introducedInVersion === "pref") {
          try {
            shouldAdd = !Services.prefs.getBoolPref(prefId);
          } catch (ex) {
            // Pref doesn't exist:
            shouldAdd = true;
          }
          shouldSetPref = shouldAdd;
        } else if (widget._introducedInVersion > currentVersion) {
          shouldAdd = true;
        }

        if (shouldAdd) {
          let futurePlacements = gFuturePlacements.get(widget.defaultArea);
          if (futurePlacements) {
            futurePlacements.add(id);
          } else {
            gFuturePlacements.set(widget.defaultArea, new Set([id]));
          }
          if (shouldSetPref) {
            Services.prefs.setBoolPref(prefId, true);
          }
        }
      }
    }

    if (currentVersion < 2) {
      // Nuke the old 'loop-call-button' out of orbit.
      CustomizableUI.removeWidgetFromArea("loop-call-button");
    }

    if (currentVersion < 4) {
      CustomizableUI.removeWidgetFromArea("loop-button-throttled");
    }
  },

  /**
   * _markObsoleteBuiltinButtonsSeen
   * when upgrading, ensure obsoleted buttons are in seen state.
   */
  _markObsoleteBuiltinButtonsSeen: function() {
    if (!gSavedState)
      return;
    let currentVersion = gSavedState.currentVersion;
    if (currentVersion >= kVersion)
      return;
    // we're upgrading, update state if necessary
    for (let id in ObsoleteBuiltinButtons) {
      let version = ObsoleteBuiltinButtons[id]
      if (version == kVersion) {
        gSeenWidgets.add(id);
        gDirty = true;
      }
    }
  },

  _placeNewDefaultWidgetsInArea: function(aArea) {
    let futurePlacedWidgets = gFuturePlacements.get(aArea);
    let savedPlacements = gSavedState && gSavedState.placements && gSavedState.placements[aArea];
    let defaultPlacements = gAreas.get(aArea).get("defaultPlacements");
    if (!savedPlacements || !savedPlacements.length || !futurePlacedWidgets || !defaultPlacements ||
        !defaultPlacements.length) {
      return;
    }
    let defaultWidgetIndex = -1;

    for (let widgetId of futurePlacedWidgets) {
      let widget = gPalette.get(widgetId);
      if (!widget || widget.source !== CustomizableUI.SOURCE_BUILTIN ||
          !widget.defaultArea || !widget._introducedInVersion ||
          savedPlacements.indexOf(widget.id) !== -1) {
        continue;
      }
      defaultWidgetIndex = defaultPlacements.indexOf(widget.id);
      if (defaultWidgetIndex === -1) {
        continue;
      }
      // Now we know that this widget should be here by default, was newly introduced,
      // and we have a saved state to insert into, and a default state to work off of.
      // Try introducing after widgets that come before it in the default placements:
      for (let i = defaultWidgetIndex; i >= 0; i--) {
        // Special case: if the defaults list this widget as coming first, insert at the beginning:
        if (i === 0 && i === defaultWidgetIndex) {
          savedPlacements.splice(0, 0, widget.id);
          // Before you ask, yes, deleting things inside a let x of y loop where y is a Set is
          // safe, and we won't skip any items.
          futurePlacedWidgets.delete(widget.id);
          gDirty = true;
          break;
        }
        // Otherwise, if we're somewhere other than the beginning, check if the previous
        // widget is in the saved placements.
        if (i) {
          let previousWidget = defaultPlacements[i - 1];
          let previousWidgetIndex = savedPlacements.indexOf(previousWidget);
          if (previousWidgetIndex != -1) {
            savedPlacements.splice(previousWidgetIndex + 1, 0, widget.id);
            futurePlacedWidgets.delete(widget.id);
            gDirty = true;
            break;
          }
        }
      }
      // The loop above either inserts the item or doesn't - either way, we can get away
      // with doing nothing else now; if the item remains in gFuturePlacements, we'll
      // add it at the end in restoreStateForArea.
    }
    this.saveState();
  },

  wrapWidget: function(aWidgetId) {
    if (gGroupWrapperCache.has(aWidgetId)) {
      return gGroupWrapperCache.get(aWidgetId);
    }

    let provider = this.getWidgetProvider(aWidgetId);
    if (!provider) {
      return null;
    }

    if (provider == CustomizableUI.PROVIDER_API) {
      let widget = gPalette.get(aWidgetId);
      if (!widget.wrapper) {
        widget.wrapper = new WidgetGroupWrapper(widget);
        gGroupWrapperCache.set(aWidgetId, widget.wrapper);
      }
      return widget.wrapper;
    }

    // PROVIDER_SPECIAL gets treated the same as PROVIDER_XUL.
    let wrapper = new XULWidgetGroupWrapper(aWidgetId);
    gGroupWrapperCache.set(aWidgetId, wrapper);
    return wrapper;
  },

  registerArea: function(aName, aProperties, aInternalCaller) {
    if (typeof aName != "string" || !/^[a-z0-9-_]{1,}$/i.test(aName)) {
      throw new Error("Invalid area name");
    }

    let areaIsKnown = gAreas.has(aName);
    let props = areaIsKnown ? gAreas.get(aName) : new Map();
    const kImmutableProperties = new Set(["type", "legacy", "overflowable"]);
    for (let key in aProperties) {
      if (areaIsKnown && kImmutableProperties.has(key) &&
          props.get(key) != aProperties[key]) {
        throw new Error("An area cannot change the property for '" + key + "'");
      }
      // XXXgijs for special items, we need to make sure they have an appropriate ID
      // so we aren't perpetually in a non-default state:
      if (key == "defaultPlacements" && Array.isArray(aProperties[key])) {
        props.set(key, aProperties[key].map(x => this.isSpecialWidget(x) ? this.ensureSpecialWidgetId(x) : x ));
      } else {
        props.set(key, aProperties[key]);
      }
    }
    // Default to a toolbar:
    if (!props.has("type")) {
      props.set("type", CustomizableUI.TYPE_TOOLBAR);
    }
    if (props.get("type") == CustomizableUI.TYPE_TOOLBAR) {
      // Check aProperties instead of props because this check is only interested
      // in the passed arguments, not the state of a potentially pre-existing area.
      if (!aInternalCaller && aProperties["defaultCollapsed"]) {
        throw new Error("defaultCollapsed is only allowed for default toolbars.")
      }
      if (!props.has("defaultCollapsed")) {
        props.set("defaultCollapsed", true);
      }
    } else if (props.has("defaultCollapsed")) {
      throw new Error("defaultCollapsed only applies for TYPE_TOOLBAR areas.");
    }
    // Sanity check type:
    let allTypes = [CustomizableUI.TYPE_TOOLBAR, CustomizableUI.TYPE_MENU_PANEL];
    if (allTypes.indexOf(props.get("type")) == -1) {
      throw new Error("Invalid area type " + props.get("type"));
    }

    // And to no placements:
    if (!props.has("defaultPlacements")) {
      props.set("defaultPlacements", []);
    }
    // Sanity check default placements array:
    if (!Array.isArray(props.get("defaultPlacements"))) {
      throw new Error("Should provide an array of default placements");
    }

    if (!areaIsKnown) {
      gAreas.set(aName, props);

      // Reconcile new default widgets. Have to do this before we start restoring things.
      this._placeNewDefaultWidgetsInArea(aName);

      if (props.get("legacy") && !gPlacements.has(aName)) {
        // Guarantee this area exists in gFuturePlacements, to avoid checking it in
        // various places elsewhere.
        if (!gFuturePlacements.has(aName)) {
          gFuturePlacements.set(aName, new Set());
        }
      } else {
        this.restoreStateForArea(aName);
      }

      // If we have pending build area nodes, register all of them
      if (gPendingBuildAreas.has(aName)) {
        let pendingNodes = gPendingBuildAreas.get(aName);
        for (let [pendingNode, existingChildren] of pendingNodes) {
          this.registerToolbarNode(pendingNode, existingChildren);
        }
        gPendingBuildAreas.delete(aName);
      }
    }
  },

  unregisterArea: function(aName, aDestroyPlacements) {
    if (typeof aName != "string" || !/^[a-z0-9-_]{1,}$/i.test(aName)) {
      throw new Error("Invalid area name");
    }
    if (!gAreas.has(aName) && !gPlacements.has(aName)) {
      throw new Error("Area not registered");
    }

    // Move all the widgets out
    this.beginBatchUpdate();
    try {
      let placements = gPlacements.get(aName);
      if (placements) {
        // Need to clone this array so removeWidgetFromArea doesn't modify it
        placements = [...placements];
        placements.forEach(this.removeWidgetFromArea, this);
      }

      // Delete all remaining traces.
      gAreas.delete(aName);
      // Only destroy placements when necessary:
      if (aDestroyPlacements) {
        gPlacements.delete(aName);
      } else {
        // Otherwise we need to re-set them, as removeFromArea will have emptied
        // them out:
        gPlacements.set(aName, placements);
      }
      gFuturePlacements.delete(aName);
      let existingAreaNodes = gBuildAreas.get(aName);
      if (existingAreaNodes) {
        for (let areaNode of existingAreaNodes) {
          this.notifyListeners("onAreaNodeUnregistered", aName, areaNode.customizationTarget,
                               CustomizableUI.REASON_AREA_UNREGISTERED);
        }
      }
      gBuildAreas.delete(aName);
    } finally {
      this.endBatchUpdate(true);
    }
  },

  registerToolbarNode: function(aToolbar, aExistingChildren) {
    let area = aToolbar.id;
    if (gBuildAreas.has(area) && gBuildAreas.get(area).has(aToolbar)) {
      return;
    }
    let areaProperties = gAreas.get(area);

    // If this area is not registered, try to do it automatically:
    if (!areaProperties) {
      // If there's no defaultset attribute and this isn't a legacy extra toolbar,
      // we assume that we should wait for registerArea to be called:
      if (!aToolbar.hasAttribute("defaultset") &&
          !aToolbar.hasAttribute("customindex")) {
        if (!gPendingBuildAreas.has(area)) {
          gPendingBuildAreas.set(area, new Map());
        }
        let pendingNodes = gPendingBuildAreas.get(area);
        pendingNodes.set(aToolbar, aExistingChildren);
        return;
      }
      let props = {type: CustomizableUI.TYPE_TOOLBAR, legacy: true};
      let defaultsetAttribute = aToolbar.getAttribute("defaultset") || "";
      props.defaultPlacements = defaultsetAttribute.split(',').filter(s => s);
      this.registerArea(area, props);
      areaProperties = gAreas.get(area);
    }

    this.beginBatchUpdate();
    try {
      let placements = gPlacements.get(area);
      if (!placements && areaProperties.has("legacy")) {
        let legacyState = aToolbar.getAttribute("currentset");
        if (legacyState) {
          legacyState = legacyState.split(",").filter(s => s);
        }

        // Manually restore the state here, so the legacy state can be converted.
        this.restoreStateForArea(area, legacyState);
        placements = gPlacements.get(area);
      }

      // Check that the current children and the current placements match. If
      // not, mark it as dirty:
      if (aExistingChildren.length != placements.length ||
          aExistingChildren.every((id, i) => id == placements[i])) {
        gDirtyAreaCache.add(area);
      }

      if (areaProperties.has("overflowable")) {
        aToolbar.overflowable = new OverflowableToolbar(aToolbar);
      }

      this.registerBuildArea(area, aToolbar);

      // We only build the toolbar if it's been marked as "dirty". Dirty means
      // one of the following things:
      // 1) Items have been added, moved or removed from this toolbar before.
      // 2) The number of children of the toolbar does not match the length of
      //    the placements array for that area.
      //
      // This notion of being "dirty" is stored in a cache which is persisted
      // in the saved state.
      if (gDirtyAreaCache.has(area)) {
        this.buildArea(area, placements, aToolbar);
      }
      this.notifyListeners("onAreaNodeRegistered", area, aToolbar.customizationTarget);
      aToolbar.setAttribute("currentset", placements.join(","));
    } finally {
      this.endBatchUpdate();
    }
  },

  buildArea: function(aArea, aPlacements, aAreaNode) {
    let document = aAreaNode.ownerDocument;
    let window = document.defaultView;
    let inPrivateWindow = PrivateBrowsingUtils.isWindowPrivate(window);
    let container = aAreaNode.customizationTarget;
    let areaIsPanel = gAreas.get(aArea).get("type") == CustomizableUI.TYPE_MENU_PANEL;

    if (!container) {
      throw new Error("Expected area " + aArea
                      + " to have a customizationTarget attribute.");
    }

    // Restore nav-bar visibility since it may have been hidden
    // through a migration path (bug 938980) or an add-on.
    if (aArea == CustomizableUI.AREA_NAVBAR) {
      aAreaNode.collapsed = false;
    }

    this.beginBatchUpdate();

    try {
      let currentNode = container.firstChild;
      let placementsToRemove = new Set();
      for (let id of aPlacements) {
        while (currentNode && currentNode.getAttribute("skipintoolbarset") == "true") {
          currentNode = currentNode.nextSibling;
        }

        if (currentNode && currentNode.id == id) {
          currentNode = currentNode.nextSibling;
          continue;
        }

        if (this.isSpecialWidget(id) && areaIsPanel) {
          placementsToRemove.add(id);
          continue;
        }

        let [provider, node] = this.getWidgetNode(id, window);
        if (!node) {
          log.debug("Unknown widget: " + id);
          continue;
        }

        let widget = null;
        // If the placements have items in them which are (now) no longer removable,
        // we shouldn't be moving them:
        if (provider == CustomizableUI.PROVIDER_API) {
          widget = gPalette.get(id);
          if (!widget.removable && aArea != widget.defaultArea) {
            placementsToRemove.add(id);
            continue;
          }
        } else if (provider == CustomizableUI.PROVIDER_XUL &&
                   node.parentNode != container && !this.isWidgetRemovable(node)) {
          placementsToRemove.add(id);
          continue;
        } // Special widgets are always removable, so no need to check them

        if (inPrivateWindow && widget && !widget.showInPrivateBrowsing) {
          continue;
        }

        this.ensureButtonContextMenu(node, aAreaNode);
        if (node.localName == "toolbarbutton") {
          if (areaIsPanel) {
            node.setAttribute("wrap", "true");
          } else {
            node.removeAttribute("wrap");
          }
        }

        // This needs updating in case we're resetting / undoing a reset.
        if (widget) {
          widget.currentArea = aArea;
        }
        this.insertWidgetBefore(node, currentNode, container, aArea);
        if (gResetting) {
          this.notifyListeners("onWidgetReset", node, container);
        } else if (gUndoResetting) {
          this.notifyListeners("onWidgetUndoMove", node, container);
        }
      }

      if (currentNode) {
        let palette = aAreaNode.toolbox ? aAreaNode.toolbox.palette : null;
        let limit = currentNode.previousSibling;
        let node = container.lastChild;
        while (node && node != limit) {
          let previousSibling = node.previousSibling;
          // Nodes opt-in to removability. If they're removable, and we haven't
          // seen them in the placements array, then we toss them into the palette
          // if one exists. If no palette exists, we just remove the node. If the
          // node is not removable, we leave it where it is. However, we can only
          // safely touch elements that have an ID - both because we depend on
          // IDs, and because such elements are not intended to be widgets
          // (eg, titlebar-placeholder elements).
          if (node.id && node.getAttribute("skipintoolbarset") != "true") {
            if (this.isWidgetRemovable(node)) {
              if (palette && !this.isSpecialWidget(node.id)) {
                palette.appendChild(node);
                this.removeLocationAttributes(node);
              } else {
                container.removeChild(node);
              }
            } else {
              node.setAttribute("removable", false);
              log.debug("Adding non-removable widget to placements of " + aArea + ": " +
                        node.id);
              gPlacements.get(aArea).push(node.id);
              gDirty = true;
            }
          }
          node = previousSibling;
        }
      }

      // If there are placements in here which aren't removable from their original area,
      // we remove them from this area's placement array. They will (have) be(en) added
      // to their original area's placements array in the block above this one.
      if (placementsToRemove.size) {
        let placementAry = gPlacements.get(aArea);
        for (let id of placementsToRemove) {
          let index = placementAry.indexOf(id);
          placementAry.splice(index, 1);
        }
      }

      if (gResetting) {
        this.notifyListeners("onAreaReset", aArea, container);
      }
    } finally {
      this.endBatchUpdate();
    }
  },

  addPanelCloseListeners: function(aPanel) {
    gELS.addSystemEventListener(aPanel, "click", this, false);
    gELS.addSystemEventListener(aPanel, "keypress", this, false);
    let win = aPanel.ownerGlobal;
    if (!gPanelsForWindow.has(win)) {
      gPanelsForWindow.set(win, new Set());
    }
    gPanelsForWindow.get(win).add(this._getPanelForNode(aPanel));
  },

  removePanelCloseListeners: function(aPanel) {
    gELS.removeSystemEventListener(aPanel, "click", this, false);
    gELS.removeSystemEventListener(aPanel, "keypress", this, false);
    let win = aPanel.ownerGlobal;
    let panels = gPanelsForWindow.get(win);
    if (panels) {
      panels.delete(this._getPanelForNode(aPanel));
    }
  },

  ensureButtonContextMenu: function(aNode, aAreaNode) {
    const kPanelItemContextMenu = "customizationPanelItemContextMenu";

    let currentContextMenu = aNode.getAttribute("context") ||
                             aNode.getAttribute("contextmenu");
    let place = CustomizableUI.getPlaceForItem(aAreaNode);
    let contextMenuForPlace = place == "panel" ?
                                kPanelItemContextMenu :
                                null;
    if (contextMenuForPlace && !currentContextMenu) {
      aNode.setAttribute("context", contextMenuForPlace);
    } else if (currentContextMenu == kPanelItemContextMenu &&
               contextMenuForPlace != kPanelItemContextMenu) {
      aNode.removeAttribute("context");
      aNode.removeAttribute("contextmenu");
    }
  },

  getWidgetProvider: function(aWidgetId) {
    if (this.isSpecialWidget(aWidgetId)) {
      return CustomizableUI.PROVIDER_SPECIAL;
    }
    if (gPalette.has(aWidgetId)) {
      return CustomizableUI.PROVIDER_API;
    }
    // If this was an API widget that was destroyed, return null:
    if (gSeenWidgets.has(aWidgetId)) {
      return null;
    }

    // We fall back to the XUL provider, but we don't know for sure (at this
    // point) whether it exists there either. So the API is technically lying.
    // Ideally, it would be able to return an error value (or throw an
    // exception) if it really didn't exist. Our code calling this function
    // handles that fine, but this is a public API.
    return CustomizableUI.PROVIDER_XUL;
  },

  getWidgetNode: function(aWidgetId, aWindow) {
    let document = aWindow.document;

    if (this.isSpecialWidget(aWidgetId)) {
      let widgetNode = document.getElementById(aWidgetId) ||
                       this.createSpecialWidget(aWidgetId, document);
      return [ CustomizableUI.PROVIDER_SPECIAL, widgetNode];
    }

    let widget = gPalette.get(aWidgetId);
    if (widget) {
      // If we have an instance of this widget already, just use that.
      if (widget.instances.has(document)) {
        log.debug("An instance of widget " + aWidgetId + " already exists in this "
                  + "document. Reusing.");
        return [ CustomizableUI.PROVIDER_API,
                 widget.instances.get(document) ];
      }

      return [ CustomizableUI.PROVIDER_API,
               this.buildWidget(document, widget) ];
    }

    log.debug("Searching for " + aWidgetId + " in toolbox.");
    let node = this.findWidgetInWindow(aWidgetId, aWindow);
    if (node) {
      return [ CustomizableUI.PROVIDER_XUL, node ];
    }

    log.debug("No node for " + aWidgetId + " found.");
    return [null, null];
  },

  registerMenuPanel: function(aPanelContents) {
    if (gBuildAreas.has(CustomizableUI.AREA_PANEL) &&
        gBuildAreas.get(CustomizableUI.AREA_PANEL).has(aPanelContents)) {
      return;
    }

    let document = aPanelContents.ownerDocument;

    aPanelContents.toolbox = document.getElementById("navigator-toolbox");
    aPanelContents.customizationTarget = aPanelContents;

    this.addPanelCloseListeners(this._getPanelForNode(aPanelContents));

    let placements = gPlacements.get(CustomizableUI.AREA_PANEL);
    this.buildArea(CustomizableUI.AREA_PANEL, placements, aPanelContents);
    this.notifyListeners("onAreaNodeRegistered", CustomizableUI.AREA_PANEL, aPanelContents);

    for (let child of aPanelContents.children) {
      if (child.localName != "toolbarbutton") {
        if (child.localName == "toolbaritem") {
          this.ensureButtonContextMenu(child, aPanelContents);
        }
        continue;
      }
      this.ensureButtonContextMenu(child, aPanelContents);
      child.setAttribute("wrap", "true");
    }

    this.registerBuildArea(CustomizableUI.AREA_PANEL, aPanelContents);
  },

  onWidgetAdded: function(aWidgetId, aArea, aPosition) {
    this.insertNode(aWidgetId, aArea, aPosition, true);

    if (!gResetting) {
      this._clearPreviousUIState();
    }
  },

  onWidgetRemoved: function(aWidgetId, aArea) {
    let areaNodes = gBuildAreas.get(aArea);
    if (!areaNodes) {
      return;
    }

    let area = gAreas.get(aArea);
    let isToolbar = area.get("type") == CustomizableUI.TYPE_TOOLBAR;
    let isOverflowable = isToolbar && area.get("overflowable");
    let showInPrivateBrowsing = gPalette.has(aWidgetId)
                              ? gPalette.get(aWidgetId).showInPrivateBrowsing
                              : true;

    for (let areaNode of areaNodes) {
      let window = areaNode.ownerGlobal;
      if (!showInPrivateBrowsing &&
          PrivateBrowsingUtils.isWindowPrivate(window)) {
        continue;
      }

      let container = areaNode.customizationTarget;
      let widgetNode = window.document.getElementById(aWidgetId);
      if (widgetNode && isOverflowable) {
        container = areaNode.overflowable.getContainerFor(widgetNode);
      }

      if (!widgetNode || !container.contains(widgetNode)) {
        log.info("Widget " + aWidgetId + " not found, unable to remove from " + aArea);
        continue;
      }

      this.notifyListeners("onWidgetBeforeDOMChange", widgetNode, null, container, true);

      // We remove location attributes here to make sure they're gone too when a
      // widget is removed from a toolbar to the palette. See bug 930950.
      this.removeLocationAttributes(widgetNode);
      // We also need to remove the panel context menu if it's there:
      this.ensureButtonContextMenu(widgetNode);
      widgetNode.removeAttribute("wrap");
      if (gPalette.has(aWidgetId) || this.isSpecialWidget(aWidgetId)) {
        container.removeChild(widgetNode);
      } else {
        areaNode.toolbox.palette.appendChild(widgetNode);
      }
      this.notifyListeners("onWidgetAfterDOMChange", widgetNode, null, container, true);

      if (isToolbar) {
        areaNode.setAttribute("currentset", gPlacements.get(aArea).join(','));
      }

      let windowCache = gSingleWrapperCache.get(window);
      if (windowCache) {
        windowCache.delete(aWidgetId);
      }
    }
    if (!gResetting) {
      this._clearPreviousUIState();
    }
  },

  onWidgetMoved: function(aWidgetId, aArea, aOldPosition, aNewPosition) {
    this.insertNode(aWidgetId, aArea, aNewPosition);
    if (!gResetting) {
      this._clearPreviousUIState();
    }
  },

  onCustomizeEnd: function(aWindow) {
    this._clearPreviousUIState();
  },

  registerBuildArea: function(aArea, aNode) {
    // We ensure that the window is registered to have its customization data
    // cleaned up when unloading.
    let window = aNode.ownerGlobal;
    if (window.closed) {
      return;
    }
    this.registerBuildWindow(window);

    // Also register this build area's toolbox.
    if (aNode.toolbox) {
      gBuildWindows.get(window).add(aNode.toolbox);
    }

    if (!gBuildAreas.has(aArea)) {
      gBuildAreas.set(aArea, new Set());
    }

    gBuildAreas.get(aArea).add(aNode);

    // Give a class to all customize targets to be used for styling in Customize Mode
    let customizableNode = this.getCustomizeTargetForArea(aArea, window);
    customizableNode.classList.add("customization-target");
  },

  registerBuildWindow: function(aWindow) {
    if (!gBuildWindows.has(aWindow)) {
      gBuildWindows.set(aWindow, new Set());

      aWindow.addEventListener("unload", this);
      aWindow.addEventListener("command", this, true);

      this.notifyListeners("onWindowOpened", aWindow);
    }
  },

  unregisterBuildWindow: function(aWindow) {
    aWindow.removeEventListener("unload", this);
    aWindow.removeEventListener("command", this, true);
    gPanelsForWindow.delete(aWindow);
    gBuildWindows.delete(aWindow);
    gSingleWrapperCache.delete(aWindow);
    let document = aWindow.document;

    for (let [areaId, areaNodes] of gBuildAreas) {
      let areaProperties = gAreas.get(areaId);
      for (let node of areaNodes) {
        if (node.ownerDocument == document) {
          this.notifyListeners("onAreaNodeUnregistered", areaId, node.customizationTarget,
                               CustomizableUI.REASON_WINDOW_CLOSED);
          if (areaProperties.has("overflowable")) {
            node.overflowable.uninit();
            node.overflowable = null;
          }
          areaNodes.delete(node);
        }
      }
    }

    for (let [, widget] of gPalette) {
      widget.instances.delete(document);
      this.notifyListeners("onWidgetInstanceRemoved", widget.id, document);
    }

    for (let [, areaMap] of gPendingBuildAreas) {
      let toDelete = [];
      for (let [areaNode, ] of areaMap) {
        if (areaNode.ownerDocument == document) {
          toDelete.push(areaNode);
        }
      }
      for (let areaNode of toDelete) {
        areaMap.delete(areaNode);
      }
    }

    this.notifyListeners("onWindowClosed", aWindow);
  },

  setLocationAttributes: function(aNode, aArea) {
    let props = gAreas.get(aArea);
    if (!props) {
      throw new Error("Expected area " + aArea + " to have a properties Map " +
                      "associated with it.");
    }

    aNode.setAttribute("cui-areatype", props.get("type") || "");
    let anchor = props.get("anchor");
    if (anchor) {
      aNode.setAttribute("cui-anchorid", anchor);
    } else {
      aNode.removeAttribute("cui-anchorid");
    }
  },

  removeLocationAttributes: function(aNode) {
    aNode.removeAttribute("cui-areatype");
    aNode.removeAttribute("cui-anchorid");
  },

  insertNode: function(aWidgetId, aArea, aPosition, isNew) {
    let areaNodes = gBuildAreas.get(aArea);
    if (!areaNodes) {
      return;
    }

    let placements = gPlacements.get(aArea);
    if (!placements) {
      log.error("Could not find any placements for " + aArea +
                " when moving a widget.");
      return;
    }

    // Go through each of the nodes associated with this area and move the
    // widget to the requested location.
    for (let areaNode of areaNodes) {
      this.insertNodeInWindow(aWidgetId, areaNode, isNew);
    }
  },

  insertNodeInWindow: function(aWidgetId, aAreaNode, isNew) {
    let window = aAreaNode.ownerGlobal;
    let showInPrivateBrowsing = gPalette.has(aWidgetId)
                              ? gPalette.get(aWidgetId).showInPrivateBrowsing
                              : true;

    if (!showInPrivateBrowsing && PrivateBrowsingUtils.isWindowPrivate(window)) {
      return;
    }

    let [, widgetNode] = this.getWidgetNode(aWidgetId, window);
    if (!widgetNode) {
      log.error("Widget '" + aWidgetId + "' not found, unable to move");
      return;
    }

    let areaId = aAreaNode.id;
    if (isNew) {
      this.ensureButtonContextMenu(widgetNode, aAreaNode);
      if (widgetNode.localName == "toolbarbutton" && areaId == CustomizableUI.AREA_PANEL) {
        widgetNode.setAttribute("wrap", "true");
      }
    }

    let [insertionContainer, nextNode] = this.findInsertionPoints(widgetNode, aAreaNode);
    this.insertWidgetBefore(widgetNode, nextNode, insertionContainer, areaId);

    if (gAreas.get(areaId).get("type") == CustomizableUI.TYPE_TOOLBAR) {
      aAreaNode.setAttribute("currentset", gPlacements.get(areaId).join(','));
    }
  },

  findInsertionPoints: function(aNode, aAreaNode) {
    let areaId = aAreaNode.id;
    let props = gAreas.get(areaId);

    // For overflowable toolbars, rely on them (because the work is more complicated):
    if (props.get("type") == CustomizableUI.TYPE_TOOLBAR && props.get("overflowable")) {
      return aAreaNode.overflowable.findOverflowedInsertionPoints(aNode);
    }

    let container = aAreaNode.customizationTarget;
    let placements = gPlacements.get(areaId);
    let nodeIndex = placements.indexOf(aNode.id);

    while (++nodeIndex < placements.length) {
      let nextNodeId = placements[nodeIndex];
      let nextNode = container.getElementsByAttribute("id", nextNodeId).item(0);

      if (nextNode) {
        return [container, nextNode];
      }
    }

    return [container, null];
  },

  insertWidgetBefore: function(aNode, aNextNode, aContainer, aArea) {
    this.notifyListeners("onWidgetBeforeDOMChange", aNode, aNextNode, aContainer);
    this.setLocationAttributes(aNode, aArea);
    aContainer.insertBefore(aNode, aNextNode);
    this.notifyListeners("onWidgetAfterDOMChange", aNode, aNextNode, aContainer);
  },

  handleEvent: function(aEvent) {
    switch (aEvent.type) {
      case "command":
        if (!this._originalEventInPanel(aEvent)) {
          break;
        }
        aEvent = aEvent.sourceEvent;
        // Fall through
      case "click":
      case "keypress":
        this.maybeAutoHidePanel(aEvent);
        break;
      case "unload":
        this.unregisterBuildWindow(aEvent.currentTarget);
        break;
    }
  },

  _originalEventInPanel: function(aEvent) {
    let e = aEvent.sourceEvent;
    if (!e) {
      return false;
    }
    let node = this._getPanelForNode(e.target);
    if (!node) {
      return false;
    }
    let win = e.view;
    let panels = gPanelsForWindow.get(win);
    return !!panels && panels.has(node);
  },

  isSpecialWidget: function(aId) {
    return (aId.startsWith(kSpecialWidgetPfx) ||
            aId.startsWith("separator") ||
            aId.startsWith("spring") ||
            aId.startsWith("spacer"));
  },

  ensureSpecialWidgetId: function(aId) {
    let nodeType = aId.match(/spring|spacer|separator/)[0];
    // If the ID we were passed isn't a generated one, generate one now:
    if (nodeType == aId) {
      // Ids are differentiated through a unique count suffix.
      return kSpecialWidgetPfx + aId + (++gNewElementCount);
    }
    return aId;
  },

  createSpecialWidget: function(aId, aDocument) {
    let nodeName = "toolbar" + aId.match(/spring|spacer|separator/)[0];
    let node = aDocument.createElementNS(kNSXUL, nodeName);
    node.id = this.ensureSpecialWidgetId(aId);
    if (nodeName == "toolbarspring") {
      node.flex = 1;
    }
    return node;
  },

  /* Find a XUL-provided widget in a window. Don't try to use this
   * for an API-provided widget or a special widget.
   */
  findWidgetInWindow: function(aId, aWindow) {
    if (!gBuildWindows.has(aWindow)) {
      throw new Error("Build window not registered");
    }

    if (!aId) {
      log.error("findWidgetInWindow was passed an empty string.");
      return null;
    }

    let document = aWindow.document;

    // look for a node with the same id, as the node may be
    // in a different toolbar.
    let node = document.getElementById(aId);
    if (node) {
      let parent = node.parentNode;
      while (parent && !(parent.customizationTarget ||
                         parent == aWindow.gNavToolbox.palette)) {
        parent = parent.parentNode;
      }

      if (parent) {
        let nodeInArea = node.parentNode.localName == "toolbarpaletteitem" ?
                         node.parentNode : node;
        // Check if we're in a customization target, or in the palette:
        if ((parent.customizationTarget == nodeInArea.parentNode &&
             gBuildWindows.get(aWindow).has(parent.toolbox)) ||
            aWindow.gNavToolbox.palette == nodeInArea.parentNode) {
          // Normalize the removable attribute. For backwards compat, if
          // the widget is not located in a toolbox palette then absence
          // of the "removable" attribute means it is not removable.
          if (!node.hasAttribute("removable")) {
            // If we first see this in customization mode, it may be in the
            // customization palette instead of the toolbox palette.
            node.setAttribute("removable", !parent.customizationTarget);
          }
          return node;
        }
      }
    }

    let toolboxes = gBuildWindows.get(aWindow);
    for (let toolbox of toolboxes) {
      if (toolbox.palette) {
        // Attempt to locate a node with a matching ID within
        // the palette.
        let node = toolbox.palette.getElementsByAttribute("id", aId)[0];
        if (node) {
          // Normalize the removable attribute. For backwards compat, this
          // is optional if the widget is located in the toolbox palette,
          // and defaults to *true*, unlike if it was located elsewhere.
          if (!node.hasAttribute("removable")) {
            node.setAttribute("removable", true);
          }
          return node;
        }
      }
    }
    return null;
  },

  buildWidget: function(aDocument, aWidget) {
    if (aDocument.documentURI != kExpectedWindowURL) {
      throw new Error("buildWidget was called for a non-browser window!");
    }
    if (typeof aWidget == "string") {
      aWidget = gPalette.get(aWidget);
    }
    if (!aWidget) {
      throw new Error("buildWidget was passed a non-widget to build.");
    }

    log.debug("Building " + aWidget.id + " of type " + aWidget.type);

    let node;
    if (aWidget.type == "custom") {
      if (aWidget.onBuild) {
        node = aWidget.onBuild(aDocument);
      }
      if (!node || !(node instanceof aDocument.defaultView.XULElement))
        log.error("Custom widget with id " + aWidget.id + " does not return a valid node");
    }
    else {
      if (aWidget.onBeforeCreated) {
        aWidget.onBeforeCreated(aDocument);
      }
      node = aDocument.createElementNS(kNSXUL, "toolbarbutton");

      node.setAttribute("id", aWidget.id);
      node.setAttribute("widget-id", aWidget.id);
      node.setAttribute("widget-type", aWidget.type);
      if (aWidget.disabled) {
        node.setAttribute("disabled", true);
      }
      node.setAttribute("removable", aWidget.removable);
      node.setAttribute("overflows", aWidget.overflows);
      if (aWidget.tabSpecific) {
        node.setAttribute("tabspecific", aWidget.tabSpecific);
      }
      node.setAttribute("label", this.getLocalizedProperty(aWidget, "label"));
      let additionalTooltipArguments = [];
      if (aWidget.shortcutId) {
        let keyEl = aDocument.getElementById(aWidget.shortcutId);
        if (keyEl) {
          additionalTooltipArguments.push(ShortcutUtils.prettifyShortcut(keyEl));
        } else {
          log.error("Key element with id '" + aWidget.shortcutId + "' for widget '" + aWidget.id +
                    "' not found!");
        }
      }

      let tooltip = this.getLocalizedProperty(aWidget, "tooltiptext", additionalTooltipArguments);
      if (tooltip) {
        node.setAttribute("tooltiptext", tooltip);
      }
      node.setAttribute("class", "toolbarbutton-1 chromeclass-toolbar-additional");

      let commandHandler = this.handleWidgetCommand.bind(this, aWidget, node);
      node.addEventListener("command", commandHandler, false);
      let clickHandler = this.handleWidgetClick.bind(this, aWidget, node);
      node.addEventListener("click", clickHandler, false);

      // If the widget has a view, and has view showing / hiding listeners,
      // hook those up to this widget.
      if (aWidget.type == "view") {
        log.debug("Widget " + aWidget.id + " has a view. Auto-registering event handlers.");
        let viewNode = aDocument.getElementById(aWidget.viewId);

        if (viewNode) {
          // PanelUI relies on the .PanelUI-subView class to be able to show only
          // one sub-view at a time.
          viewNode.classList.add("PanelUI-subView");

          for (let eventName of kSubviewEvents) {
            let handler = "on" + eventName;
            if (typeof aWidget[handler] == "function") {
              viewNode.addEventListener(eventName, aWidget[handler], false);
            }
          }

          log.debug("Widget " + aWidget.id + " showing and hiding event handlers set.");
        } else {
          log.error("Could not find the view node with id: " + aWidget.viewId +
                    ", for widget: " + aWidget.id + ".");
        }
      }

      if (aWidget.onCreated) {
        aWidget.onCreated(node);
      }
    }

    aWidget.instances.set(aDocument, node);
    return node;
  },

  getLocalizedProperty: function(aWidget, aProp, aFormatArgs, aDef) {
    const kReqStringProps = ["label"];

    if (typeof aWidget == "string") {
      aWidget = gPalette.get(aWidget);
    }
    if (!aWidget) {
      throw new Error("getLocalizedProperty was passed a non-widget to work with.");
    }
    let def, name;
    // Let widgets pass their own string identifiers or strings, so that
    // we can use strings which aren't the default (in case string ids change)
    // and so that non-builtin-widgets can also provide labels, tooltips, etc.
    if (aWidget[aProp] != null) {
      name = aWidget[aProp];
      // By using this as the default, if a widget provides a full string rather
      // than a string ID for localization, we will fall back to that string
      // and return that.
      def = aDef || name;
    } else {
      name = aWidget.id + "." + aProp;
      def = aDef || "";
    }
    try {
      if (Array.isArray(aFormatArgs) && aFormatArgs.length) {
        return gWidgetsBundle.formatStringFromName(name, aFormatArgs,
          aFormatArgs.length) || def;
      }
      return gWidgetsBundle.GetStringFromName(name) || def;
    } catch (ex) {
      // If an empty string was explicitly passed, treat it as an actual
      // value rather than a missing property.
      if (!def && (name != "" || kReqStringProps.includes(aProp))) {
        log.error("Could not localize property '" + name + "'.");
      }
    }
    return def;
  },

  addShortcut: function(aShortcutNode, aTargetNode) {
    if (!aTargetNode)
      aTargetNode = aShortcutNode;
    let document = aShortcutNode.ownerDocument;

    // Detect if we've already been here before.
    if (!aTargetNode || aTargetNode.hasAttribute("shortcut"))
      return;

    let shortcutId = aShortcutNode.getAttribute("key");
    let shortcut;
    if (shortcutId) {
      shortcut = document.getElementById(shortcutId);
    } else {
      let commandId = aShortcutNode.getAttribute("command");
      if (commandId)
        shortcut = ShortcutUtils.findShortcut(document.getElementById(commandId));
    }
    if (!shortcut) {
      return;
    }

    aTargetNode.setAttribute("shortcut", ShortcutUtils.prettifyShortcut(shortcut));
  },

  handleWidgetCommand: function(aWidget, aNode, aEvent) {
    log.debug("handleWidgetCommand");

    if (aWidget.type == "button") {
      if (aWidget.onCommand) {
        try {
          aWidget.onCommand.call(null, aEvent);
        } catch (e) {
          log.error(e);
        }
      } else {
        // XXXunf Need to think this through more, and formalize.
        Services.obs.notifyObservers(aNode,
                                     "customizedui-widget-command",
                                     aWidget.id);
      }
    } else if (aWidget.type == "view") {
      let ownerWindow = aNode.ownerGlobal;
      let area = this.getPlacementOfWidget(aNode.id).area;
      let anchor = aNode;
      if (area != CustomizableUI.AREA_PANEL) {
        let wrapper = this.wrapWidget(aWidget.id).forWindow(ownerWindow);
        if (wrapper && wrapper.anchor) {
          this.hidePanelForNode(aNode);
          anchor = wrapper.anchor;
        }
      }
      ownerWindow.PanelUI.showSubView(aWidget.viewId, anchor, area);
    }
  },

  handleWidgetClick: function(aWidget, aNode, aEvent) {
    log.debug("handleWidgetClick");
    if (aWidget.onClick) {
      try {
        aWidget.onClick.call(null, aEvent);
      } catch (e) {
        Cu.reportError(e);
      }
    } else {
      // XXXunf Need to think this through more, and formalize.
      Services.obs.notifyObservers(aNode, "customizedui-widget-click", aWidget.id);
    }
  },

  _getPanelForNode: function(aNode) {
    let panel = aNode;
    while (panel && panel.localName != "panel")
      panel = panel.parentNode;
    return panel;
  },

  /*
   * If people put things in the panel which need more than single-click interaction,
   * we don't want to close it. Right now we check for text inputs and menu buttons.
   * We also check for being outside of any toolbaritem/toolbarbutton, ie on a blank
   * part of the menu.
   */
  _isOnInteractiveElement: function(aEvent) {
    function getMenuPopupForDescendant(aNode) {
      let lastPopup = null;
      while (aNode && aNode.parentNode &&
             aNode.parentNode.localName.startsWith("menu")) {
        lastPopup = aNode.localName == "menupopup" ? aNode : lastPopup;
        aNode = aNode.parentNode;
      }
      return lastPopup;
    }

    let target = aEvent.originalTarget;
    let panel = this._getPanelForNode(aEvent.currentTarget);
    // This can happen in e.g. customize mode. If there's no panel,
    // there's clearly nothing for us to close; pretend we're interactive.
    if (!panel) {
      return true;
    }
    // We keep track of:
    // whether we're in an input container (text field)
    let inInput = false;
    // whether we're in a popup/context menu
    let inMenu = false;
    // whether we're in a toolbarbutton/toolbaritem
    let inItem = false;
    // whether the current menuitem has a valid closemenu attribute
    let menuitemCloseMenu = "auto";
    // whether the toolbarbutton/item has a valid closemenu attribute.
    let closemenu = "auto";

    // While keeping track of that, we go from the original target back up,
    // to the panel if we have to. We bail as soon as we find an input,
    // a toolbarbutton/item, or the panel:
    while (true && target) {
      // Skip out of iframes etc:
      if (target.nodeType == target.DOCUMENT_NODE) {
        if (!target.defaultView) {
          // Err, we're done.
          break;
        }
        // Cue some voodoo
        target = target.defaultView.QueryInterface(Ci.nsIInterfaceRequestor)
                                   .getInterface(Ci.nsIWebNavigation)
                                   .QueryInterface(Ci.nsIDocShell)
                                   .chromeEventHandler;
        if (!target) {
          break;
        }
      }
      let tagName = target.localName;
      inInput = tagName == "input" || tagName == "textbox";
      inItem = tagName == "toolbaritem" || tagName == "toolbarbutton";
      let isMenuItem = tagName == "menuitem";
      inMenu = inMenu || isMenuItem;
      if (inItem && target.hasAttribute("closemenu")) {
        let closemenuVal = target.getAttribute("closemenu");
        closemenu = (closemenuVal == "single" || closemenuVal == "none") ?
                    closemenuVal : "auto";
      }

      if (isMenuItem && target.hasAttribute("closemenu")) {
        let closemenuVal = target.getAttribute("closemenu");
        menuitemCloseMenu = (closemenuVal == "single" || closemenuVal == "none") ?
                            closemenuVal : "auto";
      }
      // Break out of the loop immediately for disabled items, as we need to
      // keep the menu open in that case.
      if (target.getAttribute("disabled") == "true") {
        return true;
      }

      // This isn't in the loop condition because we want to break before
      // changing |target| if any of these conditions are true
      if (inInput || inItem || target == panel) {
        break;
      }
      // We need specific code for popups: the item on which they were invoked
      // isn't necessarily in their parentNode chain:
      if (isMenuItem) {
        let topmostMenuPopup = getMenuPopupForDescendant(target);
        target = (topmostMenuPopup && topmostMenuPopup.triggerNode) ||
                 target.parentNode;
      } else {
        target = target.parentNode;
      }
    }

    // If the user clicked a menu item...
    if (inMenu) {
      // We care if we're in an input also,
      // or if the user specified closemenu!="auto":
      if (inInput || menuitemCloseMenu != "auto") {
        return true;
      }
      // Otherwise, we're probably fine to close the panel
      return false;
    }
    // If we're not in a menu, and we *are* in a type="menu" toolbarbutton,
    // we'll now interact with the menu
    if (inItem && target.getAttribute("type") == "menu") {
      return true;
    }
    // If we're not in a menu, and we *are* in a type="menu-button" toolbarbutton,
    // it depends whether we're in the dropmarker or the 'real' button:
    if (inItem && target.getAttribute("type") == "menu-button") {
      // 'real' button (which has a single action):
      if (target.getAttribute("anonid") == "button") {
        return closemenu != "none";
      }
      // otherwise, this is the outer button, and the user will now
      // interact with the menu:
      return true;
    }
    return inInput || !inItem;
  },

  hidePanelForNode: function(aNode) {
    let panel = this._getPanelForNode(aNode);
    if (panel) {
      panel.hidePopup();
    }
  },

  maybeAutoHidePanel: function(aEvent) {
    if (aEvent.type == "keypress") {
      if (aEvent.keyCode != aEvent.DOM_VK_RETURN) {
        return;
      }
      // If the user hit enter/return, we don't check preventDefault - it makes sense
      // that this was prevented, but we probably still want to close the panel.
      // If consumers don't want this to happen, they should specify the closemenu
      // attribute.

    } else if (aEvent.type != "command") { // mouse events:
      if (aEvent.defaultPrevented || aEvent.button != 0) {
        return;
      }
      let isInteractive = this._isOnInteractiveElement(aEvent);
      log.debug("maybeAutoHidePanel: interactive ? " + isInteractive);
      if (isInteractive) {
        return;
      }
    }

    // We can't use event.target because we might have passed a panelview
    // anonymous content boundary as well, and so target points to the
    // panelmultiview in that case. Unfortunately, this means we get
    // anonymous child nodes instead of the real ones, so looking for the
    // 'stoooop, don't close me' attributes is more involved.
    let target = aEvent.originalTarget;
    let closemenu = "auto";
    let widgetType = "button";
    while (target.parentNode && target.localName != "panel") {
      closemenu = target.getAttribute("closemenu");
      widgetType = target.getAttribute("widget-type");
      if (closemenu == "none" || closemenu == "single" ||
          widgetType == "view") {
        break;
      }
      target = target.parentNode;
    }
    if (closemenu == "none" || widgetType == "view") {
      return;
    }

    if (closemenu == "single") {
      let panel = this._getPanelForNode(target);
      let multiview = panel.querySelector("panelmultiview");
      if (multiview.showingSubView) {
        multiview.showMainView();
        return;
      }
    }

    // If we get here, we can actually hide the popup:
    this.hidePanelForNode(aEvent.target);
  },

  getUnusedWidgets: function(aWindowPalette) {
    let window = aWindowPalette.ownerGlobal;
    let isWindowPrivate = PrivateBrowsingUtils.isWindowPrivate(window);
    // We use a Set because there can be overlap between the widgets in
    // gPalette and the items in the palette, especially after the first
    // customization, since programmatically generated widgets will remain
    // in the toolbox palette.
    let widgets = new Set();

    // It's possible that some widgets have been defined programmatically and
    // have not been overlayed into the palette. We can find those inside
    // gPalette.
    for (let [id, widget] of gPalette) {
      if (!widget.currentArea) {
        if (widget.showInPrivateBrowsing || !isWindowPrivate) {
          widgets.add(id);
        }
      }
    }

    log.debug("Iterating the actual nodes of the window palette");
    for (let node of aWindowPalette.children) {
      log.debug("In palette children: " + node.id);
      if (node.id && !this.getPlacementOfWidget(node.id)) {
        widgets.add(node.id);
      }
    }

    return [...widgets];
  },

  getPlacementOfWidget: function(aWidgetId, aOnlyRegistered, aDeadAreas) {
    if (aOnlyRegistered && !this.widgetExists(aWidgetId)) {
      return null;
    }

    for (let [area, placements] of gPlacements) {
      if (!gAreas.has(area) && !aDeadAreas) {
        continue;
      }
      let index = placements.indexOf(aWidgetId);
      if (index != -1) {
        return { area: area, position: index };
      }
    }

    return null;
  },

  widgetExists: function(aWidgetId) {
    if (gPalette.has(aWidgetId) || this.isSpecialWidget(aWidgetId)) {
      return true;
    }

    // Destroyed API widgets are in gSeenWidgets, but not in gPalette:
    if (gSeenWidgets.has(aWidgetId)) {
      return false;
    }

    // We're assuming XUL widgets always exist, as it's much harder to check,
    // and checking would be much more error prone.
    return true;
  },

  addWidgetToArea: function(aWidgetId, aArea, aPosition, aInitialAdd) {
    if (!gAreas.has(aArea)) {
      throw new Error("Unknown customization area: " + aArea);
    }

    // Hack: don't want special widgets in the panel (need to check here as well
    // as in canWidgetMoveToArea because the menu panel is lazy):
    if (gAreas.get(aArea).get("type") == CustomizableUI.TYPE_MENU_PANEL &&
        this.isSpecialWidget(aWidgetId)) {
      return;
    }

    // If this is a lazy area that hasn't been restored yet, we can't yet modify
    // it - would would at least like to add to it. So we keep track of it in
    // gFuturePlacements,  and use that to add it when restoring the area. We
    // throw away aPosition though, as that can only be bogus if the area hasn't
    // yet been restorted (caller can't possibly know where its putting the
    // widget in relation to other widgets).
    if (this.isAreaLazy(aArea)) {
      gFuturePlacements.get(aArea).add(aWidgetId);
      return;
    }

    if (this.isSpecialWidget(aWidgetId)) {
      aWidgetId = this.ensureSpecialWidgetId(aWidgetId);
    }

    let oldPlacement = this.getPlacementOfWidget(aWidgetId, false, true);
    if (oldPlacement && oldPlacement.area == aArea) {
      this.moveWidgetWithinArea(aWidgetId, aPosition);
      return;
    }

    // Do nothing if the widget is not allowed to move to the target area.
    if (!this.canWidgetMoveToArea(aWidgetId, aArea)) {
      return;
    }

    if (oldPlacement) {
      this.removeWidgetFromArea(aWidgetId);
    }

    if (!gPlacements.has(aArea)) {
      gPlacements.set(aArea, [aWidgetId]);
      aPosition = 0;
    } else {
      let placements = gPlacements.get(aArea);
      if (typeof aPosition != "number") {
        aPosition = placements.length;
      }
      if (aPosition < 0) {
        aPosition = 0;
      }
      placements.splice(aPosition, 0, aWidgetId);
    }

    let widget = gPalette.get(aWidgetId);
    if (widget) {
      widget.currentArea = aArea;
      widget.currentPosition = aPosition;
    }

    // We initially set placements with addWidgetToArea, so in that case
    // we don't consider the area "dirtied".
    if (!aInitialAdd) {
      gDirtyAreaCache.add(aArea);
    }

    gDirty = true;
    this.saveState();

    this.notifyListeners("onWidgetAdded", aWidgetId, aArea, aPosition);
  },

  removeWidgetFromArea: function(aWidgetId) {
    let oldPlacement = this.getPlacementOfWidget(aWidgetId, false, true);
    if (!oldPlacement) {
      return;
    }

    if (!this.isWidgetRemovable(aWidgetId)) {
      return;
    }

    let placements = gPlacements.get(oldPlacement.area);
    let position = placements.indexOf(aWidgetId);
    if (position != -1) {
      placements.splice(position, 1);
    }

    let widget = gPalette.get(aWidgetId);
    if (widget) {
      widget.currentArea = null;
      widget.currentPosition = null;
    }

    gDirty = true;
    this.saveState();
    gDirtyAreaCache.add(oldPlacement.area);

    this.notifyListeners("onWidgetRemoved", aWidgetId, oldPlacement.area);
  },

  moveWidgetWithinArea: function(aWidgetId, aPosition) {
    let oldPlacement = this.getPlacementOfWidget(aWidgetId);
    if (!oldPlacement) {
      return;
    }

    let placements = gPlacements.get(oldPlacement.area);
    if (typeof aPosition != "number") {
      aPosition = placements.length;
    } else if (aPosition < 0) {
      aPosition = 0;
    } else if (aPosition > placements.length) {
      aPosition = placements.length;
    }

    let widget = gPalette.get(aWidgetId);
    if (widget) {
      widget.currentPosition = aPosition;
      widget.currentArea = oldPlacement.area;
    }

    if (aPosition == oldPlacement.position) {
      return;
    }

    placements.splice(oldPlacement.position, 1);
    // If we just removed the item from *before* where it is now added,
    // we need to compensate the position offset for that:
    if (oldPlacement.position < aPosition) {
      aPosition--;
    }
    placements.splice(aPosition, 0, aWidgetId);

    gDirty = true;
    gDirtyAreaCache.add(oldPlacement.area);

    this.saveState();

    this.notifyListeners("onWidgetMoved", aWidgetId, oldPlacement.area,
                         oldPlacement.position, aPosition);
  },

  // Note that this does not populate gPlacements, which is done lazily so that
  // the legacy state can be migrated, which is only available once a browser
  // window is openned.
  // The panel area is an exception here, since it has no legacy state and is
  // built lazily - and therefore wouldn't otherwise result in restoring its
  // state immediately when a browser window opens, which is important for
  // other consumers of this API.
  loadSavedState: function() {
    let state = null;
    try {
      state = Services.prefs.getCharPref(kPrefCustomizationState);
    } catch (e) {
      log.debug("No saved state found");
      // This will fail if nothing has been customized, so silently fall back to
      // the defaults.
    }

    if (!state) {
      return;
    }
    try {
      gSavedState = JSON.parse(state);
      if (typeof gSavedState != "object" || gSavedState === null) {
        throw "Invalid saved state";
      }
    } catch (e) {
      Services.prefs.clearUserPref(kPrefCustomizationState);
      gSavedState = {};
      log.debug("Error loading saved UI customization state, falling back to defaults.");
    }

    if (!("placements" in gSavedState)) {
      gSavedState.placements = {};
    }

    if (!("currentVersion" in gSavedState)) {
      gSavedState.currentVersion = 0;
    }

    gSeenWidgets = new Set(gSavedState.seen || []);
    gDirtyAreaCache = new Set(gSavedState.dirtyAreaCache || []);
    gNewElementCount = gSavedState.newElementCount || 0;
  },

  restoreStateForArea: function(aArea, aLegacyState) {
    let placementsPreexisted = gPlacements.has(aArea);

    this.beginBatchUpdate();
    try {
      gRestoring = true;

      let restored = false;
      if (placementsPreexisted) {
        log.debug("Restoring " + aArea + " from pre-existing placements");
        for (let [position, id] of gPlacements.get(aArea).entries()) {
          this.moveWidgetWithinArea(id, position);
        }
        gDirty = false;
        restored = true;
      } else {
        gPlacements.set(aArea, []);
      }

      if (!restored && gSavedState && aArea in gSavedState.placements) {
        log.debug("Restoring " + aArea + " from saved state");
        let placements = gSavedState.placements[aArea];
        for (let id of placements)
          this.addWidgetToArea(id, aArea);
        gDirty = false;
        restored = true;
      }

      if (!restored && aLegacyState) {
        log.debug("Restoring " + aArea + " from legacy state");
        for (let id of aLegacyState)
          this.addWidgetToArea(id, aArea);
        // Don't override dirty state, to ensure legacy state is saved here and
        // therefore only used once.
        restored = true;
      }

      if (!restored) {
        log.debug("Restoring " + aArea + " from default state");
        let defaults = gAreas.get(aArea).get("defaultPlacements");
        if (defaults) {
          for (let id of defaults)
            this.addWidgetToArea(id, aArea, null, true);
        }
        gDirty = false;
      }

      // Finally, add widgets to the area that were added before the it was able
      // to be restored. This can occur when add-ons register widgets for a
      // lazily-restored area before it's been restored.
      if (gFuturePlacements.has(aArea)) {
        for (let id of gFuturePlacements.get(aArea))
          this.addWidgetToArea(id, aArea);
        gFuturePlacements.delete(aArea);
      }

      log.debug("Placements for " + aArea + ":\n\t" + gPlacements.get(aArea).join("\n\t"));

      gRestoring = false;
    } finally {
      this.endBatchUpdate();
    }
  },

  saveState: function() {
    if (gInBatchStack || !gDirty) {
      return;
    }
    // Clone because we want to modify this map:
    let state = { placements: new Map(gPlacements),
                  seen: gSeenWidgets,
                  dirtyAreaCache: gDirtyAreaCache,
                  currentVersion: kVersion,
                  newElementCount: gNewElementCount };

    // Merge in previously saved areas if not present in gPlacements.
    // This way, state is still persisted for e.g. temporarily disabled
    // add-ons - see bug 989338.
    if (gSavedState && gSavedState.placements) {
      for (let area of Object.keys(gSavedState.placements)) {
        if (!state.placements.has(area)) {
          let placements = gSavedState.placements[area];
          state.placements.set(area, placements);
        }
      }
    }

    log.debug("Saving state.");
    let serialized = JSON.stringify(state, this.serializerHelper);
    log.debug("State saved as: " + serialized);
    Services.prefs.setCharPref(kPrefCustomizationState, serialized);
    gDirty = false;
  },

  serializerHelper: function(aKey, aValue) {
    if (typeof aValue == "object" && aValue.constructor.name == "Map") {
      let result = {};
      for (let [mapKey, mapValue] of aValue)
        result[mapKey] = mapValue;
      return result;
    }

    if (typeof aValue == "object" && aValue.constructor.name == "Set") {
      return [...aValue];
    }

    return aValue;
  },

  beginBatchUpdate: function() {
    gInBatchStack++;
  },

  endBatchUpdate: function(aForceDirty) {
    gInBatchStack--;
    if (aForceDirty === true) {
      gDirty = true;
    }
    if (gInBatchStack == 0) {
      this.saveState();
    } else if (gInBatchStack < 0) {
      throw new Error("The batch editing stack should never reach a negative number.");
    }
  },

  addListener: function(aListener) {
    gListeners.add(aListener);
  },

  removeListener: function(aListener) {
    if (aListener == this) {
      return;
    }

    gListeners.delete(aListener);
  },

  notifyListeners: function(aEvent, ...aArgs) {
    if (gRestoring) {
      return;
    }

    for (let listener of gListeners) {
      try {
        if (typeof listener[aEvent] == "function") {
          listener[aEvent].apply(listener, aArgs);
        }
      } catch (e) {
        log.error(e + " -- " + e.fileName + ":" + e.lineNumber);
      }
    }
  },

  _dispatchToolboxEventToWindow: function(aEventType, aDetails, aWindow) {
    let evt = new aWindow.CustomEvent(aEventType, {
      bubbles: true,
      cancelable: true,
      detail: aDetails
    });
    aWindow.gNavToolbox.dispatchEvent(evt);
  },

  dispatchToolboxEvent: function(aEventType, aDetails={}, aWindow=null) {
    if (aWindow) {
      this._dispatchToolboxEventToWindow(aEventType, aDetails, aWindow);
      return;
    }
    for (let [win, ] of gBuildWindows) {
      this._dispatchToolboxEventToWindow(aEventType, aDetails, win);
    }
  },

  createWidget: function(aProperties) {
    let widget = this.normalizeWidget(aProperties, CustomizableUI.SOURCE_EXTERNAL);
    // XXXunf This should probably throw.
    if (!widget) {
      log.error("unable to normalize widget");
      return undefined;
    }

    gPalette.set(widget.id, widget);

    // Clear our caches:
    gGroupWrapperCache.delete(widget.id);
    for (let [win, ] of gBuildWindows) {
      let cache = gSingleWrapperCache.get(win);
      if (cache) {
        cache.delete(widget.id);
      }
    }

    this.notifyListeners("onWidgetCreated", widget.id);

    if (widget.defaultArea) {
      let addToDefaultPlacements = false;
      let area = gAreas.get(widget.defaultArea);
      if (!CustomizableUI.isBuiltinToolbar(widget.defaultArea) &&
          widget.defaultArea != CustomizableUI.AREA_PANEL) {
        addToDefaultPlacements = true;
      }

      if (addToDefaultPlacements) {
        if (area.has("defaultPlacements")) {
          area.get("defaultPlacements").push(widget.id);
        } else {
          area.set("defaultPlacements", [widget.id]);
        }
      }
    }

    // Look through previously saved state to see if we're restoring a widget.
    let seenAreas = new Set();
    let widgetMightNeedAutoAdding = true;
    for (let [area, ] of gPlacements) {
      seenAreas.add(area);
      let areaIsRegistered = gAreas.has(area);
      let index = gPlacements.get(area).indexOf(widget.id);
      if (index != -1) {
        widgetMightNeedAutoAdding = false;
        if (areaIsRegistered) {
          widget.currentArea = area;
          widget.currentPosition = index;
        }
        break;
      }
    }

    // Also look at saved state data directly in areas that haven't yet been
    // restored. Can't rely on this for restored areas, as they may have
    // changed.
    if (widgetMightNeedAutoAdding && gSavedState) {
      for (let area of Object.keys(gSavedState.placements)) {
        if (seenAreas.has(area)) {
          continue;
        }

        let areaIsRegistered = gAreas.has(area);
        let index = gSavedState.placements[area].indexOf(widget.id);
        if (index != -1) {
          widgetMightNeedAutoAdding = false;
          if (areaIsRegistered) {
            widget.currentArea = area;
            widget.currentPosition = index;
          }
          break;
        }
      }
    }

    // If we're restoring the widget to it's old placement, fire off the
    // onWidgetAdded event - our own handler will take care of adding it to
    // any build areas.
    this.beginBatchUpdate();
    try {
      if (widget.currentArea) {
        this.notifyListeners("onWidgetAdded", widget.id, widget.currentArea,
                             widget.currentPosition);
      } else if (widgetMightNeedAutoAdding) {
        let autoAdd = true;
        try {
          autoAdd = Services.prefs.getBoolPref(kPrefCustomizationAutoAdd);
        } catch (e) {}

        // If the widget doesn't have an existing placement, and it hasn't been
        // seen before, then add it to its default area so it can be used.
        // If the widget is not removable, we *have* to add it to its default
        // area here.
        let canBeAutoAdded = autoAdd && !gSeenWidgets.has(widget.id);
        if (!widget.currentArea && (!widget.removable || canBeAutoAdded)) {
          if (widget.defaultArea) {
            if (this.isAreaLazy(widget.defaultArea)) {
              gFuturePlacements.get(widget.defaultArea).add(widget.id);
            } else {
              this.addWidgetToArea(widget.id, widget.defaultArea);
            }
          }
        }
      }
    } finally {
      // Ensure we always have this widget in gSeenWidgets, and save
      // state in case this needs to be done here.
      gSeenWidgets.add(widget.id);
      this.endBatchUpdate(true);
    }

    this.notifyListeners("onWidgetAfterCreation", widget.id, widget.currentArea);
    return widget.id;
  },

  createBuiltinWidget: function(aData) {
    // This should only ever be called on startup, before any windows are
    // opened - so we know there's no build areas to handle. Also, builtin
    // widgets are expected to be (mostly) static, so shouldn't affect the
    // current placement settings.

    // This allows a widget to be both built-in by default but also able to be
    // destroyed and removed from the area based on criteria that may not be
    // available when the widget is created -- for example, because some other
    // feature in the browser supersedes the widget.
    let conditionalDestroyPromise = aData.conditionalDestroyPromise || null;
    delete aData.conditionalDestroyPromise;

    let widget = this.normalizeWidget(aData, CustomizableUI.SOURCE_BUILTIN);
    if (!widget) {
      log.error("Error creating builtin widget: " + aData.id);
      return;
    }

    log.debug("Creating built-in widget with id: " + widget.id);
    gPalette.set(widget.id, widget);

    if (conditionalDestroyPromise) {
      conditionalDestroyPromise.then(shouldDestroy => {
        if (shouldDestroy) {
          this.destroyWidget(widget.id);
          this.removeWidgetFromArea(widget.id);
        }
      }, err => {
        Cu.reportError(err);
      });
    }
  },

  // Returns true if the area will eventually lazily restore (but hasn't yet).
  isAreaLazy: function(aArea) {
    if (gPlacements.has(aArea)) {
      return false;
    }
    return gAreas.get(aArea).has("legacy");
  },

  // XXXunf Log some warnings here, when the data provided isn't up to scratch.
  normalizeWidget: function(aData, aSource) {
    let widget = {
      implementation: aData,
      source: aSource || CustomizableUI.SOURCE_EXTERNAL,
      instances: new Map(),
      currentArea: null,
      removable: true,
      overflows: true,
      defaultArea: null,
      shortcutId: null,
      tabSpecific: false,
      tooltiptext: null,
      showInPrivateBrowsing: true,
      _introducedInVersion: -1,
    };

    if (typeof aData.id != "string" || !/^[a-z0-9-_]{1,}$/i.test(aData.id)) {
      log.error("Given an illegal id in normalizeWidget: " + aData.id);
      return null;
    }

    delete widget.implementation.currentArea;
    widget.implementation.__defineGetter__("currentArea", () => widget.currentArea);

    const kReqStringProps = ["id"];
    for (let prop of kReqStringProps) {
      if (typeof aData[prop] != "string") {
        log.error("Missing required property '" + prop + "' in normalizeWidget: "
                  + aData.id);
        return null;
      }
      widget[prop] = aData[prop];
    }

    const kOptStringProps = ["label", "tooltiptext", "shortcutId"];
    for (let prop of kOptStringProps) {
      if (typeof aData[prop] == "string") {
        widget[prop] = aData[prop];
      }
    }

    const kOptBoolProps = ["removable", "showInPrivateBrowsing", "overflows", "tabSpecific"];
    for (let prop of kOptBoolProps) {
      if (typeof aData[prop] == "boolean") {
        widget[prop] = aData[prop];
      }
    }

    // When we normalize builtin widgets, areas have not yet been registered:
    if (aData.defaultArea &&
        (aSource == CustomizableUI.SOURCE_BUILTIN || gAreas.has(aData.defaultArea))) {
      widget.defaultArea = aData.defaultArea;
    } else if (!widget.removable) {
      log.error("Widget '" + widget.id + "' is not removable but does not specify " +
                "a valid defaultArea. That's not possible; it must specify a " +
                "valid defaultArea as well.");
      return null;
    }

    if ("type" in aData && gSupportedWidgetTypes.has(aData.type)) {
      widget.type = aData.type;
    } else {
      widget.type = "button";
    }

    widget.disabled = aData.disabled === true;

    if (aSource == CustomizableUI.SOURCE_BUILTIN) {
      widget._introducedInVersion = aData.introducedInVersion || 0;
    }

    this.wrapWidgetEventHandler("onBeforeCreated", widget);
    this.wrapWidgetEventHandler("onClick", widget);
    this.wrapWidgetEventHandler("onCreated", widget);
    this.wrapWidgetEventHandler("onDestroyed", widget);

    if (widget.type == "button") {
      widget.onCommand = typeof aData.onCommand == "function" ?
                           aData.onCommand :
                           null;
    } else if (widget.type == "view") {
      if (typeof aData.viewId != "string") {
        log.error("Expected a string for widget " + widget.id + " viewId, but got "
                  + aData.viewId);
        return null;
      }
      widget.viewId = aData.viewId;

      this.wrapWidgetEventHandler("onViewShowing", widget);
      this.wrapWidgetEventHandler("onViewHiding", widget);
    } else if (widget.type == "custom") {
      this.wrapWidgetEventHandler("onBuild", widget);
    }

    if (gPalette.has(widget.id)) {
      return null;
    }

    return widget;
  },

  wrapWidgetEventHandler: function(aEventName, aWidget) {
    if (typeof aWidget.implementation[aEventName] != "function") {
      aWidget[aEventName] = null;
      return;
    }
    aWidget[aEventName] = function(...aArgs) {
      // Wrap inside a try...catch to properly log errors, until bug 862627 is
      // fixed, which in turn might help bug 503244.
      try {
        // Don't copy the function to the normalized widget object, instead
        // keep it on the original object provided to the API so that
        // additional methods can be implemented and used by the event
        // handlers.
        return aWidget.implementation[aEventName].apply(aWidget.implementation,
                                                        aArgs);
      } catch (e) {
        Cu.reportError(e);
        return undefined;
      }
    };
  },

  destroyWidget: function(aWidgetId) {
    let widget = gPalette.get(aWidgetId);
    if (!widget) {
      gGroupWrapperCache.delete(aWidgetId);
      for (let [window, ] of gBuildWindows) {
        let windowCache = gSingleWrapperCache.get(window);
        if (windowCache) {
          windowCache.delete(aWidgetId);
        }
      }
      return;
    }

    // Remove it from the default placements of an area if it was added there:
    if (widget.defaultArea) {
      let area = gAreas.get(widget.defaultArea);
      if (area) {
        let defaultPlacements = area.get("defaultPlacements");
        // We can assume this is present because if a widget has a defaultArea,
        // we automatically create a defaultPlacements array for that area.
        let widgetIndex = defaultPlacements.indexOf(aWidgetId);
        if (widgetIndex != -1) {
          defaultPlacements.splice(widgetIndex, 1);
        }
      }
    }

    // This will not remove the widget from gPlacements - we want to keep the
    // setting so the widget gets put back in it's old position if/when it
    // returns.
    for (let [window, ] of gBuildWindows) {
      let windowCache = gSingleWrapperCache.get(window);
      if (windowCache) {
        windowCache.delete(aWidgetId);
      }
      let widgetNode = window.document.getElementById(aWidgetId) ||
                       window.gNavToolbox.palette.getElementsByAttribute("id", aWidgetId)[0];
      if (widgetNode) {
        let container = widgetNode.parentNode
        this.notifyListeners("onWidgetBeforeDOMChange", widgetNode, null,
                             container, true);
        widgetNode.remove();
        this.notifyListeners("onWidgetAfterDOMChange", widgetNode, null,
                             container, true);
      }
      if (widget.type == "view") {
        let viewNode = window.document.getElementById(widget.viewId);
        if (viewNode) {
          for (let eventName of kSubviewEvents) {
            let handler = "on" + eventName;
            if (typeof widget[handler] == "function") {
              viewNode.removeEventListener(eventName, widget[handler], false);
            }
          }
        }
      }
      if (widgetNode && widget.onDestroyed) {
        widget.onDestroyed(window.document);
      }
    }

    gPalette.delete(aWidgetId);
    gGroupWrapperCache.delete(aWidgetId);

    this.notifyListeners("onWidgetDestroyed", aWidgetId);
  },

  getCustomizeTargetForArea: function(aArea, aWindow) {
    let buildAreaNodes = gBuildAreas.get(aArea);
    if (!buildAreaNodes) {
      return null;
    }

    for (let node of buildAreaNodes) {
      if (node.ownerGlobal == aWindow) {
        return node.customizationTarget ? node.customizationTarget : node;
      }
    }

    return null;
  },

  reset: function() {
    gResetting = true;
    this._resetUIState();

    // Rebuild each registered area (across windows) to reflect the state that
    // was reset above.
    this._rebuildRegisteredAreas();

    for (let [widgetId, widget] of gPalette) {
      if (widget.source == CustomizableUI.SOURCE_EXTERNAL) {
        gSeenWidgets.add(widgetId);
      }
    }
    if (gSeenWidgets.size) {
      gDirty = true;
    }

    gResetting = false;
  },

  _resetUIState: function() {
    try {
      gUIStateBeforeReset.drawInTitlebar = Services.prefs.getBoolPref(kPrefDrawInTitlebar);
      gUIStateBeforeReset.uiCustomizationState = Services.prefs.getCharPref(kPrefCustomizationState);
      gUIStateBeforeReset.currentTheme = LightweightThemeManager.currentTheme;
    } catch (e) { }

    this._resetExtraToolbars();

    Services.prefs.clearUserPref(kPrefCustomizationState);
    Services.prefs.clearUserPref(kPrefDrawInTitlebar);
    LightweightThemeManager.currentTheme = null;
    log.debug("State reset");

    // Reset placements to make restoring default placements possible.
    gPlacements = new Map();
    gDirtyAreaCache = new Set();
    gSeenWidgets = new Set();
    // Clear the saved state to ensure that defaults will be used.
    gSavedState = null;
    // Restore the state for each area to its defaults
    for (let [areaId, ] of gAreas) {
      this.restoreStateForArea(areaId);
    }
  },

  _resetExtraToolbars: function(aFilter = null) {
    let firstWindow = true; // Only need to unregister and persist once
    for (let [win, ] of gBuildWindows) {
      let toolbox = win.gNavToolbox;
      for (let child of toolbox.children) {
        let matchesFilter = !aFilter || aFilter == child.id;
        if (child.hasAttribute("customindex") && matchesFilter) {
          let toolbarId = "toolbar" + child.getAttribute("customindex");
          toolbox.toolbarset.removeAttribute(toolbarId);
          if (firstWindow) {
            win.document.persist(toolbox.toolbarset.id, toolbarId);
            // We have to unregister it properly to ensure we don't kill
            // XUL widgets which might be in here
            this.unregisterArea(child.id, true);
          }
          child.remove();
        }
      }
      firstWindow = false;
    }
  },

  _rebuildRegisteredAreas: function() {
    for (let [areaId, areaNodes] of gBuildAreas) {
      let placements = gPlacements.get(areaId);
      let isFirstChangedToolbar = true;
      for (let areaNode of areaNodes) {
        this.buildArea(areaId, placements, areaNode);

        let area = gAreas.get(areaId);
        if (area.get("type") == CustomizableUI.TYPE_TOOLBAR) {
          let defaultCollapsed = area.get("defaultCollapsed");
          let win = areaNode.ownerGlobal;
          if (defaultCollapsed !== null) {
            win.setToolbarVisibility(areaNode, !defaultCollapsed, isFirstChangedToolbar);
          }
        }
        isFirstChangedToolbar = false;
      }
    }
  },

  /**
   * Undoes a previous reset, restoring the state of the UI to the state prior to the reset.
   */
  undoReset: function() {
    if (gUIStateBeforeReset.uiCustomizationState == null ||
        gUIStateBeforeReset.drawInTitlebar == null) {
      return;
    }
    gUndoResetting = true;

    let uiCustomizationState = gUIStateBeforeReset.uiCustomizationState;
    let drawInTitlebar = gUIStateBeforeReset.drawInTitlebar;
    let currentTheme = gUIStateBeforeReset.currentTheme;

    // Need to clear the previous state before setting the prefs
    // because pref observers may check if there is a previous UI state.
    this._clearPreviousUIState();

    Services.prefs.setCharPref(kPrefCustomizationState, uiCustomizationState);
    Services.prefs.setBoolPref(kPrefDrawInTitlebar, drawInTitlebar);
    LightweightThemeManager.currentTheme = currentTheme;
    this.loadSavedState();
    // If the user just customizes toolbar/titlebar visibility, gSavedState will be null
    // and we don't need to do anything else here:
    if (gSavedState) {
      for (let areaId of Object.keys(gSavedState.placements)) {
        let placements = gSavedState.placements[areaId];
        gPlacements.set(areaId, placements);
      }
      this._rebuildRegisteredAreas();
    }

    gUndoResetting = false;
  },

  _clearPreviousUIState: function() {
    Object.getOwnPropertyNames(gUIStateBeforeReset).forEach((prop) => {
      gUIStateBeforeReset[prop] = null;
    });
  },

  removeExtraToolbar: function(aToolbarId) {
    this._resetExtraToolbars(aToolbarId);
  },

  /**
   * @param {String|Node} aWidget - widget ID or a widget node (preferred for performance).
   * @return {Boolean} whether the widget is removable
   */
  isWidgetRemovable: function(aWidget) {
    let widgetId;
    let widgetNode;
    if (typeof aWidget == "string") {
      widgetId = aWidget;
    } else {
      widgetId = aWidget.id;
      widgetNode = aWidget;
    }
    let provider = this.getWidgetProvider(widgetId);

    if (provider == CustomizableUI.PROVIDER_API) {
      return gPalette.get(widgetId).removable;
    }

    if (provider == CustomizableUI.PROVIDER_XUL) {
      if (gBuildWindows.size == 0) {
        // We don't have any build windows to look at, so just assume for now
        // that its removable.
        return true;
      }

      if (!widgetNode) {
        // Pick any of the build windows to look at.
        let [window, ] = [...gBuildWindows][0];
        [, widgetNode] = this.getWidgetNode(widgetId, window);
      }
      // If we don't have a node, we assume it's removable. This can happen because
      // getWidgetProvider returns PROVIDER_XUL by default, but this will also happen
      // for API-provided widgets which have been destroyed.
      if (!widgetNode) {
        return true;
      }
      return widgetNode.getAttribute("removable") == "true";
    }

    // Otherwise this is either a special widget, which is always removable, or
    // an API widget which has already been removed from gPalette. Returning true
    // here allows us to then remove its ID from any placements where it might
    // still occur.
    return true;
  },

  canWidgetMoveToArea: function(aWidgetId, aArea) {
    let placement = this.getPlacementOfWidget(aWidgetId);
    if (placement && placement.area != aArea) {
      // Special widgets can't move to the menu panel.
      if (this.isSpecialWidget(aWidgetId) && gAreas.has(aArea) &&
          gAreas.get(aArea).get("type") == CustomizableUI.TYPE_MENU_PANEL) {
        return false;
      }
      // For everything else, just return whether the widget is removable.
      return this.isWidgetRemovable(aWidgetId);
    }

    return true;
  },

  ensureWidgetPlacedInWindow: function(aWidgetId, aWindow) {
    let placement = this.getPlacementOfWidget(aWidgetId);
    if (!placement) {
      return false;
    }
    let areaNodes = gBuildAreas.get(placement.area);
    if (!areaNodes) {
      return false;
    }
    let container = [...areaNodes].filter((n) => n.ownerGlobal == aWindow);
    if (!container.length) {
      return false;
    }
    let existingNode = container[0].getElementsByAttribute("id", aWidgetId)[0];
    if (existingNode) {
      return true;
    }

    this.insertNodeInWindow(aWidgetId, container[0], true);
    return true;
  },

  get inDefaultState() {
    for (let [areaId, props] of gAreas) {
      let defaultPlacements = props.get("defaultPlacements");
      // Areas without default placements (like legacy ones?) get skipped
      if (!defaultPlacements) {
        continue;
      }

      let currentPlacements = gPlacements.get(areaId);
      // We're excluding all of the placement IDs for items that do not exist,
      // and items that have removable="false",
      // because we don't want to consider them when determining if we're
      // in the default state. This way, if an add-on introduces a widget
      // and is then uninstalled, the leftover placement doesn't cause us to
      // automatically assume that the buttons are not in the default state.
      let buildAreaNodes = gBuildAreas.get(areaId);
      if (buildAreaNodes && buildAreaNodes.size) {
        let container = [...buildAreaNodes][0];
        let removableOrDefault = (itemNodeOrItem) => {
          let item = (itemNodeOrItem && itemNodeOrItem.id) || itemNodeOrItem;
          let isRemovable = this.isWidgetRemovable(itemNodeOrItem);
          let isInDefault = defaultPlacements.indexOf(item) != -1;
          return isRemovable || isInDefault;
        };
        // Toolbars have a currentSet property which also deals correctly with overflown
        // widgets (if any) - use that instead:
        if (props.get("type") == CustomizableUI.TYPE_TOOLBAR) {
          let currentSet = container.currentSet;
          currentPlacements = currentSet ? currentSet.split(',') : [];
          currentPlacements = currentPlacements.filter(removableOrDefault);
        } else {
          // Clone the array so we don't modify the actual placements...
          currentPlacements = [...currentPlacements];
          currentPlacements = currentPlacements.filter((item) => {
            let itemNode = container.getElementsByAttribute("id", item)[0];
            return itemNode && removableOrDefault(itemNode || item);
          });
        }

        if (props.get("type") == CustomizableUI.TYPE_TOOLBAR) {
          let attribute = container.getAttribute("type") == "menubar" ? "autohide" : "collapsed";
          let collapsed = container.getAttribute(attribute) == "true";
          let defaultCollapsed = props.get("defaultCollapsed");
          if (defaultCollapsed !== null && collapsed != defaultCollapsed) {
            log.debug("Found " + areaId + " had non-default toolbar visibility (expected " + defaultCollapsed + ", was " + collapsed + ")");
            return false;
          }
        }
      }
      log.debug("Checking default state for " + areaId + ":\n" + currentPlacements.join(",") +
                "\nvs.\n" + defaultPlacements.join(","));

      if (currentPlacements.length != defaultPlacements.length) {
        return false;
      }

      for (let i = 0; i < currentPlacements.length; ++i) {
        if (currentPlacements[i] != defaultPlacements[i]) {
          log.debug("Found " + currentPlacements[i] + " in " + areaId + " where " +
                    defaultPlacements[i] + " was expected!");
          return false;
        }
      }
    }

    if (Services.prefs.prefHasUserValue(kPrefDrawInTitlebar)) {
      log.debug(kPrefDrawInTitlebar + " pref is non-default");
      return false;
    }

    if (LightweightThemeManager.currentTheme) {
      log.debug(LightweightThemeManager.currentTheme + " theme is non-default");
      return false;
    }

    return true;
  },

  setToolbarVisibility: function(aToolbarId, aIsVisible) {
    // We only persist the attribute the first time.
    let isFirstChangedToolbar = true;
    for (let window of CustomizableUI.windows) {
      let toolbar = window.document.getElementById(aToolbarId);
      if (toolbar) {
        window.setToolbarVisibility(toolbar, aIsVisible, isFirstChangedToolbar);
        isFirstChangedToolbar = false;
      }
    }
  },
};
Object.freeze(CustomizableUIInternal);

this.CustomizableUI = {
  /**
   * Constant reference to the ID of the menu panel.
   */
  AREA_PANEL: "PanelUI-contents",
  /**
   * Constant reference to the ID of the navigation toolbar.
   */
  AREA_NAVBAR: "nav-bar",
  /**
   * Constant reference to the ID of the menubar's toolbar.
   */
  AREA_MENUBAR: "toolbar-menubar",
  /**
   * Constant reference to the ID of the tabstrip toolbar.
   */
  AREA_TABSTRIP: "TabsToolbar",
  /**
   * Constant reference to the ID of the bookmarks toolbar.
   */
  AREA_BOOKMARKS: "PersonalToolbar",
  /**
   * Constant reference to the ID of the addon-bar toolbar shim.
   * Do not use, this will be removed as soon as reasonably possible.
   * @deprecated
   */
  AREA_ADDONBAR: "addon-bar",
  /**
   * Constant indicating the area is a menu panel.
   */
  TYPE_MENU_PANEL: "menu-panel",
  /**
   * Constant indicating the area is a toolbar.
   */
  TYPE_TOOLBAR: "toolbar",

  /**
   * Constant indicating a XUL-type provider.
   */
  PROVIDER_XUL: "xul",
  /**
   * Constant indicating an API-type provider.
   */
  PROVIDER_API: "api",
  /**
   * Constant indicating dynamic (special) widgets: spring, spacer, and separator.
   */
  PROVIDER_SPECIAL: "special",

  /**
   * Constant indicating the widget is built-in
   */
  SOURCE_BUILTIN: "builtin",
  /**
   * Constant indicating the widget is externally provided
   * (e.g. by add-ons or other items not part of the builtin widget set).
   */
  SOURCE_EXTERNAL: "external",

  /**
   * The class used to distinguish items that span the entire menu panel.
   */
  WIDE_PANEL_CLASS: "panel-wide-item",
  /**
   * The (constant) number of columns in the menu panel.
   */
  PANEL_COLUMN_COUNT: 3,

  /**
   * Constant indicating the reason the event was fired was a window closing
   */
  REASON_WINDOW_CLOSED: "window-closed",
  /**
   * Constant indicating the reason the event was fired was an area being
   * unregistered separately from window closing mechanics.
   */
  REASON_AREA_UNREGISTERED: "area-unregistered",


  /**
   * An iteratable property of windows managed by CustomizableUI.
   * Note that this can *only* be used as an iterator. ie:
   *     for (let window of CustomizableUI.windows) { ... }
   */
  windows: {
    *[Symbol.iterator]() {
      for (let [window, ] of gBuildWindows)
        yield window;
    }
  },

  /**
   * Add a listener object that will get fired for various events regarding
   * customization.
   *
   * @param aListener the listener object to add
   *
   * Not all event handler methods need to be defined.
   * CustomizableUI will catch exceptions. Events are dispatched
   * synchronously on the UI thread, so if you can delay any/some of your
   * processing, that is advisable. The following event handlers are supported:
   *   - onWidgetAdded(aWidgetId, aArea, aPosition)
   *     Fired when a widget is added to an area. aWidgetId is the widget that
   *     was added, aArea the area it was added to, and aPosition the position
   *     in which it was added.
   *   - onWidgetMoved(aWidgetId, aArea, aOldPosition, aNewPosition)
   *     Fired when a widget is moved within its area. aWidgetId is the widget
   *     that was moved, aArea the area it was moved in, aOldPosition its old
   *     position, and aNewPosition its new position.
   *   - onWidgetRemoved(aWidgetId, aArea)
   *     Fired when a widget is removed from its area. aWidgetId is the widget
   *     that was removed, aArea the area it was removed from.
   *
   *   - onWidgetBeforeDOMChange(aNode, aNextNode, aContainer, aIsRemoval)
   *     Fired *before* a widget's DOM node is acted upon by CustomizableUI
   *     (to add, move or remove it). aNode is the DOM node changed, aNextNode
   *     the DOM node (if any) before which a widget will be inserted,
   *     aContainer the *actual* DOM container (could be an overflow panel in
   *     case of an overflowable toolbar), and aWasRemoval is true iff the
   *     action about to happen is the removal of the DOM node.
   *   - onWidgetAfterDOMChange(aNode, aNextNode, aContainer, aWasRemoval)
   *     Like onWidgetBeforeDOMChange, but fired after the change to the DOM
   *     node of the widget.
   *
   *   - onWidgetReset(aNode, aContainer)
   *     Fired after a reset to default placements moves a widget's node to a
   *     different location. aNode is the widget's node, aContainer is the
   *     area it was moved into (NB: it might already have been there and been
   *     moved to a different position!)
   *   - onWidgetUndoMove(aNode, aContainer)
   *     Fired after undoing a reset to default placements moves a widget's
   *     node to a different location. aNode is the widget's node, aContainer
   *     is the area it was moved into (NB: it might already have been there
   *     and been moved to a different position!)
   *   - onAreaReset(aArea, aContainer)
   *     Fired after a reset to default placements is complete on an area's
   *     DOM node. Note that this is fired for each DOM node. aArea is the area
   *     that was reset, aContainer the DOM node that was reset.
   *
   *   - onWidgetCreated(aWidgetId)
   *     Fired when a widget with id aWidgetId has been created, but before it
   *     is added to any placements or any DOM nodes have been constructed.
   *     Only fired for API-based widgets.
   *   - onWidgetAfterCreation(aWidgetId, aArea)
   *     Fired after a widget with id aWidgetId has been created, and has been
   *     added to either its default area or the area in which it was placed
   *     previously. If the widget has no default area and/or it has never
   *     been placed anywhere, aArea may be null. Only fired for API-based
   *     widgets.
   *   - onWidgetDestroyed(aWidgetId)
   *     Fired when widgets are destroyed. aWidgetId is the widget that is
   *     being destroyed. Only fired for API-based widgets.
   *   - onWidgetInstanceRemoved(aWidgetId, aDocument)
   *     Fired when a window is unloaded and a widget's instance is destroyed
   *     because of this. Only fired for API-based widgets.
   *
   *   - onWidgetDrag(aWidgetId, aArea)
   *     Fired both when and after customize mode drag handling system tries
   *     to determine the width and height of widget aWidgetId when dragged to a
   *     different area. aArea will be the area the item is dragged to, or
   *     undefined after the measurements have been done and the node has been
   *     moved back to its 'regular' area.
   *
   *   - onCustomizeStart(aWindow)
   *     Fired when opening customize mode in aWindow.
   *   - onCustomizeEnd(aWindow)
   *     Fired when exiting customize mode in aWindow.
   *
   *   - onWidgetOverflow(aNode, aContainer)
   *     Fired when a widget's DOM node is overflowing its container, a toolbar,
   *     and will be displayed in the overflow panel.
   *   - onWidgetUnderflow(aNode, aContainer)
   *     Fired when a widget's DOM node is *not* overflowing its container, a
   *     toolbar, anymore.
   *   - onWindowOpened(aWindow)
   *     Fired when a window has been opened that is managed by CustomizableUI,
   *     once all of the prerequisite setup has been done.
   *   - onWindowClosed(aWindow)
   *     Fired when a window that has been managed by CustomizableUI has been
   *     closed.
   *   - onAreaNodeRegistered(aArea, aContainer)
   *     Fired after an area node is first built when it is registered. This
   *     is often when the window has opened, but in the case of add-ons,
   *     could fire when the node has just been registered with CustomizableUI
   *     after an add-on update or disable/enable sequence.
   *   - onAreaNodeUnregistered(aArea, aContainer, aReason)
   *     Fired when an area node is explicitly unregistered by an API caller,
   *     or by a window closing. The aReason parameter indicates which of
   *     these is the case.
   */
  addListener: function(aListener) {
    CustomizableUIInternal.addListener(aListener);
  },
  /**
   * Remove a listener added with addListener
   * @param aListener the listener object to remove
   */
  removeListener: function(aListener) {
    CustomizableUIInternal.removeListener(aListener);
  },

  /**
   * Register a customizable area with CustomizableUI.
   * @param aName   the name of the area to register. Can only contain
   *                alphanumeric characters, dashes (-) and underscores (_).
   * @param aProps  the properties of the area. The following properties are
   *                recognized:
   *                - type:   the type of area. Either TYPE_TOOLBAR (default) or
   *                          TYPE_MENU_PANEL;
   *                - anchor: for a menu panel or overflowable toolbar, the
   *                          anchoring node for the panel.
   *                - legacy: set to true if you want customizableui to
   *                          automatically migrate the currentset attribute
   *                - overflowable: set to true if your toolbar is overflowable.
   *                                This requires an anchor, and only has an
   *                                effect for toolbars.
   *                - defaultPlacements: an array of widget IDs making up the
   *                                     default contents of the area
   *                - defaultCollapsed: (INTERNAL ONLY) applies if the type is TYPE_TOOLBAR, specifies
   *                                    if toolbar is collapsed by default (default to true).
   *                                    Specify null to ensure that reset/inDefaultArea don't care
   *                                    about a toolbar's collapsed state
   */
  registerArea: function(aName, aProperties) {
    CustomizableUIInternal.registerArea(aName, aProperties);
  },
  /**
   * Register a concrete node for a registered area. This method is automatically
   * called from any toolbar in the main browser window that has its
   * "customizable" attribute set to true. There should normally be no need to
   * call it yourself.
   *
   * Note that ideally, you should register your toolbar using registerArea
   * before any of the toolbars have their XBL bindings constructed (which
   * will happen when they're added to the DOM and are not hidden). If you
   * don't, and your toolbar has a defaultset attribute, CustomizableUI will
   * register it automatically. If your toolbar does not have a defaultset
   * attribute, the node will be saved for processing when you call
   * registerArea. Note that CustomizableUI won't restore state in the area,
   * allow the user to customize it in customize mode, or otherwise deal
   * with it, until the area has been registered.
   */
  registerToolbarNode: function(aToolbar, aExistingChildren) {
    CustomizableUIInternal.registerToolbarNode(aToolbar, aExistingChildren);
  },
  /**
   * Register the menu panel node. This method should not be called by anyone
   * apart from the built-in PanelUI.
   * @param aPanel the panel DOM node being registered.
   */
  registerMenuPanel: function(aPanel) {
    CustomizableUIInternal.registerMenuPanel(aPanel);
  },
  /**
   * Unregister a customizable area. The inverse of registerArea.
   *
   * Unregistering an area will remove all the (removable) widgets in the
   * area, which will return to the panel, and destroy all other traces
   * of the area within CustomizableUI. Note that this means the *contents*
   * of the area's DOM nodes will be moved to the panel or removed, but
   * the area's DOM nodes *themselves* will stay.
   *
   * Furthermore, by default the placements of the area will be kept in the
   * saved state (!) and restored if you re-register the area at a later
   * point. This is useful for e.g. add-ons that get disabled and then
   * re-enabled (e.g. when they update).
   *
   * You can override this last behaviour (and destroy the placements
   * information in the saved state) by passing true for aDestroyPlacements.
   *
   * @param aName              the name of the area to unregister
   * @param aDestroyPlacements whether to destroy the placements information
   *                           for the area, too.
   */
  unregisterArea: function(aName, aDestroyPlacements) {
    CustomizableUIInternal.unregisterArea(aName, aDestroyPlacements);
  },
  /**
   * Add a widget to an area.
   * If the area to which you try to add is not known to CustomizableUI,
   * this will throw.
   * If the area to which you try to add has not yet been restored from its
   * legacy state, this will postpone the addition.
   * If the area to which you try to add is the same as the area in which
   * the widget is currently placed, this will do the same as
   * moveWidgetWithinArea.
   * If the widget cannot be removed from its original location, this will
   * no-op.
   *
   * This will fire an onWidgetAdded notification,
   * and an onWidgetBeforeDOMChange and onWidgetAfterDOMChange notification
   * for each window CustomizableUI knows about.
   *
   * @param aWidgetId the ID of the widget to add
   * @param aArea     the ID of the area to add the widget to
   * @param aPosition the position at which to add the widget. If you do not
   *                  pass a position, the widget will be added to the end
   *                  of the area.
   */
  addWidgetToArea: function(aWidgetId, aArea, aPosition) {
    CustomizableUIInternal.addWidgetToArea(aWidgetId, aArea, aPosition);
  },
  /**
   * Remove a widget from its area. If the widget cannot be removed from its
   * area, or is not in any area, this will no-op. Otherwise, this will fire an
   * onWidgetRemoved notification, and an onWidgetBeforeDOMChange and
   * onWidgetAfterDOMChange notification for each window CustomizableUI knows
   * about.
   *
   * @param aWidgetId the ID of the widget to remove
   */
  removeWidgetFromArea: function(aWidgetId) {
    CustomizableUIInternal.removeWidgetFromArea(aWidgetId);
  },
  /**
   * Move a widget within an area.
   * If the widget is not in any area, this will no-op.
   * If the widget is already at the indicated position, this will no-op.
   *
   * Otherwise, this will move the widget and fire an onWidgetMoved notification,
   * and an onWidgetBeforeDOMChange and onWidgetAfterDOMChange notification for
   * each window CustomizableUI knows about.
   *
   * @param aWidgetId the ID of the widget to move
   * @param aPosition the position to move the widget to.
   *                  Negative values or values greater than the number of
   *                  widgets will be interpreted to mean moving the widget to
   *                  respectively the first or last position.
   */
  moveWidgetWithinArea: function(aWidgetId, aPosition) {
    CustomizableUIInternal.moveWidgetWithinArea(aWidgetId, aPosition);
  },
  /**
   * Ensure a XUL-based widget created in a window after areas were
   * initialized moves to its correct position.
   * This is roughly equivalent to manually looking up the position and using
   * insertItem in the old API, but a lot less work for consumers.
   * Always prefer this over using toolbar.insertItem (which might no-op
   * because it delegates to addWidgetToArea) or, worse, moving items in the
   * DOM yourself.
   *
   * @param aWidgetId the ID of the widget that was just created
   * @param aWindow the window in which you want to ensure it was added.
   *
   * NB: why is this API per-window, you wonder? Because if you need this,
   * presumably you yourself need to create the widget in all the windows
   * and need to loop through them anyway.
   */
  ensureWidgetPlacedInWindow: function(aWidgetId, aWindow) {
    return CustomizableUIInternal.ensureWidgetPlacedInWindow(aWidgetId, aWindow);
  },
  /**
   * Start a batch update of items.
   * During a batch update, the customization state is not saved to the user's
   * preferences file, in order to reduce (possibly sync) IO.
   * Calls to begin/endBatchUpdate may be nested.
   *
   * Callers should ensure that NO MATTER WHAT they call endBatchUpdate once
   * for each call to beginBatchUpdate, even if there are exceptions in the
   * code in the batch update. Otherwise, for the duration of the
   * Firefox session, customization state is never saved. Typically, you
   * would do this using a try...finally block.
   */
  beginBatchUpdate: function() {
    CustomizableUIInternal.beginBatchUpdate();
  },
  /**
   * End a batch update. See the documentation for beginBatchUpdate above.
   *
   * State is not saved if we believe it is identical to the last known
   * saved state. State is only ever saved when all batch updates have
   * finished (ie there has been 1 endBatchUpdate call for each
   * beginBatchUpdate call). If any of the endBatchUpdate calls pass
   * aForceDirty=true, we will flush to the prefs file.
   *
   * @param aForceDirty force CustomizableUI to flush to the prefs file when
   *                    all batch updates have finished.
   */
  endBatchUpdate: function(aForceDirty) {
    CustomizableUIInternal.endBatchUpdate(aForceDirty);
  },
  /**
   * Create a widget.
   *
   * To create a widget, you should pass an object with its desired
   * properties. The following properties are supported:
   *
   * - id:            the ID of the widget (required).
   * - type:          a string indicating the type of widget. Possible types
   *                  are:
   *                  'button' - for simple button widgets (the default)
   *                  'view'   - for buttons that open a panel or subview,
   *                             depending on where they are placed.
   *                  'custom' - for fine-grained control over the creation
   *                             of the widget.
   * - viewId:        Only useful for views (and required there): the id of the
   *                  <panelview> that should be shown when clicking the widget.
   * - onBuild(aDoc): Only useful for custom widgets (and required there); a
   *                  function that will be invoked with the document in which
   *                  to build a widget. Should return the DOM node that has
   *                  been constructed.
   * - onBeforeCreated(aDoc): Attached to all non-custom widgets; a function
   *                  that will be invoked before the widget gets a DOM node
   *                  constructed, passing the document in which that will happen.
   *                  This is useful especially for 'view' type widgets that need
   *                  to construct their views on the fly (e.g. from bootstrapped
   *                  add-ons)
   * - onCreated(aNode): Attached to all widgets; a function that will be invoked
   *                  whenever the widget has a DOM node constructed, passing the
   *                  constructed node as an argument.
   * - onDestroyed(aDoc): Attached to all non-custom widgets; a function that
   *                  will be invoked after the widget has a DOM node destroyed,
   *                  passing the document from which it was removed. This is
   *                  useful especially for 'view' type widgets that need to
   *                  cleanup after views that were constructed on the fly.
   * - onCommand(aEvt): Only useful for button widgets; a function that will be
   *                    invoked when the user activates the button.
   * - onClick(aEvt): Attached to all widgets; a function that will be invoked
   *                  when the user clicks the widget.
   * - onViewShowing(aEvt): Only useful for views; a function that will be
   *                  invoked when a user shows your view. If any event
   *                  handler calls aEvt.preventDefault(), the view will
   *                  not be shown.
   *
   *                  The event's `detail` property is an object with an
   *                  `addBlocker` method. Handlers which need to
   *                  perform asynchronous operations before the view is
   *                  shown may pass this method a Promise, which will
   *                  prevent the view from showing until it resolves.
   *                  Additionally, if the promise resolves to the exact
   *                  value `false`, the view will not be shown.
   * - onViewHiding(aEvt): Only useful for views; a function that will be
   *                  invoked when a user hides your view.
   * - tooltiptext:   string to use for the tooltip of the widget
   * - label:         string to use for the label of the widget
   * - removable:     whether the widget is removable (optional, default: true)
   *                  NB: if you specify false here, you must provide a
   *                  defaultArea, too.
   * - overflows:     whether widget can overflow when in an overflowable
   *                  toolbar (optional, default: true)
   * - defaultArea:   default area to add the widget to
   *                  (optional, default: none; required if non-removable)
   * - shortcutId:    id of an element that has a shortcut for this widget
   *                  (optional, default: null). This is only used to display
   *                  the shortcut as part of the tooltip for builtin widgets
   *                  (which have strings inside
   *                  customizableWidgets.properties). If you're in an add-on,
   *                  you should not set this property.
   * - showInPrivateBrowsing: whether to show the widget in private browsing
   *                          mode (optional, default: true)
   *
   * @param aProperties the specifications for the widget.
   * @return a wrapper around the created widget (see getWidget)
   */
  createWidget: function(aProperties) {
    return CustomizableUIInternal.wrapWidget(
      CustomizableUIInternal.createWidget(aProperties)
    );
  },
  /**
   * Destroy a widget
   *
   * If the widget is part of the default placements in an area, this will
   * remove it from there. It will also remove any DOM instances. However,
   * it will keep the widget in the placements for whatever area it was
   * in at the time. You can remove it from there yourself by calling
   * CustomizableUI.removeWidgetFromArea(aWidgetId).
   *
   * @param aWidgetId the ID of the widget to destroy
   */
  destroyWidget: function(aWidgetId) {
    CustomizableUIInternal.destroyWidget(aWidgetId);
  },
  /**
   * Get a wrapper object with information about the widget.
   * The object provides the following properties
   * (all read-only unless otherwise indicated):
   *
   * - id:            the widget's ID;
   * - type:          the type of widget (button, view, custom). For
   *                  XUL-provided widgets, this is always 'custom';
   * - provider:      the provider type of the widget, id est one of
   *                  PROVIDER_API or PROVIDER_XUL;
   * - forWindow(w):  a method to obtain a single window wrapper for a widget,
   *                  in the window w passed as the only argument;
   * - instances:     an array of all instances (single window wrappers)
   *                  of the widget. This array is NOT live;
   * - areaType:      the type of the widget's current area
   * - isGroup:       true; will be false for wrappers around single widget nodes;
   * - source:        for API-provided widgets, whether they are built-in to
   *                  Firefox or add-on-provided;
   * - disabled:      for API-provided widgets, whether the widget is currently
   *                  disabled. NB: this property is writable, and will toggle
   *                  all the widgets' nodes' disabled states;
   * - label:         for API-provied widgets, the label of the widget;
   * - tooltiptext:   for API-provided widgets, the tooltip of the widget;
   * - showInPrivateBrowsing: for API-provided widgets, whether the widget is
   *                          visible in private browsing;
   *
   * Single window wrappers obtained through forWindow(someWindow) or from the
   * instances array have the following properties
   * (all read-only unless otherwise indicated):
   *
   * - id:            the widget's ID;
   * - type:          the type of widget (button, view, custom). For
   *                  XUL-provided widgets, this is always 'custom';
   * - provider:      the provider type of the widget, id est one of
   *                  PROVIDER_API or PROVIDER_XUL;
   * - node:          reference to the corresponding DOM node;
   * - anchor:        the anchor on which to anchor panels opened from this
   *                  node. This will point to the overflow chevron on
   *                  overflowable toolbars if and only if your widget node
   *                  is overflowed, to the anchor for the panel menu
   *                  if your widget is inside the panel menu, and to the
   *                  node itself in all other cases;
   * - overflowed:    boolean indicating whether the node is currently in the
   *                  overflow panel of the toolbar;
   * - isGroup:       false; will be true for the group widget;
   * - label:         for API-provided widgets, convenience getter for the
   *                  label attribute of the DOM node;
   * - tooltiptext:   for API-provided widgets, convenience getter for the
   *                  tooltiptext attribute of the DOM node;
   * - disabled:      for API-provided widgets, convenience getter *and setter*
   *                  for the disabled state of this single widget. Note that
   *                  you may prefer to use the group wrapper's getter/setter
   *                  instead.
   *
   * @param aWidgetId the ID of the widget whose information you need
   * @return a wrapper around the widget as described above, or null if the
   *         widget is known not to exist (anymore). NB: non-null return
   *         is no guarantee the widget exists because we cannot know in
   *         advance if a XUL widget exists or not.
   */
  getWidget: function(aWidgetId) {
    return CustomizableUIInternal.wrapWidget(aWidgetId);
  },
  /**
   * Get an array of widget wrappers (see getWidget) for all the widgets
   * which are currently not in any area (so which are in the palette).
   *
   * @param aWindowPalette the palette (and by extension, the window) in which
   *                       CustomizableUI should look. This matters because of
   *                       course XUL-provided widgets could be available in
   *                       some windows but not others, and likewise
   *                       API-provided widgets might not exist in a private
   *                       window (because of the showInPrivateBrowsing
   *                       property).
   *
   * @return an array of widget wrappers (see getWidget)
   */
  getUnusedWidgets: function(aWindowPalette) {
    return CustomizableUIInternal.getUnusedWidgets(aWindowPalette).map(
      CustomizableUIInternal.wrapWidget,
      CustomizableUIInternal
    );
  },
  /**
   * Get an array of all the widget IDs placed in an area. This is roughly
   * equivalent to fetching the currentset attribute and splitting by commas
   * in the legacy APIs. Modifying the array will not affect CustomizableUI.
   *
   * @param aArea the ID of the area whose placements you want to obtain.
   * @return an array containing the widget IDs that are in the area.
   *
   * NB: will throw if called too early (before placements have been fetched)
   *     or if the area is not currently known to CustomizableUI.
   */
  getWidgetIdsInArea: function(aArea) {
    if (!gAreas.has(aArea)) {
      throw new Error("Unknown customization area: " + aArea);
    }
    if (!gPlacements.has(aArea)) {
      throw new Error("Area not yet restored");
    }

    // We need to clone this, as we don't want to let consumers muck with placements
    return [...gPlacements.get(aArea)];
  },
  /**
   * Get an array of widget wrappers for all the widgets in an area. This is
   * the same as calling getWidgetIdsInArea and .map() ing the result through
   * CustomizableUI.getWidget. Careful: this means that if there are IDs in there
   * which don't have corresponding DOM nodes (like in the old-style currentset
   * attribute), there might be nulls in this array, or items for which
   * wrapper.forWindow(win) will return null.
   *
   * @param aArea the ID of the area whose widgets you want to obtain.
   * @return an array of widget wrappers and/or null values for the widget IDs
   *         placed in an area.
   *
   * NB: will throw if called too early (before placements have been fetched)
   *     or if the area is not currently known to CustomizableUI.
   */
  getWidgetsInArea: function(aArea) {
    return this.getWidgetIdsInArea(aArea).map(
      CustomizableUIInternal.wrapWidget,
      CustomizableUIInternal
    );
  },
  /**
   * Obtain an array of all the area IDs known to CustomizableUI.
   * This array is created for you, so is modifiable without CustomizableUI
   * being affected.
   */
  get areas() {
    return [...gAreas.keys()];
  },
  /**
   * Check what kind of area (toolbar or menu panel) an area is. This is
   * useful if you have a widget that needs to behave differently depending
   * on its location. Note that widget wrappers have a convenience getter
   * property (areaType) for this purpose.
   *
   * @param aArea the ID of the area whose type you want to know
   * @return TYPE_TOOLBAR or TYPE_MENU_PANEL depending on the area, null if
   *         the area is unknown.
   */
  getAreaType: function(aArea) {
    let area = gAreas.get(aArea);
    return area ? area.get("type") : null;
  },
  /**
   * Check if a toolbar is collapsed by default.
   *
   * @param aArea the ID of the area whose default-collapsed state you want to know.
   * @return `true` or `false` depending on the area, null if the area is unknown,
   *         or its collapsed state cannot normally be controlled by the user
   */
  isToolbarDefaultCollapsed: function(aArea) {
    let area = gAreas.get(aArea);
    return area ? area.get("defaultCollapsed") : null;
  },
  /**
   * Obtain the DOM node that is the customize target for an area in a
   * specific window.
   *
   * Areas can have a customization target that does not correspond to the
   * node itself. In particular, toolbars that have a customizationtarget
   * attribute set will have their customization target set to that node.
   * This means widgets will end up in the customization target, not in the
   * DOM node with the ID that corresponds to the area ID. This is useful
   * because it lets you have fixed content in a toolbar (e.g. the panel
   * menu item in the navbar) and have all the customizable widgets use
   * the customization target.
   *
   * Using this API yourself is discouraged; you should generally not need
   * to be asking for the DOM container node used for a particular area.
   * In particular, if you're wanting to check it in relation to a widget's
   * node, your DOM node might not be a direct child of the customize target
   * in a window if, for instance, the window is in customization mode, or if
   * this is an overflowable toolbar and the widget has been overflowed.
   *
   * @param aArea   the ID of the area whose customize target you want to have
   * @param aWindow the window where you want to fetch the DOM node.
   * @return the customize target DOM node for aArea in aWindow
   */
  getCustomizeTargetForArea: function(aArea, aWindow) {
    return CustomizableUIInternal.getCustomizeTargetForArea(aArea, aWindow);
  },
  /**
   * Reset the customization state back to its default.
   *
   * This is the nuclear option. You should never call this except if the user
   * explicitly requests it. Firefox does this when the user clicks the
   * "Restore Defaults" button in customize mode.
   */
  reset: function() {
    CustomizableUIInternal.reset();
  },

  /**
   * Undo the previous reset, can only be called immediately after a reset.
   * @return a promise that will be resolved when the operation is complete.
   */
  undoReset: function() {
    CustomizableUIInternal.undoReset();
  },

  /**
   * Remove a custom toolbar added in a previous version of Firefox or using
   * an add-on. NB: only works on the customizable toolbars generated by
   * the toolbox itself. Intended for use from CustomizeMode, not by
   * other consumers.
   * @param aToolbarId the ID of the toolbar to remove
   */
  removeExtraToolbar: function(aToolbarId) {
    CustomizableUIInternal.removeExtraToolbar(aToolbarId);
  },

  /**
   * Can the last Restore Defaults operation be undone.
   *
   * @return A boolean stating whether an undo of the
   *         Restore Defaults can be performed.
   */
  get canUndoReset() {
    return gUIStateBeforeReset.uiCustomizationState != null ||
           gUIStateBeforeReset.drawInTitlebar != null ||
           gUIStateBeforeReset.currentTheme != null;
  },

  /**
   * Get the placement of a widget. This is by far the best way to obtain
   * information about what the state of your widget is. The internals of
   * this call are cheap (no DOM necessary) and you will know where the user
   * has put your widget.
   *
   * @param aWidgetId the ID of the widget whose placement you want to know
   * @return
   *   {
   *     area: "somearea", // The ID of the area where the widget is placed
   *     position: 42 // the index in the placements array corresponding to
   *                  // your widget.
   *   }
   *
   *   OR
   *
   *   null // if the widget is not placed anywhere (ie in the palette)
   */
  getPlacementOfWidget: function(aWidgetId, aOnlyRegistered=true, aDeadAreas=false) {
    return CustomizableUIInternal.getPlacementOfWidget(aWidgetId, aOnlyRegistered, aDeadAreas);
  },
  /**
   * Check if a widget can be removed from the area it's in.
   *
   * Note that if you're wanting to move the widget somewhere, you should
   * generally be checking canWidgetMoveToArea, because that will return
   * true if the widget is already in the area where you want to move it (!).
   *
   * NB: oh, also, this method might lie if the widget in question is a
   *     XUL-provided widget and there are no windows open, because it
   *     can obviously not check anything in this case. It will return
   *     true. You will be able to move the widget elsewhere. However,
   *     once the user reopens a window, the widget will move back to its
   *     'proper' area automagically.
   *
   * @param aWidgetId a widget ID or DOM node to check
   * @return true if the widget can be removed from its area,
   *          false otherwise.
   */
  isWidgetRemovable: function(aWidgetId) {
    return CustomizableUIInternal.isWidgetRemovable(aWidgetId);
  },
  /**
   * Check if a widget can be moved to a particular area. Like
   * isWidgetRemovable but better, because it'll return true if the widget
   * is already in the right area.
   *
   * @param aWidgetId the widget ID or DOM node you want to move somewhere
   * @param aArea     the area ID you want to move it to.
   * @return true if this is possible, false if it is not. The same caveats as
   *              for isWidgetRemovable apply, however, if no windows are open.
   */
  canWidgetMoveToArea: function(aWidgetId, aArea) {
    return CustomizableUIInternal.canWidgetMoveToArea(aWidgetId, aArea);
  },
  /**
   * Whether we're in a default state. Note that non-removable non-default
   * widgets and non-existing widgets are not taken into account in determining
   * whether we're in the default state.
   *
   * NB: this is a property with a getter. The getter is NOT cheap, because
   * it does smart things with non-removable non-default items, non-existent
   * items, and so forth. Please don't call unless necessary.
   */
  get inDefaultState() {
    return CustomizableUIInternal.inDefaultState;
  },

  /**
   * Set a toolbar's visibility state in all windows.
   * @param aToolbarId    the toolbar whose visibility should be adjusted
   * @param aIsVisible    whether the toolbar should be visible
   */
  setToolbarVisibility: function(aToolbarId, aIsVisible) {
    CustomizableUIInternal.setToolbarVisibility(aToolbarId, aIsVisible);
  },

  /**
   * Get a localized property off a (widget?) object.
   *
   * NB: this is unlikely to be useful unless you're in Firefox code, because
   *     this code uses the builtin widget stringbundle, and can't be told
   *     to use add-on-provided strings. It's mainly here as convenience for
   *     custom builtin widgets that build their own DOM but use the same
   *     stringbundle as the other builtin widgets.
   *
   * @param aWidget     the object whose property we should use to fetch a
   *                    localizable string;
   * @param aProp       the property on the object to use for the fetching;
   * @param aFormatArgs (optional) any extra arguments to use for a formatted
   *                    string;
   * @param aDef        (optional) the default to return if we don't find the
   *                    string in the stringbundle;
   *
   * @return the localized string, or aDef if the string isn't in the bundle.
   *         If no default is provided,
   *           if aProp exists on aWidget, we'll return that,
   *           otherwise we'll return the empty string
   *
   */
  getLocalizedProperty: function(aWidget, aProp, aFormatArgs, aDef) {
    return CustomizableUIInternal.getLocalizedProperty(aWidget, aProp,
      aFormatArgs, aDef);
  },
  /**
   * Utility function to detect, find and set a keyboard shortcut for a menuitem
   * or (toolbar)button.
   *
   * @param aShortcutNode the XUL node where the shortcut will be derived from;
   * @param aTargetNode   (optional) the XUL node on which the `shortcut`
   *                      attribute will be set. If NULL, the shortcut will be
   *                      set on aShortcutNode;
   */
  addShortcut: function(aShortcutNode, aTargetNode) {
    return CustomizableUIInternal.addShortcut(aShortcutNode, aTargetNode);
  },
  /**
   * Given a node, walk up to the first panel in its ancestor chain, and
   * close it.
   *
   * @param aNode a node whose panel should be closed;
   */
  hidePanelForNode: function(aNode) {
    CustomizableUIInternal.hidePanelForNode(aNode);
  },
  /**
   * Check if a widget is a "special" widget: a spring, spacer or separator.
   *
   * @param aWidgetId the widget ID to check.
   * @return true if the widget is 'special', false otherwise.
   */
  isSpecialWidget: function(aWidgetId) {
    return CustomizableUIInternal.isSpecialWidget(aWidgetId);
  },
  /**
   * Add listeners to a panel that will close it. For use from the menu panel
   * and overflowable toolbar implementations, unlikely to be useful for
   * consumers.
   *
   * @param aPanel the panel to which listeners should be attached.
   */
  addPanelCloseListeners: function(aPanel) {
    CustomizableUIInternal.addPanelCloseListeners(aPanel);
  },
  /**
   * Remove close listeners that have been added to a panel with
   * addPanelCloseListeners. For use from the menu panel and overflowable
   * toolbar implementations, unlikely to be useful for consumers.
   *
   * @param aPanel the panel from which listeners should be removed.
   */
  removePanelCloseListeners: function(aPanel) {
    CustomizableUIInternal.removePanelCloseListeners(aPanel);
  },
  /**
   * Notify listeners a widget is about to be dragged to an area. For use from
   * Customize Mode only, do not use otherwise.
   *
   * @param aWidgetId the ID of the widget that is being dragged to an area.
   * @param aArea     the ID of the area to which the widget is being dragged.
   */
  onWidgetDrag: function(aWidgetId, aArea) {
    CustomizableUIInternal.notifyListeners("onWidgetDrag", aWidgetId, aArea);
  },
  /**
   * Notify listeners that a window is entering customize mode. For use from
   * Customize Mode only, do not use otherwise.
   * @param aWindow the window entering customize mode
   */
  notifyStartCustomizing: function(aWindow) {
    CustomizableUIInternal.notifyListeners("onCustomizeStart", aWindow);
  },
  /**
   * Notify listeners that a window is exiting customize mode. For use from
   * Customize Mode only, do not use otherwise.
   * @param aWindow the window exiting customize mode
   */
  notifyEndCustomizing: function(aWindow) {
    CustomizableUIInternal.notifyListeners("onCustomizeEnd", aWindow);
  },

  /**
   * Notify toolbox(es) of a particular event. If you don't pass aWindow,
   * all toolboxes will be notified. For use from Customize Mode only,
   * do not use otherwise.
   * @param aEvent the name of the event to send.
   * @param aDetails optional, the details of the event.
   * @param aWindow optional, the window in which to send the event.
   */
  dispatchToolboxEvent: function(aEvent, aDetails={}, aWindow=null) {
    CustomizableUIInternal.dispatchToolboxEvent(aEvent, aDetails, aWindow);
  },

  /**
   * Check whether an area is overflowable.
   *
   * @param aAreaId the ID of an area to check for overflowable-ness
   * @return true if the area is overflowable, false otherwise.
   */
  isAreaOverflowable: function(aAreaId) {
    let area = gAreas.get(aAreaId);
    return area ? area.get("type") == this.TYPE_TOOLBAR && area.get("overflowable")
                : false;
  },
  /**
   * Obtain a string indicating the place of an element. This is intended
   * for use from customize mode; You should generally use getPlacementOfWidget
   * instead, which is cheaper because it does not use the DOM.
   *
   * @param aElement the DOM node whose place we need to check
   * @return "toolbar" if the node is in a toolbar, "panel" if it is in the
   *         menu panel, "palette" if it is in the (visible!) customization
   *         palette, undefined otherwise.
   */
  getPlaceForItem: function(aElement) {
    let place;
    let node = aElement;
    while (node && !place) {
      if (node.localName == "toolbar")
        place = "toolbar";
      else if (node.id == CustomizableUI.AREA_PANEL)
        place = "panel";
      else if (node.id == "customization-palette")
        place = "palette";

      node = node.parentNode;
    }
    return place;
  },

  /**
   * Check if a toolbar is builtin or not.
   * @param aToolbarId the ID of the toolbar you want to check
   */
  isBuiltinToolbar: function(aToolbarId) {
    return CustomizableUIInternal._builtinToolbars.has(aToolbarId);
  },
};
Object.freeze(this.CustomizableUI);
Object.freeze(this.CustomizableUI.windows);

/**
 * All external consumers of widgets are really interacting with these wrappers
 * which provide a common interface.
 */

/**
 * WidgetGroupWrapper is the common interface for interacting with an entire
 * widget group - AKA, all instances of a widget across a series of windows.
 * This particular wrapper is only used for widgets created via the provider
 * API.
 */
function WidgetGroupWrapper(aWidget) {
  this.isGroup = true;

  const kBareProps = ["id", "source", "type", "disabled", "label", "tooltiptext",
                      "showInPrivateBrowsing", "viewId"];
  for (let prop of kBareProps) {
    let propertyName = prop;
    this.__defineGetter__(propertyName, () => aWidget[propertyName]);
  }

  this.__defineGetter__("provider", () => CustomizableUI.PROVIDER_API);

  this.__defineSetter__("disabled", function(aValue) {
    aValue = !!aValue;
    aWidget.disabled = aValue;
    for (let [, instance] of aWidget.instances) {
      instance.disabled = aValue;
    }
  });

  this.forWindow = function WidgetGroupWrapper_forWindow(aWindow) {
    let wrapperMap;
    if (!gSingleWrapperCache.has(aWindow)) {
      wrapperMap = new Map();
      gSingleWrapperCache.set(aWindow, wrapperMap);
    } else {
      wrapperMap = gSingleWrapperCache.get(aWindow);
    }
    if (wrapperMap.has(aWidget.id)) {
      return wrapperMap.get(aWidget.id);
    }

    let instance = aWidget.instances.get(aWindow.document);
    if (!instance &&
        (aWidget.showInPrivateBrowsing || !PrivateBrowsingUtils.isWindowPrivate(aWindow))) {
      instance = CustomizableUIInternal.buildWidget(aWindow.document,
                                                    aWidget);
    }

    let wrapper = new WidgetSingleWrapper(aWidget, instance);
    wrapperMap.set(aWidget.id, wrapper);
    return wrapper;
  };

  this.__defineGetter__("instances", function() {
    // Can't use gBuildWindows here because some areas load lazily:
    let placement = CustomizableUIInternal.getPlacementOfWidget(aWidget.id);
    if (!placement) {
      return [];
    }
    let area = placement.area;
    let buildAreas = gBuildAreas.get(area);
    if (!buildAreas) {
      return [];
    }
    return Array.from(buildAreas, (node) => this.forWindow(node.ownerGlobal));
  });

  this.__defineGetter__("areaType", function() {
    let areaProps = gAreas.get(aWidget.currentArea);
    return areaProps && areaProps.get("type");
  });

  Object.freeze(this);
}

/**
 * A WidgetSingleWrapper is a wrapper around a single instance of a widget in
 * a particular window.
 */
function WidgetSingleWrapper(aWidget, aNode) {
  this.isGroup = false;

  this.node = aNode;
  this.provider = CustomizableUI.PROVIDER_API;

  const kGlobalProps = ["id", "type"];
  for (let prop of kGlobalProps) {
    this[prop] = aWidget[prop];
  }

  const kNodeProps = ["label", "tooltiptext"];
  for (let prop of kNodeProps) {
    let propertyName = prop;
    // Look at the node for these, instead of the widget data, to ensure the
    // wrapper always reflects this live instance.
    this.__defineGetter__(propertyName,
                          () => aNode.getAttribute(propertyName));
  }

  this.__defineGetter__("disabled", () => aNode.disabled);
  this.__defineSetter__("disabled", function(aValue) {
    aNode.disabled = !!aValue;
  });

  this.__defineGetter__("anchor", function() {
    let anchorId;
    // First check for an anchor for the area:
    let placement = CustomizableUIInternal.getPlacementOfWidget(aWidget.id);
    if (placement) {
      anchorId = gAreas.get(placement.area).get("anchor");
    }
    if (!anchorId) {
      anchorId = aNode.getAttribute("cui-anchorid");
    }

    return anchorId ? aNode.ownerDocument.getElementById(anchorId)
                    : aNode;
  });

  this.__defineGetter__("overflowed", function() {
    return aNode.getAttribute("overflowedItem") == "true";
  });

  Object.freeze(this);
}

/**
 * XULWidgetGroupWrapper is the common interface for interacting with an entire
 * widget group - AKA, all instances of a widget across a series of windows.
 * This particular wrapper is only used for widgets created via the old-school
 * XUL method (overlays, or programmatically injecting toolbaritems, or other
 * such things).
 */
// XXXunf Going to need to hook this up to some events to keep it all live.
function XULWidgetGroupWrapper(aWidgetId) {
  this.isGroup = true;
  this.id = aWidgetId;
  this.type = "custom";
  this.provider = CustomizableUI.PROVIDER_XUL;

  this.forWindow = function XULWidgetGroupWrapper_forWindow(aWindow) {
    let wrapperMap;
    if (!gSingleWrapperCache.has(aWindow)) {
      wrapperMap = new Map();
      gSingleWrapperCache.set(aWindow, wrapperMap);
    } else {
      wrapperMap = gSingleWrapperCache.get(aWindow);
    }
    if (wrapperMap.has(aWidgetId)) {
      return wrapperMap.get(aWidgetId);
    }

    let instance = aWindow.document.getElementById(aWidgetId);
    if (!instance) {
      // Toolbar palettes aren't part of the document, so elements in there
      // won't be found via document.getElementById().
      instance = aWindow.gNavToolbox.palette.getElementsByAttribute("id", aWidgetId)[0];
    }

    let wrapper = new XULWidgetSingleWrapper(aWidgetId, instance, aWindow.document);
    wrapperMap.set(aWidgetId, wrapper);
    return wrapper;
  };

  this.__defineGetter__("areaType", function() {
    let placement = CustomizableUIInternal.getPlacementOfWidget(aWidgetId);
    if (!placement) {
      return null;
    }

    let areaProps = gAreas.get(placement.area);
    return areaProps && areaProps.get("type");
  });

  this.__defineGetter__("instances", function() {
    return Array.from(gBuildWindows, (wins) => this.forWindow(wins[0]));
  });

  Object.freeze(this);
}

/**
 * A XULWidgetSingleWrapper is a wrapper around a single instance of a XUL
 * widget in a particular window.
 */
function XULWidgetSingleWrapper(aWidgetId, aNode, aDocument) {
  this.isGroup = false;

  this.id = aWidgetId;
  this.type = "custom";
  this.provider = CustomizableUI.PROVIDER_XUL;

  let weakDoc = Cu.getWeakReference(aDocument);
  // If we keep a strong ref, the weak ref will never die, so null it out:
  aDocument = null;

  this.__defineGetter__("node", function() {
    // If we've set this to null (further down), we're sure there's nothing to
    // be gotten here, so bail out early:
    if (!weakDoc) {
      return null;
    }
    if (aNode) {
      // Return the last known node if it's still in the DOM...
      if (aNode.ownerDocument.contains(aNode)) {
        return aNode;
      }
      // ... or the toolbox
      let toolbox = aNode.ownerGlobal.gNavToolbox;
      if (toolbox && toolbox.palette && aNode.parentNode == toolbox.palette) {
        return aNode;
      }
      // If it isn't, clear the cached value and fall through to the "slow" case:
      aNode = null;
    }

    let doc = weakDoc.get();
    if (doc) {
      // Store locally so we can cache the result:
      aNode = CustomizableUIInternal.findWidgetInWindow(aWidgetId, doc.defaultView);
      return aNode;
    }
    // The weakref to the document is dead, we're done here forever more:
    weakDoc = null;
    return null;
  });

  this.__defineGetter__("anchor", function() {
    let anchorId;
    // First check for an anchor for the area:
    let placement = CustomizableUIInternal.getPlacementOfWidget(aWidgetId);
    if (placement) {
      anchorId = gAreas.get(placement.area).get("anchor");
    }

    let node = this.node;
    if (!anchorId && node) {
      anchorId = node.getAttribute("cui-anchorid");
    }

    return (anchorId && node) ? node.ownerDocument.getElementById(anchorId) : node;
  });

  this.__defineGetter__("overflowed", function() {
    let node = this.node;
    if (!node) {
      return false;
    }
    return node.getAttribute("overflowedItem") == "true";
  });

  Object.freeze(this);
}

const LAZY_RESIZE_INTERVAL_MS = 200;
const OVERFLOW_PANEL_HIDE_DELAY_MS = 500;

function OverflowableToolbar(aToolbarNode) {
  this._toolbar = aToolbarNode;
  this._collapsed = new Map();
  this._enabled = true;

  this._toolbar.setAttribute("overflowable", "true");
  let doc = this._toolbar.ownerDocument;
  this._target = this._toolbar.customizationTarget;
  this._list = doc.getElementById(this._toolbar.getAttribute("overflowtarget"));
  this._list.toolbox = this._toolbar.toolbox;
  this._list.customizationTarget = this._list;

  let window = this._toolbar.ownerGlobal;
  if (window.gBrowserInit.delayedStartupFinished) {
    this.init();
  } else {
    Services.obs.addObserver(this, "browser-delayed-startup-finished", false);
  }
}

OverflowableToolbar.prototype = {
  initialized: false,
  _forceOnOverflow: false,

  observe: function(aSubject, aTopic, aData) {
    if (aTopic == "browser-delayed-startup-finished" &&
        aSubject == this._toolbar.ownerGlobal) {
      Services.obs.removeObserver(this, "browser-delayed-startup-finished");
      this.init();
    }
  },

  init: function() {
    let doc = this._toolbar.ownerDocument;
    let window = doc.defaultView;
    window.addEventListener("resize", this);
    window.gNavToolbox.addEventListener("customizationstarting", this);
    window.gNavToolbox.addEventListener("aftercustomization", this);

    let chevronId = this._toolbar.getAttribute("overflowbutton");
    this._chevron = doc.getElementById(chevronId);
    this._chevron.addEventListener("command", this);
    this._chevron.addEventListener("dragover", this);
    this._chevron.addEventListener("dragend", this);

    let panelId = this._toolbar.getAttribute("overflowpanel");
    this._panel = doc.getElementById(panelId);
    this._panel.addEventListener("popuphiding", this);
    CustomizableUIInternal.addPanelCloseListeners(this._panel);

    CustomizableUI.addListener(this);

    // The 'overflow' event may have been fired before init was called.
    if (this._toolbar.overflowedDuringConstruction) {
      this.onOverflow(this._toolbar.overflowedDuringConstruction);
      this._toolbar.overflowedDuringConstruction = null;
    }

    this.initialized = true;
  },

  uninit: function() {
    this._toolbar.removeEventListener("overflow", this._toolbar);
    this._toolbar.removeEventListener("underflow", this._toolbar);
    this._toolbar.removeAttribute("overflowable");

    if (!this.initialized) {
      Services.obs.removeObserver(this, "browser-delayed-startup-finished");
      return;
    }

    this._disable();

    let window = this._toolbar.ownerGlobal;
    window.removeEventListener("resize", this);
    window.gNavToolbox.removeEventListener("customizationstarting", this);
    window.gNavToolbox.removeEventListener("aftercustomization", this);
    this._chevron.removeEventListener("command", this);
    this._chevron.removeEventListener("dragover", this);
    this._chevron.removeEventListener("dragend", this);
    this._panel.removeEventListener("popuphiding", this);
    CustomizableUI.removeListener(this);
    CustomizableUIInternal.removePanelCloseListeners(this._panel);
  },

  handleEvent: function(aEvent) {
    switch (aEvent.type) {
      case "aftercustomization":
        this._enable();
        break;
      case "command":
        if (aEvent.target == this._chevron) {
          this._onClickChevron(aEvent);
        } else {
          this._panel.hidePopup();
        }
        break;
      case "customizationstarting":
        this._disable();
        break;
      case "dragover":
        this._showWithTimeout();
        break;
      case "dragend":
        this._panel.hidePopup();
        break;
      case "popuphiding":
        this._onPanelHiding(aEvent);
        break;
      case "resize":
        this._onResize(aEvent);
    }
  },

  show: function() {
    if (this._panel.state == "open") {
      return Promise.resolve();
    }
    return new Promise(resolve => {
      let doc = this._panel.ownerDocument;
      this._panel.hidden = false;
      let contextMenu = doc.getElementById(this._panel.getAttribute("context"));
      gELS.addSystemEventListener(contextMenu, 'command', this, true);
      let anchor = doc.getAnonymousElementByAttribute(this._chevron, "class", "toolbarbutton-icon");
      this._panel.openPopup(anchor || this._chevron);
      this._chevron.open = true;

      let overflowableToolbarInstance = this;
      this._panel.addEventListener("popupshown", function onPopupShown(aEvent) {
        this.removeEventListener("popupshown", onPopupShown);
        this.addEventListener("dragover", overflowableToolbarInstance);
        this.addEventListener("dragend", overflowableToolbarInstance);
        resolve();
      });
    });
  },

  _onClickChevron: function(aEvent) {
    if (this._chevron.open) {
      this._panel.hidePopup();
      this._chevron.open = false;
    } else {
      this.show();
    }
  },

  _onPanelHiding: function(aEvent) {
    this._chevron.open = false;
    this._panel.removeEventListener("dragover", this);
    this._panel.removeEventListener("dragend", this);
    let doc = aEvent.target.ownerDocument;
    let contextMenu = doc.getElementById(this._panel.getAttribute("context"));
    gELS.removeSystemEventListener(contextMenu, 'command', this, true);
  },

  onOverflow: function(aEvent) {
    // The rangeParent check is here because of bug 1111986 and ensuring that
    // overflow events from the bookmarks toolbar items or similar things that
    // manage their own overflow don't trigger an overflow on the entire toolbar
    if (!this._enabled ||
        (aEvent && aEvent.target != this._toolbar.customizationTarget) ||
        (aEvent && aEvent.rangeParent))
      return;

    let child = this._target.lastChild;

    while (child && this._target.scrollLeftMin != this._target.scrollLeftMax) {
      let prevChild = child.previousSibling;

      if (child.getAttribute("overflows") != "false") {
        this._collapsed.set(child.id, this._target.clientWidth);
        child.setAttribute("overflowedItem", true);
        child.setAttribute("cui-anchorid", this._chevron.id);
        CustomizableUIInternal.notifyListeners("onWidgetOverflow", child, this._target);

        this._list.insertBefore(child, this._list.firstChild);
        if (!this._toolbar.hasAttribute("overflowing")) {
          CustomizableUI.addListener(this);
        }
        this._toolbar.setAttribute("overflowing", "true");
      }
      child = prevChild;
    }

    let win = this._target.ownerGlobal;
    win.UpdateUrlbarSearchSplitterState();
  },

  _onResize: function(aEvent) {
    if (!this._lazyResizeHandler) {
      this._lazyResizeHandler = new DeferredTask(this._onLazyResize.bind(this),
                                                 LAZY_RESIZE_INTERVAL_MS);
    }
    this._lazyResizeHandler.arm();
  },

  _moveItemsBackToTheirOrigin: function(shouldMoveAllItems) {
    let placements = gPlacements.get(this._toolbar.id);
    while (this._list.firstChild) {
      let child = this._list.firstChild;
      let minSize = this._collapsed.get(child.id);

      if (!shouldMoveAllItems &&
          minSize &&
          this._target.clientWidth <= minSize) {
        return;
      }

      this._collapsed.delete(child.id);
      let beforeNodeIndex = placements.indexOf(child.id) + 1;
      // If this is a skipintoolbarset item, meaning it doesn't occur in the placements list,
      // we're inserting it at the end. This will mean first-in, first-out (more or less)
      // leading to as little change in order as possible.
      if (beforeNodeIndex == 0) {
        beforeNodeIndex = placements.length;
      }
      let inserted = false;
      for (; beforeNodeIndex < placements.length; beforeNodeIndex++) {
        let beforeNode = this._target.getElementsByAttribute("id", placements[beforeNodeIndex])[0];
        if (beforeNode) {
          this._target.insertBefore(child, beforeNode);
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        this._target.appendChild(child);
      }
      child.removeAttribute("cui-anchorid");
      child.removeAttribute("overflowedItem");
      CustomizableUIInternal.notifyListeners("onWidgetUnderflow", child, this._target);
    }

    let win = this._target.ownerGlobal;
    win.UpdateUrlbarSearchSplitterState();

    if (!this._collapsed.size) {
      this._toolbar.removeAttribute("overflowing");
      CustomizableUI.removeListener(this);
    }
  },

  _onLazyResize: function() {
    if (!this._enabled)
      return;

    if (this._target.scrollLeftMin != this._target.scrollLeftMax) {
      this.onOverflow();
    } else {
      this._moveItemsBackToTheirOrigin();
    }
  },

  _disable: function() {
    this._enabled = false;
    this._moveItemsBackToTheirOrigin(true);
    if (this._lazyResizeHandler) {
      this._lazyResizeHandler.disarm();
    }
  },

  _enable: function() {
    this._enabled = true;
    this.onOverflow();
  },

  onWidgetBeforeDOMChange: function(aNode, aNextNode, aContainer) {
    if (aContainer != this._target && aContainer != this._list) {
      return;
    }
    // When we (re)move an item, update all the items that come after it in the list
    // with the minsize *of the item before the to-be-removed node*. This way, we
    // ensure that we try to move items back as soon as that's possible.
    if (aNode.parentNode == this._list) {
      let updatedMinSize;
      if (aNode.previousSibling) {
        updatedMinSize = this._collapsed.get(aNode.previousSibling.id);
      } else {
        // Force (these) items to try to flow back into the bar:
        updatedMinSize = 1;
      }
      let nextItem = aNode.nextSibling;
      while (nextItem) {
        this._collapsed.set(nextItem.id, updatedMinSize);
        nextItem = nextItem.nextSibling;
      }
    }
  },

  onWidgetAfterDOMChange: function(aNode, aNextNode, aContainer) {
    if (aContainer != this._target && aContainer != this._list) {
      return;
    }

    let nowInBar = aNode.parentNode == aContainer;
    let nowOverflowed = aNode.parentNode == this._list;
    let wasOverflowed = this._collapsed.has(aNode.id);

    // If this wasn't overflowed before...
    if (!wasOverflowed) {
      // ... but it is now, then we added to the overflow panel. Exciting stuff:
      if (nowOverflowed) {
        // NB: we're guaranteed that it has a previousSibling, because if it didn't,
        // we would have added it to the toolbar instead. See getOverflowedNextNode.
        let prevId = aNode.previousSibling.id;
        let minSize = this._collapsed.get(prevId);
        this._collapsed.set(aNode.id, minSize);
        aNode.setAttribute("cui-anchorid", this._chevron.id);
        aNode.setAttribute("overflowedItem", true);
        CustomizableUIInternal.notifyListeners("onWidgetOverflow", aNode, this._target);
      }
      // If it is not overflowed and not in the toolbar, and was not overflowed
      // either, it moved out of the toolbar. That means there's now space in there!
      // Let's try to move stuff back:
      else if (!nowInBar) {
        this._moveItemsBackToTheirOrigin(true);
      }
      // If it's in the toolbar now, then we don't care. An overflow event may
      // fire afterwards; that's ok!
    }
    // If it used to be overflowed...
    else if (!nowOverflowed) {
      // ... and isn't anymore, let's remove our bookkeeping:
      this._collapsed.delete(aNode.id);
      aNode.removeAttribute("cui-anchorid");
      aNode.removeAttribute("overflowedItem");
      CustomizableUIInternal.notifyListeners("onWidgetUnderflow", aNode, this._target);

      if (!this._collapsed.size) {
        this._toolbar.removeAttribute("overflowing");
        CustomizableUI.removeListener(this);
      }
    } else if (aNode.previousSibling) {
      // but if it still is, it must have changed places. Bookkeep:
      let prevId = aNode.previousSibling.id;
      let minSize = this._collapsed.get(prevId);
      this._collapsed.set(aNode.id, minSize);
    } else {
      // If it's now the first item in the overflow list,
      // maybe we can return it:
      this._moveItemsBackToTheirOrigin();
    }
  },

  findOverflowedInsertionPoints: function(aNode) {
    let newNodeCanOverflow = aNode.getAttribute("overflows") != "false";
    let areaId = this._toolbar.id;
    let placements = gPlacements.get(areaId);
    let nodeIndex = placements.indexOf(aNode.id);
    let nodeBeforeNewNodeIsOverflown = false;

    let loopIndex = -1;
    while (++loopIndex < placements.length) {
      let nextNodeId = placements[loopIndex];
      if (loopIndex > nodeIndex) {
        if (newNodeCanOverflow && this._collapsed.has(nextNodeId)) {
          let nextNode = this._list.getElementsByAttribute("id", nextNodeId).item(0);
          if (nextNode) {
            return [this._list, nextNode];
          }
        }
        if (!nodeBeforeNewNodeIsOverflown || !newNodeCanOverflow) {
          let nextNode = this._target.getElementsByAttribute("id", nextNodeId).item(0);
          if (nextNode) {
            return [this._target, nextNode];
          }
        }
      } else if (loopIndex < nodeIndex && this._collapsed.has(nextNodeId)) {
        nodeBeforeNewNodeIsOverflown = true;
      }
    }

    let containerForAppending = (this._collapsed.size && newNodeCanOverflow) ?
                                this._list : this._target;
    return [containerForAppending, null];
  },

  getContainerFor: function(aNode) {
    if (aNode.getAttribute("overflowedItem") == "true") {
      return this._list;
    }
    return this._target;
  },

  _hideTimeoutId: null,
  _showWithTimeout: function() {
    this.show().then(function () {
      let window = this._toolbar.ownerGlobal;
      if (this._hideTimeoutId) {
        window.clearTimeout(this._hideTimeoutId);
      }
      this._hideTimeoutId = window.setTimeout(() => {
        if (!this._panel.firstChild.matches(":hover")) {
          this._panel.hidePopup();
        }
      }, OVERFLOW_PANEL_HIDE_DELAY_MS);
    }.bind(this));
  },
};

CustomizableUIInternal.initialize();
