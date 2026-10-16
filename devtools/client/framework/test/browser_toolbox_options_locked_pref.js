/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that the options panel disables checkboxes for locked prefs.

const PREF = "devtools.chrome.enabled";

add_task(async function () {
  Services.prefs.lockPref(PREF);
  registerCleanupFunction(() => Services.prefs.unlockPref(PREF));

  const tab = await addTab("data:text/html,test");
  const toolbox = await openToolboxForTab(tab, "options");
  const panel = toolbox.getCurrentPanel();

  const checkbox = panel.panelDoc.querySelector(`input[data-pref="${PREF}"]`);
  ok(checkbox.disabled, "The checkbox of a locked pref is disabled");

  const otherCheckbox = panel.panelDoc.querySelector(
    `input[data-pref="devtools.debugger.remote-enabled"]`
  );
  ok(!otherCheckbox.disabled, "The checkbox of an unlocked pref is enabled");
});
