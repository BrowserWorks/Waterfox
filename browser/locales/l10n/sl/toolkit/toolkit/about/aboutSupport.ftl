# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Odpravljanje težav
page-subtitle =
    Ta stran vsebuje tehnične podatke, ki jih boste morda potrebovali pri odpravljanju
    težav. Če iščete odgovore na splošna vprašanja o programu
    { -brand-short-name }, obiščite <a data-l10n-name="support-link">strani za podporo uporabnikom</a>.
crashes-title = Poročila o sesutjih
crashes-id = ID poročila
crashes-send-date = Datum pošiljanja
crashes-all-reports = Vsa poročila o sesutjih
crashes-no-config = Ta program ni bil nastavljen za prikaz poročil o sesutjih.
extensions-title = Razširitve
extensions-name = Ime
extensions-enabled = Vključeno
extensions-version = Različica
extensions-id = ID
support-addons-title = Dodatki
support-addons-name = Ime
support-addons-type = Vrsta
support-addons-enabled = Omogočen
support-addons-version = Različica
support-addons-id = ID
security-software-title = Varnostna programska oprema
security-software-type = Vrsta
security-software-name = Ime
security-software-antivirus = Protivirusna zaščita
security-software-antispyware = Protivohunska programska oprema
security-software-firewall = Požarni zid
features-title = Zmogljivosti { -brand-short-name }a
features-name = Ime
features-version = Različica
features-id = ID
processes-title = Oddaljeni procesi
processes-type = Vrsta
processes-count = Število
app-basics-title = Osnovni podatki
app-basics-name = Ime
app-basics-version = Različica
app-basics-build-id = ID gradnje
app-basics-distribution-id = ID distribucije
app-basics-update-channel = Posodobitveni kanal
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Mapa za posodobitve
       *[other] Mapa za posodobitve
    }
app-basics-update-history = Zgodovina posodobitev
app-basics-show-update-history = Prikaži zgodovino posodobitev
# Represents the path to the binary used to start the application.
app-basics-binary = Binarna datoteka aplikacije
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Mapa s profilom
       *[other] Mapa s profilom
    }
app-basics-enabled-plugins = Omogočeni vtičniki
app-basics-build-config = Nastavitev graditve
app-basics-user-agent = Uporabniški agent
app-basics-os = OS
app-basics-memory-use = Poraba pomnilnika
app-basics-performance = Učinkovitost
app-basics-service-workers = Registrirani Service Workerji
app-basics-profiles = Profili
app-basics-launcher-process-status = Proces zaganjača
app-basics-multi-process-support = Večprocesna okna
app-basics-remote-processes-count = Oddaljeni procesi
app-basics-enterprise-policies = Pravilniki za podjetja
app-basics-location-service-key-google = Ključ lokacijskih storitev Google
app-basics-safebrowsing-key-google = Ključ Google Safebrowsing
app-basics-key-mozilla = Ključ lokacijskih storitev Mozilla
app-basics-safe-mode = Varni način
show-dir-label =
    { PLATFORM() ->
        [macos] Prikaži v Finderju
        [windows] Odpri mapo
       *[other] Odpri mapo
    }
environment-variables-title = Spremenljivke okolja
environment-variables-name = Ime
environment-variables-value = Vrednost
experimental-features-title = Poskusne zmogljivosti
experimental-features-name = Ime
experimental-features-value = Vrednost
modified-key-prefs-title = Pomembne spremenjene nastavitve
modified-prefs-name = Ime
modified-prefs-value = Vrednost
user-js-title = Nastavitve user.js
user-js-description = V vaši mapi s profilom se nahaja <a data-l10n-name="user-js-link">datoteka user.js</a>, ki vsebuje nastavitve, ki jih ni ustvaril { -brand-short-name }.
locked-key-prefs-title = Pomembne zaklenjene nastavitve
locked-prefs-name = Ime
locked-prefs-value = Vrednost
graphics-title = Grafika
graphics-features-title = Možnosti
graphics-diagnostics-title = Diagnostika
graphics-failure-log-title = Dnevnik napak
graphics-gpu1-title = GPE št. 1
graphics-gpu2-title = GPE št. 2
graphics-decision-log-title = Dnevnik odločitev
graphics-crash-guards-title = Onemogočene možnosti zaščite pred sesutjem
graphics-workarounds-title = Zaobidenja
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Okenski protokol
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Namizno okolje
place-database-title = Podatkovna zbirka mest
place-database-integrity = Celovitost
place-database-verify-integrity = Preveri celovitost
a11y-title = Dostopnost
a11y-activated = Vključeno
a11y-force-disabled = Prepreči dostopnost
a11y-handler-used = Uporabljen upravljalec dostopnosti
a11y-instantiator = Uporabnik storitve dostopnosti
library-version-title = Različice knjižnic
copy-text-to-clipboard-label = Kopiraj besedilo v odložišče
copy-raw-data-to-clipboard-label = Kopiraj neobdelane podatke v odložišče
sandbox-title = Peskovnik
sandbox-sys-call-log-title = Zavrnjeni sistemski klici
sandbox-sys-call-index = Št.
sandbox-sys-call-age = Pred nekaj sekundami
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Vrsta procesa
sandbox-sys-call-number = Sistemski klic
sandbox-sys-call-args = Argumenti
safe-mode-title = Poskusite varni način
restart-in-safe-mode-label = Ponovno zaženi z onemogočenimi dodatki …
clear-startup-cache-title = Poskusite počistiti predpomnilnik zagona
clear-startup-cache-label = Počisti predpomnilnik zagona …
startup-cache-dialog-title = Počistite predpomnilnik zagona
startup-cache-dialog-body = Ponovno zaženite { -brand-short-name }, da počistite predpomnilnik zagona. To ne bo spremenilo vaših nastavitev ali odstranilo razširitev, ki ste jih dodali v { -brand-short-name }.
restart-button-label = Ponovno zaženi

