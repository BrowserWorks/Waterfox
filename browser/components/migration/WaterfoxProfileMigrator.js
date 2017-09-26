/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
 * vim: sw=2 ts=2 sts=2 et */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
 "use strict";
 
 /*
  * Migrates data from a Firefox or old Waterfox profile in a lossy manner in order to transfer
  * to the new configuration options that Waterfox uses.
  */
 
 const { classes: Cc, interfaces: Ci, utils: Cu } = Components;
 
 Cu.import("resource://gre/modules/XPCOMUtils.jsm");
 Cu.import("resource:///modules/MigrationUtils.jsm");
 Cu.import("resource://gre/modules/Services.jsm");
 
 XPCOMUtils.defineLazyModuleGetter(this, "PlacesBackups",
  "resource://gre/modules/PlacesBackups.jsm");
 XPCOMUtils.defineLazyModuleGetter(this, "SessionMigration",
  "resource:///modules/sessionstore/SessionMigration.jsm");
 XPCOMUtils.defineLazyModuleGetter(this, "OS",
  "resource://gre/modules/osfile.jsm");
 XPCOMUtils.defineLazyModuleGetter(this, "FileUtils",
  "resource://gre/modules/FileUtils.jsm");
 XPCOMUtils.defineLazyModuleGetter(this, "ProfileAge",
  "resource://gre/modules/ProfileAge.jsm");
 XPCOMUtils.defineLazyModuleGetter(this, "AppConstants",
  "resource://gre/modules/AppConstants.jsm");
 
 
 function WaterfoxProfileMigrator() {
  this.wrappedJSObject = this; // for testing...
  this._waterfoxUserDataFolder = null;
  let waterfoxUserDataFolder = null;
  if (AppConstants.platform == "macosx") {
   waterfoxUserDataFolder = FileUtils.getDir("ULibDir", ["Application Support", "Firefox"], false);
  } else if (AppConstants.platform == "linux") {
   waterfoxUserDataFolder = FileUtils.getDir("Home", [".mozilla", "firefox"], false);
  } else if (AppConstants.platform == "win") {
   waterfoxUserDataFolder = FileUtils.getDir("AppData", ["Mozilla", "Firefox"], false);
  }
  this._waterfoxUserDataFolder = waterfoxUserDataFolder.exists() ? waterfoxUserDataFolder : null;
 }
 
 WaterfoxProfileMigrator.prototype = Object.create(MigratorPrototype);
 var gProfileName;
 
 WaterfoxProfileMigrator.prototype._getAllProfiles = function() {
  let allProfiles = new Map();
  let profileConfig = this._waterfoxUserDataFolder.clone();
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
  let rootDir = this._waterfoxUserDataFolder.clone();
  let profileDefault = "";
  let profileName = path;
  gProfileName = profileName;
  let rootFolder = "";
  if (path.split("/").length > 1) {
   profileDefault = path.split("/");
   profileName = profileDefault[profileDefault.length - 1];
   gProfileName = profileName;
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
 
 Object.defineProperty(WaterfoxProfileMigrator.prototype, "sourceProfiles", {
  get() {
   return [...this._getAllProfiles().keys()].map(x => ({
    id: x,
    name: x
   })).sort(sorter);
  }
 });
 
 WaterfoxProfileMigrator.prototype._getFileObject = function(dir, fileName) {
  let file = dir.clone();
  file.append(fileName);
 
  // File resources are monolithic.  We don't make partial copies since
  // they are not expected to work alone. Return null to avoid trying to
  // copy non-existing files.
  return file.exists() ? file : null;
 };
 
 WaterfoxProfileMigrator.prototype.getResources = function(aProfile) {
  let sourceProfileDir = aProfile ? this._getAllProfiles().get(aProfile.id) :
   Components.classes["@mozilla.org/toolkit/profile-service;1"]
   .getService(Components.interfaces.nsIToolkitProfileService)
   .selectedProfile.rootDir;
  if (!sourceProfileDir || !sourceProfileDir.exists() ||
   !sourceProfileDir.isReadable())
   return null;
 
  // Being a startup-only migrator, we can rely on
  // MigrationUtils.profileStartup being set.
  let currentProfileDir = MigrationUtils.profileStartup.directory;
 
  // Surely data cannot be imported from the current profile.
  if (sourceProfileDir.equals(currentProfileDir))
   return null;
 
  return this._getResourcesInternal(sourceProfileDir, currentProfileDir);
 };
 
 WaterfoxProfileMigrator.prototype.getLastUsedDate = function() {
  // We always pretend we're really old, so that we don't mess
  // up the determination of which browser is the most 'recent'
  // to import from.
  return Promise.resolve(new Date(0));
 };
 
 WaterfoxProfileMigrator.prototype._getResourcesInternal = function(sourceProfileDir, currentProfileDir) {
  // Set the name of the old default profile, so we can delete it after migration has finished.   
  Services.prefs.setCharPref("general.oldDefaultProfile", gProfileName);

  let getFileResource = (aMigrationType, aFileNames) => {
   let files = [];
   for (let fileName of aFileNames) {
    let file = this._getFileObject(sourceProfileDir, fileName);
    if (file)
     files.push(file);
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
    }
   };
  };
  
  let types = MigrationUtils.resourceTypes;
  let places = getFileResource(types.HISTORY, ["places.sqlite", "places.sqlite-wal"]);
  let favicons = getFileResource(types.HISTORY, ["favicons.sqlite", "favicons.sqlite-wal"]);
  let cookies = getFileResource(types.COOKIES, ["cookies.sqlite", "cookies.sqlite-wal"]);
  let passwords = getFileResource(types.PASSWORDS,
    ["signons.sqlite", "logins.json", "key3.db",
     "signedInUser.json"]);
  let formData = getFileResource(types.FORMDATA, [
    "formhistory.sqlite",
    "autofill-profiles.json",
  ]);
  let bookmarksBackups = getFileResource(types.OTHERDATA,
    [PlacesBackups.profileRelativeFolderPath]);
  let dictionary = getFileResource(types.OTHERDATA, ["persdict.dat"]);
  let setPrefs = getFileResource(types.OTHERDATA, ["prefs.js"]);

  let session;
  let env = Cc["@mozilla.org/process/environment;1"].getService(Ci.nsIEnvironment);
  if (env.get("MOZ_RESET_PROFILE_MIGRATE_SESSION")) {
    // We only want to restore the previous firefox session if the profile refresh was
    // triggered by user. The MOZ_RESET_PROFILE_MIGRATE_SESSION would be set when a user-triggered
    // profile refresh happened in nsAppRunner.cpp. Hence, we detect the MOZ_RESET_PROFILE_MIGRATE_SESSION
    // to see if session data migration is required.
    env.set("MOZ_RESET_PROFILE_MIGRATE_SESSION", "");
  }
    let sessionCheckpoints = this._getFileObject(sourceProfileDir, "sessionCheckpoints.json");
    let sessionFile = this._getFileObject(sourceProfileDir, "sessionstore.jsonlz4");
    if (sessionFile) {
      session = {
        type: types.SESSION,
        migrate(aCallback) {
          sessionCheckpoints.copyTo(currentProfileDir, "sessionCheckpoints.json");
          let newSessionFile = currentProfileDir.clone();
          newSessionFile.append("sessionstore.jsonlz4");
          let migrationPromise = SessionMigration.migrate(sessionFile.path, newSessionFile.path);
          migrationPromise.then(function() {
            // Force the browser to one-off resume the session that we give it:
            Services.prefs.setBoolPref("browser.sessionstore.resume_session_once", true);
            aCallback(true);
          }, function() {
            aCallback(false);
          });
        }
      };
    }
 
  // Here, we enumarate the profile directory and loop through each
  // file. Copy each file within that directory every loop, picking up any remnants.
  // More info:
  // https://developer.mozilla.org/en-US/docs/FileGuide/Directories#Iterating_over_the_Files_in_a_Directory
  // https://developer.mozilla.org/en-US/docs/FileGuide/MoveCopyDelete#Copying_a_File
  let enumerator = sourceProfileDir.directoryEntries;
  let listOfFiles = [];
  while (enumerator.hasMoreElements()) {
    let file = enumerator.getNext().QueryInterface(Ci.nsIFile);
    if ((file.isFile() || file.isDirectory()) && (!file.leafName.match(/^(parent.lock|.parentlock|sessionstore.jsonlz4|sessionCheckpoints.json|prefs.js|persdict.dat|autofill-profiles.json|formhistory.sqlite|signInUser.json|key3.db|logins.json|signons.sqlite|cookies.sqlite|cookies.sqlite-wal|favicons.sqlite|favicons.sqlite-wal|places.sqlite|places.sqlite-wal|bookmarkbackups)$/))) {
      listOfFiles.push(file.leafName);
	  Services.console.logStringMessage(file.leafName);
    }
  }
  
  let profileData = getFileResource(types.OTHERDATA, listOfFiles);
  
  return [places, cookies, passwords, formData, dictionary, bookmarksBackups,
          session, favicons, setPrefs, profileData].filter(r => r);
 };
 
 Object.defineProperty(WaterfoxProfileMigrator.prototype, "startupOnlyMigrator", {
  get: () => true
 });
 
 
 WaterfoxProfileMigrator.prototype.classDescription = "Waterfox Profile Migrator";
 WaterfoxProfileMigrator.prototype.contractID = "@mozilla.org/profile/migrator;1?app=browser&type=waterfox";
 WaterfoxProfileMigrator.prototype.classID = Components.ID("{2acb0662-4041-4017-abb9-548d6d0df97a}");
 
 this.NSGetFactory = XPCOMUtils.generateNSGetFactory([WaterfoxProfileMigrator]);
