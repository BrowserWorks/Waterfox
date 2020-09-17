# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informacije za rozwězowanje problemow
page-subtitle = Toś ten bok wopśimujo techniske informacije, kótarež by mógli wužytne byś, gaž wopytujośo problem rozwězaś. Jolic pytaśo za wótegronami za zwucone pšašanja qó { -brand-short-name }, woglědajśo k našomu <a data-l10n-name="support-link">pódpěrańskemu websydłoju</a>.
crashes-title = Rozpšawy wowalenjow
crashes-id = ID rozpšawy
crashes-send-date = Wótpósłany
crashes-all-reports = Wšykne rozpšawy wowalenjow
crashes-no-config = Nałoženje njejo se konfigurěrowało, aby rozpšawy wowalenjow zwobrazniło.
extensions-title = Rozšyrjenja
extensions-name = Mě
extensions-enabled = Zmóžnjony
extensions-version = Wersija
extensions-id = ID
support-addons-title = Dodanki
support-addons-name = Mě
support-addons-type = Typ
support-addons-enabled = Zmóžnjony
support-addons-version = Wersija
support-addons-id = ID
security-software-title = Wěstotna software
security-software-type = Typ
security-software-name = Mě
security-software-antivirus = Antiwirusowy program
security-software-antispyware = Software pśeśiwo spionažy
security-software-firewall = Wognjowa murja
features-title = Funkcije { -brand-short-name }
features-name = Mě
features-version = Wersija
features-id = ID
processes-title = Zdalone procese
processes-type = Typ
processes-count = Licba
app-basics-title = Zakłady nałoženja
app-basics-name = Mě
app-basics-version = Wersija
app-basics-build-id = Wersijowy ID
app-basics-distribution-id = ID distribucije
app-basics-update-channel = Aktualizěrowański kanal
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Aktualizěrowański zapis
       *[other] Aktualizěrowański zarědnik
    }
app-basics-update-history = Aktualizaciska historija
app-basics-show-update-history = Aktualizacisku historiju pokazaś
# Represents the path to the binary used to start the application.
app-basics-binary = Nałožeńska binarna dataja
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profilowy zarědnik
       *[other] Profilowy zarědnik
    }
app-basics-enabled-plugins = Zmóžnjone tykace
app-basics-build-config = Konfiguracija programoweje wersije
app-basics-user-agent = User Agent
app-basics-os = Źěłowy system
app-basics-memory-use = Wužyty składowak
app-basics-performance = Wugbaśe
app-basics-service-workers = Zregistrěrowane "service workers"
app-basics-profiles = Profile
app-basics-launcher-process-status = Startowański proces
app-basics-multi-process-support = Multiprocesowe wokna
app-basics-remote-processes-count = Zdalone procese
app-basics-enterprise-policies = Pśedewześowe pšawidła
app-basics-location-service-key-google = Kluc stojnišćoweje słužby Google
app-basics-safebrowsing-key-google = Kluc Safebrowsing Google
app-basics-key-mozilla = Kluc słužby póstajenja městna Mozilla
app-basics-safe-mode = Wěsty modus
show-dir-label =
    { PLATFORM() ->
        [macos] W Finder pokazaś
        [windows] Zarědnik wócyniś
       *[other] Zarědnik wócyniś
    }
environment-variables-title = Wokolinowe wariable
environment-variables-name = Mě
environment-variables-value = Gódnota
experimental-features-title = Eksperimentelne funkcije
experimental-features-name = Mě
experimental-features-value = Gódnota
modified-key-prefs-title = Wažne změnjone nastajenja
modified-prefs-name = Mě
modified-prefs-value = Gódnota
user-js-title = Nastajenja w user.js
user-js-description = Waš profilowy zarědnik wopśimujo <a data-l10n-name="user-js-link">dataju user.js</a>, kótaraž wopśimujo nastajenja, kótarež njejsu se pśez { -brand-short-name } napórali.
locked-key-prefs-title = Wažne zastajone nastajenja
locked-prefs-name = Mě
locked-prefs-value = Gódnota
graphics-title = Grafika
graphics-features-title = Funkcije
graphics-diagnostics-title = Diagnostika
graphics-failure-log-title = Protokol njewuspěchow
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Protokol rozsuźenja
graphics-crash-guards-title = Funkcije, kótarež su se wót wowaleńskego stražnika znjemóžnili
graphics-workarounds-title = Nuzowe rozwězanja
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Woknowy protokol
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Desktopowa wokolina
place-database-title = Datowa banka historije a cytańskich znamjenjow
place-database-integrity = Integrita
place-database-verify-integrity = Integritu pśeglědowaś
a11y-title = Bźezbariernosć
a11y-activated = Aktiwěrowany
a11y-force-disabled = Bźezbarjernosći zajźowaś
a11y-handler-used = Pśistupny handler wužyty
a11y-instantiator = Instancěrowak bźezbariernosći
library-version-title = Bibliotekowe wersije
copy-text-to-clipboard-label = Tekst do majzywótkłada kopěrowaś
copy-raw-data-to-clipboard-label = Gropne daty do mjazywótkłada kopěrowaś
sandbox-title = Pěskowy kašćik
sandbox-sys-call-log-title = Wótpokazane systemowe wołanja
sandbox-sys-call-index = #
sandbox-sys-call-age = Pśed sekundami
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Procesowy typ
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumenty
safe-mode-title = Wěsty modus wopytaś
restart-in-safe-mode-label = Ze znjemóžnjonymi dodankami znowego startowaś…
clear-startup-cache-title = Wopytajśo startowy pufrowak wuprozniś
clear-startup-cache-label = Startowy pufrowak wuprozniś…
startup-cache-dialog-title = Startowy pufrowak wuprozniś
startup-cache-dialog-body = Startujśo { -brand-short-name } znowego, aby startowy pufrowak wuproznił. To waše nastajenja njezměnijo abo rozšyrjenja njewótwónoźijo, kótarež sćo pśidał { -brand-short-name }.
restart-button-label = Znowego startowaś

