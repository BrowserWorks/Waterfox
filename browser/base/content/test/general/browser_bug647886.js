/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function() {
  await BrowserTestUtils.openNewForegroundTab(gBrowser, "http://example.com");

  await SpecialPowers.spawn(gBrowser.selectedBrowser, [], async function() {
    content.history.pushState({}, "2", "2.html");
  });

  await new Promise(resolve =>
    SessionStore.getSessionHistory(gBrowser.selectedTab, resolve)
  );

  let backButton = document.getElementById("back-button");
  let rect = backButton.getBoundingClientRect();

  info("waiting for the history menu to open");

  let popupShownPromise = BrowserTestUtils.waitForEvent(
    backButton,
    "popupshown"
  );
  EventUtils.synthesizeMouseAtCenter(backButton, { type: "mousedown" });
  EventUtils.synthesizeMouse(backButton, rect.width / 2, rect.height, {
    type: "mouseup",
  });
  let event = await popupShownPromise;

  ok(true, "history menu opened");

  // Wait for the session data to be flushed before continuing the test
  await new Promise(resolve =>
    SessionStore.getSessionHistory(gBrowser.selectedTab, resolve)
  );

  is(event.target.children.length, 2, "Two history items");

  let node = event.target.firstElementChild;
  is(node.getAttribute("uri"), "http://example.com/2.html", "first item uri");
  is(node.getAttribute("index"), "1", "first item index");
  is(node.getAttribute("historyindex"), "0", "first item historyindex");

  node = event.target.lastElementChild;
  is(node.getAttribute("uri"), "http://example.com/", "second item uri");
  is(node.getAttribute("index"), "0", "second item index");
  is(node.getAttribute("historyindex"), "-1", "second item historyindex");

  event.target.hidePopup();
  gBrowser.removeTab(gBrowser.selectedTab);
});
