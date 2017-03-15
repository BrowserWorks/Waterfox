/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

const PAGE = "http://mochi.test:8888/browser/browser/components/extensions/test/browser/context.html";

add_task(function* () {
  let tab1 = yield BrowserTestUtils.openNewForegroundTab(gBrowser, PAGE);

  gBrowser.selectedTab = tab1;

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["contextMenus"],
    },

    background: function() {
      browser.contextMenus.create({
        id: "clickme-image",
        title: "Click me!",
        contexts: ["image"],
      });
      browser.contextMenus.create({
        id: "clickme-page",
        title: "Click me!",
        contexts: ["page"],
      });
      browser.test.notifyPass();
    },
  });

  yield extension.startup();
  yield extension.awaitFinish();

  let contentAreaContextMenu = yield openContextMenu("#img1");
  let item = contentAreaContextMenu.getElementsByAttribute("label", "Click me!");
  is(item.length, 1, "contextMenu item for image was found");
  yield closeContextMenu();

  contentAreaContextMenu = yield openContextMenu("body");
  item = contentAreaContextMenu.getElementsByAttribute("label", "Click me!");
  is(item.length, 1, "contextMenu item for page was found");
  yield closeContextMenu();

  yield extension.unload();

  yield BrowserTestUtils.removeTab(tab1);
});

add_task(function* () {
  let tab1 = yield BrowserTestUtils.openNewForegroundTab(gBrowser, PAGE);

  gBrowser.selectedTab = tab1;

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["contextMenus"],
    },

    background: async function() {
      // A generic onclick callback function.
      function genericOnClick(info, tab) {
        browser.test.sendMessage("onclick", {info, tab});
      }

      browser.contextMenus.onClicked.addListener((info, tab) => {
        browser.test.sendMessage("browser.contextMenus.onClicked", {info, tab});
      });

      browser.contextMenus.create({
        contexts: ["all"],
        type: "separator",
      });

      let contexts = ["page", "selection", "image", "editable"];
      for (let i = 0; i < contexts.length; i++) {
        let context = contexts[i];
        let title = context;
        browser.contextMenus.create({
          title: title,
          contexts: [context],
          id: "ext-" + context,
          onclick: genericOnClick,
        });
        if (context == "selection") {
          browser.contextMenus.update("ext-selection", {
            title: "selection is: '%s'",
            onclick: (info, tab) => {
              browser.contextMenus.removeAll();
              genericOnClick(info, tab);
            },
          });
        }
      }

      let parent = browser.contextMenus.create({
        title: "parent",
      });
      browser.contextMenus.create({
        title: "child1",
        parentId: parent,
        onclick: genericOnClick,
      });
      let child2 = browser.contextMenus.create({
        title: "child2",
        parentId: parent,
        onclick: genericOnClick,
      });

      let parentToDel = browser.contextMenus.create({
        title: "parentToDel",
      });
      browser.contextMenus.create({
        title: "child1",
        parentId: parentToDel,
        onclick: genericOnClick,
      });
      browser.contextMenus.create({
        title: "child2",
        parentId: parentToDel,
        onclick: genericOnClick,
      });
      browser.contextMenus.remove(parentToDel);

      browser.contextMenus.create({
        title: "Without onclick property",
        id: "ext-without-onclick",
      });

      await browser.test.assertRejects(
        browser.contextMenus.update(parent, {parentId: child2}),
        /cannot be an ancestor/,
        "Should not be able to reparent an item as descendent of itself");

      browser.test.notifyPass("contextmenus");
    },
  });

  yield extension.startup();
  yield extension.awaitFinish("contextmenus");

  let expectedClickInfo = {
    menuItemId: "ext-image",
    mediaType: "image",
    srcUrl: "http://mochi.test:8888/browser/browser/components/extensions/test/browser/ctxmenu-image.png",
    pageUrl: PAGE,
    editable: false,
  };

  function checkClickInfo(result) {
    for (let i of Object.keys(expectedClickInfo)) {
      is(result.info[i], expectedClickInfo[i],
         "click info " + i + " expected to be: " + expectedClickInfo[i] + " but was: " + result.info[i]);
    }
    is(expectedClickInfo.pageSrc, result.tab.url, "click info page source is the right tab");
  }

  let extensionMenuRoot = yield openExtensionContextMenu();

  // Check some menu items
  let items = extensionMenuRoot.getElementsByAttribute("label", "image");
  is(items.length, 1, "contextMenu item for image was found (context=image)");
  let image = items[0];

  items = extensionMenuRoot.getElementsByAttribute("label", "selection-edited");
  is(items.length, 0, "contextMenu item for selection was not found (context=image)");

  items = extensionMenuRoot.getElementsByAttribute("label", "parentToDel");
  is(items.length, 0, "contextMenu item for removed parent was not found (context=image)");

  items = extensionMenuRoot.getElementsByAttribute("label", "parent");
  is(items.length, 1, "contextMenu item for parent was found (context=image)");

  is(items[0].childNodes[0].childNodes.length, 2, "child items for parent were found (context=image)");

  // Click on ext-image item and check the click results
  yield closeExtensionContextMenu(image);

  let result = yield extension.awaitMessage("onclick");
  checkClickInfo(result);
  result = yield extension.awaitMessage("browser.contextMenus.onClicked");
  checkClickInfo(result);


  // Test "editable" context and OnClick data property.
  extensionMenuRoot = yield openExtensionContextMenu("#edit-me");

  // Check some menu items.
  items = extensionMenuRoot.getElementsByAttribute("label", "editable");
  is(items.length, 1, "contextMenu item for text input element was found (context=editable)");
  let editable = items[0];

  // Click on ext-editable item and check the click results.
  yield closeExtensionContextMenu(editable);

  expectedClickInfo = {
    menuItemId: "ext-editable",
    pageUrl: PAGE,
    editable: true,
  };

  result = yield extension.awaitMessage("onclick");
  checkClickInfo(result);
  result = yield extension.awaitMessage("browser.contextMenus.onClicked");
  checkClickInfo(result);


  // Select some text
  yield ContentTask.spawn(gBrowser.selectedBrowser, { }, function* (arg) {
    let doc = content.document;
    let range = doc.createRange();
    let selection = content.getSelection();
    selection.removeAllRanges();
    let textNode = doc.getElementById("img1").previousSibling;
    range.setStart(textNode, 0);
    range.setEnd(textNode, 100);
    selection.addRange(range);
  });

  // Bring up context menu again
  extensionMenuRoot = yield openExtensionContextMenu();

  // Check some menu items
  items = extensionMenuRoot.getElementsByAttribute("label", "Without onclick property");
  is(items.length, 1, "contextMenu item was found (context=page)");

  yield closeExtensionContextMenu(items[0]);

  expectedClickInfo = {
    menuItemId: "ext-without-onclick",
    pageUrl: PAGE,
  };

  result = yield extension.awaitMessage("browser.contextMenus.onClicked");
  checkClickInfo(result);

  // Bring up context menu again
  extensionMenuRoot = yield openExtensionContextMenu();

  // Check some menu items
  items = extensionMenuRoot.getElementsByAttribute("label", "selection is: 'just some text 123456789012345678901234567890...'");
  is(items.length, 1, "contextMenu item for selection was found (context=selection)");
  let selectionItem = items[0];

  items = extensionMenuRoot.getElementsByAttribute("label", "selection");
  is(items.length, 0, "contextMenu item label update worked (context=selection)");

  yield closeExtensionContextMenu(selectionItem);

  expectedClickInfo = {
    menuItemId: "ext-selection",
    pageUrl: PAGE,
    selectionText: "just some text 1234567890123456789012345678901234567890123456789012345678901234567890123456789012",
  };

  result = yield extension.awaitMessage("onclick");
  checkClickInfo(result);
  result = yield extension.awaitMessage("browser.contextMenus.onClicked");
  checkClickInfo(result);

  let contentAreaContextMenu = yield openContextMenu("#img1");
  items = contentAreaContextMenu.getElementsByAttribute("ext-type", "top-level-menu");
  is(items.length, 0, "top level item was not found (after removeAll()");
  yield closeContextMenu();

  yield extension.unload();
  yield BrowserTestUtils.removeTab(tab1);
});