## Media titles

audio-backend = Awdiobackend
max-audio-channels = Maksimalna licba kanalow
sample-rate = Preferěrowana wótsmasowańska rata
roundtrip-latency = Woběgowa latenca (standardne wótchylenje)
media-title = Medije
media-output-devices-title = Wudawańske rědy
media-input-devices-title = Zapódawańske rědy
media-device-name = Mě
media-device-group = Kupka
media-device-vendor = Pśedawaŕ
media-device-state = Status
media-device-preferred = Preferěrowany
media-device-format = Format
media-device-channels = Kanale
media-device-rate = Rata
media-device-latency = Latenca
media-capabilities-title = Medijowe móžnosći
# List all the entries of the database.
media-capabilities-enumerate = Datowu banku nalicyś

##

intl-title = Internacionalizacija a lokalizacija
intl-app-title = Nastajenja nałoženja
intl-locales-requested = Pominane rěcy
intl-locales-available = K dispoziciji stojece rěcy
intl-locales-supported = Rěcy nałoženja
intl-locales-default = Standardna rěc
intl-os-title = Źěłowy system
intl-os-prefs-system-locales = Systemowe rěcy
intl-regional-prefs = Regionalne nastajenja

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Zdalone pytanje zmólkow (protokol Chromium)
remote-debugging-accepting-connections = Zwiski so akceptěruju
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Rozpšawy wó wowalenjach za zachadny { $days } źeń
        [two] Rozpšawy wó wowalenjach za zachadnej { $days } dnja
        [few] Rozpšawy wó wowalenjach za zachadne { $days } dny
       *[other] Rozpšawy wó wowalenjach za zachadnych { $days } dnjow
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] pśed { $minutes } minutu
        [two] pśed { $minutes } minutoma
        [few] pśed { $minutes } minutami
       *[other] pśed { $minutes } minutami
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] pśed { $hours } góźinu
        [two] pśed { $hours } góźinoma
        [few] pśed { $hours } góźinami
       *[other] pśed { $hours } góźinami
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] pśed { $days } dnjom
        [two] pśed { $days } dnjoma
        [few] pśed { $days } dnjami
       *[other] pśed { $days } dnjami
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Wšykne rozpšawy wó wowalenjach (inkluziwnje { $reports } njedocinjone wowalenje w danem casu)
        [two] Wšykne rozpšawy wó wowalenjach (inkluziwnje { $reports } njedocynjonej wowaleni w danem casu)
        [few] Wšykne rozpšawy wó wowalenjach (inkluziwnje { $reports } njedocynjone wowalenja w danem casu)
       *[other] Wšykne rozpšawy wó wowalenjach (inkluziwnje { $reports } njedocinjonych wowalenjow w danem casu)
    }
