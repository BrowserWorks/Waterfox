/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const Ci = Components.interfaces;
const Cu = Components.utils;

var {loader, require} = Cu.import("resource://devtools/shared/Loader.jsm", {});
var Telemetry = require("devtools/client/shared/telemetry");
var {showDoorhanger} = require("devtools/client/shared/doorhanger");
var {TouchEventSimulator} = require("devtools/shared/touch/simulator");
var {Task} = require("devtools/shared/task");
var promise = require("promise");
var DevToolsUtils = require("devtools/shared/DevToolsUtils");
var flags = require("devtools/shared/flags");
var Services = require("Services");
var EventEmitter = require("devtools/shared/event-emitter");
var {ViewHelpers} = require("devtools/client/shared/widgets/view-helpers");
var { LocalizationHelper } = require("devtools/shared/l10n");
var { EmulationFront } = require("devtools/shared/fronts/emulation");

loader.lazyImporter(this, "SystemAppProxy",
                    "resource://gre/modules/SystemAppProxy.jsm");
loader.lazyRequireGetter(this, "DebuggerClient",
                         "devtools/shared/client/main", true);
loader.lazyRequireGetter(this, "DebuggerServer",
                         "devtools/server/main", true);

this.EXPORTED_SYMBOLS = ["ResponsiveUIManager"];

const MIN_WIDTH = 50;
const MIN_HEIGHT = 50;

const MAX_WIDTH = 10000;
const MAX_HEIGHT = 10000;

const SLOW_RATIO = 6;
const ROUND_RATIO = 10;

const INPUT_PARSER = /(\d+)[^\d]+(\d+)/;

const SHARED_L10N = new LocalizationHelper("devtools/client/locales/shared.properties");

function debug(msg) {
  // dump(`RDM UI: ${msg}\n`);
}

var ActiveTabs = new Map();

var Manager = {
  /**
   * Check if the a tab is in a responsive mode.
   * Leave the responsive mode if active,
   * active the responsive mode if not active.
   *
   * @param aWindow the main window.
   * @param aTab the tab targeted.
   */
  toggle: function (aWindow, aTab) {
    if (this.isActiveForTab(aTab)) {
      ActiveTabs.get(aTab).close();
    } else {
      this.openIfNeeded(aWindow, aTab);
    }
  },

  /**
   * Launches the responsive mode.
   *
   * @param aWindow the main window.
   * @param aTab the tab targeted.
   * @returns {ResponsiveUI} the instance of ResponsiveUI for the current tab.
   */
  openIfNeeded: Task.async(function* (aWindow, aTab) {
    let ui;
    if (!this.isActiveForTab(aTab)) {
      ui = new ResponsiveUI(aWindow, aTab);
      yield ui.inited;
    } else {
      ui = this.getResponsiveUIForTab(aTab);
    }
    return ui;
  }),

  /**
   * Returns true if responsive view is active for the provided tab.
   *
   * @param aTab the tab targeted.
   */
  isActiveForTab: function (aTab) {
    return ActiveTabs.has(aTab);
  },

  /**
   * Return the responsive UI controller for a tab.
   */
  getResponsiveUIForTab: function (aTab) {
    return ActiveTabs.get(aTab);
  },

  /**
   * Handle gcli commands.
   *
   * @param aWindow the browser window.
   * @param aTab the tab targeted.
   * @param aCommand the command name.
   * @param aArgs command arguments.
   */
  handleGcliCommand: Task.async(function* (aWindow, aTab, aCommand, aArgs) {
    switch (aCommand) {
      case "resize to":
        let ui = yield this.openIfNeeded(aWindow, aTab);
        ui.setViewportSize(aArgs);
        break;
      case "resize on":
        this.openIfNeeded(aWindow, aTab);
        break;
      case "resize off":
        if (this.isActiveForTab(aTab)) {
          yield ActiveTabs.get(aTab).close();
        }
        break;
      case "resize toggle":
        this.toggle(aWindow, aTab);
      default:
    }
  })
};

EventEmitter.decorate(Manager);

// If the new HTML RDM UI is enabled and e10s is enabled by default (e10s is required for
// the new HTML RDM UI to function), delegate the ResponsiveUIManager API over to that
// tool instead.  Performing this delegation here allows us to contain the pref check to a
// single place.
if (Services.prefs.getBoolPref("devtools.responsive.html.enabled") &&
    Services.appinfo.browserTabsRemoteAutostart) {
  let { ResponsiveUIManager } =
    require("devtools/client/responsive.html/manager");
  this.ResponsiveUIManager = ResponsiveUIManager;
} else {
  this.ResponsiveUIManager = Manager;
}

var defaultPresets = [
  // Phones
  {key: "320x480", width: 320, height: 480},    // iPhone, B2G, with <meta viewport>
  {key: "360x640", width: 360, height: 640},    // Android 4, phones, with <meta viewport>

  // Tablets
  {key: "768x1024", width: 768, height: 1024},   // iPad, with <meta viewport>
  {key: "800x1280", width: 800, height: 1280},   // Android 4, Tablet, with <meta viewport>

  // Default width for mobile browsers, no <meta viewport>
  {key: "980x1280", width: 980, height: 1280},

  // Computer
  {key: "1280x600", width: 1280, height: 600},
  {key: "1920x900", width: 1920, height: 900},
];

