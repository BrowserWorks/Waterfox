"use strict";

/**
 * WHOA THERE: We should never be adding new things to
 * EXPECTED_APPMENU_OPEN_REFLOWS. This is a whitelist that should slowly go
 * away as we improve the performance of the front-end. Instead of adding more
 * reflows to the whitelist, you should be modifying your code to avoid the reflow.
 *
 * See https://developer.mozilla.org/en-US/Firefox/Performance_best_practices_for_Firefox_fe_engineers
 * for tips on how to do that.
 */
const EXPECTED_APPMENU_OPEN_REFLOWS = [
  {
    stack: [
      "openPopup@chrome://global/content/bindings/popup.xml",
      "show/</<@chrome://browser/content/customizableui/panelUI.js",
    ],
  },

  {
    stack: [
      "get_alignmentPosition@chrome://global/content/bindings/popup.xml",
      "adjustArrowPosition@chrome://global/content/bindings/popup.xml",
      "onxblpopupshowing@chrome://global/content/bindings/popup.xml",
      "openPopup@chrome://global/content/bindings/popup.xml",
      "show/</<@chrome://browser/content/customizableui/panelUI.js",
    ],

    times: 2, // This number should only ever go down - never up.
  },

  {
    stack: [
      "get_alignmentPosition@chrome://global/content/bindings/popup.xml",
      "adjustArrowPosition@chrome://global/content/bindings/popup.xml",
      "onxblpopuppositioned@chrome://global/content/bindings/popup.xml",
    ],
  },

  {
    stack: [
      "get_alignmentPosition@chrome://global/content/bindings/popup.xml",
      "handleEvent@resource:///modules/PanelMultiView.jsm",
      "openPopup@chrome://global/content/bindings/popup.xml",
    ],
  },

  {
    stack: [
      "handleEvent@resource:///modules/PanelMultiView.jsm",
      "openPopup@chrome://global/content/bindings/popup.xml",
    ],

    times: 6, // This number should only ever go down - never up.
  },
];

const EXPECTED_APPMENU_SUBVIEW_REFLOWS = [
  /**
   * The synced tabs view has labels that are multiline. Because of bugs in
   * XUL layout relating to multiline text in scrollable containers, we need
   * to manually read their height in order to ensure container heights are
   * correct. Unfortunately this requires 2 sync reflows.
   *
   * If we add more views where this is necessary, we may need to duplicate
   * these expected reflows further.
   */
  {
    stack: [
      "descriptionHeightWorkaround@resource:///modules/PanelMultiView.jsm",
      "onTransitionEnd@resource:///modules/PanelMultiView.jsm",
    ],

    times: 2, // This number should only ever go down - never up.
  },

  /**
   * Please don't add anything new!
   */
];

add_task(async function() {
  await ensureNoPreloadedBrowser();

  await SpecialPowers.pushPrefEnv({
    set: [["browser.photon.structure.enabled", true]],
  });

  // First, open the appmenu.
  await withReflowObserver(async function() {
    let popupPositioned =
      BrowserTestUtils.waitForEvent(PanelUI.panel, "popuppositioned");
    await PanelUI.show();
    await popupPositioned;
  }, EXPECTED_APPMENU_OPEN_REFLOWS);

  // Now open a series of subviews, and then close the appmenu. We
  // should not reflow during any of this.
  await withReflowObserver(async function() {
    // This recursive function will take the current main or subview,
    // find all of the buttons that navigate to subviews inside it,
    // and click each one individually. Upon entering the new view,
    // we recurse. When the subviews within a view have been
    // exhausted, we go back up a level.
    async function openSubViewsRecursively(currentView) {
      let navButtons = Array.from(currentView.querySelectorAll(".subviewbutton-nav"));
      if (!navButtons) {
        return;
      }

      for (let button of navButtons) {
        info("Click " + button.id);
        button.click();
        await BrowserTestUtils.waitForEvent(PanelUI.panel, "ViewShown");

        // Workaround until bug 1363756 is fixed, then this can be removed.
        await BrowserTestUtils.waitForCondition(() => {
          return !PanelUI.multiView.instance._viewContainer.hasAttribute("width");
        });

        info("Shown " + PanelUI.multiView.instance._currentSubView.id);
        // Unfortunately, I can't find a better accessor to the current
        // subview, so I have to reach the PanelMultiView instance
        // here.
        await openSubViewsRecursively(PanelUI.multiView.instance._currentSubView);
        PanelUI.multiView.goBack();
        await BrowserTestUtils.waitForEvent(PanelUI.panel, "ViewShown");

        // Workaround until bug 1363756 is fixed, then this can be removed.
        await BrowserTestUtils.waitForCondition(() => {
          return !PanelUI.multiView.instance._viewContainer.hasAttribute("width");
        });
      }
    }

    await openSubViewsRecursively(PanelUI.mainView);

    let hidden = BrowserTestUtils.waitForEvent(PanelUI.panel, "popuphidden");
    PanelUI.hide();
    await hidden;
  }, EXPECTED_APPMENU_SUBVIEW_REFLOWS);
});
