/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

async function check_has_child(aParentGuid, aChildGuid) {
  let parentTree = await PlacesUtils.promiseBookmarksTree(aParentGuid);
  Assert.ok("children" in parentTree);
  Assert.notEqual(parentTree.children.find( e => e.guid == aChildGuid ), null);
}

async function compareToNode(aItem, aNode, aIsRootItem, aExcludedGuids = []) {
  // itemId==-1 indicates a non-bookmark node, which is unexpected.
  Assert.notEqual(aNode.itemId, -1);

  function check_unset(...aProps) {
    for (let p of aProps) {
      if (p in aItem) {
        Assert.ok(false, `Unexpected property ${p} with value ${aItem[p]}`);
      }
    }
  }

  function compare_prop(aItemProp, aNodeProp = aItemProp, aOptional = false) {
    if (aOptional && aNode[aNodeProp] === null)
      check_unset(aItemProp);
    else
      Assert.strictEqual(aItem[aItemProp], aNode[aNodeProp]);
  }

  // Bug 1013053 - bookmarkIndex is unavailable for the query's root
  if (aNode.bookmarkIndex == -1)
    Assert.strictEqual(aItem.index, PlacesUtils.bookmarks.getItemIndex(aNode.itemId));
  else
    compare_prop("index", "bookmarkIndex");

  compare_prop("dateAdded");
  compare_prop("lastModified");

  if (aIsRootItem && aNode.itemId != PlacesUtils.placesRootId) {
    Assert.ok("parentGuid" in aItem);
    await check_has_child(aItem.parentGuid, aItem.guid)
  } else {
    check_unset("parentGuid");
  }

  let expectedAnnos = PlacesUtils.getAnnotationsForItem(aItem.id);
  if (expectedAnnos.length > 0)
    Assert.deepEqual(aItem.annos, expectedAnnos);
  else
    check_unset("annos");

  const BOOKMARK_ONLY_PROPS = ["uri", "iconuri", "tags", "charset", "keyword"];
  const FOLDER_ONLY_PROPS = ["children", "root"];

  let nodesCount = 1;

  switch (aNode.type) {
    case Ci.nsINavHistoryResultNode.RESULT_TYPE_FOLDER:
      Assert.equal(aItem.type, PlacesUtils.TYPE_X_MOZ_PLACE_CONTAINER);
      compare_prop("title", "title", true);
      check_unset(...BOOKMARK_ONLY_PROPS);

      let expectedChildrenNodes = [];

      PlacesUtils.asContainer(aNode);
      if (!aNode.containerOpen)
        aNode.containerOpen = true;

      for (let i = 0; i < aNode.childCount; i++) {
        let childNode = aNode.getChild(i);
        if (childNode.itemId == PlacesUtils.tagsFolderId ||
            aExcludedGuids.includes(childNode.bookmarkGuid)) {
          continue;
        }
        expectedChildrenNodes.push(childNode);
      }

      if (expectedChildrenNodes.length > 0) {
        Assert.ok(Array.isArray(aItem.children));
        Assert.equal(aItem.children.length, expectedChildrenNodes.length);
        for (let i = 0; i < aItem.children.length; i++) {
          nodesCount +=
            await compareToNode(aItem.children[i], expectedChildrenNodes[i],
                                false, aExcludedGuids);
        }
      } else {
        check_unset("children");
      }

      let rootName = mapItemIdToInternalRootName(aItem.id);
      if (rootName)
        Assert.equal(aItem.root, rootName);
      else
        check_unset("root");
      break;
    case Ci.nsINavHistoryResultNode.RESULT_TYPE_SEPARATOR:
      Assert.equal(aItem.type, PlacesUtils.TYPE_X_MOZ_PLACE_SEPARATOR);
      check_unset(...BOOKMARK_ONLY_PROPS, ...FOLDER_ONLY_PROPS);
      break;
    default:
      Assert.equal(aItem.type, PlacesUtils.TYPE_X_MOZ_PLACE);
      compare_prop("uri");
      // node.tags's format is "a, b" whilst promiseBoookmarksTree is "a,b"
      if (aNode.tags === null)
        check_unset("tags");
      else
        Assert.equal(aItem.tags, aNode.tags.replace(/, /g, ","));

      if (aNode.icon) {
        try {
          await compareFavicons(aNode.icon, aItem.iconuri);
        } catch (ex) {
          do_print(ex);
          todo_check_true(false);
        }
      } else {
        check_unset(aItem.iconuri);
      }

      check_unset(...FOLDER_ONLY_PROPS);

      let itemURI = uri(aNode.uri);
      let expectedCharset = await PlacesUtils.getCharsetForURI(itemURI);
      if (expectedCharset)
        Assert.equal(aItem.charset, expectedCharset);
      else
        check_unset("charset");

      let entry = await PlacesUtils.keywords.fetch({ url: aNode.uri });
      if (entry)
        Assert.equal(aItem.keyword, entry.keyword);
      else
        check_unset("keyword");

      if ("title" in aItem)
        compare_prop("title");
      else
        do_check_null(aNode.title);
  }

  if (aIsRootItem)
    Assert.strictEqual(aItem.itemsCount, nodesCount);

  return nodesCount;
}

