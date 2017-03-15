/*
 * This test checks that focus is adjusted properly in a browser when pressing F6 and Shift+F6.
 * There are additional tests in dom/tests/mochitest/chrome/test_focus_docnav.xul which test
 * non-browser cases.
 */

var testPage1 = "data:text/html,<html id='html1'><body id='body1'><button id='button1'>Tab 1</button></body></html>";
var testPage2 = "data:text/html,<html id='html2'><body id='body2'><button id='button2'>Tab 2</button></body></html>";
var testPage3 = "data:text/html,<html id='html3'><body id='body3' contenteditable='true'><button id='button3'>Tab 3</button></body></html>";

var fm = Services.focus;

function* expectFocusOnF6(backward, expectedDocument, expectedElement, onContent, desc)
{
  let focusChangedInChildResolver = null;
  let focusPromise = onContent ? new Promise(resolve => focusChangedInChildResolver = resolve) :
                                 BrowserTestUtils.waitForEvent(window, "focus", true);

  function focusChangedListener(msg) {
    let expected = expectedDocument;
    if (!expectedElement.startsWith("html")) {
      expected += "," + expectedElement;
    }

    is(msg.data.details, expected, desc + " child focus matches");
    focusChangedInChildResolver();
  }

  if (onContent) {
    messageManager.addMessageListener("BrowserTest:FocusChanged", focusChangedListener);

    yield ContentTask.spawn(gBrowser.selectedBrowser, { expectedElementId: expectedElement }, function* (arg) {
      let contentExpectedElement = content.document.getElementById(arg.expectedElementId);
      if (!contentExpectedElement) {
        // Element not found, so look in the child frames.
        for (let f = 0; f < content.frames.length; f++) {
          if (content.frames[f].document.getElementById(arg.expectedElementId)) {
            contentExpectedElement = content.frames[f].document;
            break;
          }
        }
      }
      else if (contentExpectedElement.localName == "html") {
        contentExpectedElement = contentExpectedElement.ownerDocument;
      }

      if (!contentExpectedElement) {
        sendSyncMessage("BrowserTest:FocusChanged",
                        { details : "expected element " + arg.expectedElementId + " not found" });
        return;
      }

      contentExpectedElement.addEventListener("focus", function focusReceived() {
        contentExpectedElement.removeEventListener("focus", focusReceived, true);

        const contentFM = Components.classes["@mozilla.org/focus-manager;1"].
                            getService(Components.interfaces.nsIFocusManager);
        let details = contentFM.focusedWindow.document.documentElement.id;
        if (contentFM.focusedElement) {
          details += "," + contentFM.focusedElement.id;
        }

        sendSyncMessage("BrowserTest:FocusChanged", { details : details });
      }, true);
    });
  }

  EventUtils.synthesizeKey("VK_F6", { shiftKey: backward });
  yield focusPromise;

  if (typeof expectedElement == "string") {
    expectedElement = fm.focusedWindow.document.getElementById(expectedElement);
  }

  if (gMultiProcessBrowser && onContent) {
    expectedDocument = "main-window";
    expectedElement = gBrowser.selectedBrowser;
  }

  is(fm.focusedWindow.document.documentElement.id, expectedDocument, desc + " document matches");
  is(fm.focusedElement, expectedElement, desc + " element matches");

  if (onContent) {
    messageManager.removeMessageListener("BrowserTest:FocusChanged", focusChangedListener);
  }
}

// Load a page and navigate between it and the chrome window.
add_task(function* ()
{
  let page1Promise = BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser);
  gBrowser.selectedBrowser.loadURI(testPage1);
  yield page1Promise;

  // When the urlbar is focused, pressing F6 should focus the root of the content page.
  gURLBar.focus();
  yield* expectFocusOnF6(false, "html1", "html1",
                                true, "basic focus content page");

  // When the content is focused, pressing F6 should focus the urlbar.
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "basic focus content page urlbar");

  // When a button in content is focused, pressing F6 should focus the urlbar.
  yield* expectFocusOnF6(false, "html1", "html1",
                                true, "basic focus content page with button focused");

  yield ContentTask.spawn(gBrowser.selectedBrowser, { }, function* () {
    return content.document.getElementById("button1").focus();
  });

  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "basic focus content page with button focused urlbar");

  // The document root should be focused, not the button
  yield* expectFocusOnF6(false, "html1", "html1",
                                true, "basic focus again content page with button focused");

  // Check to ensure that the root element is focused
  yield ContentTask.spawn(gBrowser.selectedBrowser, { }, function* () {
    Assert.ok(content.document.activeElement == content.document.documentElement,
      "basic focus again content page with button focused child root is focused");
  });
});

// Open a second tab. Document focus should skip the background tab.
add_task(function* ()
{
  yield BrowserTestUtils.openNewForegroundTab(gBrowser, testPage2);

  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "basic focus content page and second tab urlbar");
  yield* expectFocusOnF6(false, "html2", "html2",
                                true, "basic focus content page with second tab");

  yield BrowserTestUtils.removeTab(gBrowser.selectedTab);
});

