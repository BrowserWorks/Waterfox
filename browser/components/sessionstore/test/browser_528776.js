function browserWindowsCount(expected) {
  var count = 0;
  var e = Services.wm.getEnumerator("navigator:browser");
  while (e.hasMoreElements()) {
    if (!e.getNext().closed)
      ++count;
  }
  is(count, expected,
     "number of open browser windows according to nsIWindowMediator");
  is(JSON.parse(ss.getBrowserState()).windows.length, expected,
     "number of open browser windows according to getBrowserState");
}

add_task(async function() {
  browserWindowsCount(1);

  let win = await BrowserTestUtils.openNewBrowserWindow();
  browserWindowsCount(2);
  await BrowserTestUtils.closeWindow(win);
  browserWindowsCount(1);
});
