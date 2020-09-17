# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Të dhëna Diagnostikimi
page-subtitle =
    Kjo faqe përmban të dhëna teknike që mund të jenë të dobishme kur përpiqeni
    të zgjidhni një problem. Nëse po shihni për përgjigje për pyetje të rëndomta
    rreth { -brand-short-name }-it, shihni te <a data-l10n-name="support-link">sajti ynë i asistencës</a>.
crashes-title = Njoftime Vithisjesh
crashes-id = ID Njoftimi
crashes-send-date = Parashtruar më
crashes-all-reports = Krejt Njoftimet e Vithisjeve
crashes-no-config = Ky aplikacion nuk është formësuar për shfaqje njoftimesh vithisjeje.
extensions-title = Zgjerime
extensions-name = Emër
extensions-enabled = I aktivizuar
extensions-version = Version
extensions-id = ID
support-addons-title = Shtesa
support-addons-name = Emër
support-addons-type = Lloj
support-addons-enabled = E aktivizuar
support-addons-version = Version
support-addons-id = ID
security-software-title = Software Sigurie
security-software-type = Lloj
security-software-name = Emër
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = Veçori { -brand-short-name }-i
features-name = Emër
features-version = Version
features-id = ID
processes-title = Procese të Largët
processes-type = Lloj
processes-count = Numër
app-basics-title = Të dhëna bazë mbi Aplikacionin
app-basics-name = Emër
app-basics-version = Version
app-basics-build-id = ID Montimi
app-basics-distribution-id = ID Shpërndarjeje
app-basics-update-channel = Kanal Përditësimi
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Drejtori Përditësimesh
       *[other] Dosje Përditësimesh
    }
app-basics-update-history = Historik Përditësimesh
app-basics-show-update-history = Shfaq Historik Përditësimesh
# Represents the path to the binary used to start the application.
app-basics-binary = Dyor Aplikacioni
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Drejtoria e Profilit
       *[other] Dosje Profili
    }
app-basics-enabled-plugins = Shtojca të Aktivizuara
app-basics-build-config = Formësim Montimi
app-basics-user-agent = Agjent Përdoruesi
app-basics-os = OS
app-basics-memory-use = Përdorim Kujtese
app-basics-performance = Punim
app-basics-service-workers = Service Workers të Regjistruar
app-basics-profiles = Profile
app-basics-launcher-process-status = Proces Nisësi
app-basics-multi-process-support = Dritare Multiproces
app-basics-remote-processes-count = Procese të Largët
app-basics-enterprise-policies = Rregulla Në Nivel Ndërmarrjeje
app-basics-location-service-key-google = Kyç Shërbimi Vendndodhjesh Google
app-basics-safebrowsing-key-google = Kyç Google Safebrowsing
app-basics-key-mozilla = Kyç Mozilla Location Service
app-basics-safe-mode = Mënyrë e Sigurt
show-dir-label =
    { PLATFORM() ->
        [macos] Shfaqe në Finder
        [windows] Hape Dosjen
       *[other] Hape Drejtorinë
    }
environment-variables-title = Ndryshore Mjedisi
environment-variables-name = Emër
environment-variables-value = Vlerë
experimental-features-title = Veçori Eksperimentale
experimental-features-name = Emër
experimental-features-value = Vlerë
modified-key-prefs-title = Parapëlqime të Rëndësishme të Ndryshuara
modified-prefs-name = Emër
modified-prefs-value = Vlerë
user-js-title = Parapëlqime për user.js
user-js-description = Dosja juaj e profilit përmban një <a data-l10n-name="user-js-link">kartelë user.js</a>, e cila përfshin parapëlqime që nuk janë krijuar nga { -brand-short-name }-i.
locked-key-prefs-title = Parapëlqime të Rëndësishme të Kyçura
locked-prefs-name = Emër
locked-prefs-value = Vlerë
graphics-title = Grafikë
graphics-features-title = Veçori
graphics-diagnostics-title = Diagnostikime
graphics-failure-log-title = Regjistër Dështimesh
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Regjistër Vendimesh
graphics-crash-guards-title = Veçori të Çaktivizuara nga Roja i Vithisjeve
graphics-workarounds-title = Zgjidhje të përkohshme
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protokoll Window
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Mjedis Desktop
place-database-title = Bazë të Dhënash Vendesh
place-database-integrity = Integritet
place-database-verify-integrity = Verifikoni Integritetin
a11y-title = Përdorshmëri
a11y-activated = E aktivizuar
a11y-force-disabled = Parandaloje Përdorshmërinë
library-version-title = Versione Librarish
copy-text-to-clipboard-label = Kopjoje tekstin te e papastra
copy-raw-data-to-clipboard-label = Kopjo të dhëna të papërpunuara te e papastra
sandbox-title = Bankëprovë
sandbox-sys-call-log-title = Thirrje Sistemi të Hedhura Poshtë
sandbox-sys-call-index = #
sandbox-sys-call-age = Sekonda Më Parë
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Lloj Procesi
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumente
safe-mode-title = Provoni Mënyrën e Parrezik
restart-in-safe-mode-label = Riniseni me Shtesat të Çaktivizuara…
clear-startup-cache-title = Provoni spastrimin e fshehtinës së nisjes
clear-startup-cache-label = Spastroni fshehtinë nisjeje…
startup-cache-dialog-title = Spastroni fshehtinë nisjeje
startup-cache-dialog-body = Që të spastrohet fshehtina e nisjes, rinisni { -brand-short-name }-in. Kjo nuk do të ndryshojë rregullimet tuaja apo të heqë zgjerime që keni shtuar te { -brand-short-name }-i.
restart-button-label = Rinise

