/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * This test ensures we are able to update a search engine extension that
 * appears in the search engine list on about:preferences#search.
 */

const { AddonTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/AddonTestUtils.sys.mjs"
);
const { SearchTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/SearchTestUtils.sys.mjs"
);
const { SearchUtils } = ChromeUtils.importESModule(
  "moz-src:///toolkit/components/search/SearchUtils.sys.mjs"
);

AddonTestUtils.initMochitest(this);
SearchTestUtils.init(this);

add_task(async function test_change_engine() {
  await openPreferencesViaOpenPreferencesAPI("search", { leaveOpen: true });

  let doc = gBrowser.selectedBrowser.contentDocument;

  await SearchTestUtils.installSearchExtension({
    id: "example@tests.mozilla.org",
    name: "Example",
    version: "1.0",
    keyword: "foo",
    icons: {
      16: "img123.png",
    },
  });

  let engineList = doc.querySelector("moz-box-group#engineList");
  let row = [...engineList.children].find(r =>
    r.id.includes("example@tests.mozilla.org")
  ).children[0];

  Assert.notEqual(row, undefined, "Should have found the entry");
  Assert.ok(
    row.iconSrc.includes("img123.png"),
    "Should have the correct image URL"
  );
  Assert.equal(row.description, "foo", "Should show the correct keyword");

  let updatedPromise = SearchTestUtils.promiseSearchNotification(
    SearchUtils.MODIFIED_TYPE.CHANGED,
    SearchUtils.TOPIC_ENGINE_MODIFIED
  );
  await SearchTestUtils.installSearchExtension({
    id: "example@tests.mozilla.org",
    name: "Example 2",
    version: "2.0",
    keyword: "bar",
    icons: {
      16: "img456.png",
    },
  });
  await updatedPromise;

  let updatedRow = [...engineList.children].find(r =>
    r.id.includes("example@tests.mozilla.org")
  ).children[0];
  Assert.notEqual(updatedRow, undefined, "Should have found the updated entry");
  Assert.ok(
    updatedRow.iconSrc.includes("img456.png"),
    "Should have the correct updated image URL"
  );
  Assert.equal(
    updatedRow.description,
    "bar",
    "Should show the correct updated keyword"
  );

  gBrowser.removeCurrentTab();
});
