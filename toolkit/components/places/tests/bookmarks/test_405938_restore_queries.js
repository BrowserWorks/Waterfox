/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var tests = [];

/*

Backup/restore tests example:

var myTest = {
  populate: function () { ... add bookmarks ... },
  validate: function () { ... query for your bookmarks ... }
}

this.push(myTest);

*/

/*

test summary:
- create folders with content
- create a query bookmark for those folders
- backs up bookmarks
- restores bookmarks
- confirms that the query has the new ids for the same folders

scenarios:
- 1 folder  (folder shortcut)
- n folders (single query)
- n folders (multiple queries)

*/

const DEFAULT_INDEX = PlacesUtils.bookmarks.DEFAULT_INDEX;

var test = {
  _testRootId: null,
  _testRootTitle: "test root",
  _folderGuids: [],
  _bookmarkURIs: [],
  _count: 3,
  _extraBookmarksCount: 10,

  populate: async function populate() {
    // folder to hold this test
    await PlacesUtils.bookmarks.eraseEverything();

    let testFolderItems = [];
    // Set a date 60 seconds ago, so that we can set newer bookmarks later.
    let dateAdded = new Date(new Date() - 60000);

    // create test folders each with a bookmark
    for (let i = 0; i < this._count; i++) {
      this._folderGuids.push(PlacesUtils.history.makeGuid());
      testFolderItems.push({
        guid: this._folderGuids[i],
        title: `folder${i}`,
        type: PlacesUtils.bookmarks.TYPE_FOLDER,
        dateAdded,
        children: [{
          dateAdded,
          url: `http://${i}`,
          title: `bookmark${i}`,
        }]
      });
    }

    let bookmarksTree = {
      guid: PlacesUtils.bookmarks.toolbarGuid,
      children: [{
        dateAdded,
        title: this._testRootTitle,
        type: PlacesUtils.bookmarks.TYPE_FOLDER,
        children: testFolderItems
      }]
    };

    let insertedBookmarks = await PlacesUtils.bookmarks.insertTree(bookmarksTree);

    // create a query URI with 1 folder (ie: folder shortcut)
    let folderIdsMap = await PlacesUtils.promiseManyItemIds(this._folderGuids);
    let folderIds = [];
    for (let id of folderIdsMap.values()) {
      folderIds.push(id);
    }

    this._queryURI1 = `place:folder=${folderIdsMap.get(this._folderGuids[0])}&queryType=1`;
    this._queryTitle1 = "query1";
    await PlacesUtils.bookmarks.insert({
      parentGuid: insertedBookmarks[0].guid,
      dateAdded,
      url: this._queryURI1,
      title: this._queryTitle1
    });

    // create a query URI with _count folders
    this._queryURI2 = `place:folder=${folderIds.join("&folder=")}&queryType=1`;
    this._queryTitle2 = "query2";
    await PlacesUtils.bookmarks.insert({
      parentGuid: insertedBookmarks[0].guid,
      dateAdded,
      url: this._queryURI2,
      title: this._queryTitle2
    });

    // create a query URI with _count queries (each with a folder)
    // first get a query object for each folder
    var queries = folderIds.map(function(aFolderId) {
      var query = PlacesUtils.history.getNewQuery();
      query.setFolders([aFolderId], 1);
      return query;
    });

    var options = PlacesUtils.history.getNewQueryOptions();
    options.queryType = options.QUERY_TYPE_BOOKMARKS;
    this._queryURI3 =
      PlacesUtils.history.queriesToQueryString(queries, queries.length, options);
    this._queryTitle3 = "query3";
    await PlacesUtils.bookmarks.insert({
      parentGuid: insertedBookmarks[0].guid,
      dateAdded,
      url: this._queryURI3,
      title: this._queryTitle3
    });

    // Create a query URI for most recent bookmarks with NO folders specified.
    this._queryURI4 = "place:queryType=1&sort=12&excludeItemIfParentHasAnnotation=livemark%2FfeedURI&maxResults=10&excludeQueries=1";
    this._queryTitle4 = "query4";
    await PlacesUtils.bookmarks.insert({
      parentGuid: insertedBookmarks[0].guid,
      dateAdded,
      url: this._queryURI4,
      title: this._queryTitle4
    });

    dump_table("moz_bookmarks");
    dump_table("moz_places");
  },

  clean() {},

  validate: async function validate(addExtras) {
    if (addExtras) {
      // Throw a wrench in the works by inserting some new bookmarks,
      // ensuring folder ids won't be the same, when restoring.
      let date = new Date() - (this._extraBookmarksCount * 1000);
      for (let i = 0; i < this._extraBookmarksCount; i++) {
        await PlacesUtils.bookmarks.insert({
          parentGuid: PlacesUtils.bookmarks.menuGuid,
          url: uri("http://aaaa" + i),
          dateAdded: new Date(date + ((this._extraBookmarksCount - i) * 1000)),
        });
      }
    }

    var toolbar =
      PlacesUtils.getFolderContents(PlacesUtils.toolbarFolderId,
                                    false, true).root;
    do_check_true(toolbar.childCount, 1);

    var folderNode = toolbar.getChild(0);
    do_check_eq(folderNode.type, folderNode.RESULT_TYPE_FOLDER);
    do_check_eq(folderNode.title, this._testRootTitle);
    folderNode.QueryInterface(Ci.nsINavHistoryQueryResultNode);
    folderNode.containerOpen = true;

    // |_count| folders + the query nodes
    do_check_eq(folderNode.childCount, this._count + 4);

    for (let i = 0; i < this._count; i++) {
      var subFolder = folderNode.getChild(i);
      do_check_eq(subFolder.title, "folder" + i);
      subFolder.QueryInterface(Ci.nsINavHistoryContainerResultNode);
      subFolder.containerOpen = true;
      do_check_eq(subFolder.childCount, 1);
      var child = subFolder.getChild(0);
      do_check_eq(child.title, "bookmark" + i);
      do_check_true(uri(child.uri).equals(uri("http://" + i)))
    }

    // validate folder shortcut
    this.validateQueryNode1(folderNode.getChild(this._count));

    // validate folders query
    this.validateQueryNode2(folderNode.getChild(this._count + 1));

    // validate multiple queries query
    this.validateQueryNode3(folderNode.getChild(this._count + 2));

    // validate recent folders query
    this.validateQueryNode4(folderNode.getChild(this._count + 3));

    // clean up
    folderNode.containerOpen = false;
    toolbar.containerOpen = false;
  },

  validateQueryNode1: function validateQueryNode1(aNode) {
    do_check_eq(aNode.title, this._queryTitle1);
    do_check_true(PlacesUtils.nodeIsFolder(aNode));

    aNode.QueryInterface(Ci.nsINavHistoryContainerResultNode);
    aNode.containerOpen = true;
    do_check_eq(aNode.childCount, 1);
    var child = aNode.getChild(0);
    do_check_true(uri(child.uri).equals(uri("http://0")));
    do_check_eq(child.title, "bookmark0");
    aNode.containerOpen = false;
  },

  validateQueryNode2: function validateQueryNode2(aNode) {
    do_check_eq(aNode.title, this._queryTitle2);
    do_check_true(PlacesUtils.nodeIsQuery(aNode));

    aNode.QueryInterface(Ci.nsINavHistoryContainerResultNode);
    aNode.containerOpen = true;
    do_check_eq(aNode.childCount, this._count);
    for (var i = 0; i < aNode.childCount; i++) {
      var child = aNode.getChild(i);
      do_check_true(uri(child.uri).equals(uri("http://" + i)))
      do_check_eq(child.title, "bookmark" + i)
    }
    aNode.containerOpen = false;
  },

  validateQueryNode3: function validateQueryNode3(aNode) {
    do_check_eq(aNode.title, this._queryTitle3);
    do_check_true(PlacesUtils.nodeIsQuery(aNode));

    aNode.QueryInterface(Ci.nsINavHistoryContainerResultNode);
    aNode.containerOpen = true;
    do_check_eq(aNode.childCount, this._count);
    for (var i = 0; i < aNode.childCount; i++) {
      var child = aNode.getChild(i);
      do_check_true(uri(child.uri).equals(uri("http://" + i)))
      do_check_eq(child.title, "bookmark" + i)
    }
    aNode.containerOpen = false;
  },

  validateQueryNode4(aNode) {
    do_check_eq(aNode.title, this._queryTitle4);
    do_check_true(PlacesUtils.nodeIsQuery(aNode));

    aNode.QueryInterface(Ci.nsINavHistoryContainerResultNode);
    aNode.containerOpen = true;
    // The query will list the extra bookmarks added at the start of validate.
    do_check_eq(aNode.childCount, this._extraBookmarksCount);
    for (var i = 0; i < aNode.childCount; i++) {
      var child = aNode.getChild(i);
      do_check_eq(child.uri, `http://aaaa${i}/`);
    }
    aNode.containerOpen = false;
  },
}
tests.push(test);

add_task(async function() {
  // make json file
  let jsonFile = OS.Path.join(OS.Constants.Path.profileDir, "bookmarks.json");

  // populate db
  for (let singleTest of tests) {
    await singleTest.populate();
    // sanity
    await singleTest.validate(true);
  }

  // export json to file
  await BookmarkJSONUtils.exportToFile(jsonFile);

  // clean
  for (let singleTest of tests) {
    singleTest.clean();
  }

  // restore json file
  await BookmarkJSONUtils.importFromFile(jsonFile, true);

  // validate
  for (let singleTest of tests) {
    await singleTest.validate(false);
  }

  // clean up
  await OS.File.remove(jsonFile);
});
