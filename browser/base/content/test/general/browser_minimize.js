/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

add_task(async function() {
    registerCleanupFunction(function() {
      window.restore();
    });
    function waitForActive() { return gBrowser.selectedTab.linkedBrowser.docShellIsActive; }
    function waitForInactive() { return !gBrowser.selectedTab.linkedBrowser.docShellIsActive; }
    await promiseWaitForCondition(waitForActive);
    is(gBrowser.selectedTab.linkedBrowser.docShellIsActive, true, "Docshell should be active");
    window.minimize();
    await promiseWaitForCondition(waitForInactive);
    is(gBrowser.selectedTab.linkedBrowser.docShellIsActive, false, "Docshell should be Inactive");
    window.restore();
    await promiseWaitForCondition(waitForActive);
    is(gBrowser.selectedTab.linkedBrowser.docShellIsActive, true, "Docshell should be active again");
});
