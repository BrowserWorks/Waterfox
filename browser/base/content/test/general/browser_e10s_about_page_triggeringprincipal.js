"use strict";

const kChildPage = getRootDirectory(gTestPath) + "file_about_child.html";
const kParentPage = getRootDirectory(gTestPath) + "file_about_parent.html";

const kAboutPagesRegistered = Promise.all([
  BrowserTestUtils.registerAboutPage(
    registerCleanupFunction, "test-about-principal-child", kChildPage,
    Ci.nsIAboutModule.URI_MUST_LOAD_IN_CHILD | Ci.nsIAboutModule.ALLOW_SCRIPT),
  BrowserTestUtils.registerAboutPage(
    registerCleanupFunction, "test-about-principal-parent", kParentPage,
    Ci.nsIAboutModule.ALLOW_SCRIPT)
]);

add_task(async function test_principal_click() {
  await kAboutPagesRegistered;
  await BrowserTestUtils.withNewTab("about:test-about-principal-parent", async function(browser) {
    let loadPromise = BrowserTestUtils.browserLoaded(browser, false, "about:test-about-principal-child");
    let myLink = browser.contentDocument.getElementById("aboutchildprincipal");
    myLink.click();
    await loadPromise;

    await ContentTask.spawn(gBrowser.selectedBrowser, {}, async function() {
      let channel = content.document.docShell.currentDocumentChannel;
      is(channel.originalURI.asciiSpec,
         "about:test-about-principal-child",
         "sanity check - make sure we test the principal for the correct URI");

      let triggeringPrincipal = channel.loadInfo.triggeringPrincipal;
      ok(Services.scriptSecurityManager.isSystemPrincipal(triggeringPrincipal),
         "loading about: from privileged page must have a triggering of System");

      let contentPolicyType = channel.loadInfo.externalContentPolicyType;
      is(contentPolicyType, Ci.nsIContentPolicy.TYPE_DOCUMENT,
        "sanity check - loading a top level document");

      let loadingPrincipal = channel.loadInfo.loadingPrincipal;
      is(loadingPrincipal, null,
         "sanity check - load of TYPE_DOCUMENT must have a null loadingPrincipal");
    });
  });
});

add_task(async function test_principal_ctrl_click() {
  await kAboutPagesRegistered;
  await SpecialPowers.pushPrefEnv({
    "set": [["security.sandbox.content.level", 1]],
  });

  await BrowserTestUtils.withNewTab("about:test-about-principal-parent", async function(browser) {
    let loadPromise = BrowserTestUtils.waitForNewTab(gBrowser, "about:test-about-principal-child");
    // simulate ctrl+click
    BrowserTestUtils.synthesizeMouseAtCenter("#aboutchildprincipal",
                                             { ctrlKey: true, metaKey: true },
                                             gBrowser.selectedBrowser);
    let tab = await loadPromise;
    gBrowser.selectTabAtIndex(2);

    await ContentTask.spawn(gBrowser.selectedBrowser, {}, async function() {
      let channel = content.document.docShell.currentDocumentChannel;
      is(channel.originalURI.asciiSpec,
         "about:test-about-principal-child",
         "sanity check - make sure we test the principal for the correct URI");

      let triggeringPrincipal = channel.loadInfo.triggeringPrincipal;
      ok(Services.scriptSecurityManager.isSystemPrincipal(triggeringPrincipal),
         "loading about: from privileged page must have a triggering of System");

      let contentPolicyType = channel.loadInfo.externalContentPolicyType;
      is(contentPolicyType, Ci.nsIContentPolicy.TYPE_DOCUMENT,
        "sanity check - loading a top level document");

      let loadingPrincipal = channel.loadInfo.loadingPrincipal;
      is(loadingPrincipal, null,
         "sanity check - load of TYPE_DOCUMENT must have a null loadingPrincipal");
    });
    await BrowserTestUtils.removeTab(tab);
  });
});

add_task(async function test_principal_right_click_open_link_in_new_tab() {
  await kAboutPagesRegistered;
  await SpecialPowers.pushPrefEnv({
    "set": [["security.sandbox.content.level", 1]],
  });

  await BrowserTestUtils.withNewTab("about:test-about-principal-parent", async function(browser) {
    let loadPromise = BrowserTestUtils.waitForNewTab(gBrowser, "about:test-about-principal-child");

    // simulate right-click open link in tab
    BrowserTestUtils.waitForEvent(document, "popupshown", false, event => {
      // These are operations that must be executed synchronously with the event.
      document.getElementById("context-openlinkintab").doCommand();
      event.target.hidePopup();
      return true;
    });
    BrowserTestUtils.synthesizeMouseAtCenter("#aboutchildprincipal",
                                             { type: "contextmenu", button: 2 },
                                             gBrowser.selectedBrowser);

    let tab = await loadPromise;
    gBrowser.selectTabAtIndex(2);

    await ContentTask.spawn(gBrowser.selectedBrowser, {}, async function() {
      let channel = content.document.docShell.currentDocumentChannel;
      is(channel.originalURI.asciiSpec,
         "about:test-about-principal-child",
         "sanity check - make sure we test the principal for the correct URI");

      let triggeringPrincipal = channel.loadInfo.triggeringPrincipal;
      ok(Services.scriptSecurityManager.isSystemPrincipal(triggeringPrincipal),
         "loading about: from privileged page must have a triggering of System");

      let contentPolicyType = channel.loadInfo.externalContentPolicyType;
      is(contentPolicyType, Ci.nsIContentPolicy.TYPE_DOCUMENT,
        "sanity check - loading a top level document");

      let loadingPrincipal = channel.loadInfo.loadingPrincipal;
      is(loadingPrincipal, null,
         "sanity check - load of TYPE_DOCUMENT must have a null loadingPrincipal");
    });
    await BrowserTestUtils.removeTab(tab);
  });
});
