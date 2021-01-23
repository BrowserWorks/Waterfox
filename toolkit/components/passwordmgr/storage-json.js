/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * nsILoginManagerStorage implementation for the JSON back-end.
 */

"use strict";

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "LoginHelper",
  "resource://gre/modules/LoginHelper.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "LoginImport",
  "resource://gre/modules/LoginImport.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "LoginStore",
  "resource://gre/modules/LoginStore.jsm"
);
ChromeUtils.defineModuleGetter(this, "OS", "resource://gre/modules/osfile.jsm");

XPCOMUtils.defineLazyServiceGetter(
  this,
  "gUUIDGenerator",
  "@mozilla.org/uuid-generator;1",
  "nsIUUIDGenerator"
);

class LoginManagerStorage_json {
  constructor() {
    this.__crypto = null; // nsILoginManagerCrypto service
    this.__decryptedPotentiallyVulnerablePasswords = null;
  }

  get classID() {
    return Components.ID("{c00c432d-a0c9-46d7-bef6-9c45b4d07341}");
  }

  get QueryInterface() {
    return ChromeUtils.generateQI([Ci.nsILoginManagerStorage]);
  }

  get _xpcom_factory() {
    return XPCOMUtils.generateSingletonFactory(this.LoginManagerStorage_json);
  }

  get _crypto() {
    if (!this.__crypto) {
      this.__crypto = Cc["@mozilla.org/login-manager/crypto/SDR;1"].getService(
        Ci.nsILoginManagerCrypto
      );
    }
    return this.__crypto;
  }

  get _decryptedPotentiallyVulnerablePasswords() {
    if (!this.__decryptedPotentiallyVulnerablePasswords) {
      this._store.ensureDataReady();
      this.__decryptedPotentiallyVulnerablePasswords = [];
      for (const potentiallyVulnerablePassword of this._store.data
        .potentiallyVulnerablePasswords) {
        const decryptedPotentiallyVulnerablePassword = this._crypto.decrypt(
          potentiallyVulnerablePassword.encryptedPassword
        );
        this.__decryptedPotentiallyVulnerablePasswords.push(
          decryptedPotentiallyVulnerablePassword
        );
      }
    }
    return this.__decryptedPotentiallyVulnerablePasswords;
  }

  initialize() {
    try {
      // Force initialization of the crypto module.
      // See bug 717490 comment 17.
      this._crypto;

      // Set the reference to LoginStore synchronously.
      let jsonPath = OS.Path.join(OS.Constants.Path.profileDir, "logins.json");
      this._store = new LoginStore(jsonPath);

      return (async () => {
        // Load the data asynchronously.
        this.log("Opening database at", this._store.path);
        await this._store.load();

        // The import from previous versions operates the first time
        // that this built-in storage back-end is used.  This may be
        // later than expected, in case add-ons have registered an
        // alternate storage that disabled the default one.
        try {
          if (Services.prefs.getBoolPref("signon.importedFromSqlite")) {
            return;
          }
        } catch (ex) {
          // If the preference does not exist, we need to import.
        }

        // Import only happens asynchronously.
        let sqlitePath = OS.Path.join(
          OS.Constants.Path.profileDir,
          "signons.sqlite"
        );
        if (await OS.File.exists(sqlitePath)) {
          let loginImport = new LoginImport(this._store, sqlitePath);
          // Failures during import, for example due to a corrupt
          // file or a schema version that is too old, will not
          // prevent us from marking the operation as completed.
          // At the next startup, we will not try the import again.
          await loginImport.import().catch(Cu.reportError);
          this._store.saveSoon();
        }

        // We won't attempt import again on next startup.
        Services.prefs.setBoolPref("signon.importedFromSqlite", true);
      })().catch(Cu.reportError);
    } catch (e) {
      this.log("Initialization failed:", e);
      throw new Error("Initialization failed");
    }
  }

