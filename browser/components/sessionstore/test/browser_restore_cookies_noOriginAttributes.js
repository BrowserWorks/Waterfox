/*
 * Bug 1267910 - The regression test case for session cookies.
 */

"use strict";

const TEST_HOST = "www.example.com";
const COOKIE =
{
  name: "test1",
  value: "yes1",
  path: "/browser/browser/components/sessionstore/test/"
};
const SESSION_DATA = `
{
  "version": ["sessionrestore", 1],
  "windows": [{
    "tabs": [{
      "entries": [],
      "lastAccessed": 1463893009797,
      "hidden": false,
      "attributes": {},
      "image": null
    }, {
      "entries": [{
        "url": "http://www.example.com/browser/browser/components/sessionstore/test/browser_1267910_page.html",
        \"charset": "UTF-8",
        "ID": 0,
        "docshellID": 2,
        "originalURI": "http://www.example.com/browser/browser/components/sessionstore/test/browser_1267910_page.html",
        \"docIdentifier": 0,
        "persist": true
      }],
      "lastAccessed": 1463893009321,
      "hidden": false,
      "attributes": {},
      "userContextId": 0,
      "index": 1,
      "image": "http://www.example.com/favicon.ico"
    }],
    "selected": 1,
    "_closedTabs": [],
    "busy": false,
    "width": 1024,
    "height": 768,
    "screenX": 4,
    "screenY": 23,
    "sizemode": "normal",
    "cookies": [{
      "host": "www.example.com",
      "value": "yes1",
      "path": "/browser/browser/components/sessionstore/test/",
      "name": "test1"
    }]
  }],
  "selectedWindow": 1,
  "_closedWindows": [],
  "session": {
    "lastUpdate": 1463893009801,
    "startTime": 1463893007134,
    "recentCrashes": 0
  },
  "global": {}
}`;
const SESSION_DATA_OA = `
{
  "version": ["sessionrestore", 1],
  "windows": [{
    "tabs": [{
      "entries": [],
      "lastAccessed": 1463893009797,
      "hidden": false,
      "attributes": {},
      "image": null
    }, {
      "entries": [{
        "url": "http://www.example.com/browser/browser/components/sessionstore/test/browser_1267910_page.html",
        \"charset": "UTF-8",
        "ID": 0,
        "docshellID": 2,
        "originalURI": "http://www.example.com/browser/browser/components/sessionstore/test/browser_1267910_page.html",
        \"docIdentifier": 0,
        "persist": true
      }],
      "lastAccessed": 1463893009321,
      "hidden": false,
      "attributes": {},
      "userContextId": 0,
      "index": 1,
      "image": "http://www.example.com/favicon.ico"
    }],
    "selected": 1,
    "_closedTabs": [],
    "busy": false,
    "width": 1024,
    "height": 768,
    "screenX": 4,
    "screenY": 23,
    "sizemode": "normal",
    "cookies": [{
      "host": "www.example.com",
      "value": "yes1",
      "path": "/browser/browser/components/sessionstore/test/",
      "name": "test1",
      "originAttributes": {
        "addonId": "",
        "appId": 0,
        "inIsolatedMozBrowser": false,
        "userContextId": 0
      }
    }]
  }],
  "selectedWindow": 1,
  "_closedWindows": [],
  "session": {
    "lastUpdate": 1463893009801,
    "startTime": 1463893007134,
    "recentCrashes": 0
  },
  "global": {}
}`;

add_task(function* run_test() {
  // Wait until initialization is complete.
  yield SessionStore.promiseInitialized;

  // Clear cookies.
  Services.cookies.removeAll();

  // Open a new window.
  let win = yield promiseNewWindowLoaded();

  // Restore window with session cookies that have no originAttributes.
  ss.setWindowState(win, SESSION_DATA, true);

  let enumerator = Services.cookies.getCookiesFromHost(TEST_HOST, {});
  let cookie;
  let cookieCount = 0;
  while (enumerator.hasMoreElements()) {
    cookie = enumerator.getNext().QueryInterface(Ci.nsICookie);
    cookieCount++;
  }

  // Check that the cookie is restored successfully.
  is(cookieCount, 1, "expected one cookie");
  is(cookie.name, COOKIE.name, "cookie name successfully restored");
  is(cookie.value, COOKIE.value, "cookie value successfully restored");
  is(cookie.path, COOKIE.path, "cookie path successfully restored");

  // Clear cookies.
  Services.cookies.removeAll();

  // Restore window with session cookies that have originAttributes within.
  ss.setWindowState(win, SESSION_DATA_OA, true);

  enumerator = Services.cookies.getCookiesFromHost(TEST_HOST, {});
  cookieCount = 0;
  while (enumerator.hasMoreElements()) {
    cookie = enumerator.getNext().QueryInterface(Ci.nsICookie);
    cookieCount++;
  }

  // Check that the cookie is restored successfully.
  is(cookieCount, 1, "expected one cookie");
  is(cookie.name, COOKIE.name, "cookie name successfully restored");
  is(cookie.value, COOKIE.value, "cookie value successfully restored");
  is(cookie.path, COOKIE.path, "cookie path successfully restored");

  // Close our window.
  yield BrowserTestUtils.closeWindow(win);
});
