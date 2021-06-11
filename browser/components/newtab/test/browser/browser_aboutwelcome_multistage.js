"use strict";

const { ExperimentAPI } = ChromeUtils.import(
  "resource://nimbus/ExperimentAPI.jsm"
);
const { ExperimentFakes } = ChromeUtils.import(
  "resource://testing-common/NimbusTestUtils.jsm"
);
const { FxAccounts } = ChromeUtils.import(
  "resource://gre/modules/FxAccounts.jsm"
);
const { TelemetryTestUtils } = ChromeUtils.import(
  "resource://testing-common/TelemetryTestUtils.jsm"
);

const ABOUT_WELCOME_OVERRIDE_CONTENT_PREF = "browser.aboutwelcome.screens";
const DID_SEE_ABOUT_WELCOME_PREF = "trailhead.firstrun.didSeeAboutWelcome";

// Test differently for windows 7 as theme screens are removed.
const win7Content = AppConstants.isPlatformAndVersionAtMost("win", "6.1");

const TEST_MULTISTAGE_CONTENT = [
  {
    id: "AW_STEP1",
    order: 0,
    content: {
      zap: true,
      title: "Step 1",
      tiles: {
        type: "theme",
        action: {
          theme: "<event>",
        },
        data: [
          {
            theme: "automatic",
            label: "theme-1",
            tooltip: "test-tooltip",
          },
          {
            theme: "dark",
            label: "theme-2",
          },
        ],
      },
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "link",
      },
      secondary_button_top: {
        label: "link top",
        action: {
          type: "SHOW_FIREFOX_ACCOUNTS",
          data: { entrypoint: "test" },
        },
      },
    },
  },
  {
    id: "AW_STEP2",
    order: 1,
    content: {
      zap: true,
      title: "Step 2 longzaptest",
      tiles: {
        type: "topsites",
        info: true,
      },
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "link",
      },
    },
  },
  {
    id: "AW_STEP3",
    order: 2,
    content: {
      title: "Step 3",
      tiles: {
        type: "image",
        media_type: "test-img",
        source: {
          default:
            "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHBhdGggZmlsbD0iIzQ1YTFmZiIgZmlsbC1vcGFjaXR5PSJjb250ZXh0LWZpbGwtb3BhY2l0eSIgZD0iTTE1Ljg0NSA2LjA2NEExLjEgMS4xIDAgMCAwIDE1IDUuMzMxTDEwLjkxMSA0LjYgOC45ODUuNzM1YTEuMSAxLjEgMCAwIDAtMS45NjkgMEw1LjA4OSA0LjZsLTQuMDgxLjcyOWExLjEgMS4xIDAgMCAwLS42MTUgMS44MzRMMy4zMiAxMC4zMWwtLjYwOSA0LjM2YTEuMSAxLjEgMCAwIDAgMS42IDEuMTI3TDggMTMuODczbDMuNjkgMS45MjdhMS4xIDEuMSAwIDAgMCAxLjYtMS4xMjdsLS42MS00LjM2MyAyLjkyNi0zLjE0NmExLjEgMS4xIDAgMCAwIC4yMzktMS4xeiIvPjwvc3ZnPg==",
        },
      },
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "Import",
        action: {
          type: "SHOW_MIGRATION_WIZARD",
          data: { source: "chrome" },
        },
      },
      help_text: {
        text: "Here's some sample help text",
        position: "default",
      },
    },
  },
];

