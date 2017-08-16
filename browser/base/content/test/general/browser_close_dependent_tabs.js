add_task(async function() {
  await SpecialPowers.pushPrefEnv({
    set: [["browser.groupedhistory.enabled", true],
          ["dom.linkPrerender.enabled", true]]
  });

  // Wait for a process change and then fulfil the promise.
  function awaitProcessChange(browser) {
    return new Promise(resolve => {
      browser.addEventListener("BrowserChangedProcess", function(e) {
        ok(true, "The browser changed process!");
        resolve();
      }, {once: true});
    });
  }

  // Wait for given number tabs being closed.
  function awaitTabClose(number) {
    return new Promise(resolve => {
      let seen = 0;
      gBrowser.tabContainer.addEventListener("TabClose", function f() {
        if (++seen == number) {
          gBrowser.tabContainer.removeEventListener("TabClose", f);
          resolve();
        }
      });
    });
  }

  // Test 1: Create prerendered browser, and don't switch to it, then close the tab
  let closed1 = awaitTabClose(2);
  await BrowserTestUtils.withNewTab({ gBrowser, url: "data:text/html,a" }, async function(browser1) {
    // Set up the grouped SHEntry setup

    let requestMade = new Promise(resolve => {
      browser1.messageManager.addMessageListener("Prerender:Request", function f() {
        browser1.messageManager.removeMessageListener("Prerender:Request", f);
        ok(true, "Successfully received the prerender request");
        resolve();
      });
    });

    is(gBrowser.tabs.length, 2);
    await ContentTask.spawn(browser1, null, function() {
      let link = content.document.createElement("link");
      link.setAttribute("rel", "prerender");
      link.setAttribute("href", "data:text/html,b");
      content.document.body.appendChild(link);
    });
    await requestMade;

    is(gBrowser.tabs.length, 3);
  });
  await closed1;

  // At this point prerendered tab should be closed
  is(gBrowser.tabs.length, 1, "The new tab and the prerendered 'tab' should be closed");

  // Test 2: Create prerendered browser, switch to it, then close the tab
  let closed2 = awaitTabClose(2);
  await BrowserTestUtils.withNewTab({ gBrowser, url: "data:text/html,a" }, async function(browser1) {
    // Set up the grouped SHEntry setup
    let tab2 = gBrowser.loadOneTab("data:text/html,b", {
      referrerPolicy: Ci.nsIHttpChannel.REFERRER_POLICY_UNSET,
      allowThirdPartyFixup: true,
      relatedToCurrent: true,
      isPrerendered: true,
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
    });
    await BrowserTestUtils.browserLoaded(tab2.linkedBrowser);
    browser1.frameLoader.appendPartialSHistoryAndSwap(tab2.linkedBrowser.frameLoader);
    await awaitProcessChange(browser1);
  });
  await closed2;

  // At this point prerendered tab should be closed
  is(gBrowser.tabs.length, 1, "The new tab and the prerendered 'tab' should be closed");
});
