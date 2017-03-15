/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// Bug 1336811 - An XHR that has a .onreadystatechange waiting should
// not leak forever once the tab is closed. CC optimizations need to be
// turned off once it is closed.

add_task(function* test() {
  const url = "http://mochi.test:8888/browser/dom/xhr/tests/browser_xhr_onchange_leak.html";
  let newTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, url);
  let browser = gBrowser.selectedBrowser;
  let done = yield ContentTask.spawn(browser,{}, function*(browser){
    let doc = content.document;
    let promise = ContentTaskUtils.waitForEvent(this, "DOMContentLoaded", true);
    content.location = "about:home";
    yield promise;
    return true;
  });
  is(done, true, "need to check something");
  yield BrowserTestUtils.removeTab(newTab);
});
