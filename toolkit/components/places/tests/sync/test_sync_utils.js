ChromeUtils.defineModuleGetter(
  this,
  "Preferences",
  "resource://gre/modules/Preferences.jsm"
);

const SYNC_PARENT_ANNO = "sync/parent";

var makeGuid = PlacesUtils.history.makeGuid;

function shuffle(array) {
  let results = [];
  for (let i = 0; i < array.length; ++i) {
    let randomIndex = Math.floor(Math.random() * (i + 1));
    results[i] = results[randomIndex];
    results[randomIndex] = array[i];
  }
  return results;
}

async function assertTagForURLs(tag, urls, message) {
  let taggedURLs = new Set();
  await PlacesUtils.bookmarks.fetch({ tags: [tag] }, b =>
    taggedURLs.add(b.url.href)
  );
  deepEqual(
    Array.from(taggedURLs).sort(compareAscending),
    urls.sort(compareAscending),
    message
  );
}

function assertURLHasTags(url, tags, message) {
  let actualTags = PlacesUtils.tagging.getTagsForURI(uri(url));
  deepEqual(actualTags.sort(compareAscending), tags, message);
}

var populateTree = async function populate(parentGuid, ...items) {
  let guids = {};

  for (let index = 0; index < items.length; index++) {
    let item = items[index];
    let guid = makeGuid();

    switch (item.kind) {
      case "bookmark":
      case "query":
        await PlacesUtils.bookmarks.insert({
          type: PlacesUtils.bookmarks.TYPE_BOOKMARK,
          url: item.url,
          title: item.title,
          parentGuid,
          guid,
          index,
        });
        break;

      case "separator":
        await PlacesUtils.bookmarks.insert({
          type: PlacesUtils.bookmarks.TYPE_SEPARATOR,
          parentGuid,
          guid,
        });
        break;

      case "folder":
        await PlacesUtils.bookmarks.insert({
          type: PlacesUtils.bookmarks.TYPE_FOLDER,
          title: item.title,
          parentGuid,
          guid,
        });
        if (item.children) {
          Object.assign(guids, await populate(guid, ...item.children));
        }
        break;

      default:
        throw new Error(`Unsupported item type: ${item.type}`);
    }

    guids[item.title] = guid;
  }

  return guids;
};

var recordIdToId = async function recordIdToId(recordId) {
  let guid = await PlacesSyncUtils.bookmarks.recordIdToGuid(recordId);
  return PlacesUtils.promiseItemId(guid);
};

var moveSyncedBookmarksToUnsyncedParent = async function() {
  info("Insert synced bookmarks");
  let syncedGuids = await populateTree(
    PlacesUtils.bookmarks.menuGuid,
    {
      kind: "folder",
      title: "folder",
      children: [
        {
          kind: "bookmark",
          title: "childBmk",
          url: "https://example.org",
        },
      ],
    },
    {
      kind: "bookmark",
      title: "topBmk",
      url: "https://example.com",
    }
  );
  // Pretend we've synced each bookmark at least once.
  await PlacesTestUtils.setBookmarkSyncFields(
    ...Object.values(syncedGuids).map(guid => ({
      guid,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
    }))
  );

  info("Make new folder");
  let unsyncedFolder = await PlacesUtils.bookmarks.insert({
    type: PlacesUtils.bookmarks.TYPE_FOLDER,
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    title: "unsyncedFolder",
  });

  info("Move synced bookmarks into unsynced new folder");
  for (let guid of Object.values(syncedGuids)) {
    await PlacesUtils.bookmarks.update({
      guid,
      parentGuid: unsyncedFolder.guid,
      index: PlacesUtils.bookmarks.DEFAULT_INDEX,
    });
  }

  return { syncedGuids, unsyncedFolder };
};

var setChangesSynced = async function(changes) {
  for (let recordId in changes) {
    changes[recordId].synced = true;
  }
  await PlacesSyncUtils.bookmarks.pushChanges(changes);
};

var ignoreChangedRoots = async function() {
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  let expectedRoots = ["menu", "mobile", "toolbar", "unfiled"];
  if (!ObjectUtils.deepEqual(Object.keys(changes).sort(), expectedRoots)) {
    // Make sure the previous test cleaned up.
    throw new Error(
      `Unexpected changes at start of test: ${JSON.stringify(changes)}`
    );
  }
  await setChangesSynced(changes);
};

