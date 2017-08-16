/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {Cu} = require("chrome");
const Services = require("Services");

const {DevToolsShim} = Cu.import("chrome://devtools-shim/content/DevToolsShim.jsm", {});

// Load gDevToolsBrowser toolbox lazily as they need gDevTools to be fully initialized
loader.lazyRequireGetter(this, "TargetFactory", "devtools/client/framework/target", true);
loader.lazyRequireGetter(this, "Toolbox", "devtools/client/framework/toolbox", true);
loader.lazyRequireGetter(this, "ToolboxHostManager", "devtools/client/framework/toolbox-host-manager", true);
loader.lazyRequireGetter(this, "gDevToolsBrowser", "devtools/client/framework/devtools-browser", true);
loader.lazyImporter(this, "ScratchpadManager", "resource://devtools/client/scratchpad/scratchpad-manager.jsm");

const {defaultTools: DefaultTools, defaultThemes: DefaultThemes} =
  require("devtools/client/definitions");
const EventEmitter = require("devtools/shared/event-emitter");
const {JsonView} = require("devtools/client/jsonview/main");
const AboutDevTools = require("devtools/client/framework/about-devtools-toolbox");
const {Task} = require("devtools/shared/task");
const {getTheme, setTheme, addThemeObserver, removeThemeObserver} =
  require("devtools/client/shared/theme");

const FORBIDDEN_IDS = new Set(["toolbox", ""]);
const MAX_ORDINAL = 99;

/**
 * DevTools is a class that represents a set of developer tools, it holds a
 * set of tools and keeps track of open toolboxes in the browser.
 */
function DevTools() {
  this._tools = new Map();     // Map<toolId, tool>
  this._themes = new Map();    // Map<themeId, theme>
  this._toolboxes = new Map(); // Map<target, toolbox>
  // List of toolboxes that are still in process of creation
  this._creatingToolboxes = new Map(); // Map<target, toolbox Promise>

  // JSON Viewer for 'application/json' documents.
  JsonView.initialize();

  AboutDevTools.register();

  EventEmitter.decorate(this);

  // Listen for changes to the theme pref.
  this._onThemeChanged = this._onThemeChanged.bind(this);
  addThemeObserver(this._onThemeChanged);

  // This is important step in initialization codepath where we are going to
  // start registering all default tools and themes: create menuitems, keys, emit
  // related events.
  this.registerDefaults();

  // Register this new DevTools instance to Firefox. DevToolsShim is part of Firefox,
  // integrating with all Firefox codebase and making the glue between code from
  // mozilla-central and DevTools add-on on github
  DevToolsShim.register(this);
}

