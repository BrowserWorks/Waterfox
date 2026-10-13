/* Any copyright is dedicated to the Public Domain.
   https://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { PlacesTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/PlacesTestUtils.sys.mjs"
);

let component, contentWindow;

add_setup(async () => {
  const sidebar = await showHistorySidebar();
  component = sidebar.component;
  contentWindow = sidebar.contentWindow;

  info("Add pages to history sidebar.");
  await populateHistory();
  // populateHistory visits 4 pages on each of today, yesterday and a day of the
  // previous month, so wait for those three cards and for every row of the two
  // expanded ones, rather than latching onto an intermediate refresh.
  await TestUtils.waitForCondition(
    () =>
      getLists().length === 3 &&
      getLists()[0].rowEls.length === 4 &&
      getLists()[1].rowEls.length === 4,
    "The history cards are fully rendered."
  );
});

registerCleanupFunction(async () => {
  SidebarController.hide();
  await PlacesUtils.history.clear();
  Services.prefs.clearUserPref("sidebar.history.sortOption");
});

async function changeSortOption(menuItem, expectedListCount) {
  const menu = component._menu;
  const promiseMenuShown = BrowserTestUtils.waitForEvent(menu, "popupshown");
  EventUtils.synthesizeMouseAtCenter(component.menuButton, {}, contentWindow);
  await promiseMenuShown;
  menu.activateItem(menuItem);

  // Wait for panel to update.
  await BrowserTestUtils.waitForMutationCondition(
    component.shadowRoot,
    { childList: true, subtree: true },
    () => component.lists.length === expectedListCount
  );
  await component.updateComplete;

  // Wait for individual lists to update.
  for (const card of component.cards) {
    if (!card.expanded) {
      continue;
    }
    const list = card.querySelector("sidebar-tab-list");
    await BrowserTestUtils.waitForMutationCondition(
      list.shadowRoot,
      { childList: true, subtree: true },
      () => list.rowEls.length
    );
  }
}

async function clickOnRow(row, event = {}) {
  AccessibilityUtils.setEnv({ focusableRule: false });
  EventUtils.synthesizeMouseAtCenter(row.mainEl, event, contentWindow);
  AccessibilityUtils.resetEnv();
  await component.updateComplete;
}

// A history refresh rebuilds the cards, so the lists and their rows are
// replaced. Look them up right before using them.
function getLists() {
  return component.lists;
}

// A rebuilt list is in the DOM before its rows have rendered, and while the
// cards are being rebuilt there is no list at that index at all.
async function waitForRenderedRows(listIndex) {
  await TestUtils.waitForCondition(
    () => getLists()[listIndex]?.rowEls.length,
    `List ${listIndex} has rendered its rows.`
  );
}

async function refreshHistory() {
  await component.controller.updateCache();
  await component.updateComplete;
}

function rowAt(listIndex, rowIndex) {
  return getLists()[listIndex].rowEls[rowIndex];
}

// `resetSelection` clears the tracked selection but only requests the re-render
// that drops the rows' `selected` attribute, so wait for that render. Otherwise
// the next test counts rows this one left selected.
async function resetSelection() {
  component.treeView.resetSelection();
  await TestUtils.waitForCondition(
    () => [...getLists()].every(list => !getSelectedRows(list).length),
    "Selection is cleared in the DOM."
  );
}

/**
 * Get selected rows in a list.
 *
 * @param {SidebarTabList} list
 * @returns {SidebarTabRow[]}
 */
function getSelectedRows(list) {
  const rows = [];
  for (const row of list.rowEls) {
    if (row.selected) {
      rows.push(row);
    }
  }
  return rows;
}

