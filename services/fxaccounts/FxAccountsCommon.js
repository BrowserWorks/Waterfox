/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var { interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Log.jsm");

// loglevel should be one of "Fatal", "Error", "Warn", "Info", "Config",
// "Debug", "Trace" or "All". If none is specified, "Debug" will be used by
// default.  Note "Debug" is usually appropriate so that when this log is
// included in the Sync file logs we get verbose output.
const PREF_LOG_LEVEL = "identity.fxaccounts.loglevel";
// The level of messages that will be dumped to the console.  If not specified,
// "Error" will be used.
const PREF_LOG_LEVEL_DUMP = "identity.fxaccounts.log.appender.dump";

// A pref that can be set so "sensitive" information (eg, personally
// identifiable info, credentials, etc) will be logged.
const PREF_LOG_SENSITIVE_DETAILS = "identity.fxaccounts.log.sensitive";

var exports = Object.create(null);

XPCOMUtils.defineLazyGetter(exports, "log", function() {
  let log = Log.repository.getLogger("FirefoxAccounts");
  // We set the log level to debug, but the default dump appender is set to
  // the level reflected in the pref.  Other code that consumes FxA may then
  // choose to add another appender at a different level.
  log.level = Log.Level.Debug;
  let appender = new Log.DumpAppender();
  appender.level = Log.Level.Error;

  log.addAppender(appender);
  try {
    // The log itself.
    let level =
      Services.prefs.getPrefType(PREF_LOG_LEVEL) == Ci.nsIPrefBranch.PREF_STRING
      && Services.prefs.getCharPref(PREF_LOG_LEVEL);
    log.level = Log.Level[level] || Log.Level.Debug;

    // The appender.
    level =
      Services.prefs.getPrefType(PREF_LOG_LEVEL_DUMP) == Ci.nsIPrefBranch.PREF_STRING
      && Services.prefs.getCharPref(PREF_LOG_LEVEL_DUMP);
    appender.level = Log.Level[level] || Log.Level.Error;
  } catch (e) {
    log.error(e);
  }

  return log;
});

// A boolean to indicate if personally identifiable information (or anything
// else sensitive, such as credentials) should be logged.
XPCOMUtils.defineLazyGetter(exports, "logPII", function() {
  try {
    return Services.prefs.getBoolPref(PREF_LOG_SENSITIVE_DETAILS);
  } catch (_) {
    return false;
  }
});

exports.FXACCOUNTS_PERMISSION = "firefox-accounts";

exports.DATA_FORMAT_VERSION = 1;
exports.DEFAULT_STORAGE_FILENAME = "signedInUser.json";

// Token life times.
// Having this parameter be short has limited security value and can cause
// spurious authentication values if the client's clock is skewed and
// we fail to adjust. See Bug 983256.
exports.ASSERTION_LIFETIME = 1000 * 3600 * 24 * 365 * 25; // 25 years
// This is a time period we want to guarantee that the assertion will be
// valid after we generate it (e.g., the signed cert won't expire in this
// period).
exports.ASSERTION_USE_PERIOD = 1000 * 60 * 5; // 5 minutes
exports.CERT_LIFETIME      = 1000 * 3600 * 6;  // 6 hours
exports.KEY_LIFETIME       = 1000 * 3600 * 12; // 12 hours

// After we start polling for account verification, we stop polling when this
// many milliseconds have elapsed.
exports.POLL_SESSION       = 1000 * 60 * 20;   // 20 minutes

// Observer notifications.
exports.ONLOGIN_NOTIFICATION = "fxaccounts:onlogin";
exports.ONVERIFIED_NOTIFICATION = "fxaccounts:onverified";
exports.ONLOGOUT_NOTIFICATION = "fxaccounts:onlogout";
// Internal to services/fxaccounts only
exports.ON_FXA_UPDATE_NOTIFICATION = "fxaccounts:update";
exports.ON_DEVICE_CONNECTED_NOTIFICATION = "fxaccounts:device_connected";
exports.ON_DEVICE_DISCONNECTED_NOTIFICATION = "fxaccounts:device_disconnected";
exports.ON_PROFILE_UPDATED_NOTIFICATION = "fxaccounts:profile_updated"; // Push
exports.ON_PASSWORD_CHANGED_NOTIFICATION = "fxaccounts:password_changed";
exports.ON_PASSWORD_RESET_NOTIFICATION = "fxaccounts:password_reset";
exports.ON_ACCOUNT_DESTROYED_NOTIFICATION = "fxaccounts:account_destroyed";
exports.ON_COLLECTION_CHANGED_NOTIFICATION = "sync:collection_changed";

exports.FXA_PUSH_SCOPE_ACCOUNT_UPDATE = "chrome://fxa-device-update";

exports.ON_PROFILE_CHANGE_NOTIFICATION = "fxaccounts:profilechange"; // WebChannel
exports.ON_ACCOUNT_STATE_CHANGE_NOTIFICATION = "fxaccounts:statechange";

// UI Requests.
exports.UI_REQUEST_SIGN_IN_FLOW = "signInFlow";
exports.UI_REQUEST_REFRESH_AUTH = "refreshAuthentication";

// The OAuth client ID for Firefox Desktop
exports.FX_OAUTH_CLIENT_ID = "5882386c6d801776";

// Firefox Accounts WebChannel ID
exports.WEBCHANNEL_ID = "account_updates";

// Server errno.
// From https://github.com/mozilla/fxa-auth-server/blob/master/docs/api.md#response-format
exports.ERRNO_ACCOUNT_ALREADY_EXISTS         = 101;
exports.ERRNO_ACCOUNT_DOES_NOT_EXIST         = 102;
exports.ERRNO_INCORRECT_PASSWORD             = 103;
exports.ERRNO_UNVERIFIED_ACCOUNT             = 104;
exports.ERRNO_INVALID_VERIFICATION_CODE      = 105;
exports.ERRNO_NOT_VALID_JSON_BODY            = 106;
exports.ERRNO_INVALID_BODY_PARAMETERS        = 107;
exports.ERRNO_MISSING_BODY_PARAMETERS        = 108;
exports.ERRNO_INVALID_REQUEST_SIGNATURE      = 109;
exports.ERRNO_INVALID_AUTH_TOKEN             = 110;
exports.ERRNO_INVALID_AUTH_TIMESTAMP         = 111;
exports.ERRNO_MISSING_CONTENT_LENGTH         = 112;
exports.ERRNO_REQUEST_BODY_TOO_LARGE         = 113;
exports.ERRNO_TOO_MANY_CLIENT_REQUESTS       = 114;
exports.ERRNO_INVALID_AUTH_NONCE             = 115;
exports.ERRNO_ENDPOINT_NO_LONGER_SUPPORTED   = 116;
exports.ERRNO_INCORRECT_LOGIN_METHOD         = 117;
exports.ERRNO_INCORRECT_KEY_RETRIEVAL_METHOD = 118;
exports.ERRNO_INCORRECT_API_VERSION          = 119;
exports.ERRNO_INCORRECT_EMAIL_CASE           = 120;
exports.ERRNO_ACCOUNT_LOCKED                 = 121;
exports.ERRNO_ACCOUNT_UNLOCKED               = 122;
exports.ERRNO_UNKNOWN_DEVICE                 = 123;
exports.ERRNO_DEVICE_SESSION_CONFLICT        = 124;
exports.ERRNO_SERVICE_TEMP_UNAVAILABLE       = 201;
exports.ERRNO_PARSE                          = 997;
exports.ERRNO_NETWORK                        = 998;
exports.ERRNO_UNKNOWN_ERROR                  = 999;

// Offset oauth server errnos so they don't conflict with auth server errnos
exports.OAUTH_SERVER_ERRNO_OFFSET = 1000;

// OAuth Server errno.
exports.ERRNO_UNKNOWN_CLIENT_ID              = 101 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INCORRECT_CLIENT_SECRET        = 102 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INCORRECT_REDIRECT_URI         = 103 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INVALID_FXA_ASSERTION          = 104 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_UNKNOWN_CODE                   = 105 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INCORRECT_CODE                 = 106 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_EXPIRED_CODE                   = 107 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_OAUTH_INVALID_TOKEN            = 108 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INVALID_REQUEST_PARAM          = 109 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INVALID_RESPONSE_TYPE          = 110 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_UNAUTHORIZED                   = 111 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_FORBIDDEN                      = 112 + exports.OAUTH_SERVER_ERRNO_OFFSET;
exports.ERRNO_INVALID_CONTENT_TYPE           = 113 + exports.OAUTH_SERVER_ERRNO_OFFSET;

// Errors.
exports.ERROR_ACCOUNT_ALREADY_EXISTS         = "ACCOUNT_ALREADY_EXISTS";
exports.ERROR_ACCOUNT_DOES_NOT_EXIST         = "ACCOUNT_DOES_NOT_EXIST ";
exports.ERROR_ACCOUNT_LOCKED                 = "ACCOUNT_LOCKED";
exports.ERROR_ACCOUNT_UNLOCKED               = "ACCOUNT_UNLOCKED";
exports.ERROR_ALREADY_SIGNED_IN_USER         = "ALREADY_SIGNED_IN_USER";
exports.ERROR_DEVICE_SESSION_CONFLICT        = "DEVICE_SESSION_CONFLICT";
exports.ERROR_ENDPOINT_NO_LONGER_SUPPORTED   = "ENDPOINT_NO_LONGER_SUPPORTED";
exports.ERROR_INCORRECT_API_VERSION          = "INCORRECT_API_VERSION";
exports.ERROR_INCORRECT_EMAIL_CASE           = "INCORRECT_EMAIL_CASE";
exports.ERROR_INCORRECT_KEY_RETRIEVAL_METHOD = "INCORRECT_KEY_RETRIEVAL_METHOD";
exports.ERROR_INCORRECT_LOGIN_METHOD         = "INCORRECT_LOGIN_METHOD";
exports.ERROR_INVALID_EMAIL                  = "INVALID_EMAIL";
exports.ERROR_INVALID_AUDIENCE               = "INVALID_AUDIENCE";
exports.ERROR_INVALID_AUTH_TOKEN             = "INVALID_AUTH_TOKEN";
exports.ERROR_INVALID_AUTH_TIMESTAMP         = "INVALID_AUTH_TIMESTAMP";
exports.ERROR_INVALID_AUTH_NONCE             = "INVALID_AUTH_NONCE";
exports.ERROR_INVALID_BODY_PARAMETERS        = "INVALID_BODY_PARAMETERS";
exports.ERROR_INVALID_PASSWORD               = "INVALID_PASSWORD";
exports.ERROR_INVALID_VERIFICATION_CODE      = "INVALID_VERIFICATION_CODE";
exports.ERROR_INVALID_REFRESH_AUTH_VALUE     = "INVALID_REFRESH_AUTH_VALUE";
exports.ERROR_INVALID_REQUEST_SIGNATURE      = "INVALID_REQUEST_SIGNATURE";
exports.ERROR_INTERNAL_INVALID_USER          = "INTERNAL_ERROR_INVALID_USER";
exports.ERROR_MISSING_BODY_PARAMETERS        = "MISSING_BODY_PARAMETERS";
exports.ERROR_MISSING_CONTENT_LENGTH         = "MISSING_CONTENT_LENGTH";
exports.ERROR_NO_TOKEN_SESSION               = "NO_TOKEN_SESSION";
exports.ERROR_NO_SILENT_REFRESH_AUTH         = "NO_SILENT_REFRESH_AUTH";
exports.ERROR_NOT_VALID_JSON_BODY            = "NOT_VALID_JSON_BODY";
exports.ERROR_OFFLINE                        = "OFFLINE";
exports.ERROR_PERMISSION_DENIED              = "PERMISSION_DENIED";
exports.ERROR_REQUEST_BODY_TOO_LARGE         = "REQUEST_BODY_TOO_LARGE";
exports.ERROR_SERVER_ERROR                   = "SERVER_ERROR";
exports.ERROR_SYNC_DISABLED                  = "SYNC_DISABLED";
exports.ERROR_TOO_MANY_CLIENT_REQUESTS       = "TOO_MANY_CLIENT_REQUESTS";
exports.ERROR_SERVICE_TEMP_UNAVAILABLE       = "SERVICE_TEMPORARY_UNAVAILABLE";
exports.ERROR_UI_ERROR                       = "UI_ERROR";
exports.ERROR_UI_REQUEST                     = "UI_REQUEST";
exports.ERROR_PARSE                          = "PARSE_ERROR";
exports.ERROR_NETWORK                        = "NETWORK_ERROR";
exports.ERROR_UNKNOWN                        = "UNKNOWN_ERROR";
exports.ERROR_UNKNOWN_DEVICE                 = "UNKNOWN_DEVICE";
exports.ERROR_UNVERIFIED_ACCOUNT             = "UNVERIFIED_ACCOUNT";

// OAuth errors.
exports.ERROR_UNKNOWN_CLIENT_ID              = "UNKNOWN_CLIENT_ID";
exports.ERROR_INCORRECT_CLIENT_SECRET        = "INCORRECT_CLIENT_SECRET";
exports.ERROR_INCORRECT_REDIRECT_URI         = "INCORRECT_REDIRECT_URI";
exports.ERROR_INVALID_FXA_ASSERTION          = "INVALID_FXA_ASSERTION";
exports.ERROR_UNKNOWN_CODE                   = "UNKNOWN_CODE";
exports.ERROR_INCORRECT_CODE                 = "INCORRECT_CODE";
exports.ERROR_EXPIRED_CODE                   = "EXPIRED_CODE";
exports.ERROR_OAUTH_INVALID_TOKEN            = "OAUTH_INVALID_TOKEN";
exports.ERROR_INVALID_REQUEST_PARAM          = "INVALID_REQUEST_PARAM";
exports.ERROR_INVALID_RESPONSE_TYPE          = "INVALID_RESPONSE_TYPE";
exports.ERROR_UNAUTHORIZED                   = "UNAUTHORIZED";
exports.ERROR_FORBIDDEN                      = "FORBIDDEN";
exports.ERROR_INVALID_CONTENT_TYPE           = "INVALID_CONTENT_TYPE";

// Additional generic error classes for external consumers
exports.ERROR_NO_ACCOUNT                     = "NO_ACCOUNT";
exports.ERROR_AUTH_ERROR                     = "AUTH_ERROR";
exports.ERROR_INVALID_PARAMETER              = "INVALID_PARAMETER";

// Status code errors
exports.ERROR_CODE_METHOD_NOT_ALLOWED        = 405;
exports.ERROR_MSG_METHOD_NOT_ALLOWED         = "METHOD_NOT_ALLOWED";

// FxAccounts has the ability to "split" the credentials between a plain-text
// JSON file in the profile dir and in the login manager.
// In order to prevent new fields accidentally ending up in the "wrong" place,
// all fields stored are listed here.

// The fields we save in the plaintext JSON.
// See bug 1013064 comments 23-25 for why the sessionToken is "safe"
exports.FXA_PWDMGR_PLAINTEXT_FIELDS = new Set(
  ["email", "verified", "authAt", "sessionToken", "uid", "oauthTokens", "profile",
  "deviceId", "deviceRegistrationVersion", "profileCache"]);

// Fields we store in secure storage if it exists.
exports.FXA_PWDMGR_SECURE_FIELDS = new Set(
  ["kA", "kB", "keyFetchToken", "unwrapBKey", "assertion"]);

// Fields we keep in memory and don't persist anywhere.
exports.FXA_PWDMGR_MEMORY_FIELDS = new Set(
  ["cert", "keyPair"]);

// A whitelist of fields that remain in storage when the user needs to
// reauthenticate. All other fields will be removed.
exports.FXA_PWDMGR_REAUTH_WHITELIST = new Set(
  ["email", "uid", "profile", "deviceId", "deviceRegistrationVersion", "verified"]);

// The pseudo-host we use in the login manager
exports.FXA_PWDMGR_HOST = "chrome://FirefoxAccounts";
// The realm we use in the login manager.
exports.FXA_PWDMGR_REALM = "Firefox Accounts credentials";

// Error matching.
exports.SERVER_ERRNO_TO_ERROR = {};

// Error mapping
exports.ERROR_TO_GENERAL_ERROR_CLASS = {};

for (let id in exports) {
  this[id] = exports[id];
}

// Allow this file to be imported via Components.utils.import().
this.EXPORTED_SYMBOLS = Object.keys(exports);

// Set these up now that everything has been loaded into |this|.
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_ACCOUNT_ALREADY_EXISTS]         = exports.ERROR_ACCOUNT_ALREADY_EXISTS;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_ACCOUNT_DOES_NOT_EXIST]         = exports.ERROR_ACCOUNT_DOES_NOT_EXIST;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_PASSWORD]             = exports.ERROR_INVALID_PASSWORD;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNVERIFIED_ACCOUNT]             = exports.ERROR_UNVERIFIED_ACCOUNT;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_VERIFICATION_CODE]      = exports.ERROR_INVALID_VERIFICATION_CODE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_NOT_VALID_JSON_BODY]            = exports.ERROR_NOT_VALID_JSON_BODY;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_BODY_PARAMETERS]        = exports.ERROR_INVALID_BODY_PARAMETERS;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_MISSING_BODY_PARAMETERS]        = exports.ERROR_MISSING_BODY_PARAMETERS;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_REQUEST_SIGNATURE]      = exports.ERROR_INVALID_REQUEST_SIGNATURE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_AUTH_TOKEN]             = exports.ERROR_INVALID_AUTH_TOKEN;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_AUTH_TIMESTAMP]         = exports.ERROR_INVALID_AUTH_TIMESTAMP;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_MISSING_CONTENT_LENGTH]         = exports.ERROR_MISSING_CONTENT_LENGTH;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_REQUEST_BODY_TOO_LARGE]         = exports.ERROR_REQUEST_BODY_TOO_LARGE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_TOO_MANY_CLIENT_REQUESTS]       = exports.ERROR_TOO_MANY_CLIENT_REQUESTS;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_AUTH_NONCE]             = exports.ERROR_INVALID_AUTH_NONCE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_ENDPOINT_NO_LONGER_SUPPORTED]   = exports.ERROR_ENDPOINT_NO_LONGER_SUPPORTED;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_LOGIN_METHOD]         = exports.ERROR_INCORRECT_LOGIN_METHOD;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_KEY_RETRIEVAL_METHOD] = exports.ERROR_INCORRECT_KEY_RETRIEVAL_METHOD;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_API_VERSION]          = exports.ERROR_INCORRECT_API_VERSION;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_EMAIL_CASE]           = exports.ERROR_INCORRECT_EMAIL_CASE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_ACCOUNT_LOCKED]                 = exports.ERROR_ACCOUNT_LOCKED;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_ACCOUNT_UNLOCKED]               = exports.ERROR_ACCOUNT_UNLOCKED;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNKNOWN_DEVICE]                 = exports.ERROR_UNKNOWN_DEVICE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_DEVICE_SESSION_CONFLICT]        = exports.ERROR_DEVICE_SESSION_CONFLICT;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_SERVICE_TEMP_UNAVAILABLE]       = exports.ERROR_SERVICE_TEMP_UNAVAILABLE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNKNOWN_ERROR]                  = exports.ERROR_UNKNOWN;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_NETWORK]                        = exports.ERROR_NETWORK;