function ResponsiveUI(aWindow, aTab)
{
  this.mainWindow = aWindow;
  this.tab = aTab;
  this.mm = this.tab.linkedBrowser.messageManager;
  this.tabContainer = aWindow.gBrowser.tabContainer;
  this.browser = aTab.linkedBrowser;
  this.chromeDoc = aWindow.document;
  this.container = aWindow.gBrowser.getBrowserContainer(this.browser);
  this.stack = this.container.querySelector(".browserStack");
  this._telemetry = new Telemetry();

  // Let's bind some callbacks.
  this.bound_presetSelected = this.presetSelected.bind(this);
  this.bound_handleManualInput = this.handleManualInput.bind(this);
  this.bound_addPreset = this.addPreset.bind(this);
  this.bound_removePreset = this.removePreset.bind(this);
  this.bound_rotate = this.rotate.bind(this);
  this.bound_screenshot = () => this.screenshot();
  this.bound_touch = this.toggleTouch.bind(this);
  this.bound_close = this.close.bind(this);
  this.bound_startResizing = this.startResizing.bind(this);
  this.bound_stopResizing = this.stopResizing.bind(this);
  this.bound_onDrag = this.onDrag.bind(this);
  this.bound_changeUA = this.changeUA.bind(this);
  this.bound_onContentResize = this.onContentResize.bind(this);

  this.mm.addMessageListener("ResponsiveMode:OnContentResize",
                             this.bound_onContentResize);

  // We must be ready to handle window or tab close now that we have saved
  // ourselves in ActiveTabs.  Otherwise we risk leaking the window.
  this.mainWindow.addEventListener("unload", this);
  this.tab.addEventListener("TabClose", this);
  this.tabContainer.addEventListener("TabSelect", this);

  ActiveTabs.set(this.tab, this);

  this.inited = this.init();
}

