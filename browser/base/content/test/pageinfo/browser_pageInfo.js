function test() {
  waitForExplicitFinish();

  var pageInfo;

  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.selectedBrowser.addEventListener("load", function() {
    Services.obs.addObserver(observer, "page-info-dialog-loaded");
    pageInfo = BrowserPageInfo();
  }, {capture: true, once: true});
  content.location =
    "https://example.com/browser/browser/base/content/test/pageinfo/feed_tab.html";

  function observer(win, topic, data) {
    Services.obs.removeObserver(observer, "page-info-dialog-loaded");
    pageInfo.onFinished.push(handlePageInfo);
  }

  function handlePageInfo() {
    ok(pageInfo.document.getElementById("feedTab"), "Feed tab");
    let feedListbox = pageInfo.document.getElementById("feedListbox");
    ok(feedListbox, "Feed list");

    var feedRowsNum = feedListbox.getRowCount();
    is(feedRowsNum, 3, "Number of feeds listed");

    for (var i = 0; i < feedRowsNum; i++) {
      let feedItem = feedListbox.getItemAtIndex(i);
      is(feedItem.getAttribute("name"), i + 1, "Feed name");
    }

    pageInfo.close();
    gBrowser.removeCurrentTab();
    finish();
  }
}
