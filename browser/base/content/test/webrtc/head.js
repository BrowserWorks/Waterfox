Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource:///modules/SitePermissions.jsm");


const PREF_PERMISSION_FAKE = "media.navigator.permission.fake";
const CONTENT_SCRIPT_HELPER = getRootDirectory(gTestPath) + "get_user_media_content_script.js";

function waitForCondition(condition, nextTest, errorMsg, retryTimes) {
  retryTimes = typeof retryTimes !== "undefined" ? retryTimes : 30;
  var tries = 0;
  var interval = setInterval(function() {
    if (tries >= retryTimes) {
      ok(false, errorMsg);
      moveOn();
    }
    var conditionPassed;
    try {
      conditionPassed = condition();
    } catch (e) {
      ok(false, e + "\n" + e.stack);
      conditionPassed = false;
    }
    if (conditionPassed) {
      moveOn();
    }
    tries++;
  }, 100);
  var moveOn = function() { clearInterval(interval); nextTest(); };
}

function promiseWaitForCondition(aConditionFn, retryTimes) {
  return new Promise(resolve => {
    waitForCondition(aConditionFn, resolve, "Condition didn't pass.", retryTimes);
  });
}

/**
 * Waits for a window with the given URL to exist.
 *
 * @param url
 *        The url of the window.
 * @return {Promise} resolved when the window exists.
 * @resolves to the window
 */
function promiseWindow(url) {
  info("expecting a " + url + " window");
  return new Promise(resolve => {
    Services.obs.addObserver(function obs(win) {
      win.QueryInterface(Ci.nsIDOMWindow);
      win.addEventListener("load", function() {
        if (win.location.href !== url) {
          info("ignoring a window with this url: " + win.location.href);
          return;
        }

        Services.obs.removeObserver(obs, "domwindowopened");
        resolve(win);
      }, {once: true});
    }, "domwindowopened");
  });
}

function whenDelayedStartupFinished(aWindow) {
  return new Promise(resolve => {
    info("Waiting for delayed startup to finish");
    Services.obs.addObserver(function observer(aSubject, aTopic) {
      if (aWindow == aSubject) {
        Services.obs.removeObserver(observer, aTopic);
        resolve();
      }
    }, "browser-delayed-startup-finished");
  });
}

function promiseIndicatorWindow() {
  // We don't show the indicator window on Mac.
  if ("nsISystemStatusBar" in Ci)
    return Promise.resolve();

  return promiseWindow("chrome://browser/content/webrtcIndicator.xul");
}

async function assertWebRTCIndicatorStatus(expected) {
  let ui = Cu.import("resource:///modules/webrtcUI.jsm", {}).webrtcUI;
  let expectedState = expected ? "visible" : "hidden";
  let msg = "WebRTC indicator " + expectedState;
  if (!expected && ui.showGlobalIndicator) {
    // It seems the global indicator is not always removed synchronously
    // in some cases.
    info("waiting for the global indicator to be hidden");
    await promiseWaitForCondition(() => !ui.showGlobalIndicator);
  }
  is(ui.showGlobalIndicator, !!expected, msg);

  let expectVideo = false, expectAudio = false, expectScreen = false;
  if (expected) {
    if (expected.video)
      expectVideo = true;
    if (expected.audio)
      expectAudio = true;
    if (expected.screen)
      expectScreen = expected.screen;
  }
  is(ui.showCameraIndicator, expectVideo, "camera global indicator as expected");
  is(ui.showMicrophoneIndicator, expectAudio, "microphone global indicator as expected");
  is(ui.showScreenSharingIndicator, expectScreen, "screen global indicator as expected");

  let windows = Services.wm.getEnumerator("navigator:browser");
  while (windows.hasMoreElements()) {
    let win = windows.getNext();
    let menu = win.document.getElementById("tabSharingMenu");
    is(menu && !menu.hidden, !!expected, "WebRTC menu should be " + expectedState);
  }

  if (!("nsISystemStatusBar" in Ci)) {
    if (!expected) {
      let win = Services.wm.getMostRecentWindow("Browser:WebRTCGlobalIndicator");
      if (win) {
        await new Promise((resolve, reject) => {
          win.addEventListener("unload", function listener(e) {
            if (e.target == win.document) {
              win.removeEventListener("unload", listener);
              resolve();
            }
          });
        });
      }
    }
    let indicator = Services.wm.getEnumerator("Browser:WebRTCGlobalIndicator");
    let hasWindow = indicator.hasMoreElements();
    is(hasWindow, !!expected, "popup " + msg);
    if (hasWindow) {
      let document = indicator.getNext().document;
      let docElt = document.documentElement;

      if (document.readyState != "complete") {
        info("Waiting for the sharing indicator's document to load");
        await new Promise(resolve => {
          document.addEventListener("readystatechange",
                                    function onReadyStateChange() {
            if (document.readyState != "complete")
              return;
            document.removeEventListener("readystatechange", onReadyStateChange);
            resolve();
          });
        });
      }

      for (let item of ["video", "audio", "screen"]) {
        let expectedValue = (expected && expected[item]) ? "true" : "";
        is(docElt.getAttribute("sharing" + item), expectedValue,
           item + " global indicator attribute as expected");
      }

      ok(!indicator.hasMoreElements(), "only one global indicator window");
    }
  }
}

