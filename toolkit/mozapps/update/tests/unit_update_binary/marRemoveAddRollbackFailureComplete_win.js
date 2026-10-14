/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/**
 * Complete MAR rollback test for files removed then re-added.
 *
 * We inject a failure *after* the re-adds. The failure itself doesn't matter,
 * what we are testing is that the rollback correctly restores the install
 * directory to its pre-update state.
 */

async function run_test() {
  if (!setupTestCommon()) {
    return;
  }
  const STATE_AFTER_STAGE = gIsServiceTest ? STATE_PENDING_SVC : STATE_PENDING;
  gTestFiles = gTestFilesCompleteSuccess;
  gTestDirs = gTestDirsCompleteSuccess;
  setTestFilesAndDirsForFailure();
  await setupUpdaterTest(FILE_COMPLETE_MAR, false);
  // Force a failure by locking 1/10/10text0. That file is NOT listed in the
  // precomplete, so it still exists when the manifest reaches
  // "add 1/10/10text0". AddFile::Execute therefore fails to move it to backup,
  // failing the update and forcing a rollback.
  await runHelperLockFile(getTestFileByName("10text0"));
  runUpdate(STATE_FAILED_WRITE_ERROR, false, 1, true);
  await waitForHelperExit();
  await testPostUpdateProcessing();
  checkPostUpdateRunningFile(false);
  checkFilesAfterUpdateFailure(getApplyDirFile);
  // Check that the update did reach the actions whose rollback this test is
  // about, in the order we expect.
  checkUpdateLogContains(
    [
      "EXECUTE REMOVEFILE searchplugins/searchpluginstext0",
      "EXECUTE REMOVEFILE searchplugins/searchpluginspng0.png",
      "EXECUTE REMOVEFILE exe0.exe",
      "EXECUTE ADD searchplugins/searchpluginstext0",
      "EXECUTE ADD searchplugins/searchpluginspng0.png",
      "EXECUTE ADD exe0.exe",
      "EXECUTE ADD 1/10/10text0",
      ERR_RENAME_FILE,
    ].join("\n")
  );
  await waitForUpdateXMLFiles(true, false);
  await checkUpdateManager(
    STATE_AFTER_STAGE,
    true,
    STATE_AFTER_STAGE,
    WRITE_ERROR,
    0
  );
  checkCallbackLog();
}
