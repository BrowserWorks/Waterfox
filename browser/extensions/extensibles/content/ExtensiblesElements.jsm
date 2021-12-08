const EXPORTED_SYMBOLS = ["ExtensiblesElements"];

const ExtensiblesElements = {
  get elements() {
    return [
      {
        tag: "menuitem",
        attrs: {
          id: "openAllPrivate",
          "data-l10n-id": "open-all-private",
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand: "openAllPrivate(event);",
        },
        adjacentTo: "placesContext_openBookmarkContainer:tabs",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openAllLinksPrivate",
          "data-l10n-id": "open-all-links-private",
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand: "openAllPrivate(event);",
        },
        adjacentTo: "placesContext_openLinks:tabs",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openPrivate",
          "data-l10n-id": "open-private-tab",
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          oncommand: "openPrivateTab(event);",
        },
        adjacentTo: "placesContext_open:newtab",
        position: "afterend",
      },
      {
        tag: "keyset",
        attrs: {
          id: "privateTab-keyset",
        },
        adjacentTo: "mainKeyset",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "menu_newPrivateTab",
          "data-l10n-id": "new-private-tab",
          accesskey: "v",
          acceltext: "Ctrl+Alt+P", // TODO: change to key getter
          class: "menuitem-iconic privatetab-icon",
          oncommand: "browserOpenTabPrivate(window)",
        },
        adjacentTo: "menu_newNavigatorTab",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "openLinkInPrivateTab",
          "data-l10n-id": "open-link-private",
          accesskey: "v",
          class: "menuitem-iconic privatetab-icon",
          hidden: true,
        },
        adjacentTo: "context-openlinkintab",
        position: "afterend",
      },
      {
        tag: "menuitem",
        attrs: {
          id: "toggleTabPrivateState",
          "data-l10n-id": "private-tab",
          class: "menuitem-iconic privatetab-icon",
          accesskey: "v",
          acceltext: "Ctrl+Alt+T", // TODO: change to key getter
          oncommand: "togglePrivate(window, TabContextMenu.contextTab)",
        },
        adjacentTo: "context_pinTab",
        position: "afterend",
      },
      {
        tag: "toolbarbutton",
        attrs: {
          id: "newPrivateTab-button",
          "data-l10n-id": "new-private-tab",
          class: "toolbarbutton-1 chromeclass-toolbar-additional",
        },
        adjacentTo: "tabs-newtab-button",
        position: "afterend",
      },
    ];
  },

  get appendElements() {
    return [
      {
        tag: "key",
        attrs: {
          id: "togglePrivateTab-key",
          modifiers: "alt control",
          key: "T",
          oncommand: "togglePrivate(window)",
        },
        appendTo: "privateTab-keyset",
      },
      {
        tag: "key",
        attrs: {
          id: "newPrivateTab-key",
          modifiers: "alt control",
          key: "P",
          oncommand: "browserOpenTabPrivate(window)",
        },
        appendTo: "privateTab-keyset",
      },
    ];
  },

  get widgetAttrs() {
    return {
      id: "privateTab-button",
      label: "new-private-tab",
      class: "toolbarbutton-1 chromeclass-toolbar-additional",
      oncommand: "browserOpenTabPrivate(window)",
    };
  },

  get statusDummyBar() {
    return {
      tag: "toolbar",
      attrs: {
        id: "status-dummybar",
        toolbarname: "Status Bar",
        hidden: true,
      },
      appendTo: "gNavToolbox",
    };
  },

  get statusBarElements() {
    return {
      bar: {
        tag: "toolbar",
        attrs: {
          id: "status-bar",
          customizable: "true",
          context: "toolbar-context-menu",
          mode: "icons",
        },
      },
      item: {
        tag: "toolbaritem",
        attrs: {
          id: "status-text",
          flex: "1",
          width: "100",
        },
      },
    };
  },
};
