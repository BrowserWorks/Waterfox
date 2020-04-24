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
ChromeUtils.defineModuleGetter(
  this,
  "ProfileAge",
  "resource://gre/modules/ProfileAge.jsm"
);

var { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);


function LfirefoxProfileMigrator() {
  this.wrappedJSObject = this; // for testing...

  this._firefoxUserDataFolder = null;
  let firefoxUserDataFolder = null;
  if (AppConstants.platform == "macosx") {
    firefoxUserDataFolder = FileUtils.getDir("ULibDir", ["Application Support", "Firefox"], false);
  } else if (AppConstants.platform == "linux") {
    firefoxUserDataFolder = FileUtils.getDir("Home", [".mozilla", "firefox"], false);
  } else if (AppConstants.platform == "win") {
    firefoxUserDataFolder = FileUtils.getDir("AppData", ["Mozilla", "Firefox"], false);
  }
  this._firefoxUserDataFolder = firefoxUserDataFolder.exists() ? firefoxUserDataFolder : null;
}

LfirefoxProfileMigrator.prototype = Object.create(MigratorPrototype);


function getAllProfilesNative() {
  let allProfiles = new Map();
  let profileService = Cc["@mozilla.org/toolkit/profile-service;1"].getService(
    Ci.nsIToolkitProfileService
  );
  for (let profile of profileService.profiles) {
    let rootDir = profile.rootDir;

    if (
      rootDir.exists() &&
      rootDir.isReadable()){
      allProfiles.set(profile.name, rootDir);
    }
  }
  return allProfiles;
};


LfirefoxProfileMigrator.prototype._getAllProfiles = function() {
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
  let profileConfigObj = Cc["@mozilla.org/xpcom/ini-parser-factory;1"].
  getService(Ci.nsIINIParserFactory).createINIParser(profileConfig);
  let path = "";
  if (profileConfigObj) {
      path = profileConfigObj.getString("Profile0", "Path");
  }
  // get PathProfile default
  let rootDir = this._firefoxUserDataFolder.clone();
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
      folderProfile = ["Application Support", "Firefox", rootFolder, profileName];
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

LfirefoxProfileMigrator.prototype.getSourceProfiles = function() {
  Services.console.logStringMessage("LfirefoxProfileMigrator.prototype.getSourceProfiles: ");
  return [...this._getAllProfiles().keys()]
    .map(x => ({ id: x, name: x }))
    .sort(sorter);
};

LfirefoxProfileMigrator.prototype._getFileObject = function(dir, fileName) {
  Services.console.logStringMessage("LfirefoxProfileMigrator.prototype._getFileObject: " + fileName);
  let file = dir.clone();
  file.append(fileName);

  // File resources are monolithic.  We don't make partial copies since
  // they are not expected to work alone. Return null to avoid trying to
  // copy non-existing files.
  return file.exists() ? file : null;
};

LfirefoxProfileMigrator.prototype.getResources = function(aProfile) {
  Services.console.logStringMessage("LfirefoxProfileMigrator.prototype.getResources: " + aProfile);

  let sourceProfileDir = aProfile = this._getAllProfiles().get(aProfile.id);
  if (
    !sourceProfileDir ||
    !sourceProfileDir.exists() ||
    !sourceProfileDir.isReadable()
  ) {
    return null;
  }
  
  let profile = Components.classes["@mozilla.org/toolkit/profile-service;1"]
              .getService(Components.interfaces.nsIToolkitProfileService)
              .defaultProfile;

  if (null == profile){
    profile = Components.classes["@mozilla.org/toolkit/profile-service;1"]
              .getService(Components.interfaces.nsIToolkitProfileService)
              .currentProfile;
  }

  let currentProfileDir = profile.rootDir;

  Services.console.logStringMessage("LfirefoxProfileMigrator.prototype.getResources: " + sourceProfileDir + " : " + currentProfileDir);
  
  return this._getResourcesInternal(sourceProfileDir, currentProfileDir);
};

LfirefoxProfileMigrator.prototype.getLastUsedDate = function() {
  // We always pretend we're really old, so that we don't mess
  // up the determination of which browser is the most 'recent'
  // to import from.
  return Promise.resolve(new Date(0));
};

LfirefoxProfileMigrator.prototype._getResourcesInternal = function(
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

          Services.console.logStringMessage("LfirefoxProfileMigrator.prototype._getResourcesInternal: " + file.path + "\\" + file.leafName + " " + currentProfileDir.path  + "\\" + currentProfileDir.leafName);

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
  let places = getFileResource(types.HISTORY, [
    "places.sqlite",
    "places.sqlite-wal",
  ]);
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
            // Write it to prefs.js and flush the file.
            Services.prefs.setStringPref("services.sync.username", username);
            savePrefs();
            // and copy the file itself.
            await OS.File.copy(
              oldPath,
              OS.Path.join(currentProfileDir.path, "signedInUser.json")
            );
          }
        }
      } catch (ex) {
        aCallback(false);
        return;
      }
      aCallback(true);
    },
  };

  // Telemetry related migrations.
  let times = {
    name: "times", // name is used only by tests.
    type: types.OTHERDATA,
    migrate: aCallback => {
      let file = this._getFileObject(sourceProfileDir, "times.json");
      if (file) {
        file.copyTo(currentProfileDir, "");
      }
      // And record the fact a migration (ie, a reset) happened.
      let recordMigration = async () => {
        try {
          let profileTimes = await ProfileAge(currentProfileDir.path);
          await profileTimes.recordProfileReset();
          aCallback(true);
        } catch (e) {
          aCallback(false);
        }
      };

      recordMigration();
    },
  };
  let telemetry = {
    name: "telemetry", // name is used only by tests...
    type: types.OTHERDATA,
    migrate: aCallback => {
      let createSubDir = name => {
        let dir = currentProfileDir.clone();
        dir.append(name);
        dir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
        return dir;
      };

      // If the 'datareporting' directory exists we migrate files from it.
      let dataReportingDir = this._getFileObject(
        sourceProfileDir,
        "datareporting"
      );
      if (dataReportingDir && dataReportingDir.isDirectory()) {
        // Copy only specific files.
        let toCopy = ["state.json", "session-state.json"];

        let dest = createSubDir("datareporting");
        let enumerator = dataReportingDir.directoryEntries;
        while (enumerator.hasMoreElements()) {
          let file = enumerator.nextFile;
          if (file.isDirectory() || !toCopy.includes(file.leafName)) {
            continue;
          }
          file.copyTo(dest, "");
        }
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
    times,
    telemetry,
    favicons,
  ].filter(r => r);
};

Object.defineProperty(LfirefoxProfileMigrator.prototype, "startupOnlyMigrator", {
  get: () => true,
});

LfirefoxProfileMigrator.prototype.classDescription = "Local Firefox Profile Migrator";
LfirefoxProfileMigrator.prototype.contractID =
  "@mozilla.org/profile/migrator;1?app=browser&type=lfirefox";
LfirefoxProfileMigrator.prototype.classID = Components.ID(
  "{849265D1-20D6-4F19-950F-4B24546B9046}"
);

var EXPORTED_SYMBOLS = ["LfirefoxProfileMigrator"];
