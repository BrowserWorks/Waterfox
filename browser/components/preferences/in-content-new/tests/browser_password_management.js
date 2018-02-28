"use strict";
const PM_URL = "chrome://passwordmgr/content/passwordManager.xul";

var passwordsDialog;

add_task(async function test_setup() {
  let pwmgr = Cc["@mozilla.org/login-manager;1"].
                getService(Ci.nsILoginManager);
  pwmgr.removeAllLogins();

  // add login data
  let nsLoginInfo = new Components.Constructor("@mozilla.org/login-manager/loginInfo;1",
                                                 Ci.nsILoginInfo, "init");
  let login = new nsLoginInfo("http://example.com/", "http://example.com/", null,
                              "user", "password", "u1", "p1");
  pwmgr.addLogin(login);

  registerCleanupFunction(async function() {
    pwmgr.removeAllLogins();
  });
});

add_task(async function test_openPasswordSubDialog() {
  // Undo the save password change.
  registerCleanupFunction(async function() {
    await ContentTask.spawn(gBrowser.selectedBrowser, null, function() {
      let doc = content.document;
      let savePasswordCheckBox = doc.getElementById("savePasswords");
      if (savePasswordCheckBox.checked) {
        savePasswordCheckBox.click();
      }
    });

    gBrowser.removeCurrentTab();
  });

  await openPreferencesViaOpenPreferencesAPI("privacy", {leaveOpen: true});

  let dialogOpened = promiseLoadSubDialog(PM_URL);

  await ContentTask.spawn(gBrowser.selectedBrowser, null, function() {
    let doc = content.document;
    let savePasswordCheckBox = doc.getElementById("savePasswords");
    Assert.ok(!savePasswordCheckBox.checked,
              "Save Password CheckBox should be unchecked by default");
    savePasswordCheckBox.click();

    let showPasswordsButton = doc.getElementById("showPasswords");
    showPasswordsButton.click();
  });

  passwordsDialog = await dialogOpened;
});

add_task(async function test_deletePasswordWithKey() {
  let doc = passwordsDialog.document;

  let tree = doc.getElementById("signonsTree");
  Assert.equal(tree.view.rowCount, 1, "Row count should initially be 1");
  tree.focus();
  tree.view.selection.select(0);

  if (AppConstants.platform == "macosx") {
    EventUtils.synthesizeKey("VK_BACK_SPACE", {});
  } else {
    EventUtils.synthesizeKey("VK_DELETE", {});
  }

  await waitForCondition(() => tree.view.rowCount == 0);

  is_element_visible(content.gSubDialog._dialogs[0]._box,
    "Subdialog is visible after deleting an element");
});
