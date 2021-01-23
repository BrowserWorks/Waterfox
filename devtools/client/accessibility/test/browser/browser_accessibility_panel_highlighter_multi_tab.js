/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const TEST_URI = '<h1 id="h1">header</h1><p id="p">paragraph</p>';

add_task(async function() {
  Services.prefs.setBoolPref("devtools.accessibility.auto-init.enabled", false);

  const { toolbox: toolbox1 } = await addTestTab(buildURL(TEST_URI));
  const { toolbox: toolbox2 } = await addTestTab(buildURL(TEST_URI));
  const options = await openOptions(toolbox2);

  info("Check that initially both accessibility panels are highlighted.");
  await checkHighlighted(toolbox1, true);
  await checkHighlighted(toolbox2, true);

  info("Toggle accessibility panel off and on.");
  const onOtherPanelSelectedInToolbox1 = toolbox1.once("select");
  await toggleAccessibility(options);
  await toggleAccessibility(options);

  // In toolbox 1, the accessibility panel was still selected.
  // Disabling the panel will force another panel to be selected.
  // To avoid intermittents on toolbox destroy, wait for this other panel
  // to finish loading.
  info("Wait for another panel to be selected instead of accessibility panel");
  await onOtherPanelSelectedInToolbox1;

  await checkHighlighted(toolbox1, true);
  await checkHighlighted(toolbox2, true);

  info("Toggle accessibility panel off and on again.");
  await toggleAccessibility(options);
  await toggleAccessibility(options);

  const { accessibilityProxy, panelWin } = await toolbox2.selectTool(
    "accessibility"
  );
  // Disable accessibility service through the panel and wait for the shutdown
  // event.
  const shutdown = accessibilityProxy.accessibilityFront.once("shutdown");
  const disableButton = await BrowserTestUtils.waitForCondition(
    () => panelWin.document.getElementById("accessibility-disable-button"),
    "Wait for the disable button."
  );
  EventUtils.sendMouseEvent({ type: "click" }, disableButton, panelWin);
  await shutdown;

  await checkHighlighted(toolbox1, false);
  await checkHighlighted(toolbox2, false);

  Services.prefs.clearUserPref("devtools.accessibility.auto-init.enabled");
});

async function openOptions(toolbox) {
  const panel = await toolbox.selectTool("options");
  return {
    panelWin: panel.panelWin,
    // This is a getter becuse toolbox tools list gets re-setup every time there
    // is a tool-registered or tool-undregistered event.
    get checkbox() {
      return panel.panelDoc.getElementById("accessibility");
    },
  };
}

async function toggleAccessibility({ panelWin, checkbox }) {
  const prevChecked = checkbox.checked;
  const onToggleTool = gDevTools.once(
    `tool-${prevChecked ? "unregistered" : "registered"}`
  );
  EventUtils.sendMouseEvent({ type: "click" }, checkbox, panelWin);
  const id = await onToggleTool;
  is(id, "accessibility", "Correct event was fired");
}
