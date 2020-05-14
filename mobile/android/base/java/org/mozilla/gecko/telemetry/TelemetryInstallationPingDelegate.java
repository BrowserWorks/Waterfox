/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 */

package org.mozilla.gecko.telemetry;

import android.support.annotation.NonNull;
import android.util.Log;

import com.adjust.sdk.AdjustAttribution;

import org.mozilla.gecko.BrowserApp;
import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.adjust.AttributionHelperListener;
import org.mozilla.gecko.delegates.BrowserAppDelegate;
import org.mozilla.gecko.telemetry.pingbuilders.TelemetryInstallationPingBuilder;
import org.mozilla.gecko.telemetry.pingbuilders.TelemetryInstallationPingBuilder.PingReason;
import org.mozilla.gecko.telemetry.schedulers.TelemetryUploadAllPingsImmediatelyScheduler;
import org.mozilla.gecko.telemetry.stores.TelemetryInstallationPingStore;
import org.mozilla.gecko.util.ThreadUtils;

import java.io.IOException;

public class TelemetryInstallationPingDelegate
        extends BrowserAppDelegate
        implements AttributionHelperListener {

    private static final String LOGTAG = "InstallPingDelegate";

    @Override
    public void onStart(BrowserApp browserApp) {
        if (!TelemetryUploadService.isUploadEnabledByAppConfig(browserApp)) {
            return;
        }

        // Keep everything off of main thread. Don't need to burden it with telemetry.
        ThreadUtils.postToBackgroundThread(() -> {
            TelemetryInstallationPingStore store;
            try {
                store = new TelemetryInstallationPingStore();
            } catch (IllegalStateException e) {
                // The store constructor might throw an IllegalStateException if it cannot access
                // the store directory.
                // This has been observed on CI mochitests, not sure about if this would also reproduce
                // in the real world.
                // We'll retry at the next app start.
                Log.w(LOGTAG, "Cannot access ping's storage directory. Will retry later");
                return;
            }

            // First allow for stored pings to be re-uploaded if the previous upload did not succeed.
            // (A successful upload would delete the pings persisted to disk)
            if (store.getCount() != 0) {
                store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
            }

            // Only need one of each pings. Check if we should create a new one.
            if (!TelemetryInstallationPingStore.hasLightPingBeenQueuedForUpload()) {
                TelemetryOutgoingPing ping = new TelemetryInstallationPingBuilder()
                        .setReason(PingReason.APP_STARTED)
                        .build();

                try {
                    store.storePing(ping);
                    store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
                    store.setLightPingQueuedForUpload();
                } catch (IOException e) {
                    // #storePing() might throw in the process of persisting to disk.
                    // Nothing to do. At the next app start we'll try again to create a new ping,
                    // store and upload that.
                    Log.w(LOGTAG, "Could not store ping. Will try again later");
                }
            }
        });
    }

    @Override
    public void onAttributionChanged(@NonNull final AdjustAttribution attribution) {
        if (!TelemetryUploadService.isUploadEnabledByAppConfig(GeckoAppShell.getApplicationContext())) {
            return;
        }

        // Keep everything off of main thread. Don't need to burden it with telemetry.
        ThreadUtils.postToBackgroundThread(() -> {
            TelemetryInstallationPingStore store;
            try {
                store = new TelemetryInstallationPingStore();
            } catch (IllegalStateException e) {
                // The store constructor might throw an IllegalStateException if it cannot access
                // the store directory.
                // This has been observed on CI mochitests, not sure about if this would also reproduce
                // in the real world.
                // Since the attributionChanged callback only fire once IRL this would mean we won't
                // be sending the "adjust-available" ping.
                Log.w(LOGTAG, "Cannot access ping's storage directory. " +
                        "Cannot send the \"adjust-available\" ping");
                return;
            }

            // First allow for stored pings to be re-uploaded if the previous upload did not succeed.
            // (A successful upload would delete the pings persisted to disk)
            if (store.getCount() != 0) {
                store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
            }

            // It may be possible that in the app's lifetime Adjust campaigns are changed.
            // Sanity check that the "adjust-available" ping has not yet been send.
            if (!TelemetryInstallationPingStore.hasFullPingBeenQueuedForUpload()) {
                TelemetryOutgoingPing ping = new TelemetryInstallationPingBuilder()
                        .setReason(PingReason.ADJUST_AVAILABLE)
                        .setAdjustProperties(attribution)
                        .build();

                try {
                    store.storePing(ping);
                    store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
                    store.setFullPingQueuedForUpload();
                } catch (IOException e) {
                    // #storePing() might throw in the process of persisting to disk.
                    // Nothing we can do. The "adjust-available" ping is lost.
                    Log.w(LOGTAG, "Could not store the \"adjust-available\" ping");
                }
            }
        });
    }
}
