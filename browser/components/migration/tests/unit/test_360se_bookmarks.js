"use strict";

add_task(async function() {
  registerFakePath("AppData", do_get_file("AppData/Roaming/"));

  let migrator = await MigrationUtils.getMigrator("360se");
  // Sanity check for the source.
  Assert.ok(await migrator.isSourceAvailable());

  let profiles = await migrator.getSourceProfiles();
  Assert.equal(profiles.length, 2, "Should present two profiles");
  Assert.equal(
    profiles[0].name,
    "test@firefox.com.cn",
    "Current logged in user should be the first"
  );
  Assert.equal(
    profiles[profiles.length - 1].name,
    "Default",
    "Default user should be the last"
  );

  // Wait for the imported bookmarks.  Check that "From 360 Secure Browser"
  // folders are created on the toolbar.
  let source = MigrationUtils.getLocalizedString("sourceName360se");
  let label = MigrationUtils.getLocalizedString("importedBookmarksFolder", [
    source,
  ]);

  let expectedParents = [PlacesUtils.toolbarFolderId];
  let itemCount = 0;

  let gotFolder = false;
  let listener = events => {
    for (let event of events) {
      if (event.title != label) {
        itemCount++;
      }
      if (
        event.itemType == PlacesUtils.bookmarks.TYPE_FOLDER &&
        event.title == "360 \u76f8\u5173"
      ) {
        gotFolder = true;
      }
      if (expectedParents.length && event.title == label) {
        let index = expectedParents.indexOf(event.parentId);
        Assert.ok(index != -1, "Found expected parent");
        expectedParents.splice(index, 1);
      }
    }
  };
  PlacesUtils.observers.addListener(["bookmark-added"], listener);

  await promiseMigration(migrator, MigrationUtils.resourceTypes.BOOKMARKS, {
    id: "default",
  });
  PlacesUtils.observers.removeListener(["bookmark-added"], listener);

  // Check the bookmarks have been imported to all the expected parents.
  Assert.ok(!expectedParents.length, "No more expected parents");
  Assert.ok(gotFolder, "Should have seen the folder get imported");
  Assert.equal(itemCount, 10, "Should import all 10 items.");
  // Check that the telemetry matches:
  Assert.equal(
    MigrationUtils._importQuantities.bookmarks,
    itemCount,
    "Telemetry reporting correct."
  );
});
