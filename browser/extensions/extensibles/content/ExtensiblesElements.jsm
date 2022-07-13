const EXPORTED_SYMBOLS = ["ExtensiblesElements"];

const ExtensiblesElements = {
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