const TEST_PROTON_CONTENT = [
  {
    id: "AW_STEP1",
    order: 0,
    content: {
      title: "Step 1",
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "link",
      },
      secondary_button_top: {
        label: "link top",
        action: {
          type: "SHOW_FIREFOX_ACCOUNTS",
          data: { entrypoint: "test" },
        },
      },
      help_text: {
        text: "Here's some sample help text",
      },
    },
  },
  {
    id: "AW_STEP2",
    order: 1,
    content: {
      title: "Step 2",
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "link",
      },
    },
  },
  {
    id: "AW_STEP3",
    order: 2,
    content: {
      title: "Step 3",
      tiles: {
        type: "theme",
        action: {
          theme: "<event>",
        },
        data: [
          {
            theme: "automatic",
            label: "theme-1",
            tooltip: "test-tooltip",
          },
          {
            theme: "dark",
            label: "theme-2",
          },
        ],
      },
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "Import",
        action: {
          type: "SHOW_MIGRATION_WIZARD",
          data: { source: "chrome" },
        },
      },
    },
  },
  {
    id: "AW_STEP4",
    order: 3,
    content: {
      title: "Step 4",
      primary_button: {
        label: "Next",
        action: {
          navigate: true,
        },
      },
      secondary_button: {
        label: "link",
      },
    },
  },
];

async function getAboutWelcomeParent(browser) {
  let windowGlobalParent = browser.browsingContext.currentWindowGlobal;
  return windowGlobalParent.getActor("AboutWelcome");
}

const TEST_MULTISTAGE_JSON = JSON.stringify(TEST_MULTISTAGE_CONTENT);
const TEST_PROTON_JSON = JSON.stringify(TEST_PROTON_CONTENT);

async function setAboutWelcomeMultiStage(value = "") {
  return pushPrefs([ABOUT_WELCOME_OVERRIDE_CONTENT_PREF, value]);
}

async function openAboutWelcome() {
  await setAboutWelcomePref(true);
  await setAboutWelcomeMultiStage(TEST_MULTISTAGE_JSON);

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
  });
  return tab.linkedBrowser;
}

/**
 * Setup and test simplified welcome UI
 */
async function test_screen_content(
  browser,
  experiment,
  expectedSelectors = [],
  unexpectedSelectors = []
) {
  await ContentTask.spawn(
    browser,
    { expectedSelectors, experiment, unexpectedSelectors },
    async ({
      expectedSelectors: expected,
      experiment: experimentName,
      unexpectedSelectors: unexpected,
    }) => {
      for (let selector of expected) {
        await ContentTaskUtils.waitForCondition(
          () => content.document.querySelector(selector),
          `Should render ${selector} in ${experimentName}`
        );
      }
      for (let selector of unexpected) {
        ok(
          !content.document.querySelector(selector),
          `Should not render ${selector} in ${experimentName}`
        );
      }

      if (experimentName === "home") {
        Assert.equal(
          content.document.location.href,
          "about:home",
          "Navigated to about:home"
        );
      } else {
        Assert.equal(
          content.document.location.href,
          "about:welcome",
          "Navigated to a welcome screen"
        );
      }
    }
  );
}

async function onButtonClick(browser, elementId) {
  await ContentTask.spawn(
    browser,
    { elementId },
    async ({ elementId: buttonId }) => {
      await ContentTaskUtils.waitForCondition(
        () => content.document.querySelector(buttonId),
        buttonId
      );
      let button = content.document.querySelector(buttonId);
      button.click();
    }
  );
}

add_task(async function setup() {
  const sandbox = sinon.createSandbox();
  // This needs to happen before any about:welcome page opens
  sandbox.stub(FxAccounts.config, "promiseMetricsFlowURI").resolves("");
  await setAboutWelcomeMultiStage("");
  await setProton(false);

  registerCleanupFunction(() => {
    sandbox.restore();
  });
});

/**
 * Test the zero onboarding using ExperimentAPI
 */
add_task(async function test_multistage_zeroOnboarding_experimentAPI() {
  await setAboutWelcomePref(true);
  await ExperimentAPI.ready();
  let doExperimentCleanup = await ExperimentFakes.enrollWithFeatureConfig({
    featureId: "aboutwelcome",
    value: { enabled: false },
  });

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );

  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
  });

  const browser = tab.linkedBrowser;

  await test_screen_content(
    browser,
    "Opens new tab",
    // Expected selectors:
    ["div.search-wrapper", "body.activity-stream"],
    // Unexpected selectors:
    ["div.onboardingContainer", "main.AW_STEP1"]
  );

  await doExperimentCleanup();
});

