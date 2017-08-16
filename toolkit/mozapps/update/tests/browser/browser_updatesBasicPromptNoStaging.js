add_task(async function testBasicPromptNoStaging() {
  SpecialPowers.pushPrefEnv({set: [[PREF_APP_UPDATE_STAGING_ENABLED, false]]});

  let updateParams = "showPrompt=1&promptWaitTime=0";

  await runUpdateTest(updateParams, 1, [
    {
      notificationId: "update-available",
      button: "button",
      beforeClick() {
        checkWhatsNewLink("update-available-whats-new");
      }
    },
    {
      notificationId: "update-restart",
      button: "secondarybutton",
      cleanup() {
        AppMenuNotifications.removeNotification(/.*/);
      }
    },
  ]);
});
