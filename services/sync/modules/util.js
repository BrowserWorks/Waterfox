/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["XPCOMUtils", "Services", "Utils", "Async", "Svc", "Str"];

var {classes: Cc, interfaces: Ci, results: Cr, utils: Cu} = Components;

Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://services-common/observers.js");
Cu.import("resource://services-common/stringbundle.js");
Cu.import("resource://services-common/utils.js");
Cu.import("resource://services-common/async.js", this);
Cu.import("resource://services-crypto/utils.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://gre/modules/Preferences.jsm");
Cu.import("resource://gre/modules/Services.jsm", this);
Cu.import("resource://gre/modules/XPCOMUtils.jsm", this);
Cu.import("resource://gre/modules/osfile.jsm", this);
Cu.import("resource://gre/modules/Task.jsm", this);

// FxAccountsCommon.js doesn't use a "namespace", so create one here.
XPCOMUtils.defineLazyGetter(this, "FxAccountsCommon", function() {
  let FxAccountsCommon = {};
  Cu.import("resource://gre/modules/FxAccountsCommon.js", FxAccountsCommon);
  return FxAccountsCommon;
});

/*
 * Utility functions
 */

this.Utils = {
  // Alias in functions from CommonUtils. These previously were defined here.
  // In the ideal world, references to these would be removed.
  nextTick: CommonUtils.nextTick,
  namedTimer: CommonUtils.namedTimer,
  makeURI: CommonUtils.makeURI,
  encodeUTF8: CommonUtils.encodeUTF8,
  decodeUTF8: CommonUtils.decodeUTF8,
  safeAtoB: CommonUtils.safeAtoB,
  byteArrayToString: CommonUtils.byteArrayToString,
  bytesAsHex: CommonUtils.bytesAsHex,
  hexToBytes: CommonUtils.hexToBytes,
  encodeBase32: CommonUtils.encodeBase32,
  decodeBase32: CommonUtils.decodeBase32,

  // Aliases from CryptoUtils.
  generateRandomBytes: CryptoUtils.generateRandomBytes,
  computeHTTPMACSHA1: CryptoUtils.computeHTTPMACSHA1,
  digestUTF8: CryptoUtils.digestUTF8,
  digestBytes: CryptoUtils.digestBytes,
  sha1: CryptoUtils.sha1,
  sha1Base32: CryptoUtils.sha1Base32,
  sha256: CryptoUtils.sha256,
  makeHMACKey: CryptoUtils.makeHMACKey,
  makeHMACHasher: CryptoUtils.makeHMACHasher,
  hkdfExpand: CryptoUtils.hkdfExpand,
  pbkdf2Generate: CryptoUtils.pbkdf2Generate,
  deriveKeyFromPassphrase: CryptoUtils.deriveKeyFromPassphrase,
  getHTTPMACSHA1Header: CryptoUtils.getHTTPMACSHA1Header,

  /**
   * The string to use as the base User-Agent in Sync requests.
   * This string will look something like
   *
   *   Firefox/49.0a1 (Windows NT 6.1; WOW64; rv:46.0) FxSync/1.51.0.20160516142357.desktop
   */
  _userAgent: null,
  get userAgent() {
    if (!this._userAgent) {
      let hph = Cc["@mozilla.org/network/protocol;1?name=http"].getService(Ci.nsIHttpProtocolHandler);
      this._userAgent =
        Services.appinfo.name + "/" + Services.appinfo.version +  // Product.
        " (" + hph.oscpu + ")" +                                  // (oscpu)
        " FxSync/" + WEAVE_VERSION + "." +                        // Sync.
        Services.appinfo.appBuildID + ".";                        // Build.
    }
    return this._userAgent + Svc.Prefs.get("client.type", "desktop");
  },

  /**
   * Wrap a function to catch all exceptions and log them
   *
   * @usage MyObj._catch = Utils.catch;
   *        MyObj.foo = function() { this._catch(func)(); }
   *
   * Optionally pass a function which will be called if an
   * exception occurs.
   */
  catch: function Utils_catch(func, exceptionCallback) {
    let thisArg = this;
    return function WrappedCatch() {
      try {
        return func.call(thisArg);
      }
      catch(ex) {
        thisArg._log.debug("Exception calling " + (func.name || "anonymous function"), ex);
        if (exceptionCallback) {
          return exceptionCallback.call(thisArg, ex);
        }
        return null;
      }
    };
  },

  /**
   * Wrap a function to call lock before calling the function then unlock.
   *
   * @usage MyObj._lock = Utils.lock;
   *        MyObj.foo = function() { this._lock(func)(); }
   */
  lock: function lock(label, func) {
    let thisArg = this;
    return function WrappedLock() {
      if (!thisArg.lock()) {
        throw "Could not acquire lock. Label: \"" + label + "\".";
      }

      try {
        return func.call(thisArg);
      }
      finally {
        thisArg.unlock();
      }
    };
  },

  isLockException: function isLockException(ex) {
    return ex && ex.indexOf && ex.indexOf("Could not acquire lock.") == 0;
  },

  /**
   * Wrap functions to notify when it starts and finishes executing or if it
   * threw an error.
   *
   * The message is a combination of a provided prefix, the local name, and
   * the event. Possible events are: "start", "finish", "error". The subject
   * is the function's return value on "finish" or the caught exception on
   * "error". The data argument is the predefined data value.
   *
   * Example:
   *
   * @usage function MyObj(name) {
   *          this.name = name;
   *          this._notify = Utils.notify("obj:");
   *        }
   *        MyObj.prototype = {
   *          foo: function() this._notify("func", "data-arg", function () {
   *            //...
   *          }(),
   *        };
   */
  notify: function Utils_notify(prefix) {
    return function NotifyMaker(name, data, func) {
      let thisArg = this;
      let notify = function(state, subject) {
        let mesg = prefix + name + ":" + state;
        thisArg._log.trace("Event: " + mesg);
        Observers.notify(mesg, subject, data);
      };

      return function WrappedNotify() {
        try {
          notify("start", null);
          let ret = func.call(thisArg);
          notify("finish", ret);
          return ret;
        }
        catch(ex) {
          notify("error", ex);
          throw ex;
        }
      };
    };
  },

  /**
   * GUIDs are 9 random bytes encoded with base64url (RFC 4648).
   * That makes them 12 characters long with 72 bits of entropy.
   */
  makeGUID: function makeGUID() {
    return CommonUtils.encodeBase64URL(Utils.generateRandomBytes(9));
  },

  _base64url_regex: /^[-abcdefghijklmnopqrstuvwxyz0123456789_]{12}$/i,
  checkGUID: function checkGUID(guid) {
    return !!guid && this._base64url_regex.test(guid);
  },

  /**
   * Add a simple getter/setter to an object that defers access of a property
   * to an inner property.
   *
   * @param obj
   *        Object to add properties to defer in its prototype
   * @param defer
   *        Property of obj to defer to
   * @param prop
   *        Property name to defer (or an array of property names)
   */
  deferGetSet: function Utils_deferGetSet(obj, defer, prop) {
    if (Array.isArray(prop))
      return prop.map(prop => Utils.deferGetSet(obj, defer, prop));

    let prot = obj.prototype;

    // Create a getter if it doesn't exist yet
    if (!prot.__lookupGetter__(prop)) {
      prot.__defineGetter__(prop, function () {
        return this[defer][prop];
      });
    }

    // Create a setter if it doesn't exist yet
    if (!prot.__lookupSetter__(prop)) {
      prot.__defineSetter__(prop, function (val) {
        this[defer][prop] = val;
      });
    }
  },

  lazyStrings: function Weave_lazyStrings(name) {
    let bundle = "chrome://weave/locale/services/" + name + ".properties";
    return () => new StringBundle(bundle);
  },

  deepEquals: function eq(a, b) {
    // If they're triple equals, then it must be equals!
    if (a === b)
      return true;

    // If they weren't equal, they must be objects to be different
    if (typeof a != "object" || typeof b != "object")
      return false;

    // But null objects won't have properties to compare
    if (a === null || b === null)
      return false;

    // Make sure all of a's keys have a matching value in b
    for (let k in a)
      if (!eq(a[k], b[k]))
        return false;

    // Do the same for b's keys but skip those that we already checked
    for (let k in b)
      if (!(k in a) && !eq(a[k], b[k]))
        return false;

    return true;
  },

  // Generator and discriminator for HMAC exceptions.
  // Split these out in case we want to make them richer in future, and to
  // avoid inevitable confusion if the message changes.
  throwHMACMismatch: function throwHMACMismatch(shouldBe, is) {
    throw "Record SHA256 HMAC mismatch: should be " + shouldBe + ", is " + is;
  },

  isHMACMismatch: function isHMACMismatch(ex) {
    const hmacFail = "Record SHA256 HMAC mismatch: ";
    return ex && ex.indexOf && (ex.indexOf(hmacFail) == 0);
  },

  /**
   * Turn RFC 4648 base32 into our own user-friendly version.
   *   ABCDEFGHIJKLMNOPQRSTUVWXYZ234567
   * becomes
   *   abcdefghijk8mn9pqrstuvwxyz234567
   */
  base32ToFriendly: function base32ToFriendly(input) {
    return input.toLowerCase()
                .replace(/l/g, '8')
                .replace(/o/g, '9');
  },

  base32FromFriendly: function base32FromFriendly(input) {
    return input.toUpperCase()
                .replace(/8/g, 'L')
                .replace(/9/g, 'O');
  },

  /**
   * Key manipulation.
   */

  // Return an octet string in friendly base32 *with no trailing =*.
  encodeKeyBase32: function encodeKeyBase32(keyData) {
    return Utils.base32ToFriendly(
             Utils.encodeBase32(keyData))
           .slice(0, SYNC_KEY_ENCODED_LENGTH);
  },

  decodeKeyBase32: function decodeKeyBase32(encoded) {
    return Utils.decodeBase32(
             Utils.base32FromFriendly(
               Utils.normalizePassphrase(encoded)))
           .slice(0, SYNC_KEY_DECODED_LENGTH);
  },

  base64Key: function base64Key(keyData) {
    return btoa(keyData);
  },

  /**
   * N.B., salt should be base64 encoded, even though we have to decode
   * it later!
   */
  derivePresentableKeyFromPassphrase : function derivePresentableKeyFromPassphrase(passphrase, salt, keyLength, forceJS) {
    let k = CryptoUtils.deriveKeyFromPassphrase(passphrase, salt, keyLength,
                                                forceJS);
    return Utils.encodeKeyBase32(k);
  },

  /**
   * N.B., salt should be base64 encoded, even though we have to decode
   * it later!
   */
  deriveEncodedKeyFromPassphrase : function deriveEncodedKeyFromPassphrase(passphrase, salt, keyLength, forceJS) {
    let k = CryptoUtils.deriveKeyFromPassphrase(passphrase, salt, keyLength,
                                                forceJS);
    return Utils.base64Key(k);
  },

  /**
   * Take a base64-encoded 128-bit AES key, returning it as five groups of five
   * uppercase alphanumeric characters, separated by hyphens.
   * A.K.A. base64-to-base32 encoding.
   */
  presentEncodedKeyAsSyncKey : function presentEncodedKeyAsSyncKey(encodedKey) {
    return Utils.encodeKeyBase32(atob(encodedKey));
  },

  /**
   * Load a JSON file from disk in the profile directory.
   *
   * @param filePath
   *        JSON file path load from profile. Loaded file will be
   *        <profile>/<filePath>.json. i.e. Do not specify the ".json"
   *        extension.
   * @param that
   *        Object to use for logging and "this" for callback.
   * @param callback
   *        Function to process json object as its first argument. If the file
   *        could not be loaded, the first argument will be undefined.
   */
  jsonLoad: Task.async(function*(filePath, that, callback) {
    let path = OS.Path.join(OS.Constants.Path.profileDir, "weave", filePath + ".json");

    if (that._log) {
      that._log.trace("Loading json from disk: " + filePath);
    }

    let json;

    try {
      json = yield CommonUtils.readJSON(path);
    } catch (e) {
      if (e instanceof OS.File.Error && e.becauseNoSuchFile) {
        // Ignore non-existent files, but explicitly return null.
        json = null;
      } else {
        if (that._log) {
          that._log.debug("Failed to load json", e);
        }
      }
    }

    callback.call(that, json);
  }),

  /**
   * Save a json-able object to disk in the profile directory.
   *
   * @param filePath
   *        JSON file path save to <filePath>.json
   * @param that
   *        Object to use for logging and "this" for callback
   * @param obj
   *        Function to provide json-able object to save. If this isn't a
   *        function, it'll be used as the object to make a json string.
   * @param callback
   *        Function called when the write has been performed. Optional.
   *        The first argument will be a Components.results error
   *        constant on error or null if no error was encountered (and
   *        the file saved successfully).
   */
  jsonSave: Task.async(function*(filePath, that, obj, callback) {
    let path = OS.Path.join(OS.Constants.Path.profileDir, "weave",
                            ...(filePath + ".json").split("/"));
    let dir = OS.Path.dirname(path);
    let error = null;

    try {
      yield OS.File.makeDir(dir, { from: OS.Constants.Path.profileDir });

      if (that._log) {
        that._log.trace("Saving json to disk: " + path);
      }

      let json = typeof obj == "function" ? obj.call(that) : obj;

      yield CommonUtils.writeJSON(json, path);
    } catch (e) {
      error = e
    }

    if (typeof callback == "function") {
      callback.call(that, error);
    }
  }),

  /**
   * Move a json file in the profile directory. Will fail if a file exists at the
   * destination.
   *
   * @returns a promise that resolves to undefined on success, or rejects on failure
   *
   * @param aFrom
   *        Current path to the JSON file saved on disk, relative to profileDir/weave
   *        .json will be appended to the file name.
   * @param aTo
   *        New path to the JSON file saved on disk, relative to profileDir/weave
   *        .json will be appended to the file name.
   * @param that
   *        Object to use for logging
   */
  jsonMove(aFrom, aTo, that) {
    let pathFrom = OS.Path.join(OS.Constants.Path.profileDir, "weave",
                                ...(aFrom + ".json").split("/"));
    let pathTo = OS.Path.join(OS.Constants.Path.profileDir, "weave",
                              ...(aTo + ".json").split("/"));
    if (that._log) {
      that._log.trace("Moving " + pathFrom + " to " + pathTo);
    }
    return OS.File.move(pathFrom, pathTo, { noOverwrite: true });
  },

  /**
   * Removes a json file in the profile directory.
   *
   * @returns a promise that resolves to undefined on success, or rejects on failure
   *
   * @param filePath
   *        Current path to the JSON file saved on disk, relative to profileDir/weave
   *        .json will be appended to the file name.
   * @param that
   *        Object to use for logging
   */
  jsonRemove(filePath, that) {
    let path = OS.Path.join(OS.Constants.Path.profileDir, "weave",
                            ...(filePath + ".json").split("/"));
    if (that._log) {
      that._log.trace("Deleting " + path);
    }
    return OS.File.remove(path, { ignoreAbsent: true });
  },

  getErrorString: function Utils_getErrorString(error, args) {
    try {
      return Str.errors.get(error, args || null);
    } catch (e) {}

    // basically returns "Unknown Error"
    return Str.errors.get("error.reason.unknown");
  },

  /**
   * Generate 26 characters.
   */
  generatePassphrase: function generatePassphrase() {
    // Note that this is a different base32 alphabet to the one we use for
    // other tasks. It's lowercase, uses different letters, and needs to be
    // decoded with decodeKeyBase32, not just decodeBase32.
    return Utils.encodeKeyBase32(CryptoUtils.generateRandomBytes(16));
  },

  /**
   * The following are the methods supported for UI use:
   *
   * * isPassphrase:
   *     determines whether a string is either a normalized or presentable
   *     passphrase.
   * * hyphenatePassphrase:
   *     present a normalized passphrase for display. This might actually
   *     perform work beyond just hyphenation; sorry.
   * * hyphenatePartialPassphrase:
   *     present a fragment of a normalized passphrase for display.
   * * normalizePassphrase:
   *     take a presentable passphrase and reduce it to a normalized
   *     representation for storage. normalizePassphrase can safely be called
   *     on normalized input.
   * * normalizeAccount:
   *     take user input for account/username, cleaning up appropriately.
   */

  isPassphrase: function(s) {
    if (s) {
      return /^[abcdefghijkmnpqrstuvwxyz23456789]{26}$/.test(Utils.normalizePassphrase(s));
    }
    return false;
  },

  /**
   * Hyphenate a passphrase (26 characters) into groups.
   * abbbbccccddddeeeeffffggggh
   * =>
   * a-bbbbc-cccdd-ddeee-effff-ggggh
   */
  hyphenatePassphrase: function hyphenatePassphrase(passphrase) {
    // For now, these are the same.
    return Utils.hyphenatePartialPassphrase(passphrase, true);
  },

  hyphenatePartialPassphrase: function hyphenatePartialPassphrase(passphrase, omitTrailingDash) {
    if (!passphrase)
      return null;

    // Get the raw data input. Just base32.
    let data = passphrase.toLowerCase().replace(/[^abcdefghijkmnpqrstuvwxyz23456789]/g, "");

    // This is the neatest way to do this.
    if ((data.length == 1) && !omitTrailingDash)
      return data + "-";

    // Hyphenate it.
    let y = data.substr(0,1);
    let z = data.substr(1).replace(/(.{1,5})/g, "-$1");

    // Correct length? We're done.
    if ((z.length == 30) || omitTrailingDash)
      return y + z;

    // Add a trailing dash if appropriate.
    return (y + z.replace(/([^-]{5})$/, "$1-")).substr(0, SYNC_KEY_HYPHENATED_LENGTH);
  },

  normalizePassphrase: function normalizePassphrase(pp) {
    // Short var name... have you seen the lines below?!
    // Allow leading and trailing whitespace.
    pp = pp.trim().toLowerCase();

    // 20-char sync key.
    if (pp.length == 23 &&
        [5, 11, 17].every(i => pp[i] == '-')) {

      return pp.slice(0, 5) + pp.slice(6, 11)
             + pp.slice(12, 17) + pp.slice(18, 23);
    }

    // "Modern" 26-char key.
    if (pp.length == 31 &&
        [1, 7, 13, 19, 25].every(i => pp[i] == '-')) {

      return pp.slice(0, 1) + pp.slice(2, 7)
             + pp.slice(8, 13) + pp.slice(14, 19)
             + pp.slice(20, 25) + pp.slice(26, 31);
    }

    // Something else -- just return.
    return pp;
  },

  normalizeAccount: function normalizeAccount(acc) {
    return acc.trim();
  },

  /**
   * Create an array like the first but without elements of the second. Reuse
   * arrays if possible.
   */
  arraySub: function arraySub(minuend, subtrahend) {
    if (!minuend.length || !subtrahend.length)
      return minuend;
    return minuend.filter(i => subtrahend.indexOf(i) == -1);
  },

  /**
   * Build the union of two arrays. Reuse arrays if possible.
   */
  arrayUnion: function arrayUnion(foo, bar) {
    if (!foo.length)
      return bar;
    if (!bar.length)
      return foo;
    return foo.concat(Utils.arraySub(bar, foo));
  },

  bind2: function Async_bind2(object, method) {
    return function innerBind() { return method.apply(object, arguments); };
  },

  /**
   * Is there a master password configured, regardless of current lock state?
   */
  mpEnabled: function mpEnabled() {
    let modules = Cc["@mozilla.org/security/pkcs11moduledb;1"]
                    .getService(Ci.nsIPKCS11ModuleDB);
    let sdrSlot = modules.findSlotByName("");
    let status  = sdrSlot.status;
    let slots = Ci.nsIPKCS11Slot;

    return status != slots.SLOT_UNINITIALIZED && status != slots.SLOT_READY;
  },

  /**
   * Is there a master password configured and currently locked?
   */
  mpLocked: function mpLocked() {
    let modules = Cc["@mozilla.org/security/pkcs11moduledb;1"]
                    .getService(Ci.nsIPKCS11ModuleDB);
    let sdrSlot = modules.findSlotByName("");
    let status  = sdrSlot.status;
    let slots = Ci.nsIPKCS11Slot;

    if (status == slots.SLOT_READY || status == slots.SLOT_LOGGED_IN
                                   || status == slots.SLOT_UNINITIALIZED)
      return false;

    if (status == slots.SLOT_NOT_LOGGED_IN)
      return true;

    // something wacky happened, pretend MP is locked
    return true;
  },

  // If Master Password is enabled and locked, present a dialog to unlock it.
  // Return whether the system is unlocked.
  ensureMPUnlocked: function ensureMPUnlocked() {
    if (!Utils.mpLocked()) {
      return true;
    }
    let sdr = Cc["@mozilla.org/security/sdr;1"]
                .getService(Ci.nsISecretDecoderRing);
    try {
      sdr.encryptString("bacon");
      return true;
    } catch(e) {}
    return false;
  },

  /**
   * Return a value for a backoff interval.  Maximum is eight hours, unless
   * Status.backoffInterval is higher.
   *
   */
  calculateBackoff: function calculateBackoff(attempts, baseInterval,
                                              statusInterval) {
    let backoffInterval = attempts *
                          (Math.floor(Math.random() * baseInterval) +
                           baseInterval);
    return Math.max(Math.min(backoffInterval, MAXIMUM_BACKOFF_INTERVAL),
                    statusInterval);
  },

  /**
   * Return a set of hostnames (including the protocol) which may have
   * credentials for sync itself stored in the login manager.
   *
   * In general, these hosts will not have their passwords synced, will be
   * reset when we drop sync credentials, etc.
   */
  getSyncCredentialsHosts: function() {
    let result = new Set(this.getSyncCredentialsHostsLegacy());
    for (let host of this.getSyncCredentialsHostsFxA()) {
      result.add(host);
    }
    return result;
  },

  /*
   * Get the "legacy" identity hosts.
   */
  getSyncCredentialsHostsLegacy: function() {
    // the legacy sync host
    return new Set([PWDMGR_HOST]);
  },

  /*
   * Get the FxA identity hosts.
   */
  getSyncCredentialsHostsFxA: function() {
    let result = new Set();
    // the FxA host
    result.add(FxAccountsCommon.FXA_PWDMGR_HOST);
    // We used to include the FxA hosts (hence the Set() result) but we now
    // don't give them special treatment (hence the Set() with exactly 1 item)
    return result;
  },

  getDefaultDeviceName() {
    // Generate a client name if we don't have a useful one yet
    let env = Cc["@mozilla.org/process/environment;1"]
                .getService(Ci.nsIEnvironment);
    let user = env.get("USER") || env.get("USERNAME") ||
               Svc.Prefs.get("account") || Svc.Prefs.get("username");
    // A little hack for people using the the moz-build environment on Windows
    // which sets USER to the literal "%USERNAME%" (yes, really)
    if (user == "%USERNAME%" && env.get("USERNAME")) {
      user = env.get("USERNAME");
    }

    let brand = new StringBundle("chrome://branding/locale/brand.properties");
    let brandName = brand.get("brandShortName");

    let appName;
    try {
      let syncStrings = new StringBundle("chrome://browser/locale/sync.properties");
      appName = syncStrings.getFormattedString("sync.defaultAccountApplication", [brandName]);
    } catch (ex) {}
    appName = appName || brandName;

    let system =
      // 'device' is defined on unix systems
      Cc["@mozilla.org/system-info;1"].getService(Ci.nsIPropertyBag2).get("device") ||
      // hostname of the system, usually assigned by the user or admin
      Cc["@mozilla.org/system-info;1"].getService(Ci.nsIPropertyBag2).get("host") ||
      // fall back on ua info string
      Cc["@mozilla.org/network/protocol;1?name=http"].getService(Ci.nsIHttpProtocolHandler).oscpu;

    return Str.sync.get("client.name2", [user, appName, system]);
  },

  getDeviceName() {
    const deviceName = Svc.Prefs.get("client.name", "");

    if (deviceName === "") {
      return this.getDefaultDeviceName();
    }

    return deviceName;
  },

  getDeviceType() {
    return Svc.Prefs.get("client.type", DEVICE_TYPE_DESKTOP);
  },

  formatTimestamp(date) {
    // Format timestamp as: "%Y-%m-%d %H:%M:%S"
    let year = String(date.getFullYear());
    let month = String(date.getMonth() + 1).padStart(2, "0");
    let day = String(date.getDate()).padStart(2, "0");
    let hours = String(date.getHours()).padStart(2, "0");
    let minutes = String(date.getMinutes()).padStart(2, "0");
    let seconds = String(date.getSeconds()).padStart(2, "0");

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }
};

