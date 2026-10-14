/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Tests that --createprofile fails with NS_ERROR_NOT_AVAILABLE when
 * profiles.ini is unreadable.
 */

let hash = xreDirProvider.getInstallHash();

let profileData = {
  options: {
    startWithLastProfile: true,
  },
  profiles: [
    {
      name: DEDICATED_NAME,
      path: "Path1",
      isRelative: true,
      storeID: null,
      default: false,
    },
  ],
  installs: {
    [hash]: {
      default: "Path1",
    },
  },
};

function replaceProfilesIniWithDirectory() {
  let target = gDataHome.clone();
  target.append("profiles.ini");
  target.remove(false);
  target.create(Ci.nsIFile.DIRECTORY_TYPE, 0o755);
}

function removeProfilesIniDirectory() {
  let target = gDataHome.clone();
  target.append("profiles.ini");
  target.remove(true);
}

add_task(async () => {
  writeProfilesIni(profileData);
  replaceProfilesIniWithDirectory();

  registerCleanupFunction(removeProfilesIniDirectory);

  try {
    selectStartupProfile(["--createprofile", "newprofile"]);
    Assert.ok(false, "Should have failed to select a profile.");
  } catch (e) {
    Assert.equal(
      e.result,
      Cr.NS_ERROR_NOT_AVAILABLE,
      "--createprofile should fail with NS_ERROR_NOT_AVAILABLE."
    );
  }

  let service = getProfileService();

  // Flush should be blocked.
  Assert.throws(
    () => service.flush(),
    e => e.result == Cr.NS_ERROR_NOT_AVAILABLE,
    "Flush should fail when profiles.ini could not be read."
  );

  // asyncFlush should also be blocked.
  Assert.throws(
    () => service.asyncFlush(),
    e => e.result == Cr.NS_ERROR_NOT_AVAILABLE,
    "asyncFlush should fail when profiles.ini could not be read."
  );

  // profiles.ini should still be a directory, not overwritten.
  let target = gDataHome.clone();
  target.append("profiles.ini");
  Assert.ok(target.exists(), "profiles.ini should still exist.");
  Assert.ok(target.isDirectory(), "profiles.ini should still be a directory.");
});
