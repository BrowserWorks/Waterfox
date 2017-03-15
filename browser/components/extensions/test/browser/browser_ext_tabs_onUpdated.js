/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

requestLongerTimeout(2);

add_task(function* () {
  let win1 = yield BrowserTestUtils.openNewBrowserWindow();

  yield focusWindow(win1);

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
      "content_scripts": [{
        "matches": ["http://mochi.test/*/context_tabs_onUpdated_page.html"],
        "js": ["content-script.js"],
        "run_at": "document_start",
      }],
    },

    background: function() {
      let pageURL = "http://mochi.test:8888/browser/browser/components/extensions/test/browser/context_tabs_onUpdated_page.html";

      let expectedSequence = [
        {status: "loading"},
        {status: "loading", url: pageURL},
        {status: "complete"},
      ];
      let collectedSequence = [];

      browser.tabs.onUpdated.addListener(function(tabId, updatedInfo) {
        // onUpdated also fires with updatedInfo.faviconUrl, so explicitly
        // check for updatedInfo.status before recording the event.
        if ("status" in updatedInfo) {
          collectedSequence.push(updatedInfo);
        }
      });

      browser.runtime.onMessage.addListener(function() {
        if (collectedSequence.length !== expectedSequence.length) {
          browser.test.assertEq(
            JSON.stringify(expectedSequence),
            JSON.stringify(collectedSequence),
            "got unexpected number of updateInfo data"
          );
        } else {
          for (let i = 0; i < expectedSequence.length; i++) {
            browser.test.assertEq(
              expectedSequence[i].status,
              collectedSequence[i].status,
              "check updatedInfo status"
            );
            if (expectedSequence[i].url || collectedSequence[i].url) {
              browser.test.assertEq(
                expectedSequence[i].url,
                collectedSequence[i].url,
                "check updatedInfo url"
              );
            }
          }
        }

        browser.test.notifyPass("tabs.onUpdated");
      });

      browser.tabs.create({url: pageURL});
    },
    files: {
      "content-script.js": `
        window.addEventListener("message", function(evt) {
          if (evt.data == "frame-updated") {
            browser.runtime.sendMessage("load-completed");
          }
        }, true);
      `,
    },
  });

  yield Promise.all([
    extension.startup(),
    extension.awaitFinish("tabs.onUpdated"),
  ]);

  yield extension.unload();

  yield BrowserTestUtils.closeWindow(win1);
});

function* do_test_update(background, withPermissions = true) {
  let win1 = yield BrowserTestUtils.openNewBrowserWindow();

  yield focusWindow(win1);

  let manifest = {};
  if (withPermissions) {
    manifest.permissions = ["tabs"];
  }
  let extension = ExtensionTestUtils.loadExtension({manifest, background});

  yield Promise.all([
    yield extension.startup(),
    yield extension.awaitFinish("finish"),
  ]);

  yield extension.unload();

  yield BrowserTestUtils.closeWindow(win1);
}

add_task(function* test_pinned() {
  yield do_test_update(function background() {
    // Create a new tab for testing update.
    browser.tabs.create({}, function(tab) {
      browser.tabs.onUpdated.addListener(function onUpdated(tabId, changeInfo) {
        // Check callback
        browser.test.assertEq(tabId, tab.id, "Check tab id");
        browser.test.log("onUpdate: " + JSON.stringify(changeInfo));
        if ("pinned" in changeInfo) {
          browser.test.assertTrue(changeInfo.pinned, "Check changeInfo.pinned");
          browser.tabs.onUpdated.removeListener(onUpdated);
          // Remove created tab.
          browser.tabs.remove(tabId);
          browser.test.notifyPass("finish");
          return;
        }
      });
      browser.tabs.update(tab.id, {pinned: true});
    });
  });
});

add_task(function* test_unpinned() {
  yield do_test_update(function background() {
    // Create a new tab for testing update.
    browser.tabs.create({pinned: true}, function(tab) {
      browser.tabs.onUpdated.addListener(function onUpdated(tabId, changeInfo) {
        // Check callback
        browser.test.assertEq(tabId, tab.id, "Check tab id");
        browser.test.log("onUpdate: " + JSON.stringify(changeInfo));
        if ("pinned" in changeInfo) {
          browser.test.assertFalse(changeInfo.pinned, "Check changeInfo.pinned");
          browser.tabs.onUpdated.removeListener(onUpdated);
          // Remove created tab.
          browser.tabs.remove(tabId);
          browser.test.notifyPass("finish");
          return;
        }
      });
      browser.tabs.update(tab.id, {pinned: false});
    });
  });
});

add_task(function* test_url() {
  yield do_test_update(function background() {
    // Create a new tab for testing update.
    browser.tabs.create({}, function(tab) {
      browser.tabs.onUpdated.addListener(function onUpdated(tabId, changeInfo) {
        // Check callback
        browser.test.assertEq(tabId, tab.id, "Check tab id");
        browser.test.log("onUpdate: " + JSON.stringify(changeInfo));
        if ("url" in changeInfo) {
          browser.test.assertEq("about:blank", changeInfo.url,
                                "Check changeInfo.url");
          browser.tabs.onUpdated.removeListener(onUpdated);
          // Remove created tab.
          browser.tabs.remove(tabId);
          browser.test.notifyPass("finish");
          return;
        }
      });
      browser.tabs.update(tab.id, {url: "about:blank"});
    });
  });
});

add_task(function* test_without_tabs_permission() {
  yield do_test_update(function background() {
    browser.tabs.create({url: "about:blank"}, function(tab) {
      browser.tabs.onUpdated.addListener(function onUpdated(tabId, changeInfo) {
        if (tabId == tab.id) {
          browser.test.assertFalse("url" in changeInfo, "url should not be included without tabs permission");
          browser.test.assertFalse("favIconUrl" in changeInfo, "favIconUrl should not be included without tabs permission");

          if (changeInfo.status == "complete") {
            browser.tabs.onUpdated.removeListener(onUpdated);
            browser.tabs.remove(tabId);
            browser.test.notifyPass("finish");
          }
        }
      });
      browser.tabs.reload(tab.id);
    });
  }, false /* withPermissions */);
});

add_task(forceGC);
