/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.util;

import android.content.Context;
import android.content.res.Configuration;
import android.os.Build;
import android.system.Os;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public final class HardwareUtils {
    private static final String LOGTAG = "GeckoHardwareUtils";

    private static volatile boolean sInited;

    // These are all set once, during init.
    private static volatile boolean sIsLargeTablet;
    private static volatile boolean sIsSmallTablet;

    private static volatile File sLibDir;
    private static volatile int sMachineType = -1;

    private HardwareUtils() {
    }

    public static void init(final Context context) {
        if (sInited) {
            return;
        }

        // Pre-populate common flags from the context.
        final int screenLayoutSize = context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK;
        if (screenLayoutSize == Configuration.SCREENLAYOUT_SIZE_XLARGE) {
            sIsLargeTablet = true;
        } else if (screenLayoutSize == Configuration.SCREENLAYOUT_SIZE_LARGE) {
            sIsSmallTablet = true;
        }

        sLibDir = new File(context.getApplicationInfo().nativeLibraryDir);
        sInited = true;
    }

    public static boolean isTablet() {
        return sIsLargeTablet || sIsSmallTablet;
    }

    private static String getPreferredAbi() {
        String abi = null;
        if (Build.VERSION.SDK_INT >= 21) {
            abi = Build.SUPPORTED_ABIS[0];
        }
        if (abi == null) {
            abi = Build.CPU_ABI;
        }
        return abi;
    }

    public static boolean isARMSystem() {
        return "armeabi-v7a".equals(getPreferredAbi());
    }

    public static boolean isARM64System() {
        // 64-bit support was introduced in 21.
        return "arm64-v8a".equals(getPreferredAbi());
    }

    public static boolean isX86System() {
        if ("x86".equals(getPreferredAbi())) {
            return true;
        }
        if (Build.VERSION.SDK_INT >= 21) {
            // On some devices we have to look into the kernel release string.
            try {
                return Os.uname().release.contains("-x86_");
            } catch (final Exception e) {
                Log.w(LOGTAG, "Cannot get uname", e);
            }
        }
        return false;
    }

    public static String getRealAbi() {
        if (isX86System() && isARMSystem()) {
            // Some x86 devices try to make us believe we're ARM,
            // in which case CPU_ABI is not reliable.
            return "x86";
        }
        return getPreferredAbi();
    }

    private static final int ELF_MACHINE_UNKNOWN = 0;
    private static final int ELF_MACHINE_X86 = 0x03;
    private static final int ELF_MACHINE_X86_64 = 0x3e;
    private static final int ELF_MACHINE_ARM = 0x28;
    private static final int ELF_MACHINE_AARCH64 = 0xb7;

    private static int readElfMachineType(final File file) {
        try (final FileInputStream is = new FileInputStream(file)) {
            final byte[] buf = new byte[19];
            int count = 0;
            while (count != buf.length) {
                count += is.read(buf, count, buf.length - count);
            }

            int machineType = buf[18];
            if (machineType < 0) {
                machineType += 256;
            }

            return machineType;
        } catch (FileNotFoundException e) {
            Log.w(LOGTAG, String.format("Failed to open %s", file.getAbsolutePath()));
            return ELF_MACHINE_UNKNOWN;
        } catch (IOException e) {
            Log.w(LOGTAG, "Failed to read library", e);
            return ELF_MACHINE_UNKNOWN;
        }
    }

    private static String machineTypeToString(final int machineType) {
        switch (machineType) {
            case ELF_MACHINE_X86:
                return "x86";
            case ELF_MACHINE_X86_64:
                return "x86_64";
            case ELF_MACHINE_ARM:
                return "arm";
            case ELF_MACHINE_AARCH64:
                return "aarch64";
            case ELF_MACHINE_UNKNOWN:
            default:
                return String.format("unknown (0x%x)", machineType);
        }
    }

    private static void initMachineType() {
        if (sMachineType >= 0) {
            return;
        }

        sMachineType = readElfMachineType(new File(sLibDir, System.mapLibraryName("mozglue")));
    }

    /**
     * @return The ABI of the libraries installed for this app.
     */
    public static String getLibrariesABI() {
        initMachineType();

        return machineTypeToString(sMachineType);
    }
}
