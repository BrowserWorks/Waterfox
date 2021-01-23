/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

const { AuthenticationError, BrowserIDManager } = ChromeUtils.import(
  "resource://services-sync/browserid_identity.js"
);
const { Resource } = ChromeUtils.import("resource://services-sync/resource.js");
const { initializeIdentityWithTokenServerResponse } = ChromeUtils.import(
  "resource://testing-common/services/sync/fxa_utils.js"
);
const { HawkClient } = ChromeUtils.import(
  "resource://services-common/hawkclient.js"
);
const { FxAccounts } = ChromeUtils.import(
  "resource://gre/modules/FxAccounts.jsm"
);
const { FxAccountsClient } = ChromeUtils.import(
  "resource://gre/modules/FxAccountsClient.jsm"
);
const {
  CERT_LIFETIME,
  ERRNO_INVALID_AUTH_TOKEN,
  ONLOGIN_NOTIFICATION,
  ONVERIFIED_NOTIFICATION,
} = ChromeUtils.import("resource://gre/modules/FxAccountsCommon.js");
const { Service } = ChromeUtils.import("resource://services-sync/service.js");
const { Status } = ChromeUtils.import("resource://services-sync/status.js");
const { TokenServerClient, TokenServerClientServerError } = ChromeUtils.import(
  "resource://services-common/tokenserverclient.js"
);

const SECOND_MS = 1000;
const MINUTE_MS = SECOND_MS * 60;
const HOUR_MS = MINUTE_MS * 60;

const MOCK_SCOPED_KEY = {
  k:
    "3TVYx0exDTbrc5SGMkNg_C_eoNfjV0elHClP7npHrAtrlJu-esNyTUQaR6UcJBVYilPr8-T4BqWlIp4TOpKavA",
  kid: "1569964308879-5y6waestOxDDM-Ia4_2u1Q",
  kty: "oct",
  scope: "https://identity.mozilla.com/apps/oldsync",
};

const MOCK_ACCESS_TOKEN_RESPONSE = {
  token: "e3c5caf17f27a0d9e351926a928938b3737df43e91d4992a5a5fca9a7bdef8ba",
  key: MOCK_SCOPED_KEY,
  scope: "https://identity.mozilla.com/apps/oldsync",
};

var globalIdentityConfig = makeIdentityConfig();
var globalBrowseridManager = new BrowserIDManager();
configureFxAccountIdentity(globalBrowseridManager, globalIdentityConfig);

/**
 * Mock client clock and skew vs server in FxAccounts signed-in user module and
 * API client.  browserid_identity.js queries these values to construct HAWK
 * headers.  We will use this to test clock skew compensation in these headers
 * below.
 */
var MockFxAccountsClient = function() {
  FxAccountsClient.apply(this);
};
MockFxAccountsClient.prototype = {
  __proto__: FxAccountsClient.prototype,
  accountStatus() {
    return Promise.resolve(true);
  },
};

add_test(function test_initial_state() {
  _("Verify initial state");
  Assert.ok(!globalBrowseridManager._token);
  Assert.ok(!globalBrowseridManager._hasValidToken());
  run_next_test();
});

add_task(async function test_initialialize() {
  _("Verify start after fetching token");
  await globalBrowseridManager._ensureValidToken();
  Assert.ok(!!globalBrowseridManager._token);
  Assert.ok(globalBrowseridManager._hasValidToken());
});

add_task(async function test_initialialize_via_oauth_token() {
  _("Verify start after fetching token using the oauth token flow");
  Services.prefs.setBoolPref("identity.sync.useOAuthForSyncToken", true);
  let browseridManager = new BrowserIDManager();

  let identityConfig = makeIdentityConfig();
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  configureFxAccountIdentity(browseridManager, identityConfig, fxaInternal);
  browseridManager._fxaService._internal.initialize();
  browseridManager._fxaService.getAccessToken = () =>
    Promise.resolve(MOCK_ACCESS_TOKEN_RESPONSE);

  await browseridManager._ensureValidToken();
  Assert.ok(!!browseridManager._token);
  Assert.ok(browseridManager._hasValidToken());
  Services.prefs.setBoolPref("identity.sync.useOAuthForSyncToken", false);
});