raw-data-copied = Gropny daty kopěrowane do mjazywótkłada
text-copied = Tekst kopěrowany do mjazywótkłada

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Za wašu wersiju grafiskego gónjaka zablokěrowany.
blocked-gfx-card = Za wašu grafisku kórtu dla njerozwězanych gónjakowych problemow zablokěrowany.
blocked-os-version = Za wašu wersiju źěłowego systema zablokěrowany.
blocked-mismatched-version = Blokěrowany, dokulaž wersija wašogo grafikowego gónjaka rozeznawa se mjazy regstraciju a DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Za wašu wersiju grafiskego gónjaka zablokěrowany. Wopytajśo swój grafiski gónjak na wersiju { $driverVersion } abo nowšu aktualizěrowaś.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametry ClearType
compositing = Compositing
hardware-h264 = Hardwarowe dekoděrowanje H264
main-thread-no-omtc = głowna nitka, žeden OMTC
yes = Jo
no = Ně
unknown = Njeznaty
virtual-monitor-disp = Zwobraznjenje wirtuelnego monitora

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Namakany
missing = Felujucy
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Wopisanje
gpu-vendor-id = ID pśedawarja
gpu-device-id = ID rěda
gpu-subsys-id = Subsys-ID
gpu-drivers = Gónjaki
gpu-ram = RAM
gpu-driver-vendor = Zgótowaŕ gónjaka
gpu-driver-version = Wersija gónjaka
gpu-driver-date = Datum gónjaka
gpu-active = Aktiwny
webgl1-wsiinfo = WebGL 1 Informacije WSI gónjaka
webgl1-renderer = WebGL 1 - kreslak gónjaka
webgl1-version = WebGL 1 - wersija gónjaka
webgl1-driver-extensions = WebGL 1 - rozšyrjenja gónjaka
webgl1-extensions = WebGL1 - rozšyrjenja
webgl2-wsiinfo = WebGL 2 - informacije WSI gónjaka
webgl2-renderer = WebGL 2 - kreslak gónjaka
webgl2-version = WebGL 2 - wersija gónjaka
webgl2-driver-extensions = WebGL 2 - rozšyrjenja gónjaka
webgl2-extensions = WebGL 2 - rozšyrjenja
blocklisted-bug = W blokěrowańskej lisćinje znatych problemow dla
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = programowa zmólka { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = W blokěrowańskej lisćinje znatych problemow dla: <a data-l10n-name="bug-link">programowa zmólka { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = W blokěrowańskej lisćinje; zmólkowy kod { $failureCode }
d3d11layers-crash-guard = D3D11 Compositor
d3d11video-crash-guard = D3D11 Video Decoder
d3d9video-crash-guard = D3D9 Video Decoder
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Wideodekoder WMF VPX
reset-on-next-restart = Pśi pśiducem nowem starśe slědk stajiś
gpu-process-kill-button = GPU-proces skóńcyś
gpu-device-reset = Rěd slědk stajiś
gpu-device-reset-button = Rědowe slědkstajenje zapušćiś
uses-tiling = Wužywa kachlicki
content-uses-tiling = Wužywa kachlickowanje (wopśimjeśe)
off-main-thread-paint-enabled = Off Main Thread Painting zmóžnjony
off-main-thread-paint-worker-count = Licba workerow Off Main Thread Painting
target-frame-rate = Celowa wobceŕkowa cestosć
min-lib-versions = Wótcakowana minimalna wersija
loaded-lib-versions = Wužyta wersija
has-seccomp-bpf = Seccomp-BPF (Filtrowanje systemowych zawołanjow)
has-seccomp-tsync = Nitkowa synchronizacija Seccomp
has-user-namespaces = Wužywaŕske mjenjowe rumy
has-privileged-user-namespaces = Wužywaŕske mjenjowe rumy za priwilegěrowane procese
can-sandbox-content = Testowanje wopśimjeśowych procesow w pěskowem kašćiku
can-sandbox-media = Testowanje medijowych tykacow w pěskowem kašćiku
content-sandbox-level = Rownina wopśimjeśowych procesow w pěskowem kašćiku
effective-content-sandbox-level = Aktualna rownina wopśimjeśowych procesow w pěskowem kašćiku
sandbox-proc-type-content = wopśimjeśe
sandbox-proc-type-file = datajowe wopśimjeśe
sandbox-proc-type-media-plugin = medijowy tykac
sandbox-proc-type-data-decoder = dekoděrowak datow
startup-cache-title = Startowy pufrowak
startup-cache-disk-cache-path = Sćažka platowego pufrowaka
startup-cache-ignore-disk-cache = Platowy pufrowak ignorěrowaś
startup-cache-found-disk-cache-on-init = Platowy pufrowak jo se namakał pśi inicializěrowanju
startup-cache-wrote-to-disk-cache = Jo se napisało do platowego pufrowaka
launcher-process-status-0 = Zmóžnjony
launcher-process-status-1 = Zmólki dla znjemóžnjony
launcher-process-status-2 = Z nuzkanim znjemóžnjony
launcher-process-status-unknown = Njeznaty status
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Wót wužywarja zmóžnjony
multi-process-status-1 = Pó standarźe zmóžnjony
multi-process-status-2 = Znjemóžnjony
multi-process-status-4 = Pśez rědy bźezbariernosći znjemóžnjony
multi-process-status-6 = Pśez njepódpěrane tekstowe zapódaśe znjemóžnjony
multi-process-status-7 = Pśez dodanki znjemóžnjony
multi-process-status-8 = Namócnje znjemóžnjony
multi-process-status-unknown = Njeznaty status
async-pan-zoom = Asynchrone pśesuwanje/skalěrowanje
apz-none = žeden
wheel-enabled = zapódaśe z kólaskom zmóžnjone
touch-enabled = zapódaśe pśez dotyknjenje zmóžnjone
drag-enabled = śěgnjenje suwańskeje rědki zmóžnjone
keyboard-enabled = tastatura zmóžnjona
autoscroll-enabled = awtomatiske kulanje zmóžnjone
zooming-enabled = pózlažke dwójopalcowe skalěrowanje zmóžnjone

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = asynchrone zapódaśe z kólaskom jo se njepódpěranego nastajenja znjemóžniło: { $preferenceKey }
touch-warning = asynchrone zapódaśe pśez dotyknjenje jo se njepódpěranego nastajenja znjemóžniło: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Njeaktiwny
policies-active = Aktiwny
policies-error = Zmólka