  /**
   * Internal method used by regression tests only.  It is called before
   * replacing this storage module with a new instance.
   */
  terminate() {
    this._store._saver.disarm();
    return this._store._save();
  }

  addLogin(
    login,
    preEncrypted = false,
    plaintextUsername = null,
    plaintextPassword = null
  ) {
    if (
      preEncrypted &&
      (typeof plaintextUsername != "string" ||
        typeof plaintextPassword != "string")
    ) {
      throw new Error(
        "plaintextUsername and plaintextPassword are required when preEncrypted is true"
      );
    }

    this._store.ensureDataReady();

    // Throws if there are bogus values.
    LoginHelper.checkLoginValues(login);

    let [encUsername, encPassword, encType] = preEncrypted
      ? [login.username, login.password, this._crypto.defaultEncType]
      : this._encryptLogin(login);

    // Clone the login, so we don't modify the caller's object.
    let loginClone = login.clone();
    loginClone.username = preEncrypted ? plaintextUsername : login.username;
    loginClone.password = preEncrypted ? plaintextPassword : login.password;

    // Initialize the nsILoginMetaInfo fields, unless the caller gave us values
    loginClone.QueryInterface(Ci.nsILoginMetaInfo);
    if (loginClone.guid) {
      let guid = loginClone.guid;
      if (!this._isGuidUnique(guid)) {
        // We have an existing GUID, but it's possible that entry is unable
        // to be decrypted - if that's the case we remove the existing one
        // and allow this one to be added.
        let existing = this._searchLogins({ guid })[0];
        if (this._decryptLogins(existing).length) {
          // Existing item is good, so it's an error to try and re-add it.
          throw new Error("specified GUID already exists");
        }
        // find and remove the existing bad entry.
        let foundIndex = this._store.data.logins.findIndex(l => l.guid == guid);
        if (foundIndex == -1) {
          throw new Error("can't find a matching GUID to remove");
        }
        this._store.data.logins.splice(foundIndex, 1);
      }
    } else {
      loginClone.guid = gUUIDGenerator.generateUUID().toString();
    }

    // Set timestamps
    let currentTime = Date.now();
    if (!loginClone.timeCreated) {
      loginClone.timeCreated = currentTime;
    }
    if (!loginClone.timeLastUsed) {
      loginClone.timeLastUsed = currentTime;
    }
    if (!loginClone.timePasswordChanged) {
      loginClone.timePasswordChanged = currentTime;
    }
    if (!loginClone.timesUsed) {
      loginClone.timesUsed = 1;
    }

    this._store.data.logins.push({
      id: this._store.data.nextId++,
      hostname: loginClone.origin,
      httpRealm: loginClone.httpRealm,
      formSubmitURL: loginClone.formActionOrigin,
      usernameField: loginClone.usernameField,
      passwordField: loginClone.passwordField,
      encryptedUsername: encUsername,
      encryptedPassword: encPassword,
      guid: loginClone.guid,
      encType,
      timeCreated: loginClone.timeCreated,
      timeLastUsed: loginClone.timeLastUsed,
      timePasswordChanged: loginClone.timePasswordChanged,
      timesUsed: loginClone.timesUsed,
    });
    this._store.saveSoon();

    // Send a notification that a login was added.
    LoginHelper.notifyStorageChanged("addLogin", loginClone);
    return loginClone;
  }

  removeLogin(login) {
    this._store.ensureDataReady();

    let [idToDelete, storedLogin] = this._getIdForLogin(login);
    if (!idToDelete) {
      throw new Error("No matching logins");
    }

    let foundIndex = this._store.data.logins.findIndex(l => l.id == idToDelete);
    if (foundIndex != -1) {
      this._store.data.logins.splice(foundIndex, 1);
      this._store.saveSoon();
    }

    LoginHelper.notifyStorageChanged("removeLogin", storedLogin);
  }

