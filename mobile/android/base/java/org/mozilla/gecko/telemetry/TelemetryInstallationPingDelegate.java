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

        if (!TelemetryInstallationPingStore.hasLightPingBeenUploaded()) {
            ThreadUtils.postToBackgroundThread(() -> {
                TelemetryInstallationPingStore store = new TelemetryInstallationPingStore();
                TelemetryOutgoingPing ping = new TelemetryInstallationPingBuilder()
                        .setReason(PingReason.APP_STARTED)
                        .build();

                try {
                    store.storePing(ping.getPayload(), PingReason.APP_STARTED.value, ping.getURLPath());
                    store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
                } catch (IOException e) {
                    // #storePing() might throw. Nothing to do. Will try again later.
                    Log.w(LOGTAG, "Could not store ping. Will try again later");
                }
            });
        }
    }

    @Override
    public void onAttributionChanged(@NonNull final AdjustAttribution attribution) {
        if (!TelemetryUploadService.isUploadEnabledByAppConfig(GeckoAppShell.getApplicationContext())) {
            return;
        }

        if (!TelemetryInstallationPingStore.hasFullPingBeenUploaded()) {
            ThreadUtils.postToBackgroundThread(() -> {
                TelemetryInstallationPingStore store = new TelemetryInstallationPingStore();
                TelemetryOutgoingPing ping = new TelemetryInstallationPingBuilder()
                        .setReason(PingReason.ADJUST_AVAILABLE)
                        .setAdjustProperties(attribution)
                        .build();

                try {
                    store.storePing(ping.getPayload(), PingReason.ADJUST_AVAILABLE.value, ping.getURLPath());
                    store.queuePingsForUpload(new TelemetryUploadAllPingsImmediatelyScheduler());
                } catch (IOException e) {
                    // #storePing() might throw. Nothing to do. Will try again later.
                    Log.w(LOGTAG, "Could not store ping. Will try again later");
                }
            });
        }
    }
}