add_task(async function test_fetchURLFrecency() {
  // Add visits to the following URLs and then check if frecency for those URLs is not -1.
  let arrayOfURLsToVisit = [
    "https://www.mozilla.org/en-US/",
    "http://getfirefox.com",
    "http://getthunderbird.com",
  ];
  for (let url of arrayOfURLsToVisit) {
    await PlacesTestUtils.addVisits(url);
  }
  for (let url of arrayOfURLsToVisit) {
    let frecency = await PlacesSyncUtils.history.fetchURLFrecency(url);
    equal(typeof frecency, "number", "The frecency should be of type: number");
    notEqual(
      frecency,
      -1,
      "The frecency of this url should be different than -1"
    );
  }
  // Do not add visits to the following URLs, and then check if frecency for those URLs is -1.
  let arrayOfURLsNotVisited = ["https://bugzilla.org", "https://example.org"];
  for (let url of arrayOfURLsNotVisited) {
    let frecency = await PlacesSyncUtils.history.fetchURLFrecency(url);
    equal(frecency, -1, "The frecency of this url should be -1");
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_determineNonSyncableGuids() {
  // Add visits to the following URLs with different transition types.
  let arrayOfVisits = [
    { uri: "https://www.mozilla.org/en-US/", transition: TRANSITION_TYPED },
    { uri: "http://getfirefox.com/", transition: TRANSITION_LINK },
    { uri: "http://getthunderbird.com/", transition: TRANSITION_FRAMED_LINK },
  ];
  for (let visit of arrayOfVisits) {
    await PlacesTestUtils.addVisits(visit);
  }

  // Fetch the guid for each visit.
  let guids = [];
  let dictURLGuid = {};
  for (let visit of arrayOfVisits) {
    let guid = await PlacesSyncUtils.history.fetchGuidForURL(visit.uri);
    guids.push(guid);
    dictURLGuid[visit.uri] = guid;
  }

  // Filter the visits.
  let filteredGuids = await PlacesSyncUtils.history.determineNonSyncableGuids(
    guids
  );

  // Check if the filtered visits are of type TRANSITION_FRAMED_LINK.
  for (let visit of arrayOfVisits) {
    if (visit.transition === TRANSITION_FRAMED_LINK) {
      ok(
        filteredGuids.includes(dictURLGuid[visit.uri]),
        "This url should be one of the filtered guids."
      );
    } else {
      ok(
        !filteredGuids.includes(dictURLGuid[visit.uri]),
        "This url should not be one of the filtered guids."
      );
    }
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_changeGuid() {
  // Add some visits of the following URLs.
  let arrayOfURLsToVisit = [
    "https://www.mozilla.org/en-US/",
    "http://getfirefox.com/",
    "http://getthunderbird.com/",
  ];
  for (let url of arrayOfURLsToVisit) {
    await PlacesTestUtils.addVisits(url);
  }

  for (let url of arrayOfURLsToVisit) {
    let originalGuid = await PlacesSyncUtils.history.fetchGuidForURL(url);
    let newGuid = makeGuid();

    // Change the original GUID for the new GUID.
    await PlacesSyncUtils.history.changeGuid(url, newGuid);

    // Fetch the GUID for this URL.
    let newGuidFetched = await PlacesSyncUtils.history.fetchGuidForURL(url);

    // Check that the URL has the new GUID as its GUID and not the original one.
    equal(
      newGuid,
      newGuidFetched,
      "These should be equal since we changed the guid for the visit."
    );
    notEqual(
      originalGuid,
      newGuidFetched,
      "These should be different since we changed the guid for the visit."
    );
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_fetchVisitsForURL() {
  // Get the date for this moment and a date for a minute ago.
  let now = new Date();
  let aMinuteAgo = new Date(now.getTime() - 1 * 60000);

  // Add some visits of the following URLs, specifying the transition and the visit date.
  let arrayOfVisits = [
    {
      uri: "https://www.mozilla.org/en-US/",
      transition: TRANSITION_TYPED,
      visitDate: aMinuteAgo,
    },
    {
      uri: "http://getfirefox.com/",
      transition: TRANSITION_LINK,
      visitDate: aMinuteAgo,
    },
    {
      uri: "http://getthunderbird.com/",
      transition: TRANSITION_LINK,
      visitDate: aMinuteAgo,
    },
  ];
  for (let elem of arrayOfVisits) {
    await PlacesTestUtils.addVisits(elem);
  }

  for (let elem of arrayOfVisits) {
    // Fetch all the visits for this URL.
    let visits = await PlacesSyncUtils.history.fetchVisitsForURL(elem.uri);
    // Since the visit we added will be the last one in the collection of visits, we get the index of it.
    let iLast = visits.length - 1;

    // The date is saved in _micro_seconds, here we change it to milliseconds.
    let dateInMilliseconds = visits[iLast].date * 0.001;

    // Check that the info we provided for this URL is the same one retrieved.
    equal(
      dateInMilliseconds,
      elem.visitDate.getTime(),
      "The date we provided should be the same we retrieved."
    );
    equal(
      visits[iLast].type,
      elem.transition,
      "The transition type we provided should be the same we retrieved."
    );
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_fetchGuidForURL() {
  // Add some visits of the following URLs.
  let arrayOfURLsToVisit = [
    "https://www.mozilla.org/en-US/",
    "http://getfirefox.com/",
    "http://getthunderbird.com/",
  ];
  for (let url of arrayOfURLsToVisit) {
    await PlacesTestUtils.addVisits(url);
  }

  // This tries to test fetchGuidForURL in two ways:
  // 1- By fetching the GUID, and then using that GUID to retrieve the info of the visit.
  //    It then compares the URL with the URL that is on the visits info.
  // 2- By creating a new GUID, changing the GUID for the visit, fetching the GUID and comparing them.
  for (let url of arrayOfURLsToVisit) {
    let guid = await PlacesSyncUtils.history.fetchGuidForURL(url);
    let info = await PlacesSyncUtils.history.fetchURLInfoForGuid(guid);

    let newGuid = makeGuid();
    await PlacesSyncUtils.history.changeGuid(url, newGuid);
    let newGuid2 = await PlacesSyncUtils.history.fetchGuidForURL(url);

    equal(
      url,
      info.url,
      "The url provided and the url retrieved should be the same."
    );
    equal(
      newGuid,
      newGuid2,
      "The changed guid and the retrieved guid should be the same."
    );
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_fetchURLInfoForGuid() {
  // Add some visits of the following URLs. specifying the title.
  let visits = [
    { uri: "https://www.mozilla.org/en-US/", title: "mozilla" },
    { uri: "http://getfirefox.com/", title: "firefox" },
    { uri: "http://getthunderbird.com/", title: "thunderbird" },
    { uri: "http://quantum.mozilla.com/", title: null },
  ];
  for (let visit of visits) {
    await PlacesTestUtils.addVisits(visit);
  }

  for (let visit of visits) {
    let guid = await PlacesSyncUtils.history.fetchGuidForURL(visit.uri);
    let info = await PlacesSyncUtils.history.fetchURLInfoForGuid(guid);

    // Compare the info returned by fetchURLInfoForGuid,
    // URL and title should match while frecency must be different than -1.
    equal(
      info.url,
      visit.uri,
      "The url provided should be the same as the url retrieved."
    );
    equal(
      info.title,
      visit.title || "",
      "The title provided should be the same as the title retrieved."
    );
    notEqual(
      info.frecency,
      -1,
      "The frecency of the visit should be different than -1."
    );
  }

  // Create a "fake" GUID and check that the result of fetchURLInfoForGuid is null.
  let guid = makeGuid();
  let info = await PlacesSyncUtils.history.fetchURLInfoForGuid(guid);

  equal(
    info,
    null,
    "The information object of a non-existent guid should be null."
  );

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_getAllURLs() {
  // Add some visits of the following URLs.
  let arrayOfURLsToVisit = [
    "https://www.mozilla.org/en-US/",
    "http://getfirefox.com/",
    "http://getthunderbird.com/",
  ];
  for (let url of arrayOfURLsToVisit) {
    await PlacesTestUtils.addVisits(url);
  }

  // Get all URLs.
  let allURLs = await PlacesSyncUtils.history.getAllURLs({
    since: new Date(Date.now() - 2592000000),
    limit: 5000,
  });

  // The amount of URLs must be the same in both collections.
  equal(
    allURLs.length,
    arrayOfURLsToVisit.length,
    "The amount of urls retrived should match the amount of urls provided."
  );

  // Check that the correct URLs were retrived.
  for (let url of arrayOfURLsToVisit) {
    ok(
      allURLs.includes(url),
      "The urls retrieved should match the ones used in this test."
    );
  }

  // Remove the visits added during this test.
  await PlacesUtils.history.clear();
});

add_task(async function test_order() {
  info("Insert some bookmarks");
  let guids = await populateTree(
    PlacesUtils.bookmarks.menuGuid,
    {
      kind: "bookmark",
      title: "childBmk",
      url: "http://getfirefox.com",
    },
    {
      kind: "bookmark",
      title: "siblingBmk",
      url: "http://getthunderbird.com",
    },
    {
      kind: "folder",
      title: "siblingFolder",
    },
    {
      kind: "separator",
      title: "siblingSep",
    }
  );

  info("Reorder inserted bookmarks");
  {
    let order = [
      guids.siblingFolder,
      guids.siblingSep,
      guids.childBmk,
      guids.siblingBmk,
    ];
    await PlacesSyncUtils.bookmarks.order(
      PlacesUtils.bookmarks.menuGuid,
      order
    );
    let childRecordIds = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
      PlacesUtils.bookmarks.menuGuid
    );
    deepEqual(
      childRecordIds,
      order,
      "New bookmarks should be reordered according to array"
    );
  }

  info("Same order with unspecified children");
  {
    await PlacesSyncUtils.bookmarks.order(PlacesUtils.bookmarks.menuGuid, [
      guids.siblingSep,
      guids.siblingBmk,
    ]);
    let childRecordIds = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
      PlacesUtils.bookmarks.menuGuid
    );
    deepEqual(
      childRecordIds,
      [guids.siblingFolder, guids.siblingSep, guids.childBmk, guids.siblingBmk],
      "Current order should be respected if possible"
    );
  }

  info("New order with unspecified children");
  {
    await PlacesSyncUtils.bookmarks.order(PlacesUtils.bookmarks.menuGuid, [
      guids.siblingBmk,
      guids.siblingSep,
    ]);
    let childRecordIds = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
      PlacesUtils.bookmarks.menuGuid
    );
    deepEqual(
      childRecordIds,
      [guids.siblingBmk, guids.siblingSep, guids.siblingFolder, guids.childBmk],
      "Unordered children should be moved to end if current order can't be respected"
    );
  }

  info("Reorder with nonexistent children");
  {
    await PlacesSyncUtils.bookmarks.order(PlacesUtils.bookmarks.menuGuid, [
      guids.childBmk,
      makeGuid(),
      guids.siblingBmk,
      guids.siblingSep,
      makeGuid(),
      guids.siblingFolder,
      makeGuid(),
    ]);
    let childRecordIds = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
      PlacesUtils.bookmarks.menuGuid
    );
    deepEqual(
      childRecordIds,
      [guids.childBmk, guids.siblingBmk, guids.siblingSep, guids.siblingFolder],
      "Nonexistent children should be ignored"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_dedupe() {
  await ignoreChangedRoots();

  let parentFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    recordId: makeGuid(),
    parentRecordId: "menu",
  });
  let differentParentFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    recordId: makeGuid(),
    parentRecordId: "menu",
  });
  let mozBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: parentFolder.recordId,
    url: "https://mozilla.org",
  });
  let fxBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: parentFolder.recordId,
    url: "http://getfirefox.com",
  });
  let tbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: parentFolder.recordId,
    url: "http://getthunderbird.com",
  });

  await Assert.rejects(
    PlacesSyncUtils.bookmarks.dedupe(makeGuid(), makeGuid(), makeGuid()),
    /does not exist/,
    "Should reject attempts to de-dupe nonexistent items"
  );
  await Assert.rejects(
    PlacesSyncUtils.bookmarks.dedupe("menu", makeGuid(), "places"),
    /Cannot de-dupe local root/,
    "Should reject attempts to de-dupe local roots"
  );

  info("De-dupe with same remote parent");
  {
    let localId = await PlacesUtils.promiseItemId(mozBmk.recordId);
    let newRemoteRecordId = makeGuid();

    let changes = await PlacesSyncUtils.bookmarks.dedupe(
      mozBmk.recordId,
      newRemoteRecordId,
      parentFolder.recordId
    );
    deepEqual(
      Object.keys(changes).sort(),
      [
        parentFolder.recordId, // Parent.
        mozBmk.recordId, // Tombstone for old sync ID.
      ].sort(),
      "Should bump change counter of parent"
    );
    ok(
      changes[mozBmk.recordId].tombstone,
      "Should write tombstone for old local sync ID"
    );
    ok(
      Object.values(changes).every(change => change.counter === 1),
      "Change counter for every bookmark should be 1"
    );

    ok(
      !(await PlacesUtils.bookmarks.fetch(mozBmk.recordId)),
      "Bookmark with old local sync ID should not exist"
    );
    await Assert.rejects(
      PlacesUtils.promiseItemId(mozBmk.recordId),
      /no item found for the given GUID/,
      "Should invalidate GUID cache entry for old local sync ID"
    );

    let newMozBmk = await PlacesUtils.bookmarks.fetch(newRemoteRecordId);
    equal(
      newMozBmk.guid,
      newRemoteRecordId,
      "Should change local sync ID to remote sync ID"
    );
    equal(
      await PlacesUtils.promiseItemId(newRemoteRecordId),
      localId,
      "Should add new remote sync ID to GUID cache"
    );

    await setChangesSynced(changes);
  }

  info("De-dupe with different remote parent");
  {
    let localId = await PlacesUtils.promiseItemId(fxBmk.recordId);
    let newRemoteRecordId = makeGuid();

    let changes = await PlacesSyncUtils.bookmarks.dedupe(
      fxBmk.recordId,
      newRemoteRecordId,
      differentParentFolder.recordId
    );
    deepEqual(
      Object.keys(changes).sort(),
      [
        parentFolder.recordId, // Old local parent.
        differentParentFolder.recordId, // New remote parent.
        fxBmk.recordId, // Tombstone for old sync ID.
      ].sort(),
      "Should bump change counter of old parent and new parent"
    );
    ok(
      changes[fxBmk.recordId].tombstone,
      "Should write tombstone for old local sync ID"
    );
    ok(
      Object.values(changes).every(change => change.counter === 1),
      "Change counter for every bookmark should be 1"
    );

    let newFxBmk = await PlacesUtils.bookmarks.fetch(newRemoteRecordId);
    equal(
      newFxBmk.parentGuid,
      parentFolder.recordId,
      "De-duping should not move bookmark to new parent"
    );
    equal(
      await PlacesUtils.promiseItemId(newRemoteRecordId),
      localId,
      "De-duping with different remote parent should cache new sync ID"
    );

    await setChangesSynced(changes);
  }

  info("De-dupe with nonexistent remote parent");
  {
    let localId = await PlacesUtils.promiseItemId(tbBmk.recordId);
    let newRemoteRecordId = makeGuid();
    let remoteParentRecordId = makeGuid();

    let changes = await PlacesSyncUtils.bookmarks.dedupe(
      tbBmk.recordId,
      newRemoteRecordId,
      remoteParentRecordId
    );
    deepEqual(
      Object.keys(changes).sort(),
      [
        parentFolder.recordId, // Old local parent.
        tbBmk.recordId, // Tombstone for old sync ID.
      ].sort(),
      "Should bump change counter of old parent"
    );
    ok(
      changes[tbBmk.recordId].tombstone,
      "Should write tombstone for old local sync ID"
    );
    ok(
      Object.values(changes).every(change => change.counter === 1),
      "Change counter for every bookmark should be 1"
    );

    equal(
      await PlacesUtils.promiseItemId(newRemoteRecordId),
      localId,
      "De-duping with nonexistent remote parent should cache new sync ID"
    );

    await setChangesSynced(changes);
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_order_roots() {
  let oldOrder = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
    PlacesUtils.bookmarks.rootGuid
  );
  await PlacesSyncUtils.bookmarks.order(
    PlacesUtils.bookmarks.rootGuid,
    shuffle(oldOrder)
  );
  let newOrder = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
    PlacesUtils.bookmarks.rootGuid
  );
  deepEqual(oldOrder, newOrder, "Should ignore attempts to reorder roots");

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_update_tags() {
  info("Insert item without tags");
  let item = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    url: "https://mozilla.org",
    recordId: makeGuid(),
    parentRecordId: "menu",
  });

  info("Add tags");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      tags: ["foo", "bar"],
    });
    deepEqual(updatedItem.tags, ["foo", "bar"], "Should return new tags");
    assertURLHasTags(
      "https://mozilla.org",
      ["bar", "foo"],
      "Should set new tags for URL"
    );
  }

  info("Add new tag, remove existing tag");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      tags: ["foo", "baz"],
    });
    deepEqual(updatedItem.tags, ["foo", "baz"], "Should return updated tags");
    assertURLHasTags(
      "https://mozilla.org",
      ["baz", "foo"],
      "Should update tags for URL"
    );
    await assertTagForURLs("bar", [], "Should remove existing tag");
  }

  info("Tags with whitespace");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      tags: [" leading", "trailing ", " baz ", " "],
    });
    deepEqual(
      updatedItem.tags,
      ["leading", "trailing", "baz"],
      "Should return filtered tags"
    );
    assertURLHasTags(
      "https://mozilla.org",
      ["baz", "leading", "trailing"],
      "Should trim whitespace and filter blank tags"
    );
  }

  info("Remove all tags");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      tags: null,
    });
    deepEqual(updatedItem.tags, [], "Should return empty tag array");
    assertURLHasTags(
      "https://mozilla.org",
      [],
      "Should remove all existing tags"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_tags() {
  await ignoreChangedRoots();

  info("Insert untagged items with same URL");
  let firstItem = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "menu",
    url: "https://example.org",
  });
  let secondItem = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "menu",
    url: "https://example.org",
  });
  let untaggedItem = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "menu",
    url: "https://bugzilla.org",
  });
  let taggedItem = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "menu",
    url: "https://mozilla.org",
  });

  info("Create tag");
  PlacesUtils.tagging.tagURI(uri("https://example.org"), ["taggy"]);

  let tagBm = await PlacesUtils.bookmarks.fetch({
    parentGuid: PlacesUtils.bookmarks.tagsGuid,
    index: 0,
  });
  let tagFolderGuid = tagBm.guid;
  let tagFolderId = await PlacesUtils.promiseItemId(tagFolderGuid);

  info("Tagged bookmarks should be in changeset");
  {
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId].sort(),
      "Should include tagged bookmarks in changeset"
    );
    await setChangesSynced(changes);
  }

  info("Change tag case");
  {
    PlacesUtils.tagging.tagURI(uri("https://mozilla.org"), ["TaGgY"]);
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId, taggedItem.recordId].sort(),
      "Should include tagged bookmarks after changing case"
    );
    await assertTagForURLs(
      "TaGgY",
      ["https://example.org/", "https://mozilla.org/"],
      "Should add tag for new URL"
    );
    await setChangesSynced(changes);
  }

  // These tests change a tag item directly, without going through the tagging
  // service. This behavior isn't supported, but the tagging service registers
  // an observer to handle these cases, so we make sure we handle them
  // correctly.

  info("Rename tag folder using Bookmarks.setItemTitle");
  {
    PlacesUtils.bookmarks.setItemTitle(tagFolderId, "sneaky");
    deepEqual(
      (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
      ["sneaky"],
      "Tagging service should update cache with new title"
    );
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId].sort(),
      "Should include tagged bookmarks after renaming tag folder"
    );
    await setChangesSynced(changes);
  }

  info("Rename tag folder using Bookmarks.update");
  {
    await PlacesUtils.bookmarks.update({
      guid: tagFolderGuid,
      title: "tricky",
    });
    deepEqual(
      (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
      ["tricky"],
      "Tagging service should update cache after updating tag folder"
    );
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId].sort(),
      "Should include tagged bookmarks after updating tag folder"
    );
    await setChangesSynced(changes);
  }

  info("Change tag entry URL using Bookmarks.update");
  {
    let bm = await PlacesUtils.bookmarks.fetch({
      parentGuid: tagFolderGuid,
      index: 0,
    });
    bm.url = "https://bugzilla.org/";
    await PlacesUtils.bookmarks.update(bm);
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId, untaggedItem.recordId].sort(),
      "Should include tagged bookmarks after changing tag entry URI"
    );
    await assertTagForURLs(
      "tricky",
      ["https://bugzilla.org/", "https://mozilla.org/"],
      "Should remove tag entry for old URI"
    );
    await setChangesSynced(changes);

    bm.url = "https://example.org/";
    await PlacesUtils.bookmarks.update(bm);
    changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [firstItem.recordId, secondItem.recordId, untaggedItem.recordId].sort(),
      "Should include tagged bookmarks after changing tag entry URL"
    );
    await assertTagForURLs(
      "tricky",
      ["https://example.org/", "https://mozilla.org/"],
      "Should remove tag entry for old URL"
    );
    await setChangesSynced(changes);
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_update_keyword() {
  info("Insert item without keyword");
  let item = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: "menu",
    url: "https://mozilla.org",
    recordId: makeGuid(),
  });

  info("Add item keyword");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "moz",
    });
    equal(updatedItem.keyword, "moz", "Should return new keyword");
    let entryByKeyword = await PlacesUtils.keywords.fetch("moz");
    equal(
      entryByKeyword.url.href,
      "https://mozilla.org/",
      "Should set new keyword for URL"
    );
    let entryByURL = await PlacesUtils.keywords.fetch({
      url: "https://mozilla.org",
    });
    equal(
      entryByURL.keyword,
      "moz",
      "Looking up URL should return new keyword"
    );
  }

  info("Change item keyword");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "m",
    });
    equal(updatedItem.keyword, "m", "Should return updated keyword");
    let newEntry = await PlacesUtils.keywords.fetch("m");
    equal(
      newEntry.url.href,
      "https://mozilla.org/",
      "Should update keyword for URL"
    );
    let oldEntry = await PlacesUtils.keywords.fetch("moz");
    ok(!oldEntry, "Should remove old keyword");
  }

  info("Remove existing keyword");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: null,
    });
    ok(
      !updatedItem.keyword,
      "Should not include removed keyword in properties"
    );
    let entry = await PlacesUtils.keywords.fetch({
      url: "https://mozilla.org",
    });
    ok(!entry, "Should remove new keyword from URL");
  }

  info("Remove keyword for item without keyword");
  {
    await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: null,
    });
    let entry = await PlacesUtils.keywords.fetch({
      url: "https://mozilla.org",
    });
    ok(
      !entry,
      "Removing keyword for URL without existing keyword should succeed"
    );
  }

  let item2;
  info("Insert removes other item's keyword if they are the same");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "test",
    });
    equal(updatedItem.keyword, "test", "Initial update succeeds");
    item2 = await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      parentRecordId: "menu",
      url: "https://mozilla.org/1",
      recordId: makeGuid(),
      keyword: "test",
    });
    equal(item2.keyword, "test", "insert with existing should succeed");
    updatedItem = await PlacesSyncUtils.bookmarks.fetch(item.recordId);
    ok(!updatedItem.keyword, "initial item no longer has keyword");
    let entry = await PlacesUtils.keywords.fetch({
      url: "https://mozilla.org",
    });
    ok(!entry, "Direct check for original url keyword gives nothing");
    let newEntry = await PlacesUtils.keywords.fetch("test");
    ok(newEntry, "Keyword should exist for new item");
    equal(
      newEntry.url.href,
      "https://mozilla.org/1",
      "Keyword should point to new url"
    );
  }

  info("Insert updates other item's keyword if they are the same url");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "test2",
    });
    equal(updatedItem.keyword, "test2", "Initial update succeeds");
    let newItem = await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      parentRecordId: "menu",
      url: "https://mozilla.org",
      recordId: makeGuid(),
      keyword: "test3",
    });
    equal(newItem.keyword, "test3", "insert with existing should succeed");
    updatedItem = await PlacesSyncUtils.bookmarks.fetch(item.recordId);
    equal(updatedItem.keyword, "test3", "initial item has new keyword");
  }

  info("Update removes other item's keyword if they are the same");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "test4",
    });
    equal(updatedItem.keyword, "test4", "Initial update succeeds");
    let updatedItem2 = await PlacesSyncUtils.bookmarks.update({
      recordId: item2.recordId,
      keyword: "test4",
    });
    equal(updatedItem2.keyword, "test4", "New update succeeds");
    updatedItem = await PlacesSyncUtils.bookmarks.fetch(item.recordId);
    ok(!updatedItem.keyword, "initial item no longer has keyword");
    let entry = await PlacesUtils.keywords.fetch({
      url: "https://mozilla.org",
    });
    ok(!entry, "Direct check for original url keyword gives nothing");
    let newEntry = await PlacesUtils.keywords.fetch("test4");
    ok(newEntry, "Keyword should exist for new item");
    equal(
      newEntry.url.href,
      "https://mozilla.org/1",
      "Keyword should point to new url"
    );
  }

  info("Update url updates it's keyword if url already has keyword");
  {
    let updatedItem = await PlacesSyncUtils.bookmarks.update({
      recordId: item.recordId,
      keyword: "test4",
    });
    equal(updatedItem.keyword, "test4", "Initial update succeeds");
    let updatedItem2 = await PlacesSyncUtils.bookmarks.update({
      recordId: item2.recordId,
      keyword: "test5",
    });
    equal(updatedItem2.keyword, "test5", "New update succeeds");
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_conflicting_keywords() {
  await ignoreChangedRoots();

  info("Insert bookmark with new keyword");
  let tbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "unfiled",
    url: "http://getthunderbird.com",
    keyword: "tbird",
  });
  {
    let entryByKeyword = await PlacesUtils.keywords.fetch("tbird");
    equal(
      entryByKeyword.url.href,
      "http://getthunderbird.com/",
      "Should return new keyword entry by URL"
    );
    let entryByURL = await PlacesUtils.keywords.fetch({
      url: "http://getthunderbird.com",
    });
    equal(entryByURL.keyword, "tbird", "Should return new entry by keyword");
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      changes,
      {},
      "Should not bump change counter for new keyword entry"
    );
  }

  info("Insert bookmark with same URL and different keyword");
  let dupeTbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: "toolbar",
    url: "http://getthunderbird.com",
    keyword: "tb",
  });
  {
    let oldKeywordByURL = await PlacesUtils.keywords.fetch("tbird");
    ok(
      !oldKeywordByURL,
      "Should remove old entry when inserting bookmark with different keyword"
    );
    let entryByKeyword = await PlacesUtils.keywords.fetch("tb");
    equal(
      entryByKeyword.url.href,
      "http://getthunderbird.com/",
      "Should return different keyword entry by URL"
    );
    let entryByURL = await PlacesUtils.keywords.fetch({
      url: "http://getthunderbird.com",
    });
    equal(entryByURL.keyword, "tb", "Should return different entry by keyword");
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [tbBmk.recordId, dupeTbBmk.recordId].sort(),
      "Should bump change counter for bookmarks with different keyword"
    );
    await setChangesSynced(changes);
  }

  info("Update bookmark with different keyword");
  await PlacesSyncUtils.bookmarks.update({
    kind: "bookmark",
    recordId: tbBmk.recordId,
    url: "http://getthunderbird.com",
    keyword: "thunderbird",
  });
  {
    let oldKeywordByURL = await PlacesUtils.keywords.fetch("tb");
    ok(
      !oldKeywordByURL,
      "Should remove old entry when updating bookmark keyword"
    );
    let entryByKeyword = await PlacesUtils.keywords.fetch("thunderbird");
    equal(
      entryByKeyword.url.href,
      "http://getthunderbird.com/",
      "Should return updated keyword entry by URL"
    );
    let entryByURL = await PlacesUtils.keywords.fetch({
      url: "http://getthunderbird.com",
    });
    equal(
      entryByURL.keyword,
      "thunderbird",
      "Should return entry by updated keyword"
    );
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [tbBmk.recordId, dupeTbBmk.recordId].sort(),
      "Should bump change counter for bookmarks with updated keyword"
    );
    await setChangesSynced(changes);
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_update_move_root() {
  info("Move root to same parent");
  {
    // This should be a no-op.
    let sameRoot = await PlacesSyncUtils.bookmarks.update({
      recordId: "menu",
      parentRecordId: "places",
    });
    equal(sameRoot.recordId, "menu", "Menu root GUID should not change");
    equal(
      sameRoot.parentRecordId,
      "places",
      "Parent Places root GUID should not change"
    );
  }

  info("Try reparenting root");
  await Assert.rejects(
    PlacesSyncUtils.bookmarks.update({
      recordId: "menu",
      parentRecordId: "toolbar",
    }),
    /Cannot move Places root/
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert() {
  info("Insert bookmark");
  {
    let item = await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      recordId: makeGuid(),
      parentRecordId: "menu",
      url: "https://example.org",
    });
    let { type } = await PlacesUtils.bookmarks.fetch({ guid: item.recordId });
    equal(
      type,
      PlacesUtils.bookmarks.TYPE_BOOKMARK,
      "Bookmark should have correct type"
    );
  }

  info("Insert query");
  {
    let item = await PlacesSyncUtils.bookmarks.insert({
      kind: "query",
      recordId: makeGuid(),
      parentRecordId: "menu",
      url: "place:terms=term&folder=TOOLBAR&queryType=1",
      folder: "Saved search",
    });
    let { type } = await PlacesUtils.bookmarks.fetch({ guid: item.recordId });
    equal(
      type,
      PlacesUtils.bookmarks.TYPE_BOOKMARK,
      "Queries should be stored as bookmarks"
    );
  }

  info("Insert folder");
  {
    let item = await PlacesSyncUtils.bookmarks.insert({
      kind: "folder",
      recordId: makeGuid(),
      parentRecordId: "menu",
      title: "New folder",
    });
    let { type } = await PlacesUtils.bookmarks.fetch({ guid: item.recordId });
    equal(
      type,
      PlacesUtils.bookmarks.TYPE_FOLDER,
      "Folder should have correct type"
    );
  }

  info("Insert separator");
  {
    let item = await PlacesSyncUtils.bookmarks.insert({
      kind: "separator",
      recordId: makeGuid(),
      parentRecordId: "menu",
    });
    let { type } = await PlacesUtils.bookmarks.fetch({ guid: item.recordId });
    equal(
      type,
      PlacesUtils.bookmarks.TYPE_SEPARATOR,
      "Separator should have correct type"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert_tags() {
  await Promise.all(
    [
      {
        kind: "bookmark",
        url: "https://example.com",
        recordId: makeGuid(),
        parentRecordId: "menu",
        tags: ["foo", "bar"],
      },
      {
        kind: "bookmark",
        url: "https://example.org",
        recordId: makeGuid(),
        parentRecordId: "toolbar",
        tags: ["foo", "baz"],
      },
      {
        kind: "query",
        url: "place:queryType=1&sort=12&maxResults=10",
        recordId: makeGuid(),
        parentRecordId: "toolbar",
        folder: "bar",
        tags: ["baz", "qux"],
        title: "bar",
      },
    ].map(info => PlacesSyncUtils.bookmarks.insert(info))
  );

  await assertTagForURLs(
    "foo",
    ["https://example.com/", "https://example.org/"],
    "2 URLs with new tag"
  );
  await assertTagForURLs(
    "bar",
    ["https://example.com/"],
    "1 URL with existing tag"
  );
  await assertTagForURLs(
    "baz",
    ["https://example.org/", "place:queryType=1&sort=12&maxResults=10"],
    "Should support tagging URLs and tag queries"
  );
  await assertTagForURLs(
    "qux",
    ["place:queryType=1&sort=12&maxResults=10"],
    "Should support tagging tag queries"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert_tags_whitespace() {
  info("Untrimmed and blank tags");
  let taggedBlanks = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    url: "https://example.org",
    recordId: makeGuid(),
    parentRecordId: "menu",
    tags: [" untrimmed ", " ", "taggy"],
  });
  deepEqual(
    taggedBlanks.tags,
    ["untrimmed", "taggy"],
    "Should not return empty tags"
  );
  assertURLHasTags(
    "https://example.org/",
    ["taggy", "untrimmed"],
    "Should set trimmed tags and ignore dupes"
  );

  info("Dupe tags");
  let taggedDupes = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    url: "https://example.net",
    recordId: makeGuid(),
    parentRecordId: "toolbar",
    tags: [" taggy", "taggy ", " taggy ", "taggy"],
  });
  deepEqual(
    taggedDupes.tags,
    ["taggy", "taggy", "taggy", "taggy"],
    "Should return trimmed and dupe tags"
  );
  assertURLHasTags(
    "https://example.net/",
    ["taggy"],
    "Should ignore dupes when setting tags"
  );

  await assertTagForURLs(
    "taggy",
    ["https://example.net/", "https://example.org/"],
    "Should exclude falsy tags"
  );

  PlacesUtils.tagging.untagURI(uri("https://example.org"), [
    "untrimmed",
    "taggy",
  ]);
  PlacesUtils.tagging.untagURI(uri("https://example.net"), ["taggy"]);
  deepEqual(
    (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
    [],
    "Should clean up all tags"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert_keyword() {
  info("Insert item with new keyword");
  {
    await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      parentRecordId: "menu",
      url: "https://example.com",
      keyword: "moz",
      recordId: makeGuid(),
    });
    let entry = await PlacesUtils.keywords.fetch("moz");
    equal(
      entry.url.href,
      "https://example.com/",
      "Should add keyword for item"
    );
  }

  info("Insert item with existing keyword");
  {
    await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      parentRecordId: "menu",
      url: "https://mozilla.org",
      keyword: "moz",
      recordId: makeGuid(),
    });
    let entry = await PlacesUtils.keywords.fetch("moz");
    equal(
      entry.url.href,
      "https://mozilla.org/",
      "Should reassign keyword to new item"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert_tag_query() {
  info("Use the public tagging API to ensure we added the tag correctly");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    type: PlacesUtils.bookmarks.TYPE_BOOKMARK,
    url: "https://mozilla.org",
    title: "Mozilla",
  });
  PlacesUtils.tagging.tagURI(uri("https://mozilla.org"), ["taggy"]);
  assertURLHasTags(
    "https://mozilla.org/",
    ["taggy"],
    "Should set tags using the tagging API"
  );

  info("Insert tag query for non existing tag");
  {
    let query = await PlacesSyncUtils.bookmarks.insert({
      kind: "query",
      recordId: makeGuid(),
      parentRecordId: "toolbar",
      url: "place:type=7&folder=90",
      folder: "nonexisting",
      title: "Tagged stuff",
    });
    let params = new URLSearchParams(query.url.pathname);
    ok(!params.has("type"), "Should not preserve query type");
    ok(!params.has("folder"), "Should not preserve folder");
    equal(params.get("tag"), "nonexisting", "Should add tag");
    deepEqual(
      (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
      ["taggy"],
      "The nonexisting tag should not be added"
    );
  }

  info("Insert tag query for existing tag");
  {
    let url = "place:type=7&folder=90&maxResults=15";
    let query = await PlacesSyncUtils.bookmarks.insert({
      kind: "query",
      recordId: makeGuid(),
      parentRecordId: "menu",
      url,
      folder: "taggy",
      title: "Sorted and tagged",
    });
    let params = new URLSearchParams(query.url.pathname);
    ok(!params.get("type"), "Should not preserve query type");
    ok(!params.has("folder"), "Should not preserve folder");
    equal(params.get("maxResults"), "15", "Should preserve additional params");
    equal(params.get("tag"), "taggy", "Should add tag");
    deepEqual(
      (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
      ["taggy"],
      "Should not duplicate existing tags"
    );
  }

  info("Removing the tag should clean up the tag folder");
  PlacesUtils.tagging.untagURI(uri("https://mozilla.org"), null);
  deepEqual(
    (await PlacesUtils.bookmarks.fetchTags()).map(t => t.name),
    [],
    "Should remove tag folder once last item is untagged"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_insert_orphans() {
  await ignoreChangedRoots();

  let grandParentGuid = makeGuid();
  let parentGuid = makeGuid();
  let childGuid = makeGuid();
  let childId;

  info("Insert an orphaned child");
  {
    let child = await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      parentRecordId: parentGuid,
      recordId: childGuid,
      url: "https://mozilla.org",
    });
    equal(
      child.recordId,
      childGuid,
      "Should insert orphan with requested GUID"
    );
    equal(child.parentRecordId, "unfiled", "Should reparent orphan to unfiled");

    childId = await PlacesUtils.promiseItemId(childGuid);
    equal(
      PlacesUtils.annotations.getItemAnnotation(childId, SYNC_PARENT_ANNO),
      parentGuid,
      "Should set anno to missing parent GUID"
    );
  }

  info("Insert the grandparent");
  await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: "menu",
    recordId: grandParentGuid,
  });
  equal(
    PlacesUtils.annotations.getItemAnnotation(childId, SYNC_PARENT_ANNO),
    parentGuid,
    "Child should still have orphan anno"
  );

  info("Insert the missing parent");
  {
    let parent = await PlacesSyncUtils.bookmarks.insert({
      kind: "folder",
      parentRecordId: grandParentGuid,
      recordId: parentGuid,
    });
    equal(
      parent.recordId,
      parentGuid,
      "Should insert parent with requested GUID"
    );
    equal(
      parent.parentRecordId,
      grandParentGuid,
      "Parent should be child of grandparent"
    );
    ok(
      !PlacesUtils.annotations.itemHasAnnotation(childId, SYNC_PARENT_ANNO),
      "Orphan anno should be removed after reparenting"
    );

    let child = await PlacesUtils.bookmarks.fetch({ guid: childGuid });
    equal(
      child.parentGuid,
      parentGuid,
      "Should reparent child after inserting missing parent"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_move_orphans() {
  let nonexistentRecordId = makeGuid();
  let fxBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getfirefox.com",
  });
  let tbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getthunderbird.com",
  });

  info("Verify synced orphan annos match");
  {
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids.sort(),
      [fxBmk.recordId, tbBmk.recordId].sort(),
      "Orphaned bookmarks should match before moving"
    );
  }

  info("Move synced orphan using async API");
  {
    await PlacesUtils.bookmarks.update({
      guid: fxBmk.recordId,
      parentGuid: PlacesUtils.bookmarks.menuGuid,
      index: PlacesUtils.bookmarks.DEFAULT_INDEX,
    });
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids,
      [tbBmk.recordId],
      "Should remove orphan annos from updated bookmark"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_reorder_orphans() {
  let nonexistentRecordId = makeGuid();
  let fxBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getfirefox.com",
  });
  let tbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getthunderbird.com",
  });
  let mozBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "https://mozilla.org",
  });

  info("Verify synced orphan annos match");
  {
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids.sort(),
      [fxBmk.recordId, tbBmk.recordId, mozBmk.recordId].sort(),
      "Orphaned bookmarks should match before reordering"
    );
  }

  info("Reorder synced orphans");
  {
    await PlacesUtils.bookmarks.reorder(PlacesUtils.bookmarks.unfiledGuid, [
      tbBmk.recordId,
      fxBmk.recordId,
    ]);
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids,
      [mozBmk.recordId],
      "Should remove orphan annos from explicitly reordered bookmarks"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_set_orphan_indices() {
  let nonexistentRecordId = makeGuid();
  let fxBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getfirefox.com",
  });
  let tbBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getthunderbird.com",
  });

  info("Verify synced orphan annos match");
  {
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids.sort(),
      [fxBmk.recordId, tbBmk.recordId].sort(),
      "Orphaned bookmarks should match before changing indices"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_unsynced_orphans() {
  let nonexistentRecordId = makeGuid();
  let newBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getfirefox.com",
  });
  let unknownBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    recordId: makeGuid(),
    parentRecordId: nonexistentRecordId,
    url: "http://getthunderbird.com",
  });
  await PlacesTestUtils.setBookmarkSyncFields(
    {
      guid: newBmk.recordId,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NEW,
    },
    {
      guid: unknownBmk.recordId,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN,
    }
  );

  info("Move unsynced orphan");
  {
    let unknownGuid = await PlacesSyncUtils.bookmarks.recordIdToGuid(
      unknownBmk.recordId
    );
    await PlacesUtils.bookmarks.update({
      guid: unknownGuid,
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      index: PlacesUtils.bookmarks.DEFAULT_INDEX,
    });
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids.sort(),
      [newBmk.recordId].sort(),
      "Should remove orphan annos from moved unsynced bookmark"
    );
  }

  info("Reorder unsynced orphans");
  {
    await PlacesUtils.bookmarks.reorder(PlacesUtils.bookmarks.unfiledGuid, [
      newBmk.recordId,
    ]);
    let orphanGuids = await PlacesSyncUtils.bookmarks.fetchGuidsWithAnno(
      SYNC_PARENT_ANNO,
      nonexistentRecordId
    );
    deepEqual(
      orphanGuids,
      [],
      "Should remove orphan annos from reordered unsynced bookmarks"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_fetch() {
  let folder = await PlacesSyncUtils.bookmarks.insert({
    recordId: makeGuid(),
    parentRecordId: "menu",
    kind: "folder",
  });
  let bmk = await PlacesSyncUtils.bookmarks.insert({
    recordId: makeGuid(),
    parentRecordId: "menu",
    kind: "bookmark",
    url: "https://example.com",
    tags: ["taggy"],
  });
  let folderBmk = await PlacesSyncUtils.bookmarks.insert({
    recordId: makeGuid(),
    parentRecordId: folder.recordId,
    kind: "bookmark",
    url: "https://example.org",
    keyword: "kw",
  });
  let folderSep = await PlacesSyncUtils.bookmarks.insert({
    recordId: makeGuid(),
    parentRecordId: folder.recordId,
    kind: "separator",
  });
  let tagQuery = await PlacesSyncUtils.bookmarks.insert({
    kind: "query",
    recordId: makeGuid(),
    parentRecordId: "toolbar",
    url: "place:tag=taggy",
    folder: "taggy",
    title: "Tagged stuff",
  });

  info("Fetch empty folder");
  {
    let item = await PlacesSyncUtils.bookmarks.fetch(folder.recordId);
    deepEqual(
      item,
      {
        recordId: folder.recordId,
        kind: "folder",
        parentRecordId: "menu",
        childRecordIds: [folderBmk.recordId, folderSep.recordId],
        parentTitle: "menu",
        dateAdded: item.dateAdded,
        title: "",
      },
      "Should include children, title, and parent title in folder"
    );
  }

  info("Fetch bookmark with tags");
  {
    let item = await PlacesSyncUtils.bookmarks.fetch(bmk.recordId);
    deepEqual(
      Object.keys(item).sort(),
      [
        "recordId",
        "kind",
        "parentRecordId",
        "url",
        "tags",
        "parentTitle",
        "title",
        "dateAdded",
      ].sort(),
      "Should include bookmark-specific properties"
    );
    equal(item.recordId, bmk.recordId, "Sync ID should match");
    equal(item.url.href, "https://example.com/", "Should return URL");
    equal(item.parentRecordId, "menu", "Should return parent sync ID");
    deepEqual(item.tags, ["taggy"], "Should return tags");
    equal(item.parentTitle, "menu", "Should return parent title");
    strictEqual(item.title, "", "Should return empty title");
  }

  info("Fetch bookmark with keyword; without parent title");
  {
    let item = await PlacesSyncUtils.bookmarks.fetch(folderBmk.recordId);
    deepEqual(
      Object.keys(item).sort(),
      [
        "recordId",
        "kind",
        "parentRecordId",
        "url",
        "keyword",
        "tags",
        "parentTitle",
        "title",
        "dateAdded",
      ].sort(),
      "Should omit blank bookmark-specific properties"
    );
    deepEqual(item.tags, [], "Tags should be empty");
    equal(item.keyword, "kw", "Should return keyword");
    strictEqual(
      item.parentTitle,
      "",
      "Should include parent title even if empty"
    );
    strictEqual(item.title, "", "Should include bookmark title even if empty");
  }

  info("Fetch separator");
  {
    let item = await PlacesSyncUtils.bookmarks.fetch(folderSep.recordId);
    strictEqual(item.index, 1, "Should return separator position");
  }

  info("Fetch tag query");
  {
    let item = await PlacesSyncUtils.bookmarks.fetch(tagQuery.recordId);
    deepEqual(
      Object.keys(item).sort(),
      [
        "recordId",
        "kind",
        "parentRecordId",
        "url",
        "title",
        "folder",
        "parentTitle",
        "dateAdded",
      ].sort(),
      "Should include query-specific properties"
    );
    equal(
      item.url.href,
      `place:tag=taggy`,
      "Should not rewrite outgoing tag queries"
    );
    equal(item.folder, "taggy", "Should return tag name for tag queries");
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_new_parent() {
  await ignoreChangedRoots();

  let {
    syncedGuids,
    unsyncedFolder,
  } = await moveSyncedBookmarksToUnsyncedParent();

  info("Unsynced parent and synced items should be tracked");
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(changes).sort(),
    [
      syncedGuids.folder,
      syncedGuids.topBmk,
      syncedGuids.childBmk,
      unsyncedFolder.guid,
      "menu",
    ].sort(),
    "Should return change records for moved items and new parent"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_deleted_folder() {
  await ignoreChangedRoots();

  let {
    syncedGuids,
    unsyncedFolder,
  } = await moveSyncedBookmarksToUnsyncedParent();

  info("Remove unsynced new folder");
  await PlacesUtils.bookmarks.remove(unsyncedFolder.guid);

  info("Deleted synced items should be tracked; unsynced folder should not");
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(changes).sort(),
    [
      syncedGuids.folder,
      syncedGuids.topBmk,
      syncedGuids.childBmk,
      "menu",
    ].sort(),
    "Should return change records for all deleted items"
  );
  for (let guid of Object.values(syncedGuids)) {
    strictEqual(
      changes[guid].tombstone,
      true,
      `Tombstone flag should be set for deleted item ${guid}`
    );
    equal(
      changes[guid].counter,
      1,
      `Change counter should be 1 for deleted item ${guid}`
    );
    equal(
      changes[guid].status,
      PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
      `Sync status should be normal for deleted item ${guid}`
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_import_html() {
  await ignoreChangedRoots();

  info("Add unsynced bookmark");
  let unsyncedBmk = await PlacesUtils.bookmarks.insert({
    type: PlacesUtils.bookmarks.TYPE_BOOKMARK,
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    url: "https://example.com",
  });

  {
    let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
      unsyncedBmk.guid
    );
    ok(
      fields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
      ),
      "Unsynced bookmark statuses should match"
    );
  }

  info("Import new bookmarks from HTML");
  let { path } = do_get_file("./sync_utils_bookmarks.html");
  await BookmarkHTMLUtils.importFromFile(path);

  // Bookmarks.html doesn't store IDs, so we need to look these up.
  let mozBmk = await PlacesUtils.bookmarks.fetch({
    url: "https://www.mozilla.org/",
  });
  let fxBmk = await PlacesUtils.bookmarks.fetch({
    url: "https://www.mozilla.org/en-US/firefox/",
  });
  // All Bookmarks.html bookmarks are stored under the menu. For toolbar
  // bookmarks, this means they're imported into a "Bookmarks Toolbar"
  // subfolder under the menu, instead of the real toolbar root.
  let toolbarSubfolder = (
    await PlacesUtils.bookmarks.search({
      title: "Bookmarks Toolbar",
    })
  ).find(item => item.guid != PlacesUtils.bookmarks.toolbarGuid);
  let importedFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    mozBmk.guid,
    fxBmk.guid,
    toolbarSubfolder.guid
  );
  ok(
    importedFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Sync statuses should match for HTML imports"
  );

  info("Fetch new HTML imports");
  let newChanges = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(newChanges).sort(),
    [
      mozBmk.guid,
      fxBmk.guid,
      toolbarSubfolder.guid,
      "menu",
      unsyncedBmk.guid,
    ].sort(),
    "Should return new IDs imported from HTML file"
  );
  let newFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    unsyncedBmk.guid,
    mozBmk.guid,
    fxBmk.guid,
    toolbarSubfolder.guid
  );
  ok(
    newFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Pulling new HTML imports should not mark them as syncing"
  );

  info("Mark new HTML imports as syncing");
  await PlacesSyncUtils.bookmarks.markChangesAsSyncing(newChanges);
  let normalFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    unsyncedBmk.guid,
    mozBmk.guid,
    fxBmk.guid,
    toolbarSubfolder.guid
  );
  ok(
    normalFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NORMAL
    ),
    "Marking new HTML imports as syncing should update their statuses"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_import_json() {
  await ignoreChangedRoots();

  info("Add synced folder");
  let syncedFolder = await PlacesUtils.bookmarks.insert({
    type: PlacesUtils.bookmarks.TYPE_FOLDER,
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    title: "syncedFolder",
  });
  await PlacesTestUtils.setBookmarkSyncFields({
    guid: syncedFolder.guid,
    syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
  });

  info("Import new bookmarks from JSON");
  let { path } = do_get_file("./sync_utils_bookmarks.json");
  await BookmarkJSONUtils.importFromFile(path);
  {
    let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
      syncedFolder.guid,
      "NnvGl3CRA4hC",
      "APzP8MupzA8l"
    );
    deepEqual(
      fields.map(field => field.syncStatus),
      [
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NEW,
        PlacesUtils.bookmarks.SYNC_STATUS.NEW,
      ],
      "Sync statuses should match for JSON imports"
    );
  }

  info("Fetch new JSON imports");
  let newChanges = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(newChanges).sort(),
    [
      "NnvGl3CRA4hC",
      "APzP8MupzA8l",
      "menu",
      "toolbar",
      syncedFolder.guid,
    ].sort(),
    "Should return items imported from JSON backup"
  );
  let existingFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    syncedFolder.guid,
    "NnvGl3CRA4hC",
    "APzP8MupzA8l"
  );
  deepEqual(
    existingFields.map(field => field.syncStatus),
    [
      PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
      PlacesUtils.bookmarks.SYNC_STATUS.NEW,
      PlacesUtils.bookmarks.SYNC_STATUS.NEW,
    ],
    "Pulling new JSON imports should not mark them as syncing"
  );

  info("Mark new JSON imports as syncing");
  await PlacesSyncUtils.bookmarks.markChangesAsSyncing(newChanges);
  let normalFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    syncedFolder.guid,
    "NnvGl3CRA4hC",
    "APzP8MupzA8l"
  );
  ok(
    normalFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NORMAL
    ),
    "Marking new JSON imports as syncing should update their statuses"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_restore_json_tracked() {
  await ignoreChangedRoots();

  let unsyncedBmk = await PlacesUtils.bookmarks.insert({
    type: PlacesUtils.bookmarks.TYPE_BOOKMARK,
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    url: "https://example.com",
  });
  info(`Unsynced bookmark GUID: ${unsyncedBmk.guid}`);
  let syncedFolder = await PlacesUtils.bookmarks.insert({
    type: PlacesUtils.bookmarks.TYPE_FOLDER,
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    title: "syncedFolder",
  });
  info(`Synced folder GUID: ${syncedFolder.guid}`);
  await PlacesTestUtils.setBookmarkSyncFields({
    guid: syncedFolder.guid,
    syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
  });
  {
    let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
      unsyncedBmk.guid,
      syncedFolder.guid
    );
    deepEqual(
      fields.map(field => field.syncStatus),
      [
        PlacesUtils.bookmarks.SYNC_STATUS.NEW,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
      ],
      "Sync statuses should match before restoring from JSON"
    );
  }

  info("Restore from JSON, replacing existing items");
  let { path } = do_get_file("./sync_utils_bookmarks.json");
  await BookmarkJSONUtils.importFromFile(path, { replace: true });
  {
    let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
      "NnvGl3CRA4hC",
      "APzP8MupzA8l"
    );
    ok(
      fields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
      ),
      "All bookmarks should be NEW after restoring from JSON"
    );
  }

  info("Fetch new items restored from JSON");
  {
    let changes = await PlacesSyncUtils.bookmarks.pullChanges();
    deepEqual(
      Object.keys(changes).sort(),
      [
        "menu",
        "toolbar",
        "unfiled",
        "mobile",
        "NnvGl3CRA4hC",
        "APzP8MupzA8l",
      ].sort(),
      "Should restore items from JSON backup"
    );

    let existingFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      PlacesUtils.bookmarks.menuGuid,
      PlacesUtils.bookmarks.toolbarGuid,
      PlacesUtils.bookmarks.unfiledGuid,
      PlacesUtils.bookmarks.mobileGuid,
      "NnvGl3CRA4hC",
      "APzP8MupzA8l"
    );
    ok(
      existingFields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
      ),
      "Items restored from JSON backup should not be marked as syncing"
    );

    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones,
      [],
      "Tombstones should not exist after restoring from JSON backup"
    );

    await PlacesSyncUtils.bookmarks.markChangesAsSyncing(changes);
    let normalFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      PlacesUtils.bookmarks.menuGuid,
      PlacesUtils.bookmarks.toolbarGuid,
      PlacesUtils.bookmarks.unfiledGuid,
      "NnvGl3CRA4hC",
      "APzP8MupzA8l"
    );
    ok(
      normalFields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NORMAL
      ),
      "Roots and NEW items restored from JSON backup should be marked as NORMAL"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pullChanges_tombstones() {
  await ignoreChangedRoots();

  info("Insert new bookmarks");
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    children: [
      {
        guid: "bookmarkAAAA",
        url: "http://example.com/a",
        title: "A",
      },
      {
        guid: "bookmarkBBBB",
        url: "http://example.com/b",
        title: "B",
      },
    ],
  });

  info("Manually insert conflicting tombstone for new bookmark");
  await PlacesUtils.withConnectionWrapper(
    "test_pullChanges_tombstones",
    async function(db) {
      await db.executeCached(
        `
        INSERT INTO moz_bookmarks_deleted(guid)
        VALUES(:guid)`,
        { guid: "bookmarkAAAA" }
      );
    }
  );

  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(changes).sort(),
    ["bookmarkAAAA", "bookmarkBBBB", "menu"],
    "Should handle undeleted items when returning changes"
  );
  strictEqual(
    changes.bookmarkAAAA.tombstone,
    false,
    "Should replace tombstone for A with undeleted item"
  );
  strictEqual(
    changes.bookmarkBBBB.tombstone,
    false,
    "Should not report B as deleted"
  );

  await setChangesSynced(changes);

  let newChanges = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    newChanges,
    {},
    "Should not return changes after marking undeleted items as synced"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_pushChanges() {
  await ignoreChangedRoots();

  info("Populate test bookmarks");
  let guids = await populateTree(
    PlacesUtils.bookmarks.menuGuid,
    {
      kind: "bookmark",
      title: "unknownBmk",
      url: "https://example.org",
    },
    {
      kind: "bookmark",
      title: "syncedBmk",
      url: "https://example.com",
    },
    {
      kind: "bookmark",
      title: "newBmk",
      url: "https://example.info",
    },
    {
      kind: "bookmark",
      title: "deletedBmk",
      url: "https://example.edu",
    },
    {
      kind: "bookmark",
      title: "unchangedBmk",
      url: "https://example.systems",
    }
  );

  info("Update sync statuses");
  await PlacesTestUtils.setBookmarkSyncFields(
    {
      guid: guids.syncedBmk,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
    },
    {
      guid: guids.unknownBmk,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN,
    },
    {
      guid: guids.deletedBmk,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
    },
    {
      guid: guids.unchangedBmk,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
      syncChangeCounter: 0,
    }
  );

  info("Change synced bookmark; should bump change counter");
  await PlacesUtils.bookmarks.update({
    guid: guids.syncedBmk,
    url: "https://example.ninja",
  });

  info("Remove synced bookmark");
  {
    await PlacesUtils.bookmarks.remove(guids.deletedBmk);
    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    ok(
      tombstones.some(({ guid }) => guid == guids.deletedBmk),
      "Should write tombstone for deleted synced bookmark"
    );
  }

  info("Pull changes");
  let totalSyncChanges = PlacesUtils.bookmarks.totalSyncChanges;
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  {
    let actualChanges = Object.entries(changes).map(([recordId, change]) => ({
      recordId,
      syncChangeCounter: change.counter,
    }));
    let expectedChanges = [
      {
        recordId: guids.unknownBmk,
        syncChangeCounter: 1,
      },
      {
        // Parent of changed bookmarks.
        recordId: "menu",
        syncChangeCounter: 6,
      },
      {
        recordId: guids.syncedBmk,
        syncChangeCounter: 2,
      },
      {
        recordId: guids.newBmk,
        syncChangeCounter: 1,
      },
      {
        recordId: guids.deletedBmk,
        syncChangeCounter: 1,
      },
    ];
    deepEqual(
      sortBy(actualChanges, "recordId"),
      sortBy(expectedChanges, "recordId"),
      "Should return deleted, new, and unknown bookmarks"
    );
  }

  info("Modify changed bookmark to bump its counter");
  await PlacesUtils.bookmarks.update({
    guid: guids.newBmk,
    url: "https://example.club",
  });

  info("Mark some bookmarks as synced");
  for (let title of ["unknownBmk", "newBmk", "deletedBmk"]) {
    let guid = guids[title];
    strictEqual(
      changes[guid].synced,
      false,
      "All bookmarks should not be marked as synced yet"
    );
    changes[guid].synced = true;
  }

  await PlacesSyncUtils.bookmarks.pushChanges(changes);
  equal(PlacesUtils.bookmarks.totalSyncChanges, totalSyncChanges + 4);

  {
    let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
      guids.newBmk,
      guids.unknownBmk
    );
    ok(
      fields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NORMAL
      ),
      "Should update sync statuses for synced bookmarks"
    );
  }

  {
    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    ok(
      !tombstones.some(({ guid }) => guid == guids.deletedBmk),
      "Should remove tombstone after syncing"
    );

    let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      guids.unknownBmk,
      guids.syncedBmk,
      guids.newBmk
    );
    {
      let info = syncFields.find(field => field.guid == guids.unknownBmk);
      equal(
        info.syncStatus,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        "Syncing an UNKNOWN bookmark should set its sync status to NORMAL"
      );
      strictEqual(
        info.syncChangeCounter,
        0,
        "Syncing an UNKNOWN bookmark should reduce its change counter"
      );
    }
    {
      let info = syncFields.find(field => field.guid == guids.syncedBmk);
      equal(
        info.syncStatus,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        "Syncing a NORMAL bookmark should not update its sync status"
      );
      equal(
        info.syncChangeCounter,
        2,
        "Should not reduce counter for NORMAL bookmark not marked as synced"
      );
    }
    {
      let info = syncFields.find(field => field.guid == guids.newBmk);
      equal(
        info.syncStatus,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        "Syncing a NEW bookmark should update its sync status"
      );
      strictEqual(
        info.syncChangeCounter,
        1,
        "Updating new bookmark after pulling changes should bump change counter"
      );
    }
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_changes_between_pull_and_push() {
  await ignoreChangedRoots();

  info("Populate test bookmarks");
  let guids = await populateTree(PlacesUtils.bookmarks.menuGuid, {
    kind: "bookmark",
    title: "bmk",
    url: "https://example.info",
  });

  info("Update sync statuses");
  await PlacesTestUtils.setBookmarkSyncFields({
    guid: guids.bmk,
    syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
    syncChangeCounter: 1,
  });

  info("Pull changes");
  let totalSyncChanges = PlacesUtils.bookmarks.totalSyncChanges;
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  Assert.equal(changes[guids.bmk].counter, 1);
  Assert.equal(changes[guids.bmk].tombstone, false);

  // delete the bookmark.
  await PlacesUtils.bookmarks.remove(guids.bmk);

  info("Push changes");
  await PlacesSyncUtils.bookmarks.pushChanges(changes);
  equal(PlacesUtils.bookmarks.totalSyncChanges, totalSyncChanges + 2);

  // we should have a tombstone.
  let ts = await PlacesTestUtils.fetchSyncTombstones();
  Assert.equal(ts.length, 1);
  Assert.equal(ts[0].guid, guids.bmk);

  // there should be no record for the item we deleted.
  Assert.strictEqual(await PlacesUtils.bookmarks.fetch(guids.bmk), null);

  // and re-fetching changes should list it as a tombstone.
  changes = await PlacesSyncUtils.bookmarks.pullChanges();
  Assert.equal(changes[guids.bmk].counter, 1);
  Assert.equal(changes[guids.bmk].tombstone, true);

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_touch() {
  await ignoreChangedRoots();

  strictEqual(
    await PlacesSyncUtils.bookmarks.touch(makeGuid()),
    null,
    "Should not revive nonexistent items"
  );

  {
    let folder = await PlacesSyncUtils.bookmarks.insert({
      kind: "folder",
      recordId: makeGuid(),
      parentRecordId: "menu",
    });
    strictEqual(
      await PlacesSyncUtils.bookmarks.touch(folder.recordId),
      null,
      "Should not revive folders"
    );
  }

  {
    let bmk = await PlacesSyncUtils.bookmarks.insert({
      kind: "bookmark",
      recordId: makeGuid(),
      parentRecordId: "menu",
      url: "https://mozilla.org",
    });

    let changes = await PlacesSyncUtils.bookmarks.touch(bmk.recordId);
    deepEqual(
      Object.keys(changes).sort(),
      [bmk.recordId, "menu"].sort(),
      "Should return change records for revived bookmark and parent"
    );
    equal(
      changes[bmk.recordId].counter,
      1,
      "Change counter for revived bookmark should be 1"
    );

    await setChangesSynced(changes);
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_separator() {
  await ignoreChangedRoots();

  await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: "menu",
    recordId: makeGuid(),
    url: "https://example.com",
  });
  let childBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: "menu",
    recordId: makeGuid(),
    url: "https://foo.bar",
  });
  let separatorRecordId = makeGuid();
  let separator = await PlacesSyncUtils.bookmarks.insert({
    kind: "separator",
    parentRecordId: "menu",
    recordId: separatorRecordId,
  });
  await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: "menu",
    recordId: makeGuid(),
    url: "https://bar.foo",
  });

  let child2Guid = await PlacesSyncUtils.bookmarks.recordIdToGuid(
    childBmk.recordId
  );
  let parentGuid = await await PlacesSyncUtils.bookmarks.recordIdToGuid("menu");
  let separatorGuid = PlacesSyncUtils.bookmarks.recordIdToGuid(
    separatorRecordId
  );

  info("Move a bookmark around the separator");
  await PlacesUtils.bookmarks.update({
    guid: child2Guid,
    parentGuid,
    index: 2,
  });
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(Object.keys(changes).sort(), [separator.recordId, "menu"].sort());

  await setChangesSynced(changes);

  info("Move a separator around directly");
  await PlacesUtils.bookmarks.update({
    guid: separatorGuid,
    parentGuid,
    index: 0,
  });

  changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(Object.keys(changes).sort(), [separator.recordId, "menu"].sort());

  await setChangesSynced(changes);

  info("Move a separator around directly using update");
  await PlacesUtils.bookmarks.update({ guid: separatorGuid, index: 2 });
  changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(Object.keys(changes).sort(), [separator.recordId, "menu"].sort());

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_remove() {
  await ignoreChangedRoots();

  info("Insert subtree for removal");
  let parentFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: "menu",
    recordId: makeGuid(),
  });
  let childBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.com",
  });
  let childFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
  });
  let grandChildBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: childFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.edu",
  });

  info("Remove entire subtree");
  await PlacesSyncUtils.bookmarks.remove([
    parentFolder.recordId,
    childFolder.recordId,
    childBmk.recordId,
    grandChildBmk.recordId,
  ]);

  /**
   * Even though we've removed the entire subtree, we still track the menu
   * because we 1) removed `parentFolder`, 2) reparented `childFolder` to
   * `menu`, and 3) removed `childFolder`.
   *
   * This depends on the order of the folders passed to `remove`. If we
   * removed `childFolder` *before* `parentFolder`, we wouldn't reparent
   * anything to `menu`.
   *
   * `deleteSyncedFolder` could check if it's reparenting an item that will
   * eventually be removed, and avoid bumping the new parent's change counter.
   * Unfortunately, that introduces inconsistencies if `deleteSyncedFolder` is
   * interrupted by shutdown. If the server changes before the next sync,
   * we'll never upload records for the reparented item or the new parent.
   *
   * Another alternative: we can try to remove folders in level order, instead
   * of the order passed to `remove`. But that means we need a recursive query
   * to determine the order. This is already enough of an edge case that
   * occasionally reuploading the closest living ancestor is the simplest
   * solution.
   */
  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(changes),
    ["menu"],
    "Should track closest living ancestor of removed subtree"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_remove_partial() {
  await ignoreChangedRoots();

  info("Insert subtree for partial removal");
  let parentFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: PlacesUtils.bookmarks.menuGuid,
    recordId: makeGuid(),
  });
  let prevSiblingBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.net",
  });
  let childBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.com",
  });
  let nextSiblingBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.org",
  });
  let childFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
  });
  let grandChildBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://example.edu",
  });
  let grandChildSiblingBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: parentFolder.recordId,
    recordId: makeGuid(),
    url: "https://mozilla.org",
  });
  let grandChildFolder = await PlacesSyncUtils.bookmarks.insert({
    kind: "folder",
    parentRecordId: childFolder.recordId,
    recordId: makeGuid(),
  });
  let greatGrandChildPrevSiblingBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: grandChildFolder.recordId,
    recordId: makeGuid(),
    url: "http://getfirefox.com",
  });
  let greatGrandChildNextSiblingBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: grandChildFolder.recordId,
    recordId: makeGuid(),
    url: "http://getthunderbird.com",
  });
  let menuBmk = await PlacesSyncUtils.bookmarks.insert({
    kind: "bookmark",
    parentRecordId: "menu",
    recordId: makeGuid(),
    url: "https://example.info",
  });

  info("Remove subset of folders and items in subtree");
  let changes = await PlacesSyncUtils.bookmarks.remove([
    parentFolder.recordId,
    childBmk.recordId,
    grandChildFolder.recordId,
    grandChildBmk.recordId,
    childFolder.recordId,
  ]);
  deepEqual(
    Object.keys(changes).sort(),
    [
      // Closest living ancestor.
      "menu",
      // Reparented bookmarks.
      prevSiblingBmk.recordId,
      nextSiblingBmk.recordId,
      grandChildSiblingBmk.recordId,
      greatGrandChildPrevSiblingBmk.recordId,
      greatGrandChildNextSiblingBmk.recordId,
    ].sort(),
    "Should track reparented bookmarks and their closest living ancestor"
  );

  /**
   * Reparented bookmarks should maintain their order relative to their
   * siblings: `prevSiblingBmk` (0) should precede `nextSiblingBmk` (2) in the
   * menu, and `greatGrandChildPrevSiblingBmk` (0) should precede
   * `greatGrandChildNextSiblingBmk` (1).
   */
  let menuChildren = await PlacesSyncUtils.bookmarks.fetchChildRecordIds(
    PlacesUtils.bookmarks.menuGuid
  );
  deepEqual(
    menuChildren,
    [
      // Existing bookmark.
      menuBmk.recordId,
      // 1) Moved out of `parentFolder` to `menu`.
      prevSiblingBmk.recordId,
      nextSiblingBmk.recordId,
      // 3) Moved out of `childFolder` to `menu`. After this step, `childFolder`
      // is deleted.
      grandChildSiblingBmk.recordId,
      // 2) Moved out of `grandChildFolder` to `childFolder`, because we remove
      // `grandChildFolder` *before* `childFolder`. After this step,
      // `grandChildFolder` is deleted and `childFolder`'s children are
      // `[grandChildSiblingBmk, greatGrandChildPrevSiblingBmk,
      // greatGrandChildNextSiblingBmk]`.
      greatGrandChildPrevSiblingBmk.recordId,
      greatGrandChildNextSiblingBmk.recordId,
    ],
    "Should move descendants to closest living ancestor"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_migrateOldTrackerEntries() {
  let timerPrecision = Preferences.get("privacy.reduceTimerPrecision");
  Preferences.set("privacy.reduceTimerPrecision", false);

  registerCleanupFunction(function() {
    Preferences.set("privacy.reduceTimerPrecision", timerPrecision);
  });

  let unknownBmk = await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    url: "http://getfirefox.com",
    title: "Get Firefox!",
  });
  let newBmk = await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    url: "http://getthunderbird.com",
    title: "Get Thunderbird!",
  });
  let normalBmk = await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.menuGuid,
    url: "https://mozilla.org",
    title: "Mozilla",
  });

  await PlacesTestUtils.setBookmarkSyncFields(
    {
      guid: unknownBmk.guid,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN,
      syncChangeCounter: 0,
    },
    {
      guid: normalBmk.guid,
      syncStatus: PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
    }
  );
  PlacesUtils.tagging.tagURI(uri("http://getfirefox.com"), ["taggy"]);

  let tombstoneRecordId = makeGuid();
  await PlacesSyncUtils.bookmarks.migrateOldTrackerEntries([
    {
      recordId: normalBmk.guid,
      modified: Date.now(),
    },
    {
      recordId: tombstoneRecordId,
      modified: 1479162463976,
    },
  ]);

  let changes = await PlacesSyncUtils.bookmarks.pullChanges();
  deepEqual(
    Object.keys(changes).sort(),
    [normalBmk.guid, tombstoneRecordId].sort(),
    "Should return change records for migrated bookmark and tombstone"
  );

  let fields = await PlacesTestUtils.fetchBookmarkSyncFields(
    unknownBmk.guid,
    newBmk.guid,
    normalBmk.guid
  );
  for (let field of fields) {
    if (field.guid == normalBmk.guid) {
      ok(
        field.lastModified > normalBmk.lastModified,
        `Should bump last modified date for migrated bookmark ${field.guid}`
      );
      equal(
        field.syncChangeCounter,
        1,
        `Should bump change counter for migrated bookmark ${field.guid}`
      );
    } else {
      strictEqual(
        field.syncChangeCounter,
        0,
        `Should not bump change counter for ${field.guid}`
      );
    }
    equal(
      field.syncStatus,
      PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
      `Should set sync status for ${field.guid} to NORMAL`
    );
  }

  let tombstones = await PlacesTestUtils.fetchSyncTombstones();
  deepEqual(
    tombstones,
    [
      {
        guid: tombstoneRecordId,
        dateRemoved: new Date(1479162463976),
      },
    ],
    "Should write tombstone for nonexistent migrated item"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_ensureMobileQuery() {
  info("Ensure we correctly set the showMobileBookmarks preference");
  const mobilePref = "browser.bookmarks.showMobileBookmarks";
  Services.prefs.clearUserPref(mobilePref);

  await PlacesUtils.bookmarks.insert({
    guid: "bookmarkAAAA",
    parentGuid: PlacesUtils.bookmarks.mobileGuid,
    url: "http://example.com/a",
    title: "A",
  });

  await PlacesUtils.bookmarks.insert({
    guid: "bookmarkBBBB",
    parentGuid: PlacesUtils.bookmarks.mobileGuid,
    url: "http://example.com/b",
    title: "B",
  });

  await PlacesSyncUtils.bookmarks.ensureMobileQuery();

  Assert.ok(
    Services.prefs.getBoolPref(mobilePref),
    "Pref should be true where there are bookmarks in the folder."
  );

  await PlacesUtils.bookmarks.remove("bookmarkAAAA");
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");

  await PlacesSyncUtils.bookmarks.ensureMobileQuery();

  Assert.ok(
    !Services.prefs.getBoolPref(mobilePref),
    "Pref should be false where there are no bookmarks in the folder."
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_remove_stale_tombstones() {
  info("Insert and delete synced bookmark");
  {
    await PlacesUtils.bookmarks.insert({
      guid: "bookmarkAAAA",
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      url: "http://example.com/a",
      title: "A",
      source: PlacesUtils.bookmarks.SOURCES.SYNC,
    });
    await PlacesUtils.bookmarks.remove("bookmarkAAAA");
    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones.map(({ guid }) => guid),
      ["bookmarkAAAA"],
      "Should store tombstone for deleted synced bookmark"
    );
  }

  info("Reinsert deleted bookmark");
  {
    // Different parent, URL, and title, but same GUID.
    await PlacesUtils.bookmarks.insert({
      guid: "bookmarkAAAA",
      parentGuid: PlacesUtils.bookmarks.unfiledGuid,
      url: "http://example.com/a-restored",
      title: "A (Restored)",
    });

    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones,
      [],
      "Should remove tombstone for reinserted bookmark"
    );
  }

  info("Insert tree and erase everything");
  {
    await PlacesUtils.bookmarks.insertTree({
      guid: PlacesUtils.bookmarks.menuGuid,
      source: PlacesUtils.bookmarks.SOURCES.SYNC,
      children: [
        {
          guid: "bookmarkBBBB",
          url: "http://example.com/b",
          title: "B",
        },
        {
          guid: "bookmarkCCCC",
          url: "http://example.com/c",
          title: "C",
        },
      ],
    });
    await PlacesUtils.bookmarks.eraseEverything();
    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones.map(({ guid }) => guid).sort(),
      ["bookmarkBBBB", "bookmarkCCCC"],
      "Should store tombstones after erasing everything"
    );
  }

  info("Reinsert tree");
  {
    await PlacesUtils.bookmarks.insertTree({
      guid: PlacesUtils.bookmarks.mobileGuid,
      children: [
        {
          guid: "bookmarkBBBB",
          url: "http://example.com/b",
          title: "B",
        },
        {
          guid: "bookmarkCCCC",
          url: "http://example.com/c",
          title: "C",
        },
      ],
    });
    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones.map(({ guid }) => guid).sort(),
      [],
      "Should remove tombstones after reinserting tree"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_resetSyncId() {
  let syncId = await PlacesSyncUtils.bookmarks.getSyncId();
  strictEqual(syncId, "", "Should start with empty bookmarks sync ID");

  // Add a tree with a NORMAL bookmark (A), tombstone (B), NEW bookmark (C),
  // and UNKNOWN bookmark (D).
  info("Set up local tree before resetting bookmarks sync ID");
  await ignoreChangedRoots();
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    source: PlacesUtils.bookmarks.SOURCES.SYNC,
    children: [
      {
        guid: "bookmarkAAAA",
        title: "A",
        url: "http://example.com/a",
      },
      {
        guid: "bookmarkBBBB",
        title: "B",
        url: "http://example.com/b",
      },
    ],
  });
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.toolbarGuid,
    guid: "bookmarkCCCC",
    title: "C",
    url: "http://example.com/c",
  });
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    guid: "bookmarkDDDD",
    title: "D",
    url: "http://example.com/d",
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  info("Assign new bookmarks sync ID for first time");
  let newSyncId = await PlacesSyncUtils.bookmarks.resetSyncId();
  syncId = await PlacesSyncUtils.bookmarks.getSyncId();
  equal(
    newSyncId,
    syncId,
    "Should assign new bookmarks sync ID for first time"
  );

  let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    PlacesUtils.bookmarks.menuGuid,
    PlacesUtils.bookmarks.toolbarGuid,
    PlacesUtils.bookmarks.unfiledGuid,
    "bookmarkAAAA",
    "bookmarkCCCC",
    "bookmarkDDDD"
  );
  ok(
    syncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Should change all sync statuses to NEW after resetting bookmarks sync ID"
  );

  let tombstones = await PlacesTestUtils.fetchSyncTombstones();
  deepEqual(
    tombstones,
    [],
    "Should remove all tombstones after resetting bookmarks sync ID"
  );

  info("Set bookmarks last sync time");
  let lastSync = Date.now() / 1000;
  await PlacesSyncUtils.bookmarks.setLastSync(lastSync);
  equal(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    lastSync,
    "Should record bookmarks last sync time"
  );

  newSyncId = await PlacesSyncUtils.bookmarks.resetSyncId();
  notEqual(
    newSyncId,
    syncId,
    "Should set new bookmarks sync ID if one already exists"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    0,
    "Should reset bookmarks last sync time after resetting sync ID"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_wipe() {
  info("Add Sync metadata before wipe");
  let newSyncId = await PlacesSyncUtils.bookmarks.resetSyncId();
  await PlacesSyncUtils.bookmarks.setLastSync(Date.now() / 1000);

  let existingSyncId = await PlacesSyncUtils.bookmarks.getSyncId();
  equal(
    existingSyncId,
    newSyncId,
    "Ensure bookmarks sync ID was recorded before wipe"
  );

  info("Set up local tree before wipe");
  await ignoreChangedRoots();
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    source: PlacesUtils.bookmarks.SOURCES.SYNC,
    children: [
      {
        guid: "bookmarkAAAA",
        title: "A",
        url: "http://example.com/a",
      },
      {
        guid: "bookmarkBBBB",
        title: "B",
        url: "http://example.com/b",
      },
    ],
  });
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.toolbarGuid,
    guid: "bookmarkCCCC",
    title: "C",
    url: "http://example.com/c",
  });
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    guid: "bookmarkDDDD",
    title: "D",
    url: "http://example.com/d",
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  info("Wipe bookmarks");
  await PlacesSyncUtils.bookmarks.wipe();

  strictEqual(
    await PlacesSyncUtils.bookmarks.getSyncId(),
    "",
    "Should reset bookmarks sync ID after wipe"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    0,
    "Should reset bookmarks last sync after wipe"
  );
  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Wiping bookmarks locally should not wipe server"
  );

  let tombstones = await PlacesTestUtils.fetchSyncTombstones();
  deepEqual(tombstones, [], "Should drop tombstones after wipe");

  deepEqual(
    await PlacesSyncUtils.bookmarks.fetchChildRecordIds("menu"),
    [],
    "Should wipe menu children"
  );
  deepEqual(
    await PlacesSyncUtils.bookmarks.fetchChildRecordIds("toolbar"),
    [],
    "Should wipe toolbar children"
  );

  let rootSyncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    PlacesUtils.bookmarks.menuGuid,
    PlacesUtils.bookmarks.toolbarGuid,
    PlacesUtils.bookmarks.unfiledGuid
  );
  ok(
    rootSyncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Should reset all sync statuses to NEW after wipe"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_meta_eraseEverything() {
  info("Add Sync metadata before erase");
  let newSyncId = await PlacesSyncUtils.bookmarks.resetSyncId();
  let lastSync = Date.now() / 1000;
  await PlacesSyncUtils.bookmarks.setLastSync(lastSync);

  info("Set up local tree before reset");
  await ignoreChangedRoots();
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    source: PlacesUtils.bookmarks.SOURCES.SYNC,
    children: [
      {
        guid: "bookmarkAAAA",
        title: "A",
        url: "http://example.com/a",
      },
      {
        guid: "bookmarkBBBB",
        title: "B",
        url: "http://example.com/b",
      },
    ],
  });
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.toolbarGuid,
    guid: "bookmarkCCCC",
    title: "C",
    url: "http://example.com/c",
  });
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    guid: "bookmarkDDDD",
    title: "D",
    url: "http://example.com/d",
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  info("Erase all bookmarks");
  await PlacesUtils.bookmarks.eraseEverything();

  strictEqual(
    await PlacesSyncUtils.bookmarks.getSyncId(),
    newSyncId,
    "Should not reset bookmarks sync ID after erase"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    lastSync,
    "Should not reset bookmarks last sync after erase"
  );
  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Erasing everything should not wipe server"
  );

  deepEqual(
    (await PlacesTestUtils.fetchSyncTombstones()).map(info => info.guid),
    ["bookmarkAAAA", "bookmarkBBBB"],
    "Should keep tombstones after erasing everything"
  );

  let rootSyncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    PlacesUtils.bookmarks.menuGuid,
    PlacesUtils.bookmarks.toolbarGuid,
    PlacesUtils.bookmarks.unfiledGuid,
    PlacesUtils.bookmarks.mobileGuid
  );
  ok(
    rootSyncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NORMAL
    ),
    "Should not reset sync statuses after erasing everything"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_reset() {
  info("Add Sync metadata before reset");
  await PlacesSyncUtils.bookmarks.resetSyncId();
  await PlacesSyncUtils.bookmarks.setLastSync(Date.now() / 1000);

  info("Set up local tree before reset");
  await ignoreChangedRoots();
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    source: PlacesUtils.bookmarks.SOURCES.SYNC,
    children: [
      {
        guid: "bookmarkAAAA",
        title: "A",
        url: "http://example.com/a",
      },
      {
        guid: "bookmarkBBBB",
        title: "B",
        url: "http://example.com/b",
      },
    ],
  });
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.toolbarGuid,
    guid: "bookmarkCCCC",
    title: "C",
    url: "http://example.com/c",
  });
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    guid: "bookmarkDDDD",
    title: "D",
    url: "http://example.com/d",
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  info("Reset Sync metadata for bookmarks");
  await PlacesSyncUtils.bookmarks.reset();

  strictEqual(
    await PlacesSyncUtils.bookmarks.getSyncId(),
    "",
    "Should reset bookmarks sync ID after reset"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    0,
    "Should reset bookmarks last sync after reset"
  );
  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Resetting Sync metadata should not wipe server"
  );

  deepEqual(
    await PlacesTestUtils.fetchSyncTombstones(),
    [],
    "Should drop tombstones after reset"
  );

  let itemSyncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    "bookmarkAAAA",
    "bookmarkCCCC"
  );
  ok(
    itemSyncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Should reset sync statuses for existing items to NEW after reset"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_meta_restore() {
  info("Add Sync metadata before manual restore");
  await PlacesSyncUtils.bookmarks.resetSyncId();
  await PlacesSyncUtils.bookmarks.setLastSync(Date.now() / 1000);

  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Should not wipe server before manual restore"
  );

  info("Manually restore");
  let { path } = do_get_file("./sync_utils_bookmarks.json");
  await BookmarkJSONUtils.importFromFile(path, { replace: true });

  strictEqual(
    await PlacesSyncUtils.bookmarks.getSyncId(),
    "",
    "Should reset bookmarks sync ID after manual restore"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    0,
    "Should reset bookmarks last sync after manual restore"
  );
  ok(
    await PlacesSyncUtils.bookmarks.shouldWipeRemote(),
    "Should wipe server after manual restore"
  );

  let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    PlacesUtils.bookmarks.menuGuid,
    "NnvGl3CRA4hC",
    PlacesUtils.bookmarks.toolbarGuid,
    "APzP8MupzA8l"
  );
  ok(
    syncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.NEW
    ),
    "Should reset all sync stauses to NEW after manual restore"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_meta_restore_on_startup() {
  info("Add Sync metadata before simulated automatic restore");
  await PlacesSyncUtils.bookmarks.resetSyncId();
  await PlacesSyncUtils.bookmarks.setLastSync(Date.now() / 1000);

  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Should not wipe server before automatic restore"
  );

  info("Simulate automatic restore on startup");
  let { path } = do_get_file("./sync_utils_bookmarks.json");
  await BookmarkJSONUtils.importFromFile(path, {
    replace: true,
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  strictEqual(
    await PlacesSyncUtils.bookmarks.getSyncId(),
    "",
    "Should reset bookmarks sync ID after automatic restore"
  );
  strictEqual(
    await PlacesSyncUtils.bookmarks.getLastSync(),
    0,
    "Should reset bookmarks last sync after automatic restore"
  );
  ok(
    !(await PlacesSyncUtils.bookmarks.shouldWipeRemote()),
    "Should not wipe server after manual restore"
  );

  let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
    PlacesUtils.bookmarks.menuGuid,
    "NnvGl3CRA4hC",
    PlacesUtils.bookmarks.toolbarGuid,
    "APzP8MupzA8l"
  );
  ok(
    syncFields.every(
      field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN
    ),
    "Should reset all sync stauses to UNKNOWN after automatic restore"
  );

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_bookmarks_ensureCurrentSyncId() {
  info("Set up local tree");
  await ignoreChangedRoots();
  await PlacesUtils.bookmarks.insertTree({
    guid: PlacesUtils.bookmarks.menuGuid,
    source: PlacesUtils.bookmarks.SOURCES.SYNC,
    children: [
      {
        guid: "bookmarkAAAA",
        title: "A",
        url: "http://example.com/a",
      },
      {
        guid: "bookmarkBBBB",
        title: "B",
        url: "http://example.com/b",
      },
    ],
  });
  await PlacesUtils.bookmarks.remove("bookmarkBBBB");
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.toolbarGuid,
    guid: "bookmarkCCCC",
    title: "C",
    url: "http://example.com/c",
  });
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    guid: "bookmarkDDDD",
    title: "D",
    url: "http://example.com/d",
    source: PlacesUtils.bookmarks.SOURCES.RESTORE_ON_STARTUP,
  });

  let existingSyncId = await PlacesSyncUtils.bookmarks.getSyncId();
  strictEqual(existingSyncId, "", "Should start without bookmarks sync ID");

  info("Assign new bookmarks sync ID");
  {
    await PlacesSyncUtils.bookmarks.ensureCurrentSyncId("syncIdAAAAAA");

    let newSyncId = await PlacesSyncUtils.bookmarks.getSyncId();
    equal(
      newSyncId,
      "syncIdAAAAAA",
      "Should assign bookmarks sync ID if one doesn't exist"
    );

    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones.map(({ guid }) => guid),
      ["bookmarkBBBB"],
      "Should keep tombstones after assigning new bookmarks sync ID"
    );

    let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      PlacesUtils.bookmarks.menuGuid,
      PlacesUtils.bookmarks.toolbarGuid,
      PlacesUtils.bookmarks.unfiledGuid,
      "bookmarkAAAA",
      "bookmarkCCCC",
      "bookmarkDDDD"
    );
    deepEqual(
      syncFields.map(field => field.syncStatus),
      [
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NEW,
        PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN,
      ],
      "Should not reset sync statuses after assigning new bookmarks sync ID"
    );
  }

  info("Ensure existing bookmarks sync ID matches");
  {
    let lastSync = Date.now() / 1000;
    await PlacesSyncUtils.bookmarks.setLastSync(lastSync);
    await PlacesSyncUtils.bookmarks.ensureCurrentSyncId("syncIdAAAAAA");

    equal(
      await PlacesSyncUtils.bookmarks.getSyncId(),
      "syncIdAAAAAA",
      "Should keep existing bookmarks sync ID on match"
    );
    equal(
      await PlacesSyncUtils.bookmarks.getLastSync(),
      lastSync,
      "Should keep existing bookmarks last sync time on sync ID match"
    );

    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones.map(({ guid }) => guid),
      ["bookmarkBBBB"],
      "Should keep tombstones if bookmarks sync IDs match"
    );

    let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      PlacesUtils.bookmarks.menuGuid,
      PlacesUtils.bookmarks.toolbarGuid,
      PlacesUtils.bookmarks.unfiledGuid,
      "bookmarkAAAA",
      "bookmarkCCCC",
      "bookmarkDDDD"
    );
    deepEqual(
      syncFields.map(field => field.syncStatus),
      [
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NORMAL,
        PlacesUtils.bookmarks.SYNC_STATUS.NEW,
        PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN,
      ],
      "Should not reset sync statuses if bookmarks sync IDs match"
    );
  }

  info("Replace existing bookmarks sync ID with new ID");
  {
    await PlacesSyncUtils.bookmarks.ensureCurrentSyncId("syncIdBBBBBB");

    equal(
      await PlacesSyncUtils.bookmarks.getSyncId(),
      "syncIdBBBBBB",
      "Should replace existing bookmarks sync ID on mismatch"
    );
    strictEqual(
      await PlacesSyncUtils.bookmarks.getLastSync(),
      0,
      "Should reset bookmarks last sync time on sync ID mismatch"
    );

    let tombstones = await PlacesTestUtils.fetchSyncTombstones();
    deepEqual(
      tombstones,
      [],
      "Should drop tombstones after bookmarks sync ID mismatch"
    );

    let syncFields = await PlacesTestUtils.fetchBookmarkSyncFields(
      PlacesUtils.bookmarks.menuGuid,
      PlacesUtils.bookmarks.toolbarGuid,
      PlacesUtils.bookmarks.unfiledGuid,
      "bookmarkAAAA",
      "bookmarkCCCC",
      "bookmarkDDDD"
    );
    ok(
      syncFields.every(
        field => field.syncStatus == PlacesUtils.bookmarks.SYNC_STATUS.UNKNOWN
      ),
      "Should reset all sync statuses to UNKNOWN after bookmarks sync ID mismatch"
    );
  }

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesSyncUtils.bookmarks.reset();
});

