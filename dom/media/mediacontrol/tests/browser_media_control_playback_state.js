/* eslint-disable no-undef */
const PAGE_NON_AUTOPLAY =
  "https://example.com/browser/dom/media/mediacontrol/tests/file_non_autoplay.html";

const testVideoId = "video";

add_task(async function setupTestingPref() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["media.mediacontrol.testingevents.enabled", true],
      ["dom.media.mediasession.enabled", true],
    ],
  });
});

/**
 * This test is used to check the actual playback state [1] of the main media
 * controller. The declared playback state is the playback state from the active
 * media session, and the guessed playback state is determined by the media's
 * playback state. Both the declared playback and the guessed playback state
 * would be used to decide the final result of the actual playback state.
 *
 * [1] https://w3c.github.io/mediasession/#actual-playback-state
 */
add_task(async function testDefaultPlaybackStateBeforeAnyMediaStart() {
  info(`open media page`);
  const tab = await createTabAndLoad(PAGE_NON_AUTOPLAY);

  info(`before media starts, playback state should be 'stopped'`);
  await isActualPlaybackStateEqualTo(tab, "stopped");

  info(`remove tab`);
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function testGuessedPlaybackState() {
  info(`open media page`);
  const tab = await createTabAndLoad(PAGE_NON_AUTOPLAY);

  info(
    `Now declared='none', guessed='playing', so actual playback state should be 'playing'`
  );
  await setGuessedPlaybackState(tab, "playing");
  await isActualPlaybackStateEqualTo(tab, "playing");

  info(
    `Now declared='none', guessed='paused', so actual playback state should be 'paused'`
  );
  await setGuessedPlaybackState(tab, "paused");
  await isActualPlaybackStateEqualTo(tab, "paused");

  info(`remove tab`);
  await BrowserTestUtils.removeTab(tab);
});

add_task(async function testBothGuessedAndDeclaredPlaybackState() {
  info(`open media page`);
  const tab = await createTabAndLoad(PAGE_NON_AUTOPLAY);

  info(
    `Now declared='paused', guessed='playing', so actual playback state should be 'playing'`
  );
  await setDeclaredPlaybackState(tab, "paused");
  await setGuessedPlaybackState(tab, "playing");
  await isActualPlaybackStateEqualTo(tab, "playing");

  info(
    `Now declared='paused', guessed='paused', so actual playback state should be 'paused'`
  );
  await setGuessedPlaybackState(tab, "paused");
  await isActualPlaybackStateEqualTo(tab, "paused");

  info(
    `Now declared='playing', guessed='paused', so actual playback state should be 'playing'`
  );
  await setDeclaredPlaybackState(tab, "playing");
  await isActualPlaybackStateEqualTo(tab, "playing");

  info(`remove tab`);
  await BrowserTestUtils.removeTab(tab);
});

/**
 * The following are helper functions.
 */
function setGuessedPlaybackState(tab, state) {
  if (state == "playing") {
    return playMedia(tab, testVideoId);
  } else if (state == "paused") {
    return pauseMedia(tab, testVideoId);
  }
  // We won't set the state `stopped`, which would only happen if no any media
  // has ever been started in the page.
  ok(false, `should only set 'playing' or 'paused' state`);
  return Promise.resolve();
}

function isActualPlaybackStateEqualTo(tab, expectedState) {
  const currentState = ChromeUtils.getCurrentMediaSessionPlaybackState();
  is(
    currentState,
    expectedState,
    `curent state '${currentState}'' is equal to '${expectedState}'`
  );
}

function setDeclaredPlaybackState(tab, state) {
  return SpecialPowers.spawn(tab.linkedBrowser, [state], playbackState => {
    info(`set declared playback state to '${playbackState}'`);
    content.navigator.mediaSession.playbackState = playbackState;
  });
}
