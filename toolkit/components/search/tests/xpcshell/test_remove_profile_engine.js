/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function run_test() {
  // Copy an engine to [profile]/searchplugin/
  let dir = do_get_profile().clone();
  dir.append("searchplugins");
  if (!dir.exists()) {
    dir.create(dir.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
  }
  do_get_file("data/engine-override.xml").copyTo(dir, "basic.xml");

  let file = dir.clone();
  file.append("basic.xml");
  Assert.ok(file.exists());

  await AddonTestUtils.promiseStartupManager();
  await Services.search.init();

  // Install the same engine through a supported way.
  useHttpServer();
  await addTestEngines([{ name: "basic", xmlFileName: "engine-override.xml" }]);
  await promiseAfterCache();
  let data = await promiseCacheData();

  // Put the filePath inside the cache file, to simulate what a pre-58 version
  // of Firefox would have done.
  for (let engine of data.engines) {
    if (engine._name == "basic") {
      engine.filePath = file.path;
    }
  }

  await promiseSaveCacheData(data);

  await asyncReInit();

  // test the engine is loaded ok.
  let engine = Services.search.getEngineByName("basic");
  Assert.notEqual(engine, null);

  // remove the engine and verify the file has been removed too.
  await Services.search.removeEngine(engine);
  Assert.ok(!file.exists());
});
