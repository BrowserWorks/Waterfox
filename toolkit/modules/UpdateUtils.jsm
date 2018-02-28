/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["UpdateUtils"];

const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/AppConstants.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/ctypes.jsm");
Cu.importGlobalProperties(["fetch"]); /* globals fetch */

const FILE_UPDATE_LOCALE                  = "update.locale";
const PREF_APP_DISTRIBUTION               = "distribution.id";
const PREF_APP_DISTRIBUTION_VERSION       = "distribution.version";
const PREF_APP_UPDATE_CUSTOM              = "app.update.custom";


this.UpdateUtils = {
  _locale: undefined,

  /**
   * Read the update channel from defaults only.  We do this to ensure that
   * the channel is tightly coupled with the application and does not apply
   * to other instances of the application that may use the same profile.
   *
   * @param [optional] aIncludePartners
   *        Whether or not to include the partner bits. Default: true.
   */
  getUpdateChannel(aIncludePartners = true) {
    let defaults = Services.prefs.getDefaultBranch(null);
    let channel = defaults.getCharPref("app.update.channel",
                                       AppConstants.MOZ_UPDATE_CHANNEL);

    if (aIncludePartners) {
      try {
        let partners = Services.prefs.getChildList("app.partner.").sort();
        if (partners.length) {
          channel += "-cck";
          partners.forEach(function(prefName) {
            channel += "-" + Services.prefs.getCharPref(prefName);
          });
        }
      } catch (e) {
        Cu.reportError(e);
      }
    }

    return channel;
  },

  get UpdateChannel() {
    return this.getUpdateChannel();
  },

  /**
   * Formats a URL by replacing %...% values with OS, build and locale specific
   * values.
   *
   * @param  url
   *         The URL to format.
   * @return The formatted URL.
   */
  async formatUpdateURL(url) {
    const locale = await this.getLocale();

    return url.replace(/%(\w+)%/g, (match, name) => {
      switch (name) {
        case "PRODUCT":
          return Services.appinfo.name;
        case "VERSION":
          return Services.appinfo.version;
        case "BUILD_ID":
          return Services.appinfo.appBuildID;
        case "BUILD_TARGET":
          return Services.appinfo.OS + "_" + this.ABI;
        case "OS_VERSION":
          return this.OSVersion;
        case "LOCALE":
          return locale;
        case "CHANNEL":
          return this.UpdateChannel;
        case "PLATFORM_VERSION":
          return Services.appinfo.platformVersion;
        case "SYSTEM_CAPABILITIES":
          return getSystemCapabilities();
        case "CUSTOM":
          return Services.prefs.getStringPref(PREF_APP_UPDATE_CUSTOM, "");
        case "DISTRIBUTION":
          return getDistributionPrefValue(PREF_APP_DISTRIBUTION);
        case "DISTRIBUTION_VERSION":
          return getDistributionPrefValue(PREF_APP_DISTRIBUTION_VERSION);
      }
      return match;
    }).replace(/\+/g, "%2B");
  },

  /**
   * Gets the locale from the update.locale file for replacing %LOCALE% in the
   * update url. The update.locale file can be located in the application
   * directory or the GRE directory with preference given to it being located in
   * the application directory.
   */
  async getLocale() {
    if (this._locale !== undefined) {
      return this._locale;
    }

    for (let res of ["app", "gre"]) {
      const url = "resource://" + res + "/" + FILE_UPDATE_LOCALE;
      let data;
      try {
        data = await fetch(url);
      } catch (e) {
        continue;
      }
      const locale = await data.text();
      if (locale) {
        return this._locale = locale.trim();
      }
    }

    Cu.reportError(FILE_UPDATE_LOCALE + " file doesn't exist in either the " +
                   "application or GRE directories");

    return this._locale = null;
  }
};

/* Get the distribution pref values, from defaults only */
function getDistributionPrefValue(aPrefName) {
  return Services.prefs.getDefaultBranch(null).getCharPref(aPrefName, "default");
}

function getSystemCapabilities() {
  return "ISET:" + gInstructionSet + ",MEM:" + getMemoryMB() + getJAWS();
}

/**
 * Gets the appropriate update url string for whether a JAWS screen reader that
 * is incompatible with e10s is present on Windows. For platforms other than
 * Windows this returns an empty string which is easier for balrog to detect.
 */
