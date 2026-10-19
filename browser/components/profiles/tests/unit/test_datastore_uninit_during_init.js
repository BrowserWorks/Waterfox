/* Any copyright is dedicated to the Public Domain.
https://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

add_task(async function test_uninit_during_init() {
  startProfileService();
  let ProfilesDatastoreService = getProfilesDatastoreService();

  await ProfilesDatastoreService.init();
  let storeID = await ProfilesDatastoreService.storeID;
  Assert.ok(storeID, "Should have a store ID");
  await ProfilesDatastoreService.uninit();

  // Stall the datastore's IOUtils.makeDirectory call so that uninit is called
  // while init is still in progress.
  let moduleGlobal = Cu.getGlobalForObject(ProfilesDatastoreService);
  let realMakeDirectory = moduleGlobal.IOUtils.makeDirectory;
  let sawMakeDirectory = false;
  let { promise: gate, resolve: releaseGate } = Promise.withResolvers();
  moduleGlobal.IOUtils.makeDirectory = async (...args) => {
    sawMakeDirectory = true;
    await gate;
    return realMakeDirectory.apply(moduleGlobal.IOUtils, args);
  };

  let connectionPromise;
  let uninitPromise;
  try {
    connectionPromise = ProfilesDatastoreService.getConnection();
    Assert.ok(sawMakeDirectory, "Init should be waiting on makeDirectory");

    uninitPromise = ProfilesDatastoreService.uninit();
  } finally {
    releaseGate();
    moduleGlobal.IOUtils.makeDirectory = realMakeDirectory;
  }

  let connection = await connectionPromise;
  await uninitPromise;

  Assert.ok(
    connection._connectionData._identifier.startsWith(`${storeID}.sqlite`),
    "Should have opened the database for the real store ID"
  );
  Assert.ok(
    !ProfilesDatastoreService.initialized,
    "Service should not be initialized"
  );
  Assert.throws(
    () => connection.execute("SELECT 1"),
    /Connection is not open/,
    "Connection should have been closed"
  );
});
