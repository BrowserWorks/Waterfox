/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";

const SITE_SPECIFIC_PREF = "browser.zoom.siteSpecific";

add_task(function* () {
  let tab1 = yield BrowserTestUtils.openNewForegroundTab(gBrowser, "http://example.com/");
  let tab2 = yield BrowserTestUtils.openNewForegroundTab(gBrowser, "http://example.net/");

  gBrowser.selectedTab = tab1;

  async function background() {
    function promiseUpdated(tabId, attr) {
      return new Promise(resolve => {
        let onUpdated = (tabId_, changeInfo, tab) => {
          if (tabId == tabId_ && attr in changeInfo) {
            browser.tabs.onUpdated.removeListener(onUpdated);

            resolve({changeInfo, tab});
          }
        };
        browser.tabs.onUpdated.addListener(onUpdated);
      });
    }

    let deferred = {};
    browser.test.onMessage.addListener((message, msg, result) => {
      if (message == "msg-done" && deferred[msg]) {
        deferred[msg].resolve(result);
      }
    });

    let _id = 0;
    function msg(...args) {
      return new Promise((resolve, reject) => {
        let id = ++_id;
        deferred[id] = {resolve, reject};
        browser.test.sendMessage("msg", id, ...args);
      });
    }


    let zoomEvents = [];
    let eventPromises = [];
    browser.tabs.onZoomChange.addListener(info => {
      zoomEvents.push(info);
      if (eventPromises.length) {
        eventPromises.shift().resolve();
      }
    });

    let awaitZoom = async (tabId, newValue) => {
      let listener;

      await new Promise(async resolve => {
        listener = info => {
          if (info.tabId == tabId && info.newZoomFactor == newValue) {
            resolve();
          }
        };
        browser.tabs.onZoomChange.addListener(listener);

        let zoomFactor = await browser.tabs.getZoom(tabId);
        if (zoomFactor == newValue) {
          resolve();
        }
      });

      browser.tabs.onZoomChange.removeListener(listener);
    };

    let checkZoom = async (tabId, newValue, oldValue = null) => {
      let awaitEvent;
      if (oldValue != null && !zoomEvents.length) {
        awaitEvent = new Promise(resolve => {
          eventPromises.push({resolve});
        });
      }

      let [apiZoom, realZoom] = await Promise.all([
        browser.tabs.getZoom(tabId),
        msg("get-zoom", tabId),
        awaitEvent,
      ]);

      browser.test.assertEq(newValue, apiZoom, `Got expected zoom value from API`);
      browser.test.assertEq(newValue, realZoom, `Got expected zoom value from parent`);

      if (oldValue != null) {
        let event = zoomEvents.shift();
        browser.test.assertEq(tabId, event.tabId, `Got expected zoom event tab ID`);
        browser.test.assertEq(newValue, event.newZoomFactor, `Got expected zoom event zoom factor`);
        browser.test.assertEq(oldValue, event.oldZoomFactor, `Got expected zoom event old zoom factor`);

        browser.test.assertEq(3, Object.keys(event.zoomSettings).length, `Zoom settings should have 3 keys`);
        browser.test.assertEq("automatic", event.zoomSettings.mode, `Mode should be "automatic"`);
        browser.test.assertEq("per-origin", event.zoomSettings.scope, `Scope should be "per-origin"`);
        browser.test.assertEq(1, event.zoomSettings.defaultZoomFactor, `Default zoom should be 1`);
      }
    };

    try {
      let tabs = await browser.tabs.query({lastFocusedWindow: true});
      browser.test.assertEq(tabs.length, 3, "We have three tabs");

      let tabIds = [tabs[1].id, tabs[2].id];
      await checkZoom(tabIds[0], 1);

      await browser.tabs.setZoom(tabIds[0], 2);
      await checkZoom(tabIds[0], 2, 1);

      let zoomSettings = await browser.tabs.getZoomSettings(tabIds[0]);
      browser.test.assertEq(3, Object.keys(zoomSettings).length, `Zoom settings should have 3 keys`);
      browser.test.assertEq("automatic", zoomSettings.mode, `Mode should be "automatic"`);
      browser.test.assertEq("per-origin", zoomSettings.scope, `Scope should be "per-origin"`);
      browser.test.assertEq(1, zoomSettings.defaultZoomFactor, `Default zoom should be 1`);


      browser.test.log(`Switch to tab 2`);
      await browser.tabs.update(tabIds[1], {active: true});
      await checkZoom(tabIds[1], 1);


      browser.test.log(`Navigate tab 2 to origin of tab 1`);
      browser.tabs.update(tabIds[1], {url: "http://example.com"});
      await promiseUpdated(tabIds[1], "url");
      await checkZoom(tabIds[1], 2, 1);


      browser.test.log(`Update zoom in tab 2, expect changes in both tabs`);
      await browser.tabs.setZoom(tabIds[1], 1.5);
      await checkZoom(tabIds[1], 1.5, 2);


      browser.test.log(`Switch to tab 1, expect asynchronous zoom change just after the switch`);
      await Promise.all([
        awaitZoom(tabIds[0], 1.5),
        browser.tabs.update(tabIds[0], {active: true}),
      ]);
      await checkZoom(tabIds[0], 1.5, 2);


      browser.test.log("Set zoom to 0, expect it set to 1");
      await browser.tabs.setZoom(tabIds[0], 0);
      await checkZoom(tabIds[0], 1, 1.5);


      browser.test.log("Change zoom externally, expect changes reflected");
      await msg("enlarge");
      await checkZoom(tabIds[0], 1.1, 1);

      await Promise.all([
        browser.tabs.setZoom(tabIds[0], 0),
        browser.tabs.setZoom(tabIds[1], 0),
      ]);
      await Promise.all([
        checkZoom(tabIds[0], 1, 1.1),
        checkZoom(tabIds[1], 1, 1.5),
      ]);


      browser.test.log("Check that invalid zoom values throw an error");
      await browser.test.assertRejects(
        browser.tabs.setZoom(tabIds[0], 42),
        /Zoom value 42 out of range/,
        "Expected an out of range error");

      browser.test.log("Disable site-specific zoom, expect correct scope");
      await msg("site-specific", false);
      zoomSettings = await browser.tabs.getZoomSettings(tabIds[0]);

      browser.test.assertEq("per-tab", zoomSettings.scope, `Scope should be "per-tab"`);
      await msg("site-specific", null);

      browser.test.notifyPass("tab-zoom");
    } catch (e) {
      browser.test.fail(`Error: ${e} :: ${e.stack}`);
      browser.test.notifyFail("tab-zoom");
    }
  }

  let extension = ExtensionTestUtils.loadExtension({
    manifest: {
      "permissions": ["tabs"],
    },

    background,
  });

  extension.onMessage("msg", (id, msg, ...args) => {
    let {Management: {global: {TabManager}}} = Cu.import("resource://gre/modules/Extension.jsm", {});

    let resp;
    if (msg == "get-zoom") {
      let tab = TabManager.getTab(args[0]);
      resp = ZoomManager.getZoomForBrowser(tab.linkedBrowser);
    } else if (msg == "set-zoom") {
      let tab = TabManager.getTab(args[0]);
      ZoomManager.setZoomForBrowser(tab.linkedBrowser);
    } else if (msg == "enlarge") {
      FullZoom.enlarge();
    } else if (msg == "site-specific") {
      if (args[0] == null) {
        SpecialPowers.clearUserPref(SITE_SPECIFIC_PREF);
      } else {
        SpecialPowers.setBoolPref(SITE_SPECIFIC_PREF, args[0]);
      }
    }

    extension.sendMessage("msg-done", id, resp);
  });

  yield extension.startup();

  yield extension.awaitFinish("tab-zoom");

  yield extension.unload();

  yield BrowserTestUtils.removeTab(tab1);
  yield BrowserTestUtils.removeTab(tab2);
});
