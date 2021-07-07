# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Hibakeresési információ
page-subtitle = Ez az oldal problémakeresésnél használható technikai információkat tartalmaz. Ha a { -brand-short-name } programmal kapcsolatos gyakori kérdésekre keresi a választ, akkor nézze meg a <a data-l10n-name="support-link">támogató weboldalunkat</a>.
crashes-title = Hibajelentések
crashes-id = Jelentésazonosító
crashes-send-date = Elküldve
crashes-all-reports = Minden hibajelentés
crashes-no-config = Ez az alkalmazás nincs a hibajelentések megjelenítésére beállítva.
extensions-title = Kiegészítők
extensions-name = Név
extensions-enabled = Engedélyezve
extensions-version = Verzió
extensions-id = Azonosító
support-addons-title = Kiegészítők
support-addons-name = Név
support-addons-type = Típus
support-addons-enabled = Engedélyezve
support-addons-version = Verzió
support-addons-id = Azonosító
security-software-title = Biztonsági szoftver
security-software-type = Típus
security-software-name = Név
security-software-antivirus = Antivírus
security-software-antispyware = Kémprogram-elhárító
security-software-firewall = Tűzfal
features-title = A { -brand-short-name } szolgáltatásai
features-name = Név
features-version = Verzió
features-id = Azonosító
processes-title = Távoli folyamatok
processes-type = Típus
processes-count = Darabszám
app-basics-title = Alkalmazás alapadatai
app-basics-name = Név
app-basics-version = Verzió
app-basics-build-id = Build az.
app-basics-distribution-id = Terjesztési azonosító
app-basics-update-channel = Frissítési csatorna
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Könyvtár frissítése
       *[other] Mappa frissítése
    }
app-basics-update-history = Frissítési előzmények
app-basics-show-update-history = Frissítési előzmények megjelenítése
# Represents the path to the binary used to start the application.
app-basics-binary = Alkalmazás binárisa
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profilkönyvtár
       *[other] Profilmappa
    }
app-basics-enabled-plugins = Engedélyezett bővítmények
app-basics-build-config = Build konfiguráció
app-basics-user-agent = Felhasználói ügynök
app-basics-os = OS
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Rosettával fordított
app-basics-memory-use = Memóriahasználat
app-basics-performance = Teljesítmény
app-basics-service-workers = Regisztrált Service Workerek
app-basics-third-party = Harmadik féltől származó modulok
app-basics-profiles = Profilok
app-basics-launcher-process-status = Indító folyamat
app-basics-multi-process-support = Több folyamatú ablakok
app-basics-fission-support = Fission-ablakok
app-basics-remote-processes-count = Távoli folyamatok
app-basics-enterprise-policies = Vállalati házirendek
app-basics-location-service-key-google = Google helymeghatározási szolgáltatás kulcs
app-basics-safebrowsing-key-google = Google Safebrowsing kulcs
app-basics-key-mozilla = Mozilla helymeghatározási szolgáltatás kulcs
app-basics-safe-mode = Csökkentett mód
show-dir-label =
    { PLATFORM() ->
        [macos] Megjelenítés a Finderben
        [windows] Mappa megnyitása
       *[other] Könyvtár megnyitása
    }
