function* importFromFixture(fixture, replace) {
  let cwd = yield OS.File.getCurrentDirectory();
  let path = OS.Path.join(cwd, fixture);

  do_print(`Importing from ${path}`);
  yield BookmarkJSONUtils.importFromFile(path, replace);
  yield PlacesTestUtils.promiseAsyncUpdates();
}

function* treeEquals(guid, expected, message) {
  let root = yield PlacesUtils.promiseBookmarksTree(guid);
  let bookmarks = (function nodeToEntry(node) {
    let entry = { guid: node.guid, index: node.index }
    if (node.children) {
      entry.children = node.children.map(nodeToEntry);
    }
    if (node.annos) {
      entry.annos = node.annos;
    }
    return entry;
  }(root));

  do_print(`Checking if ${guid} tree matches ${JSON.stringify(expected)}`);
  do_print(`Got bookmarks tree for ${guid}: ${JSON.stringify(bookmarks)}`);

  deepEqual(bookmarks, expected, message);
}

add_task(function* test_restore_mobile_bookmarks_root() {
  yield* importFromFixture("mobile_bookmarks_root_import.json",
                           /* replace */ true);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "X6lUyOspVYwi", index: 0 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "_o8e1_zxTJFg", index: 0 },
        { guid: "QCtSqkVYUbXB", index: 1 },
      ],
    }],
  }, "Should restore mobile bookmarks from root");

  yield PlacesUtils.bookmarks.eraseEverything();
});

add_task(function* test_import_mobile_bookmarks_root() {
  yield* importFromFixture("mobile_bookmarks_root_import.json",
                           /* replace */ false);
  yield* importFromFixture("mobile_bookmarks_root_merge.json",
                           /* replace */ false);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "Utodo9b0oVws", index: 0 },
        { guid: "X6lUyOspVYwi", index: 1 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "a17yW6-nTxEJ", index: 0 },
        { guid: "xV10h9Wi3FBM", index: 1 },
        { guid: "_o8e1_zxTJFg", index: 2 },
        { guid: "QCtSqkVYUbXB", index: 3 },
      ],
    }],
  }, "Should merge bookmarks root contents");

  yield PlacesUtils.bookmarks.eraseEverything();
});

add_task(function* test_restore_mobile_bookmarks_folder() {
  yield* importFromFixture("mobile_bookmarks_folder_import.json",
                           /* replace */ true);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "X6lUyOspVYwi", index: 0 },
        { guid: "XF4yRP6bTuil", index: 1 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
      children: [{ guid: "buy7711R3ZgE", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
      children: [{ guid: "KIa9iKZab2Z5", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "_o8e1_zxTJFg", index: 0 },
        { guid: "QCtSqkVYUbXB", index: 1 },
      ],
    }],
  }, "Should restore mobile bookmark folder contents into mobile root");

  // We rewrite queries to point to the root ID instead of the name
  // ("MOBILE_BOOKMARKS") so that we don't break them if the user downgrades
  // to an earlier release channel. This can be removed along with the anno in
  // bug 1306445.
  let queryById = yield PlacesUtils.bookmarks.fetch("XF4yRP6bTuil");
  equal(queryById.url.href, "place:folder=" + PlacesUtils.mobileFolderId,
    "Should rewrite mobile query to point to root ID");

  yield PlacesUtils.bookmarks.eraseEverything();
});

add_task(function* test_import_mobile_bookmarks_folder() {
  yield* importFromFixture("mobile_bookmarks_folder_import.json",
                           /* replace */ false);
  yield* importFromFixture("mobile_bookmarks_folder_merge.json",
                           /* replace */ false);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "Utodo9b0oVws", index: 0 },
        { guid: "X6lUyOspVYwi", index: 1 },
        { guid: "XF4yRP6bTuil", index: 2 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
      children: [{ guid: "buy7711R3ZgE", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
      children: [{ guid: "KIa9iKZab2Z5", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "a17yW6-nTxEJ", index: 0 },
        { guid: "xV10h9Wi3FBM", index: 1 },
        { guid: "_o8e1_zxTJFg", index: 2 },
        { guid: "QCtSqkVYUbXB", index: 3 },
      ],
    }],
  }, "Should merge bookmarks folder contents into mobile root");

  yield PlacesUtils.bookmarks.eraseEverything();
});

add_task(function* test_restore_multiple_bookmarks_folders() {
  yield* importFromFixture("mobile_bookmarks_multiple_folders.json",
                           /* replace */ true);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "buy7711R3ZgE", index: 0 },
        { guid: "F_LBgd1fS_uQ", index: 1 },
        { guid: "oIpmQXMWsXvY", index: 2 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
      children: [{ guid: "Utodo9b0oVws", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
      children: [{ guid: "xV10h9Wi3FBM", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "sSZ86WT9WbN3", index: 0 },
        { guid: "a17yW6-nTxEJ", index: 1 },
      ],
    }],
  }, "Should restore multiple bookmarks folder contents into root");

  yield PlacesUtils.bookmarks.eraseEverything();
});

add_task(function* test_import_multiple_bookmarks_folders() {
  yield* importFromFixture("mobile_bookmarks_root_import.json",
                           /* replace */ false);
  yield* importFromFixture("mobile_bookmarks_multiple_folders.json",
                           /* replace */ false);

  yield* treeEquals(PlacesUtils.bookmarks.rootGuid, {
    guid: PlacesUtils.bookmarks.rootGuid,
    index: 0,
    children: [{
      guid: PlacesUtils.bookmarks.menuGuid,
      index: 0,
      children: [
        { guid: "buy7711R3ZgE", index: 0 },
        { guid: "F_LBgd1fS_uQ", index: 1 },
        { guid: "oIpmQXMWsXvY", index: 2 },
        { guid: "X6lUyOspVYwi", index: 3 },
      ],
    }, {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      index: 1,
      children: [{ guid: "Utodo9b0oVws", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.unfiledGuid,
      index: 3,
      children: [{ guid: "xV10h9Wi3FBM", index: 0 }],
    }, {
      guid: PlacesUtils.bookmarks.mobileGuid,
      index: 4,
      annos: [{
        name: "mobile/bookmarksRoot",
        flags: 0,
        expires: 4,
        value: 1,
      }],
      children: [
        { guid: "sSZ86WT9WbN3", index: 0 },
        { guid: "a17yW6-nTxEJ", index: 1 },
        { guid: "_o8e1_zxTJFg", index: 2 },
        { guid: "QCtSqkVYUbXB", index: 3 },
      ],
    }],
  }, "Should merge multiple mobile folders into root");

  yield PlacesUtils.bookmarks.eraseEverything();
});