  modifyLogin(oldLogin, newLoginData) {
    this._store.ensureDataReady();

    let [idToModify, oldStoredLogin] = this._getIdForLogin(oldLogin);
    if (!idToModify) {
      throw new Error("No matching logins");
    }

    let newLogin = LoginHelper.buildModifiedLogin(oldStoredLogin, newLoginData);

    // Check if the new GUID is duplicate.
    if (
      newLogin.guid != oldStoredLogin.guid &&
      !this._isGuidUnique(newLogin.guid)
    ) {
      throw new Error("specified GUID already exists");
    }

    // Look for an existing entry in case key properties changed.
    if (!newLogin.matches(oldLogin, true)) {
      let logins = this.findLogins(
        newLogin.origin,
        newLogin.formActionOrigin,
        newLogin.httpRealm
      );

      let matchingLogin = logins.find(login => newLogin.matches(login, true));
      if (matchingLogin) {
        throw LoginHelper.createLoginAlreadyExistsError(matchingLogin.guid);
      }
    }

    // Get the encrypted value of the username and password.
    let [encUsername, encPassword, encType] = this._encryptLogin(newLogin);

    for (let loginItem of this._store.data.logins) {
      if (loginItem.id == idToModify) {
        loginItem.hostname = newLogin.origin;
        loginItem.httpRealm = newLogin.httpRealm;
        loginItem.formSubmitURL = newLogin.formActionOrigin;
        loginItem.usernameField = newLogin.usernameField;
        loginItem.passwordField = newLogin.passwordField;
        loginItem.encryptedUsername = encUsername;
        loginItem.encryptedPassword = encPassword;
        loginItem.guid = newLogin.guid;
        loginItem.encType = encType;
        loginItem.timeCreated = newLogin.timeCreated;
        loginItem.timeLastUsed = newLogin.timeLastUsed;
        loginItem.timePasswordChanged = newLogin.timePasswordChanged;
        loginItem.timesUsed = newLogin.timesUsed;
        this._store.saveSoon();
        break;
      }
    }

    LoginHelper.notifyStorageChanged("modifyLogin", [oldStoredLogin, newLogin]);
  }

  recordPasswordUse(login) {
    // Update the lastUsed timestamp and increment the use count.
    let propBag = Cc["@mozilla.org/hash-property-bag;1"].createInstance(
      Ci.nsIWritablePropertyBag
    );
    propBag.setProperty("timeLastUsed", Date.now());
    propBag.setProperty("timesUsedIncrement", 1);
    this.modifyLogin(login, propBag);
  }

  async recordBreachAlertDismissal(loginGUID) {
    this._store.ensureDataReady();
    const dismissedBreachAlertsByLoginGUID = this._store._data
      .dismissedBreachAlertsByLoginGUID;

    dismissedBreachAlertsByLoginGUID[loginGUID] = {
      timeBreachAlertDismissed: new Date().getTime(),
    };

    return this._store.saveSoon();
  }

  getBreachAlertDismissalsByLoginGUID() {
    this._store.ensureDataReady();
    return this._store._data.dismissedBreachAlertsByLoginGUID;
  }

  /**
   * @return {nsILoginInfo[]}
   */
  getAllLogins() {
    this._store.ensureDataReady();

    let [logins, ids] = this._searchLogins({});

    // decrypt entries for caller.
    logins = this._decryptLogins(logins);

    this.log("getAllLogins: returning", logins.length, "logins.");
    return logins;
  }

