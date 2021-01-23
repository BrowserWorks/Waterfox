"use strict";

// 'data' contains the notification data object:
// - data.type must be provided.
// - data.isSolved and data.decoderDoctorReportId will be added if not provided
//   (false and "testReportId" resp.)
// - Other fields (e.g.: data.formats) may be provided as needed.
// 'notificationMessage': Expected message in the notification bar.
//   Falsy if nothing is expected after the notification is sent, in which case
//   we won't have further checks, so the following parameters are not needed.
// 'label': Expected button label. Falsy if no button is expected, in which case
//   we won't have further checks, so the following parameters are not needed.
// 'accessKey': Expected access key for the button.
// 'tabChecker': function(openedTab) called with the opened tab that resulted
//   from clicking the button.
async function test_decoder_doctor_notification(
  data,
  notificationMessage,
  label,
  accessKey,
  tabChecker
) {
  if (typeof data.type === "undefined") {
    ok(false, "Test implementation error: data.type must be provided");
    return;
  }
  data.isSolved = data.isSolved || false;
  if (typeof data.decoderDoctorReportId === "undefined") {
    data.decoderDoctorReportId = "testReportId";
  }
  await BrowserTestUtils.withNewTab({ gBrowser }, async function(browser) {
    let awaitNotificationBar = BrowserTestUtils.waitForNotificationBar(
      gBrowser,
      browser,
      "decoder-doctor-notification"
    );

    await SpecialPowers.spawn(browser, [data], async function(aData) {
      Services.obs.notifyObservers(
        content.window,
        "decoder-doctor-notification",
        JSON.stringify(aData)
      );
    });

    if (!notificationMessage) {
      ok(
        true,
        "Tested notifying observers with a nonsensical message, no effects expected"
      );
      return;
    }

    let notification;
    try {
      notification = await awaitNotificationBar;
    } catch (ex) {
      ok(false, ex);
      return;
    }
    ok(notification, "Got decoder-doctor-notification notification");

    is(
      notification.messageText.textContent,
      notificationMessage,
      "notification message should match expectation"
    );

    let button = notification.querySelector("button");
    if (!label) {
      ok(!button, "There should not be button");
      return;
    }

    is(
      button.getAttribute("label"),
      label,
      `notification button should be '${label}'`
    );
    is(
      button.getAttribute("accesskey"),
      accessKey,
      "notification button should have accesskey"
    );

    if (!tabChecker) {
      ok(false, "Test implementation error: Missing tabChecker");
      return;
    }
    let awaitNewTab = BrowserTestUtils.waitForNewTab(gBrowser);
    button.click();
    let openedTab = await awaitNewTab;
    tabChecker(openedTab);
    BrowserTestUtils.removeTab(openedTab);
  });
}

function tab_checker_for_sumo(expectedPath) {
  return function(openedTab) {
    let baseURL = Services.urlFormatter.formatURLPref("app.support.baseURL");
    let url = baseURL + expectedPath;
    is(
      openedTab.linkedBrowser.currentURI.spec,
      url,
      `Expected '${url}' in new tab`
    );
  };
}

function tab_checker_for_webcompat(expectedParams) {
  return function(openedTab) {
    let urlString = openedTab.linkedBrowser.currentURI.spec;
    let endpoint = Services.prefs.getStringPref(
      "media.decoder-doctor.new-issue-endpoint",
      ""
    );
    ok(
      urlString.startsWith(endpoint),
      `Expected URL starting with '${endpoint}', got '${urlString}'`
    );
    let params = new URL(urlString).searchParams;
    for (let k in expectedParams) {
      if (!params.has(k)) {
        ok(false, `Expected ${k} in webcompat URL`);
      } else {
        is(
          params.get(k),
          expectedParams[k],
          `Expected ${k}='${expectedParams[k]}' in webcompat URL`
        );
      }
    }
  };
}

add_task(async function test_platform_decoder_not_found() {
  let message = "";
  let isLinux = AppConstants.platform == "linux";
  if (isLinux) {
    message = gNavigatorBundle.getString("decoder.noCodecsLinux.message");
  } else if (AppConstants.platform == "win") {
    message = gNavigatorBundle.getString("decoder.noHWAcceleration.message");
  }

  await test_decoder_doctor_notification(
    { type: "platform-decoder-not-found", formats: "testFormat" },
    message,
    isLinux ? "" : gNavigatorBundle.getString("decoder.noCodecs.button"),
    isLinux ? "" : gNavigatorBundle.getString("decoder.noCodecs.accesskey"),
    tab_checker_for_sumo("fix-video-audio-problems-firefox-windows")
  );
});

add_task(async function test_cannot_initialize_pulseaudio() {
  let message = "";
  // This is only sent on Linux.
  if (AppConstants.platform == "linux") {
    message = gNavigatorBundle.getString("decoder.noPulseAudio.message");
  }

  await test_decoder_doctor_notification(
    { type: "cannot-initialize-pulseaudio", formats: "testFormat" },
    message,
    gNavigatorBundle.getString("decoder.noCodecs.button"),
    gNavigatorBundle.getString("decoder.noCodecs.accesskey"),
    tab_checker_for_sumo("fix-common-audio-and-video-issues")
  );
});

add_task(async function test_unsupported_libavcodec() {
  let message = "";
  // This is only sent on Linux.
  if (AppConstants.platform == "linux") {
    message = gNavigatorBundle.getString(
      "decoder.unsupportedLibavcodec.message"
    );
  }

  await test_decoder_doctor_notification(
    { type: "unsupported-libavcodec", formats: "testFormat" },
    message
  );
});

add_task(async function test_decode_error() {
  await SpecialPowers.pushPrefEnv({
    set: [
      [
        "media.decoder-doctor.new-issue-endpoint",
        "http://example.com/webcompat",
      ],
      ["browser.fixup.fallback-to-https", false],
    ],
  });
  let message = gNavigatorBundle.getString("decoder.decodeError.message");
  await test_decoder_doctor_notification(
    {
      type: "decode-error",
      decodeIssue: "DecodeIssue",
      docURL: "DocURL",
      resourceURL: "ResURL",
    },
    message,
    gNavigatorBundle.getString("decoder.decodeError.button"),
    gNavigatorBundle.getString("decoder.decodeError.accesskey"),
    tab_checker_for_webcompat({
      url: "DocURL",
      label: "type-media",
      problem_type: "video_bug",
      details: JSON.stringify({
        "Technical Information:": "DecodeIssue",
        "Resource:": "ResURL",
      }),
    })
  );
});

add_task(async function test_decode_warning() {
  await SpecialPowers.pushPrefEnv({
    set: [
      [
        "media.decoder-doctor.new-issue-endpoint",
        "http://example.com/webcompat",
      ],
    ],
  });
  let message = gNavigatorBundle.getString("decoder.decodeWarning.message");
  await test_decoder_doctor_notification(
    {
      type: "decode-warning",
      decodeIssue: "DecodeIssue",
      docURL: "DocURL",
      resourceURL: "ResURL",
    },
    message,
    gNavigatorBundle.getString("decoder.decodeError.button"),
    gNavigatorBundle.getString("decoder.decodeError.accesskey"),
    tab_checker_for_webcompat({
      url: "DocURL",
      label: "type-media",
      problem_type: "video_bug",
      details: JSON.stringify({
        "Technical Information:": "DecodeIssue",
        "Resource:": "ResURL",
      }),
    })
  );
});