## Media titles

audio-backend = Zvočno zaledje
max-audio-channels = Največje število kanalov
sample-rate = Prednostna hitrost vzorčenja
roundtrip-latency = Zakasnitev povratnega potovanja (standardni odklon)
media-title = Predstavnost
media-output-devices-title = Izhodne naprave
media-input-devices-title = Vhodne naprave
media-device-name = Ime
media-device-group = Skupina
media-device-vendor = Ponudnik
media-device-state = Stanje
media-device-preferred = Prednostno
media-device-format = Oblika
media-device-channels = Kanali
media-device-rate = Hitrost
media-device-latency = Zakasnitev
media-capabilities-title = Zmogljivosti večpredstavnosti
# List all the entries of the database.
media-capabilities-enumerate = Oštevilči bazo podatkov

##

intl-title = Jeziki in lokalizacija
intl-app-title = Nastavitve programa
intl-locales-requested = Zahtevani jeziki
intl-locales-available = Jeziki na voljo
intl-locales-supported = Jeziki programa
intl-locales-default = Privzeti jezik
intl-os-title = Operacijski sistem
intl-os-prefs-system-locales = Sistemski jeziki
intl-regional-prefs = Območne nastavitve

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Oddaljeno razhroščevanje (protokol Chromium)
remote-debugging-accepting-connections = Sprejema povezave
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Poročila o sesutjih za zadnji dan
        [two] Poročila o sesutjih za zadnja { $days } dni
        [few] Poročila o sesutjih za zadnje { $days } dni
       *[other] Poročila o sesutjih za zadnjih { $days } dni
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Pred { $minutes } minuto
        [two] Pred { $minutes } minutama
        [few] Pred { $minutes } minutami
       *[other] Pred { $minutes } minutami
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Pred { $hours } uro
        [two] Pred { $hours } urama
        [few] Pred { $hours } urami
       *[other] Pred { $hours } urami
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Pred { $days } dnem
        [two] Pred { $days } dnevoma
        [few] Pred { $days } dnevi
       *[other] Pred { $days } dnevi
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Vsa poročila o sesutjih, vključno z { $reports } čakajočim sesutjem v danem časovnem obsegu
        [two] Vsa poročila o sesutjih, vključno z { $reports } čakajočima sesutjema v danem časovnem obsegu
        [few] Vsa poročila o sesutjih, vključno s { $reports } čakajočimi sesutji v danem časovnem obsegu
       *[other] Vsa poročila o sesutjih, vključno s { $reports } čakajočimi sesutji v danem časovnem obsegu
    }