/**
 * Test the multistage welcome UI using ExperimentAPI
 */
add_task(async function test_multistage_aboutwelcome_experimentAPI() {
  const sandbox = sinon.createSandbox();
  NimbusFeatures.aboutwelcome._sendExposureEventOnce = true;
  await setAboutWelcomePref(true);
  await ExperimentAPI.ready();

  let doExperimentCleanup = await ExperimentFakes.enrollWithFeatureConfig({
    featureId: "aboutwelcome",
    enabled: true,
    value: {
      id: "my-mochitest-experiment",
      screens: TEST_MULTISTAGE_CONTENT,
    },
  });

  sandbox.spy(ExperimentAPI, "recordExposureEvent");

  Services.telemetry.clearScalars();
  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );

  const browser = tab.linkedBrowser;

  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  // Stub AboutWelcomeParent Content Message Handler
  sandbox.spy(aboutWelcomeActor, "onContentMessage");
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
    sandbox.restore();
  });

  // Test first (theme) screen for non-win7.
  if (!win7Content) {
    await test_screen_content(
      browser,
      "multistage step 1",
      // Expected selectors:
      [
        "div.onboardingContainer",
        "main.AW_STEP1",
        "h1.welcomeZap",
        "span.zap.short",
        "div.secondary-cta",
        "div.secondary-cta.top",
        "button[value='secondary_button']",
        "button[value='secondary_button_top']",
        "label.theme",
        "input[type='radio']",
        "div.indicator.current",
      ],
      // Unexpected selectors:
      ["main.AW_STEP2", "main.AW_STEP3", "div.tiles-container.info"]
    );

    await onButtonClick(browser, "button.primary");

    const { callCount } = aboutWelcomeActor.onContentMessage;
    ok(callCount >= 1, `${callCount} Stub was called`);
    let clickCall;
    for (let i = 0; i < callCount; i++) {
      const call = aboutWelcomeActor.onContentMessage.getCall(i);
      info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
      if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
        clickCall = call;
      }
    }

    Assert.equal(
      clickCall.args[0],
      "AWPage:TELEMETRY_EVENT",
      "send telemetry event"
    );

    Assert.equal(
      clickCall.args[1].message_id,
      "MY-MOCHITEST-EXPERIMENT_AW_STEP1",
      "Telemetry should join id defined in feature value with screen"
    );
  }

  await test_screen_content(
    browser,
    "multistage step 2",
    // Expected selectors:
    [
      "div.onboardingContainer",
      "main.AW_STEP2",
      "button[value='secondary_button']",
      "h1.welcomeZap",
      "span.zap.long",
      "div.tiles-container.info",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP3", "div.secondary-cta.top", "div.test-img"]
  );
  await onButtonClick(browser, "button.primary");
  await test_screen_content(
    browser,
    "multistage step 3",
    // Expected selectors:
    [
      "div.onboardingContainer",
      "main.AW_STEP3",
      "div.brand-logo",
      "div.welcome-text",
      "p.helptext",
      "div.test-img",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP2"]
  );
  await onButtonClick(browser, "button.primary");
  await test_screen_content(
    browser,
    "home",
    // Expected selectors:
    ["body.activity-stream"],
    // Unexpected selectors:
    ["div.onboardingContainer"]
  );

  Assert.ok(
    ExperimentAPI.recordExposureEvent.called,
    "Called for exposure event"
  );

  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, true);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    "telemetry.event_counts",
    "normandy#expose#nimbus_experiment",
    1
  );

  await doExperimentCleanup();
});

/**
 * Test the multistage proton welcome UI using ExperimentAPI with transitions
 */
