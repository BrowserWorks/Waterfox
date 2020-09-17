# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informacije za rješavanje problema
page-subtitle = Ova stranica sadrži tehničke informacije koje vam mogu biti korisne kada pokušavate riješiti problem. Ukoliko tražite odgovore na često postavljena pitanja o { -brand-short-name }u, posjetite našu <a data-l10n-name="support-link">web stranicu za podršku</a>.

crashes-title = Izvještaji o rušenju
crashes-id = Izvještaj broj
crashes-send-date = Poslano
crashes-all-reports = Svi izvještaji o rušenju
crashes-no-config = Ova aplikacija nije konfigurisana da prikazuje izvještaje o rušenju.
extensions-title = Ekstenzije
extensions-name = Naziv
extensions-enabled = Omogućen
extensions-version = Verzija
extensions-id = ID
support-addons-name = Naziv
support-addons-version = Verzija
support-addons-id = ID
security-software-title = Sigurnosni softver
security-software-type = Tip
security-software-name = Naziv
security-software-antivirus = Antivirus
security-software-antispyware = Antispyware
security-software-firewall = Firewall
features-title = { -brand-short-name } mogućnosti
features-name = Naziv
features-version = Verzija
features-id = ID
processes-title = Udaljeni procesi
processes-type = Tip
processes-count = Broj
app-basics-title = Osnove aplikacije
app-basics-name = Naziv
app-basics-version = Verzija
app-basics-build-id = Build ID
app-basics-update-channel = Kanal za nadograđivanje
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Ažuriraj direktorij
       *[other] Ažuriraj direktorij
    }
app-basics-update-history = Historija nadogradnji
app-basics-show-update-history = Prikaži historiju nadogradnji
# Represents the path to the binary used to start the application.
app-basics-binary = Binarna aplikacija
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Direktorij profila
       *[other] Direktorij profila
    }
app-basics-enabled-plugins = Omogućeni plugini
app-basics-build-config = Konfiguracija verzije
app-basics-user-agent = Korisnički agent
app-basics-os = OS
app-basics-memory-use = Upotreba memorije
app-basics-performance = Performanse
app-basics-service-workers = Registrovani Service Workeri
app-basics-profiles = Profili
app-basics-launcher-process-status = Pokretački proces
app-basics-multi-process-support = Multiprocesni prozori
app-basics-remote-processes-count = Udaljeni procesi
app-basics-enterprise-policies = Enterprise police
app-basics-location-service-key-google = Google Location Service Key
app-basics-safebrowsing-key-google = Google Safebrowsing Key
app-basics-key-mozilla = Mozilla Location Service Key
app-basics-safe-mode = Sigurni režim
show-dir-label =
    { PLATFORM() ->
        [macos] Prikaži u Finderu
        [windows] Otvori folder
       *[other] Otvori direktorij
    }
modified-key-prefs-title = Važne promijenjene postavke
modified-prefs-name = Naziv
modified-prefs-value = Vrijednost
user-js-title = user.js postavke
user-js-description = Direktorij vašeg profila sadrži <a data-l10n-name="user-js-link">user.js fajl</a>, koji uključuje postavke koje nije kreirao { -brand-short-name }.
locked-key-prefs-title = Važne zaključane postavke
locked-prefs-name = Naziv
locked-prefs-value = Vrijednost
graphics-title = Grafika
graphics-features-title = Osobine
graphics-diagnostics-title = Dijagnostika
graphics-failure-log-title = Zapisnik grešaka
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Zapisnik odluka
graphics-crash-guards-title = Onemogućene osobine čuvara rušenja
graphics-workarounds-title = Zaobilazna rješenja
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protokol prozora
place-database-title = Baza podataka mjesta
place-database-integrity = Integritet
place-database-verify-integrity = Verifikuj integritet
a11y-title = Pristupačnost
a11y-activated = Aktivirana
a11y-force-disabled = Prevencija pristupačnosti
a11y-handler-used = Korišteni upravljač pristupačnosti
a11y-instantiator = Instancijator pristupačnosti
library-version-title = Verzije biblioteke
copy-text-to-clipboard-label = Kopiraj tekst na clipboard
copy-raw-data-to-clipboard-label = Kopiraj sirove podatke na clipboard
sandbox-title = Sandbox
sandbox-sys-call-log-title = Odbijeni sistemski pozivi
sandbox-sys-call-index = #
sandbox-sys-call-age = sekundi ranije
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Tip procesa
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumenti
safe-mode-title = Probaj sigurni režim
restart-in-safe-mode-label = Restartuj sa onemogućenim add-onima…

