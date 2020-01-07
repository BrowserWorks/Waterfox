/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.activitystream.homepanel.stream;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.view.View;

import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.R;
import org.mozilla.gecko.Telemetry;
import org.mozilla.gecko.TelemetryContract;
import org.mozilla.gecko.activitystream.homepanel.ActivityStreamPanel;
import org.mozilla.gecko.home.HomePager.OnUrlOpenListener;

import java.util.EnumSet;

public class FirefoxPromoBannerRow extends StreamViewHolder {
    public static final @LayoutRes int LAYOUT_ID = R.layout.activity_stream_promo_banner;
    public static final String FIREFOX_PROMO_OPEN_EVENT = "firefox_promo_open";
    public static final String FIREFOX_PROMO_DISMISS_EVENT = "firefox_promo_dismiss";

    private static final String WEBSITE_PROMO_URL = "https://blog.mozilla.org/firefox/firefox-android-new-features/";

    public FirefoxPromoBannerRow(@NonNull final View itemView, @NonNull final OnUrlOpenListener onUrlOpenListener) {
        super(itemView);

        itemView.findViewById(R.id.banner_action).setOnClickListener(__ -> {
            Telemetry.sendUIEvent(TelemetryContract.Event.ACTION, TelemetryContract.Method.BUTTON, FIREFOX_PROMO_OPEN_EVENT);
            onUrlOpenListener.onUrlOpen(WEBSITE_PROMO_URL, EnumSet.noneOf(OnUrlOpenListener.Flags.class));
            dismissBanner();
        });

        itemView.findViewById(R.id.banner_dismiss).setOnClickListener(__ -> {
            Telemetry.sendUIEvent(TelemetryContract.Event.ACTION, TelemetryContract.Method.BUTTON, FIREFOX_PROMO_DISMISS_EVENT);
            dismissBanner();
        });
    }

    @SuppressLint("ApplySharedPref")
    private void dismissBanner() {
        final SharedPreferences sharedPreferences = GeckoSharedPrefs.forProfile(itemView.getContext());
        //Note: In ActivityStreamHomeFragment we have a prefs listener for this value.
        //We commit asap in order to reload our recyclerview as soon as the user dismissed the row.
        sharedPreferences.edit().putBoolean(ActivityStreamPanel.PREF_USER_DISMISSED_PROMO_BANNER, true).commit();
    }
}
