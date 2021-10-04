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
        { id: "browser.tabs.toolbarposition", type: "string" },
        { id: "browser.restart_menu.purgecache", type: "bool" },
        { id: "browser.restart_menu.requireconfirm", type: "bool" },
        { id: "browser.restart_menu.showpanelmenubtn", type: "bool" },
        { id: "browser.statusbar.enabled", type: "bool" },
        { id: "browser.statusbar.appendStatusText", type: "bool" },
        { id: "browser.bookmarks.toolbarposition", type: "string" },
      ],
    };
  },

  get containers() {
    return {
      tabPosition: [
        {
          tag: "label",
          attrs: {
            id: "tabPositionLabel",
          },
          adjacentTo: "browserContainersbox",
          position: "afterend",
        },
        {
          tag: "html:h2",
          attrs: {
            id: "tabPositionHeader",
            class: "extensiblesHeader",
            label: browser.i18n.getMessage("tabPositionHeader"),
          },
          adjacentTo: "tabPositionLabel",
          position: "afterbegin",
        },
        {
          tag: "vbox",
          attrs: {
            id: "tabPositionSettingsContainer",
          },
          adjacentTo: "tabPositionLabel",
          position: "afterend",
        },
        {
          tag: "radiogroup",
          attrs: {
            id: "tabPositionGroup",
            preference: "browser.tabs.toolbarposition",
          },
          adjacentTo: "tabPositionSettingsContainer",
          position: "afterbegin",
        },
      ],
      tabFeature: [
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
      ],
      restart: [
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
      ],
      status: [
        {
          tag: "groupbox",
          attrs: {
            id: "statusGroup",
            "data-category": "paneGeneral",
          },
          adjacentTo: "restartGroup",
          position: "afterend",
        },
        {
          tag: "label",
          attrs: {
            id: "statusFeatureLabel",
          },
          adjacentTo: "statusGroup",
          position: "beforeend",
        },
        {
          tag: "html:h2",
          attrs: {
            id: "statusFeatureHeader",
            class: "extensiblesHeader",
            label: browser.i18n.getMessage("statusHeader"),
          },
          adjacentTo: "statusFeatureLabel",
          position: "afterbegin",
        },
      ],
      bookmark: [
        {
          tag: "label",
          attrs: {
            id: "bookmarkPositionLabel",
          },
          adjacentTo: "statusGroup",
          position: "afterend",
        },
        {
          tag: "html:h2",
          attrs: {
            id: "bookmarkPositionHeader",
            class: "extensiblesHeader",
            label: browser.i18n.getMessage("bookmarkHeader"),
          },
          adjacentTo: "bookmarkPositionLabel",
          position: "afterbegin",
        },
        {
          tag: "vbox",
          attrs: {
            id: "bookmarkPositionSettingsContainer",
          },
          adjacentTo: "bookmarkPositionLabel",
          position: "afterend",
        },
        {
          tag: "radiogroup",
          attrs: {
            id: "bookmarkPositionGroup",
            preference: "browser.bookmarks.toolbarposition",
          },
          adjacentTo: "bookmarkPositionSettingsContainer",
          position: "afterbegin",
        },
      ],
    };
  },

  get toggles() {
    return {
      tabPosition: [
        {
          tag: "radio",
          attrs: {
            id: "tabBarTopAbove",
            value: "topabove",
            label: browser.i18n.getMessage("tabBarTopAbove"),
          },
          adjacentTo: "tabPositionGroup",
          position: "beforeend",
        },
        {
          tag: "radio",
          attrs: {
            id: "tabBarTopBelow",
            value: "topbelow",
            label: browser.i18n.getMessage("tabBarTopBelow"),
          },
          adjacentTo: "tabPositionGroup",
          position: "beforeend",
        },
        {
          tag: "radio",
          attrs: {
            id: "tabBarBottomAbove",
            value: "bottomabove",
            label: browser.i18n.getMessage("tabBarBottomAbove"),
          },
          adjacentTo: "tabPositionGroup",
          position: "beforeend",
        },
        {
          tag: "radio",
          attrs: {
            id: "tabBarBottomBelow",
            value: "bottombelow",
            label: browser.i18n.getMessage("tabBarBottomBelow"),
          },
          adjacentTo: "tabPositionGroup",
          position: "beforeend",
        },
      ],
      tabFeatures: [
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
      ],
      restart: [
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
      ],
      status: [
        {
          tag: "checkbox",
          attrs: {
            id: "showStatusBar",
            label: browser.i18n.getMessage("showStatusBar"),
            preference: "browser.statusbar.enabled",
          },
          adjacentTo: "statusGroup",
          position: "beforeend",
        },
        {
          tag: "checkbox",
          attrs: {
            id: "showStatusLinks",
            label: browser.i18n.getMessage("showStatusLinks"),
            preference: "browser.statusbar.appendStatusText",
          },
          adjacentTo: "statusGroup",
          position: "beforeend",
        },
      ],
      bookmark: [
        {
          tag: "radio",
          attrs: {
            id: "bookmarkBarTop",
            value: "top",
            label: browser.i18n.getMessage("bookmarkBarTop"),
          },
          adjacentTo: "bookmarkPositionGroup",
          position: "beforeend",
        },
        {
          tag: "radio",
          attrs: {
            id: "bookmarkBarBottom",
            value: "bottom",
            label: browser.i18n.getMessage("bookmarkBarBottom"),
          },
          adjacentTo: "bookmarkPositionGroup",
          position: "beforeend",
        },
      ],
    };
  },

  setStyle() {
    browser.extensibles.prefsext.setStyle();
  },

  async init() {
    // Register prefs that aren't created elsewhere
    this.registerPrefs(this.prefs);
    // Set additional styling reqs
    this.setStyle();
    // Render containers
    Object.values(this.containers).forEach(container => {
      container.forEach(item => {
        this.createAndPositionElement(item);
        if (item.attrs.label) {
          browser.extensibles.utils.append(item.attrs.id, item.attrs.label);
        }
      });
    });
    // Render checkboxes and radios
    Object.values(this.toggles).forEach(toggle => {
      toggle.forEach(item => {
        this.createAndPositionElement(item);
      });
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
