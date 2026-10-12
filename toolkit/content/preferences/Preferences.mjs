/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import { AsyncSetting } from "chrome://global/content/preferences/AsyncSetting.mjs";
import { Preference } from "chrome://global/content/preferences/Preference.mjs";
import { Setting } from "chrome://global/content/preferences/Setting.mjs";

/** @import {PreferenceConfig} from "chrome://global/content/preferences/Preference.mjs" */
/** @import {SettingConfig} from "chrome://global/content/preferences/Setting.mjs" */
/** @import {DeferredTask} from "resource://gre/modules/DeferredTask.sys.mjs" */

/**
 * @typedef {{ _deferredValueUpdateTask: DeferredTask }} DeferredValueObject
 * @typedef {DeferredValueObject & HTMLElement} DeferredValueHTMLElement
 */

/** @type {{ DeferredTask: typeof DeferredTask }} */
// @ts-expect-error bug 1996860
const lazy = {};
ChromeUtils.defineESModuleGetters(lazy, {
  DeferredTask: "resource://gre/modules/DeferredTask.sys.mjs",
});

const domContentLoadedPromise = new Promise(resolve => {
  window.addEventListener("DOMContentLoaded", resolve, {
    capture: true,
    once: true,
  });
});

export const Preferences = {
  /**
   * @type {Record<string, Preference>}
   */
  _all: {},

  /**
   * @type {Map<string, Setting>}
   */
  _settings: new Map(),

  _unloaded: false,

  /**
   * @param {PreferenceConfig} prefInfo
   */
  _add(prefInfo) {
    if (this._all[prefInfo.id]) {
      throw new Error(`preference with id '${prefInfo.id}' already added`);
    }
    const pref = new Preference(prefInfo);
    this._all[pref.id] = pref;
    domContentLoadedPromise.then(() => {
      if (!this.updateQueued) {
        pref.updateElements();
      }
    });
    return pref;
  },

  /**
   * @param {PreferenceConfig} prefInfo
   * @returns {Preference}
   */
  add(prefInfo) {
    const pref = this._add(prefInfo);
    return pref;
  },

  /**
   * @param {Array<PreferenceConfig>} prefInfos
   */
  addAll(prefInfos) {
    prefInfos.map(prefInfo => this._add(prefInfo));
  },

  /**
   * @param {string} id
   * @returns {Preference | null}
   */
  get(id) {
    return this._all[id] || null;
  },

  /**
   * @returns {Array<Preference>}
   */
  getAll() {
    return Object.values(this._all);
  },

  /**
   * A configuration object that adds an element (control) associated with a pref,
   * that includes all of the configuration for the control
   * such as its Fluent strings, support page, subcategory etc.
   *
   * @param {SettingConfig} settingConfig
   */
  addSetting(settingConfig) {
    if (this._unloaded) {
      // A synchronous importESModule spins the event loop, so pane modules can
      // finish loading after the window is gone; the observers a new Setting
      // registers would never be removed.
      return;
    }
    this._settings.set(
      settingConfig.id,
      new Setting(settingConfig.id, settingConfig)
    );
  },

  /**
   * @param {string} settingId
   * @returns {Setting | undefined}
   */
  getSetting(settingId) {
    return this._settings.get(settingId);
  },

  defaultBranch: Services.prefs.getDefaultBranch(""),

  get type() {
    return document.documentElement.getAttribute("type") || "";
  },

  get instantApply() {
    // The about:preferences page forces instantApply.
    // TODO: Remove forceEnableInstantApply in favor of always applying in a
    // parent and never applying in a child (bug 1775386).
    if (this._instantApplyForceEnabled) {
      return true;
    }

    // Dialogs of type="child" are never instantApply.
    return this.type !== "child";
  },

  _instantApplyForceEnabled: false,

  // Override the computed value of instantApply for this window.
  forceEnableInstantApply() {
    this._instantApplyForceEnabled = true;
  },

  /**
   * @param {nsISupports} _
   * @param {string} __
   * @param {string} data
   */
  observe(_, __, data) {
    const pref = this._all[data];
    if (pref) {
      pref.value = pref.valueFromPreferences;
    }
  },

  updateQueued: false,

  queueUpdateOfAllElements() {
    if (this.updateQueued) {
      return;
    }

    this.updateQueued = true;

    Services.tm.dispatchToMainThread(() => {
      let startTime = ChromeUtils.now();

      const elements = document.querySelectorAll("[preference]");
      for (const element of elements) {
        const id = element.getAttribute("preference");
        let preference = this.get(id);
        if (!preference) {
          console.error(`Missing preference for ID ${id}`);
          continue;
        }

        preference.setElementValue(element);
      }

      ChromeUtils.addProfilerMarker(
        "Preferences",
        { startTime },
        `updateAllElements: ${elements.length} preferences updated`
      );

      this.updateQueued = false;
    });
  },

  /**
   * @param {Event} _
   */
  onUnload(_) {
    this._unloaded = true;
    this._settings.forEach(setting => setting?.destroy?.());
    Services.prefs.removeObserver("", /** @type {nsIObserver} */ (this));
  },

  QueryInterface: ChromeUtils.generateQI(["nsITimerCallback", "nsIObserver"]),

  _deferredValueUpdateElements: new Set(),

  /**
   * @param {boolean} aFlushToDisk
   */
  writePreferences(aFlushToDisk) {
    // Write all values to preferences.
    if (this._deferredValueUpdateElements.size) {
      this._finalizeDeferredElements();
    }

    const preferences = Preferences.getAll();
    for (const preference of preferences) {
      preference.batching = true;
      preference.valueFromPreferences = preference.value;
      preference.batching = false;
    }
    if (aFlushToDisk) {
      Services.prefs.savePrefFile(null);
    }
  },

  /**
   * @param {HTMLElement} aStartElement
   */
  getPreferenceElement(aStartElement) {
    let temp = aStartElement;
    while (
      temp &&
      temp.nodeType == Node.ELEMENT_NODE &&
      !temp.hasAttribute("preference")
    ) {
      // @ts-expect-error
      temp = temp.parentNode;
    }
    return temp && temp.nodeType == Node.ELEMENT_NODE ? temp : aStartElement;
  },

  /**
   * @param {DeferredValueHTMLElement} aElement
   */
  _deferredValueUpdate(aElement) {
    delete aElement._deferredValueUpdateTask;
    const prefID = aElement.getAttribute("preference");
    const preference = Preferences.get(prefID);
    const prefVal = preference.getElementValue(aElement);
    preference.value = prefVal;
    this._deferredValueUpdateElements.delete(aElement);
  },

  _finalizeDeferredElements() {
    for (const el of this._deferredValueUpdateElements) {
      if (el._deferredValueUpdateTask) {
        el._deferredValueUpdateTask.finalize();
      }
    }
  },

  /**
   * @param {HTMLElement} aElement
   */
  userChangedValue(aElement) {
    const element = /** @type {DeferredValueHTMLElement} */ (
      this.getPreferenceElement(aElement)
    );
    if (element.hasAttribute("preference")) {
      if (element.getAttribute("delayprefsave") != "true") {
        const preference = Preferences.get(element.getAttribute("preference"));
        const prefVal = preference.getElementValue(element);
        preference.value = prefVal;
      } else {
        if (!element._deferredValueUpdateTask) {
          element._deferredValueUpdateTask = new lazy.DeferredTask(
            this._deferredValueUpdate.bind(this, element),
            1000
          );
          this._deferredValueUpdateElements.add(element);
        } else {
          // Each time the preference is changed, restart the delay.
          element._deferredValueUpdateTask.disarm();
        }
        element._deferredValueUpdateTask.arm();
      }
    }
  },

  /**
   * @typedef {{ sourceEvent: CommandEventWithSource } & CommandEvent} CommandEventWithSource
   * @param {CommandEventWithSource} event
   */
  onCommand(event) {
    // This "command" event handler tracks changes made to preferences by
    // the user in this window.
    if (event.sourceEvent) {
      event = event.sourceEvent;
    }
    this.userChangedValue(/** @type {HTMLElement} */ (event.target));
  },

  /** @param {Event} event */
  onChange(event) {
    // This "change" event handler tracks changes made to preferences by
    // the user in this window.
    this.userChangedValue(/** @type {HTMLElement} */ (event.target));
  },

  /** @param {Event} event */
  onInput(event) {
    // This "input" event handler tracks changes made to preferences by
    // the user in this window.
    this.userChangedValue(/** @type {HTMLElement} */ (event.target));
  },

  /**
   * @param {string} aEventName
   * @param {HTMLElement} aTarget
   */
  _fireEvent(aEventName, aTarget) {
    try {
      const event = new CustomEvent(aEventName, {
        bubbles: true,
        cancelable: true,
      });
      return aTarget.dispatchEvent(event);
    } catch (e) {
      console.error(e);
    }
    return false;
  },

  /**
   * @param {Event} event
   */
  onDialogAccept(event) {
    let dialog = document.querySelector("dialog");
    if (!this._fireEvent("beforeaccept", dialog)) {
      event.preventDefault();
      return false;
    }
    this.writePreferences(true);
    return true;
  },

  /**
   * @param {Event} event
   */
  close(event) {
    if (Preferences.instantApply) {
      window.close();
    }
    event.stopPropagation();
    event.preventDefault();
  },

  /**
   * @param {Event} event
   */
  handleEvent(event) {
    switch (event.type) {
      case "toggle":
      case "change":
        return this.onChange(event);
      case "command":
        return this.onCommand(/** @type {CommandEventWithSource} */ (event));
      case "dialogaccept":
        return this.onDialogAccept(event);
      case "input":
        return this.onInput(event);
      case "unload":
        return this.onUnload(event);
      default:
        return undefined;
    }
  },

  /** @type {WeakMap<Element, (el: Element) => any>} */
  _syncFromPrefListeners: new WeakMap(),
  /** @type {WeakMap<Element, (el: Element) => any>} */
  _syncToPrefListeners: new WeakMap(),

  /**
   * @param {Element} aElement
   * @param {(el: Element) => any} callback
   */
  addSyncFromPrefListener(aElement, callback) {
    this._syncFromPrefListeners.set(aElement, callback);
    if (this.updateQueued) {
      return;
    }
    // Make sure elements are updated correctly with the listener attached.
    let elementPref = aElement.getAttribute("preference");
    if (elementPref) {
      let pref = this.get(elementPref);
      if (pref) {
        pref.updateElements();
      }
    }
  },

  /**
   * @param {Element} aElement
   * @param {(el: Element) => any} callback
   */
  addSyncToPrefListener(aElement, callback) {
    this._syncToPrefListeners.set(aElement, callback);
    if (this.updateQueued) {
      return;
    }
    // Make sure elements are updated correctly with the listener attached.
    let elementPref = aElement.getAttribute("preference");
    if (elementPref) {
      let pref = this.get(elementPref);
      if (pref) {
        pref.updateElements();
      }
    }
  },

  /**
   * @param {Element} aElement
   */
  removeSyncFromPrefListener(aElement) {
    this._syncFromPrefListeners.delete(aElement);
  },

  /**
   * @param {Element} aElement
   */
  removeSyncToPrefListener(aElement) {
    this._syncToPrefListeners.delete(aElement);
  },

  AsyncSetting,
  Preference,
  Setting,
};

Services.prefs.addObserver("", /** @type {nsIObserver} */ (Preferences));
window.addEventListener("toggle", Preferences);
window.addEventListener("change", Preferences);
window.addEventListener("command", Preferences);
window.addEventListener("dialogaccept", Preferences);
window.addEventListener("input", Preferences);
window.addEventListener("select", Preferences);
window.addEventListener("unload", Preferences, { once: true });
