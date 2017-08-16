/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.fxa.receivers;

import android.app.IntentService;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import org.mozilla.gecko.background.common.log.Logger;
import org.mozilla.gecko.background.fxa.FxAccountClient20;
import org.mozilla.gecko.background.fxa.FxAccountClientException;
import org.mozilla.gecko.background.fxa.oauth.FxAccountAbstractClient;
import org.mozilla.gecko.background.fxa.oauth.FxAccountAbstractClientException.FxAccountAbstractClientRemoteException;
import org.mozilla.gecko.background.fxa.oauth.FxAccountOAuthClient10;
import org.mozilla.gecko.db.BrowserContract;
import org.mozilla.gecko.fxa.FxAccountConstants;
import org.mozilla.gecko.fxa.authenticator.AndroidFxAccount;
import org.mozilla.gecko.fxa.sync.FxAccountNotificationManager;
import org.mozilla.gecko.fxa.sync.FxAccountSyncAdapter;
import org.mozilla.gecko.sync.ExtendedJSONObject;
import org.mozilla.gecko.sync.repositories.android.ClientsDatabase;
import org.mozilla.gecko.sync.repositories.android.FennecTabsRepository;

import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * A background service to clean up after a Firefox Account is deleted.
 * <p>
 * Note that we specifically handle deleting the pickle file using a Service and a
 * BroadcastReceiver, rather than a background thread, to allow channels sharing a Firefox account
 * to delete their respective pickle files (since, if one remains, the account will be restored
 * when that channel is used).
 */
public class FxAccountDeletedService extends IntentService {
  public static final String LOG_TAG = FxAccountDeletedService.class.getSimpleName();

  public FxAccountDeletedService() {
    super(LOG_TAG);
  }

  @Override
  protected void onHandleIntent(final Intent intent) {
    // We have an in-memory accounts cache which we use for a variety of tasks; it needs to be cleared.
    // It should be fine to invalidate it before doing anything else, as the tasks below do not rely
    // on this data.
    AndroidFxAccount.invalidateCaches();

    // Intent can, in theory, be null. Bug 1025937.
    if (intent == null) {
      Logger.debug(LOG_TAG, "Short-circuiting on null intent.");
      return;
    }

    final Context context = this;

    long intentVersion = intent.getLongExtra(
        FxAccountConstants.ACCOUNT_DELETED_INTENT_VERSION_KEY, 0);
    long expectedVersion = FxAccountConstants.ACCOUNT_DELETED_INTENT_VERSION;
    if (intentVersion != expectedVersion) {
      Logger.warn(LOG_TAG, "Intent malformed: version " + intentVersion + " given but " +
          "version " + expectedVersion + "expected. Not cleaning up after deleted Account.");
      return;
    }

    // Android Account name, not Sync encoded account name.
    final String accountName = intent.getStringExtra(
        FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_KEY);
    if (accountName == null) {
      Logger.warn(LOG_TAG, "Intent malformed: no account name given. Not cleaning up after " +
          "deleted Account.");
      return;
    }

    clearRemoteDevicesList(intent, context);

    // Delete current device the from FxA devices list.
    deleteFxADevice(intent);

    // Fire up gecko and unsubscribe push
    final Intent geckoIntent = new Intent();
    geckoIntent.setAction("create-services");
    geckoIntent.setClassName(context, "org.mozilla.gecko.GeckoService");
    geckoIntent.putExtra("category", "android-push-service");
    geckoIntent.putExtra("data", "android-fxa-unsubscribe");
    geckoIntent.putExtra("org.mozilla.gecko.intent.PROFILE_NAME",
            intent.getStringExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_PROFILE));
    context.startService(geckoIntent);

    // Delete client database and non-local tabs.
    Logger.info(LOG_TAG, "Deleting the entire Fennec clients database and non-local tabs");
    FennecTabsRepository.deleteNonLocalClientsAndTabs(context);


    // Clear Firefox Sync client tables.
    try {
      Logger.info(LOG_TAG, "Deleting the Firefox Sync clients database.");
      ClientsDatabase db = null;
      try {
        db = new ClientsDatabase(context);
        db.wipeClientsTable();
        db.wipeCommandsTable();
      } finally {
        if (db != null) {
          db.close();
        }
      }
    } catch (Exception e) {
      Logger.warn(LOG_TAG, "Got exception deleting the Firefox Sync clients database; ignoring.", e);
    }

