/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sw=2 ts=2 sts=2 et */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/*
 * Migrates from a Firefox profile in a lossy manner in order to clean up a
 * user's profile.  Data is only migrated where the benefits outweigh the
 * potential problems caused by importing undesired/invalid configurations
 * from the source profile.
 * Caveats:
 *  - Will fail to set currentProfileDir if current profile path doesn't match a
 *    profile in the database, i.e. when browser being run from ./mach run
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
ChromeUtils.defineModuleGetter(
  this,
  "FileUtils",
  "resource://gre/modules/FileUtils.jsm"
);

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

function FirefoxProfileMigrator() {
  this.wrappedJSObject = this; // for testing...

  this._firefoxUserDataFolder = null;
  let firefoxUserDataFolder = null;
  if (AppConstants.platform == "macosx") {
    firefoxUserDataFolder = FileUtils.getDir(
      "ULibDir",
      ["Application Support", "Firefox"],
      false
    );
  } else if (AppConstants.platform == "linux") {
    firefoxUserDataFolder = FileUtils.getDir(
      "Home",
      [".mozilla", "firefox"],
      false
    );
  } else if (AppConstants.platform == "win") {
    firefoxUserDataFolder = FileUtils.getDir(
      "AppData",
      ["Mozilla", "Firefox"],
      false
    );
  }
  this._firefoxUserDataFolder = firefoxUserDataFolder.exists()
    ? firefoxUserDataFolder
    : null;
}

FirefoxProfileMigrator.prototype = Object.create(MigratorPrototype);

FirefoxProfileMigrator.prototype._getAllProfiles = function() {
  //return getAllProfilesNative();

  let allProfiles = new Map();
  let profileConfig = this._firefoxUserDataFolder.clone();
  profileConfig.append("profiles.ini");
  if (!profileConfig.exists()) {
    Cu.reportError("'Profiles.ini' does not exist.");
  }
  if (!profileConfig.isReadable()) {
    Cu.reportError("'Profiles.ini' could not be read.");
  }
  let profileConfigObj = Cc["@mozilla.org/xpcom/ini-parser-factory;1"]
    .getService(Ci.nsIINIParserFactory)
    .createINIParser(profileConfig);
  let path = "";
  if (profileConfigObj) {
    path = profileConfigObj.getString("Profile0", "Path");
  }
  // get PathProfile default
  let profileDefault = "";
  let profileName = path;
  let rootFolder = "";
  if (path.split("/").length > 1) {
    profileDefault = path.split("/");
    profileName = profileDefault[profileDefault.length - 1];
    rootFolder = profileDefault[0];
  }

  let folderProfile = [];
  let sourceFolder = null;
  if (AppConstants.platform == "macosx") {
    if (rootFolder == "") {
      folderProfile = ["Application Support", "Firefox", profileName];
    } else {
      folderProfile = [
        "Application Support",
        "Firefox",
        rootFolder,
        profileName,
      ];
    }
    sourceFolder = FileUtils.getDir("ULibDir", folderProfile, false);
  } else if (AppConstants.platform == "linux") {
    if (rootFolder == "") {
      folderProfile = [".mozilla", "firefox", profileName];
    } else {
      folderProfile = [".mozilla", "firefox", rootFolder, profileName];
    }
    sourceFolder = FileUtils.getDir("Home", folderProfile, false);
  } else if (AppConstants.platform == "win") {
    if (rootFolder == "") {
      folderProfile = ["Mozilla", "Firefox", profileName];
    } else {
      folderProfile = ["Mozilla", "Firefox", rootFolder, profileName];
    }
    sourceFolder = FileUtils.getDir("AppData", folderProfile, false);
  }

  allProfiles.set(profileName, sourceFolder);
  return allProfiles;
};

function sorter(a, b) {
  return a.id.toLocaleLowerCase().localeCompare(b.id.toLocaleLowerCase());
}

FirefoxProfileMigrator.prototype.getSourceProfiles = function() {
  return [...this._getAllProfiles().keys()]
    .map(x => ({ id: x, name: x }))
    .sort(sorter);
};

FirefoxProfileMigrator.prototype._getFileObject = function(dir, fileName) {
  let file = dir.clone();
  file.append(fileName);

  // File resources are monolithic.  We don't make partial copies since
  // they are not expected to work alone. Return null to avoid trying to
  // copy non-existing files.
  return file.exists() ? file : null;
};

FirefoxProfileMigrator.prototype.getResources = function(aProfile) {
  let sourceProfileDir = (aProfile = this._getAllProfiles().get(aProfile.id));
  if (
    !sourceProfileDir ||
    !sourceProfileDir.exists() ||
    !sourceProfileDir.isReadable()
  ) {
    return null;
  }

  let profile = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
    Ci.nsIToolkitProfileService
  ).defaultProfile;

  if (profile == null) {
    profile = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
      Ci.nsIToolkitProfileService
    ).currentProfile;
  }

  let currentProfileDir = profile.rootDir;

  return this._getResourcesInternal(sourceProfileDir, currentProfileDir);
};

FirefoxProfileMigrator.prototype.getLastUsedDate = function() {
  // We always pretend we're really old, so that we don't mess
  // up the determination of which browser is the most 'recent'
  // to import from.
  return Promise.resolve(new Date(0));
};

FirefoxProfileMigrator.prototype._getResourcesInternal = function(
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
        for (let file of files) {
          file.copyTo(currentProfileDir, "");
        }
        aCallback(true);
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
            // Copy the file itself.
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

FirefoxProfileMigrator.prototype.classDescription = "Firefox Profile Migrator";
FirefoxProfileMigrator.prototype.contractID =
  "@mozilla.org/profile/migrator;1?app=browser&type=firefox";
FirefoxProfileMigrator.prototype.classID = Components.ID(
  "{849265D1-20D6-4F19-950F-4B24546B9046}"
);

var EXPORTED_SYMBOLS = ["FirefoxProfileMigrator"];
