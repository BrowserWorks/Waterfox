"use strict";

ChromeUtils.import("resource://gre/modules/IndexedDB.jsm", this);
ChromeUtils.import("resource://gre/modules/AddonManager.jsm", this);
ChromeUtils.import("resource://testing-common/TestUtils.jsm", this);
ChromeUtils.import("resource://testing-common/AddonTestUtils.jsm", this);
ChromeUtils.import("resource://normandy/lib/AddonStudies.jsm", this);
ChromeUtils.import("resource://normandy/lib/TelemetryEvents.jsm", this);
ChromeUtils.import("resource://gre/modules/IndexedDB.jsm", this);

const { NormandyTestUtils } = ChromeUtils.import(
  "resource://testing-common/NormandyTestUtils.jsm"
);
const {
  addonStudyFactory,
  branchedAddonStudyFactory,
} = NormandyTestUtils.factories;

// Initialize test utils
AddonTestUtils.initMochitest(this);

decorate_task(AddonStudies.withStudies(), async function testGetMissing() {
  is(
    await AddonStudies.get("does-not-exist"),
    null,
    "get returns null when the requested study does not exist"
  );
});

decorate_task(
  AddonStudies.withStudies([addonStudyFactory({ slug: "test-study" })]),
  async function testGet([study]) {
    const storedStudy = await AddonStudies.get(study.recipeId);
    Assert.deepEqual(study, storedStudy, "get retrieved a study from storage.");
  }
);

decorate_task(
  AddonStudies.withStudies([addonStudyFactory(), addonStudyFactory()]),
  async function testGetAll(studies) {
    const storedStudies = await AddonStudies.getAll();
    Assert.deepEqual(
      new Set(storedStudies),
      new Set(studies),
      "getAll returns every stored study."
    );
  }
);

decorate_task(
  AddonStudies.withStudies([addonStudyFactory({ slug: "test-study" })]),
  async function testHas([study]) {
    let hasStudy = await AddonStudies.has(study.recipeId);
    ok(hasStudy, "has returns true for a study that exists in storage.");

    hasStudy = await AddonStudies.has("does-not-exist");
    ok(
      !hasStudy,
      "has returns false for a study that doesn't exist in storage."
    );
  }
);

decorate_task(
  AddonStudies.withStudies([
    addonStudyFactory({ slug: "test-study1" }),
    addonStudyFactory({ slug: "test-study2" }),
  ]),
  async function testClear([study1, study2]) {
    const hasAll =
      (await AddonStudies.has(study1.recipeId)) &&
      (await AddonStudies.has(study2.recipeId));
    ok(hasAll, "Before calling clear, both studies are in storage.");

    await AddonStudies.clear();
    const hasAny =
      (await AddonStudies.has(study1.recipeId)) ||
      (await AddonStudies.has(study2.recipeId));
    ok(!hasAny, "After calling clear, all studies are removed from storage.");
  }
);

decorate_task(
  AddonStudies.withStudies([addonStudyFactory({ slug: "foo" })]),
  async function testUpdate([study]) {
    Assert.deepEqual(await AddonStudies.get(study.recipeId), study);

    const updatedStudy = {
      ...study,
      slug: "bar",
    };
    await AddonStudies.update(updatedStudy);

    Assert.deepEqual(await AddonStudies.get(study.recipeId), updatedStudy);
  }
);

decorate_task(
  AddonStudies.withStudies([
    addonStudyFactory({
      active: true,
      addonId: "does.not.exist@example.com",
      studyEndDate: null,
    }),
    addonStudyFactory({ active: true, addonId: "installed@example.com" }),
    addonStudyFactory({
      active: false,
      addonId: "already.gone@example.com",
      studyEndDate: new Date(2012, 1),
    }),
  ]),
  withSendEventStub,
  withInstalledWebExtension(
    { id: "installed@example.com" },
    /* expectUninstall: */ true
  ),
  async function testInit(
    [activeUninstalledStudy, activeInstalledStudy, inactiveStudy],
    sendEventStub,
    [addonId, addonFile]
  ) {
    await AddonStudies.init();

    const newActiveStudy = await AddonStudies.get(
      activeUninstalledStudy.recipeId
    );
    ok(
      !newActiveStudy.active,
      "init marks studies as inactive if their add-on is not installed."
    );
    ok(
      newActiveStudy.studyEndDate,
      "init sets the study end date if a study's add-on is not installed."
    );
    let events = Services.telemetry.snapshotEvents(
      Ci.nsITelemetry.DATASET_PRERELEASE_CHANNELS,
      false
    );
    events = (events.parent || []).filter(e => e[1] == "normandy");
    Assert.deepEqual(
      events[0].slice(2), // strip timestamp and "normandy"
      [
        "unenroll",
        "addon_study",
        activeUninstalledStudy.slug,
        {
          addonId: activeUninstalledStudy.addonId,
          addonVersion: activeUninstalledStudy.addonVersion,
          reason: "uninstalled-sideload",
          branch: AddonStudies.NO_BRANCHES_MARKER,
          enrollmentId: events[0][5].enrollmentId,
        },
      ],
      "AddonStudies.init() should send the correct telemetry event"
    );
    ok(
      NormandyTestUtils.isUuid(events[0][5].enrollmentId),
      "enrollment ID should be a UUID"
    );

    const newInactiveStudy = await AddonStudies.get(inactiveStudy.recipeId);
    is(
      newInactiveStudy.studyEndDate.getFullYear(),
      2012,
      "init does not modify inactive studies."
    );

    const newActiveInstalledStudy = await AddonStudies.get(
      activeInstalledStudy.recipeId
    );
    Assert.deepEqual(
      activeInstalledStudy,
      newActiveInstalledStudy,
      "init does not modify studies whose add-on is still installed."
    );

    // Only activeUninstalledStudy should have generated any events
    ok(sendEventStub.calledOnce, "no extra events should be generated");

    // Clean up
    const addon = await AddonManager.getAddonByID(addonId);
    await addon.uninstall();
    await TestUtils.topicObserved("shield-study-ended", (subject, message) => {
      return message === `${activeInstalledStudy.recipeId}`;
    });
  }
);

