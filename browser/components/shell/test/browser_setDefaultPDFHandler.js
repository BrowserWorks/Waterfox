/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

XPCOMUtils.defineLazyModuleGetters(this, {
  ExperimentAPI: "resource://nimbus/ExperimentAPI.jsm",
  ExperimentFakes: "resource://testing-common/NimbusTestUtils.jsm",
  NimbusFeatures: "resource://nimbus/ExperimentAPI.jsm",
  sinon: "resource://testing-common/Sinon.jsm",
});

XPCOMUtils.defineLazyServiceGetter(
  this,
  "XreDirProvider",
  "@mozilla.org/xre/directory-provider;1",
  "nsIXREDirProvider"
);

const _callExternalDefaultBrowserAgentStub = sinon
  .stub(ShellService, "_callExternalDefaultBrowserAgent")
  .callsFake(async () => ({
    async wait() {
      return { exitCode: 0 };
    },
  }));

const _userChoiceImpossibleTelemetryResultStub = sinon
  .stub(ShellService, "_userChoiceImpossibleTelemetryResult")
  .callsFake(() => null);

// Ensure we don't fall back to a real implementation.
const setDefaultStub = sinon.stub();
// We'll dynamically update this as needed during the tests.
const queryCurrentDefaultHandlerForStub = sinon.stub();
const shellStub = sinon.stub(ShellService, "shellService").value({
  setDefaultBrowser: setDefaultStub,
  queryCurrentDefaultHandlerFor: queryCurrentDefaultHandlerForStub,
});

registerCleanupFunction(() => {
  _callExternalDefaultBrowserAgentStub.restore();
  _userChoiceImpossibleTelemetryResultStub.restore();
  shellStub.restore();

  ExperimentAPI._store._deleteForTests("shellService");
});

add_task(async function ready() {
  await ExperimentAPI.ready();
});

// Everything here is Windows 10+.
Assert.ok(
  AppConstants.isPlatformAndVersionAtLeast("win", "10"),
  "Windows version 10+"
);

add_task(async function remoteEnableWithPDF() {
  let doCleanup = await ExperimentFakes.enrollWithRollout({
    featureId: NimbusFeatures.shellService.featureId,
    value: {
      setDefaultBrowserUserChoice: true,
      setDefaultPDFHandlerOnlyReplaceBrowsers: false,
      setDefaultPDFHandler: true,
      enabled: true,
    },
  });

  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultBrowserUserChoice"),
    true
  );
  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultPDFHandler"),
    true
  );

  _callExternalDefaultBrowserAgentStub.resetHistory();
  ShellService.setDefaultBrowser();

  const aumi = XreDirProvider.getInstallHash();
  Assert.ok(_callExternalDefaultBrowserAgentStub.called);
  Assert.deepEqual(_callExternalDefaultBrowserAgentStub.firstCall.args, [
    {
      arguments: [
        "set-default-browser-user-choice",
        aumi,
        ".pdf",
        "WaterfoxPDF",
      ],
    },
  ]);

  await doCleanup();
});

add_task(async function remoteEnableWithPDF_testOnlyReplaceBrowsers() {
  let doCleanup = await ExperimentFakes.enrollWithRollout({
    featureId: NimbusFeatures.shellService.featureId,
    value: {
      setDefaultBrowserUserChoice: true,
      setDefaultPDFHandlerOnlyReplaceBrowsers: true,
      setDefaultPDFHandler: true,
      enabled: true,
    },
  });

  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultBrowserUserChoice"),
    true
  );
  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultPDFHandler"),
    true
  );
  Assert.equal(
    NimbusFeatures.shellService.getVariable(
      "setDefaultPDFHandlerOnlyReplaceBrowsers"
    ),
    true
  );

  const aumi = XreDirProvider.getInstallHash();

  // We'll take the default from a missing association or a known browser.
  for (let progId of ["", "MSEdgePDF"]) {
    queryCurrentDefaultHandlerForStub.callsFake(() => progId);

    _callExternalDefaultBrowserAgentStub.resetHistory();
    ShellService.setDefaultBrowser();

    Assert.ok(_callExternalDefaultBrowserAgentStub.called);
    Assert.deepEqual(
      _callExternalDefaultBrowserAgentStub.firstCall.args,
      [
        {
          arguments: [
            "set-default-browser-user-choice",
            aumi,
            ".pdf",
            "WaterfoxPDF",
          ],
        },
      ],
      `Will take default from missing association or known browser with ProgID '${progId}'`
    );
  }

  // But not from a non-browser.
  queryCurrentDefaultHandlerForStub.callsFake(() => "Acrobat.Document.DC");

  _callExternalDefaultBrowserAgentStub.resetHistory();
  ShellService.setDefaultBrowser();

  Assert.ok(_callExternalDefaultBrowserAgentStub.called);
  Assert.deepEqual(
    _callExternalDefaultBrowserAgentStub.firstCall.args,
    [{ arguments: ["set-default-browser-user-choice", aumi] }],
    `Will not take default from non-browser`
  );

  await doCleanup();
});

add_task(async function remoteEnableWithoutPDF() {
  let doCleanup = await ExperimentFakes.enrollWithRollout({
    featureId: NimbusFeatures.shellService.featureId,
    value: {
      setDefaultBrowserUserChoice: true,
      setDefaultPDFHandler: false,
      enabled: true,
    },
  });

  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultBrowserUserChoice"),
    true
  );
  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultPDFHandler"),
    false
  );

  _callExternalDefaultBrowserAgentStub.resetHistory();
  ShellService.setDefaultBrowser();

  const aumi = XreDirProvider.getInstallHash();
  Assert.ok(_callExternalDefaultBrowserAgentStub.called);
  Assert.deepEqual(_callExternalDefaultBrowserAgentStub.firstCall.args, [
    { arguments: ["set-default-browser-user-choice", aumi] },
  ]);

  await doCleanup();
});

add_task(async function remoteDisable() {
  let doCleanup = await ExperimentFakes.enrollWithRollout({
    featureId: NimbusFeatures.shellService.featureId,
    value: {
      setDefaultBrowserUserChoice: false,
      setDefaultPDFHandler: true,
      enabled: false,
    },
  });

  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultBrowserUserChoice"),
    false
  );
  Assert.equal(
    NimbusFeatures.shellService.getVariable("setDefaultPDFHandler"),
    true
  );

  _callExternalDefaultBrowserAgentStub.resetHistory();
  ShellService.setDefaultBrowser();

  Assert.ok(_callExternalDefaultBrowserAgentStub.notCalled);
  Assert.ok(setDefaultStub.called);

  await doCleanup();
});