ResponsiveUI.prototype = {
  _transitionsEnabled: true,
  get transitionsEnabled() {
    return this._transitionsEnabled;
  },
  set transitionsEnabled(aValue) {
    this._transitionsEnabled = aValue;
    if (aValue && !this._resizing && this.stack.hasAttribute("responsivemode")) {
      this.stack.removeAttribute("notransition");
    } else if (!aValue) {
      this.stack.setAttribute("notransition", "true");
    }
  },

  init: Task.async(function* () {
    debug("INIT BEGINS");
    let ready = this.waitForMessage("ResponsiveMode:ChildScriptReady");
    this.mm.loadFrameScript("resource://devtools/client/responsivedesign/responsivedesign-child.js", true);
    yield ready;

    let requiresFloatingScrollbars =
      !this.mainWindow.matchMedia("(-moz-overlay-scrollbars)").matches;
    let started = this.waitForMessage("ResponsiveMode:Start:Done");
    debug("SEND START");
    this.mm.sendAsyncMessage("ResponsiveMode:Start", {
      requiresFloatingScrollbars,
      // Tests expect events on resize to yield on various size changes
      notifyOnResize: flags.testing,
    });
    yield started;

    // Load Presets
    this.loadPresets();

    // Setup the UI
    this.container.setAttribute("responsivemode", "true");
    this.stack.setAttribute("responsivemode", "true");
    this.buildUI();
    this.checkMenus();

    // Rotate the responsive mode if needed
    try {
      if (Services.prefs.getBoolPref("devtools.responsiveUI.rotate")) {
        this.rotate();
      }
    } catch (e) {}

    // Touch events support
    this.touchEnableBefore = false;
    this.touchEventSimulator = new TouchEventSimulator(this.browser);

    yield this.connectToServer();
    this.userAgentInput.hidden = false;

    // Hook to display promotional Developer Edition doorhanger.
    // Only displayed once.
    showDoorhanger({
      window: this.mainWindow,
      type: "deveditionpromo",
      anchor: this.chromeDoc.querySelector("#content")
    });

    // Notify that responsive mode is on.
    this._telemetry.toolOpened("responsive");
    ResponsiveUIManager.emit("on", { tab: this.tab });
  }),

  connectToServer: Task.async(function* () {
    if (!DebuggerServer.initialized) {
      DebuggerServer.init();
      DebuggerServer.addBrowserActors();
    }
    this.client = new DebuggerClient(DebuggerServer.connectPipe());
    yield this.client.connect();
    let {tab} = yield this.client.getTab();
    yield this.client.attachTab(tab.actor);
    this.emulationFront = EmulationFront(this.client, tab);
  }),

  loadPresets: function () {
    // Try to load presets from prefs
    let presets = defaultPresets;
    if (Services.prefs.prefHasUserValue("devtools.responsiveUI.presets")) {
      try {
        presets = JSON.parse(Services.prefs.getCharPref("devtools.responsiveUI.presets"));
      } catch (e) {
        // User pref is malformated.
        console.error("Could not parse pref `devtools.responsiveUI.presets`: " + e);
      }
    }

    this.customPreset = {key: "custom", custom: true};

    if (Array.isArray(presets)) {
      this.presets = [this.customPreset].concat(presets);
    } else {
      console.error("Presets value (devtools.responsiveUI.presets) is malformated.");
      this.presets = [this.customPreset];
    }

    try {
      let width = Services.prefs.getIntPref("devtools.responsiveUI.customWidth");
      let height = Services.prefs.getIntPref("devtools.responsiveUI.customHeight");
      this.customPreset.width = Math.min(MAX_WIDTH, width);
      this.customPreset.height = Math.min(MAX_HEIGHT, height);

      this.currentPresetKey = Services.prefs.getCharPref("devtools.responsiveUI.currentPreset");
    } catch (e) {
      // Default size. The first preset (custom) is the one that will be used.
      let bbox = this.stack.getBoundingClientRect();

      this.customPreset.width = bbox.width - 40; // horizontal padding of the container
      this.customPreset.height = bbox.height - 80; // vertical padding + toolbar height

      this.currentPresetKey = this.presets[1].key; // most common preset
    }
  },

  /**
   * Destroy the nodes. Remove listeners. Reset the style.
   */
  close: Task.async(function* () {
    debug("CLOSE BEGINS");
    if (this.closing) {
      debug("ALREADY CLOSING, ABORT");
      return;
    }
    this.closing = true;

    // If we're closing very fast (in tests), ensure init has finished.
    debug("CLOSE: WAIT ON INITED");
    yield this.inited;
    debug("CLOSE: INITED DONE");

    this.unCheckMenus();
    // Reset style of the stack.
    debug(`CURRENT SIZE: ${this.stack.getAttribute("style")}`);
    let style = "max-width: none;" +
                "min-width: 0;" +
                "max-height: none;" +
                "min-height: 0;";
    debug("RESET STACK SIZE");
    this.stack.setAttribute("style", style);

    // Wait for resize message before stopping in the child when testing,
    // but only if we should expect to still get a message.
    if (flags.testing && this.tab.linkedBrowser.messageManager) {
      yield this.waitForMessage("ResponsiveMode:OnContentResize");
    }

    if (this.isResizing)
      this.stopResizing();

    // Remove listeners.
    this.menulist.removeEventListener("select", this.bound_presetSelected, true);
    this.menulist.removeEventListener("change", this.bound_handleManualInput, true);
    this.mainWindow.removeEventListener("unload", this);
    this.tab.removeEventListener("TabClose", this);
    this.tabContainer.removeEventListener("TabSelect", this);
    this.rotatebutton.removeEventListener("command", this.bound_rotate, true);
    this.screenshotbutton.removeEventListener("command", this.bound_screenshot, true);
    this.closebutton.removeEventListener("command", this.bound_close, true);
    this.addbutton.removeEventListener("command", this.bound_addPreset, true);
    this.removebutton.removeEventListener("command", this.bound_removePreset, true);
    this.touchbutton.removeEventListener("command", this.bound_touch, true);
    this.userAgentInput.removeEventListener("blur", this.bound_changeUA, true);

    // Removed elements.
    this.container.removeChild(this.toolbar);
    if (this.bottomToolbar) {
      this.bottomToolbar.remove();
      delete this.bottomToolbar;
    }
    this.stack.removeChild(this.resizer);
    this.stack.removeChild(this.resizeBarV);
    this.stack.removeChild(this.resizeBarH);

    this.stack.classList.remove("fxos-mode");

    // Unset the responsive mode.
    this.container.removeAttribute("responsivemode");
    this.stack.removeAttribute("responsivemode");

    ActiveTabs.delete(this.tab);
    if (this.touchEventSimulator) {
      this.touchEventSimulator.stop();
    }

    yield this.client.close();
    this.client = this.emulationFront = null;

    this._telemetry.toolClosed("responsive");

    if (this.tab.linkedBrowser.messageManager) {
      let stopped = this.waitForMessage("ResponsiveMode:Stop:Done");
      this.tab.linkedBrowser.messageManager.sendAsyncMessage("ResponsiveMode:Stop");
      yield stopped;
    }

    this.inited = null;
    ResponsiveUIManager.emit("off", { tab: this.tab });
  }),

  waitForMessage(message) {
    return new Promise(resolve => {
      let listener = () => {
        this.mm.removeMessageListener(message, listener);
        resolve();
      };
      this.mm.addMessageListener(message, listener);
    });
  },

  /**
   * Emit an event when the content has been resized. Only used in tests.
   */
  onContentResize: function (msg) {
    ResponsiveUIManager.emit("content-resize", {
      tab: this.tab,
      width: msg.data.width,
      height: msg.data.height,
    });
  },

  /**
   * Handle events
   */
  handleEvent: function (aEvent) {
    switch (aEvent.type) {
      case "TabClose":
      case "unload":
        this.close();
        break;
      case "TabSelect":
        if (this.tab.selected) {
          this.checkMenus();
        } else if (!this.mainWindow.gBrowser.selectedTab.responsiveUI) {
          this.unCheckMenus();
        }
        break;
    }
  },

  getViewportBrowser() {
    return this.browser;
  },

  /**
   * Check the menu items.
   */
  checkMenus: function RUI_checkMenus() {
    this.chromeDoc.getElementById("menu_responsiveUI").setAttribute("checked", "true");
  },

  /**
   * Uncheck the menu items.
   */
  unCheckMenus: function RUI_unCheckMenus() {
    let el = this.chromeDoc.getElementById("menu_responsiveUI");
    if (el) {
      el.setAttribute("checked", "false");
    }
  },

  /**
   * Build the toolbar and the resizers.
   *
   * <vbox class="browserContainer"> From tabbrowser.xml
   *  <toolbar class="devtools-responsiveui-toolbar">
   *    <menulist class="devtools-responsiveui-menulist"/> // presets
   *    <toolbarbutton tabindex="0" class="devtools-responsiveui-toolbarbutton" tooltiptext="rotate"/> // rotate
   *    <toolbarbutton tabindex="0" class="devtools-responsiveui-toolbarbutton" tooltiptext="screenshot"/> // screenshot
   *    <toolbarbutton tabindex="0" class="devtools-responsiveui-toolbarbutton" tooltiptext="Leave Responsive Design Mode"/> // close
   *  </toolbar>
   *  <stack class="browserStack"> From tabbrowser.xml
   *    <browser/>
   *    <box class="devtools-responsiveui-resizehandle" bottom="0" right="0"/>
   *    <box class="devtools-responsiveui-resizebarV" top="0" right="0"/>
   *    <box class="devtools-responsiveui-resizebarH" bottom="0" left="0"/>
   *    // Additional button in FxOS mode:
   *    <button class="devtools-responsiveui-sleep-button" />
   *    <vbox class="devtools-responsiveui-volume-buttons">
   *      <button class="devtools-responsiveui-volume-up-button" />
   *      <button class="devtools-responsiveui-volume-down-button" />
   *    </vbox>
   *  </stack>
   *  <toolbar class="devtools-responsiveui-hardware-button">
   *    <toolbarbutton class="devtools-responsiveui-home-button" />
   *  </toolbar>
   * </vbox>
   */
  buildUI: function RUI_buildUI() {
    // Toolbar
    this.toolbar = this.chromeDoc.createElement("toolbar");
    this.toolbar.className = "devtools-responsiveui-toolbar";
    this.toolbar.setAttribute("fullscreentoolbar", "true");

    this.menulist = this.chromeDoc.createElement("menulist");
    this.menulist.className = "devtools-responsiveui-menulist";
    this.menulist.setAttribute("editable", "true");

    this.menulist.addEventListener("select", this.bound_presetSelected, true);
    this.menulist.addEventListener("change", this.bound_handleManualInput, true);

    this.menuitems = new Map();

    let menupopup = this.chromeDoc.createElement("menupopup");
    this.registerPresets(menupopup);
    this.menulist.appendChild(menupopup);

    this.addbutton = this.chromeDoc.createElement("menuitem");
    this.addbutton.setAttribute("label", this.strings.GetStringFromName("responsiveUI.addPreset"));
    this.addbutton.addEventListener("command", this.bound_addPreset, true);

    this.removebutton = this.chromeDoc.createElement("menuitem");
    this.removebutton.setAttribute("label", this.strings.GetStringFromName("responsiveUI.removePreset"));
    this.removebutton.addEventListener("command", this.bound_removePreset, true);

    menupopup.appendChild(this.chromeDoc.createElement("menuseparator"));
    menupopup.appendChild(this.addbutton);
    menupopup.appendChild(this.removebutton);

    this.rotatebutton = this.chromeDoc.createElement("toolbarbutton");
    this.rotatebutton.setAttribute("tabindex", "0");
    this.rotatebutton.setAttribute("tooltiptext", this.strings.GetStringFromName("responsiveUI.rotate2"));
    this.rotatebutton.className = "devtools-responsiveui-toolbarbutton devtools-responsiveui-rotate";
    this.rotatebutton.addEventListener("command", this.bound_rotate, true);

    this.screenshotbutton = this.chromeDoc.createElement("toolbarbutton");
    this.screenshotbutton.setAttribute("tabindex", "0");
    this.screenshotbutton.setAttribute("tooltiptext", this.strings.GetStringFromName("responsiveUI.screenshot"));
    this.screenshotbutton.className = "devtools-responsiveui-toolbarbutton devtools-responsiveui-screenshot";
    this.screenshotbutton.addEventListener("command", this.bound_screenshot, true);

    this.closebutton = this.chromeDoc.createElement("toolbarbutton");
    this.closebutton.setAttribute("tabindex", "0");
    this.closebutton.className = "devtools-responsiveui-toolbarbutton devtools-responsiveui-close";
    this.closebutton.setAttribute("tooltiptext", this.strings.GetStringFromName("responsiveUI.close1"));
    this.closebutton.addEventListener("command", this.bound_close, true);

    this.toolbar.appendChild(this.closebutton);
    this.toolbar.appendChild(this.menulist);
    this.toolbar.appendChild(this.rotatebutton);

    this.touchbutton = this.chromeDoc.createElement("toolbarbutton");
    this.touchbutton.setAttribute("tabindex", "0");
    this.touchbutton.setAttribute("tooltiptext", this.strings.GetStringFromName("responsiveUI.touch"));
    this.touchbutton.className = "devtools-responsiveui-toolbarbutton devtools-responsiveui-touch";
    this.touchbutton.addEventListener("command", this.bound_touch, true);
    this.toolbar.appendChild(this.touchbutton);

    this.toolbar.appendChild(this.screenshotbutton);

    this.userAgentInput = this.chromeDoc.createElement("textbox");
    this.userAgentInput.className = "devtools-responsiveui-textinput";
    this.userAgentInput.setAttribute("placeholder",
      this.strings.GetStringFromName("responsiveUI.userAgentPlaceholder"));
    this.userAgentInput.addEventListener("blur", this.bound_changeUA, true);
    this.userAgentInput.hidden = true;
    this.toolbar.appendChild(this.userAgentInput);

    // Resizers
    let resizerTooltip = this.strings.GetStringFromName("responsiveUI.resizerTooltip");
    this.resizer = this.chromeDoc.createElement("box");
    this.resizer.className = "devtools-responsiveui-resizehandle";
    this.resizer.setAttribute("right", "0");
    this.resizer.setAttribute("bottom", "0");
    this.resizer.setAttribute("tooltiptext", resizerTooltip);
    this.resizer.onmousedown = this.bound_startResizing;

    this.resizeBarV = this.chromeDoc.createElement("box");
    this.resizeBarV.className = "devtools-responsiveui-resizebarV";
    this.resizeBarV.setAttribute("top", "0");
    this.resizeBarV.setAttribute("right", "0");
    this.resizeBarV.setAttribute("tooltiptext", resizerTooltip);
    this.resizeBarV.onmousedown = this.bound_startResizing;

    this.resizeBarH = this.chromeDoc.createElement("box");
    this.resizeBarH.className = "devtools-responsiveui-resizebarH";
    this.resizeBarH.setAttribute("bottom", "0");
    this.resizeBarH.setAttribute("left", "0");
    this.resizeBarH.setAttribute("tooltiptext", resizerTooltip);
    this.resizeBarH.onmousedown = this.bound_startResizing;

    this.container.insertBefore(this.toolbar, this.stack);
    this.stack.appendChild(this.resizer);
    this.stack.appendChild(this.resizeBarV);
    this.stack.appendChild(this.resizeBarH);
  },

  // FxOS custom controls
  buildPhoneUI: function () {
    this.stack.classList.add("fxos-mode");

    let sleepButton = this.chromeDoc.createElement("button");
    sleepButton.className = "devtools-responsiveui-sleep-button";
    sleepButton.setAttribute("top", 0);
    sleepButton.setAttribute("right", 0);
    sleepButton.addEventListener("mousedown", () => {
      SystemAppProxy.dispatchKeyboardEvent("keydown", {key: "Power"});
    });
    sleepButton.addEventListener("mouseup", () => {
      SystemAppProxy.dispatchKeyboardEvent("keyup", {key: "Power"});
    });
    this.stack.appendChild(sleepButton);

    let volumeButtons = this.chromeDoc.createElement("vbox");
    volumeButtons.className = "devtools-responsiveui-volume-buttons";
    volumeButtons.setAttribute("top", 0);
    volumeButtons.setAttribute("left", 0);

    let volumeUp = this.chromeDoc.createElement("button");
    volumeUp.className = "devtools-responsiveui-volume-up-button";
    volumeUp.addEventListener("mousedown", () => {
      SystemAppProxy.dispatchKeyboardEvent("keydown", {key: "AudioVolumeUp"});
    });
    volumeUp.addEventListener("mouseup", () => {
      SystemAppProxy.dispatchKeyboardEvent("keyup", {key: "AudioVolumeUp"});
    });

    let volumeDown = this.chromeDoc.createElement("button");
    volumeDown.className = "devtools-responsiveui-volume-down-button";
    volumeDown.addEventListener("mousedown", () => {
      SystemAppProxy.dispatchKeyboardEvent("keydown", {key: "AudioVolumeDown"});
    });
    volumeDown.addEventListener("mouseup", () => {
      SystemAppProxy.dispatchKeyboardEvent("keyup", {key: "AudioVolumeDown"});
    });

    volumeButtons.appendChild(volumeUp);
    volumeButtons.appendChild(volumeDown);
    this.stack.appendChild(volumeButtons);

    let bottomToolbar = this.chromeDoc.createElement("toolbar");
    bottomToolbar.className = "devtools-responsiveui-hardware-buttons";
    bottomToolbar.setAttribute("align", "center");
    bottomToolbar.setAttribute("pack", "center");

    let homeButton = this.chromeDoc.createElement("toolbarbutton");
    homeButton.className = "devtools-responsiveui-toolbarbutton devtools-responsiveui-home-button";
    homeButton.addEventListener("mousedown", () => {
      SystemAppProxy.dispatchKeyboardEvent("keydown", {key: "Home"});
    });
    homeButton.addEventListener("mouseup", () => {
      SystemAppProxy.dispatchKeyboardEvent("keyup", {key: "Home"});
    });
    bottomToolbar.appendChild(homeButton);
    this.bottomToolbar = bottomToolbar;
    this.container.appendChild(bottomToolbar);
  },

  /**
   * Validate and apply any user input on the editable menulist
   */
  handleManualInput: function RUI_handleManualInput() {
    let userInput = this.menulist.inputField.value;
    let value = INPUT_PARSER.exec(userInput);
    let selectedPreset = this.menuitems.get(this.selectedItem);

    // In case of an invalide value, we show back the last preset
    if (!value || value.length < 3) {
      this.setMenuLabel(this.selectedItem, selectedPreset);
      return;
    }

    this.rotateValue = false;

    if (!selectedPreset.custom) {
      let menuitem = this.customMenuitem;
      this.currentPresetKey = this.customPreset.key;
      this.menulist.selectedItem = menuitem;
    }

    let w = this.customPreset.width = parseInt(value[1], 10);
    let h = this.customPreset.height = parseInt(value[2], 10);

    this.saveCustomSize();
    this.setViewportSize({
      width: w,
      height: h,
    });
  },

  /**
   * Build the presets list and append it to the menupopup.
   *
   * @param aParent menupopup.
   */
  registerPresets: function RUI_registerPresets(aParent) {
    let fragment = this.chromeDoc.createDocumentFragment();
    let doc = this.chromeDoc;

    for (let preset of this.presets) {
      let menuitem = doc.createElement("menuitem");
      menuitem.setAttribute("ispreset", true);
      this.menuitems.set(menuitem, preset);

      if (preset.key === this.currentPresetKey) {
        menuitem.setAttribute("selected", "true");
        this.selectedItem = menuitem;
      }

      if (preset.custom) {
        this.customMenuitem = menuitem;
      }

      this.setMenuLabel(menuitem, preset);
      fragment.appendChild(menuitem);
    }
    aParent.appendChild(fragment);
  },

  /**
   * Set the menuitem label of a preset.
   *
   * @param aMenuitem menuitem to edit.
   * @param aPreset associated preset.
   */
  setMenuLabel: function RUI_setMenuLabel(aMenuitem, aPreset) {
    let size = SHARED_L10N.getFormatStr("dimensions",
      Math.round(aPreset.width), Math.round(aPreset.height));

    // .inputField might be not reachable yet (async XBL loading)
    if (this.menulist.inputField) {
      this.menulist.inputField.value = size;
    }

    if (aPreset.custom) {
      size = this.strings.formatStringFromName("responsiveUI.customResolution", [size], 1);
    } else if (aPreset.name != null && aPreset.name !== "") {
      size = this.strings.formatStringFromName("responsiveUI.namedResolution", [size, aPreset.name], 2);
    }

    aMenuitem.setAttribute("label", size);
  },

  /**
   * When a preset is selected, apply it.
   */
  presetSelected: function RUI_presetSelected() {
    if (this.menulist.selectedItem.getAttribute("ispreset") === "true") {
      this.selectedItem = this.menulist.selectedItem;

      this.rotateValue = false;
      let selectedPreset = this.menuitems.get(this.selectedItem);
      this.loadPreset(selectedPreset);
      this.currentPresetKey = selectedPreset.key;
      this.saveCurrentPreset();

      // Update the buttons hidden status according to the new selected preset
      if (selectedPreset == this.customPreset) {
        this.addbutton.hidden = false;
        this.removebutton.hidden = true;
      } else {
        this.addbutton.hidden = true;
        this.removebutton.hidden = false;
      }
    }
  },

  /**
   * Apply a preset.
   */
  loadPreset(preset) {
    this.setViewportSize(preset);
  },

  /**
   * Add a preset to the list and the memory
   */
  addPreset: function RUI_addPreset() {
    let w = this.customPreset.width;
    let h = this.customPreset.height;
    let newName = {};

    let title = this.strings.GetStringFromName("responsiveUI.customNamePromptTitle1");
    let message = this.strings.formatStringFromName("responsiveUI.customNamePromptMsg", [w, h], 2);
    let promptOk = Services.prompt.prompt(null, title, message, newName, null, {});

    if (!promptOk) {
      // Prompt has been cancelled
      this.menulist.selectedItem = this.selectedItem;
      return;
    }

    let newPreset = {
      key: w + "x" + h,
      name: newName.value,
      width: w,
      height: h
    };

    this.presets.push(newPreset);

    // Sort the presets according to width/height ascending order
    this.presets.sort(function RUI_sortPresets(aPresetA, aPresetB) {
      // We keep custom preset at first
      if (aPresetA.custom && !aPresetB.custom) {
        return 1;
      }
      if (!aPresetA.custom && aPresetB.custom) {
        return -1;
      }

      if (aPresetA.width === aPresetB.width) {
        if (aPresetA.height === aPresetB.height) {
          return 0;
        } else {
          return aPresetA.height > aPresetB.height;
        }
      } else {
        return aPresetA.width > aPresetB.width;
      }
    });

    this.savePresets();

    let newMenuitem = this.chromeDoc.createElement("menuitem");
    newMenuitem.setAttribute("ispreset", true);
    this.setMenuLabel(newMenuitem, newPreset);

    this.menuitems.set(newMenuitem, newPreset);
    let idx = this.presets.indexOf(newPreset);
    let beforeMenuitem = this.menulist.firstChild.childNodes[idx + 1];
    this.menulist.firstChild.insertBefore(newMenuitem, beforeMenuitem);

    this.menulist.selectedItem = newMenuitem;
    this.currentPresetKey = newPreset.key;
    this.saveCurrentPreset();
  },

  /**
   * remove a preset from the list and the memory
   */
  removePreset: function RUI_removePreset() {
    let selectedPreset = this.menuitems.get(this.selectedItem);
    let w = selectedPreset.width;
    let h = selectedPreset.height;

    this.presets.splice(this.presets.indexOf(selectedPreset), 1);
    this.menulist.firstChild.removeChild(this.selectedItem);
    this.menuitems.delete(this.selectedItem);

    this.customPreset.width = w;
    this.customPreset.height = h;
    let menuitem = this.customMenuitem;
    this.setMenuLabel(menuitem, this.customPreset);
    this.menulist.selectedItem = menuitem;
    this.currentPresetKey = this.customPreset.key;

    this.setViewportSize({
      width: w,
      height: h,
    });

    this.savePresets();
  },

  /**
   * Swap width and height.
   */
  rotate: function RUI_rotate() {
    let selectedPreset = this.menuitems.get(this.selectedItem);
    let width = this.rotateValue ? selectedPreset.height : selectedPreset.width;
    let height = this.rotateValue ? selectedPreset.width : selectedPreset.height;

    this.setViewportSize({
      width: height,
      height: width,
    });

    if (selectedPreset.custom) {
      this.saveCustomSize();
    } else {
      this.rotateValue = !this.rotateValue;
      this.saveCurrentPreset();
    }
  },

  /**
   * Take a screenshot of the page.
   *
   * @param aFileName name of the screenshot file (used for tests).
   */
  screenshot: function RUI_screenshot(aFileName) {
    let filename = aFileName;
    if (!filename) {
      let date = new Date();
      let month = ("0" + (date.getMonth() + 1)).substr(-2, 2);
      let day = ("0" + date.getDate()).substr(-2, 2);
      let dateString = [date.getFullYear(), month, day].join("-");
      let timeString = date.toTimeString().replace(/:/g, ".").split(" ")[0];
      filename = this.strings.formatStringFromName("responsiveUI.screenshotGeneratedFilename", [dateString, timeString], 2);
    }
    let mm = this.tab.linkedBrowser.messageManager;
    let chromeWindow = this.chromeDoc.defaultView;
    let doc = chromeWindow.document;
    function onScreenshot(aMessage) {
      mm.removeMessageListener("ResponsiveMode:RequestScreenshot:Done", onScreenshot);
      chromeWindow.saveURL(aMessage.data, filename + ".png", null, true, true, doc.documentURIObject, doc);
    }
    mm.addMessageListener("ResponsiveMode:RequestScreenshot:Done", onScreenshot);
    mm.sendAsyncMessage("ResponsiveMode:RequestScreenshot");
  },

  /**
   * Enable/Disable mouse -> touch events translation.
   */
  enableTouch: function RUI_enableTouch() {
    this.touchbutton.setAttribute("checked", "true");
    return this.touchEventSimulator.start();
  },

  disableTouch: function RUI_disableTouch() {
    this.touchbutton.removeAttribute("checked");
    return this.touchEventSimulator.stop();
  },

  hideTouchNotification: function RUI_hideTouchNotification() {
    let nbox = this.mainWindow.gBrowser.getNotificationBox(this.browser);
    let n = nbox.getNotificationWithValue("responsive-ui-need-reload");
    if (n) {
      n.close();
    }
  },

  toggleTouch: Task.async(function* () {
    this.hideTouchNotification();
    if (this.touchEventSimulator.enabled) {
      this.disableTouch();
    } else {
      let isReloadNeeded = yield this.enableTouch();
      if (isReloadNeeded) {
        if (Services.prefs.getBoolPref("devtools.responsiveUI.no-reload-notification")) {
          return;
        }

        let nbox = this.mainWindow.gBrowser.getNotificationBox(this.browser);

        var buttons = [{
          label: this.strings.GetStringFromName("responsiveUI.notificationReload"),
          callback: () => {
            this.browser.reload();
          },
          accessKey: this.strings.GetStringFromName("responsiveUI.notificationReload_accesskey"),
        }, {
          label: this.strings.GetStringFromName("responsiveUI.dontShowReloadNotification"),
          callback: function () {
            Services.prefs.setBoolPref("devtools.responsiveUI.no-reload-notification", true);
          },
          accessKey: this.strings.GetStringFromName("responsiveUI.dontShowReloadNotification_accesskey"),
        }];

        nbox.appendNotification(
           this.strings.GetStringFromName("responsiveUI.needReload"),
           "responsive-ui-need-reload",
           null,
           nbox.PRIORITY_INFO_LOW,
           buttons);
      }
    }
  }),

  waitForReload() {
    let navigatedDeferred = promise.defer();
    let onNavigated = (_, { state }) => {
      if (state != "stop") {
        return;
      }
      this.client.removeListener("tabNavigated", onNavigated);
      navigatedDeferred.resolve();
    };
    this.client.addListener("tabNavigated", onNavigated);
    return navigatedDeferred.promise;
  },

  /**
   * Change the user agent string
   */
  changeUA: Task.async(function* () {
    let value = this.userAgentInput.value;
    let changed;
    if (value) {
      changed = yield this.emulationFront.setUserAgentOverride(value);
      this.userAgentInput.setAttribute("attention", "true");
    } else {
      changed = yield this.emulationFront.clearUserAgentOverride();
      this.userAgentInput.removeAttribute("attention");
    }
    if (changed) {
      let reloaded = this.waitForReload();
      this.tab.linkedBrowser.reload();
      yield reloaded;
    }
    ResponsiveUIManager.emit("userAgentChanged", { tab: this.tab });
  }),

  /**
   * Get the current width and height.
   */
  getSize() {
    let width = Number(this.stack.style.minWidth.replace("px", ""));
    let height = Number(this.stack.style.minHeight.replace("px", ""));
    return {
      width,
      height,
    };
  },

  /**
   * Change the size of the viewport.
   */
  setViewportSize({ width, height }) {
    debug(`SET SIZE TO ${width} x ${height}`);
    if (width) {
      this.setWidth(width);
    }
    if (height) {
      this.setHeight(height);
    }
  },

  setWidth: function RUI_setWidth(aWidth) {
    aWidth = Math.min(Math.max(aWidth, MIN_WIDTH), MAX_WIDTH);
    this.stack.style.maxWidth = this.stack.style.minWidth = aWidth + "px";

    if (!this.ignoreX)
      this.resizeBarH.setAttribute("left", Math.round(aWidth / 2));

    let selectedPreset = this.menuitems.get(this.selectedItem);

    if (selectedPreset.custom) {
      selectedPreset.width = aWidth;
      this.setMenuLabel(this.selectedItem, selectedPreset);
    }
  },

  setHeight: function RUI_setHeight(aHeight) {
    aHeight = Math.min(Math.max(aHeight, MIN_HEIGHT), MAX_HEIGHT);
    this.stack.style.maxHeight = this.stack.style.minHeight = aHeight + "px";

    if (!this.ignoreY)
      this.resizeBarV.setAttribute("top", Math.round(aHeight / 2));

    let selectedPreset = this.menuitems.get(this.selectedItem);
    if (selectedPreset.custom) {
      selectedPreset.height = aHeight;
      this.setMenuLabel(this.selectedItem, selectedPreset);
    }
  },
  /**
   * Start the process of resizing the browser.
   *
   * @param aEvent
   */
  startResizing: function RUI_startResizing(aEvent) {
    let selectedPreset = this.menuitems.get(this.selectedItem);

    if (!selectedPreset.custom) {
      this.customPreset.width = this.rotateValue ? selectedPreset.height : selectedPreset.width;
      this.customPreset.height = this.rotateValue ? selectedPreset.width : selectedPreset.height;

      let menuitem = this.customMenuitem;
      this.setMenuLabel(menuitem, this.customPreset);

      this.currentPresetKey = this.customPreset.key;
      this.menulist.selectedItem = menuitem;
    }
    this.mainWindow.addEventListener("mouseup", this.bound_stopResizing, true);
    this.mainWindow.addEventListener("mousemove", this.bound_onDrag, true);
    this.container.style.pointerEvents = "none";

    this._resizing = true;
    this.stack.setAttribute("notransition", "true");

    this.lastScreenX = aEvent.screenX;
    this.lastScreenY = aEvent.screenY;

    this.ignoreY = (aEvent.target === this.resizeBarV);
    this.ignoreX = (aEvent.target === this.resizeBarH);

    this.isResizing = true;
  },

  /**
   * Resizing on mouse move.
   *
   * @param aEvent
   */
  onDrag: function RUI_onDrag(aEvent) {
    let shift = aEvent.shiftKey;
    let ctrl = !aEvent.shiftKey && aEvent.ctrlKey;

    let screenX = aEvent.screenX;
    let screenY = aEvent.screenY;

    let deltaX = screenX - this.lastScreenX;
    let deltaY = screenY - this.lastScreenY;

    if (this.ignoreY)
      deltaY = 0;
    if (this.ignoreX)
      deltaX = 0;

    if (ctrl) {
      deltaX /= SLOW_RATIO;
      deltaY /= SLOW_RATIO;
    }

    let width = this.customPreset.width + deltaX;
    let height = this.customPreset.height + deltaY;

    if (shift) {
      let roundedWidth, roundedHeight;
      roundedWidth = 10 * Math.floor(width / ROUND_RATIO);
      roundedHeight = 10 * Math.floor(height / ROUND_RATIO);
      screenX += roundedWidth - width;
      screenY += roundedHeight - height;
      width = roundedWidth;
      height = roundedHeight;
    }

    if (width < MIN_WIDTH) {
      width = MIN_WIDTH;
    } else {
      this.lastScreenX = screenX;
    }

    if (height < MIN_HEIGHT) {
      height = MIN_HEIGHT;
    } else {
      this.lastScreenY = screenY;
    }

    this.setViewportSize({ width, height });
  },

  /**
   * Stop End resizing
   */
  stopResizing: function RUI_stopResizing() {
    this.container.style.pointerEvents = "auto";

    this.mainWindow.removeEventListener("mouseup", this.bound_stopResizing, true);
    this.mainWindow.removeEventListener("mousemove", this.bound_onDrag, true);

    this.saveCustomSize();

    delete this._resizing;
    if (this.transitionsEnabled) {
      this.stack.removeAttribute("notransition");
    }
    this.ignoreY = false;
    this.ignoreX = false;
    this.isResizing = false;
  },

  /**
   * Store the custom size as a pref.
   */
  saveCustomSize: function RUI_saveCustomSize() {
    Services.prefs.setIntPref("devtools.responsiveUI.customWidth", this.customPreset.width);
    Services.prefs.setIntPref("devtools.responsiveUI.customHeight", this.customPreset.height);
  },

  /**
   * Store the current preset as a pref.
   */
  saveCurrentPreset: function RUI_saveCurrentPreset() {
    Services.prefs.setCharPref("devtools.responsiveUI.currentPreset", this.currentPresetKey);
    Services.prefs.setBoolPref("devtools.responsiveUI.rotate", this.rotateValue);
  },

  /**
   * Store the list of all registered presets as a pref.
   */
  savePresets: function RUI_savePresets() {
    // We exclude the custom one
    let registeredPresets = this.presets.filter(function (aPreset) {
      return !aPreset.custom;
    });

    Services.prefs.setCharPref("devtools.responsiveUI.presets", JSON.stringify(registeredPresets));
  },
};

loader.lazyGetter(ResponsiveUI.prototype, "strings", function () {
  return Services.strings.createBundle("chrome://devtools/locale/responsiveUI.properties");
});