function getJAWS() {
  if (AppConstants.platform != "win") {
    return "";
  }

  return ",JAWS:" + (Services.appinfo.shouldBlockIncompatJaws ? "1" : "0");
}

/**
 * Gets the RAM size in megabytes. This will round the value because sysinfo
 * doesn't always provide RAM in multiples of 1024.
 */
function getMemoryMB() {
  let memoryMB = "unknown";
  try {
    memoryMB = Services.sysinfo.getProperty("memsize");
    if (memoryMB) {
      memoryMB = Math.round(memoryMB / 1024 / 1024);
    }
  } catch (e) {
    Cu.reportError("Error getting system info memsize property. " +
                   "Exception: " + e);
  }
  return memoryMB;
}

/**
 * Gets the supported CPU instruction set.
 */
XPCOMUtils.defineLazyGetter(this, "gInstructionSet", function aus_gIS() {
  if (AppConstants.platform == "win") {
    const PF_MMX_INSTRUCTIONS_AVAILABLE = 3; // MMX
    const PF_XMMI_INSTRUCTIONS_AVAILABLE = 6; // SSE
    const PF_XMMI64_INSTRUCTIONS_AVAILABLE = 10; // SSE2
    const PF_SSE3_INSTRUCTIONS_AVAILABLE = 13; // SSE3

    let lib = ctypes.open("kernel32.dll");
    let IsProcessorFeaturePresent = lib.declare("IsProcessorFeaturePresent",
                                                ctypes.winapi_abi,
                                                ctypes.int32_t, /* success */
                                                ctypes.uint32_t); /* DWORD */
    let instructionSet = "unknown";
    try {
      if (IsProcessorFeaturePresent(PF_SSE3_INSTRUCTIONS_AVAILABLE)) {
        instructionSet = "SSE3";
      } else if (IsProcessorFeaturePresent(PF_XMMI64_INSTRUCTIONS_AVAILABLE)) {
        instructionSet = "SSE2";
      } else if (IsProcessorFeaturePresent(PF_XMMI_INSTRUCTIONS_AVAILABLE)) {
        instructionSet = "SSE";
      } else if (IsProcessorFeaturePresent(PF_MMX_INSTRUCTIONS_AVAILABLE)) {
        instructionSet = "MMX";
      }
    } catch (e) {
      instructionSet = "error";
      Cu.reportError("Error getting processor instruction set. " +
                     "Exception: " + e);
    }

    lib.close();
    return instructionSet;
  }

  if (AppConstants == "linux") {
    let instructionSet = "unknown";
    if (navigator.cpuHasSSE2) {
      instructionSet = "SSE2";
    }
    return instructionSet;
  }

  return "NA"
});

/* Windows only getter that returns the processor architecture. */
XPCOMUtils.defineLazyGetter(this, "gWinCPUArch", function aus_gWinCPUArch() {
  // Get processor architecture
  let arch = "unknown";

  const WORD = ctypes.uint16_t;
  const DWORD = ctypes.uint32_t;

  // This structure is described at:
  // http://msdn.microsoft.com/en-us/library/ms724958%28v=vs.85%29.aspx
  const SYSTEM_INFO = new ctypes.StructType("SYSTEM_INFO",
      [
      {wProcessorArchitecture: WORD},
      {wReserved: WORD},
      {dwPageSize: DWORD},
      {lpMinimumApplicationAddress: ctypes.voidptr_t},
      {lpMaximumApplicationAddress: ctypes.voidptr_t},
      {dwActiveProcessorMask: DWORD.ptr},
      {dwNumberOfProcessors: DWORD},
      {dwProcessorType: DWORD},
      {dwAllocationGranularity: DWORD},
      {wProcessorLevel: WORD},
      {wProcessorRevision: WORD}
      ]);

  let kernel32 = false;
  try {
    kernel32 = ctypes.open("Kernel32");
  } catch (e) {
    Cu.reportError("Unable to open kernel32! Exception: " + e);
  }

  if (kernel32) {
    try {
      let GetNativeSystemInfo = kernel32.declare("GetNativeSystemInfo",
                                                 ctypes.winapi_abi,
                                                 ctypes.void_t,
                                                 SYSTEM_INFO.ptr);
      let winSystemInfo = SYSTEM_INFO();
      // Default to unknown
      winSystemInfo.wProcessorArchitecture = 0xffff;

      GetNativeSystemInfo(winSystemInfo.address());
      switch (winSystemInfo.wProcessorArchitecture) {
        case 9:
          arch = "x64";
          break;
        case 6:
          arch = "IA64";
          break;
        case 0:
          arch = "x86";
          break;
      }
    } catch (e) {
      Cu.reportError("Error getting processor architecture. " +
                     "Exception: " + e);
    } finally {
      kernel32.close();
    }
  }

  return arch;
});