// oauth
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNKNOWN_CLIENT_ID]              = exports.ERROR_UNKNOWN_CLIENT_ID;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_CLIENT_SECRET]        = exports.ERROR_INCORRECT_CLIENT_SECRET;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_REDIRECT_URI]         = exports.ERROR_INCORRECT_REDIRECT_URI;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_FXA_ASSERTION]          = exports.ERROR_INVALID_FXA_ASSERTION;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNKNOWN_CODE]                   = exports.ERROR_UNKNOWN_CODE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INCORRECT_CODE]                 = exports.ERROR_INCORRECT_CODE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_EXPIRED_CODE]                   = exports.ERROR_EXPIRED_CODE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_OAUTH_INVALID_TOKEN]            = exports.ERROR_OAUTH_INVALID_TOKEN;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_REQUEST_PARAM]          = exports.ERROR_INVALID_REQUEST_PARAM;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_RESPONSE_TYPE]          = exports.ERROR_INVALID_RESPONSE_TYPE;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_UNAUTHORIZED]                   = exports.ERROR_UNAUTHORIZED;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_FORBIDDEN]                      = exports.ERROR_FORBIDDEN;
exports.SERVER_ERRNO_TO_ERROR[exports.ERRNO_INVALID_CONTENT_TYPE]           = exports.ERROR_INVALID_CONTENT_TYPE;