  /**
   * Returns an array of nsILoginInfo. If decryption of a login
   * fails due to a corrupt entry, the login is not included in
   * the resulting array.
   *
   * @resolve {nsILoginInfo[]}
   */
  async getAllLoginsAsync() {
    this._store.ensureDataReady();

    let [logins, ids] = this._searchLogins({});
    if (!logins.length) {
      return [];
    }
    let ciphertexts = logins
      .map(l => l.username)
      .concat(logins.map(l => l.password));
    let plaintexts = await this._crypto.decryptMany(ciphertexts);
    let usernames = plaintexts.slice(0, logins.length);
    let passwords = plaintexts.slice(logins.length);

    let result = [];
    for (let i = 0; i < logins.length; i++) {
      if (!usernames[i] || !passwords[i]) {
        // If the username or password is blank it means that decryption may have
        // failed during decryptMany but we can't differentiate an empty string
        // value from a failure so we attempt to decrypt again and check the
        // result.
        let login = logins[i];
        try {
          this._crypto.decrypt(login.username);
          this._crypto.decrypt(login.password);
        } catch (e) {
          // If decryption failed (corrupt entry?), just skip it.
          // Rethrow other errors (like canceling entry of a master pw)
          if (e.result == Cr.NS_ERROR_FAILURE) {
            this.log(
              "Could not decrypt login:",
              login.QueryInterface(Ci.nsILoginMetaInfo).guid
            );
            continue;
          }
          throw e;
        }
      }

      logins[i].username = usernames[i];
      logins[i].password = passwords[i];
      result.push(logins[i]);
    }

    return result;
  }

  async searchLoginsAsync(matchData) {
    this.log("searchLoginsAsync:", matchData);
    let result = this.searchLogins(LoginHelper.newPropertyBag(matchData));
    // Emulate being async:
    return Promise.resolve(result);
  }

  /**
   * Public wrapper around _searchLogins to convert the nsIPropertyBag to a
   * JavaScript object and decrypt the results.
   *
   * @return {nsILoginInfo[]} which are decrypted.
   */
  searchLogins(matchData) {
    this._store.ensureDataReady();

    let realMatchData = {};
    let options = {};

    matchData.QueryInterface(Ci.nsIPropertyBag2);
    if (matchData.hasKey("guid")) {
      // Enforce GUID-based filtering when available, since the origin of the
      // login may not match the origin of the form in the case of scheme
      // upgrades.
      realMatchData = { guid: matchData.getProperty("guid") };
    } else {
      // Convert nsIPropertyBag to normal JS object.
      for (let prop of matchData.enumerator) {
        switch (prop.name) {
          // Some property names aren't field names but are special options to
          // affect the search.
          case "acceptDifferentSubdomains":
          case "schemeUpgrades": {
            options[prop.name] = prop.value;
            break;
          }
          default: {
            realMatchData[prop.name] = prop.value;
            break;
          }
        }
      }
    }

    let [logins, ids] = this._searchLogins(realMatchData, options);

    // Decrypt entries found for the caller.
    logins = this._decryptLogins(logins);

    return logins;
  }