    // Remove any displayed notifications.
    new FxAccountNotificationManager(FxAccountSyncAdapter.NOTIFICATION_ID).clear(context);

    // Bug 1147275: Delete cached oauth tokens. There's no way to query all
    // oauth tokens from Android, so this is tricky to do comprehensively. We
    // can query, individually, for specific oauth tokens to delete, however.
    final String oauthServerURI = intent.getStringExtra(FxAccountConstants.ACCOUNT_OAUTH_SERVICE_ENDPOINT_KEY);
    final String[] tokens = intent.getStringArrayExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_AUTH_TOKENS);
    if (oauthServerURI != null && tokens != null) {
      final Executor directExecutor = new Executor() {
        @Override
        public void execute(Runnable runnable) {
          runnable.run();
        }
      };

      final FxAccountOAuthClient10 oauthClient = new FxAccountOAuthClient10(oauthServerURI, directExecutor);

      for (String token : tokens) {
        if (token == null) {
          Logger.error(LOG_TAG, "Cached OAuth token is null; should never happen.  Ignoring.");
          continue;
        }
        try {
          oauthClient.deleteToken(token, new FxAccountAbstractClient.RequestDelegate<Void>() {
            @Override
            public void handleSuccess(Void result) {
              Logger.info(LOG_TAG, "Successfully deleted cached OAuth token.");
            }

            @Override
            public void handleError(Exception e) {
              Logger.error(LOG_TAG, "Failed to delete cached OAuth token; ignoring.", e);
            }

            @Override
            public void handleFailure(FxAccountAbstractClientRemoteException e) {
              Logger.error(LOG_TAG, "Exception during cached OAuth token deletion; ignoring.", e);
            }
          });
        } catch (Exception e) {
          Logger.error(LOG_TAG, "Exception during cached OAuth token deletion; ignoring.", e);
        }
      }
    } else {
      Logger.error(LOG_TAG, "Cached OAuth server URI is null or cached OAuth tokens are null; ignoring.");
    }
  }

  private void clearRemoteDevicesList(Intent intent, Context context) {
    final Uri remoteDevicesUriWithProfile = BrowserContract.RemoteDevices.CONTENT_URI
            .buildUpon()
            .appendQueryParameter(BrowserContract.PARAM_PROFILE,
                                  intent.getStringExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_PROFILE))
            .build();
    ContentResolver cr = context.getContentResolver();

    cr.delete(remoteDevicesUriWithProfile, null, null);
  }

  // Remove our current device from the FxA device list.
  private void deleteFxADevice(Intent intent) {
    final byte[] sessionToken = intent.getByteArrayExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_SESSION_TOKEN);
    if (sessionToken == null) {
      Logger.warn(LOG_TAG, "Empty session token, skipping FxA device destruction.");
      return;
    }
    final String deviceId = intent.getStringExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_DEVICE_ID);
    if (TextUtils.isEmpty(deviceId)) {
      Logger.warn(LOG_TAG, "Empty FxA device ID, skipping FxA device destruction.");
      return;
    }

    ExecutorService executor = Executors.newSingleThreadExecutor(); // Not called often, it's okay to spawn another thread
    final String accountServerURI = intent.getStringExtra(FxAccountConstants.ACCOUNT_DELETED_INTENT_ACCOUNT_SERVER_URI);
    final FxAccountClient20 fxAccountClient = new FxAccountClient20(accountServerURI, executor);
    fxAccountClient.destroyDevice(sessionToken, deviceId, new FxAccountClient20.RequestDelegate<ExtendedJSONObject>() {
      @Override
      public void handleError(Exception e) {
        Logger.error(LOG_TAG, "Error while trying to delete the FxA device; ignoring.", e);
      }

      @Override
      public void handleFailure(FxAccountClientException.FxAccountClientRemoteException e) {
        Logger.error(LOG_TAG, "Exception while trying to delete the FxA device; ignoring.", e);
      }

      @Override
      public void handleSuccess(ExtendedJSONObject result) {
        Logger.info(LOG_TAG, "Successfully deleted the FxA device.");
      }
    });
  }
}
