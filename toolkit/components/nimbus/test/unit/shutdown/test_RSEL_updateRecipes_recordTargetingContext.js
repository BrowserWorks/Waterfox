/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

"use strict";

const { ASRouterTargeting } = ChromeUtils.importESModule(
  "resource:///modules/asrouter/ASRouterTargeting.sys.mjs"
);

add_task(async function test() {
  const { sandbox, loader, cleanup } = await NimbusTestUtils.setupTest();

  const blocker = Promise.withResolvers();
  sandbox.stub(ASRouterTargeting.Environment, "totalBookmarksCount").get(() => {
    blocker.resolve();
    return new Promise(() => {});
  });

  // Record pings so we can assert we never actually submit the targeting context ping.
  Services.prefs.setBoolPref(
    "telemetry.fog.enable_store_submitted_pings",
    true
  );

  Assert.deepEqual(
    Services.fog.getStoredSubmittedPingsByName("nimbus-targeting-context"),
    [],
    "Should not have submitted a nimbus-targeting-context ping yet"
  );

  const updatePromise = loader.updateRecipes("test");
  await blocker.promise;

  // Advance shutdown, which should trip #raceShutdown and cause updateRecipes()
  // to reject with a ShutdownStartedError.

  // Loadbearing magic: this ensures that we don't end up spinning the event
  // loop waiting for shutdown to complete after the callback to
  // RemoteSettingsExperimentLoader.withUpdateLock completes. Otherwise, this
  // causes a shutdown hang.
  await new Promise(resolve => executeSoon(resolve));

  Services.startup.advanceShutdownPhase(
    Services.startup.SHUTDOWN_PHASE_APPSHUTDOWNCONFIRMED
  );

  // A metric can be null for two reasons:
  // - it has never been recorded; or
  Assert.equal(
    Glean.nimbusTargetingContext.totalBookmarksCount.testGetValue(),
    null
  );
  // - it has lifetime: ping and has been submitted.
  Assert.deepEqual(
    Services.fog.getStoredSubmittedPingsByName("nimbus-targeting-context"),
    [],
    "Should not have submitted a nimbus-targeting-context ping"
  );

  await Assert.rejects(updatePromise, /Shutdown started/);

  await cleanup();
});