// init should register telemetry experiments
decorate_task(
  AddonStudies.withStudies([
    branchedAddonStudyFactory({
      active: true,
      addonId: "installed1@example.com",
    }),
    branchedAddonStudyFactory({
      active: true,
      addonId: "installed2@example.com",
    }),
  ]),
  withInstalledWebExtensionSafe({ id: "installed1@example.com" }),
  withInstalledWebExtension({ id: "installed2@example.com" }),
  withStub(TelemetryEnvironment, "setExperimentActive"),
  async function testInit(
    studies,
    [extensionId1],
    [extensionId2],
    setExperimentActiveStub
  ) {
    await AddonStudies.init();
    Assert.deepEqual(
      setExperimentActiveStub.args,
      [
        [
          studies[0].slug,
          studies[0].branch,
          {
            type: "normandy-addonstudy",
            enrollmentId: studies[0].enrollmentId,
          },
        ],
        [
          studies[1].slug,
          studies[1].branch,
          {
            type: "normandy-addonstudy",
            enrollmentId: studies[1].enrollmentId,
          },
        ],
      ],
      "Add-on studies are registered in Telemetry by AddonStudies.init"
    );
  }
);

// Test that AddonStudies.init() ends studies that have been uninstalled
decorate_task(
  AddonStudies.withStudies([
    addonStudyFactory({
      active: true,
      addonId: "installed@example.com",
      studyEndDate: null,
    }),
  ]),
  withInstalledWebExtension(
    { id: "installed@example.com" },
    /* expectUninstall: */ true
  ),
  async function testInit([study], [id, addonFile]) {
    const addon = await AddonManager.getAddonByID(id);
    await addon.uninstall();
    await TestUtils.topicObserved("shield-study-ended", (subject, message) => {
      return message === `${study.recipeId}`;
    });

    const newStudy = await AddonStudies.get(study.recipeId);
    ok(
      !newStudy.active,
      "Studies are marked as inactive when their add-on is uninstalled."
    );
    ok(
      newStudy.studyEndDate,
      "The study end date is set when the add-on for the study is uninstalled."
    );
  }
);

decorate_task(
  AddonStudies.withStudies([
    NormandyTestUtils.factories.addonStudyFactory({ active: true }),
    NormandyTestUtils.factories.branchedAddonStudyFactory(),
  ]),
  async function testRemoveOldAddonStudies([noBranchStudy, branchedStudy]) {
    // pre check, both studies are active
    const preActiveIds = (await AddonStudies.getAllActive()).map(
      addon => addon.recipeId
    );
    Assert.deepEqual(
      preActiveIds,
      [noBranchStudy.recipeId, branchedStudy.recipeId],
      "Both studies should be active"
    );

    // run the migration
    await AddonStudies.migrations.migration02RemoveOldAddonStudyAction();

    // The unbrached study should end
    const postActiveIds = (await AddonStudies.getAllActive()).map(
      addon => addon.recipeId
    );
    Assert.deepEqual(
      postActiveIds,
      [branchedStudy.recipeId],
      "The unbranched study should end"
    );

    // But both studies should still be present
    const postAllIds = (await AddonStudies.getAll()).map(
      addon => addon.recipeId
    );
    Assert.deepEqual(
      postAllIds,
      [noBranchStudy.recipeId, branchedStudy.recipeId],
      "Both studies should still be present"
    );
  }
);
