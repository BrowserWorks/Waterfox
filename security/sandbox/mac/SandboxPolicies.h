/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_SandboxPolicies_h
#define mozilla_SandboxPolicies_h

namespace mozilla {

static const char pluginSandboxRules[] = R"(
  (version 1)

  (define should-log (param "SHOULD_LOG"))
  (define plugin-binary-path (param "PLUGIN_BINARY_PATH"))
  (define app-path (param "APP_PATH"))
  (define app-binary-path (param "APP_BINARY_PATH"))

  (if (string=? should-log "TRUE")
      (deny default)
      (deny default (with no-log)))

  (allow signal (target self))
  (allow sysctl-read)
  (allow iokit-open (iokit-user-client-class "IOHIDParamUserClient"))
  (allow mach-lookup
      (global-name "com.apple.cfprefsd.agent")
      (global-name "com.apple.cfprefsd.daemon")
      (global-name "com.apple.system.opendirectoryd.libinfo")
      (global-name "com.apple.system.logger")
      (global-name "com.apple.ls.boxd"))
  (allow file-read*
      (literal "/etc")
      (literal "/dev/random")
      (literal "/dev/urandom")
      (literal "/usr/share/icu/icudt51l.dat")
      (subpath "/System/Library/Displays/Overrides")
      (subpath "/System/Library/CoreServices/CoreTypes.bundle")
      (subpath "/System/Library/PrivateFrameworks")
      (regex #"^/usr/lib/libstdc\+\+\.[^/]*dylib$")
      (literal plugin-binary-path)
      (literal app-path)
      (literal app-binary-path))
)";

static const char widevinePluginSandboxRulesAddend[] = R"(
  (allow mach-lookup (global-name "com.apple.windowserver.active"))
)";

