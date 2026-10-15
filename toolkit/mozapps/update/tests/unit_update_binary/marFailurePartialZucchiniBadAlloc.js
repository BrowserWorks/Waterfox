/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/* Zucchini Partial MAR File Patch Apply Memory Allocation Failure Test */

async function run_test() {
  if (!setupTestCommon()) {
    return;
  }
  const badAllocEnv = "MOZ_TEST_ZUCCHINI_BAD_ALLOC";
  const hadBadAllocEnv = Services.env.exists(badAllocEnv);
  const originalBadAllocEnv = hadBadAllocEnv
    ? Services.env.get(badAllocEnv)
    : "";
  Services.env.set(badAllocEnv, "1");
  registerCleanupFunction(() => {
    Services.env.set(badAllocEnv, hadBadAllocEnv ? originalBadAllocEnv : "");
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