XPCOMUtils.defineLazyGetter(UpdateUtils, "ABI", function() {
  let abi = null;
  try {
    abi = Services.appinfo.XPCOMABI;
  } catch (e) {
    Cu.reportError("XPCOM ABI unknown");
  }

  if (AppConstants.platform == "macosx") {
    // Mac universal build should report a different ABI than either macppc
    // or mactel.
    let macutils = Cc["@mozilla.org/xpcom/mac-utils;1"].
                   getService(Ci.nsIMacUtils);

    if (macutils.isUniversalBinary) {
      abi += "-u-" + macutils.architecturesInBinary;
    }
  } else if (AppConstants.platform == "win") {
    // Windows build should report the CPU architecture that it's running on.
    abi += "-" + gWinCPUArch;
  }
  return abi;
});

XPCOMUtils.defineLazyGetter(UpdateUtils, "OSVersion", function() {
  let osVersion;
  try {
    osVersion = Services.sysinfo.getProperty("name") + " " +
                Services.sysinfo.getProperty("version");
  } catch (e) {
    Cu.reportError("OS Version unknown.");
  }

  if (osVersion) {
    if (AppConstants.platform == "win") {
      const BYTE = ctypes.uint8_t;
      const WORD = ctypes.uint16_t;
      const DWORD = ctypes.uint32_t;
      const WCHAR = ctypes.char16_t;
      const BOOL = ctypes.int;

      // This structure is described at:
      // http://msdn.microsoft.com/en-us/library/ms724833%28v=vs.85%29.aspx
      const SZCSDVERSIONLENGTH = 128;
      const OSVERSIONINFOEXW = new ctypes.StructType("OSVERSIONINFOEXW",
          [
          {dwOSVersionInfoSize: DWORD},
          {dwMajorVersion: DWORD},
          {dwMinorVersion: DWORD},
          {dwBuildNumber: DWORD},
          {dwPlatformId: DWORD},
          {szCSDVersion: ctypes.ArrayType(WCHAR, SZCSDVERSIONLENGTH)},
          {wServicePackMajor: WORD},
          {wServicePackMinor: WORD},
          {wSuiteMask: WORD},
          {wProductType: BYTE},
          {wReserved: BYTE}
          ]);

      let kernel32 = false;
      try {
        kernel32 = ctypes.open("Kernel32");
      } catch (e) {
        Cu.reportError("Unable to open kernel32! " + e);
        osVersion += ".unknown (unknown)";
      }

      if (kernel32) {
        try {
          // Get Service pack info
          try {
            let GetVersionEx = kernel32.declare("GetVersionExW",
                                                ctypes.winapi_abi,
                                                BOOL,
                                                OSVERSIONINFOEXW.ptr);
            let winVer = OSVERSIONINFOEXW();
            winVer.dwOSVersionInfoSize = OSVERSIONINFOEXW.size;

            if (0 !== GetVersionEx(winVer.address())) {
              osVersion += "." + winVer.wServicePackMajor +
                           "." + winVer.wServicePackMinor;
            } else {
              Cu.reportError("Unknown failure in GetVersionEX (returned 0)");
              osVersion += ".unknown";
            }
          } catch (e) {
            Cu.reportError("Error getting service pack information. Exception: " + e);
            osVersion += ".unknown";
          }
        } finally {
          kernel32.close();
        }

        // Add processor architecture
        osVersion += " (" + gWinCPUArch + ")";
      }
    }

    try {
      osVersion += " (" + Services.sysinfo.getProperty("secondaryLibrary") + ")";
    } catch (e) {
      // Not all platforms have a secondary widget library, so an error is nothing to worry about.
    }
    osVersion = encodeURIComponent(osVersion);
  }
  return osVersion;
});