add_task(async function test_refreshOAuthTokenOn401() {
  _("Refreshes the FXA OAuth token after a 401.");
  Services.prefs.setBoolPref("identity.sync.useOAuthForSyncToken", true);
  let getTokenCount = 0;
  let browseridManager = new BrowserIDManager();
  let identityConfig = makeIdentityConfig();
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  configureFxAccountIdentity(browseridManager, identityConfig, fxaInternal);
  browseridManager._fxaService._internal.initialize();
  browseridManager._fxaService.getAccessToken = () => {
    ++getTokenCount;
    return Promise.resolve(MOCK_ACCESS_TOKEN_RESPONSE);
  };

  let didReturn401 = false;
  let didReturn200 = false;
  let mockTSC = mockTokenServer(() => {
    if (getTokenCount <= 1) {
      didReturn401 = true;
      return {
        status: 401,
        headers: { "content-type": "application/json" },
        body: JSON.stringify({}),
      };
    }
    didReturn200 = true;
    return {
      status: 200,
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        id: "id",
        key: "key",
        api_endpoint: "http://example.com/",
        uid: "uid",
        duration: 300,
      }),
    };
  });

  browseridManager._tokenServerClient = mockTSC;

  await browseridManager._ensureValidToken();

  Assert.equal(getTokenCount, 2);
  Assert.ok(didReturn401);
  Assert.ok(didReturn200);
  Assert.ok(browseridManager._token);
  Assert.ok(browseridManager._hasValidToken());
  Services.prefs.setBoolPref("identity.sync.useOAuthForSyncToken", false);
});

add_task(async function test_initialializeWithAuthErrorAndDeletedAccount() {
  _("Verify sync state with auth error + account deleted");

  var identityConfig = makeIdentityConfig();
  var browseridManager = new BrowserIDManager();

  // Use the real `_getAssertion` method that calls
  // `mockFxAClient.signCertificate`.
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  delete fxaInternal._getAssertion;

  configureFxAccountIdentity(browseridManager, identityConfig, fxaInternal);
  browseridManager._fxaService._internal.initialize();

  let signCertificateCalled = false;
  let accountStatusCalled = false;
  let sessionStatusCalled = false;

  let AuthErrorMockFxAClient = function() {
    FxAccountsClient.apply(this);
  };
  AuthErrorMockFxAClient.prototype = {
    __proto__: FxAccountsClient.prototype,
    signCertificate() {
      signCertificateCalled = true;
      return Promise.reject({
        code: 401,
        errno: ERRNO_INVALID_AUTH_TOKEN,
      });
    },
    accountStatus() {
      accountStatusCalled = true;
      return Promise.resolve(false);
    },
    sessionStatus() {
      sessionStatusCalled = true;
      return Promise.resolve(false);
    },
  };

  let mockFxAClient = new AuthErrorMockFxAClient();
  browseridManager._fxaService._internal._fxAccountsClient = mockFxAClient;

  await Assert.rejects(
    browseridManager._ensureValidToken(),
    AuthenticationError,
    "should reject due to an auth error"
  );

  Assert.ok(signCertificateCalled);
  Assert.ok(sessionStatusCalled);
  Assert.ok(accountStatusCalled);
  Assert.ok(!browseridManager._token);
  Assert.ok(!browseridManager._hasValidToken());
});

add_task(async function test_getResourceAuthenticator() {
  _(
    "BrowserIDManager supplies a Resource Authenticator callback which returns a Hawk header."
  );
  configureFxAccountIdentity(globalBrowseridManager);
  let authenticator = globalBrowseridManager.getResourceAuthenticator();
  Assert.ok(!!authenticator);
  let req = {
    uri: CommonUtils.makeURI("https://example.net/somewhere/over/the/rainbow"),
    method: "GET",
  };
  let output = await authenticator(req, "GET");
  Assert.ok("headers" in output);
  Assert.ok("authorization" in output.headers);
  Assert.ok(output.headers.authorization.startsWith("Hawk"));
  _("Expected internal state after successful call.");
  Assert.equal(
    globalBrowseridManager._token.uid,
    globalIdentityConfig.fxaccount.token.uid
  );
});

