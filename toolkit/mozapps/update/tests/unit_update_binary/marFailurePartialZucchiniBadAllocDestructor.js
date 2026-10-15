/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/* Zucchini Partial MAR File Patch Apply Memory Allocation Failure Destructor
 * Test */

async function run_test() {
  if (!setupTestCommon()) {
    return;
  }
  const destructorMarkerLog = "MOZ_TEST_ZUCCHINI_DTOR_MARKER";
  const badAllocEnv = "MOZ_TEST_ZUCCHINI_BAD_ALLOC";
  const hadBadAllocEnv = Services.env.exists(badAllocEnv);
  const originalBadAllocEnv = hadBadAllocEnv
    ? Services.env.get(badAllocEnv)
    : "";
  const destructorMarkerEnv = "MOZ_TEST_ZUCCHINI_DTOR_MARKER";
  const hadDestructorMarkerEnv = Services.env.exists(destructorMarkerEnv);
  const originalDestructorMarkerEnv = hadDestructorMarkerEnv
    ? Services.env.get(destructorMarkerEnv)
    : "";
  Services.env.set(badAllocEnv, "1");
  Services.env.set(destructorMarkerEnv, "1");
  registerCleanupFunction(() => {
    Services.env.set(badAllocEnv, hadBadAllocEnv ? originalBadAllocEnv : "");
    Services.env.set(
      destructorMarkerEnv,
      hadDestructorMarkerEnv ? originalDestructorMarkerEnv : ""
    );
  });
  gTestFiles = gTestFilesPartialSuccess;
  gTestDirs = gTestDirsPartialSuccess;
  setTestFilesAndDirsForFailure();
  await setupUpdaterTest(FILE_PARTIAL_ZUCCHINI_MAR, false);
  runUpdate(STATE_FAILED_BSPATCH_MEM_ERROR, false, USE_EXECV ? 0 : 1, true);
  checkAppBundleModTime();
  await testPostUpdateProcessing();
  checkPostUpdateRunningFile(false);
  checkFilesAfterUpdateFailure(getApplyDirFile);
  // Recovering from the bad_alloc unwinds the stack, running the destructors of
  // the local objects of the zucchini code that was interrupted.
  checkUpdateLogContains(destructorMarkerLog);
  await waitForUpdateXMLFiles();
  await checkUpdateManager(
    STATE_NONE,
    false,
    STATE_FAILED,
    BSPATCH_MEM_ERROR,
    1
  );
  checkCallbackLog();
}
