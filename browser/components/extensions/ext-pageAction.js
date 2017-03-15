/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

Cu.import("resource://gre/modules/Task.jsm");
Cu.import("resource://gre/modules/ExtensionUtils.jsm");
var {
  EventManager,
  IconDetails,
} = ExtensionUtils;

// WeakMap[Extension -> PageAction]
var pageActionMap = new WeakMap();

// Handles URL bar icons, including the |page_action| manifest entry
// and associated API.
function PageAction(options, extension) {
  this.extension = extension;
  this.id = makeWidgetId(extension.id) + "-page-action";

  this.tabManager = TabManager.for(extension);

  this.defaults = {
    show: false,
    title: options.default_title || extension.name,
    icon: IconDetails.normalize({path: options.default_icon}, extension),
    popup: options.default_popup || "",
  };

  this.browserStyle = options.browser_style || false;
  if (options.browser_style === null) {
    this.extension.logger.warn("Please specify whether you want browser_style " +
                               "or not in your page_action options.");
  }

  this.tabContext = new TabContext(tab => Object.create(this.defaults),
                                   extension);

  this.tabContext.on("location-change", this.handleLocationChange.bind(this)); // eslint-disable-line mozilla/balanced-listeners

  // WeakMap[ChromeWindow -> <xul:image>]
  this.buttons = new WeakMap();

  EventEmitter.decorate(this);
}