add_task(async function test_resourceAuthenticatorSkew() {
  _(
    "BrowserIDManager Resource Authenticator compensates for clock skew in Hawk header."
  );

  // Clock is skewed 12 hours into the future
  // We pick a date in the past so we don't risk concealing bugs in code that
  // uses new Date() instead of our given date.
  let now =
    new Date("Fri Apr 09 2004 00:00:00 GMT-0700").valueOf() + 12 * HOUR_MS;
  let browseridManager = new BrowserIDManager();
  let hawkClient = new HawkClient("https://example.net/v1", "/foo");

  // mock fxa hawk client skew
  hawkClient.now = function() {
    dump("mocked client now: " + now + "\n");
    return now;
  };
  // Imagine there's already been one fxa request and the hawk client has
  // already detected skew vs the fxa auth server.
  let localtimeOffsetMsec = -1 * 12 * HOUR_MS;
  hawkClient._localtimeOffsetMsec = localtimeOffsetMsec;

  let fxaClient = new MockFxAccountsClient();
  fxaClient.hawk = hawkClient;

  // Sanity check
  Assert.equal(hawkClient.now(), now);
  Assert.equal(hawkClient.localtimeOffsetMsec, localtimeOffsetMsec);

  // Properly picked up by the client
  Assert.equal(fxaClient.now(), now);
  Assert.equal(fxaClient.localtimeOffsetMsec, localtimeOffsetMsec);

  let identityConfig = makeIdentityConfig();
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  fxaInternal._now_is = now;
  fxaInternal.fxAccountsClient = fxaClient;

  // Mocks within mocks...
  configureFxAccountIdentity(
    browseridManager,
    globalIdentityConfig,
    fxaInternal
  );

  Assert.equal(browseridManager._fxaService._internal.now(), now);
  Assert.equal(
    browseridManager._fxaService._internal.localtimeOffsetMsec,
    localtimeOffsetMsec
  );

  Assert.equal(browseridManager._fxaService._internal.now(), now);
  Assert.equal(
    browseridManager._fxaService._internal.localtimeOffsetMsec,
    localtimeOffsetMsec
  );

  let request = new Resource("https://example.net/i/like/pie/");
  let authenticator = browseridManager.getResourceAuthenticator();
  let output = await authenticator(request, "GET");
  dump("output" + JSON.stringify(output));
  let authHeader = output.headers.authorization;
  Assert.ok(authHeader.startsWith("Hawk"));

  // Skew correction is applied in the header and we're within the two-minute
  // window.
  Assert.equal(getTimestamp(authHeader), now - 12 * HOUR_MS);
  Assert.ok(getTimestampDelta(authHeader, now) - 12 * HOUR_MS < 2 * MINUTE_MS);
});

add_task(async function test_RESTResourceAuthenticatorSkew() {
  _(
    "BrowserIDManager REST Resource Authenticator compensates for clock skew in Hawk header."
  );

  // Clock is skewed 12 hours into the future from our arbitary date
  let now =
    new Date("Fri Apr 09 2004 00:00:00 GMT-0700").valueOf() + 12 * HOUR_MS;
  let browseridManager = new BrowserIDManager();
  let hawkClient = new HawkClient("https://example.net/v1", "/foo");

  // mock fxa hawk client skew
  hawkClient.now = function() {
    return now;
  };
  // Imagine there's already been one fxa request and the hawk client has
  // already detected skew vs the fxa auth server.
  hawkClient._localtimeOffsetMsec = -1 * 12 * HOUR_MS;

  let fxaClient = new MockFxAccountsClient();
  fxaClient.hawk = hawkClient;

  let identityConfig = makeIdentityConfig();
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  fxaInternal._now_is = now;
  fxaInternal.fxAccountsClient = fxaClient;

  configureFxAccountIdentity(
    browseridManager,
    globalIdentityConfig,
    fxaInternal
  );

  Assert.equal(browseridManager._fxaService._internal.now(), now);

  let request = new Resource("https://example.net/i/like/pie/");
  let authenticator = browseridManager.getResourceAuthenticator();
  let output = await authenticator(request, "GET");
  dump("output" + JSON.stringify(output));
  let authHeader = output.headers.authorization;
  Assert.ok(authHeader.startsWith("Hawk"));

  // Skew correction is applied in the header and we're within the two-minute
  // window.
  Assert.equal(getTimestamp(authHeader), now - 12 * HOUR_MS);
  Assert.ok(getTimestampDelta(authHeader, now) - 12 * HOUR_MS < 2 * MINUTE_MS);
});