## Media titles

audio-backend = Mekanizëm Audio
max-audio-channels = Kanale Maksimum
sample-rate = Shpejtësi e Parapëlqyer Kampionizimesh
roundtrip-latency = Vonesë vajtje-ardhje (shmangie standard)
media-title = Media
media-output-devices-title = Pajisje Dalje
media-input-devices-title = Pajisje Dhëniesh
media-device-name = Emër
media-device-group = Grup
media-device-vendor = Tregtues
media-device-state = Gjendje
media-device-preferred = E parapëlqyer
media-device-format = Format
media-device-channels = Kanale
media-device-rate = Shpeshti
media-device-latency = Vonesë
media-capabilities-title = Aftësi Media
# List all the entries of the database.
media-capabilities-enumerate = Numërtoni bazë të dhënash

##

intl-title = Ndërkombëtarizim & Përkthim
intl-app-title = Rregullime Aplikacionesh
intl-locales-requested = Gjuhë të Kërkuara
intl-locales-available = Gjuhë të Mundshme
intl-locales-supported = Gjuhë Aplikacioni
intl-locales-default = Gjuhë Parazgjedhje
intl-os-title = Sistem Operativ
intl-os-prefs-system-locales = Gjuhë Sistemi
intl-regional-prefs = Parapëlqime Rajoni

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Diagnostikim Së Largëti (Protokolli Chromium)
remote-debugging-accepting-connections = Me Pranim Lidhjesh
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Njoftime Vithisjesh për Ditën e Fundit
       *[other] Njoftime Vithisjesh për { $days } Ditët e Fundit
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } minutë më parë
       *[other] { $minutes } minuta më parë
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } orë më parë
       *[other] { $hours } orë më parë
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } ditë më parë
       *[other] { $days } ditë më parë
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Krejt Njoftimet e Vithisjeve (përfshi { $reports } vithisje të panjoftuar që ndodhi brenda intervalit kohor të dhënë)
       *[other] Krejt Njoftimet e Vithisjeve përfshi { $reports } vithisje të panjoftuara që ndodhën brenda intervalit kohor të dhënë)
    }