XPCOMUtils.defineLazyGetter(Utils, "_utf8Converter", function() {
  let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"]
                    .createInstance(Ci.nsIScriptableUnicodeConverter);
  converter.charset = "UTF-8";
  return converter;
});

/*
 * Commonly-used services
 */
this.Svc = {};
Svc.Prefs = new Preferences(PREFS_BRANCH);
Svc.DefaultPrefs = new Preferences({branch: PREFS_BRANCH, defaultBranch: true});
Svc.Obs = Observers;

var _sessionCID = Services.appinfo.ID == SEAMONKEY_ID ?
  "@mozilla.org/suite/sessionstore;1" :
  "@mozilla.org/browser/sessionstore;1";

[
 ["Idle", "@mozilla.org/widget/idleservice;1", "nsIIdleService"],
 ["Session", _sessionCID, "nsISessionStore"]
].forEach(function([name, contract, iface]) {
  XPCOMUtils.defineLazyServiceGetter(Svc, name, contract, iface);
});

XPCOMUtils.defineLazyModuleGetter(Svc, "FormHistory", "resource://gre/modules/FormHistory.jsm");

Svc.__defineGetter__("Crypto", function() {
  let cryptoSvc;
  let ns = {};
  Cu.import("resource://services-crypto/WeaveCrypto.js", ns);
  cryptoSvc = new ns.WeaveCrypto();
  delete Svc.Crypto;
  return Svc.Crypto = cryptoSvc;
});

this.Str = {};
["errors", "sync"].forEach(function(lazy) {
  XPCOMUtils.defineLazyGetter(Str, lazy, Utils.lazyStrings(lazy));
});

Svc.Obs.add("xpcom-shutdown", function () {
  for (let name in Svc)
    delete Svc[name];
});