add_task(async function test_multistage_aboutwelcome_transitions() {
  const sandbox = sinon.createSandbox();
  await setAboutWelcomePref(true);
  await setProton(true);
  await ExperimentAPI.ready();

  let doExperimentCleanup = await ExperimentFakes.enrollWithFeatureConfig({
    featureId: "aboutwelcome",
    value: {
      id: "my-mochitest-experiment",
      enabled: true,
      screens: TEST_PROTON_CONTENT,
      isProton: true,
      transitions: true,
    },
  });

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );

  const browser = tab.linkedBrowser;

  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  // Stub AboutWelcomeParent Content Message Handler
  sandbox.spy(aboutWelcomeActor, "onContentMessage");
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
    sandbox.restore();
  });

  await test_screen_content(
    browser,
    "multistage proton step 1",
    // Expected selectors:
    ["div.proton.transition- .screen-0"],
    // Unexpected selectors:
    ["div.proton.transition-out"]
  );

  // Double click should still only transition once.
  await onButtonClick(browser, "button.primary");
  await onButtonClick(browser, "button.primary");

  await test_screen_content(
    browser,
    "multistage proton step 1 transition to 2",
    // Expected selectors:
    ["div.proton.transition-out .screen-0", "div.proton.transition- .screen-1"]
  );

  await doExperimentCleanup();
});

/**
 * Test the multistage proton welcome UI using ExperimentAPI without transitions
 */
add_task(async function test_multistage_aboutwelcome_transitions_off() {
  const sandbox = sinon.createSandbox();
  await setAboutWelcomePref(true);
  await ExperimentAPI.ready();

  let doExperimentCleanup = await ExperimentFakes.enrollWithFeatureConfig({
    featureId: "aboutwelcome",
    value: {
      id: "my-mochitest-experiment",
      enabled: true,
      screens: TEST_PROTON_CONTENT,
      isProton: true,
      transitions: false,
    },
  });

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );

  const browser = tab.linkedBrowser;

  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  // Stub AboutWelcomeParent Content Message Handler
  sandbox.spy(aboutWelcomeActor, "onContentMessage");
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
    sandbox.restore();
  });

  await test_screen_content(
    browser,
    "multistage proton step 1",
    // Expected selectors:
    ["div.proton.transition- .screen-0"],
    // Unexpected selectors:
    ["div.proton.transition-out"]
  );

  await onButtonClick(browser, "button.primary");
  await test_screen_content(
    browser,
    "multistage proton step 1 no transition to 2",
    // Expected selectors:
    [],
    // Unexpected selectors:
    ["div.proton.transition-out .screen-0"]
  );

  await doExperimentCleanup();
});

/**
 * Test the multistage welcome UI rendered using TEST_MULTISTAGE_JSON
 */
