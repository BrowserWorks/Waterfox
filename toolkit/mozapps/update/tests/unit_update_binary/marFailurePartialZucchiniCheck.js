/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/* Zucchini Partial MAR File Patch Apply CHECK Failure Crash Test */

/**
 * The draft file of the add that the updater completes right before it starts
 * patching files, and thus crashes. Finding it after the update proves that the
 * updater crashed during the Draft phase.
 */
const CRASH_DRAFT_REL_PATH =
  DIR_RESOURCES + "searchplugins/searchpluginstext0.moz-draft";

/**
 * The draft file of the patch that the updater is applying when it crashes.
 * Finding it after the update proves that the updater crashed in the middle of
 * patch application, with the new image still open and mapped.
 */
const CRASH_PATCH_DRAFT_REL_PATH =
  DIR_RESOURCES + "searchplugins/searchpluginspng1.png.moz-draft";

async function run_test() {
  if (!setupTestCommon()) {
    return;
  }
  const checkFailureEnv = "MOZ_TEST_ZUCCHINI_CHECK_FAILURE";
  const hadCheckFailureEnv = Services.env.exists(checkFailureEnv);
  const originalCheckFailureEnv = hadCheckFailureEnv
    ? Services.env.get(checkFailureEnv)
    : "";
  Services.env.set(checkFailureEnv, "1");
  registerCleanupFunction(() => {
    Services.env.set(
      checkFailureEnv,
      hadCheckFailureEnv ? originalCheckFailureEnv : ""
    );
  });
  gTestFiles = gTestFilesPartialSuccess;
  gTestDirs = gTestDirsPartialSuccess;
  setTestFilesAndDirsForFailure();
  await setupUpdaterTest(FILE_PARTIAL_ZUCCHINI_MAR, false);

  // A zucchini CHECK failure hard-crashes the updater, which therefore doesn't
  // get a chance to write the failure to update.status or to run the callback
  // application. The crash happens while the updater is drafting the update,
  // so the installation directory still holds the previous version of the
  // application, with the draft files that the updater had produced so far left
  // behind.
  runUpdate(STATE_APPLYING, false, EXIT_VALUE_CRASHED, true);

  checkAppBundleModTime();
  checkPostUpdateRunningFile(false);

  let draftFile = getApplyDirFile(CRASH_DRAFT_REL_PATH);
  Assert.ok(draftFile.exists(), MSG_SHOULD_EXIST + getMsgPath(draftFile.path));

  let patchDraftFile = getApplyDirFile(CRASH_PATCH_DRAFT_REL_PATH);
  Assert.ok(
    patchDraftFile.exists(),
    MSG_SHOULD_EXIST + getMsgPath(patchDraftFile.path)
  );

  // Remove the temporary files and directories that the crashed updater didn't
  // get a chance to clean up, so that the checks below can then verify that it
  // left nothing else behind and didn't touch the installed files.
  draftFile.remove(false);
  patchDraftFile.remove(false);
  getApplyDirFile("updating").remove(true);

  checkFilesAfterUpdateFailure(
    getApplyDirFile,
    /* aStageDirExists */ false,
    /* aToBeDeletedDirExists */ true
  );
  checkToBeDeletedFileCount(0);

  await waitForFilesInUse();
}
