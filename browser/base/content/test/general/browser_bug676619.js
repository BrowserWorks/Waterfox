function waitForNewWindow() {
  return new Promise(resolve => {
    var listener = {
      onOpenWindow: aXULWindow => {
        info("Download window shown...");
        Services.wm.removeListener(listener);

        function downloadOnLoad() {
          domwindow.removeEventListener("load", downloadOnLoad, true);

          is(
            domwindow.document.location.href,
            "chrome://mozapps/content/downloads/unknownContentType.xhtml",
            "Download page appeared"
          );
          resolve(domwindow);
        }

        var domwindow = aXULWindow.docShell.domWindow;
        domwindow.addEventListener("load", downloadOnLoad, true);
      },
      onCloseWindow: aXULWindow => {},
    };

    Services.wm.addListener(listener);
  });
}

async function testLink(link, name) {
  info("Checking " + link + " with name: " + name);

  let winPromise = waitForNewWindow();

  SpecialPowers.spawn(gBrowser.selectedBrowser, [link], contentLink => {
    content.document.getElementById(contentLink).click();
  });

  let win = await winPromise;

  await SpecialPowers.spawn(gBrowser.selectedBrowser, [], () => {
    Assert.equal(
      content.document.getElementById("unload-flag").textContent,
      "Okay",
      "beforeunload shouldn't have fired"
    );
  });

  is(
    win.document.getElementById("location").value,
    name,
    "file name should match"
  );

  await BrowserTestUtils.closeWindow(win);
}

async function testLocation(link, url) {
  let tabPromise = BrowserTestUtils.waitForNewTab(gBrowser);

  SpecialPowers.spawn(gBrowser.selectedBrowser, [link], contentLink => {
    content.document.getElementById(contentLink).click();
  });

  let tab = await tabPromise;
  BrowserTestUtils.removeTab(tab);
}

async function runTest(url) {
  let tab = BrowserTestUtils.addTab(gBrowser, url);
  gBrowser.selectedTab = tab;

  let browser = gBrowser.getBrowserForTab(tab);
  await BrowserTestUtils.browserLoaded(browser);

  await testLink("link1", "test.txt");
  await testLink("link2", "video.ogg");
  await testLink("link3", "just some video");
  await testLink("link4", "with-target.txt");
  await testLink("link5", "javascript.txt");
  await testLink("link6", "test.blob");
  await testLocation("link7", "http://example.com/");

  BrowserTestUtils.removeTab(tab);
}

add_task(async function() {
  requestLongerTimeout(3);
  waitForExplicitFinish();

  await runTest(
    "http://mochi.test:8888/browser/browser/base/content/test/general/download_page.html"
  );
  await runTest(
    "https://example.com:443/browser/browser/base/content/test/general/download_page.html"
  );
});