  /**
   * Private method to perform arbitrary searches on any field. Decryption is
   * left to the caller.
   *
   * Returns [logins, ids] for logins that match the arguments, where logins
   * is an array of encrypted nsLoginInfo and ids is an array of associated
   * ids in the database.
   */
  _searchLogins(
    matchData,
    aOptions = {
      schemeUpgrades: false,
      acceptDifferentSubdomains: false,
    },
    candidateLogins = this._store.data.logins
  ) {
    if (
      "formActionOrigin" in matchData &&
      matchData.formActionOrigin === "" &&
      // Carve an exception out for a unit test in test_legacy_empty_formSubmitURL.js
      Object.keys(matchData).length != 1
    ) {
      throw new Error(
        "Searching with an empty `formActionOrigin` doesn't do a wildcard search"
      );
    }

    function match(aLoginItem) {
      for (let field in matchData) {
        let wantedValue = matchData[field];

        // Override the storage field name for some fields due to backwards
        // compatibility with Sync/storage.
        let storageFieldName = field;
        switch (field) {
          case "formActionOrigin": {
            storageFieldName = "formSubmitURL";
            break;
          }
          case "origin": {
            storageFieldName = "hostname";
            break;
          }
        }

        switch (field) {
          case "formActionOrigin":
            if (wantedValue != null) {
              // Historical compatibility requires this special case
              if (aLoginItem.formSubmitURL == "") {
                break;
              }
              if (
                !LoginHelper.isOriginMatching(
                  aLoginItem[storageFieldName],
                  wantedValue,
                  aOptions
                )
              ) {
                return false;
              }
              break;
            }
          // fall through
          case "origin":
            if (wantedValue != null) {
              // needed for formActionOrigin fall through
              if (
                !LoginHelper.isOriginMatching(
                  aLoginItem[storageFieldName],
                  wantedValue,
                  aOptions
                )
              ) {
                return false;
              }
              break;
            }
          // Normal cases.
          // fall through
          case "httpRealm":
          case "id":
          case "usernameField":
          case "passwordField":
          case "encryptedUsername":
          case "encryptedPassword":
          case "guid":
          case "encType":
          case "timeCreated":
          case "timeLastUsed":
          case "timePasswordChanged":
          case "timesUsed":
            if (wantedValue == null && aLoginItem[storageFieldName]) {
              return false;
            } else if (aLoginItem[storageFieldName] != wantedValue) {
              return false;
            }
            break;
          // Fail if caller requests an unknown property.
          default:
            throw new Error("Unexpected field: " + field);
        }
      }
      return true;
    }

    let foundLogins = [],
      foundIds = [];
    for (let loginItem of candidateLogins) {
      if (match(loginItem)) {
        // Create the new nsLoginInfo object, push to array
        let login = Cc["@mozilla.org/login-manager/loginInfo;1"].createInstance(
          Ci.nsILoginInfo
        );
        login.init(
          loginItem.hostname,
          loginItem.formSubmitURL,
          loginItem.httpRealm,
          loginItem.encryptedUsername,
          loginItem.encryptedPassword,
          loginItem.usernameField,
          loginItem.passwordField
        );
        // set nsILoginMetaInfo values
        login.QueryInterface(Ci.nsILoginMetaInfo);
        login.guid = loginItem.guid;
        login.timeCreated = loginItem.timeCreated;
        login.timeLastUsed = loginItem.timeLastUsed;
        login.timePasswordChanged = loginItem.timePasswordChanged;
        login.timesUsed = loginItem.timesUsed;
        foundLogins.push(login);
        foundIds.push(loginItem.id);
      }
    }

    this.log(
      "_searchLogins: returning",
      foundLogins.length,
      "logins for",
      matchData,
      "with options",
      aOptions
    );
    return [foundLogins, foundIds];
  }

  /**
   * Removes all logins from storage.
   */
  removeAllLogins() {
    this._store.ensureDataReady();

    this.log("Removing all logins");
    this._store.data.logins = [];
    this._store.data.potentiallyVulnerablePasswords = [];
    this.__decryptedPotentiallyVulnerablePasswords = null;
    this._store.data.dismissedBreachAlertsByLoginGUID = {};
    this._store.saveSoon();

    LoginHelper.notifyStorageChanged("removeAllLogins", null);
  }

  findLogins(origin, formActionOrigin, httpRealm) {
    this._store.ensureDataReady();

    let loginData = {
      origin,
      formActionOrigin,
      httpRealm,
    };
    let matchData = {};
    for (let field of ["origin", "formActionOrigin", "httpRealm"]) {
      if (loginData[field] != "") {
        matchData[field] = loginData[field];
      }
    }
    let [logins, ids] = this._searchLogins(matchData);

    // Decrypt entries found for the caller.
    logins = this._decryptLogins(logins);

    this.log("_findLogins: returning", logins.length, "logins");
    return logins;
  }

  countLogins(origin, formActionOrigin, httpRealm) {
    this._store.ensureDataReady();

    let loginData = {
      origin,
      formActionOrigin,
      httpRealm,
    };
    let matchData = {};
    for (let field of ["origin", "formActionOrigin", "httpRealm"]) {
      if (loginData[field] != "") {
        matchData[field] = loginData[field];
      }
    }
    let [logins, ids] = this._searchLogins(matchData);

    this.log("_countLogins: counted logins:", logins.length);
    return logins.length;
  }

