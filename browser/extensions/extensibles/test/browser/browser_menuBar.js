"use strict";

add_task(async function test_addRestartButton() {
  // check that restart button has been created
  if (AppConstants.platform == "macosx") {
    let restartButton = document.getElementById("app_restartBrowser");
    ok(restartButton, "Check restart browser item added.");
  } else {
    // windows - linux
    let restartButton = document.getElementById("appMenu-restart-button");
    ok(restartButton, "Check restart browser item added.");
  }
  // check that adjusting pref on windows adjusts state to be hidden
  // check that reverting pref adjusts state again
  // reset pref
  // check that clicking initiates a browser restart
  // check that confirmation prompt shows if pref set
  // check that confirmation prompt doesn't show if prompt not set
  // check that if new window is opened, element is added there as well
  // check that correct label text is pulled through
});