static const char contentSandboxRules[] = R"(
  (version 1)

  (define should-log (param "SHOULD_LOG"))
  (define sandbox-level-1 (param "SANDBOX_LEVEL_1"))
  (define sandbox-level-2 (param "SANDBOX_LEVEL_2"))
  (define sandbox-level-3 (param "SANDBOX_LEVEL_3"))
  (define macosMinorVersion (string->number (param "MAC_OS_MINOR")))
  (define appPath (param "APP_PATH"))
  (define appBinaryPath (param "APP_BINARY_PATH"))
  (define appdir-path (param "APP_DIR"))
  (define appTempDir (param "APP_TEMP_DIR"))
  (define hasProfileDir (param "HAS_SANDBOXED_PROFILE"))
  (define profileDir (param "PROFILE_DIR"))
  (define home-path (param "HOME_PATH"))
  (define hasFilePrivileges (param "HAS_FILE_PRIVILEGES"))
  (define debugWriteDir (param "DEBUG_WRITE_DIR"))
  (define testingReadPath1 (param "TESTING_READ_PATH1"))
  (define testingReadPath2 (param "TESTING_READ_PATH2"))
  (define testingReadPath3 (param "TESTING_READ_PATH3"))
  (define testingReadPath4 (param "TESTING_READ_PATH4"))

  (if (string=? should-log "TRUE")
    (deny default)
    (deny default (with no-log)))
  (debug deny)

  ; Allow read access to standard system paths.
  (allow file-read*
    (require-all (file-mode #o0004)
      (require-any (subpath "/Library/Filesystems/NetFSPlugins")
        (subpath "/System")
        (subpath "/usr/lib")
        (subpath "/usr/share"))))

  (allow file-read-metadata
    (literal "/etc")
    (literal "/tmp")
    (literal "/var")
    (literal "/private/etc/localtime")
    (literal "/home")
    (literal "/net")
    (regex "^/private/tmp/KSInstallAction\."))

  ; Allow read access to standard special files.
  (allow file-read*
    (literal "/dev/autofs_nowait")
    (literal "/dev/random")
    (literal "/dev/urandom"))

  (allow file-read*
    file-write-data
    (literal "/dev/null")
    (literal "/dev/zero"))

  (allow file-read*
    file-write-data
    file-ioctl
    (literal "/dev/dtracehelper"))

  ; macOS 10.9 does not support the |sysctl-name| predicate, so unfortunately
  ; we need to allow all sysctl-reads there.
  (if (= macosMinorVersion 9)
    (allow sysctl-read)
    (allow sysctl-read
      (sysctl-name-regex #"^sysctl\.")
      (sysctl-name "kern.ostype")
      (sysctl-name "kern.osversion")
      (sysctl-name "kern.osrelease")
      (sysctl-name "kern.version")
      ; TODO: remove "kern.hostname". Without it the tests hang, but the hostname
      ; is arguably sensitive information, so we should see what can be done about
      ; removing it.
      (sysctl-name "kern.hostname")
      (sysctl-name "hw.machine")
      (sysctl-name "hw.model")
      (sysctl-name "hw.ncpu")
      (sysctl-name "hw.activecpu")
      (sysctl-name "hw.byteorder")
      (sysctl-name "hw.pagesize_compat")
      (sysctl-name "hw.logicalcpu_max")
      (sysctl-name "hw.physicalcpu_max")
      (sysctl-name "hw.busfrequency_compat")
      (sysctl-name "hw.busfrequency_max")
      (sysctl-name "hw.cpufrequency")
      (sysctl-name "hw.cpufrequency_compat")
      (sysctl-name "hw.cpufrequency_max")
      (sysctl-name "hw.l2cachesize")
      (sysctl-name "hw.l3cachesize")
      (sysctl-name "hw.cachelinesize_compat")
      (sysctl-name "hw.tbfrequency_compat")
      (sysctl-name "hw.vectorunit")
      (sysctl-name "hw.optional.sse2")
      (sysctl-name "hw.optional.sse3")
      (sysctl-name "hw.optional.sse4_1")
      (sysctl-name "hw.optional.sse4_2")
      (sysctl-name "hw.optional.avx1_0")
      (sysctl-name "hw.optional.avx2_0")
      (sysctl-name "machdep.cpu.vendor")
      (sysctl-name "machdep.cpu.family")
      (sysctl-name "machdep.cpu.model")
      (sysctl-name "machdep.cpu.stepping")
      (sysctl-name "debug.intel.gstLevelGST")
      (sysctl-name "debug.intel.gstLoaderControl")))

  (define (home-regex home-relative-regex)
    (regex (string-append "^" (regex-quote home-path) home-relative-regex)))
  (define (home-subpath home-relative-subpath)
    (subpath (string-append home-path home-relative-subpath)))
  (define (home-literal home-relative-literal)
    (literal (string-append home-path home-relative-literal)))

  (define (profile-subpath profile-relative-subpath)
    (subpath (string-append profileDir profile-relative-subpath)))

  (define (allow-shared-preferences-read domain)
        (begin
          (if (defined? `user-preference-read)
            (allow user-preference-read (preference-domain domain)))
          (allow file-read*
                 (home-literal (string-append "/Library/Preferences/" domain ".plist"))
                 (home-regex (string-append "/Library/Preferences/ByHost/" (regex-quote domain) "\..*\.plist$")))
          ))

  (define (allow-shared-list domain)
    (allow file-read*
           (home-regex (string-append "/Library/Preferences/" (regex-quote domain)))))

  (allow ipc-posix-shm
      (ipc-posix-name-regex "^/tmp/com.apple.csseed:")
      (ipc-posix-name-regex "^CFPBS:")
      (ipc-posix-name-regex "^AudioIO"))

  (allow signal (target self))
  (allow job-creation (literal "/Library/CoreMediaIO/Plug-Ins/DAL"))
  (allow iokit-set-properties (iokit-property "IOAudioControlValue"))

  (allow mach-lookup
      (global-name "com.apple.coreservices.launchservicesd")
      (global-name "com.apple.coreservices.appleevents")
      (global-name "com.apple.pasteboard.1")
      (global-name "com.apple.window_proxies")
      (global-name "com.apple.windowserver.active")
      (global-name "com.apple.audio.coreaudiod")
      (global-name "com.apple.audio.audiohald")
      (global-name "com.apple.PowerManagement.control")
      (global-name "com.apple.cmio.VDCAssistant")
      (global-name "com.apple.SystemConfiguration.configd")
      (global-name "com.apple.iconservices")
      (global-name "com.apple.cache_delete")
      (global-name "com.apple.pluginkit.pkd")
      (global-name "com.apple.bird")
      (global-name "com.apple.cmio.AppleCameraAssistant")
      (global-name "com.apple.DesktopServicesHelper"))

  (if (>= macosMinorVersion 13)
    (allow mach-lookup
      ; bug 1376163
      (global-name "com.apple.audio.AudioComponentRegistrar")
      ; bug 1392988
      (xpc-service-name "com.apple.coremedia.videodecoder")
      (xpc-service-name "com.apple.coremedia.videoencoder")))

; bug 1312273
  (if (= macosMinorVersion 9)
     (allow mach-lookup (global-name "com.apple.xpcd")))

  (allow iokit-open
      (iokit-user-client-class "IOHIDParamUserClient")
      (iokit-user-client-class "IOAudioControlUserClient")
      (iokit-user-client-class "IOAudioEngineUserClient")
      (iokit-user-client-class "IGAccelDevice")
      (iokit-user-client-class "nvDevice")
      (iokit-user-client-class "nvSharedUserClient")
      (iokit-user-client-class "nvFermiGLContext")
      (iokit-user-client-class "IGAccelGLContext")
      (iokit-user-client-class "IGAccelSharedUserClient")
      (iokit-user-client-class "IGAccelVideoContextMain")
      (iokit-user-client-class "IGAccelVideoContextMedia")
      (iokit-user-client-class "IGAccelVideoContextVEBox")
      (iokit-user-client-class "RootDomainUserClient")
      (iokit-user-client-class "IOUSBDeviceUserClientV2")
      (iokit-user-client-class "IOUSBInterfaceUserClientV2"))

; depending on systems, the 1st, 2nd or both rules are necessary
  (allow-shared-preferences-read "com.apple.HIToolbox")
  (allow file-read-data (literal "/Library/Preferences/com.apple.HIToolbox.plist"))

  (allow-shared-preferences-read "com.apple.ATS")
  (allow file-read-data (literal "/Library/Preferences/.GlobalPreferences.plist"))

  (allow file-read*
      (subpath "/Library/Fonts")
      (subpath "/Library/Audio/Plug-Ins")
      (subpath "/Library/CoreMediaIO/Plug-Ins/DAL")
      (subpath "/Library/Spelling")
      (literal "/")
      (literal "/private/tmp")
      (literal "/private/var/tmp")

      (home-literal "/.CFUserTextEncoding")
      (home-literal "/Library/Preferences/com.apple.DownloadAssessment.plist")
      (home-subpath "/Library/Colors")
      (home-subpath "/Library/Fonts")
      (home-subpath "/Library/FontCollections")
      (home-subpath "/Library/Keyboard Layouts")
      (home-subpath "/Library/Input Methods")
      (home-subpath "/Library/Spelling")
      (home-subpath "/Library/Application Support/Adobe/CoreSync/plugins/livetype")

      (subpath appdir-path)

      (literal appPath)
      (literal appBinaryPath))

  (when testingReadPath1
    (allow file-read* (subpath testingReadPath1)))
  (when testingReadPath2
    (allow file-read* (subpath testingReadPath2)))
  (when testingReadPath3
    (allow file-read* (subpath testingReadPath3)))
  (when testingReadPath4
    (allow file-read* (subpath testingReadPath4)))

  (allow file-read-metadata (home-subpath "/Library"))

  (allow file-read-metadata
    (literal "/private/var")
    (subpath "/private/var/folders"))

  ; bug 1303987
  (if (string? debugWriteDir)
    (begin
      (allow file-write-data (subpath debugWriteDir))
      (allow file-write-create
        (require-all
          (subpath debugWriteDir)
          (vnode-type REGULAR-FILE)))))

  ; bug 1324610
  (allow network-outbound file-read*
    (literal "/private/var/run/cupsd"))

  (allow-shared-list "org.mozilla.plugincontainer")

; the following rule should be removed when microphone access
; is brokered through the content process
  (allow device-microphone)

; Per-user and system-wide Extensions dir
  (allow file-read*
      (home-regex "/Library/Application Support/[^/]+/Extensions/[^/]/")
      (regex "/Library/Application Support/[^/]+/Extensions/[^/]/"))

; The following rules impose file access restrictions which get
; more restrictive in higher levels. When file-origin-specific
; content processes are used for file:// origin browsing, the
; global file-read* permission should be removed from each level.

; level 1: global read access permitted, no global write access
  (if (string=? sandbox-level-1 "TRUE") (allow file-read*))

; level 2: global read access permitted, no global write access,
;          no read/write access to ~/Library,
;          no read/write access to $PROFILE,
;          read access permitted to $PROFILE/{extensions,chrome}
  (if (string=? sandbox-level-2 "TRUE")
    (if (string=? hasFilePrivileges "TRUE")
      ; This process has blanket file read privileges
      (allow file-read*)
      ; This process does not have blanket file read privileges
      (begin
        ; bug 1201935
        (allow file-read* (home-subpath "/Library/Caches/TemporaryItems"))
        (if (string=? hasProfileDir "TRUE")
          ; we have a profile dir
          (begin
            (allow file-read* (require-all
                (require-not (home-subpath "/Library"))
                (require-not (subpath profileDir))))
            (allow file-read*
                (profile-subpath "/extensions")
                (profile-subpath "/chrome")))
          ; we don't have a profile dir
          (allow file-read* (require-not (home-subpath "/Library")))))))

  ; level 3: no global read/write access,
  ;          read access permitted to $PROFILE/{extensions,chrome}
  (if (string=? sandbox-level-3 "TRUE")
    (if (string=? hasFilePrivileges "TRUE")
      ; This process has blanket file read privileges
      (allow file-read*)
      ; This process does not have blanket file read privileges
      (if (string=? hasProfileDir "TRUE")
        ; we have a profile dir
          (allow file-read*
            (profile-subpath "/extensions")
            (profile-subpath "/chrome")))))

; accelerated graphics
  (allow-shared-preferences-read "com.apple.opengl")
  (allow-shared-preferences-read "com.nvidia.OpenGL")
  (allow mach-lookup
      (global-name "com.apple.cvmsServ"))
  (allow iokit-open
      (iokit-connection "IOAccelerator")
      (iokit-user-client-class "IOAccelerationUserClient")
      (iokit-user-client-class "IOSurfaceRootUserClient")
      (iokit-user-client-class "IOSurfaceSendRight")
      (iokit-user-client-class "IOFramebufferSharedUserClient")
      (iokit-user-client-class "AppleSNBFBUserClient")
      (iokit-user-client-class "AGPMClient")
      (iokit-user-client-class "AppleGraphicsControlClient")
      (iokit-user-client-class "AppleGraphicsPolicyClient"))

; bug 1153809
  (allow iokit-open
      (iokit-user-client-class "NVDVDContextTesla")
      (iokit-user-client-class "Gen6DVDContext"))

  ; bug 1237847
  (allow file-read* file-write-data
    (subpath appTempDir))
  (allow file-write-create
    (require-all
      (subpath appTempDir)
      (require-any
        (vnode-type REGULAR-FILE)
        (vnode-type DIRECTORY))))

  ; bug 1382260
  ; We may need to load fonts from outside of the standard
  ; font directories whitelisted above. This is typically caused
  ; by a font manager. For now, whitelist any file with a
  ; font extension. Limit this to the common font types:
  ; files ending in .otf, .ttf, .ttc, .otc, and .dfont.
  (allow file-read*
    (regex #"\.[oO][tT][fF]$"           ; otf
           #"\.[tT][tT][fF]$"           ; ttf
           #"\.[tT][tT][cC]$"           ; ttc
           #"\.[oO][tT][cC]$"           ; otc
           #"\.[dD][fF][oO][nN][tT]$")) ; dfont
)";

}

#endif // mozilla_SandboxPolicies_h