DevTools.prototype = {
  // The windowtype of the main window, used in various tools. This may be set
  // to something different by other gecko apps.
  chromeWindowType: "navigator:browser",

  registerDefaults() {
    // Ensure registering items in the sorted order (getDefault* functions
    // return sorted lists)
    this.getDefaultTools().forEach(definition => this.registerTool(definition));
    this.getDefaultThemes().forEach(definition => this.registerTheme(definition));
  },

  unregisterDefaults() {
    for (let definition of this.getToolDefinitionArray()) {
      this.unregisterTool(definition.id);
    }
    for (let definition of this.getThemeDefinitionArray()) {
      this.unregisterTheme(definition.id);
    }
  },

  /**
   * Register a new developer tool.
   *
   * A definition is a light object that holds different information about a
   * developer tool. This object is not supposed to have any operational code.
   * See it as a "manifest".
   * The only actual code lives in the build() function, which will be used to
   * start an instance of this tool.
   *
   * Each toolDefinition has the following properties:
   * - id: Unique identifier for this tool (string|required)
   * - visibilityswitch: Property name to allow us to hide this tool from the
   *                     DevTools Toolbox.
   *                     A falsy value indicates that it cannot be hidden.
   * - icon: URL pointing to a graphic which will be used as the src for an
   *         16x16 img tag (string|required)
   * - invertIconForLightTheme: The icon can automatically have an inversion
   *         filter applied (default is false).  All builtin tools are true, but
   *         addons may omit this to prevent unwanted changes to the `icon`
   *         image. filter: invert(1) is applied to the image (boolean|optional)
   * - url: URL pointing to a XUL/XHTML document containing the user interface
   *        (string|required)
   * - label: Localized name for the tool to be displayed to the user
   *          (string|required)
   * - hideInOptions: Boolean indicating whether or not this tool should be
                      shown in toolbox options or not. Defaults to false.
   *                  (boolean)
   * - build: Function that takes an iframe, which has been populated with the
   *          markup from |url|, and also the toolbox containing the panel.
   *          And returns an instance of ToolPanel (function|required)
   */
  registerTool(toolDefinition) {
    let toolId = toolDefinition.id;

    if (!toolId || FORBIDDEN_IDS.has(toolId)) {
      throw new Error("Invalid definition.id");
    }

    // Make sure that additional tools will always be able to be hidden.
    // When being called from main.js, defaultTools has not yet been exported.
    // But, we can assume that in this case, it is a default tool.
    if (DefaultTools.indexOf(toolDefinition) == -1) {
      toolDefinition.visibilityswitch = "devtools." + toolId + ".enabled";
    }

    this._tools.set(toolId, toolDefinition);

    this.emit("tool-registered", toolId);
  },

  /**
   * Removes all tools that match the given |toolId|
   * Needed so that add-ons can remove themselves when they are deactivated
   *
   * @param {string|object} tool
   *        Definition or the id of the tool to unregister. Passing the
   *        tool id should be avoided as it is a temporary measure.
   * @param {boolean} isQuitApplication
   *        true to indicate that the call is due to app quit, so we should not
   *        cause a cascade of costly events
   */
  unregisterTool(tool, isQuitApplication) {
    let toolId = null;
    if (typeof tool == "string") {
      toolId = tool;
      tool = this._tools.get(tool);
    } else {
      let {Deprecated} = Cu.import("resource://gre/modules/Deprecated.jsm", {});
      Deprecated.warning("Deprecation WARNING: gDevTools.unregisterTool(tool) is " +
        "deprecated. You should unregister a tool using its toolId: " +
        "gDevTools.unregisterTool(toolId).");
      toolId = tool.id;
    }
    this._tools.delete(toolId);

    if (!isQuitApplication) {
      this.emit("tool-unregistered", toolId);
    }
  },

  /**
   * Sorting function used for sorting tools based on their ordinals.
   */
  ordinalSort(d1, d2) {
    let o1 = (typeof d1.ordinal == "number") ? d1.ordinal : MAX_ORDINAL;
    let o2 = (typeof d2.ordinal == "number") ? d2.ordinal : MAX_ORDINAL;
    return o1 - o2;
  },

  getDefaultTools() {
    return DefaultTools.sort(this.ordinalSort);
  },

  getAdditionalTools() {
    let tools = [];
    for (let [, value] of this._tools) {
      if (DefaultTools.indexOf(value) == -1) {
        tools.push(value);
      }
    }
    return tools.sort(this.ordinalSort);
  },

  getDefaultThemes() {
    return DefaultThemes.sort(this.ordinalSort);
  },

  /**
   * Get a tool definition if it exists and is enabled.
   *
   * @param {string} toolId
   *        The id of the tool to show
   *
   * @return {ToolDefinition|null} tool
   *         The ToolDefinition for the id or null.
   */
  getToolDefinition(toolId) {
    let tool = this._tools.get(toolId);
    if (!tool) {
      return null;
    } else if (!tool.visibilityswitch) {
      return tool;
    }

    let enabled = Services.prefs.getBoolPref(tool.visibilityswitch, true);

    return enabled ? tool : null;
  },

  /**
   * Allow ToolBoxes to get at the list of tools that they should populate
   * themselves with.
   *
   * @return {Map} tools
   *         A map of the the tool definitions registered in this instance
   */
  getToolDefinitionMap() {
    let tools = new Map();

    for (let [id, definition] of this._tools) {
      if (this.getToolDefinition(id)) {
        tools.set(id, definition);
      }
    }

    return tools;
  },

  /**
   * Tools have an inherent ordering that can't be represented in a Map so
   * getToolDefinitionArray provides an alternative representation of the
   * definitions sorted by ordinal value.
   *
   * @return {Array} tools
   *         A sorted array of the tool definitions registered in this instance
   */
  getToolDefinitionArray() {
    let definitions = [];

    for (let [id, definition] of this._tools) {
      if (this.getToolDefinition(id)) {
        definitions.push(definition);
      }
    }

    return definitions.sort(this.ordinalSort);
  },

  /**
   * Returns the name of the current theme for devtools.
   *
   * @return {string} theme
   *         The name of the current devtools theme.
   */
  getTheme() {
    return getTheme();
  },

  /**
   * Called when the developer tools theme changes.
   */
  _onThemeChanged() {
    this.emit("theme-changed", getTheme());
  },

  /**
   * Register a new theme for developer tools toolbox.
   *
   * A definition is a light object that holds various information about a
   * theme.
   *
   * Each themeDefinition has the following properties:
   * - id: Unique identifier for this theme (string|required)
   * - label: Localized name for the theme to be displayed to the user
   *          (string|required)
   * - stylesheets: Array of URLs pointing to a CSS document(s) containing
   *                the theme style rules (array|required)
   * - classList: Array of class names identifying the theme within a document.
   *              These names are set to document element when applying
   *              the theme (array|required)
   * - onApply: Function that is executed by the framework when the theme
   *            is applied. The function takes the current iframe window
   *            and the previous theme id as arguments (function)
   * - onUnapply: Function that is executed by the framework when the theme
   *            is unapplied. The function takes the current iframe window
   *            and the new theme id as arguments (function)
   */
  registerTheme(themeDefinition) {
    let themeId = themeDefinition.id;

    if (!themeId) {
      throw new Error("Invalid theme id");
    }

    if (this._themes.get(themeId)) {
      throw new Error("Theme with the same id is already registered");
    }

    this._themes.set(themeId, themeDefinition);

    this.emit("theme-registered", themeId);
  },

  /**
   * Removes an existing theme from the list of registered themes.
   * Needed so that add-ons can remove themselves when they are deactivated
   *
   * @param {string|object} theme
   *        Definition or the id of the theme to unregister.
   */
  unregisterTheme(theme) {
    let themeId = null;
    if (typeof theme == "string") {
      themeId = theme;
      theme = this._themes.get(theme);
    } else {
      themeId = theme.id;
    }

    let currTheme = getTheme();

    // Note that we can't check if `theme` is an item
    // of `DefaultThemes` as we end up reloading definitions
    // module and end up with different theme objects
    let isCoreTheme = DefaultThemes.some(t => t.id === themeId);

    // Reset the theme if an extension theme that's currently applied
    // is being removed.
    // Ignore shutdown since addons get disabled during that time.
    if (!Services.startup.shuttingDown &&
        !isCoreTheme &&
        theme.id == currTheme) {
      setTheme("light");

      this.emit("theme-unregistered", theme);
    }

    this._themes.delete(themeId);
  },

  /**
   * Get a theme definition if it exists.
   *
   * @param {string} themeId
   *        The id of the theme
   *
   * @return {ThemeDefinition|null} theme
   *         The ThemeDefinition for the id or null.
   */
  getThemeDefinition(themeId) {
    let theme = this._themes.get(themeId);
    if (!theme) {
      return null;
    }
    return theme;
  },

  /**
   * Get map of registered themes.
   *
   * @return {Map} themes
   *         A map of the the theme definitions registered in this instance
   */
  getThemeDefinitionMap() {
    let themes = new Map();

    for (let [id, definition] of this._themes) {
      if (this.getThemeDefinition(id)) {
        themes.set(id, definition);
      }
    }

    return themes;
  },

  /**
   * Get registered themes definitions sorted by ordinal value.
   *
   * @return {Array} themes
   *         A sorted array of the theme definitions registered in this instance
   */
  getThemeDefinitionArray() {
    let definitions = [];

    for (let [id, definition] of this._themes) {
      if (this.getThemeDefinition(id)) {
        definitions.push(definition);
      }
    }

    return definitions.sort(this.ordinalSort);
  },

  /**
   * Get the array of currently opened scratchpad windows.
   *
   * @return {Array} array of currently opened scratchpad windows.
   *         Empty array if the scratchpad manager is not loaded.
   */
  getOpenedScratchpads: function () {
    // Check if the module is loaded to avoid loading ScratchpadManager for no reason.
    if (!Cu.isModuleLoaded("resource://devtools/client/scratchpad/scratchpad-manager.jsm")) {
      return [];
    }
    return ScratchpadManager.getSessionState();
  },

  /**
   * Restore the provided array of scratchpad window states.
   */
  restoreScratchpadSession: function (scratchpads) {
    ScratchpadManager.restoreSession(scratchpads);
  },

  /**
   * Show a Toolbox for a target (either by creating a new one, or if a toolbox
   * already exists for the target, by bring to the front the existing one)
   * If |toolId| is specified then the displayed toolbox will have the
   * specified tool selected.
   * If |hostType| is specified then the toolbox will be displayed using the
   * specified HostType.
   *
   * @param {Target} target
   *         The target the toolbox will debug
   * @param {string} toolId
   *        The id of the tool to show
   * @param {Toolbox.HostType} hostType
   *        The type of host (bottom, window, side)
   * @param {object} hostOptions
   *        Options for host specifically
   *
   * @return {Toolbox} toolbox
   *        The toolbox that was opened
   */
  showToolbox: Task.async(function* (target, toolId, hostType, hostOptions) {
    let toolbox = this._toolboxes.get(target);
    if (toolbox) {
      if (hostType != null && toolbox.hostType != hostType) {
        yield toolbox.switchHost(hostType);
      }

      if (toolId != null && toolbox.currentToolId != toolId) {
        yield toolbox.selectTool(toolId);
      }

      toolbox.raise();
    } else {
      // As toolbox object creation is async, we have to be careful about races
      // Check for possible already in process of loading toolboxes before
      // actually trying to create a new one.
      let promise = this._creatingToolboxes.get(target);
      if (promise) {
        return yield promise;
      }
      let toolboxPromise = this.createToolbox(target, toolId, hostType, hostOptions);
      this._creatingToolboxes.set(target, toolboxPromise);
      toolbox = yield toolboxPromise;
      this._creatingToolboxes.delete(target);
    }
    return toolbox;
  }),

  createToolbox: Task.async(function* (target, toolId, hostType, hostOptions) {
    let manager = new ToolboxHostManager(target, hostType, hostOptions);

    let toolbox = yield manager.create(toolId);

    this._toolboxes.set(target, toolbox);

    this.emit("toolbox-created", toolbox);

    toolbox.once("destroy", () => {
      this.emit("toolbox-destroy", target);
    });

    toolbox.once("destroyed", () => {
      this._toolboxes.delete(target);
      this.emit("toolbox-destroyed", target);
    });

    yield toolbox.open();
    this.emit("toolbox-ready", toolbox);

    return toolbox;
  }),

  /**
   * Return the toolbox for a given target.
   *
   * @param  {object} target
   *         Target value e.g. the target that owns this toolbox
   *
   * @return {Toolbox} toolbox
   *         The toolbox that is debugging the given target
   */
  getToolbox(target) {
    return this._toolboxes.get(target);
  },

  /**
   * Close the toolbox for a given target
   *
   * @return promise
   *         This promise will resolve to false if no toolbox was found
   *         associated to the target. true, if the toolbox was successfully
   *         closed.
   */
  closeToolbox: Task.async(function* (target) {
    let toolbox = yield this._creatingToolboxes.get(target);
    if (!toolbox) {
      toolbox = this._toolboxes.get(target);
    }
    if (!toolbox) {
      return false;
    }
    yield toolbox.destroy();
    return true;
  }),

  /**
   * Wrapper on TargetFactory.forTab, constructs a Target for the provided tab.
   *
   * @param  {XULTab} tab
   *         The tab to use in creating a new target.
   *
   * @return {TabTarget} A target object
   */
  getTargetForTab: function (tab) {
    return TargetFactory.forTab(tab);
  },

  /**
   * Either the SDK Loader has been destroyed by the add-on contribution
   * workflow, or firefox is shutting down.

   * @param {boolean} shuttingDown
   *        True if firefox is currently shutting down. We may prevent doing
   *        some cleanups to speed it up. Otherwise everything need to be
   *        cleaned up in order to be able to load devtools again.
   */
  destroy({ shuttingDown }) {
    // Do not cleanup everything during firefox shutdown, but only when
    // devtools are reloaded via the add-on contribution workflow.
    if (!shuttingDown) {
      for (let [, toolbox] of this._toolboxes) {
        toolbox.destroy();
      }
      AboutDevTools.unregister();
    }

    for (let [key, ] of this.getToolDefinitionMap()) {
      this.unregisterTool(key, true);
    }

    JsonView.destroy();

    gDevTools.unregisterDefaults();

    removeThemeObserver(this._onThemeChanged);

    // Do not unregister devtools from the DevToolsShim if the destroy is caused by an
    // application shutdown. For instance SessionStore needs to save the Scratchpad
    // manager state on shutdown.
    if (!shuttingDown) {
      // Notify the DevToolsShim that DevTools are no longer available, particularly if
      // the destroy was caused by disabling/removing the DevTools add-on.
      DevToolsShim.unregister();
    }

    // Cleaning down the toolboxes: i.e.
    //   for (let [target, toolbox] of this._toolboxes) toolbox.destroy();
    // Is taken care of by the gDevToolsBrowser.forgetBrowserWindow
  },

  /**
   * Iterator that yields each of the toolboxes.
   */
  * [Symbol.iterator ]() {
    for (let toolbox of this._toolboxes) {
      yield toolbox;
    }
  }
};

const gDevTools = exports.gDevTools = new DevTools();
