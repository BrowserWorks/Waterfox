/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

add_task(function* () {
  let tab1 = yield BrowserTestUtils.openNewForegroundTab(gBrowser,
    "http://mochi.test:8888/browser/browser/components/extensions/test/browser/context.html");

  let encodedImageData = "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAC4klEQVRYhdWXLWzbQBSADQtDAwsHC1tUhUxqfL67lk2tdn+OJg0ODU0rLByqgqINBY6tmlbn7LMTJ5FaFVVBk1G0oUGjG2jT2Y7jxmmcbU/6iJ+f36fz+e5sGP9riCGm9hB37RG+scd4Yo/wsDXCZyIE2xuXsce4bY+wXkAsQtzYmExrfFgvkJkRbkzo1ehoxx5iXcgI/9iYUGt8WH9MqDXEcmNChmEYrRCf2SHWeYgQx3x0tLNRIeKQLTtEFyJEep4NTuhk8BC+yMrwEE3+iozo42d8gK7FAOkMsRiiN8QhW2ttSK5QTfRRV4QoymVeJMvPvDp7gCZigD613MN6yRFA3SWarow9QB9LCfG+NeF9qCtjAKOSQjCqVKhfVsiHEQ+grgx/lRGqUihAc1uL8EFD+KCRO+GrF4J61phcoRoPoEzkYhZYpykh5sMb7kOdIeY+jHKur4QI4Feh4AFX1nVeLxrAvQchGsBz5ls6wa2QdwcvIcE2863bTH79KOvsz/uUYJsp+J0pSzNlDckVqqVGUAF+n6uS7txcOl6wot4JVy70ufDLy4pWLUQVPE81pRI0mGe9oxLMHSeohHvMs/STUNaUK6vDPCvOyxMFDx4achehRDJmHnydnkPww5OFfLxrGIZBFDyYl4LpMzlTQFIP6AQx86w2UeYBccFpJrcKv5L9eGDtUAU6RIELqsB74uynjy/UBRF1gS5BTFxwQT1wTiXoUg9MH7m/3NZRRoi5IJytUbMgzv4Wc832+oQkiKgEehmyMkkpKsFkQV11QsRJL5rJYBLItQgRaUZEmnoZXsomz3vGiWw+I9KMF9SVFOqZEemZekli1jN3U/UOqhHHvC6oWWGElhfSpGdOk6+O9prdwvtLj5BjRsQxdRnot+Zeifpy/2/0stktKTRNLmbk0mwXyl8253fyojj+8rxOHNAhjjm5n0/5OOCGOKBzkrMO0Z75lvSAzKlrF32Z/3z8BqLAn+yMV7VhAAAAAElFTkSuQmCC";
  let decodedImageData = atob(encodedImageData);
  const IMAGE_ARRAYBUFFER = Uint8Array.from(decodedImageData, byte => byte.charCodeAt(0)).buffer;

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["contextMenus"],
      "icons": {
        "18": "extension.png",
      },
    },

    files: {
      "extension.png": IMAGE_ARRAYBUFFER,
    },

    background: function() {
      let menuitemId = browser.contextMenus.create({
        title: "child-to-delete",
        onclick: () => {
          browser.contextMenus.remove(menuitemId);
        },
      });

      browser.contextMenus.create({
        title: "child",
      });

      browser.test.onMessage.addListener(() => {
        browser.test.sendMessage("pong");
      });
      browser.test.notifyPass("contextmenus-icons");
    },
  });

  let confirmContextMenuIcon = (rootElement) => {
    let expectedURL = new RegExp(String.raw`^moz-extension://[^/]+/extension\.png$`);
    let imageUrl = rootElement.getAttribute("image");
    ok(expectedURL.test(imageUrl), "The context menu should display the extension icon next to the root element");
  };

  yield extension.startup();
  yield extension.awaitFinish("contextmenus-icons");

  let extensionMenu = yield openExtensionContextMenu();

  let contextMenu = document.getElementById("contentAreaContextMenu");
  let topLevelMenuItem = contextMenu.getElementsByAttribute("ext-type", "top-level-menu")[0];
  confirmContextMenuIcon(topLevelMenuItem);

  let childToDelete = extensionMenu.getElementsByAttribute("label", "child-to-delete")[0];
  yield closeExtensionContextMenu(childToDelete);
  // Now perform a roundtrip to the extension process to make sure that the
  // click event has had a chance to fire.
  extension.sendMessage("ping");
  yield extension.awaitMessage("pong");

  yield openExtensionContextMenu();

  contextMenu = document.getElementById("contentAreaContextMenu");
  topLevelMenuItem = contextMenu.getElementsByAttribute("label", "child")[0];

  confirmContextMenuIcon(topLevelMenuItem);
  yield closeContextMenu();

  yield extension.unload();
  yield BrowserTestUtils.removeTab(tab1);
});