add_task(async function test_shift_click_select_all() {
  await waitForRenderedRows(0);
  await waitForRenderedRows(1);
  // Sanity check - No rows selected to begin with.
  for (const list of getLists()) {
    Assert.equal(
      getSelectedRows(list).length,
      0,
      "There are no selected rows."
    );
  }

  const firstListRows = [...getLists()[0].rowEls];
  const secondListRows = [...getLists()[1].rowEls];

  const firstListTop = firstListRows[0];
  const firstListBottom = firstListRows.at(-1);
  const secondListBottom = secondListRows.at(-1);

  info("Shift + Click bottom row of the first list.");
  await clickOnRow(firstListBottom, { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    firstListBottom,
    { attributes: true },
    () => firstListBottom.selected
  );
  Assert.equal(
    getSelectedRows(getLists()[0]).length,
    1,
    "One row selected in the first list."
  );

  info("Shift + Click the bottom row of the second list.");
  await clickOnRow(secondListBottom, { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    secondListBottom,
    { attributes: true },
    () => secondListBottom.selected
  );
  Assert.equal(
    getSelectedRows(getLists()[1]).length,
    secondListRows.length,
    "All rows in second list are selected."
  );

  info("Shift + Click the top row of the first list.");
  await clickOnRow(firstListTop, { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    firstListTop,
    { attributes: true },
    () => firstListTop.selected
  );
  Assert.equal(
    getSelectedRows(getLists()[0]).length,
    firstListRows.length,
    "All rows in first list are selected."
  );

  await resetSelection();
});

add_task(async function test_shift_arrow_into_list_header() {
  await waitForRenderedRows(0);
  await waitForRenderedRows(1);
  const firstListRows = [...getLists()[0].rowEls];
  const secondListRows = [...getLists()[1].rowEls];
  const firstListBottom = firstListRows.at(-1);
  const secondListTop = secondListRows[0];

  info("Click last row of first list, then Shift + ArrowDown to card header.");
  await clickOnRow(firstListBottom);
  EventUtils.synthesizeKey("KEY_ArrowDown", { shiftKey: true }, contentWindow);
  await BrowserTestUtils.waitForMutationCondition(
    firstListBottom,
    { attributes: true },
    () => firstListBottom.selected
  );
  Assert.equal(
    getSelectedRows(getLists()[0]).length,
    1,
    "Last row of first list is selected after Shift + ArrowDown to header."
  );

  await resetSelection();

  info("Click first row of second list, then Shift + ArrowUp to card header.");
  await clickOnRow(secondListTop);
  EventUtils.synthesizeKey("KEY_ArrowUp", { shiftKey: true }, contentWindow);
  await BrowserTestUtils.waitForMutationCondition(
    secondListTop,
    { attributes: true },
    () => secondListTop.selected
  );
  Assert.equal(
    getSelectedRows(getLists()[1]).length,
    1,
    "First row of second list is selected after Shift + ArrowUp to header."
  );

  await resetSelection();
});

add_task(async function test_context_menu() {
  await waitForRenderedRows(0);
  await waitForRenderedRows(1);
  const firstList = getLists()[0];
  const rows = [...firstList.rowEls];
  const contextMenu = SidebarController.currentContextMenu;
  const deleteSingle = document.getElementById(
    "sidebar-history-context-delete-page"
  );
  const deleteMultiple = document.getElementById(
    "sidebar-history-context-delete-pages"
  );

  info("Right-click a single row without prior selection.");
  await openAndWaitForContextMenu(contextMenu, rows[0].mainEl, () => {
    Assert.ok(
      BrowserTestUtils.isVisible(deleteSingle),
      "Single-item 'Delete Page' is visible."
    );
    Assert.ok(
      BrowserTestUtils.isHidden(deleteMultiple),
      "Multi-select 'Delete Pages' is hidden."
    );
    contextMenu.hidePopup();
  });
  await TestUtils.waitForTick();

  Assert.ok(rows[0].selected, "First row is selected after right-click.");

  info("Shift + Click to extend selection to the last row.");
  await clickOnRow(rows.at(-1), { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    rows.at(-1),
    { attributes: true },
    () => rows.at(-1).selected
  );
  Assert.equal(
    getSelectedRows(firstList).length,
    rows.length,
    "All rows are selected after Shift + Click."
  );

  info("Right-click a selected row shows multi-select context menu.");
  await openAndWaitForContextMenu(contextMenu, rows[0].mainEl, () => {
    Assert.ok(
      BrowserTestUtils.isHidden(deleteSingle),
      "Single-item 'Delete Page' is hidden."
    );
    Assert.ok(
      BrowserTestUtils.isVisible(deleteMultiple),
      "Multi-select 'Delete Pages' is visible."
    );
    contextMenu.hidePopup();
  });

  info("Right-click an unselected row moves selection to it.");
  const secondListRows = getLists()[1].rowEls;
  await openAndWaitForContextMenu(contextMenu, secondListRows[0].mainEl, () => {
    Assert.ok(
      BrowserTestUtils.isVisible(deleteSingle),
      "Single-item 'Delete Page' is visible after right-clicking unselected row."
    );
    Assert.ok(
      BrowserTestUtils.isHidden(deleteMultiple),
      "Multi-select 'Delete Pages' is hidden after right-clicking unselected row."
    );
    contextMenu.hidePopup();
  });
  await TestUtils.waitForTick();

  Assert.equal(
    getSelectedRows(firstList).length,
    0,
    "Previous selection in first list was cleared."
  );
  Assert.ok(
    secondListRows[0].selected,
    "Right-clicked row in second list is selected."
  );

  await resetSelection();
});

add_task(async function test_selection_cleared_on_sort_change() {
  await waitForRenderedRows(0);
  await waitForRenderedRows(1);
  const firstList = getLists()[0];
  const rows = [...firstList.rowEls];

  info("Shift + Click first row to set anchor.");
  await clickOnRow(rows[0], { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    rows[0],
    { attributes: true },
    () => rows[0].selected
  );

  info("Sort by site.");
  await changeSortOption(component._menuSortBySite, 4);
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    0,
    "Selection is cleared after sort change."
  );

  info("Shift + Click a row in the new view.");
  await BrowserTestUtils.waitForMutationCondition(
    getLists()[0].shadowRoot,
    { childList: true, subtree: true },
    () => getLists()[0].rowEls.length
  );
  const newRow = getLists()[0].rowEls[0];
  await clickOnRow(newRow, { shiftKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    newRow,
    { attributes: true },
    () => newRow.selected
  );
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    1,
    "Shift + Click after sort change selects a single row without error."
  );

  await resetSelection();
  await changeSortOption(component._menuSortByDate, 3);
});

add_task(async function test_select_nonconsecutive_with_keyboard() {
  await waitForRenderedRows(0);
  const lastIndex = getLists()[0].rowEls.length - 1;

  info("Focus the first row.");
  rowAt(0, 0).focus();

  info("Select first row with Space.");
  EventUtils.synthesizeKey(" ", {}, contentWindow);
  await TestUtils.waitForCondition(
    () => rowAt(0, 0).selected,
    "First row is selected."
  );

  info("Accel + ArrowDown to the last row.");
  for (let i = 0; i < lastIndex; i++) {
    EventUtils.synthesizeKey(
      "KEY_ArrowDown",
      { accelKey: true },
      contentWindow
    );
  }
  await TestUtils.waitForCondition(
    () => isActiveElement(rowAt(0, lastIndex)),
    "Last row is focused."
  );

  info("Select last row with Space.");
  EventUtils.synthesizeKey(" ", {}, contentWindow);
  await TestUtils.waitForCondition(
    () => rowAt(0, lastIndex).selected,
    "Last row is selected."
  );

  Assert.equal(
    getSelectedRows(getLists()[0]).length,
    2,
    "Two rows selected in the first list."
  );
  Assert.ok(rowAt(0, 0).selected, "First row is still selected.");
  Assert.ok(rowAt(0, lastIndex).selected, "Last row is selected.");

  await resetSelection();
});

add_task(async function test_select_nonconsecutive_with_mouse() {
  await waitForRenderedRows(0);
  const firstList = getLists()[0];
  const firstListRows = firstList.rowEls;

  const firstRow = firstListRows[0];
  const lastRow = firstListRows[firstListRows.length - 1];

  info("Accel + Click the first row.");
  await clickOnRow(firstRow, { accelKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    firstRow,
    { attributes: true },
    () => firstRow.selected
  );

  info("Accel + Click the last row.");
  await clickOnRow(lastRow, { accelKey: true });
  await BrowserTestUtils.waitForMutationCondition(
    lastRow,
    { attributes: true },
    () => lastRow.selected
  );

  Assert.equal(
    getSelectedRows(firstList).length,
    2,
    "Two rows selected in the first list."
  );
  Assert.ok(firstRow.selected, "First row is still selected.");
  Assert.ok(lastRow.selected, "Last row is selected.");

  await resetSelection();
});

add_task(async function test_selection_cleared_on_history_remove() {
  await waitForRenderedRows(0);
  const firstList = getLists()[0];
  const firstRow = firstList.rowEls[0];
  const { url } = firstRow;

  info("Click the first row to select it.");
  await clickOnRow(firstRow);
  await BrowserTestUtils.waitForMutationCondition(
    firstRow,
    { attributes: true },
    () => firstRow.selected
  );
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    1,
    "One item is selected before removal."
  );

  info("Remove the selected page from history.");
  await PlacesUtils.history.remove(url);
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    0,
    "Selection is cleared after the page is removed from history."
  );

  // Removing a page rebuilds the cards from a fresh query, and the click above
  // navigated to the page, which records a visit of its own. Settle both here
  // rather than leaving them to land in a later test.
  await PlacesTestUtils.promiseAsyncUpdates();
  await refreshHistory();
  await waitForRenderedRows(0);
});

add_task(async function test_open_all_in_tabs() {
  await waitForRenderedRows(0);
  const firstList = getLists()[0];
  const rows = firstList.rowEls;

  info("Select all of today's visits.");
  firstList.selectAll();
  for (const row of rows) {
    await BrowserTestUtils.waitForMutationCondition(
      row,
      { attributes: true },
      () => row.hasAttribute("selected")
    );
  }

  info("Open all selected visits in tabs.");
  const tabCountBefore = gBrowser.tabs.length;
  const contextMenu = SidebarController.currentContextMenu;
  await openAndWaitForContextMenu(contextMenu, rows[0].mainEl, () =>
    contextMenu.activateItem(
      document.getElementById("sidebar-history-context-open-all-in-tabs")
    )
  );
  // Every waitForNewTab listener resolves on the first TabOpen, so poll for all
  // of the tabs instead, and for their loads: those record the history visits
  // this test has to settle before it finishes.
  await TestUtils.waitForCondition(
    () =>
      gBrowser.tabs.length == tabCountBefore + rows.length &&
      gBrowser.tabs
        .slice(tabCountBefore)
        .every(
          tab =>
            !tab.linkedBrowser.webProgress.isLoadingDocument &&
            tab.linkedBrowser.currentURI.spec != "about:blank"
        ),
    "All of today's visits were opened and loaded in new tabs."
  );

  // Loading those tabs records new history visits asynchronously (re-creating a
  // page an earlier test removed, with a fresh guid). Flush the writes and
  // refresh the sidebar so this churn is settled here rather than landing in,
  // and dropping the selection of, a later test.
  await PlacesTestUtils.promiseAsyncUpdates();
  await refreshHistory();

  cleanUpExtraTabs();
  await resetSelection();
});

add_task(async function test_open_all_in_tabs_warn() {
  await waitForRenderedRows(0);
  const firstList = getLists()[0];
  const rows = firstList.rowEls;

  info("Select all of today's visits.");
  firstList.selectAll();
  for (const row of rows) {
    await BrowserTestUtils.waitForMutationCondition(
      row,
      { attributes: true },
      () => row.hasAttribute("selected")
    );
  }

  Assert.greater(rows.length, 1, "There are enough rows to warn about.");
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    rows.length,
    "All of today's visits are selected."
  );

  info("Set maxOpenBeforeWarn below the number of selected rows.");
  await SpecialPowers.pushPrefEnv({
    set: [["browser.tabs.maxOpenBeforeWarn", rows.length - 1]],
  });

  info("Open all in tabs and cancel the warning dialog.");
  const tabCountBefore = gBrowser.tabs.length;
  const dialogPromise = BrowserTestUtils.promiseAlertDialog("cancel");
  const contextMenu = SidebarController.currentContextMenu;
  await openAndWaitForContextMenu(contextMenu, rows[0].mainEl, () =>
    contextMenu.activateItem(
      document.getElementById("sidebar-history-context-open-all-in-tabs")
    )
  );
  await dialogPromise;
  Assert.equal(
    gBrowser.tabs.length,
    tabCountBefore,
    "No new tabs were opened after cancelling the warning dialog."
  );

  await SpecialPowers.popPrefEnv();
  await resetSelection();
});

// Cached visits are normalized again on every refresh, which used to append the
// visit time to a row's guid over and over (`guid` -> `guid|time|time`) and left
// the page guid holding the previous, already suffixed value.
add_task(async function test_row_guids_survive_repeated_refreshes() {
  await waitForRenderedRows(0);

  info("Refresh the history cache twice, re-normalizing the cached visits.");
  await refreshHistory();
  await refreshHistory();
  await waitForRenderedRows(0);

  for (const list of getLists()) {
    for (const { url, guid, pageGuid } of list.tabItems) {
      Assert.ok(
        PlacesUtils.isValidGuid(pageGuid),
        `${url} still has a valid page guid: ${pageGuid}`
      );
      Assert.ok(
        guid.startsWith(`${pageGuid}|`),
        `${url} has a guid derived from its page guid: ${guid}`
      );
    }
  }
});

// A history row's guid embeds its visit time, so re-visiting a page changes the
// guid even though the row still refers to the same page. The multiselection
// must follow the row across such a refresh; otherwise a background history
// update silently empties the selection (e.g. dropping the "open all in tabs"
// warning because nothing looks selected anymore).
add_task(async function test_selection_survives_history_refresh() {
  await waitForRenderedRows(0);
  const firstList = getLists()[0];
  const rows = firstList.rowEls;

  info("Select all of today's visits.");
  firstList.selectAll();
  for (const row of rows) {
    await BrowserTestUtils.waitForMutationCondition(
      row,
      { attributes: true },
      () => row.hasAttribute("selected")
    );
  }
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    rows.length,
    "All of today's visits are selected."
  );

  const guidsBefore = firstList.tabItems.map(item => item.guid);

  info("Re-visit those pages, then refresh the sidebar's history cache.");
  await PlacesUtils.history.insertMany(
    Array.from(firstList.tabItems, ({ url }, i) => ({
      url,
      title: `Example Domain ${i}`,
      visits: [{ date: new Date() }],
    }))
  );
  await refreshHistory();
  await waitForRenderedRows(0);

  Assert.deepEqual(
    getLists()[0]
      .tabItems.map(item => item.guid)
      .sort(),
    guidsBefore.sort(),
    "The re-visit left the rows' guids alone."
  );
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    rows.length,
    "Selection is preserved after a background history refresh."
  );
  Assert.equal(
    getSelectedRows(getLists()[0]).length,
    rows.length,
    "Every row of the rebuilt list is marked selected."
  );

  await resetSelection();
});

