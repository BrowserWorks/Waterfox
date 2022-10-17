/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sw=2 ts=2 sts=2 et */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";
/*
 * Imports from a Waterfox profile in a lossy manner in order to clean up a
 * user's profile.  Data is only migrated where the benefits outweigh the
 * potential problems caused by importing undesired/invalid configurations
 * from the source profile.
 */

const { MigrationUtils, MigratorPrototype } = ChromeUtils.import(
  "resource:///modules/MigrationUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "PlacesBackups",
  "resource://gre/modules/PlacesBackups.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "SessionMigration",
  "resource:///modules/sessionstore/SessionMigration.jsm"
);
ChromeUtils.defineModuleGetter(this, "OS", "resource://gre/modules/osfile.jsm");

function SelectedDirProfileMigrator() {
  this.wrappedJSObject = this; // for testing...
}

SelectedDirProfileMigrator.prototype = Object.create(MigratorPrototype);

SelectedDirProfileMigrator.prototype._getFileObject = function(dir, fileName) {
  let file = dir.clone();
  file.append(fileName);

  // File resources are monolithic.  We don't make partial copies since
  // they are not expected to work alone. Return null to avoid trying to
  // copy non-existing files.
  return file.exists() ? file : null;
};

SelectedDirProfileMigrator.prototype.getResources = function(aProfile) {
  let sourceProfileDir;
  if (aProfile.rootDir) {
    sourceProfileDir = aProfile.rootDir;
  } else {
    // if the selected profile doesn't have a rootDir we have a bigger problem
    return null;
  }

  if (
    !sourceProfileDir ||
    !sourceProfileDir.exists() ||
    !sourceProfileDir.isReadable()
  ) {
    return null;
  }

  // try to migrate to default if set, if not migrate to current
  let profile = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
    Ci.nsIToolkitProfileService
  ).defaultProfile;

  if (!profile) {
    profile = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
      Ci.nsIToolkitProfileService
    ).currentProfile;
  }

  if (!profile) {
    // no profile in use, nowhere to migrate data
    return null;
  }

  let currentProfileDir = profile.rootDir;

  // Surely data cannot be imported from the current profile.
  if (sourceProfileDir.equals(currentProfileDir)) {
    return null;
  }

  return this._getResourcesInternal(sourceProfileDir, currentProfileDir);
};

SelectedDirProfileMigrator.prototype.getLastUsedDate = function() {
  // We always pretend we're really old, so that we don't mess
  // up the determination of which browser is the most 'recent'
  // to import from.
  return Promise.resolve(new Date(0));
};