// Shift+F6 should navigate backwards. There's only one document here so the effect
// is the same.
add_task(function* ()
{
  gURLBar.focus();
  yield* expectFocusOnF6(true, "html1", "html1",
                               true, "back focus content page");
  yield* expectFocusOnF6(true, "main-window", gURLBar.inputField,
                               false, "back focus content page urlbar");
});

// Open the sidebar and navigate between the sidebar, content and top-level window
add_task(function* ()
{
  let sidebar = document.getElementById("sidebar");

  let loadPromise = BrowserTestUtils.waitForEvent(sidebar, "load", true);
  SidebarUI.toggle('viewBookmarksSidebar');
  yield loadPromise;


  gURLBar.focus();
  yield* expectFocusOnF6(false, "bookmarksPanel",
                                sidebar.contentDocument.getElementById("search-box").inputField,
                                false, "focus with sidebar open sidebar");
  yield* expectFocusOnF6(false, "html1", "html1",
                                true, "focus with sidebar open content");
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "focus with sidebar urlbar");

  // Now go backwards
  yield* expectFocusOnF6(true, "html1", "html1",
                               true, "back focus with sidebar open content");
  yield* expectFocusOnF6(true, "bookmarksPanel",
                               sidebar.contentDocument.getElementById("search-box").inputField,
                               false, "back focus with sidebar open sidebar");
  yield* expectFocusOnF6(true, "main-window", gURLBar.inputField,
                               false, "back focus with sidebar urlbar");

  SidebarUI.toggle('viewBookmarksSidebar');
});

// Navigate when the downloads panel is open
add_task(function* ()
{
  yield pushPrefs(["accessibility.tabfocus", 7]);

  let popupShownPromise = BrowserTestUtils.waitForEvent(document, "popupshown", true);
  EventUtils.synthesizeMouseAtCenter(document.getElementById("downloads-button"), { });
  yield popupShownPromise;

  gURLBar.focus();
  yield* expectFocusOnF6(false, "main-window", document.getElementById("downloadsHistory"),
                                false, "focus with downloads panel open panel");
  yield* expectFocusOnF6(false, "html1", "html1",
                                true, "focus with downloads panel open");
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "focus downloads panel open urlbar");

  // Now go backwards
  yield* expectFocusOnF6(true, "html1", "html1",
                               true, "back focus with downloads panel open");
  yield* expectFocusOnF6(true, "main-window", document.getElementById("downloadsHistory"),
                               false, "back focus with downloads panel open");
  yield* expectFocusOnF6(true, "main-window", gURLBar.inputField,
                               false, "back focus downloads panel open urlbar");

  let downloadsPopup = document.getElementById("downloadsPanel");
  let popupHiddenPromise = BrowserTestUtils.waitForEvent(downloadsPopup, "popuphidden", true);
  downloadsPopup.hidePopup();
  yield popupHiddenPromise;
});

// Navigation with a contenteditable body
add_task(function* ()
{
  yield BrowserTestUtils.openNewForegroundTab(gBrowser, testPage3);

  // The body should be focused when it is editable, not the root.
  gURLBar.focus();
  yield* expectFocusOnF6(false, "html3", "body3",
                                true, "focus with contenteditable body");
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "focus with contenteditable body urlbar");

  // Now go backwards

  yield* expectFocusOnF6(false, "html3", "body3",
                                true, "back focus with contenteditable body");
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "back focus with contenteditable body urlbar");

  yield BrowserTestUtils.removeTab(gBrowser.selectedTab);
});

// Navigation with a frameset loaded
add_task(function* ()
{
  yield BrowserTestUtils.openNewForegroundTab(gBrowser,
    "http://mochi.test:8888/browser/browser/base/content/test/general/file_documentnavigation_frameset.html");

  gURLBar.focus();
  yield* expectFocusOnF6(false, "htmlframe1", "htmlframe1",
                                true, "focus on frameset frame 0");
  yield* expectFocusOnF6(false, "htmlframe2", "htmlframe2",
                                true, "focus on frameset frame 1");
  yield* expectFocusOnF6(false, "htmlframe3", "htmlframe3",
                                true, "focus on frameset frame 2");
  yield* expectFocusOnF6(false, "htmlframe4", "htmlframe4",
                                true, "focus on frameset frame 3");
  yield* expectFocusOnF6(false, "main-window", gURLBar.inputField,
                                false, "focus on frameset frame urlbar");

  yield* expectFocusOnF6(true, "htmlframe4", "htmlframe4",
                               true, "back focus on frameset frame 3");
  yield* expectFocusOnF6(true, "htmlframe3", "htmlframe3",
                               true, "back focus on frameset frame 2");
  yield* expectFocusOnF6(true, "htmlframe2", "htmlframe2",
                               true, "back focus on frameset frame 1");
  yield* expectFocusOnF6(true, "htmlframe1", "htmlframe1",
                               true, "back focus on frameset frame 0");
  yield* expectFocusOnF6(true, "main-window", gURLBar.inputField,
                               false, "back focus on frameset frame urlbar");

  yield BrowserTestUtils.removeTab(gBrowser.selectedTab);
});

// XXXndeakin add tests for browsers inside of panels
