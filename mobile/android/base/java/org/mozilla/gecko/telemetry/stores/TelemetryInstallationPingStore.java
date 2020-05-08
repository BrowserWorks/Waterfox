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
import org.mozilla.gecko.telemetry.pingbuilders.TelemetryInstallationPingBuilder.PingReason;
import org.mozilla.gecko.util.FileUtils;

import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class TelemetryInstallationPingStore extends TelemetryJSONFilePingStore {
    private static final String PREF_KEY_WAS_LIGHT_PING_SENT = "wasLightInstallationPingSent";
    private static final String PREF_KEY_WAS_FULL_PING_SENT = "wasFullInstallationPingSent";
    private static final String INSTALLATION_PING_STORE_DIR = "installation_ping";
    private static final String DEFAULT_PROFILE = "default";

    public TelemetryInstallationPingStore() {
        super(getInstallationPingStoreDir(), getCurrentProfileName());
    }

    @Override
    public void onUploadAttemptComplete(@NonNull final Set<String> successfulRemoveIDs) {
        // Delete the just uploaded files
        super.onUploadAttemptComplete(successfulRemoveIDs);

        // Remember the uploads. We only wanted one of each.
        if (successfulRemoveIDs.contains(PingReason.APP_STARTED.value)) {
            setLightPingUploaded();
        }
        if (successfulRemoveIDs.contains(PingReason.ADJUST_AVAILABLE.value)) {
            setFullPingUploaded();
        }
    }

    @Override
    protected FilenameFilter getFilenameFilter() {
        return new FileUtils.FilenameWhitelistFilter(
                new HashSet<>(Arrays.asList(PingReason.APP_STARTED.value, PingReason.ADJUST_AVAILABLE.value))
        );
    }

    public void queuePingsForUpload(@NonNull final TelemetryUploadAllPingsImmediatelyScheduler scheduler) {
        scheduler.scheduleUpload(GeckoAppShell.getApplicationContext(), this);
    }

    public static boolean hasLightPingBeenUploaded() {
        return getSharedPrefs().getBoolean(PREF_KEY_WAS_LIGHT_PING_SENT, false);
    }

    public static boolean hasFullPingBeenUploaded() {
        return getSharedPrefs().getBoolean(PREF_KEY_WAS_FULL_PING_SENT, false);
    }

    private static void setLightPingUploaded() {
        getSharedPrefs().edit().putBoolean(PREF_KEY_WAS_LIGHT_PING_SENT, true).apply();
    }

    private static void setFullPingUploaded() {
        getSharedPrefs().edit().putBoolean(PREF_KEY_WAS_FULL_PING_SENT, true).apply();
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
            return new TelemetryInstallationPingStore();
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