SelectedDirProfileMigrator.prototype._getResourcesInternal = function(
  sourceProfileDir,
  currentProfileDir
) {
  let getFileResource = (aMigrationType, aFileNames) => {
    let files = [];
    for (let fileName of aFileNames) {
      let file = this._getFileObject(sourceProfileDir, fileName);
      if (file) {
        files.push(file);
      }
    }
    if (!files.length) {
      return null;
    }
    return {
      type: aMigrationType,
      migrate(aCallback) {
        try {
          for (let file of files) {
            file.copyTo(currentProfileDir, "");
          }
          aCallback(true);
        } catch (ex) {
          aCallback(false);
        }
      },
    };
  };

  function savePrefs() {
    // If we've used the pref service to write prefs for the new profile, it's too
    // early in startup for the service to have a profile directory, so we have to
    // manually tell it where to save the prefs file.
    let newPrefsFile = currentProfileDir.clone();
    newPrefsFile.append("prefs.js");
    Services.prefs.savePrefFile(newPrefsFile);
  }

  let types = MigrationUtils.resourceTypes;

  if (!this._getFileObject(sourceProfileDir, "places.sqlite")) {
    places = getFileResource(types.HISTORY, [
      "places.sqlite",
      "places.sqlite-wal",
    ]);
  }
  let favicons = getFileResource(types.HISTORY, [
    "favicons.sqlite",
    "favicons.sqlite-wal",
  ]);
  let cookies = getFileResource(types.COOKIES, [
    "cookies.sqlite",
    "cookies.sqlite-wal",
  ]);
  let passwords = getFileResource(types.PASSWORDS, [
    "signons.sqlite",
    "logins.json",
    "key3.db",
    "key4.db",
  ]);
  let formData = getFileResource(types.FORMDATA, [
    "formhistory.sqlite",
    "autofill-profiles.json",
  ]);

  let bookmarks;
  let places;
  // don't try to import if places.sqlite doesn't exist
  if (this._getFileObject(sourceProfileDir, "places.sqlite")) {
    places = {
      name: "history",
      type: types.HISTORY,
      migrate: aCallback => {
        MigrationUtils.migrateFirefoxStyleHistory(aCallback, sourceProfileDir);
      },
    };

    bookmarks = {
      name: "bookmarks", // name is used only by tests.
      type: types.BOOKMARKS,
      migrate: aCallback => {
        MigrationUtils.migrateFirefoxStyleBookmarks(
          aCallback,
          sourceProfileDir,
          currentProfileDir
        );
      },
    };
  } else {
    places = getFileResource(types.HISTORY, ["places.sqlite"]);
  }

  let bookmarksBackups = getFileResource(types.OTHERDATA, [
    PlacesBackups.profileRelativeFolderPath,
  ]);
  let dictionary = getFileResource(types.OTHERDATA, ["persdict.dat"]);

  let session;
  let env = Cc["@mozilla.org/process/environment;1"].getService(
    Ci.nsIEnvironment
  );
  if (env.get("MOZ_RESET_PROFILE_MIGRATE_SESSION")) {
    // We only want to restore the previous firefox session if the profile refresh was
    // triggered by user. The MOZ_RESET_PROFILE_MIGRATE_SESSION would be set when a user-triggered
    // profile refresh happened in nsAppRunner.cpp. Hence, we detect the MOZ_RESET_PROFILE_MIGRATE_SESSION
    // to see if session data migration is required.
    env.set("MOZ_RESET_PROFILE_MIGRATE_SESSION", "");
    let sessionCheckpoints = this._getFileObject(
      sourceProfileDir,
      "sessionCheckpoints.json"
    );
    let sessionFile = this._getFileObject(
      sourceProfileDir,
      "sessionstore.jsonlz4"
    );
    if (sessionFile) {
      session = {
        type: types.SESSION,
        migrate(aCallback) {
          sessionCheckpoints.copyTo(
            currentProfileDir,
            "sessionCheckpoints.json"
          );
          let newSessionFile = currentProfileDir.clone();
          newSessionFile.append("sessionstore.jsonlz4");
          let migrationPromise = SessionMigration.migrate(
            sessionFile.path,
            newSessionFile.path
          );
          migrationPromise.then(
            function() {
              let buildID = Services.appinfo.platformBuildID;
              let mstone = Services.appinfo.platformVersion;
              // Force the browser to one-off resume the session that we give it:
              Services.prefs.setBoolPref(
                "browser.sessionstore.resume_session_once",
                true
              );
              // Reset the homepage_override prefs so that the browser doesn't override our
              // session with the "what's new" page:
              Services.prefs.setCharPref(
                "browser.startup.homepage_override.mstone",
                mstone
              );
              Services.prefs.setCharPref(
                "browser.startup.homepage_override.buildID",
                buildID
              );
              savePrefs();
              aCallback(true);
            },
            function() {
              aCallback(false);
            }
          );
        },
      };
    }
  }

  // Sync/FxA related data
  let sync = {
    name: "sync", // name is used only by tests.
    type: types.OTHERDATA,
    migrate: async aCallback => {
      // Try and parse a signedInUser.json file from the source directory and
      // if we can, copy it to the new profile and set sync's username pref
      // (which acts as a de-facto flag to indicate if sync is configured)
      try {
        let oldPath = OS.Path.join(sourceProfileDir.path, "signedInUser.json");
        let exists = await OS.File.exists(oldPath);
        if (exists) {
          let raw = await OS.File.read(oldPath, { encoding: "utf-8" });
          let data = JSON.parse(raw);
          if (data && data.accountData && data.accountData.email) {
            let username = data.accountData.email;
            // copy the file itself.
            await OS.File.copy(
              oldPath,
              OS.Path.join(currentProfileDir.path, "signedInUser.json")
            );
            // Now we need to know whether Sync is actually configured for this
            // user. The only way we know is by looking at the prefs file from
            // the old profile. We avoid trying to do a full parse of the prefs
            // file and even avoid parsing the single string value we care
            // about.
            let prefsPath = OS.Path.join(sourceProfileDir.path, "prefs.js");
            if (await OS.File.exists(oldPath)) {
              let rawPrefs = await OS.File.read(prefsPath, {
                encoding: "utf-8",
              });
              if (/^user_pref\("services\.sync\.username"/m.test(rawPrefs)) {
                // sync's configured in the source profile - ensure it is in the
                // new profile too.
                // Write it to prefs.js and flush the file.
                Services.prefs.setStringPref(
                  "services.sync.username",
                  username
                );
                savePrefs();
              }
            }
          }
        }
      } catch (ex) {
        aCallback(false);
        return;
      }
      aCallback(true);
    },
  };

  return [
    places,
    cookies,
    passwords,
    formData,
    dictionary,
    bookmarksBackups,
    session,
    sync,
    favicons,
    bookmarks,
  ].filter(r => r);
};

SelectedDirProfileMigrator.prototype.classDescription =
  "Selected Dir Profile Migrator";
SelectedDirProfileMigrator.prototype.contractID =
  "@mozilla.org/profile/migrator;1?app=browser&type=selecteddir";
SelectedDirProfileMigrator.prototype.classID = Components.ID(
  "{e25b779a-4b0a-4de5-95eb-887f6840dca4}"
);

var EXPORTED_SYMBOLS = ["SelectedDirProfileMigrator"];
