# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Impormasyon sa Pag-troubleshoot
page-subtitle = Ang pahinang ito ay naglalaman ng teknikal na impormasyon na maaaring makatulong kapag may sinusubukan kang ayusin na problema. Kung naghahanap ka ng kasagutan sa mga karaniwang katanungan tungkol sa { -brand-short-name }, bisitahin ang ating <a data-l10n-name="support-link">support website</a>.

crashes-title = Ulat ng mga Crash
crashes-id = Report ID
crashes-send-date = Nai-sumite
crashes-all-reports = Lahat ng Ulat ng Pag-crash
crashes-no-config = Ang application na ito ay hindi pa na i-configure para ipakita ang mga crash reports.
extensions-title = Mga Extension
extensions-name = Pangalan
extensions-enabled = Naka-enable
extensions-version = Bersyon
extensions-id = ID
support-addons-name = Pangalan
support-addons-version = Bersyon
support-addons-id = ID
security-software-title = Security Software
security-software-type = Uri
security-software-name = Pangalan
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Mga katangian ng { -brand-short-name }
features-name = Pangalan
features-version = Bersyon
features-id = ID
processes-title = Mga Remote Process
processes-type = Uri
processes-count = Bilang
app-basics-title = Mga Paunang Katangian ng Application
app-basics-name = Pangalan
app-basics-version = Bersyon
app-basics-build-id = Build ID
app-basics-update-channel = Update Channel
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Update Directory
       *[other] Update Folder
    }
app-basics-update-history = Kasaysayan ng Pag-update
app-basics-show-update-history = Ipakita ang Kasaysayan ng Pag-update
# Represents the path to the binary used to start the application.
app-basics-binary = Application Binary
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Talaan ng Profile
       *[other] Folder ng Profile
    }
app-basics-enabled-plugins = Mga gumaganang Plugins
app-basics-build-config = Build Configuration
app-basics-user-agent = User Agent
app-basics-os = OS
app-basics-memory-use = Paggamit ng Memory
app-basics-performance = Pagganap
app-basics-service-workers = Mga Nakarehistrong Service Worker
app-basics-profiles = Mga Profile
app-basics-launcher-process-status = Launcher Process
app-basics-multi-process-support = Multiprocess Windows
app-basics-remote-processes-count = Mga Remote Process
app-basics-enterprise-policies = Mga Polisiyang Pang-enterprise
app-basics-location-service-key-google = Google Location Service Key
app-basics-safebrowsing-key-google = Google Safebrowsing Key
app-basics-key-mozilla = Mozilla Location Service Key
app-basics-safe-mode = Safe Mode
show-dir-label =
    { PLATFORM() ->
        [macos] Ipakita sa Finder
        [windows] Buksan ang Folder
       *[other] Buksan ang Directory
    }
modified-key-prefs-title = Mga Mahalagang Binagong Kagustuhan
modified-prefs-name = Pangalan
modified-prefs-value = Halaga
user-js-title = user.js Preferences
locked-key-prefs-title = Mga Importanteng Nakapinid na Kagustuhan
locked-prefs-name = Pangalan
locked-prefs-value = Halaga
graphics-title = Graphics
graphics-features-title = Mga Katangian
graphics-diagnostics-title = Mga diagnostics
graphics-failure-log-title = Log ng Kabiguan
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Log ng mga Desisyon
graphics-crash-guards-title = Crash Guard Disabled Features
graphics-workarounds-title = Workarounds
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Window Protocol
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Desktop Environment
place-database-title = Places Database
place-database-integrity = Integredad
place-database-verify-integrity = Patunayan ang Integridad
a11y-title = Accessibility
a11y-activated = Naka-activate
a11y-force-disabled = Pigilan ang pag-access
a11y-handler-used = Ginamit na Accessible Handler
a11y-instantiator = Accessibility Instantiator
library-version-title = Mga Bersyon ng Library
copy-text-to-clipboard-label = Kopyahin ang text sa clipboard
copy-raw-data-to-clipboard-label = Kopyahin ang raw data sa clipboard
sandbox-title = Sandbox
sandbox-sys-call-log-title = Mga Ni-reject na System Call
sandbox-sys-call-index = #
sandbox-sys-call-age = Mga segundong Nakalipas
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tipo ng Proseso
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Arguments
safe-mode-title = Subukan mag-safe mode
restart-in-safe-mode-label = Mag-restart na Naka-Disable ang mga Add-on…

## Media titles

audio-backend = Backend ng Audio
max-audio-channels = Max na mga Channel
sample-rate = Ninanais na Sample Rate
media-title = Media
media-output-devices-title = Mga Output Device
media-input-devices-title = Mga Input Device
media-device-name = Pangalan
media-device-group = Pangkat
media-device-vendor = Tindero
media-device-state = Estado
media-device-preferred = Kagustuhan
media-device-format = Format
media-device-channels = Mga channel
media-device-rate = Rate
media-device-latency = Latency
media-capabilities-title = Mga Media Capability
# List all the entries of the database.
media-capabilities-enumerate = Ilista ang database

##

intl-title = Internationalization & Localization
intl-app-title = Mga Application Setting
intl-locales-requested = Mga Hininging Locale
intl-locales-available = Mga Available na Locale
intl-locales-supported = Mga App Locale
intl-locales-default = Default Locale
intl-os-title = Operating System
intl-os-prefs-system-locales = Mga System Locale
intl-regional-prefs = Mga Regional Preference

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Remote Debugging (Chromium Protocol)
remote-debugging-accepting-connections = Tumatanggap ng mga Koneksyon
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Mga Ulat sa Pag-crash para sa Huling { $days } Araw
       *[other] Mga Ulat sa Pag-crash para sa Huling { $days } Araw
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } minutong nakalipas
       *[other] { $minutes } minutong nakalipas
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } oras na nakalipas
       *[other] { $hours } oras na nakalipas
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } araw na nakalipas
       *[other] { $days } araw na nakalipas
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Lahat ng mga Crash Report (kasama ang { $reports } pending na crash sa nabanggit na panahon)
       *[other] Lahat ng mga Crash Report (kasama ang { $reports } pending na mga crash sa nabanggit na panahon)
    }