add_task(async function test_history_resetSyncId() {
  let syncId = await PlacesSyncUtils.history.getSyncId();
  strictEqual(syncId, "", "Should start with empty history sync ID");

  info("Assign new history sync ID for first time");
  let newSyncId = await PlacesSyncUtils.history.resetSyncId();
  syncId = await PlacesSyncUtils.history.getSyncId();
  equal(newSyncId, syncId, "Should assign new history sync ID for first time");

  info("Set history last sync time");
  let lastSync = Date.now() / 1000;
  await PlacesSyncUtils.history.setLastSync(lastSync);
  equal(
    await PlacesSyncUtils.history.getLastSync(),
    lastSync,
    "Should record history last sync time"
  );

  newSyncId = await PlacesSyncUtils.history.resetSyncId();
  notEqual(
    newSyncId,
    syncId,
    "Should set new history sync ID if one already exists"
  );
  strictEqual(
    await PlacesSyncUtils.history.getLastSync(),
    0,
    "Should reset history last sync time after resetting sync ID"
  );

  await PlacesSyncUtils.history.reset();
});

add_task(async function test_history_ensureCurrentSyncId() {
  info("Assign new history sync ID");
  await PlacesSyncUtils.history.ensureCurrentSyncId("syncIdAAAAAA");
  equal(
    await PlacesSyncUtils.history.getSyncId(),
    "syncIdAAAAAA",
    "Should assign history sync ID if one doesn't exist"
  );

  info("Ensure existing history sync ID matches");
  let lastSync = Date.now() / 1000;
  await PlacesSyncUtils.history.setLastSync(lastSync);
  await PlacesSyncUtils.history.ensureCurrentSyncId("syncIdAAAAAA");

  equal(
    await PlacesSyncUtils.history.getSyncId(),
    "syncIdAAAAAA",
    "Should keep existing history sync ID on match"
  );
  equal(
    await PlacesSyncUtils.history.getLastSync(),
    lastSync,
    "Should keep existing history last sync time on sync ID match"
  );

  info("Replace existing history sync ID with new ID");
  await PlacesSyncUtils.history.ensureCurrentSyncId("syncIdBBBBBB");

  equal(
    await PlacesSyncUtils.history.getSyncId(),
    "syncIdBBBBBB",
    "Should replace existing history sync ID on mismatch"
  );
  strictEqual(
    await PlacesSyncUtils.history.getLastSync(),
    0,
    "Should reset history last sync time on sync ID mismatch"
  );

  await PlacesSyncUtils.history.reset();
});
