/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko;

import android.app.ActivityManager;
import android.app.ActivityManager.MemoryInfo;
import android.content.Context;
import android.util.Log;

import org.mozilla.gecko.util.StrictModeContext;

import java.io.File;
import java.io.FileFilter;

import java.util.regex.Pattern;

/**
 * A collection of system info values, broadly mirroring a subset of
 * nsSystemInfo. See also the constants in org.mozilla.geckoview.BuildConfig,
 * which reflect much of nsIXULAppInfo.
 */
// Normally, we'd annotate with @RobocopTarget.  Since SysInfo is compiled
// before RobocopTarget, we instead add o.m.g.SysInfo directly to the Proguard
// configuration.
public final class SysInfo {
    private static final String LOG_TAG = "GeckoSysInfo";

    // Number of bytes of /proc/meminfo to read in one go.
    private static final int MEMINFO_BUFFER_SIZE_BYTES = 256;

    // We don't mind an instant of possible duplicate work, we only wish to
    // avoid inconsistency, so we don't bother with synchronization for
    // these.
    private static volatile int cpuCount = -1;

    private static volatile int totalRAM = -1;

    /**
     * Get the number of cores on the device.
     *
     * We can't use a nice tidy API call, <a
     * href="https://stackoverflow.com/q/7962155">because they're all
     * wrong</a>. This method is based on that code.
     *
     * @return the number of CPU cores, or 1 if the number could not be
     *         determined.
     */
    @SuppressWarnings("try")
    public static int getCPUCount() {
        if (cpuCount > 0) {
            return cpuCount;
        }

        // Avoid a strict mode warning.
        try (StrictModeContext unused = StrictModeContext.allowDiskReads()) {
            return readCPUCount();
        }
    }

    private static int readCPUCount() {
        class CpuFilter implements FileFilter {
            @Override
            public boolean accept(final File pathname) {
                return Pattern.matches("cpu[0-9]+", pathname.getName());
            }
        }
        try {
            final File dir = new File("/sys/devices/system/cpu/");
            return cpuCount = dir.listFiles(new CpuFilter()).length;
        } catch (Exception e) {
            Log.w(LOG_TAG, "Assuming 1 CPU; got exception.", e);
            return cpuCount = 1;
        }
    }

    /**
     * Fetch the total memory of the device in MB.
     *
     * NB: This cannot be called before GeckoAppShell has been
     * initialized.
     *
     * @return Memory size in MB.
     */
    public static int getMemSize(final Context context) {
        if (totalRAM >= 0) {
            return totalRAM;
        }

        final MemoryInfo memInfo = new MemoryInfo();

        final ActivityManager am = (ActivityManager) context
                                   .getSystemService(Context.ACTIVITY_SERVICE);
        am.getMemoryInfo(memInfo);

        // `getMemoryInfo()` returns a value in B. Convert to MB.
        totalRAM = (int)(memInfo.totalMem / (1024 * 1024));

        Log.d(LOG_TAG, "System memory: " + totalRAM + "MB.");

        return totalRAM;
    }

    /**
     * @return the SDK version supported by this device, such as '16'.
     */
    public static int getVersion() {
        return android.os.Build.VERSION.SDK_INT;
    }

    /**
     * @return the release version string, such as "4.1.2".
     */
    public static String getReleaseVersion() {
        return android.os.Build.VERSION.RELEASE;
    }

    /**
     * @return the kernel version string, such as "3.4.10-geb45596".
     */
    public static String getKernelVersion() {
        return System.getProperty("os.version", "");
    }

    /**
     * @return the device manufacturer, such as "HTC".
     */
    public static String getManufacturer() {
        return android.os.Build.MANUFACTURER;
    }

    /**
     * @return the device name, such as "HTC One".
     */
    public static String getDevice() {
        // No, not android.os.Build.DEVICE.
        return android.os.Build.MODEL;
    }

    /**
     * @return the Android "hardware" identifier, such as "m7".
     */
    public static String getHardware() {
        return android.os.Build.HARDWARE;
    }

    /**
     * @return the system OS name. Hardcoded to "Android".
     */
    public static String getName() {
        // We deliberately differ from PR_SI_SYSNAME, which is "Linux".
        return "Android";
    }

    /**
     * @return the Android architecture string, including ABI.
     */
    public static String getArchABI() {
        // Android likes to include the ABI, too ("armeabiv7"), so we
        // differ to add value.
        return android.os.Build.CPU_ABI;
    }
}
