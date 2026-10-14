/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

/* Partial MAR file patch apply failure test with a stale backup file */

/**
 * A backup that a previous updater instance would have left behind if it had
 * died before discarding it. 0/00/00png0.png comes after 0/0exe0.exe in the
 * partial MAR, so the update fails before it reaches that file.
 */
const STALE_BACKUP_REL_PATH = DIR_RESOURCES + "0/00/00png0.png.moz-backup";
const STALE_BACKUP_CONTENTS = "LeftBehindByAPreviousUpdaterRun\n";

async function run_test() {
  if (!setupTestCommon()) {
    return;
  }
  gTestFiles = gTestFilesPartialSuccess;
  getTestFileByName("0exe0.exe").originalFile = "partial.png";
  gTestDirs = gTestDirsPartialSuccess;
  setTestFilesAndDirsForFailure();
  await setupUpdaterTest(FILE_PARTIAL_MAR, false);
  let staleBackup = getApplyDirFile(STALE_BACKUP_REL_PATH);
  writeFile(staleBackup, STALE_BACKUP_CONTENTS);

  // If execv is used the updater process will turn into the callback process
  // and the updater's return code will be that of the callback process.
  runUpdate(
    STATE_FAILED_LOADSOURCE_ERROR_WRONG_SIZE,
    false,
    USE_EXECV ? 0 : 1,
    true
  );
  checkAppBundleModTime();
  checkNoUpdateTelemetry();
  await testPostUpdateProcessing();
  checkPostUpdateRunningFile(false);

  Assert.ok(
    staleBackup.exists(),
    MSG_SHOULD_EXIST + getMsgPath(staleBackup.path)
  );
  Assert.equal(
    readFileBytes(staleBackup),
    STALE_BACKUP_CONTENTS,
    "the stale backup contents" + MSG_SHOULD_EQUAL
  );
  checkUpdateLogContains(
    "backup_restore: not restoring a backup that this action did not create: " +
      STALE_BACKUP_REL_PATH
  );
  // The check for temporary files that checkFilesAfterUpdateFailure performs
  // would find the stale backup, which the updater leaves in place on purpose.
  staleBackup.remove(false);
  checkFilesAfterUpdateFailure(getApplyDirFile);

  await waitForUpdateXMLFiles();
  await checkUpdateManager(
    STATE_NONE,
    false,
    STATE_FAILED,
    LOADSOURCE_ERROR_WRONG_SIZE,
    1
  );
  checkCallbackLog();
}
