const PAGE = "https://example.com/browser/toolkit/content/tests/browser/file_mediaPlayback2.html";

var SuspendedType = {
  NONE_SUSPENDED             : 0,
  SUSPENDED_PAUSE            : 1,
  SUSPENDED_BLOCK            : 2,
  SUSPENDED_PAUSE_DISPOSABLE : 3
};

function wait_for_event(browser, event) {
  return BrowserTestUtils.waitForEvent(browser, event, false, (event) => {
    is(event.originalTarget, browser, "Event must be dispatched to correct browser.");
    return true;
  });
}

function check_audio_onplay() {
  var list = content.document.getElementsByTagName('audio');
  if (list.length != 1) {
    ok(false, "There should be only one audio element in page!")
  }

  var audio = list[0];
  return new Promise((resolve, reject) => {
    audio.onplay = () => {
      ok(needToReceiveOnPlay, "Should not receive play event!");
      this.onplay = null;
      reject();
    };

    audio.pause();
    audio.play();

    setTimeout(() => {
      ok(true, "Doesn't receive play event when media was blocked.");
      audio.onplay = null;
      resolve();
    }, 1000)
  });
}

function check_audio_suspended(suspendedType) {
  var list = content.document.getElementsByTagName('audio');
  if (list.length != 1) {
    ok(false, "There should be only one audio element in page!")
  }

  var audio = list[0];
  is(audio.computedSuspended, suspendedType,
     "The suspended state of MediaElement is correct.");
}

function check_audio_pause_state(expectedPauseState) {
  var list = content.document.getElementsByTagName('audio');
  if (list.length != 1) {
    ok(false, "There should be only one audio element in page!")
  }

  var audio = list[0];
  if (expectedPauseState) {
    is(audio.paused, true, "Audio is paused correctly.");
  } else {
    is(audio.paused, false, "Audio is resumed correctly.");
  }
}

function* suspended_pause(url, browser) {
  info("### Start test for suspended-pause ###");
  browser.loadURI(url);

  info("- page should have playing audio -");
  yield wait_for_event(browser, "DOMAudioPlaybackStarted");

  info("- the suspended state of audio should be non-suspened -");
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);

  info("- pause playing audio -");
  browser.pauseMedia(false /* non-disposable */);
  yield ContentTask.spawn(browser, true /* expect for pause */,
                                   check_audio_pause_state);
  yield ContentTask.spawn(browser, SuspendedType.SUSPENDED_PAUSE,
                                   check_audio_suspended);

  info("- resume paused audio -");
  browser.resumeMedia();
  yield ContentTask.spawn(browser, false /* expect for playing */,
                                   check_audio_pause_state);
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);
}

function* suspended_pause_disposable(url, browser) {
  info("### Start test for suspended-pause-disposable ###");
  browser.loadURI(url);

  info("- page should have playing audio -");
  yield wait_for_event(browser, "DOMAudioPlaybackStarted");

  info("- the suspended state of audio should be non-suspened -");
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);

  info("- pause playing audio -");
  browser.pauseMedia(true /* disposable */);
  yield ContentTask.spawn(browser, true /* expect for pause */,
                                   check_audio_pause_state);
  yield ContentTask.spawn(browser, SuspendedType.SUSPENDED_PAUSE_DISPOSABLE,
                                   check_audio_suspended);

  info("- resume paused audio -");
  browser.resumeMedia();
  yield ContentTask.spawn(browser, false /* expect for playing */,
                                   check_audio_pause_state);
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);
}

function* suspended_stop_disposable(url, browser) {
  info("### Start test for suspended-stop-disposable ###");
  browser.loadURI(url);

  info("- page should have playing audio -");
  yield wait_for_event(browser, "DOMAudioPlaybackStarted");

  info("- the suspended state of audio should be non-suspened -");
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);

  info("- stop playing audio -");
  browser.stopMedia();
  yield wait_for_event(browser, "DOMAudioPlaybackStopped");
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);
}

function* suspended_block(url, browser) {
  info("### Start test for suspended-block ###");
  browser.loadURI(url);

  info("- page should have playing audio -");
  yield wait_for_event(browser, "DOMAudioPlaybackStarted");

  info("- block playing audio -");
  browser.blockMedia();
  yield ContentTask.spawn(browser, SuspendedType.SUSPENDED_BLOCK,
                                   check_audio_suspended);
  yield ContentTask.spawn(browser, null,
                                   check_audio_onplay);

  info("- resume blocked audio -");
  browser.resumeMedia();
  yield ContentTask.spawn(browser, SuspendedType.NONE_SUSPENDED,
                                   check_audio_suspended);
}

add_task(function* setup_test_preference() {
  yield new Promise(resolve => {
    SpecialPowers.pushPrefEnv({"set": [
      ["media.useAudioChannelService.testing", true]
    ]}, resolve);
  });
});

add_task(function* test_suspended_pause() {
  yield BrowserTestUtils.withNewTab({
      gBrowser,
      url: "about:blank"
    }, suspended_pause.bind(this, PAGE));
});

add_task(function* test_suspended_pause_disposable() {
  yield BrowserTestUtils.withNewTab({
      gBrowser,
      url: "about:blank"
    }, suspended_pause_disposable.bind(this, PAGE));
});

add_task(function* test_suspended_stop_disposable() {
  yield BrowserTestUtils.withNewTab({
      gBrowser,
      url: "about:blank"
    }, suspended_stop_disposable.bind(this, PAGE));
});

add_task(function* test_suspended_block() {
  yield BrowserTestUtils.withNewTab({
      gBrowser,
      url: "about:blank"
    }, suspended_block.bind(this, PAGE));
});