add_task(async function test_ensureLoggedIn() {
  configureFxAccountIdentity(globalBrowseridManager);
  await globalBrowseridManager._ensureValidToken();
  Assert.equal(Status.login, LOGIN_SUCCEEDED, "original initialize worked");
  Assert.ok(globalBrowseridManager._token);

  // arrange for no logged in user.
  let fxa = globalBrowseridManager._fxaService;
  let signedInUser =
    fxa._internal.currentAccountState.storageManager.accountData;
  fxa._internal.currentAccountState.storageManager.accountData = null;
  await Assert.rejects(
    globalBrowseridManager._ensureValidToken(true),
    /no user is logged in/,
    "expecting rejection due to no user"
  );
  // Restore the logged in user to what it was.
  fxa._internal.currentAccountState.storageManager.accountData = signedInUser;
  Status.login = LOGIN_FAILED_LOGIN_REJECTED;
  await globalBrowseridManager._ensureValidToken(true);
  Assert.equal(Status.login, LOGIN_SUCCEEDED, "final ensureLoggedIn worked");
});

add_task(async function test_syncState() {
  // Avoid polling for an unverified user.
  let identityConfig = makeIdentityConfig();
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  fxaInternal.startVerifiedCheck = () => {};
  configureFxAccountIdentity(
    globalBrowseridManager,
    globalIdentityConfig,
    fxaInternal
  );

  // arrange for no logged in user.
  let fxa = globalBrowseridManager._fxaService;
  let signedInUser =
    fxa._internal.currentAccountState.storageManager.accountData;
  fxa._internal.currentAccountState.storageManager.accountData = null;
  await Assert.rejects(
    globalBrowseridManager._ensureValidToken(true),
    /no user is logged in/,
    "expecting rejection due to no user"
  );
  // Restore to an unverified user.
  Services.prefs.setStringPref("services.sync.username", signedInUser.email);
  signedInUser.verified = false;
  fxa._internal.currentAccountState.storageManager.accountData = signedInUser;
  Status.login = LOGIN_FAILED_LOGIN_REJECTED;
  // The browserid_identity observers are async, so call them directly.
  await globalBrowseridManager.observe(null, ONLOGIN_NOTIFICATION, "");
  Assert.equal(
    Status.login,
    LOGIN_FAILED_LOGIN_REJECTED,
    "should not have changed the login state for an unverified user"
  );

  // now pretend the user because verified.
  signedInUser.verified = true;
  await globalBrowseridManager.observe(null, ONVERIFIED_NOTIFICATION, "");
  Assert.equal(
    Status.login,
    LOGIN_SUCCEEDED,
    "should have changed the login state to success"
  );
});

add_task(async function test_tokenExpiration() {
  _("BrowserIDManager notices token expiration:");
  let bimExp = new BrowserIDManager();
  configureFxAccountIdentity(bimExp, globalIdentityConfig);

  let authenticator = bimExp.getResourceAuthenticator();
  Assert.ok(!!authenticator);
  let req = {
    uri: CommonUtils.makeURI("https://example.net/somewhere/over/the/rainbow"),
    method: "GET",
  };
  await authenticator(req, "GET");

  // Mock the clock.
  _("Forcing the token to expire ...");
  Object.defineProperty(bimExp, "_now", {
    value: function customNow() {
      return Date.now() + 3000001;
    },
    writable: true,
  });
  Assert.ok(bimExp._token.expiration < bimExp._now());
  _("... means BrowserIDManager knows to re-fetch it on the next call.");
  Assert.ok(!bimExp._hasValidToken());
});

add_task(async function test_getTokenErrors() {
  _("BrowserIDManager correctly handles various failures to get a token.");

  _("Arrange for a 401 - Sync should reflect an auth error.");
  initializeIdentityWithTokenServerResponse({
    status: 401,
    headers: { "content-type": "application/json" },
    body: JSON.stringify({}),
  });
  let browseridManager = Service.identity;

  await Assert.rejects(
    browseridManager._ensureValidToken(),
    AuthenticationError,
    "should reject due to 401"
  );
  Assert.equal(Status.login, LOGIN_FAILED_LOGIN_REJECTED, "login was rejected");

  // XXX - other interesting responses to return?

  // And for good measure, some totally "unexpected" errors - we generally
  // assume these problems are going to magically go away at some point.
  _(
    "Arrange for an empty body with a 200 response - should reflect a network error."
  );
  initializeIdentityWithTokenServerResponse({
    status: 200,
    headers: [],
    body: "",
  });
  browseridManager = Service.identity;
  await Assert.rejects(
    browseridManager._ensureValidToken(),
    TokenServerClientServerError,
    "should reject due to non-JSON response"
  );
  Assert.equal(
    Status.login,
    LOGIN_FAILED_NETWORK_ERROR,
    "login state is LOGIN_FAILED_NETWORK_ERROR"
  );
});

