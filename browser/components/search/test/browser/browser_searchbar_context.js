/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Tests the context menu for the search bar.
 */

"use strict";

let win;

add_task(async function setup() {
  await gCUITestUtils.addSearchBar();

  win = await BrowserTestUtils.openNewBrowserWindow();

  // Create an engine to use for the test.
  await Services.search.addEngineWithDetails("MozSearch1", {
    alias: "mozalias",
    method: "GET",
    template: "https://example.com/?q={searchTerms}",
  });

  let originalEngine = await Services.search.getDefault();
  let engineDefault = Services.search.getEngineByName("MozSearch1");
  await Services.search.setDefault(engineDefault);

  registerCleanupFunction(async function() {
    await Services.search.setDefault(originalEngine);
    await Services.search.removeEngine(engineDefault);
    await BrowserTestUtils.closeWindow(win);
    gCUITestUtils.removeSearchBar();
  });
});

add_task(async function test_emptybar() {
  const searchbar = win.BrowserSearch.searchBar;
  searchbar.focus();

  let contextMenu = searchbar.querySelector(".textbox-contextmenu");
  let contextMenuPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popupshown"
  );

  await EventUtils.synthesizeMouseAtCenter(
    searchbar,
    { type: "contextmenu", button: 2 },
    win
  );
  await contextMenuPromise;

  Assert.ok(
    contextMenu.getElementsByAttribute("cmd", "cmd_cut")[0].disabled,
    "Should have disabled the cut menuitem"
  );
  Assert.ok(
    contextMenu.getElementsByAttribute("cmd", "cmd_copy")[0].disabled,
    "Should have disabled the copy menuitem"
  );

  let popupHiddenPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popuphidden"
  );
  contextMenu.hidePopup();
  await popupHiddenPromise;
});

add_task(async function test_text_in_bar() {
  const searchbar = win.BrowserSearch.searchBar;
  searchbar.focus();

  searchbar.value = "Test";
  searchbar._textbox.editor.selectAll();

  let contextMenu = searchbar.querySelector(".textbox-contextmenu");
  let contextMenuPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popupshown"
  );

  await EventUtils.synthesizeMouseAtCenter(
    searchbar,
    { type: "contextmenu", button: 2 },
    win
  );
  await contextMenuPromise;

  Assert.ok(
    !contextMenu.getElementsByAttribute("cmd", "cmd_cut")[0].disabled,
    "Should have enabled the cut menuitem"
  );
  Assert.ok(
    !contextMenu.getElementsByAttribute("cmd", "cmd_copy")[0].disabled,
    "Should have enabled the copy menuitem"
  );

  let popupHiddenPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popuphidden"
  );
  contextMenu.hidePopup();
  await popupHiddenPromise;
});
