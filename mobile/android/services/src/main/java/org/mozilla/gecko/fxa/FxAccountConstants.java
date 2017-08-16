/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.fxa;

import org.mozilla.gecko.AppConstants;

public class FxAccountConstants {
  public static final String GLOBAL_LOG_TAG = "FxAccounts";
  public static final String ACCOUNT_TYPE = AppConstants.MOZ_ANDROID_SHARED_FXACCOUNT_TYPE;

  // Must be a client ID allocated with "canGrant" privileges!
  public static final String OAUTH_CLIENT_ID_FENNEC = "3332a18d142636cb";

  public static final String DEFAULT_AUTH_SERVER_ENDPOINT = "https://api.accounts.firefox.com/v1";
  public static final String DEFAULT_TOKEN_SERVER_ENDPOINT = "https://token.services.mozilla.com/1.0/sync/1.5";
  public static final String DEFAULT_OAUTH_SERVER_ENDPOINT = "https://oauth.accounts.firefox.com/v1";
  public static final String DEFAULT_PROFILE_SERVER_ENDPOINT = "https://profile.accounts.firefox.com/v1";

  public static final String STAGE_AUTH_SERVER_ENDPOINT = "https://stable.dev.lcip.org/auth/v1";
  public static final String STAGE_TOKEN_SERVER_ENDPOINT = "https://stable.dev.lcip.org/syncserver/token/1.0/sync/1.5";
  public static final String STAGE_OAUTH_SERVER_ENDPOINT = "https://oauth-stable.dev.lcip.org/v1";
  public static final String STAGE_PROFILE_SERVER_ENDPOINT = "https://latest.dev.lcip.org/profile/v1";

  // Action to update on cached profile information.
  public static final String ACCOUNT_PROFILE_JSON_UPDATED_ACTION = "org.mozilla.gecko.fxa.profile.JSON.updated";

  // You must be at least 13 years old, on the day of creation, to create a Firefox Account.
  public static final int MINIMUM_AGE_TO_CREATE_AN_ACCOUNT = 13;

  // Key for avatar URI in profile JSON.
  public static final String KEY_PROFILE_JSON_AVATAR = "avatar";
  // Key for username in profile JSON.
  public static final String KEY_PROFILE_JSON_USERNAME = "displayName";

  // You must wait 15 minutes after failing an age check before trying to create a different account.
  public static final long MINIMUM_TIME_TO_WAIT_AFTER_AGE_CHECK_FAILED_IN_MILLISECONDS = 15 * 60 * 1000;

  public static final String USER_AGENT = "Firefox-Android-FxAccounts/" + AppConstants.MOZ_APP_VERSION + " (" + AppConstants.MOZ_APP_UA_NAME + ")";

  public static final String ACCOUNT_PICKLE_FILENAME = "fxa.account.json";


  /**
   * Version number of contents of SYNC_ACCOUNT_DELETED_ACTION intent.
   */
  public static final long ACCOUNT_DELETED_INTENT_VERSION = 1;

  public static final String ACCOUNT_DELETED_INTENT_VERSION_KEY = "account_deleted_intent_version";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_KEY = "account_deleted_intent_account";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_PROFILE = "account_deleted_intent_profile";
  public static final String ACCOUNT_OAUTH_SERVICE_ENDPOINT_KEY = "account_oauth_service_endpoint";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_AUTH_TOKENS = "account_deleted_intent_auth_tokens";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_SESSION_TOKEN = "account_deleted_intent_session_token";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_SERVER_URI = "account_deleted_intent_account_server_uri";
  public static final String ACCOUNT_DELETED_INTENT_ACCOUNT_DEVICE_ID = "account_deleted_intent_account_device_id";

  /**
   * This action is broadcast when an Android Firefox Account's internal state
   * is changed.
   * <p>
   * It is protected by signing-level permission PER_ACCOUNT_TYPE_PERMISSION and
   * can be received only by Firefox versions sharing the same Android Firefox
   * Account type.
   */
  public static final String ACCOUNT_STATE_CHANGED_ACTION = AppConstants.MOZ_ANDROID_SHARED_FXACCOUNT_TYPE + ".accounts.ACCOUNT_STATE_CHANGED_ACTION";

  public static final String ACTION_FXA_CONFIRM_ACCOUNT            = AppConstants.ANDROID_PACKAGE_NAME + ".ACTION_FXA_CONFIRM_ACCOUNT";
  public static final String ACTION_FXA_FINISH_MIGRATING           = AppConstants.ANDROID_PACKAGE_NAME + ".ACTION_FXA_FINISH_MIGRATING";
  public static final String ACTION_FXA_GET_STARTED                = AppConstants.ANDROID_PACKAGE_NAME + ".ACTION_FXA_GET_STARTED";
  public static final String ACTION_FXA_STATUS                     = AppConstants.ANDROID_PACKAGE_NAME + ".ACTION_FXA_STATUS";
  public static final String ACTION_FXA_UPDATE_CREDENTIALS         = AppConstants.ANDROID_PACKAGE_NAME + ".ACTION_FXA_UPDATE_CREDENTIALS";

  public static final String ENDPOINT_PREFERENCES  = "preferences";
  public static final String ENDPOINT_NOTIFICATION = "notification";
  public static final String ENDPOINT_FIRSTRUN = "firstrun";
}