add_task(async function test_refreshCertificateOn401() {
  _("BrowserIDManager refreshes the FXA certificate after a 401.");
  var identityConfig = makeIdentityConfig();
  var browseridManager = new BrowserIDManager();
  // Use the real `_getAssertion` method that calls
  // `mockFxAClient.signCertificate`.
  let fxaInternal = makeFxAccountsInternalMock(identityConfig);
  delete fxaInternal._getAssertion;
  configureFxAccountIdentity(browseridManager, identityConfig, fxaInternal);
  browseridManager._fxaService._internal.initialize();

  let getCertCount = 0;

  let CheckSignMockFxAClient = function() {
    FxAccountsClient.apply(this);
  };
  CheckSignMockFxAClient.prototype = {
    __proto__: FxAccountsClient.prototype,
    signCertificate() {
      ++getCertCount;
    },
  };

  let mockFxAClient = new CheckSignMockFxAClient();
  browseridManager._fxaService._internal._fxAccountsClient = mockFxAClient;

  let didReturn401 = false;
  let didReturn200 = false;
  let mockTSC = mockTokenServer(() => {
    if (getCertCount <= 1) {
      didReturn401 = true;
      return {
        status: 401,
        headers: { "content-type": "application/json" },
        body: JSON.stringify({}),
      };
    }
    didReturn200 = true;
    return {
      status: 200,
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        id: "id",
        key: "key",
        api_endpoint: "http://example.com/",
        uid: "uid",
        duration: 300,
      }),
    };
  });

  browseridManager._tokenServerClient = mockTSC;

  await browseridManager._ensureValidToken();

  Assert.equal(getCertCount, 2);
  Assert.ok(didReturn401);
  Assert.ok(didReturn200);
  Assert.ok(browseridManager._token);
  Assert.ok(browseridManager._hasValidToken());
});

add_task(async function test_getTokenErrorWithRetry() {
  _("tokenserver sends an observer notification on various backoff headers.");

  // Set Sync's backoffInterval to zero - after we simulated the backoff header
  // it should reflect the value we sent.
  Status.backoffInterval = 0;
  _("Arrange for a 503 with a Retry-After header.");
  initializeIdentityWithTokenServerResponse({
    status: 503,
    headers: { "content-type": "application/json", "retry-after": "100" },
    body: JSON.stringify({}),
  });
  let browseridManager = Service.identity;

  await Assert.rejects(
    browseridManager._ensureValidToken(),
    TokenServerClientServerError,
    "should reject due to 503"
  );

  // The observer should have fired - check it got the value in the response.
  Assert.equal(Status.login, LOGIN_FAILED_NETWORK_ERROR, "login was rejected");
  // Sync will have the value in ms with some slop - so check it is at least that.
  Assert.ok(Status.backoffInterval >= 100000);

  _("Arrange for a 200 with an X-Backoff header.");
  Status.backoffInterval = 0;
  initializeIdentityWithTokenServerResponse({
    status: 503,
    headers: { "content-type": "application/json", "x-backoff": "200" },
    body: JSON.stringify({}),
  });
  browseridManager = Service.identity;

  await Assert.rejects(
    browseridManager._ensureValidToken(),
    TokenServerClientServerError,
    "should reject due to no token in response"
  );

  // The observer should have fired - check it got the value in the response.
  Assert.ok(Status.backoffInterval >= 200000);
});