## Media titles

audio-backend = Audio Backend
max-audio-channels = Max kanala
sample-rate = Željeni sample rate
media-title = Medij
media-output-devices-title = Izlazni uređaji
media-input-devices-title = Ulazni uređaji
media-device-name = Naziv
media-device-group = Grupa
media-device-vendor = Proizvođač
media-device-state = Stanje
media-device-preferred = Preferirano
media-device-format = Format
media-device-channels = Kanali
media-device-rate = Brzina
media-device-latency = Kašnjenje
media-capabilities-title = Mogućnosti medija
# List all the entries of the database.
media-capabilities-enumerate = Enumeriraj bazu podataka

##

intl-title = Internacionalizacija & lokalizacija
intl-app-title = Postavke aplikacije
intl-locales-requested = Zatraženi lokali
intl-locales-available = Dostupni lokali
intl-locales-supported = App lokali
intl-locales-default = Glavni lokal
intl-os-title = Operativni sistem
intl-os-prefs-system-locales = Sistemski lokali
intl-regional-prefs = Regionalne postavke

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Udaljeno debagiranje (Chromium protokol)
remote-debugging-accepting-connections = Prihvatanje veza
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Izvještaji o rušenju za protekli { $days } dan
        [few] Izvještaji o rušenju za proteklih { $days } dana
       *[other] Izvještaji o rušenju za proteklih { $days } dana
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Prije { $minutes } minute
        [few] Prije { $minutes } minuta
       *[other] Prije { $minutes } minuta
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Prije { $hours } sat
        [few] Prije { $hours } sati
       *[other] Prije { $hours } sati
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Prije { $days } dan
        [few] Prije { $days } dana
       *[other] Prije { $days } dana
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Svi izvještaji o rušenju (uključujući { $reports } neriješeno rušenje u datom periodu)
        [few] Svi izvještaji o rušenju (uključujući { $reports } neriješena rušenja u datom periodu)
       *[other] Svi izvještaji o rušenju (uključujući { $reports } neriješena rušenja u datom periodu)
    }

raw-data-copied = Sirovi podaci kopirani na clipboard
text-copied = Tekst kopiran na clipboard

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Blokirano za vašu verziju grafičkog drajvera.
blocked-gfx-card = Blokirano za vašu grafičku karticu zbog neriješenih problema sa drajverom.
blocked-os-version = Blokirano zbog verzije vašeg operativnog sistema.
blocked-mismatched-version = Blokiran jer se verzije drajvera vaše grafičke kartice ne podudaraju u registru i DLL-u.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Blokirano za vašu verziju grafičkog drajvera. Pokušajte nadograditi vaš grafički drajvera na verziju { $driverVersion } ili noviju.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType Parametri

compositing = Sastavljanje
hardware-h264 = Hardversko H264 dekodiranje
main-thread-no-omtc = glavna nit, bez OMTC
yes = Da
no = Ne
unknown = Nepoznato
virtual-monitor-disp = Virtualni monitor

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Pronađeno
missing = Nedostaje

