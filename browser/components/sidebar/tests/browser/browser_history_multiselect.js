/* Any copyright is dedicated to the Public Domain.
   https://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

let component, contentWindow, lists;

add_setup(async () => {
  const sidebar = await showHistorySidebar();
  component = sidebar.component;
  contentWindow = sidebar.contentWindow;

  info("Add pages to history sidebar.");
  await populateHistory();
  await BrowserTestUtils.waitForMutationCondition(
    component.shadowRoot,
    { childList: true, subtree: true },
    () => component.lists.length >= 2
  );

  lists = component.lists;

  await BrowserTestUtils.waitForMutationCondition(
    lists[0].shadowRoot,
    { childList: true, subtree: true },
    () => !!lists[0].rowEls.length
  );
  await BrowserTestUtils.waitForMutationCondition(
    lists[1].shadowRoot,
    { childList: true, subtree: true },
    () => !!lists[1].rowEls.length
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

  lists = component.lists;

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
  // Sanity check - No rows selected to begin with.
  for (const list of lists) {
    Assert.equal(
      getSelectedRows(list).length,
      0,
      "There are no selected rows."
    );
  }

  const firstListRows = [...lists[0].rowEls];
  const secondListRows = [...lists[1].rowEls];

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
    getSelectedRows(lists[0]).length,
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
    getSelectedRows(lists[1]).length,
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
    getSelectedRows(lists[0]).length,
    firstListRows.length,
    "All rows in first list are selected."
  );

  component.treeView.resetSelection();
});

add_task(async function test_shift_arrow_into_list_header() {
  const firstListRows = [...lists[0].rowEls];
  const secondListRows = [...lists[1].rowEls];
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
    getSelectedRows(lists[0]).length,
    1,
    "Last row of first list is selected after Shift + ArrowDown to header."
  );

  component.treeView.resetSelection();

  info("Click first row of second list, then Shift + ArrowUp to card header.");
  await clickOnRow(secondListTop);
  EventUtils.synthesizeKey("KEY_ArrowUp", { shiftKey: true }, contentWindow);
  await BrowserTestUtils.waitForMutationCondition(
    secondListTop,
    { attributes: true },
    () => secondListTop.selected
  );
  Assert.equal(
    getSelectedRows(lists[1]).length,
    1,
    "First row of second list is selected after Shift + ArrowUp to header."
  );

  component.treeView.resetSelection();
});

add_task(async function test_context_menu() {
  const [firstList] = lists;
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
  const secondListRows = lists[1].rowEls;
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

  component.treeView.resetSelection();
});

add_task(async function test_selection_cleared_on_sort_change() {
  const [firstList] = lists;
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
    lists[0].shadowRoot,
    { childList: true, subtree: true },
    () => lists[0].rowEls.length
  );
  const newRow = lists[0].rowEls[0];
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

  component.treeView.resetSelection();
  await changeSortOption(component._menuSortByDate, 3);
});

add_task(async function test_selection_cleared_on_history_remove() {
  const [firstList] = lists;
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
});

add_task(async function test_open_all_in_tabs() {
  const [firstList] = lists;
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
  const newTabPromises = Array(rows.length)
    .fill()
    .map(() => BrowserTestUtils.waitForNewTab(gBrowser));
  const contextMenu = SidebarController.currentContextMenu;
  await openAndWaitForContextMenu(contextMenu, rows[0].mainEl, () =>
    contextMenu.activateItem(
      document.getElementById("sidebar-history-context-open-all-in-tabs")
    )
  );
  const newTabs = await Promise.all(newTabPromises);
  Assert.equal(
    newTabs.length,
    rows.length,
    "All of today's visits were opened in new tabs."
  );

  cleanUpExtraTabs();
  component.treeView.resetSelection();
});

add_task(async function test_open_all_in_tabs_warn() {
  const [firstList] = lists;
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

  info("Set maxOpenBeforeWarn below the number of selected rows.");
  await SpecialPowers.pushPrefEnv({
    set: [["browser.tabs.maxOpenBeforeWarn", 2]],
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
  component.treeView.resetSelection();
});

add_task(async function test_select_nonconsecutive_with_keyboard() {
  const [firstList] = lists;
  const firstListRows = firstList.rowEls;

  const firstRow = firstListRows[0];
  const lastRow = firstListRows[firstListRows.length - 1];

  info("Focus the first row.");
  firstRow.focus();

  info("Select first row with Space.");
  EventUtils.synthesizeKey(" ", {}, contentWindow);
  await BrowserTestUtils.waitForMutationCondition(
    firstRow,
    { attributes: true },
    () => firstRow.selected
  );
  Assert.ok(firstRow.selected, "First row is selected.");

  info("Accel + ArrowDown to the last row.");
  const focused = BrowserTestUtils.waitForEvent(lastRow, "focus");
  for (let i = 0; i < firstListRows.length - 1; i++) {
    EventUtils.synthesizeKey(
      "KEY_ArrowDown",
      { accelKey: true },
      contentWindow
    );
  }
  await focused;

  info("Select last row with Space.");
  EventUtils.synthesizeKey(" ", {}, contentWindow);
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

  component.treeView.resetSelection();
});

add_task(async function test_select_nonconsecutive_with_mouse() {
  const [firstList] = lists;
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

  component.treeView.resetSelection();
});

async function waitForHistoryRows() {
  await TestUtils.waitForCondition(
    () => component.lists[0]?.rowEls.length,
    "The history list has rendered its rows."
  );
}

async function clearSelection() {
  component.treeView.resetSelection();
  await TestUtils.waitForCondition(
    () =>
      [...component.lists].every(
        list => ![...list.rowEls].some(row => row.selected)
      ),
    "Selection is cleared in the DOM."
  );
}

// Cached visits are normalized again on every refresh, which used to append the
// visit time to a row's guid over and over (`guid` -> `guid|time|time`) and left
// the page guid holding the previous, already suffixed value.
add_task(async function test_row_guids_survive_repeated_refreshes() {
  info("Refresh the history cache twice, re-normalizing the cached visits.");
  await component.controller.updateCache();
  await component.updateComplete;
  await component.controller.updateCache();
  await component.updateComplete;
  await waitForHistoryRows();

  for (const list of component.lists) {
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

// Visiting a page again keeps its row in the same day's card, so the row keeps
// its identity and its selection. Keying the row on the visit time dropped the
// selection on every background refresh.
add_task(async function test_selection_survives_history_refresh() {
  await waitForHistoryRows();
  const [firstList] = component.lists;
  const rowCount = firstList.rowEls.length;

  info("Select all of today's visits.");
  firstList.selectAll();
  await TestUtils.waitForCondition(
    () => component.treeView.getSelectedTabItems().length == rowCount,
    "All of today's visits are selected."
  );
  const guidsBefore = firstList.tabItems.map(item => item.guid).sort();

  info("Visit those pages again, then refresh the history cache.");
  await PlacesUtils.history.insertMany(
    Array.from(firstList.tabItems, ({ url }, i) => ({
      url,
      title: `Example Domain ${i}`,
      visits: [{ date: new Date() }],
    }))
  );
  await component.controller.updateCache();
  await component.updateComplete;
  await waitForHistoryRows();

  Assert.deepEqual(
    component.lists[0].tabItems.map(item => item.guid).sort(),
    guidsBefore,
    "The rows kept their guids."
  );
  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    rowCount,
    "Selection is preserved after a background history refresh."
  );
  Assert.equal(
    [...component.lists[0].rowEls].filter(row => row.selected).length,
    rowCount,
    "Every row of the rebuilt list is still marked selected."
  );

  await clearSelection();
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
  await component.controller.updateCache();
  await component.updateComplete;

  const rowsForUrl = list => list.tabItems.filter(item => item.url == url);
  await TestUtils.waitForCondition(
    () => [...component.lists].some(list => rowsForUrl(list).length == 2),
    "Both visits show up in the same card."
  );
  const monthList = [...component.lists].find(
    list => rowsForUrl(list).length == 2
  );
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

  await component.controller.updateCache();
  await component.updateComplete;

  Assert.equal(
    component.treeView.getSelectedTabItems().length,
    selectedBefore,
    "Both rows for the repeated page kept their selection."
  );

  await clearSelection();
});
