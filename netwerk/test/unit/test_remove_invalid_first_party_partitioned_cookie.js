/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

// The test ensure we remove first-party partitioned cookies that don't have
// partitioned attribute.

add_task(async function run_test() {
  // Set up a profile.
  let profile = do_get_profile();

  // Start the cookieservice, to force creation of a database.
  Services.cookies.sessionCookies;

  // Close the profile.
  await promise_close_profile();

  // Remove the cookie file in order to create another database file.
  do_get_cookie_file(profile).remove(false);

  // Create a schema 14 database.
  let schema14db = new CookieDatabaseConnection(
    do_get_cookie_file(profile),
    15
  );

  let now = Math.round(Date.now() / 1000);

  // Create an invalid first-party partitioned cookie.
  let invalidFPCookie = new Cookie(
    "invalid",
    "bad",
    "example.com",
    "/",
    now + 34560000,
    now,
    now,
    false, // isSession
    true, // isSecure
    false, // isHttpOnly
    false, // isBrowserElement
    { partitionKey: "(https,example.com)" },
    Ci.nsICookie.SAMESITE_UNSET,
    Ci.nsICookie.SCHEME_UNSET,
    false // isPartitioned
  );
  schema14db.insertCookie(invalidFPCookie);

  // Create a valid first-party partitioned cookie(CHIPS).
  let valid1stCHIPS = new Cookie(
    "valid1stCHIPS",
    "good",
    "example.com",
    "/",
    now + 34560000,
    now,
    now,
    false, // isSession
    true, // isSecure
    false, // isHttpOnly
    false, // isBrowserElement
    { partitionKey: "(https,example.com)" },
    Ci.nsICookie.SAMESITE_UNSET,
    Ci.nsICookie.SCHEME_UNSET,
    true // isPartitioned
  );
  schema14db.insertCookie(valid1stCHIPS);

  // Create a valid unpartitioned cookie.
  let unpartitionedCookie = new Cookie(
    "valid",
    "good",
    "example.com",
    "/",
    now + 34560000,
    now,
    now,
    false, // isSession
    true, // isSecure
    false, // isHttpOnly
    false, // isBrowserElement
    {},
    Ci.nsICookie.SAMESITE_UNSET,
    Ci.nsICookie.SCHEME_UNSET,
    false // isPartitioned
  );
  schema14db.insertCookie(unpartitionedCookie);

  // Create valid third-party partitioned TCP cookie.
  let valid3rdTCPCookie = new Cookie(
    "valid3rdTCP",
    "good",
    "example.com",
    "/",
    now + 34560000,
    now,
    now,
    false, // isSession
    true, // isSecure
    false, // isHttpOnly
    false, // isBrowserElement
    { partitionKey: "(https,example.org)" },
    Ci.nsICookie.SAMESITE_UNSET,
    Ci.nsICookie.SCHEME_UNSET,
    false // isPartitioned
  );
  schema14db.insertCookie(valid3rdTCPCookie);

  // Create valid third-party partitioned CHIPS cookie.
  let valid3rdCHIPSCookie = new Cookie(
    "valid3rdCHIPS",
    "good",
    "example.com",
    "/",
    now + 34560000,
    now,
    now,
    false, // isSession
    true, // isSecure
    false, // isHttpOnly
    false, // isBrowserElement
    { partitionKey: "(https,example.org)" },
    Ci.nsICookie.SAMESITE_UNSET,
    Ci.nsICookie.SCHEME_UNSET,
    true // isPartitioned
  );
  schema14db.insertCookie(valid3rdCHIPSCookie);

  schema14db.close();
  schema14db = null;

  // Check if we have the right testing entries
  {
    const dbConnection = Services.storage.openDatabase(
      do_get_cookie_file(profile)
    );
    const stmt = dbConnection.createStatement(
      "SELECT count(name) FROM moz_cookies WHERE host = 'example.com';"
    );
    const success = stmt.executeStep();
    Assert.ok(success);

    const count = stmt.getInt32(0);
    Assert.equal(count, 5);
    stmt.finalize();
    dbConnection.close();
  }

  // Reload profile. Reading the database drops the invalid cookies, but the
  // removals are written out in batches, so wait for them to land before
  // inspecting the file.
  const invalidCookiesRemoved = new _promise_observer("cookie-saved-on-disk");
  await promise_load_profile();

  // Check the number of unpartitioned cookies is correct, and we only have
  // good cookies.
  let cookies = Services.cookies.getCookiesFromHost("example.com", {});
  Assert.equal(cookies.length, 1);
  for (const cookie of cookies) {
    Assert.equal(cookie.value, "good");
  }

  // Check the number of first-party partitioned cookies is correct, and we only
  // have good cookies.
  cookies = Services.cookies.getCookiesFromHost("example.com", {
    partitionKey: "(https,example.com)",
  });
  Assert.equal(cookies.length, 1);
  for (const cookie of cookies) {
    Assert.equal(cookie.value, "good");
  }

  // Check the number of third-party partitioned cookies is correct, and we only
  // have good cookies.
  cookies = Services.cookies.getCookiesFromHost("example.com", {
    partitionKey: "(https,example.org)",
  });
  Assert.equal(cookies.length, 2);
  for (const cookie of cookies) {
    Assert.equal(cookie.value, "good");
  }

  // Ensure the invalid cookies is gone in the DB.
  await invalidCookiesRemoved;
  {
    const dbConnection = Services.storage.openDatabase(
      do_get_cookie_file(profile)
    );
    const stmt = dbConnection.createStatement(
      "SELECT count(name) FROM moz_cookies WHERE value = 'bad';"
    );
    const success = stmt.executeStep();
    Assert.ok(success);

    const count = stmt.getInt32(0);
    Assert.equal(count, 0);
    stmt.finalize();
    dbConnection.close();
  }

  // Cleanup
  Services.cookies.removeAll();
  do_close_profile();
});
