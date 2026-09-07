"use strict";

// Tests that Local Network Access (LNA) checks are enforced for Notification
// icon loads. Those loads have no requesting node, so the address space of the
// document that created the notification is read from its policy container.

Services.scriptloader.loadSubScript(
  new URL("head_local_network_access.js", gTestPath).href,
  this
);

const { PermissionTestUtils } = ChromeUtils.importESModule(
  "resource://testing-common/PermissionTestUtils.sys.mjs"
);

const TEST_PAGE = `${LNA_BASE_URL}page_notification_icon.html`;
const TEST_ORIGIN = "https://example.com";

add_setup(async function () {
  await setupLnaPrefs();
  await setupLnaServer();
  PermissionTestUtils.add(
    TEST_ORIGIN,
    "desktop-notification",
    Services.perms.ALLOW_ACTION
  );
  registerCleanupFunction(() => {
    PermissionTestUtils.remove(TEST_ORIGIN, "desktop-notification");
  });
});

async function showNotificationWithIcon(rand, expectedStatus, description) {
  const promise = observeAndCheck("img", rand, expectedStatus, description);
  const tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, TEST_PAGE);

  await SpecialPowers.spawn(tab.linkedBrowser, [rand], async iconRand => {
    const notification = new content.Notification("lna", {
      icon: `http://localhost:21555/?type=img&rand=${iconRand}`,
    });
    // The notification is shown whether or not the icon load succeeds.
    await new Promise(resolve =>
      notification.addEventListener("show", resolve, { once: true })
    );
    notification.close();
  });

  await promise;
  gBrowser.removeTab(tab);
}

add_task(async function test_notification_icon_denied_without_permission() {
  Services.prefs.setCharPref(
    "network.lna.address_space.public.override",
    "127.0.0.1:4443"
  );

  await showNotificationWithIcon(
    Math.random(),
    Cr.NS_ERROR_LOCAL_NETWORK_ACCESS_DENIED,
    "Notification icon load to localhost is denied without permission"
  );

  Services.prefs.clearUserPref("network.lna.address_space.public.override");
});

add_task(async function test_notification_icon_allowed_with_permission() {
  Services.prefs.setCharPref(
    "network.lna.address_space.public.override",
    "127.0.0.1:4443"
  );

  PermissionTestUtils.add(
    TEST_ORIGIN,
    "loopback-network",
    Services.perms.ALLOW_ACTION
  );

  await showNotificationWithIcon(
    Math.random(),
    Cr.NS_OK,
    "Notification icon load to localhost is allowed with persistent permission"
  );

  PermissionTestUtils.remove(TEST_ORIGIN, "loopback-network");
  Services.prefs.clearUserPref("network.lna.address_space.public.override");
});

// Without the public override the document itself is loopback, so the icon load
// is not a local network access and must not be affected.
add_task(async function test_notification_icon_local_to_local_allowed() {
  await showNotificationWithIcon(
    Math.random(),
    Cr.NS_OK,
    "Notification icon load from a local document is not an LNA"
  );
});
