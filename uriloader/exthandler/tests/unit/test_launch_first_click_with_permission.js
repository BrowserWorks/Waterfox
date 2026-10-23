/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { nsContentDispatchChooser } = ChromeUtils.importESModule(
  "resource://gre/modules/ContentDispatchChooser.sys.mjs"
);
const { MockRegistrar } = ChromeUtils.importESModule(
  "resource://testing-common/MockRegistrar.sys.mjs"
);

const TEST_SCHEME = "lnksap";
const TEST_ORIGIN = "https://example.com";

function makeMockHandler() {
  return {
    type: TEST_SCHEME,
    hasDefaultHandler: true,
    preferredApplicationHandler: null,
    alwaysAskBeforeHandling: true,
    preferredAction: Ci.nsIHandlerInfo.useSystemDefault,
    launchedURI: null,
    launchWithURI(aURI) {
      this.launchedURI = aURI;
    },
  };
}

/**
 * When a caller already has the open-protocol-handler permission for a
 * non-standard protocol that has an OS default handler but no preferred
 * application, the first click should launch the handler directly without
 * prompting, and the updated handler data should be persisted. See bug 1966584.
 */
add_task(async function test_first_click_launches_with_permission() {
  let storedHandler = null;
  let mockHandlerService = {
    QueryInterface: ChromeUtils.generateQI(["nsIHandlerService"]),
    store(handlerInfo) {
      storedHandler = handlerInfo;
    },
  };
  let cid = MockRegistrar.register(
    "@mozilla.org/uriloader/handler-service;1",
    mockHandlerService
  );
  registerCleanupFunction(() => MockRegistrar.unregister(cid));

  let principal =
    Services.scriptSecurityManager.createContentPrincipalFromOrigin(
      TEST_ORIGIN
    );
  Services.perms.addFromPrincipal(
    principal,
    "open-protocol-handler^" + TEST_SCHEME,
    Services.perms.ALLOW_ACTION
  );

  let chooser = new nsContentDispatchChooser();
  let handler = makeMockHandler();
  let uri = Services.io.newURI(`${TEST_SCHEME}://test`);

  await chooser.handleURI(handler, uri, principal, null);

  Assert.equal(
    handler.launchedURI?.spec,
    uri.spec,
    "Should launch the handler on the first click."
  );
  Assert.ok(
    !handler.alwaysAskBeforeHandling,
    "Should clear alwaysAskBeforeHandling."
  );
  Assert.ok(storedHandler, "Should persist the updated handler data.");
  Assert.ok(
    !storedHandler.alwaysAskBeforeHandling,
    "Persisted handler should no longer always ask."
  );

  Services.perms.removeAll();
});

add_task(function test_permission_not_inherited_by_subdomain() {
  Services.perms.addFromPrincipal(
    Services.scriptSecurityManager.createContentPrincipalFromOrigin(
      TEST_ORIGIN
    ),
    "open-protocol-handler^" + TEST_SCHEME,
    Services.perms.ALLOW_ACTION
  );

  let chooser = new nsContentDispatchChooser();
  let subdomainPrincipal =
    Services.scriptSecurityManager.createContentPrincipalFromOrigin(
      "https://www.example.com"
    );

  Assert.ok(
    !chooser._hasProtocolHandlerPermission(
      makeMockHandler(),
      subdomainPrincipal,
      false,
      false,
      false
    ),
    "Subdomain should not inherit the permission."
  );

  Services.perms.removeAll();
});
