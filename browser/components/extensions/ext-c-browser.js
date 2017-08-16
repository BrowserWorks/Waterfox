"use strict";

extensions.registerModules({
  devtools: {
    url: "chrome://browser/content/ext-c-devtools.js",
    scopes: ["devtools_child"],
    paths: [
      ["devtools"],
    ],
  },
  devtools_inspectedWindow: {
    url: "chrome://browser/content/ext-c-devtools-inspectedWindow.js",
    scopes: ["devtools_child"],
    paths: [
      ["devtools", "inspectedWindow"],
    ],
  },
  devtools_panels: {
    url: "chrome://browser/content/ext-c-devtools-panels.js",
    scopes: ["devtools_child"],
    paths: [
      ["devtools", "panels"],
    ],
  },
  // Because of permissions, the module name must differ from both namespaces.
  menusInternal: {
    url: "chrome://browser/content/ext-c-menus.js",
    scopes: ["addon_child"],
    paths: [
      ["contextMenus"],
      ["menus"],
    ],
  },
  omnibox: {
    url: "chrome://browser/content/ext-c-omnibox.js",
    scopes: ["addon_child"],
    paths: [
      ["omnibox"],
    ],
  },
  tabs: {
    url: "chrome://browser/content/ext-c-tabs.js",
    scopes: ["addon_child"],
    paths: [
      ["tabs"],
    ],
  },
});
