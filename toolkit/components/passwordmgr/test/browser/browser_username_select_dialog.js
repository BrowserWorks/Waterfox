/*
 * Test username selection dialog, on password update from a p-only form,
 * when there are multiple saved logins on the domain.
 */

// Copied from prompt_common.js. TODO: share the code.
function getSelectDialogDoc() {
  // Trudge through all the open windows, until we find the one
  // that has selectDialog.xul loaded.
  var wm = Cc["@mozilla.org/appshell/window-mediator;1"].
           getService(Ci.nsIWindowMediator);
  // var enumerator = wm.getEnumerator("navigator:browser");
  var enumerator = wm.getXULWindowEnumerator(null);

  while (enumerator.hasMoreElements()) {
    var win = enumerator.getNext();
    var windowDocShell = win.QueryInterface(Ci.nsIXULWindow).docShell;

    var containedDocShells = windowDocShell.getDocShellEnumerator(
                                      Ci.nsIDocShellTreeItem.typeChrome,
                                      Ci.nsIDocShell.ENUMERATE_FORWARDS);
    while (containedDocShells.hasMoreElements()) {
        // Get the corresponding document for this docshell
        var childDocShell = containedDocShells.getNext();
        // We don't want it if it's not done loading.
        if (childDocShell.busyFlags != Ci.nsIDocShell.BUSY_FLAGS_NONE)
          continue;
        var childDoc = childDocShell.QueryInterface(Ci.nsIDocShell)
                                    .contentViewer
                                    .DOMDocument;

        if (childDoc.location.href == "chrome://global/content/selectDialog.xul")
          return childDoc;
    }
  }

  return null;
}

let nsLoginInfo = new Components.Constructor("@mozilla.org/login-manager/loginInfo;1",
                                             Ci.nsILoginInfo, "init");
let login1 = new nsLoginInfo("http://example.com", "http://example.com", null,
                             "notifyu1", "notifyp1", "user", "pass");
let login1B = new nsLoginInfo("http://example.com", "http://example.com", null,
                              "notifyu1B", "notifyp1B", "user", "pass");

add_task(function* test_changeUPLoginOnPUpdateForm_accept() {
  info("Select an u+p login from multiple logins, on password update form, and accept.");
  Services.logins.addLogin(login1);
  Services.logins.addLogin(login1B);

  yield testSubmittingLoginForm("subtst_notifications_change_p.html", function*(fieldValues) {
    is(fieldValues.username, "null", "Checking submitted username");
    is(fieldValues.password, "pass2", "Checking submitted password");

    yield ContentTaskUtils.waitForCondition(() => {
      return getSelectDialogDoc();
    }, "Wait for selection dialog to be accessible.");

    let doc = getSelectDialogDoc();
    let dialog = doc.getElementsByTagName("dialog")[0];
    let listbox = doc.getElementById("list");

    is(listbox.selectedIndex, 0, "Checking selected index");
    is(listbox.itemCount, 2, "Checking selected length");
    ['notifyu1', 'notifyu1B'].forEach((username, i) => {
      is(listbox.getItemAtIndex(i).label, username, "Check username selection on dialog");
    });

    dialog.acceptDialog();

    yield ContentTaskUtils.waitForCondition(() => {
      return !getSelectDialogDoc();
    }, "Wait for selection dialog to disappear.");
  });

  let logins = Services.logins.getAllLogins();
  is(logins.length, 2, "Should have 2 logins");

  let login = SpecialPowers.wrap(logins[0]).QueryInterface(Ci.nsILoginMetaInfo);
  is(login.username, "notifyu1", "Check the username unchanged");
  is(login.password, "pass2", "Check the password changed");
  is(login.timesUsed, 2, "Check times used");

  login = SpecialPowers.wrap(logins[1]).QueryInterface(Ci.nsILoginMetaInfo);
  is(login.username, "notifyu1B", "Check the username unchanged");
  is(login.password, "notifyp1B", "Check the password unchanged");
  is(login.timesUsed, 1, "Check times used");

  // cleanup
  login1.password = "pass2";
  Services.logins.removeLogin(login1);
  login1.password = "notifyp1";

  Services.logins.removeLogin(login1B);
});

add_task(function* test_changeUPLoginOnPUpdateForm_cancel() {
  info("Select an u+p login from multiple logins, on password update form, and cancel.");
  Services.logins.addLogin(login1);
  Services.logins.addLogin(login1B);

  yield testSubmittingLoginForm("subtst_notifications_change_p.html", function*(fieldValues) {
    is(fieldValues.username, "null", "Checking submitted username");
    is(fieldValues.password, "pass2", "Checking submitted password");

    yield ContentTaskUtils.waitForCondition(() => {
      return getSelectDialogDoc();
    }, "Wait for selection dialog to be accessible.");

    let doc = getSelectDialogDoc();
    let dialog = doc.getElementsByTagName("dialog")[0];
    let listbox = doc.getElementById("list");

    is(listbox.selectedIndex, 0, "Checking selected index");
    is(listbox.itemCount, 2, "Checking selected length");
    ['notifyu1', 'notifyu1B'].forEach((username, i) => {
      is(listbox.getItemAtIndex(i).label, username, "Check username selection on dialog");
    });

    dialog.cancelDialog();

    yield ContentTaskUtils.waitForCondition(() => {
      return !getSelectDialogDoc();
    }, "Wait for selection dialog to disappear.");
  });

  let logins = Services.logins.getAllLogins();
  is(logins.length, 2, "Should have 2 logins");

  let login = SpecialPowers.wrap(logins[0]).QueryInterface(Ci.nsILoginMetaInfo);
  is(login.username, "notifyu1", "Check the username unchanged");
  is(login.password, "notifyp1", "Check the password unchanged");
  is(login.timesUsed, 1, "Check times used");

  login = SpecialPowers.wrap(logins[1]).QueryInterface(Ci.nsILoginMetaInfo);
  is(login.username, "notifyu1B", "Check the username unchanged");
  is(login.password, "notifyp1B", "Check the password unchanged");
  is(login.timesUsed, 1, "Check times used");

  // cleanup
  Services.logins.removeLogin(login1);
  Services.logins.removeLogin(login1B);
});
