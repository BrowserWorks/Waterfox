/**
 * Test that the notification bar for crashed GMPs works.
 */
add_task(async function() {
  await BrowserTestUtils.withNewTab({
    gBrowser,
    url: "about:blank",
  }, async function(browser) {
    await ContentTask.spawn(browser, null, async function() {
      const GMP_CRASH_EVENT = {
        pluginID: 1,
        pluginName: "GlobalTestPlugin",
        submittedCrashReport: false,
        bubbles: true,
        cancelable: true,
        gmpPlugin: true,
      };

      let crashEvent = new content.PluginCrashedEvent("PluginCrashed",
                                                      GMP_CRASH_EVENT);
      content.dispatchEvent(crashEvent);
    });

    let notification = await waitForNotificationBar("plugin-crashed", browser);

    let notificationBox = gBrowser.getNotificationBox(browser);
    ok(notification, "Infobar was shown.");
    is(notification.priority, notificationBox.PRIORITY_WARNING_MEDIUM,
       "Correct priority.");
    is(notification.getAttribute("label"),
       "The GlobalTestPlugin plugin has crashed.",
       "Correct message.");
  });
});