// Map internal errors to more generic error classes for consumers
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ACCOUNT_ALREADY_EXISTS]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ACCOUNT_DOES_NOT_EXIST]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ACCOUNT_LOCKED]                 = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ACCOUNT_UNLOCKED]               = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ALREADY_SIGNED_IN_USER]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_DEVICE_SESSION_CONFLICT]        = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_ENDPOINT_NO_LONGER_SUPPORTED]   = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_API_VERSION]          = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_EMAIL_CASE]           = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_KEY_RETRIEVAL_METHOD] = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_LOGIN_METHOD]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_EMAIL]                  = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_AUDIENCE]               = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_AUTH_TOKEN]             = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_AUTH_TIMESTAMP]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_AUTH_NONCE]             = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_BODY_PARAMETERS]        = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_PASSWORD]               = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_VERIFICATION_CODE]      = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_REFRESH_AUTH_VALUE]     = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_REQUEST_SIGNATURE]      = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INTERNAL_INVALID_USER]          = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_MISSING_BODY_PARAMETERS]        = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_MISSING_CONTENT_LENGTH]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_NO_TOKEN_SESSION]               = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_NO_SILENT_REFRESH_AUTH]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_NOT_VALID_JSON_BODY]            = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_PERMISSION_DENIED]              = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_REQUEST_BODY_TOO_LARGE]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UNKNOWN_DEVICE]                 = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UNVERIFIED_ACCOUNT]             = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UI_ERROR]                       = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UI_REQUEST]                     = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_OFFLINE]                        = exports.ERROR_NETWORK;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_SERVER_ERROR]                   = exports.ERROR_NETWORK;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_TOO_MANY_CLIENT_REQUESTS]       = exports.ERROR_NETWORK;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_SERVICE_TEMP_UNAVAILABLE]       = exports.ERROR_NETWORK;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_PARSE]                          = exports.ERROR_NETWORK;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_NETWORK]                        = exports.ERROR_NETWORK;

// oauth
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_CLIENT_SECRET]        = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_REDIRECT_URI]         = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_FXA_ASSERTION]          = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UNKNOWN_CODE]                   = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INCORRECT_CODE]                 = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_EXPIRED_CODE]                   = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_OAUTH_INVALID_TOKEN]            = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_REQUEST_PARAM]          = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_RESPONSE_TYPE]          = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_UNAUTHORIZED]                   = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_FORBIDDEN]                      = exports.ERROR_AUTH_ERROR;
exports.ERROR_TO_GENERAL_ERROR_CLASS[exports.ERROR_INVALID_CONTENT_TYPE]           = exports.ERROR_AUTH_ERROR;