  addPotentiallyVulnerablePassword(login) {
    this._store.ensureDataReady();
    // this breached password is already stored
    if (this.isPotentiallyVulnerablePassword(login)) {
      return;
    }
    this.__decryptedPotentiallyVulnerablePasswords.push(login.password);

    this._store.data.potentiallyVulnerablePasswords.push({
      encryptedPassword: this._crypto.encrypt(login.password),
    });
    this._store.saveSoon();
  }

  isPotentiallyVulnerablePassword(login) {
    return this._decryptedPotentiallyVulnerablePasswords.includes(
      login.password
    );
  }

  clearAllPotentiallyVulnerablePasswords() {
    this._store.ensureDataReady();
    if (!this._store.data.potentiallyVulnerablePasswords.length) {
      // No need to write to disk
      return;
    }
    this._store.data.potentiallyVulnerablePasswords = [];
    this._store.saveSoon();
    this.__decryptedPotentiallyVulnerablePasswords = null;
  }

  get uiBusy() {
    return this._crypto.uiBusy;
  }

  get isLoggedIn() {
    return this._crypto.isLoggedIn;
  }

  /**
   * Returns an array with two items: [id, login]. If the login was not
   * found, both items will be null. The returned login contains the actual
   * stored login (useful for looking at the actual nsILoginMetaInfo values).
   */
  _getIdForLogin(login) {
    this._store.ensureDataReady();

    let matchData = {};
    for (let field of ["origin", "formActionOrigin", "httpRealm"]) {
      if (login[field] != "") {
        matchData[field] = login[field];
      }
    }
    let [logins, ids] = this._searchLogins(matchData);

    let id = null;
    let foundLogin = null;

    // The specified login isn't encrypted, so we need to ensure
    // the logins we're comparing with are decrypted. We decrypt one entry
    // at a time, lest _decryptLogins return fewer entries and screw up
    // indices between the two.
    for (let i = 0; i < logins.length; i++) {
      let [decryptedLogin] = this._decryptLogins([logins[i]]);

      if (!decryptedLogin || !decryptedLogin.equals(login)) {
        continue;
      }

      // We've found a match, set id and break
      foundLogin = decryptedLogin;
      id = ids[i];
      break;
    }

    return [id, foundLogin];
  }

  /**
   * Checks to see if the specified GUID already exists.
   */
  _isGuidUnique(guid) {
    this._store.ensureDataReady();

    return this._store.data.logins.every(l => l.guid != guid);
  }

  /**
   * Returns the encrypted username, password, and encrypton type for the specified
   * login. Can throw if the user cancels a master password entry.
   */
  _encryptLogin(login) {
    let encUsername = this._crypto.encrypt(login.username);
    let encPassword = this._crypto.encrypt(login.password);
    let encType = this._crypto.defaultEncType;

    return [encUsername, encPassword, encType];
  }

  /**
   * Decrypts username and password fields in the provided array of
   * logins.
   *
   * The entries specified by the array will be decrypted, if possible.
   * An array of successfully decrypted logins will be returned. The return
   * value should be given to external callers (since still-encrypted
   * entries are useless), whereas internal callers generally don't want
   * to lose unencrypted entries (eg, because the user clicked Cancel
   * instead of entering their master password)
   */
  _decryptLogins(logins) {
    let result = [];

    for (let login of logins) {
      try {
        login.username = this._crypto.decrypt(login.username);
        login.password = this._crypto.decrypt(login.password);
      } catch (e) {
        // If decryption failed (corrupt entry?), just skip it.
        // Rethrow other errors (like canceling entry of a master pw)
        if (e.result == Cr.NS_ERROR_FAILURE) {
          continue;
        }
        throw e;
      }
      result.push(login);
    }

    return result;
  }
}

XPCOMUtils.defineLazyGetter(LoginManagerStorage_json.prototype, "log", () => {
  let logger = LoginHelper.createLogger("Login storage");
  return logger.log.bind(logger);
});

const EXPORTED_SYMBOLS = ["LoginManagerStorage_json"];