environment-variables-title = Környezeti változók
environment-variables-name = Név
environment-variables-value = Érték
experimental-features-title = Kísérleti funkciók
experimental-features-name = Név
experimental-features-value = Érték
modified-key-prefs-title = Fontos, módosított beállítások
modified-prefs-name = Név
modified-prefs-value = Érték
user-js-title = user.js beállítások
user-js-description = Profilmappája tartalmaz egy <a data-l10n-name="user-js-link">user.js fájlt</a>, amely nem a { -brand-short-name } által létrehozott beállításokat is tartalmaz.
locked-key-prefs-title = Fontos zárolt beállítások
locked-prefs-name = Név
locked-prefs-value = Érték
graphics-title = Grafika
graphics-features-title = Képességek
graphics-diagnostics-title = Diagnosztika
graphics-failure-log-title = Hibanapló
graphics-gpu1-title = 1. GPU
graphics-gpu2-title = 2. GPU
graphics-decision-log-title = Döntésnapló
graphics-crash-guards-title = Összeomlásvédelem által letiltott funkciók
graphics-workarounds-title = Kerülő eljárások
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Ablakprotokoll
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Asztali környezet
place-database-title = Helyek adatbázisa
place-database-integrity = Sértetlenség
place-database-verify-integrity = Sértetlenség ellenőrzése
a11y-title = Kisegítő lehetőségek
a11y-activated = Aktiválva
a11y-force-disabled = Kisegítő lehetőségek letiltása
a11y-handler-used = Használt akadálymentesítés-kezelő
a11y-instantiator = Kisegítő lehetőségek kezdeményezője
library-version-title = Könyvtárak verziói
copy-text-to-clipboard-label = Szöveg másolása a vágólapra
copy-raw-data-to-clipboard-label = Nyers adatok másolása a vágólapra
sandbox-title = Sandbox
sandbox-sys-call-log-title = Elutasított rendszerhívások
sandbox-sys-call-index = #
sandbox-sys-call-age = másodperce
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Folyamattípus
sandbox-sys-call-number = Rendszerhívás
sandbox-sys-call-args = Argumentumok
safe-mode-title = Biztonságos mód kipróbálása
restart-in-safe-mode-label = Újraindítás letiltott kiegészítőkkel…
troubleshoot-mode-title = Problémák diagnosztizálása
restart-in-troubleshoot-mode-label = Hibaelhárítási mód…
clear-startup-cache-title = Próbálja meg üríteni az indítási gyorsítótárat
clear-startup-cache-label = Indítási gyorsítótár törlése…
startup-cache-dialog-title2 = Újraindítja a { -brand-short-name }ot az indítási gyorsítótár törléséhez?
startup-cache-dialog-body2 = Ez nem módosítja a beállításait, és nem távolít el kiegészítőket.
restart-button-label = Újraindítás

## Media titles

audio-backend = Hang háttérprogram
max-audio-channels = Csatornák maximum
sample-rate = Elsődleges mintavételezési sebesség
roundtrip-latency = Oda-vissza út késleltetése (szórás)
media-title = Média
media-output-devices-title = Kimeneti eszközök
media-input-devices-title = Bemeneti eszközök
media-device-name = Név
media-device-group = Csoport
media-device-vendor = Gyártó
media-device-state = Állapot
media-device-preferred = Elsődleges
media-device-format = Formátum
media-device-channels = Csatornák
media-device-rate = Sebesség
media-device-latency = Késleltetés
media-capabilities-title = Médiafunkciók
# List all the entries of the database.
media-capabilities-enumerate = Adatbázis felsorolása

##

intl-title = Nemzetköziesítés és honosítás
intl-app-title = Alkalmazásbeállítások
intl-locales-requested = Kért területi beállítások
intl-locales-available = Rendelkezésre álló területi beállítások
intl-locales-supported = Alkalmazás területi beállításai
intl-locales-default = Alapértelmezett területi beállítás
intl-os-title = Operációs rendszer
intl-os-prefs-system-locales = Rendszer területi beállításai
intl-regional-prefs = Területi beállítások

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Távoli hibakeresés (Chromium protokoll)
remote-debugging-accepting-connections = Kapcsolatok elfogadása
remote-debugging-url = URL

##

support-third-party-modules-title = Harmadik féltől származó modulok
support-third-party-modules-module = Modulfájl
support-third-party-modules-version = Fájlverzió
support-third-party-modules-vendor = Szállítói információk
support-third-party-modules-occurrence = Előfordulás
support-third-party-modules-process = Folyamattípus és azonosító
support-third-party-modules-thread = Szál
support-third-party-modules-base = Imagebase cím
support-third-party-modules-uptime = Folyamat üzemideje (ms)
support-third-party-modules-duration = Betöltés időtartama (ms)
support-third-party-modules-status = Állapot
support-third-party-modules-status-loaded = Betöltött
support-third-party-modules-status-blocked = Blokkolt
support-third-party-modules-status-redirected = Átirányított
support-third-party-modules-empty = Nincs harmadik féltől származó modul betöltve.
support-third-party-modules-no-value = (Nincs érték)
support-third-party-modules-button-open =
    .title = A fájl helyének megnyitása…
support-third-party-modules-expand =
    .title = Részletes információk megjelenítése
support-third-party-modules-collapse =
    .title = Részletes információk összecsukása