add_task(async function test_Multistage_About_Welcome_branches() {
  await setProton(false);
  let browser = await openAboutWelcome();

  // Test first (theme) screen for non-win7.
  if (!win7Content) {
    await test_screen_content(
      browser,
      "multistage step 1",
      // Expected selectors:
      [
        "div.onboardingContainer",
        "main.AW_STEP1",
        "h1.welcomeZap",
        "span.zap.short",
        "div.secondary-cta",
        "div.secondary-cta.top",
        "button[value='secondary_button']",
        "button[value='secondary_button_top']",
        "label.theme",
        "input[type='radio']",
        "div.indicator.current",
      ],
      // Unexpected selectors:
      ["main.AW_STEP2", "main.AW_STEP3", "div.tiles-container.info"]
    );

    await onButtonClick(browser, "button.primary");
  }

  await test_screen_content(
    browser,
    "multistage step 2",
    // Expected selectors:
    [
      "div.onboardingContainer",
      "main.AW_STEP2",
      "h1.welcomeZap",
      "span.zap.long",
      "button[value='secondary_button']",
      "div.tiles-container.info",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP3", "div.secondary-cta.top"]
  );
  await onButtonClick(browser, "button.primary");
  await test_screen_content(
    browser,
    "multistage step 3",
    // Expected selectors:
    [
      "div.onboardingContainer",
      "main.AW_STEP3",
      "div.brand-logo",
      "div.welcome-text",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP2", "h1.welcomeZap"]
  );
  await onButtonClick(browser, "button.primary");
  await test_screen_content(
    browser,
    "home",
    // Expected selectors:
    ["body.activity-stream"],
    // Unexpected selectors:
    ["div.onboardingContainer"]
  );
});

/**
 * Test navigating back/forward between screens
 */
add_task(async function test_Multistage_About_Welcome_navigation() {
  let browser = await openAboutWelcome();

  await onButtonClick(browser, "button.primary");
  await TestUtils.waitForCondition(() => browser.canGoBack);
  browser.goBack();

  // Test first (theme) screen for non-win7.
  if (!win7Content) {
    await test_screen_content(
      browser,
      "multistage step 1",
      // Expected selectors:
      [
        "div.onboardingContainer",
        "main.AW_STEP1",
        "div.secondary-cta",
        "div.secondary-cta.top",
        "button[value='secondary_button']",
        "button[value='secondary_button_top']",
        "div.indicator.current",
      ],
      // Unexpected selectors:
      ["main.AW_STEP2", "main.AW_STEP3"]
    );

    await document.getElementById("forward-button").click();
  }

  await test_screen_content(
    browser,
    "multistage step 2",
    // Expected selectors:
    [
      "div.onboardingContainer",
      "main.AW_STEP2",
      "button[value='secondary_button']",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP3", "div.secondary-cta.top"]
  );
});

/**
 * Test the multistage welcome UI primary button action
 */
add_task(async function test_AWMultistage_Primary_Action() {
  let browser = await openAboutWelcome();
  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  const sandbox = sinon.createSandbox();
  // Stub AboutWelcomeParent Content Message Handler
  sandbox
    .stub(aboutWelcomeActor, "onContentMessage")
    .resolves("")
    .withArgs("AWPage:IMPORTABLE_SITES")
    .resolves([]);
  registerCleanupFunction(() => {
    sandbox.restore();
  });

  await onButtonClick(browser, "button.primary");
  const { callCount } = aboutWelcomeActor.onContentMessage;
  ok(callCount >= 1, `${callCount} Stub was called`);

  let clickCall;
  let impressionCall;
  let performanceCall;
  for (let i = 0; i < callCount; i++) {
    const call = aboutWelcomeActor.onContentMessage.getCall(i);
    info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
    if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
      clickCall = call;
    } else if (
      call.calledWithMatch("", {
        event_context: { importable: sinon.match.number },
      })
    ) {
      impressionCall = call;
    } else if (
      call.calledWithMatch("", {
        event_context: { mountStart: sinon.match.number },
      })
    ) {
      performanceCall = call;
    }
  }

  // For some builds, we can stub fast enough to catch the impression
  if (impressionCall) {
    Assert.equal(
      impressionCall.args[0],
      "AWPage:TELEMETRY_EVENT",
      "send telemetry event"
    );
    Assert.equal(
      impressionCall.args[1].event,
      "IMPRESSION",
      "impression event recorded in telemetry"
    );
    Assert.equal(
      impressionCall.args[1].event_context.display,
      "static",
      "static sites display recorded in telemetry"
    );
    Assert.equal(
      typeof impressionCall.args[1].event_context.importable,
      "number",
      "numeric importable sites recorded in telemetry"
    );
    Assert.equal(
      impressionCall.args[1].message_id,
      "DEFAULT_ABOUTWELCOME_SITES",
      "SITES MessageId sent in impression event telemetry"
    );
  }

  // For some builds, we can stub fast enough to catch the performance
  if (performanceCall) {
    Assert.equal(
      performanceCall.args[0],
      "AWPage:TELEMETRY_EVENT",
      "send telemetry event"
    );
    Assert.equal(
      performanceCall.args[1].event,
      "IMPRESSION",
      "performance impression event recorded in telemetry"
    );
    Assert.equal(
      typeof performanceCall.args[1].event_context.domComplete,
      "number",
      "numeric domComplete recorded in telemetry"
    );
    Assert.equal(
      typeof performanceCall.args[1].event_context.domInteractive,
      "number",
      "numeric domInteractive recorded in telemetry"
    );
    Assert.equal(
      typeof performanceCall.args[1].event_context.mountStart,
      "number",
      "numeric mountStart recorded in telemetry"
    );
    Assert.equal(
      performanceCall.args[1].message_id,
      "DEFAULT_ABOUTWELCOME",
      "MessageId sent in performance event telemetry"
    );
  }

  Assert.equal(
    clickCall.args[0],
    "AWPage:TELEMETRY_EVENT",
    "send telemetry event"
  );
  Assert.equal(
    clickCall.args[1].event,
    "CLICK_BUTTON",
    "click button event recorded in telemetry"
  );
  Assert.equal(
    clickCall.args[1].event_context.source,
    "primary_button",
    "primary button click source recorded in telemetry"
  );
  Assert.equal(
    clickCall.args[1].message_id,
    `DEFAULT_ABOUTWELCOME_${
      TEST_MULTISTAGE_CONTENT[win7Content ? 1 : 0].id
    }`.toUpperCase(),
    "MessageId sent in click event telemetry"
  );
});

add_task(async function test_AWMultistage_Secondary_Open_URL_Action() {
  // First (theme) screen with secondary_button_top is removed for win7.
  if (win7Content) return;

  let { doExperimentCleanup } = ExperimentFakes.enrollmentHelper();
  await doExperimentCleanup();
  let browser = await openAboutWelcome();
  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  const sandbox = sinon.createSandbox();
  // Stub AboutWelcomeParent Content Message Handler
  sandbox
    .stub(aboutWelcomeActor, "onContentMessage")
    .resolves("")
    .withArgs("AWPage:IMPORTABLE_SITES")
    .resolves([]);
  registerCleanupFunction(() => {
    sandbox.restore();
  });

  await onButtonClick(browser, "button[value='secondary_button_top']");
  const { callCount } = aboutWelcomeActor.onContentMessage;
  ok(
    callCount >= 2,
    `${callCount} Stub called twice to handle FxA open URL and Telemetry`
  );

  let actionCall;
  let eventCall;
  for (let i = 0; i < callCount; i++) {
    const call = aboutWelcomeActor.onContentMessage.getCall(i);
    info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
    if (call.calledWithMatch("SPECIAL")) {
      actionCall = call;
    } else if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
      eventCall = call;
    }
  }

  Assert.equal(
    actionCall.args[0],
    "AWPage:SPECIAL_ACTION",
    "Got call to handle special action"
  );
  Assert.equal(
    actionCall.args[1].type,
    "SHOW_FIREFOX_ACCOUNTS",
    "Special action SHOW_FIREFOX_ACCOUNTS event handled"
  );
  Assert.equal(
    actionCall.args[1].data.extraParams.utm_term,
    "aboutwelcome-default-screen",
    "UTMTerm set in FxA URL"
  );
  Assert.equal(
    actionCall.args[1].data.entrypoint,
    "test",
    "EntryPoint set in FxA URL"
  );
  Assert.equal(
    eventCall.args[0],
    "AWPage:TELEMETRY_EVENT",
    "Got call to handle Telemetry event"
  );
  Assert.equal(
    eventCall.args[1].event,
    "CLICK_BUTTON",
    "click button event recorded in Telemetry"
  );
  Assert.equal(
    eventCall.args[1].event_context.source,
    "secondary_button_top",
    "secondary_top button click source recorded in Telemetry"
  );
});

add_task(async function test_AWMultistage_Themes() {
  // No theme screen to test for win7.
  if (win7Content) return;

  let browser = await openAboutWelcome();
  let aboutWelcomeActor = await getAboutWelcomeParent(browser);

  const sandbox = sinon.createSandbox();
  // Stub AboutWelcomeParent Content Message Handler
  sandbox
    .stub(aboutWelcomeActor, "onContentMessage")
    .resolves("")
    .withArgs("AWPage:IMPORTABLE_SITES")
    .resolves([]);
  registerCleanupFunction(() => {
    sandbox.restore();
  });

  await ContentTask.spawn(browser, "Themes", async () => {
    await ContentTaskUtils.waitForCondition(
      () => content.document.querySelector("label.theme"),
      "Theme Icons"
    );
    let themes = content.document.querySelectorAll("label.theme");
    Assert.equal(themes.length, 2, "Two themes displayed");
  });

  await onButtonClick(browser, "input[value=automatic]");

  const { callCount } = aboutWelcomeActor.onContentMessage;
  ok(callCount >= 1, `${callCount} Stub was called`);

  let actionCall;
  let eventCall;
  for (let i = 0; i < callCount; i++) {
    const call = aboutWelcomeActor.onContentMessage.getCall(i);
    info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
    if (call.calledWithMatch("SELECT_THEME")) {
      actionCall = call;
    } else if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
      eventCall = call;
    }
  }

  Assert.equal(
    actionCall.args[0],
    "AWPage:SELECT_THEME",
    "Got call to handle select theme"
  );
  Assert.equal(
    actionCall.args[1],
    "AUTOMATIC",
    "Theme value passed as AUTOMATIC"
  );
  Assert.equal(
    eventCall.args[0],
    "AWPage:TELEMETRY_EVENT",
    "Got call to handle Telemetry event when theme tile clicked"
  );
  Assert.equal(
    eventCall.args[1].event,
    "CLICK_BUTTON",
    "click button event recorded in Telemetry"
  );
  Assert.equal(
    eventCall.args[1].event_context.source,
    "automatic",
    "automatic click source recorded in Telemetry"
  );
});