function promisePopupEvent(popup, eventSuffix) {
  let endState = {shown: "open", hidden: "closed"}[eventSuffix];

  if (popup.state == endState)
    return Promise.resolve();

  let eventType = "popup" + eventSuffix;
  return new Promise(resolve => {
    popup.addEventListener(eventType, function(event) {
      resolve();
    }, {once: true});

  });
}

function promiseNotificationShown(notification) {
  let win = notification.browser.ownerGlobal;
  if (win.PopupNotifications.panel.state == "open") {
    return Promise.resolve();
  }
  let panelPromise = promisePopupEvent(win.PopupNotifications.panel, "shown");
  notification.reshow();
  return panelPromise;
}

function _mm() {
  return gBrowser.selectedBrowser.messageManager;
}

function promiseObserverCalled(aTopic) {
  return new Promise(resolve => {
    let mm = _mm();
    mm.addMessageListener("Test:ObserverCalled", function listener({data}) {
      if (data == aTopic) {
        ok(true, "got " + aTopic + " notification");
        mm.removeMessageListener("Test:ObserverCalled", listener);
        resolve();
      }
    });
    mm.sendAsyncMessage("Test:WaitForObserverCall", aTopic);
  });
}

function expectObserverCalled(aTopic, aCount = 1) {
  return new Promise(resolve => {
    let mm = _mm();
    mm.addMessageListener("Test:ExpectObserverCalled:Reply",
                          function listener({data}) {
      is(data.count, aCount, "expected notification " + aTopic);
      mm.removeMessageListener("Test:ExpectObserverCalled:Reply", listener);
      resolve();
    });
    mm.sendAsyncMessage("Test:ExpectObserverCalled", {topic: aTopic, count: aCount});
  });
}

function expectNoObserverCalled() {
  return new Promise(resolve => {
    let mm = _mm();
    mm.addMessageListener("Test:ExpectNoObserverCalled:Reply",
                          function listener({data}) {
      mm.removeMessageListener("Test:ExpectNoObserverCalled:Reply", listener);
      for (let topic in data) {
        if (!data[topic])
          continue;

        is(data[topic], 0, topic + " notification unexpected");
      }
      resolve();
    });
    mm.sendAsyncMessage("Test:ExpectNoObserverCalled");
  });
}

function ignoreObserversCalled() {
  return new Promise(resolve => {
    let mm = _mm();
    mm.addMessageListener("Test:ExpectNoObserverCalled:Reply",
                          function listener() {
      mm.removeMessageListener("Test:ExpectNoObserverCalled:Reply", listener);
      resolve();
    });
    mm.sendAsyncMessage("Test:ExpectNoObserverCalled");
  });
}

function promiseMessageReceived() {
  return new Promise((resolve, reject) => {
    let mm = _mm();
    mm.addMessageListener("Test:MessageReceived", function listener({data}) {
      mm.removeMessageListener("Test:MessageReceived", listener);
      resolve(data);
    });
    mm.sendAsyncMessage("Test:WaitForMessage");
  });
}

function promiseSpecificMessageReceived(aMessage, aCount = 1) {
  return new Promise(resolve => {
    let mm = _mm();
    let counter = 0;
    mm.addMessageListener("Test:MessageReceived", function listener({data}) {
      if (data == aMessage) {
        counter++;
        if (counter == aCount) {
          mm.sendAsyncMessage("Test:StopWaitForMultipleMessages");
          mm.removeMessageListener("Test:MessageReceived", listener);
          resolve(data);
        }
      }
    });
    mm.sendAsyncMessage("Test:WaitForMultipleMessages");
  });
}

function promiseMessage(aMessage, aAction) {
  let promise = new Promise((resolve, reject) => {
    promiseMessageReceived(aAction).then(data => {
      is(data, aMessage, "received " + aMessage);
      if (data == aMessage)
        resolve();
      else
        reject();
    });
  });

  if (aAction)
    aAction();

  return promise;
}