add_task(async function test_getKeysErrorWithBackoff() {
  _(
    "Auth server (via hawk) sends an observer notification on backoff headers."
  );

  // Set Sync's backoffInterval to zero - after we simulated the backoff header
  // it should reflect the value we sent.
  Status.backoffInterval = 0;
  _("Arrange for a 503 with a X-Backoff header.");

  let config = makeIdentityConfig();
  // We want no kSync, kXCS, kExtSync or kExtKbHash so we attempt to fetch them.
  delete config.fxaccount.user.kSync;
  delete config.fxaccount.user.kXCS;
  delete config.fxaccount.user.kExtSync;
  delete config.fxaccount.user.kExtKbHash;
  config.fxaccount.user.keyFetchToken = "keyfetchtoken";
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "get");
    Assert.equal(uri, "http://mockedserver:9999/account/keys");
    return {
      status: 503,
      headers: { "content-type": "application/json", "x-backoff": "100" },
      body: "{}",
    };
  });

  let browseridManager = Service.identity;
  await Assert.rejects(
    browseridManager._ensureValidToken(),
    TokenServerClientServerError,
    "should reject due to 503"
  );

  // The observer should have fired - check it got the value in the response.
  Assert.equal(Status.login, LOGIN_FAILED_NETWORK_ERROR, "login was rejected");
  // Sync will have the value in ms with some slop - so check it is at least that.
  Assert.ok(Status.backoffInterval >= 100000);
});

add_task(async function test_getKeysErrorWithRetry() {
  _("Auth server (via hawk) sends an observer notification on retry headers.");

  // Set Sync's backoffInterval to zero - after we simulated the backoff header
  // it should reflect the value we sent.
  Status.backoffInterval = 0;
  _("Arrange for a 503 with a Retry-After header.");

  let config = makeIdentityConfig();
  // We want no kSync, kXCS, kExtSync or kExtKbHash so we attempt to fetch them.
  delete config.fxaccount.user.kSync;
  delete config.fxaccount.user.kXCS;
  delete config.fxaccount.user.kExtSync;
  delete config.fxaccount.user.kExtKbHash;
  config.fxaccount.user.keyFetchToken = "keyfetchtoken";
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "get");
    Assert.equal(uri, "http://mockedserver:9999/account/keys");
    return {
      status: 503,
      headers: { "content-type": "application/json", "retry-after": "100" },
      body: "{}",
    };
  });

  let browseridManager = Service.identity;
  await Assert.rejects(
    browseridManager._ensureValidToken(),
    TokenServerClientServerError,
    "should reject due to 503"
  );

  // The observer should have fired - check it got the value in the response.
  Assert.equal(Status.login, LOGIN_FAILED_NETWORK_ERROR, "login was rejected");
  // Sync will have the value in ms with some slop - so check it is at least that.
  Assert.ok(Status.backoffInterval >= 100000);
});

add_task(async function test_getHAWKErrors() {
  _("BrowserIDManager correctly handles various HAWK failures.");

  _("Arrange for a 401 - Sync should reflect an auth error.");
  let config = makeIdentityConfig();
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "post");
    Assert.equal(uri, "http://mockedserver:9999/certificate/sign?service=sync");
    return {
      status: 401,
      headers: { "content-type": "application/json" },
      body: JSON.stringify({}),
    };
  });
  Assert.equal(Status.login, LOGIN_FAILED_LOGIN_REJECTED, "login was rejected");

  // XXX - other interesting responses to return?

  // And for good measure, some totally "unexpected" errors - we generally
  // assume these problems are going to magically go away at some point.
  _(
    "Arrange for an empty body with a 200 response - should reflect a network error."
  );
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "post");
    Assert.equal(uri, "http://mockedserver:9999/certificate/sign?service=sync");
    return {
      status: 200,
      headers: [],
      body: "",
    };
  });
  Assert.equal(
    Status.login,
    LOGIN_FAILED_NETWORK_ERROR,
    "login state is LOGIN_FAILED_NETWORK_ERROR"
  );
});

add_task(async function test_getGetKeysFailing401() {
  _("BrowserIDManager correctly handles 401 responses fetching keys.");

  _("Arrange for a 401 - Sync should reflect an auth error.");
  let config = makeIdentityConfig();
  // We want no kSync, kXCS, kExtSync or kExtKbHash so we attempt to fetch them.
  delete config.fxaccount.user.kSync;
  delete config.fxaccount.user.kXCS;
  delete config.fxaccount.user.kExtSync;
  delete config.fxaccount.user.kExtKbHash;
  config.fxaccount.user.keyFetchToken = "keyfetchtoken";
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "get");
    Assert.equal(uri, "http://mockedserver:9999/account/keys");
    return {
      status: 401,
      headers: { "content-type": "application/json" },
      body: "{}",
    };
  });
  Assert.equal(Status.login, LOGIN_FAILED_LOGIN_REJECTED, "login was rejected");
});