// A card covering a whole month has one row per day, so the same page can appear
// more than once in a single list, and each of those rows needs its own guid.
add_task(async function test_rows_of_a_repeated_page_are_distinct() {
  const url = "https://example.com/repeated-page";
  const today = new Date();

  info("Visit a page on two different days of the previous month.");
  await PlacesUtils.history.insertMany(
    [-4, -3].map(day => ({
      url,
      title: "Repeated page",
      visits: [{ date: new Date(today.getFullYear(), today.getMonth(), day) }],
    }))
  );
  await refreshHistory();

  const rowsForUrl = list => list.tabItems.filter(item => item.url == url);
  await TestUtils.waitForCondition(
    () => [...getLists()].some(list => rowsForUrl(list).length == 2),
    "Both visits show up in the same card."
  );
  const monthIndex = [...getLists()].findIndex(
    list => rowsForUrl(list).length == 2
  );
  const monthList = getLists()[monthIndex];
  const repeated = rowsForUrl(monthList);
  Assert.equal(
    repeated[0].pageGuid,
    repeated[1].pageGuid,
    "Both rows are the same page."
  );
  Assert.notEqual(
    repeated[0].guid,
    repeated[1].guid,
    "Each row has its own guid."
  );

  info("Select every row in that card, then refresh.");
  const selectedBefore = monthList.tabItems.length;
  monthList.selectAll();
  await TestUtils.waitForCondition(
    () => component.treeView.getSelectedTabItems().length == selectedBefore,
    "Every row in the card is selected."
  );

  await refreshHistory();

  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    selectedBefore,
    "Both rows for the repeated page kept their selection."
  );

  await resetSelection();
});