raw-data-copied = Neobdelani podatki kopirani v odložišče
text-copied = Besedilo kopirano v odložišče

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Onemogočeno za vaš grafični gonilnik.
blocked-gfx-card = Onemogočeno za vašo grafično kartico zaradi težav z gonilnikom.
blocked-os-version = Onemogočeno za vaš operacijski sistem.
blocked-mismatched-version = Onemogočeno zaradi neujemanja različice grafičnega gonilnika v registru in DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Onemogočeno za vaš grafični gonilnik. Poskusite ga posodobiti na različico { $driverVersion } ali novejšo.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parametri ClearType
compositing = Sestavljanje
hardware-h264 = Strojno dekodiranje H264
main-thread-no-omtc = glavna nit, brez OMTC
yes = Da
no = Ne
unknown = Neznano
virtual-monitor-disp = Navidezni zaslon

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Najdeno
missing = Manjka
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Opis
gpu-vendor-id = ID izdelovalca
gpu-device-id = ID naprave
gpu-subsys-id = ID podsistema
gpu-drivers = Gonilniki
gpu-ram = RAM
gpu-driver-vendor = Ponudnik gonilnika
gpu-driver-version = Različica gonilnika
gpu-driver-date = Datum gonilnika
gpu-active = Dejaven
webgl1-wsiinfo = Podatki WSI o gonilniku WebGL 1
webgl1-renderer = Izrisovalnik gonilnika WebGL 1
webgl1-version = Različica gonilnika WebGL 1
webgl1-driver-extensions = Razširitve gonilnika WebGL 1
webgl1-extensions = Razširitve WebGL 1
webgl2-wsiinfo = Podatki WSI o gonilniku WebGL 2
webgl2-renderer = Izrisovalnik gonilnika WebGL 2
webgl2-version = Različica gonilnika WebGL 2
webgl2-driver-extensions = Razširitve gonilnika WebGL 2
webgl2-extensions = Razširitve WebGL 2
blocklisted-bug = Dodano na seznam zavrnjenih zaradi znanih težav
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = hrošč { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Dodano na seznam zavrnjenih zaradi znanih težav: <a data-l10n-name="bug-link">hrošč { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Dodano na seznam zavrnjenih; koda napake { $failureCode }
d3d11layers-crash-guard = Sestavljalnik D3D11
d3d11video-crash-guard = Videodekodirnik D3D11
d3d9video-crash-guard = Videodekodirnik D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Videodekodirnik WMF VPX
reset-on-next-restart = Ponastavi ob naslednjem zagonu
gpu-process-kill-button = Prekini proces GPE
gpu-device-reset = Ponastavitev naprave
gpu-device-reset-button = Sproži ponastavitev naprave
uses-tiling = Uporablja razpostavljanje
content-uses-tiling = Uporablja razpostavljanje (vsebina)
off-main-thread-paint-enabled = Izrisovanje izven glavne niti je omogočeno
off-main-thread-paint-worker-count = Število workerjev za izrisovanje izven glavne niti
target-frame-rate = Ciljna hitrost sličic
min-lib-versions = Najnižja podprta različica
loaded-lib-versions = Trenutna različica
has-seccomp-bpf = Seccomp-BPF (Filtriranje sistemskih klicev)
has-seccomp-tsync = Sinhronizacija niti Seccomp
has-user-namespaces = Uporabniški imenski prostori
has-privileged-user-namespaces = Uporabniški imenski prostori za privilegirane procese
can-sandbox-content = Peskovnik vsebinskih procesov
can-sandbox-media = Peskovnik večpredstavnih vtičnikov
content-sandbox-level = Raven peskovnika vsebinskih opravil
effective-content-sandbox-level = Dejanska raven peskovnika vsebinskih opravil
sandbox-proc-type-content = vsebina
sandbox-proc-type-file = vsebina datoteke
sandbox-proc-type-media-plugin = večpredstavni vtičnik
sandbox-proc-type-data-decoder = podatkovni dekodirnik
startup-cache-title = Predpomnilnik zagona
startup-cache-disk-cache-path = Pot predpomnilnika diska
startup-cache-ignore-disk-cache = Prezri predpomnilnik diska
startup-cache-found-disk-cache-on-init = Najden predpomnilnik diska ob inicializaciji
startup-cache-wrote-to-disk-cache = Zapisano v predpomnilnik diska
launcher-process-status-0 = Omogočeno
launcher-process-status-1 = Onemogočeno zaradi napake
launcher-process-status-2 = Prisilno onemogočeno
launcher-process-status-unknown = Neznano stanje
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Omogočil uporabnik
multi-process-status-1 = Privzeto omogočeno
multi-process-status-2 = Onemogočeno
multi-process-status-4 = Onemogočila orodja za dostopnost
multi-process-status-6 = Onemogočeno zaradi nepodprtega vnosa besedila
multi-process-status-7 = Onemogočili dodatki
multi-process-status-8 = Prisilno onemogočeno
multi-process-status-unknown = Neznano stanje
async-pan-zoom = Asinhrono pomikanje/povečava
apz-none = brez
wheel-enabled = vnos s koleščkom omogočen
touch-enabled = vnos na dotik omogočen
drag-enabled = vlečenje drsnika omogočeno
keyboard-enabled = tipkovnica omogočena
autoscroll-enabled = samodrsenje omogočeno
zooming-enabled = omogočeno gladko povečanje s približevanjem prstov

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = asinhroni vnos s koleščkom onemogočen zaradi nedpodprte nastavitve: { $preferenceKey }
touch-warning = asinhroni vnos na dotik onemogočen zaradi nedpodprte nastavitve: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Nedejavno
policies-active = Dejavno
policies-error = Napaka