support-third-party-modules-unsigned-icon =
    .title = Ez a modul nincs aláírva
support-third-party-modules-folder-icon =
    .title = A fájl helyének megnyitása…
support-third-party-modules-down-icon =
    .title = Részletes információk megjelenítése
support-third-party-modules-up-icon =
    .title = Részletes információk összecsukása
# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Hibajelentések az elmúlt { $days } napról
       *[other] Hibajelentések az elmúlt { $days } napról
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } perce
       *[other] { $minutes } perce
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } órája
       *[other] { $hours } órája
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } napja
       *[other] { $days } napja
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Minden hibajelentés (beleértve { $reports } függőben lévő hibajelentést az adott időszakban)
       *[other] Minden hibajelentés (beleértve { $reports } függőben lévő hibajelentést az adott időszakban)
    }
raw-data-copied = Nyers adatok a vágólapra másolva
text-copied = Szöveg a vágólapra másolva

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Ezzel a grafikus illesztőprogrammal nem engedélyezett az együttműködés.
blocked-gfx-card = Megoldatlan illesztőprogram-problémák miatt nem engedélyezett ezen a grafikus kártyán.
blocked-os-version = Nem engedélyezett ezen az operációs rendszeren.
blocked-mismatched-version = Blokkolva a grafikus illesztőprogram verzióeltérése miatt a beállításjegyzék és a DLL közt
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Ezzel a grafikus illesztőprogrammal nem engedélyezett az együttműködés. Próbálja meg frissíteni a grafikus illesztőprogramot { $driverVersion } vagy újabb verzióra.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType-paraméterek
compositing = Kompozitálás
hardware-h264 = Hardveres H264-dekódolás
main-thread-no-omtc = fő szál, nincs OMTC
yes = Igen
no = Nem
unknown = Ismeretlen
virtual-monitor-disp = Virtuális monitorkijelző

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Megtalálva
missing = Hiányzik
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Leírás
gpu-vendor-id = Gyártóazonosító
gpu-device-id = Eszközazonosító
gpu-subsys-id = Alrendszer-azonosító
gpu-drivers = Illesztőprogramok
gpu-ram = RAM
gpu-driver-vendor = Illesztőprogram szállítója
gpu-driver-version = Illesztőprogram verziója
gpu-driver-date = Illesztőprogram dátuma
gpu-active = Aktív
webgl1-wsiinfo = WebGL 1 illesztőprogram WSI Info
webgl1-renderer = WebGL 1 illesztőprogram megjelenítő
webgl1-version = WebGL 1 illesztőprogram verzió
webgl1-driver-extensions = WebGL 1 illesztőprogram kiterjesztései
webgl1-extensions = WebGL 1 kiterjesztések
webgl2-wsiinfo = WebGL 2 illesztőprogram WSI Info
webgl2-renderer = WebGL 2 illesztőprogram megjelenítő
webgl2-version = WebGL 2 illesztőprogram verzió
webgl2-driver-extensions = WebGL 2 illesztőprogram kiterjesztései
webgl2-extensions = WebGL 2 kiterjesztések
blocklisted-bug = Ismert problémák miatt blokkolva
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = { $bugNumber } számú hiba
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Ismert problémák miatt blokkolva: <a data-l10n-name="bug-link">{ $bugNumber }. hiba</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blokkolva, hibakód: { $failureCode }
d3d11layers-crash-guard = D3D11 kompozitáló
d3d11video-crash-guard = D3D11 videodekóder
d3d9video-crash-guard = D3D9 videodekóder
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX videodekóder
reset-on-next-restart = Újraindításkor alaphelyzetbe
gpu-process-kill-button = GPU folyamat leállítása
gpu-device-reset = Eszköz visszaállítása
gpu-device-reset-button = Eszköz alapállapotba hozása
uses-tiling = Csempézés használata
content-uses-tiling = Csempézés használata (Tartalom)
off-main-thread-paint-enabled = Fő szálon kívüli rajzolás engedélyezve
off-main-thread-paint-worker-count = Fő szálon kívüli rajzoló workerek száma
target-frame-rate = Cél képkockasebesség
min-lib-versions = Elvárt minimális verzió
loaded-lib-versions = Használt verzió
has-seccomp-bpf = Seccomp-BPF (rendszerhívás-szűrés)
has-seccomp-tsync = Seccomp szálszinkronizáció
has-user-namespaces = Felhasználói névterek
has-privileged-user-namespaces = Felhasználói névterek privilegizált folyamatokhoz
can-sandbox-content = Tartalomfolyamat sandboxing
can-sandbox-media = Médiabővítmény sandboxing
content-sandbox-level = Tartalomfolyamat sandboxing szintje
effective-content-sandbox-level = Tartalomfolyamat tényleges sandboxing szintje
content-win32k-lockdown-state = Win32k zárolási állapot a tartalmi folyamathoz
sandbox-proc-type-content = tartalom
sandbox-proc-type-file = fájltartalom
sandbox-proc-type-media-plugin = médiabővítmény
sandbox-proc-type-data-decoder = adatdekódoló
startup-cache-title = Indítási gyorsítótár
startup-cache-disk-cache-path = Lemezgyorsítótár elérési útja
startup-cache-ignore-disk-cache = Lemezgyorsítótár figyelmen kívül hagyása
startup-cache-found-disk-cache-on-init = Lemezgyorsítótár megtalálva indításkor
startup-cache-wrote-to-disk-cache = Lemezgyorsítótárba írva
launcher-process-status-0 = Engedélyezve
launcher-process-status-1 = Hiba miatt letiltva
launcher-process-status-2 = Kényszerítve letiltva
launcher-process-status-unknown = Ismeretlen állapot
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = A felhasználó engedélyezte
multi-process-status-1 = Alapértelmezésben engedélyezve
multi-process-status-2 = Tiltva
multi-process-status-4 = Akadálymentesítési eszközök letiltották
multi-process-status-6 = A nem támogatott szövegbevitel letiltotta
multi-process-status-7 = Kiegészítők letiltották
multi-process-status-8 = Kikapcsolása kényszerítve
multi-process-status-unknown = Ismeretlen állapot
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Kísérlet által letiltva
fission-status-experiment-treatment = Kísérlet által engedélyezve
fission-status-disabled-by-e10s-env = Környezet által letiltva
fission-status-enabled-by-env = Környezet által engedélyezve
fission-status-disabled-by-safe-mode = Csökkentett mód miatt letiltva
fission-status-enabled-by-default = Alapértelmezésben engedélyezve
fission-status-disabled-by-default = Alapértelmezésben tiltva
fission-status-enabled-by-user-pref = A felhasználó által engedélyezve
fission-status-disabled-by-user-pref = A felhasználó által letiltva
fission-status-disabled-by-e10s-other = E10s letiltva
fission-status-enabled-by-rollout = Szakaszos bevezetés által engedélyezve
async-pan-zoom = Aszinkron görgetés/nagyítás
apz-none = nincs
wheel-enabled = kerékbemenet engedélyezve
touch-enabled = érintőbemenet engedélyezve
drag-enabled = gördítősáv húzása engedélyezve
keyboard-enabled = billentyűzet engedélyezve
autoscroll-enabled = automatikus görgetés engedélyezve
zooming-enabled = sima csípéssel történő nagyítás engedélyezve

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = aszinkron kerékbemenet letiltva egy nem támogatott beállítás miatt: { $preferenceKey }
touch-warning = aszinkron érintőbemenet letiltva egy nem támogatott beállítás miatt: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Inaktív
policies-active = Aktív
policies-error = Hiba

## Printing section

support-printing-title = Nyomtatás
support-printing-troubleshoot = Hibaelhárítás
support-printing-clear-settings-button = Mentett nyomtatási beállítások törlése
support-printing-modified-settings = Módosított nyomtatási beállítások
support-printing-prefs-name = Név
support-printing-prefs-value = Érték

## Normandy sections

support-remote-experiments-title = Távoli kísérletek
support-remote-experiments-name = Név
support-remote-experiments-branch = Kísérleti ág
support-remote-experiments-see-about-studies = További információkért tekintse meg az <a data-l10n-name="support-about-studies-link">about:studies</a> oldalt, beleértve az egyes kísérletek letiltásának módját, vagy annak, hogy a { -brand-short-name } ne futtasson többé ilyen típusú kísérleteket.
support-remote-features-title = Távoli funkciók
support-remote-features-name = Név
support-remote-features-status = Állapot