add_task(async function test_AWMultistage_Import() {
  let browser = await openAboutWelcome();
  let aboutWelcomeActor = await getAboutWelcomeParent(browser);

  // Click twice to advance to screen 3 - once for win7.
  if (!win7Content) await onButtonClick(browser, "button.primary");
  await onButtonClick(browser, "button.primary");

  const sandbox = sinon.createSandbox();
  // Stub AboutWelcomeParent Content Message Handler
  sandbox
    .stub(aboutWelcomeActor, "onContentMessage")
    .resolves("")
    .withArgs("AWPage:IMPORTABLE_SITES")
    .resolves([]);
  registerCleanupFunction(() => {
    sandbox.restore();
  });

  await onButtonClick(browser, "button[value='secondary_button']");
  const { callCount } = aboutWelcomeActor.onContentMessage;

  let actionCall;
  let eventCall;
  for (let i = 0; i < callCount; i++) {
    const call = aboutWelcomeActor.onContentMessage.getCall(i);
    info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
    if (call.calledWithMatch("SPECIAL")) {
      actionCall = call;
    } else if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
      eventCall = call;
    }
  }

  Assert.equal(
    actionCall.args[0],
    "AWPage:SPECIAL_ACTION",
    "Got call to handle special action"
  );
  Assert.equal(
    actionCall.args[1].type,
    "SHOW_MIGRATION_WIZARD",
    "Special action SHOW_MIGRATION_WIZARD event handled"
  );
  Assert.equal(
    actionCall.args[1].data.source,
    "chrome",
    "Source passed to event handler"
  );
  Assert.equal(
    eventCall.args[0],
    "AWPage:TELEMETRY_EVENT",
    "Got call to handle Telemetry event"
  );
});

