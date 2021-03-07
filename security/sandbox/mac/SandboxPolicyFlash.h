/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_SandboxPolicyFlash_h
#define mozilla_SandboxPolicyFlash_h

namespace mozilla {

// Flash NPAPI plugin process profile
static const char SandboxPolicyFlash[] = R"SANDBOX_LITERAL(
  (version 1)

  ; Parameters
  (define shouldLog (param "SHOULD_LOG"))
  (define sandbox-level-1 (param "SANDBOX_LEVEL_1"))
  (define sandbox-level-2 (param "SANDBOX_LEVEL_2"))
  (define macosVersion (string->number (param "MAC_OS_VERSION")))
  (define homeDir (param "HOME_PATH"))
  (define tempDir (param "DARWIN_USER_TEMP_DIR"))
  (define cacheDir (param "DARWIN_USER_CACHE_DIR"))
  (define pluginPath (param "PLUGIN_BINARY_PATH"))

  (if (string=? shouldLog "TRUE")
      (deny default)
      (deny default (with no-log)))
  (debug deny)
  (allow system-audit file-read-metadata)
  ; These are not included in (deny default)
  (deny process-info*)
  ; This isn't available in some older macOS releases.
  (if (defined? 'nvram*)
    (deny nvram*))

  ; Allow read access to standard system paths.
  (allow file-read*
    (require-all (file-mode #o0004)
      (require-any
        (subpath "/System")
        (subpath "/usr/lib")
        (subpath "/Library/Filesystems/NetFSPlugins")
        (subpath "/Library/GPUBundles")
        (subpath "/usr/share"))))
  (allow file-read-metadata
         (literal "/etc")
         (literal "/tmp")
         (literal "/var"))
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

  ; Timezone
  (allow file-read*
    (subpath "/private/var/db/timezone")
    (subpath "/usr/share/zoneinfo")
    (subpath "/usr/share/zoneinfo.default")
    (literal "/private/etc/localtime"))

  ; Graphics
  (allow user-preference-read
         (preference-domain "com.apple.opengl")
         (preference-domain "com.nvidia.OpenGL"))
  (allow mach-lookup
         (global-name "com.apple.cvmsServ"))
  (allow iokit-open
         (iokit-connection "IOAccelerator")
         (iokit-user-client-class "IOAccelerationUserClient")
         (iokit-user-client-class "IOSurfaceRootUserClient")
         (iokit-user-client-class "IOSurfaceSendRight"))
  (allow iokit-open
         (iokit-user-client-class "AppleIntelMEUserClient")
         (iokit-user-client-class "AppleSNBFBUserClient"))
  (allow iokit-open
         (iokit-user-client-class "AGPMClient")
         (iokit-user-client-class "AppleGraphicsControlClient")
         (iokit-user-client-class "AppleGraphicsPolicyClient"))
  ; Camera access
  (allow iokit-open
         (iokit-user-client-class "IOUSBDeviceUserClientV2")
         (iokit-user-client-class "IOUSBInterfaceUserClientV2"))

  ; Network
  (allow file-read*
         (literal "/Library/Preferences/com.apple.networkd.plist"))
  (allow mach-lookup
         (global-name "com.apple.SystemConfiguration.PPPController")
         (global-name "com.apple.SystemConfiguration.SCNetworkReachability")
         (global-name "com.apple.nehelper")
         (global-name "com.apple.networkd")
         (global-name "com.apple.nsurlstorage-cache")
         (global-name "com.apple.symptomsd")
         (global-name "com.apple.usymptomsd"))
  (allow network-outbound
         (control-name "com.apple.netsrc")
         (control-name "com.apple.network.statistics"))
  (allow system-socket
         (require-all (socket-domain AF_SYSTEM)
                      (socket-protocol 2)) ; SYSPROTO_CONTROL
         (socket-domain AF_ROUTE))
  (allow network-outbound
      (literal "/private/var/run/mDNSResponder")
      (literal "/private/var/run/asl_input")
      (literal "/private/var/run/syslog")
      (remote tcp)
      (remote udp))
  (allow network-inbound
      (local udp))

  (allow process-info-pidinfo)
  (allow process-info-setcontrol (target self))

  ; macOS 10.9 does not support the |sysctl-name| predicate
  (if (= macosVersion 1009)
      (allow sysctl-read)
      (allow sysctl-read
        (sysctl-name
          "hw.activecpu"
          "hw.availcpu"
          "hw.busfrequency_max"
          "hw.cpu64bit_capable"
          "hw.cputype"
          "hw.physicalcpu_max"
          "hw.logicalcpu_max"
          "hw.machine"
          "hw.memsize"
          "hw.model"
          "hw.ncpu"
          "hw.optional.avx1_0"
          "hw.optional.avx2_0"
          "hw.optional.sse2"
          "hw.optional.sse3"
          "hw.optional.sse4_1"
          "hw.optional.sse4_2"
          "hw.optional.x86_64"
          "kern.hostname"
          "kern.maxfilesperproc"
          "kern.memorystatus_level"
          "kern.osrelease"
          "kern.ostype"
          "kern.osvariant_status"
          "kern.osversion"
          "kern.safeboot"
          "kern.version"
          "vm.footprint_suspend")))

  ; Utilities for allowing access to home subdirectories
  (define home-library-path
    (string-append homeDir "/Library"))

  (define (home-subpath home-relative-subpath)
    (subpath (string-append homeDir home-relative-subpath)))

  (define home-library-prefs-path
    (string-append homeDir "/Library" "/Preferences"))

  (define (home-literal home-relative-literal)
    (literal (string-append homeDir home-relative-literal)))

  (define (home-library-regex home-library-relative-regex)
    (regex (string-append "^" (regex-quote home-library-path))
           home-library-relative-regex))

  (define (home-library-subpath home-library-relative-subpath)
      (subpath (string-append home-library-path home-library-relative-subpath)))

  (define (home-library-literal home-library-relative-literal)
      (literal (string-append home-library-path home-library-relative-literal)))

  (define (home-library-preferences-literal
           home-library-preferences-relative-literal)
      (literal (string-append home-library-prefs-path
                home-library-preferences-relative-literal)))

  ; Utility for allowing access to a temp dir subdirectory
  (define (tempDir-regex tempDir-relative-regex)
    (regex (string-append "^" (regex-quote tempDir)) tempDir-relative-regex))

  ; Utility for allowing access to specific files within the cache dir
  (define (cache-literal cache-relative-literal)
    (literal (string-append cacheDir cache-relative-literal)))

  ; Read-only paths
  (allow file-read*
      (literal "/")
      (literal "/private/etc/services")
      (literal "/private/etc/resolv.conf")
      (literal "/private/var/run/resolv.conf")
      (subpath "/Library/Frameworks")
      (subpath "/Library/Managed Preferences")
      (home-literal "/.CFUserTextEncoding")
      (home-library-subpath "/Audio")
      (home-library-subpath "/ColorPickers")
      (home-library-subpath "/ColorSync")
      (subpath "/Library/Components")
      (home-library-subpath "/Components")
      (subpath "/Library/Contextual Menu Items")
      (subpath "/Library/Input Methods")
      (home-library-subpath "/Input Methods")
      (subpath "/Library/InputManagers")
      (home-library-subpath "/InputManagers")
      (home-library-subpath "/KeyBindings")
      (subpath "/Library/Keyboard Layouts")
      (home-library-subpath "/Keyboard Layouts")
      (subpath "/Library/Spelling")
      (home-library-subpath "/Spelling")
      (home-library-literal "/Caches/com.apple.coreaudio.components.plist")
      (subpath "/Library/Audio/Sounds")
      (subpath "/Library/Audio/Plug-Ins/Components")
      (home-library-subpath "/Audio/Plug-Ins/Components")
      (subpath "/Library/Audio/Plug-Ins/HAL")
      (subpath "/Library/CoreMediaIO/Plug-Ins/DAL")
      (subpath "/Library/QuickTime")
      (home-library-subpath "/QuickTime")
      (subpath "/Library/Video/Plug-Ins")
      (home-library-subpath "/Caches/QuickTime")
      (subpath "/Library/ColorSync")
      (home-literal "/Library/Preferences/com.apple.lookup.shared.plist"))

  (allow iokit-open
      (iokit-user-client-class "IOAudioControlUserClient")
      (iokit-user-client-class "IOAudioEngineUserClient")
      (iokit-user-client-class "IOHIDParamUserClient")
      (iokit-user-client-class "RootDomainUserClient"))

  ; Services
  (allow mach-lookup
      (global-name "com.apple.audio.AudioComponentRegistrar")
      (global-name "com.apple.DiskArbitration.diskarbitrationd")
      (global-name "com.apple.ImageCaptureExtension2.presence")
      (global-name "com.apple.PowerManagement.control")
      (global-name "com.apple.SecurityServer")
      (global-name "com.apple.SystemConfiguration.PPPController")
      (global-name "com.apple.SystemConfiguration.configd")
      (global-name "com.apple.UNCUserNotification")
      (global-name "com.apple.audio.audiohald")
      (global-name "com.apple.audio.coreaudiod")
      (global-name "com.apple.cfnetwork.AuthBrokerAgent")
      (global-name "com.apple.lsd.mapdb")
      (global-name "com.apple.pasteboard.1") ; Allows paste into input field
      (global-name "com.apple.dock.server")
      (global-name "com.apple.dock.fullscreen")
      (global-name "com.apple.coreservices.appleevents")
      (global-name "com.apple.coreservices.launchservicesd")
      (global-name "com.apple.window_proxies")
      (local-name "com.apple.tsm.portname")
      (global-name "com.apple.axserver")
      (global-name "com.apple.pbs.fetch_services")
      (global-name "com.apple.tsm.uiserver")
      (global-name "com.apple.inputmethodkit.launchagent")
      (global-name "com.apple.inputmethodkit.launcher")
      (global-name "com.apple.inputmethodkit.getxpcendpoint")
      (global-name "com.apple.decalog4.incoming")
      (global-name "com.apple.windowserver.active")
      (global-name "com.apple.trustd.agent")
      (global-name "com.apple.ocspd"))
  ; Required for camera access
  (allow mach-lookup
      (global-name "com.apple.tccd")
      (global-name "com.apple.tccd.system")
      (global-name "com.apple.cmio.AppleCameraAssistant")
      (global-name "com.apple.cmio.IIDCVideoAssistant")
      (global-name "com.apple.cmio.AVCAssistant")
      (global-name "com.apple.cmio.VDCAssistant"))
  ; bug 1475707
  (if (= macosVersion 1009)
     (allow mach-lookup (global-name "com.apple.xpcd")))
  (if (>= macosVersion 1015)
     (allow mach-lookup
      (global-name "com.apple.ViewBridgeAuxiliary")
      (global-name "com.apple.appkit.xpc.openAndSavePanelService")
      (global-name "com.apple.MTLCompilerService")))

  ; Fonts
  (allow file-read*
    (subpath "/Library/Fonts")
    (subpath "/Library/Application Support/Apple/Fonts")
    (home-library-subpath "/Fonts")
    ; Allow read access to paths allowed via sandbox extensions.
    ; This is needed for fonts in non-standard locations normally
    ; due to third party font managers. The extensions are
    ; automatically issued by the font server in response to font
    ; API calls.
    (extension "com.apple.app-sandbox.read"))
  ; Fonts may continue to work without explicitly allowing these
  ; services because, at present, connections are made to the services
  ; before the sandbox is enabled as a side-effect of some API calls.
  (allow mach-lookup
    (global-name "com.apple.fonts")
    (global-name "com.apple.FontObjectsServer"))
  (if (<= macosVersion 1011)
    (allow mach-lookup (global-name "com.apple.FontServer")))

  ; Fonts
  ; Workaround for sandbox extensions not being automatically
  ; issued for fonts on 10.11 and earlier versions (bug 1460917).
  (if (<= macosVersion 1011)
    (allow file-read*
      (regex #"\.[oO][tT][fF]$"          ; otf
             #"\.[tT][tT][fF]$"          ; ttf
             #"\.[tT][tT][cC]$"          ; ttc
             #"\.[oO][tT][cC]$"          ; otc
             #"\.[dD][fF][oO][nN][tT]$") ; dfont
      (home-subpath "/Library/FontCollections")
      (home-subpath "/Library/Application Support/Adobe/CoreSync/plugins/livetype")
      (home-subpath "/Library/Application Support/FontAgent")
      (home-subpath "/Library/Extensis/UTC") ; bug 1469657
      (subpath "/Library/Extensis/UTC")      ; bug 1469657
      (regex #"\.fontvault/")
      (home-subpath "/FontExplorer X/Font Library")))

  ; level 1: global read access permitted, no global write access
  (if (string=? sandbox-level-1 "TRUE") (allow file-read*))

  ; level 2: read access via file dialog exceptions, no global write access
  (if (or (string=? sandbox-level-2 "TRUE")
          (string=? sandbox-level-1 "TRUE")) (begin
    ; Open file dialogs
    (allow mach-lookup
	; needed for the dialog sidebar
	(global-name "com.apple.coreservices.sharedfilelistd.xpc")
	; bird(8) -- "Documents in the Cloud"
	; needed to avoid iCloud error dialogs and to display iCloud files
	(global-name "com.apple.bird")
	(global-name "com.apple.bird.token")
	; needed for icons in the file dialog
	(global-name "com.apple.iconservices"))
    ; Needed for read access to files selected by the user with the
    ; file dialog. The extensions are granted when the dialog is
    ; displayed. Unfortunately (testing revealed) that displaying
    ; the file dialog grants access to all files within the directory
    ; displayed by the file dialog--a small improvement compared
    ; to global read access.
    (allow file-read*
	(extension "com.apple.app-sandbox.read-write"))))

  (allow ipc-posix-shm*
      (ipc-posix-name-regex #"^AudioIO")
      (ipc-posix-name-regex #"^CFPBS:"))

  (allow ipc-posix-shm-read*
      (ipc-posix-name-regex #"^/tmp/com\.apple\.csseed\.")
      (ipc-posix-name "FNetwork.defaultStorageSession")
      (ipc-posix-name "apple.shm.notification_center"))

  ; Printing
  (allow network-outbound (literal "/private/var/run/cupsd"))
  (allow mach-lookup
      (global-name "com.apple.printuitool.agent")
      (global-name "com.apple.printtool.agent")
      (global-name "com.apple.printtool.daemon"))
  (allow file-read*
      (subpath "/Library/Printers")
      (home-literal "/.cups/lpoptions")
      (home-literal "/.cups/client.conf")
      (literal "/private/etc/cups/client.conf")
      (literal "/private/etc/cups/lpoptions")
      (subpath "/private/etc/cups/ppd")
      (literal "/private/var/run/cupsd"))
  (allow user-preference-read
      (preference-domain "org.cups.PrintingPrefs"))
  ; Temporary files read/written here during printing
  (allow file-read* file-write-create file-write-data
      (tempDir-regex "/FlashTmp"))

  ; Camera/Mic
  (allow device-camera)
  (allow device-microphone)

  ; Path to the plugin binary, user cache dir, and user temp dir
  (allow file-read* (subpath pluginPath))

  ; Per Adobe, needed for Flash LocalConnection functionality
  (allow ipc-posix-sem
      (ipc-posix-name "MacromediaSemaphoreDig"))

  ; Flash debugger and enterprise deployment config files
  (allow file-read*
      (home-literal "/mm.cfg")
      (home-literal "/mms.cfg"))

  (allow file-read* file-write-create file-write-mode file-write-owner
      (home-library-literal "/Caches/Adobe")
      (home-library-preferences-literal "/Macromedia"))

  (allow file-read* file-write-create file-write-data
      (literal "/Library/Application Support/Macromedia/mms.cfg")
      (home-library-literal "/Application Support/Macromedia/mms.cfg")
      (home-library-subpath "/Caches/Adobe/Flash Player"))
  (allow file-read* file-write-create file-write-data file-write-unlink
      (home-library-subpath "/Preferences/Macromedia/Flash Player"))

  (allow file-read*
      (literal "/Library/PreferencePanes/Flash Player.prefPane")
      (home-library-literal "/PreferencePanes/Flash Player.prefPane")
      (home-library-regex "/Application Support/Macromedia/ss\.(cfg|cfn|sgn)$"))

  (allow file-read*
      (literal "/Library/Preferences/com.apple.security.plist")
      (subpath "/private/var/db/mds"))

  ; Additional read/write paths needed for encrypted video playback.
  ; Tests revealed file-write-{data,create,flags} are required for the
  ; accesses to the mds files. file-write-{data,create,mode,unlink}
  ; required for CertStore.dat access. Allow file-write* to match system
  ; profiles and for better compatibilty.
  (allow file-read* file-write*
      (require-all
          (vnode-type REGULAR-FILE)
          (require-any
              (cache-literal "/mds/mds.lock")
              (cache-literal "/mds/mdsDirectory.db")
              (cache-literal "/mds/mdsDirectory.db_")
              (cache-literal "/mds/mdsObject.db")
              (cache-literal "/mds/mdsObject.db_")
              (tempDir-regex "/TemporaryItems/[^/]+/CertStore.dat"))))

  (allow network-bind (local ip))

  (deny file-write-create (vnode-type SYMLINK))
)SANDBOX_LITERAL";

}  // namespace mozilla

#endif  // mozilla_SandboxPolicyFlash_h