PageAction.prototype = {
  // Returns the value of the property |prop| for the given tab, where
  // |prop| is one of "show", "title", "icon", "popup".
  getProperty(tab, prop) {
    return this.tabContext.get(tab)[prop];
  },

  // Sets the value of the property |prop| for the given tab to the
  // given value, symmetrically to |getProperty|.
  //
  // If |tab| is currently selected, updates the page action button to
  // reflect the new value.
  setProperty(tab, prop, value) {
    if (value != null) {
      this.tabContext.get(tab)[prop] = value;
    } else {
      delete this.tabContext.get(tab)[prop];
    }

    if (tab.selected) {
      this.updateButton(tab.ownerGlobal);
    }
  },

  // Updates the page action button in the given window to reflect the
  // properties of the currently selected tab:
  //
  // Updates "tooltiptext" and "aria-label" to match "title" property.
  // Updates "image" to match the "icon" property.
  // Shows or hides the icon, based on the "show" property.
  updateButton(window) {
    let tabData = this.tabContext.get(window.gBrowser.selectedTab);

    if (!(tabData.show || this.buttons.has(window))) {
      // Don't bother creating a button for a window until it actually
      // needs to be shown.
      return;
    }

    let button = this.getButton(window);

    if (tabData.show) {
      // Update the title and icon only if the button is visible.

      let title = tabData.title || this.extension.name;
      button.setAttribute("tooltiptext", title);
      button.setAttribute("aria-label", title);

      // These URLs should already be properly escaped, but make doubly sure CSS
      // string escape characters are escaped here, since they could lead to a
      // sandbox break.
      let escape = str => str.replace(/[\\\s"]/g, encodeURIComponent);

      let getIcon = size => escape(IconDetails.getPreferredIcon(tabData.icon, this.extension, size).icon);

      button.setAttribute("style", `
        --webextension-urlbar-image: url("${getIcon(16)}");
        --webextension-urlbar-image-2x: url("${getIcon(32)}");
      `);

      button.classList.add("webextension-page-action");
    }

    button.hidden = !tabData.show;
  },

  // Create an |image| node and add it to the |urlbar-icons|
  // container in the given window.
  addButton(window) {
    let document = window.document;

    let button = document.createElement("image");
    button.id = this.id;
    button.setAttribute("class", "urlbar-icon");

    button.addEventListener("click", event => { // eslint-disable-line mozilla/balanced-listeners
      if (event.button == 0) {
        this.handleClick(window);
      }
    });

    document.getElementById("urlbar-icons").appendChild(button);

    return button;
  },

  // Returns the page action button for the given window, creating it if
  // it doesn't already exist.
  getButton(window) {
    if (!this.buttons.has(window)) {
      let button = this.addButton(window);
      this.buttons.set(window, button);
    }

    return this.buttons.get(window);
  },

  /**
   * Triggers this page action for the given window, with the same effects as
   * if it were clicked by a user.
   *
   * This has no effect if the page action is hidden for the selected tab.
   *
   * @param {Window} window
   */
  triggerAction(window) {
    let pageAction = pageActionMap.get(this.extension);
    if (pageAction.getProperty(window.gBrowser.selectedTab, "show")) {
      pageAction.handleClick(window);
    }
  },

  // Handles a click event on the page action button for the given
  // window.
  // If the page action has a |popup| property, a panel is opened to
  // that URL. Otherwise, a "click" event is emitted, and dispatched to
  // the any click listeners in the add-on.
  handleClick(window) {
    let tab = window.gBrowser.selectedTab;
    let popupURL = this.tabContext.get(tab).popup;

    this.tabManager.addActiveTabPermission(tab);

    // If the widget has a popup URL defined, we open a popup, but do not
    // dispatch a click event to the extension.
    // If it has no popup URL defined, we dispatch a click event, but do not
    // open a popup.
    if (popupURL) {
      new PanelPopup(this.extension, this.getButton(window), popupURL,
                     this.browserStyle);
    } else {
      this.emit("click", tab);
    }
  },

  handleLocationChange(eventType, tab, fromBrowse) {
    if (fromBrowse) {
      this.tabContext.clear(tab);
    }
    this.updateButton(tab.ownerGlobal);
  },

  shutdown() {
    this.tabContext.shutdown();

    for (let window of WindowListManager.browserWindows()) {
      if (this.buttons.has(window)) {
        this.buttons.get(window).remove();
      }
    }
  },
};

/* eslint-disable mozilla/balanced-listeners */
extensions.on("manifest_page_action", (type, directive, extension, manifest) => {
  let pageAction = new PageAction(manifest.page_action, extension);
  pageActionMap.set(extension, pageAction);
});

extensions.on("shutdown", (type, extension) => {
  if (pageActionMap.has(extension)) {
    pageActionMap.get(extension).shutdown();
    pageActionMap.delete(extension);
  }
});
/* eslint-enable mozilla/balanced-listeners */

PageAction.for = extension => {
  return pageActionMap.get(extension);
};

global.pageActionFor = PageAction.for;

extensions.registerSchemaAPI("pageAction", "addon_parent", context => {
  let {extension} = context;
  return {
    pageAction: {
      onClicked: new EventManager(context, "pageAction.onClicked", fire => {
        let listener = (evt, tab) => {
          fire(TabManager.convert(extension, tab));
        };
        let pageAction = PageAction.for(extension);

        pageAction.on("click", listener);
        return () => {
          pageAction.off("click", listener);
        };
      }).api(),

      show(tabId) {
        let tab = TabManager.getTab(tabId, context);
        PageAction.for(extension).setProperty(tab, "show", true);
      },

      hide(tabId) {
        let tab = TabManager.getTab(tabId, context);
        PageAction.for(extension).setProperty(tab, "show", false);
      },

      setTitle(details) {
        let tab = TabManager.getTab(details.tabId, context);

        // Clear the tab-specific title when given a null string.
        PageAction.for(extension).setProperty(tab, "title", details.title || null);
      },

      getTitle(details) {
        let tab = TabManager.getTab(details.tabId, context);

        let title = PageAction.for(extension).getProperty(tab, "title");
        return Promise.resolve(title);
      },

      setIcon(details) {
        let tab = TabManager.getTab(details.tabId, context);

        let icon = IconDetails.normalize(details, extension, context);
        PageAction.for(extension).setProperty(tab, "icon", icon);
      },

      setPopup(details) {
        let tab = TabManager.getTab(details.tabId, context);

        // Note: Chrome resolves arguments to setIcon relative to the calling
        // context, but resolves arguments to setPopup relative to the extension
        // root.
        // For internal consistency, we currently resolve both relative to the
        // calling context.
        let url = details.popup && context.uri.resolve(details.popup);
        PageAction.for(extension).setProperty(tab, "popup", url);
      },

      getPopup(details) {
        let tab = TabManager.getTab(details.tabId, context);

        let popup = PageAction.for(extension).getProperty(tab, "popup");
        return Promise.resolve(popup);
      },
    },
  };
});
