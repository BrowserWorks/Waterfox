/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global browser */

const PrefsExt = {
  // only prefs for built-in elements that need adjusting
  get prefs() {
    return {
      defaults: [{ id: "browser.tabs.duplicateTab", value: true }],
      types: [
        { id: "browser.tabs.duplicateTab", type: "bool" },
        { id: "browser.tabs.copyurl", type: "bool" },
        { id: "browser.tabs.copyurl.activetab", type: "bool" },
        { id: "browser.tabs.copyallurls", type: "bool" },
        { id: "browser.restart_menu.purgecache", type: "bool" },
        { id: "browser.restart_menu.requireconfirm", type: "bool" },
        { id: "browser.restart_menu.showpanelmenubtn", type: "bool" },
      ],
    };
  },

  get tabContainer() {
    return [
      {
        tag: "label",
        attrs: {
          id: "tabFeatureLabel",
        },
        adjacentTo: "languageAndAppearanceCategory",
        position: "beforebegin",
      },
      {
        tag: "html:h2",
        attrs: {
          id: "tabFeatureHeader",
          class: "extensiblesHeader",
          label: browser.i18n.getMessage("tabHeader"),
        },
        adjacentTo: "tabFeatureLabel",
        position: "afterbegin",
      },
      {
        tag: "vbox",
        attrs: {
          id: "tabContextMenuSettingsContainer",
        },
        adjacentTo: "tabFeatureLabel",
        position: "afterend",
      },
    ];
  },

  get tabPrefToggles() {
    return [
      {
        tag: "checkbox",
        attrs: {
          id: "duplicateTab",
          label: browser.i18n.getMessage("showDuplicateTab"),
          preference: "browser.tabs.duplicateTab",
        },
        adjacentTo: "tabContextMenuSettingsContainer",
        position: "beforeend",
      },
      {
        tag: "checkbox",
        attrs: {
          id: "copyUrl",
          label: browser.i18n.getMessage("showCopyTab"),
          preference: "browser.tabs.copyurl",
        },
        adjacentTo: "tabContextMenuSettingsContainer",
        position: "beforeend",
      },
      {
        tag: "checkbox",
        attrs: {
          id: "copyActiveTab",
          label: browser.i18n.getMessage("showCopyActiveTab"),
          preference: "browser.tabs.copyurl.activetab",
        },
        adjacentTo: "tabContextMenuSettingsContainer",
        position: "beforeend",
      },
      {
        tag: "checkbox",
        attrs: {
          id: "copyAllUrls",
          label: browser.i18n.getMessage("showCopyAllTab"),
          preference: "browser.tabs.copyallurls",
        },
        adjacentTo: "tabContextMenuSettingsContainer",
        position: "beforeend",
      },
    ];
  },

  get restartContainer() {
    return [
      {
        tag: "groupbox",
        attrs: {
          id: "restartGroup",
          "data-category": "paneGeneral",
        },
        adjacentTo: "languagesGroup",
        position: "afterend",
      },
      {
        tag: "label",
        attrs: {
          id: "restartFeatureLabel",
        },
        adjacentTo: "restartGroup",
        position: "beforeend",
      },
      {
        tag: "html:h2",
        attrs: {
          id: "restartFeatureHeader",
          class: "extensiblesHeader",
          label: browser.i18n.getMessage("restartHeader"),
        },
        adjacentTo: "restartFeatureLabel",
        position: "afterbegin",
      },
    ];
  },

  get restartPrefToggles() {
    return [
      {
        tag: "checkbox",
        attrs: {
          id: "showRestartItem",
          label: browser.i18n.getMessage("showRestartButton"),
          preference: "browser.restart_menu.showpanelmenubtn",
        },
        adjacentTo: "restartGroup",
        position: "beforeend",
      },
      {
        tag: "checkbox",
        attrs: {
          id: "purgeCache",
          label: browser.i18n.getMessage("restartClearCache"),
          preference: "browser.restart_menu.purgecache",
        },
        adjacentTo: "restartGroup",
        position: "beforeend",
      },
      {
        tag: "checkbox",
        attrs: {
          id: "requireRestartConfirmation",
          label: browser.i18n.getMessage("confirmRestart"),
          preference: "browser.restart_menu.requireconfirm",
        },
        adjacentTo: "restartGroup",
        position: "beforeend",
      },
    ];
  },

  setStyle() {
    browser.extensibles.prefsext.setStyle();
  },

  async init() {
    // register prefs that aren't created elsewhere
    this.registerPrefs(this.prefs);
    // set additional styling reqs
    this.setStyle();
    // build tab context menu prefs
    this.tabContainer.forEach(item => {
      this.createAndPositionElement(item);
      if (item.attrs.label) {
        browser.extensibles.utils.append(item.attrs.id, item.attrs.label);
      }
    });
    this.tabPrefToggles.forEach(item => {
      this.createAndPositionElement(item);
    });
    // build restart button prefs
    this.restartContainer.forEach(item => {
      this.createAndPositionElement(item);
      if (item.attrs.label) {
        browser.extensibles.utils.append(item.attrs.id, item.attrs.label);
      }
    });
    this.restartPrefToggles.forEach(item => {
      this.createAndPositionElement(item);
    });
  },

  registerPrefs(aPrefs) {
    aPrefs.defaults.forEach(item => {
      browser.extensibles.utils.registerPref(item.id, item.value);
    });
    aPrefs.types.forEach(item => {
      browser.extensibles.utils.addPreference(item.id, item.type);
    });
  },

  createAndPositionElement(item) {
    const { tag, attrs, adjacentTo, position } = item;
    // arg[4] true is to ensure this executed in content document
    browser.extensibles.utils.createAndPositionElement(
      tag,
      attrs,
      adjacentTo,
      position,
      true
    );
  },
};

(async function() {
  let listener = async (tabId, changeInfo, tab) => {
    if (
      (await browser.extensibles.utils.elementExistsInContent(
        "duplicateTab"
      )) ||
      !tab.favIconUrl // listener fires twice, once before content loaded and once with faviconurl once content loaded
    ) {
      return;
    }
    await PrefsExt.init();
  };
  let extraParameters = {
    urls: ["about:preferences"],
    properties: ["url"],
  };
  browser.tabs.onUpdated.addListener(listener, extraParameters);
})();