gpu-process-pid = GPUProcessPid
gpu-process = GPUPproces
gpu-description = Opis
gpu-vendor-id = ID Izdavača
gpu-device-id = ID Uređaja
gpu-subsys-id = Subsys ID
gpu-drivers = Drajveri
gpu-ram = RAM
gpu-driver-vendor = Proizvođač drajvera
gpu-driver-version = Verzija drajvera
gpu-driver-date = Datum drajvera
gpu-active = Aktivno
webgl1-wsiinfo = WebGL 1 Driver WSI Info
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = WebGL 1 Driver verzija
webgl1-driver-extensions = WebGL 1 Driver ekstenzije
webgl1-extensions = WebGL 1 ekstenzije
webgl2-wsiinfo = WebGL 2 Driver WSI Info
webgl2-renderer = WebGL 2 Driver Renderer
webgl2-version = WebGL 2 Driver verzija
webgl2-driver-extensions = WebGL 2 Driver ekstenzije
webgl2-extensions = WebGL 2 ekstenzije
blocklisted-bug = Blokiran zbog poznatih problema

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Blokiran; kod neuspjeha { $failureCode }

d3d11layers-crash-guard = D3D11 kompozitor
d3d11video-crash-guard = D3D11 Video dekoder
d3d9video-crash-guard = D3D9 Video dekoder
glcontext-crash-guard = OpenGL

reset-on-next-restart = Resetuj vrijednosti kod sljedećeg restarta
gpu-process-kill-button = Okončaj GPU procese
gpu-device-reset = Reset uređaja
gpu-device-reset-button = Okini reset uređaja
uses-tiling = Koristi mozaik
content-uses-tiling = Koristi tiling (sadržaj)
off-main-thread-paint-enabled = Off Main Thread Painting omogućen
off-main-thread-paint-worker-count = Off Main Thread Painting Worker brojač
target-frame-rate = Ciljni Frame Rate

min-lib-versions = Očekivana minimalna verzija
loaded-lib-versions = Verzija u upotrebi

has-seccomp-bpf = Seccomp-BPF (filtriranje sistemskih poziva)
has-seccomp-tsync = Seccomp Thread sinhronizacija
has-user-namespaces = Korisnički namespace-i
has-privileged-user-namespaces = Korisnički namespace-i za privilegovane procese
can-sandbox-content = Sandboxing procesa sadržaja
can-sandbox-media = Sandboxing media plugina
content-sandbox-level = Sanbox nivo procesa sadržaja
effective-content-sandbox-level = Efektivni Content Process Sandbox nivo
sandbox-proc-type-content = sadržaj
sandbox-proc-type-file = sadržaj fajla
sandbox-proc-type-media-plugin = medijski plugin
sandbox-proc-type-data-decoder = dekoder podataka

launcher-process-status-0 = Omogućeno
launcher-process-status-1 = Onemogućeno zbog kvara
launcher-process-status-2 = Prisilno onemogućeno
launcher-process-status-unknown = Nepoznat status

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Korisnički omogućeno
multi-process-status-1 = Izvorno omogućeno
multi-process-status-2 = Onemogućeno
multi-process-status-4 = Onemogućili alati pristupačnosti
multi-process-status-6 = Onemogućio nepodržani unos teksta
multi-process-status-7 = Onemogućili add-oni
multi-process-status-8 = Prisilno onemogućeno
multi-process-status-unknown = Nepoznat status

async-pan-zoom = Asinhrono pomicanje/uvećanje
apz-none = ništa
wheel-enabled = omogućen ulaz točkićem
touch-enabled = omogućen ulaz dodirom
drag-enabled = omogućeno povlačenje scrollbara
keyboard-enabled = tastatura omogućena
autoscroll-enabled = autoscroll omogućen

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = asinhroni ulaz točkićem onemogućen zbog nepodržane postavke: { $preferenceKey }
touch-warning = asinhroni ulaz dodirom onemogućen zbog nepodržane postavke: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Neaktivno
policies-active = Aktivno
policies-error = Greška