add_task(async function test_getGetKeysFailing503() {
  _("BrowserIDManager correctly handles 5XX responses fetching keys.");

  _("Arrange for a 503 - Sync should reflect a network error.");
  let config = makeIdentityConfig();
  // We want no kSync, kXCS, kExtSync or kExtKbHash so we attempt to fetch them.
  delete config.fxaccount.user.kSync;
  delete config.fxaccount.user.kXCS;
  delete config.fxaccount.user.kExtSync;
  delete config.fxaccount.user.kExtKbHash;
  config.fxaccount.user.keyFetchToken = "keyfetchtoken";
  await initializeIdentityWithHAWKResponseFactory(config, function(
    method,
    data,
    uri
  ) {
    Assert.equal(method, "get");
    Assert.equal(uri, "http://mockedserver:9999/account/keys");
    return {
      status: 503,
      headers: { "content-type": "application/json" },
      body: "{}",
    };
  });
  Assert.equal(
    Status.login,
    LOGIN_FAILED_NETWORK_ERROR,
    "state reflects network error"
  );
});

add_task(async function test_getKeysMissing() {
  _(
    "BrowserIDManager correctly handles getKeys succeeding but not returning keys."
  );

  let browseridManager = new BrowserIDManager();
  let identityConfig = makeIdentityConfig();
  // our mock identity config already has kSync, kXCS, kExtSync and kExtKbHash - remove them or we never
  // try and fetch them.
  delete identityConfig.fxaccount.user.kSync;
  delete identityConfig.fxaccount.user.kXCS;
  delete identityConfig.fxaccount.user.kExtSync;
  delete identityConfig.fxaccount.user.kExtKbHash;
  identityConfig.fxaccount.user.keyFetchToken = "keyFetchToken";

  configureFxAccountIdentity(browseridManager, identityConfig);

  // Mock a fxAccounts object
  let fxa = new FxAccounts({
    fxAccountsClient: new MockFxAccountsClient(),
    newAccountState(credentials) {
      // We only expect this to be called with null indicating the (mock)
      // storage should be read.
      if (credentials) {
        throw new Error("Not expecting to have credentials passed");
      }
      let storageManager = new MockFxaStorageManager();
      storageManager.initialize(identityConfig.fxaccount.user);
      return new AccountState(storageManager);
    },
    // And the keys object with a mock that returns no keys.
    keys: {
      fetchAndUnwrapKeys() {
        return Promise.resolve({});
      },
    },
  });

  // Add a mock to the currentAccountState object.
  fxa._internal.currentAccountState.getCertificate = function(
    data,
    keyPair,
    mustBeValidUntil
  ) {
    this.cert = {
      validUntil: fxa._internal.now() + CERT_LIFETIME,
      cert: "certificate",
    };
    return Promise.resolve(this.cert.cert);
  };

  browseridManager._fxaService = fxa;

  await Assert.rejects(
    browseridManager._ensureValidToken(),
    /user data missing: kSync, kXCS, kExtSync, kExtKbHash/
  );
});

add_task(async function test_signedInUserMissing() {
  _(
    "BrowserIDManager detects getSignedInUser returning incomplete account data"
  );

  let browseridManager = new BrowserIDManager();
  // Delete stored keys and the key fetch token.
  delete globalIdentityConfig.fxaccount.user.kSync;
  delete globalIdentityConfig.fxaccount.user.kXCS;
  delete globalIdentityConfig.fxaccount.user.kExtSync;
  delete globalIdentityConfig.fxaccount.user.kExtKbHash;
  delete globalIdentityConfig.fxaccount.user.keyFetchToken;

  configureFxAccountIdentity(browseridManager, globalIdentityConfig);

  let fxa = new FxAccounts({
    fetchAndUnwrapKeys() {
      return Promise.resolve({});
    },
    fxAccountsClient: new MockFxAccountsClient(),
    newAccountState(credentials) {
      // We only expect this to be called with null indicating the (mock)
      // storage should be read.
      if (credentials) {
        throw new Error("Not expecting to have credentials passed");
      }
      let storageManager = new MockFxaStorageManager();
      storageManager.initialize(globalIdentityConfig.fxaccount.user);
      return new AccountState(storageManager);
    },
  });

  browseridManager._fxaService = fxa;

  let status = await browseridManager.unlockAndVerifyAuthState();
  Assert.equal(status, LOGIN_FAILED_LOGIN_REJECTED);
});

