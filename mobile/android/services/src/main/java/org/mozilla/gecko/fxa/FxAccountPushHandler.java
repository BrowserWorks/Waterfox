package org.mozilla.gecko.fxa;

import android.accounts.Account;
import android.accounts.AccountManager;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.mozilla.gecko.fxa.authenticator.AndroidFxAccount;
import org.mozilla.gecko.util.GeckoBundle;

public class FxAccountPushHandler {
    private static final String LOG_TAG = "FxAccountPush";

    private static final String COMMAND_DEVICE_DISCONNECTED = "fxaccounts:device_disconnected";
    private static final String COMMAND_COLLECTION_CHANGED = "sync:collection_changed";

    private static final String CLIENTS_COLLECTION = "clients";

    // Forbid instantiation
    private FxAccountPushHandler() {}

    public static void handleFxAPushMessage(Context context, GeckoBundle bundle) {
        Log.i(LOG_TAG, "Handling FxA Push Message");
        String rawMessage = bundle.getString("message");
        JSONObject message = null;
        if (!TextUtils.isEmpty(rawMessage)) {
            try {
                message = new JSONObject(rawMessage);
            } catch (JSONException e) {
                Log.e(LOG_TAG, "Could not parse JSON", e);
                return;
            }
        }
        if (message == null) {
            // An empty body means we should check the verification state of the account (FxA sends this
            // when the account email is verified for example).
            // See notifyUpdate in https://github.com/mozilla/fxa-auth-server/blob/master/lib/push.js
            handleVerification(context);
            return;
        }
        try {
            String command = message.getString("command");
            JSONObject data = message.getJSONObject("data");
            switch (command) {
                case COMMAND_DEVICE_DISCONNECTED:
                    handleDeviceDisconnection(context, data);
                    break;
                case COMMAND_COLLECTION_CHANGED:
                    handleCollectionChanged(context, data);
                    break;
                default:
                    Log.d(LOG_TAG, "No handler defined for FxA Push command " + command);
                    break;
            }
        } catch (JSONException e) {
            Log.e(LOG_TAG, "Error while handling FxA push notification", e);
        }
    }

    private static void handleVerification(Context context) {
        AndroidFxAccount fxAccount = AndroidFxAccount.fromContext(context);
        if (fxAccount == null) {
            Log.e(LOG_TAG, "The Android account does not exist anymore");
            return;
        }
        Log.i(LOG_TAG, "Received 'accountVerified' push event, requesting immediate sync");
        // This will trigger an email verification check and a sync.
        fxAccount.requestImmediateSync(null, null);
    }

    private static void handleCollectionChanged(Context context, JSONObject data) throws JSONException {
        JSONArray collections = data.getJSONArray("collections");
        int len = collections.length();
        for (int i = 0; i < len; i++) {
            if (collections.getString(i).equals(CLIENTS_COLLECTION)) {
                final Account account = FirefoxAccounts.getFirefoxAccount(context);
                if (account == null) {
                    Log.e(LOG_TAG, "The account does not exist anymore");
                    return;
                }
                final AndroidFxAccount fxAccount = new AndroidFxAccount(context, account);
                fxAccount.requestImmediateSync(new String[] { CLIENTS_COLLECTION }, null);
                return;
            }
        }
    }

    private static void handleDeviceDisconnection(Context context, JSONObject data) throws JSONException {
        final Account account = FirefoxAccounts.getFirefoxAccount(context);
        if (account == null) {
            Log.e(LOG_TAG, "The account does not exist anymore");
            return;
        }
        final AndroidFxAccount fxAccount = new AndroidFxAccount(context, account);
        if (!fxAccount.getDeviceId().equals(data.getString("id"))) {
            return;
        }
        AccountManager.get(context).removeAccount(account, null, null);
    }
}