add_task(async function test_updatesPrefOnAWOpen() {
  Services.prefs.setBoolPref(DID_SEE_ABOUT_WELCOME_PREF, false);
  await setAboutWelcomePref(true);

  await openAboutWelcome();
  await TestUtils.waitForCondition(
    () =>
      Services.prefs.getBoolPref(DID_SEE_ABOUT_WELCOME_PREF, false) === true,
    "Updated pref to seen AW"
  );
  Services.prefs.clearUserPref(DID_SEE_ABOUT_WELCOME_PREF);
});

// Test Fxaccounts MetricsFlowURI
test_newtab(
  {
    async before({ pushPrefs }) {
      await pushPrefs(["browser.aboutwelcome.enabled", true]);
    },
    test: async function test_startBrowsing() {
      await ContentTaskUtils.waitForCondition(
        () => content.document.querySelector(".indicator.current"),
        "Wait for about:welcome to load"
      );
    },
    after() {
      Assert.ok(
        FxAccounts.config.promiseMetricsFlowURI.called,
        "Stub was called"
      );
      Assert.equal(
        FxAccounts.config.promiseMetricsFlowURI.firstCall.args[0],
        "aboutwelcome",
        "Called by AboutWelcomeParent"
      );
    },
  },
  "about:welcome"
);