// End of tests
// Utility functions follow

// Create a new browserid_identity object and initialize it with a
// hawk mock that simulates HTTP responses.
// The callback function will be called each time the mocked hawk server wants
// to make a request.  The result of the callback should be the mock response
// object that will be returned to hawk.
// A token server mock will be used that doesn't hit a server, so we move
// directly to a hawk request.
async function initializeIdentityWithHAWKResponseFactory(
  config,
  cbGetResponse
) {
  // A mock request object.
  function MockRESTRequest(uri, credentials, extra) {
    this._uri = uri;
    this._credentials = credentials;
    this._extra = extra;
  }
  MockRESTRequest.prototype = {
    setHeader() {},
    async post(data) {
      this.response = cbGetResponse(
        "post",
        data,
        this._uri,
        this._credentials,
        this._extra
      );
      return this.response;
    },
    async get() {
      // Skip /status requests (browserid_identity checks if the account still
      // exists after an auth error)
      if (this._uri.startsWith("http://mockedserver:9999/account/status")) {
        this.response = {
          status: 200,
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ exists: true }),
        };
      } else {
        this.response = cbGetResponse(
          "get",
          null,
          this._uri,
          this._credentials,
          this._extra
        );
      }
      return this.response;
    },
  };

  // The hawk client.
  function MockedHawkClient() {}
  MockedHawkClient.prototype = new HawkClient("http://mockedserver:9999");
  MockedHawkClient.prototype.constructor = MockedHawkClient;
  MockedHawkClient.prototype.newHAWKAuthenticatedRESTRequest = function(
    uri,
    credentials,
    extra
  ) {
    return new MockRESTRequest(uri, credentials, extra);
  };
  // Arrange for the same observerPrefix as FxAccountsClient uses
  MockedHawkClient.prototype.observerPrefix = "FxA:hawk";

  // tie it all together - configureFxAccountIdentity isn't useful here :(
  let fxaClient = new MockFxAccountsClient();
  fxaClient.hawk = new MockedHawkClient();
  let internal = {
    fxAccountsClient: fxaClient,
    newAccountState(credentials) {
      // We only expect this to be called with null indicating the (mock)
      // storage should be read.
      if (credentials) {
        throw new Error("Not expecting to have credentials passed");
      }
      let storageManager = new MockFxaStorageManager();
      storageManager.initialize(config.fxaccount.user);
      return new AccountState(storageManager);
    },
  };
  let fxa = new FxAccounts(internal);

  globalBrowseridManager._fxaService = fxa;
  await Assert.rejects(
    globalBrowseridManager._ensureValidToken(true),
    // TODO: Ideally this should have a specific check for an error.
    () => true,
    "expecting rejection due to hawk error"
  );
}

function getTimestamp(hawkAuthHeader) {
  return parseInt(/ts="(\d+)"/.exec(hawkAuthHeader)[1], 10) * SECOND_MS;
}

function getTimestampDelta(hawkAuthHeader, now = Date.now()) {
  return Math.abs(getTimestamp(hawkAuthHeader) - now);
}

function mockTokenServer(func) {
  let requestLog = Log.repository.getLogger("testing.mock-rest");
  if (!requestLog.appenders.length) {
    // might as well see what it says :)
    requestLog.addAppender(new Log.DumpAppender());
    requestLog.level = Log.Level.Trace;
  }
  function MockRESTRequest(url) {}
  MockRESTRequest.prototype = {
    _log: requestLog,
    setHeader() {},
    async get() {
      this.response = func();
      return this.response;
    },
  };
  // The mocked TokenServer client which will get the response.
  function MockTSC() {}
  MockTSC.prototype = new TokenServerClient();
  MockTSC.prototype.constructor = MockTSC;
  MockTSC.prototype.newRESTRequest = function(url) {
    return new MockRESTRequest(url);
  };
  // Arrange for the same observerPrefix as browserid_identity uses.
  MockTSC.prototype.observerPrefix = "weave:service";
  return new MockTSC();
}
