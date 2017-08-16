/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.distribution;

import org.mozilla.gecko.AdjustConstants;
import org.mozilla.gecko.annotation.RobocopTarget;
import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.EventDispatcher;
import org.mozilla.gecko.util.GeckoBundle;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;

public class ReferrerReceiver extends BroadcastReceiver {
    private static final String LOGTAG = "GeckoReferrerReceiver";

    private static final String ACTION_INSTALL_REFERRER = "com.android.vending.INSTALL_REFERRER";

    // Sent when we're done.
    @RobocopTarget
    public static final String ACTION_REFERRER_RECEIVED = "org.mozilla.fennec.REFERRER_RECEIVED";

    /**
     * If the install intent has this source, it is a Mozilla specific or over
     * the air distribution referral.  We'll track the campaign ID using
     * Mozilla's metrics systems.
     *
     * If the install intent has a source different than this one, it is a
     * referral from an advertising network.  We may track these campaigns using
     * third-party tracking and metrics systems.
     */
    private static final String MOZILLA_UTM_SOURCE = "mozilla";

    /**
     * If the install intent has this source, it is a referrer intent using our
     * Adjust ID. It's treated as OTA and tracked using Adjust and
     * Mozilla's metrics systems.
     */
    private static final String MOZILLA_ADJUST_SOURCE = "adjust_store";

    /**
     * If the install intent has this campaign, we'll load the specified distribution.
     */
    private static final String DISTRIBUTION_UTM_CAMPAIGN = "distribution";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.v(LOGTAG, "Received intent " + intent);
        if (!ACTION_INSTALL_REFERRER.equals(intent.getAction())) {
            // This should never happen.
            return;
        }

        // Track the referrer object for distribution handling.
        ReferrerDescriptor referrer = new ReferrerDescriptor(intent.getStringExtra("referrer"));

        if (!TextUtils.equals(referrer.source, MOZILLA_UTM_SOURCE) &&
            !TextUtils.equals(referrer.source, MOZILLA_ADJUST_SOURCE)) {
            // Allow the Adjust handler to process the intent.
            try {
                AdjustConstants.getAdjustHelper().onReceive(context, intent);
            } catch (Exception e) {
                Log.e(LOGTAG, "Got exception in Adjust's onReceive; ignoring referrer intent.", e);
            }
            return;
        }

        if (TextUtils.equals(referrer.campaign, DISTRIBUTION_UTM_CAMPAIGN)) {
            Distribution.onReceivedReferrer(context, referrer);
            // We want Adjust information for OTA distributions as well
            try {
                AdjustConstants.getAdjustHelper().onReceive(context, intent);
            } catch (Exception e) {
                Log.e(LOGTAG, "Got exception in Adjust's onReceive for distribution.", e);
            }
        } else {
            Log.d(LOGTAG, "Not downloading distribution: non-matching campaign.");
            // If this is a Mozilla campaign, pass the campaign along to Gecko.
            // It'll pretend to be a "playstore" distribution for BLP purposes.
            propagateMozillaCampaign(referrer);
        }

        // Broadcast a secondary, local intent to allow test code to respond.
        final Intent receivedIntent = new Intent(ACTION_REFERRER_RECEIVED);
        LocalBroadcastManager.getInstance(context).sendBroadcast(receivedIntent);
    }


    private void propagateMozillaCampaign(ReferrerDescriptor referrer) {
        if (referrer.campaign == null) {
            return;
        }

        final GeckoBundle data = new GeckoBundle(2);
        data.putString("id", "playstore");
        data.putString("version", referrer.campaign);
        // Try to make sure the prefs are written as a group.
        EventDispatcher.getInstance().dispatch("Campaign:Set", data);
    }
}