raw-data-copied = Nakopya na ang raw data sa clipboard
text-copied = Ang teksto ay nakopya na sa clipboard

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Hinarang para sa bersyon ng iyong graphics driver.
blocked-gfx-card = Hinarang para sa iyong graphics card dahil sa mga hindi naresolbang problema sa driver.
blocked-os-version = Hinarang para sa bersyon ng iyong operating system.
blocked-mismatched-version = Hinarang para sa bersyon ng iyong graphics driver dahil sa pagkakaiba ng registry at DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Hinarang para sa bersyon ng iyong graphics driver. Subukang i-update ang iyong graphics driver sa bersyong { $driverVersion } o mas higit pa.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType na mga Parameter

compositing = Compositing
hardware-h264 = Hardware H264 na Pag-decode
main-thread-no-omtc = pangunahing thread, walang OMTC
yes = Oo
no = Hindi
unknown = Hindi Alam
virtual-monitor-disp = Virtual Monitor Display

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Nahanap
missing = Nawawala

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Paglalarawan
gpu-vendor-id = Vendor ID
gpu-device-id = ID ng Device
gpu-subsys-id = ID ng Subsys
gpu-drivers = Mga driver
gpu-ram = RAM
gpu-driver-vendor = Driver Vendor
gpu-driver-version = Bersyon ng Driver
gpu-driver-date = Petsa ng Driver
gpu-active = Aktibo
webgl1-wsiinfo = WebGL 1 Driver WSI Info
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = WebGL 1 Bersyon ng Driver
webgl1-driver-extensions = WebGL 1 Mga Extensyon ng Driver
webgl1-extensions = WebGL 1 Mga extensyon
webgl2-wsiinfo = WebGL 2 Driver WSI Info
webgl2-renderer = WebGL 2 Driver Renderer
webgl2-version = WebGL 2 Bersyon ng Driver
webgl2-driver-extensions = WebGL 2 Mga Extensyon ng Driver
webgl2-extensions = WebGL 2 Mga Extensyon
blocklisted-bug = Naka-blocklist dahil sa mga kilalang problema

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Nakablocklist; failure code { $failureCode }

d3d11layers-crash-guard = D3D11 Compositor
d3d11video-crash-guard = D3D11 Video Decoder
d3d9video-crash-guard = D3D9 Video Decoder
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX Video Decoder

reset-on-next-restart = I-reset sa Susunod na Restart
gpu-process-kill-button = Patigilin ang mga Proseso ng GPU
gpu-device-reset = Device Reset
gpu-device-reset-button = I-trigger ang Pag-reset ng Device
uses-tiling = Paggamit ng Tiling
content-uses-tiling = Gumagamit ng Tiling (Content)
off-main-thread-paint-enabled = Naka-enable ang Off Main Thread Painting
off-main-thread-paint-worker-count = Bilang ng Off Main Thread Painting Worker
target-frame-rate = Target Frame Rate

min-lib-versions = Inaasahang pinakamababang bersyon
loaded-lib-versions = Bersyon na ginagamit

has-seccomp-bpf = Seccomp-BPF (System Call Filtering)
has-seccomp-tsync = Seccomp Thread Synchronization
has-user-namespaces = Mga Namespace ng Gumagamit
has-privileged-user-namespaces = Mga Namespace ng Gumagamit para sa mga pribilihiyong mga proseso
can-sandbox-content = Content Process Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Antas ng Sandbox ng Proseso ng Nilalaman
effective-content-sandbox-level = Effective Content Process Sandbox Level
sandbox-proc-type-content = nilalaman
sandbox-proc-type-file = nilalaman ng file
sandbox-proc-type-media-plugin = plugin ng media
sandbox-proc-type-data-decoder = data decoder

startup-cache-title = Startup Cache
startup-cache-disk-cache-path = Disk Cache Path
startup-cache-ignore-disk-cache = Ignore Disk Cache
startup-cache-found-disk-cache-on-init = Found Disk Cache on Init
startup-cache-wrote-to-disk-cache = Wrote to Disk Cache

launcher-process-status-0 = Naka-enable
launcher-process-status-1 = Na-disable dahil sa pagkasira
launcher-process-status-2 = Sapilitang na-disable
launcher-process-status-unknown = Di-kilalang status

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Pinagana ng gumagamit
multi-process-status-1 = Pinapagana ayon sa default
multi-process-status-2 = Hindi Pinagana
multi-process-status-4 = Na-disable ng mga accessibility tool
multi-process-status-6 = Hindi pinagana ng hindi suportadong text input
multi-process-status-7 = Hindi pinagana ng mga add-on
multi-process-status-8 = Sapilitang hindi pinagana
multi-process-status-unknown = Hindi alam na katayuan

async-pan-zoom = Asynchronous Pan/Zoom
apz-none = wala
wheel-enabled = naka-enable ang wheel input
touch-enabled = naka-enable ang touch input
drag-enabled = naka-enable ang scrollbar drag
keyboard-enabled = naka-enable ang keyboard
autoscroll-enabled = pinagana ang autoscroll
zooming-enabled = smooth pinch-zoom enabled

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = na-disable ang async wheel input dahil sa hindi suportadong pref: { $preferenceKey }
touch-warning = na-disable ang async touch input dahil sa hindi suportadong pref: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Di Aktibo
policies-active = Aktibo
policies-error = Error
