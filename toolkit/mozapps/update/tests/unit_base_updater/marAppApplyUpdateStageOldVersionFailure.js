/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

/**
 * Test a replace request for a staged update with a version file that specifies
 * an older version failure. The same check is used in nsUpdateDriver.cpp for
 * all update types which is why there aren't tests for the maintenance service
 * as well as for other update types.
 */

const STATE_AFTER_STAGE = STATE_APPLIED;

function run_test() {
  if (!setupTestCommon()) {
    return;
  }

  gTestFiles = gTestFilesCompleteSuccess;
  gTestDirs = gTestDirsCompleteSuccess;
  setupUpdaterTest(FILE_COMPLETE_MAR);
}

/**
 * Called after the call to setupUpdaterTest finishes.
 */
function setupUpdaterTestFinished() {
  stageUpdate(false);
}

/**
 * Called after the call to stageUpdate finishes.
 */
function stageUpdateFinished() {
  checkPostUpdateRunningFile(false);
  checkFilesAfterUpdateSuccess(getStageDirFile, true);
  checkUpdateLogContents(LOG_COMPLETE_SUCCESS, true);
  // Change the active update to an older version to simulate installing a new
  // version of the application while there is an update that has been staged.
  let patchProps = {state: STATE_AFTER_STAGE};
  let patches = getLocalPatchString(patchProps);
  let updateProps = {appVersion: "1.0"};
  let updates = getLocalUpdateString(updateProps, patches);
  writeUpdatesToXMLFile(getLocalUpdatesXMLString(updates), true);
  // Change the version file to an older version to simulate installing a new
  // version of the application while there is an update that has been staged.
  writeVersionFile("1.0");
  reloadUpdateManagerData();
  // Try to switch the application to the staged application that was updated.
  runUpdateUsingApp(STATE_AFTER_STAGE);
}

/**
 * Called after the call to runUpdateUsingApp finishes.
 */
function runUpdateFinished() {
  standardInit();
  Assert.equal(readStatusState(), STATE_NONE,
               "the status file state" + MSG_SHOULD_EQUAL);
  Assert.ok(!gUpdateManager.activeUpdate,
            "the active update should not be defined");
  Assert.equal(gUpdateManager.updateCount, 1,
               "the update manager updateCount attribute" + MSG_SHOULD_EQUAL);
  Assert.equal(gUpdateManager.getUpdateAt(0).state, STATE_AFTER_STAGE,
               "the update state" + MSG_SHOULD_EQUAL);
  checkPostUpdateRunningFile(false);
  setTestFilesAndDirsForFailure();
  checkFilesAfterUpdateFailure(getApplyDirFile, !IS_MACOSX, false);

  let updatesDir = getUpdatesPatchDir();
  Assert.ok(updatesDir.exists(),
            MSG_SHOULD_EXIST + getMsgPath(updatesDir.path));

  let log = getUpdateLog(FILE_UPDATE_LOG);
  Assert.ok(!log.exists(),
            MSG_SHOULD_NOT_EXIST + getMsgPath(log.path));

  log = getUpdateLog(FILE_LAST_UPDATE_LOG);
  Assert.ok(log.exists(),
            MSG_SHOULD_EXIST + getMsgPath(log.path));

  log = getUpdateLog(FILE_BACKUP_UPDATE_LOG);
  Assert.ok(!log.exists(),
            MSG_SHOULD_NOT_EXIST + getMsgPath(log.path));

  waitForFilesInUse();
}