function promisePopupNotificationShown(aName, aAction) {
  return new Promise(resolve => {

    PopupNotifications.panel.addEventListener("popupshown", function() {
      ok(!!PopupNotifications.getNotification(aName), aName + " notification shown");
      ok(PopupNotifications.isPanelOpen, "notification panel open");
      ok(!!PopupNotifications.panel.firstChild, "notification panel populated");

      resolve();
    }, {once: true});

    if (aAction)
      aAction();

  });
}

function promisePopupNotification(aName) {
  return new Promise(resolve => {

    waitForCondition(() => PopupNotifications.getNotification(aName),
                     () => {
      ok(!!PopupNotifications.getNotification(aName),
         aName + " notification appeared");

      resolve();
    }, "timeout waiting for popup notification " + aName);

  });
}

function promiseNoPopupNotification(aName) {
  return new Promise(resolve => {

    waitForCondition(() => !PopupNotifications.getNotification(aName),
                     () => {
      ok(!PopupNotifications.getNotification(aName),
         aName + " notification removed");
      resolve();
    }, "timeout waiting for popup notification " + aName + " to disappear");

  });
}

const kActionAlways = 1;
const kActionDeny = 2;
const kActionNever = 3;

function activateSecondaryAction(aAction) {
  let notification = PopupNotifications.panel.firstChild;
  switch (aAction) {
    case kActionNever:
      notification.checkbox.setAttribute("checked", true); // fallthrough
    case kActionDeny:
      notification.secondaryButton.click();
      break;
    case kActionAlways:
      notification.checkbox.setAttribute("checked", true);
      notification.button.click();
      break;
  }
}

function getMediaCaptureState() {
  return new Promise(resolve => {
    let mm = _mm();
    mm.addMessageListener("Test:MediaCaptureState", ({data}) => {
      resolve(data);
    });
    mm.sendAsyncMessage("Test:GetMediaCaptureState");
  });
}

async function stopSharing(aType = "camera", aShouldKeepSharing = false) {
  let promiseRecordingEvent = promiseObserverCalled("recording-device-events");
  gIdentityHandler._identityBox.click();
  let permissions = document.getElementById("identity-popup-permission-list");
  let cancelButton =
    permissions.querySelector(".identity-popup-permission-icon." + aType + "-icon ~ " +
                              ".identity-popup-permission-remove-button");
  cancelButton.click();
  gIdentityHandler._identityPopup.hidden = true;
  await promiseRecordingEvent;
  await expectObserverCalled("getUserMedia:revoke");

  // If we are stopping screen sharing and expect to still have another stream,
  // "recording-window-ended" won't be fired.
  if (!aShouldKeepSharing)
    await expectObserverCalled("recording-window-ended");

  await expectNoObserverCalled();

  if (!aShouldKeepSharing)
    await checkNotSharing();
}

function promiseRequestDevice(aRequestAudio, aRequestVideo, aFrameId, aType,
                              aBrowser = gBrowser.selectedBrowser,
                              aBadDevice = false) {
  info("requesting devices");
  return ContentTask.spawn(aBrowser,
                           {aRequestAudio, aRequestVideo, aFrameId, aType, aBadDevice},
                           async function(args) {
    let global = content.wrappedJSObject;
    if (args.aFrameId)
      global = global.document.getElementById(args.aFrameId).contentWindow;
    global.requestDevice(args.aRequestAudio, args.aRequestVideo, args.aType, args.aBadDevice);
  });
}

async function closeStream(aAlreadyClosed, aFrameId) {
  await expectNoObserverCalled();

  let promises;
  if (!aAlreadyClosed) {
    promises = [promiseObserverCalled("recording-device-events"),
                promiseObserverCalled("recording-window-ended")];
  }

  info("closing the stream");
  await ContentTask.spawn(gBrowser.selectedBrowser, aFrameId, async function(contentFrameId) {
    let global = content.wrappedJSObject;
    if (contentFrameId)
      global = global.document.getElementById(contentFrameId).contentWindow;
    global.closeStream();
  });

  if (promises)
    await Promise.all(promises);

  await assertWebRTCIndicatorStatus(null);
}

async function reloadAndAssertClosedStreams() {
  info("reloading the web page");
  let promises = [
    promiseObserverCalled("recording-device-events"),
    promiseObserverCalled("recording-window-ended")
  ];
  await ContentTask.spawn(gBrowser.selectedBrowser, null,
                          "() => content.location.reload()");
  await Promise.all(promises);

  await expectNoObserverCalled();
  await checkNotSharing();
}