raw-data-copied = Të dhënat e papërpunuara u kopjuan te e papastra
text-copied = Teksti u kopjua në të papastër

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = E bllokuar për versionin tuaj të përudhësit grafik.
blocked-gfx-card = E bllokuar në kartën tuaj grafike, për shkak problemesh të pazgjidhura për përudhësin.
blocked-os-version = E bllokuar për versionin tuaj të sistemit operativ.
blocked-mismatched-version = E bllokuar për shkak mospërputhjeje versionesh mes regjistrit dhe DLL-së për përudhësin tuaj grafik.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = E bllokuar për versionin tuaj të përudhësit grafik. Provoni të përditësoni përudhësin tuaj grafik me versionin { $driverVersion } ose më të ri.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametra ClearType
compositing = Hartim
hardware-h264 = Shkodim Hardware H264
main-thread-no-omtc = rrjedhë kryesore, jo OMTC
yes = Po
no = Jo
unknown = E panjohur
virtual-monitor-disp = Shfaqje Nën Monitor Virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = U gjet
missing = Mungon
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Përshkrim
gpu-vendor-id = ID Treguesi
gpu-device-id = ID Pajisjeje
gpu-subsys-id = ID Subsys-i
gpu-drivers = Përudhës
gpu-ram = RAM
gpu-driver-vendor = Shitës Përudhësi
gpu-driver-version = Version Përudhësi
gpu-driver-date = Datë Përudhësi
gpu-active = Aktiv
webgl1-wsiinfo = Të dhëna WSI Përudhësi WebGL 1
webgl1-renderer = Vizatues Përudhësi WebGL 1
webgl1-version = Version Përudhësi WebGL 1
webgl1-driver-extensions = Zgjerime Përudhësi WebGL 1
webgl1-extensions = Zgjerime WebGL 1
webgl2-wsiinfo = Të dhëna WSI Përudhësi WebGL 2
webgl2-renderer = Vizatues WebGL2
webgl2-version = Version Përudhësi WebGL 2
webgl2-driver-extensions = Zgjerime Përudhësi WebGL 2
webgl2-extensions = Zgjerime WebGL 2
blocklisted-bug = Vënë në listë të zezë, për shkak problemesh të njohura
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = e meta { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Shtuar në listë bllokimesh për shkak çështjesh të njohura: <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Vënë në listë të zezë, kod dështimi { $failureCode }
d3d11layers-crash-guard = Hartues D3D11
d3d11video-crash-guard = Shkodues Videosh D3D11
d3d9video-crash-guard = Shkodues Videosh D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Shkodues Videosh WMF VPX
reset-on-next-restart = Gjatë Rinisjes Tjetër Ktheje te Parazgjedhjet
gpu-process-kill-button = Përfundoje Procesin GPU
gpu-device-reset = Rikthim i Pajisjes Në Fillimet
gpu-device-reset-button = Shkakto Rikthim të Pajisjes Në Fillimet
uses-tiling = Përdor Tjegullzim
content-uses-tiling = Përdor Tjegullzim (Lëndë)
min-lib-versions = Version minimum i pritshëm
loaded-lib-versions = Version në përdorim
has-seccomp-bpf = Seccomp-BPF (Filtrim Thirrjesh Sistemi)
has-seccomp-tsync = Njëkohësim Seccomp Rrjedhe
has-user-namespaces = Emërhapësira Përdoruesi
has-privileged-user-namespaces = Emërhapësira Përdoruesi për procese të privilegjuar
can-sandbox-content = Mbajtje Brenda Bankëprovës e Proceseve të Lëndës
can-sandbox-media = Mbajtje Brenda Bankëprovës e Shtojcave Për Media
content-sandbox-level = Shkallë Mbajtjeje Brenda Bankëprovës e Proceseve të Lëndës
effective-content-sandbox-level = Shkallë Efektive Mbajtjeje Brenda Bankëprovës e Proceseve të Lëndës
sandbox-proc-type-content = lëndë
sandbox-proc-type-file = lëndë kartele
sandbox-proc-type-media-plugin = shtojcë mediash
sandbox-proc-type-data-decoder = shkodues të dhënash
startup-cache-title = Fshehtinë Nisjeje
startup-cache-disk-cache-path = Shteg Fshehtine Disku
startup-cache-ignore-disk-cache = Shpërfill Fshehtinë Disku
startup-cache-found-disk-cache-on-init = U gjet Fshehtinë Disku në Init
startup-cache-wrote-to-disk-cache = U shkrua në Fshehtinë Disku
launcher-process-status-0 = E aktivizuar
launcher-process-status-1 = Çaktivizuar për shkak dështimesh
launcher-process-status-2 = Çaktivizuar forcërisht
launcher-process-status-unknown = Gjendje e panjohur
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Aktivizuar nga përdoruesi
multi-process-status-1 = Aktivizuar si parazgjedhje
multi-process-status-2 = I çaktivizuar
multi-process-status-4 = Çaktivizuar nga mjetet e përdorshmërisë
multi-process-status-6 = Çaktivizuar për shkak futje teksti të pambuluar
multi-process-status-7 = Çaktivizuar nga shtesat
multi-process-status-8 = Çaktivizuar forcërisht
multi-process-status-unknown = Gjendje e panjohur
async-pan-zoom = Pan/Zoom Asinkron
apz-none = asnjë
wheel-enabled = me input nga rrotëz miu
touch-enabled = me input nga prekje
drag-enabled = me tërheqje shtylle rrëshqitjeje
keyboard-enabled = me vetërrëshqitje të aktivizuar
autoscroll-enabled = me vetërrëshqitje të aktivizuar

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = input asinkron nga rrotëz miu i çaktivizuar, për shkak parapëlqimi të pambuluar: { $preferenceKey }
touch-warning = input asinkron me prekje i çaktivizuar, për shkak parapëlqimi të pambuluar: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Joaktiv
policies-active = Aktiv
policies-error = Gabim
