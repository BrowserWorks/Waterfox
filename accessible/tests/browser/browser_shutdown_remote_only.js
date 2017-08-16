/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

'use strict';

add_task(async function () {
  // Making sure that the e10s is enabled on Windows for testing.
  await setE10sPrefs();

  await BrowserTestUtils.withNewTab({
    gBrowser,
    url: `data:text/html,
      <html>
        <head>
          <meta charset="utf-8"/>
          <title>Accessibility Test</title>
        </head>
        <body></body>
      </html>`
  }, async function(browser) {
    info('Creating a service in content');
    // Create a11y service in the content process.
    let a11yInit = initPromise(browser);
    loadFrameScripts(browser, `let accService = Components.classes[
      '@mozilla.org/accessibilityService;1'].getService(
        Components.interfaces.nsIAccessibilityService);`);
    await a11yInit;

    info('Removing a service in content');
    // Remove a11y service reference from the content process.
    let a11yShutdown = shutdownPromise(browser);
    // Force garbage collection that should trigger shutdown.
    loadFrameScripts(browser, `accService = null; Components.utils.forceGC();`);
    await a11yShutdown;

    // Unsetting e10s related preferences.
    await unsetE10sPrefs();
  });
});
