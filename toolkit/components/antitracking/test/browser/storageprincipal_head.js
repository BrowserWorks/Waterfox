/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* import-globals-from head.js */

"use strict";

this.StoragePrincipalHelper = {
  runTest(name, callback, cleanupFunction, extraPrefs, runInPrivateWindow) {
    add_task(async _ => {
      info(
        "Starting test `" +
          name +
          "' with storage principal running in a " +
          (runInPrivateWindow ? "private" : "normal") +
          " window..."
      );

      await SpecialPowers.flushPrefEnv();
      await SpecialPowers.pushPrefEnv({
        set: [
          ["dom.storage_access.enabled", true],
          [
            "network.cookie.cookieBehavior",
            Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER,
          ],
          ["privacy.trackingprotection.enabled", false],
          ["privacy.trackingprotection.pbmode.enabled", false],
          ["privacy.trackingprotection.annotate_channels", true],
          ["privacy.storagePrincipal.enabledForTrackers", true],
          [
            "privacy.restrict3rdpartystorage.userInteractionRequiredForHosts",
            "tracking.example.org",
          ],
        ],
      });

      if (extraPrefs && Array.isArray(extraPrefs) && extraPrefs.length) {
        await SpecialPowers.pushPrefEnv({ set: extraPrefs });
      }

      await UrlClassifierTestUtils.addTestTrackers();

      let win = window;
      if (runInPrivateWindow) {
        win = OpenBrowserWindow({ private: true });
        await TestUtils.topicObserved("browser-delayed-startup-finished");
      }

      info("Creating a new tab");
      let tab = BrowserTestUtils.addTab(win.gBrowser, TEST_TOP_PAGE);
      win.gBrowser.selectedTab = tab;

      let browser = win.gBrowser.getBrowserForTab(tab);
      await BrowserTestUtils.browserLoaded(browser);

      info("Creating a 3rd party content");
      await SpecialPowers.spawn(
        browser,
        [
          {
            page: TEST_3RD_PARTY_STORAGE_PAGE,
            callback: callback.toString(),
          },
        ],
        async obj => {
          await new content.Promise(resolve => {
            let ifr = content.document.createElement("iframe");
            ifr.onload = async _ => {
              await SpecialPowers.spawn(ifr, [], async _ => {
                is(
                  content.document.nodePrincipal.originAttributes
                    .firstPartyDomain,
                  "",
                  "We don't have first-party set on nodePrincipal"
                );
                is(
                  content.document.effectiveStoragePrincipal.originAttributes
                    .firstPartyDomain,
                  "(http,example.net)",
                  "We have first-party set on storagePrincipal"
                );
              });
              info("Sending code to the 3rd party content");
              ifr.contentWindow.postMessage(obj.callback, "*");
            };

            content.addEventListener("message", function msg(event) {
              if (event.data.type == "finish") {
                content.removeEventListener("message", msg);
                resolve();
                return;
              }

              if (event.data.type == "ok") {
                ok(event.data.what, event.data.msg);
                return;
              }

              if (event.data.type == "info") {
                info(event.data.msg);
                return;
              }

              ok(false, "Unknown message");
            });

            content.document.body.appendChild(ifr);
            ifr.src = obj.page;
          });
        }
      );

      info("Removing the tab");
      BrowserTestUtils.removeTab(tab);

      if (runInPrivateWindow) {
        win.close();
      }
    });

    add_task(async _ => {
      info("Cleaning up.");
      if (cleanupFunction) {
        await cleanupFunction();
      }
      UrlClassifierTestUtils.cleanupTestTrackers();

      // While running these tests we typically do not have enough idle time to do
      // GC reliably, so force it here.
      /* import-globals-from antitracking_head.js */
      forceGC();
    });
  },
};