function checkDeviceSelectors(aAudio, aVideo, aScreen) {
  let micSelector = document.getElementById("webRTC-selectMicrophone");
  if (aAudio)
    ok(!micSelector.hidden, "microphone selector visible");
  else
    ok(micSelector.hidden, "microphone selector hidden");

  let cameraSelector = document.getElementById("webRTC-selectCamera");
  if (aVideo)
    ok(!cameraSelector.hidden, "camera selector visible");
  else
    ok(cameraSelector.hidden, "camera selector hidden");

  let screenSelector = document.getElementById("webRTC-selectWindowOrScreen");
  if (aScreen)
    ok(!screenSelector.hidden, "screen selector visible");
  else
    ok(screenSelector.hidden, "screen selector hidden");
}

// aExpected is for the current tab,
// aExpectedGlobal is for all tabs.
async function checkSharingUI(aExpected, aWin = window, aExpectedGlobal = null) {
  let doc = aWin.document;
  // First check the icon above the control center (i) icon.
  let identityBox = doc.getElementById("identity-box");
  ok(identityBox.hasAttribute("sharing"), "sharing attribute is set");
  let sharing = identityBox.getAttribute("sharing");
  if (aExpected.screen)
    is(sharing, "screen", "showing screen icon on the control center icon");
  else if (aExpected.video)
    is(sharing, "camera", "showing camera icon on the control center icon");
  else if (aExpected.audio)
    is(sharing, "microphone", "showing mic icon on the control center icon");

  // Then check the sharing indicators inside the control center panel.
  identityBox.click();
  let permissions = doc.getElementById("identity-popup-permission-list");
  for (let id of ["microphone", "camera", "screen"]) {
    let convertId = idToConvert => {
      if (idToConvert == "camera")
        return "video";
      if (idToConvert == "microphone")
        return "audio";
      return idToConvert;
    };
    let expected = aExpected[convertId(id)];
    is(!!aWin.gIdentityHandler._sharingState[id], !!expected,
       "sharing state for " + id + " as expected");
    let icon = permissions.querySelectorAll(
      ".identity-popup-permission-icon." + id + "-icon");
    if (expected) {
      is(icon.length, 1, "should show " + id + " icon in control center panel");
      ok(icon[0].classList.contains("in-use"), "icon should have the in-use class");
    } else if (!icon.length) {
      ok(true, "should not show " + id + " icon in the control center panel");
    } else {
      // This will happen if there are persistent permissions set.
      ok(!icon[0].classList.contains("in-use"),
         "if shown, the " + id + " icon should not have the in-use class");
      is(icon.length, 1, "should not show more than 1 " + id + " icon");
    }
  }
  aWin.gIdentityHandler._identityPopup.hidden = true;

  // Check the global indicators.
  await assertWebRTCIndicatorStatus(aExpectedGlobal || aExpected);
}

async function checkNotSharing() {
  Assert.deepEqual((await getMediaCaptureState()), {},
                   "expected nothing to be shared");

  ok(!document.getElementById("identity-box").hasAttribute("sharing"),
     "no sharing indicator on the control center icon");

  await assertWebRTCIndicatorStatus(null);
}

function promiseReloadFrame(aFrameId) {
  return ContentTask.spawn(gBrowser.selectedBrowser, aFrameId, async function(contentFrameId) {
    content.wrappedJSObject
           .document
           .getElementById(contentFrameId)
           .contentWindow
           .location
           .reload();
  });
}

async function runTests(tests, options = {}) {
  let leaf = options.relativeURI || "get_user_media.html";

  let rootDir = getRootDirectory(gTestPath);
  rootDir = rootDir.replace("chrome://mochitests/content/",
                            "https://example.com/");
  let absoluteURI = rootDir + leaf;
  let cleanup = options.cleanup || (() => expectNoObserverCalled());

  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, absoluteURI);
  let browser = tab.linkedBrowser;

  browser.messageManager.loadFrameScript(CONTENT_SCRIPT_HELPER, true);

  is(PopupNotifications._currentNotifications.length, 0,
     "should start the test without any prior popup notification");
  ok(gIdentityHandler._identityPopup.hidden,
     "should start the test with the control center hidden");

  await SpecialPowers.pushPrefEnv({"set": [[PREF_PERMISSION_FAKE, true]]});

  for (let testCase of tests) {
    info(testCase.desc);
    await testCase.run(browser);
    await cleanup();
  }

  // Some tests destroy the original tab and leave a new one in its place.
  await BrowserTestUtils.removeTab(gBrowser.selectedTab);
}