add_task(function* testRemoveAllWithTwoExtensions() {
  const tab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, PAGE);
  const manifest = {permissions: ["contextMenus"]};

  const first = ExtensionTestUtils.loadExtension({manifest, background() {
    browser.contextMenus.create({title: "alpha", contexts: ["all"]});

    browser.contextMenus.onClicked.addListener(() => {
      browser.contextMenus.removeAll();
    });
    browser.test.onMessage.addListener(msg => {
      if (msg == "ping") {
        browser.test.sendMessage("pong-alpha");
        return;
      }
      browser.contextMenus.create({title: "gamma", contexts: ["all"]});
    });
  }});

  const second = ExtensionTestUtils.loadExtension({manifest, background() {
    browser.contextMenus.create({title: "beta", contexts: ["all"]});

    browser.contextMenus.onClicked.addListener(() => {
      browser.contextMenus.removeAll();
    });

    browser.test.onMessage.addListener(() => {
      browser.test.sendMessage("pong-beta");
    });
  }});

  yield first.startup();
  yield second.startup();

  function* confirmMenuItems(...items) {
    // Round-trip to extension to make sure that the context menu state has been
    // updated by the async contextMenus.create / contextMenus.removeAll calls.
    first.sendMessage("ping");
    second.sendMessage("ping");
    yield first.awaitMessage("pong-alpha");
    yield second.awaitMessage("pong-beta");

    const menu = yield openContextMenu();
    for (const id of ["alpha", "beta", "gamma"]) {
      const expected = items.includes(id);
      const found = menu.getElementsByAttribute("label", id);
      is(found.length, expected, `menu item ${id} ${expected ? "" : "not "}found`);
    }
    // Return the first menu item, we need to click it.
    return menu.getElementsByAttribute("label", items[0])[0];
  }

  // Confirm alpha, beta exist; click alpha to remove it.
  const alpha = yield confirmMenuItems("alpha", "beta");
  yield closeExtensionContextMenu(alpha);

  // Confirm only beta exists.
  yield confirmMenuItems("beta");
  yield closeContextMenu();

  // Create gamma, confirm, click.
  first.sendMessage("create");
  const beta = yield confirmMenuItems("beta", "gamma");
  yield closeExtensionContextMenu(beta);

  // Confirm only gamma is left.
  yield confirmMenuItems("gamma");
  yield closeContextMenu();

  yield first.unload();
  yield second.unload();
  yield BrowserTestUtils.removeTab(tab);
});
