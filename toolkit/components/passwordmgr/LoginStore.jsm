/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Handles serialization of the data and persistence into a file.
 *
 * The file is stored in JSON format, without indentation, using UTF-8 encoding.
 * With indentation applied, the file would look like this:
 *
 * {
 *   "logins": [
 *     {
 *       "id": 2,
 *       "hostname": "http://www.example.com",
 *       "httpRealm": null,
 *       "formSubmitURL": "http://www.example.com/submit-url",
 *       "usernameField": "username_field",
 *       "passwordField": "password_field",
 *       "encryptedUsername": "...",
 *       "encryptedPassword": "...",
 *       "guid": "...",
 *       "encType": 1,
 *       "timeCreated": 1262304000000,
 *       "timeLastUsed": 1262304000000,
 *       "timePasswordChanged": 1262476800000,
 *       "timesUsed": 1
 *     },
 *     {
 *       "id": 4,
 *       (...)
 *     }
 *   ],
 *   "disabledHosts": [
 *     "http://www.example.org",
 *     "http://www.example.net"
 *   ],
 *   "nextId": 10,
 *   "version": 1
 * }
 */

"use strict";

this.EXPORTED_SYMBOLS = [
  "LoginStore",
];

// Globals

const { classes: Cc, interfaces: Ci, utils: Cu, results: Cr } = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "JSONFile",
                                  "resource://gre/modules/JSONFile.jsm");

/**
 * Current data version assigned by the code that last touched the data.
 *
 * This number should be updated only when it is important to understand whether
 * an old version of the code has touched the data, for example to execute an
 * update logic.  In most cases, this number should not be changed, in
 * particular when no special one-time update logic is needed.
 *
 * For example, this number should NOT be changed when a new optional field is
 * added to a login entry.
 */
const kDataVersion = 2;

// The permission type we store in the permission manager.
const PERMISSION_SAVE_LOGINS = "login-saving";

// LoginStore

/**
 * Inherits from JSONFile and handles serialization of login-related data and
 * persistence into a file.
 *
 * @param aPath
 *        String containing the file path where data should be saved.
 */
function LoginStore(aPath) {
  JSONFile.call(this, {
    path: aPath,
    dataPostProcessor: this._dataPostProcessor.bind(this)
  });
}

LoginStore.prototype = Object.create(JSONFile.prototype);
LoginStore.prototype.constructor = LoginStore;

/**
 * Synchronously work on the data just loaded into memory.
 */
LoginStore.prototype._dataPostProcessor = function(data) {
  if (data.nextId === undefined) {
    data.nextId = 1;
  }

  // Create any arrays that are not present in the saved file.
  if (!data.logins) {
    data.logins = [];
  }

  // Stub needed for login imports before data has been migrated.
  if (!data.disabledHosts) {
    data.disabledHosts = [];
  }

  if (data.version === 1) {
    this._migrateDisabledHosts(data);
  }

  // Indicate that the current version of the code has touched the file.
  data.version = kDataVersion;

  return data;
};

/**
 * Migrates disabled hosts to the permission manager.
 */
LoginStore.prototype._migrateDisabledHosts = function (data) {
  for (let host of data.disabledHosts) {
    try {
      let uri = Services.io.newURI(host, null, null);
      Services.perms.add(uri, PERMISSION_SAVE_LOGINS, Services.perms.DENY_ACTION);
    } catch (e) {
      Cu.reportError(e);
    }
  }

  delete data.disabledHosts;
};
