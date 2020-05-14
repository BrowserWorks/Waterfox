/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 */

package org.mozilla.gecko.telemetry.stores;

import android.content.SharedPreferences;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.annotation.NonNull;

import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.GeckoThread;
import org.mozilla.gecko.telemetry.schedulers.TelemetryUploadAllPingsImmediatelyScheduler;

import java.io.File;

public class TelemetryInstallationPingStore extends TelemetryJSONFilePingStore {
    private static final String PREF_KEY_WAS_LIGHT_PING_STORED = "wasLightInstallationPingStored";
    private static final String PREF_KEY_WAS_FULL_PING_STORED = "wasFullInstallationPingStored";
    private static final String INSTALLATION_PING_STORE_DIR = "installation_ping";
    private static final String DEFAULT_PROFILE = "default";

    public TelemetryInstallationPingStore() {
        super(getInstallationPingStoreDir(), getCurrentProfileName());
    }

    public TelemetryInstallationPingStore(@NonNull final File storeDir, @NonNull final String profileName) {
        super(storeDir, profileName);
    }

    @Override
    public void maybePrunePings() {
        // no-op
        // Successfully uploaded pings will be deleted in onUploadAttemptComplete(..).
    }

    public void queuePingsForUpload(@NonNull final TelemetryUploadAllPingsImmediatelyScheduler scheduler) {
        scheduler.scheduleUpload(GeckoAppShell.getApplicationContext(), this);
    }

    public static boolean hasLightPingBeenQueuedForUpload() {
        return getSharedPrefs().getBoolean(PREF_KEY_WAS_LIGHT_PING_STORED, false);
    }

    public static boolean hasFullPingBeenQueuedForUpload() {
        return getSharedPrefs().getBoolean(PREF_KEY_WAS_FULL_PING_STORED, false);
    }

    public void setLightPingQueuedForUpload() {
        getSharedPrefs().edit().putBoolean(PREF_KEY_WAS_LIGHT_PING_STORED, true).apply();
    }

    public void setFullPingQueuedForUpload() {
        getSharedPrefs().edit().putBoolean(PREF_KEY_WAS_FULL_PING_STORED, true).apply();
    }

    private static @NonNull SharedPreferences getSharedPrefs() {
        return GeckoSharedPrefs.forProfile(GeckoAppShell.getApplicationContext());
    }

    private static @NonNull File getInstallationPingStoreDir() {
        return GeckoAppShell.getApplicationContext().getFileStreamPath(INSTALLATION_PING_STORE_DIR);
    }

    private static @NonNull String getCurrentProfileName() {
        return GeckoThread.getActiveProfile() != null ?
                GeckoThread.getActiveProfile().getName() :
                DEFAULT_PROFILE;
    }


    // Class needs to be Parcelable as it will be passed through Intents
    public static final Parcelable.Creator<TelemetryInstallationPingStore> CREATOR =
            new Parcelable.Creator<TelemetryInstallationPingStore>() {

        @Override
        public TelemetryInstallationPingStore createFromParcel(final Parcel source) {
            final String storeDirPath = source.readString();
            final String profileName = source.readString();
            return new TelemetryInstallationPingStore(new File(storeDirPath), profileName);
        }

        @Override
        public TelemetryInstallationPingStore[] newArray(final int size) {
            return new TelemetryInstallationPingStore[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(final Parcel dest, final int flags) {
        super.writeToParcel(dest, flags);
    }
}
