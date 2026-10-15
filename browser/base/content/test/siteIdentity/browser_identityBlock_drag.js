/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const TEST_URL =
  getRootDirectory(gTestPath).replace(
    "chrome://mochitests/content",
    "https://example.com"
  ) + "dummy_page.html?a=1&b=2";

add_task(async function test_drag_identity_box_data() {
  await BrowserTestUtils.withNewTab(TEST_URL, async () => {
    let url = gBrowser.currentURI.displaySpec;
    Assert.ok(url.includes("&"), "The URL contains an ampersand");

    let dataTransfer = new DataTransfer();
    document
      .getElementById("identity-box")
      .dispatchEvent(
        new DragEvent("dragstart", { dataTransfer, bubbles: true })
      );

    let escapedURL = url.replaceAll("&", "&amp;");
    Assert.equal(
      dataTransfer.getData("text/html"),
      `<a href="${escapedURL}">${escapedURL}</a>`,
      "Should set the expected text/html drag data"
    );
    Assert.equal(
      dataTransfer.getData("text/plain"),
      url,
      "Should set the expected text/plain drag data"
    );
  });
});
