/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Opens up the content area context menu on a video loaded in a
 * browser.
 *
 * @param {Element} browser The <xul:browser> hosting the <video>
 *
 * @param {String} videoID The ID of the video to open the context
 * menu with.
 *
 * @returns Promise
 * @resolves With the context menu DOM node once opened.
 */
async function openContextMenu(browser, videoID) {
  let contextMenu = document.getElementById("contentAreaContextMenu");
  let popupShownPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popupshown"
  );
  await BrowserTestUtils.synthesizeMouseAtCenter(
    "#" + videoID,
    { type: "contextmenu", button: 2 },
    browser
  );
  await popupShownPromise;
  return contextMenu;
}

/**
 * Closes the content area context menu.
 *
 * @param {Element} contextMenu The content area context menu opened with
 * openContextMenu.
 *
 * @returns Promise
 * @resolves With undefined
 */
async function closeContextMenu(contextMenu) {
  let popupHiddenPromise = BrowserTestUtils.waitForEvent(
    contextMenu,
    "popuphidden"
  );
  contextMenu.hidePopup();
  await popupHiddenPromise;
}

/**
 * Tests that the Picture-in-Picture context menu is correctly updated
 * based on the Picture-in-Picture state of the video.
 */
add_task(async () => {
  for (let videoID of ["with-controls", "no-controls"]) {
    info(`Testing ${videoID} case.`);

    await BrowserTestUtils.withNewTab(
      {
        url: TEST_PAGE,
        gBrowser,
      },
      async browser => {
        let menuItem = document.getElementById(
          "context-video-pictureinpicture"
        );
        let menu = await openContextMenu(browser, videoID);
        Assert.ok(
          !menuItem.hidden,
          "Should show Picture-in-Picture menu item."
        );
        Assert.equal(
          menuItem.getAttribute("checked"),
          "false",
          "Picture-in-Picture should be unchecked."
        );
        await closeContextMenu(menu);

        let pipWin = await triggerPictureInPicture(browser, videoID);
        ok(pipWin, "Got Picture-in-Picture window.");

        await SpecialPowers.spawn(browser, [videoID], async videoID => {
          let video = content.document.getElementById(videoID);
          await ContentTaskUtils.waitForCondition(() => {
            return video.isCloningElementVisually;
          }, "Video has started being cloned.");
        });

        menu = await openContextMenu(browser, videoID);
        Assert.ok(
          !menuItem.hidden,
          "Should show Picture-in-Picture menu item."
        );
        Assert.equal(
          menuItem.getAttribute("checked"),
          "true",
          "Picture-in-Picture should be checked."
        );
        await closeContextMenu(menu);

        let videoNotCloning = SpecialPowers.spawn(
          browser,
          [videoID],
          async videoID => {
            let video = content.document.getElementById(videoID);
            await ContentTaskUtils.waitForCondition(() => {
              return !video.isCloningElementVisually;
            }, "Video has stopped being cloned.");
          }
        );
        pipWin.close();
        await videoNotCloning;

        menu = await openContextMenu(browser, videoID);
        Assert.ok(
          !menuItem.hidden,
          "Should show Picture-in-Picture menu item."
        );
        Assert.equal(
          menuItem.getAttribute("checked"),
          "false",
          "Picture-in-Picture should be unchecked."
        );
        await closeContextMenu(menu);

        // Due to bug 1592539, we're hiding the Picture-in-Picture
        // context menu item for <video> elements that have srcObject
        // set to anything but null.
        await SpecialPowers.spawn(browser, [videoID], async videoID => {
          // Construct a new video element, and capture a stream from it
          // to redirect to the video that we're testing.
          let newVideo = content.document.createElement("video");
          content.document.body.appendChild(newVideo);

          let testedVideo = content.document.getElementById(videoID);
          newVideo.src = testedVideo.src;

          testedVideo.srcObject = newVideo.mozCaptureStream();
          await newVideo.play();
          await testedVideo.play();

          await newVideo.pause();
          await testedVideo.pause();
        });
        menu = await openContextMenu(browser, videoID);
        Assert.ok(
          menuItem.hidden,
          "Should not be showing Picture-in-Picture menu item."
        );
        await closeContextMenu(menu);
      }
    );
  }
});