var itemsCount = 0;
async function new_bookmark(aInfo) {
  ++itemsCount;
  if (!("url" in aInfo))
    aInfo.url = uri("http://test.item." + itemsCount);

  if (!("title" in aInfo))
    aInfo.title = "Test Item (bookmark) " + itemsCount;

  await PlacesTransactions.NewBookmark(aInfo).transact();
}

async function new_folder(aInfo) {
  if (!("title" in aInfo))
    aInfo.title = "Test Item (folder) " + itemsCount;
  return await PlacesTransactions.NewFolder(aInfo).transact();
}

// Walks a result nodes tree and test promiseBookmarksTree for each node.
// DO NOT COPY THIS LOGIC:  It is done here to accomplish a more comprehensive
// test of the API (the entire hierarchy data is available in the very test).
async function test_promiseBookmarksTreeForEachNode(aNode, aOptions, aExcludedGuids) {
  Assert.ok(aNode.bookmarkGuid && aNode.bookmarkGuid.length > 0);
  let item = await PlacesUtils.promiseBookmarksTree(aNode.bookmarkGuid, aOptions);
  await compareToNode(item, aNode, true, aExcludedGuids);

  if (!PlacesUtils.nodeIsContainer(aNode)) {
    return item;
  }

  for (let i = 0; i < aNode.childCount; i++) {
    let child = aNode.getChild(i);
    if (child.itemId != PlacesUtils.tagsFolderId)
      await test_promiseBookmarksTreeForEachNode(child,
                                                 { includeItemIds: true },
                                                 aExcludedGuids);
  }
  return item;
}

async function test_promiseBookmarksTreeAgainstResult(aItemGuid = "",
                                                 aOptions = { includeItemIds: true },
                                                 aExcludedGuids) {
  let itemId = aItemGuid ?
    await PlacesUtils.promiseItemId(aItemGuid) : PlacesUtils.placesRootId;
  let node = PlacesUtils.getFolderContents(itemId).root;
  return await test_promiseBookmarksTreeForEachNode(node, aOptions, aExcludedGuids);
}

add_task(async function() {
  // Add some bookmarks to cover various use cases.
  await new_bookmark({ parentGuid: PlacesUtils.bookmarks.toolbarGuid });
  await new_folder({ parentGuid: PlacesUtils.bookmarks.menuGuid,
                     annotations: [{ name: "TestAnnoA", value: "TestVal" },
                                   { name: "TestAnnoB", value: 0 }]});
  let sepInfo = { parentGuid: PlacesUtils.bookmarks.menuGuid };
  await PlacesTransactions.NewSeparator(sepInfo).transact();
  let folderGuid = await new_folder({ parentGuid: PlacesUtils.bookmarks.menuGuid });
  await new_bookmark({ title: null,
                       parentGuid: folderGuid,
                       keyword: "test_keyword",
                       tags: ["TestTagA", "TestTagB"],
                       annotations: [{ name: "TestAnnoA", value: "TestVal2"}]});
  let urlWithCharsetAndFavicon = uri("http://charset.and.favicon");
  await new_bookmark({ parentGuid: folderGuid, url: urlWithCharsetAndFavicon });
  await PlacesUtils.setCharsetForURI(urlWithCharsetAndFavicon, "UTF-8");
  await setFaviconForPage(urlWithCharsetAndFavicon, SMALLPNG_DATA_URI);
  // Test the default places root without specifying it.
  await test_promiseBookmarksTreeAgainstResult();

  // Do specify it
  await test_promiseBookmarksTreeAgainstResult(PlacesUtils.bookmarks.rootGuid);

  // Exclude the bookmarks menu.
  // The calllback should be four times - once for the toolbar, once for
  // the bookmark we inserted under, and once for the menu (and not
  // at all for any of its descendants) and once for the unsorted bookmarks
  // folder.  However, promiseBookmarksTree is called multiple times, so
  // rather than counting the calls, we count the number of unique items
  // passed in.
  let guidsPassedToExcludeCallback = new Set();
  let placesRootWithoutTheMenu =
  await test_promiseBookmarksTreeAgainstResult(PlacesUtils.bookmarks.rootGuid, {
    excludeItemsCallback: aItem => {
      guidsPassedToExcludeCallback.add(aItem.guid);
      return aItem.root == "bookmarksMenuFolder";
    },
    includeItemIds: true
  }, [PlacesUtils.bookmarks.menuGuid]);
  Assert.equal(guidsPassedToExcludeCallback.size, 5);
  Assert.equal(placesRootWithoutTheMenu.children.length, 3);
});