/**
 * Test the multistage welcome Proton UI
 */
add_task(async function test_multistage_aboutwelcome_proton() {
  const sandbox = sinon.createSandbox();
  await setAboutWelcomePref(true);
  await setAboutWelcomeMultiStage(TEST_PROTON_JSON);
  await setProton(true);

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:welcome",
    true
  );

  const browser = tab.linkedBrowser;

  let aboutWelcomeActor = await getAboutWelcomeParent(browser);
  // Stub AboutWelcomeParent Content Message Handler
  sandbox.spy(aboutWelcomeActor, "onContentMessage");
  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
    sandbox.restore();
  });

  await test_screen_content(
    browser,
    "multistage proton step 1",
    // Expected selectors:
    [
      "main.AW_STEP1",
      "div.onboardingContainer",
      "div.proton[style*='.jpg']",
      "div.section-left",
      "span.attrib-text",
      "div.secondary-cta.top",
    ],
    // Unexpected selectors:
    [
      "main.AW_STEP2",
      "main.AW_STEP3",
      "nav.steps",
      "main.dialog-initial",
      "main.dialog-last",
    ]
  );

  await onButtonClick(browser, "button.primary");

  const { callCount } = aboutWelcomeActor.onContentMessage;
  ok(callCount >= 1, `${callCount} Stub was called`);
  let clickCall;
  for (let i = 0; i < callCount; i++) {
    const call = aboutWelcomeActor.onContentMessage.getCall(i);
    info(`Call #${i}: ${call.args[0]} ${JSON.stringify(call.args[1])}`);
    if (call.calledWithMatch("", { event: "CLICK_BUTTON" })) {
      clickCall = call;
    }
  }

  Assert.ok(
    clickCall.args[1].message_id === "DEFAULT_ABOUTWELCOME_PROTON_AW_STEP1",
    "AboutWelcome proton message id joined with screen id"
  );

  await test_screen_content(
    browser,
    "multistage proton step 2",
    // Expected selectors:
    [
      "main.AW_STEP2.dialog-initial",
      "div.onboardingContainer",
      "div.proton[style*='.jpg']",
      "div.section-main",
      "nav.steps",
    ],
    // Unexpected selectors:
    ["main.AW_STEP1", "main.AW_STEP3", "div.section-left", "main.dialog-last"]
  );

  await onButtonClick(browser, "button.primary");

  // No 3rd screen to go to for win7.
  if (win7Content) return;

  await test_screen_content(
    browser,
    "multistage proton step 3",
    // Expected selectors:
    [
      "main.AW_STEP3",
      "div.onboardingContainer",
      "div.proton[style*='.jpg']",
      "div.section-main",
      "div.tiles-theme-container",
      "nav.steps",
    ],
    // Unexpected selectors:
    [
      "main.AW_STEP2",
      "main.AW_STEP1",
      "div.section-left",
      "main.dialog-initial",
      "main.dialog-last",
    ]
  );

  await onButtonClick(browser, "button.primary");

  await test_screen_content(
    browser,
    "multistage proton step 4",
    // Expected selectors:
    [
      "main.AW_STEP4.screen-1",
      "main.AW_STEP4.dialog-last",
      "div.onboardingContainer",
    ],
    // Unexpected selectors:
    [
      "main.AW_STEP2",
      "main.AW_STEP1",
      "main.AW_STEP3",
      "main.dialog-initial",
      "main.AW_STEP4.screen-0",
      "main.AW_STEP4.screen-2",
      "main.AW_STEP4.screen-3",
    ]
  );
});
