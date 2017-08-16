const PAGE = "https://example.com/browser/toolkit/content/tests/browser/file_webAudio.html";

async function click_icon(tab) {
  let icon = document.getAnonymousElementByAttribute(tab, "anonid", "soundplaying-icon");

  await hover_icon(icon, document.getElementById("tabbrowser-tab-tooltip"));
  EventUtils.synthesizeMouseAtCenter(icon, {button: 0});
  leave_icon(icon);
}

function start_webAudio() {
  var startButton = content.document.getElementById("start");
  if (!startButton) {
    ok(false, "Can't get the start button!");
  }

  startButton.click();
}

function stop_webAudio() {
  var stopButton = content.document.getElementById("stop");
  if (!stopButton) {
    ok(false, "Can't get the stop button!");
  }

  stopButton.click();
}

add_task(async function setup_test_preference() {
  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
  await SpecialPowers.pushPrefEnv({"set": [
    ["media.useAudioChannelService.testing", true],
    ["media.block-autoplay-until-in-foreground", true]
  ]});
});

add_task(async function mute_web_audio() {
  info("- open new tab -");
  let tab = await BrowserTestUtils.openNewForegroundTab(window.gBrowser,
                                                        "about:blank");
  tab.linkedBrowser.loadURI(PAGE);
  await BrowserTestUtils.browserLoaded(tab.linkedBrowser);

  info("- tab should be audible -");
  await waitForTabPlayingEvent(tab, true);

  info("- mute browser -");
  ok(!tab.linkedBrowser.audioMuted, "Audio should not be muted by default");
  await click_icon(tab);
  ok(tab.linkedBrowser.audioMuted, "Audio should be muted now");

  info("- stop web audip -");
  await ContentTask.spawn(tab.linkedBrowser, null, stop_webAudio);

  info("- start web audio -");
  await ContentTask.spawn(tab.linkedBrowser, null, start_webAudio);

  info("- unmute browser -");
  ok(tab.linkedBrowser.audioMuted, "Audio should be muted now");
  await click_icon(tab);
  ok(!tab.linkedBrowser.audioMuted, "Audio should be unmuted now");

  info("- tab should be audible -");
  await waitForTabPlayingEvent(tab, true);

  info("- remove tab -");
  await BrowserTestUtils.removeTab(tab);
});
