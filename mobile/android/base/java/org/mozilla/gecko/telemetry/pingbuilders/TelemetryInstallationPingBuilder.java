/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 */

package org.mozilla.gecko.telemetry.pingbuilders;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.adjust.sdk.AdjustAttribution;

import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.GeckoThread;
import org.mozilla.gecko.Locales;
import org.mozilla.gecko.util.DateUtil;
import org.mozilla.gecko.util.HardwareUtils;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class TelemetryInstallationPingBuilder extends TelemetryPingBuilder {
    private static final String LOGTAG = "InstallPingBuilder";

    public enum PingReason {
        APP_STARTED("app-started"),
        ADJUST_AVAILABLE("adjust-available");

        PingReason(String reason) {
            this.value = reason;
        }

        public final String value;
    }

    private static final String PING_TYPE = "installation";

    private static final String PREF_KEY_SEQ_NUMBER = "installationPingSeqNumber";

    private static final String REASON = "reason";
    private static final String PING_QUEUED_TIMES = "seq";
    private static final String CLIENT_ID = "client_id";
    private static final String DEVICE_ID = "device_id";
    private static final String LOCALE = "locale";
    private static final String OS_NAME = "os";
    private static final String OS_VERSION = "osversion";
    private static final String DEVICE_MANUFACTURER = "manufacturer";
    private static final String DEVICE_MODEL = "model";
    private static final String DEVICE_ABI = "arch";
    private static final String PROFILE_DATE = "profile_date";
    private static final String PING_CREATION_TIME = "created";
    private static final String TIMEZONE_OFFSET = "tz";
    private static final String APP_NAME = "app_name";
    private static final String RELEASE_CHANNEL = "channel";
    private static final String ADJUST_CAMPAIGN = "campaign";
    private static final String ADJUST_ADGROUP = "adgroup";
    private static final String ADJUST_CREATIVE = "creative";
    private static final String ADJUST_NETWORK = "network";

    public TelemetryInstallationPingBuilder() {
        super(UNIFIED_TELEMETRY_VERSION, false);
        setPayloadConstants();
    }

    @Override
    public String getDocType() {
        return PING_TYPE;
    }

    @Override
    public String[] getMandatoryFields() {
        return new String[]{
                REASON,
                PING_QUEUED_TIMES,
                CLIENT_ID,
                DEVICE_ID,
                LOCALE,
                OS_NAME,
                OS_VERSION,
                DEVICE_MANUFACTURER,
                DEVICE_MODEL,
                DEVICE_ABI,
                PROFILE_DATE,
                PING_CREATION_TIME,
                TIMEZONE_OFFSET,
                APP_NAME,
                RELEASE_CHANNEL,
        };
    }

    public @NonNull TelemetryInstallationPingBuilder setReason(@NonNull PingReason reason) {
        payload.put(REASON, reason.value);

        return this;
    }

    public @NonNull TelemetryInstallationPingBuilder setAdjustProperties(@NonNull final AdjustAttribution attribution) {
        payload.put(ADJUST_CAMPAIGN, attribution.campaign);
        payload.put(ADJUST_ADGROUP, attribution.adgroup);
        payload.put(ADJUST_CREATIVE, attribution.creative);
        payload.put(ADJUST_NETWORK, attribution.network);

        return this;
    }

    private void setPayloadConstants() {
        payload.put(PING_QUEUED_TIMES, incrementAndGetQueueTimes());
        payload.put(CLIENT_ID, getGeckoClientID());
        payload.put(DEVICE_ID, getAdvertisingId());
        payload.put(LOCALE, Locales.getLanguageTag(Locale.getDefault()));
        payload.put(OS_NAME, TelemetryPingBuilder.OS_NAME);
        payload.put(OS_VERSION, Integer.toString(Build.VERSION.SDK_INT));
        payload.put(DEVICE_MANUFACTURER, Build.MANUFACTURER);
        payload.put(DEVICE_MODEL, Build.MODEL);
        payload.put(DEVICE_ABI, HardwareUtils.getRealAbi());
        payload.put(PROFILE_DATE, getGeckoProfileCreationDate());
        payload.put(PING_CREATION_TIME, new SimpleDateFormat("yyyy-MM-dd", Locale.US).format(new Date()));
        payload.put(TIMEZONE_OFFSET, DateUtil.getTimezoneOffsetInMinutesForGivenDate(Calendar.getInstance()));
        payload.put(APP_NAME, AppConstants.MOZ_APP_BASENAME);
        payload.put(RELEASE_CHANNEL, AppConstants.MOZ_UPDATE_CHANNEL);
    }

    private @Nullable String getGeckoClientID() {
        // zero-ed Gecko profile that respects the expected format "8-4-4-4-12" chars
        String clientID = "00000000-0000-0000-0000-000000000000";
        try {
            clientID = GeckoThread.getActiveProfile().getClientId();
        } catch (Exception e) {
            Log.w(LOGTAG, "Could not get Gecko Client ID", e);
        }

        return clientID;
    }

    private @Nullable String getAdvertisingId() {
        String advertisingId = null;
        try {
            final Class<?> clazz = Class.forName("org.mozilla.gecko.advertising.AdvertisingUtil");
            final Method getAdvertisingId = clazz.getMethod("getAdvertisingId", Context.class);
            advertisingId = (String) getAdvertisingId.invoke(clazz, GeckoAppShell.getApplicationContext());
        } catch (Exception e) {
            Log.w(LOGTAG, "Could not get advertising ID", e);
        }

        return advertisingId;
    }

    private int incrementAndGetQueueTimes() {
        final SharedPreferences sharedPrefs = GeckoSharedPrefs.forProfile(GeckoAppShell.getApplicationContext());

        // 1-based, always incremented
        final int incrementedSeqNumber = sharedPrefs.getInt(PREF_KEY_SEQ_NUMBER, 0) + 1;
        sharedPrefs.edit().putInt(PREF_KEY_SEQ_NUMBER, incrementedSeqNumber).apply();

        return incrementedSeqNumber;
    }

    private int getGeckoProfileCreationDate() {
        // The method returns days since epoch. An int is enough.
        int date = 0;
        try {
            date = TelemetryActivationPingBuilder.getProfileCreationDate(
                    GeckoAppShell.getApplicationContext(),
                    GeckoThread.getActiveProfile()).intValue();
        } catch (NullPointerException e) {
            Log.w(LOGTAG, "Could not get Gecko profile creation date", e);
        }

        return date;
    }
}
